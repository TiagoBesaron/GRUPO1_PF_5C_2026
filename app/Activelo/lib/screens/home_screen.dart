import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../provider/bluetooth_provider.dart';
import '../provider/perfil_provider.dart';
import '../provider/user_mode_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _formatTiempo(num? seg) {
    if (seg == null || seg <= 0) return "-- s";
    return "${seg.toStringAsFixed(3)} s";
  }

  ImageProvider? _obtenerImagen(String? photoUrl) {
    if (photoUrl == null || photoUrl.isEmpty) return null;
    if (photoUrl.startsWith('data:image')) {
      try {
        final base64Str = photoUrl.split(',').last;
        return MemoryImage(base64Decode(base64Str));
      } catch (_) {
        return null;
      }
    }
    return NetworkImage(photoUrl);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final btState = ref.watch(bluetoothProvider);
    final perfilActivo = ref.watch(perfilActivoProvider);
    final esModoProfesional = ref.watch(modoProfesionalProvider);
    final cardColor =
        Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<BluetoothState>(bluetoothProvider, (prev, next) {
      if (prev != null &&
          prev.desconexionInesperadaTicket != next.desconexionInesperadaTicket) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.bluetooth_disabled, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(loc.errorDesconexionMensaje),
                  ),
                ],
              ),
              backgroundColor: Colors.redAccent,
              duration: const Duration(seconds: 4),
            ),
          );
      }
    });

    final activePerfilId =
        esModoProfesional ? (perfilActivo?.id ?? "principal") : "principal";

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/config-entrenamiento'),
        icon: const Icon(Icons.play_arrow),
        label: Text(
          loc.entrenar,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<User?>(
                stream: FirebaseAuth.instance.userChanges(),
                builder: (context, snapshot) {
                  final currentUser = snapshot.data ?? user;
                  final nombre = (currentUser?.displayName != null &&
                          currentUser!.displayName!.isNotEmpty)
                      ? currentUser.displayName!
                      : loc.entrenador;

                  return Text(
                    loc.holaEntrenador(nombre),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              if (esModoProfesional) ...[
                StreamBuilder<DatabaseEvent>(
                  stream: user != null
                      ? FirebaseDatabase.instance
                          .ref('usuarios/${user.uid}')
                          .onValue
                      : const Stream.empty(),
                  builder: (context, snapshotUser) {
                    String nombreMostrado =
                        perfilActivo?.nombre ?? loc.perfilPrincipal;
                    String subtituloMostrado = perfilActivo == null
                        ? loc.perfilPrincipalPropietario
                        : '';
                    String? photoUrlMostrada =
                        perfilActivo == null ? user?.photoURL : null;

                    if (snapshotUser.hasData &&
                        snapshotUser.data!.snapshot.value is Map) {
                      final userData = Map<String, dynamic>.from(
                          snapshotUser.data!.snapshot.value as Map);

                      if (perfilActivo == null) {
                        if (userData['nombre'] != null &&
                            userData['nombre'].toString().trim().isNotEmpty) {
                          nombreMostrado = userData['nombre'].toString().trim();
                        } else if (user?.displayName != null &&
                            user!.displayName!.trim().isNotEmpty) {
                          nombreMostrado = user.displayName!.trim();
                        }
                        if (userData['photoUrl'] != null &&
                            userData['photoUrl'].toString().isNotEmpty) {
                          photoUrlMostrada = userData['photoUrl'].toString();
                        }
                      } else if (userData['perfiles'] is Map) {
                        final perfilesMap =
                            Map<String, dynamic>.from(userData['perfiles']);
                        final perfilRaw = perfilesMap[perfilActivo.id];
                        if (perfilRaw is Map) {
                          if (perfilRaw['nombre'] != null &&
                              perfilRaw['nombre'].toString().trim().isNotEmpty) {
                            nombreMostrado =
                                perfilRaw['nombre'].toString().trim();
                          }
                          subtituloMostrado =
                              (perfilRaw['notas'] ?? '').toString().trim();
                          if (perfilRaw['photoUrl'] != null &&
                              perfilRaw['photoUrl'].toString().isNotEmpty) {
                            photoUrlMostrada = perfilRaw['photoUrl'].toString();
                          }
                        }
                      }
                    }

                    final avatarImg = _obtenerImagen(photoUrlMostrada);

                    return Material(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () => context.push('/gestionar-perfiles'),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.blueAccent,
                                backgroundImage: avatarImg,
                                child: avatarImg == null
                                    ? Text(
                                        nombreMostrado.isNotEmpty
                                            ? nombreMostrado[0].toUpperCase()
                                            : 'U',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      loc.usuarioActivo,
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.grey),
                                    ),
                                    Text(
                                      nombreMostrado,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (subtituloMostrado.isNotEmpty)
                                      Text(
                                        subtituloMostrado,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark
                                              ? Colors.grey.shade400
                                              : Colors.grey.shade700,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: () =>
                                    context.push('/gestionar-perfiles'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                ),
                                child: Text(loc.cambiar),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],

              Material(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => context.push('/bluetooth'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: btState.conectado
                                ? Colors.green.shade50
                                : Colors.red.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            btState.conectado
                                ? Icons.bluetooth_connected
                                : Icons.bluetooth_disabled,
                            color: btState.conectado
                                ? Colors.green
                                : Colors.redAccent,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.estadoDispositivo,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                btState.conectado
                                    ? loc.esp32Conectado(
                                        btState.device?.platformName
                                                    .isNotEmpty ==
                                                true
                                            ? btState.device!.platformName
                                            : loc.podBle)
                                    : loc.esp32Desconectado,
                                style: TextStyle(
                                  color: btState.conectado
                                      ? Colors.green
                                      : Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.bluetooth,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              StreamBuilder<DatabaseEvent>(
                stream: user != null
                    ? FirebaseDatabase.instance
                        .ref('usuarios/${user.uid}/sesiones')
                        .onValue
                    : const Stream.empty(),
                builder: (context, snapshot) {
                  num? mejorSeg;
                  num? mejorPromedioSeg;
                  num? ultimoSeg;
                  num? promedioSeg;
                  int toquesUltimaSesion = 0;
                  num? recordUltimaSesion;
                  bool tieneUltimaSesion = false;

                  if (snapshot.hasData &&
                      snapshot.data!.snapshot.value != null) {
                    try {
                      final rawData = snapshot.data!.snapshot.value
                          as Map<dynamic, dynamic>;
                      final List<Map<String, dynamic>> sesionesUsuario = [];

                      rawData.forEach((key, value) {
                        if (value is Map) {
                          final perfilIdBD = value['perfil_id'] ?? 'principal';

                          if (!esModoProfesional ||
                              perfilIdBD == activePerfilId) {
                            final tiemposRaw = value['tiempos'];
                            List<double> tiempos = [];
                            if (tiemposRaw is List) {
                              tiempos = tiemposRaw
                                  .map((t) => (t as num).toDouble())
                                  .toList();
                            } else if (tiemposRaw is Map) {
                              tiemposRaw.forEach((k, v) {
                                if (v is num) tiempos.add(v.toDouble());
                              });
                            }

                            sesionesUsuario.add({
                              'id': key,
                              'promedio_seg':
                                  (value['promedio_seg'] as num?)?.toDouble() ??
                                      0.0,
                              'tiempos': tiempos,
                              'timestamp':
                                  (value['timestamp'] as num?)?.toInt() ?? 0,
                            });
                          }
                        }
                      });

                      if (sesionesUsuario.isNotEmpty) {
                        sesionesUsuario.sort((a, b) => (b['timestamp'] as num)
                            .compareTo(a['timestamp'] as num));

                        final ultimaSesion = sesionesUsuario.first;
                        tieneUltimaSesion = true;
                        final List<double> tiemposUltima =
                            ultimaSesion['tiempos'];
                        toquesUltimaSesion = tiemposUltima.length;
                        if (tiemposUltima.isNotEmpty) {
                          recordUltimaSesion =
                              tiemposUltima.reduce((a, b) => a < b ? a : b);
                        } else {
                          recordUltimaSesion = ultimaSesion['promedio_seg'];
                        }
                        ultimoSeg = ultimaSesion['promedio_seg'];

                        mejorPromedioSeg = sesionesUsuario
                            .map((s) => s['promedio_seg'] as double)
                            .reduce((a, b) => a < b ? a : b);

                        List<double> todosLosTiempos = [];
                        double sumaPromedios = 0.0;

                        for (var s in sesionesUsuario) {
                          final List<double> listT = s['tiempos'];
                          todosLosTiempos.addAll(listT);
                          sumaPromedios += (s['promedio_seg'] as double);
                        }

                        if (todosLosTiempos.isNotEmpty) {
                          mejorSeg =
                              todosLosTiempos.reduce((a, b) => a < b ? a : b);
                        }
                        promedioSeg = sumaPromedios / sesionesUsuario.length;
                      }
                    } catch (e) {
                      debugPrint("Error al procesar estadísticas: $e");
                    }
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              icon: Icons.emoji_events,
                              iconColor: Colors.amber,
                              label: loc.mejor,
                              value: _formatTiempo(mejorSeg),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.star,
                              iconColor: Colors.orangeAccent,
                              label: loc.mejorPromedio,
                              value: _formatTiempo(mejorPromedioSeg),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              icon: Icons.timer_sharp,
                              iconColor: Colors.blue,
                              label: loc.ultimoPromedio,
                              value: _formatTiempo(ultimoSeg),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.bar_chart,
                              iconColor: Colors.green,
                              label: loc.promedioGeneral,
                              value: _formatTiempo(promedioSeg),
                            ),
                          ),
                        ],
                      ),

                      if (tieneUltimaSesion) ...[
                        const SizedBox(height: 24),
                        Text(
                          esModoProfesional
                              ? loc.ultimaSesionDe(
                                  perfilActivo?.nombre ?? loc.perfilPrincipal)
                              : loc.ultimaSesion,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade200,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    loc.toquesEnEstaSesion,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    "$toquesUltimaSesion",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    loc.mejorToqueDeLaSesion,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    _formatTiempo(recordUltimaSesion),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              Text(
                loc.accesosRapidos,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              if (esModoProfesional) ...[
                _QuickAccessItem(
                  icon: Icons.people_outline,
                  title: loc.gestionarUsuarios,
                  onTap: () => context.push('/gestionar-perfiles'),
                ),
                const SizedBox(height: 8),
              ],
              _QuickAccessItem(
                icon: Icons.bluetooth,
                title: loc.vincularPodBle,
                onTap: () => context.push('/bluetooth'),
              ),
              const SizedBox(height: 8),
              _QuickAccessItem(
                icon: Icons.history,
                title: loc.verHistorialTiempos,
                onTap: () => context.push('/tiempos'),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor =
        Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAccessItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _QuickAccessItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor =
        Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
        ),
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: Colors.blue),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}