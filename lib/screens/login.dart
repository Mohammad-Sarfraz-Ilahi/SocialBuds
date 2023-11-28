import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:social_buds/main.dart';
import 'package:social_buds/screens/feed_screen.dart';
import 'package:social_buds/screens/forgot_password.dart';
import 'package:social_buds/screens/register.dart';

import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();

  bool _pass = true;
  bool x = false;
  String name = "";

  

  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    void _togglePassword() {
      setState(() {
        _pass = !_pass;
      });
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Material(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/login.png",
                    fit: BoxFit.cover,
                  ),
                  Text(
                    'Hey',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailcontroller,
                          decoration: InputDecoration(
                            hintText: 'Enter Email',
                            labelText: 'Email',
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email required";
                            } else {
                              return null;
                            }
                          },
                        ),
                        TextFormField(
                          controller: passcontroller,
                          decoration: InputDecoration(
                            hintText: 'Enter Password',
                            labelText: 'Password',
                            suffix: InkWell(
                              onTap: _togglePassword,
                              child: Icon(
                                _pass
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          obscureText: _pass,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password required";
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPasswordScreen()));
                              },
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            bool isValid = (await AuthService.login(
                                emailcontroller.text,
                                passcontroller.text,
                                context));
                            if (isValid) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyApp.getScreenId()));
                            } else {
                              print("Login problem");
                            }
                          },
                          child: Text(
                            'LOG IN',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          style: TextButton.styleFrom(
                              minimumSize: Size(150, 43),
                              backgroundColor: Color.fromARGB(255, 255, 78, 90),
                              elevation: 0),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpScreen()));
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.blue.shade400,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
