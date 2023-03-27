import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import '../utils/utils.dart';

class QRCodeGen extends StatefulWidget {
  final String id;
  final String name;
  const QRCodeGen({super.key, required this.id, required this.name});

  @override
  State<QRCodeGen> createState() => _QRCodeGenState();
}

class _QRCodeGenState extends State<QRCodeGen> {
  GlobalKey globalKey = GlobalKey();
  late String token;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // TODO call api to get details
    token = generateAndSignMessage(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Spacer(),
                Text(
                  '$widget.name',
                  style: TextStyle(fontSize: 24),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      _shareQRCode(context);
                    },
                    icon: Icon(Icons.share),
                    label: Text(""),
                  ),
                )
              ]),
              QrImage(
                data: token,
                version: QrVersions.auto,
                size: 300.0,
                gapless: false,
                embeddedImage: AssetImage('assets/qrLogo.png'),
                embeddedImageStyle: QrEmbeddedImageStyle(size: Size(55, 79)),
              ),
              SizedBox(height: 20),
              Text(
                'Share this with the reciever to mark',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'the transaction as complete',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'and recieve your credits',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Back to listing'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // _shareQRCode() async {
  //   final directory = (await getApplicationDocumentsDirectory()).path;
  //   await screenshotController
  //       .capture(delay: const Duration(milliseconds: 10))
  //       .then((Uint8List image) async {
  //     if (image != null) {
  //       final directory = await getApplicationDocumentsDirectory();
  //       final imagePath = await File('${directory.path}/image.png').create();
  //       await imagePath.writeAsBytes(image);

  //       /// Share Plugin
  //       await Share.shareFiles([imagePath.path]);
  //     }
  //   });
  //   // screenshotController
  //   //     .capture()
  //   //     .then((Uint8List image) {
  //   //       // try {
  //   //       String fileName = DateTime.now().microsecondsSinceEpoch.toString();
  //   //       final imagePath = await File('$directory/$fileName.png').create();
  //   //       await imagePath.writeAsBytes(image);
  //   //       // ignore: deprecated_member_use
  //   //       Share.shareFiles([imagePath.path]);
  //   //       // } catch (error) {}
  //   //     } )
  //   //     .catchError((onError) {
  //   //   print(onError);
  //   // });
  // }

  // TODO fix logic for share
  _shareQRCode(context) async {
    // try {
    RenderRepaintBoundary? boundary =
        context.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/image.png').create();
    await file.writeAsBytes(pngBytes);
    Share.shareFiles([file.path]);
    // } catch (e) {
    //   print(e.toString());
    // }
  }

  // _shareQRCode(context) async {
  //   // try {`
  //   final RenderBox box = context.findRenderObject() as RenderBox;
  //   final ui.Image img = new ;
  //   final QrPainter painter = QrPainter(
  //     data: widget.token,
  //     version: QrVersions.auto,
  //     gapless: false,
  //     embeddedImage: img,
  //     embeddedImageStyle: QrEmbeddedImageStyle(size: Size(55, 79)),
  //   );
  //   final ByteData? imageData =
  //       await painter.toImageData(300.0);
  //   RenderRepaintBoundary? boundary =
  //       context.findRenderObject() as RenderRepaintBoundary;
  //   var image = await boundary!.toImage();
  //   ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
  //   Uint8List pngBytes = byteData!.buffer.asUint8List();

  //   final tempDir = await getTemporaryDirectory();
  //   final file = await new File('${tempDir.path}/image.png').create();
  //   await file.writeAsBytes(pngBytes);
  //   Share.shareFiles([file.path]);
  //   // } catch (e) {
  //   //   print(e.toString());
  //   // }
  // }
}
