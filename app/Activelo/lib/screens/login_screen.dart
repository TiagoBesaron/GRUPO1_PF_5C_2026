import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../provider/locale_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  static const Map<String, String> _idiomasDisponibles = {
    'es': '🇦🇷 Español',
    'en': '🇺🇸 English',
    'pt': '🇧🇷 Português',
    'it': '🇮🇹 Italiano',
    'fr': '🇫🇷 Français',
    'de': '🇩🇪 Deutsch',
    'ar': '🇸🇦 العربية',
    'he': '🇮🇱 עברית',
    'ja': '🇯🇵 日本語',
    'zh': '🇨🇳 中文',
  };

  static const Map<String, Map<String, String>> _textosReset = {
    'es': {
      'forgot': '¿Olvidaste tu contraseña?',
      'title': 'Restablecer contraseña',
      'desc':
          'Ingresá tu correo electrónico y te enviaremos un enlace para crear una nueva contraseña.',
      'cancel': 'Cancelar',
      'send': 'Enviar enlace',
      'sent':
          'Si el correo está registrado, te enviamos un enlace para restablecer tu contraseña. Revisá también spam.',
      'notFound': 'No encontramos ninguna cuenta con ese correo.',
      'error': 'No se pudo enviar el correo. Intentá de nuevo más tarde.',
    },
    'en': {
      'forgot': 'Forgot password?',
      'title': 'Reset password',
      'desc':
          'Enter your email address and we will send you a link to create a new password.',
      'cancel': 'Cancel',
      'send': 'Send link',
      'sent':
          'If the email is registered, we sent you a password reset link. Check your spam folder too.',
      'notFound': 'No account found with that email.',
      'error': 'Could not send email. Please try again later.',
    },
    'pt': {
      'forgot': 'Esqueceu sua senha?',
      'title': 'Redefinir senha',
      'desc':
          'Digite seu e-mail e enviaremos um link para criar uma nova senha.',
      'cancel': 'Cancelar',
      'send': 'Enviar link',
      'sent':
          'Se o e-mail estiver cadastrado, enviamos um link para redefinir sua senha. Verifique também o spam.',
      'notFound': 'Nenhuma conta encontrada com esse e-mail.',
      'error': 'Não foi possível enviar o e-mail. Tente novamente mais tarde.',
    },
    'it': {
      'forgot': 'Password dimenticata?',
      'title': 'Reimposta password',
      'desc':
          'Inserisci la tua email e ti invieremo un link per creare una nuova password.',
      'cancel': 'Annulla',
      'send': 'Invia link',
      'sent':
          'Se l’email è registrata, ti abbiamo inviato un link per reimpostare la password. Controlla anche lo spam.',
      'notFound': 'Nessun account trovato con questa email.',
      'error': 'Impossibile inviare l’email. Riprova più tardi.',
    },
    'fr': {
      'forgot': 'Mot de passe oublié ?',
      'title': 'Réinitialiser le mot de passe',
      'desc':
          'Entrez votre adresse e-mail et nous vous enverrons un lien pour créer un nouveau mot de passe.',
      'cancel': 'Annuler',
      'send': 'Envoyer le lien',
      'sent':
          'Si l’e-mail est enregistré, un lien de réinitialisation vous a été envoyé. Vérifiez aussi vos spams.',
      'notFound': 'Aucun compte trouvé avec cet e-mail.',
      'error': 'Impossible d’envoyer l’e-mail. Réessayez plus tard.',
    },
    'de': {
      'forgot': 'Passwort vergessen?',
      'title': 'Passwort zurücksetzen',
      'desc':
          'Gib deine E-Mail-Adresse ein und wir senden dir einen Link zum Erstellen eines neuen Passworts.',
      'cancel': 'Abbrechen',
      'send': 'Link senden',
      'sent':
          'Falls die E-Mail registriert ist, haben wir dir einen Link gesendet. Prüfe auch den Spam-Ordner.',
      'notFound': 'Kein Konto mit dieser E-Mail gefunden.',
      'error':
          'E-Mail konnte nicht gesendet werden. Bitte später erneut versuchen.',
    },
    'ar': {
      'forgot': 'هل نسيت كلمة المرور؟',
      'title': 'إعادة تعيين كلمة المرور',
      'desc':
          'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإنشاء كلمة مرور جديدة.',
      'cancel': 'إلغاء',
      'send': 'إرسال الرابط',
      'sent':
          'إذا كان البريد مسجلاً، فقد أرسلنا رابط إعادة التعيين. تحقق من البريد العشوائي أيضًا.',
      'notFound': 'لم يتم العثور على حساب بهذا البريد.',
      'error': 'تعذر إرسال البريد الإلكتروني. حاول لاحقًا.',
    },
    'he': {
      'forgot': 'שכחת סיסמה?',
      'title': 'איפוס סיסמה',
      'desc': 'הזן את כתובת האימייל שלך ונשלח לך קישור ליצירת סיסמה חדשה.',
      'cancel': 'ביטול',
      'send': 'שלח קישור',
      'sent':
          'אם האימייל רשום, שלחנו לך קישור לאיפוס הסיסמה. בדוק גם בתיקיית הספאם.',
      'notFound': 'לא נמצא חשבון עם אימייל זה.',
      'error': 'לא ניתן לשלוח את האימייל. נסה שוב מאוחר יותר.',
    },
    'ja': {
      'forgot': 'パスワードをお忘れですか？',
      'title': 'パスワードの再設定',
      'desc':
          'メールアドレスを入力すると、新しいパスワードを作成するリンクをお送りします。',
      'cancel': 'キャンセル',
      'send': 'リンクを送信',
      'sent':
          '登録されている場合、再設定用リンクを送信しました。迷惑メールフォルダもご確認ください。',
      'notFound': 'このメールアドレスのアカウントが見つかりません。',
      'error': 'メールを送信できませんでした。後でもう一度お試しください。',
    },
    'zh': {
      'forgot': '忘记密码？',
      'title': '重置密码',
      'desc': '输入您的电子邮箱，我们将向您发送创建新密码的链接。',
      'cancel': '取消',
      'send': '发送链接',
      'sent': '如果该邮箱已注册，我们已发送重置链接，请同时检查垃圾邮件箱。',
      'notFound': '未找到使用该邮箱的账户。',
      'error': '无法发送邮件，请稍后再试。',
    },
  };

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _mapAuthError(FirebaseAuthException e, AppLocalizations l10n) {
    switch (e.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
      case 'INVALID_LOGIN_CREDENTIALS':
        return l10n.errorCredencialesIncorrectas;
      case 'invalid-email':
        return l10n.errorCorreoInvalido;
      default:
        return l10n.errorCredencialesIncorrectas;
    }
  }

  Future<void> _mostrarDialogoRestablecer(
      AppLocalizations l10n, String langCode) async {
    final textos = _textosReset[langCode] ?? _textosReset['es']!;
    final resetEmailController =
        TextEditingController(text: _emailController.text.trim());
    final resetFormKey = GlobalKey<FormState>();

    bool enviando = false;
    String? errorDialog;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(Icons.lock_reset_rounded, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  textos['title']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Form(
            key: resetFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  textos['desc']!,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: resetEmailController,
                  enabled: !enviando,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) {
                    if (errorDialog != null) {
                      setDialogState(() => errorDialog = null);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: l10n.correoElectronico,
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.errorCorreoVacio;
                    }
                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );
                    if (!emailRegex.hasMatch(value.trim())) {
                      return l10n.errorCorreoInvalido;
                    }
                    return null;
                  },
                ),
                if (errorDialog != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    errorDialog!,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed:
                  enviando ? null : () => Navigator.of(dialogContext).pop(),
              child: Text(textos['cancel']!),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: enviando
                  ? null
                  : () async {
                      if (!resetFormKey.currentState!.validate()) return;

                      setDialogState(() {
                        enviando = true;
                        errorDialog = null;
                      });

                      try {
                        await FirebaseAuth.instance.setLanguageCode(langCode);
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: resetEmailController.text.trim(),
                        );

                        if (dialogContext.mounted) {
                          Navigator.of(dialogContext).pop();
                        }

                        if (!mounted) return;
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.green.shade700,
                              duration: const Duration(seconds: 5),
                              content: Row(
                                children: [
                                  const Icon(Icons.mark_email_read_rounded,
                                      color: Colors.white),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      textos['sent']!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                      } on FirebaseAuthException catch (e) {
                        if (!dialogContext.mounted) return;
                        setDialogState(() {
                          enviando = false;
                          if (e.code == 'user-not-found') {
                            errorDialog = textos['notFound'];
                          } else if (e.code == 'invalid-email') {
                            errorDialog = l10n.errorCorreoInvalido;
                          } else {
                            errorDialog = textos['error'];
                          }
                        });
                      } catch (_) {
                        if (!dialogContext.mounted) return;
                        setDialogState(() {
                          enviando = false;
                          errorDialog = textos['error'];
                        });
                      }
                    },
              child: enviando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(textos['send']!),
            ),
          ],
        ),
      ),
    );

    resetEmailController.dispose();
  }

  Future<void> _login(AppLocalizations l10n) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) {
        context.go('/home');
      }
    } on FirebaseAuthException catch (e) {
      final message = _mapAuthError(e, l10n);
      if (!mounted) return;
      setState(() {
        _errorMessage = message;
      });
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
    } catch (_) {
      final message = l10n.errorCredencialesIncorrectas;
      if (!mounted) return;
      setState(() {
        _errorMessage = message;
      });
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final currentLocale = ref.watch(localeProvider);
    final selectedLang =
        _idiomasDisponibles.containsKey(currentLocale.languageCode)
            ? currentLocale.languageCode
            : 'es';
    final textosResetActual =
        _textosReset[selectedLang] ?? _textosReset['es']!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Desplegable de idioma arriba a la derecha
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedLang,
                      isDense: true,
                      borderRadius: BorderRadius.circular(12),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20,
                      ),
                      items: _idiomasDisponibles.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text(
                            entry.value,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (nuevoCodigo) {
                        if (nuevoCodigo != null) {
                          ref
                              .read(localeProvider.notifier)
                              .cambiarIdioma(nuevoCodigo);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Contenido centrado del login
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo circular y más grande
                        Center(
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.blue.withValues(alpha: 0.25),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/logo.png',
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.blue.withValues(alpha: 0.1),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.sports_score_rounded,
                                      size: 84,
                                      color: Colors.blue,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.appTitle,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.subtituloLogin,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (_) {
                                      if (_errorMessage != null) {
                                        setState(() => _errorMessage = null);
                                      }
                                    },
                                    decoration: InputDecoration(
                                      labelText: l10n.correoElectronico,
                                      prefixIcon:
                                          const Icon(Icons.email_outlined),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return l10n.errorCorreoVacio;
                                      }
                                      final emailRegex = RegExp(
                                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                      );
                                      if (!emailRegex.hasMatch(value.trim())) {
                                        return l10n.errorCorreoInvalido;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) => _login(l10n),
                                    onChanged: (_) {
                                      if (_errorMessage != null) {
                                        setState(() => _errorMessage = null);
                                      }
                                    },
                                    decoration: InputDecoration(
                                      labelText: l10n.contrasena,
                                      prefixIcon:
                                          const Icon(Icons.lock_outline),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return l10n.errorContrasenaVacia;
                                      }
                                      return null;
                                    },
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 4,
                                        ),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: _isLoading
                                          ? null
                                          : () => _mostrarDialogoRestablecer(
                                              l10n, selectedLang),
                                      child: Text(
                                        textosResetActual['forgot']!,
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_errorMessage != null) ...[
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.red.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.red.shade400,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            color: Colors.red.shade700,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              _errorMessage!,
                                              style: TextStyle(
                                                color: Colors.red.shade700,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: _isLoading
                                          ? null
                                          : () => _login(l10n),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              height: 22,
                                              width: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Text(
                                              l10n.iniciarSesion.toUpperCase(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${l10n.noTenesCuenta} ',
                              style: theme.textTheme.bodyMedium,
                            ),
                            GestureDetector(
                              onTap: () => context.go('/register'),
                              child: Text(
                                l10n.registrate,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text.rich(
                          TextSpan(
                            text: '${l10n.alIngresarAceptas} ',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            children: [
                              TextSpan(
                                text: l10n.terminosYPrivacidad,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap =
                                      () => context.push('/terminos-privacidad'),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}