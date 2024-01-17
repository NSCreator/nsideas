// ignore_for_file: import_of_legacy_library_into_null_safe, non_constant_identifier_names, camel_case_types, must_be_immutable, use_key_in_widget_constructors, prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ns_ideas/authPage.dart';
import 'package:ns_ideas/homepage.dart';
import 'settings.dart';
import 'commonFunctions.dart';
import 'functions.dart';
import 'package:path_provider/path_provider.dart';

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
  String folderPath="";
  File file = File("");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPath();
  }
  getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    folderPath = directory.path;
  }
  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return backGroundImage(
      text: "Board",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: EdgeInsets.only(left: Size*15,bottom: Size*10),
            child: Text(
              "Board",
              style: TextStyle(
                  fontSize: Size*25,
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
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      itemCount: Subjects!.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final SubjectsData = Subjects[index];
                        if (SubjectsData.photoUrl.split(";").first.length > 3) {
                          final Uri uri = Uri.parse(SubjectsData.photoUrl.split(";").first);
                          final String fileName = uri.pathSegments.last;
                          var name = fileName.split("/").last;
                          file = File("$folderPath/${SubjectsData.id}/$name");

                        }
                        return InkWell(
                          child: Column(
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 7,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: ImageShowAndDownload(
                                    image: SubjectsData.photoUrl.split(";").first,
                                    id: SubjectsData.id,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding:  EdgeInsets.only(top:Size*2.0,bottom:Size*8.0),
                                  child: Text(
                                    SubjectsData.name.split(";").last,
                                    style:  TextStyle(
                                      fontSize: Size*20.0,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
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
                    );
                  }
              }
            },
          ),
          SizedBox(
            height: Size*50,
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
    double Size = size(context);
    return backGroundImage(
      text: widget.heading,
      child: Column(
        children: [
          imageHeadingTagsDescription(heading: widget.heading.split(";").last, id: widget.id, description: "              ${widget.description}", photoUrl: widget.photoUrl, tags: const []),

          Description(c0: 'raspberrypi',d0: "raspberrypiBoard",c1: "Boards",d1:widget.id, typeOfProject: 'raspberrypiBoard',),
          if (widget.pinDiagram.isNotEmpty)
            Padding(
              padding:  EdgeInsets.all(Size*5.0),
              child: scrollingImages(images: widget.pinDiagram.split(";"),  id: widget.id,isZoom: true,),
            ),
          Center(child: Text("--${widget.heading}--")),
        ],
      ),
    );
  }
}







