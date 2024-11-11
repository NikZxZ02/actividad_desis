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
  int folio = 1450;
  bool isLoading = false;

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
          productsProvider.products, productsProvider.totalAmount, folio);

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
      print("Error al realizar la vista previa");
    }
  }

  void sendEmail() async {
    setIsloading();
    final productsProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final rutProvider = Provider.of<AuthProvider>(context, listen: false);
    final pdfPreview = await PdfSalesSlipCreate.generate(
        productsProvider.products, productsProvider.totalAmount, folio);

    if (isReadOnly) {
      final status = await emailService.sendDocumentEmail(
          _emailController.text, pdfPreview);
      setIsloading();
      if (mounted && status == 200) {
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
      if (mounted) {
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

        productsProvider.removeAllProductList();
      }
    }
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
                              isReadOnly = !isReadOnly;
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
                      sendEmail();
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
