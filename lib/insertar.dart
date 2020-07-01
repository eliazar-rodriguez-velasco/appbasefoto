import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'convertir.dart';
import 'students.dart';
import 'crud_operations.dart';


class insertar extends StatefulWidget {
  @override
  _Insert createState() => new _Insert();
}

class _Insert extends State<insertar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//Variables referentes al manejo de la bd
  Future<List<Student>> Studentss;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerAPaterno = TextEditingController();
  TextEditingController controllerAMaterno = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerMatricula = TextEditingController();
  TextEditingController controllerPhoto = TextEditingController();
  TextEditingController controllerImage = TextEditingController();
  String name;
  String Apaterno;
  String Amaterno;
  String email;
  String phone;
  String matricula = null;
  String photo;
  String image;
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
    controllerName.text = "";
    controllerAPaterno.text = "";
    controllerAMaterno.text = "";
    controllerPhone.text = "";
    controllerEmail.text = "";
    controllerMatricula.text = "";
    controllerPhoto.text = "";
    controllerImage.text = "";
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: Colors.black,
        content: new Text(
          value,
          style: TextStyle(fontSize: 20.0, color: Colors.cyan),
        )));
  }

  void verificar() async {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      if (isUpdating) {
        Student stu = Student(
            currentUserId, name, Apaterno, Amaterno, phone, email, matricula,photo);
        bdHelper.update(stu);
        setState(() {
          isUpdating = false;
        });
      } else {
        Student stu =
            Student(null, name, Apaterno, Amaterno, phone, email, matricula,photo);
        var col = await bdHelper.Matricula(matricula);
        print(col);
        if (col == 0) {
          bdHelper.insert(stu);
          showInSnackBar("Data saved");
        } else {
          showInSnackBar(" NO PUEDE HABER DOS MATICULAS IGUALES");
        }
      }
      cleanData();
      refreshList();
    }
  }

  final formkey = new GlobalKey<FormState>();
  ImageGallery(BuildContext context) {
    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
      image = imgString;
      Navigator.of(context).pop();
      controllerPhoto.text = "Campo lleno";
      return image;
    });
  }

  ImageCamera(BuildContext context) {
    ImagePicker.pickImage(source: ImageSource.camera).then((imgFile) {
      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
      image = imgString;
      Navigator.of(context).pop();
      controllerPhoto.text = "Campo lleno";
      return image;
    });
  }

  //Select the image
  Future<void> _selectphoto(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("elije", textAlign: TextAlign.center,),
              backgroundColor: Colors.black,
              content: SingleChildScrollView(
                child: ListBody(children: <Widget>[
                  GestureDetector(
                    child: Text("Galeria"),
                    onTap: () {
                      ImageGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(10.0),),
                  GestureDetector(
                    child: Text("Camara",),
                    onTap: () {
                      ImageCamera(context );
                    },
                  )
                ]),
              ));
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(
          "INSERTAR",

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
                  verticalDirection: VerticalDirection.up,
                  children: <Widget>[
                    TextFormField(
                      controller: controllerPhoto,
                      decoration: InputDecoration(
                          labelText: "Photo",
                          suffixIcon: RaisedButton(
                            color: Colors.grey,
                            onPressed: () {
                              _selectphoto(context);
                            },
                            child: Text("Select image", textAlign: TextAlign.center,),
                          )),
                      validator: (val) => val.length == 0
                          ? 'Debes subir una imagen'
                          : controllerPhoto.text == "Campo lleno"
                          ? null
                          : "Solo imagenes",
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    TextFormField(
                      controller: controllerName,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Name',
                          contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          icon: Icon(
                            Icons.person,
                            size: 35.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      validator: (val) => val.length == 0 ? 'Enter name' : null,
                      onSaved: (val) => name = val.toUpperCase(),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: controllerAPaterno,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'apellido paterno',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          icon: Icon(
                            Icons.person_pin,
                            color: Colors.cyan,
                            size: 35.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      validator: (val) =>
                          val.length == 0 ? 'Ingrese apellido' : null,
                      onSaved: (val) => Apaterno = val.toUpperCase(),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: controllerAMaterno,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'apellido materno',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          icon: Icon(
                            Icons.person_pin,
                            color: Colors.cyan,
                            size: 35.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      validator: (val) =>
                          val.length == 0 ? 'Ingrese apellido' : null,
                      onSaved: (val) => Amaterno = val.toUpperCase(),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          icon: Icon(
                            Icons.contact_mail,
                            color: Colors.cyan,
                            size: 35.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      validator: (val) =>
                          !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                  .hasMatch(val)
                              ? 'Enter mail'
                              : null,
                      onSaved: (val) => email = val,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: controllerPhone,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: 'numero de telefono',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          icon: Icon(
                            Icons.phone_android,
                            color: Colors.cyan,
                            size: 35.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      validator: (val) => val.length < 10
                          ? ' los numero de telefono tienen 10 caracteres'
                          : null,
                      onSaved: (val) => phone = val,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: controllerMatricula,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Matricula',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          icon: Icon(
                            Icons.perm_identity,
                            color: Colors.cyan,
                            size: 35.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      validator: (val) =>
                          (val.length < 10) ? 'Matricula' : null,
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
                              side: BorderSide(color: Colors.cyan, width: 2.0)),
                          onPressed: () async {
                            verificar();
                          },
                          child: Text(
                            isUpdating ? 'ACTUALIZAR' : 'AÑADIR',
                            style: TextStyle(fontSize: 17.0),
                          ),
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.cyan, width: 2.0)),
                          onPressed: () {
                            setState(() {
                              isUpdating = false;
                            });
                            cleanData();
                          },
                          child: Text('CANCELAR',
                              style: TextStyle(fontSize: 17.0)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),


    );
  }
}



