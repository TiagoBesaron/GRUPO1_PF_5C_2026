import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:go_router/go_router.dart';
import '../provider/bluetooth_provider.dart';
import '../provider/perfil_provider.dart';
import '../provider/user_mode_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _formatTiempo(num? seg) {
    if (seg == null || seg <= 0) return "-- s";
    return "${seg.toStringAsFixed(3)} s";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final btState = ref.watch(bluetoothProvider);
    final perfilActivo = ref.watch(perfilActivoProvider);
    final esModoProfesional = ref.watch(modoProfesionalProvider);
    final cardColor = Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ID del perfil seleccionado actualmente
    final activePerfilId = esModoProfesional
        ? (perfilActivo?.id ?? "principal")
        : "principal";

    return Scaffold(
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
                      : "Entrenador";

                  return Text(
                    "¡Hola, $nombre! 👋",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // TARJETA DE USUARIO SELECCIONADO (SOLO EN MODO PROFESIONAL)
              if (esModoProfesional) ...[
                Material(
                  color: isDark ? const Color(0xFF1E293B) : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => context.push('/gestionar-perfiles'),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: perfilActivo != null ? Colors.blueAccent : Colors.grey,
                            child: Icon(
                              perfilActivo != null ? Icons.person : Icons.people_outline,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Usuario Activo:",
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  perfilActivo?.nombre ?? "Perfil Principal",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () => context.push('/gestionar-perfiles'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            child: const Text('CAMBIAR'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Tarjeta Estado Bluetooth
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
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: btState.conectado ? Colors.green.shade50 : Colors.red.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            btState.conectado ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                            color: btState.conectado ? Colors.green : Colors.redAccent,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Estado del dispositivo",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                btState.conectado
                                    ? "ESP32 Conectado (${btState.device?.platformName.isNotEmpty == true ? btState.device!.platformName : 'Pod BLE'})"
                                    : "ESP32 desconectado",
                                style: TextStyle(
                                  color: btState.conectado ? Colors.green : Colors.grey,
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

              // Estadísticas filtradas EXCLUSIVAMENTE por el usuario activo
              StreamBuilder<DatabaseEvent>(
                stream: user != null
                    ? FirebaseDatabase.instance
                        .ref('usuarios/${user.uid}/sesiones')
                        .onValue
                    : const Stream.empty(),
                builder: (context, snapshot) {
                  num? mejorSeg;
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
                          
                          // Filtrar solo las sesiones del usuario activo
                          if (!esModoProfesional || perfilIdBD == activePerfilId) {
                            final tiemposRaw = value['tiempos'];
                            List<double> tiempos = [];
                            if (tiemposRaw is List) {
                              tiempos = tiemposRaw.map((t) => (t as num).toDouble()).toList();
                            }

                            sesionesUsuario.add({
                              'id': key,
                              'promedio_seg': (value['promedio_seg'] as num?)?.toDouble() ?? 0.0,
                              'tiempos': tiempos,
                              'timestamp': (value['timestamp'] as num?)?.toInt() ?? 0,
                            });
                          }
                        }
                      });

                      if (sesionesUsuario.isNotEmpty) {
                        // Ordenar de más reciente a más antigua
                        sesionesUsuario.sort((a, b) =>
                            (b['timestamp'] as num).compareTo(a['timestamp'] as num));

                        // Datos de la última sesión específica de este usuario
                        final ultimaSesion = sesionesUsuario.first;
                        tieneUltimaSesion = true;
                        final List<double> tiemposUltima = ultimaSesion['tiempos'];
                        toquesUltimaSesion = tiemposUltima.length;
                        if (tiemposUltima.isNotEmpty) {
                          recordUltimaSesion = tiemposUltima.reduce((a, b) => a < b ? a : b);
                        } else {
                          recordUltimaSesion = ultimaSesion['promedio_seg'];
                        }
                        ultimoSeg = ultimaSesion['promedio_seg'];

                        // Cálculo global del usuario activo en todas sus sesiones
                        List<double> todosLosTiempos = [];
                        double sumaPromedios = 0.0;

                        for (var s in sesionesUsuario) {
                          final List<double> listT = s['tiempos'];
                          todosLosTiempos.addAll(listT);
                          sumaPromedios += (s['promedio_seg'] as double);
                        }

                        if (todosLosTiempos.isNotEmpty) {
                          mejorSeg = todosLosTiempos.reduce((a, b) => a < b ? a : b);
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
                              label: "Mejor",
                              value: _formatTiempo(mejorSeg),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.timer_sharp,
                              iconColor: Colors.blue,
                              label: "Último Promedio",
                              value: _formatTiempo(ultimoSeg),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.bar_chart,
                              color: Colors.green,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Promedio General",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _formatTiempo(promedioSeg),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (tieneUltimaSesion) ...[
                        const SizedBox(height: 24),
                        Text(
                          esModoProfesional
                              ? "Última sesión de ${perfilActivo?.nombre ?? 'Perfil Principal'}"
                              : "Última sesión",
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
                              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Toques en esta sesión",
                                    style: TextStyle(color: Colors.grey),
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
                                  const Text(
                                    "Mejor toque de la sesión",
                                    style: TextStyle(color: Colors.grey),
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
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/config-entrenamiento'),
                  icon: const Icon(Icons.play_arrow, size: 20),
                  label: const Text(
                    "COMENZAR ENTRENAMIENTO",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                "Accesos rápidos",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              if (esModoProfesional) ...[
                _QuickAccessItem(
                  icon: Icons.people_outline,
                  title: "Gestionar Usuarios",
                  onTap: () => context.push('/gestionar-perfiles'),
                ),
                const SizedBox(height: 8),
              ],
              _QuickAccessItem(
                icon: Icons.bluetooth,
                title: "Vincular Pod BLE",
                onTap: () => context.push('/bluetooth'),
              ),
              const SizedBox(height: 8),
              _QuickAccessItem(
                icon: Icons.history,
                title: "Ver historial de tiempos",
                onTap: () => context.push('/tiempos'),
              ),
              const SizedBox(height: 40),
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
    final cardColor = Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor;
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
    final cardColor = Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor;
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