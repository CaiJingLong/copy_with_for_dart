part of 'copy_gen.dart';

/// 主入口
void makeExtensionFile(Package pkg, [bool makeFile = true]) {
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

  if (!makeFile) {
    return;
  }

  final outputFile = pkg.packageDir.child('lib/copy_with_ext.dart');
  outputFile.writeAsStringSync(
    formatedSrc,
    flush: true,
    mode: FileMode.write,
  );
}

/// 根据class节点生成源码
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

  final general = makeGeneral(clazz);
  final fullGeneral = makeGeneral(clazz, true);

  return '''
extension ${className}CopyWithExt$fullGeneral on $className$general {
  $className$general copyWith({$params}) {
    $bodySetter

    return $className$general( $retParams );
  }
}
  ''';
}

/// 生成函数体的返回参数体
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

/// 生成导入
String makeImport(ClassResult classResult) {
  final pkg = classResult.package;
  final lib = pkg.packageDir.childDir('lib');
  final filePath = classResult.filePath;

  final relatePath = path.relative(filePath, from: lib.absolute.path);
  final name = pkg.name;

  return '''import 'package:$name/$relatePath';''';
}

String makeGeneral(
  ClassDeclaration clazz, [
  bool containsExtends = false,
]) {
  final typeParameters = clazz?.typeParameters?.typeParameters;

  if (typeParameters == null) {
    return '';
  }

  final sb = StringBuffer();

  sb.write('<');

  sb.write(typeParameters.map((e) {
    if (!containsExtends || e.bound == null) return e.name;

    return '${e.name} extends ${e.bound}';
  }).join(','));

  sb.write('>');

  return sb.toString();
}
