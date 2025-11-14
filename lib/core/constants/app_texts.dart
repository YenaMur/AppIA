class AppTexts {
  // Login
  static const String loginButton = 'Iniciar sesión';
  static const String registerButton = 'Crear una cuenta';

  // Login - Pantalla principal
  static const String welcomeBack = 'Bienvenid@ de nuevo';
  static const String loginSubtitle = 'Inicia sesión con tu cuenta registrada';

  // Campos
  static const String email = 'Correo';
  static const String phone = 'Celular';
  static const String password = 'Contraseña';
  static const String forgotPassword = '¿Olvidaste la contraseña?';
  static const String hintPassword =
      'Mínimo 8 caracteres, incluye mayúsculas y números.';
  static const String hintEmail = 'ejemplo@ejemplos.com';
  static const String hintPhone = '123 456 7891';
  static const String termsText =
      'Al crear una cuenta, aceptas nuestros Términos y Condiciones y nuestro Aviso de Privacidad.';
  static const String alreadyHaveAccount = '¿Ya tienes una cuenta?';

  //validation messages
  static const String errorNameRequired =
      'Por favor ingresa tu nombre completo.';
  static const String errorEmailInvalid = 'Ingresa un correo válido.';
  static const String errorPasswordShort =
      'La contraseña debe tener al menos 8 caracteres.';
  static const String errorPasswordMatch = 'Las contraseñas no coinciden.';
  static const String loginSuccess = 'Inicio de sesión exitoso.';

  // Verificación de cuenta
  static const String verifyTitle = 'Verifica tu cuenta';
  static const String verifySubtitle =
      'Ingresa el código que enviamos a tu correo';
  static const String verifyButton = 'Verificar';
  static const String verifyResend = 'Reenviar el código en';
  static const String verifyCodeExpired = '¿No recibiste el código?';
  static const String verifyResendNow = 'Reenviar ahora';

  // Cuenta verificada
  static const String verifiedTitle = 'Tu cuenta está lista';
  static const String verifiedSubtitle =
      'Tu cuenta ha sido verificada con éxito,\nahora disfruta de las funciones de ContaIA!';
  static const String verifiedButton = 'Comenzar';

  // Botones
  static const String loginAccess = 'Accede a tu cuenta';
  static const String loginWithGoogle = 'Acceder con Google';
  static const String loginWithApple = 'Acceder con Apple';
  static const String noAccount = '¿No tienes cuenta aún?';
  static const String registerNow = 'Regístrate';
  static const String continueWith = 'o continúa con';

  // Campos específicos (número)
  static const String enterPhone = 'Ingresa tu número';
  static const String countryPrefix = '+57';

  // Home
  static const String greeting = 'Buenos días';
  static const String balanceTitle = 'Tu saldo';
  static const String thisWeek = 'Esta semana';
  // Resumen
  static const String incomes = 'Ingresos';
  static const String expenses = 'Gastos';
  // Gastos recientes
  static const String recentExpenses = 'Tus últimos gastos';
  static const String seeMore = 'Ver más';
  static const String paid = 'Pagado';
  // Bottom navigation
  static const String navHome = 'Principal';
  static const String navHistory = 'Historial';

  // Grafico
  static const String chartTitle = 'Gastos por categoría';
  static const String chartAxisX = 'Categorías';
  static const String chartAxisY = 'Monto';
  static const String chartEmpty = 'No hay datos para mostrar';

  // Escáner de facturas
  static const String scanTitle = 'Escanea tu factura';
  static const String scanSubtitle =
      'Escanea tu factura y deja que ContaIA clasifique la información por ti.';
  static const String scanButton = 'Tomar foto';

  // Cámara
  static const String cameraTitle = 'Centra tu factura';
  static const String cameraSubtitle =
      'Asegúrate que se vea la fecha y el valor de la factura en la imagen.';

  // Resultado de escaneo
  static const String scanSuccessTitle = 'Escaneo exitoso';
  static const String scanSuccessHeading = 'Factura escaneada';
  static const String scanSuccessSubtitle =
      'La información fue capturada con éxito.';
  static const String scanSuccessButton = 'Continuar';

  // Confirmación de factura
  static const String confirmTitle = 'Confirmación';
  static const String confirmSubtitle = 'Total de la factura (USD)';
  static const String confirmButton = 'Añadir a mis finanzas';
  static const String confirmButton2 = 'Confirmar';

  static const String labelFacturaID = 'Factura ID';
  static const String labelProveedor = 'Proveedor';
  static const String labelCategoria = 'Categoría';
  static const String labelMetodoPago = 'Método de pago';
  static const String labelFecha = 'Fecha';
  static const String labelTotal = 'Total';

  // Historial financiero
  static const String historyTitle = 'Historial Financiero';
  static const String historySummaryTitle = 'Resumen del Mes';
  static const String historyViewAll = 'Ver Todo';
  static const String historyIncome = 'Ingresos';
  static const String historyExpenses = 'Gastos';
  static const String historyBalance = 'Balance';
  static const String historyAll = 'Todo';
  static const String historyRecentInvoices = 'Facturas Recientes';
  static const String historyThisMonth = 'Este mes';
}
