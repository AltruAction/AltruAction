import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../Data/ListingProvider.dart';
import 'ImageFromGalleryEx.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

enum ImageSourceType { gallery, camera }

const double IMAGE_WIDTH = 150;

class AddPhoto extends StatefulWidget {
  final int index;

  const AddPhoto({Key? key, required this.index}) : super(key: key);

  @override
  State<AddPhoto> createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  var imagePicker;
  var _image;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  // Future uploadFile() async {
  //   if (_image == null) return;
  //   final fileName = p.basename(_image!.path);
  //   final destination = 'files/$fileName';

  //   try {
  //     final ref = firebase_storage.FirebaseStorage.instance
  //         .ref(destination)
  //         .child('file/');

  //     await ref.putFile(_image!);
  //     var downloadUrl = await ref.getDownloadURL();
  //     Provider.of<ListingProvider>(context, listen: false)
  //         .addDownloadUrl(downloadUrl, widget.index);
  //   } catch (e) {
  //     print('error occured');
  //   }
  // }

  Future getImagefromCamera() async {
    XFile image = await imagePicker.pickImage(source: ImageSource.camera);

    Provider.of<ListingProvider>(context, listen: false)
        .add(Item(image), widget.index);

    setState(() {
      _image = File(image.path);
      // uploadFile();
    });
  }

  Future getImagefromGallery() async {
    print(widget.index);
    XFile image = await imagePicker.pickImage(source: ImageSource.gallery);

    Provider.of<ListingProvider>(context, listen: false)
        .add(Item(image), widget.index);

    setState(() {
      _image = File(image.path);
      // uploadFile();
    });
  }

  Future showUploadImageModal() {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.green,
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FloatingActionButton(
                onPressed: getImagefromCamera,
                tooltip: "pickImage",
                child: const Icon(Icons.add_a_photo),
              ),
              FloatingActionButton(
                onPressed: getImagefromGallery,
                tooltip: "Pick Image",
                child: const Icon(Icons.add_photo_alternate),
              )
            ],
          )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      // TODO: make ink not spill out of image
      child: _image != null
          // TODO: make it such that the code for onTap is not repeated
          ? InkWell(
              child: Image.file(
                _image,
                fit: BoxFit.scaleDown,
                width: IMAGE_WIDTH,
                height: IMAGE_WIDTH,
              ),
              onTap: () {
                showUploadImageModal();
              })
          : Ink.image(
              image: AssetImage('assets/addItem.png'),
              fit: BoxFit.scaleDown,
              width: IMAGE_WIDTH,
              height: IMAGE_WIDTH,
              child: InkWell(
                onTap: () {
                  showUploadImageModal();
                },
              ),
            ),
    );
  }
}
