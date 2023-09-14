import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'gestpage.dart';
import 'homepage.dart';


class LoginPage extends StatefulWidget {
  final SharedPreferences prefs;

  LoginPage({required this.prefs});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorMessage = "";

  Future<void> login() async {
    final url = Uri.parse('https://fakestoreapi.com/auth/login');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR",
      },
      body: jsonEncode({
        "username": usernameController.text,
        "password": passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String receivedToken = responseData['token'];

      widget.prefs.setBool('isLoggedIn', true);
      widget.prefs.setString('token', receivedToken);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(prefs: widget.prefs)),
      );
    } else {
      setState(() {
        errorMessage = "Incorrect username or password. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                obscureText: true,
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    login();
                  },
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    elevation: 4,
                  ),
                ),
                ElevatedButton(
                  
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GestView()),
            );
          },
          child: Text('Go to Guest Page'),
           style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    elevation: 4,
                  ),
        ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              errorMessage,
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}