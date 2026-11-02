// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Activelo';

  @override
  String get paginaNoEncontrada => 'Page not found';

  @override
  String get paginaNoExiste => 'The requested screen does not exist.';

  @override
  String get volverAlInicio => 'Return to Home';

  @override
  String get navInicio => 'Start';

  @override
  String get navHistorial => 'Record';

  @override
  String get navAjustes => 'Settings';

  @override
  String get iniciarSesion => 'Login';

  @override
  String get crearCuenta => 'CREATE ACCOUNT';

  @override
  String get registrate => 'Register';

  @override
  String get nombreCompleto => 'Full Name';

  @override
  String get fechaNacimiento => 'Birthdate';

  @override
  String get correoElectronico => 'Email';

  @override
  String get contrasena => 'Password';

  @override
  String get confirmarContrasena => 'Confirm Password';

  @override
  String get seleccionarFecha => 'Select date';

  @override
  String get seleccionaTuFechaNacimiento => 'SELECT YOUR DATE OF BIRTH';

  @override
  String get errorFechaNacimiento => 'Please select your date of birth.';

  @override
  String get errorNombreVacio => 'Enter your full name';

  @override
  String get errorCorreoVacio => 'Enter your email';

  @override
  String get errorCorreoInvalido => 'Enter a valid email';

  @override
  String get errorContrasenaVacia => 'Enter your password';

  @override
  String get errorContrasenaCorta => 'Password must be at least 6 characters';

  @override
  String get errorContrasenasNoCoinciden => 'Passwords do not match';

  @override
  String get subtituloLogin => 'Sign in to start your routine';

  @override
  String get subtituloRegistro => 'Create your account to save your workouts';

  @override
  String get yaTenesCuenta => 'Do you already have an account?';

  @override
  String get noTenesCuenta => 'Don\'t have an account?';

  @override
  String get alRegistrarteAceptas => 'By registering, you agree to our';

  @override
  String get alIngresarAceptas => 'By entering, you accept our';

  @override
  String get terminosYPrivacidad => 'Terms and Privacy';

  @override
  String get volverAlInicioSesion => 'Return to Login';

  @override
  String get entrenar => 'Train';

  @override
  String holaEntrenador(Object nombre) {
    return 'Hello, $nombre! 👋';
  }

  @override
  String get entrenador => 'Coach';

  @override
  String get usuarioActivo => 'Active User:';

  @override
  String get perfilPrincipal => 'Main Profile';

  @override
  String get cambiar => 'CHANGE';

  @override
  String get estadoDispositivo => 'Device status';

  @override
  String esp32Conectado(Object dispositivo) {
    return 'ESP32 Connected ($dispositivo)';
  }

  @override
  String get esp32Desconectado => 'ESP32 disconnected';

  @override
  String get podBle => 'BLE Pod';

  @override
  String get mejor => 'Better';

  @override
  String get ultimoPromedio => 'Last Average';

  @override
  String get promedioGeneral => 'General Average';

  @override
  String ultimaSesionDe(Object nombre) {
    return 'Last session of $nombre';
  }

  @override
  String get ultimaSesion => 'Last session';

  @override
  String get toquesEnEstaSesion => 'Touches in this session';

  @override
  String get mejorToqueDeLaSesion => 'Best touch of the session';

  @override
  String get accesosRapidos => 'Quick access';

  @override
  String get gestionarUsuarios => 'Manage Users';

  @override
  String get vincularPodBle => 'Link BLE Pod';

  @override
  String get verHistorialTiempos => 'View time history';

  @override
  String get configurarEntrenamiento => 'Set up training';

  @override
  String get cantidadPodsActivos => 'Number of Active Pods';

  @override
  String get podsAUtilizar => 'Pods to use:';

  @override
  String get seleccionaElModo => 'Select the Mode';

  @override
  String get porRondas => 'By Rounds';

  @override
  String get completaNumeroFijo => 'Complete a fixed number of touches';

  @override
  String get porTiempo => 'By Time';

  @override
  String get tocaMayorCantidad =>
      'Tap as many as possible before time runs out';

  @override
  String get modoBicolor => 'Two-color mode';

  @override
  String get desactivaColor1 => 'Disable Color 1 and ignore Color 2';

  @override
  String get modoManual => 'Manual Mode';

  @override
  String get controlaLuzDirectamente =>
      'Control the light directly from the app';

  @override
  String get parametrosRondas => 'Round Parameters';

  @override
  String get parametrosTiempo => 'Time Parameters';

  @override
  String get cantidadRondas => 'Number of Rounds:';

  @override
  String get tiempoLimite => 'Time Limit:';

  @override
  String get mensajeModoManual =>
      'In Manual Mode you can turn the pod on and off at any time by tapping its boxes.';

  @override
  String get tiempoLimiteColor2 => 'Time Limit Color 2 (Distractor)';

  @override
  String get tiempoParaIgnorar => 'Time to ignore:';

  @override
  String get intervaloEntrePods => 'Interval between Pods';

  @override
  String get pausaEntreToques => 'Pause between touches:';

  @override
  String get coloresBicolor => 'Two-tone colors';

  @override
  String get colorLeds => 'LED Color';

  @override
  String get color1ATocar => 'Color 1 (To be played)';

  @override
  String get color2NoTocar => 'Color 2 (DO NOT touch / Ignore)';

  @override
  String get seleccionarColorBase => 'Select Base Color';

  @override
  String get ajusteColorRgb => 'RGB Color Adjustment:';

  @override
  String get vistaPrevia => 'Preview:';

  @override
  String get intensidadLeds => 'LED intensity';

  @override
  String get brilloIntensidad => 'Brightness/Intensity:';

  @override
  String get iniciarRutina => 'START ROUTINE';

  @override
  String get errorBluetoothRequerido =>
      'You must connect the ESP32 via Bluetooth before starting the routine.';

  @override
  String get conectar => 'CONNECT';

  @override
  String get errorBicolorColoresIguales =>
      'In Bicolor Mode you must select two different colors.';

  @override
  String get aparatoListo => 'Device Ready!';

  @override
  String get preparate => 'Get ready!';

  @override
  String get atento => 'Attentive!';

  @override
  String tocaPodColor1(Object pod) {
    return 'TOUCH Pod $pod! (Color 1)';
  }

  @override
  String noTocarColor2(Object pod) {
    return 'DO NOT TOUCH! (Color 2 in Pod $pod)';
  }

  @override
  String pasaManoPorPod(Object pod) {
    return 'Run your hand through Pod $pod!';
  }

  @override
  String get excelenteColorIgnorado => 'Excellent! Color 2 ignored.';

  @override
  String get tocaCuadradoEncender => 'Tap a square to turn on your Pod';

  @override
  String get seleccionaPodEncender => 'Select a Pod to turn on';

  @override
  String get ledApagado => 'LED Off.';

  @override
  String toqueEnPod(Object pod, Object tiempo) {
    return 'Tap Pod $pod! (${tiempo}s)';
  }

  @override
  String errorTocasteColor2(Object pod) {
    return 'Mistake! You played Color 2 in Pod $pod';
  }

  @override
  String get desconectado => 'Offline';

  @override
  String get errorDesconexionMensaje =>
      'The Bluetooth connection to the Pod Central has been interrupted. The session has been stopped.';

  @override
  String get entrenamientoFinalizado => 'Training Finished! 🏆';

  @override
  String usuario(Object nombre) {
    return 'User: $nombre';
  }

  @override
  String toquesValidos(Object cantidad) {
    return 'Valid touches: $cantidad';
  }

  @override
  String promedioSegundos(Object promedio) {
    return 'Average: $promedio s';
  }

  @override
  String erroresCometidos(Object errores) {
    return 'Errors made: $errores';
  }

  @override
  String get anotacionesSesionOpcional => 'Session logs (Optional)';

  @override
  String get hintAnotaciones => 'Ex: Good evolution, muscle fatigue, etc.';

  @override
  String get guardarYFinalizar => 'SAVE AND FINISH';

  @override
  String modoManualToques(Object cantidad) {
    return 'Manual Mode (Tops: $cantidad)';
  }

  @override
  String tiempoRestanteToques(Object cantidad, Object tiempoRestante) {
    return 'Time: ${tiempoRestante}s | Touches: $cantidad';
  }

  @override
  String bicolorRonda(Object rondaActual, Object rondasTotal) {
    return 'Bicolor | Round $rondaActual of $rondasTotal';
  }

  @override
  String rondaDe(Object rondaActual, Object rondasTotal) {
    return 'Round $rondaActual of $rondasTotal';
  }

  @override
  String tiempoRestante(Object tiempoRestante) {
    return 'REMAINING TIME: ${tiempoRestante}s';
  }

  @override
  String get ultimoTiempoValido => 'LAST VALID TIME';

  @override
  String get finalizarSesion => 'END SESSION';

  @override
  String get encendido => 'ON';

  @override
  String podLabel(Object num) {
    return 'POD $num';
  }

  @override
  String get conectarBluetooth => 'Connect Bluetooth';

  @override
  String conectadoExitosamente(Object nombre) {
    return 'Successfully connected to $nombre!';
  }

  @override
  String errorAlConectar(Object error) {
    return 'Error connecting: $error';
  }

  @override
  String get dispositivoDesconectado => 'Device disconnected';

  @override
  String get desconectar => 'Disconnect';

  @override
  String get conectado => 'Connected';

  @override
  String get dispositivosDisponibles => 'Available devices:';

  @override
  String get buscandoPods => 'Looking for nearby pods...';

  @override
  String get presionaBotonBuscar =>
      'Press the button below to search for pods.';

  @override
  String get cancelarBusqueda => 'CANCEL SEARCH';

  @override
  String get buscarDispositivos => 'SEARCH DEVICES';

  @override
  String get editarPerfil => 'Edit Profile';

  @override
  String get perfilActualizado => 'Profile updated successfully';

  @override
  String get errorActualizarPerfil => 'Error updating profile';

  @override
  String correoRestablecimientoEnviado(Object email) {
    return 'We send an email to $email to reset your password.';
  }

  @override
  String get errorCorreoRestablecimiento => 'Error sending reset email.';

  @override
  String get subirFotoPerfil => 'Upload profile photo';

  @override
  String get cambiarFotoPerfil => 'Change profile photo';

  @override
  String get eliminarFoto => 'Delete photo';

  @override
  String get informacionPersonal => 'PERSONAL INFORMATION';

  @override
  String get correoNoModificable => 'The email cannot be modified directly.';

  @override
  String get seguridad => 'SECURITY';

  @override
  String get solicitarRestablecerContrasena =>
      'Request a link by email to reset or change your current password.';

  @override
  String get cambiarContrasena => 'CHANGE PASSWORD';

  @override
  String get guardarCambios => 'SAVE CHANGES';

  @override
  String get gestionDeUsuarios => 'User Management';

  @override
  String get agregar => 'Add';

  @override
  String get eliminarUsuario => 'Delete User';

  @override
  String confirmarEliminarUsuario(Object nombre) {
    return 'Are you sure you want to delete the profile of \"$nombre\"?';
  }

  @override
  String get cancelar => 'CANCEL';

  @override
  String get eliminar => 'ELIMINATE';

  @override
  String get nuevoUsuario => 'New User';

  @override
  String get editarUsuario => 'Edit User';

  @override
  String get subirFoto => 'Upload photo';

  @override
  String get cambiarFoto => 'Change photo';

  @override
  String get notasObservaciones => 'Notes / Observations';

  @override
  String get guardar => 'KEEP';

  @override
  String get mejorPromedio => 'Best Average';

  @override
  String get mejorTiempo => 'Best Time';

  @override
  String get mejorUltimaSesion => 'Best (Last Session)';

  @override
  String get promedioUltimaSesion => 'Avg. (Last Session)';

  @override
  String get iniciaSesionParaGestionar => 'Sign in to manage profiles.';

  @override
  String get perfilPrincipalPropietario => 'Main Profile (Owner)';

  @override
  String get sinNombre => 'Unnamed';

  @override
  String get cuentaPrincipal => 'Main Account';

  @override
  String get instruccionGestionUsuarios =>
      'Select the user who will train in this session.';

  @override
  String get usuarioRegistrado => 'Registered user';

  @override
  String get ajustes => 'Settings and Configuration';

  @override
  String felizCumpleanos(Object nombre) {
    return 'Happy Birthday, $nombre! 🎂';
  }

  @override
  String get mensajeCumpleanos =>
      'The entire Activelo team wishes you an excellent day of training!';

  @override
  String get perfilYModoDeUso => 'PROFILE AND MODE OF USE';

  @override
  String get modoProfesional => 'Professional Mode';

  @override
  String get modoProfesionalDesc =>
      'Enables management of multiple users and session notes.';

  @override
  String get aparienciaTema => 'APPEARANCE AND THEME';

  @override
  String get modoOscuro => 'Dark Mode';

  @override
  String get cambiarTemaClaroOscuro => 'Switch between light and dark theme';

  @override
  String get idioma => 'Language';

  @override
  String get sonidoRetroalimentacion => 'SOUND AND FEEDBACK';

  @override
  String get efectosSonido => 'Sound Effects';

  @override
  String get reproducirSonidosRutina =>
      'Play sounds when starting and ending the routine';

  @override
  String get cuentaPerfil => 'ACCOUNT AND PROFILE';

  @override
  String get actualizaInformacionPersonal => 'Update your personal information';

  @override
  String get dispositivosBluetooth => 'Bluetooth devices';

  @override
  String get administrarConexiones => 'Manage connections and scanning';

  @override
  String get informacion => 'INFORMATION';

  @override
  String get versionApp => 'Version 1.0.0';

  @override
  String get cerrarSesion => 'Sign Out';

  @override
  String get historialSesiones => 'Session History';

  @override
  String get historialIniciaSesion => 'You must log in to view your history.';

  @override
  String get sinSesionesRegistradas =>
      'You do not have registered sessions yet.';

  @override
  String get noHaySesionesUsuario => 'There are no sessions for this user.';

  @override
  String get anotacionesDeLaSesion => 'Session Notes';

  @override
  String get observacionesDeLaSesion => 'Session observations';

  @override
  String get todos => 'All';

  @override
  String toquesCount(Object count) {
    return '$count touches';
  }

  @override
  String get mejorToque => 'Better Touch';

  @override
  String get promedio => 'Average';

  @override
  String get errores => 'Errors';

  @override
  String get sinAnotaciones => 'No annotations entered.';

  @override
  String get desglosePorToqueValido => 'Breakdown by valid touch:';

  @override
  String get legalesYPrivacidad => 'Legal and Privacy';

  @override
  String get terminosDeUso => 'Terms of Use';

  @override
  String get privacidad => 'Privacy';

  @override
  String get terminosYCondicionesDeUso => 'Terms and Conditions of Use';

  @override
  String get ultimaActualizacion => 'Last update: 2026';

  @override
  String get tituloTerminos1 => '1. Acceptance of Terms';

  @override
  String get textoTerminos1 =>
      'By downloading, registering or using the Activelo application, you agree to be bound by these Terms and Conditions. If you do not agree with any of them, you must refrain from using the platform.';

  @override
  String get tituloTerminos2 => '2. Service Description';

  @override
  String get textoTerminos2 =>
      'Activelo is a platform designed for the configuration, control and monitoring of physical and agility training routines through interaction with wireless interactive devices.';

  @override
  String get tituloTerminos3 => '3. User Accounts';

  @override
  String get textoTerminos3 =>
      'To access synchronization of your history and performance statistics, you must register an account with a valid email. You are solely responsible for maintaining the confidentiality of your credentials.';

  @override
  String get tituloTerminos4 => '4. Responsibility and Physical Health';

  @override
  String get textoTerminos4 =>
      'The use of the application implies carrying out physical activity. Activelo does not provide medical advice. It is recommended to warm up properly and suspend training if there is any physical discomfort.';

  @override
  String get tituloTerminos5 => '5. Hardware Use and Wireless Interaction';

  @override
  String get textoTerminos5 =>
      'The app requires wireless connectivity to operate with the training pods. The user is responsible for operating the devices in a safe and appropriate environment.';

  @override
  String get tituloTerminos6 => '6. Platform Modifications';

  @override
  String get textoTerminos6 =>
      'We reserve the right to modify or discontinue features of the Service and to update these Terms at any time.';

  @override
  String get politicaPrivacidad => 'Privacy Policy';

  @override
  String get tituloPrivacidad1 => '1. Information Collected';

  @override
  String get textoPrivacidad1 =>
      'We only collect essential data to provide the service:\n• Identification data: Registration email.\n• Training metrics: Reaction times, number of touches, modes used and dates of each session.';

  @override
  String get tituloPrivacidad2 => '2. Required Permissions';

  @override
  String get textoPrivacidad2 =>
      'To link and transmit the routines to the training devices, the application will request wireless connection (Bluetooth) and location permissions in cases required by the operating system.';

  @override
  String get tituloPrivacidad3 => '3. Use of Information';

  @override
  String get textoPrivacidad3 =>
      'The stored data is used exclusively to allow access to your account, calculate your personal performance statistics and show you your progress history.';

  @override
  String get tituloPrivacidad4 => '4. Data Protection';

  @override
  String get textoPrivacidad4 =>
      'We implement security measures to protect your information stored in the cloud. We do not sell or share your personal data with third parties for commercial or advertising purposes.';

  @override
  String get tituloPrivacidad5 => '5. Data Deletion';

  @override
  String get textoPrivacidad5 =>
      'You have the right to request the permanent deletion of your account and the total deletion of your training records at any time.';
}
