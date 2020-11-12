import 'package:example/example2.dart';
import 'package:example/example.dart';

extension PersonCopyWithExt on Person {
  Person copyWith({
    String firstName,
    int height,
    int weight,
  }) {
    firstName ??= this.firstName;
    height ??= this.height;
    weight ??= this.weight;

    return Person(
      firstName,
      height,
      weight,
    );
  }
}

extension CopyWithExampleCopyWithExt on CopyWithExample {
  CopyWithExample copyWith({
    String name,
    String age,
    int amont,
  }) {
    name ??= this.name;
    age ??= this.age;
    amont ??= this.amont;

    return CopyWithExample(
      age,
      name: name,
      amont: amont,
    );
  }
}
