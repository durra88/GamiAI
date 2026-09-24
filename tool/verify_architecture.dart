import 'dart:io';

final _srcImport = RegExp(
  '''(?:import|export)\\s+['"]package:([A-Za-z0-9_]+)/src/''',
);

final _forbiddenDomainImport = RegExp(
  '''import\\s+['"]package:(?:flutter|dio|json_annotation)(?:/|['"])''',
);

void main() {
  final violations = <String>[];

  for (final directory in [Directory('packages'), Directory('app')]) {
    if (!directory.existsSync()) {
      continue;
    }
    _visit(directory, (file) {
      final path = file.path.replaceAll('\\', '/');
      final contents = file.readAsStringSync();
      final owner = _packageName(path);
      for (final match in _srcImport.allMatches(contents)) {
        final imported = match.group(1);
        if (imported != null && imported != owner) {
          violations.add(
            '$path imports package:$imported/src/. '
            'Import the package barrel instead.',
          );
        }
      }
      if (path.contains('packages/core/lib/src/domain/') &&
          _forbiddenDomainImport.hasMatch(contents)) {
        violations.add(
          '$path is domain code and cannot import Flutter, Dio, '
          'or json_annotation.',
        );
      }
    });
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

void _visit(Directory directory, void Function(File file) onFile) {
  for (final entity in directory.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      onFile(entity);
    }
  }
}

String? _packageName(String path) {
  const marker = 'packages/';
  final index = path.indexOf(marker);
  if (index != -1) {
    final rest = path.substring(index + marker.length);
    final name = rest.split('/').first;
    return name.isEmpty ? null : name;
  }
  if (path.contains('/app/') || path.startsWith('app/')) {
    return 'app';
  }
  return null;
}
