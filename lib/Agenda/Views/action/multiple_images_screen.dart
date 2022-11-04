import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Utils/utility_file.dart';

class MultipleImageScreen extends StatefulWidget {
  const MultipleImageScreen({Key? key}) : super(key: key);

  @override
  State<MultipleImageScreen> createState() => _MultipleImageScreenState();
}

class _MultipleImageScreenState extends State<MultipleImageScreen> {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<String> base64List = [];
  String base64String = '';

  //CarouselController buttonCarouselController = CarouselController();
  //int pageIndex=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Image Picker Example"),
        ),
        body: Center(
          child: Column(
            children: [
              MaterialButton(
                  color: Colors.blue,
                  child: const Text("Pick Images from Gallery",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: ((builder) => bottomSheet()),
                    );
                  }),
              SizedBox(
                height: 20,
              ),
              /* Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                        itemCount: imageFileList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Image.file(File(imageFileList[index].path), fit: BoxFit.cover);
                        }
                    ),
                  )
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CarouselSlider(
                      items: generateImagesTile(),
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16/9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          viewportFraction: 1,
                          onPageChanged: (index, carouselReason){

                          }
                        ),
                      carouselController: buttonCarouselController,
                    ),
                  )
              ), */
              imageFileList.length == 0
                  ? Container()
                  : Expanded(
                      child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ImageSlideshow(
                        children: generateImagesTile(),
                        autoPlayInterval: 3000,
                        isLoop: true,
                        width: double.infinity,
                        height: 200,
                        initialPage: 0,
                        indicatorColor: Colors.blue,
                        indicatorBackgroundColor: Colors.grey,
                      ),
                    )),
              /*Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          height: 300,
                          width: double.infinity,
                          child: PageView(
                            children: generateImagesTile(),

                            onPageChanged: (index){
                              setState(() {
                                pageIndex=index;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 40,),
                        CarouselIndicator(
                          count: imageFileList!.length,
                          index: pageIndex,
                        ),
                      ],
                    ),
                  )
              ),

               Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Swiper(
                        itemCount: imageFileList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Image.file(File(imageFileList[index].path), fit: BoxFit.cover);
                        },
                      //pagination: new SwiperPagination(),
                      //control: new SwiperControl(),
                      itemHeight: 500.0,
                    ),
                  )
              ), */
            ],
          ),
        ));
  }

  List<Widget> generateImagesTile() {
    return imageFileList
        .map((element) => ClipRRect(
              child: Image.file(File(element.path), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(10.0),
            ))
        .toList();
  }

  //2.Create BottomSheet
  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                  width: MediaQuery.of(context).size.width / 1.1, height: 50),
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Color(0xFD18A3A8)),
                  padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                ),
                icon: Icon(Icons.image),
                label: Text(
                  'Camera',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {
                  if (imageFileList.length >= 5) {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.SCALE,
                      dialogType: DialogType.ERROR,
                      body: Center(
                        child: Text(
                          "You can choose 5 images maximum",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      title: 'Cancel',
                      btnOkOnPress: () {
                        Navigator.of(context).pop();
                      },
                    )..show();
                    return;
                  }
                  takePhoto(ImageSource.camera);
                },
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                  width: MediaQuery.of(context).size.width / 1.1, height: 50),
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Color(0xFD147FAA)),
                  padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                ),
                icon: Icon(Icons.image),
                label: Text(
                  'Gallery',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {
                  if (imageFileList.length >= 5) {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.SCALE,
                      dialogType: DialogType.ERROR,
                      body: Center(
                        child: Text(
                          "You can choose 5 images maximum",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      title: 'Cancel',
                      btnOkOnPress: () {
                        Navigator.of(context).pop();
                      },
                    )..show();
                    return;
                  }
                  selectImages();
                },
              ),
            ),
            /* FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                if(imageFileList.length >= 5){
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.SCALE,
                    dialogType: DialogType.ERROR,
                    body: Center(child: Text(
                      "You can choose 5 images maximum",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),),
                    title: 'Cancel',
                    btnOkOnPress: () {
                      Navigator.of(context).pop();
                    },
                  )..show();
                  return;
                }
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            SizedBox(width : 20.0,),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                if(imageFileList.length >= 5){
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.SCALE,
                    dialogType: DialogType.ERROR,
                    body: Center(child: Text(
                      "You can choose 5 images maximum",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),),
                    title: 'Cancel',
                    btnOkOnPress: () {
                      Navigator.of(context).pop();
                    },
                  )..show();
                  return;
                }
                selectImages();
              },
              label: Text("Gallery"),
            ), */
          ])
        ],
      ),
    );
  }

  void selectImages() async {
    try {
      //multi image picker
      final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
      if (selectedImages!.isNotEmpty) {
        imageFileList.addAll(selectedImages);
        //print('images list ${imageFileList}');
        for (var i = 0; i < selectedImages.length; i++) {
          final byteData = await selectedImages[i].readAsBytes();
          base64String = base64Encode(byteData);
          //print('base64String ${base64String}');
          base64List.add(base64String);
          print('list from gallery ${base64List}');
        }
      }
      setState(() {});
      Navigator.of(context).pop();
    } catch (error) {
      debugPrint(error.toString());
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(
          child: Text(
            error.toString(),
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        title: 'Error',
        btnCancel: Text('Cancel'),
        btnOkOnPress: () {
          Navigator.of(context).pop();
        },
      )..show();
    }
  }

  takePhoto(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      imageFileList.add(photo);
      setState(() {
        //pickedImage = tempImage;
        base64String = UtilityFile.base64String(tempImage.readAsBytesSync());
        base64List.add(base64String);
        print('list from camera ${base64List}');
      });

      Navigator.of(context).pop();
    } catch (error) {
      debugPrint(error.toString());
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(
          child: Text(
            error.toString(),
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        title: 'Error',
        btnCancel: Text('Cancel'),
        btnOkOnPress: () {
          Navigator.of(context).pop();
        },
      )..show();
    }
  }
}
