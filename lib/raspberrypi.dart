// ignore_for_file: import_of_legacy_library_into_null_safe, non_constant_identifier_names, camel_case_types, must_be_immutable, use_key_in_widget_constructors, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:marquee/marquee.dart';
import 'sensors.dart';
import 'settings.dart';
import 'textField.dart';
import 'package:url_launcher/url_launcher.dart';
import 'commonFunctions.dart';
import 'functions.dart';
import 'main.dart';
const TextStyle creatorHeadingTextStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Colors.white);

class raspberrypiBoards extends StatefulWidget {
  const raspberrypiBoards({Key? key}) : super(key: key);

  @override
  State<raspberrypiBoards> createState() => _raspberrypiBoardsState();
}

class _raspberrypiBoardsState extends State<raspberrypiBoards> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Board",
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          StreamBuilder<List<raspiBoardsConvertor>>(
            stream: readraspiBoards(),
            builder: (context, snapshot) {
              final Subjects = snapshot.data;
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 0.3,
                    color: Colors.cyan,
                  ));
                default:
                  if (snapshot.hasError) {
                    return const Text("Error with server");
                  } else {
                    return SizedBox(
                      height: 140,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: Subjects!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          final SubjectsData = Subjects[index];
                          return InkWell(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: SizedBox(
                                    height: 140,
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black38,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(15)),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                SubjectsData.photoUrl,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Container(
                                              width: double.infinity,
                                              // height: 50,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(15),
                                                    bottomRight:
                                                        Radius.circular(15)),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topRight,
                                                    end: Alignment.bottomLeft,
                                                    colors: [
                                                      Colors.black12,
                                                      Colors.black38,
                                                      Colors.black54
                                                    ]),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  SubjectsData.name,
                                                  style: const TextStyle(
                                                    fontSize: 28.0,
                                                    color: Colors.tealAccent,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                                if (Subjects.length - index == 1)
                                  SizedBox(
                                    width: 80,
                                  )
                              ],
                            ),
                            onTap: () {
                              FirebaseFirestore.instance
                                  .collection('raspberrypi')
                                  .doc("raspberrypiBoard")
                                  .collection("Boards")
                                  .doc(SubjectsData
                                  .id) // Replace "documentId" with the ID of the document you want to retrieve
                                  .get()
                                  .then((DocumentSnapshot snapshot) async {
                                if (snapshot.exists) {
                                  var data = snapshot.data();
                                  if (data != null &&
                                      data is Map<String, dynamic>) {
                                    List<String> images = [];
                                    if (SubjectsData.photoUrl.isNotEmpty) {
                                      images = SubjectsData.photoUrl.split(";");
                                    }
                                    if (data['pinDiagram']
                                        .toString()
                                        .isNotEmpty) {
                                      images.addAll(data['pinDiagram']
                                          .toString()
                                          .split(";"));
                                    }

                                    if (!kIsWeb) {
                                      await showDialog(
                                        context: context,
                                        builder: (context) =>
                                            ImageDownloadScreen(
                                              typeOfProject: "raspberrypiBoard",
                                              images: images,
                                              id: data['id'],
                                            ),
                                      );
                                    }

                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                        const Duration(milliseconds: 300),
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                            raspberrypiBoard(
                                              pinDiagram: data['pinDiagram'],
                                              id: SubjectsData.id,
                                              heading: SubjectsData.name,
                                              description: data['description'],
                                              photoUrl: SubjectsData.photoUrl,
                                            ),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          final fadeTransition = FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );

                                          return Container(
                                            color: Colors.black
                                                .withOpacity(animation.value),
                                            child: AnimatedOpacity(
                                                duration:
                                                Duration(milliseconds: 300),
                                                opacity: animation.value
                                                    .clamp(0.3, 1.0),
                                                child: fadeTransition),
                                          );
                                        },
                                      ),
                                    );
                                  }
                                } else {
                                  print("Document does not exist.");
                                }
                              }).catchError((error) {
                                print(
                                    "An error occurred while retrieving data: $error");
                              });
                            },
                          );
                        },
                      ),
                    );
                  }
              }
            },
          ),
          SizedBox(
            height: 150,
          )
        ],
      ),
    );
  }
}

Stream<List<raspiBoardsConvertor>> readraspiBoards() =>
    FirebaseFirestore.instance
        .collection('raspberrypi')
        .doc("raspberrypiBoard")
        .collection("Boards")
        .orderBy("name", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => raspiBoardsConvertor.fromJson(doc.data()))
            .toList());

Future createraspiBoards(
    {required String name,
    required String description,
    required String photoUrl}) async {
  final docflash =
      FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = raspiBoardsConvertor(
      id: docflash.id,
      name: name,
      photoUrl: photoUrl);
  final json = flash.toJson();
  await docflash.set(json);
}

class raspiBoardsConvertor {
  String id;
  final String name,photoUrl;

  raspiBoardsConvertor(
      {this.id = "",
      required this.name,
      required this.photoUrl});

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "photoUrl": photoUrl
      };

  static raspiBoardsConvertor fromJson(Map<String, dynamic> json) =>
      raspiBoardsConvertor(
          id: json['id'],
          name: json["name"],
          photoUrl: json["photoUrl"]);
}

class raspberrypiBoard extends StatefulWidget {
  String id, heading, description, photoUrl,pinDiagram;
  raspberrypiBoard(
      {required this.id,
      required this.heading,
      required this.description,
      required this.pinDiagram,
      required this.photoUrl});

  @override
  State<raspberrypiBoard> createState() => _raspberrypiBoardState();
}

class _raspberrypiBoardState extends State<raspberrypiBoard> {
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
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.photoUrl.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: InkWell(
                                child:  scrollingImages(images: widget.photoUrl.split(";"), typeOfProject: "raspberrypiBoard", id: widget.id),
                                onTap: () {
                                  showToastText(longPressToViewImage);
                                },
                                onLongPress: () {
                                  if (widget.photoUrl.length > 3) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                zoom(
                                                    typeOfProject: 'raspberrypiBoard', id:widget.id,
                                                    url: widget
                                                        .photoUrl)));
                                  } else {
                                    showToastText(noImageUrl);
                                  }
                                },
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.heading.split(";").last,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),

                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.white24,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                    top: 10,
                                    bottom: 3),
                                child: Text(
                                  "Description",
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                height: 3,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    bottom: 15,
                                    top: 13),
                                child: Text(
                                  "              ${widget.description}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  Description(c0: 'raspberrypi',d0: "raspberrypiBoard",c1: "Boards",d1:widget.id, typeOfProject: 'raspberrypiBoard',),
                  if (widget.pinDiagram.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                        child:  scrollingImages(images: widget.pinDiagram.split(";"), typeOfProject: "raspberrypiBoard", id: widget.id),
                        onTap: () {
                          showToastText(longPressToViewImage);
                        },
                        onLongPress: () {
                          if (widget.pinDiagram.length > 3) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        zoom(
                                            typeOfProject: 'raspberrypiBoard', id:widget.id,
                                            url: widget
                                                .pinDiagram)));
                          } else {
                            showToastText(noImageUrl);
                          }
                        },
                      ),
                    ),
                  Center(child: Text("--${widget.heading}--")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}







