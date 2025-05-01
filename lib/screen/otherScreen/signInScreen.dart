import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'loginScreen.dart';
import '../../color/appColors.dart';
import '../../exceptions/exceptions.dart';
import '../../model/user.dart';
import '../../logic/userBackendService.dart'; // Import the User model
import 'package:cloud_firestore/cloud_firestore.dart'; //for timestamps
import '../../widget/NavigationBar/bottomNavBar.dart';

import '../mainScreen/profilepage.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _agreePrivacyAndPolicy = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  InputDecoration _usernameDecoration = InputDecoration();
  InputDecoration _emailDecoration = InputDecoration();

  final UserBackendService userBackendService = UserBackendService(
      baseUrl: 'http://192.168.0.122:3000'); // Add UserService instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(32.0),
            constraints: const BoxConstraints(maxWidth: 450),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _gaptop(context),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: Text("Sign up",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              )),
                    ),
                  ),
                  _gap(),
                  TextFormField(
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                    decoration: _usernameDecoration.copyWith(
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      prefixIcon: Icon(Icons.person_2_outlined),
                      filled: true,
                      fillColor: MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? textfieldGrey
                          : textfieldWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color: logoPurple,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color: logoPurple,
                          width: 2.0,
                        ), // Set the color to your preference
                      ),
                      labelStyle: TextStyle(
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
                            ? white
                            : black,
                      ),
                      errorStyle: TextStyle(
                        color:
                            warningRed, // Set vibrant red color for error text
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color:
                              warningRed, // Set vibrant red color for error underline
                          width: 2.0,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color:
                              logoPurple, // Set color back to purple on focus
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  _gap(),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      // You can add email validation here
                      return null;
                    },
                    decoration: _emailDecoration.copyWith(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.mail_outline),
                      filled: true,
                      fillColor: MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? textfieldGrey
                          : textfieldWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color: logoPurple,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color: logoPurple,
                          width: 2.0,
                        ), // Set the color to your preference
                      ),
                      labelStyle: TextStyle(
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
                            ? white
                            : black,
                      ),
                      errorStyle: TextStyle(
                        color:
                            warningRed, // Set vibrant red color for error text
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color:
                              warningRed, // Set vibrant red color for error underline
                          width: 2.0,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color:
                              logoPurple, // Set color back to purple on focus
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  _gap(),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      // You can add password validation here
                      return null;
                    },
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      filled: true,
                      fillColor: MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? textfieldGrey
                          : textfieldWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color: logoPurple,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color: logoPurple,
                          width: 2.0,
                        ), // Set the color to your preference
                      ),
                      labelStyle: TextStyle(
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
                            ? white
                            : black,
                      ),
                      errorStyle: TextStyle(
                        color:
                            warningRed, // Set vibrant red color for error text
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color:
                              warningRed, // Set vibrant red color for error underline
                          width: 2.0,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                          color:
                              logoPurple, // Set color back to purple on focus
                          width: 2.0,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  _gapsmall(),
                  CheckboxListTile(
                    value: _agreePrivacyAndPolicy,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _agreePrivacyAndPolicy = value;
                      });
                    },
                    title: const Text('I Agree with privacy and policy'),
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                    contentPadding: const EdgeInsets.all(0),
                    activeColor: logoPurple,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: BorderSide(color: logoPurple), // Border color
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          logoPurple, // Set background color to transparent
                        ),
                      ),
                      onPressed: _onSignUpPressed,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: white),
                        ),
                      ),
                    ),
                  ),
                  _gap(),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                          child: Text(
                            "Log in",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: logoPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*Image.asset(
                    'assets/TravelerLogo.png',
                    width: 200,
                    height: 200,
                  ),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSignUpPressed() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final usernameExists = await userBackendService
            .checkUsernameExists(_usernameController.text);
        if (usernameExists) {
          throw UsernameAlreadyExistsException('Username already exists');
        }

        final emailExists =
            await userBackendService.checkEmailExists(_emailController.text);
        if (emailExists) {
          throw EmailAlreadyExistsException('Email already exists');
        }

        User newUser = await userBackendService.createUser(
          _usernameController.text.toString(),
          _emailController.text,
          _passwordController.text,
          'black',
          0.0,
          0.0, // Color
        );
      } on UsernameAlreadyExistsException {
        showSnackbar(context, 'Username already exists');
        setState(() {
          _usernameDecoration = _usernameDecoration.copyWith(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.red),
            ),
          );
        });
      } on EmailAlreadyExistsException {
        showSnackbar(context, 'Email already exists');
        setState(() {
          _emailDecoration = _emailDecoration.copyWith(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.red),
            ),
          );
        });
      } catch (e) {
        //showSnackbar(context, 'Error signing up: $e');
      }
    }
  }

  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.black),
      ),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      elevation: 8.0,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _gapsmall() => const SizedBox(height: 10);
  Widget _gap() => const SizedBox(height: 16);
  Widget _gapbig() => const SizedBox(height: 32);
  Widget _gaptop(BuildContext context) =>
      SizedBox(height: MediaQuery.of(context).size.height * 0.15);
}
