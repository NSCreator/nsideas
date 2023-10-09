// ignore_for_file: prefer_const_literals_to_create_immutables, non_constant_identifier_names, import_of_legacy_library_into_null_safe, camel_case_types, must_be_immutable, prefer_const_constructors, use_build_context_synchronously
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ns_ideas/authPage.dart';
import 'package:ns_ideas/textField.dart';
import 'commonFunctions.dart';
import 'functions.dart';
import 'homepage.dart';

class sensorsAndComponents extends StatefulWidget {
  const sensorsAndComponents({Key? key}) : super(key: key);

  @override
  State<sensorsAndComponents> createState() => _sensorsAndComponentsState();
}

class _sensorsAndComponentsState extends State<sensorsAndComponents> {
  bool isComp = false;
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         "Components",
          //         style: TextStyle(color: Colors.white, fontSize: 40),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(top: 20,right: 10),
          //         child: InkWell(
          //           child: Text(
          //             isComp?"Collapse":"Expand",
          //             style: TextStyle(color: Colors.lightBlueAccent, fontSize: 20),
          //           ),
          //           onTap: (){
          //             setState(() {
          //               isComp = !isComp;
          //             });
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // if(isComp)StreamBuilder<List<electronicComponentsConvertor>>(
          //   stream: readelectronicComponents(),
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
          //           return Text("Error with server");
          //         } else {
          //           return ListView.builder(
          //             physics: const BouncingScrollPhysics(),
          //             itemCount: Subjects!.length,
          //             shrinkWrap: true,
          //             padding: EdgeInsets.only(left: 8, right: 8, bottom: 3),
          //             itemBuilder: (BuildContext context, int index) {
          //               final SubjectsData0 = Subjects[index];
          //               return InkWell(
          //                 child: Container(
          //                   decoration: BoxDecoration(
          //                     border: Border.all(
          //                         color:
          //                             const Color.fromRGBO(174, 228, 242, 0.1)),
          //                     borderRadius:
          //                         const BorderRadius.all(Radius.circular(15)),
          //                     color: Colors.black.withOpacity(0.3),
          //                   ),
          //                   child: Column(
          //                     mainAxisAlignment: MainAxisAlignment.start,
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Row(
          //                         children: [
          //                           Padding(
          //                             padding: const EdgeInsets.all(1.5),
          //                             child: Container(
          //                               decoration: BoxDecoration(
          //                                   borderRadius:
          //                                       const BorderRadius.all(
          //                                           Radius.circular(15)),
          //                                   color:
          //                                       Colors.black.withOpacity(0.5),
          //                                   image: DecorationImage(
          //                                     image: NetworkImage(
          //                                       SubjectsData0.photoUrl,
          //                                     ),
          //                                     fit: BoxFit.cover,
          //                                   )),
          //                               height: 70,
          //                               width: 125,
          //                             ),
          //                           ),
          //                           Expanded(
          //                             child: Padding(
          //                               padding: const EdgeInsets.only(
          //                                   left: 5, top: 5, bottom: 3),
          //                               child: Text(
          //                                 SubjectsData0.name,
          //                                 style: TextStyle(
          //                                     fontSize: 40,
          //                                     color: Colors.white),
          //                               ),
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                       Padding(
          //                         padding: const EdgeInsets.only(
          //                             left: 5, top: 3, bottom: 3, right: 5),
          //                         child: StreamBuilder<
          //                             List<subElectronicComponentsConvertor>>(
          //                           stream: readsubElectronicComponents(
          //                               SubjectsData0.id),
          //                           builder: (context, snapshot) {
          //                             final Subjects = snapshot.data;
          //                             switch (snapshot.connectionState) {
          //                               case ConnectionState.waiting:
          //                                 return const Center(
          //                                     child: CircularProgressIndicator(
          //                                   strokeWidth: 0.3,
          //                                   color: Colors.cyan,
          //                                 ));
          //                               default:
          //                                 if (snapshot.hasError) {
          //                                   return const Text(
          //                                       "Error with server");
          //                                 } else {
          //                                   return Padding(
          //                                     padding: const EdgeInsets.only(
          //                                         left: 20, right: 10),
          //                                     child: ListView.builder(
          //                                       physics:
          //                                           const NeverScrollableScrollPhysics(),
          //                                       itemCount: Subjects!.length,
          //                                       shrinkWrap: true,
          //                                       itemBuilder:
          //                                           (BuildContext context,
          //                                               int index) {
          //                                         final SubjectsData =
          //                                             Subjects[index];
          //                                         return Padding(
          //                                           padding:
          //                                               const EdgeInsets.all(
          //                                                   3.0),
          //                                           child: InkWell(
          //                                             child: Container(
          //                                                 decoration:
          //                                                     BoxDecoration(
          //                                                   borderRadius:
          //                                                       BorderRadius
          //                                                           .all(Radius
          //                                                               .circular(
          //                                                                   15)),
          //                                                   gradient: LinearGradient(
          //                                                       begin: Alignment
          //                                                           .topRight,
          //                                                       end: Alignment
          //                                                           .bottomLeft,
          //                                                       colors: [
          //                                                         Colors
          //                                                             .deepOrange
          //                                                             .withOpacity(
          //                                                                 0.3),
          //                                                         Colors.red
          //                                                             .withOpacity(
          //                                                                 0.3),
          //                                                         Colors
          //                                                             .orangeAccent
          //                                                             .withOpacity(
          //                                                                 0.3)
          //                                                       ]),
          //                                                 ),
          //                                                 child: Padding(
          //                                                   padding:
          //                                                       const EdgeInsets
          //                                                           .all(8.0),
          //                                                   child: Text(
          //                                                     SubjectsData.name,
          //                                                     style: const TextStyle(
          //                                                         fontSize: 25,
          //                                                         fontWeight:
          //                                                             FontWeight
          //                                                                 .bold,
          //                                                         color: Colors
          //                                                             .blue),
          //                                                   ),
          //                                                 )),
          //                                             onTap: () {
          //                                               Navigator.push(
          //                                                   context,
          //                                                   MaterialPageRoute(
          //                                                       builder:
          //                                                           (context) =>
          //                                                               electronicComponent(
          //                                                                 id1: SubjectsData0
          //                                                                     .id,
          //                                                                 pinDiagram:
          //                                                                     SubjectsData.pinDiagram,
          //                                                                 id2: SubjectsData
          //                                                                     .id,
          //                                                                 heading:
          //                                                                     SubjectsData.name,
          //                                                                 photoUrl:
          //                                                                     SubjectsData.photoUrl,
          //                                                               )));
          //                                             },
          //                                           ),
          //                                         );
          //                                       },
          //                                       // separatorBuilder: (context, index) =>const Divider(),
          //                                     ),
          //                                   );
          //                                 }
          //                             }
          //                           },
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //                 onTap: () {},
          //               );
          //             },
          //           );
          //         }
          //     }
          //   },
          // ),
          Padding(
            padding:  EdgeInsets.only(left: Size*15,bottom: Size*15),
            child: Text(
              "Sensors",
              style: TextStyle(color: Colors.white, fontSize:Size* 30),
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
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: Subjects!.length,
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
                          child: Padding(
                            padding:  EdgeInsets.only(
                                left: Size*10, right: Size*10, bottom: Size*4),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius:  BorderRadius.all(
                                    Radius.circular(Size*15)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color.fromRGBO(
                                              174, 228, 242, 0.3)),
                                      color: Colors.black38,
                                      borderRadius:
                                           BorderRadius.all(
                                              Radius.circular(Size*15)),
                                      image: DecorationImage(
                                        image: FileImage(file),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    height: Size*70,
                                    width: Size*110,
                                  ),
                                  Expanded(
                                      child: Padding(
                                        padding:
                                             EdgeInsets.all(Size*8.0),
                                        child: Text(
                                          SubjectsData.name,
                                          style:  TextStyle(
                                              fontSize: Size*19,
                                              color: Colors.white),
                                          maxLines: 2,
                                          overflow:
                                              TextOverflow.ellipsis,
                                        ),
                                      ))
                                ],
                              ),
                            ),
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
                                            technicalParameters: data['technicalParameters'],
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
            height:Size* 150,
          )
        ],
      ),
    );
  }
}

Stream<List<sensorsDetailsConvertor>> readsensorsDetails(String id) =>
    FirebaseFirestore.instance
        .collection('sensors')
        .doc(id)
        .collection("details")
        .orderBy("name", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => sensorsDetailsConvertor.fromJson(doc.data()))
            .toList());

Future createsensorsDetails({required String heading, required String id}) async {
  final docflash = FirebaseFirestore.instance
      .collection('sensors')
      .doc(id)
      .collection("details")
      .doc();
  final flash = sensorsDetailsConvertor(
    id: docflash.id,
    name: heading,
  );
  final json = flash.toJson();
  await docflash.set(json);
}

class sensorsDetailsConvertor {
  String id;
  final String name;

  sensorsDetailsConvertor({this.id = "", required this.name});

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  static sensorsDetailsConvertor fromJson(Map<String, dynamic> json) =>
      sensorsDetailsConvertor(id: json['id'], name: json["name"]);
}

Stream<List<sensorsConvertor>> readsensors() => FirebaseFirestore.instance
    .collection('sensors')
    .orderBy("name", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => sensorsConvertor.fromJson(doc.data()))
        .toList());

Future createsensors({required String name,required String description,required String photoUrl}) async {
  final docflash =
      FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = sensorsConvertor(
      id: docflash.id,
      name: name,

      photoUrl: photoUrl,
     );
  final json = flash.toJson();
  await docflash.set(json);
}

class sensorsConvertor {
  String id;
  final String name,
      photoUrl;


  sensorsConvertor(
      {this.id = "",
      required this.name,
      required this.photoUrl,});

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "photoUrl": photoUrl,

      };

  static sensorsConvertor fromJson(Map<String, dynamic> json) =>
      sensorsConvertor(
          id: json['id'],
          name: json["name"],
          photoUrl: json["photoUrl"],
          );
}

class sensor extends StatefulWidget {
  String description,photoUrl,name,id,technicalParameters,pinDiagram,pinConnection;

  sensor({Key? key, required this.description,required this.photoUrl,required this.id,required this.name,required this.pinConnection,required this.pinDiagram,required this.technicalParameters}) : super(key: key);

  @override
  State<sensor> createState() => _sensorState();
}

class _sensorState extends State<sensor> {
  List images = [];
  CarouselController buttonCarouselController = CarouselController();
  int currentPos = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    images = widget.photoUrl.split(",");
  }

  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return backGroundImage(
        child:    SingleChildScrollView(
          child: Column(
            
          children: [
            backButton(size: Size*1,text: widget.name,),
            scrollingImages(
              images: images, id: widget.id,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: Size*8, vertical: Size*20),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(Size*3.0),
                    decoration: BoxDecoration(color: Colors.orangeAccent),
                    child: Center(
                      child: Text(
                        "About Sensor",
                        style:  TextStyle(
                            color: Colors.black,
                            fontSize: Size*25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(vertical: Size*20,horizontal: Size*10),
                    child: Text(
                      "          ${widget.description}",
                      style:  TextStyle(color: Colors.white, fontSize: Size*18),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: Size*8, vertical: Size*20),
              child: Column(
                children: [
                  Container(
                    padding:  EdgeInsets.all(Size*3.0),
                    decoration: BoxDecoration(color: Colors.orangeAccent),
                    child: Center(
                      child: Text(
                        "Technical Parameters",
                        style:  TextStyle(
                            color: Colors.black,
                            fontSize:Size* 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                      padding:  EdgeInsets.symmetric(vertical: Size*20,horizontal:Size* 5),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.technicalParameters
                            .split(";")
                            .length +
                            1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Table(
                              border: TableBorder.all(
                                  width: Size*0.8,
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(Size*10),
                                      topLeft: Radius.circular(Size*10))),
                              defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                              columnWidths: {
                                0: FractionColumnWidth(0.5),
                                1: FractionColumnWidth(0.5),
                              },
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.only(
                            topRight: Radius
                                .circular(Size*10),
                          topLeft: Radius
                              .circular(
                              Size*10)),
                                      color:
                                      Colors.grey.withOpacity(0.3)),
                                  children: [
                                    Padding(
                                      padding:  EdgeInsets.all(Size*8.0),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        'Technical Parameters',
                                        style: TextStyle(
                                          fontSize: Size*15,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.all(Size*8.0),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        'Description',
                                        style: TextStyle(
                                          fontSize:Size* 15,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            String subTechnicalParameters = widget
                                .technicalParameters
                                .split(";")[index - 1];
                            return Table(
                              border: TableBorder.all(
                                  width: Size*0.5,
                                  color: Colors.white54,
                                  borderRadius: index ==
                                      widget.technicalParameters
                                          .split(";")
                                          .length
                                      ? BorderRadius.only(
                                      bottomLeft: Radius.circular(Size*10),
                                      bottomRight:
                                      Radius.circular(Size*10))
                                      : BorderRadius.circular(0)),
                              defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                              columnWidths: {
                                0: FractionColumnWidth(0.5),
                                1: FractionColumnWidth(0.5),
                              },
                              children: [
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding:
                                         EdgeInsets.all(Size*8.0),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          subTechnicalParameters
                                              .split(":")
                                              .first,
                                          style: TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding:
                                         EdgeInsets.all(Size*8.0),
                                        child: Text(
                                            textAlign: TextAlign.center,
                                            subTechnicalParameters
                                                .split(":")
                                                .last,
                                            style: TextStyle(
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                        },
                      )),

                  if (widget.pinDiagram.isNotEmpty)
                    Padding(
                      padding:  EdgeInsets.symmetric(vertical: Size*20),
                      child: Column(
                        children: [
                          Text(
                            "PinOut",
                            style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: Size*25,
                                fontWeight: FontWeight.w500),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: Size*20),
                            child: Container(
                              height: Size*2,
                              width: Size*30,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(Size*5)),
                            ),
                          ),
                          scrollingImages(
                            images: widget.pinDiagram.split(";"), id: widget.id,
                          ),
                        ],
                      ),
                    ),
                  Padding(
                      padding:  EdgeInsets.symmetric(horizontal:Size* 50),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:
                        widget.pinConnection.split(";").length +
                            1, // Number of rows including the header
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Column(
                              children: [
                                Text(
                                  "Pin Connections",
                                  style: TextStyle(
                                      color: Colors.orangeAccent,
                                      fontSize: Size*25,
                                      fontWeight: FontWeight.w500),
                                ),
                                Padding(
                                  padding:
                                   EdgeInsets.only(bottom: Size*20),
                                  child: Container(
                                    height: Size*2,
                                    width:Size* 60,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(Size*5)),
                                  ),
                                ),
                                Table(
                                  border: TableBorder.all(
                                      width: Size*0.8,
                                      color: Colors.white70,

                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(Size*10),
                                          topLeft: Radius.circular(Size*10))),
                                  defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                                  columnWidths: {
                                    0: FractionColumnWidth(0.5),
                                    1: FractionColumnWidth(0.5),
                                  },
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                          color: Colors.grey
                                              .withOpacity(0.3)),
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(Size*8.0),
                                          child: Text(
                                            'Module',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: Size*15,
                                              color: Colors.orange,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(Size*8.0),
                                          child: Text(
                                            'Uno',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: Size*15,
                                              color: Colors.orange,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            String subTechnicalParameters = widget
                                .pinConnection
                                .split(";")[index - 1];
                            return Table(
                              border: TableBorder.all(
                                  width: Size*0.5,
                                  color: Colors.white54,
                                  borderRadius: index ==
                                      widget.pinConnection
                                          .split(";")
                                          .length
                                      ? BorderRadius.only(
                                      bottomLeft: Radius.circular(Size*10),
                                      bottomRight:
                                      Radius.circular(Size*10))
                                      : BorderRadius.circular(0)),
                              defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                              columnWidths: {
                                0: FractionColumnWidth(0.5),
                                1: FractionColumnWidth(0.5),
                              },
                              children: [
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(Size*8.0),
                                        child: Text(
                                          subTechnicalParameters
                                              .split(":")
                                              .first,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(Size*8.0),
                                        child: Text(
                                            subTechnicalParameters
                                                .split(":")
                                                .last,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                        },
                      )),
                ],
              ),
            ),
            Padding(
              padding:  EdgeInsets.all(Size*8.0),
              child: Container(
                padding:  EdgeInsets.all(Size*3.0),
                decoration: BoxDecoration(color: Colors.orangeAccent),
                child: Center(
                  child: Text(
                    "With Arduino Board",
                    style:  TextStyle(
                        color: Colors.black,
                        fontSize: Size*25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Description(c0: "sensors", d0: widget.id, c1: "", d1: "", typeOfProject: "sensors"),
            SizedBox(
              height: Size*150,
            )
          ],
        ),));
  }
}

Stream<List<DescriptionConvertor>> readDescription(String id) =>
    FirebaseFirestore.instance
        .collection('sensors')
        .doc(id)
        .collection("description")
        .orderBy("id", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DescriptionConvertor.fromJson(doc.data()))
            .toList());

class DescriptionConvertor {
  String id;
  final String data, subData, images, table,files;

  DescriptionConvertor(
      {this.id = "",
      required this.data,
      required this.subData,
      required this.images,
      required this.files,
      required this.table});

  Map<String, dynamic> toJson() => {
        "id": id,
        "data": data,
        "subData": subData,
        'images': images,
        'files': files,
        'table': table
      };

  static DescriptionConvertor fromJson(Map<String, dynamic> json) =>
      DescriptionConvertor(
          id: json['id'],
          data: json["data"],
          subData: json["subData"],
          table: json["table"],
          files: json["files"],
          images: json['images']);
}

Stream<List<sensorConnectionConvertor>> readsensorConnection(String id) =>
    FirebaseFirestore.instance
        .collection('sensors')
        .doc(id)
        .collection("sensorConnection")
        .orderBy("id", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => sensorConnectionConvertor.fromJson(doc.data()))
            .toList());

class sensorConnectionConvertor {
  String id;
  final String data, subData, file, images, table;

  sensorConnectionConvertor(
      {this.id = "",
      required this.data,
      required this.table,
      required this.subData,
      required this.file,
      required this.images});

  Map<String, dynamic> toJson() => {
        "id": id,
        "data": data,
        "subData": subData,
        "table": table,
        "file": file,
        "images": images
      };

  static sensorConnectionConvertor fromJson(Map<String, dynamic> json) =>
      sensorConnectionConvertor(
          id: json['id'],
          data: json["data"],
          subData: json["subData"],
          table: json["table"],
          file: json['file'],
          images: json["images"]);
}

