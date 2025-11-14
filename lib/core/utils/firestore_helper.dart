import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'snackbar_helper.dart';

class FirestoreHelper {
  static Future<void> eliminarFactura(
    BuildContext context,
    String id,
    String titulo,
  ) async {
    try {
      // Diálogo de confirmación
      final confirmar = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Eliminar factura'),
          content: Text('¿Estás seguro de que deseas eliminar "$titulo"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        ),
      );

      if (confirmar == true) {
        await FirebaseFirestore.instance
            .collection('facturas')
            .doc(id)
            .delete();

        if (context.mounted) {
          SnackbarHelper.showSuccess(
            context,
            'Factura eliminada correctamente',
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarHelper.showError(context, 'Error al eliminar: $e');
      }
    }
  }
}
