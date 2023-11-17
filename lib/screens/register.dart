import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:social_buds/main.dart';
import 'package:social_buds/screens/home_screen.dart';
import 'package:social_buds/screens/login.dart';

import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  //const register({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isHidden = true;
  bool _Hidden = true;
  String _errorMessage = '';

  GlobalKey<FormState> formkey = GlobalKey();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController biocontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  TextEditingController conpasscontroller = TextEditingController();

  moveTohome(BuildContext context) {}
  @override
  Widget build(BuildContext context) {
    void _togglePasswordView() {
      setState(() {
        _isHidden = !_isHidden;
      });
    }

    void _togglePasswordview() {
      setState(() {
        _Hidden = !_Hidden;
      });
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Material(
        child: Scaffold(
          //backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(children: [
                Image.asset(
                  'assets/images/register.png',
                  fit: BoxFit.cover,
                ),
                Text(
                  'Create an Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade500,
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailcontroller,
                        decoration: InputDecoration(
                          hintText: 'Enter Email',
                          labelText: 'Email',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (values) {
                          if (values!.isEmpty) {
                            return "Email required";
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        controller: usernamecontroller,
                        decoration: InputDecoration(
                          hintText: 'Enter Username',
                          labelText: 'Username',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username';
                          }
                          if (value.length < 3 || value.length > 30) {
                            return 'Username must be between 3 and 30 characters';
                          }
                          if (!RegExp(r'^[a-z-0-9_]+$').hasMatch(value)) {
                            return 'It can only contain small letters, numbers, underscore';
                          }
                          if (value.startsWith('_') || value.endsWith('_')) {
                            return 'Username cannot start or end with an underscore';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: biocontroller,
                        decoration: InputDecoration(
                          hintText: 'Enter Bio',
                          labelText: 'Bio',
                        ),
                      ),
                      TextFormField(
                          controller: passcontroller,
                          decoration: InputDecoration(
                              hintText: 'Enter Password',
                              labelText: 'Password',
                              suffix: InkWell(
                                  onTap: _togglePasswordView,
                                  child: Icon(
                                    _isHidden
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ))),
                          obscureText: _isHidden,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (values) {
                            if (values!.isEmpty) {
                              return "Password required";
                            } else if (values.length < 6) {
                              return 'Password must be at least 6 characters';
                            } else {
                              return null;
                            }
                          }),
                      TextFormField(
                          controller: conpasscontroller,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            labelText: 'Confirm Password',
                            suffix: InkWell(
                              onTap: _togglePasswordview,
                              child: Icon(
                                _Hidden
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          obscureText: _Hidden,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (values) {
                            if (values!.isEmpty) {
                              return "Password required";
                            }
                            if (values != passcontroller.text) {
                              return 'Password do not match';
                            } else {
                              return null;
                            }
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          bool isValid = (await AuthService.signUp(
                              emailcontroller.text,
                              usernamecontroller.text,
                              biocontroller.text,
                              passcontroller.text,
                              context));
                          if (isValid) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyApp.getScreenId()));
                          } else {
                            print("Something went wrong");
                          }
                        },
                        child: Text('SIGN UP',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        style: TextButton.styleFrom(
                            minimumSize: Size(150, 43),
                            backgroundColor: Color.fromARGB(255, 255, 78, 90),
                            elevation: 0),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
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
                                builder: (context) => LoginScreen()));
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                            color: Colors.blue.shade400,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
