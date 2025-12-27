import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import '../models/DBhelper.dart';

class Authprovider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _currentUserEmail = '';

  Authprovider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    final db = await DBHelper.database;
    final users = await db.query('users');

    if (users.isNotEmpty) {
      _isLoggedIn = true;
      _currentUserEmail = users.first['email'] as String;
    }
    notifyListeners();
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final db = await DBHelper.database;
      await db.insert(
        'users',
        {
          'name': name,
          'email': email,
          'password': password,
        },
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      return true;
    } catch (e) {
      print('Signup error: $e');
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final db = await DBHelper.database;
      final result = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );

      if (result.isNotEmpty) {
        _isLoggedIn = true;
        _currentUserEmail = email;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  void logout() {
    _isLoggedIn = false;
    _currentUserEmail = '';
    notifyListeners();
  }

  bool get isLoggedIn => _isLoggedIn;
  String get userEmail => _currentUserEmail;
}
