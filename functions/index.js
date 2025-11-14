const functions = require("firebase-functions");
const vision = require("@google-cloud/vision");
const admin = require("firebase-admin");
admin.initializeApp();

// Cliente de Google Vision
const client = new vision.ImageAnnotatorClient();

/**
 * Function: ocrFactura
 * Analiza una imagen en Storage y devuelve el texto detectado
 */
exports.ocrFactura = functions.https.onCall(async (data, context) => {
  const { imageUrl } = data;
  if (!imageUrl) {
    throw new functions.https.HttpsError("invalid-argument", "imageUrl is required");
  }

  try {
    // Detectar texto con Vision API
    const [result] = await client.textDetection(imageUrl);
    const detections = result.textAnnotations;

    if (!detections || detections.length === 0) {
      return { text: "", message: "No se detectó texto en la imagen." };
    }

    // Texto completo
    const fullText = detections[0].description;

    // Intentar capturar monto con regex
    const montoMatch = fullText.match(/(\$?\s?\d+([.,]\d{2})?)/);
    const monto = montoMatch ? montoMatch[0].replace(/\s/g, "") : null;

    // Intentar capturar fecha con regex
    const fechaMatch = fullText.match(/(\d{1,2}[\/.-]\d{1,2}[\/.-]\d{2,4})/);
    const fecha = fechaMatch ? fechaMatch[0] : null;

    // Intentar detectar proveedor (primeras líneas de texto)
    const lineas = fullText.split("\n");
    const proveedor = lineas[0] || "Proveedor desconocido";

    return {
      text: fullText,
      proveedor,
      monto,
      fecha,
      message: "Texto analizado correctamente ✅",
    };
  } catch (error) {
    console.error("Error en OCR:", error);
    throw new functions.https.HttpsError("internal", error.message);
  }
});
