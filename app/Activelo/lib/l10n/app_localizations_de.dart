// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Activelo';

  @override
  String get paginaNoEncontrada => 'Seite nicht gefunden';

  @override
  String get paginaNoExiste => 'Der angeforderte Bildschirm existiert nicht.';

  @override
  String get volverAlInicio => 'Zurück nach Hause';

  @override
  String get navInicio => 'Start';

  @override
  String get navHistorial => 'Aufzeichnen';

  @override
  String get navAjustes => 'Einstellungen';

  @override
  String get iniciarSesion => 'Login';

  @override
  String get crearCuenta => 'BENUTZERKONTO ERSTELLEN';

  @override
  String get registrate => 'Registrieren';

  @override
  String get nombreCompleto => 'Vollständiger Name';

  @override
  String get fechaNacimiento => 'Geburtsdatum';

  @override
  String get correoElectronico => 'E-Mail';

  @override
  String get contrasena => 'Passwort';

  @override
  String get confirmarContrasena => 'Passwort bestätigen';

  @override
  String get seleccionarFecha => 'Datum auswählen';

  @override
  String get seleccionaTuFechaNacimiento => 'WÄHLEN SIE IHR GEBURTSDATUM';

  @override
  String get errorFechaNacimiento => 'Bitte wählen Sie Ihr Geburtsdatum aus.';

  @override
  String get errorNombreVacio => 'Geben Sie Ihren vollständigen Namen ein';

  @override
  String get errorCorreoVacio => 'Geben Sie Ihre E-Mail-Adresse ein';

  @override
  String get errorCorreoInvalido => 'Geben Sie eine gültige E-Mail-Adresse ein';

  @override
  String get errorContrasenaVacia => 'Geben Sie Ihr Passwort ein';

  @override
  String get errorContrasenaCorta =>
      'Das Passwort muss mindestens 6 Zeichen lang sein';

  @override
  String get errorContrasenasNoCoinciden => 'Passwörter stimmen nicht überein';

  @override
  String get subtituloLogin =>
      'Melden Sie sich an, um mit Ihrer Routine zu beginnen';

  @override
  String get subtituloRegistro =>
      'Erstellen Sie Ihr Konto, um Ihre Trainingseinheiten zu speichern';

  @override
  String get yaTenesCuenta => 'Haben Sie bereits ein Konto?';

  @override
  String get noTenesCuenta => 'Sie haben noch kein Konto?';

  @override
  String get alRegistrarteAceptas =>
      'Mit der Registrierung erklären Sie sich mit unseren einverstanden';

  @override
  String get alIngresarAceptas => 'Mit Ihrer Eingabe akzeptieren Sie unsere';

  @override
  String get terminosYPrivacidad => 'Bedingungen und Datenschutz';

  @override
  String get volverAlInicioSesion => 'Zurück zur Anmeldung';

  @override
  String get entrenar => 'Zug';

  @override
  String holaEntrenador(Object nombre) {
    return 'Hallo, $nombre! 👋';
  }

  @override
  String get entrenador => 'Trainer';

  @override
  String get usuarioActivo => 'Aktiver Benutzer:';

  @override
  String get perfilPrincipal => 'Hauptprofil';

  @override
  String get cambiar => 'ÄNDERN';

  @override
  String get estadoDispositivo => 'Gerätestatus';

  @override
  String esp32Conectado(Object dispositivo) {
    return 'ESP32 verbunden ($dispositivo)';
  }

  @override
  String get esp32Desconectado => 'ESP32 getrennt';

  @override
  String get podBle => 'BLE-Pod';

  @override
  String get mejor => 'Besser';

  @override
  String get ultimoPromedio => 'Letzter Durchschnitt';

  @override
  String get promedioGeneral => 'Allgemeiner Durchschnitt';

  @override
  String ultimaSesionDe(Object nombre) {
    return 'Letzte Sitzung von $nombre';
  }

  @override
  String get ultimaSesion => 'Letzte Sitzung';

  @override
  String get toquesEnEstaSesion => 'Berührungen in dieser Sitzung';

  @override
  String get mejorToqueDeLaSesion => 'Beste Berührung der Sitzung';

  @override
  String get accesosRapidos => 'Schneller Zugriff';

  @override
  String get gestionarUsuarios => 'Benutzer verwalten';

  @override
  String get vincularPodBle => 'BLE-Pod verknüpfen';

  @override
  String get verHistorialTiempos => 'Zeitverlauf anzeigen';

  @override
  String get configurarEntrenamiento => 'Schulung einrichten';

  @override
  String get cantidadPodsActivos => 'Anzahl der aktiven Pods';

  @override
  String get podsAUtilizar => 'Zu verwendende Pods:';

  @override
  String get seleccionaElModo => 'Wählen Sie den Modus aus';

  @override
  String get porRondas => 'Nach Runden';

  @override
  String get completaNumeroFijo =>
      'Führen Sie eine festgelegte Anzahl an Berührungen durch';

  @override
  String get porTiempo => 'Nach Zeit';

  @override
  String get tocaMayorCantidad =>
      'Tippe so viele wie möglich an, bevor die Zeit abläuft';

  @override
  String get modoBicolor => 'Zweifarbenmodus';

  @override
  String get desactivaColor1 =>
      'Deaktivieren Sie Farbe 1 und ignorieren Sie Farbe 2';

  @override
  String get modoManual => 'Manueller Modus';

  @override
  String get controlaLuzDirectamente =>
      'Steuern Sie das Licht direkt über die App';

  @override
  String get parametrosRondas => 'Rundenparameter';

  @override
  String get parametrosTiempo => 'Zeitparameter';

  @override
  String get cantidadRondas => 'Anzahl der Runden:';

  @override
  String get tiempoLimite => 'Zeitlimit:';

  @override
  String get mensajeModoManual =>
      'Im manuellen Modus können Sie den Pod jederzeit ein- und ausschalten, indem Sie auf die Felder tippen.';

  @override
  String get tiempoLimiteColor2 => 'Zeitlimit-Farbe 2 (Distraktor)';

  @override
  String get tiempoParaIgnorar => 'Zeit zu ignorieren:';

  @override
  String get intervaloEntrePods => 'Intervall zwischen Pods';

  @override
  String get pausaEntreToques => 'Pause zwischen Berührungen:';

  @override
  String get coloresBicolor => 'Zweifarbige Farben';

  @override
  String get colorLeds => 'LED-Farbe';

  @override
  String get color1ATocar => 'Farbe 1 (zu spielen)';

  @override
  String get color2NoTocar => 'Farbe 2 (NICHT berühren/Ignorieren)';

  @override
  String get seleccionarColorBase => 'Wählen Sie Grundfarbe';

  @override
  String get ajusteColorRgb => 'RGB-Farbanpassung:';

  @override
  String get vistaPrevia => 'Vorschau:';

  @override
  String get intensidadLeds => 'LED-Intensität';

  @override
  String get brilloIntensidad => 'Helligkeit/Intensität:';

  @override
  String get iniciarRutina => 'START-ROUTINE';

  @override
  String get errorBluetoothRequerido =>
      'Sie müssen den ESP32 über Bluetooth verbinden, bevor Sie die Routine starten.';

  @override
  String get conectar => 'VERBINDEN';

  @override
  String get errorBicolorColoresIguales =>
      'Im Bicolor-Modus müssen Sie zwei verschiedene Farben auswählen.';

  @override
  String get aparatoListo => 'Gerät bereit!';

  @override
  String get preparate => 'Machen Sie sich bereit!';

  @override
  String get atento => 'Aufmerksam!';

  @override
  String tocaPodColor1(Object pod) {
    return 'TOUCH Pod $pod! (Farbe 1)';
  }

  @override
  String noTocarColor2(Object pod) {
    return 'NICHT BERÜHREN! (Farbe 2 in Pod $pod)';
  }

  @override
  String pasaManoPorPod(Object pod) {
    return 'Führen Sie Ihre Hand durch Pod $pod!';
  }

  @override
  String get excelenteColorIgnorado => 'Exzellent! Farbe 2 wird ignoriert.';

  @override
  String get tocaCuadradoEncender =>
      'Tippen Sie auf ein Quadrat, um Ihren Pod einzuschalten';

  @override
  String get seleccionaPodEncender =>
      'Wählen Sie einen Pod zum Einschalten aus';

  @override
  String get ledApagado => 'LED aus.';

  @override
  String toqueEnPod(Object pod, Object tiempo) {
    return 'Tippen Sie auf Pod $pod! (${tiempo}s)';
  }

  @override
  String errorTocasteColor2(Object pod) {
    return 'Fehler! Du hast Color 2 im Pod $pod gespielt';
  }

  @override
  String get desconectado => 'Offline';

  @override
  String get errorDesconexionMensaje =>
      'Die Bluetooth-Verbindung zum Pod Central wurde unterbrochen. Die Sitzung wurde beendet.';

  @override
  String get entrenamientoFinalizado => 'Training beendet! 🏆';

  @override
  String usuario(Object nombre) {
    return 'Benutzer: $nombre';
  }

  @override
  String toquesValidos(Object cantidad) {
    return 'Gültige Berührungen: $cantidad';
  }

  @override
  String promedioSegundos(Object promedio) {
    return 'Durchschnitt: $promedio s';
  }

  @override
  String erroresCometidos(Object errores) {
    return 'Fehler gemacht: $errores';
  }

  @override
  String get anotacionesSesionOpcional => 'Sitzungsprotokolle (optional)';

  @override
  String get hintAnotaciones =>
      'Beispiel: Gute Entwicklung, Muskelermüdung usw.';

  @override
  String get guardarYFinalizar => 'SPEICHERN UND FERTIGSTELLEN';

  @override
  String modoManualToques(Object cantidad) {
    return 'Manueller Modus (Tops: $cantidad)';
  }

  @override
  String tiempoRestanteToques(Object cantidad, Object tiempoRestante) {
    return 'Zeit: ${tiempoRestante}s | Berührungen: $cantidad';
  }

  @override
  String bicolorRonda(Object rondaActual, Object rondasTotal) {
    return 'Zweifarbig | Runde $rondaActual von $rondasTotal';
  }

  @override
  String rondaDe(Object rondaActual, Object rondasTotal) {
    return 'Runde $rondaActual von $rondasTotal';
  }

  @override
  String tiempoRestante(Object tiempoRestante) {
    return 'VERBLEIBENDE ZEIT: ${tiempoRestante}s';
  }

  @override
  String get ultimoTiempoValido => 'LETZTE GÜLTIGKEIT';

  @override
  String get finalizarSesion => 'SITZUNG BEENDEN';

  @override
  String get encendido => 'AN';

  @override
  String podLabel(Object num) {
    return 'POD $num';
  }

  @override
  String get conectarBluetooth => 'Verbinden Sie Bluetooth';

  @override
  String conectadoExitosamente(Object nombre) {
    return 'Erfolgreich mit $nombre verbunden!';
  }

  @override
  String errorAlConectar(Object error) {
    return 'Fehler beim Verbinden: $error';
  }

  @override
  String get dispositivoDesconectado => 'Gerät getrennt';

  @override
  String get desconectar => 'Trennen';

  @override
  String get conectado => 'Verbunden';

  @override
  String get dispositivosDisponibles => 'Verfügbare Geräte:';

  @override
  String get buscandoPods => 'Suche nach Pods in der Nähe...';

  @override
  String get presionaBotonBuscar =>
      'Klicken Sie auf die Schaltfläche unten, um nach Pods zu suchen.';

  @override
  String get cancelarBusqueda => 'SUCHE ABBRECHEN';

  @override
  String get buscarDispositivos => 'SUCHE GERÄTE';

  @override
  String get editarPerfil => 'Profil bearbeiten';

  @override
  String get perfilActualizado => 'Profil erfolgreich aktualisiert';

  @override
  String get errorActualizarPerfil => 'Fehler beim Aktualisieren des Profils';

  @override
  String correoRestablecimientoEnviado(Object email) {
    return 'Wir senden eine E-Mail an $email, um Ihr Passwort zurückzusetzen.';
  }

  @override
  String get errorCorreoRestablecimiento =>
      'Fehler beim Senden der Reset-E-Mail.';

  @override
  String get subirFotoPerfil => 'Profilfoto hochladen';

  @override
  String get cambiarFotoPerfil => 'Profilfoto ändern';

  @override
  String get eliminarFoto => 'Foto löschen';

  @override
  String get informacionPersonal => 'PERSÖNLICHE INFORMATIONEN';

  @override
  String get correoNoModificable =>
      'Die E-Mail kann nicht direkt geändert werden.';

  @override
  String get seguridad => 'SICHERHEIT';

  @override
  String get solicitarRestablecerContrasena =>
      'Fordern Sie per E-Mail einen Link an, um Ihr aktuelles Passwort zurückzusetzen oder zu ändern.';

  @override
  String get cambiarContrasena => 'KENNWORT ÄNDERN';

  @override
  String get guardarCambios => 'ÄNDERUNGEN SPEICHERN';

  @override
  String get gestionDeUsuarios => 'Benutzerverwaltung';

  @override
  String get agregar => 'Hinzufügen';

  @override
  String get eliminarUsuario => 'Benutzer löschen';

  @override
  String confirmarEliminarUsuario(Object nombre) {
    return 'Sind Sie sicher, dass Sie das Profil von „$nombre“ löschen möchten?';
  }

  @override
  String get cancelar => 'STORNIEREN';

  @override
  String get eliminar => 'BESEITIGEN';

  @override
  String get nuevoUsuario => 'Neuer Benutzer';

  @override
  String get editarUsuario => 'Benutzer bearbeiten';

  @override
  String get subirFoto => 'Foto hochladen';

  @override
  String get cambiarFoto => 'Foto ändern';

  @override
  String get notasObservaciones => 'Notizen / Beobachtungen';

  @override
  String get guardar => 'HALTEN';

  @override
  String get mejorPromedio => 'Bester Durchschnitt';

  @override
  String get mejorTiempo => 'Beste Zeit';

  @override
  String get mejorUltimaSesion => 'Am besten (Letzte Sitzung)';

  @override
  String get promedioUltimaSesion => 'Durchschn. (Letzte Sitzung)';

  @override
  String get iniciaSesionParaGestionar =>
      'Melden Sie sich an, um Profile zu verwalten.';

  @override
  String get perfilPrincipalPropietario => 'Hauptprofil (Inhaber)';

  @override
  String get sinNombre => 'Unbenannt';

  @override
  String get cuentaPrincipal => 'Hauptkonto';

  @override
  String get instruccionGestionUsuarios =>
      'Wählen Sie den Benutzer aus, der in dieser Sitzung trainieren soll.';

  @override
  String get usuarioRegistrado => 'Registrierter Benutzer';

  @override
  String get ajustes => 'Einstellungen und Konfiguration';

  @override
  String felizCumpleanos(Object nombre) {
    return 'Alles Gute zum Geburtstag, $nombre! 🎂';
  }

  @override
  String get mensajeCumpleanos =>
      'Das gesamte Activelo-Team wünscht Ihnen einen tollen Trainingstag!';

  @override
  String get perfilYModoDeUso => 'PROFIL UND NUTZUNGSART';

  @override
  String get modoProfesional => 'Professioneller Modus';

  @override
  String get modoProfesionalDesc =>
      'Ermöglicht die Verwaltung mehrerer Benutzer und Sitzungsnotizen.';

  @override
  String get aparienciaTema => 'ERSCHEINUNGSBILD UND THEMA';

  @override
  String get modoOscuro => 'Dunkler Modus';

  @override
  String get cambiarTemaClaroOscuro =>
      'Wechseln Sie zwischen hellem und dunklem Thema';

  @override
  String get idioma => 'Sprache';

  @override
  String get sonidoRetroalimentacion => 'SOUND UND FEEDBACK';

  @override
  String get efectosSonido => 'Soundeffekte';

  @override
  String get reproducirSonidosRutina =>
      'Spielen Sie beim Starten und Beenden der Routine Töne ab';

  @override
  String get cuentaPerfil => 'KONTO UND PROFIL';

  @override
  String get actualizaInformacionPersonal =>
      'Aktualisieren Sie Ihre persönlichen Daten';

  @override
  String get dispositivosBluetooth => 'Bluetooth-Geräte';

  @override
  String get administrarConexiones => 'Verwalten Sie Verbindungen und Scans';

  @override
  String get informacion => 'INFORMATION';

  @override
  String get versionApp => 'Version 1.0.0';

  @override
  String get cerrarSesion => 'Abmelden';

  @override
  String get historialSesiones => 'Sitzungsverlauf';

  @override
  String get historialIniciaSesion =>
      'Sie müssen sich anmelden, um Ihren Verlauf anzuzeigen.';

  @override
  String get sinSesionesRegistradas =>
      'Sie haben noch keine registrierten Sitzungen.';

  @override
  String get noHaySesionesUsuario =>
      'Für diesen Benutzer gibt es keine Sitzungen.';

  @override
  String get anotacionesDeLaSesion => 'Sitzungsnotizen';

  @override
  String get observacionesDeLaSesion => 'Sitzungsbeobachtungen';

  @override
  String get todos => 'Alle';

  @override
  String toquesCount(Object count) {
    return '$count berührt';
  }

  @override
  String get mejorToque => 'Bessere Berührung';

  @override
  String get promedio => 'Durchschnitt';

  @override
  String get errores => 'Fehler';

  @override
  String get sinAnotaciones => 'Keine Anmerkungen eingegeben.';

  @override
  String get desglosePorToqueValido =>
      'Aufschlüsselung nach gültiger Berührung:';

  @override
  String get legalesYPrivacidad => 'Recht und Datenschutz';

  @override
  String get terminosDeUso => 'Nutzungsbedingungen';

  @override
  String get privacidad => 'Privatsphäre';

  @override
  String get terminosYCondicionesDeUso => 'Nutzungsbedingungen';

  @override
  String get ultimaActualizacion => 'Letzte Aktualisierung: 2026';

  @override
  String get tituloTerminos1 => '1. Annahme der Bedingungen';

  @override
  String get textoTerminos1 =>
      'Durch das Herunterladen, Registrieren oder Verwenden der Activelo-Anwendung erklären Sie sich mit diesen Allgemeinen Geschäftsbedingungen einverstanden. Wenn Sie mit einer davon nicht einverstanden sind, müssen Sie die Nutzung der Plattform unterlassen.';

  @override
  String get tituloTerminos2 => '2. Leistungsbeschreibung';

  @override
  String get textoTerminos2 =>
      'Activelo ist eine Plattform zur Konfiguration, Steuerung und Überwachung von Körper- und Beweglichkeitstrainingsroutinen durch Interaktion mit drahtlosen interaktiven Geräten.';

  @override
  String get tituloTerminos3 => '3. Benutzerkonten';

  @override
  String get textoTerminos3 =>
      'Um auf die Synchronisierung Ihres Verlaufs und Ihrer Leistungsstatistiken zugreifen zu können, müssen Sie ein Konto mit einer gültigen E-Mail-Adresse registrieren. Sie allein sind für die Wahrung der Vertraulichkeit Ihrer Anmeldeinformationen verantwortlich.';

  @override
  String get tituloTerminos4 => '4. Verantwortung und körperliche Gesundheit';

  @override
  String get textoTerminos4 =>
      'Die Nutzung der Anwendung setzt die Ausübung körperlicher Aktivität voraus. Activelo bietet keine medizinische Beratung an. Es empfiehlt sich, sich ausreichend aufzuwärmen und bei körperlichen Beschwerden das Training zu unterbrechen.';

  @override
  String get tituloTerminos5 => '5. Hardwarenutzung und drahtlose Interaktion';

  @override
  String get textoTerminos5 =>
      'Für den Betrieb der App mit den Trainings-Pods ist eine drahtlose Verbindung erforderlich. Der Benutzer ist dafür verantwortlich, die Geräte in einer sicheren und angemessenen Umgebung zu betreiben.';

  @override
  String get tituloTerminos6 => '6. Plattformänderungen';

  @override
  String get textoTerminos6 =>
      'Wir behalten uns das Recht vor, Funktionen des Dienstes jederzeit zu ändern oder einzustellen und diese Bedingungen zu aktualisieren.';

  @override
  String get politicaPrivacidad => 'Datenschutzrichtlinie';

  @override
  String get tituloPrivacidad1 => '1. Gesammelte Informationen';

  @override
  String get textoPrivacidad1 =>
      'Wir erfassen nur die für die Bereitstellung des Dienstes erforderlichen Daten:\n• Identifikationsdaten: Registrierungs-E-Mail.\n• Trainingsmetriken: Reaktionszeiten, Anzahl der Berührungen, verwendete Modi und Daten jeder Sitzung.';

  @override
  String get tituloPrivacidad2 => '2. Erforderliche Berechtigungen';

  @override
  String get textoPrivacidad2 =>
      'Um die Routinen zu verknüpfen und an die Trainingsgeräte zu übertragen, fordert die Anwendung in den vom Betriebssystem erforderlichen Fällen eine drahtlose Verbindung (Bluetooth) und Standortberechtigungen an.';

  @override
  String get tituloPrivacidad3 => '3. Nutzung der Informationen';

  @override
  String get textoPrivacidad3 =>
      'Die gespeicherten Daten werden ausschließlich dazu verwendet, den Zugriff auf Ihr Konto zu ermöglichen, Ihre persönlichen Leistungsstatistiken zu berechnen und Ihnen Ihren Fortschrittsverlauf anzuzeigen.';

  @override
  String get tituloPrivacidad4 => '4. Datenschutz';

  @override
  String get textoPrivacidad4 =>
      'Wir implementieren Sicherheitsmaßnahmen, um Ihre in der Cloud gespeicherten Informationen zu schützen. Wir verkaufen oder geben Ihre personenbezogenen Daten nicht zu kommerziellen oder Werbezwecken an Dritte weiter.';

  @override
  String get tituloPrivacidad5 => '5. Datenlöschung';

  @override
  String get textoPrivacidad5 =>
      'Sie haben jederzeit das Recht, die dauerhafte Löschung Ihres Kontos und die vollständige Löschung Ihrer Schulungsunterlagen zu verlangen.';

  @override
  String get errorCredencialesIncorrectas => 'E-Mail/Passwort falsch';
}
