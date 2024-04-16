import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/model/profile_pic.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserId;
  final String receiverUserName;
  const ChatPage({
    required this.receiverUserEmail,
    required this.receiverUserId,
    required this.receiverUserName,
    super.key
    });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage()async{
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(
        widget.receiverUserId, 
        _messageController.text
        );
        _messageController.clear();
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ProfilePic(userId: widget.receiverUserId, radius: 15),
            SizedBox(width: 10,),
            Text(widget.receiverUserName),
          ],
        ),
        
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
        child: Column(
          //messages
          children: [
            Expanded(
              child: _buildMessageList()
              ),
            // user input
            _buildMessageInput()
          ],
        ),
      ),
    );
  }
  //build messageList
  Widget _buildMessageList(){
    return StreamBuilder(
      stream: _chatService.getMessages(
        _firebaseAuth.currentUser!.uid,
        widget.receiverUserId, 
        
        ), 
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return Text('error ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting){
          return const Text('loading..');
        }
       
        //  return Text(
        //   snapshot.data!.docs.toString()
        //  );
        return ListView(         
          children: snapshot.data!.docs
          .map((doc) => _buildMessageItem(doc)).toList(),
          // children: snapshot.data!.docs.map((e) => Text(e['message'])).toList(),
        );
      }
      );
  }
  //build message item
  Widget _buildMessageItem (DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //allign messages to right and left dempending on sender
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
    ? Alignment.centerRight
    : Alignment.centerLeft;
    Color msgBox = (data['senderId'] == _firebaseAuth.currentUser!.uid)
    ? Colors.greenAccent
    : Colors.grey.shade200;
    BorderRadius msgBoxRadius = (data['senderId'] == _firebaseAuth.currentUser!.uid)
    ? BorderRadius.only(topLeft: Radius.circular(15),bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15))
    :BorderRadius.only(topRight: Radius.circular(15),bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15));

    return Container(
      alignment: alignment,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: msgBox,
          borderRadius: msgBoxRadius
        ),
        child: Column(
          children: [
            // Text(data['senderEmail']),
            Text(data['message'])
          ]),
      ),
    );
  }

  //build message input
  Widget _buildMessageInput(){
    return Row(
      children: [
        //textfield
        Expanded(
          child: MyTextField(
            controller: _messageController,
            obscureText: false,
            hintText: 'Enter message',)
          ),
        //send message
        IconButton(
          onPressed: sendMessage, 
          icon: const Icon(Icons.arrow_upward)
          )
      ],
    );
  }
}