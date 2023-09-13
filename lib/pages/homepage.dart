import 'package:ecommerce/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class HomePage extends StatelessWidget {
  final SharedPreferences prefs;

  HomePage({required this.prefs});

  Future<void> logout(BuildContext context) async {
    prefs.setBool('isLoggedIn', false);
    prefs.remove('token');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(prefs: prefs)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.orange,
            ),
            child:Container()
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              // Handle the onTap action for the Home item
              Navigator.pop(context); // Close the Drawer
              // Add your navigation logic here
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Handle the onTap action for the Settings item
              Navigator.pop(context); // Close the Drawer
              // Add your navigation logic here
            },
          ),
          Spacer(), // Adds space to push the logout button to the bottom
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
                  logout(context);
            },
          ),
        ],
      ),
    ),
      appBar: AppBar(
        
        title: Text('Welcome Page'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome! You have successfully logged in.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
           
          ],
        ),
      ),
    );
  }
}