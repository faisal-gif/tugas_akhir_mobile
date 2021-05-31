import 'package:flutter/material.dart';
import 'package:uts/botNav.dart';
import 'package:uts/sign_in.dart';
import 'Home.dart';
import 'Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
//package letak folder Anda
void main() => runApp(MyApp());
User us;
class MyApp extends StatelessWidget {
 
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    BotNav.tag: (context) => BotNav(us),
  };
  
  Widget home=LoginPage();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tambahkan Item',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: routePage(),
      routes: routes,
    );
  }
}
class routePage extends StatefulWidget
{
  @override
  routePageState createState() => routePageState();
}

class routePageState extends State<routePage>
{
  
  bool isLoggedin = false;
  @override
  void initState() {
    super.initState();
    print("Init state");
    getCurrentUser().then((value){
      if(value == 'null')
      {
        print(isLoggedin);
        setState(() {
          isLoggedin = false;
        });
      }
      else if(value !=null)
      {
        us= value;
        setState(() {
          isLoggedin = true;
        });
      }
      else{
        setState(() {
          isLoggedin = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedin==true ? BotNav(us) : LoginPage();
  }

}
