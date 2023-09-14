import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/AllCards.dart';
import 'login.dart';

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

  final List<String> tabTexts = [
    'All',
    'electronics',
    'jewelery',
    "men's clothing",
    "women's clothing",
  ];

  @override
  Widget build(BuildContext context) {
    // Load the selected tab index from SharedPreferences
    final selectedTabIndex = prefs.getInt('selectedTabIndex') ?? 0;
  
    return DefaultTabController(
      length: tabTexts.length,
      initialIndex: selectedTabIndex,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.orange,
                ),
                child: Container(),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context); // Close the Drawer
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Navigator.pop(context); // Close the Drawer
                  // Add your navigation logic here
                },
              ),
              Spacer(),
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.orange, borderRadius: BorderRadius.circular(25)),
                child: TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.red[50],
                  indicator:
                      BoxDecoration(color: Colors.lime[500], borderRadius: BorderRadius.circular(25)),
                  tabs: tabTexts.map((text) => Tab(text: text)).toList(),
                  onTap: (index) {
                    // Use Provider to update the selected tab index
                    Provider.of<TabIndexProvider>(context, listen: false).updateTabIndex(index);

                    // Save the selected tab index to SharedPreferences
                    prefs.setInt('selectedTabIndex', index);
                  },
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    AllCardsPage(categoryUrl: 'https://fakestoreapi.com/products', searchQuery: '',),
                    AllCardsPage(categoryUrl: 'https://fakestoreapi.com/products/category/electronics', searchQuery: '',),
                    AllCardsPage(categoryUrl: 'https://fakestoreapi.com/products/category/jewelery', searchQuery: '',),
                    AllCardsPage(categoryUrl: "https://fakestoreapi.com/products/category/men's clothing", searchQuery: '',),
                    AllCardsPage(categoryUrl: "https://fakestoreapi.com/products/category/women's clothing", searchQuery: '',),
                    // AllCardsPage(categoryUrl: 'https://fakestoreapi.com/products/category', searchQuery: '',),
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TabIndexProvider with ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void updateTabIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
  
}
