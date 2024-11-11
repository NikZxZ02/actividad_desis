import 'package:actividad_desis/providers/product_provider.dart';
import 'package:actividad_desis/views/sales_slip/add_products_screen.dart';
import 'package:actividad_desis/views/sales_slip/sales_slip.dart';
import 'package:actividad_desis/views/sales_slip/total_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleSlipScreen extends StatefulWidget {
  const SaleSlipScreen({super.key});

  @override
  State<SaleSlipScreen> createState() => _SaleSlipScreenState();
}

class _SaleSlipScreenState extends State<SaleSlipScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int page = 0;

  void onPageChange(int newPage) {
    setState(() {
      page = newPage;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    final views = [
      if (productProvider.products.isNotEmpty)
        _productList(productProvider.products)
      else
        const SaleSlip(otherProduct: false),
      const TotalScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Boleta Express",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1A90D9),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            productProvider.deleteProduct();
            productProvider.removeAllProductList();
          },
        ),
        actions: [
          productProvider.products.isNotEmpty && page == 0
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const AddProductScreen();
                        },
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.add,
                  ),
                )
              : const SizedBox.shrink(),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.live_help,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            page == 0 ? "Agregar detalle" : "Totales",
            style: TextStyle(
              fontSize: 17,
              color: Colors.blue[600],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  _pageController.animateToPage(0,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeIn);
                  onPageChange(0);
                },
                icon: Icon(
                  Icons.arrow_circle_left_outlined,
                  color: page == 1 ? Colors.blue[500] : Colors.blue[100],
                ),
                iconSize: 30,
              ),
              Icon(
                Icons.circle,
                color: page == 0 ? Colors.blue[500] : Colors.blue[100],
              ),
              Icon(
                Icons.circle,
                color: page == 1 ? Colors.blue[500] : Colors.blue[100],
              ),
              IconButton(
                onPressed: () {
                  _pageController.animateToPage(1,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeInOut);
                  onPageChange(1);
                },
                icon: Icon(
                  Icons.arrow_circle_right_outlined,
                  color: page == 0 ? Colors.blue[500] : Colors.blue[100],
                ),
                iconSize: 30,
              )
            ],
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: views.length,
              onPageChanged: onPageChange,
              itemBuilder: (context, index) {
                return views.elementAt(index);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _productList(List<Map<String, dynamic>> products) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 5.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      color: (index % 2 == 0) ? Colors.white : Colors.grey[200],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                products.elementAt(index)['description'],
                                style: const TextStyle(fontSize: 17),
                              ),
                              Row(
                                children: [
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Cantidad:",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        "Precio Unitario:",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${products.elementAt(index)['quantity']} UN",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "\$ ${products.elementAt(index)['unitPrice']}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          "Valor Total:",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "\$ ${products.elementAt(index)['totalValue']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        PopupMenuButton(
                          onSelected: (value) =>
                              productProvider.removeProductToList(index),
                          itemBuilder: (context) => <PopupMenuEntry>[
                            const PopupMenuItem(
                              value: "Delete",
                              child: Text('Borrar'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.blue[700]),
                child: const Text(
                  "Monto Total",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.grey[300]),
                child: Text(
                  "\$ ${productProvider.totalAmount}",
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
