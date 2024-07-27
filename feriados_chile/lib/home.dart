import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import '/Models/Feriado.dart';
import 'package:feriados_chile/apijson.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime _currentDate = DateTime.now();
  static const String urlfromapi =
      'https://apis.digital.gob.cl/fl/feriados/2024';
  late http.Client cliente;
  bool loading = true;
  bool error = false;
  List<Feriado> feriados = [];

  @override
  void initState() {
    cliente = http.Client();
    fetchDataFromJSON();
    super.initState();
    initializeDateFormatting('es_ES', null).then((_) {
      setState(() {});
    });
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

  void _incrementDate() {
    setState(() {
      _currentDate = _currentDate.add(const Duration(days: 1));
    });
  }

  void _decrementDate() {
    setState(() {
      _currentDate = _currentDate.subtract(const Duration(days: 1));
    });
  }

  bool _isHoliday(DateTime date) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return feriados.any((feriado) =>
        DateFormat('yyyy-MM-dd').format(DateTime.parse(feriado.getFecha)) ==
        formattedDate);
  }

  Map<String, String> _getHolidayInfo(DateTime date) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    var holiday = feriados.firstWhere(
        (feriado) =>
            DateFormat('yyyy-MM-dd').format(DateTime.parse(feriado.getFecha)) ==
            formattedDate,
        orElse: () => Feriado.fromJSON({
              'nombre': 'No Disponible',
              'fecha': 'No Disponible',
              'tipo': 'No Disponible'
            }));

    return {
      'nombre': holiday.getNombre,
      'tipo': holiday.getTipo,
    };
  }

  DateTime? _getNextHolidayDate() {
    DateTime today = DateTime.now();
    DateTime nextHoliday = DateTime(today.year, 12, 31); // Initial value

    for (var feriado in feriados) {
      DateTime holidayDate = DateTime.parse(feriado.getFecha);
      if (holidayDate.isAfter(today) && holidayDate.isBefore(nextHoliday)) {
        nextHoliday = holidayDate;
      }
    }

    return nextHoliday.isAfter(today) ? nextHoliday : null;
  }

  String _daysUntilNextHoliday() {
    DateTime? nextHoliday = _getNextHolidayDate();
    if (nextHoliday == null) {
      return 'No hay más feriados en este año';
    }
    int daysUntil = nextHoliday.difference(DateTime.now()).inDays;
    return '$daysUntil días hasta el siguiente feriado';
  }

  void _showDaysUntilNextHoliday() {
    DateTime today = DateTime.now();
    String todayFormatted = DateFormat('dd MMMM yyyy', 'es_ES').format(today);
    String message = 'Hoy es $todayFormatted\n\n${_daysUntilNextHoliday()}';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Información del próximo feriado'),
          content: Text(
            message,
            style: const TextStyle(fontSize: 18),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Compartir'),
              onPressed: () {
                Share.share(message);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd').format(_currentDate);
    String formattedMonth = DateFormat('MMMM', 'es_ES').format(_currentDate);
    String formattedYear = DateFormat('yyyy').format(_currentDate);
    bool isHoliday = _isHoliday(_currentDate);
    Map<String, String> holidayInfo =
        isHoliday ? _getHolidayInfo(_currentDate) : {};

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF001BE6), // Cambiar color aquí
        title: Center(
          child: Text(widget.title, style: TextStyle(color: Colors.white)),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.white),
            onPressed: _showDaysUntilNextHoliday,
          ),
        ],
        iconTheme: IconThemeData(
            color: Colors.white), // Cambiar color de los iconos aquí
      ),
      drawer: Drawer(
        backgroundColor: Color(0xFFDE0000), // Cambiar color del Drawer aquí
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFDE0000), // Cambiar color del DrawerHeader aquí
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text(
                'Feriados 2024',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20, // Aumentar tamaño del texto
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ApiJsonPage()),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Cuánto falta para el siguiente feriado?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20, // Aumentar tamaño del texto
                ),
              ),
              onTap: _showDaysUntilNextHoliday,
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              formattedYear,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 150,
                  height: 200,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_left, size: 100),
                    onPressed: _decrementDate,
                  ),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    color: isHoliday ? Colors.red : Colors.black,
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 200,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_right, size: 100),
                    onPressed: _incrementDate,
                  ),
                ),
              ],
            ),
            Text(
              formattedMonth,
              style: const TextStyle(fontSize: 40),
            ),
            if (isHoliday)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          holidayInfo['nombre'] ?? 'No Disponible',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tipo: ${holidayInfo['tipo'] ?? 'No Disponible'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
