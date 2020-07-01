import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'actualizar.dart';
import 'borrar.dart';
import 'crud_operations.dart';
import 'insertar.dart';
import 'seleccionar.dart';
import 'students.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<homePage> {
  //Variables referentes al manejo de la bd
  Future<List<Student>> Studentss;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerAPaterno = TextEditingController();
  TextEditingController controllerAMaterno = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerMatricula = TextEditingController();
  TextEditingController controllerPhoto = TextEditingController();
  String name;
  String appaterno;
  String apmaterno;
  String email;
  String phone;
  String matricula;
  String photo;
  int currentUserId;
  var bdHelper;
  bool isUpdating;
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    bdHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Studentss = bdHelper.Students(null);
    });
  }

  Widget list() {
    return Expanded(
      child: FutureBuilder(
        future: Studentss,
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text("Not data founded");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  void cleanData() {
    controllerName.text = "";
    controllerAPaterno.text = "";
    controllerAMaterno.text = "";
    controllerPhone.text = "";
    controllerEmail.text = "";
    controllerMatricula.text = "";
    controllerPhoto.text = "";
  }

  Widget menu() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "OPCIONES",
              style: TextStyle(color: Colors.white, fontSize: 35),
              textAlign: TextAlign.center,
            ),
            decoration: BoxDecoration(color: Colors.cyan),
          ),
          ListTile(
            leading: Icon(
              Icons.search,
              color: Colors.cyan,
              size: 28.0,
            ),
            title: Text('BUSCAR',
                style: TextStyle(fontSize: 20.0, color: Colors.cyan)),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => seleccionar()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.add_circle,
              color: Colors.cyan,
              size: 28.0,
            ),
            title: Text('INSERTAR',
                style: TextStyle(fontSize: 20.0, color: Colors.cyan)),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => insertar()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.cancel,
              color: Colors.cyan,
              size: 28.0,
            ),
            title: Text('BORRAR',
                style: TextStyle(fontSize: 20.0, color: Colors.cyan)),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => borrar()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.refresh,
              color: Colors.cyan,
              size: 28.0,
            ),

            title: Text(
              'ACTUALIZAR',
              style: TextStyle(fontSize: 20.0, color: Colors.cyan),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => actualizar()));
            },
          ),
          ListTile(
            title: Text(
              'el boton de abajo actualiza la pantalla principal',
            ),
          ),
          Row(
            children: <Widget>[
              Center(
                  child: Container(

                      padding: EdgeInsets.all(5.0),
                      width: 300,

                      child: MaterialButton(

                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.black, width: 1.0)),

                        onPressed: refreshList,
                        child: Text(
                          'ACTUALIZAR ',

                          style: TextStyle(fontSize: 20.0),

                        ),

                      )))
            ],
          ),
        ],
      ),
    );
  }

  //Mostrar datos
  SingleChildScrollView dataTable(List<Student> Studentss) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(
                label: Text(
                  "Control",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              DataColumn(
                label: Text("Matricula",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey)),
              ),
              DataColumn(
                label: Text("Nombre",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey)),
              ),
              DataColumn(
                label: Text("apellidoPaterno",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey)),
              ),
              DataColumn(
                label: Text("apellidoMaterno",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey)),
              ),

              DataColumn(
                label: Text("Numero de telefono",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey)),
              ),
              DataColumn(
                label: Text("Email",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey)),
              ),
            ],
            rows: Studentss.map((student) =>
                DataRow(cells: [
                  DataCell(Text(student.controlum.toString(),
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey))),
                  DataCell(Text(student.matricula.toString(),
                      style: TextStyle(fontSize: 16.0, color: Colors.brown))),
                  DataCell(
                    Text(student.name.toString(),
                        style: TextStyle(fontSize: 16.0, color: Colors.brown)),
                  ),
                  DataCell(Text(student.Apaterno.toString(),
                      style: TextStyle(fontSize: 16.0, color: Colors.brown))),
                  DataCell(Text(student.Amaterno.toString(),
                      style: TextStyle(fontSize: 16.0, color: Colors.brown))),
                  DataCell(Text(student.phone.toString(),
                      style: TextStyle(fontSize: 16.0, color: Colors.brown))),
                  DataCell(Text(student.email.toString(),
                      style: TextStyle(fontSize: 16.0, color: Colors.brown))),
                ])).toList(),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      key: _scaffoldkey,
      drawer: menu(),
      appBar: new AppBar(
        title: Text("SQL operations"),
        backgroundColor: Colors.black,
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            list(),

            //NavDrawer(),
          ],
        ),
      ),
    );
  }
}
