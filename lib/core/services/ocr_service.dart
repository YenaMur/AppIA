import 'dart:io';
import 'dart:ui';
import 'dart:math';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRService {
  final TextRecognizer _textRecognizer = TextRecognizer();

  Future<Map<String, dynamic>> procesarImagen(
    File imageFile, {
    bool debug = false,
  }) async {
    final log = StringBuffer();
    void d(String s) {
      if (debug) log.writeln(s);
      print(s);
    }

    try {
      final inputImage = InputImage.fromFile(imageFile);
      final RecognizedText visionText = await _textRecognizer.processImage(
        inputImage,
      );

      // 1️⃣ Obtener texto plano y ocr_text reconstruido
      final ocrText = _reconstruirOCRTexto(visionText);
      final raw = visionText.text;
      final lines = raw
          .split('\n')
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty)
          .toList();
      final normalized = _normalize(raw);

      d("🧾 Texto detectado:\n${lines.map((e) => '- $e').join('\n')}");

      // 2️⃣ Extraer datos principales
      final proveedor = _extraerProveedor(lines, normalized, d);
      final monto = _extraerMontoPorPosicion(visionText, d);
      final fecha = _extraerFecha(normalized, d);
      final metodo = _extraerMetodo(normalized);
      final tipo = _inferirTipo(normalized);
      final categoria = _inferirCategoria(proveedor, normalized);

      return {
        "texto": raw,
        "ocr_text": ocrText, // <-- igual que los OCR profesionales
        "proveedor": proveedor,
        "monto": monto,
        "fecha": fecha,
        "metodo": metodo,
        "tipo": tipo,
        "categoria": categoria,
        "moneda": "COP",
        if (debug) "debugLog": log.toString(),
      };
    } catch (e) {
      print("❌ Error OCR: $e");
      return {"error": e.toString()};
    }
  }

  // ---------- NORMALIZAR ----------
  String _normalize(String s) => s
      .replaceAll(RegExp(r'[,.]'), '.')
      .replaceAll(RegExp(r'\s+'), ' ')
      .toLowerCase()
      .trim();

  // ---------- RECONSTRUIR OCR_TEXT ----------
  String _reconstruirOCRTexto(RecognizedText text) {
    // Agrupamos por bloques y líneas con coordenadas aproximadas
    final buffer = StringBuffer();
    for (final block in text.blocks) {
      for (final line in block.lines) {
        final words = line.elements;
        final lineStr = words.map((e) => e.text).join(' ');
        buffer.writeln(lineStr);
      }
    }
    return buffer.toString().trim();
  }

  // ---------- DETECCIÓN ESPACIAL DE MONTO ----------
  double _extraerMontoPorPosicion(
    RecognizedText visionText,
    void Function(String) d,
  ) {
    d("💰 Analizando posiciones espaciales de 'TOTAL' (v6.0)…");

    final montoRegExp = RegExp(
      r'(?:COP|CO|COL|\$)?\s*\d{1,3}(?:[.,]\d{3})*(?:[.,]\d{0,2})?',
      caseSensitive: false,
    );

    double? parseMonto(String text) {
      var clean = text.replaceAll(RegExp(r'[^0-9,\.]'), '');
      if (clean.contains('.') && clean.contains(',')) {
        clean = clean.replaceAll('.', '').replaceAll(',', '.');
      } else if (clean.split('.').length > 2) {
        clean = clean.replaceAll('.', '');
      }
      clean = clean.replaceAll(',', '.');
      final val = double.tryParse(clean);
      if (val == null || val < 100 || val > 10000000) return null;
      return val;
    }

    List<TextElement> elementos = [];
    for (final b in visionText.blocks) {
      for (final l in b.lines) {
        elementos.addAll(l.elements);
      }
    }

    final totales = elementos.where((e) {
      final t = e.text.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
      return t == 'total' ||
          t == 'valortotal' ||
          t == 'totalapagar' ||
          t == 'totalfactura';
    }).toList();

    if (totales.isEmpty) {
      d("⚠️ No se encontró la palabra 'TOTAL' → usando fallback");
      return _fallbackMonto(visionText, d);
    }

    final candidatos = <double>[];

    for (final total in totales) {
      final rectTotal = total.boundingBox;
      if (rectTotal == null) continue;

      for (final e in elementos) {
        if (e == total || e.boundingBox == null) continue;
        final rect = e.boundingBox!;
        final dist = _distancia(rectTotal, rect);

        // Posiciones válidas: derecha, justo arriba o justo abajo
        final esDerecha =
            rect.left > rectTotal.right &&
            (rect.top - rectTotal.top).abs() < rectTotal.height * 1.5;
        final esAbajo =
            rect.top > rectTotal.bottom &&
            (rect.left - rectTotal.left).abs() < rectTotal.width * 2;
        final esArriba =
            rect.bottom < rectTotal.top &&
            (rect.left - rectTotal.left).abs() < rectTotal.width * 2;

        if ((esDerecha || esAbajo || esArriba) && dist < 200) {
          final txt = e.text;
          final m = montoRegExp.firstMatch(txt);
          if (m != null) {
            final val = parseMonto(m.group(0)!);
            if (val != null) {
              d(
                "✅ Monto espacialmente vinculado a TOTAL → $val (${esDerecha
                    ? "derecha"
                    : esAbajo
                    ? "abajo"
                    : "arriba"})",
              );
              candidatos.add(val);
            }
          }
        }
      }
    }

    if (candidatos.isNotEmpty) {
      final elegido = candidatos.reduce((a, b) => a > b ? a : b);
      d("💰 Total elegido por proximidad → $elegido");
      return elegido;
    }

    return _fallbackMonto(visionText, d);
  }

  double _fallbackMonto(RecognizedText text, void Function(String) d) {
    final montoRegExp = RegExp(
      r'(?:COP|CO|COL|\$)?\s*\d{1,3}(?:[.,]\d{3})*(?:[.,]\d{0,2})?',
      caseSensitive: false,
    );
    double? parseMonto(String s) {
      final clean = s.replaceAll(RegExp(r'[^\d.]'), '');
      final v = double.tryParse(clean);
      if (v == null || v < 500 || v > 10000000) return null;
      return v;
    }

    final todos = <double>[];
    for (final b in text.blocks) {
      for (final l in b.lines) {
        for (final m in montoRegExp.allMatches(l.text)) {
          final v = parseMonto(m.group(0) ?? '');
          if (v != null) todos.add(v);
        }
      }
    }

    if (todos.isNotEmpty) {
      final elegido = todos.reduce((a, b) => a > b ? a : b);
      d("⚙️ Fallback (mayor monto global) → $elegido");
      return elegido;
    }

    d("⚠️ No se encontró total → 0.00");
    return 0.0;
  }

  double _distancia(Rect a, Rect b) {
    final dx = max(0, max(a.left - b.right, b.left - a.right));
    final dy = max(0, max(a.top - b.bottom, b.top - a.bottom));
    return sqrt(dx * dx + dy * dy);
  }

  // ---------- PROVEEDOR ----------
  String _extraerProveedor(
    List<String> lines,
    String normalized,
    void Function(String) d,
  ) {
    final tiendas = [
      'cruz verde',
      'contaia',
      'drogueria la rebaja',
      'geo parking',
      'universidad autonoma de occidente',
      'caribe supermercados',
      'dollarcity',
      'jeronimo martins',
      'exito',
      'carulla',
      'jumbo',
      'olimpica',
      'd1',
      'ara',
      'makro',
      'metro',
      'homecenter',
      'falabella',
      'alkosto',
      'decathlon',
      'farmatodo',
      'texaco',
      'primax',
      'terpel',
      'biomax',
      'koaj',
      'zara',
      'nike',
      'adidas',
      'puma',
    ];

    tiendas.sort((a, b) => b.length.compareTo(a.length));
    for (final t in tiendas) {
      if (normalized.contains(t)) {
        d("🏷️ Proveedor → $t");
        return _tituloCase(t);
      }
    }

    for (final l in lines.take(6)) {
      if (l.length < 40 && !RegExp(r'\d').hasMatch(l)) {
        d("🏷️ Proveedor (fallback) → $l");
        return _tituloCase(l);
      }
    }
    return "Desconocido";
  }

  // ---------- FECHA ----------
  DateTime _extraerFecha(String normalized, void Function(String) d) {
    final exp = RegExp(
      r'(\d{4}[-/. ]\d{1,2}[-/. ]\d{1,2})|(\d{1,2}[-/. ]\d{1,2}[-/. ]\d{4})|(\d{1,2}[-/. ]\d{1,2}[-/. ]\d{2})',
    );
    final match = exp.firstMatch(normalized);
    if (match != null) {
      final dateStr = match.group(0)!.replaceAll(' ', '').replaceAll('.', '-');
      try {
        final parts = dateStr.split('-');
        if (parts[0].length == 4) {
          return DateTime.parse(dateStr.replaceAll('/', '-'));
        } else {
          final dd = int.tryParse(parts[0]) ?? 1;
          final mm = int.tryParse(parts[1]) ?? 1;
          var yyyy = int.tryParse(parts[2]) ?? DateTime.now().year;
          if (parts[2].length == 2) yyyy += 2000;
          return DateTime(yyyy, mm, dd);
        }
      } catch (_) {}
    }
    d("📅 Sin fecha clara → DateTime.now()");
    return DateTime.now();
  }

  // ---------- MÉTODO ----------
  String _extraerMetodo(String normalized) {
    if (normalized.contains('efectivo')) return 'Efectivo';
    if (normalized.contains('tarjeta') ||
        normalized.contains('debito') ||
        normalized.contains('credito'))
      return 'Tarjeta';
    if (normalized.contains('transferencia') ||
        normalized.contains('pago movil'))
      return 'Transferencia';
    if (normalized.contains('nequi') || normalized.contains('daviplata'))
      return 'Billetera digital';
    return 'Desconocido';
  }

  // ---------- TIPO ----------
  String _inferirTipo(String normalized) {
    if (normalized.contains('abono') || normalized.contains('consignacion')) {
      return 'ingreso';
    }
    return 'egreso';
  }

  // ---------- CATEGORÍA ----------
  String _inferirCategoria(String proveedor, String normalized) {
    final lower = proveedor.toLowerCase();
    if (lower.contains('exito') ||
        lower.contains('carulla') ||
        lower.contains('jumbo') ||
        lower.contains('olimpica') ||
        lower.contains('d1') ||
        lower.contains('ara') ||
        lower.contains('dollarcity') ||
        lower.contains('caribe supermercados')) {
      return 'Supermercado';
    }
    if (lower.contains('texaco') ||
        lower.contains('primax') ||
        lower.contains('terpel') ||
        lower.contains('biomax'))
      return 'Combustible';
    if (lower.contains('koaj') ||
        lower.contains('zara') ||
        lower.contains('nike') ||
        lower.contains('adidas') ||
        lower.contains('puma'))
      return 'Ropa';

    // 💊 Salud y farmacia
    if (lower.contains('cruz verde') ||
        lower.contains('farmatodo') ||
        lower.contains('drogueria la rebaja') ||
        lower.contains('la rebaja') ||
        lower.contains('drogueria') ||
        normalized.contains('farmacia'))
      return 'Salud';

    // 💼 Salario o ingresos
    if (lower.contains('contaia') ||
        normalized.contains('salario') ||
        normalized.contains('pago') ||
        normalized.contains('recibo de abono')) {
      return 'Salario / Ingreso laboral';
    }

    // 🅿️ UAO / Transporte
    if (lower.contains('geo parking') ||
        normalized.contains('universidad autónoma de occidente') ||
        normalized.contains('uao') ||
        normalized.contains('parqueadero')) {
      return 'Transporte / UAO';
    }
    return 'General';
  }

  String _tituloCase(String s) => s
      .split(' ')
      .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
      .join(' ');

  void dispose() => _textRecognizer.close();
}
