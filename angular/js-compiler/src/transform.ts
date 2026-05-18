import * as ts from "typescript";
import { stylePath } from "./angular";

function resourceModuleSpecifier(path: string) {
  if (!path.startsWith("./")) {
    path = `./${path}`;
  }
  return `${path}.cjs`;
}

function createImport(
  factory: ts.NodeFactory,
  imports: ts.Statement[],
  path: string,
): ts.Expression {
  // eslint-disable-next-line unicorn/no-useless-undefined
  const identifier = factory.createTempVariable(undefined);
  const importClause = factory.createImportClause(
    false,
    undefined,
    factory.createNamespaceImport(identifier),
  );
  const moduleSpecifier = factory.createStringLiteral(
    resourceModuleSpecifier(path),
  );
  // TS 4.8+ removed the separate decorators parameter from createImportDeclaration
  const importDecl =
    factory.createImportDeclaration.length <= 4
      ? (factory.createImportDeclaration as any)(
          undefined,
          importClause,
          moduleSpecifier,
        )
      : (factory.createImportDeclaration as any)(
          undefined,
          undefined,
          importClause,
          moduleSpecifier,
        );
  imports.push(importDecl);
  return factory.createPropertyAccessExpression(identifier, "content");
}

function transformDecorator(
  factory: ts.NodeFactory,
  decorator: ts.Decorator,
  imports: ts.Statement[],
): ts.Decorator {
  const expression = decorator.expression;
  if (!ts.isCallExpression(expression)) {
    return decorator;
  }
  const args = expression.arguments.map((argument) => {
    if (!ts.isObjectLiteralExpression(argument)) {
      return argument;
    }
    const properties = argument.properties.map((property) => {
      if (!ts.isPropertyAssignment(property)) {
        return property;
      }
      let name: string;
      if (ts.isStringLiteral(property.name)) {
        name = property.name.text;
      } else if (ts.isIdentifier(property.name)) {
        name = property.name.escapedText.toString();
      } else {
        return property;
      }
      switch (name) {
        case "styleUrls": {
          if (!ts.isArrayLiteralExpression(property.initializer)) {
            break;
          }
          const array = factory.createArrayLiteralExpression(
            property.initializer.elements.map((element) => {
              if (!ts.isStringLiteral(element)) {
                return element;
              }
              return createImport(factory, imports, stylePath(element.text));
            }),
          );
          return factory.updatePropertyAssignment(
            property,
            factory.createIdentifier("styles"),
            array,
          );
        }
        case "templateUrl": {
          if (!ts.isStringLiteral(property.initializer)) {
            return property;
          }
          const identifier = createImport(
            factory,
            imports,
            property.initializer.text,
          );
          return factory.updatePropertyAssignment(
            property,
            factory.createIdentifier("template"),
            identifier,
          );
        }
      }
      return property;
    });
    return factory.updateObjectLiteralExpression(argument, properties);
  });
  const updatedCall = factory.updateCallExpression(
    expression,
    expression.expression,
    expression.typeArguments,
    args,
  );
  // TS 4.8+ removed updateDecorator
  if (typeof factory.updateDecorator === "function") {
    return factory.updateDecorator(decorator, updatedCall);
  }
  return factory.createDecorator(updatedCall);
}

function getDecorators(node: ts.Node): readonly ts.Decorator[] | undefined {
  // TS 4.8+ moved decorators into modifiers; ts.getDecorators handles both
  if (typeof (ts as any).getDecorators === "function") {
    return (ts as any).getDecorators(node);
  }
  return (node as any).decorators;
}

/**
 * Replace styleUrls and templateUrl with imports from JS files.
 */
export function resourceTransformer(): ts.TransformerFactory<ts.SourceFile> {
  return (context: ts.TransformationContext) => {
    const { factory } = context;
    return (file: ts.SourceFile) => {
      const imports: ts.Statement[] = [];
      file = ts.visitEachChild(
        file,
        (node): ts.VisitResult<ts.Node> => {
          if (!ts.isClassDeclaration(node)) {
            return node;
          }
          const decorators = getDecorators(node);
          if (!decorators?.length) {
            return node;
          }
          const transformedDecorators = decorators.map((decorator) =>
            transformDecorator(factory, decorator, imports),
          );
          // TS 4.8+: decorators and modifiers are merged
          if (typeof (ts as any).getDecorators === "function") {
            const otherModifiers = ((node.modifiers as any) || []).filter(
              (m: ts.ModifierLike) => !ts.isDecorator(m),
            );
            return factory.updateClassDeclaration(
              node,
              [...transformedDecorators, ...otherModifiers] as any,
              node.name,
              node.typeParameters,
              node.heritageClauses,
              node.members,
            );
          }
          // TS <4.8: separate decorators parameter
          return (factory as any).updateClassDeclaration(
            node,
            transformedDecorators,
            node.modifiers,
            node.name,
            node.typeParameters,
            node.heritageClauses,
            node.members,
          );
        },
        context,
      );
      file = factory.updateSourceFile(file, [...imports, ...file.statements]);
      return file;
    };
  };
}
