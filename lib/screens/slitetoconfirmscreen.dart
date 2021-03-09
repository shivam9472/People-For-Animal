import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peopleforanimal/models/teamname.dart';
import 'package:peopleforanimal/screens/teamscreen.dart';

import 'package:slider_button/slider_button.dart';

import 'package:url_launcher/url_launcher.dart';

class Slidetoconfirmscreen extends StatefulWidget {
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
  final String teamname;

  Slidetoconfirmscreen(
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
      this.uid,
      this.teamname})
      : super(key: key);

  @override
  _SlidetoconfirmscreenState createState() => _SlidetoconfirmscreenState();
}

class _SlidetoconfirmscreenState extends State<Slidetoconfirmscreen> {
  bool loading = false;
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchURL(double latitude, double longitude) async {
    String url = "https://maps.google.com/?q=$latitude,$longitude";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final databaseReference = FirebaseDatabase.instance.reference();

  void deletedatase(String entryid) {
    setState(() {
      loading = true;
    });
    FirebaseDatabase.instance
        .reference()
        .child("Requests")
        .child("OngoingRequests")
        .child(entryid)
        .remove();
    setState(() {
      loading = false;
    });
  }

  // void getteamdatabase() {
  //   setState(() {
  //     loading = true;
  //   });
  //   var teamrefrence = FirebaseDatabase.instance
  //       .reference()
  //       .child("Teams")
  //       .child("${widget.teamphone}");
  //   teamrefrence.once().then((snaphot) {
  //     team = Teamname(
  //       name: snaphot.value["name"],
  //       phone: snaphot.value["phone"],
  //     );
  //   });
  //   setState(() {
  //     loading = false;
  //   });
  // }

  void setentry() {
    setState(() {
      loading = true;
    });
    databaseReference
        .child("Requests")
        .child('CompletedRequests')
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
      "teamname": widget.teamname
    });
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _launchURL(widget.latitude, widget.longitude);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("People For Animal Details"),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Card(
                      child: Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: widget.imageurl == "No Image"
                              ? Center(
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Center(
                                      child: Text("No image"),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Image.network(
                                    widget.imageurl,
                                    height: 100,
                                    width: 100,
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
                                    width: size.width * .3,
                                    child: Text("Animal")),
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
                                    width: size.width * .3,
                                    child: Text("Problem")),
                                SizedBox(
                                    width: size.width * .45,
                                    child:
                                        Expanded(child: Text(widget.problem)))
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                    width: size.width * .3,
                                    child: Text("Rescue by")),
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
                                SizedBox(
                                    width: size.width * .3,
                                    child: Text("Name")),
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
                                    width: size.width * .3,
                                    child: Text("Phone")),
                                SizedBox(
                                    width: size.width * .45,
                                    child: Text(widget.phone)),
                                IconButton(
                                    icon: Icon(Icons.call),
                                    onPressed: () =>
                                        _makePhoneCall('tel:${widget.phone}'))
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
                                    width: size.width * .3,
                                    child: Text("Location")),
                                SizedBox(
                                    width: size.width * .45,
                                    child:
                                        Expanded(child: Text(widget.address))),
                                IconButton(
                                    icon: Icon(Icons.directions),
                                    onPressed: () => _launchURL(
                                        widget.latitude, widget.longitude))
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
                        print("Confirmed");
                        setentry();
                        deletedatase(widget.entryid);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (ctx) => Teamscreen(
                                      teamphone: widget.teamphone,
                                      uid: widget.uid,
                                    )),
                            (route) => false);
                      },
                      label: Text(
                        "Swipe to Confirm",
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
