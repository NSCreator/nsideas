// ignore_for_file: camel_case_types, must_be_immutable, non_constant_identifier_names, import_of_legacy_library_into_null_safe, prefer_const_constructors, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:marquee/marquee.dart';
import 'settings.dart';
import 'commonFunctions.dart';
import 'electronicProjects.dart';
import 'functions.dart';
import 'homepage.dart';


class arduinoAndProjects extends StatefulWidget {
  const arduinoAndProjects({super.key});

  @override
  State<arduinoAndProjects> createState() => _arduinoAndProjectsState();
}

class _arduinoAndProjectsState extends State<arduinoAndProjects> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Boards",
              style: TextStyle(color: Colors.white, fontSize: 40),
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
                      height: 140,
                      child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: Subjects!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            final SubjectsData = Subjects[index];
                            return InkWell(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: SizedBox(
                                      height: 140,
                                      child: AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: Container(
                                            decoration: BoxDecoration(
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
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Container(
                                                width: double.infinity,
                                                // height: 50,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  15),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  15)),
                                                  gradient: LinearGradient(
                                                      begin: Alignment.topRight,
                                                      end: Alignment.bottomLeft,
                                                      colors: [
                                                        Colors.black12,
                                                        Colors.black38,
                                                        Colors.black54
                                                      ]),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    SubjectsData.name,
                                                    style: const TextStyle(
                                                      fontSize: 28.0,
                                                      color: Colors.tealAccent,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            )),
                                      ),
                                    ),
                                  ),
                                  if (Subjects.length - index == 1)
                                    SizedBox(
                                      width: 80,
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
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 10,
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
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Projects",
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
          ),
          arduinoTagsFilter(),
          SizedBox(
            height: 150,
          )
        ],
      ),
    );
  }
}

class arduinoTagsFilter extends StatefulWidget {
  const arduinoTagsFilter({super.key});

  @override
  State<arduinoTagsFilter> createState() => _arduinoTagsFilterState();
}

class _arduinoTagsFilterState extends State<arduinoTagsFilter> {
  String data = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: getBoardStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Map<String, dynamic>> boardList = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Tags :",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              height: 28,
                              child: Row(
                                children: [
                                  InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: AnimatedBorder(
                                        text: "All",
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        data = "";
                                      });
                                    },
                                  ),
                                  ListView.builder(
                                    itemCount: boardList.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> boardData =
                                          boardList[index];
                                      showToastText("${boardList.length}");
                                      return InkWell(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: AnimatedBorder(
                                            text: boardData["tag"],
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            data = boardData["tag"];
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text(
                'Error retrieving board list',
                style: TextStyle(color: Colors.white),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        StreamBuilder<List<ProjectsConvertor>>(
          stream: readProjectsConvertor(true,"arduino","arduinoProjects","projects"),
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
                  return data.isNotEmpty
                      ? AnimationLimiter(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: Subjects!.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              final SubjectsData = Subjects[index];
                              return SubjectsData.heading == data
                                  ? AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 375),
                                      child: SlideAnimation(
                                        verticalOffset: 50.0,
                                        child: FadeInAnimation(
                                          child: InkWell(
                                            child:ContainerForProjectsShowing(data: SubjectsData, c0: 'arduino',d0: "arduinoProjects",c1: "projects"),
                                            onTap: () {
                                              FirebaseFirestore.instance
                                                  .collection("arduino").doc("arduinoProjects").collection("projects")
                                                  .doc(SubjectsData.id) // Replace "documentId" with the ID of the document you want to retrieve
                                                  .get()
                                                  .then((DocumentSnapshot snapshot) async {
                                                if (snapshot.exists) {
                                                  var data = snapshot.data();
                                                  if (data != null && data is Map<String, dynamic>) {

                                                    FirebaseFirestore.instance
                                                        .collection("arduino").doc("arduinoProjects").collection("projects")
                                                        .doc(SubjectsData.id)
                                                        .update({
                                                      "views": SubjectsData.views+ 1
                                                    });
                                                    showToastText("+1 view");
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => arduinoProject(
                                                              youtubeUrl: SubjectsData.youtubeUrl,

                                                              id: data['id'],
                                                              heading: data['heading'],
                                                              description: data['description'],
                                                              photoUrl: data['photoUrl'],
                                                              creator: data['creator'], tags: [], views: 0, tableOfContent: '',


                                                            )));
                                                  }
                                                } else {
                                                  print("Document does not exist.");
                                                }
                                              }).catchError((error) {
                                                print("An error occurred while retrieving data: $error");
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container();
                            },
                          ),
                        )
                      : AnimationLimiter(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: Subjects!.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              final SubjectsData = Subjects[index];
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: InkWell(
                                      child:ContainerForProjectsShowing(data: SubjectsData, c0: 'arduino', d0: 'arduinoProjects', c1: 'projects',),
                                      onTap: () {
                                        FirebaseFirestore.instance
                                            .collection("arduino").doc("arduinoProjects").collection("projects")
                                            .doc(SubjectsData.id) // Replace "documentId" with the ID of the document you want to retrieve
                                            .get()
                                            .then((DocumentSnapshot snapshot) async {
                                          if (snapshot.exists) {
                                            var data = snapshot.data();
                                            if (data != null && data is Map<String, dynamic>) {

                                              FirebaseFirestore.instance
                                                  .collection("arduino").doc("arduinoProjects").collection("projects")
                                                  .doc(SubjectsData.id)
                                                  .update({
                                                "views": SubjectsData.views+ 1
                                              });
                                              showToastText("+1 view");
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => arduinoProject(
                                                        youtubeUrl: SubjectsData.youtubeUrl,

                                                        id: data['id'],
                                                        heading: data['heading'],
                                                        description: data['description'],
                                                        photoUrl: data['photoUrl'],
                                                        creator: data['creator'], tags: [], views: 0, tableOfContent: '',

                                                      )));
                                            }
                                          } else {
                                            print("Document does not exist.");
                                          }
                                        }).catchError((error) {
                                          print("An error occurred while retrieving data: $error");
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                }
            }
          },
        ),
      ],
    );
  }
}

class AnimatedBorder extends StatefulWidget {
  String text;
  AnimatedBorder({Key? key, required this.text}) : super(key: key);
  @override
  _AnimatedBorderState createState() => _AnimatedBorderState();
}

class _AnimatedBorderState extends State<AnimatedBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Adjust the duration as needed
    );

    _colorAnimation = ColorTween(
      begin: Colors.red, // Initial color
      end: Colors.blue, // Final color
    ).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CustomPaint(
            painter: BorderPainter(color: _colorAnimation.value),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        child: Text(
          widget.text,
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  final Color? color;

  BorderPainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(15)))
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) {
    return oldDelegate.color != color;
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

Future createarduinoBoards(
    {required String name,
    required String description,
    required String photoUrl,
    required String mainFeatures,
    required String pinDiagram}) async {
  final docflash = FirebaseFirestore.instance
      .collection('arduino')
      .doc("arduinoBoards")
      .collection("Board")
      .doc();
  final flash = arduinoBoardsConvertor(
      id: docflash.id,
      name: name,
      photoUrl: photoUrl,
  );
  final json = flash.toJson();
  await docflash.set(json);
}

class arduinoBoardsConvertor {
  String id;
  final String name,photoUrl;

  arduinoBoardsConvertor(
      {this.id = "",
      required this.name,
      required this.photoUrl,
      });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "photoUrl": photoUrl,
      };

  static arduinoBoardsConvertor fromJson(Map<String, dynamic> json) =>
      arduinoBoardsConvertor(
          id: json['id'],
          name: json["name"],
          photoUrl: json["photoUrl"],
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
    return backGroundImage(
        child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                border: Border.all(color: Colors.white12),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.photoUrl.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 5),
                      child: InkWell(
                        child:scrollingImages(images: widget.photoUrl.split(";"), typeOfProject: "arduinoBoards", id: widget.id),
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
                                            typeOfProject: 'arduinoBoards', id:widget.id,
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
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                  Container(
                    height: 0.5,
                    width: double.infinity,
                    color: Colors.white24,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        height: 2,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                        child: StyledTextWidget(text: "              ${widget.description}",fontSize: 16,fontWeight: FontWeight.w300,),

                      ),
                    ],
                  )

                ],
              ),
            ),
          ),
          Description(c0: 'arduino', d0: 'arduinoBoards', c1: 'Board', d1: widget.id, typeOfProject: 'arduinoBoards',),
          if (widget.pinDiagram.isNotEmpty)
            Padding(
              padding:
              EdgeInsets.only(left: 10, top: 20, bottom: 10),
              child: Text(
                "Pin Diagram",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
          scrollingImages(images: widget.pinDiagram.split(";"), typeOfProject: "arduinoBoards", id: widget.id),
          Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "---${widget.heading}---",
                  style:
                  const TextStyle(fontSize: 10, color: Colors.white),
                ),
              )),
        ],
      ),
    ));
  }
}


class arduinoProject extends StatefulWidget {
  String id, heading, description, photoUrl, youtubeUrl, creator,tableOfContent;
  int views;
  List tags;

  arduinoProject(
      {Key? key,
      required this.id,
      required this.tags,
      required this.heading,
      required this.views,
      required this.tableOfContent,
      this.creator = "",
      required this.description,
      required this.photoUrl,
      required this.youtubeUrl})
      : super(key: key);

  @override
  State<arduinoProject> createState() => _arduinoProjectState();
}

class _arduinoProjectState extends State<arduinoProject> {

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return backGroundImage(
        child: CustomScrollView(
      physics: BouncingScrollPhysics(
      ),
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
                      // onTap: () {
                      //   showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return Scaffold(
                      //         backgroundColor: Colors.transparent,
                      //         body: Padding(
                      //           padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 20),
                      //           child: ClipRRect(
                      //             borderRadius: BorderRadius.circular(20),
                      //             child: BackdropFilter(
                      //               filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      //
                      //               child: Container(
                      //                 width: double.infinity,
                      //                 height: double.infinity,
                      //                 decoration: BoxDecoration(
                      //                     color: Colors.black.withOpacity(0.5),
                      //                     border: Border.all(color: Colors.white24),
                      //                     borderRadius: BorderRadius.circular(20)
                      //                 ),
                      //                 child: Column(
                      //                   children: [
                      //                     Text("Comments",style: TextStyle(color: Colors.white,fontSize: 30),),
                      //
                      //                     Padding(
                      //                       padding: const EdgeInsets.symmetric(horizontal: 5),
                      //                       child: Row(
                      //                         children: [
                      //                           Flexible(
                      //                             child: Padding(
                      //                               padding: const EdgeInsets.only(left: 20),
                      //                               child: TextFormField(
                      //                                 controller: _comment,
                      //                                 textInputAction: TextInputAction.next,
                      //                                 keyboardType: TextInputType.multiline,
                      //                                 style: TextStyle(color: Colors.white),
                      //                                 maxLines: null, // Allows the field to expand as needed
                      //                                 decoration: const InputDecoration(
                      //                                   hintStyle: TextStyle(color: Colors.white60),
                      //                                   border: InputBorder.none,
                      //                                   hintText: 'Comment Here',
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                           ),
                      //                           InkWell(
                      //                             child: Padding(
                      //                               padding: const EdgeInsets.all(5.0),
                      //                               child: Icon(Icons.send,color: Colors.lightBlueAccent,),
                      //                             ),
                      //                             onTap: ()async{
                      //                               await addComment("electronicProjects",widget.id,true,_comment.text);
                      //                               Navigator.pop(context);
                      //                               getComments();
                      //                               _comment.clear();
                      //                             },
                      //                           )
                      //                         ],
                      //                       ),
                      //                     ),
                      //                     Expanded(
                      //                       child: ListView.builder(
                      //                         shrinkWrap: true,
                      //                         physics: BouncingScrollPhysics(),
                      //                         padding: EdgeInsets.symmetric(horizontal: 10),
                      //                         itemCount: comments.length,
                      //                         itemBuilder: (BuildContext context, int index) {
                      //                           String data = comments[index];
                      //                           String user = data.split(";").first;
                      //                           String comment = data.split(";").last;
                      //                           return Padding(
                      //                             padding: const EdgeInsets.symmetric(vertical: 5),
                      //                             child: Row(
                      //                               children: [
                      //                                 Container(
                      //                                   decoration: BoxDecoration(
                      //                                       borderRadius: BorderRadius.circular(30),
                      //                                       border: Border.all(color: Colors.white54)
                      //                                   ),
                      //                                   child:  Padding(
                      //                                     padding: const EdgeInsets.all(3.0),
                      //                                     child: Text(user.split(":").first,style: TextStyle(color: Colors.white,fontSize: 20),),
                      //                                   ) ,
                      //                                 ),
                      //                                 SizedBox(width: 10,),
                      //                                 Column(
                      //                                   mainAxisAlignment: MainAxisAlignment.start,
                      //                                   crossAxisAlignment: CrossAxisAlignment.start,
                      //                                   children: [
                      //                                     Text("@${user.split(":").last}",style: TextStyle(color: Colors.white54,fontSize: 13),),
                      //                                     Text(comment,style: TextStyle(color: Colors.white,fontSize: 20),),
                      //
                      //                                   ],
                      //                                 ),
                      //                                 Spacer(),
                      //                                 InkWell(child: Icon(Icons.delete,color: Colors.redAccent,size: 30,),
                      //                                   onTap: (){
                      //                                     addComment("electronicProjects",widget.id,false,data);
                      //                                     Navigator.pop(context);
                      //                                     getComments();
                      //                                   },)
                      //                               ],
                      //                             ),
                      //                           );
                      //                         },
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   );
                      // },
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
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.white24)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.photoUrl.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: InkWell(
                                      child: scrollingImages(images: widget.photoUrl.split(";"), typeOfProject: 'arduinoProjects', id: widget.id,),
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
                                                          typeOfProject: 'arduinoProjects', id:widget.id,
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
                                      padding: const EdgeInsets.only(left: 5,bottom: 5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: Colors.white24)
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: 3,horizontal: 8),
                                        child: Text(text,style: TextStyle(color: Colors.white70),),
                                      ),
                                    ),
                                  )
                                      .toList(),
                                ),
                                Container(
                                  height: 0.5,
                                  width: double.infinity,
                                  color: Colors.white24,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Container(
                                      height: 2,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
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
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.black)
                            ),
                            child: tableOfContent(list: widget.tableOfContent.split(";")),
                          ),
                        ),
                        Description(c0: 'arduino',d0: "arduinoProjects",c1: "projects",d1:widget.id, typeOfProject: 'arduinoProjects',),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8, bottom: 5,top: 10),
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
                                              color: Colors.black,
                                              borderRadius:
                                              BorderRadius.circular(
                                                  15)),
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
                                              color: Colors.black,
                                              borderRadius:
                                              BorderRadius.circular(
                                                  15)),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
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
                                                      BorderRadius.circular(8),
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







                      ],
                    ),
                  ),
                )

            ],
          ),
        ),
      ],
    )
    );
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
      creator: creator,
      photoUrl: photoUrl,
      videoUrl: videoUrl);
  final json = flash.toJson();
  await docflash.set(json);
}

class arduinoProjectsConvertor {
  String id;
  final String heading, description, creator, photoUrl, videoUrl;

  arduinoProjectsConvertor(
      {this.id = "",
      required this.videoUrl,
      required this.heading,
      required this.description,
      required this.creator,
      required this.photoUrl});

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "description": description,
        "creator": creator,
        "photoUrl": photoUrl,
        "videoUrl": videoUrl
      };

  static arduinoProjectsConvertor fromJson(Map<String, dynamic> json) =>
      arduinoProjectsConvertor(
          id: json['id'],
          videoUrl: json["videoUrl"],
          heading: json["heading"],
          description: json["description"],
          creator: json["creator"],
          photoUrl: json["photoUrl"]);
}




Stream<List<arduinoProjectDownloadConvertor>> readarduinoProjectDownload(
        String id) =>
    FirebaseFirestore.instance
        .collection('arduino')
        .doc("arduinoProjects")
        .collection("projects")
        .doc(id)
        .collection("downloads")
        .orderBy("name", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => arduinoProjectDownloadConvertor.fromJson(doc.data()))
            .toList());

Future createarduinoProjectDownload(
    {required String heading,
    required String description,
    required int quantity}) async {
  final docflash =
      FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = arduinoProjectDownloadConvertor(
      id: docflash.id,
      name: heading,
      link: description,
      description: description);
  final json = flash.toJson();
  await docflash.set(json);
}

class arduinoProjectDownloadConvertor {
  String id;
  final String name, link, description;

  arduinoProjectDownloadConvertor(
      {this.id = "",
      required this.name,
      required this.link,
      required this.description});

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "link": link, "description": description};

  static arduinoProjectDownloadConvertor fromJson(Map<String, dynamic> json) =>
      arduinoProjectDownloadConvertor(
          id: json['id'],
          name: json["name"],
          link: json["link"],
          description: json["description"]);
}





