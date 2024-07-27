import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Importa SharedPreferences
import '/Models/Feriado.dart';

class ApiJsonPage extends StatefulWidget {
  @override
  _ApiJsonPageState createState() => _ApiJsonPageState();
}

class _ApiJsonPageState extends State<ApiJsonPage> {
  static const String urlfromapi =
      'https://apis.digital.gob.cl/fl/feriados/2024';
  late http.Client cliente;
  bool loading = true;
  bool error = false;

  List<Feriado> feriados = [];

  @override
  void initState() {
    cliente = http.Client();
    _loadFeriados(); // Intenta cargar los feriados desde SharedPreferences
    super.initState();
  }

  Future<void> _loadFeriados() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFeriados = prefs.getString('feriados_2024');

    if (storedFeriados != null) {
      // Si hay datos almacenados, úsalos
      List<dynamic> jsonData = json.decode(storedFeriados);
      setState(() {
        feriados =
            jsonData.map((dynamic json) => Feriado.fromJSON(json)).toList();
        loading = false;
      });
    } else {
      // Si no hay datos almacenados, obtén los feriados desde la API
      fetchDataFromJSON();
    }
  }

  Future<void> fetchDataFromJSON() async {
    final uri = Uri.parse(urlfromapi);
    http.Response respuesta = await cliente.get(uri);

    if (respuesta.statusCode == 200) {
      List jsonData = json.decode(utf8.decode(respuesta.bodyBytes));
      setState(() {
        feriados =
            jsonData.map((dynamic json) => Feriado.fromJSON(json)).toList();
        loading = false;
      });

      // Guarda los feriados en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('feriados_2024', json.encode(jsonData));
    } else {
      Exception('Ha sucedido un error al consultar a la API');
      setState(() {
        loading = false;
        error = true;
      });
    }
  }

  @override
  void dispose() {
    cliente.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF979797), // Color de fondo
        child: loading ? customLoading() : customListBuilder(),
      ),
    );
  }

  Widget customLoading() {
    return SafeArea(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget customListBuilder() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: feriados.isEmpty
            ? customEmpty()
            : ListView.builder(
                itemCount: feriados.length,
                itemBuilder: (BuildContext context, int index) {
                  final feriado = feriados[index];
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    color: Color(0xFFC5C5C5), // Color de fondo de la tarjeta
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        feriado.getNombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Color del texto
                          fontSize: 22, // Tamaño del texto
                        ),
                      ),
                      subtitle: Text(
                        '${feriado.getFecha}',
                        style: const TextStyle(
                          color: Colors.black54, // Color del texto
                          fontSize: 18, // Tamaño del texto
                        ),
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget customEmpty() {
    return Center(
      child: ListTile(
        title: const Text(
          'Lista Vacía',
          style: TextStyle(
            color: Colors.black, // Color del texto
            fontSize: 22, // Tamaño del texto
          ),
        ),
        subtitle: const Text(
          'La API no tiene contenido',
          style: TextStyle(
            color: Colors.black54, // Color del texto
            fontSize: 18, // Tamaño del texto
          ),
        ),
      ),
    );
  }
}
