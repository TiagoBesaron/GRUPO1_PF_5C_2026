import 'package:flutter/material.dart';

class TerminosPrivacidadScreen extends StatelessWidget {
  const TerminosPrivacidadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Legales y Privacidad'),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.blueAccent,
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Términos de Uso', icon: Icon(Icons.description_outlined)),
              Tab(text: 'Privacidad', icon: Icon(Icons.security_outlined)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSection(
              isDark: isDark,
              child: const _TerminosDeUsoContent(),
            ),
            _buildSection(
              isDark: isDark,
              child: const _PoliticaPrivacidadContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required bool isDark, required Widget child}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
          ),
        ),
        child: child,
      ),
    );
  }
}

class _TerminosDeUsoContent extends StatelessWidget {
  const _TerminosDeUsoContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Términos y Condiciones de Uso',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'Última actualización: 2026',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Divider(height: 24),
        _TituloSeccion('1. Aceptación de los Términos'),
        _TextoParrafo(
          'Al descargar, registrarte o utilizar la aplicación Activelo, aceptas quedar vinculado por estos Términos y Condiciones. Si no estás de acuerdo con alguno de ellos, debes abstenerte de utilizar la plataforma.',
        ),
        _TituloSeccion('2. Descripción del Servicio'),
        _TextoParrafo(
          'Activelo es una plataforma diseñada para la configuración, control y seguimiento de rutinas de entrenamiento físico y agilidad mediante interacción con dispositivos interactivos inalámbricos.',
        ),
        _TituloSeccion('3. Cuentas de Usuario'),
        _TextoParrafo(
          'Para acceder a la sincronización de tu historial y estadísticas de rendimiento, debes registrar una cuenta con un correo electrónico válido. Eres el único responsable de mantener la confidencialidad de tus credenciales.',
        ),
        _TituloSeccion('4. Responsabilidad y Salud Física'),
        _TextoParrafo(
          'El uso de la aplicación implica la realización de actividad física. Activelo no proporciona asesoramiento médico. Se recomienda realizar una entrada en calor adecuada y suspender el entrenamiento ante cualquier molestia física.',
        ),
        _TituloSeccion('5. Uso del Hardware e Interacción Inalámbrica'),
        _TextoParrafo(
          'La app requiere conectividad inalámbrica para operar con los pods de entrenamiento. El usuario es responsable de operar los dispositivos en un entorno seguro y adecuado.',
        ),
        _TituloSeccion('6. Modificaciones de la Plataforma'),
        _TextoParrafo(
          'Nos reservamos el derecho de modificar o discontinuar funciones del servicio, así como de actualizar estos términos en cualquier momento.',
        ),
      ],
    );
  }
}

class _PoliticaPrivacidadContent extends StatelessWidget {
  const _PoliticaPrivacidadContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Política de Privacidad',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'Última actualización: 2026',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Divider(height: 24),
        _TituloSeccion('1. Información Recopilada'),
        _TextoParrafo(
          'Unicamente recopilamos los datos esenciales para prestar el servicio:\n'
          '• Datos de identificación: Correo electrónico de registro.\n'
          '• Métricas de entrenamiento: Tiempos de reacción, cantidad de toques, modos utilizados y fechas de cada sesión.',
        ),
        _TituloSeccion('2. Permisos Requeridos'),
        _TextoParrafo(
          'Para vincular y transmitir las rutinas a los dispositivos de entrenamiento, la aplicación solicitará permisos de conexión inalámbrica (Bluetooth) y ubicación en los casos exigidos por el sistema operativo.',
        ),
        _TituloSeccion('3. Uso de la Información'),
        _TextoParrafo(
          'Los datos almacenados se utilizan exclusivamente para permitir el acceso a tu cuenta, calcular tus estadísticas de rendimiento personal y mostrarte tu historial de progreso.',
        ),
        _TituloSeccion('4. Protección de Datos'),
        _TextoParrafo(
          'Implementamos medidas de seguridad para proteger tu información almacenada en la nube. No vendemos ni compartimos tus datos personales con terceros para fines comerciales o publicitarios.',
        ),
        _TituloSeccion('5. Eliminación de Datos'),
        _TextoParrafo(
          'Tienes derecho a solicitar la baja definitiva de tu cuenta y la eliminación total de tus registros de entrenamiento en cualquier momento.',
        ),
      ],
    );
  }
}

class _TituloSeccion extends StatelessWidget {
  final String texto;
  const _TituloSeccion(this.texto);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 6.0),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}

class _TextoParrafo extends StatelessWidget {
  final String texto;
  const _TextoParrafo(this.texto);

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 14,
        height: 1.4,
      ),
    );
  }
}