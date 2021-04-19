import 'package:flutter/material.dart';
import 'package:double_v/models/user.dart';
import 'dart:convert';
import 'package:double_v/screens/update.dart';
import 'package:double_v/data/database_helpers.dart';

class UserInfo extends StatefulWidget {
  final User user;

  UserInfo({Key key, this.user}) : super(key: key);

  @override
  _UserInfo createState() => _UserInfo();
}

class _UserInfo extends State<UserInfo> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  List _address = [];
  List<Widget> _children = [];

  // Create the widgets addresses from current User
  void createAddresses() {
    _address = json.decode(widget.user.address);
    for (var i = 1; i <= _address.length; i++) {
      _children.add(
        TextFormField(
          decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            labelText: 'Direccion $i',
            labelStyle: TextStyle(height: 0.5),
          ),
          readOnly: true,
          initialValue: "${_address[i - 1]}",
        ),
      );
      _children.add(SizedBox(height: 5));
    }
  }

  // Tap function for Bottom Navigation Bar
  void onTabTapped(int idx) {
    if (idx == 0) Navigator.of(context).pushNamed('/home');
    if (idx == 1) Navigator.of(context).pushNamed('/search');
    if (idx == 2) Navigator.of(context).pushNamed('/list');
  }

  // Manage pop up menu selections
  void appBarList(int idx) async {
    if (idx == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Modify(user: widget.user),
          ));
    }
    if (idx == 2) {
      DatabaseHelper helper = DatabaseHelper.instance;
      helper.delete(widget.user.id);
      final snackbar = new SnackBar(
        content: new Text('El usuario ha sido eliminado correctamente'),
      );
      scaffoldKey.currentState.showSnackBar(snackbar);
      await Future.delayed(const Duration(seconds: 2), () {});
      Navigator.of(context).pushNamed('/home');
    }
  }

  Widget build(BuildContext context) {
    _address = [];
    _children = [];
    createAddresses();
    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('Informacion de Usuario'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Modificar"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Eliminar"),
              ),
            ],
            onSelected: appBarList,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: new Padding(
            padding: const EdgeInsets.all(20.0),
            child: new Form(
              child: new Column(
                children: <Widget>[
                  new TextFormField(
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      labelText: 'Nombre',
                      labelStyle: TextStyle(height: 0.5),
                    ),
                    readOnly: true,
                    initialValue: "${widget.user.name}",
                  ),
                  new TextFormField(
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      labelText: 'Apellido',
                      labelStyle: TextStyle(height: 0.5),
                    ),
                    readOnly: true,
                    initialValue: "${widget.user.lastName}",
                  ),
                  new TextFormField(
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      labelText: 'Fecha de nacimiento',
                      labelStyle: TextStyle(height: 0.5),
                    ),
                    readOnly: true,
                    initialValue: "${widget.user.birthDate}",
                  ),
                  new TextFormField(
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      labelText: 'Email',
                      labelStyle: TextStyle(height: 0.5),
                    ),
                    readOnly: true,
                    initialValue: "${widget.user.email}",
                  ),
                  new Container(
                    height: 1000,
                    child: new ListView(
                      children: _children,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.find_in_page),
            label: 'Buscar Usuario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Lista de Usuarios',
          ),
        ],
        onTap: onTabTapped,
      ),
    );
  }
}
