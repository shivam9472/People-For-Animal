import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peopleforanimal/screens/adminscreen.dart';
import 'package:peopleforanimal/screens/contactdetailscreen.dart';
import 'package:peopleforanimal/screens/detailsscreen.dart';
import 'package:peopleforanimal/screens/homescreen.dart';
import 'package:peopleforanimal/screens/teamscreen.dart';

class Otpscreen extends StatefulWidget {
  final String phone;

  // final String name;

  Otpscreen({
    Key key,
    this.phone,
  }) : super(key: key);

  @override
  _OtpscreenState createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otpscreen> {
  String smscode;
  String teamuid;
  String _verificationCode;
  bool loading = false;
  final databaseReference = FirebaseDatabase.instance.reference();
  void setentry(String uid) {
    databaseReference.child("Users").child(uid).set({
      "phone": widget.phone,
      "role": "user",
    });
  }

  _verifyPhone() async {
    print(widget.phone);

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          setState(() {
            loading = true;
          });
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Homescreen(
                            uid: value.user.uid,
                            phone: widget.phone,
                          )),
                  (route) => false);
            }
          });
          setState(() {
            loading = false;
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Details"),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: (size.height * 0.7),
                    margin: EdgeInsets.all(40),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              decoration: InputDecoration(
                                hintText: 'OTP',
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
                                smscode = val;
                              },
                              validator: (val) {
                                if (val.length == 0)
                                  return "This field Can't Be empty";
                              }),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    child: Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          try {
                            await FirebaseAuth.instance
                                .signInWithCredential(
                                    PhoneAuthProvider.credential(
                                        verificationId: _verificationCode,
                                        smsCode: smscode))
                                .then((value) async {
                              if (value.user != null) {
                                databaseReference
                                    .child("Users")
                                    .child(value.user.uid)
                                    .once()
                                    .then((snapshot) {
                                  if (snapshot.value == null) {
                                    setentry(value.user.uid);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Homescreen(
                                                  // name: widget.name,
                                                  phone: widget.phone,
                                                  uid: value.user.uid,
                                                )),
                                        (route) => false);
                                  } else {
                                    if (snapshot.value["role"] == "user") {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Homescreen(
                                                    // name: widget.name,
                                                    phone: widget.phone,
                                                    uid: value.user.uid,
                                                  )),
                                          (route) => false);
                                    } else if (snapshot.value["role"] ==
                                        "admin") {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Homescreen(
                                                    phone:
                                                        snapshot.value["phone"],
                                                    role: "admin",
                                                    uid: value.user.uid,
                                                  )),
                                          (route) => false);
                                    } else if (snapshot.value["role"] ==
                                        "rescueTeam") {
                                      if (snapshot.value["active"] == "true") {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Homescreen(
                                                        phone: snapshot
                                                            .value["phone"],
                                                        role: "team",
                                                        uid: value.user.uid)),
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
                                                          onPressed: () => Navigator
                                                                  .of(context)
                                                              .pushAndRemoveUntil(
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (ctx) =>
                                                                              ContactDetailScreen()),
                                                                  (route) =>
                                                                      false)),
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
                                                          onPressed: () => Navigator
                                                                  .of(context)
                                                              .pushAndRemoveUntil(
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (ctx) =>
                                                                              ContactDetailScreen()),
                                                                  (route) =>
                                                                      false)),
                                                    ],
                                                  );
                                                });
                                      }
                                    }
                                  }
                                });
                              }
                            });
                            setState(() {
                              loading = false;
                            });
                          } catch (e) {
                            setState(() {
                              loading = false;
                            });
                            Platform.isIOS
                                ? showCupertinoDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return CupertinoAlertDialog(
                                        title: Text(e.code),
                                        // content: Expanded(
                                        //   child: Text(e.message),
                                        // ),
                                        actions: [
                                          CupertinoDialogAction(
                                            child: Text("OK"),
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                          ),
                                        ],
                                      );
                                    })
                                : showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return AlertDialog(
                                        title: Text(e.code),
                                        // content: Expanded(
                                        //   child: Text(e.message),
                                        // ),
                                        actions: [
                                          FlatButton(
                                            child: Text("OK"),
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                          ),
                                        ],
                                      );
                                    });
                          }
                        },
                        child: Text("Submit"),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
