import '../../logic/userBackendService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../color/appColors.dart';
import '../../model/user.dart';
import '../../widget/NavigationBar/bottomNavBar.dart';
import 'signInScreen.dart';
import '../mainScreen/homeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _AgreePrivacyAndPolicy = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _Username;
  String? _password;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String loggedInUsername = "";
  bool _obscurePassword = true;
  String userID1 = "1";

  UserBackendService _userBackendService = UserBackendService(
    baseUrl: 'http://192.168.0.122:3000',
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleLogin(BuildContext context) async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => CustomBottomTabBar(
              trans_index: 0,
              userId: userID1,
              username: "Ramajana05",
            ),
      ),
    );
  }

  Future<User?> _verifyLogin(String username, String password) async {
    return await _userBackendService.login(username, password);
  }

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
                      child: Text(
                        "Log in",
                        style: GoogleFonts.roboto(
                          textStyle: Theme.of(
                            context,
                          ).textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _gap(),
                  TextFormField(
                    validator: (value) {},
                    onSaved: (value) => _Username = value?.trim(),
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter your Username',
                      prefixIcon: Icon(Icons.person_2_outlined),
                      filled: true,
                      fillColor:
                          MediaQuery.of(context).platformBrightness ==
                                  Brightness.dark
                              ? textfieldGrey
                              : textfieldWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(color: logoPurple, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(color: logoPurple, width: 2.0),
                      ),
                      labelStyle: TextStyle(
                        color:
                            MediaQuery.of(context).platformBrightness ==
                                    Brightness.dark
                                ? white
                                : black,
                      ),
                      errorStyle: TextStyle(color: warningRed),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(color: warningRed, width: 2.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(color: logoPurple, width: 2.0),
                      ),
                    ),
                  ),
                  _gap(),
                  TextFormField(
                    validator: (value) {},
                    onChanged: (value) {
                      setState(() {
                        _password = value.trim();
                      });
                    },
                    onSaved: (value) {
                      _password = value?.trim();
                    },
                    obscureText: !_isPasswordVisible,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      filled: true,
                      fillColor:
                          MediaQuery.of(context).platformBrightness ==
                                  Brightness.dark
                              ? textfieldGrey
                              : textfieldWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(color: logoPurple, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(color: logoPurple, width: 2.0),
                      ),
                      labelStyle: TextStyle(
                        color:
                            MediaQuery.of(context).platformBrightness ==
                                    Brightness.dark
                                ? white
                                : black,
                      ),
                      errorStyle: TextStyle(color: warningRed),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(color: warningRed, width: 2.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(color: logoPurple, width: 2.0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  _gapsmall(),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: []),
                  _gap(),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                                side: BorderSide(color: logoPurple),
                              ),
                            ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          logoPurple,
                        ),
                      ),
                      onPressed: () {
                        //_handleLogin(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => CustomBottomTabBar(
                                  trans_index: 0,
                                  userId: "1",
                                  username: "Ramajana05",
                                ),
                          ),
                        );

                        if (_formKey.currentState?.validate() ?? false) {}
                      },
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: white,
                          ),
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
                          "Don't have an account yet?",
                          style: TextStyle(fontSize: 15),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Sign up",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _gapsmallest() => const SizedBox(height: 5);
  Widget _gapsmall() => const SizedBox(height: 10);
  Widget _gap() => const SizedBox(height: 16);
  Widget _gapbig() => const SizedBox(height: 32);
  Widget _gaptop(BuildContext context) =>
      SizedBox(height: MediaQuery.of(context).size.height * 0.19);
}
