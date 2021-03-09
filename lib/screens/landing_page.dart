import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peopleforanimal/screens/adminscreen.dart';
import 'package:peopleforanimal/screens/contactdetailscreen.dart';
import 'package:peopleforanimal/screens/detailsscreen.dart';
import 'package:peopleforanimal/screens/teamscreen.dart';
import 'package:peopleforanimal/services/auth.dart';
import 'package:provider/provider.dart';

import 'homescreen.dart';

class LandingPage extends StatefulWidget {
  // final String address;
  // final double latitude;
  // final double longitude;

  LandingPage();

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String role;
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder<UsersUid>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            UsersUid user = snapshot.data;
            if (user == null) {
              // Navigator.of(context).pushAndRemoveUntil(
              //     MaterialPageRoute(
              // builder: (ctx) =>

              return ContactDetailScreen(
                  // address: widget.address,
                  // latitue: widget.latitude,
                  // longitude: widget.longitude,
                  );
              //   ),
              // ),
              // (route) => false);
            } else {
              final databaseReference = FirebaseDatabase.instance.reference();

              databaseReference
                  .child("Users")
                  .child(user.uid)
                  .once()
                  .then((snap) {
                if (snap.value["role"] == "user") {
                  role = "user";
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (ctx) => Homescreen(
                                phone: snap.value["phone"],
                                uid: user.uid,
                              )),
                      (route) => false);
                } else if (snap.value["role"] == "admin") {
                  role = "admin";
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (ctx) => Homescreen(
                                phone: snap.value["phone"],
                                uid: user.uid,
                                role: "admin",
                              )),
                      (route) => false);
                } else if (snap.value["role"] == "rescueTeam") {
                  if (snap.value["active"] == "true") {
                    role = "team";
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (ctx) => Homescreen(
                                  uid: user.uid,
                                  phone: snap.value["phone"],
                                  role: "team",
                                )),
                        (route) => false);
                  } else {
                    Platform.isIOS
                        ? showCupertinoDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (ctx) {
                              return CupertinoAlertDialog(
                                title: Text(
                                    "You Have Blocked By Admin.Please Contact Admin"),
                                actions: [
                                  CupertinoDialogAction(
                                      child: Text("OK"),
                                      onPressed: () => Navigator.of(context)
                                          .pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      Homescreen()),
                                              (route) => false)),
                                ],
                              );
                            })
                        : showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                title: Text(
                                    "You Have Blocked By Admin.Please Contact Admin"),
                                actions: [
                                  FlatButton(
                                      child: Text("OK"),
                                      onPressed: () => Navigator.of(context)
                                          .pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      Homescreen()),
                                              (route) => false)),
                                ],
                              );
                            });
                  }
                }
              });
              return Scaffold(
                  body: Center(
                child: CircularProgressIndicator(),
              ));
            }
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
