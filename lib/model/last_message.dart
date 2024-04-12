import 'package:chat_app/services/chat/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LastMessage extends StatelessWidget {
  final String receiverUserId;
  const LastMessage({
    required this.receiverUserId,
    super.key
    });

  @override
  Widget build(BuildContext context) {
    final ChatService chatService = ChatService();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return StreamBuilder(
      stream: chatService.getMessages(
        firebaseAuth.currentUser!.uid,
        receiverUserId, 
        
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
        List messagesList = snapshot.data!.docs.map((e) => e['message']).toList();
        List lastSender = snapshot.data!.docs.map((e) => e['senderId']).toList();
        return messagesList.isEmpty
        ? const Text('say hi') 
        : Row(
            children: [
              if(firebaseAuth.currentUser!.uid == lastSender.last) 
              const Icon(Icons.check_outlined, color: Colors.grey,),
              const SizedBox(width: 5,),
              Text(messagesList.last),
            ],
          );
      }
      );
  }
}