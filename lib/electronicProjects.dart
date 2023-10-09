// ignore_for_file: import_of_legacy_library_into_null_safe, camel_case_types, non_constant_identifier_names, must_be_immutable, equal_keys_in_map, library_private_types_in_public_api, use_build_context_synchronously, prefer_const_constructors

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ns_ideas/authPage.dart';
import 'package:ns_ideas/textField.dart';
import 'settings.dart';
import 'commonFunctions.dart';
import 'functions.dart';
import 'homepage.dart';

class electronicProjects extends StatefulWidget {
  const electronicProjects({Key? key}) : super(key: key);

  @override
  State<electronicProjects> createState() => _electronicProjectsState();
}

class _electronicProjectsState extends State<electronicProjects> {
  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<List<ProjectsConvertor>>(
            stream: readProjectsConvertor(false, "electronicProjects", "", ""),
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
                      scrollDirection: Axis.vertical,
                      controller: new ScrollController(keepScrollOffset: false),
                      itemCount: Subjects!.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      padding:  EdgeInsets.only(left: Size*5, right: Size*5),
                      itemBuilder: (BuildContext context, int index) {
                        final SubjectsData = Subjects[index];
                        return InkWell(
                          child: ContainerForProjectsShowing(
                            data: SubjectsData,
                             c0: 'electronicProjects', d0: '', c1: '',
                          ),
                          onTap: () async {
                            List<String> images = [];
                            images = SubjectsData.photoUrl.split(";");
                            if (!kIsWeb) {
                              await showDialog(
                                context: context,
                                builder: (context) => ImageDownloadScreen(
                                  images: images,
                                  id:SubjectsData.id,
                                ),
                              );
                            }

                            FirebaseFirestore.instance
                                .collection("electronicProjects")
                                .doc(SubjectsData.id)
                                .update({"views": SubjectsData.views + 1});
                            FirebaseFirestore.instance
                                .collection("electronicProjects")
                                .doc(SubjectsData
                                    .id) // Replace "documentId" with the ID of the document you want to retrieve
                                .get()
                                .then((DocumentSnapshot snapshot) async {
                              if (snapshot.exists) {
                                var data = snapshot.data();
                                if (data != null &&
                                    data is Map<String, dynamic>) {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(milliseconds: 300),
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          electronicProject(
                                        likes: data['likedBy'],
                                        tags: SubjectsData.tags.split(";"),
                                        youtubeUrl: SubjectsData.youtubeUrl,
                                        views: SubjectsData.views,
                                        requiredComponents:
                                            data['requiredComponents'],
                                        toolsRequired: data['toolsRequired'],
                                        id: data['id'],
                                        heading: SubjectsData.heading,
                                        description: data['description'],
                                        photoUrl: SubjectsData.photoUrl,

                                        tableOfContent: data['tableOfContent'],
                                            comments: data["comments"],
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
            height: Size*150,
          )
        ],
      ),
    );
  }
}


Stream<List<ProjectsConvertor>> readProjectsConvertor(bool mode, String c0, String d0, String c1) => mode
        ? FirebaseFirestore.instance
            .collection(c0)
            .doc(d0)
            .collection(c1)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => ProjectsConvertor.fromJson(doc.data()))
                .toList())
        : FirebaseFirestore.instance
            .collection(c0)
            .orderBy("views", descending: true)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => ProjectsConvertor.fromJson(doc.data()))
                .toList());

class ProjectsConvertor {
  String id;
  final int views, comments;
  final String heading, photoUrl, tags, youtubeUrl,tableOfContent;
  List<String> likedBy;

  ProjectsConvertor({
    this.id = "",
    required this.heading,
    this.views = 0,
    required this.photoUrl,
    required this.youtubeUrl,
    required this.tableOfContent,
    required this.tags,
     this.comments=0,
    List<String>? likedBy,
  }) : likedBy = likedBy ?? [];

  static ProjectsConvertor fromJson(
          Map<String, dynamic> json) =>
      ProjectsConvertor(
          views: json["views"],
          id: json['id'],
          youtubeUrl: json["youtubeLink"],
          comments: json["comments"],
          likedBy:
              json["likedBy"] != null ? List<String>.from(json["likedBy"]) : [],
          heading: json["heading"],
          tags: json["tags"],
          photoUrl: json["images"],
          tableOfContent: json["tableOfContent"]);
}



class electronicProject extends StatefulWidget {
  String id,
      heading,
      tableOfContent,
      description,
      photoUrl,
      youtubeUrl;
  List tags, requiredComponents, toolsRequired, likes;
  int views,comments;

  electronicProject(
      {Key? key,
      required this.tableOfContent,
      required this.likes,
      required this.id,
      required this.views,
      required this.comments,
      required this.heading,
      required this.requiredComponents,
      required this.description,
      required this.photoUrl,
      required this.toolsRequired,
      required this.tags,
      required this.youtubeUrl})
      : super(key: key);

  @override
  State<electronicProject> createState() => _electronicProjectState();
}

class _electronicProjectState extends State<electronicProject> {

  late bool like = false;
  late int likeCount = 0;
  List comments = [];
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return backGroundImage(child: SingleChildScrollView(child: Column(
      children: [
        backButton(size: Size,text: widget.heading.split(";").first,),
        SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.all(Size*4.0),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(Size*15),
                  ),
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
                                            typeOfProject:
                                            'electronicProjects',

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
                              fontSize:Size* 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        children: widget.tags
                            .map(
                              (text) => Padding(
                            padding:  EdgeInsets.only(left:Size* 5, bottom:Size* 5),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Size*10),
                                  border: Border.all(color: Colors.white24)),
                              padding: EdgeInsets.symmetric(
                                  vertical: Size*3, horizontal: Size*8),
                              child: Text(
                                text,
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                        )
                            .toList(),
                      ),
                      Container(
                        height:Size* 1,
                        width: double.infinity,
                        color: Colors.white24,
                      ),
                      Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                           Padding(
                            padding: EdgeInsets.only(
                                left: Size*8,
                                right:Size* 8,
                                top: Size*10,
                                bottom: Size*3),
                            child: Text(
                              "About",
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
                              borderRadius:
                              BorderRadius.circular(Size*15),
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.only(
                                left: Size*10,
                                right: Size*10,
                                bottom: Size*15,
                                top: Size*13),
                            child: Text(
                              "              ${widget.description}",
                              style:  TextStyle(
                                  fontSize:Size* 16,
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
                padding:  EdgeInsets.all(Size*6.0),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(Size*20),
                  ),
                  child: Column(
                    children: [
                      tableOfContent(
                          list: widget.tableOfContent.split(";")),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.all(Size*4.0),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(Size*15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.photoUrl.split(";").last.isNotEmpty)
                         Padding(
                          padding: EdgeInsets.all(Size*8.0),
                          child: Text(
                            "Circuit Diagram : ",
                            style: TextStyle(
                                fontSize: Size*23,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      if (widget.photoUrl.split(";").last.isNotEmpty)
                        Padding(
                          padding:  EdgeInsets.all(Size*8.0),
                          child: InkWell(
                            child: scrollingImages(
                              images: widget.photoUrl.split(";").last
                                  .split(";"),
                              id: widget.id,
                            ),
                            onTap: () {
                              showToastText(longPressToViewImage);
                            },
                            onLongPress: () {
                              if (widget.photoUrl.split(";").last.length >
                                  3) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => zoom(
                                            typeOfProject:
                                            'electronicProjects',

                                            url: widget.photoUrl.split(";").last)));
                              } else {
                                showToastText(noImageUrl);
                              }
                            },
                          ),
                        ),
                      Required(
                        heading: "Required Components",
                        list: widget.requiredComponents,
                      ),
                      Padding(
                        padding:  EdgeInsets.all(Size*8.0),
                        child: Container(
                          height:Size* 1,
                          width: double.infinity,
                          color: Colors.white24,
                        ),
                      ),
                      Required(
                        heading: "Tools Required",
                        list: widget.toolsRequired,
                      ),
                    ],
                  ),
                ),
              ),
              Description(
                c0: 'electronicProjects',
                d0: widget.id,
                c1: "",
                d1: "",
                typeOfProject: 'electronicProjects',
              ),
              Padding(
                padding:  EdgeInsets.all(Size*4.0),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(Size*15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(
                            left: Size*8, bottom: Size*5),
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
                        padding:  EdgeInsets.only(
                            top: Size*13, left: Size*10, bottom: Size*15),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(
                                        42, 51, 59, 1),
                                    borderRadius:
                                    BorderRadius.circular(
                                        Size*20)),
                                child: Padding(
                                  padding:
                                   EdgeInsets.all(Size*8.0),
                                  child: Text(
                                    "Play",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Size*22,
                                        fontWeight:
                                        FontWeight.w600),
                                  ),
                                ),
                              ),
                              onTap: () {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                  false, // user must tap button!
                                  builder:
                                      (BuildContext context) {
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
                                    color: Color.fromRGBO(
                                        42, 51, 59, 1),
                                    borderRadius:
                                    BorderRadius.circular(
                                        Size*20)),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                       EdgeInsets.all(
                                          Size*8.0),
                                      child: Text(
                                        "View On",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: Size*22,
                                            fontWeight:
                                            FontWeight.w600),
                                      ),
                                    ),
                                    Container(
                                        height: Size*40,
                                        width: Size*100,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(Size*8),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    "https://ghiencongnghe.info/wp-content/uploads/2021/02/bia-youtube-la-gi.gif"))))
                                  ],
                                ),
                              ),
                              onTap: () {
                                ExternalLaunchUrl(
                                    widget.youtubeUrl);
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
                c0: 'electronicProjects',
                d0: widget.id,
                c1: "",
                d1: "",)
            ],
          ),
        )

      ],
    ),));
  }
}

updateLike(String documentId, String user) async {
  try {
    await FirebaseFirestore.instance
        .collection("electronicProjects")
        .doc(documentId)
        .collection("likes")
        .doc(user)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        FirebaseFirestore.instance
            .collection("electronicProjects")
            .doc(documentId)
            .collection("likes")
            .doc(user)
            .delete();
        showToastText("Unliked");
      } else {
        FirebaseFirestore.instance
            .collection("electronicProjects")
            .doc(documentId)
            .collection("likes")
            .doc(user)
            .set({"id": user});
        showToastText("Liked");
      }
    });
  } catch (e) {
    print(e);
  }
}

Stream<List<electronicProjectDownloadConvertor>> readelectronicProjectDownload(
        String id) =>
    FirebaseFirestore.instance
        .collection("electronicProjects")
        .doc(id)
        .collection("downloads")
        .orderBy("name", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                electronicProjectDownloadConvertor.fromJson(doc.data()))
            .toList());

Future createelectronicProjectDownload(
    {required String id,
    required String heading,
    required String description,
    required String link}) async {
  final docflash = FirebaseFirestore.instance
      .collection("electronicProjects")
      .doc(id)
      .collection("downloads")
      .doc();
  final flash = electronicProjectDownloadConvertor(
      id: docflash.id, name: heading, link: link, description: description);
  final json = flash.toJson();
  await docflash.set(json);
}

class electronicProjectDownloadConvertor {
  String id;
  final String name, link, description;

  electronicProjectDownloadConvertor(
      {this.id = "",
      required this.name,
      required this.link,
      required this.description});

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "link": link, "description": description};

  static electronicProjectDownloadConvertor fromJson(
          Map<String, dynamic> json) =>
      electronicProjectDownloadConvertor(
          id: json['id'],
          name: json["name"],
          link: json["link"],
          description: json["description"]);
}

