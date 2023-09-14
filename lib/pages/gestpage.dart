import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GestView extends StatefulWidget {
  @override
  _GestViewState createState() => _GestViewState();
}

class _GestViewState extends State<GestView> with SingleTickerProviderStateMixin {
  List<String> tabs = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchCategories() async {
    String categoriesUrl = 'https://fakestoreapi.com/products/categories';
    final response = await http.get(Uri.parse(categoriesUrl));

    if (response.statusCode == 200) {
      final categories = ['All', ...jsonDecode(response.body)].map((category) => category.toString()).toList();
      setState(() {
        tabs = categories;
        _tabController = TabController(length: categories.length, vsync: this);
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Gest View'),
        bottom: tabs.isEmpty
            ? null
            : TabBar(
                  unselectedLabelColor: Colors.red[50],
                  labelColor: Colors.white,
                  
                controller: _tabController,
                tabs: tabs.map((tab) => Tab(text: tab)).toList(),
              ),
      ),
      body: tabs.isEmpty
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: tabs.map((tab) {
                return ProductList(category: tab);
              }).toList(),
            ),
    );
  }
}

class ProductList extends StatefulWidget {
  final String category;

  ProductList({required this.category});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    String url = widget.category == 'All'
        ? 'https://fakestoreapi.com/products'
        : 'https://fakestoreapi.com/products/category/${widget.category.toLowerCase()}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        products = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        final product = products[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetail(product: product),
              ),
            );
          },
          child: Card(
            child: ListTile(
              leading: Image.network(product['image']),
              title: Text(product['title']),
              subtitle: Text('\$${product['price']}'),
            ),
          ),
        );
      },
    );
  }
}

class ProductDetail extends StatelessWidget {
  final dynamic product;

  ProductDetail({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,

        title: Text('Product Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(product['image']),
            ListTile(
              title: Text(product['title']),
              subtitle: Text('\$${product['price']}'),
            ),
            ListTile(
              title: Text('Description'),
              subtitle: Text(product['description']),
            ),
          ],
        ),
      ),
    );
  }
}
