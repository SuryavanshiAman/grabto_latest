import 'package:grabto/theme/theme.dart';
import 'package:flutter/material.dart';

// void showErrorMessage(BuildContext context, {required String message}) {
//   final snackBar = SnackBar(
//     content: Text(
//       message,
//       style: TextStyle(color: Colors.white),
//     ),
//     backgroundColor: Colors.red,
//   );
//   ScaffoldMessenger.of(context).showSnackBar(snackBar);
// }
void showErrorMessage(BuildContext context, {required String message}) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.red.shade600,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    content: Row(
      children: [
        Icon(Icons.error_outline, color: Colors.white),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
    duration: const Duration(seconds: 4),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
void showSuccessMessage(BuildContext context, {required String message}) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.green.shade600,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    content: Row(
      children: [
        Icon(Icons.check_circle, color: Colors.white),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
    duration: const Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

// void showSuccessMessage(BuildContext context, {required String message}) {
//   final snackBar = SnackBar(
//
//     content: Text(
//       message,
//       style: TextStyle(color: Colors.white),
//     ),
//     backgroundColor: Colors.green,
//   );
//   ScaffoldMessenger.of(context).showSnackBar(snackBar);
// }

void showSnackBarWithAction(BuildContext context, String msg, String actionName,
    VoidCallback onPressed) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text('' + msg),
      action: SnackBarAction(
        label: actionName,
        onPressed: onPressed, // Custom onPressed function
      ),
    ),
  );
}

void showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      "" + msg,
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
    ),
    elevation: 5,
    backgroundColor: MyColors.blackBG,
    action: SnackBarAction(
      label: "UNDO",
      textColor: MyColors.primaryColor,
      onPressed: () {}, // Custom onPressed function
    ),
  ));
}
