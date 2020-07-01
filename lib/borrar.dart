import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'students.dart';
import 'crud_operations.dart';
import 'main.dart';

class borrar extends StatefulWidget {
  @override
  _borrar createState() => new _borrar();
}

class _borrar extends State<borrar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//Variables referentes al manejo de la bd
  Future<List<Student>> Studentss;
  TextEditingController controllerMatricula = TextEditingController();
  String name;
  String Apellidopaterno;
  String Apellidomaterno;
  String email;
  String phone;
  String matricula = null;
  String photo;
  int count;
  int currentUserId;
  var bdHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    bdHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Studentss = bdHelper.Students(matricula);
    });
  }

  void cleanData() {
    controllerMatricula.text = "";
  }

  void verificar() async {
    Student stu = Student(
        null, name, Apellidopaterno, Apellidomaterno, phone, email, matricula,photo);
    var col = await bdHelper.Matricula(matricula);
    print(col);
    if (col == 0) {
      showInSnackBar("Data not found!");
      matricula = null;
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
                  label: Text("BORRAR",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ))),
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
                label: Text("numero de telefono",
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
              )
            ],
            rows: Studentss.map((student) => DataRow(cells: [
                  DataCell(IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.black,
                      size: 30.0,
                    ),
                    onPressed: () {
                      bdHelper.delete(student.controlum);
                      refreshList();
                    },
                  )),
                  DataCell(Text(student.matricula.toString(),
                      style: TextStyle(fontSize: 16.0, color: Colors.blueGrey))),
                  DataCell(
                    Text(student.name.toString(),
                        style: TextStyle(fontSize: 16.0, color: Colors.blueGrey)),
                  ),
                  DataCell(Text(student.Apaterno.toString(),
                      style: TextStyle(fontSize: 16.0, color: Colors.blueGrey))),
                  DataCell(Text(student.Amaterno.toString(),
                      style: TextStyle(fontSize: 16.0, color: Colors.blueGrey))),
                  DataCell(Text(student.phone.toString(),
                      style: TextStyle(fontSize: 16.0, color: Colors.blueGrey))),
                  DataCell(Text(student.email.toString(),
                      style: TextStyle(fontSize: 16.0, color: Colors.blueGrey))),
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
          "BORRAR",
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
                      controller: controllerMatricula,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Matricula',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          icon: Icon(
                            Icons.perm_identity,
                            size: 35.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),

                      validator: (val) => (val.length < 10 && val.length > 1)
                          ? 'Matricula'
                          : null,
                      onSaved: (val) => matricula = val,
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
                            matricula = controllerMatricula.text;
                            if (matricula == "") {
                              showInSnackBar("Data not found!");
                              matricula = null;
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

                      ],
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
                        matricula = null;
                        refreshList();
                      },
                      child:
                      Text('CANCEL', style: TextStyle(fontSize: 17.0)),
                    ),
                    Row(children: <Widget>[list(
                      
                    )])
                    
                    
                  ],
                  
                ),
              ),
            ),
          )),
    );
  }
}
