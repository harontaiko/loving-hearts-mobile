import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:hearts/Login.dart';
import 'package:hearts/loading.dart';
import 'package:hearts/payment.dart';
import 'package:hearts/terms.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
  final emailTextEditController = new TextEditingController();
  final sponsorTextEditController = new TextEditingController();
  final phoneTextEditController = new TextEditingController();
  final usernameTextEditController = new TextEditingController();
  final passwordTextEditController = new TextEditingController();
  final confirmPasswordTextEditController = new TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _sponsorFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _errorMessage = '';

  void processError(final PlatformException error) {
    setState(() {
      _errorMessage = error.message!;
    });
  }

  String _res = "";

  String phpurl = "https://wealthlifeglobal.com/createslots.php";

  Future<void> senddata() async {
    var res = await http.post(Uri.parse(phpurl), body: {
      "id": FirebaseAuth.instance.currentUser!.uid.toString(),
      'username': usernameTextEditController.text,
      'phone': phoneTextEditController.text,
      'email': emailTextEditController.text,
      'sponsor': sponsorTextEditController.text,
    });

    _res = res.body;
  }

    Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Signin()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
     // ignore: unused_local_variable
     final height = MediaQuery.of(context).size.height;
    print(_res);
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
                            'Join Loving Hearts',
                            style: TextStyle(
                                fontSize: 26.0, color: Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            '$_errorMessage',
                            style: TextStyle(fontSize: 14.0, color: Colors.red),
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
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return 'Please enter a valid email.';
                                  }
                                  return null;
                                },
                                controller: emailTextEditController,
                                keyboardType: TextInputType.emailAddress,
                                autofocus: true,
                                textInputAction: TextInputAction.next,
                                focusNode: _emailFocus,
                                onFieldSubmitted: (term) {
                                  FocusScope.of(context)
                                      .requestFocus(_usernameFocus);
                                },
                                decoration: InputDecoration(
                                    hintText: 'Email',
                                    border: InputBorder.none,
                                    fillColor: Color(0xfff3f3f4),
                                    filled: true),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Username',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                             TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your username.';
                              }
                              return null;
                            },
                            controller: usernameTextEditController,
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            textInputAction: TextInputAction.next,
                            focusNode: _usernameFocus,
                            onFieldSubmitted: (term) {
                              FocusScope.of(context).requestFocus(_phoneFocus);
                            },
                            decoration: InputDecoration(
                              hintText: 'username',
                                    border: InputBorder.none,
                                    fillColor: Color(0xfff3f3f4),
                                    filled: true
                            ),
                          ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Phone',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                             TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your phone number.';
                              }
                              return null;
                            },
                            controller: phoneTextEditController,
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            textInputAction: TextInputAction.next,
                            focusNode: _phoneFocus,
                            onFieldSubmitted: (term) {
                              FocusScope.of(context)
                                  .requestFocus(_sponsorFocus);
                            },
                            decoration: InputDecoration(
                              hintText: 'phone starts with 254(required)',
                               border: InputBorder.none,
                                    fillColor: Color(0xfff3f3f4),
                                    filled: true
                            ),
                          ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Sponsor',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                             TextFormField(
                            controller: sponsorTextEditController,
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            textInputAction: TextInputAction.next,
                            focusNode: _sponsorFocus,
                            onFieldSubmitted: (term) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocus);
                            },
                            decoration: InputDecoration(
                              hintText: 'sponsor(required)',
                             border: InputBorder.none,
                                    fillColor: Color(0xfff3f3f4),
                                    filled: true
                            ),
                          ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Password',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            TextFormField(
                            validator: (value) {
                              if (value!.length < 8) {
                                return 'Password must be longer than 8 characters.';
                              }
                              return null;
                            },
                            autofocus: false,
                            obscureText: true,
                            controller: passwordTextEditController,
                            textInputAction: TextInputAction.next,
                            focusNode: _passwordFocus,
                            onFieldSubmitted: (term) {
                              FocusScope.of(context)
                                  .requestFocus(_confirmPasswordFocus);
                            },
                            decoration: InputDecoration(
                              hintText: 'Password',
                              border: InputBorder.none,
                                    fillColor: Color(0xfff3f3f4),
                                    filled: true
                            ),
                          ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Password',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                         TextFormField(
                            autofocus: false,
                            obscureText: true,
                            controller: confirmPasswordTextEditController,
                            focusNode: _confirmPasswordFocus,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (passwordTextEditController.text.length > 8 &&
                                  passwordTextEditController.text != value) {
                                return 'Passwords do not match.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                                  border: InputBorder.none,
                                    fillColor: Color(0xfff3f3f4),
                                    filled: true
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'I agree to the ',
                              style: TextStyle(color: Colors.black),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Terms()));
                              },
                              child: Text(
                                'Terms and Conditions',
                                style: TextStyle(
                                    color: Colors.blue[600],
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                            ],
                          ),
                        ),



          
                       
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          fixedSize: Size(MediaQuery.of(context).size.width, 50.0),
          primary: Colors.purple[300],
          onPrimary: Colors.white,
          textStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                _firebaseAuth
                                    .createUserWithEmailAndPassword(
                                        email: emailTextEditController.text,
                                        password:
                                            passwordTextEditController.text)
                                    .then((onValue) {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .set({
                                    'username': usernameTextEditController.text,
                                    'phone': phoneTextEditController.text,
                                    'reg': "",
                                    'sponsor': sponsorTextEditController.text,
                                    'email': emailTextEditController.text,
                                    'balance': '0',
                                    'created': FieldValue.serverTimestamp(),
                                  }).then((userInfoValue) async {
                                    User? user =
                                        FirebaseAuth.instance.currentUser;
                                    senddata();
                                    if (user != null && !user.emailVerified) {
                                      await user.sendEmailVerification();
                                      setState(() {
                                        loading = false;
                                        sponsorTextEditController.clear();
                                        usernameTextEditController.clear();
                                        phoneTextEditController.clear();
                                        emailTextEditController.clear();
                                        passwordTextEditController.clear();
                                        confirmPasswordTextEditController
                                            .clear();
                                      });
                                    }

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Mpesa()));
                                  });
                                }).catchError((onError) {
                                  processError(onError);
                                });
                              }
                            },
                            child: Text('Sign Up'.toUpperCase(),
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                                         
                    _loginAccountLabel(),
                      
                      ],
                    ))),
          );
  }
}
