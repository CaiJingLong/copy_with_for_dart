import 'package:copy_with_gen/copy_with_gen.dart';

@copyWith
class CopyWithExample {
  final String name, age;
  final int amont;

  CopyWithExample(
    this.age, {
    this.name,
    this.amont,
  });
}

@copyWith
class Entity {
  Entity(this.firstName);

  final String firstName;
}
