import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  DateTime? _fechaNacimiento;
  bool _isRegistering = false;
  bool _isLoading = false;
  bool _obscurePassword = true;

  final Map<String, String> _idiomasSoportados = const {
    'es': 'Español',
    'en': 'English',
    'fr': 'Français',
    'it': 'Italiano',
    'de': 'Deutsch',
    'pt': 'Português',
    'he': 'עברית',
    'ar': 'العربية',
    'ja': '日本語',
    'zh': '中文',
  };

  Future<void> _seleccionarFechaNacimiento(AppLocalizations loc) async {
    final now = DateTime.now();
    final fecha = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20),
      firstDate: DateTime(1900),
      lastDate: now,
      locale: Locale(ref.read(localeProvider).languageCode),
      helpText: loc.seleccionaTuFechaNacimiento,
      cancelText: loc.cancelar,
      confirmText: loc.guardar,
    );

    if (fecha != null) {
      setState(() {
        _fechaNacimiento = fecha;
      });
    }
  }

  Future<void> _submit(AppLocalizations loc) async {
    if (!_formKey.currentState!.validate()) return;

    if (_isRegistering && _fechaNacimiento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.errorFechaNacimiento),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isRegistering) {
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        final user = userCredential.user;
        if (user != null) {
          final nombre = _nombreController.text.trim();
          await user.updateDisplayName(nombre);

          final ref = FirebaseDatabase.instance.ref('usuarios/${user.uid}');
          await ref.update({
            'nombre': nombre,
            'fecha_nacimiento': _fechaNacimiento!.toIso8601String(),
          });
        }
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }

      if (mounted) {
        context.go('/home');
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String mensaje = "Ocurrió un error al autenticar.";
        if (e.code == 'user-not-found') {
          mensaje = "No existe una cuenta con este correo.";
        } else if (e.code == 'wrong-password') {
          mensaje = "Contraseña incorrecta.";
        } else if (e.code == 'email-already-in-use') {
          mensaje = "El correo ya se encuentra registrado.";
        } else if (e.code == 'weak-password') {
          mensaje = loc.errorContrasenaCorta;
        } else if (e.code == 'invalid-email') {
          mensaje = loc.errorCorreoInvalido;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(mensaje),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // DESPLEGABLE DE IDIOMAS EN LA ESQUINA SUPERIOR DERECHA
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2C2C2C) : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.language, size: 18, color: Colors.blueAccent),
                            const SizedBox(width: 6),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: currentLocale.languageCode,
                                isDense: true,
                                icon: const Icon(Icons.arrow_drop_down, size: 20),
                                items: _idiomasSoportados.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.key,
                                    child: Text(
                                      entry.value,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (langCode) {
                                  if (langCode != null) {
                                    ref.read(localeProvider.notifier).cambiarIdioma(langCode);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Center(
                      child: SizedBox(
                        width: 140,
                        height: 140,
                        child: ClipOval(
                          child: Transform.scale(
                            scale: 1.14,
                            child: Image.asset(
                              'assets/logo.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      loc.appTitle.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isRegistering ? loc.subtituloRegistro : loc.subtituloLogin,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 28),

                    if (_isRegistering) ...[
                      TextFormField(
                        controller: _nombreController,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: loc.nombreCompleto,
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (_isRegistering && (value == null || value.trim().isEmpty)) {
                            return loc.errorNombreVacio;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      InkWell(
                        onTap: () => _seleccionarFechaNacimiento(loc),
                        borderRadius: BorderRadius.circular(12),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: loc.fechaNacimiento,
                            prefixIcon: const Icon(Icons.cake_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _fechaNacimiento != null
                                ? "${_fechaNacimiento!.day.toString().padLeft(2, '0')}/${_fechaNacimiento!.month.toString().padLeft(2, '0')}/${_fechaNacimiento!.year}"
                                : loc.seleccionarFecha,
                            style: TextStyle(
                              color: _fechaNacimiento != null
                                  ? (isDark ? Colors.white : Colors.black87)
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: loc.correoElectronico,
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return loc.errorCorreoVacio;
                        }
                        if (!value.contains('@')) {
                          return loc.errorCorreoInvalido;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(loc),
                      decoration: InputDecoration(
                        labelText: loc.contrasena,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return loc.errorContrasenaVacia;
                        }
                        if (value.length < 6) {
                          return loc.errorContrasenaCorta;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        onPressed: _isLoading ? null : () => _submit(loc),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                _isRegistering ? loc.crearCuenta : loc.iniciarSesion,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          _isRegistering ? loc.alRegistrarteAceptas : loc.alIngresarAceptas,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/terminos-privacidad'),
                          child: Text(
                            loc.terminosYPrivacidad,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isRegistering ? loc.yaTenesCuenta : loc.noTenesCuenta,
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isRegistering = !_isRegistering;
                              _formKey.currentState?.reset();
                            });
                          },
                          child: Text(
                            _isRegistering ? loc.iniciarSesion : loc.registrate,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}