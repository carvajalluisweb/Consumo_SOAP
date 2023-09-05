import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/partidos.dart';
import 'package:flutter_application_1/pages/localidad_page.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/providers/providers_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PartidoPage extends StatefulWidget {
  PartidoPage();

  @override
  _PartidoPageState createState() => _PartidoPageState();
}

class _PartidoPageState extends State<PartidoPage> {
  final partidoProvider = ProvidersServices();
  late Future<List<Partidos>> mapa;
  String username = ''; // Variable para almacenar el nombre de usuario
  int userId = 0; // Variable para almacenar el ID del usuario

  @override
  void initState() {
    super.initState();
    _loadUserData();
    mapa = partidoProvider.traerPartidos();
    partidoProvider.verificarRespuesta();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username") ?? '';
      userId = prefs.getInt("userId") ?? 0;
    });
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs
        .clear(); // Borra todas las claves y valores almacenados en SharedPreferences

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bienvenido $username',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          Material(
            shape: const CircleBorder(), // Control the circle border shape
            clipBehavior: Clip.hardEdge,
            color: Colors
                .transparent, // Set a transparent color for the material widget
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _logout();
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: mapa,
        builder:
            (BuildContext context, AsyncSnapshot<List<Partidos>> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            final data = snapshot.data;
            return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                            '${data?[index].equipoLocal} vs ${data?[index].equipoVisitante}'),
                        subtitle: Text(
                            'Fecha: ${data?[index].fechaPartido} - Hora: ${data?[index].horaPartido}  ${data?[index].lugar}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Material(
                              shape: const CircleBorder(),
                              clipBehavior: Clip.hardEdge,
                              child: IconButton(
                                icon: const Icon(Icons.shopping_cart),
                                onPressed: () async {
                                  SharedPreferences prefsPartido =
                                      await SharedPreferences.getInstance();
                                  await prefsPartido.setInt("partidoCodigo",
                                      data![index].codigoPartido);
                                  await prefsPartido.setString(
                                      "equipoLocal", data[index].equipoLocal);
                                  await prefsPartido.setString(
                                      "equipoVisitante",
                                      data[index].equipoVisitante);
                                  await prefsPartido.setString(
                                      "fecha", data[index].fechaPartido);
                                  await prefsPartido.setString(
                                      "hora", data[index].horaPartido);
                                  await prefsPartido.setString(
                                      "lugar", data[index].lugar);
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LocalidadPage(),
                                    ),
                                    (route) =>
                                        false, // Remove all previous routes
                                  );
                                },
                                highlightColor: Colors.grey.withOpacity(
                                    0.5), // Cambia el color de fondo cuando el cursor está encima
                                color: const Color.fromARGB(255, 0, 129,
                                    4), // Cambia el color del icono aquí
                              ),
                            ),
                            Material(
                              // Wrap the IconButton with Material
                              shape:
                                  const CircleBorder(), // Control the circle border shape
                              clipBehavior: Clip.hardEdge,
                              color: Colors
                                  .transparent, // Set a transparent color for the material widget
                              child: IconButton(
                                icon: const Icon(CupertinoIcons.doc_chart_fill),
                                onPressed: () {},
                                highlightColor: Colors.grey.withOpacity(
                                    0.1), // Set the highlight color for the circle background
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),

                        // Puedes agregar más widgets aquí para mostrar otros detalles del partido en la tarjeta.
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
