import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peopleforanimal/models/teamname.dart';
import 'package:uuid/uuid.dart';

class RescueteamName extends StatefulWidget {
  final String uid;
  RescueteamName({Key key, this.uid}) : super(key: key);

  @override
  _RescueteamNameState createState() => _RescueteamNameState();
}

class _RescueteamNameState extends State<RescueteamName> {
  final databaseReference = FirebaseDatabase.instance.reference();
  final _formKey = GlobalKey<FormState>();
  String name;
  String phoneno;
  bool active = true;
  int l;
  var arr;
  var uuid = Uuid();
  int c = 0;
  bool loading = false;

  List<Teamname> _list = [];
  void getdatabase() {
    print("start");
    var teamrefrence = FirebaseDatabase.instance.reference().child("Users");
    setState(() {
      loading = true;
    });

    teamrefrence.once().then((datasnapshot) {
      _list.clear();
      var keys = datasnapshot.value.keys;
      var values = datasnapshot.value;
      for (var key in keys) {
        if (values[key]["role"] == "rescueTeam") {
          Teamname team = Teamname(
              name: values[key]["name"],
              phone: values[key]["phone"],
              active: values[key]["active"],
              uid: values[key]["uid"]);
          _list.add(team);
        }
      }
      setState(() {});
    });
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getdatabase();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Rescue Team"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (ctx) {
                return loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : SingleChildScrollView(
                        child: Container(
                          height: size.height * .25,
                          margin: EdgeInsets.all(20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: 'Rescue Member Name',
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
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  decoration: InputDecoration(
                                    hintText: 'Contact Number',
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
                                    phoneno = val;
                                  },
                                  validator: (val) {
                                    if (val.length == 0 || val.length != 10)
                                      return "This field Can't Be empty";
                                  },
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Container(
                                    height: 50,
                                    width: size.width * 0.4,
                                    child: Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            var teamrefrence = FirebaseDatabase
                                                .instance
                                                .reference()
                                                .child("Users");
                                            setState(() {
                                              loading = true;
                                            });
                                            teamrefrence
                                                .once()
                                                .then((datasnapshot) {
                                              var keys =
                                                  datasnapshot.value.keys;
                                              var values = datasnapshot.value;

                                              for (var key in keys) {
                                                if (values[key]["phone"] ==
                                                    phoneno) {
                                                  c++;

                                                  databaseReference
                                                      .child('Users')
                                                      .child(key.toString())
                                                      .set({
                                                    "phone": phoneno,
                                                    "name": name,
                                                    "role": "rescueTeam",
                                                    "active": "true",
                                                    "uid": key.toString()
                                                  });
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    getdatabase();
                                                  });

                                                  break;
                                                }
                                              }
                                              setState(() {
                                                loading = false;
                                              });
                                              if (c == 0) {
                                                Platform.isIOS
                                                    ? showCupertinoDialog(
                                                        barrierDismissible:
                                                            false,
                                                        context: context,
                                                        builder: (ctx) {
                                                          return CupertinoAlertDialog(
                                                            content: Expanded(
                                                              child: Text(
                                                                  "Team members First need to register"),
                                                            ),
                                                            actions: [
                                                              CupertinoDialogAction(
                                                                  child: Text(
                                                                      "OK"),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  }),
                                                            ],
                                                          );
                                                        })
                                                    : showDialog(
                                                        barrierDismissible:
                                                            false,
                                                        context: context,
                                                        builder: (ctx) {
                                                          return AlertDialog(
                                                            content: Expanded(
                                                              child: Text(
                                                                  "Team members First need to register"),
                                                            ),
                                                            actions: [
                                                              FlatButton(
                                                                  child: Text(
                                                                      "OK"),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  }),
                                                            ],
                                                          );
                                                        });
                                              }
                                            });
                                          }
                                        },
                                        child: Text("Done"),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
              });
        },
      ),
      body: _list.length == 0
          ? Center(
              child: Text("There is no data"),
            )
          : ListView.builder(
              itemCount: _list.length,
              itemBuilder: (context, i) {
                print(_list.length);

                return Card(
                  child: SwitchListTile(
                    title: Text(
                      _list[i].name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_list[i].phone),
                    value: _list[i].active == "true" ? true : false,
                    onChanged: (val) {
                      // active = val;

                      databaseReference
                          .child('Users')
                          .child(_list[i].uid)
                          .update({"active": val.toString()});
                      getdatabase();
                    },
                  ),
                );
              },
            ),
    );
  }
}
