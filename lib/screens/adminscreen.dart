import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:peopleforanimal/models/requests.dart';
import 'package:peopleforanimal/screens/contactdetailscreen.dart';
import 'package:peopleforanimal/screens/homescreen.dart';
import 'package:peopleforanimal/screens/recueteamname.dart';
import 'package:peopleforanimal/services/auth.dart';
import 'package:provider/provider.dart';

enum WidgetMarker { all, ongoing, completed }

class Adminscreen extends StatefulWidget {
  final String uid;
  Adminscreen({Key key, this.uid}) : super(key: key);

  @override
  _AdminscreenState createState() => _AdminscreenState();
}

class _AdminscreenState extends State<Adminscreen> {
  WidgetMarker selectedWidgetMarker = WidgetMarker.ongoing;
  List<Request> _list = [];
  List<Request> _ongoinglist = [];
  List<Request> _completedlist = [];
  void getdatabase() {
    print("start");
    var teamrefrence = FirebaseDatabase.instance
        .reference()
        .child("Requests")
        .child('NewRequests');

    teamrefrence.once().then((datasnapshot) {
      _list.clear();
      var keys = datasnapshot.value.keys;
      var values = datasnapshot.value;

      for (var key in keys) {
        Request request = Request(
            name: values[key]["name"],
            address: values[key]["address"],
            animaltype: values[key]["animaltype"],
            currentdate: values[key]["currentdate"],
            entryid: key.toString(),
            imageurl: values[key]["imageurl"],
            latitude: values[key]["latitude"],
            longitude: values[key]["longitude"],
            phone: values[key]["phone"],
            problem: values[key]["problem"],
            rescuedatetime: values[key]["rescuedatetime"]);
        _list.add(request);
      }
      setState(() {});
    });
  }

  void getongoingdatabase() {
    var teamrefrence = FirebaseDatabase.instance
        .reference()
        .child("Requests")
        .child('OngoingRequests');

    teamrefrence.once().then((datasnapshot) {
      _ongoinglist.clear();
      var keys = datasnapshot.value.keys;
      var values = datasnapshot.value;

      for (var key in keys) {
        Request request = Request(
            name: values[key]["name"],
            address: values[key]["address"],
            animaltype: values[key]["animaltype"],
            currentdate: values[key]["currentdate"],
            entryid: key.toString(),
            imageurl: values[key]["imageurl"],
            latitude: values[key]["latitude"],
            longitude: values[key]["longitude"],
            phone: values[key]["phone"],
            problem: values[key]["problem"],
            rescuedatetime: values[key]["rescuedatetime"],
            teamphone: values[key]["teamphone"],
            teamname: values[key]["teamname"]);
        _ongoinglist.add(request);
      }
      setState(() {});
    });
  }

  void getcompleteddatabase() {
    var teamrefrence = FirebaseDatabase.instance
        .reference()
        .child("Requests")
        .child('CompletedRequests');

    teamrefrence.once().then((datasnapshot) {
      _completedlist.clear();
      var keys = datasnapshot.value.keys;
      var values = datasnapshot.value;

      for (var key in keys) {
        Request request = Request(
            name: values[key]["name"],
            address: values[key]["address"],
            animaltype: values[key]["animaltype"],
            currentdate: values[key]["currentdate"],
            entryid: key.toString(),
            imageurl: values[key]["imageurl"],
            latitude: values[key]["latitude"],
            longitude: values[key]["longitude"],
            phone: values[key]["phone"],
            problem: values[key]["problem"],
            rescuedatetime: values[key]["rescuedatetime"],
            teamphone: values[key]["teamphone"],
            teamname: values[key]["teamname"]);
        _completedlist.add(request);
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getdatabase();
    getongoingdatabase();
    getcompleteddatabase();
  }

  Widget ongoingWidget() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _ongoinglist.length,
        itemBuilder: (context, i) {
          return Card(
              child: ListTile(
                  title: Expanded(child: Text(_ongoinglist[i].problem)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(_ongoinglist[i].rescuedatetime),
                      Text(
                          "Handling By:-${_ongoinglist[i].teamname}(${_ongoinglist[i].teamphone})"),
                      Text("Accepted on ${_ongoinglist[i].currentdate}")
                    ],
                  ),
                  trailing: _ongoinglist[i].imageurl == "No Image"
                      ? Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: Center(
                            child: Text("No image"),
                          ),
                        )
                      : Image.network(
                          _ongoinglist[i].imageurl,
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,
                        )));
        });
  }

  Widget allrequestWidget() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _list.length,
        itemBuilder: (context, i) {
          return Card(
              child: ListTile(
                  title: Expanded(child: Text(_list[i].problem)),
                  subtitle: Text(_list[i].rescuedatetime),
                  trailing: _list[i].imageurl == "No Image"
                      ? Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: Center(
                            child: Text("No image"),
                          ),
                        )
                      : Image.network(
                          _list[i].imageurl,
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,
                        )));
        });
  }

  Widget completedWidget() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _completedlist.length,
        itemBuilder: (context, i) {
          return Card(
              child: ListTile(
                  title: Expanded(child: Text(_completedlist[i].problem)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(_completedlist[i].rescuedatetime),
                      Text(
                          "Handled By:-${_completedlist[i].teamname}(${_completedlist[i].teamphone})"),
                      Text("Completed on ${_completedlist[i].currentdate}")
                    ],
                  ),
                  trailing: _completedlist[i].imageurl == "No Image"
                      ? Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: Center(
                            child: Text("No image"),
                          ),
                        )
                      : Image.network(
                          _completedlist[i].imageurl,
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,
                        )));
        });
  }

  Widget getCustomContainer() {
    switch (selectedWidgetMarker) {
      case WidgetMarker.ongoing:
        return ongoingWidget();
      case WidgetMarker.all:
        return allrequestWidget();
      case WidgetMarker.completed:
        return completedWidget();
    }

    return ongoingWidget();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final auth = Provider.of<AuthBase>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("People For Animal Admin "),
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              color: Colors.white,
              onSelected: (value) {
                if (value == 2) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => RescueteamName(
                            uid: widget.uid,
                          )));
                } else if (value == 3) {
                  auth.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (ctx) => ContactDetailScreen(),
                      ),
                      (route) => false);
                } else if (value == 1) {
                  var teamrefrence = FirebaseDatabase.instance
                      .reference()
                      .child("Users")
                      .child(widget.uid);
                  teamrefrence.once().then((snap) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (ctx) => Homescreen(
                            phone: snap.value["phone"],
                            role: "admin",
                            uid: widget.uid,
                          ),
                        ),
                        (route) => false);
                  });
                }
              },
              itemBuilder: (context) => [
                    PopupMenuItem(value: 1, child: Text("Home")),
                    PopupMenuItem(value: 2, child: Text("Rescue Team")),
                    PopupMenuItem(value: 3, child: Text("Logout")),
                  ]),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => Adminscreen(
                        uid: widget.uid,
                      )),
              (route) => false);
        },
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: size.width * 0.3,
                    child: Expanded(
                      child: RaisedButton(
                        color: selectedWidgetMarker == WidgetMarker.all
                            ? Colors.blue
                            : Colors.white,
                        child: Text(
                          "All Requests",
                          style: TextStyle(
                            color: selectedWidgetMarker == WidgetMarker.all
                                ? Colors.white
                                : Colors.blue,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedWidgetMarker = WidgetMarker.all;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                        width: size.width * 0.3,
                        child: Expanded(
                          child: RaisedButton(
                            color: selectedWidgetMarker == WidgetMarker.ongoing
                                ? Colors.blue
                                : Colors.white,
                            child: Text(
                              "Ongoing",
                              style: TextStyle(
                                color:
                                    selectedWidgetMarker == WidgetMarker.ongoing
                                        ? Colors.white
                                        : Colors.blue,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedWidgetMarker = WidgetMarker.ongoing;
                              });
                            },
                          ),
                        ))),
                ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                        width: size.width * 0.3,
                        child: Expanded(
                          child: RaisedButton(
                            color:
                                selectedWidgetMarker == WidgetMarker.completed
                                    ? Colors.blue
                                    : Colors.white,
                            child: Text(
                              "Completed",
                              style: TextStyle(
                                color: selectedWidgetMarker ==
                                        WidgetMarker.completed
                                    ? Colors.white
                                    : Colors.blue,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedWidgetMarker = WidgetMarker.completed;
                              });
                            },
                          ),
                        )))
              ],
            ),
            Container(
              child: getCustomContainer(),
            ),
          ],
        ),
      ),
    );
  }
}
