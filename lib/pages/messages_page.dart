import 'package:chat_app/model/last_message.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatefulWidget {
 
  const MessagesPage({
   
    super.key
    });

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(), 
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return const Text('error');
        }
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }
        return ListView(
          children: snapshot.data!.docs
            .map<Widget>((doc) => _buildUserListItem(doc, auth))
            .toList()
        );
      }
      );
  }

  Widget _buildUserListItem(DocumentSnapshot document, auth){
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    
    //display all users except current user
    if(auth.currentUser!.email != data['email']){
      return ListTile(
        leading: CircleAvatar(radius: 30,),
        title: Text(
          data['userName'],
          style: TextStyle(fontWeight: FontWeight.bold),
          ),            
        // subtitle: Text('hello i wrote about the inquiry ..'),
        subtitle: LastMessage(receiverUserId: data['uid']),
        onTap: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserEmail: data['email'], 
                receiverUserId: data['uid'])
              ));
        },
      );
    }else {
      return Container();
    }

  }
}
