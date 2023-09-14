import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


import '../pages/cartPage.dart';
import '../pages/productdetailpage.dart';
import '../provider.dart';

class AllCardsPage extends StatefulWidget {
  final String categoryUrl;

  AllCardsPage({required this.categoryUrl, required String searchQuery});

  @override
  _AllCardsPageState createState() => _AllCardsPageState();
}

enum SortingOrder { highestToLowest, lowestToHighest }

class _AllCardsPageState extends State<AllCardsPage> {
  List<dynamic> products = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  SortingOrder sortingOrder = SortingOrder.highestToLowest;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    fetchProducts();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(widget.categoryUrl));
      if (_isMounted) {
        if (response.statusCode == 200) {
          setState(() {
            products = json.decode(response.body);
            isLoading = false;
          });
        } else {
          throw Exception('Failed to load products');
        }
      }
    } catch (error) {
      if (_isMounted) {
        print(error);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void updateProductInList(Map<String, dynamic> updatedProduct) {
    setState(() {
      final index = products.indexWhere(
          (product) => product['id'] == updatedProduct['id']);

      if (index != -1) {
        products[index] = updatedProduct;
      }
    });
  }

  List<dynamic> filteredData() {
    final query = searchController.text.toLowerCase();
    var filteredList = products.where((item) {
      final itemTitle = item['title'].toString().toLowerCase();
      return itemTitle.contains(query);
    }).toList();

    if (sortingOrder == SortingOrder.highestToLowest) {
      filteredList.sort((a, b) => b['price'].compareTo(a['price']));
    } else {
      filteredList.sort((a, b) => a['price'].compareTo(b['price']));
    }

    return filteredList;
  }

  void _navigateToProductDetail(
      BuildContext context, Map<String, dynamic> product) async {
    final updatedProduct = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ProductDetailPage(product: product),
    ));

    if (updatedProduct != null && updatedProduct is Map<String, dynamic>) {
      updateProductInList(updatedProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context, listen: false);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: (text) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DropdownButton<SortingOrder>(
            value: sortingOrder,
            icon: Icon(Icons.arrow_drop_down),
            onChanged: (value) {
              setState(() {
                sortingOrder = value!;
              });
            },
            items: SortingOrder.values
                .map((order) => DropdownMenuItem<SortingOrder>(
                      value: order,
                      child: Text(order == SortingOrder.highestToLowest
                          ? 'Highest to Lowest Price'
                          : 'Lowest to Highest Price'),
                    ))
                .toList(),
          ),
          isLoading
              ? CircularProgressIndicator()
              : filteredData().isEmpty
                  ? Center(
                      child: Text('No items found.'),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: filteredData().length,
                        itemBuilder: (context, index) {
                          final product = filteredData()[index];

                          return CardItem(
                            product: product,
                            cartModel: cartModel,
                            onProductTap: () {
                              _navigateToProductDetail(context, product);
                            },
                          );
                        },
                      ),
                    ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CartPage(cartModel: cartModel),
          )).then((_) {
            setState(() {});
          });
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}

class CardItem extends StatefulWidget {
  final Map<String, dynamic> product;
  final CartModel cartModel;
  final Function() onProductTap;

  CardItem({
    required this.product,
    required this.cartModel,
    required this.onProductTap,
  });

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  bool isAddedToCart = false;

  @override
  void initState() {
    super.initState();
    isAddedToCart = widget.cartModel.contains(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onProductTap,
      child: Card(
        
        elevation: 4,
        margin: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Image.network(
            widget.product['image'],
            height: 100,
           
            fit: BoxFit.cover,
          ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [Text(
                widget.product['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                
                ),
                maxLines: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0,bottom: 5 ,right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Category: ${widget.product['category']}',
                        style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,
                    ),
                      ),
                      Text(
                        'Price: \$${widget.product['price']}',
                        style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,),
                      ),
                          
                    ],
                  ),
              ),
            
                     Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                       children: [
                         ElevatedButton(
                  onPressed: () {
                    setState(() {
                          if (isAddedToCart) {
                            widget.cartModel.removeFromCart(widget.product);
                          } else {
                            widget.cartModel.addToCart(widget.product);
                          }
                          isAddedToCart = !isAddedToCart; // Toggle the state
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange
                  ),
                  child: Text(
                    isAddedToCart ? 'Aded' : 'Add To cart',
                    style: TextStyle(color: isAddedToCart ? Colors.white : Colors.white,),
                    
                  ),
                ),
                       ],
                     ),],
              ),
            )
           
          ],
        ),
      ),
    );
  }
}
