part of 'copy_gen.dart';

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
