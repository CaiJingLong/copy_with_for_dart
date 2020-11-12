import 'package:copy_with_gen/copy_with_gen.dart';

@copyWith
class Person {
  Person(
    this.firstName, [
    this.height,
    this.weight,
  ]);

  final String firstName;
  final int height;
  final int weight;
}
