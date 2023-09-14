import 'package:flutter/material.dart';
import '../provider.dart';

class CartPage extends StatefulWidget {
  final CartModel cartModel;

  CartPage({
    required this.cartModel,
  });

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double _totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _calculateTotalPrice();
  }

  void _calculateTotalPrice() {
    double total = widget.cartModel.cart.fold(0, (prev, product) => prev + product['price']);
    setState(() {
      _totalPrice = total;
    });
  }

  Widget _buildCartItem(Map<String, dynamic> product) {
    return Dismissible(
      key: Key(product['id'].toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      onDismissed: (direction) {
        widget.cartModel.removeFromCart(product);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed from cart: ${product['title']}'),
            duration: Duration(seconds: 2),
          ),
        );
        _calculateTotalPrice();
      },
      child: Card(
        margin: EdgeInsets.all(16),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          leading: Image.network(
            product['image'],
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
          title: Text(
            product['title'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Category: ${product['category']}',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                'Price: \$${product['price']}',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Shopping Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartModel.cart.length,
              itemBuilder: (context, index) {
                final product = widget.cartModel.cart[index];
                return _buildCartItem(product);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Price: \$${_totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
