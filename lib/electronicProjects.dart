// ignore_for_file: import_of_legacy_library_into_null_safe, camel_case_types, non_constant_identifier_names, must_be_immutable, equal_keys_in_map, library_private_types_in_public_api, use_build_context_synchronously, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ns_ideas/authPage.dart';
import 'settings.dart';
import 'commonFunctions.dart';
import 'functions.dart';
import 'homepage.dart';

Stream<List<ProjectsConvertor>> readProjectsConvertor( String c0, String d0, String c1) =>  FirebaseFirestore.instance
    .collection(c0)
    .doc(d0)
    .collection(c1)
    .snapshots()
    .map((snapshot) => snapshot.docs
    .map((doc) => ProjectsConvertor.fromJson(doc.data()))
    .toList());

class ProjectsConvertor {
  String id;
  final String heading, images,time,VL,type;

  ProjectsConvertor({
    this.id = "",
    required this.heading,
    required this.images,
    required this.time,
    required this.type,
    required this.VL,
  }) ;
  static ProjectsConvertor fromJson(
      Map<String, dynamic> json) =>
      ProjectsConvertor(
          id: json['id'],
          heading: json["title"],
          type: json["type"]??"",
          time: json["time"],
          images: json["Thumbnails"],
          VL: json["ViewsLikes"]);
}


Stream<List<HomePageImagesConvertor>> readHomePageImagesConvertor() =>  FirebaseFirestore.instance
            .collection("HomePageImages")
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => HomePageImagesConvertor.fromJson(doc.data()))
                .toList());

class HomePageImagesConvertor {
  String id;
  final String  image;

  HomePageImagesConvertor({
    this.id = "",
    required this.image,

  }) ;
  static HomePageImagesConvertor fromJson(
          Map<String, dynamic> json) =>
      HomePageImagesConvertor(
          id: json['id'],

          image: json["image"],
      );
}



class electronicProject extends StatefulWidget {
  String id,
      heading,
      tableOfContent,
      description,
      photoUrl,
      youtubeUrl;
  List tags, requiredComponents, toolsRequired, likes;
  String views;
  int comments;

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
    return backGroundImage(
        text: widget.heading.split(";").first,
        child: SingleChildScrollView(child: Column(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageHeadingTagsDescription(heading: widget.heading.split(";").last, id: widget.youtubeUrl, description: "              ${widget.description}", photoUrl: widget.photoUrl, tags: widget.tags,),
              tableOfContent(
                  list: widget.tableOfContent.split(";")),
              Padding(
                padding:  EdgeInsets.all(Size*4.0),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
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
                                fontSize: Size*20,

                                color: Colors.white),
                          ),
                        ),
                      if (widget.photoUrl.split(";").last.isNotEmpty)
                        Padding(
                          padding:  EdgeInsets.all(Size*8.0),
                          child: scrollingImages(
                            images: widget.photoUrl.split(";"),
                            id: widget.youtubeUrl,
                            isZoom: true,
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
              youtubeInfo(url: widget.youtubeUrl,),
              commentsPage(
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




