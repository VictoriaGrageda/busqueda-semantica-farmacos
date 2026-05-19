import 'package:flutter/material.dart';

void main() {
  runApp(const FarmacoSearchApp());
}

class FarmacoSearchApp extends StatelessWidget {
  const FarmacoSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Búsqueda farmacológica',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF2563EB),
      ),
      home: const SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  Map<String, dynamic>? resultado;
  String mensaje = '';

  void buscar() {
    final consulta = _controller.text.toLowerCase().trim();

    if (consulta.isEmpty) {
      setState(() {
        resultado = null;
        mensaje = 'Ingrese una consulta farmacológica.';
      });
      return;
    }

    if (consulta.contains('fiebre') ||
        consulta.contains('paracetamol') ||
        consulta.contains('parasetmol')) {
      setState(() {
        mensaje = '';
        resultado = {
          'medicamento': 'Paracetamol',
          'principio_activo': 'Paracetamol',
          'grupo': 'Analgésico y antipirético',
          'indicaciones': ['dolor', 'fiebre'],
          'contraindicaciones': ['hipersensibilidad al principio activo'],
          'reacciones': [
            'náuseas',
            'rash cutáneo',
            'hepatotoxicidad en sobredosis',
          ],
          'via': ['oral'],
        };
      });
    } else {
      setState(() {
        resultado = null;
        mensaje = 'No se encontró información relacionada con la consulta.';
      });
    }
  }

  Widget dato(String titulo, String contenido) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 15, color: Colors.white),
          children: [
            TextSpan(
              text: '$titulo: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: contenido),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscador farmacológico'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Consulta información farmacológica mediante búsqueda semántica.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText:
                    'Buscar medicamento, principio activo o indicación...',
                filled: true,
                fillColor: const Color(0xFF1E293B),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: buscar,
                icon: const Icon(Icons.manage_search),
                label: const Text('Buscar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (mensaje.isNotEmpty)
              Text(
                mensaje,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.orangeAccent,
                ),
              ),
            if (resultado != null)
              Card(
                color: const Color(0xFF1E293B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resultado!['medicamento'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      dato('Principio activo', resultado!['principio_activo']),
                      dato('Grupo farmacológico', resultado!['grupo']),
                      dato(
                        'Indicaciones',
                        (resultado!['indicaciones'] as List).join(', '),
                      ),
                      dato(
                        'Contraindicaciones',
                        (resultado!['contraindicaciones'] as List).join(', '),
                      ),
                      dato(
                        'Reacciones adversas',
                        (resultado!['reacciones'] as List).join(', '),
                      ),
                      dato(
                        'Vía de administración',
                        (resultado!['via'] as List).join(', '),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
