import 'package:serverpod/serverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LessonEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  Future<Map<String, dynamic>> generateLesson(
    Session session,
    String topic,
    String subject,
    String learningStyle,
  ) async {
    try {
      final apiKey = session.passwords['openrouter'] ?? '';
      
      final response = await http.post(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'openrouter/auto',
          'messages': [
            {
              'role': 'user',
              'content': '''Create an adaptive lesson for a Nigerian student about "$topic" in $subject.
Learning style: $learningStyle.
Return JSON with: title, summary, content (array of sections with heading and text), 
keyPoints (array), and funFact.'''
            }
          ],
          'response_format': {'type': 'json_object'},
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = jsonDecode(
          data['choices'][0]['message']['content']
        );
        return {'success': true, 'lesson': content};
      }
      return {'success': false, 'message': 'AI service error'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> generateQuiz(
    Session session,
    String topic,
    String subject,
  ) async {
    try {
      final apiKey = session.passwords['openrouter'] ?? '';
      
      final response = await http.post(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'openrouter/auto',
          'messages': [
            {
              'role': 'user',
              'content': '''Create 5 quiz questions about "$topic" in $subject for Nigerian students.
Return JSON with: questions (array of objects with question, options array of 4, correctAnswer, explanation).'''
            }
          ],
          'response_format': {'type': 'json_object'},
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = jsonDecode(
          data['choices'][0]['message']['content']
        );
        return {'success': true, 'quiz': content};
      }
      return {'success': false, 'message': 'AI service error'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> saveProgress(
    Session session,
    String userId,
    String topicId,
    int score,
    bool completed,
  ) async {
    try {
      await session.db.unsafeQuery(
        "INSERT INTO progress (user_id, topic_id, score, completed, updated_at) "
        "VALUES ('$userId', '$topicId', $score, $completed, NOW()) "
        "ON CONFLICT (user_id, topic_id) DO UPDATE "
        "SET score=$score, completed=$completed, updated_at=NOW()",
      );
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getProgress(
    Session session,
    String userId,
  ) async {
    try {
      final result = await session.db.unsafeQuery(
        "SELECT topic_id, score, completed, updated_at FROM progress "
        "WHERE user_id='$userId'",
      );
      
      final progress = result.map((row) => {
        'topicId': row[0],
        'score': row[1],
        'completed': row[2],
        'updatedAt': row[3].toString(),
      }).toList();
      
      return {'success': true, 'progress': progress};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}