import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:copy_with_gen/copy_with_gen_tools.dart';
import 'package:project/project.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as path;

void main(List<String> args) {
  final package = Package.fromPath(Directory.current.absolute.path);
  makeExtensionFile(package);
}

void makeExtensionFile(Package pkg) {
  final filePathList = pkg.dartSources.map((e) => e.absolute.path).toList();

  final classess = AnalyzerUtils.findCopyWith(pkg, filePathList);

  final imports = StringBuffer();
  final sources = StringBuffer();

  for (final classResult in classess) {
    imports.write(makeImport(classResult));
    for (final clazz in classResult.declarations) {
      sources.write(makeSource(clazz));
    }
  }

  final unformat = StringBuffer()..write(imports)..write(sources);

  final formatter = DartFormatter();
  final formatedSrc = formatter.format(unformat.toString());

  print(formatedSrc);

  final outputFile = pkg.packageDir.child('lib/copy_with_ext.dart');
  outputFile.writeAsStringSync(
    formatedSrc,
    flush: true,
    mode: FileMode.write,
  );
}

String makeSource(ClassDeclaration clazz) {
  var ctorNames = <String>[];
  ConstructorDeclaration constructorDecl;

  for (final child in clazz.childEntities) {
    if (child is ConstructorDeclaration) {
      final params = child.parameters;
      for (final param in params.parameters) {
        ctorNames.add(param.identifier.name);
      }
      constructorDecl = child;
      break;
    }
  }
  final className = clazz.name.name;
  if (constructorDecl == null) {
    print('The ${className} cannot find constructor');
    return '';
  }

  final needsName = <Field>[];

  for (final child in clazz.childEntities) {
    if (child is FieldDeclaration) {
      if (child.isStatic) {
        continue;
      }
      final fields = child.fields;
      for (final field in fields.variables) {
        // final name = field.name.name;
        if (ctorNames.contains(field.name.name)) {
          needsName.add(Field(child, field));
        }
      }
    }
  }

  final params = needsName.map((e) {
    return '${e.type} ${e.name},';
  }).join(' ');

  final bodySetter = needsName.map((e) {
    return '${e.name} ??= this.${e.name};';
  }).join('\n');

  final retParams = makeReturnParams(needsName, constructorDecl);

  return '''
extension ${className}CopyWithExt on $className {
  $className copyWith({$params}) {
    $bodySetter

    return $className( $retParams );
  }
}
  ''';
}

String makeReturnParams(
  List<Field> fields,
  ConstructorDeclaration declarations,
) {
  final sb = StringBuffer();

  final must = <FormalParameter>[];
  final nonamed = <FormalParameter>[];
  final named = <FormalParameter>[];

  for (final param in declarations.parameters.parameters) {
    if (!param.isOptional) {
      must.add(param);
    } else if (param.isNamed) {
      named.add(param);
    } else {
      nonamed.add(param);
    }
  }

  if (must.isNotEmpty) {
    sb.write(must.map((e) {
      final name = e.identifier.name;
      return '$name';
    }).join(','));
    sb.write(',');
  }

  if (nonamed.isNotEmpty) {
    sb.write(nonamed.map((e) {
      return e.identifier.name;
    }).join(','));
    sb.write(',');
  }

  if (named.isNotEmpty) {
    sb.write(named.map((e) {
      final name = e.identifier.name;
      return '$name: $name';
    }).join(','));
    sb.write(',');
  }

  return sb.toString();
}

String makeImport(ClassResult classResult) {
  final pkg = classResult.package;
  final lib = pkg.packageDir.childDir('lib');
  final filePath = classResult.filePath;

  final relatePath = path.relative(filePath, from: lib.absolute.path);
  final name = pkg.name;

  return '''import 'package:$name/$relatePath';''';
}

class Field {
  Field(this.field, this.variable);
  final FieldDeclaration field;
  final VariableDeclaration variable;

  String get name => variable.name.name;
  String get type {
    final typeName =
        field.fields.childEntities.whereType<TypeName>().firstWhere(
              (element) => element is TypeName,
              orElse: () => null,
            );
    return typeName?.name?.name ?? '';
  }
}

void printNode(AstNode astNode, [int level = 0]) {
  _printNode(astNode, level);
  for (final child in astNode.childEntities) {
    if (child is AstNode) {
      printNode(child, level + 1);
    } else {
      _printNode(child, level + 1);
    }
  }
}

void _printNode(SyntacticEntity syntacticEntity, [int level = 0]) {
  var prefix = '';
  var tab = '  ' * (level - 1);
  if (level > 1) {
    prefix = '$tab|--';
  }
  print('$prefix$syntacticEntity');
}
