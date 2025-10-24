const functions = require("firebase-functions");
const admin = require("firebase-admin");
const vision = require("@google-cloud/vision");

admin.initializeApp();
const db = admin.firestore();
const client = new vision.ImageAnnotatorClient();

exports.analizarFactura = functions.storage.object().onFinalize(async (object) => {
  const filePath = object.name;
  const fileUrl = `gs://${object.bucket}/${filePath}`;
  console.log("📄 Analizando:", fileUrl);

  try {
    // === OCR ===
    const [result] = await client.textDetection(fileUrl);
    const detections = result.textAnnotations;
    const fullText = detections?.[0]?.description || "";
    const texto = fullText.toLowerCase();

    console.log("🧠 Texto detectado:", texto.slice(0, 200), "...");

    // === CATEGORIZADOR INTELIGENTE ===
    const categorias = {
      Educación: ["universidad", "autónoma", "matrícula", "colegio", "curso"],
      Restaurantes: ["burger", "mcdonald", "rey", "comida", "restaurante", "pizzería", "kfc"],
      Compras: ["éxito", "d1", "carulla", "super", "mercado", "alkosto", "jumbo", "tienda"],
      Transporte: ["uber", "taxi", "bus", "gasolina", "peaje", "metro"],
      Servicios: ["tigo", "claro", "internet", "energía", "agua", "movistar", "emcali"],
      Entretenimiento: ["cine", "netflix", "spotify", "parque", "teatro"],
      Salud: ["farmacia", "clínica", "eps", "medicina", "laboratorio"],
      Hogar: ["homecenter", "muebles", "ferretería", "decoración"],
    };

    let categoriaDetectada = "General";
    for (const [categoria, palabras] of Object.entries(categorias)) {
      if (palabras.some((p) => texto.includes(p))) {
        categoriaDetectada = categoria;
        break;
      }
    }

    // === MONTO ===
    const matchMonto = fullText.match(/(\d+[.,]\d{2})/);
    const monto = matchMonto ? parseFloat(matchMonto[0].replace(",", ".")) : 0;

    // === PROVEEDOR ===
    const proveedor = fullText.split("\n")[0].substring(0, 40);

    // === GUARDAR EN FIRESTORE ===
    await db.collection("facturas_pendientes").add({
      titulo: proveedor,
      categoria: categoriaDetectada,
      monto,
      metodo: "Detectado automáticamente",
      fecha: admin.firestore.FieldValue.serverTimestamp(),
      textoOCR: fullText,
      filePath,
    });

    console.log(`✅ Guardado: ${proveedor} → ${categoriaDetectada} ($${monto})`);
    return null;
  } catch (error) {
    console.error("❌ Error al analizar factura:", error);
    return null;
  }
});
