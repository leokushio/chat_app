import 'package:chat_app/model/last_message.dart';
import 'package:chat_app/model/profile_pic.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactsPage extends StatefulWidget {
  
  const ContactsPage({
   
    super.key
    });

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
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
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: ListTile(
          leading: ProfilePic(userId: data['uid'], radius: 30),
          title: Text(
            data['userName'],
            style: TextStyle(fontWeight: FontWeight.bold),
            ),            
          // subtitle: Text('hello i wrote about the inquiry ..'),
          
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverUserEmail: data['email'], 
                  receiverUserId: data['uid'],
                  receiverUserName: data['userName'],
                  )
                ));
          },
        ),
      );
    }else {
      return Container();
    }

  }
}
