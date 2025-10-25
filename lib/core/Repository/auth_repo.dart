import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<User?> loginWithEmail(String email, String password) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    }on FirebaseAuthException catch (e) {
      // ✅ ارمي الخطأ الأصلي نفسه، مش داخل Exception جديدة
      throw e;
    } catch (e) {
      throw Exception("خطأ غير متوقع: $e");
    }
  }

  bool isLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Future<User?> signUpWithEmailPassword(String email, String password) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Stream<User?> get user => _firebaseAuth.authStateChanges();


  loginByGmail() async{
    try{

      GoogleSignIn.instance.initialize(clientId: "670694094031-p70fn6js8b7vlat204m3vivlua2uh3ot.apps.googleusercontent.");
      GoogleSignInAccount? googleUser=await GoogleSignIn.instance.authenticate();
      GoogleSignInAuthentication googleAuth = googleUser.authentication;
      // Create a new credential

      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);
      FirebaseAuth.instance.signInWithCredential(credential);


    }


    catch(e){
      print(e.toString());
    }


  }
}