import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'borrar.dart';
import 'insertar.dart';
import 'actualizar.dart';
import 'students.dart';
import 'crud_operations.dart';
import 'main.dart';

class seleccionar extends StatefulWidget {
  @override
  _Select createState() => new _Select();
}

class _Select extends State<seleccionar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//Variables referentes al manejo de la bd
  Future<List<Student>> Studentss;
  TextEditingController controllerValor = TextEditingController();
  String name;
  String Apaterno;
  String Amaterno;
  String email;
  String phone;
  String matricula;
  String photo;
  int count;
  int currentUserId;
  var bdHelper;
  bool isUpdating;
  String valor;

  @override
  void initState() {
    super.initState();
    bdHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Studentss = bdHelper.search(valor);
    });
  }

  void cleanData() {
    controllerValor.text = "";
  }

  void verificar() async {
    print(valor.toUpperCase());
    Student stu =
        Student(null, name, Apaterno, Amaterno, phone, email, matricula,photo);
    var col = await bdHelper.search(valor.toUpperCase());
    print(col);
    if (col.length < 1) {
      showInSnackBar("Data not found!");
      valor = null;
      cleanData();
      refreshList();
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: Colors.black,
        content: new Text(
          value,
          style: TextStyle(fontSize: 20.0, color: Colors.cyan),
        )));
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
                label: Text("Apellido Paterno",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey)),
              ),
              DataColumn(
                label: Text("Apellido Materno",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey)),
              ),
              DataColumn(
                label: Text("E-mail",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey)),
              ),
              DataColumn(
                label: Text("numero de telefono",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey)),
              )
            ],
            rows: Studentss.map((student) => DataRow(cells: [
                  DataCell(Text(student.controlum.toString(),
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey))),
                  DataCell(Text(student.matricula.toString(),
                      style:
                          TextStyle(fontSize: 16.0, color: Colors.brown))),
                  DataCell(
                    Text(student.name.toString(),
                        style: TextStyle(
                            fontSize: 16.0, color: Colors.brown)),
                  ),
                  DataCell(Text(student.Apaterno.toString(),
                      style:
                          TextStyle(fontSize: 16.0, color: Colors.brown))),
                  DataCell(Text(student.Amaterno.toString(),
                      style:
                          TextStyle(fontSize: 16.0, color: Colors.brown))),
                  DataCell(Text(student.phone.toString(),
                      style:
                          TextStyle(fontSize: 16.0, color: Colors.brown))),
                  DataCell(Text(student.email.toString(),
                      style:
                          TextStyle(fontSize: 16.0, color: Colors.brown))),
                ])).toList(),
          ),
        ));
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

  final formkey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(
          "BUSCAR",
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: formkey,
              child: Padding(
                padding: EdgeInsets.only(
                    top: 35.0, right: 15.0, bottom: 35.0, left: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    TextFormField(
                      controller: controllerValor,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Search',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          icon: Icon(
                            Icons.search,
                            color: Colors.blueGrey,
                            size: 35.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      validator: (val) => (val.length == 0) ? 'Search' : null,
                      onSaved: (val) => valor = val.toString().toUpperCase(),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                  color: Colors.black, width: 2.0)),
                          onPressed: () {
                            valor = controllerValor.text;
                            if (valor == "") {
                              showInSnackBar("Data not found!");
                              valor = null;
                              cleanData();
                              refreshList();
                            } else {
                              verificar();
                              refreshList();
                            }
                          },
                          child: Text(
                            isUpdating ? 'ACTUALIZAR' : 'BUSCAR',
                            style: TextStyle(fontSize: 17.0),
                          ),
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                  color: Colors.black, width: 2.0)),
                          onPressed: () {
                            setState(() {
                              isUpdating = false;
                            });
                            cleanData();
                            valor = null;
                            refreshList();
                          },
                          child:
                              Text('CANCEL', style: TextStyle(fontSize: 17.0)),
                        )
                      ],
                    ),
                    Row(children: <Widget>[list()])
                  ],
                ),
              ),
            ),
          )),

    );
  }
}
