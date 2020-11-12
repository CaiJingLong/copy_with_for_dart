import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:copy_with_gen/copy_with_gen_tools.dart';
import 'package:project/project.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as path;

part 'maker.g.dart';

part 'tools.g.dart';

part 'entity.g.dart';

void main(List<String> args) {
  final package = Package.fromPath(Directory.current.absolute.path);
  makeExtensionFile(package);
}
