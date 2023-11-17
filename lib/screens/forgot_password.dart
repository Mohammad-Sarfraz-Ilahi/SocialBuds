import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_buds/constants.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Forgot Password?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Enter your email',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _showResetPasswordDialog(context);
            },
            child: Text('Reset Password'),
            style: TextButton.styleFrom(
                minimumSize: Size(150, 43),
                backgroundColor: Color.fromARGB(255, 255, 78, 90),
                elevation: 0),
          ),
        ],
      ),
    );
  }

  void _showResetPasswordDialog(BuildContext context) {
    if(_emailController.text.isEmpty){
      return;
    }
    if (_emailController.text.isNotEmpty) {
      auth.sendPasswordResetEmail(email: _emailController.text.toString()).then((value) {
      });
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Password Reset Email Sent'),
          content: Text(
              'An email to reset your password has been sent to ${_emailController.text}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
