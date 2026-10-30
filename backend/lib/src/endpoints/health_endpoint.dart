import 'package:serverpod/serverpod.dart';

class HealthEndpoint extends Endpoint {
  Future<String> check(Session session) async {
    return 'Pathfinder backend is running!';
  }
}