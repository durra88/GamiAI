import 'dart:io';

final _srcImport = RegExp(
  '''(?:import|export)\\s+['"]package:([A-Za-z0-9_]+)/src/''',
);

final _forbiddenDomainImport = RegExp(
  '''(?:import|export)\\s+['"]package:(?:flutter|dio)(?:/|['"])''',
);

void main() {
  final root = Directory.current;
  final violations = <String>[];

  for (final entity in root.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) {
      continue;
    }
    final path = entity.path.replaceAll('\\', '/');
    if (_ignored(path)) {
      continue;
    }
    final owner = _packageName(entity);
    final lines = entity.readAsLinesSync();
    for (var index = 0; index < lines.length; index++) {
      final line = lines[index];
      final lineNumber = index + 1;
      final srcMatch = _srcImport.firstMatch(line);
      if (srcMatch != null) {
        final imported = srcMatch.group(1);
        if (imported != null && imported != owner) {
          violations.add(
            '$path:$lineNumber imports package:$imported/src/. '
            'Import the package barrel instead.',
          );
        }
      }
      if (path.contains('/src/domain/') &&
          _forbiddenDomainImport.hasMatch(line)) {
        violations.add(
          '$path:$lineNumber is domain code and cannot import Flutter or Dio.',
        );
      }
    }
  }

  if (violations.isNotEmpty) {
    stderr.writeln('Architecture check failed:');
    for (final violation in violations) {
      stderr.writeln('- $violation');
    }
    exitCode = 1;
    return;
  }

  stdout.writeln('Architecture checks passed.');
}

bool _ignored(String path) {
  return path.contains('/.dart_tool/') ||
      path.contains('/build/') ||
      path.contains('/.melos_tool/');
}

String? _packageName(File file) {
  var directory = file.parent;
  while (true) {
    final pubspec = File('${directory.path}/pubspec.yaml');
    if (pubspec.existsSync()) {
      for (final line in pubspec.readAsLinesSync()) {
        final match = RegExp(r'^name:\s*([A-Za-z0-9_]+)').firstMatch(line);
        if (match != null) {
          return match.group(1);
        }
      }
    }
    final parent = directory.parent;
    if (parent.path == directory.path) {
      return null;
    }
    directory = parent;
  }
}
