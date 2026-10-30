import 'package:serverpod/serverpod.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class AuthEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  Future<Map<String, dynamic>> signUp(
    Session session,
    String email,
    String password,
    String name,
    String role,
  ) async {
    try {
      final hashedPassword = sha256.convert(utf8.encode(password)).toString();
      
      final result = await session.db.unsafeQuery(
        "INSERT INTO users (email, password_hash, name, role, created_at) "
        "VALUES ('$email', '$hashedPassword', '$name', '$role', NOW()) "
        "RETURNING id, email, name, role",
      );

      if (result.isEmpty) {
        return {'success': false, 'message': 'Failed to create user'};
      }

      final user = result.first;
      return {
        'success': true,
        'user': {
          'id': user[0],
          'email': user[1],
          'name': user[2],
          'role': user[3],
        }
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> signIn(
    Session session,
    String email,
    String password,
  ) async {
    try {
      final hashedPassword = sha256.convert(utf8.encode(password)).toString();
      
      final result = await session.db.unsafeQuery(
        "SELECT id, email, name, role FROM users "
        "WHERE email='$email' AND password_hash='$hashedPassword'",
      );

      if (result.isEmpty) {
        return {'success': false, 'message': 'Invalid email or password'};
      }

      final user = result.first;
      return {
        'success': true,
        'user': {
          'id': user[0],
          'email': user[1],
          'name': user[2],
          'role': user[3],
        }
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}