import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'borrar.dart';
import 'convertir.dart';
import 'insertar.dart';
import 'seleccionar.dart';
import 'actualizar.dart';
import 'students.dart';
import 'crud_operations.dart';
import 'main.dart';
import 'students.dart';

class actualizar extends StatefulWidget {
  @override
  _actualizar createState() => new _actualizar();
}

class _actualizar extends State<actualizar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//Variables referentes al manejo de la bd
  Future<List<Student>> Studentss;
  TextEditingController controllerValue = TextEditingController();
  TextEditingController controllerPhoto = TextEditingController();
  String name;
  String Apellidopaterno;
  String Apellidomaterno;
  String email;
  String phone;
  String matricula = null;
  String photo;
  String image;
  int count;
  int currentUserId;
  var bdHelper;
  bool isUpdating;
  int opcion;
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
      Studentss = bdHelper.Students(null);
    });
  }

  void cleanData() {
    controllerValue.text = "";
    controllerPhoto.text = "";
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
                    color: Colors.black,
                  ),
                ),
              ),
              DataColumn(
                label: Text("Matricula",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              DataColumn(
                label: Text("Nombre",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              DataColumn(
                label: Text("ApellidoPaterno",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              DataColumn(
                label: Text("ApellidoMaterno",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),

              DataColumn(
                label: Text("numero de telefono",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              DataColumn(
                label: Text("Email",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey)),
              ),
            ],

            rows: Studentss.map((student) => DataRow(cells: [
              DataCell(Text(student.controlum.toString(),
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black))),
              DataCell(Text(student.matricula.toString(),
                  style:
                  TextStyle(fontSize: 16.0, color: Colors.brown))),
              DataCell(
                  Text(student.name.toString(),
                      style: TextStyle(
                          fontSize: 16.0, color: Colors.brown)),
                  onTap: () {
                    setState(() {
                      //isUpdating = true;
                      currentUserId = student.controlum;
                      name = student.name;
                      Apellidopaterno = student.Apaterno;
                      Apellidomaterno=student.Amaterno;
                      phone=student.phone;
                      email=student.email;
                      matricula=student.matricula;
                      opcion=1;
                    });
                    controllerValue.text = student.name;
                  }
              ),
              DataCell(Text(student.Apaterno.toString(),
                  style:
                  TextStyle(fontSize: 16.0, color: Colors.brown)), onTap: () {
                setState(() {
                  //isUpdating = true;
                  currentUserId = student.controlum;
                  name = student.name;
                  Apellidopaterno = student.Apaterno;
                  Apellidomaterno=student.Amaterno;
                  phone=student.phone;
                  email=student.email;
                  matricula=student.matricula;
                  opcion=2;
                });
                controllerValue.text = student.Apaterno;
              }),
              DataCell(Text(student.Amaterno.toString(),
                  style:
                  TextStyle(fontSize: 16.0, color: Colors.brown)), onTap: () {
                setState(() {
                  //isUpdating = true;
                  currentUserId = student.controlum;
                  name = student.name;
                  Apellidopaterno = student.Apaterno;
                  Apellidomaterno=student.Amaterno;
                  phone=student.phone;
                  email=student.email;
                  matricula=student.matricula;
                  opcion=3;
                });
                controllerValue.text = student.Amaterno;
              }),
              DataCell(Text(student.phone.toString(),
                  style:
                  TextStyle(fontSize: 16.0, color: Colors.brown)), onTap: () {
                setState(() {
                  //isUpdating = true;
                  currentUserId = student.controlum;
                  name = student.name;
                  Apellidopaterno = student.Apaterno;
                  Apellidomaterno=student.Amaterno;
                  phone=student.phone;
                  email=student.email;
                  matricula=student.matricula;
                  opcion=4;
                });
                controllerValue.text = student.phone;
              }),
              DataCell(Text(student.email.toString(),
                  style:
                  TextStyle(fontSize: 16.0, color: Colors.brown)), onTap: () {
                setState(() {
                  //isUpdating = true;
                  currentUserId = student.controlum;
                  name = student.name;
                  Apellidopaterno = student.Apaterno;
                  Apellidomaterno=student.Amaterno;
                  phone=student.phone;
                  email=student.email;
                  matricula=student.matricula;
                  opcion=5;
                });
                controllerValue.text = student.email;
              }),
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

  void updateData() {
    print("Valor de Opción");
    print(opcion);
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      if(opcion == null){
        bdHelper.getStudents(matricula);
      }
      else if (opcion == 1) {

        Student stu = Student(
            currentUserId, valor,  Apellidopaterno,  Apellidomaterno, phone, email, matricula,image);
        bdHelper.update(stu);
      } else if (opcion == 2) {
        Student stu = Student(
            currentUserId, name, valor,  Apellidomaterno, phone, email, matricula,image);
        bdHelper.update(stu);
      } else if (opcion == 3) {
        Student stu = Student(
            currentUserId, name,  Apellidopaterno, valor, phone, email, matricula,image);
        bdHelper.update(stu);
      } else if (opcion == 4) {
        Student stu = Student(
            currentUserId, name,  Apellidopaterno,  Apellidomaterno, valor, email, matricula, photo);
        bdHelper.update(stu);
      } else if (opcion == 5) {
        Student stu = Student(
            currentUserId, name,  Apellidopaterno,  Apellidomaterno, phone, valor, matricula,photo);
        bdHelper.update(stu);
      }
    }
    cleanData();
    refreshList();
  }
//Metodo para imagen
  pickImagefromGallery(BuildContext context) {
    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
      var image = imgString;
      //Funciona para la obtencion de imagen ya sea galeria o camera
      Navigator.of(context).pop();
      controllerValue.text = image;
      return image;
    });
  }

  pickImagefromCamera(BuildContext context) {
    ImagePicker.pickImage(source: ImageSource.camera).then((imgFile) {
      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
      var image = imgString;
      Navigator.of(context).pop();
      controllerValue.text = image;
      return image;
    });
  }

  // seleccionar imagen ya se camara o galeria
  Future<void> _selectfoto(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                "Make a choise!",
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.deepPurpleAccent[200],
              content: SingleChildScrollView(
                child: ListBody(children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      pickImagefromGallery(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  GestureDetector(
                    child: Text(
                      "Camera",
                    ),
                    onTap: () {
                      pickImagefromCamera(context);
                    },
                  )
                ]),
              ));
        });
  }

  final formkey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(
          "ACTUALIZAR",
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
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: controllerValue,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'toca el valor que deseas cambiar',
                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      validator: (val) =>
                      val.length == 0 ? 'toca el valor que deseas cambiar' : null,
                      onSaved: (val) => valor = val.toUpperCase(),
                    ),

                    Row(children: <Widget>[list()]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(
                                    color: Colors.cyan, width: 2.0)),
                            onPressed: () {
                              updateData();
                              refreshList();
                              opcion=null;
                            },
                            child: Text(
                              isUpdating ? 'Update' : 'Update',
                              style: TextStyle(fontSize: 17.0),
                            ),
                          ),
                        ]),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          )),

    );
  }
}
