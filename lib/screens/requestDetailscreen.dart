import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peopleforanimal/models/teamname.dart';
import 'package:peopleforanimal/screens/slitetoconfirmscreen.dart';

import 'package:slider_button/slider_button.dart';

class RequestDetailsscreen extends StatefulWidget {
  final String phone;
  final String name;
  final String currentdate;
  final double latitude;
  final double longitude;
  final String address;
  final String imageurl;
  final String animaltype;
  final String problem;
  final String rescuedatetime;
  final String entryid;
  final String teamphone;
  final String uid;

  RequestDetailsscreen(
      {Key key,
      this.address,
      this.animaltype,
      this.currentdate,
      this.imageurl,
      this.latitude,
      this.longitude,
      this.name,
      this.phone,
      this.problem,
      this.rescuedatetime,
      this.entryid,
      this.teamphone,
      this.uid})
      : super(key: key);

  @override
  _RequestDetailsscreenState createState() => _RequestDetailsscreenState();
}

class _RequestDetailsscreenState extends State<RequestDetailsscreen> {
  Teamname team;
  final databaseReference = FirebaseDatabase.instance.reference();
  void deletedatase(String entryid) {
    FirebaseDatabase.instance
        .reference()
        .child("Requests")
        .child('NewRequests')
        .child(entryid)
        .remove();
  }

  void getteamdatabase() {
    var teamrefrence =
        FirebaseDatabase.instance.reference().child("Users").child(widget.uid);
    teamrefrence.once().then((snaphot) {
      team = Teamname(
        name: snaphot.value["name"],
        phone: snaphot.value["phone"],
      );
    });
  }

  void setentry() {
    databaseReference
        .child("Requests")
        .child('OngoingRequests')
        .child(widget.entryid)
        .set({
      "phone": widget.phone,
      "name": widget.name,
      "currentdate": DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now()),
      "latitude": widget.latitude,
      "longitude": widget.longitude,
      "address": widget.address,
      "imageurl": widget.imageurl == null ? "No Image" : widget.imageurl,
      "animaltype": widget.animaltype,
      "problem": widget.problem,
      "rescuedatetime": widget.rescuedatetime,
      "entryid": widget.entryid,
      "teamphone": widget.teamphone,
      "teamname": team.name
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getteamdatabase();
  }

  void showdialogbox() {
    Platform.isIOS
        ? showCupertinoDialog(
            context: context,
            builder: (ctx) {
              return CupertinoAlertDialog(
                title: Text("Warning!"),
                content: Expanded(
                  child: Text("You first need to accept Request"),
                ),
                actions: [
                  CupertinoDialogAction(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      }),
                ],
              );
            })
        : showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text("Warning!"),
                content: Expanded(
                  child: Text("You first need to accept Request"),
                ),
                actions: [
                  FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      }),
                ],
              );
            });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("People For Animal Details"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Card(
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: widget.imageurl == "No Image"
                        ? Center(
                            child: Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)),
                              child: Center(
                                child: Text("No image"),
                              ),
                            ),
                          )
                        : Center(
                            child: Image.network(
                              widget.imageurl,
                              height: 130,
                              width: 130,
                              fit: BoxFit.fill,
                            ),
                          )),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Animal Details",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: size.width * .3, child: Text("Animal")),
                          SizedBox(
                              width: size.width * .45,
                              child: Text(widget.animaltype))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: size.width * .3, child: Text("Problem")),
                          SizedBox(
                              width: size.width * .45,
                              child: Expanded(child: Text(widget.problem)))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: size.width * .3, child: Text("Rescue by")),
                          SizedBox(
                              width: size.width * .45,
                              child: Text(widget.rescuedatetime))
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contact Details",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(width: size.width * .3, child: Text("Name")),
                          SizedBox(
                              width: size.width * .45,
                              child: Text(widget.name)),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: size.width * .3, child: Text("Phone")),
                          SizedBox(
                              width: size.width * .45,
                              child: Text(widget.phone)),
                          IconButton(
                              icon: Icon(Icons.call),
                              onPressed: () => showdialogbox())
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Location Details",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: size.width * .3, child: Text("Location")),
                          SizedBox(
                              width: size.width * .45,
                              child: Expanded(child: Text(widget.address))),
                          IconButton(
                              icon: Icon(Icons.directions),
                              onPressed: () => showdialogbox())
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SliderButton(
                backgroundColor: Colors.blue,
                width: size.width * .9,
                icon: Icon(Icons.arrow_right_alt_rounded),
                action: () {
                  setentry();
                  deletedatase(widget.entryid);
                  print("Confirmed");

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (ctx) => Slidetoconfirmscreen(
                                address: widget.address,
                                animaltype: widget.animaltype,
                                currentdate: widget.currentdate,
                                entryid: widget.entryid,
                                imageurl: widget.imageurl,
                                latitude: widget.latitude,
                                longitude: widget.longitude,
                                name: widget.name,
                                phone: widget.phone,
                                problem: widget.problem,
                                rescuedatetime: widget.rescuedatetime,
                                teamphone: widget.teamphone,
                                uid: widget.uid,
                                teamname: team.name,
                              )),
                      (route) => false);
                },
                label: Text(
                  "Swipe to Go",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
