import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  //instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //instance of firebase
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //sign user in -----------------------------------------------
  Future<UserCredential> signInWithEmailandPassword(String email, String password) async{
    try {
      UserCredential userCredential = 
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password);
      return userCredential;
    }
    on FirebaseAuthException catch (e) {
      throw e.code;
    }
  }

  //sign user out ---------------------------------------------------
  Future<void> signOut() async{
    return FirebaseAuth.instance.signOut();
  }

  //create a new user ----------------------------------------------
  Future<UserCredential> signUpWithEmailAndPassword (String email, String password, String userName) async{
    try {
      UserCredential userCredential = 
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password);
      //after creating new user, create new document for user in the fire store collection
      _fireStore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'userName': userName
      });
      
      return userCredential;
      

    }on FirebaseAuthException catch (e) {
      throw e.code;
    }
  }

}