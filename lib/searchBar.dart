// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ns_ideas/authPage.dart';
import 'package:ns_ideas/homepage.dart';
import 'package:ns_ideas/sensors.dart';
import 'package:ns_ideas/textField.dart';
import 'package:path_provider/path_provider.dart';

import 'arduino.dart';
import 'commonFunctions.dart';
import 'electronicProjects.dart';
import 'functions.dart';
import 'raspberrypi.dart';

class searchBar extends StatefulWidget {
  const searchBar({Key? key}) : super(key: key);

  @override
  State<searchBar> createState() => _searchBarState();
}

class _searchBarState extends State<searchBar> {
  String name = "";
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
    return backGroundImage(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              flex: 1,
              child: TextFieldContainer(
                child: Row(
                children: [
                  Padding(
                    padding:  EdgeInsets.only(right: Size*10),
                    child: Icon(
                      Icons.search,
                      size: Size*30,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: Size*20),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search Bar',
                        hintStyle: TextStyle(color: Colors.white54)
                      ),
                    ),
                  ),
                ],
              ),),
            ),
            if (name.isNotEmpty)
              InkWell(
                onTap: () {
                  setState(() {
                    name = "";
                  });
                },
                child: Padding(
                  padding:  EdgeInsets.only(
                    right:Size* 10,
                  ),
                  child: Icon(
                    Icons.clear,
                    size:Size* 35,
                    color: Colors.white,
                  ),
                ),
              )
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.only(left: Size*10, right: Size*10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:  EdgeInsets.all(Size*8.0),
                    child: Text(
                      "Arduino",
                      style: TextStyle(fontSize:Size* 22, color: Colors.white),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('arduino')
                        .doc("arduinoProjects")
                        .collection("projects")
                        .snapshots(),
                    builder: (context, snapshots) {
                      return (snapshots.connectionState ==
                          ConnectionState.waiting)
                          ? const Center(
                        child: CircularProgressIndicator(),
                      )
                          : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshots.data!.docs.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var data = snapshots.data!.docs[index]
                                .data() as Map<String, dynamic>;
                            List<String> tagsList = data["tags"].toString().split(";").map((tag) => tag.trim()).toList();
                            bool tags = false;
                            for (String x in tagsList) {
                              if (x.toLowerCase().startsWith(name.toLowerCase().trim())) {
                                tags = true; // Set to true if any tag starts with the specified name
                                break;
                              }
                            }
                            if (data["images"].split(";").first.length > 3) {
                              final Uri uri = Uri.parse(data["images"].split(";").first);
                              final String fileName = uri.pathSegments.last;
                              var name = fileName.split("/").last;
                              file = File("$folderPath/${data["id"]}/$name");

                            }
                            if (name.isEmpty) {
                              return InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:Colors.white30),
                                          color: Colors.black38,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(Size*15)),
                                          image: DecorationImage(
                                            image: FileImage(file),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        height: Size*60,
                                        width: Size*100,
                                      ),
                                      Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                     EdgeInsets
                                                        .all(Size*8.0),
                                                    child: Text(
                                                      data["heading"].toString().replaceAll(";", "-"),
                                                      style: TextStyle(
                                                          fontSize: Size*19,
                                                          color:
                                                          Colors.white),
                                                      maxLines: 2,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                    ),
                                                  ),
                                                  Wrap(
                                                    direction: Axis.horizontal,
                                                    children: data["tags"].toString().split(";")
                                                        .map(
                                                          (text) => Padding(
                                                        padding:  EdgeInsets.only(right: Size*5),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(Size*10),
                                                              border: Border.all(color: Colors.white24)),
                                                          padding: EdgeInsets.symmetric(
                                                              vertical: Size*2, horizontal:Size* 6),
                                                          child: Text(
                                                            text,
                                                            style: TextStyle(color: Colors.white,fontSize: Size*15),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                        .toList(),
                                                  ),
                                                ],
                                              ),
                                              if(isUser())
                                              PopupMenuButton(
                                                icon: Icon(
                                                  Icons.more_vert,
                                                  color: Colors.white,
                                                  size:  25,
                                                ),
                                                // Callback that sets the selected popup menu item.
                                                onSelected: (item) {
                                                  if (item == "edit") {
                                                    Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        transitionDuration:
                                                        const Duration(milliseconds: 300),
                                                        pageBuilder:
                                                            (context, animation, secondaryAnimation) =>
                                                                arduinoProjectCreator(
                                                              appsAndPlatforms:data["appsAndPlatforms"],
                                                                  youtubeLink: data["youtubeLink"],
                                                              id: data['id'],
                                                              heading: data['heading'],
                                                              description: data['description'],
                                                              images: data['images'],
                                                              tags: data['tags'],
                                                              tableOfContent: data['tableOfContent'],
                                                               componentsAndSupplies: data['componentsAndSupplies'],
                                                            ),
                                                        transitionsBuilder: (context, animation,
                                                            secondaryAnimation, child) {
                                                          final fadeTransition = FadeTransition(
                                                            opacity: animation,
                                                            child: child,
                                                          );

                                                          return Container(
                                                            color:
                                                            Colors.black.withOpacity(animation.value),
                                                            child: AnimatedOpacity(
                                                                duration: Duration(milliseconds: 300),
                                                                opacity: animation.value.clamp(0.3, 1.0),
                                                                child: fadeTransition),
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  } else if (item == "delete") {
                                                    FirebaseFirestore.instance
                                                        .collection('arduino')
                                                        .doc("arduinoProjects")
                                                        .collection("projects")
                                                        .doc(data["id"]).delete();
                                                  }
                                                },
                                                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                                  const PopupMenuItem(
                                                    value: "edit",
                                                    child: Text('Edit'),
                                                  ),
                                                  const PopupMenuItem(
                                                    value: "delete",
                                                    child: Text('Delete'),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                                onTap: () async {

                                  if (!kIsWeb) {
                                    List<String> images = [];
                                    if (data['images'].toString().isNotEmpty) {
                                      images = data['images'].toString().split(";");
                                    }
                                    await FirebaseFirestore.instance
                                        .collection("arduino")
                                        .doc("arduinoProjects")
                                        .collection("projects")
                                        .doc(data["id"])
                                        .collection("description") // Replace "photos" with your actual collection name
                                        .get()
                                        .then((QuerySnapshot snapshot) {
                                      if (snapshot.size > 0) {
                                        snapshot.docs.forEach((DocumentSnapshot document) {
                                          var data1 = document.data();
                                          if (data1 != null && data1 is Map<String, dynamic>) {
                                            if (data1['images'].toString().isNotEmpty) {
                                              images.addAll(
                                                  data1['images'].toString().split(";"));
                                            }
                                          }
                                        });
                                      }
                                    });

                                    await showDialog(
                                    context: context,
                                    builder: (context) => ImageDownloadScreen(
                                      images: images,
                                      id: data['id'],
                                    ),
                                    );
                                  }
                                  FirebaseFirestore.instance
                                      .collection("arduino")
                                      .doc("arduinoProjects")
                                      .collection("projects")
                                      .doc(data['id'])
                                      .update({"views": data['views'] + 1});

                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration:
                                      const Duration(milliseconds: 300),
                                      pageBuilder:
                                          (context, animation, secondaryAnimation) =>
                                          arduinoProject(
                                            appsAndPlatforms:data["appsAndPlatforms"],
                                            comments: data["comments"],

                                            youtubeUrl: data["youtubeLink"],
                                            id: data['id'],
                                            heading: data['heading'],
                                            description: data['description'],
                                            photoUrl: data['images'],
                                            tags: data['tags'].toString().split(";"),
                                            tableOfContent: data['tableOfContent'],
                                            views: data["views"], componentsAndSupplies: data['componentsAndSupplies'],
                                          ),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        final fadeTransition = FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );

                                        return Container(
                                          color:
                                          Colors.black.withOpacity(animation.value),
                                          child: AnimatedOpacity(
                                              duration: Duration(milliseconds: 300),
                                              opacity: animation.value.clamp(0.3, 1.0),
                                              child: fadeTransition),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                            if (data['heading']
                                .toString().split(";").first
                                .toLowerCase()
                                .startsWith(name.toLowerCase())||data['heading']
                                .toString().split(";").last
                                .toLowerCase()
                                .startsWith(name.toLowerCase())||tags) {
                              return InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:Colors.white30),
                                          color: Colors.black38,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(Size*15)),
                                          image: DecorationImage(
                                            image: FileImage(file),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        height: Size*60,
                                        width: Size*100,
                                      ),
                                      Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                    EdgeInsets
                                                        .all(Size*8.0),
                                                    child: Text(
                                                      data["heading"].toString().replaceAll(";", "-"),
                                                      style: TextStyle(
                                                          fontSize: Size*19,
                                                          color:
                                                          Colors.white),
                                                      maxLines: 2,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                    ),
                                                  ),
                                                  Wrap(
                                                    direction: Axis.horizontal,
                                                    children: data["tags"].toString().split(";")
                                                        .map(
                                                          (text) => Padding(
                                                        padding:  EdgeInsets.only(right: Size*5),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(Size*10),
                                                              border: Border.all(color: Colors.white24)),
                                                          padding: EdgeInsets.symmetric(
                                                              vertical: Size*2, horizontal:Size* 6),
                                                          child: Text(
                                                            text,
                                                            style: TextStyle(color: Colors.white,fontSize: Size*15),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                        .toList(),
                                                  ),
                                                ],
                                              ),
                                              if(isUser())
                                                PopupMenuButton(
                                                  icon: Icon(
                                                    Icons.more_vert,
                                                    color: Colors.white,
                                                    size:  25,
                                                  ),
                                                  // Callback that sets the selected popup menu item.
                                                  onSelected: (item) {
                                                    if (item == "edit") {
                                                      Navigator.push(
                                                        context,
                                                        PageRouteBuilder(
                                                          transitionDuration:
                                                          const Duration(milliseconds: 300),
                                                          pageBuilder:
                                                              (context, animation, secondaryAnimation) =>
                                                              arduinoProjectCreator(
                                                                appsAndPlatforms:data["appsAndPlatforms"],
                                                                youtubeLink: data["youtubeLink"],
                                                                id: data['id'],
                                                                heading: data['heading'],
                                                                description: data['description'],
                                                                images: data['images'],
                                                                tags: data['tags'],
                                                                tableOfContent: data['tableOfContent'],
                                                                componentsAndSupplies: data['componentsAndSupplies'],
                                                              ),
                                                          transitionsBuilder: (context, animation,
                                                              secondaryAnimation, child) {
                                                            final fadeTransition = FadeTransition(
                                                              opacity: animation,
                                                              child: child,
                                                            );

                                                            return Container(
                                                              color:
                                                              Colors.black.withOpacity(animation.value),
                                                              child: AnimatedOpacity(
                                                                  duration: Duration(milliseconds: 300),
                                                                  opacity: animation.value.clamp(0.3, 1.0),
                                                                  child: fadeTransition),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    } else if (item == "delete") {
                                                      FirebaseFirestore.instance
                                                          .collection('arduino')
                                                          .doc("arduinoProjects")
                                                          .collection("projects")
                                                          .doc(data["id"]).delete();
                                                    }
                                                  },
                                                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                                    const PopupMenuItem(
                                                      value: "edit",
                                                      child: Text('Edit'),
                                                    ),
                                                    const PopupMenuItem(
                                                      value: "delete",
                                                      child: Text('Delete'),
                                                    ),
                                                  ],
                                                )
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                                onTap: () async {
                                  if (!kIsWeb) {
                                    List<String> images = [];
                                    if (data['images'].toString().isNotEmpty) {
                                      images = data['images'].toString().split(";");
                                    }
                                    await FirebaseFirestore.instance
                                        .collection("arduino")
                                        .doc("arduinoProjects")
                                        .collection("projects")
                                        .doc(data["id"])
                                        .collection("description") // Replace "photos" with your actual collection name
                                        .get()
                                        .then((QuerySnapshot snapshot) {
                                      if (snapshot.size > 0) {
                                        snapshot.docs.forEach((DocumentSnapshot document) {
                                          var data1 = document.data();
                                          if (data1 != null && data1 is Map<String, dynamic>) {
                                            if (data1['images'].toString().isNotEmpty) {
                                              images.addAll(
                                                  data1['images'].toString().split(";"));
                                            }
                                          }
                                        });
                                      }
                                    });

                                    await showDialog(
                                      context: context,
                                      builder: (context) => ImageDownloadScreen(
                                        images: images,
                                        id: data['id'],
                                      ),
                                    );
                                  }
                                  FirebaseFirestore.instance
                                      .collection("arduino")
                                      .doc("arduinoProjects")
                                      .collection("projects")
                                      .doc(data['id'])
                                      .update({"views": data['views'] + 1});

                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration:
                                      const Duration(milliseconds: 300),
                                      pageBuilder:
                                          (context, animation, secondaryAnimation) =>
                                          arduinoProject(
                                            appsAndPlatforms:data["appsAndPlatforms"],
                                            comments: data["comments"],

                                            youtubeUrl: data["youtubeLink"],
                                            id: data['id'],
                                            heading: data['heading'],
                                            description: data['description'],
                                            photoUrl: data['images'],
                                            tags: data['tags'].toString().split(";"),
                                            tableOfContent: data['tableOfContent'],
                                            views: data["views"], componentsAndSupplies: data['componentsAndSupplies'],
                                          ),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        final fadeTransition = FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );

                                        return Container(
                                          color:
                                          Colors.black.withOpacity(animation.value),
                                          child: AnimatedOpacity(
                                              duration: Duration(milliseconds: 300),
                                              opacity: animation.value.clamp(0.3, 1.0),
                                              child: fadeTransition),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                            return Container();
                          });
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('arduino')
                        .doc("arduinoBoards")
                        .collection("Board")
                        .snapshots(),
                    builder: (context, snapshots) {
                      return (snapshots.connectionState ==
                          ConnectionState.waiting)
                          ? const Center(
                        child: CircularProgressIndicator(),
                      )
                          : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshots.data!.docs.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var data = snapshots.data!.docs[index]
                                .data() as Map<String, dynamic>;
                            if (data["images"].split(";").first.length > 3) {
                              final Uri uri = Uri.parse(data["images"].split(";").first);
                              final String fileName = uri.pathSegments.last;
                              var name = fileName.split("/").last;
                              file = File("$folderPath/${data["id"]}/$name");

                            }
                            if (name.isEmpty) {
                              return InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:Colors.white30),
                                          color: Colors.black38,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(Size*15)),
                                          image: DecorationImage(
                                            image: FileImage(file),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        height: Size*60,
                                        width: Size*100,
                                      ),
                                      Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                EdgeInsets
                                                    .all(Size*8.0),
                                                child: Text(
                                                  data["name"].toString().replaceAll(";", "-"),
                                                  style: TextStyle(
                                                      fontSize: Size*19,
                                                      color:
                                                      Colors.white),
                                                  maxLines: 2,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                ),
                                              ),
                                              if(isUser())
                                                PopupMenuButton(
                                                  icon: Icon(
                                                    Icons.more_vert,
                                                    color: Colors.white,
                                                    size:  25,
                                                  ),
                                                  // Callback that sets the selected popup menu item.
                                                  onSelected: (item) {
                                                    if (item == "edit") {
                                                      Navigator.push(
                                                        context,
                                                        PageRouteBuilder(
                                                          transitionDuration:
                                                          const Duration(milliseconds: 300),
                                                          pageBuilder:
                                                              (context, animation, secondaryAnimation) =>
                                                              arduinoBoardCreator(
                                                                circuitDiagram: data['pinOut'],
                                                                id: data['id'],
                                                                heading: data['name'],
                                                                description: data['description'],
                                                                photoUrl: data['images'],
                                                              ),
                                                          transitionsBuilder: (context, animation,
                                                              secondaryAnimation, child) {
                                                            final fadeTransition = FadeTransition(
                                                              opacity: animation,
                                                              child: child,
                                                            );

                                                            return Container(
                                                              color:
                                                              Colors.black.withOpacity(animation.value),
                                                              child: AnimatedOpacity(
                                                                  duration: Duration(milliseconds: 300),
                                                                  opacity: animation.value.clamp(0.3, 1.0),
                                                                  child: fadeTransition),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    } else if (item == "delete") {
                                                      FirebaseFirestore.instance
                                                          .collection('arduino')
                                                          .doc("arduinoProjects")
                                                          .collection("projects")
                                                          .doc(data["id"]).delete();
                                                    }
                                                  },
                                                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                                    const PopupMenuItem(
                                                      value: "edit",
                                                      child: Text('Edit'),
                                                    ),
                                                    const PopupMenuItem(
                                                      value: "delete",
                                                      child: Text('Delete'),
                                                    ),
                                                  ],
                                                )
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  FirebaseFirestore.instance
                                      .collection("arduino")
                                      .doc("arduinoBoards")
                                      .collection("Board")
                                      .doc(data["id"]) // Replace "documentId" with the ID of the document you want to retrieve
                                      .get()
                                      .then((DocumentSnapshot snapshot) async {
                                    if (snapshot.exists) {
                                      var data = snapshot.data();
                                      if (data != null &&
                                          data is Map<String, dynamic>) {
                                        List<String> images = [];
                                        images = data['images']
                                            .toString()
                                            .split(";");
                                        images.addAll(data['pinOut']
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
                                                  id: data["id"],
                                                  heading: data["name"],
                                                  description: data['description'],
                                                  photoUrl: data["images"],
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
                            }
                            else if (data['name']
                                .toString()
                                .toLowerCase()
                                .startsWith(name.toLowerCase())) {
                              return InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:Colors.white30),
                                          color: Colors.black38,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(Size*15)),
                                          image: DecorationImage(
                                            image: FileImage(file),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        height: Size*60,
                                        width: Size*100,
                                      ),
                                      Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                EdgeInsets
                                                    .all(Size*8.0),
                                                child: Text(
                                                  data["name"].toString().replaceAll(";", "-"),
                                                  style: TextStyle(
                                                      fontSize: Size*19,
                                                      color:
                                                      Colors.white),
                                                  maxLines: 2,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                ),
                                              ),
                                              if(isUser())
                                                PopupMenuButton(
                                                  icon: Icon(
                                                    Icons.more_vert,
                                                    color: Colors.white,
                                                    size:  25,
                                                  ),
                                                  // Callback that sets the selected popup menu item.
                                                  onSelected: (item) {
                                                    if (item == "edit") {
                                                      Navigator.push(
                                                        context,
                                                        PageRouteBuilder(
                                                          transitionDuration:
                                                          const Duration(milliseconds: 300),
                                                          pageBuilder:
                                                              (context, animation, secondaryAnimation) =>
                                                              arduinoBoardCreator(
                                                                circuitDiagram: data['pinOut'],
                                                                id: data['id'],
                                                                heading: data['name'],
                                                                description: data['description'],
                                                                photoUrl: data['images'],
                                                              ),
                                                          transitionsBuilder: (context, animation,
                                                              secondaryAnimation, child) {
                                                            final fadeTransition = FadeTransition(
                                                              opacity: animation,
                                                              child: child,
                                                            );

                                                            return Container(
                                                              color:
                                                              Colors.black.withOpacity(animation.value),
                                                              child: AnimatedOpacity(
                                                                  duration: Duration(milliseconds: 300),
                                                                  opacity: animation.value.clamp(0.3, 1.0),
                                                                  child: fadeTransition),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    } else if (item == "delete") {
                                                      FirebaseFirestore.instance
                                                          .collection('arduino')
                                                          .doc("arduinoProjects")
                                                          .collection("projects")
                                                          .doc(data["id"]).delete();
                                                    }
                                                  },
                                                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                                    const PopupMenuItem(
                                                      value: "edit",
                                                      child: Text('Edit'),
                                                    ),
                                                    const PopupMenuItem(
                                                      value: "delete",
                                                      child: Text('Delete'),
                                                    ),
                                                  ],
                                                )
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  FirebaseFirestore.instance
                                      .collection("arduino")
                                      .doc("arduinoBoards")
                                      .collection("Board")
                                      .doc(data["id"]) // Replace "documentId" with the ID of the document you want to retrieve
                                      .get()
                                      .then((DocumentSnapshot snapshot) async {
                                    if (snapshot.exists) {
                                      var data = snapshot.data();
                                      if (data != null &&
                                          data is Map<String, dynamic>) {
                                        List<String> images = [];
                                        images = data['images']
                                            .toString()
                                            .split(";");
                                        images.addAll(data['pinOut']
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
                                                  id: data["id"],
                                                  heading: data["name"],
                                                  description: data['description'],
                                                  photoUrl: data["images"],
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
                            }
                            else Container();
                          });
                    },
                  ),
                  Padding(
                    padding:  EdgeInsets.all(Size*8.0),
                    child: Text(
                      "Raspberry Pi",
                      style: TextStyle(fontSize:Size* 22, color: Colors.white),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('raspberrypi')
                        .doc("raspberrypiBoard")
                        .collection("Boards")
                        .snapshots(),
                    builder: (context, snapshots) {
                      return (snapshots.connectionState ==
                          ConnectionState.waiting)
                          ? const Center(
                        child: CircularProgressIndicator(),
                      )
                          : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshots.data!.docs.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var data = snapshots.data!.docs[index]
                                .data() as Map<String, dynamic>;
                            if (data["photoUrl"].split(";").first.length > 3) {
                              final Uri uri = Uri.parse(data["photoUrl"].split(";").first);
                              final String fileName = uri.pathSegments.last;
                              var name = fileName.split("/").last;
                              file = File("$folderPath/${data["id"]}/$name");

                            }
                            if (name.isEmpty) {
                              return InkWell(
                                child: Padding(
                                  padding:  EdgeInsets.all(Size*3.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                              Color.fromRGBO(
                                                  174,
                                                  228,
                                                  242,
                                                  0.3)),
                                          color: Colors.black38,
                                          borderRadius:
                                           BorderRadius
                                              .all(
                                              Radius.circular(
                                                  Size*15)),
                                          image: DecorationImage(
                                            image: FileImage(file),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        height: Size*60,
                                        width: Size*100,
                                      ),
                                      Expanded(
                                          child: Padding(
                                            padding:
                                             EdgeInsets
                                                .all(Size*8.0),
                                            child: Text(
                                              data["name"],
                                              style: TextStyle(
                                                  fontSize: Size*19,
                                                  color:
                                                  Colors.white),
                                              maxLines: 2,
                                              overflow: TextOverflow
                                                  .ellipsis,
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  FirebaseFirestore.instance
                                      .collection('raspberrypi')
                                      .doc("raspberrypiBoard")
                                      .collection("Boards")
                                      .doc(data["id"]) // Replace "documentId" with the ID of the document you want to retrieve
                                      .get()
                                      .then((DocumentSnapshot snapshot) async {
                                    if (snapshot.exists) {
                                      var data = snapshot.data();
                                      if (data != null &&
                                          data is Map<String, dynamic>) {
                                        List<String> images = [];
                                        if (data["photoUrl"].isNotEmpty) {
                                          images = data["photoUrl"].split(";");
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
                                                  id: data['id'],
                                                  heading: data['name'],
                                                  description: data['description'],
                                                  photoUrl: data['photoUrl'],
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
                            }
                            if (data['name']
                                .toString()
                                .toLowerCase()
                                .startsWith(name.toLowerCase())) {
                              return InkWell(
                                child: Padding(
                                  padding:  EdgeInsets.all(Size*3.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                              Color.fromRGBO(
                                                  174,
                                                  228,
                                                  242,
                                                  0.3)),
                                          color: Colors.black38,
                                          borderRadius:
                                          BorderRadius
                                              .all(
                                              Radius.circular(
                                                  Size*15)),
                                          image: DecorationImage(
                                            image: FileImage(file),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        height: Size*60,
                                        width: Size*100,
                                      ),
                                      Expanded(
                                          child: Padding(
                                            padding:
                                            EdgeInsets
                                                .all(Size*8.0),
                                            child: Text(
                                              data["name"],
                                              style: TextStyle(
                                                  fontSize: Size*19,
                                                  color:
                                                  Colors.white),
                                              maxLines: 2,
                                              overflow: TextOverflow
                                                  .ellipsis,
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  FirebaseFirestore.instance
                                      .collection('raspberrypi')
                                      .doc("raspberrypiBoard")
                                      .collection("Boards")
                                      .doc(data["id"]) // Replace "documentId" with the ID of the document you want to retrieve
                                      .get()
                                      .then((DocumentSnapshot snapshot) async {
                                    if (snapshot.exists) {
                                      var data = snapshot.data();
                                      if (data != null &&
                                          data is Map<String, dynamic>) {
                                        List<String> images = [];
                                        if (data["photoUrl"].isNotEmpty) {
                                          images = data["photoUrl"].split(";");
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
                                                  id: data['id'],
                                                  heading: data['name'],
                                                  description: data['description'],
                                                  photoUrl: data['photoUrl'],
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
                            }
                            return Container();
                          });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(Size*8.0),
                    child: Text(
                      "DIY Electronic Project",
                      style: TextStyle(fontSize: Size*22, color: Colors.white),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('electronicProjects')
                        .snapshots(),
                    builder: (context, snapshots) {
                      return (snapshots.connectionState ==
                          ConnectionState.waiting)
                          ? const Center(
                        child: CircularProgressIndicator(),
                      )
                          : ListView.builder(
                          itemCount: snapshots.data!.docs.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var data = snapshots.data!.docs[index]
                                .data() as Map<String, dynamic>;
                            List<String> tagsList = data["tags"].toString().split(";").map((tag) => tag.trim()).toList();
                            bool tags = false;
                            for (String x in tagsList) {
                              if (x.toLowerCase().startsWith(name.toLowerCase().trim())) {
                                tags = true; // Set to true if any tag starts with the specified name
                                break;
                              }
                            }
                            if (data["images"].split(";").first.length > 3) {
                              final Uri uri = Uri.parse(data["images"].split(";").first);
                              final String fileName = uri.pathSegments.last;
                              var name = fileName.split("/").last;
                              file = File("$folderPath/${data["id"]}/$name");

                            }
                            if (name.isEmpty) {
                              return InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:Colors.white30),
                                          color: Colors.black38,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(Size*15)),
                                          image: DecorationImage(
                                            image: FileImage(file),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        height: Size*60,
                                        width: Size*100,
                                      ),
                                      Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                    EdgeInsets
                                                        .all(Size*8.0),
                                                    child: Text(
                                                      data["heading"].toString().split(";").first,
                                                      style: TextStyle(
                                                          fontSize: Size*19,
                                                          color:
                                                          Colors.white),
                                                      maxLines: 2,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                    ),
                                                  ),
                                                  Wrap(
                                                    direction: Axis.horizontal,
                                                    children: data["tags"].toString().split(";")
                                                        .map(
                                                          (text) => Padding(
                                                        padding:  EdgeInsets.only(right: Size*5),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(Size*10),
                                                              border: Border.all(color: Colors.white24)),
                                                          padding: EdgeInsets.symmetric(
                                                              vertical: Size*2, horizontal:Size* 6),
                                                          child: Text(
                                                            text,
                                                            style: TextStyle(color: Colors.white,fontSize: Size*15),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                        .toList(),
                                                  ),
                                                ],
                                              ),
                                              if(isUser())
                                                PopupMenuButton(
                                                  icon: Icon(
                                                    Icons.more_vert,
                                                    color: Colors.white,
                                                    size:  25,
                                                  ),
                                                  // Callback that sets the selected popup menu item.
                                                  onSelected: (item) {
                                                    if (item == "edit") {
                                                      Navigator.push(
                                                        context,
                                                        PageRouteBuilder(
                                                          transitionDuration:
                                                          const Duration(milliseconds: 300),
                                                          pageBuilder:
                                                              (context, animation, secondaryAnimation) =>
                                                              electronicProjectsCreator(

                                                                tags: data["tags"],
                                                                videoUrl: data["youtubeLink"],

                                                                requiredComponents: data['requiredComponents'],
                                                                toolsRequired: data['toolsRequired'],
                                                                projectId: data['id'],
                                                                heading: data['heading'],
                                                                description: data['description'],
                                                                photoUrl: data['images'],
                                                                tableOfContent: data['tableOfContent'],
                                                              ),
                                                          transitionsBuilder: (context, animation,
                                                              secondaryAnimation, child) {
                                                            final fadeTransition = FadeTransition(
                                                              opacity: animation,
                                                              child: child,
                                                            );

                                                            return Container(
                                                              color:
                                                              Colors.black.withOpacity(animation.value),
                                                              child: AnimatedOpacity(
                                                                  duration: Duration(milliseconds: 300),
                                                                  opacity: animation.value.clamp(0.3, 1.0),
                                                                  child: fadeTransition),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    } else if (item == "delete") {
                                                      FirebaseFirestore.instance
                                                          .collection("electronicProjects")
                                                          .doc(data["id"]).delete();
                                                    }
                                                  },
                                                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                                    const PopupMenuItem(
                                                      value: "edit",
                                                      child: Text('Edit'),
                                                    ),
                                                    const PopupMenuItem(
                                                      value: "delete",
                                                      child: Text('Delete'),
                                                    ),
                                                  ],
                                                )
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                                onTap: () async {
                                  List<String> images = [];
                                  if (data["images"].isNotEmpty)images = data["images"].split(";");


                                  await showDialog(
                                    context: context,
                                    builder: (context) => ImageDownloadScreen(
                                      images: images,
                                      id: data["id"],
                                    ),
                                  );


                                  FirebaseFirestore.instance
                                      .collection("electronicProjects")
                                      .doc(data["id"])
                                      .update({"views": data["views"] + 1});
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration:
                                      const Duration(milliseconds: 300),
                                      pageBuilder:
                                          (context, animation, secondaryAnimation) =>
                                          electronicProject(
                                            likes:data['likedBy'], comments: data["comments"],
                                            tags: data["tags"].split(";"),
                                            youtubeUrl: data["youtubeLink"],
                                            views: data["views"],
                                            requiredComponents: data['requiredComponents'],
                                            toolsRequired: data['toolsRequired'],
                                            id: data['id'],
                                            heading: data['heading'],
                                            description: data['description'],
                                            photoUrl: data['images'],

                                            tableOfContent: data['tableOfContent'],
                                          ),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        final fadeTransition = FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );

                                        return Container(
                                          color:
                                          Colors.black.withOpacity(animation.value),
                                          child: AnimatedOpacity(
                                              duration: Duration(milliseconds: 300),
                                              opacity: animation.value.clamp(0.3, 1.0),
                                              child: fadeTransition),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                            if (data['heading']
                                .toString().split(";").first
                                .toLowerCase()
                                .startsWith(name.toLowerCase())||data['heading']
                                .toString().split(";").last
                                .toLowerCase()
                                .startsWith(name.toLowerCase())||tags) {
                              return InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:Colors.white30),
                                          color: Colors.black38,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(Size*15)),
                                          image: DecorationImage(
                                            image: FileImage(file),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        height: Size*60,
                                        width: Size*100,
                                      ),
                                      Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                    EdgeInsets
                                                        .all(Size*8.0),
                                                    child: Text(
                                                      data["heading"].toString().split(";").first,
                                                      style: TextStyle(
                                                          fontSize: Size*19,
                                                          color:
                                                          Colors.white),
                                                      maxLines: 2,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                    ),
                                                  ),
                                                  Wrap(
                                                    direction: Axis.horizontal,
                                                    children: data["tags"].toString().split(";")
                                                        .map(
                                                          (text) => Padding(
                                                        padding:  EdgeInsets.only(right: Size*5),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(Size*10),
                                                              border: Border.all(color: Colors.white24)),
                                                          padding: EdgeInsets.symmetric(
                                                              vertical: Size*2, horizontal:Size* 6),
                                                          child: Text(
                                                            text,
                                                            style: TextStyle(color: Colors.white,fontSize: Size*15),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                        .toList(),
                                                  ),
                                                ],
                                              ),
                                              if(isUser())
                                                PopupMenuButton(
                                                  icon: Icon(
                                                    Icons.more_vert,
                                                    color: Colors.white,
                                                    size:  25,
                                                  ),
                                                  // Callback that sets the selected popup menu item.
                                                  onSelected: (item) {
                                                    if (item == "edit") {
                                                      Navigator.push(
                                                        context,
                                                        PageRouteBuilder(
                                                          transitionDuration:
                                                          const Duration(milliseconds: 300),
                                                          pageBuilder:
                                                              (context, animation, secondaryAnimation) =>
                                                              electronicProjectsCreator(

                                                                tags: data["tags"],
                                                                videoUrl: data["youtubeLink"],

                                                                requiredComponents: data['requiredComponents'],
                                                                toolsRequired: data['toolsRequired'],
                                                                projectId: data['id'],
                                                                heading: data['heading'],
                                                                description: data['description'],
                                                                photoUrl: data['images'],
                                                                tableOfContent: data['tableOfContent'],
                                                              ),
                                                          transitionsBuilder: (context, animation,
                                                              secondaryAnimation, child) {
                                                            final fadeTransition = FadeTransition(
                                                              opacity: animation,
                                                              child: child,
                                                            );

                                                            return Container(
                                                              color:
                                                              Colors.black.withOpacity(animation.value),
                                                              child: AnimatedOpacity(
                                                                  duration: Duration(milliseconds: 300),
                                                                  opacity: animation.value.clamp(0.3, 1.0),
                                                                  child: fadeTransition),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    } else if (item == "delete") {
                                                      FirebaseFirestore.instance
                                                          .collection("electronicProjects")
                                                          .doc(data["id"]).delete();
                                                    }
                                                  },
                                                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                                    const PopupMenuItem(
                                                      value: "edit",
                                                      child: Text('Edit'),
                                                    ),
                                                    const PopupMenuItem(
                                                      value: "delete",
                                                      child: Text('Delete'),
                                                    ),
                                                  ],
                                                )
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                                onTap: () async {
                                  List<String> images = [];
                                  if (data["images"].isNotEmpty)images = data["images"].split(";");


                                    await showDialog(
                                    context: context,
                                    builder: (context) => ImageDownloadScreen(
                                      images: images,
                                      id: data["id"],
                                    ),
                                    );


                                  FirebaseFirestore.instance
                                      .collection("electronicProjects")
                                      .doc(data["id"])
                                      .update({"views": data["views"] + 1});
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration:
                                      const Duration(milliseconds: 300),
                                      pageBuilder:
                                          (context, animation, secondaryAnimation) =>
                                          electronicProject(
                                            likes:data['likedBy'], comments: data["comments"],
                                            tags: data["tags"].split(";"),
                                            youtubeUrl: data["youtubeLink"],
                                            views: data["views"],
                                            requiredComponents: data['requiredComponents'],
                                            toolsRequired: data['toolsRequired'],
                                            id: data['id'],
                                            heading: data['heading'],
                                            description: data['description'],
                                            photoUrl: data['images'],

                                            tableOfContent: data['tableOfContent'],
                                          ),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        final fadeTransition = FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );

                                        return Container(
                                          color:
                                          Colors.black.withOpacity(animation.value),
                                          child: AnimatedOpacity(
                                              duration: Duration(milliseconds: 300),
                                              opacity: animation.value.clamp(0.3, 1.0),
                                              child: fadeTransition),
                                        );
                                      },
                                    ),
                                  );
                                  },
                              );
                            }
                            return Container();
                          });
                    },
                  ),
                  Padding(
                    padding:  EdgeInsets.all(Size*8.0),
                    child: Text(
                      "Sensors",
                      style: TextStyle(fontSize: Size*22, color: Colors.white),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('sensors')
                        .snapshots(),
                    builder: (context, snapshots) {
                      return (snapshots.connectionState ==
                              ConnectionState.waiting)
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              itemCount: snapshots.data!.docs.length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var data = snapshots.data!.docs[index]
                                    .data() as Map<String, dynamic>;
                                if (data["photoUrl"].split(";").first.length > 3) {
                                  final Uri uri = Uri.parse(data["photoUrl"].split(";").first);
                                  final String fileName = uri.pathSegments.last;
                                  var name = fileName.split("/").last;
                                  file = File("$folderPath/${data["id"]}/$name");

                                }
                                if (name.isEmpty) {
                                  return InkWell(
                                    child: Padding(
                                      padding:  EdgeInsets.all(Size*3.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      Color.fromRGBO(
                                                          174,
                                                          228,
                                                          242,
                                                          0.3)),
                                              color: Colors.black38,
                                              borderRadius:
                                                   BorderRadius
                                                      .all(
                                                      Radius.circular(
                                                          Size* 15)),
                                              image: DecorationImage(
                                                image: FileImage(file),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            height:Size* 70,
                                            width:Size* 110,
                                          ),
                                          Expanded(
                                              child: Padding(
                                                padding:
                                                     EdgeInsets
                                                        .all(Size*8.0),
                                                child: Text(
                                                  data["name"],
                                                  style: TextStyle(
                                                      fontSize:Size* 20,
                                                      color:
                                                          Colors.white),
                                                  maxLines: 2,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      FirebaseFirestore.instance
                                          .collection("sensors")
                                          .doc(data["id"]) // Replace "documentId" with the ID of the document you want to retrieve
                                          .get()
                                          .then((DocumentSnapshot snapshot) async {
                                        if (snapshot.exists) {
                                          var data = snapshot.data();
                                          if (data != null &&
                                              data is Map<String, dynamic>) {
                                            List<String> images = [];
                                            images = data["photoUrl"].split(";");
                                            images.addAll(
                                                data['pinDiagram'].toString().split(";"));
                                            if (!kIsWeb) {
                                              await showDialog(
                                                context: context,
                                                builder: (context) => ImageDownloadScreen(
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
                                                    sensor(
                                                      pinDiagram: data['pinDiagram'],
                                                      id: data["id"],
                                                      name: data["name"],
                                                      description: data['description'],
                                                      photoUrl: data["photoUrl"],
                                                      pinConnection: data['pinConnection'],
                                                      technicalParameters:
                                                      data['technicalParameters'],
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
                                }
                                if (data['name']
                                    .toString()
                                    .toLowerCase()
                                    .startsWith(name.toLowerCase())) {
                                  return InkWell(
                                    child: Padding(
                                      padding:  EdgeInsets.all(Size*3.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                  Color.fromRGBO(
                                                      174,
                                                      228,
                                                      242,
                                                      0.3)),
                                              color: Colors.black38,
                                              borderRadius:
                                              BorderRadius
                                                  .all(
                                                  Radius.circular(
                                                      Size* 15)),
                                              image: DecorationImage(
                                                image: FileImage(file),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            height:Size* 70,
                                            width:Size* 110,
                                          ),
                                          Expanded(
                                              child: Padding(
                                                padding:
                                                EdgeInsets
                                                    .all(Size*8.0),
                                                child: Text(
                                                  data["name"],
                                                  style: TextStyle(
                                                      fontSize:Size* 20,
                                                      color:
                                                      Colors.white),
                                                  maxLines: 2,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      FirebaseFirestore.instance
                                          .collection("sensors")
                                          .doc(data["id"]) // Replace "documentId" with the ID of the document you want to retrieve
                                          .get()
                                          .then((DocumentSnapshot snapshot) async {
                                        if (snapshot.exists) {
                                          var data = snapshot.data();
                                          if (data != null &&
                                              data is Map<String, dynamic>) {
                                            List<String> images = [];
                                            images = data["photoUrl"].split(";");
                                            images.addAll(
                                                data['pinDiagram'].toString().split(";"));
                                            if (!kIsWeb) {
                                              await showDialog(
                                                context: context,
                                                builder: (context) => ImageDownloadScreen(
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
                                                    sensor(
                                                      pinDiagram: data['pinDiagram'],
                                                      id: data["id"],
                                                      name: data["name"],
                                                      description: data['description'],
                                                      photoUrl: data["photoUrl"],
                                                      pinConnection: data['pinConnection'],
                                                      technicalParameters:
                                                      data['technicalParameters'],
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
                                }
                                return Container();
                              });
                    },
                  ),
                  SizedBox(height: Size*150)
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
