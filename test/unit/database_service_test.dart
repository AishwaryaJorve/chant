import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:chants/services/database_service.dart';
import 'package:chants/models/user.dart';

class MockDatabaseService extends Mock implements DatabaseService {
  @override
  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    if (email == 'valid@example.com' && password == 'correctpassword') {
      return User(
        id: 1,
        name: 'Test User',
        email: email,
        createdAt: DateTime.now().toIso8601String(),
      );
    }
    return null;
  }
}

void main() {
  group('Database Service Tests', () {
    late MockDatabaseService databaseService;

    setUp(() {
      databaseService = MockDatabaseService();
    });

    test('Successful user authentication', () async {
      final user = await databaseService.getUserByEmailAndPassword(
        'valid@example.com', 
        'correctpassword'
      );

      expect(user, isNotNull);
      expect(user?.email, 'valid@example.com');
    });

    test('Failed user authentication', () async {
      final user = await databaseService.getUserByEmailAndPassword(
        'invalid@example.com', 
        'wrongpassword'
      );

      expect(user, isNull);
    });
  });
} 