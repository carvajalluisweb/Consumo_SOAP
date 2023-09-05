const String bodyTraerPartidos = '''
<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <verPartidos xmlns="http://ws.monster.edu.ec/"/>
    </Body>
</Envelope>
''';
String bodyLogin(String usuario, String pass) => '''
  <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <login xmlns="http://ws.monster.edu.ec/">
            <usuario xmlns="">$usuario</usuario>
            <pass xmlns="">$pass</pass>
        </login>
    </Body>
</Envelope>
''';

String bodyTraerLocalidad(int codigoPartido) => '''
 <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <verLocalidades xmlns="http://ws.monster.edu.ec/">
            <localidad xmlns="">$codigoPartido</localidad>
        </verLocalidades>
    </Body>
</Envelope>
''';
