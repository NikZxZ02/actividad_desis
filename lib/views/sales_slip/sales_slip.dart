import 'package:actividad_desis/providers/product_provider.dart';
import 'package:actividad_desis/views/register/widgets/custom_button.dart';
import 'package:actividad_desis/views/sales_slip/search_product_screen.dart';
import 'package:actividad_desis/views/sales_slip/widgets/sale_slip_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleSlip extends StatefulWidget {
  final bool otherProduct;
  const SaleSlip({super.key, required this.otherProduct});

  @override
  State<SaleSlip> createState() => _SaleSlipState();
}

class _SaleSlipState extends State<SaleSlip> {
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _totalValue = TextEditingController();
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    _codeController.addListener(checkIfForm);
    _descriptionController.addListener(checkIfForm);
    _quantityController.addListener(checkIfForm);
    _unitPriceController.addListener(checkIfForm);
    _totalValue.addListener(checkIfForm);

    _quantityController.addListener(_updateTotalValue);
    _unitPriceController.addListener(_updateTotalValue);
  }

  void checkIfForm() {
    setState(() {
      isValid = _codeController.text.isNotEmpty &&
          _descriptionController.text.isNotEmpty &&
          _quantityController.text.isNotEmpty &&
          _unitPriceController.text.isNotEmpty &&
          _totalValue.text.isNotEmpty;
    });
  }

  void _updateTotalValue() {
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final unitPrice = int.tryParse(_unitPriceController.text) ?? 0;
    final totalValue = quantity * unitPrice;
    _totalValue.text = totalValue.toString();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final productProvider = Provider.of<ProductProvider>(context);

    if (productProvider.product != null) {
      _codeController.text = productProvider.product!.code;
      _descriptionController.text = productProvider.product!.description;
      _unitPriceController.text = productProvider.product!.unitPrice.toString();
      _quantityController.text = 1.toString();
      _totalValue.text = (productProvider.product!.unitPrice *
              (int.tryParse(_quantityController.text) ?? 0))
          .toString();
    }
  }

  void addProduct() {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final product = {
      "code": _codeController.text,
      "description": _descriptionController.text,
      "quantity": _quantityController.text,
      "unitPrice": _unitPriceController.text,
      "totalValue": int.parse(_totalValue.text)
    };
    productProvider.addToProductList(product);
    productProvider.deleteProduct();
    if (widget.otherProduct) {
      Navigator.pop(context);
    }
  }

  void clearTextField() {
    _codeController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    _unitPriceController.clear();
    _totalValue.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.blue[800],
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const SearchProductScreen();
                        },
                      ));
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.blue[800],
                    ),
                    onPressed: () {
                      clearTextField();
                    },
                  )
                ],
              ),
            ),
            SaleSlipTextField(
              controller: _codeController,
              label: "Código",
              readOnly: true,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const SearchProductScreen();
                  },
                ));
              },
            ),
            SaleSlipTextField(
              controller: _descriptionController,
              label: "Descripción",
              readOnly: false,
            ),
            Row(
              children: [
                Expanded(
                  child: SaleSlipTextField(
                    controller: _quantityController,
                    label: "Cantidad",
                    readOnly: false,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_circle_down,
                    color: Colors.blue[800],
                  ),
                  onPressed: () {
                    if (_quantityController.text.isNotEmpty) {
                      final currentQuantity =
                          int.tryParse(_quantityController.text) ?? 0;
                      if (currentQuantity > 1) {
                        _quantityController.text =
                            (currentQuantity - 1).toString();
                      }
                    }
                  },
                ),
                const SizedBox(
                  width: 20.0,
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_circle_up,
                    color: Colors.blue[800],
                  ),
                  onPressed: () {
                    if (_quantityController.text.isNotEmpty) {
                      _quantityController.text =
                          (int.parse(_quantityController.text) + 1).toString();
                    }
                  },
                ),
              ],
            ),
            SaleSlipTextField(
              controller: _unitPriceController,
              label: "Precio Unitario",
              readOnly: false,
              keyboardType: TextInputType.number,
            ),
            Text(
              "Valor total",
              style: TextStyle(
                color: Colors.blue[600],
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            Divider(
              color: Colors.blue[600],
              height: 1.0,
              thickness: 2,
            ),
            const SizedBox(
              height: 5.0,
            ),
            SaleSlipTextField(
              controller: _totalValue,
              readOnly: true,
            ),
            CustomButton(
              onPress: () {
                addProduct();
              },
              label: "Aceptar",
              width: MediaQuery.of(context).size.width,
              isDisabled: !isValid,
            )
          ],
        ),
      ),
    );
  }
}
