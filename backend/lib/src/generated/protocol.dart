import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/database/table_definition.dart';

class Protocol extends SerializationManagerServer {
  @override
  T deserialize<T>(dynamic data, [Type? t]) {
    t ??= T;
    throw UnsupportedError('No class found for type $t.');
  }

  @override
  String? getClassNameForObject(Object? data) => null;

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    throw UnsupportedError('No class found.');
  }

  @override
  String getModuleName() => 'pathfinder_backend';

  @override
  List<TableDefinition> getTargetTableDefinitions() => [];

  @override
  Table? getTableForType(Type t) => null;
}
