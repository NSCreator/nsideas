// ignore_for_file: import_of_legacy_library_into_null_safe, non_constant_identifier_names, camel_case_types, must_be_immutable, use_key_in_widget_constructors, prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ns_ideas/authPage.dart';
import 'package:ns_ideas/homepage.dart';
import 'settings.dart';
import 'textField.dart';
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
    return SingleChildScrollView(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: Size*15,bottom: Size*15),
            child: Text(
              "Board",
              style: TextStyle(
                  fontSize: Size*30,
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
                      height: Size*130,
                      child: ListView.builder(
                        itemCount: Subjects!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          final SubjectsData = Subjects[index];
                          if (SubjectsData.photoUrl.split(";").first.length > 3) {
                            final Uri uri = Uri.parse(SubjectsData.photoUrl.split(";").first);
                            final String fileName = uri.pathSegments.last;
                            var name = fileName.split("/").last;
                            file = File("$folderPath/${SubjectsData.id}/$name");

                          }
                          return InkWell(
                            child: Row(
                              children: [
                                Padding(
                                  padding:  EdgeInsets.only(left: Size*15),
                                  child: SizedBox(
                                    height: Size*130,
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black38,
                                            borderRadius:
                                                 BorderRadius.all(
                                                    Radius.circular(Size*15)),
                                            image: DecorationImage(
                                              image: FileImage(file),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Padding(
                                              padding:  EdgeInsets.all(Size*5.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.6),
                                                  borderRadius: BorderRadius.circular(Size*15),
                                                ),
                                                child: Padding(
                                                  padding:  EdgeInsets.all(Size*8.0),
                                                  child: Text(
                                                    SubjectsData.name.split(";").last,
                                                    style:  TextStyle(
                                                      fontSize: Size*20.0,
                                                      color: Colors.tealAccent,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                                if (Subjects.length - index == 1)
                                  SizedBox(
                                    width: Size*80,
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
            height: Size*150,
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            backButton(size: Size,text: widget.heading,),
            Padding(
              padding:  EdgeInsets.all(Size*4.0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(Size*15),
                  border: Border.all(color: Colors.white24)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.photoUrl.isNotEmpty)
                      Padding(
                        padding:  EdgeInsets.all(Size*5.0),
                        child: InkWell(
                          child:  scrollingImages(images: widget.photoUrl.split(";"),id: widget.id),
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
                                              typeOfProject: 'raspberrypiBoard',
                                              url: widget
                                                  .photoUrl)));
                            } else {
                              showToastText(noImageUrl);
                            }
                          },
                        ),
                      ),
                    Padding(
                      padding:  EdgeInsets.all(Size*8.0),
                      child: Text(
                        widget.heading.split(";").last,
                        style: TextStyle(
                            fontSize: Size*20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),

                    Container(
                      height: Size*1,
                      width: double.infinity,
                      color: Colors.white24,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Padding(
                          padding: EdgeInsets.only(
                              left: Size*8,
                              right:Size* 8,
                              top: Size*10,
                              bottom: Size*3),
                          child: Text(
                            "Description",
                            style: TextStyle(
                                fontSize: Size*25,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          height: Size*3,
                          width: Size*60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(Size*15),
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(
                              left: Size*10,
                              right: Size*10,
                              bottom: Size*15,
                              top:Size* 13),
                          child: Text(
                            "              ${widget.description}",
                            style:  TextStyle(
                                fontSize: Size*16,
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
                padding:  EdgeInsets.all(Size*5.0),
                child: InkWell(
                  child:  scrollingImages(images: widget.pinDiagram.split(";"),  id: widget.id),
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
                                      typeOfProject: 'raspberrypiBoard',
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
    );
  }
}







