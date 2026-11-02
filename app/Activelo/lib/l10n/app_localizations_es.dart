// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Activelo';

  @override
  String get paginaNoEncontrada => 'Página no encontrada';

  @override
  String get paginaNoExiste => 'La pantalla solicitada no existe.';

  @override
  String get volverAlInicio => 'Volver al Inicio';

  @override
  String get navInicio => 'Inicio';

  @override
  String get navHistorial => 'Historial';

  @override
  String get navAjustes => 'Ajustes';

  @override
  String get iniciarSesion => 'Iniciar Sesión';

  @override
  String get crearCuenta => 'CREAR CUENTA';

  @override
  String get registrate => 'Registrate';

  @override
  String get nombreCompleto => 'Nombre Completo';

  @override
  String get fechaNacimiento => 'Fecha de Nacimiento';

  @override
  String get correoElectronico => 'Correo Electrónico';

  @override
  String get contrasena => 'Contraseña';

  @override
  String get confirmarContrasena => 'Confirmar Contraseña';

  @override
  String get seleccionarFecha => 'Seleccionar fecha';

  @override
  String get seleccionaTuFechaNacimiento => 'SELECCIONÁ TU FECHA DE NACIMIENTO';

  @override
  String get errorFechaNacimiento =>
      'Por favor, seleccioná tu fecha de nacimiento.';

  @override
  String get errorNombreVacio => 'Ingresá tu nombre completo';

  @override
  String get errorCorreoVacio => 'Ingresá tu correo electrónico';

  @override
  String get errorCorreoInvalido => 'Ingresá un correo válido';

  @override
  String get errorContrasenaVacia => 'Ingresá tu contraseña';

  @override
  String get errorContrasenaCorta =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get errorContrasenasNoCoinciden => 'Las contraseñas no coinciden';

  @override
  String get subtituloLogin => 'Inicia sesión para comenzar tu rutina';

  @override
  String get subtituloRegistro =>
      'Crea tu cuenta para guardar tus entrenamientos';

  @override
  String get yaTenesCuenta => '¿Ya tenés una cuenta?';

  @override
  String get noTenesCuenta => '¿No tenés una cuenta?';

  @override
  String get alRegistrarteAceptas => 'Al registrarte, aceptás nuestros ';

  @override
  String get alIngresarAceptas => 'Al ingresar, aceptás nuestros ';

  @override
  String get terminosYPrivacidad => 'Términos y Privacidad';

  @override
  String get volverAlInicioSesion => 'Volver al Inicio de Sesión';

  @override
  String get entrenar => 'Entrenar';

  @override
  String holaEntrenador(Object nombre) {
    return '¡Hola, $nombre! 👋';
  }

  @override
  String get entrenador => 'Entrenador';

  @override
  String get usuarioActivo => 'Usuario Activo:';

  @override
  String get perfilPrincipal => 'Perfil Principal';

  @override
  String get cambiar => 'CAMBIAR';

  @override
  String get estadoDispositivo => 'Estado del dispositivo';

  @override
  String esp32Conectado(Object dispositivo) {
    return 'ESP32 Conectado ($dispositivo)';
  }

  @override
  String get esp32Desconectado => 'ESP32 desconectado';

  @override
  String get podBle => 'Pod BLE';

  @override
  String get mejor => 'Mejor';

  @override
  String get ultimoPromedio => 'Último Promedio';

  @override
  String get promedioGeneral => 'Promedio General';

  @override
  String ultimaSesionDe(Object nombre) {
    return 'Última sesión de $nombre';
  }

  @override
  String get ultimaSesion => 'Última sesión';

  @override
  String get toquesEnEstaSesion => 'Toques en esta sesión';

  @override
  String get mejorToqueDeLaSesion => 'Mejor toque de la sesión';

  @override
  String get accesosRapidos => 'Accesos rápidos';

  @override
  String get gestionarUsuarios => 'Gestionar Usuarios';

  @override
  String get vincularPodBle => 'Vincular Pod BLE';

  @override
  String get verHistorialTiempos => 'Ver historial de tiempos';

  @override
  String get configurarEntrenamiento => 'Configurar Entrenamiento';

  @override
  String get cantidadPodsActivos => 'Cantidad de Pods Activos';

  @override
  String get podsAUtilizar => 'Pods a utilizar:';

  @override
  String get seleccionaElModo => 'Selecciona el Modo';

  @override
  String get porRondas => 'Por Rondas';

  @override
  String get completaNumeroFijo => 'Completa un número fijo de toques';

  @override
  String get porTiempo => 'Por Tiempo';

  @override
  String get tocaMayorCantidad =>
      'Toca la mayor cantidad antes de que acabe el tiempo';

  @override
  String get modoBicolor => 'Modo Bicolor';

  @override
  String get desactivaColor1 => 'Desactiva Color 1 e ignora Color 2';

  @override
  String get modoManual => 'Modo Manual';

  @override
  String get controlaLuzDirectamente =>
      'Controlá la luz directamente desde la app';

  @override
  String get parametrosRondas => 'Parámetros de Rondas';

  @override
  String get parametrosTiempo => 'Parámetros de Tiempo';

  @override
  String get cantidadRondas => 'Cantidad de Rondas:';

  @override
  String get tiempoLimite => 'Tiempo Límite:';

  @override
  String get mensajeModoManual =>
      'En el Modo Manual podés encender y apagar el pod en cualquier momento tocando sus casillas.';

  @override
  String get tiempoLimiteColor2 => 'Tiempo Límite Color 2 (Distractor)';

  @override
  String get tiempoParaIgnorar => 'Tiempo para ignorar:';

  @override
  String get intervaloEntrePods => 'Intervalo entre Pods';

  @override
  String get pausaEntreToques => 'Pausa entre toques:';

  @override
  String get coloresBicolor => 'Colores Bicolor';

  @override
  String get colorLeds => 'Color de los LEDs';

  @override
  String get color1ATocar => 'Color 1 (A tocar)';

  @override
  String get color2NoTocar => 'Color 2 (NO tocar / Ignorar)';

  @override
  String get seleccionarColorBase => 'Seleccionar Color Base';

  @override
  String get ajusteColorRgb => 'Ajuste de Color RGB:';

  @override
  String get vistaPrevia => 'Vista previa:';

  @override
  String get intensidadLeds => 'Intensidad de los LEDs';

  @override
  String get brilloIntensidad => 'Brillo / Intensidad:';

  @override
  String get iniciarRutina => 'INICIAR RUTINA';

  @override
  String get errorBluetoothRequerido =>
      'Debés conectar el ESP32 por Bluetooth antes de iniciar la rutina.';

  @override
  String get conectar => 'CONECTAR';

  @override
  String get errorBicolorColoresIguales =>
      'En el Modo Bicolor debés seleccionar dos colores distintos.';

  @override
  String get aparatoListo => '¡Aparato Listo!';

  @override
  String get preparate => '¡Preparate!';

  @override
  String get atento => '¡Atento!';

  @override
  String tocaPodColor1(Object pod) {
    return '¡TOCÁ el Pod $pod! (Color 1)';
  }

  @override
  String noTocarColor2(Object pod) {
    return '¡NO TOCAR! (Color 2 en Pod $pod)';
  }

  @override
  String pasaManoPorPod(Object pod) {
    return '¡Pasa la mano por el Pod $pod!';
  }

  @override
  String get excelenteColorIgnorado => '¡Excelente! Color 2 ignorado.';

  @override
  String get tocaCuadradoEncender => 'Tocá un cuadrado para encender su Pod';

  @override
  String get seleccionaPodEncender => 'Seleccioná un Pod para encender';

  @override
  String get ledApagado => 'LED Apagado.';

  @override
  String toqueEnPod(Object pod, Object tiempo) {
    return '¡Toque en Pod $pod! ($tiempo s)';
  }

  @override
  String errorTocasteColor2(Object pod) {
    return '¡Error! Tocaste el Color 2 en Pod $pod';
  }

  @override
  String get desconectado => 'Desconectado';

  @override
  String get errorDesconexionMensaje =>
      'Se interrumpió la conexión Bluetooth con el Pod Central. La sesión se ha detenido.';

  @override
  String get entrenamientoFinalizado => '¡Entrenamiento Finalizado! 🏆';

  @override
  String usuario(Object nombre) {
    return 'Usuario: $nombre';
  }

  @override
  String toquesValidos(Object cantidad) {
    return 'Toques válidos: $cantidad';
  }

  @override
  String promedioSegundos(Object promedio) {
    return 'Promedio: $promedio s';
  }

  @override
  String erroresCometidos(Object errores) {
    return 'Errores cometidos: $errores';
  }

  @override
  String get anotacionesSesionOpcional => 'Anotaciones de la sesión (Opcional)';

  @override
  String get hintAnotaciones => 'Ej: Buena evolución, fatiga muscular, etc.';

  @override
  String get guardarYFinalizar => 'GUARDAR Y FINALIZAR';

  @override
  String modoManualToques(Object cantidad) {
    return 'Modo Manual (Toques: $cantidad)';
  }

  @override
  String tiempoRestanteToques(Object cantidad, Object tiempoRestante) {
    return 'Tiempo: ${tiempoRestante}s | Toques: $cantidad';
  }

  @override
  String bicolorRonda(Object rondaActual, Object rondasTotal) {
    return 'Bicolor | Ronda $rondaActual de $rondasTotal';
  }

  @override
  String rondaDe(Object rondaActual, Object rondasTotal) {
    return 'Ronda $rondaActual de $rondasTotal';
  }

  @override
  String tiempoRestante(Object tiempoRestante) {
    return 'TIEMPO RESTANTE: ${tiempoRestante}s';
  }

  @override
  String get ultimoTiempoValido => 'ÚLTIMO TIEMPO VÁLIDO';

  @override
  String get finalizarSesion => 'FINALIZAR SESIÓN';

  @override
  String get encendido => 'ENCENDIDO';

  @override
  String podLabel(Object num) {
    return 'POD $num';
  }

  @override
  String get conectarBluetooth => 'Conectar Bluetooth';

  @override
  String conectadoExitosamente(Object nombre) {
    return '¡Conectado exitosamente a $nombre!';
  }

  @override
  String errorAlConectar(Object error) {
    return 'Error al conectar: $error';
  }

  @override
  String get dispositivoDesconectado => 'Dispositivo desconectado';

  @override
  String get desconectar => 'Desconectar';

  @override
  String get conectado => 'Conectado';

  @override
  String get dispositivosDisponibles => 'Dispositivos disponibles:';

  @override
  String get buscandoPods => 'Buscando pods cercanos...';

  @override
  String get presionaBotonBuscar =>
      'Presioná el botón de abajo para buscar pods.';

  @override
  String get cancelarBusqueda => 'CANCELAR BÚSQUEDA';

  @override
  String get buscarDispositivos => 'BUSCAR DISPOSITIVOS';

  @override
  String get editarPerfil => 'Editar Perfil';

  @override
  String get perfilActualizado => 'Perfil actualizado correctamente';

  @override
  String get errorActualizarPerfil => 'Error al actualizar el perfil';

  @override
  String correoRestablecimientoEnviado(Object email) {
    return 'Enviamos un correo a $email para restablecer tu contraseña.';
  }

  @override
  String get errorCorreoRestablecimiento =>
      'Error al enviar el correo de restablecimiento.';

  @override
  String get subirFotoPerfil => 'Subir foto de perfil';

  @override
  String get cambiarFotoPerfil => 'Cambiar foto de perfil';

  @override
  String get eliminarFoto => 'Eliminar foto';

  @override
  String get informacionPersonal => 'INFORMACIÓN PERSONAL';

  @override
  String get correoNoModificable =>
      'El correo no se puede modificar directamente.';

  @override
  String get seguridad => 'SEGURIDAD';

  @override
  String get solicitarRestablecerContrasena =>
      'Solicitá un enlace por correo para restablecer o cambiar tu contraseña actual.';

  @override
  String get cambiarContrasena => 'CAMBIAR CONTRASEÑA';

  @override
  String get guardarCambios => 'GUARDAR CAMBIOS';

  @override
  String get gestionDeUsuarios => 'Gestión de Usuarios';

  @override
  String get agregar => 'Agregar';

  @override
  String get eliminarUsuario => 'Eliminar Usuario';

  @override
  String confirmarEliminarUsuario(Object nombre) {
    return '¿Estás seguro de que deseas eliminar el perfil de \"$nombre\"?';
  }

  @override
  String get cancelar => 'CANCELAR';

  @override
  String get eliminar => 'ELIMINAR';

  @override
  String get nuevoUsuario => 'Nuevo Usuario';

  @override
  String get editarUsuario => 'Editar Usuario';

  @override
  String get subirFoto => 'Subir foto';

  @override
  String get cambiarFoto => 'Cambiar foto';

  @override
  String get notasObservaciones => 'Notas / Observaciones';

  @override
  String get guardar => 'GUARDAR';

  @override
  String get mejorPromedio => 'Mejor Promedio';

  @override
  String get mejorTiempo => 'Mejor Tiempo';

  @override
  String get mejorUltimaSesion => 'Mejor (Últ. Sesión)';

  @override
  String get promedioUltimaSesion => 'Prom. (Últ. Sesión)';

  @override
  String get iniciaSesionParaGestionar =>
      'Iniciá sesión para gestionar perfiles.';

  @override
  String get perfilPrincipalPropietario => 'Perfil Principal (Propietario)';

  @override
  String get sinNombre => 'Sin nombre';

  @override
  String get cuentaPrincipal => 'Cuenta Principal';

  @override
  String get instruccionGestionUsuarios =>
      'Seleccioná el usuario que entrenará en esta sesión.';

  @override
  String get usuarioRegistrado => 'Usuario registrado';

  @override
  String get ajustes => 'Ajustes y Configuración';

  @override
  String felizCumpleanos(Object nombre) {
    return '¡Feliz Cumpleaños, $nombre! 🎂';
  }

  @override
  String get mensajeCumpleanos =>
      '¡Todo el equipo de Activelo te desea un excelente día de entrenamiento!';

  @override
  String get perfilYModoDeUso => 'PERFIL Y MODO DE USO';

  @override
  String get modoProfesional => 'Modo Profesional';

  @override
  String get modoProfesionalDesc =>
      'Habilita la gestión de múltiples usuarios y notas de sesión.';

  @override
  String get aparienciaTema => 'APARIENCIA Y TEMA';

  @override
  String get modoOscuro => 'Modo Oscuro';

  @override
  String get cambiarTemaClaroOscuro => 'Cambiar entre tema claro y oscuro';

  @override
  String get idioma => 'Idioma';

  @override
  String get sonidoRetroalimentacion => 'SONIDO Y RETROALIMENTACIÓN';

  @override
  String get efectosSonido => 'Efectos de Sonido';

  @override
  String get reproducirSonidosRutina =>
      'Reproducir sonidos al iniciar y finalizar la rutina';

  @override
  String get cuentaPerfil => 'CUENTA Y PERFIL';

  @override
  String get actualizaInformacionPersonal =>
      'Actualiza tu información personal';

  @override
  String get dispositivosBluetooth => 'Dispositivos Bluetooth';

  @override
  String get administrarConexiones => 'Administrar conexiones y escaneo';

  @override
  String get informacion => 'INFORMACIÓN';

  @override
  String get versionApp => 'Versión 1.0.0';

  @override
  String get cerrarSesion => 'Cerrar Sesión';

  @override
  String get historialSesiones => 'Historial de Sesiones';

  @override
  String get historialIniciaSesion =>
      'Debés iniciar sesión para ver tu historial.';

  @override
  String get sinSesionesRegistradas => 'Aún no tenés sesiones registradas.';

  @override
  String get noHaySesionesUsuario => 'No hay sesiones para este usuario.';

  @override
  String get anotacionesDeLaSesion => 'Anotaciones de la Sesión';

  @override
  String get observacionesDeLaSesion => 'Observaciones de la sesión';

  @override
  String get todos => 'Todos';

  @override
  String toquesCount(Object count) {
    return '$count toques';
  }

  @override
  String get mejorToque => 'Mejor Toque';

  @override
  String get promedio => 'Promedio';

  @override
  String get errores => 'Errores';

  @override
  String get sinAnotaciones => 'Sin anotaciones ingresadas.';

  @override
  String get desglosePorToqueValido => 'Desglose por toque válido:';

  @override
  String get legalesYPrivacidad => 'Legales y Privacidad';

  @override
  String get terminosDeUso => 'Términos de Uso';

  @override
  String get privacidad => 'Privacidad';

  @override
  String get terminosYCondicionesDeUso => 'Términos y Condiciones de Uso';

  @override
  String get ultimaActualizacion => 'Última actualización: 2026';

  @override
  String get tituloTerminos1 => '1. Aceptación de los Términos';

  @override
  String get textoTerminos1 =>
      'Al descargar, registrarte o utilizar la aplicación Activelo, aceptas quedar vinculado por estos Términos y Condiciones. Si no estás de acuerdo con alguno de ellos, debes abstenerte de utilizar la plataforma.';

  @override
  String get tituloTerminos2 => '2. Descripción del Servicio';

  @override
  String get textoTerminos2 =>
      'Activelo es una plataforma diseñada para la configuración, control y seguimiento de rutinas de entrenamiento físico y agilidad mediante interacción con dispositivos interactivos inalámbricos.';

  @override
  String get tituloTerminos3 => '3. Cuentas de Usuario';

  @override
  String get textoTerminos3 =>
      'Para acceder a la sincronización de tu historial y estadísticas de rendimiento, debes registrar una cuenta con un correo electrónico válido. Eres el único responsable de mantener la confidencialidad de tus credenciales.';

  @override
  String get tituloTerminos4 => '4. Responsabilidad y Salud Física';

  @override
  String get textoTerminos4 =>
      'El uso de la aplicación implica la realización de actividad física. Activelo no proporciona asesoramiento médico. Se recomienda realizar una entrada en calor adecuada y suspender el entrenamiento ante cualquier molestia física.';

  @override
  String get tituloTerminos5 => '5. Uso del Hardware e Interacción Inalámbrica';

  @override
  String get textoTerminos5 =>
      'La app requiere conectividad inalámbrica para operar con los pods de entrenamiento. El usuario es responsable de operar los dispositivos en un entorno seguro y adecuado.';

  @override
  String get tituloTerminos6 => '6. Modificaciones de la Plataforma';

  @override
  String get textoTerminos6 =>
      'Nos reservamos el derecho de modificar o discontinuar funciones del servicio, así como de actualizar estos términos en cualquier momento.';

  @override
  String get politicaPrivacidad => 'Política de Privacidad';

  @override
  String get tituloPrivacidad1 => '1. Información Recopilada';

  @override
  String get textoPrivacidad1 =>
      'Únicamente recopilamos los datos esenciales para prestar el servicio:\n• Datos de identificación: Correo electrónico de registro.\n• Métricas de entrenamiento: Tiempos de reacción, cantidad de toques, modos utilizados y fechas de cada sesión.';

  @override
  String get tituloPrivacidad2 => '2. Permisos Requeridos';

  @override
  String get textoPrivacidad2 =>
      'Para vincular y transmitir las rutinas a los dispositivos de entrenamiento, la aplicación solicitará permisos de conexión inalámbrica (Bluetooth) y ubicación en los casos exigidos por el sistema operativo.';

  @override
  String get tituloPrivacidad3 => '3. Uso de la Información';

  @override
  String get textoPrivacidad3 =>
      'Los datos almacenados se utilizan exclusivamente para permitir el acceso a tu cuenta, calcular tus estadísticas de rendimiento personal y mostrarte tu historial de progreso.';

  @override
  String get tituloPrivacidad4 => '4. Protección de Datos';

  @override
  String get textoPrivacidad4 =>
      'Implementamos medidas de seguridad para proteger tu información almacenada en la nube. No vendemos ni compartimos tus datos personales con terceros para fines comerciales o publicitarios.';

  @override
  String get tituloPrivacidad5 => '5. Eliminación de Datos';

  @override
  String get textoPrivacidad5 =>
      'Tienes derecho a solicitar la baja definitiva de tu cuenta y la eliminación total de tus registros de entrenamiento en cualquier momento.';
}
