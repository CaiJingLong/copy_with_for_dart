import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as path;
import 'package:project/project.dart';

const copyWith = CopyWith._();

class CopyWith {
  const CopyWith._();
}

class PathUtils {
  static String fixPath(String filePath) {
    final list =
        filePath.split(path.separator).where((element) => element != '.');
    return '/${path.joinAll(list)}';
  }
}

class AnalyzerUtils {
  static List<ClassResult> findCopyWith(
      Package package, List<String> filePathList) {
    final classResults = <ClassResult>[];

    final contextCollection = AnalysisContextCollection(
      includedPaths: filePathList,
    );

    for (final filePath in filePathList) {
      final context = contextCollection.contextFor(filePath);

      final result = context.currentSession.getParsedUnit(filePath);

      final classResult = ClassResult();
      classResult.package = package;
      classResult.filePath = filePath;

      for (final element in result.unit.childEntities) {
        if (element is ClassDeclaration) {
          if (haveCopyWithAnnotation(element)) {
            classResult.declarations.add(element);
          }
        }
      }

      if (classResult.declarations.isNotEmpty) {
        classResults.add(classResult);
      }
    }

    return classResults;
  }

  static bool haveCopyWithAnnotation(ClassDeclaration classDeclaration) {
    return classDeclaration.metadata.any(
      (element) => element.name.name == 'copyWith',
    );
  }
}

class ClassResult {
  Package package;
  String filePath;
  List<ClassDeclaration> declarations = [];
}
