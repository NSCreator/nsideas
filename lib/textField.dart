// ignore_for_file: camel_case_types, non_constant_identifier_names, must_be_immutable, prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'authPage.dart';
import 'main.dart';
import 'raspberrypi.dart';
import 'arduino.dart';
import 'commonFunctions.dart';

class backButton extends StatefulWidget {
  Color color;
  double size;
  String text;

  backButton({this.color = Colors.white, required this.size, this.text = ""});

  @override
  State<backButton> createState() => _backButtonState();
}

class _backButtonState extends State<backButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            child: Padding(
              padding: EdgeInsets.only(
                  left: widget.size * 10, right: widget.size * 10),
              child: Icon(
                Icons.arrow_back,
                color: widget.color,
                size: widget.size * 30,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          if (widget.text.isNotEmpty)
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(bottom: widget.size * 10),
                child: Text(
                  widget.text,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.size * 30,
                      fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          if (widget.text.isNotEmpty)
            SizedBox(
              width: 45,
            )
        ],
      ),
    );
  }
}

TextStyle textFieldStyle(double size) {
  return TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: size * 20,
  );
}

TextStyle textFieldHintStyle(double size) {
  return TextStyle(
    color: Colors.white54,
    fontWeight: FontWeight.w300,
    fontSize: size * 18,
  );
}

class TextFieldContainer extends StatefulWidget {
  Widget child;
  String heading;

  TextFieldContainer({required this.child, this.heading = ""});

  @override
  State<TextFieldContainer> createState() => _TextFieldContainerState();
}

class _TextFieldContainerState extends State<TextFieldContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.heading.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Text(
              widget.heading,
              style: creatorHeadingTextStyle,
            ),
          ),
        Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white24,
              border: Border.all(color: Colors.white54),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}

class createNewOne extends StatefulWidget {
  String heading;
  String description;
  String photoUrl;
  String videoUrl;
  String circuitDiagram;
  String projectId;

  createNewOne(
      {Key? key,
      this.circuitDiagram = "",
      this.description = "",
      this.heading = "",
      this.photoUrl = "",
      this.videoUrl = "",
      this.projectId = ""})
      : super(key: key);

  @override
  State<createNewOne> createState() => _createNewOneState();
}

class _createNewOneState extends State<createNewOne> {
  final HeadingController = TextEditingController();
  final DescriptionController = TextEditingController();
  final PhotoUrl = TextEditingController();
  final VideoUrl = TextEditingController();
  final CircuitDiagram = TextEditingController();

  void AutoFill() {
    HeadingController.text = widget.heading;
    DescriptionController.text = widget.description;
    PhotoUrl.text = widget.photoUrl;
    VideoUrl.text = widget.videoUrl;
    CircuitDiagram.text = widget.circuitDiagram;
  }

  @override
  void initState() {
    AutoFill();
    super.initState();
  }

  @override
  void dispose() {
    HeadingController.dispose();
    DescriptionController.dispose();
    PhotoUrl.dispose();
    VideoUrl.dispose();
    CircuitDiagram.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(53, 166, 204, 1),
                Color.fromRGBO(24, 45, 74, 1),
                Color.fromRGBO(21, 47, 61, 1)
              ]),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Data Creator"),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 3, bottom: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            controller: HeadingController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Heading',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 3, bottom: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            controller: DescriptionController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Description',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 3, bottom: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            controller: DescriptionController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Photo Url',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 3, bottom: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            controller: DescriptionController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Pin Diagram Url',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 3, bottom: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            controller: DescriptionController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Video Url',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 3, bottom: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            controller: DescriptionController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Source Name',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 3, bottom: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            controller: DescriptionController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Source Url',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 3, bottom: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            controller: DescriptionController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Creator Name',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 3, bottom: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            controller: DescriptionController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Creator Photo',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 3, bottom: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            controller: DescriptionController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Main Features',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class electronicProjectsCreator extends StatefulWidget {
  String heading;
  String description;
  String photoUrl;
  String videoUrl;
  String tableOfContent;
  String tags;
  List requiredComponents;
  List toolsRequired;
  String projectId;

  electronicProjectsCreator({
    super.key,
    this.description = "",
    this.heading = "",
    this.photoUrl = "",
    this.videoUrl = "",

    this.tags = "",
    this.tableOfContent = "",
    List? requiredComponents,
    List? toolsRequired,
    this.projectId = "",
  })  : requiredComponents = requiredComponents ?? [],
        toolsRequired = toolsRequired ?? [];

  @override
  State<electronicProjectsCreator> createState() =>
      _electronicProjectsCreatorState();
}

class _electronicProjectsCreatorState extends State<electronicProjectsCreator> {
  final HeadingFirstController = TextEditingController();
  final HeadingLastController = TextEditingController();
  final DescriptionController = TextEditingController();

  List ImageList = [];
  final TextEditingController _ImageController = TextEditingController();
  int selectedImageIndex = -1;

  List tableOfContentList = [];
  final TextEditingController _tableOfContentController =
      TextEditingController();
  int selectedtableOfContentIndex = -1;

  List TagsList = [];
  final TextEditingController _TagsController = TextEditingController();
  int selectedTagsIndex = -1;

  List requiredComponentsList = [];
  final TextEditingController _requiredComponentsController =
      TextEditingController();
  int selectedrequiredComponentsIndex = -1;

  List toolsRequiredList = [];
  final TextEditingController _toolsRequiredController =
      TextEditingController();
  int selectedtoolsRequiredIndex = -1;

  final VideoUrl = TextEditingController();

  void AutoFill() {
    HeadingFirstController.text = widget.heading.split(";").first;
    if (widget.heading.split(";").length > 1)
      HeadingLastController.text = widget.heading.split(";").last;
    DescriptionController.text = widget.description;
    ImageList= widget.photoUrl.split(";");
TagsList = widget.tags.split(";");
requiredComponentsList = widget.requiredComponents;
toolsRequiredList = widget.toolsRequired;
tableOfContentList = widget.tableOfContent.split(";");
    VideoUrl.text = widget.videoUrl;

  }

  @override
  void initState() {
    if (widget.projectId.isNotEmpty) AutoFill();
    super.initState();
  }

  @override
  void dispose() {
    HeadingFirstController.dispose();
    HeadingLastController.dispose();
    DescriptionController.dispose();
    _ImageController.dispose();
    VideoUrl.dispose();
    super.dispose();
  }

  void addImages() {
    String points = _ImageController.text;
    if (points.isNotEmpty) {
      setState(() {
        ImageList.add(points);
        _ImageController.clear();
      });
    }
  }

  void editImages(int index) {
    setState(() {
      selectedImageIndex = index;
      _ImageController.text = ImageList[index];
    });
  }

  void saveImages() {
    String editedImage = _ImageController.text;
    if (editedImage.isNotEmpty && selectedImageIndex != -1) {
      setState(() {
        ImageList[selectedImageIndex] = editedImage;
        _ImageController.clear();
        selectedImageIndex = -1;
      });
    }
  }

  void deleteImages(int index) {
    setState(() {
      ImageList.removeAt(index);
      if (selectedImageIndex == index) {
        selectedImageIndex = -1;
        _ImageController.clear();
      }
    });
  }

  void moveImagesUp(int index) {
    if (index > 0) {
      setState(() {
        String point = ImageList.removeAt(index);
        ImageList.insert(index - 1, point);
        if (selectedImageIndex == index) {
          selectedImageIndex--;
        }
      });
    }
  }

  void moveImagesDown(int index) {
    if (index < ImageList.length - 1) {
      setState(() {
        String Image = ImageList.removeAt(index);
        ImageList.insert(index + 1, Image);
        if (selectedImageIndex == index) {
          selectedImageIndex++;
        }
      });
    }
  }

  void addTags() {
    String points = _TagsController.text;
    if (points.isNotEmpty) {
      setState(() {
        TagsList.add(points);
        _TagsController.clear();
      });
    }
  }

  void editTags(int index) {
    setState(() {
      selectedTagsIndex = index;
      _TagsController.text = TagsList[index];
    });
  }

  void saveTags() {
    String editedImage = _TagsController.text;
    if (editedImage.isNotEmpty && selectedTagsIndex != -1) {
      setState(() {
        TagsList[selectedImageIndex] = editedImage;
        _TagsController.clear();
        selectedTagsIndex = -1;
      });
    }
  }

  void deleteTags(int index) {
    setState(() {
      TagsList.removeAt(index);
      if (selectedTagsIndex == index) {
        selectedTagsIndex = -1;
        _TagsController.clear();
      }
    });
  }

  void moveTagsUp(int index) {
    if (index > 0) {
      setState(() {
        String point = TagsList.removeAt(index);
        TagsList.insert(index - 1, point);
        if (selectedTagsIndex == index) {
          selectedTagsIndex--;
        }
      });
    }
  }

  void moveTagsDown(int index) {
    if (index < TagsList.length - 1) {
      setState(() {
        String Image = TagsList.removeAt(index);
        TagsList.insert(index + 1, Image);
        if (selectedTagsIndex == index) {
          selectedTagsIndex++;
        }
      });
    }
  }

  void addtoolsRequired() {
    String points = _toolsRequiredController.text;
    if (points.isNotEmpty) {
      setState(() {
        toolsRequiredList.add(points);
        _toolsRequiredController.clear();
      });
    }
  }

  void edittoolsRequired(int index) {
    setState(() {
      selectedtoolsRequiredIndex = index;
      _toolsRequiredController.text = toolsRequiredList[index];
    });
  }

  void savetoolsRequired() {
    String editedImage = _toolsRequiredController.text;
    if (editedImage.isNotEmpty && selectedtoolsRequiredIndex != -1) {
      setState(() {
        toolsRequiredList[selectedImageIndex] = editedImage;
        _toolsRequiredController.clear();
        selectedtoolsRequiredIndex = -1;
      });
    }
  }

  void deletetoolsRequired(int index) {
    setState(() {
      toolsRequiredList.removeAt(index);
      if (selectedtoolsRequiredIndex == index) {
        selectedtoolsRequiredIndex = -1;
        _toolsRequiredController.clear();
      }
    });
  }

  void movetoolsRequiredUp(int index) {
    if (index > 0) {
      setState(() {
        String point = toolsRequiredList.removeAt(index);
        toolsRequiredList.insert(index - 1, point);
        if (selectedtoolsRequiredIndex == index) {
          selectedtoolsRequiredIndex--;
        }
      });
    }
  }

  void movetoolsRequiredDown(int index) {
    if (index < toolsRequiredList.length - 1) {
      setState(() {
        String Image = toolsRequiredList.removeAt(index);
        toolsRequiredList.insert(index + 1, Image);
        if (selectedtoolsRequiredIndex == index) {
          selectedtoolsRequiredIndex++;
        }
      });
    }
  }

  void addrequiredComponents() {
    String points = _requiredComponentsController.text;
    if (points.isNotEmpty) {
      setState(() {
        requiredComponentsList.add(points);
        _requiredComponentsController.clear();
      });
    }
  }

  void editrequiredComponents(int index) {
    setState(() {
      selectedrequiredComponentsIndex = index;
      _requiredComponentsController.text = requiredComponentsList[index];
    });
  }

  void saverequiredComponents() {
    String editedImage = _requiredComponentsController.text;
    if (editedImage.isNotEmpty && selectedrequiredComponentsIndex != -1) {
      setState(() {
        requiredComponentsList[selectedrequiredComponentsIndex] = editedImage;
        _requiredComponentsController.clear();
        selectedrequiredComponentsIndex = -1;
      });
    }
  }

  void deleterequiredComponents(int index) {
    setState(() {
      requiredComponentsList.removeAt(index);
      if (selectedrequiredComponentsIndex == index) {
        selectedrequiredComponentsIndex = -1;
        _requiredComponentsController.clear();
      }
    });
  }

  void moverequiredComponentsUp(int index) {
    if (index > 0) {
      setState(() {
        String point = requiredComponentsList.removeAt(index);
        requiredComponentsList.insert(index - 1, point);
        if (selectedrequiredComponentsIndex == index) {
          selectedrequiredComponentsIndex--;
        }
      });
    }
  }

  void moverequiredComponentsDown(int index) {
    if (index < requiredComponentsList.length - 1) {
      setState(() {
        String Image = requiredComponentsList.removeAt(index);
        requiredComponentsList.insert(index + 1, Image);
        if (selectedrequiredComponentsIndex == index) {
          selectedrequiredComponentsIndex++;
        }
      });
    }
  }

  void addtableOfContent() {
    String points = _tableOfContentController.text;
    if (points.isNotEmpty) {
      setState(() {
        tableOfContentList.add(points);
        _tableOfContentController.clear();
      });
    }
  }

  void edittableOfContent(int index) {
    setState(() {
      selectedtableOfContentIndex = index;
      _tableOfContentController.text = tableOfContentList[index];
    });
  }

  void savetableOfContent() {
    String editedImage = _tableOfContentController.text;
    if (editedImage.isNotEmpty && selectedtableOfContentIndex != -1) {
      setState(() {
        tableOfContentList[selectedtableOfContentIndex] = editedImage;
        _tableOfContentController.clear();
        selectedtableOfContentIndex = -1;
      });
    }
  }

  void deletetableOfContent(int index) {
    setState(() {
      tableOfContentList.removeAt(index);
      if (selectedtableOfContentIndex == index) {
        selectedtableOfContentIndex = -1;
        _tableOfContentController.clear();
      }
    });
  }

  void movetableOfContentUp(int index) {
    if (index > 0) {
      setState(() {
        String point = tableOfContentList.removeAt(index);
        tableOfContentList.insert(index - 1, point);
        if (selectedtableOfContentIndex == index) {
          selectedtableOfContentIndex--;
        }
      });
    }
  }

  void movetableOfContentDown(int index) {
    if (index < tableOfContentList.length - 1) {
      setState(() {
        String Image = tableOfContentList.removeAt(index);
        tableOfContentList.insert(index + 1, Image);
        if (selectedtableOfContentIndex == index) {
          selectedtableOfContentIndex++;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return backGroundImage(child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          backButton(size: size(context),text: "Electronic Projects",),
          const Padding(
            padding: EdgeInsets.only(left: 15, top: 8),
            child: Text(
              "Heading",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      border:
                      Border.all(color: Colors.white.withOpacity(0.6)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: HeadingFirstController,
                        maxLines: null,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'First',
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      border:
                      Border.all(color: Colors.white.withOpacity(0.6)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: HeadingLastController,
                        maxLines: null,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Last',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Text(
              "Tags",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: TagsList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(TagsList[index]),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  deleteTags(index);
                },
                child: ListTile(
                  title: Text(TagsList[index],
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                  trailing: SingleChildScrollView(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteTags(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            editTags(index);
                          },
                        ),
                        InkWell(
                          child: Icon(
                            Icons.move_up,
                            size: 30,
                          ),
                          onTap: () {
                            moveTagsUp(index);
                          },
                          onDoubleTap: () {
                            moveTagsDown(index);
                          },
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    editTags(index);
                  },
                ),
              );
            },
          ),
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      border:
                      Border.all(color: Colors.white.withOpacity(0.6)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: _TagsController,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Tags Here',
                            hintStyle: TextStyle(color: Colors.black),
                            hoverColor: Colors.black,
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 45,
                  ),
                ),
                onTap: () {
                  addTags();
                },
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15, top: 8),
            child: Text(
              "Project Description",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                border: Border.all(color: Colors.white.withOpacity(0.6)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: TextFormField(
                  //obscureText: true,
                  controller: DescriptionController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Description or Full name',
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Text(
              "Images",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: ImageList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(ImageList[index]),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  deleteImages(index);
                },
                child: ListTile(
                  title: Text(ImageList[index],
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                  trailing: SingleChildScrollView(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteImages(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            editImages(index);
                          },
                        ),
                        InkWell(
                          child: Icon(
                            Icons.move_up,
                            size: 30,
                          ),
                          onTap: () {
                            moveImagesUp(index);
                          },
                          onDoubleTap: () {
                            moveImagesDown(index);
                          },
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    editImages(index);
                  },
                ),
              );
            },
          ),
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      border:
                      Border.all(color: Colors.white.withOpacity(0.6)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: _ImageController,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Images Here',
                            hintStyle: TextStyle(color: Colors.black),
                            hoverColor: Colors.black,
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 45,
                  ),
                ),
                onTap: () {
                  addImages();
                },
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Text(
              "Table Of Content",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: tableOfContentList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(tableOfContentList[index]),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  deletetableOfContent(index);
                },
                child: ListTile(
                  title: Text(tableOfContentList[index],
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                  trailing: SingleChildScrollView(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deletetableOfContent(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            edittableOfContent(index);
                          },
                        ),
                        InkWell(
                          child: Icon(
                            Icons.move_up,
                            size: 30,
                          ),
                          onTap: () {
                            movetableOfContentUp(index);
                          },
                          onDoubleTap: () {
                            movetableOfContentDown(index);
                          },
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    edittableOfContent(index);
                  },
                ),
              );
            },
          ),
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      border:
                      Border.all(color: Colors.white.withOpacity(0.6)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: _tableOfContentController,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter tableOfContent Here',
                            hintStyle: TextStyle(color: Colors.black),
                            hoverColor: Colors.black,
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 45,
                  ),
                ),
                onTap: () {
                  addtableOfContent();
                },
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Text(
              "Required Components",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: requiredComponentsList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(requiredComponentsList[index]),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  deleterequiredComponents(index);
                },
                child: ListTile(
                  title: Text(requiredComponentsList[index],
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                  trailing: SingleChildScrollView(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleterequiredComponents(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            editrequiredComponents(index);
                          },
                        ),
                        InkWell(
                          child: Icon(
                            Icons.move_up,
                            size: 30,
                          ),
                          onTap: () {
                            moverequiredComponentsUp(index);
                          },
                          onDoubleTap: () {
                            moverequiredComponentsDown(index);
                          },
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    editrequiredComponents(index);
                  },
                ),
              );
            },
          ),
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      border:
                      Border.all(color: Colors.white.withOpacity(0.6)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: _requiredComponentsController,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter requiredComponents Here',
                            hintStyle: TextStyle(color: Colors.black),
                            hoverColor: Colors.black,
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 45,
                  ),
                ),
                onTap: () {
                  addrequiredComponents();
                },
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Text(
              "Tools Required",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: toolsRequiredList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(toolsRequiredList[index]),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  deletetoolsRequired(index);
                },
                child: ListTile(
                  title: Text(toolsRequiredList[index],
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                  trailing: SingleChildScrollView(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deletetoolsRequired(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            edittoolsRequired(index);
                          },
                        ),
                        InkWell(
                          child: Icon(
                            Icons.move_up,
                            size: 30,
                          ),
                          onTap: () {
                            movetoolsRequiredUp(index);
                          },
                          onDoubleTap: () {
                            movetoolsRequiredDown(index);
                          },
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    edittoolsRequired(index);
                  },
                ),
              );
            },
          ),
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      border:
                      Border.all(color: Colors.white.withOpacity(0.6)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: _toolsRequiredController,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter toolsRequired Here',
                            hintStyle: TextStyle(color: Colors.black),
                            hoverColor: Colors.black,
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 45,
                  ),
                ),
                onTap: () {
                  addtoolsRequired();
                },
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15, top: 8),
            child: Text(
              "Video Url (--YouTube--)",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                border: Border.all(color: Colors.white.withOpacity(0.6)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: TextFormField(
                  // obscureText: true,
                  controller: VideoUrl,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'PDF Url',
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white.withOpacity(0.5),
                    border: Border.all(color: Colors.white),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Text("Back"),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  String HeadingText = "";
                  if (HeadingLastController.text.isNotEmpty) {
                    HeadingText = HeadingFirstController.text +
                        ";" +
                        HeadingLastController.text;
                  } else {
                    HeadingText = HeadingFirstController.text;
                  }
                  if (widget.projectId.length < 3) {
                    FirebaseFirestore.instance
                        .collection("electronicProjects")
                        .doc(getID())
                        .set({


                      "description": DescriptionController.text,
                      "heading": HeadingText,
                      "id": getID(),
                      "images": ImageList.join(';'),
                      "likedBy": [],
                      "requiredComponents": requiredComponentsList,
                      "tableOfContent": tableOfContentList.join(';'),
                      "tags": TagsList.join(";"),
                      "youtubeLink": VideoUrl.text,
                      "views": 0,
                      "comments":0,
                      "toolsRequired": toolsRequiredList,
                    });
                  } else {
                    FirebaseFirestore.instance
                        .collection("electronicProjects")
                        .doc(widget.projectId)
                        .update({
                      "description": DescriptionController.text,
                      "heading": HeadingText,

                      "images": ImageList.join(';'),

                      "requiredComponents": requiredComponentsList,
                      "tableOfContent": tableOfContentList.join(';'),
                      "tags": TagsList.join(";"),
                      "youtubeLink": VideoUrl.text,
                      "toolsRequired": toolsRequiredList,
                    });
                  }
                  Navigator.pop(context);
                },
                child: widget.projectId.length < 3
                    ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white.withOpacity(0.5),
                    border: Border.all(color: Colors.white),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Text("Create"),
                  ),
                )
                    : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white.withOpacity(0.5),
                    border: Border.all(color: Colors.white),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Text("Update"),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          )
        ],
      ),
    ));
  }
}

class arduinoBoardCreator extends StatefulWidget {
  String heading;
  String description;
  String photoUrl;
  String circuitDiagram;
  String id;

  arduinoBoardCreator(
      {Key? key,
      this.circuitDiagram = "",
      this.description = "",
      this.heading = "",
      this.photoUrl = "",
      this.id = ""})
      : super(key: key);

  @override
  State<arduinoBoardCreator> createState() => _arduinoBoardCreatorState();
}

class _arduinoBoardCreatorState extends State<arduinoBoardCreator> {
  final nameController = TextEditingController();
  final DescriptionController = TextEditingController();
  final PhotoUrl = TextEditingController();
  final CircuitDiagram = TextEditingController();

  void AutoFill() {
    nameController.text = widget.heading;
    DescriptionController.text = widget.description;
    PhotoUrl.text = widget.photoUrl;
    CircuitDiagram.text = widget.circuitDiagram;
  }

  @override
  void initState() {
    AutoFill();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    DescriptionController.dispose();
    PhotoUrl.dispose();
    CircuitDiagram.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return backGroundImage(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          backButton(
            size: size(context),
            text: "Arduino Boaed",
          ),
          TextFieldContainer(
            child: TextFormField(
              controller: nameController,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: Colors.white, fontSize: 20),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Heading',
                  hintStyle: TextStyle(color: Colors.white54)),
            ),
            heading: "Board Heading",
          ),
          TextFieldContainer(
            child: TextFormField(
              controller: DescriptionController,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: Colors.white, fontSize: 20),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Description',
                  hintStyle: TextStyle(color: Colors.white54)),
            ),
            heading: "Board Description",
          ),
          TextFieldContainer(
            child: TextFormField(
              controller: PhotoUrl,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: Colors.white, fontSize: 20),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Images',
                  hintStyle: TextStyle(color: Colors.white54)),
            ),
            heading: "Board Images",
          ),
          TextFieldContainer(
            child: TextFormField(
              controller: CircuitDiagram,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: Colors.white, fontSize: 20),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Pin Out',
                  hintStyle: TextStyle(color: Colors.white54)),
            ),
            heading: "Board Pin Out ",
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white.withOpacity(0.5),
                    border: Border.all(color: Colors.white),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: Text("Back"),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  if (widget.id.length < 3) {
                    String id = getID();
                    FirebaseFirestore.instance
                        .collection('arduino')
                        .doc("arduinoBoards")
                        .collection("Board")
                        .doc(id)
                        .set({
                      "id": id,
                      "name": nameController.text.trim(),
                      "pinOut": CircuitDiagram.text.trim(),
                      "description": DescriptionController.text.trim(),
                      "images": PhotoUrl.text.trim()
                    });
                  } else {
                    FirebaseFirestore.instance
                        .collection('arduino')
                        .doc("arduinoBoards")
                        .collection("Board")
                        .doc(widget.id)
                        .update({
                      "name": nameController.text.trim(),
                      "pinOut": CircuitDiagram.text.trim(),
                      "description": DescriptionController.text.trim(),
                      "images": PhotoUrl.text.trim()
                    });
                  }
                  Navigator.pop(context);
                },
                child: widget.id.length < 3
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.5),
                          border: Border.all(color: Colors.white),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          child: Text("Create"),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.5),
                          border: Border.all(color: Colors.white),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          child: Text("Update"),
                        ),
                      ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class arduinoProjectCreator extends StatefulWidget {
  String heading;
  String description;
  String tableOfContent;
  String tags;
  String images;
  String youtubeLink;
  String id;
  List appsAndPlatforms,componentsAndSupplies;

  arduinoProjectCreator(
      {Key? key,
      this.tableOfContent = "",
      this.tags = "",
      this.description = "",
      this.heading = "",
      this.images = "",
      this.youtubeLink = "",
      this.id = "",
        List? appsAndPlatforms,
        List? componentsAndSupplies,
      }): appsAndPlatforms = appsAndPlatforms ?? [],componentsAndSupplies = componentsAndSupplies??[];

  @override
  State<arduinoProjectCreator> createState() => _arduinoProjectCreatorState();
}

class _arduinoProjectCreatorState extends State<arduinoProjectCreator> {
  final HeadingFirstController = TextEditingController();
  final HeadingLastController = TextEditingController();
  final DescriptionController = TextEditingController();
  final tableOfContentController = TextEditingController();
  final componentsAndSuppliesController = TextEditingController();

  final PhotoUrl = TextEditingController();
  final VideoUrl = TextEditingController();




  void AutoFill() {
    HeadingFirstController.text = widget.heading.split(";").first;
    if (widget.heading.split(";").length > 1) {
      HeadingLastController.text = widget.heading.split(";").last;
    }
    DescriptionController.text = widget.description;
    ImageList = widget.images.split(";");
    VideoUrl.text = widget.youtubeLink;
    tableOfContentList = widget.tableOfContent.split(";");
    TagsList = widget.tags.split(";");
    requiredComponentsList = widget.appsAndPlatforms;
    toolsRequiredList = widget.componentsAndSupplies;
  }

  @override
  void initState() {
    if (widget.id.isNotEmpty) AutoFill();
    super.initState();
  }
  
  List ImageList = [];
  final TextEditingController _ImageController = TextEditingController();
  int selectedImageIndex = -1;

  List tableOfContentList = [];
  final TextEditingController _tableOfContentController =
  TextEditingController();
  int selectedtableOfContentIndex = -1;

  List TagsList = [];
  final TextEditingController _TagsController = TextEditingController();
  int selectedTagsIndex = -1;

  List requiredComponentsList = [];
  final TextEditingController _appsAndPlatformsController =
  TextEditingController();
  int selectedrequiredComponentsIndex = -1;

  List toolsRequiredList = [];
  final TextEditingController _toolsRequiredController =
  TextEditingController();
  int selectedtoolsRequiredIndex = -1;

  final CircuitDiagram = TextEditingController();

  void addImages() {
    String points = _ImageController.text;
    if (points.isNotEmpty) {
      setState(() {
        ImageList.add(points);
        _ImageController.clear();
      });
    }
  }

  void editImages(int index) {
    setState(() {
      selectedImageIndex = index;
      _ImageController.text = ImageList[index];
    });
  }

  void saveImages() {
    String editedImage = _ImageController.text;
    if (editedImage.isNotEmpty && selectedImageIndex != -1) {
      setState(() {
        ImageList[selectedImageIndex] = editedImage;
        _ImageController.clear();
        selectedImageIndex = -1;
      });
    }
  }

  void deleteImages(int index) {
    setState(() {
      ImageList.removeAt(index);
      if (selectedImageIndex == index) {
        selectedImageIndex = -1;
        _ImageController.clear();
      }
    });
  }

  void moveImagesUp(int index) {
    if (index > 0) {
      setState(() {
        String point = ImageList.removeAt(index);
        ImageList.insert(index - 1, point);
        if (selectedImageIndex == index) {
          selectedImageIndex--;
        }
      });
    }
  }

  void moveImagesDown(int index) {
    if (index < ImageList.length - 1) {
      setState(() {
        String Image = ImageList.removeAt(index);
        ImageList.insert(index + 1, Image);
        if (selectedImageIndex == index) {
          selectedImageIndex++;
        }
      });
    }
  }

  void addTags() {
    String points = _TagsController.text;
    if (points.isNotEmpty) {
      setState(() {
        TagsList.add(points);
        _TagsController.clear();
      });
    }
  }

  void editTags(int index) {
    setState(() {
      selectedTagsIndex = index;
      _TagsController.text = TagsList[index];
    });
  }

  void saveTags() {
    String editedImage = _TagsController.text;
    if (editedImage.isNotEmpty && selectedTagsIndex != -1) {
      setState(() {
        TagsList[selectedImageIndex] = editedImage;
        _TagsController.clear();
        selectedTagsIndex = -1;
      });
    }
  }

  void deleteTags(int index) {
    setState(() {
      TagsList.removeAt(index);
      if (selectedTagsIndex == index) {
        selectedTagsIndex = -1;
        _TagsController.clear();
      }
    });
  }

  void moveTagsUp(int index) {
    if (index > 0) {
      setState(() {
        String point = TagsList.removeAt(index);
        TagsList.insert(index - 1, point);
        if (selectedTagsIndex == index) {
          selectedTagsIndex--;
        }
      });
    }
  }

  void moveTagsDown(int index) {
    if (index < TagsList.length - 1) {
      setState(() {
        String Image = TagsList.removeAt(index);
        TagsList.insert(index + 1, Image);
        if (selectedTagsIndex == index) {
          selectedTagsIndex++;
        }
      });
    }
  }

  void addtoolsRequired() {
    String points = _toolsRequiredController.text;
    if (points.isNotEmpty) {
      setState(() {
        toolsRequiredList.add(points);
        _toolsRequiredController.clear();
      });
    }
  }

  void edittoolsRequired(int index) {
    setState(() {
      selectedtoolsRequiredIndex = index;
      _toolsRequiredController.text = toolsRequiredList[index];
    });
  }

  void savetoolsRequired() {
    String editedImage = _toolsRequiredController.text;
    if (editedImage.isNotEmpty && selectedtoolsRequiredIndex != -1) {
      setState(() {
        toolsRequiredList[selectedImageIndex] = editedImage;
        _toolsRequiredController.clear();
        selectedtoolsRequiredIndex = -1;
      });
    }
  }

  void deletetoolsRequired(int index) {
    setState(() {
      toolsRequiredList.removeAt(index);
      if (selectedtoolsRequiredIndex == index) {
        selectedtoolsRequiredIndex = -1;
        _toolsRequiredController.clear();
      }
    });
  }

  void movetoolsRequiredUp(int index) {
    if (index > 0) {
      setState(() {
        String point = toolsRequiredList.removeAt(index);
        toolsRequiredList.insert(index - 1, point);
        if (selectedtoolsRequiredIndex == index) {
          selectedtoolsRequiredIndex--;
        }
      });
    }
  }

  void movetoolsRequiredDown(int index) {
    if (index < toolsRequiredList.length - 1) {
      setState(() {
        String Image = toolsRequiredList.removeAt(index);
        toolsRequiredList.insert(index + 1, Image);
        if (selectedtoolsRequiredIndex == index) {
          selectedtoolsRequiredIndex++;
        }
      });
    }
  }

  void addrequiredComponents() {
    String points = _appsAndPlatformsController.text;
    if (points.isNotEmpty) {
      setState(() {
        requiredComponentsList.add(points);
        _appsAndPlatformsController.clear();
      });
    }
  }

  void editrequiredComponents(int index) {
    setState(() {
      selectedrequiredComponentsIndex = index;
      _appsAndPlatformsController.text = requiredComponentsList[index];
    });
  }

  void saverequiredComponents() {
    String editedImage = _appsAndPlatformsController.text;
    if (editedImage.isNotEmpty && selectedrequiredComponentsIndex != -1) {
      setState(() {
        requiredComponentsList[selectedrequiredComponentsIndex] = editedImage;
        _appsAndPlatformsController.clear();
        selectedrequiredComponentsIndex = -1;
      });
    }
  }

  void deleterequiredComponents(int index) {
    setState(() {
      requiredComponentsList.removeAt(index);
      if (selectedrequiredComponentsIndex == index) {
        selectedrequiredComponentsIndex = -1;
        _appsAndPlatformsController.clear();
      }
    });
  }

  void moverequiredComponentsUp(int index) {
    if (index > 0) {
      setState(() {
        String point = requiredComponentsList.removeAt(index);
        requiredComponentsList.insert(index - 1, point);
        if (selectedrequiredComponentsIndex == index) {
          selectedrequiredComponentsIndex--;
        }
      });
    }
  }

  void moverequiredComponentsDown(int index) {
    if (index < requiredComponentsList.length - 1) {
      setState(() {
        String Image = requiredComponentsList.removeAt(index);
        requiredComponentsList.insert(index + 1, Image);
        if (selectedrequiredComponentsIndex == index) {
          selectedrequiredComponentsIndex++;
        }
      });
    }
  }

  void addtableOfContent() {
    String points = _tableOfContentController.text;
    if (points.isNotEmpty) {
      setState(() {
        tableOfContentList.add(points);
        _tableOfContentController.clear();
      });
    }
  }

  void edittableOfContent(int index) {
    setState(() {
      selectedtableOfContentIndex = index;
      _tableOfContentController.text = tableOfContentList[index];
    });
  }

  void savetableOfContent() {
    String editedImage = _tableOfContentController.text;
    if (editedImage.isNotEmpty && selectedtableOfContentIndex != -1) {
      setState(() {
        tableOfContentList[selectedtableOfContentIndex] = editedImage;
        _tableOfContentController.clear();
        selectedtableOfContentIndex = -1;
      });
    }
  }

  void deletetableOfContent(int index) {
    setState(() {
      tableOfContentList.removeAt(index);
      if (selectedtableOfContentIndex == index) {
        selectedtableOfContentIndex = -1;
        _tableOfContentController.clear();
      }
    });
  }

  void movetableOfContentUp(int index) {
    if (index > 0) {
      setState(() {
        String point = tableOfContentList.removeAt(index);
        tableOfContentList.insert(index - 1, point);
        if (selectedtableOfContentIndex == index) {
          selectedtableOfContentIndex--;
        }
      });
    }
  }

  void movetableOfContentDown(int index) {
    if (index < tableOfContentList.length - 1) {
      setState(() {
        String Image = tableOfContentList.removeAt(index);
        tableOfContentList.insert(index + 1, Image);
        if (selectedtableOfContentIndex == index) {
          selectedtableOfContentIndex++;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return backGroundImage(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          backButton(
            size: size(context),
            text: "Arduino Projects",
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Text(
              "Images",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),

            itemCount: ImageList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(ImageList[index]),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  deleteImages(index);
                },
                child: ListTile(
                  title: Text(ImageList[index],style: TextStyle(color: Colors.white70,fontSize: 15,fontWeight: FontWeight.w500),),
                  trailing: SingleChildScrollView(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteImages(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            editImages(index);
                          },
                        ),
                        InkWell(
                          child: Icon(
                            Icons.move_up,
                            size: 30,
                          ),
                          onTap: () {
                            moveImagesUp(index);
                          },
                          onDoubleTap: () {
                            moveImagesDown(index);
                          },
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    editImages(index);
                  },
                ),
              );
            },
          ),
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      border:
                      Border.all(color: Colors.white.withOpacity(0.6)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: _ImageController,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Images Here',
                            hintStyle: TextStyle(color: Colors.black),
                            hoverColor: Colors.black,
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 45,
                  ),
                ),
                onTap: () {
                  addImages();
                },
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15, top: 8),
            child: Text(
              "Project Heading",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: TextFieldContainer(
                    child: TextFormField(
                      controller: HeadingFirstController,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'First',
                          hintStyle: TextStyle(color: Colors.white54)),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: TextFieldContainer(
                      child: TextFormField(
                    controller: HeadingLastController,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Last',
                        hintStyle: TextStyle(color: Colors.white54)),
                  )),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Text(
              "Tags",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),

            itemCount: TagsList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(TagsList[index]),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  deleteTags(index);
                },
                child: ListTile(
                  title: Text(TagsList[index],style: TextStyle(color: Colors.white70,fontSize: 15,fontWeight: FontWeight.w500),),
                  trailing: SingleChildScrollView(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteTags(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            editTags(index);
                          },
                        ),
                        InkWell(
                          child: Icon(
                            Icons.move_up,
                            size: 30,
                          ),
                          onTap: () {
                            moveTagsUp(index);
                          },
                          onDoubleTap: () {
                            moveTagsDown(index);
                          },
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    editTags(index);
                  },
                ),
              );
            },
          ),
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      border:
                      Border.all(color: Colors.white.withOpacity(0.6)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: _TagsController,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Tags Here',
                            hintStyle: TextStyle(color: Colors.black),
                            hoverColor: Colors.black,
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 45,
                  ),
                ),
                onTap: () {
                  addTags();
                },
              )
            ],
          ),
          TextFieldContainer(
            child: TextFormField(
              controller: DescriptionController,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: Colors.white, fontSize: 20),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Description',
                  hintStyle: TextStyle(color: Colors.white54)),
            ),
            heading: "Project Description",
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Text(
              "Table Of Content",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),

            itemCount: tableOfContentList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(tableOfContentList[index]),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  deletetableOfContent(index);
                },
                child: ListTile(
                  title: Text(tableOfContentList[index],style: TextStyle(color: Colors.white70,fontSize: 15,fontWeight: FontWeight.w500),),
                  trailing: SingleChildScrollView(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deletetableOfContent(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            edittableOfContent(index);
                          },
                        ),
                        InkWell(
                          child: Icon(
                            Icons.move_up,
                            size: 30,
                          ),
                          onTap: () {
                            movetableOfContentUp(index);
                          },
                          onDoubleTap: () {
                            movetableOfContentDown(index);
                          },
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    edittableOfContent(index);
                  },
                ),
              );
            },
          ),
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      border:
                      Border.all(color: Colors.white.withOpacity(0.6)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: _tableOfContentController,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter tableOfContent Here',
                            hintStyle: TextStyle(color: Colors.black),
                            hoverColor: Colors.black,
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 45,
                  ),
                ),
                onTap: () {
                  addtableOfContent();
                },
              )
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Text(
              "Project Components And Supplies",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),

            itemCount: toolsRequiredList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(toolsRequiredList[index]),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  deletetoolsRequired(index);
                },
                child: ListTile(
                  title: Text(toolsRequiredList[index],style: TextStyle(color: Colors.white70,fontSize: 15,fontWeight: FontWeight.w500),),
                  trailing: SingleChildScrollView(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deletetoolsRequired(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            edittoolsRequired(index);
                          },
                        ),
                        InkWell(
                          child: Icon(
                            Icons.move_up,
                            size: 30,
                          ),
                          onTap: () {
                            movetoolsRequiredUp(index);
                          },
                          onDoubleTap: () {
                            movetoolsRequiredDown(index);
                          },
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    edittoolsRequired(index);
                  },
                ),
              );
            },
          ),
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      border:
                      Border.all(color: Colors.white.withOpacity(0.6)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: _toolsRequiredController,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Components And Supplies',
                            hintStyle: TextStyle(color: Colors.black),
                            hoverColor: Colors.black,
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 45,
                  ),
                ),
                onTap: () {
                  addtoolsRequired();
                },
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Text(
              "Apps And Platforms",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: requiredComponentsList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(requiredComponentsList[index]),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  deleterequiredComponents(index);
                },
                child: ListTile(
                  title: Text(requiredComponentsList[index],style: TextStyle(color: Colors.white70,fontSize: 15,fontWeight: FontWeight.w500),),
                  trailing: SingleChildScrollView(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleterequiredComponents(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            editrequiredComponents(index);
                          },
                        ),
                        InkWell(
                          child: Icon(
                            Icons.move_up,
                            size: 30,
                          ),
                          onTap: () {
                            moverequiredComponentsUp(index);
                          },
                          onDoubleTap: () {
                            moverequiredComponentsDown(index);
                          },
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    editrequiredComponents(index);
                  },
                ),
              );
            },
          ),
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      border:
                      Border.all(color: Colors.white.withOpacity(0.6)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: _appsAndPlatformsController,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Apps And Platforms',
                            hintStyle: TextStyle(color: Colors.black),
                            hoverColor: Colors.black,
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 45,
                  ),
                ),
                onTap: () {
                  addrequiredComponents();
                },
              )
            ],
          ),
          TextFieldContainer(
            child: TextFormField(
              controller: VideoUrl,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: Colors.white, fontSize: 20),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'YouTube Link',
                  hintStyle: TextStyle(color: Colors.white54)),
            ),
            heading: "Project Youtube Link",
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white.withOpacity(0.5),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Text("Back"),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  String HeadingText = "";
                  if (HeadingLastController.text.isNotEmpty) {
                    HeadingText = HeadingFirstController.text +
                        ";" +
                        HeadingLastController.text;
                  } else {
                    HeadingText = HeadingFirstController.text;
                  }
                  if (widget.id.length < 3) {
                    String id = getID();
                    FirebaseFirestore.instance
                        .collection('arduino')
                        .doc("arduinoProjects")
                        .collection("projects")
                        .doc(id)
                        .set({
                      "id": id,
                      "appsAndPlatforms":requiredComponentsList,
                      "componentsAndSupplies":toolsRequiredList,
                      "tableOfContent": tableOfContentList.join(";"),
                      "tags": TagsList.join(";"),
                      "likedBy": [],
                      "heading": HeadingText,
                      "comments":0,
                      "views": 0,
                      "youtubeLink": VideoUrl.text.trim(),
                      "description": DescriptionController.text.trim(),
                      "images": ImageList.join(";")
                    });
                  } else {
                    FirebaseFirestore.instance
                        .collection('arduino')
                        .doc("arduinoProjects")
                        .collection("projects")
                        .doc(widget.id)
                        .update({
                      "appsAndPlatforms":requiredComponentsList,
                      "componentsAndSupplies":toolsRequiredList,
                      "tableOfContent": tableOfContentList.join(";"),
                      "tags": TagsList.join(";"),
                      "heading": HeadingText,

                      "youtubeLink": VideoUrl.text.trim(),
                      "description": DescriptionController.text.trim(),
                      "images": ImageList.join(";")
                    });
                  }
                  Navigator.pop(context);
                },
                child: widget.id.length < 3
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.5),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          child: Text("Create"),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.5),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          child: Text("Update"),
                        ),
                      ),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          )
        ],
      ),
    ));
  }
}

class DescriptionCreator extends StatefulWidget {
  final String c0;
  final String d0;
  final String c1;
  final String d1;
  final String d2;
  String data;
  String subData;
  String images;
  String table;
  String files;

  DescriptionCreator({
    Key? key,
    required this.c0,
    required this.d0,
    required this.c1,
    required this.d1,
    this.d2 = "",
    this.data = "",
    this.subData = "",
    this.images = "",
    this.table = "",
    this.files = "",
  }) : super(key: key);

  @override
  State<DescriptionCreator> createState() => _DescriptionCreatorState();
}

class _DescriptionCreatorState extends State<DescriptionCreator> {
  List<String> pointsList = [];
  final TextEditingController _pointsController = TextEditingController();
  int selectedPointIndex = -1;

  List<Point> points = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController scoreController = TextEditingController();
  int selectedTableIndex = -1;

  TextEditingController HeadingController = TextEditingController();

  List<String> ImageList = [];
  final TextEditingController _ImageController = TextEditingController();
  int selectedImageIndex = -1;

  List<String> FilesList = [];
  final TextEditingController _FilesController = TextEditingController();
  int selectedFilesIndex = -1;

  @override
  void initState() {
    super.initState();
    autoFill();
  }

  autoFill() {
    if (widget.d2.isNotEmpty) {
      HeadingController.text = widget.data;
      if (widget.subData.isNotEmpty) pointsList = widget.subData.split(";");
      if (widget.images.isNotEmpty) ImageList = widget.images.split(";");
      if (widget.files.isNotEmpty) FilesList = widget.files.split(";");
      if (widget.table.isNotEmpty) parsePointsString(widget.table);
    }
  }

  void addTextField() {
    String points = _pointsController.text;
    if (points.isNotEmpty) {
      setState(() {
        pointsList.add(points);
        _pointsController.clear();
      });
    }
  }

  void editPoint(int index) {
    setState(() {
      selectedPointIndex = index;
      _pointsController.text = pointsList[index];
    });
  }

  void saveEditedPoint() {
    String editedPoint = _pointsController.text;
    if (editedPoint.isNotEmpty && selectedPointIndex != -1) {
      setState(() {
        pointsList[selectedPointIndex] = editedPoint;
        _pointsController.clear();
        selectedPointIndex = -1;
      });
    }
  }

  void deletePoint(int index) {
    setState(() {
      pointsList.removeAt(index);
      if (selectedPointIndex == index) {
        selectedPointIndex = -1;
        _pointsController.clear();
      }
    });
  }

  void movePointUp(int index) {
    if (index > 0) {
      setState(() {
        String point = pointsList.removeAt(index);
        pointsList.insert(index - 1, point);
        if (selectedPointIndex == index) {
          selectedPointIndex--;
        }
      });
    }
  }

  void movePointDown(int index) {
    if (index < pointsList.length - 1) {
      setState(() {
        String point = pointsList.removeAt(index);
        pointsList.insert(index + 1, point);
        if (selectedPointIndex == index) {
          selectedPointIndex++;
        }
      });
    }
  }

  void parsePointsString(String pointsString) {
    List<String> pointStrings = pointsString.split(';');
    List<Point> parsedPoints = [];
    for (String pointString in pointStrings) {
      List<String> parts = pointString.split(':');
      if (parts.length == 2) {
        parsedPoints.add(Point(name: parts[0], score: parts[1]));
      }
    }
    setState(() {
      points = parsedPoints;
    });
  }

  void addTable() {
    String name = nameController.text;
    String scoreText = scoreController.text;
    String score = scoreText;

    if (name.isNotEmpty && score.isNotEmpty) {
      setState(() {
        Point newPoint = Point(name: name, score: score);
        points.add(newPoint);
        nameController.clear();
        scoreController.clear();
      });
    }
  }

  void editTable(int index) {
    Point selectedPoint = points[index];
    setState(() {
      selectedPointIndex = index;
      nameController.text = selectedPoint.name;
      scoreController.text = selectedPoint.score.toString();
    });
  }

  void saveEditedTable() {
    String newName = nameController.text;
    String newScoreText = scoreController.text;
    String newScore = newScoreText;

    if (newName.isNotEmpty && newScore.isNotEmpty && selectedPointIndex != -1) {
      setState(() {
        Point selectedPoint = points[selectedPointIndex];
        selectedPoint.name = newName;
        selectedPoint.score = newScore;
        selectedPointIndex = -1;
        nameController.clear();
        scoreController.clear();
      });
    }
  }

  void deleteTable(int index) {
    setState(() {
      points.removeAt(index);
      if (selectedPointIndex == index) {
        selectedPointIndex = -1;
        nameController.clear();
        scoreController.clear();
      }
    });
  }

  void moveTableUp(int index) {
    if (index > 0) {
      setState(() {
        Point currentPoint = points[index];
        points.removeAt(index);
        points.insert(index - 1, currentPoint);
      });
    }
  }

  void moveTableDown(int index) {
    if (index < points.length - 1) {
      setState(() {
        Point currentPoint = points[index];
        points.removeAt(index);
        points.insert(index + 1, currentPoint);
      });
    }
  }

  void addImages() {
    String points = _ImageController.text;
    if (points.isNotEmpty) {
      setState(() {
        ImageList.add(points);
        _ImageController.clear();
      });
    }
  }

  void editImages(int index) {
    setState(() {
      selectedImageIndex = index;
      _ImageController.text = ImageList[index];
    });
  }

  void saveImages() {
    String editedImage = _ImageController.text;
    if (editedImage.isNotEmpty && selectedImageIndex != -1) {
      setState(() {
        ImageList[selectedImageIndex] = editedImage;
        _ImageController.clear();
        selectedImageIndex = -1;
      });
    }
  }

  void deleteImages(int index) {
    setState(() {
      ImageList.removeAt(index);
      if (selectedImageIndex == index) {
        selectedImageIndex = -1;
        _ImageController.clear();
      }
    });
  }

  void moveImagesUp(int index) {
    if (index > 0) {
      setState(() {
        String point = ImageList.removeAt(index);
        ImageList.insert(index - 1, point);
        if (selectedImageIndex == index) {
          selectedImageIndex--;
        }
      });
    }
  }

  void moveImagesDown(int index) {
    if (index < ImageList.length - 1) {
      setState(() {
        String Image = ImageList.removeAt(index);
        ImageList.insert(index + 1, Image);
        if (selectedImageIndex == index) {
          selectedImageIndex++;
        }
      });
    }
  }

  void addFiles() {
    String Files = _FilesController.text;
    if (Files.isNotEmpty) {
      setState(() {
        FilesList.add(Files);
        _FilesController.clear();
      });
    }
  }

  void editFiles(int index) {
    setState(() {
      selectedFilesIndex = index;
      _FilesController.text = FilesList[index];
    });
  }

  void saveFiles() {
    String editedFiles = _FilesController.text;
    if (editedFiles.isNotEmpty && selectedFilesIndex != -1) {
      setState(() {
        FilesList[selectedFilesIndex] = editedFiles;
        _FilesController.clear();
        selectedFilesIndex = -1;
      });
    }
  }

  void deleteFiles(int index) {
    setState(() {
      FilesList.removeAt(index);
      if (selectedFilesIndex == index) {
        selectedFilesIndex = -1;
        _FilesController.clear();
      }
    });
  }

  void moveFilesUp(int index) {
    if (index > 0) {
      setState(() {
        String Files = FilesList.removeAt(index);
        FilesList.insert(index - 1, Files);
        if (selectedFilesIndex == index) {
          selectedFilesIndex--;
        }
      });
    }
  }

  void moveFilesDown(int index) {
    if (index < FilesList.length - 1) {
      setState(() {
        String Files = FilesList.removeAt(index);
        FilesList.insert(index + 1, Files);
        if (selectedFilesIndex == index) {
          selectedFilesIndex++;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return backGroundImage(child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          backButton(size: size(context),text: "Description",),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Text(
              "ParaGraph",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: TextFormField(
                  controller: HeadingController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(color: Colors.black),
                  maxLines: null,
                  // Allows the field to expand as needed
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                    hintText: 'Heading',
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Text(
              "Points",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: pointsList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(pointsList[index]),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  deletePoint(index);
                },
                child: ListTile(
                  title: selectedPointIndex == index
                      ? TextField(
                    textInputAction: TextInputAction.done,
                    maxLines: null,
                    controller: _pointsController,
                    onEditingComplete: saveEditedPoint,
                  )
                      : Text(pointsList[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deletePoint(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          editPoint(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_upward),
                        onPressed: () {
                          movePointUp(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_downward),
                        onPressed: () {
                          movePointDown(index);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    editPoint(index);
                  },
                ),
              );
            },
          ),
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: _pointsController,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Points Here',
                            hintStyle: TextStyle(color: Colors.black),
                            hoverColor: Colors.black,
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 45,
                  ),
                ),
                onTap: () {
                  addTextField();
                },
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: points.length + 1,
            // Number of rows including the header
            itemBuilder: (context, index) {
              if (index == 0) {
                return Table(
                  border: TableBorder.all(
                    width: 0.8,
                    color: Colors.white70,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: {
                    0: FractionColumnWidth(0.2),
                    1: FractionColumnWidth(0.6),
                    2: FractionColumnWidth(0.2),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Name',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Score',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Actions',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
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
                int dataIndex = index - 1;
                Point point = points[dataIndex];
                return Table(
                  border: TableBorder.all(
                    width: 0.5,
                    color: Colors.white54,
                    borderRadius: dataIndex == points.length - 1
                        ? BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    )
                        : BorderRadius.circular(0),
                  ),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: {
                    0: FractionColumnWidth(0.2),
                    1: FractionColumnWidth(0.6),
                    2: FractionColumnWidth(0.2),
                  },
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              point.name,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              point.score,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                InkWell(
                                  child: Icon(
                                    Icons.published_with_changes,
                                    size: 30,
                                  ),
                                  onTap: () {
                                    editTable(dataIndex);
                                  },
                                  onDoubleTap: () {
                                    deleteTable(dataIndex);
                                  },
                                ),
                                InkWell(
                                  child: Icon(
                                    Icons.move_up,
                                    size: 30,
                                  ),
                                  onTap: () {
                                    moveTableUp(dataIndex);
                                  },
                                  onDoubleTap: () {
                                    moveTableDown(dataIndex);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            controller: nameController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(color: Colors.black),
                            maxLines: null,
                            // Allows the field to expand as needed
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              hintText: 'Parameters',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TextFormField(
                              controller: scoreController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(color: Colors.black),
                              maxLines: null,
                              // Allows the field to expand as needed
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none,
                                hintText: 'Description',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                        flex: 1,
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              selectedPointIndex != -1
                                  ? Icons.save
                                  : Icons.add,
                              size: 45,
                            ),
                          ),
                          onTap: () {
                            selectedPointIndex != -1
                                ? saveEditedTable()
                                : addTable();
                            nameController.clear();
                            scoreController.clear();
                          },
                        ))
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Text(
              "Images",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          ListView.builder(
            itemCount: ImageList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(ImageList[index]),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  deleteImages(index);
                },
                child: ListTile(
                  title: Text(ImageList[index]),
                  trailing: SingleChildScrollView(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteImages(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            editImages(index);
                          },
                        ),
                        InkWell(
                          child: Icon(
                            Icons.move_up,
                            size: 30,
                          ),
                          onTap: () {
                            moveImagesUp(index);
                          },
                          onDoubleTap: () {
                            moveImagesDown(index);
                          },
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    editImages(index);
                  },
                ),
              );
            },
          ),
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: _ImageController,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Images Here',
                            hintStyle: TextStyle(color: Colors.black),
                            hoverColor: Colors.black,
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 45,
                  ),
                ),
                onTap: () {
                  addImages();
                },
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 8),
            child: Text(
              "Files",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          ListView.builder(
            itemCount: FilesList.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(FilesList[index]),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  deleteImages(index);
                },
                child: ListTile(
                  title: Text(FilesList[index]),
                  trailing: SingleChildScrollView(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteFiles(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            editFiles(index);
                          },
                        ),
                        InkWell(
                          child: Icon(
                            Icons.move_up,
                            size: 30,
                          ),
                          onTap: () {
                            moveFilesUp(index);
                          },
                          onDoubleTap: () {
                            moveFilesDown(index);
                          },
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    editFiles(index);
                  },
                ),
              );
            },
          ),
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: _FilesController,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Files Here',
                            hintStyle: TextStyle(color: Colors.black),
                            hoverColor: Colors.black,
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 45,
                  ),
                ),
                onTap: () {
                  addFiles();
                },
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              children: [
                Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white.withOpacity(0.5),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Text("Back"),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                    onTap: () async {
                      String result = '';
                      for (int i = 0; i < points.length; i++) {
                        Point point = points[i];
                        result += '${point.name}:${point.score}';
                        if (i < points.length - 1) {
                          result += ';';
                        }
                      }

                      if (widget.d2.isNotEmpty) {
                        widget.c1.isNotEmpty && widget.d1.isNotEmpty
                            ? FirebaseFirestore.instance
                            .collection(widget.c0)
                            .doc(widget.d0)
                            .collection(widget.c1)
                            .doc(widget.d1)
                            .collection("description")
                            .doc(widget.d2)
                            .update({
                          "data": HeadingController.text,
                          "subData": pointsList.join(';'),
                          "table": result,
                          "images": ImageList.join(';'),
                          "files": FilesList.join(";")
                        })
                            : FirebaseFirestore.instance
                            .collection(widget.c0)
                            .doc(widget.d0)
                            .collection("description")
                            .doc(widget.d2)
                            .update({
                          "data": HeadingController.text,
                          "subData": pointsList.join(';'),
                          "table": result,
                          "images": ImageList.join(';'),
                          "files": FilesList.join(";")
                        });
                      } else {
                        widget.c1.isNotEmpty && widget.d1.isNotEmpty
                            ? FirebaseFirestore.instance
                            .collection(widget.c0)
                            .doc(widget.d0)
                            .collection(widget.c1)
                            .doc(widget.d1)
                            .collection("description")
                            .doc(getID())
                            .set({
                          "id": getID(),
                          "data": HeadingController.text,
                          "subData": pointsList.join(';'),
                          "table": result,
                          "images": ImageList.join(';'),
                          "files": FilesList.join(";")
                        })
                            : FirebaseFirestore.instance
                            .collection(widget.c0)
                            .doc(widget.d0)
                            .collection("description")
                            .doc(getID())
                            .set({
                          "id": getID(),
                          "data": HeadingController.text,
                          "subData": pointsList.join(';'),
                          "table": result,
                          "images": ImageList.join(';'),
                          "files": FilesList.join(";")
                        });
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white.withOpacity(0.5),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child:
                        Text(widget.d2.isNotEmpty ? "Update" : "Create"),
                      ),
                    )),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          )
        ],
      ),
    ),);
  }
}

class Point {
  String name;
  String score;

  Point({required this.name, required this.score});
}
