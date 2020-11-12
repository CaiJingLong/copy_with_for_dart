import 'package:project/project.dart';

import 'copy_gen.dart' as m;

void main(List<String> args) {
  final package = Package.fromPath('example');
  m.makeExtensionFile(package, false);
}
