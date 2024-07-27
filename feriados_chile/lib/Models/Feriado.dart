class Feriado {
  String nombre;
  String comentarios;
  String fecha;
  bool irrenunciable;
  String tipo;

  Feriado(
      this.nombre, this.comentarios, this.fecha, this.irrenunciable, this.tipo);

  get getNombre => nombre;
  get getComentario => comentarios;
  get getFecha => fecha;
  get getIrrenunciable => irrenunciable;
  get getTipo => tipo;

  //Get data
  factory Feriado.fromJSON(Map<String, dynamic> json) {
    bool isIrrenunciable;
    var irrenunciableValue = json['irrenunciable'];

    if (irrenunciableValue is String) {
      isIrrenunciable = irrenunciableValue.toLowerCase() == 'true';
    } else if (irrenunciableValue is bool) {
      isIrrenunciable = irrenunciableValue;
    } else {
      isIrrenunciable = true;
    }

    return Feriado(json['nombre'].toString(), json['comentarios'].toString(),
        json['fecha'].toString(), isIrrenunciable, json['tipo'].toString());
  }
}
