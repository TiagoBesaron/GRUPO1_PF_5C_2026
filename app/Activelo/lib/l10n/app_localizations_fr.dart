// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Activelo';

  @override
  String get paginaNoEncontrada => 'Page introuvable';

  @override
  String get paginaNoExiste => 'L\'écran demandé n\'existe pas.';

  @override
  String get volverAlInicio => 'Retour à la maison';

  @override
  String get navInicio => 'Commencer';

  @override
  String get navHistorial => 'Enregistrer';

  @override
  String get navAjustes => 'Paramètres';

  @override
  String get iniciarSesion => 'Se connecter';

  @override
  String get crearCuenta => 'CRÉER UN COMPTE';

  @override
  String get registrate => 'Registre';

  @override
  String get nombreCompleto => 'Nom et prénom';

  @override
  String get fechaNacimiento => 'Date de naissance';

  @override
  String get correoElectronico => 'E-mail';

  @override
  String get contrasena => 'Mot de passe';

  @override
  String get confirmarContrasena => 'Confirmez le mot de passe';

  @override
  String get seleccionarFecha => 'Sélectionnez une date';

  @override
  String get seleccionaTuFechaNacimiento =>
      'CHOISISSEZ VOTRE DATE DE NAISSANCE';

  @override
  String get errorFechaNacimiento =>
      'Veuillez sélectionner votre date de naissance.';

  @override
  String get errorNombreVacio => 'Entrez votre nom complet';

  @override
  String get errorCorreoVacio => 'Entrez votre email';

  @override
  String get errorCorreoInvalido => 'Entrez un email valide';

  @override
  String get errorContrasenaVacia => 'Entrez votre mot de passe';

  @override
  String get errorContrasenaCorta =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get errorContrasenasNoCoinciden =>
      'Les mots de passe ne correspondent pas';

  @override
  String get subtituloLogin => 'Connectez-vous pour démarrer votre routine';

  @override
  String get subtituloRegistro =>
      'Créez votre compte pour sauvegarder vos entraînements';

  @override
  String get yaTenesCuenta => 'Avez-vous déjà un compte ?';

  @override
  String get noTenesCuenta => 'Vous n\'avez pas de compte ?';

  @override
  String get alRegistrarteAceptas => 'En vous inscrivant, vous acceptez notre';

  @override
  String get alIngresarAceptas => 'En participant, vous acceptez notre';

  @override
  String get terminosYPrivacidad => 'Conditions et confidentialité';

  @override
  String get volverAlInicioSesion => 'Revenir à la connexion';

  @override
  String get entrenar => 'Former';

  @override
  String holaEntrenador(Object nombre) {
    return 'Bonjour, $nombre ! 👋';
  }

  @override
  String get entrenador => 'Entraîneur';

  @override
  String get usuarioActivo => 'Utilisateur actif :';

  @override
  String get perfilPrincipal => 'Profil principal';

  @override
  String get cambiar => 'CHANGEMENT';

  @override
  String get estadoDispositivo => 'État de l\'appareil';

  @override
  String esp32Conectado(Object dispositivo) {
    return 'ESP32 connecté ($dispositivo)';
  }

  @override
  String get esp32Desconectado => 'ESP32 déconnecté';

  @override
  String get podBle => 'Pod BLE';

  @override
  String get mejor => 'Mieux';

  @override
  String get ultimoPromedio => 'Dernière moyenne';

  @override
  String get promedioGeneral => 'Moyenne générale';

  @override
  String ultimaSesionDe(Object nombre) {
    return 'Dernière séance du $nombre';
  }

  @override
  String get ultimaSesion => 'Dernière séance';

  @override
  String get toquesEnEstaSesion => 'Touches dans cette session';

  @override
  String get mejorToqueDeLaSesion => 'Meilleure touche de la séance';

  @override
  String get accesosRapidos => 'Accès rapide';

  @override
  String get gestionarUsuarios => 'Gérer les utilisateurs';

  @override
  String get vincularPodBle => 'Lier le module BLE';

  @override
  String get verHistorialTiempos => 'Afficher l\'historique du temps';

  @override
  String get configurarEntrenamiento => 'Mettre en place une formation';

  @override
  String get cantidadPodsActivos => 'Nombre de pods actifs';

  @override
  String get podsAUtilizar => 'Pods à utiliser :';

  @override
  String get seleccionaElModo => 'Sélectionnez le mode';

  @override
  String get porRondas => 'Par tours';

  @override
  String get completaNumeroFijo => 'Effectuer un nombre fixe de touches';

  @override
  String get porTiempo => 'Par temps';

  @override
  String get tocaMayorCantidad =>
      'Appuyez autant que possible avant la fin du temps imparti';

  @override
  String get modoBicolor => 'Mode bicolore';

  @override
  String get desactivaColor1 =>
      'Désactivez la couleur 1 et ignorez la couleur 2';

  @override
  String get modoManual => 'Mode manuel';

  @override
  String get controlaLuzDirectamente =>
      'Contrôlez la lumière directement depuis l\'application';

  @override
  String get parametrosRondas => 'Paramètres ronds';

  @override
  String get parametrosTiempo => 'Paramètres de temps';

  @override
  String get cantidadRondas => 'Nombre de tours :';

  @override
  String get tiempoLimite => 'Limite de temps :';

  @override
  String get mensajeModoManual =>
      'En mode manuel, vous pouvez allumer et éteindre le pod à tout moment en appuyant sur ses cases.';

  @override
  String get tiempoLimiteColor2 => 'Couleur de limite de temps 2 (Distracteur)';

  @override
  String get tiempoParaIgnorar => 'Il est temps d\'ignorer :';

  @override
  String get intervaloEntrePods => 'Intervalle entre les pods';

  @override
  String get pausaEntreToques => 'Pause entre les touches :';

  @override
  String get coloresBicolor => 'Couleurs bicolores';

  @override
  String get colorLeds => 'Couleur des LED';

  @override
  String get color1ATocar => 'Couleur 1 (A jouer)';

  @override
  String get color2NoTocar => 'Couleur 2 (NE PAS toucher / Ignorer)';

  @override
  String get seleccionarColorBase => 'Sélectionnez la couleur de base';

  @override
  String get ajusteColorRgb => 'Réglage des couleurs RVB :';

  @override
  String get vistaPrevia => 'Aperçu :';

  @override
  String get intensidadLeds => 'Intensité des LED';

  @override
  String get brilloIntensidad => 'Luminosité/Intensité :';

  @override
  String get iniciarRutina => 'COMMENCER LA ROUTINE';

  @override
  String get errorBluetoothRequerido =>
      'Vous devez connecter l\'ESP32 via Bluetooth avant de démarrer la routine.';

  @override
  String get conectar => 'CONNECTER';

  @override
  String get errorBicolorColoresIguales =>
      'En mode Bicolore, vous devez sélectionner deux couleurs différentes.';

  @override
  String get aparatoListo => 'Appareil prêt !';

  @override
  String get preparate => 'Se préparer!';

  @override
  String get atento => 'Attentif!';

  @override
  String tocaPodColor1(Object pod) {
    return 'TOUCHEZ le module $pod ! (Couleur 1)';
  }

  @override
  String noTocarColor2(Object pod) {
    return 'NE PAS TOUCHER! (Couleur 2 dans le module $pod)';
  }

  @override
  String pasaManoPorPod(Object pod) {
    return 'Passez votre main dans le Pod $pod !';
  }

  @override
  String get excelenteColorIgnorado => 'Excellent! Couleur 2 ignorée.';

  @override
  String get tocaCuadradoEncender =>
      'Appuyez sur un carré pour allumer votre Pod';

  @override
  String get seleccionaPodEncender => 'Sélectionnez un Pod à allumer';

  @override
  String get ledApagado => 'LED éteinte.';

  @override
  String toqueEnPod(Object pod, Object tiempo) {
    return 'Appuyez sur Pod $pod ! (${tiempo}s)';
  }

  @override
  String errorTocasteColor2(Object pod) {
    return 'Erreur! Vous avez joué à Color 2 dans le Pod $pod';
  }

  @override
  String get desconectado => 'Hors ligne';

  @override
  String get errorDesconexionMensaje =>
      'La connexion Bluetooth au Pod Central a été interrompue. La séance a été arrêtée.';

  @override
  String get entrenamientoFinalizado => 'Formation terminée ! 🏆';

  @override
  String usuario(Object nombre) {
    return 'Utilisateur : $nombre';
  }

  @override
  String toquesValidos(Object cantidad) {
    return 'Touches valides : $cantidad';
  }

  @override
  String promedioSegundos(Object promedio) {
    return 'Moyenne : $promedio s';
  }

  @override
  String erroresCometidos(Object errores) {
    return 'Erreurs commises : $errores';
  }

  @override
  String get anotacionesSesionOpcional => 'Journaux de session (facultatif)';

  @override
  String get hintAnotaciones =>
      'Ex : Bonne évolution, fatigue musculaire, etc.';

  @override
  String get guardarYFinalizar => 'ENREGISTRER ET TERMINER';

  @override
  String modoManualToques(Object cantidad) {
    return 'Mode manuel (hauts : $cantidad)';
  }

  @override
  String tiempoRestanteToques(Object cantidad, Object tiempoRestante) {
    return 'Heure : ${tiempoRestante}s | Touches : $cantidad';
  }

  @override
  String bicolorRonda(Object rondaActual, Object rondasTotal) {
    return 'Bicolore | Tour $rondaActual sur $rondasTotal';
  }

  @override
  String rondaDe(Object rondaActual, Object rondasTotal) {
    return 'Tour $rondaActual sur $rondasTotal';
  }

  @override
  String tiempoRestante(Object tiempoRestante) {
    return 'TEMPS RESTANT : ${tiempoRestante}s';
  }

  @override
  String get ultimoTiempoValido => 'DERNIÈRE HEURE VALABLE';

  @override
  String get finalizarSesion => 'FIN DE SÉANCE';

  @override
  String get encendido => 'SUR';

  @override
  String podLabel(Object num) {
    return 'POD $num';
  }

  @override
  String get conectarBluetooth => 'Connectez Bluetooth';

  @override
  String conectadoExitosamente(Object nombre) {
    return 'Connexion réussie à $nombre !';
  }

  @override
  String errorAlConectar(Object error) {
    return 'Erreur de connexion : $error';
  }

  @override
  String get dispositivoDesconectado => 'Appareil déconnecté';

  @override
  String get desconectar => 'Déconnecter';

  @override
  String get conectado => 'Connecté';

  @override
  String get dispositivosDisponibles => 'Appareils disponibles :';

  @override
  String get buscandoPods => 'Vous recherchez des pods à proximité...';

  @override
  String get presionaBotonBuscar =>
      'Appuyez sur le bouton ci-dessous pour rechercher des pods.';

  @override
  String get cancelarBusqueda => 'ANNULER LA RECHERCHE';

  @override
  String get buscarDispositivos => 'RECHERCHER DES APPAREILS';

  @override
  String get editarPerfil => 'Modifier le profil';

  @override
  String get perfilActualizado => 'Profil mis à jour avec succès';

  @override
  String get errorActualizarPerfil => 'Erreur lors de la mise à jour du profil';

  @override
  String correoRestablecimientoEnviado(Object email) {
    return 'Nous envoyons un e-mail à $email pour réinitialiser votre mot de passe.';
  }

  @override
  String get errorCorreoRestablecimiento =>
      'Erreur lors de l\'envoi de l\'e-mail de réinitialisation.';

  @override
  String get subirFotoPerfil => 'Télécharger une photo de profil';

  @override
  String get cambiarFotoPerfil => 'Changer la photo de profil';

  @override
  String get eliminarFoto => 'Supprimer la photo';

  @override
  String get informacionPersonal => 'INFORMATIONS PERSONNELLES';

  @override
  String get correoNoModificable =>
      'L\'email ne peut pas être modifié directement.';

  @override
  String get seguridad => 'SÉCURITÉ';

  @override
  String get solicitarRestablecerContrasena =>
      'Demandez un lien par e-mail pour réinitialiser ou modifier votre mot de passe actuel.';

  @override
  String get cambiarContrasena => 'CHANGER LE MOT DE PASSE';

  @override
  String get guardarCambios => 'ENREGISTRER LES MODIFICATIONS';

  @override
  String get gestionDeUsuarios => 'Gestion des utilisateurs';

  @override
  String get agregar => 'Ajouter';

  @override
  String get eliminarUsuario => 'Supprimer un utilisateur';

  @override
  String confirmarEliminarUsuario(Object nombre) {
    return 'Etes-vous sûr de vouloir supprimer le profil de « $nombre » ?';
  }

  @override
  String get cancelar => 'ANNULER';

  @override
  String get eliminar => 'ÉLIMINER';

  @override
  String get nuevoUsuario => 'Nouvel utilisateur';

  @override
  String get editarUsuario => 'Modifier l\'utilisateur';

  @override
  String get subirFoto => 'Télécharger une photo';

  @override
  String get cambiarFoto => 'Changer de photo';

  @override
  String get notasObservaciones => 'Remarques / Observations';

  @override
  String get guardar => 'GARDER';

  @override
  String get mejorPromedio => 'Meilleure moyenne';

  @override
  String get mejorTiempo => 'Meilleur moment';

  @override
  String get mejorUltimaSesion => 'Meilleur (dernière session)';

  @override
  String get promedioUltimaSesion => 'Moy. (Dernière séance)';

  @override
  String get iniciaSesionParaGestionar =>
      'Connectez-vous pour gérer les profils.';

  @override
  String get perfilPrincipalPropietario => 'Profil principal (propriétaire)';

  @override
  String get sinNombre => 'Anonyme';

  @override
  String get cuentaPrincipal => 'Compte principal';

  @override
  String get instruccionGestionUsuarios =>
      'Sélectionnez l\'utilisateur qui s\'entraînera dans cette session.';

  @override
  String get usuarioRegistrado => 'Utilisateur enregistré';

  @override
  String get ajustes => 'Paramètres et configuration';

  @override
  String felizCumpleanos(Object nombre) {
    return 'Joyeux anniversaire, $nombre ! 🎂';
  }

  @override
  String get mensajeCumpleanos =>
      'Toute l\'équipe Activelo vous souhaite une excellente journée de formation !';

  @override
  String get perfilYModoDeUso => 'PROFIL ET MODE D\'UTILISATION';

  @override
  String get modoProfesional => 'Mode professionnel';

  @override
  String get modoProfesionalDesc =>
      'Permet la gestion de plusieurs utilisateurs et notes de session.';

  @override
  String get aparienciaTema => 'APPARENCE ET THÈME';

  @override
  String get modoOscuro => 'Mode sombre';

  @override
  String get cambiarTemaClaroOscuro =>
      'Basculer entre le thème clair et sombre';

  @override
  String get idioma => 'Langue';

  @override
  String get sonidoRetroalimentacion => 'SON ET RÉTROACTION';

  @override
  String get efectosSonido => 'Bruitage';

  @override
  String get reproducirSonidosRutina =>
      'Jouer des sons au début et à la fin de la routine';

  @override
  String get cuentaPerfil => 'COMPTE ET PROFIL';

  @override
  String get actualizaInformacionPersonal =>
      'Mettez à jour vos informations personnelles';

  @override
  String get dispositivosBluetooth => 'Appareils Bluetooth';

  @override
  String get administrarConexiones => 'Gérer les connexions et la numérisation';

  @override
  String get informacion => 'INFORMATION';

  @override
  String get versionApp => 'Version 1.0.0';

  @override
  String get cerrarSesion => 'Se déconnecter';

  @override
  String get historialSesiones => 'Historique des sessions';

  @override
  String get historialIniciaSesion =>
      'Vous devez vous connecter pour consulter votre historique.';

  @override
  String get sinSesionesRegistradas =>
      'Vous n\'avez pas encore de sessions inscrites.';

  @override
  String get noHaySesionesUsuario =>
      'Il n\'y a aucune session pour cet utilisateur.';

  @override
  String get anotacionesDeLaSesion => 'Notes de séance';

  @override
  String get observacionesDeLaSesion => 'Observations de la séance';

  @override
  String get todos => 'Tous';

  @override
  String toquesCount(Object count) {
    return '$count touche';
  }

  @override
  String get mejorToque => 'Meilleur toucher';

  @override
  String get promedio => 'Moyenne';

  @override
  String get errores => 'Erreurs';

  @override
  String get sinAnotaciones => 'Aucune annotation saisie.';

  @override
  String get desglosePorToqueValido => 'Répartition par touche valide :';

  @override
  String get legalesYPrivacidad => 'Mentions légales et confidentialité';

  @override
  String get terminosDeUso => 'Conditions d\'utilisation';

  @override
  String get privacidad => 'Confidentialité';

  @override
  String get terminosYCondicionesDeUso => 'Conditions générales d\'utilisation';

  @override
  String get ultimaActualizacion => 'Dernière mise à jour : 2026';

  @override
  String get tituloTerminos1 => '1. Acceptation des conditions';

  @override
  String get textoTerminos1 =>
      'En téléchargeant, en vous inscrivant ou en utilisant l\'application Activelo, vous acceptez d\'être lié par les présentes Conditions Générales. Si vous n’êtes pas d’accord avec l’un d’entre eux, vous devez vous abstenir d’utiliser la plateforme.';

  @override
  String get tituloTerminos2 => '2. Description des services';

  @override
  String get textoTerminos2 =>
      'Activelo est une plateforme conçue pour la configuration, le contrôle et la surveillance de routines d\'entraînement physique et d\'agilité grâce à l\'interaction avec des appareils interactifs sans fil.';

  @override
  String get tituloTerminos3 => '3. Comptes d\'utilisateurs';

  @override
  String get textoTerminos3 =>
      'Pour accéder à la synchronisation de votre historique et de vos statistiques de performances, vous devez créer un compte avec une adresse email valide. Vous êtes seul responsable du maintien de la confidentialité de vos informations d’identification.';

  @override
  String get tituloTerminos4 => '4. Responsabilité et santé physique';

  @override
  String get textoTerminos4 =>
      'L\'utilisation de l\'application implique la pratique d\'une activité physique. Activelo ne fournit pas de conseil médical. Il est recommandé de bien s\'échauffer et de suspendre l\'entraînement en cas d\'inconfort physique.';

  @override
  String get tituloTerminos5 =>
      '5. Utilisation du matériel et interaction sans fil';

  @override
  String get textoTerminos5 =>
      'L\'application nécessite une connectivité sans fil pour fonctionner avec les modules d\'entraînement. L\'utilisateur est responsable de l\'utilisation des appareils dans un environnement sûr et approprié.';

  @override
  String get tituloTerminos6 => '6. Modifications de la plateforme';

  @override
  String get textoTerminos6 =>
      'Nous nous réservons le droit de modifier ou d\'interrompre les fonctionnalités du Service et de mettre à jour ces Conditions à tout moment.';

  @override
  String get politicaPrivacidad => 'politique de confidentialité';

  @override
  String get tituloPrivacidad1 => '1. Informations collectées';

  @override
  String get textoPrivacidad1 =>
      'Nous collectons uniquement les données essentielles pour fournir le service :\n• Données d\'identification : Email d\'inscription.\n• Métriques d\'entraînement : temps de réaction, nombre de touches, modes utilisés et dates de chaque séance.';

  @override
  String get tituloPrivacidad2 => '2. Autorisations requises';

  @override
  String get textoPrivacidad2 =>
      'Pour relier et transmettre les routines aux appareils d\'entraînement, l\'application demandera des autorisations de connexion sans fil (Bluetooth) et de localisation dans les cas requis par le système d\'exploitation.';

  @override
  String get tituloPrivacidad3 => '3. Utilisation des informations';

  @override
  String get textoPrivacidad3 =>
      'Les données stockées sont utilisées exclusivement pour permettre l\'accès à votre compte, calculer vos statistiques de performances personnelles et vous montrer votre historique de progression.';

  @override
  String get tituloPrivacidad4 => '4. Protection des données';

  @override
  String get textoPrivacidad4 =>
      'Nous mettons en œuvre des mesures de sécurité pour protéger vos informations stockées dans le cloud. Nous ne vendons ni ne partageons vos données personnelles avec des tiers à des fins commerciales ou publicitaires.';

  @override
  String get tituloPrivacidad5 => '5. Suppression des données';

  @override
  String get textoPrivacidad5 =>
      'Vous avez le droit de demander à tout moment la suppression définitive de votre compte et la suppression totale de vos dossiers de formation.';

  @override
  String get errorCredencialesIncorrectas => 'E-mail/mot de passe incorrect';
}
