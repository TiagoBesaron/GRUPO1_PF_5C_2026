// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Activelo';

  @override
  String get paginaNoEncontrada => 'Página não encontrada';

  @override
  String get paginaNoExiste => 'A tela solicitada não existe.';

  @override
  String get volverAlInicio => 'Voltar ao Início';

  @override
  String get navInicio => 'Início';

  @override
  String get navHistorial => 'Histórico';

  @override
  String get navAjustes => 'Configurações';

  @override
  String get iniciarSesion => 'Iniciar Sessão';

  @override
  String get crearCuenta => 'CRIAR CONTA';

  @override
  String get registrate => 'Cadastre-se';

  @override
  String get nombreCompleto => 'Nome Completo';

  @override
  String get fechaNacimiento => 'Data de Nascimento';

  @override
  String get correoElectronico => 'E-mail';

  @override
  String get contrasena => 'Senha';

  @override
  String get confirmarContrasena => 'Confirmar Senha';

  @override
  String get seleccionarFecha => 'Selecionar data';

  @override
  String get seleccionaTuFechaNacimiento => 'SELECIONE SUA DATA DE NASCIMENTO';

  @override
  String get errorFechaNacimiento =>
      'Por favor, selecione sua data de nascimento.';

  @override
  String get errorNombreVacio => 'Digite seu nome completo';

  @override
  String get errorCorreoVacio => 'Digite seu e-mail';

  @override
  String get errorCorreoInvalido => 'Digite um e-mail válido';

  @override
  String get errorContrasenaVacia => 'Digite sua senha';

  @override
  String get errorContrasenaCorta => 'A senha deve ter pelo menos 6 caracteres';

  @override
  String get errorContrasenasNoCoinciden => 'As senhas não coincidem';

  @override
  String get subtituloLogin => 'Inicie sessão para começar sua rotina';

  @override
  String get subtituloRegistro => 'Crie sua conta para salvar seus treinos';

  @override
  String get yaTenesCuenta => 'Já tem uma conta?';

  @override
  String get noTenesCuenta => 'Não tem uma conta?';

  @override
  String get alRegistrarteAceptas => 'Ao se cadastrar, você aceita nossos ';

  @override
  String get alIngresarAceptas => 'Ao entrar, você aceita nossos ';

  @override
  String get terminosYPrivacidad => 'Termos e Privacidade';

  @override
  String get volverAlInicioSesion => 'Voltar ao Início de Sessão';

  @override
  String get entrenar => 'Treinar';

  @override
  String holaEntrenador(Object nombre) {
    return 'Olá, $nombre! 👋';
  }

  @override
  String get entrenador => 'Treinador';

  @override
  String get usuarioActivo => 'Usuário Ativo:';

  @override
  String get perfilPrincipal => 'Perfil Principal';

  @override
  String get cambiar => 'ALTERAR';

  @override
  String get estadoDispositivo => 'Status do dispositivo';

  @override
  String esp32Conectado(Object dispositivo) {
    return 'ESP32 Conectado ($dispositivo)';
  }

  @override
  String get esp32Desconectado => 'ESP32 desconectado';

  @override
  String get podBle => 'Pod BLE';

  @override
  String get mejor => 'Melhor';

  @override
  String get ultimoPromedio => 'Última Média';

  @override
  String get promedioGeneral => 'Média Geral';

  @override
  String ultimaSesionDe(Object nombre) {
    return 'Última sessão de $nombre';
  }

  @override
  String get ultimaSesion => 'Última sessão';

  @override
  String get toquesEnEstaSesion => 'Toques nesta sessão';

  @override
  String get mejorToqueDeLaSesion => 'Melhor toque da sessão';

  @override
  String get accesosRapidos => 'Acessos rápidos';

  @override
  String get gestionarUsuarios => 'Gerenciar Usuários';

  @override
  String get vincularPodBle => 'Vincular Pod BLE';

  @override
  String get verHistorialTiempos => 'Ver histórico de tempos';

  @override
  String get configurarEntrenamiento => 'Configurar Treino';

  @override
  String get cantidadPodsActivos => 'Quantidade de Pods Ativos';

  @override
  String get podsAUtilizar => 'Pods a utilizar:';

  @override
  String get seleccionaElModo => 'Selecione o Modo';

  @override
  String get porRondas => 'Por Rodadas';

  @override
  String get completaNumeroFijo => 'Conclua um número fixo de toques';

  @override
  String get porTiempo => 'Por Tempo';

  @override
  String get tocaMayorCantidad =>
      'Toque a maior quantidade antes que o tempo acabe';

  @override
  String get modoBicolor => 'Modo Bicolor';

  @override
  String get desactivaColor1 => 'Desativa Cor 1 e ignora Cor 2';

  @override
  String get modoManual => 'Modo Manual';

  @override
  String get controlaLuzDirectamente => 'Controle a luz diretamente pelo app';

  @override
  String get parametrosRondas => 'Parâmetros de Rodadas';

  @override
  String get parametrosTiempo => 'Parâmetros de Tempo';

  @override
  String get cantidadRondas => 'Quantidade de Rodadas:';

  @override
  String get tiempoLimite => 'Tempo Limite:';

  @override
  String get mensajeModoManual =>
      'No Modo Manual você pode ligar e desligar o pod a qualquer momento tocando em seus quadros.';

  @override
  String get tiempoLimiteColor2 => 'Tempo Limite Cor 2 (Distrator)';

  @override
  String get tiempoParaIgnorar => 'Tempo para ignorar:';

  @override
  String get intervaloEntrePods => 'Intervalo entre Pods';

  @override
  String get pausaEntreToques => 'Pausa entre toques:';

  @override
  String get coloresBicolor => 'Cores Bicolor';

  @override
  String get colorLeds => 'Cor dos LEDs';

  @override
  String get color1ATocar => 'Cor 1 (A tocar)';

  @override
  String get color2NoTocar => 'Cor 2 (NÃO tocar / Ignorar)';

  @override
  String get seleccionarColorBase => 'Selecionar Cor Base';

  @override
  String get ajusteColorRgb => 'Ajuste de Cor RGB:';

  @override
  String get vistaPrevia => 'Pré-visualização:';

  @override
  String get intensidadLeds => 'Intensidade dos LEDs';

  @override
  String get brilloIntensidad => 'Brilho / Intensidade:';

  @override
  String get iniciarRutina => 'INICIAR ROTINA';

  @override
  String get errorBluetoothRequerido =>
      'Você deve conectar o ESP32 via Bluetooth antes de iniciar a rotina.';

  @override
  String get conectar => 'CONECTAR';

  @override
  String get errorBicolorColoresIguales =>
      'No Modo Bicolor você deve selecionar duas cores diferentes.';

  @override
  String get aparatoListo => 'Aparelho Pronto!';

  @override
  String get preparate => 'Prepare-se!';

  @override
  String get atento => 'Atenção!';

  @override
  String tocaPodColor1(Object pod) {
    return 'TOQUE no Pod $pod! (Cor 1)';
  }

  @override
  String noTocarColor2(Object pod) {
    return 'NÃO TOQUE! (Cor 2 no Pod $pod)';
  }

  @override
  String pasaManoPorPod(Object pod) {
    return 'Passe a mão pelo Pod $pod!';
  }

  @override
  String get excelenteColorIgnorado => 'Excelente! Cor 2 ignorada.';

  @override
  String get tocaCuadradoEncender => 'Toque em um quadrado para ligar o Pod';

  @override
  String get seleccionaPodEncender => 'Selecione um Pod para ligar';

  @override
  String get ledApagado => 'LED Desligado.';

  @override
  String toqueEnPod(Object pod, Object tiempo) {
    return 'Toque no Pod $pod! ($tiempo s)';
  }

  @override
  String errorTocasteColor2(Object pod) {
    return 'Erro! Você tocou na Cor 2 no Pod $pod';
  }

  @override
  String get desconectado => 'Desconectado';

  @override
  String get errorDesconexionMensaje =>
      'A conexão Bluetooth com o Pod Central foi interrompida. A sessão foi interrompida.';

  @override
  String get entrenamientoFinalizado => 'Treino Finalizado! 🏆';

  @override
  String usuario(Object nombre) {
    return 'Usuário: $nombre';
  }

  @override
  String toquesValidos(Object cantidad) {
    return 'Toques válidos: $cantidad';
  }

  @override
  String promedioSegundos(Object promedio) {
    return 'Média: $promedio s';
  }

  @override
  String erroresCometidos(Object errores) {
    return 'Erros cometidos: $errores';
  }

  @override
  String get anotacionesSesionOpcional => 'Anotações da sessão (Opcional)';

  @override
  String get hintAnotaciones => 'Ex: Boa evolução, fadiga muscular, etc.';

  @override
  String get guardarYFinalizar => 'SALVAR E FINALIZAR';

  @override
  String modoManualToques(Object cantidad) {
    return 'Modo Manual (Toques: $cantidad)';
  }

  @override
  String tiempoRestanteToques(Object cantidad, Object tiempoRestante) {
    return 'Tempo: ${tiempoRestante}s | Toques: $cantidad';
  }

  @override
  String bicolorRonda(Object rondaActual, Object rondasTotal) {
    return 'Bicolor | Rodada $rondaActual de $rondasTotal';
  }

  @override
  String rondaDe(Object rondaActual, Object rondasTotal) {
    return 'Rodada $rondaActual de $rondasTotal';
  }

  @override
  String tiempoRestante(Object tiempoRestante) {
    return 'TEMPO RESTANTE: ${tiempoRestante}s';
  }

  @override
  String get ultimoTiempoValido => 'ÚLTIMO TEMPO VÁLIDO';

  @override
  String get finalizarSesion => 'FINALIZAR SESSÃO';

  @override
  String get encendido => 'LIGADO';

  @override
  String podLabel(Object num) {
    return 'POD $num';
  }

  @override
  String get conectarBluetooth => 'Conectar Bluetooth';

  @override
  String conectadoExitosamente(Object nombre) {
    return 'Conectado com sucesso a $nombre!';
  }

  @override
  String errorAlConectar(Object error) {
    return 'Erro ao conectar: $error';
  }

  @override
  String get dispositivoDesconectado => 'Dispositivo desconectado';

  @override
  String get desconectar => 'Desconectar';

  @override
  String get conectado => 'Conectado';

  @override
  String get dispositivosDisponibles => 'Dispositivos disponíveis:';

  @override
  String get buscandoPods => 'Procurando pods próximos...';

  @override
  String get presionaBotonBuscar =>
      'Pressione o botão abaixo para procurar pods.';

  @override
  String get cancelarBusqueda => 'CANCELAR BUSCA';

  @override
  String get buscarDispositivos => 'BUSCAR DISPOSITIVOS';

  @override
  String get editarPerfil => 'Editar Perfil';

  @override
  String get perfilActualizado => 'Perfil atualizado com sucesso';

  @override
  String get errorActualizarPerfil => 'Erro ao atualizar o perfil';

  @override
  String correoRestablecimientoEnviado(Object email) {
    return 'Enviamos um e-mail para $email para redefinir sua senha.';
  }

  @override
  String get errorCorreoRestablecimiento =>
      'Erro ao enviar o e-mail de redefinição.';

  @override
  String get subirFotoPerfil => 'Enviar foto de perfil';

  @override
  String get cambiarFotoPerfil => 'Alterar foto de perfil';

  @override
  String get eliminarFoto => 'Excluir foto';

  @override
  String get informacionPersonal => 'INFORMAÇÕES PESSOAIS';

  @override
  String get correoNoModificable =>
      'O e-mail não pode ser modificado diretamente.';

  @override
  String get seguridad => 'SEGURANÇA';

  @override
  String get solicitarRestablecerContrasena =>
      'Solicite um link por e-mail para redefinir ou alterar sua senha atual.';

  @override
  String get cambiarContrasena => 'ALTERAR SENHA';

  @override
  String get guardarCambios => 'SALVAR ALTERAÇÕES';

  @override
  String get gestionDeUsuarios => 'Gerenciamento de Usuários';

  @override
  String get agregar => 'Adicionar';

  @override
  String get eliminarUsuario => 'Excluir Usuário';

  @override
  String confirmarEliminarUsuario(Object nombre) {
    return 'Tem certeza de que deseja excluir o perfil de \"$nombre\"?';
  }

  @override
  String get cancelar => 'CANCELAR';

  @override
  String get eliminar => 'EXCLUIR';

  @override
  String get nuevoUsuario => 'Novo Usuário';

  @override
  String get editarUsuario => 'Editar Usuário';

  @override
  String get subirFoto => 'Enviar foto';

  @override
  String get cambiarFoto => 'Alterar foto';

  @override
  String get notasObservaciones => 'Notas / Observações';

  @override
  String get guardar => 'SALVAR';

  @override
  String get mejorPromedio => 'Melhor Média';

  @override
  String get mejorTiempo => 'Melhor Tempo';

  @override
  String get mejorUltimaSesion => 'Melhor (Últ. Sessão)';

  @override
  String get promedioUltimaSesion => 'Média (Últ. Sessão)';

  @override
  String get iniciaSesionParaGestionar =>
      'Inicie sessão para gerenciar perfis.';

  @override
  String get perfilPrincipalPropietario => 'Perfil Principal (Proprietário)';

  @override
  String get sinNombre => 'Sem nome';

  @override
  String get cuentaPrincipal => 'Conta Principal';

  @override
  String get instruccionGestionUsuarios =>
      'Selecione o usuário que treinará nesta sessão.';

  @override
  String get usuarioRegistrado => 'Usuário registrado';

  @override
  String get ajustes => 'Configurações';

  @override
  String felizCumpleanos(Object nombre) {
    return 'Feliz Aniversário, $nombre! 🎂';
  }

  @override
  String get mensajeCumpleanos =>
      'Toda a equipe do Activelo deseja a você um excelente dia de treino!';

  @override
  String get perfilYModoDeUso => 'PERFIL E MODO DE USO';

  @override
  String get modoProfesional => 'Modo Profissional';

  @override
  String get modoProfesionalDesc =>
      'Ativa o gerenciamento de múltiplos usuários e notas de sessão.';

  @override
  String get aparienciaTema => 'APARÊNCIA E TEMA';

  @override
  String get modoOscuro => 'Modo Escuro';

  @override
  String get cambiarTemaClaroOscuro => 'Alternar entre tema claro e escuro';

  @override
  String get idioma => 'Idioma';

  @override
  String get sonidoRetroalimentacion => 'SOM E FEEDBACK';

  @override
  String get efectosSonido => 'Efeitos de Som';

  @override
  String get reproducirSonidosRutina =>
      'Reproduzir sons ao iniciar e finalizar a rotina';

  @override
  String get cuentaPerfil => 'CONTA E PERFIL';

  @override
  String get actualizaInformacionPersonal =>
      'Atualize suas informações pessoais';

  @override
  String get dispositivosBluetooth => 'Dispositivos Bluetooth';

  @override
  String get administrarConexiones => 'Gerenciar conexões e escaneamento';

  @override
  String get informacion => 'INFORMAÇÃO';

  @override
  String get versionApp => 'Versión 1.0.0';

  @override
  String get cerrarSesion => 'Sair';

  @override
  String get historialSesiones => 'Histórico de Sessões';

  @override
  String get historialIniciaSesion =>
      'Você deve iniciar sessão para ver seu histórico.';

  @override
  String get sinSesionesRegistradas => 'Ainda não há sessões registradas.';

  @override
  String get noHaySesionesUsuario => 'Não há sessões para este usuário.';

  @override
  String get anotacionesDeLaSesion => 'Anotações da Sessão';

  @override
  String get observacionesDeLaSesion => 'Observações da sessão';

  @override
  String get todos => 'Todos';

  @override
  String toquesCount(Object count) {
    return '$count toques';
  }

  @override
  String get mejorToque => 'Melhor Toque';

  @override
  String get promedio => 'Média';

  @override
  String get errores => 'Erros';

  @override
  String get sinAnotaciones => 'Nenhuma anotação inserida.';

  @override
  String get desglosePorToqueValido => 'Detalhamento por toque válido:';

  @override
  String get legalesYPrivacidad => 'Termos Legais e Privacidade';

  @override
  String get terminosDeUso => 'Termos de Uso';

  @override
  String get privacidad => 'Privacidade';

  @override
  String get terminosYCondicionesDeUso => 'Termos e Condições de Uso';

  @override
  String get ultimaActualizacion => 'Última atualização: 2026';

  @override
  String get tituloTerminos1 => '1. Aceitação dos Termos';

  @override
  String get textoTerminos1 =>
      'Ao baixar, cadastrar-se ou usar o aplicativo Activelo, você concorda em cumprir estes Termos e Condições. Se você não concordar com algum deles, deve se abster de usar a plataforma.';

  @override
  String get tituloTerminos2 => '2. Descrição do Serviço';

  @override
  String get textoTerminos2 =>
      'O Activelo é uma plataforma projetada para configuração, controle e acompanhamento de rotinas de treino físico e agilidade por meio da interação com dispositivos sem fio.';

  @override
  String get tituloTerminos3 => '3. Contas de Usuário';

  @override
  String get textoTerminos3 =>
      'Para acessar a sincronização do seu histórico e estatísticas de desempenho, você deve cadastrar uma conta com um e-mail válido. Você é o único responsável por manter a confidencialidade das suas credenciais.';

  @override
  String get tituloTerminos4 => '4. Responsabilidade e Saúde Física';

  @override
  String get textoTerminos4 =>
      'O uso do aplicativo envolve a realização de atividade física. O Activelo não fornece aconselhamento médico. Recomenda-se realizar um aquecimento adequado e suspender o treino diante de qualquer desconforto físico.';

  @override
  String get tituloTerminos5 => '5. Uso de Hardware e Interação Sem Fio';

  @override
  String get textoTerminos5 =>
      'O app requer conectividade sem fio para operar com os pods de treino. O usuário é responsável por operar os dispositivos em um ambiente seguro e adequado.';

  @override
  String get tituloTerminos6 => '6. Modificações da Plataforma';

  @override
  String get textoTerminos6 =>
      'Reservamo-nos o direito de modificar ou descontinuar recursos do serviço, bem como atualizar estes termos a qualquer momento.';

  @override
  String get politicaPrivacidad => 'Política de Privacidade';

  @override
  String get tituloPrivacidad1 => '1. Informações Coletadas';

  @override
  String get textoPrivacidad1 =>
      'Coletamos apenas dados essenciais para fornecer o serviço:\n• Dados de identificação: E-mail de cadastro.\n• Métricas de treino: Tempos de reação, quantidade de toques, modos utilizados e datas de cada sessão.';

  @override
  String get tituloPrivacidad2 => '2. Permissões Necessárias';

  @override
  String get textoPrivacidad2 =>
      'Para vincular e transmitir as rotinas aos dispositivos de treino, o aplicativo solicitará permissões de conexão sem fio (Bluetooth) e localização quando exigido pelo sistema operacional.';

  @override
  String get tituloPrivacidad3 => '3. Uso das Informações';

  @override
  String get textoPrivacidad3 =>
      'Os dados armazenados são usados exclusivamente para permitir o acesso à sua conta, calcular suas estatísticas de desempenho pessoal e exibir seu histórico de progresso.';

  @override
  String get tituloPrivacidad4 => '4. Proteção de Dados';

  @override
  String get textoPrivacidad4 =>
      'Implementamos medidas de segurança para proteger suas informações armazenadas na nuvem. Não vendemos nem compartilhamos seus dados pessoais com terceiros para fins comerciais ou publicitários.';

  @override
  String get tituloPrivacidad5 => '5. Exclusão de Dados';

  @override
  String get textoPrivacidad5 =>
      'Você tem o direito de solicitar o encerramento definitivo da sua conta e a exclusão total dos seus registros de treino a qualquer momento.';

  @override
  String get errorCredencialesIncorrectas => 'E-mail/senha incorretos';
}
