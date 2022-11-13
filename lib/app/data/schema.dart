import 'package:isar/isar.dart';

part 'schema.g.dart';

@collection
class Settings {
  Id id = Isar.autoIncrement;
  bool onboard = false;
}
