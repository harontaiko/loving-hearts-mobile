import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hearts/loading.dart';

import 'auth.dart';

class ForgotPassword extends StatefulWidget {
  static String tag = 'register-page';
  @override
  _ForgotPasswordState createState() => new _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final AuthService _auth = AuthService();

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(MaterialApp());
  }

  bool loading = false;

  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  final passwordTextEditController = new TextEditingController();

  // ignore: unused_field
  final FocusNode _passwordFocus = FocusNode();

  // ignore: unused_field
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _errorMessage = '';

  void processError(final PlatformException error) {
    setState(() {
      _errorMessage = error.message!;
    });
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            body: Center(
                child: Form(
                    key: _formKey,
                    child: ListView(
                        shrinkWrap: true,
                        padding:
                            EdgeInsets.only(top: 36.0, left: 24.0, right: 24.0),
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Enter Your email and instructions will be mailed to you',
                              style: TextStyle(
                                  fontSize: 36.0, color: Colors.black87),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              '$_errorMessage',
                              style:
                                  TextStyle(fontSize: 14.0, color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Email',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !value.contains('@')) {
                                        return 'Please enter a valid email.';
                                      }
                                      return null;
                                    },
                                    controller: passwordTextEditController,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.done,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true,
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Icon(
                                          FontAwesomeIcons.envelope,
                                          size: 28,
                                          color: Colors.black,
                                        ),
                                      ),
                                      hintText: 'email',
                                    ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.center,
                                fixedSize: Size(
                                    MediaQuery.of(context).size.width, 70.0),
                                primary: Colors.purple[300],
                                onPrimary: Colors.white,
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  dynamic result =
                                      await _auth.sendPasswordResetLink(
                                          passwordTextEditController.text);
                                  if (result == null) {
                                    setState(() {
                                      _errorMessage =
                                          'check your email for password reset instructions';
                                      loading = false;
                                    });
                                  } else {
                                    setState(() {
                                      _errorMessage = 'invalid email';
                                      loading = false;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              },
                              child: Text('send'.toUpperCase(),
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          Positioned(top: 40, left: 0, child: _backButton()),
                        ]))),
          );
  }
}
