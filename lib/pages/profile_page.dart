import 'dart:io';

import 'package:badges/badges.dart';
import 'package:chat_app/model/profile_pic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  void changeUserName(String userId, TextEditingController controller) async{
     await FirebaseFirestore.instance
        .collection('users').doc(userId).update({
          'userName' : controller.text,                     
            });
  }
  void changeUserAbout(String userId, TextEditingController controller) async{
     await FirebaseFirestore.instance
        .collection('users').doc(userId).update({
          'userAbout' : controller.text,                     
            });
  }

  updateUserInfo ({
    required TextEditingController? controller, 
    required BuildContext? context,
    required String userId,
    required void Function()? onPressed,
     }){
    return showDialog(
      context: context!, 
      builder: (context)=> AlertDialog(
        // title: Text('new'),
        content: TextField(controller: controller,),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), 
            child: Text('Cancel')
            ),
          TextButton(
            onPressed: () {
              onPressed!();
              Navigator.of(context).pop();
            }, 
            child: Text('Update')
            )
        ],
      )
      );
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController userNameController = TextEditingController();
    TextEditingController userAboutConttroller = TextEditingController();
    FirebaseAuth _auth = FirebaseAuth.instance;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
        .collection('users').doc(_auth.currentUser!.uid).snapshots(), 
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return const Text('error');
        }
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }
        Map<String, dynamic>? userData = snapshot.data!.data();
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: ()async{
                    //profile picture logic... pick image from gallery or camera
                    // with image_picker package and get its path 
                    //upload to fire store, create folder "profile pic" if it doesn exist
                    //add image url to fire base "user" collection - "profile pic" in document
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery );
                   
                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages = referenceRoot.child('profileimg');
                    Reference referenceImgToUpload = referenceDirImages.child(_auth.currentUser!.uid);
                    try{
                      await referenceImgToUpload.putFile(File(file!.path));

                      String imageUrl = await referenceImgToUpload.getDownloadURL();
                      await FirebaseFirestore.instance
                        .collection('users').doc(_auth.currentUser!.uid).update({
                          'profilePic' : imageUrl
                        }); 
                    }catch (e){

                    }                    
                  },
                  child: ProfilePic(
                    userId: _auth.currentUser!.uid,
                    radius: 70,
                    ),
                ),
               
                const SizedBox(height: 20,),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Name'),
                  subtitle: Text(userData!['userName']),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      updateUserInfo(
                        controller: userNameController, 
                        context: context, 
                        userId: _auth.currentUser!.uid,
                        onPressed: (() {
                          changeUserName(_auth.currentUser!.uid, userNameController);
                        })
                        );
                    }
                    ),
                ),
                // SizedBox(height: 10,),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('About'),
                  subtitle: Text(userData['userAbout']),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      updateUserInfo(
                        controller: userAboutConttroller, 
                        context: context, 
                        userId: _auth.currentUser!.uid,
                        onPressed: (() {
                          changeUserAbout(_auth.currentUser!.uid, userAboutConttroller);
                        })
                        );
                    }
                    ),
                )
              ],
            ),
          ),
        );
      }
      );
  }
}