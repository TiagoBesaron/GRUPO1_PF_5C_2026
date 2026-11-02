import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _emailController;
  String? _photoUrl;
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _nombreController = TextEditingController(text: user?.displayName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _cargarFotoPerfil();
  }

  Future<void> _cargarFotoPerfil() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final snapshot = await FirebaseDatabase.instance
            .ref('usuarios/${user.uid}/photoUrl')
            .get();
        if (snapshot.exists && snapshot.value != null) {
          setState(() {
            _photoUrl = snapshot.value.toString();
          });
        } else if (user.photoURL != null && user.photoURL!.isNotEmpty) {
          setState(() {
            _photoUrl = user.photoURL;
          });
        }
      } catch (e) {
        debugPrint("Error al cargar foto de perfil: $e");
      }
    }
  }

  Future<void> _seleccionarFoto() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null) {
          final base64Str = base64Encode(file.bytes!);
          final ext = file.name.contains('.')
              ? file.name.split('.').last.toLowerCase()
              : 'jpg';
          final mime = ext == 'png' ? 'image/png' : 'image/jpeg';

          setState(() {
            _photoUrl = 'data:$mime;base64,$base64Str';
          });
        }
      }
    } catch (e) {
      debugPrint('Error al seleccionar imagen: $e');
    }
  }

  Future<void> _guardarCambios(AppLocalizations loc) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final nuevoNombre = _nombreController.text.trim();
        await user.updateDisplayName(nuevoNombre);

        final updates = <String, dynamic>{
          'nombre': nuevoNombre,
          'photoUrl': _photoUrl,
        };

        if (_photoUrl != null &&
            _photoUrl!.isNotEmpty &&
            !_photoUrl!.startsWith('data:')) {
          try {
            await user.updatePhotoURL(_photoUrl);
          } catch (e) {
            debugPrint("updatePhotoURL ignorado por formato Base64: $e");
          }
        } else if (_photoUrl == null) {
          try {
            await user.updatePhotoURL(null);
          } catch (_) {}
        }

        final ref = FirebaseDatabase.instance.ref('usuarios/${user.uid}');
        await ref.update(updates);
        await user.reload();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.perfilActualizado),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      }
    } catch (e) {
      debugPrint("Error al guardar perfil: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.errorActualizarPerfil),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  Future<void> _enviarCorreoCambioPassword(AppLocalizations loc) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) return;

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.correoRestablecimientoEnviado(user.email!)),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.errorCorreoRestablecimiento),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  ImageProvider? _getAvatarImage() {
    if (_photoUrl != null && _photoUrl!.isNotEmpty) {
      if (_photoUrl!.startsWith('data:image')) {
        try {
          final base64Str = _photoUrl!.split(',').last;
          return MemoryImage(base64Decode(base64Str));
        } catch (_) {}
      } else {
        return NetworkImage(_photoUrl!);
      }
    }
    return null;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avatarImage = _getAvatarImage();

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.editarPerfil),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _seleccionarFoto,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 52,
                          backgroundColor:
                              Colors.blueAccent.withValues(alpha: 0.15),
                          backgroundImage: avatarImage,
                          child: avatarImage == null
                              ? const Icon(
                                  Icons.person,
                                  size: 64,
                                  color: Colors.blueAccent,
                                )
                              : null,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: _seleccionarFoto,
                    child: Text(
                      _photoUrl == null ? loc.subirFotoPerfil : loc.cambiarFotoPerfil,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
                if (_photoUrl != null && _photoUrl!.isNotEmpty)
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _photoUrl = null;
                        });
                      },
                      icon: const Icon(Icons.delete_outline,
                          size: 18, color: Colors.redAccent),
                      label: Text(
                        loc.eliminarFoto,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc.informacionPersonal,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nombreController,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: loc.nombreCompleto,
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return loc.errorNombreVacio;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: loc.correoElectronico,
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            helperText: loc.correoNoModificable,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc.seguridad,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          loc.solicitarRestablecerContrasena,
                          style: TextStyle(
                            fontSize: 13,
                            color:
                                isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: () => _enviarCorreoCambioPassword(loc),
                            icon: const Icon(Icons.mark_email_read_outlined,
                                color: Colors.blueAccent),
                            label: Text(
                              loc.cambiarContrasena,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.blueAccent,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.blueAccent),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

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
                    onPressed: _cargando ? null : () => _guardarCambios(loc),
                    child: _cargando
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            loc.guardarCambios,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}