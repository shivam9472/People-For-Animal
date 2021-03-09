import 'dart:io';
import 'dart:math';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peopleforanimal/screens/homescreen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:peopleforanimal/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class DetailsScreen extends StatefulWidget {
  final String phone;
  final double latitue;
  final double longitude;
  final String address;
  final String role;

  final String uid;
  DetailsScreen(
      {Key key,
      this.phone,
      this.address,
      this.latitue,
      this.longitude,
      this.role,
      this.uid})
      : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  final picker = ImagePicker();
  File _image;
  final _formKey = GlobalKey<FormState>();
  String name;
  String animaltype;
  String problem;
  String datetime = DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now());
  String imageurl;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  bool loading = false;
  Future<void> getImage() async {
    setState(() {
      loading = true;
    });
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 30);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });

    await firebase_storage.FirebaseStorage.instance
        .ref('AnimalImages/${widget.uid}/${pickedFile.path}')
        .putFile(_image);

    imageurl = await firebase_storage.FirebaseStorage.instance
        .ref('AnimalImages/${widget.uid}/${pickedFile.path}')
        .getDownloadURL();
    setState(() {
      loading = false;
    });
  }

  var uuid = Uuid();

  void _submit(BuildContext context) {
    if (_formKey.currentState.validate()) {
      print(imageurl);
      print(datetime);
      try {
        databaseReference
            .child("Requests")
            .child('NewRequests')
            .child(uuid.v1())
            .set({
          "phone": widget.phone,
          "name": name,
          "currentdate": DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now()),
          "latitude": widget.latitue,
          "longitude": widget.longitude,
          "address": widget.address,
          "imageurl": imageurl == null ? "No Image" : imageurl,
          "animaltype": animaltype,
          "problem": problem,
          "rescuedatetime": datetime,
        });
      } catch (e) {
        print(e.toString());
      }

      Platform.isIOS
          ? showCupertinoDialog(
              barrierDismissible: false,
              context: context,
              builder: (ctx) {
                return CupertinoAlertDialog(
                  title: Text("Thank You"),
                  content: Expanded(
                    child: Text(
                        "We have Recieved Your Request.Someone from People for Animal team will contack you shortly"),
                  ),
                  actions: [
                    CupertinoDialogAction(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (ctx) => Homescreen(
                                        phone: widget.phone,
                                        uid: widget.uid,
                                        role: widget.role,
                                        completed: "yes",
                                        name: name,
                                      )),
                              (route) => false);
                        }),
                  ],
                );
              })
          : showDialog(
              barrierDismissible: false,
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text("Thank You"),
                  content: Expanded(
                    child: Text(
                        "We have Recieved Your Request.Someone from People for Animal team will contack you shortly"),
                  ),
                  actions: [
                    FlatButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (ctx) => Homescreen(
                                  phone: widget.phone,
                                  uid: widget.uid,
                                  role: widget.role,
                                  completed: "yes",
                                  name: name,
                                ),
                              ),
                              (route) => false);
                        }),
                  ],
                );
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("More Details"),
        actions: [],
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                            child: _image == null
                                ? GestureDetector(
                                    onTap: getImage,
                                    child: Container(
                                      height: size.height * 0.5,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: size.height * 0.5,
                                            width: size.width * 0.9,
                                            child: Center(
                                              child: Text(
                                                "Capture animal photo",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 25),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: IconButton(
                                              icon: Icon(Icons.camera),
                                              onPressed: getImage,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Image.file(_image,
                                    height: size.height * 0.5,
                                    width: size.height * 0.9,
                                    fit: BoxFit.fill)),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Animal Details",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: 'Which Animal (Example:Dog)',
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        width: 3,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(16),
                                  ),
                                  onChanged: (val) {
                                    animaltype = val;
                                  },
                                  validator: (val) {
                                    if (val.length == 0)
                                      return "This field Can't Be empty";
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.text,
                                  minLines: 1,
                                  maxLines: 6,
                                  maxLength: 100,
                                  decoration: InputDecoration(
                                    hintText: 'Problem for the Animal',
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        width: 3,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(16),
                                  ),
                                  onChanged: (val) {
                                    problem = val;
                                  },
                                  validator: (val) {
                                    if (val.length == 0)
                                      return "This field Can't Be empty";
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black54),
                                  ),
                                  child: DateTimePicker(
                                    type: DateTimePickerType.dateTimeSeparate,
                                    dateMask: 'd MMM, yyyy',
                                    initialValue: DateTime.now().toString(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                    icon: Icon(Icons.event),
                                    dateLabelText: 'Rescue By Date',
                                    timeLabelText: "Rescue By Time",
                                    onChanged: (val) {
                                      datetime = val;
                                      print(datetime);
                                    },
                                    validator: (val) {
                                      if (val.isEmpty)
                                        return "This Can't Be Null";
                                    },
                                    onSaved: (val) => print(val),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: widget.address,
                                  ),
                                  readOnly: true,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "Your Details",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                TextFormField(
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: 'Your Name',
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        width: 3,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(16),
                                  ),
                                  onChanged: (val) {
                                    name = val;
                                  },
                                  validator: (val) {
                                    if (val.length == 0)
                                      return "This field Can't Be empty";
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: widget.phone,
                                  ),
                                  readOnly: true,
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Container(
                    width: size.width,
                    height: 50,
                    child: Expanded(
                      child: ElevatedButton(
                        onPressed: () => _submit(context),
                        child: Text("Submit Request"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
