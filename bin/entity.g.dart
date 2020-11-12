part of 'copy_gen.dart';

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
