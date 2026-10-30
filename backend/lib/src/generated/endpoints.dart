import 'package:serverpod/serverpod.dart';
import '../endpoints/health_endpoint.dart';
import '../endpoints/auth_endpoint.dart';
import '../endpoints/lesson_endpoint.dart';

class Endpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {
    var health = HealthEndpoint();
    health.initialize(server, 'health', null);
    connectors['health'] = EndpointConnector(
      name: 'health',
      endpoint: health,
      methodConnectors: {
        'check': MethodConnector(
          name: 'check',
          params: {},
          call: (Session session, Map<String, dynamic> params) async {
            return health.check(session);
          },
        ),
      },
    );

    var auth = AuthEndpoint();
    auth.initialize(server, 'auth', null);
    connectors['auth'] = EndpointConnector(
      name: 'auth',
      endpoint: auth,
      methodConnectors: {
        'signUp': MethodConnector(
          name: 'signUp',
          params: {
            'email': ParameterDescription(name: 'email', type: getType<String>(), nullable: false),
            'password': ParameterDescription(name: 'password', type: getType<String>(), nullable: false),
            'name': ParameterDescription(name: 'name', type: getType<String>(), nullable: false),
            'role': ParameterDescription(name: 'role', type: getType<String>(), nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return auth.signUp(session, params['email'] as String, params['password'] as String, params['name'] as String, params['role'] as String);
          },
        ),
        'signIn': MethodConnector(
          name: 'signIn',
          params: {
            'email': ParameterDescription(name: 'email', type: getType<String>(), nullable: false),
            'password': ParameterDescription(name: 'password', type: getType<String>(), nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return auth.signIn(session, params['email'] as String, params['password'] as String);
          },
        ),
      },
    );

    var lesson = LessonEndpoint();
    lesson.initialize(server, 'lesson', null);
    connectors['lesson'] = EndpointConnector(
      name: 'lesson',
      endpoint: lesson,
      methodConnectors: {
        'generateLesson': MethodConnector(
          name: 'generateLesson',
          params: {
            'topic': ParameterDescription(name: 'topic', type: getType<String>(), nullable: false),
            'subject': ParameterDescription(name: 'subject', type: getType<String>(), nullable: false),
            'learningStyle': ParameterDescription(name: 'learningStyle', type: getType<String>(), nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return lesson.generateLesson(session, params['topic'] as String, params['subject'] as String, params['learningStyle'] as String);
          },
        ),
        'generateQuiz': MethodConnector(
          name: 'generateQuiz',
          params: {
            'topic': ParameterDescription(name: 'topic', type: getType<String>(), nullable: false),
            'subject': ParameterDescription(name: 'subject', type: getType<String>(), nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return lesson.generateQuiz(session, params['topic'] as String, params['subject'] as String);
          },
        ),
        'saveProgress': MethodConnector(
          name: 'saveProgress',
          params: {
            'userId': ParameterDescription(name: 'userId', type: getType<String>(), nullable: false),
            'topicId': ParameterDescription(name: 'topicId', type: getType<String>(), nullable: false),
            'score': ParameterDescription(name: 'score', type: getType<int>(), nullable: false),
            'completed': ParameterDescription(name: 'completed', type: getType<bool>(), nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return lesson.saveProgress(session, params['userId'] as String, params['topicId'] as String, params['score'] as int, params['completed'] as bool);
          },
        ),
        'getProgress': MethodConnector(
          name: 'getProgress',
          params: {
            'userId': ParameterDescription(name: 'userId', type: getType<String>(), nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return lesson.getProgress(session, params['userId'] as String);
          },
        ),
      },
    );
  }
}
