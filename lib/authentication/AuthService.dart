import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:template01/models/user.dart';

class AuthService {
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<Users?> authenticateUser(String username, String password) async {
    var snapshot = await usersRef.doc(username).get();
    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      // ignore: unnecessary_null_comparison
      if (data != null && data['password'] == password) {
        return Users(
          username: data['username'],
          password: data['password'],
          phone: data['phone'],
          email: data['email'],
          role: data['role'],
          createDate: (data['createDate'] as Timestamp).toDate(),
          updateDate: (data['updateDate'] as Timestamp).toDate(),
        );
      }
    }
    return null;
  }

  Future<void> registerUser(Users user) async {
    try {
      // Register the user in Firebase Authentication
      // ignore: unused_local_variable
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      // Store additional user information in Firestore
      return usersRef.doc(user.username).set({
        'username': user.username,
        'password': user.password,
        'phone': user.phone,
        'email': user.email,
        'role': user.role,
        'createDate': user.createDate,
        'updateDate': user.updateDate,
      });
    } on FirebaseAuthException catch (e) {
      print('Error: ${e.message}');
      throw e; // Rethrow the exception to be handled in the UI
    }
  }

  Future<Users?> getUser(String username) async {
    var snapshot = await usersRef.doc(username).get();
    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      return Users(
        username: data['username'],
        password: data['password'],
        phone: data['phone'],
        email: data['email'],
        role: data['role'],
        createDate: (data['createDate'] as Timestamp).toDate(),
        updateDate: (data['updateDate'] as Timestamp).toDate(),
      );
    }
    return null;
  }
  // username can not be same
  Future<bool> isUsernameTaken(String username) async {
    var snapshot = await usersRef.doc(username).get();
    return snapshot.exists;
  }

    Future<bool> isEmailTaken(String email) async {
    var snapshot = await usersRef.where('email', isEqualTo: email).get();
    return snapshot.docs.isNotEmpty;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print('Error: ${e.message}');
      throw e; // Rethrow the exception to be handled in the UI
    }
  }
Future<void> signOutGuest(String guestUsername) async {
  print('Deleting guest user from Firestore: $guestUsername');
  await usersRef.doc(guestUsername).delete();
}
}
