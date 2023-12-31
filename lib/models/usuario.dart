import 'dart:convert';

List<Usuario> usuarioFromJson(String str) =>
    List<Usuario>.from(json.decode(str).map((x) => Usuario.fromJson(x)));

String usuarioToJson(List<Usuario> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Usuario {
  int id;
  String nombre;
  String password;

  Usuario({
    required this.id,
    required this.nombre,
    required this.password,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json["id"],
        nombre: json["nombre"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "password": password,
      };
}
