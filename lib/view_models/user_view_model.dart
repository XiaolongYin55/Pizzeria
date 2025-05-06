import 'package:flutter/material.dart';
import 'package:template01/authentication/AuthService.dart';
import 'package:template01/models/user.dart';


class UserViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  Users? _currentUser;
  bool _isLoading = false;

  Users? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<void> authenticateUser(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    
    _currentUser = await _authService.authenticateUser(username, password);
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> registerUser(Users user) async {
    _isLoading = true;
    notifyListeners();
    
    await _authService.registerUser(user);
    
    _currentUser = user;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUser(String username) async {
    _isLoading = true;
    notifyListeners();
    
    _currentUser = await _authService.getUser(username);
    
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> isUsernameTaken(String username) async {
    return await _authService.isUsernameTaken(username);
  }

  Future<bool> isEmailTaken(String email) async {
    return await _authService.isEmailTaken(email);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  Future<void> signOutGuest(String guestUsername) async {
    await _authService.signOutGuest(guestUsername);
    _currentUser = null;
    notifyListeners();
  }
}
