// ignore_for_file: camel_case_types, must_be_immutable, non_constant_identifier_names, import_of_legacy_library_into_null_safe, prefer_const_constructors, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures, use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ns_ideas/authPage.dart';
import 'package:ns_ideas/textField.dart';
import 'commonFunctions.dart';
import 'electronicProjects.dart';
import 'functions.dart';
import 'homepage.dart';

class arduinoAndProjects extends StatefulWidget {
  final List<ProjectsConvertor> data;

  arduinoAndProjects({required this.data});

  @override
  State<arduinoAndProjects> createState() => _arduinoAndProjectsState();
}

class _arduinoAndProjectsState extends State<arduinoAndProjects> {
  String folderPath = "";
  File file = File("");
  late List filteredData=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPath();
     filteredData = widget.data.where((subjectData) => subjectData.type.split(";").last == "AP").toList();

  }

  getPath() async {
  }

  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return backGroundImage(
      text: "Arduino",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: Size * 15, bottom: Size * 15),
            child: Text(
              "Boards",
              style: TextStyle(color: Colors.white, fontSize: Size * 25),
            ),
          ),
          StreamBuilder<List<arduinoBoardsConvertor>>(
            stream: readarduinoBoards(),
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
                      height: Size * 95,
                      child: ListView.separated(
                          itemCount: Subjects!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            final SubjectsData = Subjects[index];

                            return InkWell(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: Size * 15),
                                    child: Stack(
                                      children: [

                                        AspectRatio(
                                          aspectRatio: 9 / 5,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: ImageShowAndDownload(
                                              image: SubjectsData.images.split(";").first,
                                              id: SubjectsData.id,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            bottom: 0,right: 0,
                                            child: Padding(
                                          padding:
                                          EdgeInsets.all(Size * 5.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withOpacity(0.8),
                                              borderRadius:
                                              BorderRadius.circular(
                                                  Size * 15),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: Size * 8.0),
                                              child: Text(
                                                SubjectsData.name
                                                    .split(";")
                                                    .last,
                                                style: TextStyle(
                                                  fontSize: Size * 20.0,
                                                  color: Colors.black,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow:
                                                TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ))

                                      ],
                                    ),
                                  ),
                                  if (Subjects.length - index == 1)
                                    SizedBox(
                                      width: Size * 80,
                                    )
                                ],
                              ),
                              onTap: () {
                                FirebaseFirestore.instance
                                    .collection("arduino")
                                    .doc("arduinoBoards")
                                    .collection("Board")
                                    .doc(SubjectsData
                                        .id) // Replace "documentId" with the ID of the document you want to retrieve
                                    .get()
                                    .then((DocumentSnapshot snapshot) async {
                                  if (snapshot.exists) {
                                    var data = snapshot.data();
                                    if (data != null &&
                                        data is Map<String, dynamic>) {
                                      List<String> images = [];
                                      images = data['photoUrl']
                                          .toString()
                                          .split(";");
                                      images.addAll(data['pinDiagram']
                                          .toString()
                                          .split(";"));



                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration:
                                              const Duration(milliseconds: 300),
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              arduinoBoard(
                                            pinDiagram: data['pinOut'],
                                            id: SubjectsData.id,
                                            heading: SubjectsData.name,
                                            description: data['description'],
                                            photoUrl: SubjectsData.images,
                                          ),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            final fadeTransition =
                                                FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );

                                            return Container(
                                              color: Colors.black
                                                  .withOpacity(animation.value),
                                              child: AnimatedOpacity(
                                                  duration: Duration(
                                                      milliseconds: 300),
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
                          separatorBuilder: (context, index) => SizedBox(
                                height: Size * 10,
                                child: Divider(
                                  color: Colors.blue,
                                ),
                              )),
                    );
                  }
              }
            },
          ),
          Padding(
            padding: EdgeInsets.only(
                left: Size * 15, top: Size * 20, bottom: Size * 15),
            child: Text(
              "Projects",
              style: TextStyle(color: Colors.white, fontSize: Size * 25),
            ),
          ),
          ListView.builder(
            itemCount: filteredData.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final subjectsData = filteredData[index];
              return videoInfo(
                data: subjectsData,
              );
            },
          ),
          SizedBox(
            height: Size * 50,
          )
        ],
      ),
    );
  }
}

Stream<List<arduinoBoardsConvertor>> readarduinoBoards() =>
    FirebaseFirestore.instance
        .collection('arduino')
        .doc("arduinoBoards")
        .collection("Board")
        .orderBy("name", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => arduinoBoardsConvertor.fromJson(doc.data()))
            .toList());

class arduinoBoardsConvertor {
  String id;
  final String name, images, description, pinOut;

  arduinoBoardsConvertor({
    this.id = "",
    required this.name,
    required this.images,
    required this.description,
    required this.pinOut,
  });

  static arduinoBoardsConvertor fromJson(Map<String, dynamic> json) =>
      arduinoBoardsConvertor(
        id: json['id'],
        name: json["name"],
        images: json["images"],
        description: json["description"],
        pinOut: json["pinOut"],
      );
}

class arduinoBoard extends StatefulWidget {
  String id, heading, description, photoUrl, pinDiagram;

  arduinoBoard(
      {Key? key,
      required this.id,
      required this.heading,
      required this.description,
      required this.photoUrl,
      required this.pinDiagram})
      : super(key: key);

  @override
  State<arduinoBoard> createState() => _arduinoBoardState();
}

class _arduinoBoardState extends State<arduinoBoard> {
  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return backGroundImage(
        text: widget.heading.split(";").first,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageHeadingTagsDescription(
              heading: widget.heading.split(";").last,
              id: widget.id,
              description: "              ${widget.description}",
              photoUrl: widget.photoUrl,
              tags: [],
            ),
            Description(
              c0: 'arduino',
              d0: 'arduinoBoards',
              c1: 'Board',
              d1: widget.id,
              typeOfProject: 'arduinoBoards',
            ),
            if (widget.pinDiagram.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(
                    left: Size * 10, top: Size * 20, bottom: Size * 10),
                child: Text(
                  "PinOut",
                  style: TextStyle(
                      fontSize: Size * 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            scrollingImages(
                images: widget.pinDiagram.split(";"), id: widget.id,isZoom: true,),
            Center(
                child: Padding(
              padding: EdgeInsets.all(Size * 8.0),
              child: Text(
                "---${widget.heading}---",
                style: TextStyle(fontSize: Size * 10, color: Colors.white),
              ),
            )),
          ],
        ));
  }
}

class arduinoProject extends StatefulWidget {
  String id, heading, description, photoUrl, youtubeUrl, tableOfContent;
  int views, comments;
  List tags;
  List componentsAndSupplies, appsAndPlatforms;

  arduinoProject(
      {Key? key,
      required this.id,
      required this.tags,
      required this.comments,
      required this.heading,
      required this.views,
      required this.tableOfContent,
      required this.componentsAndSupplies,
      required this.appsAndPlatforms,
      required this.description,
      required this.photoUrl,
      required this.youtubeUrl})
      : super(key: key);

  @override
  State<arduinoProject> createState() => _arduinoProjectState();
}

class _arduinoProjectState extends State<arduinoProject> {
  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return backGroundImage(
        text: widget.heading.split(";").first,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(isUser())ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>arduinoProjectCreator(tableOfContent: widget.tableOfContent,appsAndPlatforms: widget.appsAndPlatforms,componentsAndSupplies: widget.componentsAndSupplies,heading: widget.heading,description: widget.description,tags: widget.tags.join(";"),youtubeLink: widget.id,id: widget.id,)));
            }, child: Text("EDIT")),
            imageHeadingTagsDescription(
              heading: widget.heading.split(";").last,
              id: widget.youtubeUrl,
              description: "          ${widget.description}",
              photoUrl: widget.photoUrl,
              tags: widget.tags,
            ),
            tableOfContent(
              list: widget.tableOfContent.split(";"),
            ),
            Padding(
              padding: EdgeInsets.all(Size * 8.0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(Size * 20),
                    border: Border.all(color: Colors.black)),
                child:
                    componentsAndSupplies(list: widget.componentsAndSupplies),
              ),
            ),
            if(widget.appsAndPlatforms.isNotEmpty)Padding(
              padding: EdgeInsets.all(Size * 8.0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(Size * 20)),
                child: appsAndPlatforms(list: widget.appsAndPlatforms),
              ),
            ),
            Description(
              c0: 'arduino',
              d0: "arduinoProjects",
              c1: "projects",
              d1: widget.id,
              typeOfProject: 'arduinoProjects',
            ),
            youtubeInfo(
              url: widget.youtubeUrl,
            ),
            commentsPage(
              c0: 'arduino',
              d0: "arduinoProjects",
              c1: "projects",
              d1: widget.id,
            )
          ],
        ));
  }
}

