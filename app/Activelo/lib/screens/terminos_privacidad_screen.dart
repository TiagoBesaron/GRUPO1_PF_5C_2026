import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class TerminosPrivacidadScreen extends StatelessWidget {
  const TerminosPrivacidadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            loc.legalesYPrivacidad,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
            tabs: [
              Tab(
                text: loc.terminosDeUso,
                icon: const Icon(Icons.description_outlined),
              ),
              Tab(
                text: loc.privacidad,
                icon: const Icon(Icons.security_outlined),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSection(
              isDark: isDark,
              child: _TerminosDeUsoContent(loc: loc),
            ),
            _buildSection(
              isDark: isDark,
              child: _PoliticaPrivacidadContent(loc: loc),
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
  final AppLocalizations loc;
  const _TerminosDeUsoContent({required this.loc});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.terminosYCondicionesDeUso,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          loc.ultimaActualizacion,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const Divider(height: 24),
        _TituloSeccion(loc.tituloTerminos1),
        _TextoParrafo(loc.textoTerminos1),
        _TituloSeccion(loc.tituloTerminos2),
        _TextoParrafo(loc.textoTerminos2),
        _TituloSeccion(loc.tituloTerminos3),
        _TextoParrafo(loc.textoTerminos3),
        _TituloSeccion(loc.tituloTerminos4),
        _TextoParrafo(loc.textoTerminos4),
        _TituloSeccion(loc.tituloTerminos5),
        _TextoParrafo(loc.textoTerminos5),
        _TituloSeccion(loc.tituloTerminos6),
        _TextoParrafo(loc.textoTerminos6),
      ],
    );
  }
}

class _PoliticaPrivacidadContent extends StatelessWidget {
  final AppLocalizations loc;
  const _PoliticaPrivacidadContent({required this.loc});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.politicaPrivacidad,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          loc.ultimaActualizacion,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const Divider(height: 24),
        _TituloSeccion(loc.tituloPrivacidad1),
        _TextoParrafo(loc.textoPrivacidad1),
        _TituloSeccion(loc.tituloPrivacidad2),
        _TextoParrafo(loc.textoPrivacidad2),
        _TituloSeccion(loc.tituloPrivacidad3),
        _TextoParrafo(loc.textoPrivacidad3),
        _TituloSeccion(loc.tituloPrivacidad4),
        _TextoParrafo(loc.textoPrivacidad4),
        _TituloSeccion(loc.tituloPrivacidad5),
        _TextoParrafo(loc.textoPrivacidad5),
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