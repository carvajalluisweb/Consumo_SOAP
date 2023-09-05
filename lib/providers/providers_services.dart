import 'package:flutter_application_1/models/usuario.dart';
import 'package:flutter_application_1/models/localidad.dart';
import 'package:flutter_application_1/models/partidos.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import '../services/body_services.dart';

class ProvidersServices {
  final _uri = Uri.parse(
      "http://localhost:8080/WSProyecto_SOAP_Servidor_Monster/WSTicketPremiun");

  ProvidersServices();

  Future<List<Partidos>> traerPartidos() async {
    final resp = await http.post(
      _uri,
      headers: {"content-type": "text/xml; charset=utf-8", "SOAPAction": ""},
      body: bodyTraerPartidos,
    );

    if (resp.statusCode == 200) {
      final responseBody = resp.body;
      final parsedXml = xml.XmlDocument.parse(responseBody);
      final partidos = parsedXml.findAllElements('partidos').map((node) {
        final codigoPartido =
            int.parse(node.findElements('codigoPartido').first.innerText);
        final equipoLocal = node.findElements('equipoLocal').first.innerText;
        final equipoVisitante =
            node.findElements('equipoVisitante').first.innerText;
        final fechaPartidoFull =
            node.findElements('fechaPartido').first.innerText;
        final fechaPartido = fechaPartidoFull.split('T')[0];
        final horaPartido = node.findElements('horaPartido').first.innerText;
        final lugar = node.findElements('lugar').first.innerText;

        return Partidos(
          codigoPartido: codigoPartido,
          equipoLocal: equipoLocal,
          equipoVisitante: equipoVisitante,
          fechaPartido: fechaPartido,
          horaPartido: horaPartido,
          lugar: lugar,
        );
      }).toList();
      return partidos;
    } else {
      return [];
    }
  }

  Future<Usuario?> login(String usuario, String pass) async {
    final resp = await http.post(
      _uri,
      headers: {"content-type": "text/xml; charset=utf-8", "SOAPAction": ""},
      body: bodyLogin(usuario, pass),
    );

    if (resp.statusCode == 200) {
      final responseBody = resp.body;
      final parsedXml = xml.XmlDocument.parse(responseBody);
      final usuarioElements = parsedXml.findAllElements('usuario');
      if (usuarioElements.isNotEmpty) {
        final usuario = usuarioElements.first;
        final codigoUsuario =
            int.parse(usuario.findElements('codigo').first.innerText);
        final nombreUsuario = usuario.findElements('usuario').first.innerText;
        final password = usuario.findElements('pass').first.innerText;
        return Usuario(
            id: codigoUsuario, nombre: nombreUsuario, password: password);
      } else {
        // La lista de nodos 'usuario' está vacía, lo que indica un usuario inválido.
        // Puedes lanzar una excepción o devolver null para indicar que el usuario no es válido.
        return null;
      }
    } else {
      throw Exception('Error al realizar el login');
    }
  }

  Future<List<Localidad>> traerLocalidades(int codigoPartido) async {
    final resp = await http.post(
      _uri,
      headers: {"content-type": "text/xml; charset=utf-8", "SOAPAction": ""},
      body: bodyTraerLocalidad(codigoPartido),
    );

    if (resp.statusCode == 200) {
      final responseBody = resp.body;
      final parsedXml = xml.XmlDocument.parse(responseBody);
      final localidades = parsedXml.findAllElements('localidades').map((node) {
        final codigoLocalidad =
            int.parse(node.findElements('codigoLocalidad').first.innerText);
        final codigoPartido =
            int.parse(node.findElements('codigoPartido').first.innerText);
        final disponibilidad =
            int.parse(node.findElements('disponibilidad').first.innerText);
        final nombrelocalidad = node.findElements('localidad').first.innerText;
        final precio =
            double.parse(node.findElements('precio').first.innerText);

        return Localidad(
            codigoLocalidad: codigoLocalidad,
            codigoPartido: codigoPartido,
            disponibilidad: disponibilidad,
            nombreLocalidad: nombrelocalidad,
            precio: precio);
      }).toList();
      return localidades;
    } else {
      return [];
    }
  }

  Future<void> verificarRespuesta() async {
    final resp = await http.post(
      _uri,
      headers: {"content-type": "text/xml; charset=utf-8", "SOAPAction": ""},
      body: bodyTraerPartidos,
    );

    if (resp.statusCode == 200) {
      //final responseBody = resp.body;
      //print(responseBody);
    } else {
      throw Exception('Error al obtener los datos');
    }
  }

  Future<void> verificarRespuestaL(int codigoPartido) async {
    final resp = await http.post(
      _uri,
      headers: {"content-type": "text/xml; charset=utf-8", "SOAPAction": ""},
      body: bodyTraerLocalidad(codigoPartido),
    );

    if (resp.statusCode == 200) {
      final responseBody = resp.body;
      print(responseBody);
    } else {
      throw Exception('Error al obtener los datos');
    }
  }
}
