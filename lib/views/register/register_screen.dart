import 'dart:developer';

import 'package:actividad_desis/db/database.dart';
import 'package:actividad_desis/models/user.dart';
import 'package:actividad_desis/services/user_service.dart';
import 'package:actividad_desis/views/auth/login_screen.dart';
import 'package:actividad_desis/views/register/widgets/custom_button.dart';
import 'package:actividad_desis/views/register/widgets/custom_texfield.dart';
import 'package:actividad_desis/widgets/custom_drawer.dart';
import 'package:actividad_desis/widgets/message_status.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:actividad_desis/validators/form_validators.dart' as validators;

class RegisterScreen extends StatefulWidget {
  final bool newUser;
  const RegisterScreen({super.key, required this.newUser});

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _addressController = TextEditingController();
  final _dateController = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isValid = false;
  final userService = UserService();
  DBSqlite database = DBSqlite();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(checkIfForm);
    _emailController.addListener(checkIfForm);
    _passwordController.addListener(checkIfForm);
    _addressController.addListener(checkIfForm);
    _dateController.addListener(checkIfForm);
    _phoneNumber.addListener(checkIfForm);
    _passwordConfirmController.addListener(checkIfForm);
  }

  void setIsLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  void checkIfForm() {
    setState(() {
      bool isEmptyInputs = _nameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _addressController.text.isNotEmpty &&
          _dateController.text.isNotEmpty &&
          _phoneNumber.text.isNotEmpty;
      isValid = widget.newUser
          ? isEmptyInputs && _passwordConfirmController.text.isNotEmpty
          : isEmptyInputs;
    });
  }

  void handleGetUser() async {
    setIsLoading(true);
    final user = await userService.fetchUser();
    _nameController.text = user!.name;
    _emailController.text = user.email;
    _addressController.text = user.address;
    _dateController.text = user.birthDate.split('T')[0];
    _phoneNumber.text = user.phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    _passwordController.text = user.password;
    setIsLoading(false);
  }

  void handleRegister() async {
    final location = await userService.getLocation(_addressController.text);
    User user = User(
      name: _nameController.text,
      email: _emailController.text,
      birthDate: _dateController.text,
      address: _addressController.text,
      password: _passwordController.text,
      phoneNumber: _phoneNumber.text,
      coordinates: [location["lat"], location["lon"]],
    );
    database.insertUser(user);
    if (mounted) {
      MessagesStatus.showStatusMessage(
          context, "Usuario registrado con exito", false);
    }
    _nameController.clear();
    _emailController.clear();
    _dateController.clear();
    _addressController.clear();
    _phoneNumber.clear();
    _passwordController.clear();

    if (widget.newUser) {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const LoginScreen();
          },
        ));
      }
    }
  }

  void handleGetLocation() async {
    final location = await userService.getLocation(_addressController.text);
    log(location["lat"].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Creación Cuenta",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1A90D9),
      ),
      drawer: widget.newUser
          ? null
          : const CustomDrawer(
              isHome: false,
            ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                  controller: _nameController,
                  label: "Nombre Completo",
                  validator: validators.nameValidator),
              CustomTextFormField(
                  controller: _emailController,
                  label: "Correo Electrónico",
                  validator: validators.emailValidator),
              CustomTextFormField(
                  controller: _addressController,
                  label: "Dirección",
                  validator: validators.addressValidator),
              CustomTextFormField(
                  controller: _phoneNumber,
                  label: "Número de Teléfono",
                  validator: validators.phoneNumberValidator),
              CustomTextFormField(
                  controller: _dateController,
                  label: "Fecha de Nacimiento",
                  onTap: _onSelectedDate,
                  readOnly: true,
                  validator: validators.birthdayValidator),
              CustomTextFormField(
                  controller: _passwordController,
                  label: "Contraseña",
                  validator: validators.passwordValidator),
              widget.newUser
                  ? CustomTextFormField(
                      controller: _passwordConfirmController,
                      label: "Confirmar Contraseña",
                      validator: (value) => validators.confirmPasswordValidator(
                          value, _passwordController.text),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomButton(
                    onPress: () {
                      _formKey.currentState!.save();
                      if (_formKey.currentState!.validate()) {
                        handleRegister();
                      }
                    },
                    isDisabled: !isValid,
                    label: "Registrar Usuario",
                    width: MediaQuery.of(context).size.width),
              ),
              const SizedBox(
                height: 5,
              ),
              widget.newUser
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: CustomButton(
                        onPress: () {
                          handleGetUser();
                        },
                        label: "Obtener desde API",
                        width: MediaQuery.of(context).size.width,
                        isLoading: isLoading,
                        isDisabled: isLoading,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSelectedDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale("es", "ES"),
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2025),
    );

    if (picked != null) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }
}
