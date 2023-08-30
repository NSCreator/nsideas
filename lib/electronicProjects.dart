// ignore_for_file: import_of_legacy_library_into_null_safe, camel_case_types, non_constant_identifier_names, must_be_immutable, equal_keys_in_map, library_private_types_in_public_api, use_build_context_synchronously, prefer_const_constructors

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marquee/marquee.dart';
import 'settings.dart';
import 'commonFunctions.dart';
import 'functions.dart';
import 'homepage.dart';
import 'main.dart';

class electronicProjects extends StatefulWidget {
  const electronicProjects({Key? key}) : super(key: key);

  @override
  State<electronicProjects> createState() => _electronicProjectsState();
}

class _electronicProjectsState extends State<electronicProjects> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
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
                      padding: const EdgeInsets.only(left: 5, right: 5),
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
                            images.addAll(SubjectsData.diagram.split(";"));

                            if (!kIsWeb) {
                              await showDialog(
                                context: context,
                                builder: (context) => ImageDownloadScreen(
                                  typeOfProject: "electronicProjects",
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
                                        circuitDiagram: SubjectsData.diagram,
                                        id: data['id'],
                                        heading: SubjectsData.heading,
                                        description: data['description'],
                                        photoUrl: SubjectsData.photoUrl,
                                        creator: data['creator'],
                                        source: data['source'],
                                        tableOfContent: data['tableOfContent'],
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
            height: 150,
          )
        ],
      ),
    );
  }
}


Stream<List<ProjectsConvertor>> readProjectsConvertor(
        bool mode, String c0, String d0, String c1) =>
    mode
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
  final String heading, photoUrl, diagram, tags, youtubeUrl;
  List<String> likedBy;

  ProjectsConvertor({
    this.id = "",
    required this.heading,
    this.diagram = "",
    this.views = 0,
    required this.photoUrl,
    required this.youtubeUrl,
    required this.tags,
    required this.comments,
    List<String>? likedBy,
  }) : likedBy = likedBy ?? [];

  static ProjectsConvertor fromJson(
          Map<String, dynamic> json) =>
      ProjectsConvertor(
          views: json["views"],
          id: json['id'],
          youtubeUrl: json["videoUrl"],
          comments: json["likes"] != null ? json["likes"] : 0,
          likedBy:
              json["likedBy"] != null ? List<String>.from(json["likedBy"]) : [],
          heading: json["heading"],
          diagram: json["circuitDiagram"] != null ? json["circuitDiagram"] : "",
          tags: json["tags"],
          photoUrl: json["photoUrl"]);
}



class electronicProject extends StatefulWidget {
  String id,
      heading,
      tableOfContent,
      description,
      photoUrl,
      circuitDiagram,
      youtubeUrl,
      creator,
      source;
  List tags, requiredComponents, toolsRequired, likes;
  int views;

  electronicProject(
      {Key? key,
      required this.creator,
      required this.tableOfContent,
      required this.likes,
      required this.source,
      required this.id,
      required this.views,
      required this.heading,
      required this.requiredComponents,
      required this.description,
      required this.photoUrl,
      required this.circuitDiagram,
      required this.toolsRequired,
      required this.tags,
      required this.youtubeUrl})
      : super(key: key);

  @override
  State<electronicProject> createState() => _electronicProjectState();
}

class _electronicProjectState extends State<electronicProject> {
  final TextEditingController _comment = TextEditingController();
  late bool like = false;
  late int likeCount = 0;
  List comments = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getComments();
  }

  addComment(String c0, String id, bool isAdd, String data) {
    if (isAdd) {
      data = "${"NS" ":" + userId()};$data";
    }
    FirebaseFirestore.instance.collection(c0).doc(id).update({
      "comments": isAdd
          ? FieldValue.arrayUnion([data])
          : FieldValue.arrayRemove([data]),
    });
  }

  void getComments() {
    FirebaseFirestore.instance
        .collection("electronicProjects")
        .doc(widget.id)
        .get()
        .then((DocumentSnapshot snapshot) async {
      if (snapshot.exists) {
        var data = snapshot.data();
        if (data != null && data is Map<String, dynamic>) {
          comments = data['comments'];
        }
      } else {
        print("Document does not exist.");
      }
    }).catchError((error) {
      print("An error occurred while retrieving data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
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
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Scaffold(
                                  backgroundColor: Colors.transparent,
                                  body: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 40, horizontal: 20),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 5, sigmaY: 5),
                                        child: Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              border: Border.all(
                                                  color: Colors.white24),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Comments",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 30),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 20),
                                                        child: TextFormField(
                                                          controller: _comment,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          maxLines: null,
                                                          // Allows the field to expand as needed
                                                          decoration:
                                                              const InputDecoration(
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .white60),
                                                            border: InputBorder
                                                                .none,
                                                            hintText:
                                                                'Comment Here',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Icon(
                                                          Icons.send,
                                                          color: Colors
                                                              .lightBlueAccent,
                                                        ),
                                                      ),
                                                      onTap: () async {
                                                        await addComment(
                                                            "electronicProjects",
                                                            widget.id,
                                                            true,
                                                            _comment.text);
                                                        Navigator.pop(context);
                                                        getComments();
                                                        _comment.clear();
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  itemCount: comments.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    String data =
                                                        comments[index];
                                                    String user =
                                                        data.split(";").first;
                                                    String comment =
                                                        data.split(";").last;
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white54)),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(3.0),
                                                              child: Text(
                                                                user
                                                                    .split(":")
                                                                    .first,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "@${user.split(":").last}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white54,
                                                                    fontSize:
                                                                        13),
                                                              ),
                                                              Text(
                                                                comment,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          InkWell(
                                                            child: Icon(
                                                              Icons.delete,
                                                              color: Colors
                                                                  .redAccent,
                                                              size: 30,
                                                            ),
                                                            onTap: () {
                                                              addComment(
                                                                  "electronicProjects",
                                                                  widget.id,
                                                                  false,
                                                                  data);
                                                              Navigator.pop(
                                                                  context);
                                                              getComments();
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
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
                  if (isMobile(context))
                    Scrollbar(
                      controller: _scrollController,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                          child: scrollingImages(
                                            images: widget.photoUrl.split(";"),
                                            typeOfProject: 'electronicProjects',
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
                                                          id: widget.id,
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
                                    Wrap(
                                      direction: Axis.horizontal,
                                      children: widget.tags
                                          .map(
                                            (text) => Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: Colors.white24)),
                                                padding: EdgeInsets.all(5.0),
                                                child: Text(text),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    Container(
                                      height: 1,
                                      width: double.infinity,
                                      color: Colors.white24,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                            borderRadius:
                                                BorderRadius.circular(15),
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
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(20),
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
                                    if (widget.circuitDiagram.isNotEmpty)
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Circuit Diagram : ",
                                          style: TextStyle(
                                              fontSize: 23,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                    if (widget.circuitDiagram.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          child: scrollingImages(
                                            images: widget.circuitDiagram
                                                .split(";"),
                                            typeOfProject: 'electronicProjects',
                                            id: widget.id,
                                          ),
                                          onTap: () {
                                            showToastText(longPressToViewImage);
                                          },
                                          onLongPress: () {
                                            if (widget.circuitDiagram.length >
                                                3) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => zoom(
                                                          typeOfProject:
                                                              'electronicProjects',
                                                          id: widget.id,
                                                          url: widget
                                                              .circuitDiagram)));
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
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 1,
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
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, bottom: 5),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Making Video",
                                            style: TextStyle(
                                                fontSize: 23,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 13, left: 10, bottom: 15),
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
                                                          20)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Play",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 22,
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
                                                          20)),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "View On",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  Container(
                                                      height: 40,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
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
                                    Divider(
                                      color: Colors.white54,
                                    ),
                                    StreamBuilder<
                                        List<
                                            electronicProjectDownloadConvertor>>(
                                      stream: readelectronicProjectDownload(
                                          widget.id),
                                      builder: (context, snapshot) {
                                        final Subjects = snapshot.data;
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.waiting:
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                              strokeWidth: 0.3,
                                              color: Colors.cyan,
                                            ));
                                          default:
                                            if (snapshot.hasError) {
                                              return const Text(
                                                  "Error with server");
                                            } else {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: Row(
                                                      children: [
                                                        const Text(
                                                          "Downloads",
                                                          style: TextStyle(
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15,
                                                            right: 5,
                                                            bottom: 13),
                                                    child: ListView.builder(
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount:
                                                          Subjects!.length,
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        final SubjectsData =
                                                            Subjects[index];
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 8,
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  InkWell(
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                        border: Border.all(
                                                                            color: const Color.fromRGBO(
                                                                                174,
                                                                                228,
                                                                                242,
                                                                                0.1)),
                                                                        gradient: const LinearGradient(
                                                                            begin:
                                                                                Alignment.topLeft,
                                                                            end: Alignment.topRight,
                                                                            colors: [
                                                                              Colors.orange,
                                                                              Colors.red
                                                                            ]),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(5.0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              children: const [
                                                                                Icon(
                                                                                  Icons.download_outlined,
                                                                                  color: Colors.white,
                                                                                  size: 25,
                                                                                ),
                                                                                Text(
                                                                                  "Download",
                                                                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    onTap: () {
                                                                      if (SubjectsData
                                                                          .link
                                                                          .isNotEmpty) {
                                                                        ExternalLaunchUrl(
                                                                            SubjectsData.link);
                                                                      } else {
                                                                        showToastText(
                                                                            "No Link Available");
                                                                      }
                                                                    },
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          SubjectsData
                                                                              .name,
                                                                          style: const TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.white),
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                        const Divider(
                                                                          color:
                                                                              Colors.white60,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        3.0),
                                                                child: Text(
                                                                  "                ${SubjectsData.description}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .white60),
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(15.0),
                                    topLeft: Radius.circular(27.0)),
                                color: Colors.black.withOpacity(0.3),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(25.0)),
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              image: DecorationImage(
                                                  image: NetworkImage(widget
                                                      .creator
                                                      .split(";")
                                                      .last),
                                                  fit: BoxFit.fill,
                                                  filterQuality:
                                                      FilterQuality.low)),
                                          height: 50,
                                          width: 50,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 3),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.creator.split(";").first,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    const Icon(
                                                      Icons.circle,
                                                      size: 5,
                                                      color: Colors.redAccent,
                                                    ),
                                                    Text(
                                                      " ${widget.views}",
                                                      style: const TextStyle(
                                                          fontSize: 11,
                                                          color: Colors
                                                              .lightBlueAccent),
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 8, left: 3),
                                                      child: Text(
                                                        "views",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 13),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 15, right: 5),
                                                  child: Icon(
                                                    Icons.circle,
                                                    size: 8,
                                                  ),
                                                ),
                                                InkWell(
                                                  child: Text(
                                                    widget.source
                                                        .split(";")
                                                        .first,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                  onTap: () {
                                                    ExternalLaunchUrl(widget
                                                        .source
                                                        .split(";")
                                                        .last);
                                                  },
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: Width(context) < 1100 ? 3 : 5,
                          child: Scrollbar(
                            controller: _scrollController,
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: Width(context) * 0.05,
                                    right: Width(context) * 0.015),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Column(
                                          children: [
                                            if (widget.photoUrl.isNotEmpty)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: InkWell(
                                                  child: scrollingImages(
                                                    images: widget.photoUrl
                                                        .split(";"),
                                                    typeOfProject:
                                                        'electronicProjects',
                                                    id: widget.id,
                                                  ),
                                                  onTap: () {
                                                    showToastText(
                                                        longPressToViewImage);
                                                  },
                                                  onLongPress: () {
                                                    if (widget.photoUrl.length >
                                                        3) {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => zoom(
                                                                  typeOfProject:
                                                                      'electronicProjects',
                                                                  id: widget.id,
                                                                  url: widget
                                                                      .photoUrl)));
                                                    } else {
                                                      showToastText(noImageUrl);
                                                    }
                                                  },
                                                ),
                                              ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                widget.heading,
                                                style: TextStyle(
                                                    fontSize: Width(context) *
                                                        Height(context) *
                                                        0.00005,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Container(
                                              height: 1,
                                              width: double.infinity,
                                              color: Colors.white24,
                                            ),
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
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Container(
                                              height: 3,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15),
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
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          children: [
                                            tableOfContent(
                                              list: widget.tableOfContent
                                                  .split(";"),
                                              isView: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Column(
                                          children: [
                                            if (widget
                                                .circuitDiagram.isNotEmpty)
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Circuit Diagram : ",
                                                  style: TextStyle(
                                                      fontSize: 23,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            if (widget
                                                .circuitDiagram.isNotEmpty)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  child: scrollingImages(
                                                    images: widget
                                                        .circuitDiagram
                                                        .split(";"),
                                                    typeOfProject:
                                                        'electronicProjects',
                                                    id: widget.id,
                                                  ),
                                                  onTap: () {
                                                    showToastText(
                                                        longPressToViewImage);
                                                  },
                                                  onLongPress: () {
                                                    if (widget.circuitDiagram
                                                            .length >
                                                        3) {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => zoom(
                                                                  typeOfProject:
                                                                      'electronicProjects',
                                                                  id: widget.id,
                                                                  url: widget
                                                                      .circuitDiagram)));
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
                                            Container(
                                              height: 1,
                                              width: double.infinity,
                                              color: Colors.white24,
                                            ),
                                            Required(
                                              heading: "Tools Required",
                                              list: widget.toolsRequired,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // if (fullUserId() == ownerId)
                                    //   Padding(
                                    //     padding: const EdgeInsets.all(3.0),
                                    //     child: Container(
                                    //       decoration: BoxDecoration(
                                    //         borderRadius:
                                    //             const BorderRadius.all(Radius.circular(15.0)),
                                    //         color: Colors.black.withOpacity(0.3),
                                    //       ),
                                    //       child: Column(
                                    //         mainAxisAlignment: MainAxisAlignment.start,
                                    //         crossAxisAlignment: CrossAxisAlignment.start,
                                    //         children: [
                                    //           const Padding(
                                    //             padding: EdgeInsets.only(left: 10, top: 5),
                                    //             child: Text(
                                    //               "Add to ...",
                                    //               style: TextStyle(
                                    //                   fontSize: 15, color: Colors.white),
                                    //             ),
                                    //           ),
                                    //           Row(
                                    //             mainAxisAlignment: MainAxisAlignment.center,
                                    //             crossAxisAlignment: CrossAxisAlignment.center,
                                    //             children: [
                                    //               Flexible(
                                    //                 flex: 1,
                                    //                 child: InkWell(
                                    //                   child: Padding(
                                    //                     padding: const EdgeInsets.all(5.0),
                                    //                     child: Container(
                                    //                       decoration: const BoxDecoration(
                                    //                         gradient: LinearGradient(
                                    //                             begin: Alignment.topLeft,
                                    //                             end: Alignment.topRight,
                                    //                             colors: [
                                    //                               Colors.orange,
                                    //                               Colors.red
                                    //                             ]),
                                    //                         borderRadius: BorderRadius.all(
                                    //                             Radius.circular(8.0)),
                                    //                         color: Colors.blue,
                                    //                       ),
                                    //                       child: const Padding(
                                    //                         padding: EdgeInsets.all(8.0),
                                    //                         child: Text("Treading"),
                                    //                       ),
                                    //                     ),
                                    //                   ),
                                    //                   onTap: () {
                                    //                     createtreadingProjects(
                                    //                         projectId: widget.id,
                                    //                         heading: widget.heading,
                                    //                         description: widget.description,
                                    //                         photoUrl: widget.photoUrl,
                                    //                         videoUrl: widget.youtubeUrl,
                                    //                         circuitDiagram:
                                    //                             widget.circuitDiagram,
                                    //                         mode: "ep",
                                    //                         creator: "");
                                    //                   },
                                    //                 ),
                                    //               ),
                                    //               Flexible(
                                    //                 flex: 1,
                                    //                 child: InkWell(
                                    //                   child: Padding(
                                    //                     padding: const EdgeInsets.all(5.0),
                                    //                     child: Container(
                                    //                       decoration: const BoxDecoration(
                                    //                         gradient: LinearGradient(
                                    //                             begin: Alignment.topLeft,
                                    //                             end: Alignment.topRight,
                                    //                             colors: [
                                    //                               Colors.orange,
                                    //                               Colors.red
                                    //                             ]),
                                    //                         borderRadius: BorderRadius.all(
                                    //                             Radius.circular(8.0)),
                                    //                         color: Colors.blue,
                                    //                       ),
                                    //                       child: const Padding(
                                    //                         padding: EdgeInsets.all(8.0),
                                    //                         child: Text("Status"),
                                    //                       ),
                                    //                     ),
                                    //                   ),
                                    //                   onTap: () {
                                    //                     createStatus(
                                    //                         heading: widget.heading,
                                    //                         description: widget.description,
                                    //                         projectId: widget.id,
                                    //                         mode: "ep",
                                    //                         photoUrl: widget.photoUrl,
                                    //                         videoUrl: widget.youtubeUrl,
                                    //                         circuitDiagram:
                                    //                             widget.circuitDiagram);
                                    //                   },
                                    //                 ),
                                    //               ),
                                    //               Flexible(
                                    //                 flex: 1,
                                    //                 child: InkWell(
                                    //                   child: Padding(
                                    //                     padding: const EdgeInsets.all(5.0),
                                    //                     child: Container(
                                    //                       decoration: const BoxDecoration(
                                    //                         gradient: LinearGradient(
                                    //                             begin: Alignment.topLeft,
                                    //                             end: Alignment.topRight,
                                    //                             colors: [
                                    //                               Colors.orange,
                                    //                               Colors.red
                                    //                             ]),
                                    //                         borderRadius: BorderRadius.all(
                                    //                             Radius.circular(8.0)),
                                    //                         color: Colors.blue,
                                    //                       ),
                                    //                       child: const Padding(
                                    //                         padding: EdgeInsets.all(8.0),
                                    //                         child: Text("Sub Page"),
                                    //                       ),
                                    //                     ),
                                    //                   ),
                                    //                   onTap: () {},
                                    //                 ),
                                    //               ),
                                    //               Flexible(
                                    //                 flex: 1,
                                    //                 child: InkWell(
                                    //                   child: Padding(
                                    //                     padding: const EdgeInsets.all(5.0),
                                    //                     child: Container(
                                    //                       decoration: const BoxDecoration(
                                    //                         gradient: LinearGradient(
                                    //                             begin: Alignment.topLeft,
                                    //                             end: Alignment.topRight,
                                    //                             colors: [
                                    //                               Colors.orange,
                                    //                               Colors.red
                                    //                             ]),
                                    //                         borderRadius: BorderRadius.all(
                                    //                             Radius.circular(8.0)),
                                    //                         color: Colors.blue,
                                    //                       ),
                                    //                       child: const Padding(
                                    //                         padding: EdgeInsets.all(8.0),
                                    //                         child: Text("Home Page"),
                                    //                       ),
                                    //                     ),
                                    //                   ),
                                    //                   onTap: () {},
                                    //                 ),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    //
                                    //                                 StreamBuilder<
                                    //                                     List<electronicProjectsConvertor>>(
                                    //                                   stream: readotherelectronicProjects(
                                    //                                       id: widget.id),
                                    //                                   builder: (context, snapshot) {
                                    //                                     final Subjects = snapshot.data;
                                    //                                     switch (snapshot.connectionState) {
                                    //                                       case ConnectionState.waiting:
                                    //                                         return const Center(
                                    //                                             child: CircularProgressIndicator(
                                    //                                           strokeWidth: 0.3,
                                    //                                           color: Colors.cyan,
                                    //                                         ));
                                    //                                       default:
                                    //                                         if (snapshot.hasError) {
                                    //                                           return const Text(
                                    //                                               "Error with server");
                                    //                                         } else {
                                    //                                           return Column(
                                    //                                             crossAxisAlignment:
                                    //                                                 CrossAxisAlignment.start,
                                    //                                             mainAxisAlignment:
                                    //                                                 MainAxisAlignment.start,
                                    //                                             children: [
                                    //                                               Padding(
                                    //                                                 padding:
                                    //                                                     const EdgeInsets.only(
                                    //                                                         left: 10, top: 13),
                                    //                                                 child: Row(
                                    //                                                   children: [
                                    //                                                     const Text(
                                    //                                                       "Other Projects",
                                    //                                                       style: TextStyle(
                                    //                                                           fontSize: 25,
                                    //                                                           fontWeight:
                                    //                                                               FontWeight.w500,
                                    //                                                           color:
                                    //                                                               Colors.white),
                                    //                                                     ),
                                    //                                                     const Spacer(),
                                    //                                                     if (fullUserId() ==
                                    //                                                         ownerId)
                                    //                                                       InkWell(
                                    //                                                         child: Padding(
                                    //                                                           padding:
                                    //                                                               const EdgeInsets
                                    //                                                                   .only(
                                    //                                                                   right: 15),
                                    //                                                           child: Container(
                                    //                                                             decoration:
                                    //                                                                 const BoxDecoration(
                                    //                                                               gradient: LinearGradient(
                                    //                                                                   begin: Alignment
                                    //                                                                       .topLeft,
                                    //                                                                   end: Alignment.topRight,
                                    //                                                                   colors: [
                                    //                                                                     Colors
                                    //                                                                         .orange,
                                    //                                                                     Colors.red
                                    //                                                                   ]),
                                    //                                                               borderRadius: BorderRadius
                                    //                                                                   .all(Radius
                                    //                                                                       .circular(
                                    //                                                                           8.0)),
                                    //                                                               color:
                                    //                                                                   Colors.blue,
                                    //                                                             ),
                                    //                                                             child: Padding(
                                    //                                                               padding:
                                    //                                                                   const EdgeInsets
                                    //                                                                       .only(
                                    //                                                                       left: 5,
                                    //                                                                       right:
                                    //                                                                           5,
                                    //                                                                       top: 3,
                                    //                                                                       bottom:
                                    //                                                                           3),
                                    //                                                               child: Row(
                                    //                                                                 children: const [
                                    //                                                                   Text(
                                    //                                                                       " Add "),
                                    //                                                                   Icon(
                                    //                                                                     Icons.add,
                                    //                                                                     size: 20,
                                    //                                                                   ),
                                    //                                                                 ],
                                    //                                                               ),
                                    //                                                             ),
                                    //                                                           ),
                                    //                                                         ),
                                    //                                                         onTap: () {
                                    //                                                           showDialog(
                                    //                                                             context: context,
                                    //                                                             builder:
                                    //                                                                 (context) {
                                    //                                                               return Dialog(
                                    //                                                                 backgroundColor: Colors
                                    //                                                                     .black
                                    //                                                                     .withOpacity(
                                    //                                                                         0.1),
                                    //                                                                 shape: RoundedRectangleBorder(
                                    //                                                                     borderRadius:
                                    //                                                                         BorderRadius.circular(
                                    //                                                                             20)),
                                    //                                                                 elevation: 16,
                                    //                                                                 child:
                                    //                                                                     Container(
                                    //                                                                   decoration:
                                    //                                                                       BoxDecoration(
                                    //                                                                     border: Border.all(
                                    //                                                                         color: Colors
                                    //                                                                             .white
                                    //                                                                             .withOpacity(0.1)),
                                    //                                                                     borderRadius:
                                    //                                                                         BorderRadius.circular(
                                    //                                                                             20),
                                    //                                                                   ),
                                    //                                                                   child:
                                    //                                                                       ListView(
                                    //                                                                     physics:
                                    //                                                                         BouncingScrollPhysics(),
                                    //                                                                     shrinkWrap:
                                    //                                                                         true,
                                    //                                                                     children: <Widget>[
                                    //                                                                       const Center(
                                    //                                                                         child:
                                    //                                                                             Padding(
                                    //                                                                           padding:
                                    //                                                                               EdgeInsets.all(8.0),
                                    //                                                                           child:
                                    //                                                                               Text(
                                    //                                                                             "Add to Other Projects",
                                    //                                                                             style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300, color: Colors.blue),
                                    //                                                                           ),
                                    //                                                                         ),
                                    //                                                                       ),
                                    //                                                                       StreamBuilder<
                                    //                                                                           List<electronicProjectsConvertor>>(
                                    //                                                                         stream:
                                    //                                                                             readelectronicProjects(),
                                    //                                                                         builder:
                                    //                                                                             (context, snapshot) {
                                    //                                                                           final Subjects =
                                    //                                                                               snapshot.data;
                                    //                                                                           switch (snapshot.connectionState) {
                                    //                                                                             case ConnectionState.waiting:
                                    //                                                                               return const Center(
                                    //                                                                                   child: CircularProgressIndicator(
                                    //                                                                                 strokeWidth: 0.3,
                                    //                                                                                 color: Colors.cyan,
                                    //                                                                               ));
                                    //                                                                             default:
                                    //                                                                               if (snapshot.hasError) {
                                    //                                                                                 return const Text("Error with server");
                                    //                                                                               } else {
                                    //                                                                                 return ListView.separated(
                                    //                                                                                     physics: const BouncingScrollPhysics(),
                                    //                                                                                     itemCount: Subjects!.length,
                                    //                                                                                     shrinkWrap: true,
                                    //                                                                                     padding: const EdgeInsets.only(left: 5, right: 5),
                                    //                                                                                     itemBuilder: (BuildContext context, int index) {
                                    //                                                                                       final SubjectsData = Subjects[index];
                                    //                                                                                       return Container(
                                    //                                                                                         decoration: const BoxDecoration(
                                    //                                                                                           borderRadius: BorderRadius.all(Radius.circular(15)),
                                    //                                                                                           gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [
                                    //                                                                                             Colors.black38,
                                    //                                                                                             Colors.black38,
                                    //                                                                                             Colors.black87
                                    //                                                                                           ]),
                                    //                                                                                         ),
                                    //                                                                                         child: Row(
                                    //                                                                                           children: [
                                    //                                                                                             Container(
                                    //                                                                                               decoration: BoxDecoration(
                                    //                                                                                                 border: Border.all(color: Color.fromRGBO(174, 228, 242, 0.3)),
                                    //                                                                                                 color: Colors.black38,
                                    //                                                                                                 borderRadius: const BorderRadius.all(Radius.circular(15)),
                                    //                                                                                                 image: DecorationImage(
                                    //                                                                                                   image: NetworkImage(
                                    //                                                                                                     SubjectsData.photoUrl,
                                    //                                                                                                   ),
                                    //                                                                                                   fit: BoxFit.cover,
                                    //                                                                                                 ),
                                    //                                                                                               ),
                                    //                                                                                               height: 40,
                                    //                                                                                               width: 70,
                                    //                                                                                             ),
                                    //                                                                                             Expanded(
                                    //                                                                                               child: Column(
                                    //                                                                                                 children: [
                                    //                                                                                                   Text(
                                    //                                                                                                     SubjectsData.heading,
                                    //                                                                                                     overflow: TextOverflow.ellipsis,
                                    //                                                                                                     style: TextStyle(color: Colors.white),
                                    //                                                                                                   ),
                                    //                                                                                                   InkWell(
                                    //                                                                                                     child: Container(
                                    //                                                                                                       decoration: const BoxDecoration(
                                    //                                                                                                         gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.topRight, colors: [Colors.orange, Colors.red]),
                                    //                                                                                                         borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                    //                                                                                                         color: Colors.blue,
                                    //                                                                                                       ),
                                    //                                                                                                       child: const Padding(
                                    //                                                                                                         padding: const EdgeInsets.all(5.0),
                                    //                                                                                                         child: const Text("+ Add"),
                                    //                                                                                                       ),
                                    //                                                                                                     ),
                                    //                                                                                                     onTap: () {
                                    //                                                                                                       createotherelectronicProjects(projectId: widget.id, id: SubjectsData.id, videoUrl: SubjectsData.youtubeUrl, description: SubjectsData.description, photoUrl: SubjectsData.photoUrl, heading: SubjectsData.heading, circuitDiagram: SubjectsData.circuitDiagram, source: SubjectsData.source, creator: SubjectsData.creator, creatorPhoto: SubjectsData.creatorPhoto, sourceName: SubjectsData.sourceName);
                                    //                                                                                                       Navigator.pop(context);
                                    //                                                                                                     },
                                    //                                                                                                   )
                                    //                                                                                                 ],
                                    //                                                                                               ),
                                    //                                                                                             )
                                    //                                                                                           ],
                                    //                                                                                         ),
                                    //                                                                                       );
                                    //                                                                                     },
                                    //                                                                                     separatorBuilder: (context, index) => const SizedBox(
                                    //                                                                                           height: 4,
                                    //                                                                                         ));
                                    //                                                                               }
                                    //                                                                           }
                                    //                                                                         },
                                    //                                                                       ),
                                    //                                                                       const SizedBox(
                                    //                                                                         height:
                                    //                                                                             10,
                                    //                                                                       )
                                    //                                                                     ],
                                    //                                                                   ),
                                    //                                                                 ),
                                    //                                                               );
                                    //                                                             },
                                    //                                                           );
                                    //                                                         },
                                    //                                                       ),
                                    //                                                   ],
                                    //                                                 ),
                                    //                                               ),
                                    //                                               const SizedBox(
                                    //                                                 height: 10,
                                    //                                               ),
                                    //                                               Padding(
                                    //                                                 padding:
                                    //                                                     const EdgeInsets.only(
                                    //                                                         left: 20, right: 10),
                                    //                                                 child: ListView.builder(
                                    //                                                   physics:
                                    //                                                       const NeverScrollableScrollPhysics(),
                                    //                                                   itemCount: Subjects!.length,
                                    //                                                   shrinkWrap: true,
                                    //                                                   itemBuilder:
                                    //                                                       (BuildContext context,
                                    //                                                           int index) {
                                    //                                                     final SubjectsData =
                                    //                                                         Subjects[index];
                                    //                                                     return Padding(
                                    //                                                       padding:
                                    //                                                           const EdgeInsets
                                    //                                                               .all(2.0),
                                    //                                                       child: InkWell(
                                    //                                                         child: Row(
                                    //                                                           children: [
                                    //                                                             Container(
                                    //                                                               height: 50,
                                    //                                                               width: 80,
                                    //                                                               decoration:
                                    //                                                                   BoxDecoration(
                                    //                                                                 borderRadius:
                                    //                                                                     BorderRadius
                                    //                                                                         .circular(
                                    //                                                                             15),
                                    //                                                                 color: Colors
                                    //                                                                     .black
                                    //                                                                     .withOpacity(
                                    //                                                                         0.4),
                                    //                                                                 border: Border.all(
                                    //                                                                     color: const Color
                                    //                                                                         .fromRGBO(
                                    //                                                                         174,
                                    //                                                                         228,
                                    //                                                                         242,
                                    //                                                                         0.5)),
                                    //                                                                 image:
                                    //                                                                     DecorationImage(
                                    //                                                                   image:
                                    //                                                                       NetworkImage(
                                    //                                                                     SubjectsData
                                    //                                                                         .photoUrl,
                                    //                                                                   ),
                                    //                                                                   fit: BoxFit
                                    //                                                                       .cover,
                                    //                                                                 ),
                                    //                                                               ),
                                    //                                                             ),
                                    //                                                             const SizedBox(
                                    //                                                               width: 8,
                                    //                                                             ),
                                    //                                                             Expanded(
                                    //                                                               child: Text(
                                    //                                                                 SubjectsData
                                    //                                                                     .heading,
                                    //                                                                 style: const TextStyle(
                                    //                                                                     fontSize:
                                    //                                                                         20,
                                    //                                                                     color: Colors
                                    //                                                                         .red),
                                    //                                                                 maxLines: 2,
                                    //                                                                 overflow:
                                    //                                                                     TextOverflow
                                    //                                                                         .ellipsis,
                                    //                                                               ),
                                    //                                                             ),
                                    //                                                           ],
                                    //                                                         ),
                                    //                                                         onTap: () {
                                    // //                                                           Navigator.push(
                                    // //                                                               context,
                                    // //                                                               MaterialPageRoute(
                                    // //                                                                   builder:
                                    // //                                                                       (context) =>
                                    // //                                                                           electronicProject(
                                    // //                                                                       tags: SubjectsData.tags,
                                    // //
                                    // // youtubeUrl: SubjectsData.youtubeUrl,
                                    // //                                                                             circuitDiagram: SubjectsData.circuitDiagram,
                                    // //                                                                             id: SubjectsData.id,
                                    // //                                                                             heading: SubjectsData.heading,
                                    // //                                                                             description: SubjectsData.description,
                                    // //                                                                             photoUrl: SubjectsData.photoUrl,
                                    // //                                                                             creator: SubjectsData.creator,
                                    // //                                                                             creatorPhoto: SubjectsData.creatorPhoto,
                                    // //                                                                             source: SubjectsData.source,
                                    // //                                                                             sourceName: SubjectsData.sourceName,
                                    // //                                                                           )));
                                    //                                                         },
                                    //                                                         onLongPress: () {
                                    //                                                           FirebaseFirestore
                                    //                                                               .instance
                                    //                                                               .collection(
                                    //                                                                   'electronicProjects')
                                    //                                                               .doc(widget.id)
                                    //                                                               .collection(
                                    //                                                                   "otherProjects")
                                    //                                                               .doc(
                                    //                                                                   SubjectsData
                                    //                                                                       .id)
                                    //                                                               .delete();
                                    //                                                           showToastText(
                                    //                                                               "${SubjectsData.heading} has been Deleted");
                                    //                                                         },
                                    //                                                       ),
                                    //                                                     );
                                    //                                                   },
                                    //                                                 ),
                                    //                                               ),
                                    //                                               const SizedBox(
                                    //                                                 height: 20,
                                    //                                               )
                                    //                                             ],
                                    //                                           );
                                    //                                         }
                                    //                                     }
                                    //                                   },
                                    //                                 ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (Width(context) > 700)
                          Flexible(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: Width(context) * 0.04,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black54,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                25.0)),
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            widget.creator
                                                                .split(";")
                                                                .last),
                                                        fit: BoxFit.fill,
                                                        filterQuality:
                                                            FilterQuality.low)),
                                                height: 50,
                                                width: 50,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 3),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    widget.creator
                                                        .split(";")
                                                        .first,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 22),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          const Icon(
                                                            Icons.circle,
                                                            size: 5,
                                                            color: Colors
                                                                .redAccent,
                                                          ),
                                                          Text(
                                                            " ${widget.views}",
                                                            style: const TextStyle(
                                                                fontSize: 11,
                                                                color: Colors
                                                                    .lightBlueAccent),
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 8,
                                                                    left: 3),
                                                            child: Text(
                                                              "views",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 13),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 15,
                                                                right: 5),
                                                        child: Icon(
                                                          Icons.circle,
                                                          size: 8,
                                                        ),
                                                      ),
                                                      InkWell(
                                                        child: Text(
                                                          widget.source
                                                              .split(";")
                                                              .first,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16),
                                                        ),
                                                        onTap: () {
                                                          ExternalLaunchUrl(
                                                              widget.source
                                                                  .split(";")
                                                                  .last);
                                                        },
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, bottom: 5),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Making Video",
                                                style: TextStyle(
                                                    fontSize: 23,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 13, left: 10, bottom: 15),
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
                                                              20)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Play",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  showDialog<void>(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    // user must tap button!
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
                                                              20)),
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "View On",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 22,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                      Container(
                                                          height: 40,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              image: DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
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
                                        Divider(
                                          color: Colors.white54,
                                        ),
                                        StreamBuilder<
                                            List<
                                                electronicProjectDownloadConvertor>>(
                                          stream: readelectronicProjectDownload(
                                              widget.id),
                                          builder: (context, snapshot) {
                                            final Subjects = snapshot.data;
                                            switch (snapshot.connectionState) {
                                              case ConnectionState.waiting:
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                  strokeWidth: 0.3,
                                                  color: Colors.cyan,
                                                ));
                                              default:
                                                if (snapshot.hasError) {
                                                  return const Text(
                                                      "Error with server");
                                                } else {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: Row(
                                                          children: [
                                                            const Text(
                                                              "Downloads",
                                                              style: TextStyle(
                                                                  fontSize: 25,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 15,
                                                                right: 5,
                                                                bottom: 13),
                                                        child: ListView.builder(
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          itemCount:
                                                              Subjects!.length,
                                                          shrinkWrap: true,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            final SubjectsData =
                                                                Subjects[index];
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                top: 8,
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      InkWell(
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15),
                                                                            border:
                                                                                Border.all(color: const Color.fromRGBO(174, 228, 242, 0.1)),
                                                                            gradient:
                                                                                const LinearGradient(begin: Alignment.topLeft, end: Alignment.topRight, colors: [
                                                                              Colors.orange,
                                                                              Colors.red
                                                                            ]),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(5.0),
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Row(
                                                                                  children: const [
                                                                                    Icon(
                                                                                      Icons.download_outlined,
                                                                                      color: Colors.white,
                                                                                      size: 25,
                                                                                    ),
                                                                                    Text(
                                                                                      "Download",
                                                                                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          if (SubjectsData
                                                                              .link
                                                                              .isNotEmpty) {
                                                                            ExternalLaunchUrl(SubjectsData.link);
                                                                          } else {
                                                                            showToastText("No Link Available");
                                                                          }
                                                                        },
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              SubjectsData.name,
                                                                              style: const TextStyle(fontSize: 14, color: Colors.white),
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                            const Divider(
                                                                              color: Colors.white60,
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            3.0),
                                                                    child: Text(
                                                                      "                ${SubjectsData.description}",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          color:
                                                                              Colors.white60),
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

