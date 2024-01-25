import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:logger/logger.dart';

class VerifiableTextField extends StatefulWidget {
  final TextEditingController controller;
  final StringValidationCallback? validator;
  final bool canBeHidden;
  final String labelText;
  final String? helperText;
  final ValueChanged<String>? onChanged;

  const VerifiableTextField(
      {super.key,
      required this.controller,
      this.validator,
      this.helperText,
      required this.labelText,
      required this.onChanged,
      this.canBeHidden = false});

  @override
  State<VerifiableTextField> createState() =>
      _VerifiableTextFieldState(field: this);
}

class _VerifiableTextFieldState extends State<VerifiableTextField> {
  final Logger logger = Logger();
  final VerifiableTextField field;
  bool _hasBeenFocused = false;
  bool _isTappedOutside = false;

  late bool _isObscured = field.canBeHidden;

  _VerifiableTextFieldState({required this.field});

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (value) {
        _hasBeenFocused = value || _hasBeenFocused;
      },
      child: TextField(
        obscureText: _isObscured,
        onChanged: (input) {
          setState(() {
            field.controller.text = input;
          });

          if (field.onChanged != null) {
            field.onChanged!(input);
          }
        },
        onTapOutside: (_) {
          setState(() {
            _isTappedOutside = true;
          });
          logger.d('${field.labelText}/tappedOutside is $_isTappedOutside}');
        },
        controller: field.controller,
        decoration: InputDecoration(
          helperText: field.helperText,
          border: const OutlineInputBorder(),
          labelText: field.labelText,
          errorText:
              _hasBeenFocused && field.validator != null
                  ? field.validator!(field.controller.value.text)
                  : null,
          suffixIcon: field.canBeHidden
              ? IconButton(
                  icon: _isObscured
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  })
              : null,
        ),
      ),
    );
  }
}
