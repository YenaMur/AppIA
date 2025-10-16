import 'package:flutter/material.dart';

class NavHelper {
  // Abre una nueva pantalla sin cerrar la pantalla actual
  static void navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  // Reemplaza la pantalla actual por otra (usado para Splash -> Login)
  static void navigateAndReplace(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // Cierra la pantalla actual y vuelve a la anterior
  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
