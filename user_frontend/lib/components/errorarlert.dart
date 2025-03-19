import 'package:flutter/material.dart';

class ErrorSnackBar extends SnackBar {
  ErrorSnackBar({Key? key, required String content})
      : super(
          key: key,
          content: Text(content),
          duration: const Duration(milliseconds: 2500),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
}
