// ignore_for_file: non_constant_identifier_names, camel_case_types, must_be_immutable, prefer_const_constructors, use_build_context_synchronously

import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'electronicProjects.dart';
import 'raspberrypi.dart';
import 'searchBar.dart';
import 'sensors.dart';
import 'textField.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'arduino.dart';
import 'commonFunctions.dart';
import 'functions.dart';
import 'main.dart';
import 'settings.dart';
class backGroundImage extends StatefulWidget {
  Widget child;
  backGroundImage({required this.child});

  @override
  State<backGroundImage> createState() => _backGroundImageState();
}

class _backGroundImageState extends State<backGroundImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/img.png"),
              fit: BoxFit.fill)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.75),
          body: SafeArea(
            child: widget.child,
          ),
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
    return DefaultTabController(
      length: 5, // Number of tabs
      child:backGroundImage(
        child: NestedScrollView(
          // floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              flexibleSpace: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        ExternalLaunchUrl(
                            "https://www.youtube.com/@NSIdeas");
                      },
                      child: SizedBox(height:35,width:105,child: Image.asset("assets/logo.png"),),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                            const Duration(milliseconds: 300),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          width: 210,
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white54),
                          ),
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                SizedBox(width: 3),
                                Flexible(
                                  child: CarouselSlider(
                                    items: List.generate(
                                      searchList.length,
                                          (int index) {
                                        return Center(
                                          child: Text(
                                            searchList[index],
                                            style: TextStyle(
                                              fontSize: 19.0,
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
                                      height: 40,
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
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.white38),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.person,
                            color: Colors.white70,
                            size: 25,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                            const Duration(milliseconds: 300),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
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
                  ],
                ),
              ),
              floating: true,
              primary: true,
              snap: false,
            ),
            SliverAppBar(
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                color: Colors.black,
                height: 45,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TabBar(
                    physics: BouncingScrollPhysics(),
                    isScrollable: true,
                    labelPadding: EdgeInsets.symmetric(
                        horizontal:10,
                    ),
                    labelStyle: TextStyle(
                        color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15
                    ),
                    tabs: [
                      Tab(text: '    All'),
                      Tab(text: 'Arduino & Projects'),
                      Tab(text: 'Raspberry Pi & Projects'),
                      Tab(text: 'electronics & Projects'),
                      Tab(text: 'Sensors & Components    '),
                    ],
                  ),
                ),
              ),
              floating: true,
              primary: true,
              snap: true,
              pinned: true,
            ),
          ],
          body: TabBarView(
            physics: BouncingScrollPhysics(),
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


   ContainerForProjectsShowing({required this.data,required this.c0,required this.d0,required this.c1});

  @override
  State<ContainerForProjectsShowing> createState() =>
      _ContainerForProjectsShowingState();
}

class _ContainerForProjectsShowingState
    extends State<ContainerForProjectsShowing> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 5,vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: Colors.white54)
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: AspectRatio(
                    aspectRatio: 16/9,
                    child: Image.network(
                      widget.data
                          .photoUrl,
                      fit: BoxFit.cover,
                    )

                ),
              ),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white30)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(widget.data
                        .heading.split(";").first,style: TextStyle(color: Colors.white),),
                  )),
              Text(widget.data
                  .heading.split(";").last,style: TextStyle(color: Colors.white,fontSize: 30),),
              Row(
                children: [
                  Text("${widget.data.likedBy.length+1} Likes",style: TextStyle(color: Colors.white,fontSize: 15),),
                  Text("${widget.data.comments}  Comments  ",style: TextStyle(color: Colors.white,fontSize: 15),),
                  Text("${widget.data.views} Views ",style: TextStyle(color: Colors.white,fontSize: 15),),

                ],
              ),
              Row(
                children: [
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(" Edit "),
                        ),
                      ),
                    ),
                    onTap: (){
                      if(widget.d0.isNotEmpty&&widget.c1.isNotEmpty) {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>arduinoProjectCreator(   heading:widget.data.heading,
                       description:widget.data.heading,
                       photoUrl:widget.data.photoUrl,
                       videoUrl:widget.data.youtubeUrl,
                           circuitDiagram:widget.data.diagram,
                           projectId:widget.data.id)));
                      } else {
                        FirebaseFirestore.instance
                          .collection("electronicProjects")
                          .doc(widget.data
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
                                    electronicProjectsCreator(
                                      projectId: widget.data.id,
                                      circuitDiagram: widget.data.diagram,

                                      heading: widget.data.heading,
                                      description: data['description'],
                                     creator: data['creator'],
                                      requiredComponents: data['requiredComponents'],
                                      source: data['source'],
                                      toolsRequired: data['toolsRequired'],
                                      videoUrl: data['videoUrl'],
                                      tags: data['tags'],
                                      tableOfContent: data['tableOfContent'],

                                      photoUrl: widget.data.photoUrl,
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
                      }
                    },
                  ),
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius:
                        BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(" Delete "),
                      ),
                    ),
                    onTap: (){
                      widget.d0.isNotEmpty&&widget.c1.isNotEmpty?FirebaseFirestore.instance.collection(widget.c0).doc(widget.d0).collection(widget.c1).doc(widget.data.id).delete():FirebaseFirestore.instance.collection(widget.c0).doc(widget.data.id).delete();
                    },
                  ),
                ],
              )

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
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Arduino",
              style: HeadingsTextStyle,
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
                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: Subjects!.length,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            3, // Adjust the number of columns as needed
                        crossAxisSpacing: 3,

                        childAspectRatio: 16 / 8,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final SubjectsData = Subjects[index];
                        return InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
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
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    SubjectsData.name.split(" ").last,
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.tealAccent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
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
                                  images =
                                      data['photoUrl'].toString().split(";");
                                  images.addAll(
                                      data['pinDiagram'].toString().split(";"));

                                  if (!kIsWeb) {
                                    await showDialog(
                                      context: context,
                                      builder: (context) => ImageDownloadScreen(
                                        typeOfProject: "arduinoBoards",
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
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
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
                            const Padding(
                              padding:
                                  EdgeInsets.only(left: 10, top: 20, bottom: 8),
                              child: Text(
                                "Arduino Projects",
                                style: HeadingsTextStyle,
                              ),
                            ),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: min(6, Books.length),
                                // Display the top 6 trending books or less if there are fewer than 6 books in total
                                scrollDirection: Axis.horizontal,
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
                            ),
                          ],
                        );
                      }
                    }
                }
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Raspberry Pi",
              style: HeadingsTextStyle,
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: Subjects!.length,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              2, // Adjust the number of items per row as needed
                          crossAxisSpacing: 10,
                          childAspectRatio: 16 / 7,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final SubjectsData = Subjects[index];
                          return InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
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
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Colors.black12,
                                        Colors.black38,
                                        Colors.black54,
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      SubjectsData.name,
                                      style: const TextStyle(
                                        fontSize: 28.0,
                                        color: Colors.tealAccent,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Electronic Projects",
              style: HeadingsTextStyle,
            ),
          ),
          StreamBuilder<List<ProjectsConvertor>>(
            stream: readProjectsConvertor(false, "electronicProjects", "", ""),
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
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Other Projects are not available",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: 200,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: min(6, Books.length),
                          // Display the top 6 trending books or less if there are fewer than 6 books in total
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            // Sort the Books list based on a combined score of likes and views in descending order
                            final sortedBooks = Books
                              ..sort((a, b) => (b.likedBy.length+ b.views)
                                  .compareTo(a.likedBy.length + a.views));

                            // Retrieve the data for the current item from the sortedBooks list using the index
                            final SubjectsData = sortedBooks[index];

                            // Check if the index is within the bounds of the list and if the book has at least one like
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
                      );
                    }
                  }
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Sensors",
              style: HeadingsTextStyle,
            ),
          ),
          StreamBuilder<List<sensorsConvertor>>(
            stream: readsensors(),
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
                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: Subjects!.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            2, // Adjust the number of columns as needed
                        crossAxisSpacing: 3,
                        mainAxisSpacing: 3,
                        childAspectRatio: 15 / 9,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final SubjectsData = Subjects[index];
                        return InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color.fromRGBO(
                                      174, 228, 242, 0.3)),
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
                            height: 100,
                            width: 110,
                          ),
                          onTap: () {
                            FirebaseFirestore.instance
                                .collection("sensors")
                                .doc(SubjectsData
                                    .id) // Replace "documentId" with the ID of the document you want to retrieve
                                .get()
                                .then((DocumentSnapshot snapshot) async {
                              if (snapshot.exists) {
                                var data = snapshot.data();
                                if (data != null &&
                                    data is Map<String, dynamic>) {
                                  List<String> images = [];
                                  images = SubjectsData.photoUrl.split(";");
                                  images.addAll(
                                      data['pinDiagram'].toString().split(";"));
                                  if (!kIsWeb) {
                                    await showDialog(
                                      context: context,
                                      builder: (context) => ImageDownloadScreen(
                                        typeOfProject: "sensors",
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
                                        id: SubjectsData.id,
                                        name: SubjectsData.name,
                                        description: data['description'],
                                        photoUrl: SubjectsData.photoUrl,
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

  @override
  void initState() {
    super.initState();
  }

  void onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onEntered(true),
      onExit: (_) => onEntered(false),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: AnimatedContainer(
            height: 200,
            width: isHovered ? 350 : 300,
            duration: Duration(milliseconds: 200),
            child: Stack(children: [
              if (isHovered)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                              widget.data.diagram.split(";").first,
                              fit: BoxFit.cover, loadingBuilder:
                                  (context, child, loadingProgress) {
                            if (loadingProgress != null) {
                              return CircularProgressIndicator(
                                  value: loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!);
                            }
                            return child;
                          }),
                        ),
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 3),
                            child: Container(
                              color: Colors.black.withOpacity(0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (!isHovered)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        border: Border.all(color: Colors.white30),
                        borderRadius: BorderRadius.circular(15)),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Center(
                                child: Text(
                                  'Arduino',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.03),
                                    fontSize: 60,
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
              Positioned(
                bottom: -20,
                right: 40,
                child: Transform.translate(
                  offset: Offset(20, -20),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.white54),
                        borderRadius: BorderRadius.circular(13)),
                    padding: EdgeInsets.all(3),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          child: Row(
                            children: [
                              Icon(
                                Icons.favorite,
                                color:
                                    widget.data.likedBy.contains(fullUserId())
                                        ? Colors.redAccent
                                        : Colors.white,
                                size: 15,
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
                        SizedBox(width: 3),
                        Icon(
                          Icons.comment,
                          size: 15,
                          color: Colors.white,
                        ),
                        Text(
                          "15+",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (!isHovered)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.data.tags.split(";").length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border:
                                            Border.all(color: Colors.white24)),
                                    padding: EdgeInsets.symmetric(vertical: 2,horizontal: 5),
                                    child: Text(
                                        widget.data.tags.split(";")[index],style: TextStyle(color: Colors.white60,fontSize: 13),),
                                  ),
                                ],
                              ),
                            );
                          },
                        )),
                  ),
                ),
              AnimatedPositioned(
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  bottom: isHovered ? 120 : 22,
                  left: 10,
                  child: Container(
                    height: isHovered ? 35 : 25,
                    width: 290,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Marquee(
                      text: widget.data.heading.split(";").first.isNotEmpty
                          ? widget.data.heading.split(";").first
                          : "No Name",
                      style: TextStyle(
                        color: isHovered ? Colors.deepOrange : Colors.white,
                        fontSize: isHovered ? 35 : 25,
                        fontWeight:
                            isHovered ? FontWeight.bold : FontWeight.w400,
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
              Align(
                  alignment: Alignment.topRight,
                  child: AnimatedContainer(
                      duration: Duration(milliseconds: 400),
                      height: isHovered ? 110 : 155,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(widget.data.photoUrl,
                            loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress != null) {
                            print(loadingProgress.cumulativeBytesLoaded);
                            return CircularProgressIndicator(
                                value: loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!);
                          }
                          return child;
                        }),
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

class _AnimatedWidgetContainerState extends State<AnimatedWidgetContainer>
    with SingleTickerProviderStateMixin {
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
    List<Widget> texts = [
      Row(
        children: [
          Row(
            children: [
              Icon(
                Icons.circle,
                size: 7,
              ),
              Text(
                " NSIdeas",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          if (widget.data.youtubeUrl.isNotEmpty)
            InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 7,
                    ),
                    Text(
                      " YouTube",
                      style: TextStyle(
                          fontSize: 15,
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
                size: 5,
              ),
              Text(
                "${widget.data.views} Views",
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
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
                                horizontal: 8, vertical: 2),
                            child: Text(
                              "View",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.open_in_new,
                          color: Colors.black,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              onTap: () async {

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
                          if (data['photoUrl'].toString().isNotEmpty)
                            images = data['photoUrl'].toString().split(";");
                          await FirebaseFirestore.instance
                              .collection("arduino")
                              .doc("arduinoProjects")
                              .collection("projects")
                              .doc(widget.data.id)
                              .collection("description") // Replace "photos" with your actual collection name
                              .get()
                              .then((QuerySnapshot snapshot) {
                            if (snapshot.size > 0) {
                              snapshot.docs.forEach((DocumentSnapshot document) {
                                var data = document.data();
                                if (data != null && data is Map<String, dynamic>) {

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
                              typeOfProject: "arduinoProjects",
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
                              youtubeUrl: widget.data.youtubeUrl,
                              id: data['id'],
                              heading: data['heading'],
                              description: data['description'],
                              photoUrl: data['photoUrl'],
                              creator: data['creator'],
                              tags: data['tags'].toString().split(";"),
                              tableOfContent: data['tableOfContent'],
                              views: 0,
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
                else {
                  List<String> images = [];
                  if (widget.data.photoUrl.isNotEmpty)images = widget.data.photoUrl.split(";");
                  if (widget.data.diagram.isNotEmpty)images.addAll(widget.data.diagram.split(";"));

                  if (!kIsWeb) {
                    await showDialog(
                      context: context,
                      builder: (context) => ImageDownloadScreen(
                        typeOfProject: "electronicProjects",
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
                                      likes:data['likedBy'],
                              tags: widget.data.tags.split(";"),
                              youtubeUrl: widget.data.youtubeUrl,
                              views: widget.data.views,
                              requiredComponents: data['requiredComponents'],
                              toolsRequired: data['toolsRequired'],
                              circuitDiagram: data['circuitDiagram'],
                              id: data['id'],
                              heading: data['heading'],
                              description: data['description'],
                              photoUrl: data['photoUrl'],
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            child: Text(
                              "Save",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.library_add_check_outlined,
                          color: Colors.black,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          child: Text(
                            "Save",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.read_more,
                        color: Colors.black,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Text(
        widget.data.heading.split(";").last,
        style: TextStyle(
          fontSize: 15,
          shadows: [
            Shadow(
              color: Colors.blueGrey,
              offset: Offset(0, 0),
              blurRadius: 2,
            ),
          ],
        ),
      )
    ];
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 8),
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
