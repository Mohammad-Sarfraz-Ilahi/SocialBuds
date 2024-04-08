import 'package:flutter/material.dart';
import 'package:social_buds/screens/login.dart';
import 'package:social_buds/screens/register.dart';
import 'package:social_buds/widgets/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                  ),
                  Image.asset(
                    'assets/images/app_logo.png',
                    height: 200,
                    width: 200,
                  ),
                  Text(
                    "Connect with your friends and family through Social Buds",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  RoundedButton(
                    btnText: 'Log In',
                    onBtnPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                    }
                  ),
                  SizedBox(height: 30,),
                  RoundedButton(
                    btnText: 'Create Account',
                    onBtnPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                    }
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
