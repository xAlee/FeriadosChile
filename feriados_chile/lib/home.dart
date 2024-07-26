import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class home extends StatefulWidget {
  const home({super.key, required this.title});

  final String title;

  @override
  State<home> createState() => _home_State();
}

class _home_State extends State<home> {
  DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_ES', null).then((_) {
      setState(() {});
    });
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

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd').format(_currentDate);
    String formattedMonth = DateFormat('MMMM', 'es_ES').format(_currentDate);
    String formattedYear = DateFormat('yyyy').format(_currentDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(
          child: Text(widget.title),
        ),
        centerTitle: true,
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
                  style: const TextStyle(
                      fontSize: 100, fontWeight: FontWeight.bold),
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
          ],
        ),
      ),
    );
  }
}
