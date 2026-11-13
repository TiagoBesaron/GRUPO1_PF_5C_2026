// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Activelo';

  @override
  String get paginaNoEncontrada => '页面未找到';

  @override
  String get paginaNoExiste => '请求的页面不存在。';

  @override
  String get volverAlInicio => '返回首页';

  @override
  String get navInicio => '首页';

  @override
  String get navHistorial => '历史';

  @override
  String get navAjustes => '设置';

  @override
  String get iniciarSesion => '登录';

  @override
  String get crearCuenta => '创建账号';

  @override
  String get registrate => '立即注册';

  @override
  String get nombreCompleto => '全名';

  @override
  String get fechaNacimiento => '出生日期';

  @override
  String get correoElectronico => '电子邮箱';

  @override
  String get contrasena => '密码';

  @override
  String get confirmarContrasena => '确认密码';

  @override
  String get seleccionarFecha => '选择日期';

  @override
  String get seleccionaTuFechaNacimiento => '请选择您的出生日期';

  @override
  String get errorFechaNacimiento => '请选择您的出生日期。';

  @override
  String get errorNombreVacio => '请输入您的姓名';

  @override
  String get errorCorreoVacio => '请输入您的邮箱';

  @override
  String get errorCorreoInvalido => '请输入有效的邮箱地址';

  @override
  String get errorContrasenaVacia => '请输入您的密码';

  @override
  String get errorContrasenaCorta => '密码长度不能少于6个字符';

  @override
  String get errorContrasenasNoCoinciden => '两次输入的密码不一致';

  @override
  String get subtituloLogin => '登录以开始您的日常训练';

  @override
  String get subtituloRegistro => '创建账号以保存您的训练记录';

  @override
  String get yaTenesCuenta => '已有账号？';

  @override
  String get noTenesCuenta => '还没有账号？';

  @override
  String get alRegistrarteAceptas => '注册即表示您同意我们的 ';

  @override
  String get alIngresarAceptas => '登录即表示您同意 our ';

  @override
  String get terminosYPrivacidad => '服务条款与隐私政策';

  @override
  String get volverAlInicioSesion => '返回登录界面';

  @override
  String get entrenar => '开始训练';

  @override
  String holaEntrenador(Object nombre) {
    return '你好，$nombre！ 👋';
  }

  @override
  String get entrenador => '教练';

  @override
  String get usuarioActivo => '当前用户:';

  @override
  String get perfilPrincipal => '主个人资料';

  @override
  String get cambiar => '切换';

  @override
  String get estadoDispositivo => '设备状态';

  @override
  String esp32Conectado(Object dispositivo) {
    return 'ESP32 已连接 ($dispositivo)';
  }

  @override
  String get esp32Desconectado => 'ESP32 未连接';

  @override
  String get podBle => 'Pod BLE';

  @override
  String get mejor => '最佳成绩';

  @override
  String get ultimoPromedio => '上次平均';

  @override
  String get promedioGeneral => '总平均';

  @override
  String ultimaSesionDe(Object nombre) {
    return '$nombre 的上次训练';
  }

  @override
  String get ultimaSesion => '上次训练';

  @override
  String get toquesEnEstaSesion => '本次触碰次数';

  @override
  String get mejorToqueDeLaSesion => '本次最快触碰';

  @override
  String get accesosRapidos => '快捷方式';

  @override
  String get gestionarUsuarios => '用户管理';

  @override
  String get vincularPodBle => '绑定 Pod BLE';

  @override
  String get verHistorialTiempos => '查看成绩历史';

  @override
  String get configurarEntrenamiento => '训练设置';

  @override
  String get cantidadPodsActivos => '活跃 Pod 数量';

  @override
  String get podsAUtilizar => '使用 Pod 数量:';

  @override
  String get seleccionaElModo => '选择模式';

  @override
  String get porRondas => '按轮次';

  @override
  String get completaNumeroFijo => '完成固定次数的触碰';

  @override
  String get porTiempo => '按时间';

  @override
  String get tocaMayorCantidad => '在时间结束前完成尽可能多的触碰';

  @override
  String get modoBicolor => '双色模式';

  @override
  String get desactivaColor1 => '触碰颜色1，忽略颜色2';

  @override
  String get modoManual => '手动模式';

  @override
  String get controlaLuzDirectamente => '直接在应用中控制灯光';

  @override
  String get parametrosRondas => '轮次参数';

  @override
  String get parametrosTiempo => '时间参数';

  @override
  String get cantidadRondas => '总轮数:';

  @override
  String get tiempoLimite => '时间限制:';

  @override
  String get mensajeModoManual => '在手动模式下，您可以随时点击方格来开关对应的 Pod。';

  @override
  String get tiempoLimiteColor2 => '颜色2超时时间 (干扰色)';

  @override
  String get tiempoParaIgnorar => '忽略等待时间:';

  @override
  String get intervaloEntrePods => 'Pod 间隔时间';

  @override
  String get pausaEntreToques => '触碰间停顿:';

  @override
  String get coloresBicolor => '双色设置';

  @override
  String get colorLeds => 'LED 颜色';

  @override
  String get color1ATocar => '颜色 1 (需要触碰)';

  @override
  String get color2NoTocar => '颜色 2 (请勿触碰 / 忽略)';

  @override
  String get seleccionarColorBase => '选择基础颜色';

  @override
  String get ajusteColorRgb => 'RGB 颜色微调:';

  @override
  String get vistaPrevia => '预览:';

  @override
  String get intensidadLeds => 'LED 亮度';

  @override
  String get brilloIntensidad => '亮度 / 强度:';

  @override
  String get iniciarRutina => '开始训练';

  @override
  String get errorBluetoothRequerido => '开始训练前请先通过蓝牙连接 ESP32。';

  @override
  String get conectar => '连接';

  @override
  String get errorBicolorColoresIguales => '双色模式下必须选择两种不同的颜色。';

  @override
  String get aparatoListo => '设备已就绪！';

  @override
  String get preparate => '准备！';

  @override
  String get atento => '注意！';

  @override
  String tocaPodColor1(Object pod) {
    return '触碰 Pod $pod！ (颜色 1)';
  }

  @override
  String noTocarColor2(Object pod) {
    return '请勿触碰！ (Pod $pod 为颜色 2)';
  }

  @override
  String pasaManoPorPod(Object pod) {
    return '请在 Pod $pod 上方划过手掌！';
  }

  @override
  String get excelenteColorIgnorado => '太棒了！成功忽略颜色 2。';

  @override
  String get tocaCuadradoEncender => '点击方格以点亮对应 Pod';

  @override
  String get seleccionaPodEncender => '选择要点亮的 Pod';

  @override
  String get ledApagado => 'LED 已熄灭。';

  @override
  String toqueEnPod(Object pod, Object tiempo) {
    return '成功触碰 Pod $pod！ ($tiempo 秒)';
  }

  @override
  String errorTocasteColor2(Object pod) {
    return '错误！触碰了 Pod $pod 的颜色 2';
  }

  @override
  String get desconectado => '已断开';

  @override
  String get errorDesconexionMensaje => '与主 Pod 的蓝牙连接已中断。会话已暂停。';

  @override
  String get entrenamientoFinalizado => '训练完成！ 🏆';

  @override
  String usuario(Object nombre) {
    return '用户: $nombre';
  }

  @override
  String toquesValidos(Object cantidad) {
    return '有效触碰: $cantidad';
  }

  @override
  String promedioSegundos(Object promedio) {
    return '平均用时: $promedio 秒';
  }

  @override
  String erroresCometidos(Object errores) {
    return '失误次数: $errores';
  }

  @override
  String get anotacionesSesionOpcional => '训练备注 (可选)';

  @override
  String get hintAnotaciones => '例如: 状态良好，肌肉酸痛等';

  @override
  String get guardarYFinalizar => '保存并结束';

  @override
  String modoManualToques(Object cantidad) {
    return '手动模式 (触碰数: $cantidad)';
  }

  @override
  String tiempoRestanteToques(Object cantidad, Object tiempoRestante) {
    return '剩余时间: $tiempoRestante秒 | 触碰数: $cantidad';
  }

  @override
  String bicolorRonda(Object rondaActual, Object rondasTotal) {
    return '双色模式 | 第 $rondaActual 轮 / 共 $rondasTotal 轮';
  }

  @override
  String rondaDe(Object rondaActual, Object rondasTotal) {
    return '第 $rondaActual 轮 / 共 $rondasTotal 轮';
  }

  @override
  String tiempoRestante(Object tiempoRestante) {
    return '剩余时间: $tiempoRestante秒';
  }

  @override
  String get ultimoTiempoValido => '最新有效成绩';

  @override
  String get finalizarSesion => '结束会话';

  @override
  String get encendido => '点亮中';

  @override
  String podLabel(Object num) {
    return 'POD $num';
  }

  @override
  String get conectarBluetooth => '连接蓝牙';

  @override
  String conectadoExitosamente(Object nombre) {
    return '成功连接到 $nombre！';
  }

  @override
  String errorAlConectar(Object error) {
    return '连接失败: $error';
  }

  @override
  String get dispositivoDesconectado => '设备已断开连接';

  @override
  String get desconectar => '断开连接';

  @override
  String get conectado => '已连接';

  @override
  String get dispositivosDisponibles => '可用设备:';

  @override
  String get buscandoPods => '正在搜索附近的 Pod...';

  @override
  String get presionaBotonBuscar => '点击下方按钮开始搜索 Pod。';

  @override
  String get cancelarBusqueda => '取消搜索';

  @override
  String get buscarDispositivos => '搜索设备';

  @override
  String get editarPerfil => '编辑个人资料';

  @override
  String get perfilActualizado => '个人资料更新成功';

  @override
  String get errorActualizarPerfil => '更新个人资料失败';

  @override
  String correoRestablecimientoEnviado(Object email) {
    return '重置密码邮件已发送至 $email。';
  }

  @override
  String get errorCorreoRestablecimiento => '发送重置密码邮件失败。';

  @override
  String get subirFotoPerfil => '上传头像';

  @override
  String get cambiarFotoPerfil => '更换头像';

  @override
  String get eliminarFoto => '删除头像';

  @override
  String get informacionPersonal => '个人信息';

  @override
  String get correoNoModificable => '电子邮箱不可直接修改。';

  @override
  String get seguridad => '安全设置';

  @override
  String get solicitarRestablecerContrasena => '通过邮件接收链接以重置或修改当前密码。';

  @override
  String get cambiarContrasena => '修改密码';

  @override
  String get guardarCambios => '保存修改';

  @override
  String get gestionDeUsuarios => '用户管理';

  @override
  String get agregar => '添加';

  @override
  String get eliminarUsuario => '删除用户';

  @override
  String confirmarEliminarUsuario(Object nombre) {
    return '您确定要删除用户 \"$nombre\" 的资料吗？';
  }

  @override
  String get cancelar => '取消';

  @override
  String get eliminar => '删除';

  @override
  String get nuevoUsuario => '新建用户';

  @override
  String get editarUsuario => '编辑用户';

  @override
  String get subirFoto => '上传照片';

  @override
  String get cambiarFoto => '更换照片';

  @override
  String get notasObservaciones => '备注 / 说明';

  @override
  String get guardar => '保存';

  @override
  String get mejorPromedio => '最佳平均成绩';

  @override
  String get mejorTiempo => '最快单次成绩';

  @override
  String get mejorUltimaSesion => '上次最快';

  @override
  String get promedioUltimaSesion => '上次平均';

  @override
  String get iniciaSesionParaGestionar => '请先登录以管理用户资料。';

  @override
  String get perfilPrincipalPropietario => '主资料 (账户所有者)';

  @override
  String get sinNombre => '未命名';

  @override
  String get cuentaPrincipal => '主账号';

  @override
  String get instruccionGestionUsuarios => '请选择将在本次训练中使用的用户。';

  @override
  String get usuarioRegistrado => '已注册用户';

  @override
  String get ajustes => '设置与配置';

  @override
  String felizCumpleanos(Object nombre) {
    return '生日快乐，$nombre！ 🎂';
  }

  @override
  String get mensajeCumpleanos => 'Activelo 团队祝您度过愉快而充实的一天！';

  @override
  String get perfilYModoDeUso => '个人资料与使用模式';

  @override
  String get modoProfesional => '专业模式';

  @override
  String get modoProfesionalDesc => '开启多用户管理和训练备注功能。';

  @override
  String get aparienciaTema => '外观与主题';

  @override
  String get modoOscuro => '深色模式';

  @override
  String get cambiarTemaClaroOscuro => '切换浅色和深色主题';

  @override
  String get idioma => '语言';

  @override
  String get sonidoRetroalimentacion => '声音与反馈';

  @override
  String get efectosSonido => '音效';

  @override
  String get reproducirSonidosRutina => '在训练开始和结束时播放音效';

  @override
  String get cuentaPerfil => '账号与资料';

  @override
  String get actualizaInformacionPersonal => '更新您的个人信息';

  @override
  String get dispositivosBluetooth => '蓝牙设备';

  @override
  String get administrarConexiones => '管理连接和扫描';

  @override
  String get informacion => '关于应用';

  @override
  String get versionApp => '版本 1.0.0';

  @override
  String get cerrarSesion => '退出登录';

  @override
  String get historialSesiones => '训练历史';

  @override
  String get historialIniciaSesion => '请先登录以查看历史记录。';

  @override
  String get sinSesionesRegistradas => '暂无训练记录。';

  @override
  String get noHaySesionesUsuario => '该用户暂无训练记录。';

  @override
  String get anotacionesDeLaSesion => '训练备注';

  @override
  String get observacionesDeLaSesion => '会话备注与心得';

  @override
  String get todos => '全部';

  @override
  String toquesCount(Object count) {
    return '$count 次触碰';
  }

  @override
  String get mejorToque => '最快触碰';

  @override
  String get promedio => '平均用时';

  @override
  String get errores => '失误';

  @override
  String get sinAnotaciones => '暂无备注。';

  @override
  String get desglosePorToqueValido => '有效触碰明细:';

  @override
  String get legalesYPrivacidad => '法律条款与隐私';

  @override
  String get terminosDeUso => '使用条款';

  @override
  String get privacidad => '隐私政策';

  @override
  String get terminosYCondicionesDeUso => '服务与使用条款';

  @override
  String get ultimaActualizacion => '最近更新: 2026年';

  @override
  String get tituloTerminos1 => '1. 条款接受';

  @override
  String get textoTerminos1 => '下载、注册或使用 Activelo 应用即表示您同意受本条款和条件的约束。';

  @override
  String get tituloTerminos2 => '2. 服务说明';

  @override
  String get textoTerminos2 => 'Activelo 是一个通过无线交互设备控制和追踪敏捷性及体能训练的平台。';

  @override
  String get tituloTerminos3 => '3. 用户账号';

  @override
  String get textoTerminos3 => '要同步历史记录和统计数据，您必须使用有效的邮箱注册账号。';

  @override
  String get tituloTerminos4 => '4. 责任与身体健康';

  @override
  String get textoTerminos4 => '使用本应用涉及体育锻炼。应用不提供医疗建议，请适当热身。';

  @override
  String get tituloTerminos5 => '5. 硬件与无线交互';

  @override
  String get textoTerminos5 => '应用需要无线连接才能与训练 Pod 配合使用。';

  @override
  String get tituloTerminos6 => '6. 平台修改';

  @override
  String get textoTerminos6 => '我们保留随时修改或终止服务以及更新本条款的权利。';

  @override
  String get politicaPrivacidad => '隐私政策';

  @override
  String get tituloPrivacidad1 => '1. 收集的信息';

  @override
  String get textoPrivacidad1 =>
      '我们仅收集提供服务所必需的数据:\n• 标识数据: 注册邮箱。\n• 训练指标: 反应时间、触碰次数、模式及日期。';

  @override
  String get tituloPrivacidad2 => '2. 所需权限';

  @override
  String get textoPrivacidad2 => '应用将申请蓝牙和位置权限以连接训练设备。';

  @override
  String get tituloPrivacidad3 => '3. 信息使用';

  @override
  String get textoPrivacidad3 => '存储的数据仅用于登录、统计分析和展示您的训练进度。';

  @override
  String get tituloPrivacidad4 => '4. 保护数据';

  @override
  String get textoPrivacidad4 => '我们采取安全措施保护您的云端数据。绝不出售您的个人信息。';

  @override
  String get tituloPrivacidad5 => '5. 数据删除';

  @override
  String get textoPrivacidad5 => '您有权随时申请注销账号并删除所有训练记录。';

  @override
  String get errorCredencialesIncorrectas => '邮箱或密码错误';
}
