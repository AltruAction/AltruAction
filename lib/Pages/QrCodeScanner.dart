import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:recloset/Services/ItemService.dart';
import 'package:recloset/Services/TransactionService.dart';
import 'package:recloset/app_state.dart';

import '../utils/utils.dart';
import 'SuccessPage.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QrCodeScanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              softWrap: true,
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(text: 'Scan the '),
                                  TextSpan(
                                    text: 'QR Code',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  TextSpan(
                                      text:
                                          ' of the item \n to mark it as received.'),
                                ],
                              ),
                            ),
                            const Text(
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                                'Note: This is irreverisble.'),
                          ],
                        )
                      ]),
                ),
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 500.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.green,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      bool isValid =
          isValidStartToken(scanData.code) && verifySignature(scanData.code);

      controller!.pauseCamera();
      if (!isValid) {
        _showInvalidQRCodePopup(controller);
      } else {
        String itemId = getMessage(scanData.code!).split("-")[1];
        print(scanData.code);
        print("getMEssage: ${getMessage(scanData.code!)}");
        print("itemId:: $itemId");
        Item item = await ItemService().getItemById(itemId);
        String userId = "kPGQD7QuzSvOFelAWpSc";
        // Provider.of<ApplicationState>(context, listen: false).user!.uid;
        try {
          await TransactionService()
              .createTransaction(item.owner, userId, itemId);
        } catch (e) {
          // Handle the error
          print('Transaction failed: $e');
          _showErrorPopup(controller, e.toString());
          return;
        }
        _navigateToSuccessPage(item.name);
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    // log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void _showErrorPopup(QRViewController controller, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('$message'),
          actions: [
            TextButton(
              onPressed: () {
                controller!.resumeCamera();
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showInvalidQRCodePopup(QRViewController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid QR Code'),
          content: Text('Please scan a valid QR Code'),
          actions: [
            TextButton(
              onPressed: () {
                controller!.resumeCamera();
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToSuccessPage(name) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SuccessPage(name: name)),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
