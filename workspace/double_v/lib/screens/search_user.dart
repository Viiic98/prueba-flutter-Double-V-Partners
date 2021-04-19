import 'package:flutter/material.dart';
import 'package:double_v/models/user.dart';
import 'package:double_v/data/database_helpers.dart';
import 'package:double_v/screens/update.dart';
import 'package:double_v/screens/user_inf.dart';
import 'package:double_v/validators/validators.dart';

class SearchUser extends StatefulWidget {
  final User user;

  SearchUser({Key key, this.user}) : super(key: key);

  @override
  _SearchUser createState() => _SearchUser();
}

class _SearchUser extends State<SearchUser> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  String _email = "";

  // Search function
  // Validate form
  void _searchUser() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      performSearch(1);
    }
  }

  // Modify function
  // Validate form
  void _modifyUser() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      performSearch(2);
    }
  }

  // Auxiliar search function
  // Search the user in the database
  // Receives 1 to check user info otherwise modify
  void performSearch(action) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    User user = await helper.queryUser(_email);
    if (user != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                action == 1 ? UserInfo(user: user) : Modify(user: user),
          ));
    } else {
      String text = "No existe un usuario asociado a ese email";
      final snackbar = new SnackBar(
        content: new Text(text),
      );
      scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  // Function to navegate with the Bottom Navigation Bar
  void onTabTapped(int idx) {
    if (idx == 0) Navigator.of(context).pushNamed('/home');
    if (idx == 1) Navigator.of(context).pushNamed('/list');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('Buscar Usuario'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: new Padding(
              padding: const EdgeInsets.all(20.0),
              child: new Form(
                key: formKey,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text('Ingrese el Email del usuario:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        )),
                    SizedBox(height: 15),
                    new TextFormField(
                      decoration: new InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(height: 0.5),
                      ),
                      validator: emailValidator,
                      onSaved: (value) => _email = value,
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: ElevatedButton(
                              child: Text('Modificar'),
                              onPressed: _modifyUser,
                            ),
                          ),
                          ElevatedButton(
                            child: Text('Consultar Usuario'),
                            onPressed: _searchUser,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
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
