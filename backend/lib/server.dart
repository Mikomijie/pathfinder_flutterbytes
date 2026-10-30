import 'package:serverpod/serverpod.dart';
import 'src/endpoints/health_endpoint.dart';
import 'src/endpoints/auth_endpoint.dart';
import 'src/endpoints/lesson_endpoint.dart';

void main(List<String> args) async {
  final pod = Serverpod(
    args,
    SerializationManagerServer(),
    Protocol(),
  );

  pod.addEndpoint(HealthEndpoint(), 'health');
  pod.addEndpoint(AuthEndpoint(), 'auth');
  pod.addEndpoint(LessonEndpoint(), 'lesson');

  await pod.start();
}