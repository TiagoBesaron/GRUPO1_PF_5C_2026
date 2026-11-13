// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Activelo';

  @override
  String get paginaNoEncontrada => 'الصفحة غير موجودة';

  @override
  String get paginaNoExiste => 'الشاشة المطلوبة غير موجودة.';

  @override
  String get volverAlInicio => 'العودة إلى الصفحة الرئيسية';

  @override
  String get navInicio => 'الرئيسية';

  @override
  String get navHistorial => 'السجل';

  @override
  String get navAjustes => 'الإعدادات';

  @override
  String get iniciarSesion => 'تسجيل الدخول';

  @override
  String get crearCuenta => 'إنشاء حساب';

  @override
  String get registrate => 'إنشاء حساب جديد';

  @override
  String get nombreCompleto => 'الاسم الكامل';

  @override
  String get fechaNacimiento => 'تاريخ الميلاد';

  @override
  String get correoElectronico => 'البريد الإلكتروني';

  @override
  String get contrasena => 'كلمة المرور';

  @override
  String get confirmarContrasena => 'تأكيد كلمة المرور';

  @override
  String get seleccionarFecha => 'حدد التاريخ';

  @override
  String get seleccionaTuFechaNacimiento => 'حدد تاريخ ميلادك';

  @override
  String get errorFechaNacimiento => 'يرجى تحديد تاريخ ميلادك.';

  @override
  String get errorNombreVacio => 'أدخل اسمك الكامل';

  @override
  String get errorCorreoVacio => 'أدخل بريدك الإلكتروني';

  @override
  String get errorCorreoInvalido => 'أدخل بريداً إلكترونياً صالحاً';

  @override
  String get errorContrasenaVacia => 'أدخل كلمة المرور';

  @override
  String get errorContrasenaCorta =>
      'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get errorContrasenasNoCoinciden => 'كلمات المرور غير متطابقة';

  @override
  String get subtituloLogin => 'سجل الدخول لبدء تمرينك';

  @override
  String get subtituloRegistro => 'أنشئ حسابك لحفظ تمارينك';

  @override
  String get yaTenesCuenta => 'هل لديك حساب بالفعل؟';

  @override
  String get noTenesCuenta => 'ليس لديك حساب؟';

  @override
  String get alRegistrarteAceptas => 'بالتسجيل، فإنك توافق على ';

  @override
  String get alIngresarAceptas => 'بالدخول، فإنك توافق على ';

  @override
  String get terminosYPrivacidad => 'الشروط والخصوصية';

  @override
  String get volverAlInicioSesion => 'العودة إلى تسجيل الدخول';

  @override
  String get entrenar => 'بدء التمرين';

  @override
  String holaEntrenador(Object nombre) {
    return 'مرحباً، $nombre! 👋';
  }

  @override
  String get entrenador => 'المدرب';

  @override
  String get usuarioActivo => 'المستخدم النشط:';

  @override
  String get perfilPrincipal => 'الملف الشخصي الرئيسي';

  @override
  String get cambiar => 'تغيير';

  @override
  String get estadoDispositivo => 'حالة الجهاز';

  @override
  String esp32Conectado(Object dispositivo) {
    return 'ESP32 متصل ($dispositivo)';
  }

  @override
  String get esp32Desconectado => 'ESP32 غير متصل';

  @override
  String get podBle => 'جهاز Pod BLE';

  @override
  String get mejor => 'الأفضل';

  @override
  String get ultimoPromedio => 'آخر متوسط';

  @override
  String get promedioGeneral => 'المتوسط العام';

  @override
  String ultimaSesionDe(Object nombre) {
    return 'آخر جلسة لـ $nombre';
  }

  @override
  String get ultimaSesion => 'آخر جلسة';

  @override
  String get toquesEnEstaSesion => 'اللمسات في هذه الجلسة';

  @override
  String get mejorToqueDeLaSesion => 'أفضل لمسة في الجلسة';

  @override
  String get accesosRapidos => 'وصول سريع';

  @override
  String get gestionarUsuarios => 'إدارة المستخدمين';

  @override
  String get vincularPodBle => 'ربط Pod BLE';

  @override
  String get verHistorialTiempos => 'عرض سجل الأوقات';

  @override
  String get configurarEntrenamiento => 'إعداد التمرين';

  @override
  String get cantidadPodsActivos => 'عدد الأجهزة النشطة';

  @override
  String get podsAUtilizar => 'الأجهزة المستخدمة:';

  @override
  String get seleccionaElModo => 'اختر الوضع';

  @override
  String get porRondas => 'حسب الجولات';

  @override
  String get completaNumeroFijo => 'إكمال عدد محدد من اللمسات';

  @override
  String get porTiempo => 'حسب الوقت';

  @override
  String get tocaMayorCantidad => 'اللمس لأكبر عدد ممكن قبل انتهاء الوقت';

  @override
  String get modoBicolor => 'وضع اللونين';

  @override
  String get desactivaColor1 => 'تفعيل اللون 1 وتجاهل اللون 2';

  @override
  String get modoManual => 'الوضع اليدوي';

  @override
  String get controlaLuzDirectamente => 'التحكم بالإضاءة مباشرة من التطبيق';

  @override
  String get parametrosRondas => 'إعدادات الجولات';

  @override
  String get parametrosTiempo => 'إعدادات الوقت';

  @override
  String get cantidadRondas => 'عدد الجولات:';

  @override
  String get tiempoLimite => 'الوقت المحدد:';

  @override
  String get mensajeModoManual =>
      'في الوضع اليدوي، يمكنك تشغيل وإيقاف الجهاز في أي وقت بالضغط على مربعه.';

  @override
  String get tiempoLimiteColor2 => 'الوقت المحدد للون 2 (المشتت)';

  @override
  String get tiempoParaIgnorar => 'وقت التجاهل:';

  @override
  String get intervaloEntrePods => 'الفاصل الزمني بين الأجهزة';

  @override
  String get pausaEntreToques => 'الاستراحة بين اللمسات:';

  @override
  String get coloresBicolor => 'ألوان وضع اللونين';

  @override
  String get colorLeds => 'لون الإضاءة';

  @override
  String get color1ATocar => 'اللون 1 (للمس)';

  @override
  String get color2NoTocar => 'اللون 2 (لا تلمس / تجاهل)';

  @override
  String get seleccionarColorBase => 'اختر اللون الأساسي';

  @override
  String get ajusteColorRgb => 'تعديل لون RGB:';

  @override
  String get vistaPrevia => 'معاينة:';

  @override
  String get intensidadLeds => 'شدة الإضاءة';

  @override
  String get brilloIntensidad => 'السطوع / الشدة:';

  @override
  String get iniciarRutina => 'بدء التمرين';

  @override
  String get errorBluetoothRequerido =>
      'يجب توصيل ESP32 عبر البلوتوث قبل بدء التمرين.';

  @override
  String get conectar => 'توصيل';

  @override
  String get errorBicolorColoresIguales =>
      'في وضع اللونين، يجب اختيار لونين مختلفين.';

  @override
  String get aparatoListo => 'الجهاز جاهز!';

  @override
  String get preparate => 'استعد!';

  @override
  String get atento => 'انتبه!';

  @override
  String tocaPodColor1(Object pod) {
    return 'المس الجهاز $pod! (اللون 1)';
  }

  @override
  String noTocarColor2(Object pod) {
    return 'لا تلمس! (اللون 2 في الجهاز $pod)';
  }

  @override
  String pasaManoPorPod(Object pod) {
    return 'مرر يدك فوق الجهاز $pod!';
  }

  @override
  String get excelenteColorIgnorado => 'ممتاز! تم تجاهل اللون 2.';

  @override
  String get tocaCuadradoEncender => 'اضغط على مربع لتشغيل جهازه';

  @override
  String get seleccionaPodEncender => 'اختر جهازاً لتشغيله';

  @override
  String get ledApagado => 'الإضاءة مطفأة.';

  @override
  String toqueEnPod(Object pod, Object tiempo) {
    return 'لمسة في الجهاز $pod! ($tiempo ثانية)';
  }

  @override
  String errorTocasteColor2(Object pod) {
    return 'خطأ! لمست اللون 2 في الجهاز $pod';
  }

  @override
  String get desconectado => 'غير متصل';

  @override
  String get errorDesconexionMensaje =>
      'تم انقطاع اتصال البلوتوث بالجهاز المركزي. تم إيقاف الجلسة.';

  @override
  String get entrenamientoFinalizado => 'اكتمل التمرين! 🏆';

  @override
  String usuario(Object nombre) {
    return 'المستخدم: $nombre';
  }

  @override
  String toquesValidos(Object cantidad) {
    return 'اللمسات الصحيحة: $cantidad';
  }

  @override
  String promedioSegundos(Object promedio) {
    return 'المتوسط: $promedio ثانية';
  }

  @override
  String erroresCometidos(Object errores) {
    return 'الأخطاء: $errores';
  }

  @override
  String get anotacionesSesionOpcional => 'ملاحظات الجلسة (اختياري)';

  @override
  String get hintAnotaciones => 'مثال: تطور جيد، إجهاد عضلي...';

  @override
  String get guardarYFinalizar => 'حفظ وإنهاء';

  @override
  String modoManualToques(Object cantidad) {
    return 'الوضع اليدوي (اللمسات: $cantidad)';
  }

  @override
  String tiempoRestanteToques(Object cantidad, Object tiempoRestante) {
    return 'الوقت: $tiempoRestanteث | اللمسات: $cantidad';
  }

  @override
  String bicolorRonda(Object rondaActual, Object rondasTotal) {
    return 'لونين | الجولة $rondaActual من $rondasTotal';
  }

  @override
  String rondaDe(Object rondaActual, Object rondasTotal) {
    return 'الجولة $rondaActual من $rondasTotal';
  }

  @override
  String tiempoRestante(Object tiempoRestante) {
    return 'الوقت المتبقي: $tiempoRestanteث';
  }

  @override
  String get ultimoTiempoValido => 'آخر وقت صحيح';

  @override
  String get finalizarSesion => 'إنهاء الجلسة';

  @override
  String get encendido => 'مضاء';

  @override
  String podLabel(Object num) {
    return 'جهاز $num';
  }

  @override
  String get conectarBluetooth => 'توصيل البلوتوث';

  @override
  String conectadoExitosamente(Object nombre) {
    return 'تم الاتصال بنجاح بـ $nombre!';
  }

  @override
  String errorAlConectar(Object error) {
    return 'خطأ في الاتصال: $error';
  }

  @override
  String get dispositivoDesconectado => 'تم فصل الجهاز';

  @override
  String get desconectar => 'فصل الاتصال';

  @override
  String get conectado => 'متصل';

  @override
  String get dispositivosDisponibles => 'الأجهزة المتاحة:';

  @override
  String get buscandoPods => 'جاري البحث عن أجهزة قريبة...';

  @override
  String get presionaBotonBuscar =>
      'اضغط على زر البحث أدناه للاقتران بالأجهزة.';

  @override
  String get cancelarBusqueda => 'إلغاء البحث';

  @override
  String get buscarDispositivos => 'البحث عن أجهزة';

  @override
  String get editarPerfil => 'تعديل الملف الشخصي';

  @override
  String get perfilActualizado => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get errorActualizarPerfil => 'خطأ في تحديث الملف الشخصي';

  @override
  String correoRestablecimientoEnviado(Object email) {
    return 'تم إرسال بريد إلكتروني إلى $email لإعادة تعيين كلمة المرور.';
  }

  @override
  String get errorCorreoRestablecimiento => 'خطأ في إرسال بريد إعادة التعيين.';

  @override
  String get subirFotoPerfil => 'تحميل صورة الشخصية';

  @override
  String get cambiarFotoPerfil => 'تغيير الصورة الشخصية';

  @override
  String get eliminarFoto => 'حذف الصورة';

  @override
  String get informacionPersonal => 'المعلومات الشخصية';

  @override
  String get correoNoModificable => 'لا يمكن تغيير البريد الإلكتروني مباشرة.';

  @override
  String get seguridad => 'الأمان';

  @override
  String get solicitarRestablecerContrasena =>
      'طلب رابط عبر البريد لتغيير كلمة المرور.';

  @override
  String get cambiarContrasena => 'تغيير كلمة المرور';

  @override
  String get guardarCambios => 'حفظ التغييرات';

  @override
  String get gestionDeUsuarios => 'إدارة المستخدمين';

  @override
  String get agregar => 'إضافة';

  @override
  String get eliminarUsuario => 'حذف المستخدم';

  @override
  String confirmarEliminarUsuario(Object nombre) {
    return 'هل أنت تأكد من رغبتك في حذف ملف \"$nombre\"؟';
  }

  @override
  String get cancelar => 'إلغاء';

  @override
  String get eliminar => 'حذف';

  @override
  String get nuevoUsuario => 'مستخدم جديد';

  @override
  String get editarUsuario => 'تعديل المستخدم';

  @override
  String get subirFoto => 'تحميل صورة';

  @override
  String get cambiarFoto => 'تغيير الصورة';

  @override
  String get notasObservaciones => 'ملاحظات';

  @override
  String get guardar => 'حفظ';

  @override
  String get mejorPromedio => 'أفضل متوسط';

  @override
  String get mejorTiempo => 'أفضل وقت';

  @override
  String get mejorUltimaSesion => 'الأفضل (آخر جلسة)';

  @override
  String get promedioUltimaSesion => 'المتوسط (آخر جلسة)';

  @override
  String get iniciaSesionParaGestionar => 'سجل الدخول لإدارة الملفات الشخصية.';

  @override
  String get perfilPrincipalPropietario => 'الملف الرئيسي (المالك)';

  @override
  String get sinNombre => 'بدون اسم';

  @override
  String get cuentaPrincipal => 'الحساب الرئيسي';

  @override
  String get instruccionGestionUsuarios =>
      'حدد المستخدم الذي سيتدرب في هذه الجلسة.';

  @override
  String get usuarioRegistrado => 'مستخدم مسجل';

  @override
  String get ajustes => 'الإعدادات والتكوين';

  @override
  String felizCumpleanos(Object nombre) {
    return 'عيد ميلاد سعيد، $nombre! 🎂';
  }

  @override
  String get mensajeCumpleanos =>
      'يتمنى لك فريق Activelo يوماً تدريبياً رائعاً!';

  @override
  String get perfilYModoDeUso => 'الملف الشخصي ووضع الاستخدام';

  @override
  String get modoProfesional => 'الوضع الاحترافي';

  @override
  String get modoProfesionalDesc =>
      'تفعيل إدارة مستخدمين متعددين وملاحظات الجلسات.';

  @override
  String get aparienciaTema => 'المظهر والسمة';

  @override
  String get modoOscuro => 'الوضع الداكن';

  @override
  String get cambiarTemaClaroOscuro => 'التبديل بين المظهر الفاتح والداكن';

  @override
  String get idioma => 'اللغة';

  @override
  String get sonidoRetroalimentacion => 'الصوت والتغذية الراجعة';

  @override
  String get efectosSonido => 'المؤثرات الصوتية';

  @override
  String get reproducirSonidosRutina => 'تشغيل أصوات عند بدء وانهاء التمرين';

  @override
  String get cuentaPerfil => 'الحساب والملف الشخصي';

  @override
  String get actualizaInformacionPersonal => 'تحديث معلوماتك الشخصية';

  @override
  String get dispositivosBluetooth => 'أجهزة البلوتوث';

  @override
  String get administrarConexiones => 'إدارة الاتصالات والبحث';

  @override
  String get informacion => 'المعلومات';

  @override
  String get versionApp => 'الإصدار 1.0.0';

  @override
  String get cerrarSesion => 'تسجيل الخروج';

  @override
  String get historialSesiones => 'سجل الجلسات';

  @override
  String get historialIniciaSesion => 'يجب تسجيل الدخول لعرض السجل.';

  @override
  String get sinSesionesRegistradas => 'لا توجد جلسات مسجلة بعد.';

  @override
  String get noHaySesionesUsuario => 'لا توجد جلسات لهذا المستخدم.';

  @override
  String get anotacionesDeLaSesion => 'ملاحظات الجلسة';

  @override
  String get observacionesDeLaSesion => 'ملاحظات الجلسة';

  @override
  String get todos => 'الكل';

  @override
  String toquesCount(Object count) {
    return '$count لمسات';
  }

  @override
  String get mejorToque => 'أفضل لمسة';

  @override
  String get promedio => 'المتوسط';

  @override
  String get errores => 'الأخطاء';

  @override
  String get sinAnotaciones => 'لا توجد ملاحظات مدخلة.';

  @override
  String get desglosePorToqueValido => 'تفاصيل اللمسات الصحيحة:';

  @override
  String get legalesYPrivacidad => 'الشروط القانونية والخصوصية';

  @override
  String get terminosDeUso => 'شروط الاستخدام';

  @override
  String get privacidad => 'الخصوصية';

  @override
  String get terminosYCondicionesDeUso => 'شروط وأحكام الاستخدام';

  @override
  String get ultimaActualizacion => 'آخر تحديث: 2026';

  @override
  String get tituloTerminos1 => '1. قبول الشروط';

  @override
  String get textoTerminos1 =>
      'بتنزيل تطبيق Activelo أو التسجيل فيه أو استخدامه، فإنك توافق على الالتزام بشروط وأحكام الخدمة هذه.';

  @override
  String get tituloTerminos2 => '2. وصف الخدمة';

  @override
  String get textoTerminos2 =>
      'Activelo هي منصة مصممة لإعداد وتتبع تمارين اللياقة والسرعة التفاعلية عبر أجهزة لاسلكية.';

  @override
  String get tituloTerminos3 => '3. حسابات المستخدمين';

  @override
  String get textoTerminos3 =>
      'للوصول إلى مزامنة السجل والإحصائيات، يجب تسجيل حساب ببريد إلكتروني صالح. أنت المسؤول الوحيد عن الحفاظ على سرية حسابك.';

  @override
  String get tituloTerminos4 => '4. المسؤولية والصحة البدنية';

  @override
  String get textoTerminos4 =>
      'يتطلب استخدام التطبيق القيام بنشاط بدني. التطبيق لا يقدم استشارات طبية. يُنصح بالإحماء المناسب والتوقف عند الشعور بأي ألم.';

  @override
  String get tituloTerminos5 => '5. استخدام الأجهزة والتفاعل اللاسلكي';

  @override
  String get textoTerminos5 =>
      'يتطلب التطبيق اتصالاً لاسلكياً للعمل مع أجهزة التدريب. المستخدم مسؤول عن تشغيل الأجهزة في بيئة آمنة.';

  @override
  String get tituloTerminos6 => '6. تعديلات المنصة';

  @override
  String get textoTerminos6 =>
      'نحتفظ بالحق في تعديل أو إيقاف خدماتنا وتحديث هذه الشروط في أي وقت.';

  @override
  String get politicaPrivacidad => 'سياسة الخصوصية';

  @override
  String get tituloPrivacidad1 => '1. المعلومات المجمعة';

  @override
  String get textoPrivacidad1 =>
      'نجمع فقط البيانات الأساسية لتقديم الخدمة:\n• بيانات الهوية: البريد الإلكتروني للتسجيل.\n• مقاييس التمرين: زمن الاستجابة، عدد اللمسات، الأوضاع المستخدمة وتواريخ الجلسات.';

  @override
  String get tituloPrivacidad2 => '2. الأذونات المطلوبة';

  @override
  String get textoPrivacidad2 =>
      'للاقتران بالأجهزة اللاسلكية ونقل التمارين، سيطلب التطبيق أذونات البلوتوث والموقع الجغرافي حسب متطلبات نظام التشغيل.';

  @override
  String get tituloPrivacidad3 => '3. استخدام المعلومات';

  @override
  String get textoPrivacidad3 =>
      'تُستخدم البيانات المخزنة حصرياً للسماح بالوصول إلى حسابك وحساب الإحصائيات وعرض تقدمك.';

  @override
  String get tituloPrivacidad4 => '4. حماية البيانات';

  @override
  String get textoPrivacidad4 =>
      'نطبق تدابير أمنية لحماية بياناتك المخزنة في السحابة. نحن لا نبيع ولا نشارك بياناتك الشخصية مع أطراف خارجية لأغراض تجارية.';

  @override
  String get tituloPrivacidad5 => '5. حذف البيانات';

  @override
  String get textoPrivacidad5 =>
      'يحق لك طلب حذف حسابك بشكل نهائي وإزالة جميع سجلات تمارينك في أي وقت.';

  @override
  String get errorCredencialesIncorrectas =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة';
}
