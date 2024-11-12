import 'package:actividad_desis/db/database.dart';
import 'package:actividad_desis/models/sale_slip.dart';
import 'package:actividad_desis/views/sales_book/filter_screen.dart';
import 'package:actividad_desis/views/sales_book/sale_slip_detail.dart';
import 'package:flutter/material.dart';

class SalesBookScreen extends StatefulWidget {
  const SalesBookScreen({super.key});

  @override
  State<SalesBookScreen> createState() => _SalesBookScreenState();
}

class _SalesBookScreenState extends State<SalesBookScreen> {
  DBSqlite db = DBSqlite();
  List<SaleSlip> saleSlips = [];

  @override
  void initState() {
    loadSaleSlips();
    super.initState();
  }

  Future<void> loadSaleSlips() async {
    final saleSlipData = await db.getSaleSlips();
    setState(() {
      saleSlips = saleSlipData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Libro de Ventas",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1A90D9),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const FilterScreen();
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.search,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: saleSlips.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SaleSlipDetail(
                            saleSlip: saleSlips.elementAt(index)),
                      )),
                  leading: Image.asset(
                    'assets/pdf_icon.png',
                    height: 35,
                    width: 35,
                  ),
                  tileColor:
                      (index % 2 == 0) ? Colors.blue[100] : Colors.blue[50],
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Boleta Electronica',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${saleSlips.elementAt(index).folio} / ${saleSlips.elementAt(index).rut}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '\$ ${saleSlips.elementAt(index).totalAmount}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            saleSlips.elementAt(index).date,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
