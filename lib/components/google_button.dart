import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Container(
        margin: EdgeInsets.only(left: 40, right: 40),
        padding: EdgeInsets.all(5),
        width: double.maxFinite,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10), color: Colors.white
          ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login with Google'),
            const SizedBox(width: 10,),
            Image.asset(
              'lib/assets/google_icon.png',
              width: 20,
              height: 20,
            )
            
          ],
        ),
        
      ),
    );
  }
}