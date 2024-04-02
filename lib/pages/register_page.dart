import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_colorized_txt.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/components/my_typer_txt.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({
    required this.onTap,
    super.key
    });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  // text controller
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  //sign up user
  void signUp() async{
    if(passController.text != confirmPassController.text) {
      ScaffoldMessenger.of(context)
      .showSnackBar(
        const SnackBar(content: Text('Passwords dont match')));
    
    return;
    }
    final authService = Provider.of<AuthService>(context, listen: false);
    try{
      await authService.signUpWithEmailAndPassword(
        emailController.text, 
        passController.text);
      ScaffoldMessenger.of(context)
      .showSnackBar(
        const SnackBar(content: Text('Succesfull Sign Up!')));

      // Navigator.pop(context);
      
      
    } catch (e) {
      ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.message,
                size: 80,
                color: Colors.grey,
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

              const SizedBox(height: 10),

              MyTextField(
                controller: confirmPassController, 
                obscureText: true, 
                hintText: 'Confirm Password'),

              const SizedBox(height: 15),

              MyButton(text: 'Sign up', onTap: signUp,),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already a member? '),
                  MyColorizedTxt(
                    onTap: widget.onTap,
                    // onTap: () {
                    //   Navigator.popAndPushNamed(context, '/login_page');
                    // },
                    text: 'Login',
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
    
  }
}