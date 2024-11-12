import 'dart:io';
import 'dart:math';
import 'package:actividad_desis/db/database.dart';
import 'package:actividad_desis/models/sale_slip.dart';
import 'package:actividad_desis/providers/auth_provider.dart';
import 'package:actividad_desis/providers/product_provider.dart';
import 'package:actividad_desis/services/email_services.dart';
import 'package:actividad_desis/views/register/widgets/custom_button.dart';
import 'package:actividad_desis/views/sales_slip/finished_screen.dart';
import 'package:actividad_desis/views/sales_slip/rut_screen.dart';
import 'package:actividad_desis/views/sales_slip/widgets/pdf_sales_slip.dart';
import 'package:actividad_desis/views/sales_slip/widgets/pdf_viewer.dart';
import 'package:actividad_desis/views/sales_slip/widgets/sale_slip_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class TotalScreen extends StatefulWidget {
  const TotalScreen({super.key});

  @override
  State<TotalScreen> createState() => _TotalScreenState();
}

class _TotalScreenState extends State<TotalScreen> {
  final _rutController = TextEditingController();
  final _emailController = TextEditingController();
  bool autoFocus = false;
  bool isReadOnly = false;
  final emailService = EmailServices();
  bool isLoading = false;
  DBSqlite db = DBSqlite();

  @override
  void didChangeDependencies() {
    final rutProvider = Provider.of<AuthProvider>(context);
    if (rutProvider.rut.isNotEmpty) {
      _rutController.text = rutProvider.rut;
    }
    super.didChangeDependencies();
  }

  void setIsloading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void _createPreview() async {
    final productsProvider =
        Provider.of<ProductProvider>(context, listen: false);
    try {
      final pdfPreview = await PdfSalesSlipCreate.generate(
          productsProvider.products, productsProvider.totalAmount, null);

      if (mounted) {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PdfPreviewScreen(
                pdfPreview: pdfPreview.path,
              );
            },
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  int _generateFolio() {
    return 1 + Random().nextInt(1000);
  }

  //TODO: Refactorizar el codigo
  void _printSaleSlip() async {
    setIsloading();
    final folio = _generateFolio();
    final productsProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final rutProvider = Provider.of<AuthProvider>(context, listen: false);

    final pdfPreview = await PdfSalesSlipCreate.generate(
        productsProvider.products, productsProvider.totalAmount, folio);

    final now = DateTime.now();
    final nowDate = getLocalDate(now);

    final saleSlip = SaleSlip(
        folio: folio,
        rut: _rutController.text.isNotEmpty ? _rutController.text : '6666666-6',
        totalAmount: (productsProvider.totalAmount +
                (productsProvider.totalAmount * 0.19))
            .toInt(),
        saleSlip: pdfPreview.readAsBytesSync(),
        date: nowDate.toIso8601String().split('T').first,
        datetime: nowDate.toString());

    if (isReadOnly) {
      final status = await emailService.sendDocumentEmail(
          _emailController.text, pdfPreview);
      setIsloading();
      if (status == 200) {
        db.insertSaleSlip(saleSlip);
        _moveToNextPage(folio, pdfPreview);
        productsProvider.removeAllProductList();
        rutProvider.setRut('');
      } else {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Hubo un error al emitir el documento"),
            ),
          );
        }
      }
    } else {
      setIsloading();
      db.insertSaleSlip(saleSlip);
      _moveToNextPage(folio, pdfPreview);
      productsProvider.removeAllProductList();
    }
  }

  void _moveToNextPage(int folio, File pdfPreview) {
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FinishedScreen(
          folio: folio,
          pdf: pdfPreview,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _rutController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Container(
      child: productProvider.products.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.blue[700]),
                    child: const Text(
                      "Valor Total",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    child: Text(
                      "\$ ${productProvider.totalAmount}",
                      style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Enviar por correo"),
                        Switch(
                          value: isReadOnly,
                          onChanged: (value) {
                            setState(() {
                              isReadOnly = value;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  SaleSlipTextField(
                    controller: _rutController,
                    label: "RUT",
                    readOnly: !isReadOnly,
                    autoFocus: autoFocus,
                    onTap: isReadOnly
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const RutScreen();
                                },
                              ),
                            );
                          }
                        : null,
                  ),
                  SaleSlipTextField(
                    controller: _emailController,
                    label: "Correo Electronico",
                    readOnly: !isReadOnly,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomButton(
                    onPress: () {
                      _showAlert(context, true);
                      _createPreview();
                    },
                    label: "Vista Previa",
                    width: MediaQuery.of(context).size.width,
                    color: Colors.blue[700]!,
                  ),
                  CustomButton(
                    onPress: () {
                      _showAlert(context, false);
                      _printSaleSlip();
                    },
                    label: "Emitir ",
                    width: MediaQuery.of(context).size.width,
                    color: Colors.green,
                    isDisabled: isLoading,
                    isLoading: isLoading,
                  )
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

void _showAlert(BuildContext context, bool isPreview) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              width: 15.0,
            ),
            Text(
              isPreview ? 'Vista Previa...' : 'Emitiendo...',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    },
  );
}

DateTime getLocalDate(DateTime date) {
  tz.initializeTimeZones();
  var location = tz.getLocation('America/Santiago');

  return tz.TZDateTime.from(date, location);
}
