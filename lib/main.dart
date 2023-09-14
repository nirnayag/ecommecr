import 'package:ecommerce/pages/login.dart';
import 'package:ecommerce/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'pages/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(
    
      MyApp(prefs: prefs, isLoggedIn: isLoggedIn),);
  
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final bool isLoggedIn;

  MyApp({required this.prefs, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return 
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
      create: (context) => CartModel(), // Initialize your data model here
      
    ), ChangeNotifierProvider(
      create: (context) => TabIndexProvider(), // Initialize your data model here
      
    ),
      ],
        child: MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.orange,
          ),
          home: isLoggedIn
              ? HomePage(prefs: prefs)
              : LoginPage(prefs: prefs),
        
          ),
      );
  }
}




