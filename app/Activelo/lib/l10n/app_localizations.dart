import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('he'),
    Locale('it'),
    Locale('ja'),
    Locale('pt'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Activelo'**
  String get appTitle;

  /// No description provided for @paginaNoEncontrada.
  ///
  /// In es, this message translates to:
  /// **'Página no encontrada'**
  String get paginaNoEncontrada;

  /// No description provided for @paginaNoExiste.
  ///
  /// In es, this message translates to:
  /// **'La pantalla solicitada no existe.'**
  String get paginaNoExiste;

  /// No description provided for @volverAlInicio.
  ///
  /// In es, this message translates to:
  /// **'Volver al Inicio'**
  String get volverAlInicio;

  /// No description provided for @navInicio.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get navInicio;

  /// No description provided for @navHistorial.
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get navHistorial;

  /// No description provided for @navAjustes.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get navAjustes;

  /// No description provided for @iniciarSesion.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión'**
  String get iniciarSesion;

  /// No description provided for @crearCuenta.
  ///
  /// In es, this message translates to:
  /// **'CREAR CUENTA'**
  String get crearCuenta;

  /// No description provided for @registrate.
  ///
  /// In es, this message translates to:
  /// **'Registrate'**
  String get registrate;

  /// No description provided for @nombreCompleto.
  ///
  /// In es, this message translates to:
  /// **'Nombre Completo'**
  String get nombreCompleto;

  /// No description provided for @fechaNacimiento.
  ///
  /// In es, this message translates to:
  /// **'Fecha de Nacimiento'**
  String get fechaNacimiento;

  /// No description provided for @correoElectronico.
  ///
  /// In es, this message translates to:
  /// **'Correo Electrónico'**
  String get correoElectronico;

  /// No description provided for @contrasena.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get contrasena;

  /// No description provided for @confirmarContrasena.
  ///
  /// In es, this message translates to:
  /// **'Confirmar Contraseña'**
  String get confirmarContrasena;

  /// No description provided for @seleccionarFecha.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar fecha'**
  String get seleccionarFecha;

  /// No description provided for @seleccionaTuFechaNacimiento.
  ///
  /// In es, this message translates to:
  /// **'SELECCIONÁ TU FECHA DE NACIMIENTO'**
  String get seleccionaTuFechaNacimiento;

  /// No description provided for @errorFechaNacimiento.
  ///
  /// In es, this message translates to:
  /// **'Por favor, seleccioná tu fecha de nacimiento.'**
  String get errorFechaNacimiento;

  /// No description provided for @errorNombreVacio.
  ///
  /// In es, this message translates to:
  /// **'Ingresá tu nombre completo'**
  String get errorNombreVacio;

  /// No description provided for @errorCorreoVacio.
  ///
  /// In es, this message translates to:
  /// **'Ingresá tu correo electrónico'**
  String get errorCorreoVacio;

  /// No description provided for @errorCorreoInvalido.
  ///
  /// In es, this message translates to:
  /// **'Ingresá un correo válido'**
  String get errorCorreoInvalido;

  /// No description provided for @errorContrasenaVacia.
  ///
  /// In es, this message translates to:
  /// **'Ingresá tu contraseña'**
  String get errorContrasenaVacia;

  /// No description provided for @errorContrasenaCorta.
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos 6 caracteres'**
  String get errorContrasenaCorta;

  /// No description provided for @errorContrasenasNoCoinciden.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get errorContrasenasNoCoinciden;

  /// No description provided for @subtituloLogin.
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión para comenzar tu rutina'**
  String get subtituloLogin;

  /// No description provided for @subtituloRegistro.
  ///
  /// In es, this message translates to:
  /// **'Crea tu cuenta para guardar tus entrenamientos'**
  String get subtituloRegistro;

  /// No description provided for @yaTenesCuenta.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tenés una cuenta?'**
  String get yaTenesCuenta;

  /// No description provided for @noTenesCuenta.
  ///
  /// In es, this message translates to:
  /// **'¿No tenés una cuenta?'**
  String get noTenesCuenta;

  /// No description provided for @alRegistrarteAceptas.
  ///
  /// In es, this message translates to:
  /// **'Al registrarte, aceptás nuestros '**
  String get alRegistrarteAceptas;

  /// No description provided for @alIngresarAceptas.
  ///
  /// In es, this message translates to:
  /// **'Al ingresar, aceptás nuestros '**
  String get alIngresarAceptas;

  /// No description provided for @terminosYPrivacidad.
  ///
  /// In es, this message translates to:
  /// **'Términos y Privacidad'**
  String get terminosYPrivacidad;

  /// No description provided for @volverAlInicioSesion.
  ///
  /// In es, this message translates to:
  /// **'Volver al Inicio de Sesión'**
  String get volverAlInicioSesion;

  /// No description provided for @entrenar.
  ///
  /// In es, this message translates to:
  /// **'Entrenar'**
  String get entrenar;

  /// No description provided for @holaEntrenador.
  ///
  /// In es, this message translates to:
  /// **'¡Hola, {nombre}! 👋'**
  String holaEntrenador(Object nombre);

  /// No description provided for @entrenador.
  ///
  /// In es, this message translates to:
  /// **'Entrenador'**
  String get entrenador;

  /// No description provided for @usuarioActivo.
  ///
  /// In es, this message translates to:
  /// **'Usuario Activo:'**
  String get usuarioActivo;

  /// No description provided for @perfilPrincipal.
  ///
  /// In es, this message translates to:
  /// **'Perfil Principal'**
  String get perfilPrincipal;

  /// No description provided for @cambiar.
  ///
  /// In es, this message translates to:
  /// **'CAMBIAR'**
  String get cambiar;

  /// No description provided for @estadoDispositivo.
  ///
  /// In es, this message translates to:
  /// **'Estado del dispositivo'**
  String get estadoDispositivo;

  /// No description provided for @esp32Conectado.
  ///
  /// In es, this message translates to:
  /// **'ESP32 Conectado ({dispositivo})'**
  String esp32Conectado(Object dispositivo);

  /// No description provided for @esp32Desconectado.
  ///
  /// In es, this message translates to:
  /// **'ESP32 desconectado'**
  String get esp32Desconectado;

  /// No description provided for @podBle.
  ///
  /// In es, this message translates to:
  /// **'Pod BLE'**
  String get podBle;

  /// No description provided for @mejor.
  ///
  /// In es, this message translates to:
  /// **'Mejor'**
  String get mejor;

  /// No description provided for @ultimoPromedio.
  ///
  /// In es, this message translates to:
  /// **'Último Promedio'**
  String get ultimoPromedio;

  /// No description provided for @promedioGeneral.
  ///
  /// In es, this message translates to:
  /// **'Promedio General'**
  String get promedioGeneral;

  /// No description provided for @ultimaSesionDe.
  ///
  /// In es, this message translates to:
  /// **'Última sesión de {nombre}'**
  String ultimaSesionDe(Object nombre);

  /// No description provided for @ultimaSesion.
  ///
  /// In es, this message translates to:
  /// **'Última sesión'**
  String get ultimaSesion;

  /// No description provided for @toquesEnEstaSesion.
  ///
  /// In es, this message translates to:
  /// **'Toques en esta sesión'**
  String get toquesEnEstaSesion;

  /// No description provided for @mejorToqueDeLaSesion.
  ///
  /// In es, this message translates to:
  /// **'Mejor toque de la sesión'**
  String get mejorToqueDeLaSesion;

  /// No description provided for @accesosRapidos.
  ///
  /// In es, this message translates to:
  /// **'Accesos rápidos'**
  String get accesosRapidos;

  /// No description provided for @gestionarUsuarios.
  ///
  /// In es, this message translates to:
  /// **'Gestionar Usuarios'**
  String get gestionarUsuarios;

  /// No description provided for @vincularPodBle.
  ///
  /// In es, this message translates to:
  /// **'Vincular Pod BLE'**
  String get vincularPodBle;

  /// No description provided for @verHistorialTiempos.
  ///
  /// In es, this message translates to:
  /// **'Ver historial de tiempos'**
  String get verHistorialTiempos;

  /// No description provided for @configurarEntrenamiento.
  ///
  /// In es, this message translates to:
  /// **'Configurar Entrenamiento'**
  String get configurarEntrenamiento;

  /// No description provided for @cantidadPodsActivos.
  ///
  /// In es, this message translates to:
  /// **'Cantidad de Pods Activos'**
  String get cantidadPodsActivos;

  /// No description provided for @podsAUtilizar.
  ///
  /// In es, this message translates to:
  /// **'Pods a utilizar:'**
  String get podsAUtilizar;

  /// No description provided for @seleccionaElModo.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el Modo'**
  String get seleccionaElModo;

  /// No description provided for @porRondas.
  ///
  /// In es, this message translates to:
  /// **'Por Rondas'**
  String get porRondas;

  /// No description provided for @completaNumeroFijo.
  ///
  /// In es, this message translates to:
  /// **'Completa un número fijo de toques'**
  String get completaNumeroFijo;

  /// No description provided for @porTiempo.
  ///
  /// In es, this message translates to:
  /// **'Por Tiempo'**
  String get porTiempo;

  /// No description provided for @tocaMayorCantidad.
  ///
  /// In es, this message translates to:
  /// **'Toca la mayor cantidad antes de que acabe el tiempo'**
  String get tocaMayorCantidad;

  /// No description provided for @modoBicolor.
  ///
  /// In es, this message translates to:
  /// **'Modo Bicolor'**
  String get modoBicolor;

  /// No description provided for @desactivaColor1.
  ///
  /// In es, this message translates to:
  /// **'Desactiva Color 1 e ignora Color 2'**
  String get desactivaColor1;

  /// No description provided for @modoManual.
  ///
  /// In es, this message translates to:
  /// **'Modo Manual'**
  String get modoManual;

  /// No description provided for @controlaLuzDirectamente.
  ///
  /// In es, this message translates to:
  /// **'Controlá la luz directamente desde la app'**
  String get controlaLuzDirectamente;

  /// No description provided for @parametrosRondas.
  ///
  /// In es, this message translates to:
  /// **'Parámetros de Rondas'**
  String get parametrosRondas;

  /// No description provided for @parametrosTiempo.
  ///
  /// In es, this message translates to:
  /// **'Parámetros de Tiempo'**
  String get parametrosTiempo;

  /// No description provided for @cantidadRondas.
  ///
  /// In es, this message translates to:
  /// **'Cantidad de Rondas:'**
  String get cantidadRondas;

  /// No description provided for @tiempoLimite.
  ///
  /// In es, this message translates to:
  /// **'Tiempo Límite:'**
  String get tiempoLimite;

  /// No description provided for @mensajeModoManual.
  ///
  /// In es, this message translates to:
  /// **'En el Modo Manual podés encender y apagar el pod en cualquier momento tocando sus casillas.'**
  String get mensajeModoManual;

  /// No description provided for @tiempoLimiteColor2.
  ///
  /// In es, this message translates to:
  /// **'Tiempo Límite Color 2 (Distractor)'**
  String get tiempoLimiteColor2;

  /// No description provided for @tiempoParaIgnorar.
  ///
  /// In es, this message translates to:
  /// **'Tiempo para ignorar:'**
  String get tiempoParaIgnorar;

  /// No description provided for @intervaloEntrePods.
  ///
  /// In es, this message translates to:
  /// **'Intervalo entre Pods'**
  String get intervaloEntrePods;

  /// No description provided for @pausaEntreToques.
  ///
  /// In es, this message translates to:
  /// **'Pausa entre toques:'**
  String get pausaEntreToques;

  /// No description provided for @coloresBicolor.
  ///
  /// In es, this message translates to:
  /// **'Colores Bicolor'**
  String get coloresBicolor;

  /// No description provided for @colorLeds.
  ///
  /// In es, this message translates to:
  /// **'Color de los LEDs'**
  String get colorLeds;

  /// No description provided for @color1ATocar.
  ///
  /// In es, this message translates to:
  /// **'Color 1 (A tocar)'**
  String get color1ATocar;

  /// No description provided for @color2NoTocar.
  ///
  /// In es, this message translates to:
  /// **'Color 2 (NO tocar / Ignorar)'**
  String get color2NoTocar;

  /// No description provided for @seleccionarColorBase.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Color Base'**
  String get seleccionarColorBase;

  /// No description provided for @ajusteColorRgb.
  ///
  /// In es, this message translates to:
  /// **'Ajuste de Color RGB:'**
  String get ajusteColorRgb;

  /// No description provided for @vistaPrevia.
  ///
  /// In es, this message translates to:
  /// **'Vista previa:'**
  String get vistaPrevia;

  /// No description provided for @intensidadLeds.
  ///
  /// In es, this message translates to:
  /// **'Intensidad de los LEDs'**
  String get intensidadLeds;

  /// No description provided for @brilloIntensidad.
  ///
  /// In es, this message translates to:
  /// **'Brillo / Intensidad:'**
  String get brilloIntensidad;

  /// No description provided for @iniciarRutina.
  ///
  /// In es, this message translates to:
  /// **'INICIAR RUTINA'**
  String get iniciarRutina;

  /// No description provided for @errorBluetoothRequerido.
  ///
  /// In es, this message translates to:
  /// **'Debés conectar el ESP32 por Bluetooth antes de iniciar la rutina.'**
  String get errorBluetoothRequerido;

  /// No description provided for @conectar.
  ///
  /// In es, this message translates to:
  /// **'CONECTAR'**
  String get conectar;

  /// No description provided for @errorBicolorColoresIguales.
  ///
  /// In es, this message translates to:
  /// **'En el Modo Bicolor debés seleccionar dos colores distintos.'**
  String get errorBicolorColoresIguales;

  /// No description provided for @aparatoListo.
  ///
  /// In es, this message translates to:
  /// **'¡Aparato Listo!'**
  String get aparatoListo;

  /// No description provided for @preparate.
  ///
  /// In es, this message translates to:
  /// **'¡Preparate!'**
  String get preparate;

  /// No description provided for @atento.
  ///
  /// In es, this message translates to:
  /// **'¡Atento!'**
  String get atento;

  /// No description provided for @tocaPodColor1.
  ///
  /// In es, this message translates to:
  /// **'¡TOCÁ el Pod {pod}! (Color 1)'**
  String tocaPodColor1(Object pod);

  /// No description provided for @noTocarColor2.
  ///
  /// In es, this message translates to:
  /// **'¡NO TOCAR! (Color 2 en Pod {pod})'**
  String noTocarColor2(Object pod);

  /// No description provided for @pasaManoPorPod.
  ///
  /// In es, this message translates to:
  /// **'¡Pasa la mano por el Pod {pod}!'**
  String pasaManoPorPod(Object pod);

  /// No description provided for @excelenteColorIgnorado.
  ///
  /// In es, this message translates to:
  /// **'¡Excelente! Color 2 ignorado.'**
  String get excelenteColorIgnorado;

  /// No description provided for @tocaCuadradoEncender.
  ///
  /// In es, this message translates to:
  /// **'Tocá un cuadrado para encender su Pod'**
  String get tocaCuadradoEncender;

  /// No description provided for @seleccionaPodEncender.
  ///
  /// In es, this message translates to:
  /// **'Seleccioná un Pod para encender'**
  String get seleccionaPodEncender;

  /// No description provided for @ledApagado.
  ///
  /// In es, this message translates to:
  /// **'LED Apagado.'**
  String get ledApagado;

  /// No description provided for @toqueEnPod.
  ///
  /// In es, this message translates to:
  /// **'¡Toque en Pod {pod}! ({tiempo} s)'**
  String toqueEnPod(Object pod, Object tiempo);

  /// No description provided for @errorTocasteColor2.
  ///
  /// In es, this message translates to:
  /// **'¡Error! Tocaste el Color 2 en Pod {pod}'**
  String errorTocasteColor2(Object pod);

  /// No description provided for @desconectado.
  ///
  /// In es, this message translates to:
  /// **'Desconectado'**
  String get desconectado;

  /// No description provided for @errorDesconexionMensaje.
  ///
  /// In es, this message translates to:
  /// **'Se interrumpió la conexión Bluetooth con el Pod Central. La sesión se ha detenido.'**
  String get errorDesconexionMensaje;

  /// No description provided for @entrenamientoFinalizado.
  ///
  /// In es, this message translates to:
  /// **'¡Entrenamiento Finalizado! 🏆'**
  String get entrenamientoFinalizado;

  /// No description provided for @usuario.
  ///
  /// In es, this message translates to:
  /// **'Usuario: {nombre}'**
  String usuario(Object nombre);

  /// No description provided for @toquesValidos.
  ///
  /// In es, this message translates to:
  /// **'Toques válidos: {cantidad}'**
  String toquesValidos(Object cantidad);

  /// No description provided for @promedioSegundos.
  ///
  /// In es, this message translates to:
  /// **'Promedio: {promedio} s'**
  String promedioSegundos(Object promedio);

  /// No description provided for @erroresCometidos.
  ///
  /// In es, this message translates to:
  /// **'Errores cometidos: {errores}'**
  String erroresCometidos(Object errores);

  /// No description provided for @anotacionesSesionOpcional.
  ///
  /// In es, this message translates to:
  /// **'Anotaciones de la sesión (Opcional)'**
  String get anotacionesSesionOpcional;

  /// No description provided for @hintAnotaciones.
  ///
  /// In es, this message translates to:
  /// **'Ej: Buena evolución, fatiga muscular, etc.'**
  String get hintAnotaciones;

  /// No description provided for @guardarYFinalizar.
  ///
  /// In es, this message translates to:
  /// **'GUARDAR Y FINALIZAR'**
  String get guardarYFinalizar;

  /// No description provided for @modoManualToques.
  ///
  /// In es, this message translates to:
  /// **'Modo Manual (Toques: {cantidad})'**
  String modoManualToques(Object cantidad);

  /// No description provided for @tiempoRestanteToques.
  ///
  /// In es, this message translates to:
  /// **'Tiempo: {tiempoRestante}s | Toques: {cantidad}'**
  String tiempoRestanteToques(Object cantidad, Object tiempoRestante);

  /// No description provided for @bicolorRonda.
  ///
  /// In es, this message translates to:
  /// **'Bicolor | Ronda {rondaActual} de {rondasTotal}'**
  String bicolorRonda(Object rondaActual, Object rondasTotal);

  /// No description provided for @rondaDe.
  ///
  /// In es, this message translates to:
  /// **'Ronda {rondaActual} de {rondasTotal}'**
  String rondaDe(Object rondaActual, Object rondasTotal);

  /// No description provided for @tiempoRestante.
  ///
  /// In es, this message translates to:
  /// **'TIEMPO RESTANTE: {tiempoRestante}s'**
  String tiempoRestante(Object tiempoRestante);

  /// No description provided for @ultimoTiempoValido.
  ///
  /// In es, this message translates to:
  /// **'ÚLTIMO TIEMPO VÁLIDO'**
  String get ultimoTiempoValido;

  /// No description provided for @finalizarSesion.
  ///
  /// In es, this message translates to:
  /// **'FINALIZAR SESIÓN'**
  String get finalizarSesion;

  /// No description provided for @encendido.
  ///
  /// In es, this message translates to:
  /// **'ENCENDIDO'**
  String get encendido;

  /// No description provided for @podLabel.
  ///
  /// In es, this message translates to:
  /// **'POD {num}'**
  String podLabel(Object num);

  /// No description provided for @conectarBluetooth.
  ///
  /// In es, this message translates to:
  /// **'Conectar Bluetooth'**
  String get conectarBluetooth;

  /// No description provided for @conectadoExitosamente.
  ///
  /// In es, this message translates to:
  /// **'¡Conectado exitosamente a {nombre}!'**
  String conectadoExitosamente(Object nombre);

  /// No description provided for @errorAlConectar.
  ///
  /// In es, this message translates to:
  /// **'Error al conectar: {error}'**
  String errorAlConectar(Object error);

  /// No description provided for @dispositivoDesconectado.
  ///
  /// In es, this message translates to:
  /// **'Dispositivo desconectado'**
  String get dispositivoDesconectado;

  /// No description provided for @desconectar.
  ///
  /// In es, this message translates to:
  /// **'Desconectar'**
  String get desconectar;

  /// No description provided for @conectado.
  ///
  /// In es, this message translates to:
  /// **'Conectado'**
  String get conectado;

  /// No description provided for @dispositivosDisponibles.
  ///
  /// In es, this message translates to:
  /// **'Dispositivos disponibles:'**
  String get dispositivosDisponibles;

  /// No description provided for @buscandoPods.
  ///
  /// In es, this message translates to:
  /// **'Buscando pods cercanos...'**
  String get buscandoPods;

  /// No description provided for @presionaBotonBuscar.
  ///
  /// In es, this message translates to:
  /// **'Presioná el botón de abajo para buscar pods.'**
  String get presionaBotonBuscar;

  /// No description provided for @cancelarBusqueda.
  ///
  /// In es, this message translates to:
  /// **'CANCELAR BÚSQUEDA'**
  String get cancelarBusqueda;

  /// No description provided for @buscarDispositivos.
  ///
  /// In es, this message translates to:
  /// **'BUSCAR DISPOSITIVOS'**
  String get buscarDispositivos;

  /// No description provided for @editarPerfil.
  ///
  /// In es, this message translates to:
  /// **'Editar Perfil'**
  String get editarPerfil;

  /// No description provided for @perfilActualizado.
  ///
  /// In es, this message translates to:
  /// **'Perfil actualizado correctamente'**
  String get perfilActualizado;

  /// No description provided for @errorActualizarPerfil.
  ///
  /// In es, this message translates to:
  /// **'Error al actualizar el perfil'**
  String get errorActualizarPerfil;

  /// No description provided for @correoRestablecimientoEnviado.
  ///
  /// In es, this message translates to:
  /// **'Enviamos un correo a {email} para restablecer tu contraseña.'**
  String correoRestablecimientoEnviado(Object email);

  /// No description provided for @errorCorreoRestablecimiento.
  ///
  /// In es, this message translates to:
  /// **'Error al enviar el correo de restablecimiento.'**
  String get errorCorreoRestablecimiento;

  /// No description provided for @subirFotoPerfil.
  ///
  /// In es, this message translates to:
  /// **'Subir foto de perfil'**
  String get subirFotoPerfil;

  /// No description provided for @cambiarFotoPerfil.
  ///
  /// In es, this message translates to:
  /// **'Cambiar foto de perfil'**
  String get cambiarFotoPerfil;

  /// No description provided for @eliminarFoto.
  ///
  /// In es, this message translates to:
  /// **'Eliminar foto'**
  String get eliminarFoto;

  /// No description provided for @informacionPersonal.
  ///
  /// In es, this message translates to:
  /// **'INFORMACIÓN PERSONAL'**
  String get informacionPersonal;

  /// No description provided for @correoNoModificable.
  ///
  /// In es, this message translates to:
  /// **'El correo no se puede modificar directamente.'**
  String get correoNoModificable;

  /// No description provided for @seguridad.
  ///
  /// In es, this message translates to:
  /// **'SEGURIDAD'**
  String get seguridad;

  /// No description provided for @solicitarRestablecerContrasena.
  ///
  /// In es, this message translates to:
  /// **'Solicitá un enlace por correo para restablecer o cambiar tu contraseña actual.'**
  String get solicitarRestablecerContrasena;

  /// No description provided for @cambiarContrasena.
  ///
  /// In es, this message translates to:
  /// **'CAMBIAR CONTRASEÑA'**
  String get cambiarContrasena;

  /// No description provided for @guardarCambios.
  ///
  /// In es, this message translates to:
  /// **'GUARDAR CAMBIOS'**
  String get guardarCambios;

  /// No description provided for @gestionDeUsuarios.
  ///
  /// In es, this message translates to:
  /// **'Gestión de Usuarios'**
  String get gestionDeUsuarios;

  /// No description provided for @agregar.
  ///
  /// In es, this message translates to:
  /// **'Agregar'**
  String get agregar;

  /// No description provided for @eliminarUsuario.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Usuario'**
  String get eliminarUsuario;

  /// No description provided for @confirmarEliminarUsuario.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que deseas eliminar el perfil de \"{nombre}\"?'**
  String confirmarEliminarUsuario(Object nombre);

  /// No description provided for @cancelar.
  ///
  /// In es, this message translates to:
  /// **'CANCELAR'**
  String get cancelar;

  /// No description provided for @eliminar.
  ///
  /// In es, this message translates to:
  /// **'ELIMINAR'**
  String get eliminar;

  /// No description provided for @nuevoUsuario.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Usuario'**
  String get nuevoUsuario;

  /// No description provided for @editarUsuario.
  ///
  /// In es, this message translates to:
  /// **'Editar Usuario'**
  String get editarUsuario;

  /// No description provided for @subirFoto.
  ///
  /// In es, this message translates to:
  /// **'Subir foto'**
  String get subirFoto;

  /// No description provided for @cambiarFoto.
  ///
  /// In es, this message translates to:
  /// **'Cambiar foto'**
  String get cambiarFoto;

  /// No description provided for @notasObservaciones.
  ///
  /// In es, this message translates to:
  /// **'Notas / Observaciones'**
  String get notasObservaciones;

  /// No description provided for @guardar.
  ///
  /// In es, this message translates to:
  /// **'GUARDAR'**
  String get guardar;

  /// No description provided for @mejorPromedio.
  ///
  /// In es, this message translates to:
  /// **'Mejor Promedio'**
  String get mejorPromedio;

  /// No description provided for @mejorTiempo.
  ///
  /// In es, this message translates to:
  /// **'Mejor Tiempo'**
  String get mejorTiempo;

  /// No description provided for @mejorUltimaSesion.
  ///
  /// In es, this message translates to:
  /// **'Mejor (Últ. Sesión)'**
  String get mejorUltimaSesion;

  /// No description provided for @promedioUltimaSesion.
  ///
  /// In es, this message translates to:
  /// **'Prom. (Últ. Sesión)'**
  String get promedioUltimaSesion;

  /// No description provided for @iniciaSesionParaGestionar.
  ///
  /// In es, this message translates to:
  /// **'Iniciá sesión para gestionar perfiles.'**
  String get iniciaSesionParaGestionar;

  /// No description provided for @perfilPrincipalPropietario.
  ///
  /// In es, this message translates to:
  /// **'Perfil Principal (Propietario)'**
  String get perfilPrincipalPropietario;

  /// No description provided for @sinNombre.
  ///
  /// In es, this message translates to:
  /// **'Sin nombre'**
  String get sinNombre;

  /// No description provided for @cuentaPrincipal.
  ///
  /// In es, this message translates to:
  /// **'Cuenta Principal'**
  String get cuentaPrincipal;

  /// No description provided for @instruccionGestionUsuarios.
  ///
  /// In es, this message translates to:
  /// **'Seleccioná el usuario que entrenará en esta sesión.'**
  String get instruccionGestionUsuarios;

  /// No description provided for @usuarioRegistrado.
  ///
  /// In es, this message translates to:
  /// **'Usuario registrado'**
  String get usuarioRegistrado;

  /// No description provided for @ajustes.
  ///
  /// In es, this message translates to:
  /// **'Ajustes y Configuración'**
  String get ajustes;

  /// No description provided for @felizCumpleanos.
  ///
  /// In es, this message translates to:
  /// **'¡Feliz Cumpleaños, {nombre}! 🎂'**
  String felizCumpleanos(Object nombre);

  /// No description provided for @mensajeCumpleanos.
  ///
  /// In es, this message translates to:
  /// **'¡Todo el equipo de Activelo te desea un excelente día de entrenamiento!'**
  String get mensajeCumpleanos;

  /// No description provided for @perfilYModoDeUso.
  ///
  /// In es, this message translates to:
  /// **'PERFIL Y MODO DE USO'**
  String get perfilYModoDeUso;

  /// No description provided for @modoProfesional.
  ///
  /// In es, this message translates to:
  /// **'Modo Profesional'**
  String get modoProfesional;

  /// No description provided for @modoProfesionalDesc.
  ///
  /// In es, this message translates to:
  /// **'Habilita la gestión de múltiples usuarios y notas de sesión.'**
  String get modoProfesionalDesc;

  /// No description provided for @aparienciaTema.
  ///
  /// In es, this message translates to:
  /// **'APARIENCIA Y TEMA'**
  String get aparienciaTema;

  /// No description provided for @modoOscuro.
  ///
  /// In es, this message translates to:
  /// **'Modo Oscuro'**
  String get modoOscuro;

  /// No description provided for @cambiarTemaClaroOscuro.
  ///
  /// In es, this message translates to:
  /// **'Cambiar entre tema claro y oscuro'**
  String get cambiarTemaClaroOscuro;

  /// No description provided for @idioma.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get idioma;

  /// No description provided for @sonidoRetroalimentacion.
  ///
  /// In es, this message translates to:
  /// **'SONIDO Y RETROALIMENTACIÓN'**
  String get sonidoRetroalimentacion;

  /// No description provided for @efectosSonido.
  ///
  /// In es, this message translates to:
  /// **'Efectos de Sonido'**
  String get efectosSonido;

  /// No description provided for @reproducirSonidosRutina.
  ///
  /// In es, this message translates to:
  /// **'Reproducir sonidos al iniciar y finalizar la rutina'**
  String get reproducirSonidosRutina;

  /// No description provided for @cuentaPerfil.
  ///
  /// In es, this message translates to:
  /// **'CUENTA Y PERFIL'**
  String get cuentaPerfil;

  /// No description provided for @actualizaInformacionPersonal.
  ///
  /// In es, this message translates to:
  /// **'Actualiza tu información personal'**
  String get actualizaInformacionPersonal;

  /// No description provided for @dispositivosBluetooth.
  ///
  /// In es, this message translates to:
  /// **'Dispositivos Bluetooth'**
  String get dispositivosBluetooth;

  /// No description provided for @administrarConexiones.
  ///
  /// In es, this message translates to:
  /// **'Administrar conexiones y escaneo'**
  String get administrarConexiones;

  /// No description provided for @informacion.
  ///
  /// In es, this message translates to:
  /// **'INFORMACIÓN'**
  String get informacion;

  /// No description provided for @versionApp.
  ///
  /// In es, this message translates to:
  /// **'Versión 1.0.0'**
  String get versionApp;

  /// No description provided for @cerrarSesion.
  ///
  /// In es, this message translates to:
  /// **'Cerrar Sesión'**
  String get cerrarSesion;

  /// No description provided for @historialSesiones.
  ///
  /// In es, this message translates to:
  /// **'Historial de Sesiones'**
  String get historialSesiones;

  /// No description provided for @historialIniciaSesion.
  ///
  /// In es, this message translates to:
  /// **'Debés iniciar sesión para ver tu historial.'**
  String get historialIniciaSesion;

  /// No description provided for @sinSesionesRegistradas.
  ///
  /// In es, this message translates to:
  /// **'Aún no tenés sesiones registradas.'**
  String get sinSesionesRegistradas;

  /// No description provided for @noHaySesionesUsuario.
  ///
  /// In es, this message translates to:
  /// **'No hay sesiones para este usuario.'**
  String get noHaySesionesUsuario;

  /// No description provided for @anotacionesDeLaSesion.
  ///
  /// In es, this message translates to:
  /// **'Anotaciones de la Sesión'**
  String get anotacionesDeLaSesion;

  /// No description provided for @observacionesDeLaSesion.
  ///
  /// In es, this message translates to:
  /// **'Observaciones de la sesión'**
  String get observacionesDeLaSesion;

  /// No description provided for @todos.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get todos;

  /// No description provided for @toquesCount.
  ///
  /// In es, this message translates to:
  /// **'{count} toques'**
  String toquesCount(Object count);

  /// No description provided for @mejorToque.
  ///
  /// In es, this message translates to:
  /// **'Mejor Toque'**
  String get mejorToque;

  /// No description provided for @promedio.
  ///
  /// In es, this message translates to:
  /// **'Promedio'**
  String get promedio;

  /// No description provided for @errores.
  ///
  /// In es, this message translates to:
  /// **'Errores'**
  String get errores;

  /// No description provided for @sinAnotaciones.
  ///
  /// In es, this message translates to:
  /// **'Sin anotaciones ingresadas.'**
  String get sinAnotaciones;

  /// No description provided for @desglosePorToqueValido.
  ///
  /// In es, this message translates to:
  /// **'Desglose por toque válido:'**
  String get desglosePorToqueValido;

  /// No description provided for @legalesYPrivacidad.
  ///
  /// In es, this message translates to:
  /// **'Legales y Privacidad'**
  String get legalesYPrivacidad;

  /// No description provided for @terminosDeUso.
  ///
  /// In es, this message translates to:
  /// **'Términos de Uso'**
  String get terminosDeUso;

  /// No description provided for @privacidad.
  ///
  /// In es, this message translates to:
  /// **'Privacidad'**
  String get privacidad;

  /// No description provided for @terminosYCondicionesDeUso.
  ///
  /// In es, this message translates to:
  /// **'Términos y Condiciones de Uso'**
  String get terminosYCondicionesDeUso;

  /// No description provided for @ultimaActualizacion.
  ///
  /// In es, this message translates to:
  /// **'Última actualización: 2026'**
  String get ultimaActualizacion;

  /// No description provided for @tituloTerminos1.
  ///
  /// In es, this message translates to:
  /// **'1. Aceptación de los Términos'**
  String get tituloTerminos1;

  /// No description provided for @textoTerminos1.
  ///
  /// In es, this message translates to:
  /// **'Al descargar, registrarte o utilizar la aplicación Activelo, aceptas quedar vinculado por estos Términos y Condiciones. Si no estás de acuerdo con alguno de ellos, debes abstenerte de utilizar la plataforma.'**
  String get textoTerminos1;

  /// No description provided for @tituloTerminos2.
  ///
  /// In es, this message translates to:
  /// **'2. Descripción del Servicio'**
  String get tituloTerminos2;

  /// No description provided for @textoTerminos2.
  ///
  /// In es, this message translates to:
  /// **'Activelo es una plataforma diseñada para la configuración, control y seguimiento de rutinas de entrenamiento físico y agilidad mediante interacción con dispositivos interactivos inalámbricos.'**
  String get textoTerminos2;

  /// No description provided for @tituloTerminos3.
  ///
  /// In es, this message translates to:
  /// **'3. Cuentas de Usuario'**
  String get tituloTerminos3;

  /// No description provided for @textoTerminos3.
  ///
  /// In es, this message translates to:
  /// **'Para acceder a la sincronización de tu historial y estadísticas de rendimiento, debes registrar una cuenta con un correo electrónico válido. Eres el único responsable de mantener la confidencialidad de tus credenciales.'**
  String get textoTerminos3;

  /// No description provided for @tituloTerminos4.
  ///
  /// In es, this message translates to:
  /// **'4. Responsabilidad y Salud Física'**
  String get tituloTerminos4;

  /// No description provided for @textoTerminos4.
  ///
  /// In es, this message translates to:
  /// **'El uso de la aplicación implica la realización de actividad física. Activelo no proporciona asesoramiento médico. Se recomienda realizar una entrada en calor adecuada y suspender el entrenamiento ante cualquier molestia física.'**
  String get textoTerminos4;

  /// No description provided for @tituloTerminos5.
  ///
  /// In es, this message translates to:
  /// **'5. Uso del Hardware e Interacción Inalámbrica'**
  String get tituloTerminos5;

  /// No description provided for @textoTerminos5.
  ///
  /// In es, this message translates to:
  /// **'La app requiere conectividad inalámbrica para operar con los pods de entrenamiento. El usuario es responsable de operar los dispositivos en un entorno seguro y adecuado.'**
  String get textoTerminos5;

  /// No description provided for @tituloTerminos6.
  ///
  /// In es, this message translates to:
  /// **'6. Modificaciones de la Plataforma'**
  String get tituloTerminos6;

  /// No description provided for @textoTerminos6.
  ///
  /// In es, this message translates to:
  /// **'Nos reservamos el derecho de modificar o discontinuar funciones del servicio, así como de actualizar estos términos en cualquier momento.'**
  String get textoTerminos6;

  /// No description provided for @politicaPrivacidad.
  ///
  /// In es, this message translates to:
  /// **'Política de Privacidad'**
  String get politicaPrivacidad;

  /// No description provided for @tituloPrivacidad1.
  ///
  /// In es, this message translates to:
  /// **'1. Información Recopilada'**
  String get tituloPrivacidad1;

  /// No description provided for @textoPrivacidad1.
  ///
  /// In es, this message translates to:
  /// **'Únicamente recopilamos los datos esenciales para prestar el servicio:\n• Datos de identificación: Correo electrónico de registro.\n• Métricas de entrenamiento: Tiempos de reacción, cantidad de toques, modos utilizados y fechas de cada sesión.'**
  String get textoPrivacidad1;

  /// No description provided for @tituloPrivacidad2.
  ///
  /// In es, this message translates to:
  /// **'2. Permisos Requeridos'**
  String get tituloPrivacidad2;

  /// No description provided for @textoPrivacidad2.
  ///
  /// In es, this message translates to:
  /// **'Para vincular y transmitir las rutinas a los dispositivos de entrenamiento, la aplicación solicitará permisos de conexión inalámbrica (Bluetooth) y ubicación en los casos exigidos por el sistema operativo.'**
  String get textoPrivacidad2;

  /// No description provided for @tituloPrivacidad3.
  ///
  /// In es, this message translates to:
  /// **'3. Uso de la Información'**
  String get tituloPrivacidad3;

  /// No description provided for @textoPrivacidad3.
  ///
  /// In es, this message translates to:
  /// **'Los datos almacenados se utilizan exclusivamente para permitir el acceso a tu cuenta, calcular tus estadísticas de rendimiento personal y mostrarte tu historial de progreso.'**
  String get textoPrivacidad3;

  /// No description provided for @tituloPrivacidad4.
  ///
  /// In es, this message translates to:
  /// **'4. Protección de Datos'**
  String get tituloPrivacidad4;

  /// No description provided for @textoPrivacidad4.
  ///
  /// In es, this message translates to:
  /// **'Implementamos medidas de seguridad para proteger tu información almacenada en la nube. No vendemos ni compartimos tus datos personales con terceros para fines comerciales o publicitarios.'**
  String get textoPrivacidad4;

  /// No description provided for @tituloPrivacidad5.
  ///
  /// In es, this message translates to:
  /// **'5. Eliminación de Datos'**
  String get tituloPrivacidad5;

  /// No description provided for @textoPrivacidad5.
  ///
  /// In es, this message translates to:
  /// **'Tienes derecho a solicitar la baja definitiva de tu cuenta y la eliminación total de tus registros de entrenamiento en cualquier momento.'**
  String get textoPrivacidad5;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'he',
        'it',
        'ja',
        'pt',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
