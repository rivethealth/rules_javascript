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
  const identifier = factory.createTempVariable(undefined);
  imports.push(
    factory.createImportDeclaration(
      undefined,
      undefined,
      factory.createImportClause(
        false,
        undefined,
        factory.createNamespaceImport(identifier),
      ),
      factory.createStringLiteral(resourceModuleSpecifier(path)),
    ),
  );
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
  return factory.updateDecorator(
    decorator,
    factory.updateCallExpression(
      expression,
      expression.expression,
      expression.typeArguments,
      args,
    ),
  );
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
          if (!ts.isClassDeclaration(node) || !node.decorators?.length) {
            return node;
          }
          const decorators = node.decorators.map((decorator) =>
            transformDecorator(factory, decorator, imports),
          );
          return factory.updateClassDeclaration(
            node,
            decorators,
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
      // console.error(ts.createPrinter().printFile(file));
      return file;
    };
  };
}
