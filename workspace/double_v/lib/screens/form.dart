import 'package:flutter/material.dart';
import 'package:double_v/models/user.dart';
import 'package:double_v/validators/validators.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => new _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  // Text controller for birthDate
  final controller = TextEditingController(text: '');

  // Values that are going to be modified
  String _name;
  String _lastName;
  String _birthDateStr;
  DateTime birthDate;
  bool isDateSelected = false;
  String _email;
  List _address = [];
  List<Widget> _children = [];
  // Heigh of address container
  double _addressHeight = 0;
  // Number of addresses
  int _count = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  // Function to create user
  // Validate the form
  void _createUser() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      User user = new User();
      performRegistration(user);
    }
  }

  // Auxiliar function
  // Create the user in the database
  void performRegistration(User user) async {
    int id = await user.save(_name, _lastName, _birthDateStr, _email, _address);
    String text = "";
    if (id >= 1)
      text = "Usuario registrado satisfactoriamente";
    else {
      text = "El email ya ha sido registrado";
      _address = [];
    }
    final snackbar = new SnackBar(
      content: new Text(text),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
    await Future.delayed(const Duration(seconds: 2), () {});
    if (id >= 1) Navigator.of(context).pushNamed('/home');
  }

  // Date validator
  String dateValidator(String string) {
    if (birthDate == null || birthDate.year > 2021 || _birthDateStr == '')
      return 'Ingrese una fecha valida';
    return null;
  }

  // Add a new address field
  void _add() {
    _children = List.from(_children)
      ..add(
        TextFormField(
          decoration: new InputDecoration(
            labelText: 'Direccion $_count',
            labelStyle: TextStyle(height: 0.5),
          ),
          validator: addressValidator,
          onSaved: (value) => _address.add(value),
        ),
      );
    _children = List.from(_children)
      ..add(
        SizedBox(height: 5),
      );
    setState(() => {++_count, _addressHeight += 68});
  }

  // Initialize address
  // Create the first address field
  void initAddress() {
    if (_count == 1) _add();
  }

  @override
  Widget build(BuildContext context) {
    initAddress();
    return new Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          title: new Text('Registro de usuario'),
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
                      validator: nameValidator,
                      onSaved: (value) => _name = value,
                    ),
                    new TextFormField(
                      decoration: new InputDecoration(
                        labelText: 'Apellido',
                        labelStyle: TextStyle(height: 0.5),
                      ),
                      validator: nameValidator,
                      onSaved: (value) => _lastName = value,
                    ),
                    new TextFormField(
                      decoration: new InputDecoration(
                        labelText: 'Fecha de nacimiento',
                        labelStyle: TextStyle(height: 0.5),
                      ),
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
                      validator: emailValidator,
                      onSaved: (value) => _email = value,
                    ),
                    new Container(
                      height: _addressHeight,
                      child: new ListView(
                        //physics: NeverScrollableScrollPhysics(),
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
                        onPressed: _createUser,
                        child: new Text('Registrar Usuario'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
