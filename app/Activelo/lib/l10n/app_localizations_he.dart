// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'Activelo';

  @override
  String get paginaNoEncontrada => 'הדף לא נמצא';

  @override
  String get paginaNoExiste => 'המסך המבוקש אינו קיים.';

  @override
  String get volverAlInicio => 'חזרה לדף הבית';

  @override
  String get navInicio => 'בית';

  @override
  String get navHistorial => 'היסטוריה';

  @override
  String get navAjustes => 'הגדרות';

  @override
  String get iniciarSesion => 'התחברות';

  @override
  String get crearCuenta => 'יצירת חשבון';

  @override
  String get registrate => 'הרשמה';

  @override
  String get nombreCompleto => 'שם מלא';

  @override
  String get fechaNacimiento => 'תאריך לידה';

  @override
  String get correoElectronico => 'דואר אלקטרוני';

  @override
  String get contrasena => 'סיסמה';

  @override
  String get confirmarContrasena => 'אימות סיסמה';

  @override
  String get seleccionarFecha => 'בחר תאריך';

  @override
  String get seleccionaTuFechaNacimiento => 'בחר את תאריך הלידה שלך';

  @override
  String get errorFechaNacimiento => 'אנא בחר את תאריך הלידה שלך.';

  @override
  String get errorNombreVacio => 'הזן את שמך המלא';

  @override
  String get errorCorreoVacio => 'הזן את כתובת הדואר האלקטרוני שלך';

  @override
  String get errorCorreoInvalido => 'הזן כתובת דוא\"ל תקינה';

  @override
  String get errorContrasenaVacia => 'הזן את הסיסמה שלך';

  @override
  String get errorContrasenaCorta => 'הסיסמה חייבת להכיל לפחות 6 תווים';

  @override
  String get errorContrasenasNoCoinciden => 'הסיסמאות אינן תואמות';

  @override
  String get subtituloLogin => 'התחבר כדי להתחיל את האימון שלך';

  @override
  String get subtituloRegistro => 'צור חשבון כדי לשמור את האימונים שלך';

  @override
  String get yaTenesCuenta => 'כבר יש לך חשבון?';

  @override
  String get noTenesCuenta => 'אין לך חשבון?';

  @override
  String get alRegistrarteAceptas => 'בהרשמתך, אתה מסכים ל';

  @override
  String get alIngresarAceptas => 'בהתחברותך, אתה מסכים ל';

  @override
  String get terminosYPrivacidad => 'תנאים ופרטיות';

  @override
  String get volverAlInicioSesion => 'חזרה לדף ההתחברות';

  @override
  String get entrenar => 'להתאמן';

  @override
  String holaEntrenador(Object nombre) {
    return 'שלום, $nombre! 👋';
  }

  @override
  String get entrenador => 'מאמן';

  @override
  String get usuarioActivo => 'משתמש פעיל:';

  @override
  String get perfilPrincipal => 'פרופיל ראשי';

  @override
  String get cambiar => 'שינוי';

  @override
  String get estadoDispositivo => 'סטטוס המכשיר';

  @override
  String esp32Conectado(Object dispositivo) {
    return 'ESP32 מחובר ($dispositivo)';
  }

  @override
  String get esp32Desconectado => 'ESP32 מנותק';

  @override
  String get podBle => 'פוד BLE';

  @override
  String get mejor => 'הכי טוב';

  @override
  String get ultimoPromedio => 'ממוצע אחרון';

  @override
  String get promedioGeneral => 'ממוצע כללי';

  @override
  String ultimaSesionDe(Object nombre) {
    return 'אימון אחרון של $nombre';
  }

  @override
  String get ultimaSesion => 'אימון אחרון';

  @override
  String get toquesEnEstaSesion => 'נגיעות באימון זה';

  @override
  String get mejorToqueDeLaSesion => 'הנגיעה הטובה ביותר באימון';

  @override
  String get accesosRapidos => 'גישה מהירה';

  @override
  String get gestionarUsuarios => 'ניהול משתמשים';

  @override
  String get vincularPodBle => 'חיבור פוד BLE';

  @override
  String get verHistorialTiempos => 'צפייה בהיסטוריית זמנים';

  @override
  String get configurarEntrenamiento => 'הגדרת אימון';

  @override
  String get cantidadPodsActivos => 'כמות פודים פעילים';

  @override
  String get podsAUtilizar => 'פודים לשימוש:';

  @override
  String get seleccionaElModo => 'בחר מצב';

  @override
  String get porRondas => 'לפי סבבים';

  @override
  String get completaNumeroFijo => 'השלם מספר נגיעות קבוע';

  @override
  String get porTiempo => 'לפי זמן';

  @override
  String get tocaMayorCantidad => 'גע בכמה שיותר לפני שהזמן נגמר';

  @override
  String get modoBicolor => 'מצב דו-צבעי';

  @override
  String get desactivaColor1 => 'מכבה צבע 1 ומתעלם מצבע 2';

  @override
  String get modoManual => 'מצב ידני';

  @override
  String get controlaLuzDirectamente => 'שלוט בתאורה ישירות מהאפליקציה';

  @override
  String get parametrosRondas => 'פרמטרים לסבבים';

  @override
  String get parametrosTiempo => 'פרמטרים לזמן';

  @override
  String get cantidadRondas => 'כמות סבבים:';

  @override
  String get tiempoLimite => 'זמן מוקצב:';

  @override
  String get mensajeModoManual =>
      'במצב ידני תוכל להדליק ולכבות את הפוד בכל עת בלחיצה על המשבצת שלו.';

  @override
  String get tiempoLimiteColor2 => 'זמן מוקצב לצבע 2 (מסיח)';

  @override
  String get tiempoParaIgnorar => 'זמן להתעלמות:';

  @override
  String get intervaloEntrePods => 'מרווח בין פודים';

  @override
  String get pausaEntreToques => 'הפסקה בין נגיעות:';

  @override
  String get coloresBicolor => 'צבעי מצב דו-צבעי';

  @override
  String get colorLeds => 'צבע נורות ה-LED';

  @override
  String get color1ATocar => 'צבע 1 (לנגיעה)';

  @override
  String get color2NoTocar => 'צבע 2 (לא לגעת / להתעלם)';

  @override
  String get seleccionarColorBase => 'בחר צבע בסיס';

  @override
  String get ajusteColorRgb => 'כוונון צבע RGB:';

  @override
  String get vistaPrevia => 'תצוגה מקדימה:';

  @override
  String get intensidadLeds => 'עוצמת נורות ה-LED';

  @override
  String get brilloIntensidad => 'בהירות / עוצמה:';

  @override
  String get iniciarRutina => 'התחל אימון';

  @override
  String get errorBluetoothRequerido =>
      'עליך לחבר את ה-ESP32 בלוטות\' לפני תחילת האימון.';

  @override
  String get conectar => 'התחבר';

  @override
  String get errorBicolorColoresIguales =>
      'במצב דו-צבעי עליך לבחור שני צבעים שונים.';

  @override
  String get aparatoListo => 'המכשיר מוכן!';

  @override
  String get preparate => 'התכונן!';

  @override
  String get atento => 'שים לב!';

  @override
  String tocaPodColor1(Object pod) {
    return 'גע בפוד $pod! (צבע 1)';
  }

  @override
  String noTocarColor2(Object pod) {
    return 'אל תגע! (צבע 2 בפוד $pod)';
  }

  @override
  String pasaManoPorPod(Object pod) {
    return 'העבר את היד מעל פוד $pod!';
  }

  @override
  String get excelenteColorIgnorado => 'מצוין! התעלמת מצבע 2.';

  @override
  String get tocaCuadradoEncender => 'לחץ על משבצת כדי להדליק את הפוד';

  @override
  String get seleccionaPodEncender => 'בחר פוד להדלקה';

  @override
  String get ledApagado => 'נורת LED כבויה.';

  @override
  String toqueEnPod(Object pod, Object tiempo) {
    return 'נגיעה בפוד $pod! ($tiempo שניות)';
  }

  @override
  String errorTocasteColor2(Object pod) {
    return 'שגיאה! נגעת בצבע 2 בפוד $pod';
  }

  @override
  String get desconectado => 'מנותק';

  @override
  String get errorDesconexionMensaje =>
      'חיבור הבלוטות\' לפוד המרכזי הופסק. האימון הופסק.';

  @override
  String get entrenamientoFinalizado => 'האימון הסתיים! 🏆';

  @override
  String usuario(Object nombre) {
    return 'משתמש: $nombre';
  }

  @override
  String toquesValidos(Object cantidad) {
    return 'נגיעות תקינות: $cantidad';
  }

  @override
  String promedioSegundos(Object promedio) {
    return 'ממוצע: $promedio שניות';
  }

  @override
  String erroresCometidos(Object errores) {
    return 'שגיאות: $errores';
  }

  @override
  String get anotacionesSesionOpcional => 'הערות לאימון (רשות)';

  @override
  String get hintAnotaciones => 'לדוגמה: שיפור טוב, עייפות שרירים...';

  @override
  String get guardarYFinalizar => 'שמור וסים';

  @override
  String modoManualToques(Object cantidad) {
    return 'מצב ידני (נגיעות: $cantidad)';
  }

  @override
  String tiempoRestanteToques(Object cantidad, Object tiempoRestante) {
    return 'זמן: $tiempoRestanteש\' | נגיעות: $cantidad';
  }

  @override
  String bicolorRonda(Object rondaActual, Object rondasTotal) {
    return 'דו-צבעי | סבב $rondaActual מתוך $rondasTotal';
  }

  @override
  String rondaDe(Object rondaActual, Object rondasTotal) {
    return 'סבב $rondaActual מתוך $rondasTotal';
  }

  @override
  String tiempoRestante(Object tiempoRestante) {
    return 'זמן נותר: $tiempoRestanteש\'';
  }

  @override
  String get ultimoTiempoValido => 'זמן תקין אחרון';

  @override
  String get finalizarSesion => 'סיום אימון';

  @override
  String get encendido => 'דולק';

  @override
  String podLabel(Object num) {
    return 'פוד $num';
  }

  @override
  String get conectarBluetooth => 'חיבור בלוטות\'';

  @override
  String conectadoExitosamente(Object nombre) {
    return 'חובור בהצלחה ל-$nombre!';
  }

  @override
  String errorAlConectar(Object error) {
    return 'שגיאה בחיבור: $error';
  }

  @override
  String get dispositivoDesconectado => 'המכשיר נותק';

  @override
  String get desconectar => 'נתק';

  @override
  String get conectado => 'מחובר';

  @override
  String get dispositivosDisponibles => 'מכשירים זמינים:';

  @override
  String get buscandoPods => 'מחפש פודים בסביבה...';

  @override
  String get presionaBotonBuscar => 'לחץ על הלחצן למטה כדי לחפש פודים.';

  @override
  String get cancelarBusqueda => 'בטל חיפוש';

  @override
  String get buscarDispositivos => 'חפש מכשירים';

  @override
  String get editarPerfil => 'עריכת פרופיל';

  @override
  String get perfilActualizado => 'הפרופיל עודכן בהצלחה';

  @override
  String get errorActualizarPerfil => 'שגיאה בעדכון הפרופיל';

  @override
  String correoRestablecimientoEnviado(Object email) {
    return 'שלחנו דוא\"ל ל-$email לאיפוס הסיסמה שלך.';
  }

  @override
  String get errorCorreoRestablecimiento => 'שגיאה שליחת דוא\"ל האיפוס.';

  @override
  String get subirFotoPerfil => 'העלאת תמונת פרופיל';

  @override
  String get cambiarFotoPerfil => 'שינוי תמונת פרופיל';

  @override
  String get eliminarFoto => 'מחק תמונה';

  @override
  String get informacionPersonal => 'מידע אישי';

  @override
  String get correoNoModificable => 'לא ניתן לשנות את הדוא\"ל ישירות.';

  @override
  String get seguridad => 'אבטחה';

  @override
  String get solicitarRestablecerContrasena =>
      'בקש קישור בדוא\"ל לאיפוס או שינוי הסיסמה הנוכחית שלך.';

  @override
  String get cambiarContrasena => 'שינוי סיסמה';

  @override
  String get guardarCambios => 'שמור שינויים';

  @override
  String get gestionDeUsuarios => 'ניהול משתמשים';

  @override
  String get agregar => 'הוסף';

  @override
  String get eliminarUsuario => 'מחק משתמש';

  @override
  String confirmarEliminarUsuario(Object nombre) {
    return 'האם אתה בטוח שברצונך למחוק את הפרופיל \"$nombre\"?';
  }

  @override
  String get cancelar => 'ביטול';

  @override
  String get eliminar => 'מחק';

  @override
  String get nuevoUsuario => 'משתמש חדש';

  @override
  String get editarUsuario => 'עריכת משתמש';

  @override
  String get subirFoto => 'העלאת תמונה';

  @override
  String get cambiarFoto => 'שינוי תמונה';

  @override
  String get notasObservaciones => 'הערות / תצפיות';

  @override
  String get guardar => 'שמור';

  @override
  String get mejorPromedio => 'ממוצע הכי טוב';

  @override
  String get mejorTiempo => 'זמן הכי טוב';

  @override
  String get mejorUltimaSesion => 'הכי טוב (אימון אחרון)';

  @override
  String get promedioUltimaSesion => 'ממוצע (אימון אחרון)';

  @override
  String get iniciaSesionParaGestionar => 'התחבר כדי לנהל פרופילים.';

  @override
  String get perfilPrincipalPropietario => 'פרופיל ראשי (בעלים)';

  @override
  String get sinNombre => 'ללא שם';

  @override
  String get cuentaPrincipal => 'חשבון ראשי';

  @override
  String get instruccionGestionUsuarios => 'בחר את המשתמש שיתאמן באימון זה.';

  @override
  String get usuarioRegistrado => 'משתמש רשום';

  @override
  String get ajustes => 'הגדרות';

  @override
  String felizCumpleanos(Object nombre) {
    return 'יום הולדת שמח, $nombre! 🎂';
  }

  @override
  String get mensajeCumpleanos => 'צוות Activelo מאחל לך יום אימון מצוין!';

  @override
  String get perfilYModoDeUso => 'פרופיל ומצב שימוש';

  @override
  String get modoProfesional => 'מצב מקצועי';

  @override
  String get modoProfesionalDesc => 'מאפשר ניהול משתמשים מרובים והערות אימון.';

  @override
  String get aparienciaTema => 'מראה ועיצוב';

  @override
  String get modoOscuro => 'מצב כהה';

  @override
  String get cambiarTemaClaroOscuro => 'מעבר בין עיצוב בהיר לכהה';

  @override
  String get idioma => 'שפה';

  @override
  String get sonidoRetroalimentacion => 'צלילים ומשוב';

  @override
  String get efectosSonido => 'אפקטים קוליים';

  @override
  String get reproducirSonidosRutina => 'השמעת צלילים בתחילת ובסיום האימון';

  @override
  String get cuentaPerfil => 'חשבון ופרופיל';

  @override
  String get actualizaInformacionPersonal => 'עדכן את המידע האישי שלך';

  @override
  String get dispositivosBluetooth => 'מכשירי בלוטות\'';

  @override
  String get administrarConexiones => 'ניהול חיבורים וסריקה';

  @override
  String get informacion => 'מידע';

  @override
  String get versionApp => 'גרסה 1.0.0';

  @override
  String get cerrarSesion => 'התנתקות';

  @override
  String get historialSesiones => 'היסטוריית אימונים';

  @override
  String get historialIniciaSesion => 'עליך להתחבר כדי לצפות בהיסטוריה שלך.';

  @override
  String get sinSesionesRegistradas => 'עדיין אין אימונים רשומים.';

  @override
  String get noHaySesionesUsuario => 'אין אימונים עבור משתמש זה.';

  @override
  String get anotacionesDeLaSesion => 'הערות לאימון';

  @override
  String get observacionesDeLaSesion => 'תצפיות על האימון';

  @override
  String get todos => 'הכל';

  @override
  String toquesCount(Object count) {
    return '$count נגיעות';
  }

  @override
  String get mejorToque => 'נגיעה הכי טובה';

  @override
  String get promedio => 'ממוצע';

  @override
  String get errores => 'שגיאות';

  @override
  String get sinAnotaciones => 'לא הוכנסו הערות.';

  @override
  String get desglosePorToqueValido => 'פירוט לפי נגיעה תקינה:';

  @override
  String get legalesYPrivacidad => 'משפטי ופרטיות';

  @override
  String get terminosDeUso => 'תנאי שימוש';

  @override
  String get privacidad => 'פרטיות';

  @override
  String get terminosYCondicionesDeUso => 'תנאים והגבלות שימוש';

  @override
  String get ultimaActualizacion => 'עדכון אחרון: 2026';

  @override
  String get tituloTerminos1 => '1. הסכמה לתנאים';

  @override
  String get textoTerminos1 =>
      'בהורדה, הרשמה או שימוש באפליקציית Activelo, אתה מסכים להיות כפוף לתנאים והגבלות אלה.';

  @override
  String get tituloTerminos2 => '2. תיאור השירות';

  @override
  String get textoTerminos2 =>
      'Activelo היא פלטפורמה המיועדת להגדרה, שליטה ומעקב אחר אימוני כושר וזריזות באמצעות מכשירים אלחוטיים.';

  @override
  String get tituloTerminos3 => '3. חשבונות משתמש';

  @override
  String get textoTerminos3 =>
      'כדי לגשת לסנכרון ההיסטוריה והסטטיסטיקות שלך, עליך לרשום חשבון עם דוא\"ל תקין.';

  @override
  String get tituloTerminos4 => '4. אחריות ובריאות גופנית';

  @override
  String get textoTerminos4 =>
      'השימוש באפליקציה כרוך בביצוע פעילות גופנית. האפליקציה אינה מספקת ייעוץ רפואי.';

  @override
  String get tituloTerminos5 => '5. שימוש בחומרה ואינטראקציה אלחוטית';

  @override
  String get textoTerminos5 =>
      'האפליקציה דורשת קישוריות אלחוטית כדי לפעול עם פודי האימון.';

  @override
  String get tituloTerminos6 => '6. שינויים בפלטפורמה';

  @override
  String get textoTerminos6 =>
      'אנו שומרים לעצמנו את הזכות לשנות או להפסיק שירותים ולעדכן תנאים אלה בכל עת.';

  @override
  String get politicaPrivacidad => 'מדיניות פרטיות';

  @override
  String get tituloPrivacidad1 => '1. מידע שנאסף';

  @override
  String get textoPrivacidad1 =>
      'אנו אוספים רק נתונים חיוניים למתן השירות:\n• דוא\"ל הרשמה.\n• מדדי אימון: זמני תגובה, כמות נגיעות, מצבים ותאריכים.';

  @override
  String get tituloPrivacidad2 => '2. הרשאות נדרשות';

  @override
  String get textoPrivacidad2 =>
      'לחיבור והעברת האימונים למכשירים, האפליקציה תבקש הרשאות בלוטות\' ומיקום.';

  @override
  String get tituloPrivacidad3 => '3. שימוש במידע';

  @override
  String get textoPrivacidad3 =>
      'הנתונים משמשים אך ורק לאפשר גישה לחשבונך ולהצגת ההתקדמות שלך.';

  @override
  String get tituloPrivacidad4 => '4. הגנת נתונים';

  @override
  String get textoPrivacidad4 =>
      'אנו מיישמים אמצעי אבטחה להגנה על המידע שלך. איננו מוכרים את המידע האישי שלך.';

  @override
  String get tituloPrivacidad5 => '5. מחיקת נתונים';

  @override
  String get textoPrivacidad5 =>
      'זכותך לבקש מחיקה לצמיתות של חשבונך וכל נתוני האימון שלך בכל עת.';
}
