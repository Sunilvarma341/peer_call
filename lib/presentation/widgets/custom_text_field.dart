import 'package:flutter/material.dart';

class CustomeTextFormField extends StatefulWidget {
  CustomeTextFormField({
    super.key,
    required this.validator,
    required this.controller,
    this.obscureText = false,
    this.hintText,
    this.labelText,
  });
  final String? Function(String?)? validator;
  final TextEditingController controller;
  bool obscureText;
  final String? hintText;
  final String? labelText;

  @override
  State<CustomeTextFormField> createState() => _CustomeTextFormFieldState();
}

class _CustomeTextFormFieldState extends State<CustomeTextFormField> {
  bool obscureText = false;

  @override
  void initState() {
    obscureText = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Enter text',
        focusColor: Colors.blue,
        hintText: widget.hintText,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: const Icon(Icons.visibility),
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                  print(obscureText);
                },
              )
            : null,
      ),
      validator: widget.validator,
    );
  }
}
