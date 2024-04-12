
import 'package:chat_app/components/google_button.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_colorized_txt.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/components/my_typer_txt.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({
    required this.onTap,
    super.key
    });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // text controller
  final emailController = TextEditingController();
  final passController = TextEditingController();

  //sign in user
  void signIn() async{
    final authService = Provider.of<AuthService>(context, listen: false);

    try{
      await authService.signInWithEmailandPassword(
        emailController.text, 
        passController.text);
    } catch (e){
      ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(
          content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/chat-bubble.png',
                height: 150,

                ),
              

              const SizedBox(height: 10),

              const MyTyperTxt(text: 'Welcome to Chat App'),

              const SizedBox(height: 25),

              MyTextField(
                controller: emailController, 
                obscureText: false, 
                hintText: 'Email'),

              const SizedBox(height: 10),

              MyTextField(
                controller: passController, 
                obscureText: true, 
                hintText: 'Password'),

              const SizedBox(height: 15),

              MyButton(text: 'Sign In', onTap: signIn,),

              const SizedBox(height: 40),

              const Text(
                'or',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                ),
                ),

              const SizedBox(height: 40),

              GoogleButton(),

              const SizedBox(height: 80),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not a member? '),
                  MyColorizedTxt(
                    onTap: widget.onTap,
                    text: 'Register Now!',
                    )
                ],
              ),
              
            ],
          ),
        ),
      ),
    );
    
  }
}