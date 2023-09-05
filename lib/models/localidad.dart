// To parse this JSON data, do
//
//     final localidad = localidadFromJson(jsonString);

import 'dart:convert';

List<Localidad> localidadFromJson(String str) =>
    List<Localidad>.from(json.decode(str).map((x) => Localidad.fromJson(x)));

String localidadToJson(List<Localidad> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Localidad {
  int codigoLocalidad;
  int codigoPartido;
  int disponibilidad;
  String nombreLocalidad;
  double precio;

  Localidad({
    required this.codigoLocalidad,
    required this.codigoPartido,
    required this.disponibilidad,
    required this.nombreLocalidad,
    required this.precio,
  });

  factory Localidad.fromJson(Map<String, dynamic> json) => Localidad(
        codigoLocalidad: json["codigoLocalidad"],
        codigoPartido: json["codigoPartido"],
        disponibilidad: json["disponibilidad"],
        nombreLocalidad: json["localidad"],
        precio: json["precio"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "codigoLocalidad": codigoLocalidad,
        "codigoPartido": codigoPartido,
        "disponibilidad": disponibilidad,
        "localidad": nombreLocalidad,
        "precio": precio,
      };
}
