// ignore_for_file: prefer_const_constructors, must_be_immutable, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ns_ideas/authPage.dart';
import 'package:photo_view/photo_view.dart';
import 'homepage.dart';
import 'settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'functions.dart';
import 'sensors.dart';
import 'textField.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class commentsPage extends StatefulWidget {
final int comments;
  final String c0;
  final String d0;
  final String c1;
  final String d1;
  const commentsPage({required this.c0,required this.d0,required this.c1,required this.d1,required this.comments});


  @override
  State<commentsPage> createState() => _commentsPageState();
}

class _commentsPageState extends State<commentsPage> {
   TextEditingController comment = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.symmetric(vertical:Size* 8,horizontal:Size* 20),
          child: Row(
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(Size*20)),
                  child: Padding(
                    padding:  EdgeInsets.only(left: Size*10),
                    child: TextFormField(
                      controller: comment,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      style:
                      TextStyle(color: Colors.white, fontSize:Size* 20),
                      maxLines: null,
                      // Allows the field to expand as needed
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(
                          color: Colors.white60,
                        ),
                        border: InputBorder.none,
                        hintText: 'Add a comment...',
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Padding(
                  padding:  EdgeInsets.all(Size*5.0),
                  child: Icon(
                    Icons.send,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                onTap: () async {
                  String id = getID();

                 await FirebaseFirestore.instance
                      .collection("user")
                      .doc(fullUserId())
                      .get()
                      .then((DocumentSnapshot snapshot) async {
                    if (snapshot.exists) {
                      var data = snapshot.data();
                      if (data != null &&
                          data is Map<String, dynamic>) {


                        String name = data['name'].toString().split(";").first[0]??"";
                         name =name+ data['name'].toString().split(";").last[0]??"";
                         name="$name:"+fullUserId();
                         name ="$name;${comment.text.trim()}";
                         showToastText(comment.text);
                        widget.c1.isNotEmpty && widget.d1.isNotEmpty
                            ? await FirebaseFirestore.instance
                            .collection(widget.c0)
                            .doc(widget.d0)
                            .collection(widget.c1)
                            .doc(widget.d1)
                            .collection("comments")
                            .doc(id)
                            .set({
                          "id": id,
                          "data": name,
                          "reply":[],
                          "likedBy":[]
                        })
                            :await FirebaseFirestore.instance
                            .collection(widget.c0)
                            .doc(widget.d0)
                            .collection("comments")
                            .doc(id)
                            .set({
                          "id": id,
                          "data": name,
                          "reply":[],
                          "likedBy":[]
                        });

                        widget.c1.isNotEmpty && widget.d1.isNotEmpty
                            ? await FirebaseFirestore.instance
                            .collection(widget.c0)
                            .doc(widget.d0)
                            .collection(widget.c1)
                            .doc(widget.d1)

                            .update({
                          "comments": widget.comments+1,

                        })
                            :await FirebaseFirestore.instance
                            .collection(widget.c0)
                            .doc(widget.d0)

                            .update({
                          "comments": widget.comments+1,

                        });

                      }
                    } else {
                      print("Document does not exist.");
                    }
                  }).catchError((error) {
                    print(
                        "An error occurred while retrieving data: $error");
                  });

                    comment.clear();
                  }


              )
            ],
          ),
        ),
        StreamBuilder<List<CommentsConvertor>>(
          stream: readComments(widget.c0,widget.d0,widget.c1,widget.d1),
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
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: Subjects!.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final SubjectsData = Subjects[index];

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          Padding(
                            padding:  EdgeInsets.all(Size*8.0),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(color: Colors.white12,
                                  borderRadius: BorderRadius.circular(Size*20)),
                                  child: Padding(
                                    padding:  EdgeInsets.all(Size*5),
                                    child: Text(SubjectsData.data.split(":").first.toUpperCase(),style: TextStyle(color: Colors.white,fontSize: Size*25,fontWeight: FontWeight.bold),),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:  EdgeInsets.only(left: Size*5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                          Text("@${SubjectsData.data.split(";").first.split(":").last}",style: TextStyle(color: Colors.white54,fontSize:Size* 15)),
                                          StyledTextWidget(
                                              text: SubjectsData.data.split(";").last,
                                              fontSize: Size*22,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                          if(SubjectsData.reply.isNotEmpty)ListView.builder(
                                              physics:
                                              const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: SubjectsData.reply.length,
                                              itemBuilder: (BuildContext context,
                                                  int index) {
                                                return StyledTextWidget(
                                                    text: SubjectsData.reply[
                                                    index],
                                                    color: Colors
                                                        .white70,
                                                    fontSize:
                                                    Size*18);
                                              }),
                                      ],
                                    ),
                                  ),
                                ),
                                if(fullUserId()==SubjectsData.data.split(";").first.split(":").last||fullUserId()=="sujithnimmala03@gmail.com")InkWell(
                                    child: Padding(
                                      padding:  EdgeInsets.all(Size*5.0),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.amberAccent,
                                      ),
                                    ),
                                    onTap: () async {
                                      widget.c1.isNotEmpty && widget.d1.isNotEmpty
                                          ? await FirebaseFirestore.instance
                                          .collection(widget.c0)
                                          .doc(widget.d0)
                                          .collection(widget.c1)
                                          .doc(widget.d1)

                                          .update({
                                        "comments": Subjects.length-1,

                                      })
                                          :await FirebaseFirestore.instance
                                          .collection(widget.c0)
                                          .doc(widget.d0)

                                          .update({
                                        "comments": Subjects.length-1,

                                      });
                                      widget.c1.isNotEmpty && widget.d1.isNotEmpty
                                          ? FirebaseFirestore.instance
                                          .collection(widget.c0)
                                          .doc(widget.d0)
                                          .collection(widget.c1)
                                          .doc(widget.d1)
                                          .collection("comments")
                                          .doc(SubjectsData.id).delete()
                                          : FirebaseFirestore.instance
                                          .collection(widget.c0)
                                          .doc(widget.d0)
                                          .collection("comments")
                                          .doc(SubjectsData.id).delete();


                                    }



                                )
                              ],
                            ),
                          ),


                        ],
                      );
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(
                          height: Size*15,
                        ),
                  );
                }
            }
          },
        ),
        SizedBox(height: Size*150),
      ],
    );
  }
}


class ImageDownloadScreen extends StatefulWidget {
  List<String> images;
  String id;


  ImageDownloadScreen(
      {Key? key,required this.images,required this.id})
      : super(key: key);
  @override
  _ImageDownloadScreenState createState() => _ImageDownloadScreenState();
}

class _ImageDownloadScreenState extends State<ImageDownloadScreen> {


  int totalImages = 0;
  int downloadedImages = 0;
  double overallProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _downloadImages();
  }

  _downloadImages() async {
    totalImages = widget.images.length;
    downloadedImages = 0;
    overallProgress = 0.0;

    // Create a directory to save the downloaded images
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String imagesDirPath = '${appDir.path}/${widget.id}';
    await Directory(imagesDirPath).create(recursive: true);

    for (String url in widget.images) {
      final Uri uri = Uri.parse(url);
      final String filename = uri.pathSegments.last;
      final File file = File('$imagesDirPath/$filename');
      if(file.existsSync()){
        downloadedImages++;
      }
      else {
        try {
        final http.Response response = await http.get(uri);
        await file.writeAsBytes(response.bodyBytes);
        downloadedImages++;
      } catch (e) {
        print('Error downloading image: $e');
      }
      }

      setState(() {
        overallProgress = downloadedImages / totalImages;
      });

      await Future.delayed(Duration(milliseconds: 100));
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Container(
        padding: EdgeInsets.all(Size*10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Size*15),
          border: Border.all(color: Colors.white30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Just A Movement',style: TextStyle(color: Colors.white,fontSize: Size*25,fontWeight: FontWeight.w600),),
            SizedBox(height:Size* 8,),
            Text('...loading image $downloadedImages of $totalImages',style: TextStyle(color: Colors.white,fontSize: Size*18),),
            LinearProgressIndicator(
              // value: overallProgress,
            ),
          ],
        ),
      ),
    );
  }
}

class ImageDownloadsScreen extends StatefulWidget {
  List<String> images;
  ImageDownloadsScreen(
      {Key? key,required this.images})
      : super(key: key);
  @override
  _ImageDownloadsScreenState createState() => _ImageDownloadsScreenState();
}

class _ImageDownloadsScreenState extends State<ImageDownloadsScreen> {


  int totalImages = 0;
  int downloadedImages = 0;
  double overallProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _downloadImages();
  }

  _downloadImages() async {
    totalImages = widget.images.length;
    downloadedImages = 0;
    overallProgress = 0.0;



    for (String url in widget.images) {
      final Uri uri = Uri.parse(url.split(";").first);
      final String fileName = uri.pathSegments.last;
      var name = fileName.split("/").last;
      if (url.startsWith('https://drive.google.com')) {
        name = url.split(";").first.split('/d/')[1].split('/')[0];

        url = "https://drive.google.com/uc?export=download&id=$name";
      }
      final response = await http.get(Uri.parse(url.split(";").first));
      final documentDirectory = await getApplicationDocumentsDirectory();
      final newDirectory =
      Directory('${documentDirectory.path}/${url.split(";").last}');
      if (!await newDirectory.exists()) {
        await newDirectory.create(recursive: true);
      }
      final file = File('${newDirectory.path}/${name.split(";").first}');
      await file.writeAsBytes(response.bodyBytes);

      setState(() {
        downloadedImages++;
        overallProgress = downloadedImages / totalImages;
      });

      await Future.delayed(Duration(milliseconds: 100));
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Container(
        padding: EdgeInsets.all(Size*10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Size*15),
          border: Border.all(color: Colors.white30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Just A Movement',style: TextStyle(color: Colors.white,fontSize: Size*25,fontWeight: FontWeight.w600),),
            SizedBox(height:Size* 8,),
            Text('...loading image $downloadedImages of $totalImages',style: TextStyle(color: Colors.white,fontSize: Size*18),),
            LinearProgressIndicator(
              // value: overallProgress,
            ),
          ],
        ),
      ),
    );
  }
}


class Description extends StatefulWidget {

  final String c0;
  final String typeOfProject;
  final String d0;
  final String c1;
  final String d1;
  const Description({required this.c0,required this.d0,required this.c1,required this.d1,required this.typeOfProject});

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  Widget build(BuildContext context) {
double Size = size(context);
    return StreamBuilder<List<DescriptionConvertor>>(
      stream: readAllDescription(widget.c0,widget.d0,widget.c1,widget.d1),
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
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  if(isUser()) Padding(
                    padding:  EdgeInsets.symmetric(horizontal: Size*20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text("Description",style: TextStyle(color: Colors.white70,fontSize: Size*20,fontWeight: FontWeight.w600),),
                         InkWell(
                           child:  Container(
                             decoration: BoxDecoration(
                               color: Colors.greenAccent,
                               borderRadius:
                               BorderRadius.circular(Size*15),
                             ),
                             child: Padding(
                               padding:  EdgeInsets.all(Size*5.0),
                               child: Text(" ADD "),
                             ),
                           ),
                           onTap: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context)=>DescriptionCreator(c0: widget.c0,d0:widget.d0,c1:widget.c1,d1:widget.d1)));
                           },
                         ),
                       ],
                     ),
                  ),

                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: Subjects!.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final SubjectsData = Subjects[index];
                      List<String> newList = [];
                      newList = SubjectsData.subData.split(";");
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          if(isUser())Row(
                            children: [
                              Text("Id : ${SubjectsData.id}",style: TextStyle(color: Colors.white),),
                              Spacer(),
                              InkWell(
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: Size*10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent,
                                      borderRadius:
                                      BorderRadius.circular(Size*15),
                                    ),
                                    child: Padding(
                                      padding:  EdgeInsets.all(Size*5.0),
                                      child: Text(" Edit "),
                                    ),
                                  ),
                                ),
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>DescriptionCreator(data:SubjectsData.data ,subData: SubjectsData.subData,table: SubjectsData.table,images: SubjectsData.images,d2: SubjectsData.id, c0: widget.c0,d0: widget.d0,c1: widget.c1,d1:widget.d1,files: SubjectsData.files,)));
                                },
                              ),
                              InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius:
                                    BorderRadius.circular(Size*15),
                                  ),
                                  child: Padding(
                                    padding:  EdgeInsets.all(Size*5.0),
                                    child: Text(" Delete "),
                                  ),
                                ),
                                onTap: (){
                                  widget.c1.isNotEmpty&&widget.d1.isNotEmpty?FirebaseFirestore.instance.collection(widget.c0).doc(widget.d0).collection(widget.c1).doc(widget.d1).collection("description").doc(SubjectsData.id).delete():FirebaseFirestore.instance.collection(widget.c0).doc(widget.d0).collection("description").doc(SubjectsData.id).delete();
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding:  EdgeInsets.all(Size*8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (newList.length > 1)
                                  StyledTextWidget(
                                      text: SubjectsData.data,
                                      fontSize: Size*22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)
                                else if (SubjectsData.images.isNotEmpty)
                                  StyledTextWidget(
                                      text: SubjectsData.data,
                                      fontSize: Size*22,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500)
                                else
                                  StyledTextWidget(
                                      text: "       ${SubjectsData.data}",
                                      fontSize: Size*20,
                                      color:
                                      Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w400),
                                if (SubjectsData.images.isNotEmpty)
                                  Padding(
                                    padding:
                                     EdgeInsets.only(top:Size* 20),
                                    child: scrollingImages(
                                      images: SubjectsData.images
                                          .split(";"),  id: widget.d1,),
                                  ),
                                if (SubjectsData.subData.isNotEmpty)
                                  ListView.builder(
                                      physics:
                                      const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: newList.length,
                                      itemBuilder: (BuildContext context,
                                          int index) {
                                        if (newList.length > 1) {
                                          return Padding(
                                            padding:
                                             EdgeInsets.all(Size*8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Text(
                                                  "${index + 1}. ",
                                                  style:  TextStyle(
                                                      color: Colors.white,
                                                      fontSize: Size*20),
                                                ),
                                                Expanded(
                                                    child:
                                                    StyledTextWidget(
                                                        text: newList[
                                                        index],
                                                        color: Colors
                                                            .white70,
                                                        fontSize:
                                                        Size*18)),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return Center(
                                            child: Padding(
                                                padding:
                                                 EdgeInsets.all(
                                                    Size*8.0),
                                                child: StyledTextWidget(
                                                    text: newList[index],
                                                    color: Colors
                                                        .amberAccent,
                                                    fontSize: Size*16)),
                                          );
                                        }
                                      }),
                              ],
                            ),
                          ),
                          if (SubjectsData.table.isNotEmpty)
                            Padding(
                              padding:  EdgeInsets.symmetric(
                                  horizontal:Size* 8, vertical:Size* 10),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics:
                                NeverScrollableScrollPhysics(),
                                itemCount: SubjectsData.table
                                    .split(";")
                                    .length +
                                    1, // Number of rows including the header
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return Table(
                                      border: TableBorder.all(
                                          width:Size* 0.8,
                                          color: Colors.white70,
                                          borderRadius:
                                          BorderRadius.only(
                                              topRight: Radius
                                                  .circular(Size*10),
                                              topLeft: Radius
                                                  .circular(
                                                  Size* 10))),
                                      defaultVerticalAlignment:
                                      TableCellVerticalAlignment
                                          .middle,
                                      columnWidths: {
                                        0: FractionColumnWidth(0.2),
                                        1: FractionColumnWidth(0.5),
                                      },
                                      children: [
                                        TableRow(
                                          decoration: BoxDecoration(
                                              color: Colors.grey
                                                  .withOpacity(
                                                  0.3),
                                              borderRadius:
                                              BorderRadius.only(
                                                  topRight: Radius
                                                      .circular(Size*10),
                                                  topLeft: Radius
                                                      .circular(
                                                      Size*10))
                                          ),
                                          children: [
                                            Padding(
                                              padding:
                                               EdgeInsets
                                                  .all(Size*8.0),
                                              child: Text(
                                                textAlign: TextAlign
                                                    .center,
                                                'Module',
                                                style: TextStyle(
                                                  fontSize: Size*15,
                                                  color:
                                                  Colors.orange,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                               EdgeInsets
                                                  .all(Size*8.0),
                                              child: Text(
                                                textAlign: TextAlign
                                                    .center,
                                                'Arduino Board',
                                                style: TextStyle(
                                                  fontSize:Size* 15,
                                                  color:
                                                  Colors.orange,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  } else {
                                    String subTechnicalParameters =
                                    SubjectsData.table
                                        .split(";")[index - 1];
                                    return Table(
                                      border: TableBorder.all(
                                          width: Size*0.5,
                                          color: Colors.white54,
                                          borderRadius: index ==
                                              SubjectsData.table
                                                  .split(";")
                                                  .length
                                              ? BorderRadius.only(
                                              bottomLeft: Radius
                                                  .circular(Size*10),
                                              bottomRight:
                                              Radius
                                                  .circular(
                                                  Size*10))
                                              : BorderRadius
                                              .circular(0)),
                                      defaultVerticalAlignment:
                                      TableCellVerticalAlignment
                                          .middle,
                                      columnWidths: {
                                        0: FractionColumnWidth(0.2),
                                        1: FractionColumnWidth(0.5),
                                      },
                                      children: [
                                        TableRow(
                                          children: [
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                 EdgeInsets
                                                    .all(Size*8.0),
                                                child: Text(
                                                  textAlign:
                                                  TextAlign
                                                      .center,
                                                  subTechnicalParameters
                                                      .split(":")
                                                      .first,
                                                  style: TextStyle(
                                                      color: Colors
                                                          .white),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                 EdgeInsets
                                                    .all(Size*8.0),
                                                child: Text(
                                                    textAlign:
                                                    TextAlign
                                                        .center,
                                                    subTechnicalParameters
                                                        .split(":")
                                                        .last,
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ),
                          if(SubjectsData.files.isNotEmpty)
                            Padding(
                              padding:  EdgeInsets.all(Size*5.0),
                              child: Container(
                                width:double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  border: Border.all(color: Colors.white24),
                                  borderRadius: BorderRadius.circular(Size*10)
                                ),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color:Colors.white12,

                                            borderRadius:
                                            BorderRadius.only(
                                                topRight: Radius
                                                    .circular(Size*10),
                                                topLeft: Radius
                                                    .circular(
                                                    Size*10))
                                        ),
                                        child: Padding(
                                          padding:  EdgeInsets.all(Size*5.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Code",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                            ],
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding:  EdgeInsets.all(Size*8.0),
                                        child: SingleChildScrollView(
                                          physics: BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          child: SelectableText(
                                            SubjectsData.files,
                                            style: TextStyle(fontSize: Size*15,color: Colors.white.withOpacity(0.9)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            )

                        ],
                      );
                    },
                    separatorBuilder: (context, index) =>
                     SizedBox(
                      height: Size*15,
                    ),
                  ),
                ],
              );
            }
        }
      },
    );
  }
}

Stream<List<DescriptionConvertor>> readAllDescription(String c0,String d0,String c1,String d1) =>
    c1.isNotEmpty && d1.isNotEmpty?FirebaseFirestore.instance
        .collection(c0)
        .doc(d0)
        .collection(c1)
        .doc(d1)
        .collection("description")
        .orderBy("id", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => DescriptionConvertor.fromJson(doc.data()))
        .toList()):FirebaseFirestore.instance
        .collection(c0)
        .doc(d0)
        .collection("description")
        .orderBy("id", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => DescriptionConvertor.fromJson(doc.data()))
        .toList());

String getID() {
  var now = new DateTime.now();
  return DateFormat('d.M.y-kk:mm:ss').format(now);
}

class webView extends StatefulWidget {
  const webView({required this.url});

  final String url;

  @override
  State<webView> createState() => _webViewState();
}

class _webViewState extends State<webView> {
  late final WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: controller,
    );
  }
}

class tableOfContent extends StatefulWidget {
  final List list;
  final bool isView;
  const tableOfContent({Key? key, required this.list, this.isView = false})
      : super(key: key);

  @override
  State<tableOfContent> createState() => _tableOfContentState();
}

class _tableOfContentState extends State<tableOfContent> {
  bool isView = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isView = widget.isView;
    });
  }

  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return Padding(
      padding:  EdgeInsets.all(Size*10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
               Text(
                "Table of Content : ",
                style: TextStyle(
                    fontSize: Size*25,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
              Spacer(),
              InkWell(
                child: Text(
                  isView ? "Hide" : "View",
                  style: TextStyle(
                      color: Color.fromRGBO(17, 245, 237, 1),
                      fontSize: Size*16),
                ),
                onTap: () {
                  setState(() {
                    isView = !isView;
                  });
                },
              ),
              SizedBox(
                width: Size*10,
              )
            ],
          ),
          if (isView)
            Padding(
              padding:
               EdgeInsets.only(left:Size* 20, right: Size*10, top:Size* 10),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.list.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  String name = widget.list[index];
                  return Row(
                    children: [
                      Column(
                        children: [
                           Icon(
                            Icons.circle,
                            size: Size*5,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                       SizedBox(
                        width: Size*10,
                      ),
                      Text(
                        name,
                        style:  TextStyle(
                            fontSize: Size*18,
                            color: Colors.white70,
                            fontWeight: FontWeight.w400),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class componentsAndSupplies
    extends StatefulWidget {
  final List list;
  final bool isView;
  const componentsAndSupplies
      ({Key? key, required this.list, this.isView = false})
      : super(key: key);

  @override
  State<componentsAndSupplies> createState() => _componentsAndSuppliesState();
}

class _componentsAndSuppliesState extends State<componentsAndSupplies> {
  bool isView = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isView = widget.isView;
    });
  }

  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return Padding(
      padding:  EdgeInsets.all(Size*10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Components And Supplies",
                style: TextStyle(
                    fontSize: Size*25,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
              Spacer(),
              InkWell(
                child: Text(
                  isView ? "Hide" : "View",
                  style: TextStyle(
                      color: Color.fromRGBO(17, 245, 237, 1),
                      fontSize: Size*16),
                ),
                onTap: () {
                  setState(() {
                    isView = !isView;
                  });
                },
              ),
              SizedBox(
                width: Size*10,
              )
            ],
          ),
          if (isView)
            Padding(
              padding:
              EdgeInsets.only(left:Size* 20, right: Size*10, top:Size* 10),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.list.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  String name = widget.list[index];
                  return Row(
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.circle,
                            size: Size*5,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: Size*5,
                      ),
                      Expanded(
                        child: InkWell(
                          child: Text(
                            name.split(";").first,
                            style:  TextStyle(
                                fontSize: Size*18,
                                color: Colors.white70,
                                fontWeight: FontWeight.w400),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>zoom(url: name.split(";")[1], typeOfProject: "componentsAndSupplies")));

                          },
                        ),
                      ),
                      InkWell(
                        child: Icon(Icons.open_in_new,color: Colors.lightGreenAccent,),
                        onTap: (){
                          ExternalLaunchUrl(name.split(";").last.trim());
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
class appsAndPlatforms
    extends StatefulWidget {
  final List list;
  final bool isView;
  const appsAndPlatforms
      ({Key? key, required this.list, this.isView = false})
      : super(key: key);

  @override
  State<appsAndPlatforms> createState() => _appsAndPlatformsState();
}

class _appsAndPlatformsState extends State<appsAndPlatforms> {
  bool isView = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isView = widget.isView;
    });
  }

  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return Padding(
      padding:  EdgeInsets.all(Size*10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Apps and platforms",
                style: TextStyle(
                    fontSize: Size*25,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
              Spacer(),
              InkWell(
                child: Text(
                  isView ? "Hide" : "View",
                  style: TextStyle(
                      color: Color.fromRGBO(17, 245, 237, 1),
                      fontSize: Size*16),
                ),
                onTap: () {
                  setState(() {
                    isView = !isView;
                  });
                },
              ),
              SizedBox(
                width: Size*10,
              )
            ],
          ),
          if (isView)
            Padding(
              padding:
              EdgeInsets.only(left:Size* 20, right: Size*10, top:Size* 10),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.list.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  String name = widget.list[index];
                  return Row(
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.circle,
                            size: Size*5,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: Size*5,
                      ),
                      Expanded(
                        child: Text(
                          name.split(";").first,
                          style:  TextStyle(
                              fontSize: Size*18,
                              color: Colors.white70,
                              fontWeight: FontWeight.w400),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        child: Icon(Icons.open_in_new,color: Colors.lightGreenAccent,),
                        onTap: (){
                          ExternalLaunchUrl(name.split(";").last.trim());
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}


class Required extends StatefulWidget {
  final List list;
  final String heading;
  const Required({Key? key, required this.list,required this.heading}) : super(key: key);

  @override
  State<Required> createState() => _RequiredState();
}

class _RequiredState extends State<Required> {
  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.only(left: Size*8, bottom: Size*5),
          child: Row(
            children: [
               Text(
                widget.heading,
                style: TextStyle(
                    fontSize: Size*23,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left:Size* 20, right: Size*10),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.list.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final data = widget.list[index];
              String name = data.split(";").first;
              String photoUrl = data.split(";").last;

              return InkWell(
                child: Padding(
                  padding:  EdgeInsets.all(Size*4.0),
                  child: Row(
                    children: [
                       Icon(
                        Icons.circle,
                        size: Size*8,
                        color: Colors.white,
                      ),
                       SizedBox(
                        width: Size*5,
                      ),
                      Expanded(
                          child: Text(
                            name,
                            style:  TextStyle(
                                color: Colors.white,
                                fontSize:Size* 20,
                                fontWeight: FontWeight.w300),
                          )),
                    ],
                  ),
                ),
                onTap: () {
                  showToastText(longPressToViewImage);
                },
                onLongPress: () {
                  if (photoUrl.length > 3) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                zoom(url: photoUrl, typeOfProject: '',)));
                  } else {
                    showToastText(noImageUrl);
                  }
                },
              );
            },
            // separatorBuilder: (context, index) =>const Divider(),
          ),
        ),
      ],
    );
  }
}

class youtube extends StatefulWidget {
  final url;
  const youtube({Key? key, required this.url}) : super(key: key);
  @override
  State<youtube> createState() => _youtubeState();
}

class _youtubeState extends State<youtube> {
  late YoutubePlayerController _controller;
  @override
  void initState() {
    final videoID = YoutubePlayer.convertUrlToId(widget.url);
    _controller = YoutubePlayerController(
        initialVideoId: videoID!,
        flags: const YoutubePlayerFlags(autoPlay: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      onReady: () => debugPrint("Ready"),
      bottomActions: [
        CurrentPosition(),
        ProgressBar(
          isExpanded: true,
          colors: const ProgressBarColors(
              playedColor: Colors.amber, handleColor: Colors.amberAccent),
        ),
        const PlaybackSpeedButton(),
        FullScreenButton()
      ],
    );
  }
}

class zoom extends StatefulWidget {
  String url;
  String typeOfProject;
  zoom({Key? key,required this.url,required this.typeOfProject}) : super(key: key);

  @override
  State<zoom> createState() => _zoomState();
}

class _zoomState extends State<zoom> {
     File file =File('');


  @override
  void initState() {
    super.initState();
    getPath();
  }
   getPath()
   async{
     final Directory appDir = await getApplicationDocumentsDirectory();
     final String imagesDirPath = '${appDir.path}/${widget.typeOfProject}';
     final Uri uri = Uri.parse(widget.url);
     final String filename = uri.pathSegments.last;
     file = File('$imagesDirPath/$filename');

   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              backButton(),
              Expanded(
                child: Center(
                  child: file.existsSync()?PhotoView(imageProvider: FileImage(file)):PhotoView(imageProvider:NetworkImage(widget.url),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class StyledTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  StyledTextWidget(
      {required this.text,
        this.fontSize = 14,
        this.color = Colors.white,
        this.fontWeight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> spans = [];

    List<String> words = text.split(' ');

    for (String word in words) {
      if (word.startsWith('**')) {
        spans.add(TextSpan(
          children: [
            WidgetSpan(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.white54)),
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
                child: Text(
                  word.substring(2),
                  style: TextStyle(color: Colors.white, fontSize: fontSize - 5),
                ),
              ),
            ),
            TextSpan(text: ' '),
          ],
        ));
      } else if (word.startsWith("'") && word.endsWith("'")) {
        spans.add(TextSpan(
          text: '${word.substring(1, word.length - 1)} ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ));
      } else {
        spans.add(TextSpan(text: '$word '));
      }
    }

    return Wrap(
      children: [
        RichText(
          text: TextSpan(
              children: spans,
              style: TextStyle(
                  fontSize: fontSize, color: color, fontWeight: fontWeight)),
        ),
      ],
    );
  }
}