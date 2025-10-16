/// Pequeña utilidad para crear pausas o animaciones controladas.
/// Ejemplo: await delay(2000); // espera 2 segundos
Future<void> delay(int milliseconds) async {
  await Future.delayed(Duration(milliseconds: milliseconds));
}
