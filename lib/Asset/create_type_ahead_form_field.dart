import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../const.dart';

class CreateTypeAheadFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final FutureOr<Iterable<dynamic>> Function(String) suggestionsCallback;
  final Widget Function(BuildContext, dynamic) itemBuilder;
  final void Function(dynamic) onSuggestionSelected;
  final String? Function(dynamic) validator;
  final bool? enabled;
  const CreateTypeAheadFormField({
    super.key,
    this.controller,
    required this.hintText,
    required this.suggestionsCallback,
    required this.itemBuilder,
    required this.onSuggestionSelected,
    required this.validator,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          filled: enabled == false ? true : false,
          fillColor: enabled == false ? disabledColor : null,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: accentColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: accentColor),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: errorTextColor),
          ),
        ),
        enabled: enabled ?? true,
      ),
      suggestionsCallback: suggestionsCallback,
      itemBuilder: itemBuilder,
      onSuggestionSelected: onSuggestionSelected,
      noItemsFoundBuilder: (context) => const SizedBox.shrink(),
      autovalidateMode: AutovalidateMode.always,
      validator: validator,
    );
  }
}
