
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/contacts_page.dart';
import 'package:chat_app/pages/messages_page.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //sign user out
  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  final List screens = [
    MessagesPage(),
    ContactsPage(),
    ProfilePage(),

  ];

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 141, 184, 243),
        title: const Text('Messages'),
        actions: [
          IconButton(
            onPressed: signOut, 
            icon: const Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        // child: _buildUserList(),
        child: screens[index],
      ),


      bottomNavigationBar: CurvedNavigationBar(
        key: navigationKey,
        onTap: (index) => setState(() {this.index = index;}),
        backgroundColor: Colors.white,
        color: Colors.blueAccent,
        animationDuration: Duration(milliseconds: 300),
        items: const [
          CurvedNavigationBarItem(
            child: Icon(Icons.message_outlined, color: Colors.white,),
            label: 'Messages',
            labelStyle: TextStyle(color: Colors.white)
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.group, color: Colors.white,),
            label: 'Contacts',
            labelStyle: TextStyle(color: Colors.white)
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.person, color: Colors.white,),
            label: 'Profile',
            labelStyle: TextStyle(color: Colors.white)
          ),
        ]
        ),
    );
  }

}