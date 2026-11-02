// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Attivalo';

  @override
  String get paginaNoEncontrada => 'Pagina non trovata';

  @override
  String get paginaNoExiste => 'La schermata richiesta non esiste.';

  @override
  String get volverAlInicio => 'Ritorno a casa';

  @override
  String get navInicio => 'Inizio';

  @override
  String get navHistorial => 'Documentazione';

  @override
  String get navAjustes => 'Impostazioni';

  @override
  String get iniciarSesion => 'Login';

  @override
  String get crearCuenta => 'CREARE UN ACCOUNT';

  @override
  String get registrate => 'Registro';

  @override
  String get nombreCompleto => 'Nome e cognome';

  @override
  String get fechaNacimiento => 'Data di nascita';

  @override
  String get correoElectronico => 'E-mail';

  @override
  String get contrasena => 'Password';

  @override
  String get confirmarContrasena => 'Conferma password';

  @override
  String get seleccionarFecha => 'Seleziona la data';

  @override
  String get seleccionaTuFechaNacimiento => 'SELEZIONA LA TUA DATA DI NASCITA';

  @override
  String get errorFechaNacimiento => 'Seleziona la tua data di nascita.';

  @override
  String get errorNombreVacio => 'Inserisci il tuo nome completo';

  @override
  String get errorCorreoVacio => 'Inserisci la tua email';

  @override
  String get errorCorreoInvalido => 'Inserisci un\'e-mail valida';

  @override
  String get errorContrasenaVacia => 'Inserisci la tua password';

  @override
  String get errorContrasenaCorta =>
      'La password deve contenere almeno 6 caratteri';

  @override
  String get errorContrasenasNoCoinciden => 'Le password non corrispondono';

  @override
  String get subtituloLogin => 'Accedi per iniziare la tua routine';

  @override
  String get subtituloRegistro =>
      'Crea il tuo account per salvare i tuoi allenamenti';

  @override
  String get yaTenesCuenta => 'Hai già un account?';

  @override
  String get noTenesCuenta => 'Non hai un account?';

  @override
  String get alRegistrarteAceptas => 'Registrandoti accetti i ns';

  @override
  String get alIngresarAceptas => 'Entrando accetti la nostra';

  @override
  String get terminosYPrivacidad => 'Termini e Privacy';

  @override
  String get volverAlInicioSesion => 'Torna all\'accesso';

  @override
  String get entrenar => 'Treno';

  @override
  String holaEntrenador(Object nombre) {
    return 'Ciao, $nombre! 👋';
  }

  @override
  String get entrenador => 'Allenatore';

  @override
  String get usuarioActivo => 'Utente attivo:';

  @override
  String get perfilPrincipal => 'Profilo principale';

  @override
  String get cambiar => 'MODIFICA';

  @override
  String get estadoDispositivo => 'Stato del dispositivo';

  @override
  String esp32Conectado(Object dispositivo) {
    return 'ESP32 connesso ($dispositivo)';
  }

  @override
  String get esp32Desconectado => 'ESP32 disconnesso';

  @override
  String get podBle => 'Pod BLE';

  @override
  String get mejor => 'Meglio';

  @override
  String get ultimoPromedio => 'Ultima media';

  @override
  String get promedioGeneral => 'Media generale';

  @override
  String ultimaSesionDe(Object nombre) {
    return 'Ultima sessione di $nombre';
  }

  @override
  String get ultimaSesion => 'Ultima sessione';

  @override
  String get toquesEnEstaSesion => 'Tocchi in questa sessione';

  @override
  String get mejorToqueDeLaSesion => 'Il miglior tocco della sessione';

  @override
  String get accesosRapidos => 'Accesso rapido';

  @override
  String get gestionarUsuarios => 'Gestisci utenti';

  @override
  String get vincularPodBle => 'Collegare il pod BLE';

  @override
  String get verHistorialTiempos => 'Visualizza la cronologia temporale';

  @override
  String get configurarEntrenamiento => 'Imposta la formazione';

  @override
  String get cantidadPodsActivos => 'Numero di pod attivi';

  @override
  String get podsAUtilizar => 'Pod da utilizzare:';

  @override
  String get seleccionaElModo => 'Seleziona la modalità';

  @override
  String get porRondas => 'Per turni';

  @override
  String get completaNumeroFijo => 'Completa un numero fisso di tocchi';

  @override
  String get porTiempo => 'Per tempo';

  @override
  String get tocaMayorCantidad =>
      'Toccane il maggior numero possibile prima che scada il tempo';

  @override
  String get modoBicolor => 'Modalità a due colori';

  @override
  String get desactivaColor1 => 'Disabilita Colore 1 e ignora Colore 2';

  @override
  String get modoManual => 'Modalità manuale';

  @override
  String get controlaLuzDirectamente =>
      'Controlla la luce direttamente dall\'app';

  @override
  String get parametrosRondas => 'Parametri rotondi';

  @override
  String get parametrosTiempo => 'Parametri temporali';

  @override
  String get cantidadRondas => 'Numero di round:';

  @override
  String get tiempoLimite => 'Limite di tempo:';

  @override
  String get mensajeModoManual =>
      'In modalità manuale puoi accendere e spegnere il pod in qualsiasi momento toccando le sue caselle.';

  @override
  String get tiempoLimiteColor2 => 'Colore limite temporale 2 (distrattore)';

  @override
  String get tiempoParaIgnorar => 'È ora di ignorare:';

  @override
  String get intervaloEntrePods => 'Intervallo tra i pod';

  @override
  String get pausaEntreToques => 'Pausa tra i tocchi:';

  @override
  String get coloresBicolor => 'Colori bicolore';

  @override
  String get colorLeds => 'Colore LED';

  @override
  String get color1ATocar => 'Colore 1 (da riprodurre)';

  @override
  String get color2NoTocar => 'Colore 2 (NON toccare/Ignorare)';

  @override
  String get seleccionarColorBase => 'Seleziona Colore base';

  @override
  String get ajusteColorRgb => 'Regolazione colore RGB:';

  @override
  String get vistaPrevia => 'Anteprima:';

  @override
  String get intensidadLeds => 'Intensità del LED';

  @override
  String get brilloIntensidad => 'Luminosità/Intensità:';

  @override
  String get iniciarRutina => 'INIZIA LA ROUTINE';

  @override
  String get errorBluetoothRequerido =>
      'È necessario connettere l\'ESP32 tramite Bluetooth prima di avviare la routine.';

  @override
  String get conectar => 'COLLEGARE';

  @override
  String get errorBicolorColoresIguales =>
      'Nella modalità Bicolore è necessario selezionare due colori diversi.';

  @override
  String get aparatoListo => 'Dispositivo pronto!';

  @override
  String get preparate => 'Preparati!';

  @override
  String get atento => 'Attento!';

  @override
  String tocaPodColor1(Object pod) {
    return 'TOUCH Pod $pod! (Colore 1)';
  }

  @override
  String noTocarColor2(Object pod) {
    return 'NON TOCCARE! (Colore 2 nel contenitore $pod)';
  }

  @override
  String pasaManoPorPod(Object pod) {
    return 'Passa la mano attraverso il Pod $pod!';
  }

  @override
  String get excelenteColorIgnorado => 'Eccellente! Colore 2 ignorato.';

  @override
  String get tocaCuadradoEncender => 'Tocca un quadrato per accendere il Pod';

  @override
  String get seleccionaPodEncender => 'Seleziona un pod da accendere';

  @override
  String get ledApagado => 'LED spento.';

  @override
  String toqueEnPod(Object pod, Object tiempo) {
    return 'Tocca Pod $pod! (${tiempo}s)';
  }

  @override
  String errorTocasteColor2(Object pod) {
    return 'Errore! Hai giocato a Colore 2 nel Pod $pod';
  }

  @override
  String get desconectado => 'Non in linea';

  @override
  String get errorDesconexionMensaje =>
      'La connessione Bluetooth al Pod Central è stata interrotta. La sessione è stata interrotta.';

  @override
  String get entrenamientoFinalizado => 'Formazione terminata! 🏆';

  @override
  String usuario(Object nombre) {
    return 'Utente: $nombre';
  }

  @override
  String toquesValidos(Object cantidad) {
    return 'Tocchi validi: $cantidad';
  }

  @override
  String promedioSegundos(Object promedio) {
    return 'Media: $promedio secondi';
  }

  @override
  String erroresCometidos(Object errores) {
    return 'Errori commessi: $errores';
  }

  @override
  String get anotacionesSesionOpcional => 'Registri di sessione (facoltativo)';

  @override
  String get hintAnotaciones =>
      'Es: buona evoluzione, affaticamento muscolare, ecc.';

  @override
  String get guardarYFinalizar => 'SALVA E FINISCI';

  @override
  String modoManualToques(Object cantidad) {
    return 'Modalità manuale (Top: $cantidad)';
  }

  @override
  String tiempoRestanteToques(Object cantidad, Object tiempoRestante) {
    return 'Tempo: ${tiempoRestante}s | Tocchi: $cantidad';
  }

  @override
  String bicolorRonda(Object rondaActual, Object rondasTotal) {
    return 'Bicolore | Turno $rondaActual di $rondasTotal';
  }

  @override
  String rondaDe(Object rondaActual, Object rondasTotal) {
    return 'Turno $rondaActual di $rondasTotal';
  }

  @override
  String tiempoRestante(Object tiempoRestante) {
    return 'TEMPO RIMANENTE: ${tiempoRestante}s';
  }

  @override
  String get ultimoTiempoValido => 'ULTIMA ORA VALIDA';

  @override
  String get finalizarSesion => 'FINE SESSIONE';

  @override
  String get encendido => 'SU';

  @override
  String podLabel(Object num) {
    return 'POD$num';
  }

  @override
  String get conectarBluetooth => 'Connetti Bluetooth';

  @override
  String conectadoExitosamente(Object nombre) {
    return 'Connessione a $nombre riuscita!';
  }

  @override
  String errorAlConectar(Object error) {
    return 'Errore di connessione: $error';
  }

  @override
  String get dispositivoDesconectado => 'Dispositivo disconnesso';

  @override
  String get desconectar => 'Disconnetti';

  @override
  String get conectado => 'Collegato';

  @override
  String get dispositivosDisponibles => 'Dispositivi disponibili:';

  @override
  String get buscandoPods => 'Ricerca di pod nelle vicinanze...';

  @override
  String get presionaBotonBuscar =>
      'Premi il pulsante qui sotto per cercare i pod.';

  @override
  String get cancelarBusqueda => 'ANNULLA RICERCA';

  @override
  String get buscarDispositivos => 'DISPOSITIVI DI RICERCA';

  @override
  String get editarPerfil => 'Modifica profilo';

  @override
  String get perfilActualizado => 'Profilo aggiornato con successo';

  @override
  String get errorActualizarPerfil =>
      'Errore durante l\'aggiornamento del profilo';

  @override
  String correoRestablecimientoEnviado(Object email) {
    return 'Inviamo un\'email a $email per reimpostare la tua password.';
  }

  @override
  String get errorCorreoRestablecimiento =>
      'Errore nell\'invio dell\'e-mail di reimpostazione.';

  @override
  String get subirFotoPerfil => 'Carica la foto del profilo';

  @override
  String get cambiarFotoPerfil => 'Cambia foto del profilo';

  @override
  String get eliminarFoto => 'Elimina foto';

  @override
  String get informacionPersonal => 'INFORMAZIONI PERSONALI';

  @override
  String get correoNoModificable =>
      'L\'e-mail non può essere modificata direttamente.';

  @override
  String get seguridad => 'SICUREZZA';

  @override
  String get solicitarRestablecerContrasena =>
      'Richiedi un collegamento via e-mail per reimpostare o modificare la password attuale.';

  @override
  String get cambiarContrasena => 'CAMBIARE LA PASSWORD';

  @override
  String get guardarCambios => 'SALVA MODIFICHE';

  @override
  String get gestionDeUsuarios => 'Gestione utenti';

  @override
  String get agregar => 'Aggiungere';

  @override
  String get eliminarUsuario => 'Elimina utente';

  @override
  String confirmarEliminarUsuario(Object nombre) {
    return 'Sei sicuro di voler eliminare il profilo di \"$nombre\"?';
  }

  @override
  String get cancelar => 'CANCELLARE';

  @override
  String get eliminar => 'ELIMINARE';

  @override
  String get nuevoUsuario => 'Nuovo utente';

  @override
  String get editarUsuario => 'Modifica utente';

  @override
  String get subirFoto => 'Carica foto';

  @override
  String get cambiarFoto => 'Cambia foto';

  @override
  String get notasObservaciones => 'Note/Osservazioni';

  @override
  String get guardar => 'MANTENERE';

  @override
  String get mejorPromedio => 'Miglior media';

  @override
  String get mejorTiempo => 'Miglior tempo';

  @override
  String get mejorUltimaSesion => 'Migliore (ultima sessione)';

  @override
  String get promedioUltimaSesion => 'Media (Ultima sessione)';

  @override
  String get iniciaSesionParaGestionar => 'Accedi per gestire i profili.';

  @override
  String get perfilPrincipalPropietario => 'Profilo principale (proprietario)';

  @override
  String get sinNombre => 'Senza nome';

  @override
  String get cuentaPrincipal => 'Conto principale';

  @override
  String get instruccionGestionUsuarios =>
      'Seleziona l\'utente che si allenerà in questa sessione.';

  @override
  String get usuarioRegistrado => 'Utente registrato';

  @override
  String get ajustes => 'Impostazioni e configurazione';

  @override
  String felizCumpleanos(Object nombre) {
    return 'Buon compleanno, $nombre! 🎂';
  }

  @override
  String get mensajeCumpleanos =>
      'Tutto il team Activelo vi augura un\'ottima giornata di formazione!';

  @override
  String get perfilYModoDeUso => 'PROFILO E MODALITÀ DI UTILIZZO';

  @override
  String get modoProfesional => 'Modalità professionale';

  @override
  String get modoProfesionalDesc =>
      'Consente la gestione di più utenti e note di sessione.';

  @override
  String get aparienciaTema => 'ASPETTO E TEMA';

  @override
  String get modoOscuro => 'Modalità oscura';

  @override
  String get cambiarTemaClaroOscuro =>
      'Passa dal tema chiaro a quello scuro e viceversa';

  @override
  String get idioma => 'Lingua';

  @override
  String get sonidoRetroalimentacion => 'SUONO E FEEDBACK';

  @override
  String get efectosSonido => 'Effetti sonori';

  @override
  String get reproducirSonidosRutina =>
      'Riproduci suoni all\'inizio e alla fine della routine';

  @override
  String get cuentaPerfil => 'ACCOUNT E PROFILO';

  @override
  String get actualizaInformacionPersonal =>
      'Aggiorna le tue informazioni personali';

  @override
  String get dispositivosBluetooth => 'Dispositivi Bluetooth';

  @override
  String get administrarConexiones => 'Gestisci connessioni e scansioni';

  @override
  String get informacion => 'INFORMAZIONI';

  @override
  String get versionApp => 'Versione 1.0.0';

  @override
  String get cerrarSesion => 'Disconnessione';

  @override
  String get historialSesiones => 'Cronologia della sessione';

  @override
  String get historialIniciaSesion =>
      'Devi effettuare il login per visualizzare la tua cronologia.';

  @override
  String get sinSesionesRegistradas => 'Non hai ancora sessioni registrate.';

  @override
  String get noHaySesionesUsuario =>
      'Non sono presenti sessioni per questo utente.';

  @override
  String get anotacionesDeLaSesion => 'Note sulla sessione';

  @override
  String get observacionesDeLaSesion => 'Osservazioni della sessione';

  @override
  String get todos => 'Tutto';

  @override
  String toquesCount(Object count) {
    return '$count tocca';
  }

  @override
  String get mejorToque => 'Tocco migliore';

  @override
  String get promedio => 'Media';

  @override
  String get errores => 'Errori';

  @override
  String get sinAnotaciones => 'Nessuna annotazione inserita.';

  @override
  String get desglosePorToqueValido => 'Ripartizione per tocco valido:';

  @override
  String get legalesYPrivacidad => 'Legale e Privacy';

  @override
  String get terminosDeUso => 'Termini di utilizzo';

  @override
  String get privacidad => 'Privacy';

  @override
  String get terminosYCondicionesDeUso => 'Termini e condizioni d\'uso';

  @override
  String get ultimaActualizacion => 'Ultimo aggiornamento: 2026';

  @override
  String get tituloTerminos1 => '1. Accettazione dei Termini';

  @override
  String get textoTerminos1 =>
      'Scaricando, registrandoti o utilizzando l\'applicazione Activelo, accetti di essere vincolato dai presenti Termini e Condizioni. Se non sei d\'accordo con nessuno di essi, devi astenerti dall\'utilizzare la piattaforma.';

  @override
  String get tituloTerminos2 => '2. Descrizione del servizio';

  @override
  String get textoTerminos2 =>
      'Activelo è una piattaforma progettata per la configurazione, il controllo e il monitoraggio di routine di allenamento fisico e di agilità attraverso l\'interazione con dispositivi interattivi wireless.';

  @override
  String get tituloTerminos3 => '3. Account utente';

  @override
  String get textoTerminos3 =>
      'Per accedere alla sincronizzazione della cronologia e delle statistiche sulle prestazioni, è necessario registrare un account con un\'e-mail valida. Sei l\'unico responsabile del mantenimento della riservatezza delle tue credenziali.';

  @override
  String get tituloTerminos4 => '4. Responsabilità e salute fisica';

  @override
  String get textoTerminos4 =>
      'L\'utilizzo dell\'applicazione implica lo svolgimento di attività fisica. Activelo non fornisce consulenza medica. Si consiglia di effettuare un adeguato riscaldamento e di sospendere l\'allenamento in caso di disturbi fisici.';

  @override
  String get tituloTerminos5 =>
      '5. Utilizzo dell\'hardware e interazione wireless';

  @override
  String get textoTerminos5 =>
      'L\'app richiede la connettività wireless per funzionare con i pod di addestramento. L\'utente è responsabile dell\'utilizzo dei dispositivi in ​​un ambiente sicuro e appropriato.';

  @override
  String get tituloTerminos6 => '6. Modifiche alla piattaforma';

  @override
  String get textoTerminos6 =>
      'Ci riserviamo il diritto di modificare o interrompere le funzionalità del Servizio e di aggiornare i presenti Termini in qualsiasi momento.';

  @override
  String get politicaPrivacidad => 'politica sulla riservatezza';

  @override
  String get tituloPrivacidad1 => '1. Informazioni raccolte';

  @override
  String get textoPrivacidad1 =>
      'Raccogliamo solo dati essenziali per fornire il servizio:\n• Dati identificativi: email di registrazione.\n• Metriche di allenamento: tempi di reazione, numero di tocchi, modalità utilizzate e date di ogni sessione.';

  @override
  String get tituloPrivacidad2 => '2. Autorizzazioni richieste';

  @override
  String get textoPrivacidad2 =>
      'Per collegare e trasmettere le routine ai dispositivi di allenamento, l\'applicazione richiederà la connessione wireless (Bluetooth) e le autorizzazioni di localizzazione nei casi richiesti dal sistema operativo.';

  @override
  String get tituloPrivacidad3 => '3. Utilizzo delle informazioni';

  @override
  String get textoPrivacidad3 =>
      'I dati memorizzati vengono utilizzati esclusivamente per consentire l\'accesso al tuo account, calcolare le statistiche sulle prestazioni personali e mostrarti la cronologia dei progressi.';

  @override
  String get tituloPrivacidad4 => '4. Protezione dei dati';

  @override
  String get textoPrivacidad4 =>
      'Implementiamo misure di sicurezza per proteggere le tue informazioni archiviate nel cloud. Non vendiamo né condividiamo i tuoi dati personali con terzi per scopi commerciali o pubblicitari.';

  @override
  String get tituloPrivacidad5 => '5. Eliminación de Datos';

  @override
  String get textoPrivacidad5 =>
      'Tienes derecho a solicitar la baja definitiva de tu cuenta y la eliminación total de tus registros de entrenamiento en cualquier momento.';
}
