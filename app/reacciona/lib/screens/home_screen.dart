import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:go_router/go_router.dart';
import '../provider/bluetooth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _formatTiempo(num? ms) {
    if (ms == null || ms <= 0) return "-- s";
    final segundos = ms / 1000.0;
    return "${segundos.toStringAsFixed(3)} s";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final btState = ref.watch(bluetoothProvider);
    final cardColor = Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LED Trainer',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/config-entrenamiento'),
        icon: const Icon(Icons.play_arrow),
        label: const Text('Entrenar'),
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
                      : "Atleta";

                  return Text(
                    "¡Hola, $nombre! 👋",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: () => context.push('/bluetooth'),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
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
              const SizedBox(height: 16),

              StreamBuilder<DatabaseEvent>(
                stream: user != null
                    ? FirebaseDatabase.instance
                        .ref('usuarios/${user.uid}/tiempos')
                        .onValue
                    : const Stream.empty(),
                builder: (context, snapshot) {
                  num? mejorMs;
                  num? ultimoMs;
                  num? promedioMs;
                  int cantidadIntentos = 0;

                  if (snapshot.hasData &&
                      snapshot.data!.snapshot.value != null) {
                    try {
                      final rawData = snapshot.data!.snapshot.value
                          as Map<dynamic, dynamic>;
                      final List<Map<String, dynamic>> listaIntentos = [];

                      rawData.forEach((key, value) {
                        if (value is Map && value.containsKey('tiempoMs')) {
                          listaIntentos.add({
                            'tiempoMs': value['tiempoMs'] as num,
                            'timestamp': value['timestamp'] ?? 0,
                          });
                        }
                      });

                      if (listaIntentos.isNotEmpty) {
                        cantidadIntentos = listaIntentos.length;

                        listaIntentos.sort((a, b) =>
                            (a['timestamp'] as num).compareTo(b['timestamp'] as num));
                        ultimoMs = listaIntentos.last['tiempoMs'];

                        final listaMs = listaIntentos.map((e) => e['tiempoMs'] as num).toList();
                        listaMs.sort();
                        mejorMs = listaMs.first;

                        final suma = listaMs.reduce((a, b) => a + b);
                        promedioMs = suma / listaMs.length;
                      }
                    } catch (e) {
                      debugPrint("Error al procesar estadísticas: $e");
                    }
                  }

                  final bool tieneUltimaSesion = ultimoMs != null;

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
                              value: _formatTiempo(mejorMs),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.timer_sharp,
                              iconColor: Colors.blue,
                              label: "Último",
                              value: _formatTiempo(ultimoMs),
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
                              "Promedio",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _formatTiempo(promedioMs),
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
                        const Text(
                          "Última sesión",
                          style: TextStyle(
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
                                    "Intentos",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    "$cantidadIntentos",
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
                                    "Récord",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    _formatTiempo(mejorMs),
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
              const SizedBox(height: 8),
              _QuickAccessItem(
                icon: Icons.person_outline,
                title: "Mi perfil",
                onTap: () => context.push('/edit-profile'),
              ),
              const SizedBox(height: 8),
              _QuickAccessItem(
                icon: Icons.settings_outlined,
                title: "Ajustes y Configuración",
                onTap: () => context.push('/settings'),
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

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
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
    );
  }
}