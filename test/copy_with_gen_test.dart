import 'dart:io';

import 'package:copy_with_gen/copy_with_gen_tools.dart';
import 'package:project/project.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    test('Test copy with', () {
      final package = Package.fromPath(Directory.current.absolute.path);

      final file = package.childFile('example/copy_with_gen_example.dart');

      final classess =
          AnalyzerUtils.findCopyWith(package, [file.absolute.path]);
    });
  });
}
