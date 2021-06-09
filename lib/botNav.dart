import 'package:flutter/material.dart';
import 'Models/UserSql.dart';
import 'dart:async';
import 'Home.dart';
import 'Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_in.dart';
import 'jadwal.dart';
import 'profile.dart';

class BotNav extends StatefulWidget {
  @override
  static String tag = 'bot-page';
  final user;
  BotNav(this.user);
  BotNavState createState() => BotNavState();
}

String a;
int _currentIndex = 0;
String id;
User d;

class BotNavState extends State<BotNav> {
  Widget build(BuildContext context) {
    User us = widget.user;
    final User userArgs = ModalRoute.of(context).settings.arguments;
    if (userArgs != null) {
      a = userArgs.uid;
      d = userArgs;
    } else {
      a = us.uid;
      d = us;
    }
    final List<Widget> _children = [Home(a), Jadwal(a),Profile(d)];
    //int id = userArgs.id;

    @override
    void onTabTapped(int index) {
      setState(() {
        _currentIndex = index;
      });
    }

    void handleClick(String value) {
      switch (value) {
        case 'Logout':
          signOutGoogle();

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) {
            return LoginPage();
          }), ModalRoute.withName('/'));
          break;
        case 'Settings':
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("semabako"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Logout', 'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),

      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped, // new
          currentIndex: _currentIndex, // new
          items: [
            new BottomNavigationBarItem(
              icon: Icon(Icons.cake),
              title: Text('Sembako'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.date_range),
              title: Text('Jadwal'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.account_balance),
              title: Text('Profile'),
            ),
          ]),
    );
  }
}
