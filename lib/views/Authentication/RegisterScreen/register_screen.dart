import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_firebase/global_widgets/custom_button.dart';
import 'package:ecommerce_firebase/global_widgets/custom_widget.dart';
import 'package:ecommerce_firebase/helpers/form_helper.dart';
import 'package:ecommerce_firebase/views/Authentication/LoginScreen/login_screen.dart';
import 'package:ecommerce_firebase/views/HomeScreen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    'Create Account',
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Create an account so you can explore all the existing jobs',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black.withOpacity(.5),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  CustomTextField(
                    hintText: 'Email',
                    controller: _email,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    hintText: 'Password',
                    controller: _password,
                    secured: true,
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.visibility),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    hintText: 'Confirm Password',
                    secured: true,
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.visibility),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    buttonTitle: 'Sign Up',
                    onTap: () async {
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: _email.text,
                          password: _password.text,
                        ).then((value) {
                          FirebaseFirestore.instance.collection('users').doc(_email.text).set({
                            'email' : _email.text,
                            'password' : _password.text,
                            'cart' : 'cart'
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Already Have An Account',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
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
