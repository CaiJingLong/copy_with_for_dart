# copy_with_gen

A generator to make copyWith extension file.

## Usage

### import the package

```yaml
dependencies:
  copy_with_gen: any
```

```dart
import 'package:copy_with_gen/copy_with_gen.dart';

@copyWith
class Entity{
    Entity(this.firstName);

    final String firstName;
}
```

### install the package with pub global

Install it with [pub global](https://dart.dev/tools/pub/cmd/pub-global):

```bash
pub global activate copy_with_gen
```

### use it

```bash
cd $poject_dir
copy_gen
```
