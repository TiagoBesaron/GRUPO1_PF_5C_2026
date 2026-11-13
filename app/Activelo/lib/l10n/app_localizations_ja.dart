// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Activelo';

  @override
  String get paginaNoEncontrada => 'ページが見つかりません';

  @override
  String get paginaNoExiste => '要求された画面は存在しません。';

  @override
  String get volverAlInicio => 'ホームに戻る';

  @override
  String get navInicio => 'ホーム';

  @override
  String get navHistorial => '履歴';

  @override
  String get navAjustes => '設定';

  @override
  String get iniciarSesion => 'ログイン';

  @override
  String get crearCuenta => 'アカウント作成';

  @override
  String get registrate => '新規登録';

  @override
  String get nombreCompleto => '氏名';

  @override
  String get fechaNacimiento => '生年月日';

  @override
  String get correoElectronico => 'メールアドレス';

  @override
  String get contrasena => 'パスワード';

  @override
  String get confirmarContrasena => 'パスワード再入力';

  @override
  String get seleccionarFecha => '日付を選択';

  @override
  String get seleccionaTuFechaNacimiento => '生年月日を選択してください';

  @override
  String get errorFechaNacimiento => '生年月日を選択してください。';

  @override
  String get errorNombreVacio => '氏名を入力してください';

  @override
  String get errorCorreoVacio => 'メールアドレスを入力してください';

  @override
  String get errorCorreoInvalido => '有効なメールアドレスを入力してください';

  @override
  String get errorContrasenaVacia => 'パスワードを入力してください';

  @override
  String get errorContrasenaCorta => 'パスワードは6文字以上で入力してください';

  @override
  String get errorContrasenasNoCoinciden => 'パスワードが一致しません';

  @override
  String get subtituloLogin => 'ログインしてトレーニングを開始しましょう';

  @override
  String get subtituloRegistro => 'アカウントを作成して記録を保存しましょう';

  @override
  String get yaTenesCuenta => 'すでにアカウントをお持ちですか？';

  @override
  String get noTenesCuenta => 'アカウントをお持ちでないですか？';

  @override
  String get alRegistrarteAceptas => '登録することで、規約に同意したことになります ';

  @override
  String get alIngresarAceptas => 'ログインすることで、規約に同意したことになります ';

  @override
  String get terminosYPrivacidad => '利用規約とプライバシー';

  @override
  String get volverAlInicioSesion => 'ログイン画面に戻る';

  @override
  String get entrenar => 'トレーニング開始';

  @override
  String holaEntrenador(Object nombre) {
    return 'こんにちは、$nombreさん！ 👋';
  }

  @override
  String get entrenador => 'トレーナー';

  @override
  String get usuarioActivo => 'アクティブユーザー:';

  @override
  String get perfilPrincipal => 'メインプロファイル';

  @override
  String get cambiar => '変更';

  @override
  String get estadoDispositivo => 'デバイスの状態';

  @override
  String esp32Conectado(Object dispositivo) {
    return 'ESP32 接続済み ($dispositivo)';
  }

  @override
  String get esp32Desconectado => 'ESP32 未接続';

  @override
  String get podBle => 'Pod BLE';

  @override
  String get mejor => '自己ベスト';

  @override
  String get ultimoPromedio => '直近の平均';

  @override
  String get promedioGeneral => '全体平均';

  @override
  String ultimaSesionDe(Object nombre) {
    return '$nombreさんの前回のセッション';
  }

  @override
  String get ultimaSesion => '前回のセッション';

  @override
  String get toquesEnEstaSesion => 'このセッションのタッチ数';

  @override
  String get mejorToqueDeLaSesion => 'セッション最速タッチ';

  @override
  String get accesosRapidos => 'クイックアクセス';

  @override
  String get gestionarUsuarios => 'ユーザー管理';

  @override
  String get vincularPodBle => 'Pod BLEを接続';

  @override
  String get verHistorialTiempos => 'タイム履歴を見る';

  @override
  String get configurarEntrenamiento => 'トレーニング設定';

  @override
  String get cantidadPodsActivos => '使用するPodの数';

  @override
  String get podsAUtilizar => '使用するPod:';

  @override
  String get seleccionaElModo => 'モードを選択';

  @override
  String get porRondas => 'ラウンド指定';

  @override
  String get completaNumeroFijo => '指定した回数をタッチします';

  @override
  String get porTiempo => '時間指定';

  @override
  String get tocaMayorCantidad => '制限時間内にできるだけ多くタッチします';

  @override
  String get modoBicolor => '2色モード';

  @override
  String get desactivaColor1 => '色1をタッチし、色2を無視します';

  @override
  String get modoManual => '手動モード';

  @override
  String get controlaLuzDirectamente => 'アプリから直接ライトを操作します';

  @override
  String get parametrosRondas => 'ラウンド設定';

  @override
  String get parametrosTiempo => '時間設定';

  @override
  String get cantidadRondas => 'ラウンド数:';

  @override
  String get tiempoLimite => '制限時間:';

  @override
  String get mensajeModoManual => '手動モードではマス目を押していつでもPodを点灯・消灯できます。';

  @override
  String get tiempoLimiteColor2 => '色2の制限時間 (妨害色)';

  @override
  String get tiempoParaIgnorar => '無視時間:';

  @override
  String get intervaloEntrePods => 'Pod間のインターバル';

  @override
  String get pausaEntreToques => 'タッチ間のポーズ:';

  @override
  String get coloresBicolor => '2色の設定';

  @override
  String get colorLeds => 'LEDカラー';

  @override
  String get color1ATocar => '色1 (タッチ対象)';

  @override
  String get color2NoTocar => '色2 (タッチ禁止 / 無視)';

  @override
  String get seleccionarColorBase => 'ベースカラーを選択';

  @override
  String get ajusteColorRgb => 'RGBカラー調整:';

  @override
  String get vistaPrevia => 'プレビュー:';

  @override
  String get intensidadLeds => 'LEDの輝度';

  @override
  String get brilloIntensidad => '明るさ / 輝度:';

  @override
  String get iniciarRutina => 'ルーティン開始';

  @override
  String get errorBluetoothRequerido => '開始前にESP32をBluetooth接続してください。';

  @override
  String get conectar => '接続';

  @override
  String get errorBicolorColoresIguales => '2色モードでは異なる2つの色を選択してください。';

  @override
  String get aparatoListo => '準備完了！';

  @override
  String get preparate => '準備してください！';

  @override
  String get atento => '集中！';

  @override
  String tocaPodColor1(Object pod) {
    return 'Pod $podをタッチ！ (色1)';
  }

  @override
  String noTocarColor2(Object pod) {
    return '触るな！ (色2 Pod $pod)';
  }

  @override
  String pasaManoPorPod(Object pod) {
    return 'Pod $podに手をかざしてください！';
  }

  @override
  String get excelenteColorIgnorado => '素晴らしい！ 色2を回避しました。';

  @override
  String get tocaCuadradoEncender => 'マス目を押してPodを点灯';

  @override
  String get seleccionaPodEncender => '点灯させるPodを選択';

  @override
  String get ledApagado => 'LED消灯。';

  @override
  String toqueEnPod(Object pod, Object tiempo) {
    return 'Pod $podをタッチ！ ($tiempo 秒)';
  }

  @override
  String errorTocasteColor2(Object pod) {
    return 'エラー！ Pod $podのColor 2に触れました';
  }

  @override
  String get desconectado => '切断されました';

  @override
  String get errorDesconexionMensaje =>
      'メインPodとのBluetooth接続が切断されました。セッションを一時停止しました。';

  @override
  String get entrenamientoFinalizado => 'トレーニング終了！ 🏆';

  @override
  String usuario(Object nombre) {
    return 'ユーザー: $nombre';
  }

  @override
  String toquesValidos(Object cantidad) {
    return '有効タッチ数: $cantidad';
  }

  @override
  String promedioSegundos(Object promedio) {
    return '平均時間: $promedio 秒';
  }

  @override
  String erroresCometidos(Object errores) {
    return 'ミス数: $errores';
  }

  @override
  String get anotacionesSesionOpcional => 'セッションメモ (任意)';

  @override
  String get hintAnotaciones => '例: 順調な進化、筋疲労あり...';

  @override
  String get guardarYFinalizar => '保存して終了';

  @override
  String modoManualToques(Object cantidad) {
    return '手動モード (タッチ数: $cantidad)';
  }

  @override
  String tiempoRestanteToques(Object cantidad, Object tiempoRestante) {
    return '残り時間: $tiempoRestante秒 | タッチ数: $cantidad';
  }

  @override
  String bicolorRonda(Object rondaActual, Object rondasTotal) {
    return '2色モード | ラウンド $rondaActual / $rondasTotal';
  }

  @override
  String rondaDe(Object rondaActual, Object rondasTotal) {
    return 'ラウンド $rondaActual / $rondasTotal';
  }

  @override
  String tiempoRestante(Object tiempoRestante) {
    return '残り時間: $tiempoRestante秒';
  }

  @override
  String get ultimoTiempoValido => '直近の有効タイム';

  @override
  String get finalizarSesion => 'セッションを終了';

  @override
  String get encendido => '点灯中';

  @override
  String podLabel(Object num) {
    return 'POD $num';
  }

  @override
  String get conectarBluetooth => 'Bluetooth接続';

  @override
  String conectadoExitosamente(Object nombre) {
    return '$nombreに正常に接続されました！';
  }

  @override
  String errorAlConectar(Object error) {
    return '接続エラー: $error';
  }

  @override
  String get dispositivoDesconectado => 'デバイスが切断されました';

  @override
  String get desconectar => '切断';

  @override
  String get conectado => '接続済み';

  @override
  String get dispositivosDisponibles => '利用可能なデバイス:';

  @override
  String get buscandoPods => '近くのPodを検索中...';

  @override
  String get presionaBotonBuscar => '下のボタンを押してPodを検索してください。';

  @override
  String get cancelarBusqueda => '検索をキャンセル';

  @override
  String get buscarDispositivos => 'デバイスを検索';

  @override
  String get editarPerfil => 'プロフィール編集';

  @override
  String get perfilActualizado => 'プロフィールが更新されました';

  @override
  String get errorActualizarPerfil => 'プロフィールの更新に失敗しました';

  @override
  String correoRestablecimientoEnviado(Object email) {
    return 'パスワード再設定用のメールを $email に送信しました。';
  }

  @override
  String get errorCorreoRestablecimiento => '再設定メールの送信に失敗しました。';

  @override
  String get subirFotoPerfil => 'プロフィール写真をアップロード';

  @override
  String get cambiarFotoPerfil => 'プロフィール写真を変更';

  @override
  String get eliminarFoto => '写真を削除';

  @override
  String get informacionPersonal => '個人情報';

  @override
  String get correoNoModificable => 'メールアドレスは直接変更できません。';

  @override
  String get seguridad => 'セキュリティ';

  @override
  String get solicitarRestablecerContrasena => 'メールでリンクを受け取ってパスワードを再設定できます。';

  @override
  String get cambiarContrasena => 'パスワード変更';

  @override
  String get guardarCambios => '変更を保存';

  @override
  String get gestionDeUsuarios => 'ユーザー管理';

  @override
  String get agregar => '追加';

  @override
  String get eliminarUsuario => 'ユーザー削除';

  @override
  String confirmarEliminarUsuario(Object nombre) {
    return '本当に「$nombre」のプロファイルを削除しますか？';
  }

  @override
  String get cancelar => 'キャンセル';

  @override
  String get eliminar => '削除';

  @override
  String get nuevoUsuario => '新規ユーザー';

  @override
  String get editarUsuario => 'ユーザー編集';

  @override
  String get subirFoto => '写真をアップロード';

  @override
  String get cambiarFoto => '写真を変更';

  @override
  String get notasObservaciones => 'メモ / 備考';

  @override
  String get guardar => '保存';

  @override
  String get mejorPromedio => '最高平均タイム';

  @override
  String get mejorTiempo => '最速タイム';

  @override
  String get mejorUltimaSesion => '前回の最速タイム';

  @override
  String get promedioUltimaSesion => '前回の平均タイム';

  @override
  String get iniciaSesionParaGestionar => 'プロファイルを管理するにはログインしてください。';

  @override
  String get perfilPrincipalPropietario => 'メインプロファイル (所有者)';

  @override
  String get sinNombre => '名前なし';

  @override
  String get cuentaPrincipal => 'メインアカウント';

  @override
  String get instruccionGestionUsuarios => 'このセッションでトレーニングするユーザーを選択してください。';

  @override
  String get usuarioRegistrado => '登録済みユーザー';

  @override
  String get ajustes => '設定と各種構成';

  @override
  String felizCumpleanos(Object nombre) {
    return 'お誕生日おめでとうございます、$nombreさん！ 🎂';
  }

  @override
  String get mensajeCumpleanos => 'Activeloチーム一同、素晴らしいトレーニングの日になることを願っています！';

  @override
  String get perfilYModoDeUso => 'プロファイルと利用モード';

  @override
  String get modoProfesional => 'プロフェッショナルモード';

  @override
  String get modoProfesionalDesc => '複数ユーザー管理とセッションメモ機能を有効化します。';

  @override
  String get aparienciaTema => '外観とテーマ';

  @override
  String get modoOscuro => 'ダークモード';

  @override
  String get cambiarTemaClaroOscuro => 'ライトテーマとダークテーマを切り替えます';

  @override
  String get idioma => '言語';

  @override
  String get sonidoRetroalimentacion => 'サウンドとフィードバック';

  @override
  String get efectosSonido => '効果音';

  @override
  String get reproducirSonidosRutina => '開始・終了時に効果音を再生します';

  @override
  String get cuentaPerfil => 'アカウントとプロファイル';

  @override
  String get actualizaInformacionPersonal => '個人情報を更新';

  @override
  String get dispositivosBluetooth => 'Bluetoothデバイス';

  @override
  String get administrarConexiones => '接続とスキャンの管理';

  @override
  String get informacion => 'アプリ情報';

  @override
  String get versionApp => 'バージョン 1.0.0';

  @override
  String get cerrarSesion => 'ログアウト';

  @override
  String get historialSesiones => 'セッション履歴';

  @override
  String get historialIniciaSesion => '履歴を見るにはログインが必要です。';

  @override
  String get sinSesionesRegistradas => 'まだ記録されたセッションはありません。';

  @override
  String get noHaySesionesUsuario => 'このユーザーのセッションはありません。';

  @override
  String get anotacionesDeLaSesion => 'セッションのメモ';

  @override
  String get observacionesDeLaSesion => 'セッションの感想・詳細';

  @override
  String get todos => 'すべて';

  @override
  String toquesCount(Object count) {
    return '$count 回タッチ';
  }

  @override
  String get mejorToque => '最速タッチ';

  @override
  String get promedio => '平均時間';

  @override
  String get errores => 'ミス数';

  @override
  String get sinAnotaciones => 'メモは入力されていません。';

  @override
  String get desglosePorToqueValido => '有効タッチの詳細:';

  @override
  String get legalesYPrivacidad => '法的情報とプライバシー';

  @override
  String get terminosDeUso => '利用規約';

  @override
  String get privacidad => 'プライバシー';

  @override
  String get terminosYCondicionesDeUso => '利用規約および条件';

  @override
  String get ultimaActualizacion => '最終更新: 2026年';

  @override
  String get tituloTerminos1 => '1. 規約への同意';

  @override
  String get textoTerminos1 =>
      'Activeloアプリをダウンロード、登録、または利用することで、お客様は本規約に同意したことになります。';

  @override
  String get tituloTerminos2 => '2. サービス概要';

  @override
  String get textoTerminos2 =>
      'Activeloは、ワイヤレスポッドとの相互作用を通じてアジリティおよびフィジカルトレーニングを制御・追跡するためのプラットフォームです。';

  @override
  String get tituloTerminos3 => '3. ユーザーアカウント';

  @override
  String get textoTerminos3 =>
      '履歴や統計データの同期機能を利用するには、有効なメールアドレスでアカウントを登録する必要があります。';

  @override
  String get tituloTerminos4 => '4. 免責事項と健康状態';

  @override
  String get textoTerminos4 => 'アプリの利用には運動が伴います。医療アドバイスを提供するものではありません。';

  @override
  String get tituloTerminos5 => '5. ハードウェアとワイヤレス通信';

  @override
  String get textoTerminos5 => '本アプリはトレーニングポッドと通信するためにBluetooth機能を利用します。';

  @override
  String get tituloTerminos6 => '6. 規約の変更';

  @override
  String get textoTerminos6 => '当社は事前の通知なくいつでも本規約を変更できる権利を留保します。';

  @override
  String get politicaPrivacidad => 'プライバシーポリシー';

  @override
  String get tituloPrivacidad1 => '1. 収集する情報';

  @override
  String get textoPrivacidad1 =>
      'サービス提供に必要な最小限のデータのみを収集します:\n• 登録メールアドレス\n• 反応時間、タッチ数、モード、日付などのトレーニング指標';

  @override
  String get tituloPrivacidad2 => '2. 必要な権限';

  @override
  String get textoPrivacidad2 => 'デバイス連携のため、Bluetoothおよび位置情報の利用許可を求めます。';

  @override
  String get tituloPrivacidad3 => '3. 情報の利用目的';

  @override
  String get textoPrivacidad3 => '収集したデータは統計計算および履歴表示のみに使用されます。';

  @override
  String get tituloPrivacidad4 => '4. データ保護';

  @override
  String get textoPrivacidad4 => 'クラウド上のデータを保護するためのセキュリティ対策を講じています。';

  @override
  String get tituloPrivacidad5 => '5. データの削除';

  @override
  String get textoPrivacidad5 => 'ユーザーはいつでもアカウントおよびトレーニング記録の削除を要求できます。';

  @override
  String get errorCredencialesIncorrectas => 'メールアドレスまたはパスワードが正しくありません';
}
