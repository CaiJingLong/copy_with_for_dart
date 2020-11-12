import 'package:example/example3.dart';
import 'package:example/example2.dart';
import 'package:example/example.dart';

extension ContainerCopyWithExt<T> on Container<T> {
  Container<T> copyWith({
    int length,
    T value,
  }) {
    length ??= this.length;
    value ??= this.value;

    return Container<T>(
      length,
      value,
    );
  }
}

extension StackCopyWithExt<T extends num> on Stack<T> {
  Stack<T> copyWith({
    T value,
  }) {
    value ??= this.value;

    return Stack<T>(
      value,
    );
  }
}

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

extension EntityCopyWithExt on Entity {
  Entity copyWith({
    String firstName,
  }) {
    firstName ??= this.firstName;

    return Entity(
      firstName,
    );
  }
}
