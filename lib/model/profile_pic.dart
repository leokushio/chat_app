import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  final String userId;
  final double radius;

  const ProfilePic({
    required this.userId,
    required this.radius,
    super.key
    });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(), 
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return Text('error ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting){
          return const Text('loading..');
        }
        String imageUrl = snapshot.data!.get('profilePic');
        return CircleAvatar(
          backgroundImage: imageUrl == ''
          ? Image.asset('lib/assets/default_profile_pic.jpg').image : Image.network(imageUrl).image,
          radius: radius,

        );
      }
      );
  }
}