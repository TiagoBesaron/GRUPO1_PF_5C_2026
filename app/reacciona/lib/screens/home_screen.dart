import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _formatTiempo(num? ms) {
    if (ms == null || ms <= 0) return "-- s";
    final segundos = ms / 1000.0;
    return "${segundos.toStringAsFixed(3)} s";
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
              // SALUDO DINÁMICO
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

              // ESTADO DEL DISPOSITIVO ESP32
              InkWell(
                onTap: () => context.push('/bluetooth'),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.bluetooth_disabled,
                          color: Colors.redAccent,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Estado del dispositivo",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "ESP32 desconectado",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.bluetooth,
                        color: Colors.black54,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // STREAM DE TIEMPOS Y ÚLTIMA SESIÓN DESDE FIREBASE
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
                      final List<num> lista = [];

                      rawData.forEach((key, value) {
                        if (value is Map && value.containsKey('tiempoMs')) {
                          final ms = value['tiempoMs'] as num;
                          lista.add(ms);
                          ultimoMs = ms;
                        }
                      });

                      if (lista.isNotEmpty) {
                        cantidadIntentos = lista.length;
                        lista.sort();
                        mejorMs = lista.first;
                        final suma = lista.reduce((a, b) => a + b);
                        promedioMs = suma / lista.length;
                      }
                    } catch (e) {
                      debugPrint("Error al procesar estadísticas: $e");
                    }
                  }

                  final bool tieneUltimaSesion = ultimoMs != null;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CARDS DE MEJOR Y ÚLTIMO
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

                      // PROMEDIO
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
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

                      // ÚLTIMA SESIÓN: SOLO SE MUESTRA SI EXISTE AL MENOS UN REGISTRO
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
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
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

              // BOTÓN COMENZAR ENTRENAMIENTO
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/config-entrenamiento'),
                  icon: const Icon(Icons.play_arrow, size: 18),
                  label: const Text(
                    "COMENZAR ENTRENAMIENTO",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFF8F9FA),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ACCESOS RÁPIDOS
              const Text(
                "Accesos rápidos",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

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
                title: "Configuración",
                onTap: () => context.push('/edit-profile'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// COMPONENTE TARJETA DE ESTADÍSTICA (MEJOR / ÚLTIMO)
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
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

// COMPONENTE ITEM DE ACCESO RÁPIDO
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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.black87),
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