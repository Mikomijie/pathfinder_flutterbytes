import 'package:serverpod/serverpod.dart';
import 'package:pathfinder_backend/src/generated/protocol.dart';
import 'package:pathfinder_backend/src/generated/endpoints.dart';

void main(List<String> args) async {
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  await pod.start();
}