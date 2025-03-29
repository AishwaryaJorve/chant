import 'package:flutter_test/flutter_test.dart';
import 'package:chants/models/user.dart';

void main() {
  group('User Model Tests', () {
    test('User creation', () {
      final user = User(
        id: 1,
        name: 'Test User',
        email: 'test@example.com',
        createdAt: DateTime.now().toIso8601String(),
      );

      expect(user.id, 1);
      expect(user.name, 'Test User');
      expect(user.email, 'test@example.com');
    });

    test('User copyWith method', () {
      final originalUser = User(
        id: 1,
        name: 'Original Name',
        email: 'original@example.com',
        createdAt: DateTime.now().toIso8601String(),
      );

      final updatedUser = originalUser.copyWith(
        name: 'Updated Name',
        email: 'updated@example.com',
      );

      expect(updatedUser.id, originalUser.id);
      expect(updatedUser.name, 'Updated Name');
      expect(updatedUser.email, 'updated@example.com');
    });
  });
} 