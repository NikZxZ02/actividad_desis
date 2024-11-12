import 'dart:io';
import 'package:actividad_desis/models/sale_slip.dart';
import 'package:actividad_desis/views/register/widgets/custom_button.dart';
import 'package:actividad_desis/views/sales_book/widgets/row_text_box.dart';
import 'package:actividad_desis/views/sales_slip/widgets/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class SaleSlipDetail extends StatefulWidget {
  final SaleSlip saleSlip;
  const SaleSlipDetail({super.key, required this.saleSlip});

  @override
  State<SaleSlipDetail> createState() => _SaleSlipDetailState();
}

class _SaleSlipDetailState extends State<SaleSlipDetail> {
  bool isLoading = false;

  void setIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void _viewDocument() async {
    setIsLoading();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/boleta.pdf');
    final pdf = await file.writeAsBytes(widget.saleSlip.saleSlip);
    if (mounted) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfPreviewScreen(pdfPreview: pdf.path),
          ));
    }
    setIsLoading();
  }

  @override
  Widget build(BuildContext context) {
    final datetime = DateTime.parse(widget.saleSlip.datetime);
    final formatDate = DateFormat('yyyy-MM-dd HH:mm').format(datetime);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detalle Venta",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1A90D9),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "BOLETA ELECTRONICA",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            CustomRowText(
                label: "Folio:", value: widget.saleSlip.folio.toString()),
            CustomRowText(label: "Rut:", value: widget.saleSlip.rut),
            CustomRowText(
                label: "Monto Total:",
                value: '\$ ${widget.saleSlip.totalAmount.toString()}'),
            const CustomRowText(
              label: "Estado DTE en SII:",
              value: 'Aceptado',
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              "Periodo",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            CustomRowText(
                label: "Fecha documento:", value: widget.saleSlip.date),
            CustomRowText(label: "Fecha de Ingreso:", value: formatDate),
            const SizedBox(
              height: 45.0,
            ),
            CustomButton(
              onPress: () {
                _viewDocument();
              },
              label: "Ver PDF",
              width: MediaQuery.of(context).size.width,
              color: Colors.blue[800]!,
            ),
          ],
        ),
      ),
    );
  }
}
