import 'package:flutter/material.dart';
import 'package:pick_my_dish/constants.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
            image: DecorationImage(
            image: AssetImage("assets/login/background.png"),
            fit: BoxFit.cover,
          ),
        ),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                     Colors.transparent,
                     Colors.black,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,

                  )
                  )
                ),

              Padding(padding: EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                SizedBox(height: 20,),
                    //logo
                Image.asset('assets/login/logo.png'),

                SizedBox(height: 10),
                Text(
                  "PICK MY DISH",
                  style: title,
                  )
                ]
              ),
            ),
          ],
        ),
      ),
              );
  }
}