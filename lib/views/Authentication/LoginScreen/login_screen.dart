import 'package:ecommerce_firebase/global_widgets/custom_button.dart';
import 'package:ecommerce_firebase/global_widgets/custom_widget.dart';
import 'package:ecommerce_firebase/helpers/form_helper.dart';
import 'package:ecommerce_firebase/utils/colors.dart';
import 'package:ecommerce_firebase/views/Authentication/RegisterScreen/register_screen.dart';
import 'package:ecommerce_firebase/views/BottomNavBarView/bottom_view.dart';
import 'package:ecommerce_firebase/views/HomeScreen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                    'Login here',
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Welcome back you’ve\nbeen missed!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
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
                    secured: true,
                    controller: _password,
                    suffixIcon: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.visibility)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot your password?',
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomButton(
                    buttonTitle: 'Login',
                    onTap: () async {
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: _email.text,
                          password: _password.text,
                        ).then((value){
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
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
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Create new account',
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
