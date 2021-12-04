
import 'package:flutter/material.dart';
import 'package:hearts/Login.dart';
import 'package:hearts/register_page.dart';
import 'package:hearts/welcomepage.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:splashscreen/splashscreen.dart';

import 'home_page.dart';
import 'login_page.dart';



class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.shade200,
                      offset: Offset(2, 4),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xff3e5f5), Color(0xff9c27b0)])),
      child: new SplashScreen(
        seconds: 3,
        navigateAfterSeconds: new AfterSplash(),
        title: new Text('Welcome to Loving hearts',
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0
        ),),
        image: new Image.asset('assets/intro.png'),
        backgroundColor: Colors.white,
        
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
      ),
    );
  }
}

class AfterSplash extends StatelessWidget {
      final routes = <String, WidgetBuilder>{
        WelcomePage.tag: (context) => WelcomePage(),
        Signin.tag:(context)=>Signin(),
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    RegisterPage.tag: (context) => RegisterPage(),
  };
  @override
  Widget build(BuildContext context) {
  return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: MaterialApp(
          title: 'Loving Hearts',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MaterialApp(
            title: 'Loving Hearts',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.lightBlue,
              fontFamily: 'Nunito',
            ),
            home: WelcomePage(),
            routes: routes,
          )),
    );
  }
}