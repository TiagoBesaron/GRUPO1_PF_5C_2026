import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _cargando = false;
  bool _ocultarPassword = true;
  bool _ocultarConfirmPassword = true;

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (_nombreController.text.trim().isNotEmpty) {
        await userCredential.user
            ?.updateDisplayName(_nombreController.text.trim());
      }

      if (mounted) {
        context.go('/home');
      }
    } on FirebaseAuthException catch (e) {
      String mensaje = "Ocurrió un error al registrar la cuenta.";

      if (e.code == 'email-already-in-use') {
        mensaje = "El correo electrónico ya está registrado.";
      } else if (e.code == 'invalid-email') {
        mensaje = "El correo electrónico no es válido.";
      } else if (e.code == 'weak-password') {
        mensaje = "La contraseña debe tener al menos 6 caracteres.";
      } else if (e.code == 'network-request-failed') {
        mensaje = "Sin conexión a internet. Verificá tu red.";
      }

      _mostrarError(mensaje);
    } catch (e) {
      _mostrarError("No se pudo crear la cuenta. Intentá más tarde.");
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  void _mostrarError(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Cuenta"),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Registro de Usuario",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // CAMPO NOMBRE
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: "Nombre completo",
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Ingresá tu nombre";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // CAMPO EMAIL
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Correo Electrónico",
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Ingresá tu correo";
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return "Ingresá un correo válido (ej: usuario@mail.com)";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // CAMPO CONTRASEÑA
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _ocultarPassword,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _ocultarPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _ocultarPassword = !_ocultarPassword;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Ingresá una contraseña";
                      }
                      if (value.length < 6) {
                        return "Debe tener al menos 6 caracteres";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // CAMPO CONFIRMAR CONTRASEÑA
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _ocultarConfirmPassword,
                    decoration: InputDecoration(
                      labelText: "Confirmar Contraseña",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _ocultarConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _ocultarConfirmPassword =
                                !_ocultarConfirmPassword;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Confirmá tu contraseña";
                      }
                      if (value != _passwordController.text) {
                        return "Las contraseñas no coinciden";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // BOTÓN DE REGISTRO
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _cargando ? null : _registrar,
                      child: _cargando
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              "CREAR CUENTA",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // VOLVER A LOGIN
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("¿Ya tenés cuenta?"),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text("Iniciá sesión"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}