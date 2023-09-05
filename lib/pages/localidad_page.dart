import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/localidad.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/providers/providers_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalidadPage extends StatefulWidget {
  LocalidadPage({
    Key? key,
  }) : super(key: key);

  @override
  _LocalidadPageState createState() => _LocalidadPageState();
}

class _LocalidadPageState extends State<LocalidadPage> {
  int partidoCodigo = 0;
  String equipoL = '';
  String equipoV = '';
  String fecha = '';
  String hora = '';
  String lugar = '';

  final localidadProvider = ProvidersServices();
  late Future<List<Localidad>> mapa;
  String?
      selectedLocalidad; // Variable para almacenar la localidad seleccionada
  List<Localidad>? localidades; // Variable para almacenar las localidades
  final TextEditingController boletosController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPartido();
    _loadCodigoPartido();
    //print("Valor de partidoCodigo: $partidoCodigo");
  }

  Future<void> _loadCodigoPartido() async {
    SharedPreferences prefsPartido = await SharedPreferences.getInstance();
    setState(() {
      partidoCodigo = prefsPartido.getInt("partidoCodigo") ?? 0;
    });
  }

  Future<void> _loadPartido() async {
    SharedPreferences prefsPartido = await SharedPreferences.getInstance();
    setState(() {
      equipoL = prefsPartido.getString("equipoLocal") ?? '';
      equipoV = prefsPartido.getString("equipoVisitante") ?? '';
      fecha = prefsPartido.getString("fecha") ?? '';
      hora = prefsPartido.getString("hora") ?? '';
      lugar = prefsPartido.getString("lugar") ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    mapa = localidadProvider.traerLocalidades(partidoCodigo);
    //localidadProvider.verificarRespuestaL(partidoCodigo);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bienvenido $partidoCodigo',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.hardEdge,
            color: Colors.transparent,
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: mapa,
        builder:
            (BuildContext context, AsyncSnapshot<List<Localidad>> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            final data = snapshot.data;
            //print(localidades); // Almacenar los datos del Future en localidades

            return Center(
              child: Column(
                children: [
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.all(16),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Equipo Local: $equipoL',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Equipo Visitante: $equipoV',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Fecha: $fecha',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Hora: $hora',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Lugar: $lugar',
                            style: TextStyle(fontSize: 16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: const Text('Agregar Boleto'),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: data?.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text('${data?[index].nombreLocalidad}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Disponibilidad: ${data?[index].disponibilidad} '),
                                    Text('Precio: ${data?[index].precio} '),
                                  ],
                                ),
                              ),
                              TextFormField(
                                controller: boletosController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Cantidad de boletos',
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
