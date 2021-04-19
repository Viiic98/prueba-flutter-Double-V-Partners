import 'package:flutter/material.dart';
import 'package:double_v/models/user.dart';
import 'package:double_v/data/database_helpers.dart';
import 'package:double_v/screens/user_inf.dart';
import 'package:double_v/screens/update.dart';

class ListUsers extends StatefulWidget {
  @override
  _ListUsers createState() => _ListUsers();
}

class _ListUsers extends State<ListUsers> {
  // Function to navegate with the Bottom Navigation Bar
  void onTabTapped(int idx) {
    if (idx == 0) Navigator.of(context).pushNamed('/home');
    if (idx == 1) Navigator.of(context).pushNamed('/search');
  }

  Widget build(BuildContext context) {
    DatabaseHelper helper = DatabaseHelper.instance;
    return Scaffold(
      appBar: AppBar(title: Text("Listado de Usuarios")),
      body: FutureBuilder<List<User>>(
        future: helper.getAllUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                User item = snapshot.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    helper.delete(item.id);
                  },
                  child: ListTile(
                    title: Text(
                      "${item.email}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.create,
                            size: 20.0,
                            color: Colors.brown[900],
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Modify(user: item),
                                ));
                          },
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.account_circle_sharp,
                              size: 20.0,
                              color: Colors.brown[900],
                            ),
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          UserInfo(user: item)),
                                  (Route<dynamic> route) => true);
                            }),
                        IconButton(
                          icon: Icon(
                            Icons.delete_forever,
                            size: 20.0,
                            color: Colors.brown[900],
                          ),
                          onPressed: () {
                            helper.delete(item.id);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
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
        ],
        onTap: onTabTapped,
      ),
    );
  }
}
