import 'dart:convert';

List<Partidos> partidosFromJson(String str) =>
    List<Partidos>.from(json.decode(str).map((x) => Partidos.fromJson(x)));

String partidosToJson(List<Partidos> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Partidos {
  int codigoPartido;
  String equipoLocal;
  String equipoVisitante;
  String fechaPartido;
  String horaPartido;
  String lugar;

  Partidos({
    required this.codigoPartido,
    required this.equipoLocal,
    required this.equipoVisitante,
    required this.fechaPartido,
    required this.horaPartido,
    required this.lugar,
  });

  factory Partidos.fromJson(Map<String, dynamic> json) => Partidos(
        codigoPartido: json["codigoPartido"],
        equipoLocal: json["equipoLocal"],
        equipoVisitante: json["equipoVisitante"],
        fechaPartido: json["fechaPartido"],
        horaPartido: json["horaPartido"],
        lugar: json["lugar"],
      );

  Map<String, dynamic> toJson() => {
        "codigoPartido": codigoPartido,
        "equipoLocal": equipoLocal,
        "equipoVisitante": equipoVisitante,
        "fechaPartido": fechaPartido,
        "horaPartido": horaPartido,
        "lugar": lugar,
      };
}
