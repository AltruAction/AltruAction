import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

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
                Container(
                  width: 200,
                  child: Text(
                    '${widget.name}',
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 24),
                  ),
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

  _shareQRCode(context) async {
    final QrPainter painter = QrPainter(
      data: token,
      version: QrVersions.auto,
      gapless: false,
      emptyColor: Colors.white,
      embeddedImage: await getImageFromAsset('assets/qrLogo.png'),
      embeddedImageStyle: QrEmbeddedImageStyle(size: Size(165, 237)),
    );
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    String path = '$tempPath/$ts.png';
    final picData =
        await painter.toImageData(900, format: ui.ImageByteFormat.png);
    await writeToFile(picData!, path);

    await Share.shareFiles([path],
        subject: 'QR Code for ${widget.name}',
        text: 'Please scan me to complete the transaction for ${widget.name}');
  }

  Future<void> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<ui.Image> getImageFromAsset(String path) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();
    final image = await decodeImageFromList(bytes);

    return image;
  }
}
