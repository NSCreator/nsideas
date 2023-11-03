// ignore_for_file: camel_case_types, must_be_immutable, non_constant_identifier_names, import_of_legacy_library_into_null_safe, prefer_const_constructors, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures, use_build_context_synchronously, avoid_print


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ns_ideas/authPage.dart';
import 'package:ns_ideas/textField.dart';
import 'settings.dart';
import 'commonFunctions.dart';
import 'electronicProjects.dart';
import 'functions.dart';
import 'homepage.dart';
import 'package:path_provider/path_provider.dart';

class arduinoAndProjects extends StatefulWidget {
  const arduinoAndProjects({super.key});

  @override
  State<arduinoAndProjects> createState() => _arduinoAndProjectsState();
}

class _arduinoAndProjectsState extends State<arduinoAndProjects> {
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:  EdgeInsets.only(left: Size*15,bottom: Size*15),
            child: Text(
              "Boards",
              style: TextStyle(color: Colors.white, fontSize: Size * 30),
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
                      height: Size * 130,
                      child: ListView.separated(
                          itemCount: Subjects!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            final SubjectsData = Subjects[index];
                            if (SubjectsData.images.split(";").first.length > 3) {
                              final Uri uri = Uri.parse(SubjectsData.images.split(";").first);
                              final String fileName = uri.pathSegments.last;
                              var name = fileName.split("/").last;
                              file = File("$folderPath/${SubjectsData.id}/$name");

                            }
                            return InkWell(
                              child: Row(
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(left: Size * 15),
                                    child: SizedBox(
                                      height: Size * 130,
                                      child: AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black38,
                                              borderRadius:
                                                   BorderRadius.all(
                                                      Radius.circular(Size * 15)),
                                              image: DecorationImage(
                                                image: FileImage(file),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Padding(
                                                padding:
                                                     EdgeInsets.all(Size * 5.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Size * 15),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                         EdgeInsets.all(
                                                            Size * 8.0),
                                                    child: Text(
                                                      SubjectsData.name
                                                          .split(";")
                                                          .last,
                                                      style:  TextStyle(
                                                        fontSize: Size * 20.0,
                                                        color:
                                                            Colors.tealAccent,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                          separatorBuilder: (context, index) =>  SizedBox(
                                height:Size *  10,
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
            padding:  EdgeInsets.only(left: Size*15,top: Size*30,bottom: Size*15),
            child: Text(
              "Projects",
              style: TextStyle(color: Colors.white, fontSize: Size * 30),
            ),
          ),
          StreamBuilder<List<ProjectsConvertor>>(
            stream: readProjectsConvertor( "arduino", "arduinoProjectsInfo", "arduinoProjectsInfo"),
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
                      physics: const BouncingScrollPhysics(),
                      itemCount: Subjects!.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final SubjectsData = Subjects[index];
                        return Container();
                        // return InkWell(
                        //   child: ContainerForProjectsShowing(
                        //       data: SubjectsData,
                        //       c0: 'arduino',
                        //       d0: "arduinoProjects",
                        //       c1: "projects"),
                        //   // onTap: () {
                        //   //   FirebaseFirestore.instance
                        //   //       .collection("arduino")
                        //   //       .doc("arduinoProjects")
                        //   //       .collection("projects")
                        //   //       .doc(SubjectsData
                        //   //       .id) // Replace "documentId" with the ID of the document you want to retrieve
                        //   //       .get()
                        //   //       .then((DocumentSnapshot
                        //   //   snapshot) async {
                        //   //     if (snapshot.exists) {
                        //   //       var data = snapshot.data();
                        //   //       if (data != null &&
                        //   //           data is Map<String,
                        //   //               dynamic>) {
                        //   //         FirebaseFirestore.instance
                        //   //             .collection("arduino")
                        //   //             .doc("arduinoProjects")
                        //   //             .collection("projects")
                        //   //             .doc(SubjectsData.id)
                        //   //             .update({
                        //   //           "views":
                        //   //           SubjectsData.views + 1
                        //   //         });
                        //   //         showToastText("+1 view");
                        //   //         Navigator.push(
                        //   //             context,
                        //   //             MaterialPageRoute(
                        //   //                 builder: (context) =>
                        //   //                     arduinoProject(
                        //   //                       appsAndPlatforms:data["appsAndPlatforms"],
                        //   //
                        //   //                       youtubeUrl: SubjectsData.youtubeUrl,
                        //   //                       id: data['id'],
                        //   //                       heading: SubjectsData.heading,
                        //   //                       description: data['description'],
                        //   //                       photoUrl: SubjectsData.images.split(";").first,
                        //   //                       tags: SubjectsData.tags.toString().split(";"),
                        //   //                       tableOfContent: data['tableOfContent'],
                        //   //                       views: 0, componentsAndSupplies: data['componentsAndSupplies'],
                        //   //                       comments: data["comments"],
                        //   //                     )));
                        //   //       }
                        //   //     } else {
                        //   //       print(
                        //   //           "Document does not exist.");
                        //   //     }
                        //   //   }).catchError((error) {
                        //   //     print(
                        //   //         "An error occurred while retrieving data: $error");
                        //   //   });
                        //   // },
                        // );
                      },
                    );
                  }
              }
            },
          ),
          SizedBox(
            height: Size * 150,
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
  final String name, images,description,pinOut;

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

Stream<List<Map<String, dynamic>>> getBoardStream() {
  return FirebaseFirestore.instance
      .collection('arduino')
      .doc('tags')
      .collection('tags')
      .snapshots()
      .map((querySnapshot) =>
          querySnapshot.docs.map((doc) => doc.data()).toList());
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
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          backButton(
            text: widget.heading.split(";").first,
          ),
          Padding(
            padding:  EdgeInsets.all(Size*8.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                border: Border.all(color: Colors.white12),
                borderRadius: BorderRadius.circular(Size*15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.photoUrl.isNotEmpty)
                    Padding(
                      padding:  EdgeInsets.symmetric(
                          vertical: Size*8, horizontal: Size*5),
                      child: InkWell(
                        child: scrollingImages(
                            images: widget.photoUrl.split(";"),
                            id: widget.id),
                        onTap: () {
                          showToastText(longPressToViewImage);
                        },
                        onLongPress: () {
                          if (widget.photoUrl.length > 3) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => zoom(
                                        typeOfProject: 'arduinoBoards',
                                        url: widget.photoUrl)));
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
                          fontSize: Size*25,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                  Container(
                    height:Size* 0.5,
                    width: double.infinity,
                    color: Colors.white24,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Padding(
                        padding: EdgeInsets.symmetric(vertical: Size*5),
                        child: Text(
                          "Description",
                          style: TextStyle(
                              fontSize: Size*25,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        height: Size*2,
                        width: Size*50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(Size*15),
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(
                            vertical: Size*8, horizontal: Size*10),
                        child: StyledTextWidget(
                          text: "              ${widget.description}",
                          fontSize: Size*16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
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
              padding: EdgeInsets.only(left: Size*10, top: Size*20, bottom: Size*10),
              child: Text(
                "PinOut",
                style: TextStyle(
                    fontSize: Size*25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
          scrollingImages(
              images: widget.pinDiagram.split(";"),
              id: widget.id),
          Center(
              child: Padding(
            padding:  EdgeInsets.all(Size*8.0),
            child: Text(
              "---${widget.heading}---",
              style:  TextStyle(fontSize: Size*10, color: Colors.white),
            ),
          )),
        ],
      ),
    ));
  }
}

class arduinoProject extends StatefulWidget {
  String id,
      heading,
      description,
      photoUrl,
      youtubeUrl,
      tableOfContent;
  int views,comments;
  List tags;
  List componentsAndSupplies,appsAndPlatforms;

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
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return backGroundImage(
        child: SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          backButton(
            text: widget.heading.split(";").first,
          ),
          Padding(
            padding:  EdgeInsets.all(Size*5.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(Size*15),
                  border: Border.all(color: Colors.white24)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.photoUrl.isNotEmpty)
                    Padding(
                      padding:  EdgeInsets.all(Size*5.0),
                      child: InkWell(
                        child: scrollingImages(
                          images: widget.photoUrl.split(";"),
                          id: widget.id,
                        ),
                        onTap: () {
                          showToastText(longPressToViewImage);
                        },
                        onLongPress: () {
                          if (widget.photoUrl.length > 3) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => zoom(
                                        typeOfProject: 'arduinoProjects',

                                        url: widget.photoUrl)));
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
                  Wrap(
                    direction: Axis.horizontal,
                    children: widget.tags
                        .map(
                          (text) => Padding(
                            padding:  EdgeInsets.only(left: Size*5, bottom: Size*5),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Size*10),
                                  border: Border.all(color: Colors.white24)),
                              padding: EdgeInsets.symmetric(
                                  vertical: Size*3, horizontal:Size* 8),
                              child: Text(
                                text,
                                style: TextStyle(color: Colors.white70,fontSize: Size*15),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  Container(
                    height:Size* 0.5,
                    width: double.infinity,
                    color: Colors.white24,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Padding(
                        padding: EdgeInsets.only(
                            left:Size* 8, right: Size*8, top:Size* 10, bottom: Size*3),
                        child: Text(
                          "Description",
                          style: TextStyle(
                              fontSize: Size*25,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Container(
                        height: Size*2,
                        width: Size*50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(Size*15),
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(
                            left:Size* 10, right: Size*10, bottom: Size*15, top:Size* 13),
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
          Padding(
            padding:  EdgeInsets.all(Size*8.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(Size*15),
                  border: Border.all(color: Colors.black)),
              child: tableOfContent(list: widget.tableOfContent.split(";")),
            ),
          ),
          Padding(
            padding:  EdgeInsets.all(Size*8.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(Size*15),
                  border: Border.all(color: Colors.black)),
              child: componentsAndSupplies
                (list: widget.componentsAndSupplies),
            ),
          ),  Padding(
            padding:  EdgeInsets.all(Size*8.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(Size*15),
                  border: Border.all(color: Colors.black)),
              child: appsAndPlatforms
                (list: widget.appsAndPlatforms),
            ),
          ),
          Description(
            c0: 'arduino',
            d0: "arduinoProjects",
            c1: "projects",
            d1: widget.id,
            typeOfProject: 'arduinoProjects',
          ),
          Padding(
            padding:  EdgeInsets.all(Size*4.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(Size*15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(left: Size*8, bottom:Size* 5, top: Size*10),
                    child: Row(
                      children: [
                        Text(
                          "Making Video",
                          style: TextStyle(
                              fontSize: Size*23,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:Size* 13, left:Size* 10, bottom:Size* 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(Size*15)),
                            child: Padding(
                              padding:  EdgeInsets.all(Size*8.0),
                              child: Text(
                                "Play",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Size*22,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          onTap: () {
                            showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return youtube(
                                  url: widget.youtubeUrl,
                                );
                              },
                            );
                          },
                        ),
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(Size*15)),
                            child: Row(
                              children: [
                                Padding(
                                  padding:  EdgeInsets.all(Size*8.0),
                                  child: Text(
                                    "View On",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Size*22,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Container(
                                    height: Size*40,
                                    width: Size*100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                "https://ghiencongnghe.info/wp-content/uploads/2021/02/bia-youtube-la-gi.gif"))))
                              ],
                            ),
                          ),
                          onTap: () {
                            ExternalLaunchUrl(widget.youtubeUrl);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Size*8.0),
            child: Text(
              "${widget.comments} Comments",
              style: TextStyle(
                  fontSize: Size*23,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          commentsPage(
            comments: widget.comments,
              c0: 'arduino',
              d0: "arduinoProjects",
              c1: "projects",
              d1: widget.id,)
        ],
      ),
    ));
  }
}

Stream<List<arduinoProjectsConvertor>> readarduinoProjects() =>
    FirebaseFirestore.instance
        .collection('arduino')
        .doc("arduinoProjects")
        .collection("projects")
        .orderBy("heading", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => arduinoProjectsConvertor.fromJson(doc.data()))
            .toList());

Future createarduinoProjects(
    {required String heading,
    required String description,
    required String videoUrl,
    required String creator,
    required String photoUrl}) async {
  final docflash = FirebaseFirestore.instance
      .collection('arduino')
      .doc("arduinoProjects")
      .collection("projects")
      .doc();
  final flash = arduinoProjectsConvertor(
      id: docflash.id,
      heading: heading,
      description: description,
      photoUrl: photoUrl,
      videoUrl: videoUrl);
  final json = flash.toJson();
  await docflash.set(json);
}

class arduinoProjectsConvertor {
  String id;
  final String heading, description, photoUrl, videoUrl;

  arduinoProjectsConvertor(
      {this.id = "",
      required this.videoUrl,
      required this.heading,
      required this.description,
      required this.photoUrl});

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "description": description,
        "photoUrl": photoUrl,
        "videoUrl": videoUrl
      };

  static arduinoProjectsConvertor fromJson(Map<String, dynamic> json) =>
      arduinoProjectsConvertor(
          id: json['id'],
          videoUrl: json["videoUrl"],
          heading: json["heading"],
          description: json["description"],
          photoUrl: json["photoUrl"]);
}

