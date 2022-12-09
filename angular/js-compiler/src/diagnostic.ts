import * as ts from "typescript";

function formatDiagnostic(diagnostic: ts.Diagnostic): string {
  if (diagnostic.file) {
    const { line, character } = diagnostic.file.getLineAndCharacterOfPosition(
      diagnostic.start!,
    );
    const message = ts.flattenDiagnosticMessageText(
      diagnostic.messageText,
      "\n",
    );
    return `${diagnostic.file.fileName} (${line + 1},${
      character + 1
    }): ${message}`;
  } else {
    return ts.flattenDiagnosticMessageText(diagnostic.messageText, "\n");
  }
}

export function formatDiagnostics(diagnostics: ts.Diagnostic[]): string {
  return diagnostics
    .map((diagnostic) => `${formatDiagnostic(diagnostic)}\n`)
    .join(",");
}
