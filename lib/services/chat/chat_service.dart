import 'package:chat_app/model/message.dart';
import 'package:chat_app/pages/messages_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //SEND MESSAGE
  Future<void> sendMessage(String receiverId, String message) async{
    //get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //create a new message
   Message newMessage =Message(
    senderId: currentUserId, 
    senderEmail: currentUserEmail, 
    receiverId: receiverId, 
    message: message, 
    timestamp: timestamp);

    //construct a chatroom id from current user id and recerver id(sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); //sort ids so that the are the same for both users
    String chatroomId = ids.join('_');// join to a single string

    //add new message to the database
    await _firestore.collection('chat_rooms')
      .doc(chatroomId)
      .collection('messages')
      .add(newMessage.toMap());
    //
  }

  //GET MESSAGE
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId){
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatroomId = ids.join('_');

    return _firestore
      .collection('chat_rooms')
      .doc(chatroomId)
      .collection('messages')
      .orderBy('timeStamp', descending: false)
      .snapshots();
  }

 
  }