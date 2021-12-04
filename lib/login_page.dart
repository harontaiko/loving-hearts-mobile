import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hearts/forgotpassword.dart';
import 'package:hearts/loading.dart';
import 'package:hearts/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hearts/home_page.dart';

import 'Widget/bezierContainer.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ignore: unused_field
  final AuthService _auth = AuthService();
  // ignore: unused_field
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
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

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  String _errorMessage = '';

  void onChange() {
    setState(() {
      _errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final node = FocusScope.of(context);

    emailController.addListener(onChange);
    passwordController.addListener(onChange);

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/intro.png'),
      ),
    );

    final errorMessage = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '$_errorMessage',
        style: TextStyle(fontSize: 14.0, color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );

    final email = TextFormField(
      validator: (value) {
        if (value!.isEmpty || !value.contains('@')) {
          return 'Please enter a valid email.';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: emailController,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      textInputAction: TextInputAction.next,
      onEditingComplete: () => node.nextFocus(),
    );

    final password = TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter password.';
        }
        return null;
      },
      autofocus: false,
      obscureText: true,
      controller: passwordController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(node);
      },
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
borderRadius: BorderRadius.circular(24),
                                )
                              )),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() {
              loading = true;
            });
            signIn(emailController.text, passwordController.text)
                .then((uid) => {
                      Navigator.of(context).pushNamed(HomePage.tag),
                    })
                // ignore: invalid_return_type_for_catch_error
                .catchError((error) => {processError(error)});
          }
        },
        
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = Padding(
        padding: EdgeInsets.all(10.0),
        child: new GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ForgotPassword()));
          },
          child: Text(
            'Forgot password?',
            style: TextStyle(color: Colors.black54),
          ),
        ));

    final registerButton = Padding(
      padding: EdgeInsets.zero,
      child: ElevatedButton(
        style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
borderRadius: BorderRadius.circular(24),
                                )
                              )),
        onPressed: () {
          Navigator.of(context).pushNamed(RegisterPage.tag);
        },
        
        child: Text('Join Now', style: TextStyle(color: Colors.white)),
      ),
    );

    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              
              child: Stack(
                children: <Widget>[
                  Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),
                  Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 24.0, right: 24.0),
                      children: <Widget>[
                        logo,
                        SizedBox(height: 24.0),
                        errorMessage,
                        SizedBox(height: 12.0),
                        email,
                        SizedBox(height: 8.0),
                        password,
                        SizedBox(height: 24.0),
                        loginButton,
                        registerButton,
                        forgotLabel
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }

  Future<String> signIn(final String email, final String password) async {
    UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.user!.uid;
  }

  void processError(final FirebaseAuthException error) {
    setState(() {
      loading = false;
    });
    if (error.code == "ERROR_USER_NOT_FOUND") {
      setState(() {
        _errorMessage = "Unable to find user. Please register.";
        loading = false;
      });
    } else if (error.code == "ERROR_WRONG_PASSWORD") {
      setState(() {
        _errorMessage = "Incorrect password.";
        loading = false;
      });
    } else {
      setState(() {
        _errorMessage = "incorrect email or password";
        loading = false;
      });
    }
  }
}
