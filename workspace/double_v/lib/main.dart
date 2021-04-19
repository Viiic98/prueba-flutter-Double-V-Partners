import 'package:flutter/material.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: new HomePage(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new HomePage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Double V Partners'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Text('Bienvenido Admin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                )),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text('Registrar Usuario'),
              onPressed: (() =>
                  Navigator.of(context).pushNamed('/registration')),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              child: Text('Buscar Usuario'),
              onPressed: (() => Navigator.of(context).pushNamed('/search')),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              child: Text('Lista de Usuarios'),
              onPressed: (() => Navigator.of(context).pushNamed('/list')),
            ),
          ])),
    );
  }
}
