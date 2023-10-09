// ignore_for_file: non_constant_identifier_names, camel_case_types, must_be_immutable, prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables
import 'dart:async';
import 'dart:io';

import 'dart:math';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:ns_ideas/authPage.dart';
import 'electronicProjects.dart';
import 'raspberrypi.dart';
import 'searchBar.dart';
import 'sensors.dart';
import 'arduino.dart';
import 'commonFunctions.dart';
import 'functions.dart';
import 'settings.dart';
import 'package:path_provider/path_provider.dart';

class backGroundImage extends StatefulWidget {
  Widget child;
  backGroundImage({required this.child});
  @override
  State<backGroundImage> createState() => _backGroundImageState();
}

class _backGroundImageState extends State<backGroundImage> {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.75),
        body: SafeArea(
          child: widget.child,
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List searchList = ["Search About", "Arduino", "Raspberry Pi", "Sensors"];

  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return DefaultTabController(
      length: 5, // Number of tabs
      child: backGroundImage(
        child: NestedScrollView(
          // floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              collapsedHeight: 100,
              expandedHeight: 100,
              toolbarHeight: 100,
              backgroundColor: Colors.transparent,
              flexibleSpace: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: InkWell(
                            onTap: () {
                              ExternalLaunchUrl(
                                  "https://www.youtube.com/@NSIdeas");
                            },
                            child: SizedBox(
                              height: 20,
                              width: 100,
                              child: Image.asset("assets/logo.png"),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 6,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(milliseconds: 300),
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const searchBar(),
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
                                          duration: Duration(milliseconds: 300),
                                          opacity:
                                              animation.value.clamp(0.3, 1.0),
                                          child: fadeTransition),
                                    );
                                  },
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: Size * 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white30,
                                  borderRadius:
                                      BorderRadius.circular(Size * 15),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Size * 5),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.search,
                                        color: Colors.white,
                                        size: Size * 25,
                                      ),
                                      SizedBox(width: Size * 3),
                                      Flexible(
                                        child: CarouselSlider(
                                          items: List.generate(
                                            searchList.length,
                                            (int index) {
                                              return Center(
                                                child: Text(
                                                  searchList[index],
                                                  style: TextStyle(
                                                    fontSize: Size * 19.0,
                                                    color: Color.fromRGBO(
                                                        192, 237, 252, 1),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          //Slider Container properties
                                          options: CarouselOptions(
                                            scrollDirection: Axis.vertical,
                                            // Set the axis to vertical
                                            viewportFraction: 0.95,
                                            disableCenter: true,
                                            enlargeCenterPage: true,
                                            height: Size * 40,
                                            autoPlayAnimationDuration:
                                                const Duration(seconds: 3),
                                            autoPlay: true,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: InkWell(
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: Size * 25,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(milliseconds: 300),
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const settings(),
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
                                          duration: Duration(milliseconds: 300),
                                          opacity:
                                              animation.value.clamp(0.3, 1.0),
                                          child: fadeTransition),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        height: 25,
                        child: TabBar(
                          dividerColor: Colors.transparent,
                          isScrollable: true,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF0e1c26),
                                  Color(0xFF2a454b),
                                  Color(0xFF243748),
                                  Color(0xFF0e1c26),
                                ]),
                          ),
                          labelColor: Colors.white,
                          labelPadding:
                              EdgeInsets.symmetric(horizontal: Size * 10),
                          labelStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: Size * 16),
                          unselectedLabelColor: Colors.white54,
                          tabs: [
                            Tab(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  " All ",
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "Arduino",
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Raspberry Pi",
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Electronic Projects",
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Sensors",
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              floating: true,
              primary: true,
              snap: false,
            ),
          ],
          body: TabBarView(
            children: [
              all(),
              arduinoAndProjects(),
              raspberrypiBoards(),
              electronicProjects(),
              sensorsAndComponents()
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerForProjectsShowing extends StatefulWidget {
  ProjectsConvertor data;
  final String c0;
  final String d0;
  final String c1;

  ContainerForProjectsShowing(
      {required this.data,
      required this.c0,
      required this.d0,
      required this.c1});

  @override
  State<ContainerForProjectsShowing> createState() =>
      _ContainerForProjectsShowingState();
}

class _ContainerForProjectsShowingState
    extends State<ContainerForProjectsShowing> {
  String folderPath = "";
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
    if (widget.data.photoUrl.split(";").first.length > 3) {
      final Uri uri = Uri.parse(widget.data.photoUrl.split(";").first);
      final String fileName = uri.pathSegments.last;
      var name = fileName.split("/").last;
      file = File("$folderPath/${widget.data.id}/$name");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return Padding(
      padding: EdgeInsets.all(Size * 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Size * 13),
            border: Border.all(color: Colors.white54)),
        child: Padding(
          padding: EdgeInsets.all(Size * 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: Size * 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.file(
                        file,
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              Text(
                widget.data.heading.split(";").last,
                style: TextStyle(color: Colors.white, fontSize: Size * 30),
              ),
              Row(
                children: [
                  Text(
                    " ${widget.data.likedBy.length + 1} Likes",
                    style: TextStyle(color: Colors.white, fontSize: Size * 13),
                  ),
                  Text(
                    "   ${widget.data.comments} Comments  ",
                    style: TextStyle(color: Colors.white, fontSize: Size * 13),
                  ),
                  Text(
                    "${widget.data.views} Views ",
                    style: TextStyle(color: Colors.white, fontSize: Size * 13),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class all extends StatefulWidget {
  const all({super.key});

  @override
  State<all> createState() => _allState();
}

class _allState extends State<all> {
  String folderPath = "";
  File file = File("");

  @override
  void initState() {
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
      child: Padding(
        padding: EdgeInsets.all(Size * 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Padding(
            //   padding:  EdgeInsets.only(bottom: Size*10),
            //   child: Text(
            //     "Arduino",
            //     style: HeadingsTextStyle,
            //   ),
            // ),
            // StreamBuilder<List<arduinoBoardsConvertor>>(
            //   stream: readarduinoBoards(),
            //   builder: (context, snapshot) {
            //     final Subjects = snapshot.data;
            //     switch (snapshot.connectionState) {
            //       case ConnectionState.waiting:
            //         return const Center(
            //             child: CircularProgressIndicator(
            //           strokeWidth: 0.3,
            //           color: Colors.cyan,
            //         ));
            //       default:
            //         if (snapshot.hasError) {
            //           return const Text("Error with server");
            //         } else {
            //           return GridView.builder(
            //             physics: const BouncingScrollPhysics(),
            //             itemCount: Subjects!.length,
            //             padding: EdgeInsets.symmetric(horizontal: Size * 8),
            //             shrinkWrap: true,
            //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //               crossAxisCount:
            //                   2, // Adjust the number of columns as needed
            //               crossAxisSpacing: 10,
            //
            //               childAspectRatio: 16 / 10,
            //             ),
            //             itemBuilder: (BuildContext context, int index) {
            //               final SubjectsData = Subjects[index];
            //               if (SubjectsData.images.split(";").first.length > 3) {
            //                 final Uri uri = Uri.parse(SubjectsData.images.split(";").first);
            //                 final String fileName = uri.pathSegments.last;
            //                 var name = fileName.split("/").last;
            //                  file = File("${folderPath}/${SubjectsData.id}/$name");
            //
            //               }
            //               return InkWell(
            //                 child: Container(
            //                   decoration: BoxDecoration(
            //                     color: Colors.black38,
            //                     borderRadius:
            //                          BorderRadius.all(Radius.circular(Size * 15)),
            //                     image: DecorationImage(
            //                       image: FileImage(file),
            //                       fit: BoxFit.cover,
            //                     ),
            //                   ),
            //                   child: Align(
            //                     alignment: Alignment.bottomLeft,
            //                     child: Padding(
            //                       padding:  EdgeInsets.all(Size*5.0),
            //                       child: Container(
            //                         decoration: BoxDecoration(
            //                           color: Colors.black.withOpacity(0.6),
            //                           borderRadius: BorderRadius.circular(Size * 15),
            //                         ),
            //                         child: Padding(
            //                           padding:  EdgeInsets.all(Size * 8.0),
            //                           child: Text(
            //                             SubjectsData.name.split(";").first,
            //                             style:  TextStyle(
            //                               fontSize:Size *  20.0,
            //                               color: Colors.tealAccent,
            //                               fontWeight: FontWeight.w600,
            //                             ),
            //                             maxLines: 1,
            //                             overflow: TextOverflow.ellipsis,
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //                 onTap: () {
            //                   FirebaseFirestore.instance
            //                       .collection("arduino")
            //                       .doc("arduinoBoards")
            //                       .collection("Board")
            //                       .doc(SubjectsData
            //                           .id) // Replace "documentId" with the ID of the document you want to retrieve
            //                       .get()
            //                       .then((DocumentSnapshot snapshot) async {
            //                     if (snapshot.exists) {
            //                       var data = snapshot.data();
            //                       if (data != null &&
            //                           data is Map<String, dynamic>) {
            //                         List<String> images = [];
            //                         images =
            //                             data['images'].toString().split(";");
            //                         images.addAll(
            //                             data['pinOut'].toString().split(";"));
            //
            //                         if (!kIsWeb) {
            //                           await showDialog(
            //                             context: context,
            //                             builder: (context) => ImageDownloadScreen(
            //                               images: images,
            //                               id: data['id'],
            //                             ),
            //                           );
            //                         }
            //
            //                         Navigator.push(
            //                           context,
            //                           PageRouteBuilder(
            //                             transitionDuration:
            //                                 const Duration(milliseconds: 300),
            //                             pageBuilder: (context, animation,
            //                                     secondaryAnimation) =>
            //                                 arduinoBoard(
            //                               pinDiagram: data['pinOut'],
            //                               id: SubjectsData.id,
            //                               heading: SubjectsData.name,
            //                               description: data['description'],
            //                               photoUrl: SubjectsData.images,
            //                             ),
            //                             transitionsBuilder: (context, animation,
            //                                 secondaryAnimation, child) {
            //                               final fadeTransition = FadeTransition(
            //                                 opacity: animation,
            //                                 child: child,
            //                               );
            //
            //                               return Container(
            //                                 color: Colors.black
            //                                     .withOpacity(animation.value),
            //                                 child: AnimatedOpacity(
            //                                     duration:
            //                                         Duration(milliseconds: 300),
            //                                     opacity: animation.value
            //                                         .clamp(0.3, 1.0),
            //                                     child: fadeTransition),
            //                               );
            //                             },
            //                           ),
            //                         );
            //                       }
            //                     } else {
            //                       print("Document does not exist.");
            //                     }
            //                   }).catchError((error) {
            //                     print(
            //                         "An error occurred while retrieving data: $error");
            //                   });
            //                 },
            //               );
            //             },
            //           );
            //         }
            //     }
            //   },
            // ),
            StreamBuilder<List<ProjectsConvertor>>(
                stream: readProjectsConvertor(
                    true, "arduino", "arduinoProjects", "projects"),
                builder: (context, snapshot) {
                  final Books = snapshot.data;
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(
                          child: CircularProgressIndicator(
                        strokeWidth: 0.3,
                        color: Colors.cyan,
                      ));
                    default:
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text(
                                'Error with TextBooks Data or\n Check Internet Connection'));
                      } else {
                        if (Books!.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(Size * 8.0),
                              child: Text(
                                "Arduino Projects are not available",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: Size * 30, bottom: Size * 15),
                                child: Text(
                                  "Arduino Projects",
                                  style: HeadingsTextStyle,
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),

                                itemCount: min(3, Books.length),
                                // Display the top 6 trending books or less if there are fewer than 6 books in total
                                itemBuilder: (BuildContext context, int index) {
                                  // Sort the Books list based on a combined score of likes and views in descending order
                                  final sortedBooks = Books
                                    ..sort((a, b) => (b.likedBy.length +
                                            b.views)
                                        .compareTo(a.likedBy.length + a.views));

                                  // Retrieve the data for the current item from the sortedBooks list using the index
                                  final SubjectsData = sortedBooks[index];

                                  // Check if the index is within the bounds of the list and if the book has at least one like
                                  if (index < sortedBooks.length &&
                                      SubjectsData.likedBy.length >= 0) {
                                    return DetailsContainer(
                                      mode: true,
                                      c0: "arduino",
                                      d0: "arduinoProjects",
                                      c1: "projects",
                                      data: SubjectsData,
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: Size * 30, bottom: Size * 15),
                                child: Text(
                                  "Arduino Projects",
                                  style: HeadingsTextStyle,
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: min(2, Books.reversed.length),
                                itemBuilder: (BuildContext context, int index) {
                                  final SubjectsData =
                                      Books.reversed.toList()[index];
                                  return DetailsContainer(
                                    mode: true,
                                    c0: "arduino",
                                    d0: "arduinoProjects",
                                    c1: "projects",
                                    data: SubjectsData,
                                  );
                                },
                              ),
                            ],
                          );
                        }
                      }
                  }
                }),
            // Padding(
            //   padding:  EdgeInsets.only(top: Size*30,bottom: Size*15),
            //   child: Text(
            //     "Raspberry Pi",
            //     style: HeadingsTextStyle,
            //   ),
            // ),
            // StreamBuilder<List<raspiBoardsConvertor>>(
            //   stream: readraspiBoards(),
            //   builder: (context, snapshot) {
            //     final Subjects = snapshot.data;
            //     switch (snapshot.connectionState) {
            //       case ConnectionState.waiting:
            //         return const Center(
            //             child: CircularProgressIndicator(
            //           strokeWidth: 0.3,
            //           color: Colors.cyan,
            //         ));
            //       default:
            //         if (snapshot.hasError) {
            //           return const Text("Error with server");
            //         } else {
            //           return Padding(
            //             padding:  EdgeInsets.symmetric(horizontal: Size * 8),
            //             child: GridView.builder(
            //               physics: const BouncingScrollPhysics(),
            //               itemCount: Subjects!.length,
            //               shrinkWrap: true,
            //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //                 crossAxisCount:
            //                     2, // Adjust the number of items per row as needed
            //                 crossAxisSpacing: 10,
            //                 childAspectRatio: 16 / 7,
            //               ),
            //               itemBuilder: (BuildContext context, int index) {
            //                 final SubjectsData = Subjects[index];
            //                 if (SubjectsData.photoUrl.split(";").first.length > 3) {
            //                   final Uri uri = Uri.parse(SubjectsData.photoUrl.split(";").first);
            //                   final String fileName = uri.pathSegments.last;
            //                   var name = fileName.split("/").last;
            //                   file = File("$folderPath/${SubjectsData.id}/$name");
            //
            //                 }
            //                 return InkWell(
            //                   child: Container(
            //                     decoration: BoxDecoration(
            //                       color: Colors.black38,
            //                       borderRadius:
            //                            BorderRadius.all(Radius.circular(Size * 15)),
            //                       image: DecorationImage(
            //                         image: FileImage(file),
            //                         fit: BoxFit.cover,
            //                       ),
            //                     ),
            //                     child: Align(
            //                       alignment: Alignment.bottomLeft,
            //                       child: Container(
            //                         decoration: BoxDecoration(
            //                           color: Colors.black.withOpacity(0.6),
            //                           borderRadius: BorderRadius.circular(Size * 15),
            //                         ),
            //                         child: Padding(
            //                           padding:  EdgeInsets.all(Size * 8.0),
            //                           child: Text(
            //                             SubjectsData.name.split(";").first,
            //                             style:  TextStyle(
            //                               fontSize:Size *  20.0,
            //                               color: Colors.tealAccent,
            //                               fontWeight: FontWeight.w600,
            //                             ),
            //                             maxLines: 1,
            //                             overflow: TextOverflow.ellipsis,
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                   onTap: () {
            //                     FirebaseFirestore.instance
            //                         .collection('raspberrypi')
            //                         .doc("raspberrypiBoard")
            //                         .collection("Boards")
            //                         .doc(SubjectsData
            //                             .id) // Replace "documentId" with the ID of the document you want to retrieve
            //                         .get()
            //                         .then((DocumentSnapshot snapshot) async {
            //                       if (snapshot.exists) {
            //                         var data = snapshot.data();
            //                         if (data != null &&
            //                             data is Map<String, dynamic>) {
            //                           List<String> images = [];
            //                           if (SubjectsData.photoUrl.isNotEmpty) {
            //                             images = SubjectsData.photoUrl.split(";");
            //                           }
            //                           if (data['pinDiagram']
            //                               .toString()
            //                               .isNotEmpty) {
            //                             images.addAll(data['pinDiagram']
            //                                 .toString()
            //                                 .split(";"));
            //                           }
            //
            //                           if (!kIsWeb) {
            //                             await showDialog(
            //                               context: context,
            //                               builder: (context) =>
            //                                   ImageDownloadScreen(
            //                                 images: images,
            //                                 id: data['id'],
            //                               ),
            //                             );
            //                           }
            //
            //                           Navigator.push(
            //                             context,
            //                             PageRouteBuilder(
            //                               transitionDuration:
            //                                   const Duration(milliseconds: 300),
            //                               pageBuilder: (context, animation,
            //                                       secondaryAnimation) =>
            //                                   raspberrypiBoard(
            //                                 pinDiagram: data['pinDiagram'],
            //                                 id: SubjectsData.id,
            //                                 heading: SubjectsData.name,
            //                                 description: data['description'],
            //                                 photoUrl: SubjectsData.photoUrl,
            //                               ),
            //                               transitionsBuilder: (context, animation,
            //                                   secondaryAnimation, child) {
            //                                 final fadeTransition = FadeTransition(
            //                                   opacity: animation,
            //                                   child: child,
            //                                 );
            //
            //                                 return Container(
            //                                   color: Colors.black
            //                                       .withOpacity(animation.value),
            //                                   child: AnimatedOpacity(
            //                                       duration:
            //                                           Duration(milliseconds: 300),
            //                                       opacity: animation.value
            //                                           .clamp(0.3, 1.0),
            //                                       child: fadeTransition),
            //                                 );
            //                               },
            //                             ),
            //                           );
            //                         }
            //                       } else {
            //                         print("Document does not exist.");
            //                       }
            //                     }).catchError((error) {
            //                       print(
            //                           "An error occurred while retrieving data: $error");
            //                     });
            //                   },
            //                 );
            //               },
            //             ),
            //           );
            //         }
            //     }
            //   },
            // ),
            Padding(
              padding: EdgeInsets.only(top: Size * 30, bottom: Size * 15),
              child: Text(
                "Electronic Projects",
                style: HeadingsTextStyle,
              ),
            ),
            StreamBuilder<List<ProjectsConvertor>>(
              stream:
                  readProjectsConvertor(false, "electronicProjects", "", ""),
              builder: (context, snapshot) {
                final Books = snapshot.data;
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 0.3,
                      color: Colors.cyan,
                    ));
                  default:
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text(
                              'Error with TextBooks Data or\n Check Internet Connection'));
                    } else {
                      if (Books!.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(Size * 8.0),
                            child: Text(
                              "Other Projects are not available",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: min(3, Books.length),
                              itemBuilder: (BuildContext context, int index) {
                                final sortedBooks = Books
                                  ..sort((a, b) => (b.likedBy.length + b.views)
                                      .compareTo(a.likedBy.length + a.views));

                                final SubjectsData = sortedBooks[index];

                                if (index < sortedBooks.length &&
                                    SubjectsData.likedBy.length >= 0) {
                                  return DetailsContainer(
                                    mode: false,
                                    c0: "electronicProjects",
                                    d0: "",
                                    c1: "",
                                    data: SubjectsData,
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: min(1, Books.reversed.length),
                              itemBuilder: (BuildContext context, int index) {
                                final sortedBooks = Books.reversed.toList();
                                final SubjectsData = sortedBooks[index];
                                return DetailsContainer(
                                  mode: false,
                                  c0: "electronicProjects",
                                  d0: "",
                                  c1: "",
                                  data: SubjectsData,
                                );
                              },
                            )
                          ],
                        );
                      }
                    }
                }
              },
            ),
            // Padding(
            //   padding: EdgeInsets.only(top: Size * 30, bottom: Size * 15),
            //   child: Text(
            //     "Sensors",
            //     style: HeadingsTextStyle,
            //   ),
            // ),
            // StreamBuilder<List<sensorsConvertor>>(
            //   stream: readsensors(),
            //   builder: (context, snapshot) {
            //     final Subjects = snapshot.data;
            //     switch (snapshot.connectionState) {
            //       case ConnectionState.waiting:
            //         return const Center(
            //             child: CircularProgressIndicator(
            //           strokeWidth: 0.3,
            //           color: Colors.cyan,
            //         ));
            //       default:
            //         if (snapshot.hasError) {
            //           return const Text("Error with server");
            //         } else {
            //           return Padding(
            //             padding: EdgeInsets.all(Size * 8.0),
            //             child: GridView.builder(
            //               physics: NeverScrollableScrollPhysics(),
            //               itemCount: Subjects!.length,
            //               shrinkWrap: true,
            //               gridDelegate:
            //                   SliverGridDelegateWithFixedCrossAxisCount(
            //                 crossAxisCount:
            //                     2, // Adjust the number of columns as needed
            //                 crossAxisSpacing: 3,
            //                 mainAxisSpacing: 3,
            //                 childAspectRatio: 15 / 9,
            //               ),
            //               itemBuilder: (BuildContext context, int index) {
            //                 final SubjectsData = Subjects[index];
            //                 if (SubjectsData.photoUrl.split(";").first.length >
            //                     3) {
            //                   final Uri uri = Uri.parse(
            //                       SubjectsData.photoUrl.split(";").first);
            //                   final String fileName = uri.pathSegments.last;
            //                   var name = fileName.split("/").last;
            //                   file =
            //                       File("$folderPath/${SubjectsData.id}/$name");
            //                 }
            //                 return InkWell(
            //                   child: Container(
            //                     decoration: BoxDecoration(
            //                       border: Border.all(
            //                           color: const Color.fromRGBO(
            //                               174, 228, 242, 0.3)),
            //                       color: Colors.black38,
            //                       borderRadius: BorderRadius.all(
            //                           Radius.circular(Size * 15)),
            //                       image: DecorationImage(
            //                         image: FileImage(file),
            //                         fit: BoxFit.cover,
            //                       ),
            //                     ),
            //                     height: Size * 100,
            //                     width: Size * 110,
            //                   ),
            //                   onTap: () {
            //                     FirebaseFirestore.instance
            //                         .collection("sensors")
            //                         .doc(SubjectsData
            //                             .id) // Replace "documentId" with the ID of the document you want to retrieve
            //                         .get()
            //                         .then((DocumentSnapshot snapshot) async {
            //                       if (snapshot.exists) {
            //                         var data = snapshot.data();
            //                         if (data != null &&
            //                             data is Map<String, dynamic>) {
            //                           List<String> images = [];
            //                           images = SubjectsData.photoUrl.split(";");
            //                           images.addAll(data['pinDiagram']
            //                               .toString()
            //                               .split(";"));
            //                           if (!kIsWeb) {
            //                             await showDialog(
            //                               context: context,
            //                               builder: (context) =>
            //                                   ImageDownloadScreen(
            //                                 images: images,
            //                                 id: data['id'],
            //                               ),
            //                             );
            //                           }
            //
            //                           Navigator.push(
            //                             context,
            //                             PageRouteBuilder(
            //                               transitionDuration:
            //                                   const Duration(milliseconds: 300),
            //                               pageBuilder: (context, animation,
            //                                       secondaryAnimation) =>
            //                                   sensor(
            //                                 pinDiagram: data['pinDiagram'],
            //                                 id: SubjectsData.id,
            //                                 name: SubjectsData.name,
            //                                 description: data['description'],
            //                                 photoUrl: SubjectsData.photoUrl,
            //                                 pinConnection:
            //                                     data['pinConnection'],
            //                                 technicalParameters:
            //                                     data['technicalParameters'],
            //                               ),
            //                               transitionsBuilder: (context,
            //                                   animation,
            //                                   secondaryAnimation,
            //                                   child) {
            //                                 final fadeTransition =
            //                                     FadeTransition(
            //                                   opacity: animation,
            //                                   child: child,
            //                                 );
            //
            //                                 return Container(
            //                                   color: Colors.black
            //                                       .withOpacity(animation.value),
            //                                   child: AnimatedOpacity(
            //                                       duration: Duration(
            //                                           milliseconds: 300),
            //                                       opacity: animation.value
            //                                           .clamp(0.3, 1.0),
            //                                       child: fadeTransition),
            //                                 );
            //                               },
            //                             ),
            //                           );
            //                         }
            //                       } else {
            //                         print("Document does not exist.");
            //                       }
            //                     }).catchError((error) {
            //                       print(
            //                           "An error occurred while retrieving data: $error");
            //                     });
            //                   },
            //                 );
            //               },
            //             ),
            //           );
            //         }
            //     }
            //   },
            // ),
            SizedBox(
              height: Size * 50,
            )
          ],
        ),
      ),
    );
  }
}

class DetailsContainer extends StatefulWidget {
  bool mode;
  String c0, d0, c1;
  ProjectsConvertor data;

  DetailsContainer(
      {Key? key,
      required this.data,
      required this.mode,
      required this.c0,
      required this.d0,
      required this.c1})
      : super(key: key);

  @override
  State<DetailsContainer> createState() => _DetailsContainerState();
}

class _DetailsContainerState extends State<DetailsContainer> {
  bool isHovered = false;
  String folderPath = "";
  File file = File("");
  File file1 = File("");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPath();
  }

  getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    folderPath = directory.path;
    if (widget.data.photoUrl.split(";").first.length > 3) {
      final Uri uri = Uri.parse(widget.data.photoUrl.split(";").first);
      final String fileName = uri.pathSegments.last;
      var name = fileName.split("/").last;
      file = File("$folderPath/${widget.data.id}/$name");
    }
    if (widget.data.photoUrl.split(";").last.length > 3) {
      final Uri uri = Uri.parse(widget.data.photoUrl.split(";").last);
      final String fileName = uri.pathSegments.last;
      var name = fileName.split("/").last;
      file1 = File("$folderPath/${widget.data.id}/$name");
    }
    setState(() {
      file1;
      file;
    });
  }

  void onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    double Size = size(context);

    return MouseRegion(
      onEnter: (_) => onEntered(true),
      onExit: (_) => onEntered(false),
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.only(left: Size * 10),
          child: AnimatedContainer(
            height: Size * 200,
            width: isHovered ? Size * 350 : Size * 300,
            duration: Duration(milliseconds: 200),
            child: Stack(children: [
              if (isHovered)
                Padding(
                  padding: EdgeInsets.only(bottom: Size * 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Size * 15),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.file(
                            file1,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 3),
                            child: Container(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (!isHovered)
                Padding(
                  padding: EdgeInsets.only(bottom: Size * 10),
                  child: Container(
                    height: Size * 200,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        border: Border.all(color: Colors.white30),
                        borderRadius: BorderRadius.circular(Size * 15)),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Size * 15),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Center(
                                child: Text(
                                  'Arduino',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.03),
                                    fontSize: Size * 60,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.white.withOpacity(0.2),
                                        blurRadius: 2,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (isHovered)
                AnimatedWidgetContainer(
                  isTrue: widget.mode,
                  data: widget.data,
                ),
              if (!isHovered)
                AnimatedPositioned(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    bottom: Size * 22,
                    left: Size * 10,
                    child: Container(
                      height: Size * 25,
                      width: Size * 290,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(Size * 8.0)),
                      ),
                      child: Marquee(
                        text: widget.data.heading.split(";").first.isNotEmpty
                            ? widget.data.heading.split(";").first
                            : "No Name",
                        style: TextStyle(
                          color: isHovered ? Colors.amber : Colors.white,
                          fontSize: Size * 20,
                          fontWeight: FontWeight.w400,
                          shadows: [
                            Shadow(
                              color: Colors.grey,
                              offset: Offset(0, 0),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        blankSpace: 200.0,
                        velocity: 50.0,
                        pauseAfterRound: Duration(seconds: 1),
                        startPadding: 0.0,
                        accelerationDuration: Duration(seconds: 1),
                        accelerationCurve: Curves.linear,
                        decelerationDuration: Duration(milliseconds: 500),
                        decelerationCurve: Curves.easeOut,
                      ),
                    )),
              Positioned(
                bottom: Size * -20,
                right: Size * 40,
                child: Transform.translate(
                  offset: Offset(20, -20),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.white54),
                        borderRadius: BorderRadius.circular(Size * 13)),
                    padding: EdgeInsets.all(Size * 3),
                    child: InkWell(
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: widget.data.likedBy.contains(fullUserId())
                                ? Colors.redAccent
                                : Colors.white,
                            size: Size * 15,
                          ),
                          Text(
                            widget.data.likedBy.length > 0
                                ? " ${widget.data.likedBy.length}+ "
                                : " ${widget.data.likedBy.length} ",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      onTap: () {
                        like(
                            widget.mode,
                            widget.c0,
                            widget.d0,
                            widget.c1,
                            !widget.data.likedBy.contains(fullUserId()),
                            widget.data.id);
                      },
                    ),
                  ),
                ),
              ),
              if (!isHovered)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(Size * 15.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.data.tags.split(";").length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: Size * 2),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(Size * 8),
                                        border:
                                            Border.all(color: Colors.white24)),
                                    padding: EdgeInsets.symmetric(
                                        vertical: Size * 2,
                                        horizontal: Size * 5),
                                    child: Text(
                                      widget.data.tags.split(";")[index],
                                      style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: Size * 13),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )),
                  ),
                ),
              Align(
                  alignment: Alignment.topRight,
                  child: AnimatedContainer(
                      duration: Duration(milliseconds: 400),
                      height: isHovered ? Size * 110 : Size * 155,
                      child: Padding(
                        padding: EdgeInsets.all(Size * 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Size * 10),
                          child: Image.file(file),
                        ),
                      ))),
            ]),
          ),
        ),
        onTap: () {
          setState(() {
            isHovered = isHovered ? false : true;
          });
        },
      ),
    );
  }
}

void like(
    bool mode, String c0, String d0, String c1, bool isAdd, String updateId) {
  mode
      ? FirebaseFirestore.instance
          .collection(c0)
          .doc(d0)
          .collection(c1)
          .doc(updateId)
          .update({
          "likedBy": isAdd
              ? FieldValue.arrayUnion([fullUserId()])
              : FieldValue.arrayRemove([fullUserId()]),
        })
      : FirebaseFirestore.instance.collection(c0).doc(updateId).update({
          "likedBy": isAdd
              ? FieldValue.arrayUnion([fullUserId()])
              : FieldValue.arrayRemove([fullUserId()]),
        });
}

class AnimatedWidgetContainer extends StatefulWidget {
  ProjectsConvertor data;
  bool isTrue;

  AnimatedWidgetContainer({Key? key, required this.data, required this.isTrue})
      : super(key: key);

  @override
  _AnimatedWidgetContainerState createState() =>
      _AnimatedWidgetContainerState();
}

class _AnimatedWidgetContainerState extends State<AnimatedWidgetContainer> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  bool isAnimating = false;
  late Timer timer;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 100), (_) {
      if (!isAnimating) {
        startAnimation();
      }
    });
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void startAnimation() {
    setState(() {
      isAnimating = true;
      currentIndex = (currentIndex + 1) % 3;
    });
    _animationController.reset();
    _animationController.forward().whenComplete(() {
      setState(() {
        isAnimating = false;
        currentIndex = (currentIndex + 1) % 3;
        if (currentIndex == 3 - 1) {
          timer.cancel(); // Stop the timer when animation is completed
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    List<Widget> texts = [
      Row(
        children: [
          Row(
            children: [
              Icon(
                Icons.circle,
                size: Size * 7,
              ),
              Text(
                " NSIdeas",
                style:
                    TextStyle(fontSize: Size * 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          if (widget.data.youtubeUrl.isNotEmpty)
            InkWell(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Size * 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 7,
                    ),
                    Text(
                      " YouTube",
                      style: TextStyle(
                          fontSize: Size * 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ],
                ),
              ),
              onTap: () {},
            ),
          Row(
            children: [
              Icon(
                Icons.circle,
                size: Size * 5,
              ),
              Text(
                "${widget.data.views} Views",
                style: TextStyle(
                    fontSize: Size * 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ],
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: Size * 5),
        child: Row(
          children: [
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Size * 15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Size * 15),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5,
                    ),
                    child: Row(
                      children: [
                        Container(
                          color: Colors.black.withOpacity(0.4),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Size * 8, vertical: Size * 2),
                            child: Text(
                              "View",
                              style: TextStyle(
                                  fontSize: Size * 20, color: Colors.white),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.open_in_new,
                          color: Colors.black,
                          size: Size * 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              onTap: () async {
                List<String> images = [];
                if (widget.data.photoUrl.isNotEmpty)
                  images = widget.data.photoUrl.split(";");
                if (widget.isTrue) {
                  FirebaseFirestore.instance
                      .collection("arduino")
                      .doc("arduinoProjects")
                      .collection("projects")
                      .doc(widget.data
                          .id) // Replace "documentId" with the ID of the document you want to retrieve
                      .get()
                      .then((DocumentSnapshot snapshot) async {
                    if (snapshot.exists) {
                      var data = snapshot.data();
                      if (data != null && data is Map<String, dynamic>) {
                        if (!kIsWeb) {
                          List<String> images = [];
                          if (data['images'].toString().isNotEmpty)
                            images = data['images'].toString().split(";");
                          await FirebaseFirestore.instance
                              .collection("arduino")
                              .doc("arduinoProjects")
                              .collection("projects")
                              .doc(widget.data.id)
                              .collection(
                                  "description") // Replace "photos" with your actual collection name
                              .get()
                              .then((QuerySnapshot snapshot) {
                            if (snapshot.size > 0) {
                              snapshot.docs
                                  .forEach((DocumentSnapshot document) {
                                var data = document.data();
                                if (data != null &&
                                    data is Map<String, dynamic>) {
                                  if (data['images'].toString().isNotEmpty)
                                    images.addAll(
                                        data['images'].toString().split(";"));
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
                            .doc(widget.data.id)
                            .update({"views": widget.data.views + 1});

                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 300),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    arduinoProject(
                              appsAndPlatforms: data["appsAndPlatforms"],
                              comments: data["comments"],
                              youtubeUrl: widget.data.youtubeUrl,
                              id: data['id'],
                              heading: data['heading'],
                              description: data['description'],
                              photoUrl: data['images'],
                              tags: data['tags'].toString().split(";"),
                              tableOfContent: data['tableOfContent'],
                              views: 0,
                              componentsAndSupplies:
                                  data['componentsAndSupplies'],
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
                      }
                    } else {
                      print("Document does not exist.");
                    }
                  }).catchError((error) {
                    print("An error occurred while retrieving data: $error");
                  });
                } else {
                  if (!kIsWeb) {
                    await showDialog(
                      context: context,
                      builder: (context) => ImageDownloadScreen(
                        images: images,
                        id: widget.data.id,
                      ),
                    );
                  }

                  FirebaseFirestore.instance
                      .collection("electronicProjects")
                      .doc(widget.data.id)
                      .update({"views": widget.data.views + 1});
                  FirebaseFirestore.instance
                      .collection("electronicProjects")
                      .doc(widget.data
                          .id) // Replace "documentId" with the ID of the document you want to retrieve
                      .get()
                      .then((DocumentSnapshot snapshot) async {
                    if (snapshot.exists) {
                      var data = snapshot.data();
                      if (data != null && data is Map<String, dynamic>) {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 300),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    electronicProject(
                              comments: data["comments"],
                              likes: data['likedBy'],
                              tags: widget.data.tags.split(";"),
                              youtubeUrl: widget.data.youtubeUrl,
                              views: widget.data.views,
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
                      }
                    } else {
                      print("Document does not exist.");
                    }
                  }).catchError((error) {
                    print("An error occurred while retrieving data: $error");
                  });
                }
              },
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 10),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(15),
            //     ),
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(15),
            //       child: BackdropFilter(
            //         filter: ImageFilter.blur(
            //           sigmaX: 5,
            //           sigmaY: 5,
            //         ),
            //         child: Row(
            //           children: [
            //             Container(
            //               color: Colors.black.withOpacity(0.4),
            //               child: Padding(
            //                 padding: const EdgeInsets.symmetric(
            //                     horizontal: 8, vertical: 2),
            //                 child: Text(
            //                   "Save",
            //                   style:
            //                       TextStyle(fontSize: 20, color: Colors.white),
            //                 ),
            //               ),
            //             ),
            //             Icon(
            //               Icons.library_add_check_outlined,
            //               color: Colors.black,
            //               size: 20,
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(15),
            //   ),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(15),
            //     child: BackdropFilter(
            //       filter: ImageFilter.blur(
            //         sigmaX: 5,
            //         sigmaY: 5,
            //       ),
            //       child: Row(
            //         children: [
            //           Container(
            //             color: Colors.black.withOpacity(0.4),
            //             child: Padding(
            //               padding: const EdgeInsets.symmetric(
            //                   horizontal: 8, vertical: 2),
            //               child: Text(
            //                 "Save",
            //                 style: TextStyle(fontSize: 20, color: Colors.white),
            //               ),
            //             ),
            //           ),
            //           Icon(
            //             Icons.read_more,
            //             color: Colors.black,
            //             size: 20,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      Text(
        widget.data.heading.split(";").last,
        style: TextStyle(fontSize: Size * 18, fontWeight: FontWeight.w500),
      )
    ];
    return Padding(
      padding: EdgeInsets.only(bottom: Size * 15),
      child: Padding(
        padding: EdgeInsets.only(bottom: Size * 8, left: Size * 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: List.generate(texts.length, (index) {
            final isVisible = index <= currentIndex;
            return SlideTransition(
              position: _slideAnimation,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: isVisible ? 1.0 : 0.0,
                child: texts[index],
              ),
            );
          }),
        ),
      ),
    );
  }
}
