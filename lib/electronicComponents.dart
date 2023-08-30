// ignore_for_file: camel_case_types, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'sensors.dart';

import 'commonFunctions.dart';
import 'functions.dart';

Stream<List<electronicComponentsConvertor>> readelectronicComponents() =>
    FirebaseFirestore.instance
        .collection('electronicComponents')
        .orderBy("heading", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => electronicComponentsConvertor.fromJson(doc.data()))
            .toList());

Future createsensors(
    {required String name,
    required String description,
    required String photoUrl}) async {
  final docflash =
      FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash =
      electronicComponentsConvertor(id: docflash.id, name: name, photoUrl: "");
  final json = flash.toJson();
  await docflash.set(json);
}

class electronicComponentsConvertor {
  String id;
  final String name, photoUrl;
  electronicComponentsConvertor(
      {this.id = "", required this.name, required this.photoUrl});
  Map<String, dynamic> toJson() =>
      {"id": id, "heading": name, "photoUrl": photoUrl};

  static electronicComponentsConvertor fromJson(Map<String, dynamic> json) =>
      electronicComponentsConvertor(
          id: json['id'], name: json["heading"], photoUrl: json["photoUrl"]);
}

Stream<List<subElectronicComponentsConvertor>> readsubElectronicComponents(
        String id) =>
    FirebaseFirestore.instance
        .collection('electronicComponents')
        .doc(id)
        .collection("subComponents")
        .orderBy("name", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => subElectronicComponentsConvertor.fromJson(doc.data()))
            .toList());

Future createtoolsRequired(
    {required String heading,
    required String description,
    required bool isHomePage,
    required bool isSubPage,
    required String creator,
    required String photoUrl}) async {
  final docflash =
      FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = subElectronicComponentsConvertor(
      id: docflash.id, name: heading, pinDiagram: "", photoUrl: "");
  final json = flash.toJson();
  await docflash.set(json);
}

class subElectronicComponentsConvertor {
  String id;
  final String name, photoUrl, pinDiagram;

  subElectronicComponentsConvertor(
      {this.id = "",
      required this.name,
      required this.photoUrl,
      required this.pinDiagram});

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  static subElectronicComponentsConvertor fromJson(Map<String, dynamic> json) =>
      subElectronicComponentsConvertor(
          id: json['id'],
          name: json["name"],
          photoUrl: json["photoUrl"],
          pinDiagram: json["pinDiagram"]);
}

class electronicComponent extends StatefulWidget {
  String id1, id2, heading, photoUrl, pinDiagram;
  electronicComponent(
      {required this.id1,
      required this.id2,
      required this.heading,
      required this.photoUrl,
      required this.pinDiagram});

  @override
  State<electronicComponent> createState() => _electronicComponentState();
}

class _electronicComponentState extends State<electronicComponent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              shadowColor: Colors.transparent,
              toolbarHeight: 52,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              flexibleSpace: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.white54),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white70,
                                size: 30,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        Flexible(
                          child: widget.heading.length >
                                  20 // Adjust the condition based on your requirements
                              ? Marquee(
                                  text: widget.heading,
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                  scrollAxis: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  blankSpace: 20.0,
                                  velocity: 100.0,
                                  pauseAfterRound: Duration(seconds: 1),
                                  startPadding: 0.0,
                                  accelerationDuration: Duration(seconds: 1),
                                  accelerationCurve: Curves.linear,
                                  decelerationDuration:
                                      Duration(milliseconds: 500),
                                  decelerationCurve: Curves.easeOut,

                                  // Rest of the Marquee widget properties...
                                )
                              : Text(
                                  widget.heading,
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      overflow: TextOverflow.ellipsis),
                                ),
                        ),
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.white54),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Icon(
                                Icons.comment,
                                color: Colors.white70,
                                size: 30,
                              ),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              floating: true,
              primary: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 5, bottom: 10),
                        child: Text(
                          widget.heading,
                          style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                      if (widget.photoUrl.isNotEmpty)
                        Center(child: Image.network(widget.photoUrl)),

                      if (widget.pinDiagram.isNotEmpty)
                        const Padding(
                          padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                          child: Text(
                            "Pin Diagram",
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      if (widget.pinDiagram.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 3, right: 3, top: 10, bottom: 5),
                          child: Image.network(
                            widget.pinDiagram,
                          ),
                        ),
                      SizedBox(
                        height: 150,
                      )
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

Stream<List<electronicComponentsDescriptionConvertor>>
    readelectronicComponentsDescription(String id1, String id2) =>
        FirebaseFirestore.instance
            .collection('electronicComponents')
            .doc(id1)
            .collection("subComponents")
            .doc(id2)
            .collection("electronicComponentsDescription")
            .orderBy("id", descending: false)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => electronicComponentsDescriptionConvertor
                    .fromJson(doc.data()))
                .toList());

Future createtoolsRequred(
    {required String heading,
    required String description,
    required String creator,
    required String photoUrl}) async {
  final docflash =
      FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = electronicComponentsDescriptionConvertor(
      id: docflash.id, heading: heading, table: "", photoUrl: "");
  final json = flash.toJson();
  await docflash.set(json);
}

class electronicComponentsDescriptionConvertor {
  String id;
  final String heading;
  final String table;
  final String photoUrl;

  electronicComponentsDescriptionConvertor({
    this.id = "",
    required this.heading,
    required this.table,
    required this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": heading,
        "photoUrl": photoUrl,
        "table": table,
      };

  static electronicComponentsDescriptionConvertor fromJson(
          Map<String, dynamic> json) =>
      electronicComponentsDescriptionConvertor(
        id: json['id'],
        heading: json["description"],
        table: json["table"],
        photoUrl: json["photoUrl"],
      );
}
