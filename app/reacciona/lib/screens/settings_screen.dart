import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AjustesScreen extends StatefulWidget {
  const AjustesScreen({super.key});

  @override
  State<AjustesScreen> createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  bool _modoOscuro = false;
  bool _notificaciones = true;

  // FUNCIÓN PARA GENERAR Y DESCARGAR EL PDF AUTOMÁTICAMENTE
  Future<void> _generarYDescargarPDF() async {
    final pdf = pw.Document();
    final user = FirebaseAuth.instance.currentUser;
    final nombreUsuario = user?.displayName ?? "Atleta";
    final emailUsuario = user?.email ?? "Sin correo";

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'REACCIONA - LED Trainer',
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'Informe de Proyecto',
                        style: const pw.TextStyle(
                          fontSize: 14,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // DATOS DEL USUARIO
                pw.Text(
                  'Datos del Atleta:',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text('Nombre: $nombreUsuario'),
                pw.Text('Email: $emailUsuario'),
                pw.Text('Fecha de reporte: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),

                // Corrección: pw.Divider envuelto en pw.Padding
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 16),
                  child: pw.Divider(),
                ),

                // RESUMEN DEL PROYECTO
                pw.Text(
                  'Resumen del Sistema:',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'GRUPO1_PF_5C_2026 es una plataforma interactiva de entrenamiento de reflejos y velocidad de reacción.',
                ),
                pw.SizedBox(height: 6),
                pw.Bullet(
                  text: 'Hardware: Módulos de luces LED gestionados vía ESP32.',
                ),
                pw.Bullet(
                  text: 'Conectividad: Comunicación inalámbrica Bluetooth BLE de baja latencia.',
                ),
                pw.Bullet(
                  text: 'Telemetría: Sincronización en tiempo real con Firebase Realtime Database.',
                ),
                pw.Bullet(
                  text: 'Análisis: Registro estadístico de promedios, récord personal e historial de sesiones.',
                ),

                pw.Spacer(),

                pw.Center(
                  child: pw.Text(
                    'Documento generado automáticamente por REACCIONA App',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    // Muestra el diálogo de descarga / impresión automática del sistema
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Resumen_Proyecto_LED_Trainer.pdf',
    );
  }

  // DIÁLOGO CON EL RESUMEN DEL PROYECTO
  void _mostrarResumenProyecto() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.info_outline, color: Colors.blue),
            SizedBox(width: 10),
            Text('Resumen del Proyecto'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'REACCIONA - LED Trainer',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Proyecto Final 5C 2026.\n\n'
                'Sistema integral de entrenamiento táctil y cognitivo diseñado para medir y mejorar el tiempo de reacción en atletas mediante dispositivos LED programables impulsados por ESP32 y Bluetooth BLE.',
              ),
              SizedBox(height: 12),
              Text(
                'Tecnologías:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Flutter & Dart\n• Firebase Realtime Database\n• Bluetooth BLE & ESP32'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _generarYDescargarPDF();
            },
            icon: const Icon(Icons.picture_as_pdf, size: 18),
            label: const Text('Descargar PDF'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final nombre = user?.displayName ?? "Pp";
    final email = user?.email ?? "pollo@gmail.com";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            // TARJETA DE USUARIO
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(Icons.person, color: Colors.blue),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nombre,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          email,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // SECCIÓN PREFERENCIAS
            const Text(
              "Preferencias",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),

            SwitchListTile(
              value: _modoOscuro,
              onChanged: (val) {
                setState(() => _modoOscuro = val);
              },
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text('Modo Oscuro'),
            ),

            SwitchListTile(
              value: _notificaciones,
              onChanged: (val) {
                setState(() => _notificaciones = val);
              },
              secondary: const Icon(Icons.notifications_none),
              title: const Text('Notificaciones'),
            ),

            const Divider(height: 32),

            // SECCIÓN PROYECTO E INFORMES
            const Text(
              "Proyecto & Informes",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),

            ListTile(
              leading: const Icon(Icons.article_outlined),
              title: const Text('Resumen del Proyecto'),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: _mostrarResumenProyecto,
            ),

            ListTile(
              leading: const Icon(Icons.picture_as_pdf_outlined, color: Colors.redAccent),
              title: const Text('Descargar Informe PDF'),
              subtitle: const Text('Descarga automática del resumen'),
              trailing: const Icon(Icons.download, size: 20),
              onTap: _generarYDescargarPDF,
            ),

            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Editar Perfil'),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () => context.push('/edit-profile'),
            ),

            const Divider(height: 32),

            // CERRAR SESIÓN (Corrección de uso síncrono del BuildContext)
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Cerrar Sesión',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;
                context.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}