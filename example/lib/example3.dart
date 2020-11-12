import 'package:copy_with_gen/copy_with_gen.dart';

@copyWith
class Container<T> {
  final _list = <T>[];

  final int length;

  final T value;

  Container(this.length, this.value);
}

@copyWith
class Stack<T extends num> {
  final T value;

  Stack(this.value);
}
