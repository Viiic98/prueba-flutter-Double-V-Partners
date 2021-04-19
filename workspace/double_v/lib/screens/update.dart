import 'package:flutter/material.dart';
import 'package:double_v/models/user.dart';
import 'dart:convert';
import 'package:double_v/data/database_helpers.dart';
import 'package:collection/collection.dart';
import 'package:double_v/validators/validators.dart';

class Modify extends StatefulWidget {
  final User user;

  Modify({Key key, this.user}) : super(key: key);

  @override
  _Modify createState() => _Modify();
}

class _Modify extends State<Modify> {
  // Function to check if values in a list are equals
  Function eq = const ListEquality().equals;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  // Text controller for birthDate
  final controller = TextEditingController(text: '');

  // Initial values for current User
  int _started = 0;
  String _initName = '';
  String _initLastName = '';
  String _initBirthDateStr;
  String _initEmail;
  List _initAddress = [];

  // Values that are going to be modified
  String _name = '';
  String _lastName = '';
  String _birthDateStr;
  DateTime birthDate;
  bool isDateSelected = false;
  String _email;
  List _address = [];
  List<Widget> _children = [];
  // Heigh of address container
  double _addressHeight = 0;
  // Number of addresses
  int _count = 0;

  // Create the widgets addresses from current User
  void _startAddresses() {
    if (_count == 0) {
      _address = json.decode(widget.user.address);
      for (var i = 1; i <= _address.length; i++) {
        _children.add(
          TextFormField(
            decoration: new InputDecoration(
              labelText: 'Direccion $i',
              labelStyle: TextStyle(height: 0.5),
            ),
            initialValue: "${_address[i - 1]}",
            onSaved: (value) => _addressValidator(value, i - 1),
          ),
        );
        _children.add(SizedBox(height: 5));
      }
      _addressHeight = (_address.length).toDouble() * 68;
      _count = _address.length + 1;
    }
  }

  // Initial values of User
  void _startUserData() {
    if (controller.text == '') controller.text = widget.user.birthDate;
    if (_started == 0) {
      _initName = widget.user.name;
      _initLastName = widget.user.lastName;
      _initBirthDateStr = widget.user.birthDate;
      _initEmail = widget.user.email;
      birthDate = DateTime.parse(_initBirthDateStr);
      _initAddress = List.from(_address);
    }
    _started = 1;
  }

  // Date validator
  String dateValidator(String string) {
    if (birthDate == null || birthDate.year > 2021 || _birthDateStr == '')
      return 'Ingrese una fecha valida';
    return null;
  }

  // Check if the value of an address has changed
  String _addressValidator(String string, int i) {
    if (_initAddress.asMap().containsKey(i)) {
      if (string != _initAddress[i]) _address[i] = string;
    } else
      _address.add(string);
  }

  // Update function
  // Check if the form is valid
  void _updateUser() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      performUpdate();
    }
  }

  // Auxiliar update function
  // Save the changes in database
  void performUpdate() async {
    int done = 0;
    String text = "";
    if (_name == _initName &&
        _lastName == _initLastName &&
        _birthDateStr == _initBirthDateStr &&
        _email == _initEmail &&
        eq(_address, _initAddress)) {
      text = "No se ha realizado ningun cambio.";
    } else {
      User user = widget.user;
      user.name = _name;
      user.lastName = _lastName;
      user.birthDate = _birthDateStr;
      user.email = _email;
      user.address = jsonEncode(_address);
      DatabaseHelper helper = DatabaseHelper.instance;
      helper.update(user);
      text = "Cambios realizados satisfactoriamente";
      done = 1;
    }
    final snackbar = new SnackBar(
      content: new Text(text),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
    if (done == 1) {
      await Future.delayed(const Duration(seconds: 2), () {});
      Navigator.of(context).pushNamed('/home');
    }
  }

  // Add a new address field
  void _add() {
    _children.add(
      TextFormField(
        decoration: new InputDecoration(
          labelText: 'Direccion $_count',
          labelStyle: TextStyle(height: 0.5),
        ),
        validator: addressValidator,
        onSaved: (value) => _addressValidator(value, _count - 1),
      ),
    );
    _children = List.from(_children)
      ..add(
        SizedBox(height: 5),
      );
    setState(() => {++_count, _addressHeight += 68});
  }

  // Function to navegate with the Bottom Navigation Bar
  void onTabTapped(int idx) {
    if (idx == 0) Navigator.of(context).pushNamed('/home');
    if (idx == 1) Navigator.of(context).pushNamed('/list');
  }

  Widget build(BuildContext context) {
    _name = widget.user.name;
    _lastName = widget.user.lastName;
    _birthDateStr = widget.user.birthDate;
    _email = widget.user.email;
    _startAddresses();
    _startUserData();
    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('Editar Usuario'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: new Padding(
            padding: const EdgeInsets.all(20.0),
            child: new Form(
              key: formKey,
              child: new Column(
                children: <Widget>[
                  new TextFormField(
                    decoration: new InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: TextStyle(height: 0.5),
                    ),
                    initialValue: "${widget.user.name}",
                    validator: nameValidator,
                    onSaved: (value) => _name = value,
                  ),
                  new TextFormField(
                    decoration: new InputDecoration(
                      labelText: 'Apellido',
                      labelStyle: TextStyle(height: 0.5),
                    ),
                    initialValue: "${widget.user.lastName}",
                    validator: nameValidator,
                    onSaved: (value) => _lastName = value,
                  ),
                  new TextFormField(
                    decoration: new InputDecoration(
                      labelText: 'Fecha de nacimiento',
                      labelStyle: TextStyle(height: 0.5),
                    ),
                    //initialValue: "${widget.user.birthDate}",
                    validator: dateValidator,
                    onSaved: (value) => _birthDateStr = value,
                    controller: controller,
                    onTap: () async {
                      // Below line stops keyboard from appearing
                      FocusScope.of(context).requestFocus(new FocusNode());

                      // Show Date Picker Here
                      final datePick = await showDatePicker(
                          context: context,
                          initialDate: new DateTime.now(),
                          firstDate: new DateTime(1900),
                          lastDate: new DateTime(2100));
                      if (datePick != null && datePick != birthDate) {
                        setState(() {
                          String day = '';
                          String month = '';
                          birthDate = datePick;
                          isDateSelected = true;
                          if (birthDate.day < 10)
                            day = '0' + birthDate.day.toString();
                          else
                            day = birthDate.day.toString();
                          if (birthDate.month < 10)
                            month = '0' + birthDate.month.toString();
                          else
                            month = birthDate.month.toString();
                          _birthDateStr =
                              "${birthDate.year}-$month-$day"; // yyyy-mm-dd
                          controller.text = _birthDateStr;
                        });
                      }
                    },
                  ),
                  new TextFormField(
                    decoration: new InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(height: 0.5),
                    ),
                    readOnly: true,
                    initialValue: "${widget.user.email}",
                  ),
                  new Container(
                    height: _addressHeight,
                    child: new ListView(
                      children: _children,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: new TextButton(
                      onPressed: _add,
                      child: Text('Añadir nueva direccion +',
                          textAlign: TextAlign.left),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: new ElevatedButton(
                      onPressed: _updateUser,
                      child: new Text('Guardar cambios'),
                    ),
                  )
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
            icon: Icon(Icons.library_books),
            label: 'Lista de Usuarios',
          ),
        ],
        onTap: onTabTapped,
      ),
    );
  }
}
