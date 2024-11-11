import 'package:actividad_desis/providers/auth_provider.dart';
import 'package:actividad_desis/validators/rut_validator.dart';
import 'package:actividad_desis/views/register/widgets/custom_button.dart';
import 'package:actividad_desis/views/sales_slip/widgets/custom_box_digit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RutScreen extends StatefulWidget {
  const RutScreen({super.key});

  @override
  State<RutScreen> createState() => _RutScreenState();
}

class _RutScreenState extends State<RutScreen> {
  final _rutController = TextEditingController();
  bool isValid = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _rutController.addListener(_isValid);
  }

  @override
  void dispose() {
    _rutController.removeListener(_isValid);
    _rutController.dispose();
    super.dispose();
  }

  void _isValid() {
    setState(() {
      isValid = _rutController.text.length > 9;
    });
  }

  void removeDigit() {
    setState(() {
      if (_rutController.text.isNotEmpty) {
        _rutController.text =
            _rutController.text.substring(0, _rutController.text.length - 1);
        formatRut();
      }
    });
  }

  addDigit(String digit) {
    if (_rutController.text.length > 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("RUT ya completo su largo máximo permitido"),
        ),
      );
    } else {
      setState(() {
        _rutController.text += digit;
        formatRut();
      });
    }
  }

  void formatRut() {
    String text = _rutController.text.replaceAll('-', '');
    if (text.length > 1) {
      text =
          '${text.substring(0, text.length - 1)}-${text.substring(text.length - 1)}';
    }
    _rutController.text = text;
  }

  @override
  Widget build(BuildContext context) {
    final rutProvider = Provider.of<AuthProvider>(context);
    final rutValidator = RUTValidator(validationErrorText: 'RUT no válido');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Digitar Rut",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1A90D9),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: TextFormField(
                  controller: _rutController,
                  keyboardType: TextInputType.none,
                  decoration: InputDecoration(
                    labelText: "RUT",
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10.0),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    prefixIcon: const Icon(
                      Icons.check_circle,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        removeDigit();
                      },
                      icon: const Icon(Icons.backspace),
                    ),
                  ),
                  validator: (value) {
                    return rutValidator.validator(value);
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(12),
                  ],
                  readOnly: true,
                ),
              ),
              Row(
                children: [
                  CustomBoxDigit(label: "1", onPress: () => addDigit("1")),
                  CustomBoxDigit(
                    label: "2",
                    onPress: () {
                      addDigit("2");
                    },
                  ),
                  CustomBoxDigit(
                    label: "3",
                    onPress: () {
                      addDigit("3");
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  CustomBoxDigit(
                    label: "4",
                    onPress: () {
                      addDigit("4");
                    },
                  ),
                  CustomBoxDigit(
                    label: "5",
                    onPress: () {
                      addDigit("5");
                    },
                  ),
                  CustomBoxDigit(
                    label: "6",
                    onPress: () {
                      addDigit("6");
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  CustomBoxDigit(
                    label: "7",
                    onPress: () {
                      addDigit("7");
                    },
                  ),
                  CustomBoxDigit(
                    label: "8",
                    onPress: () {
                      addDigit("8");
                    },
                  ),
                  CustomBoxDigit(
                    label: "9",
                    onPress: () {
                      addDigit("9");
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  CustomBoxDigit(
                    label: "0",
                    onPress: () {
                      addDigit("0");
                    },
                  ),
                  CustomBoxDigit(
                    label: "K",
                    onPress: () {
                      addDigit("K");
                    },
                  ),
                  CustomBoxDigit(
                    label: "BORRAR",
                    color: Colors.red,
                    onPress: () {
                      _rutController.clear();
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 25.0,
              ),
              CustomButton(
                onPress: () {
                  bool result = _formKey.currentState!.validate();
                  if (result) {
                    rutProvider.setRut(_rutController.text);
                    Navigator.pop(context);
                  }
                },
                label: "Aceptar",
                width: MediaQuery.of(context).size.width,
                color: Colors.blue[900]!,
                isDisabled: !isValid,
              )
            ],
          ),
        ),
      ),
    );
  }
}
