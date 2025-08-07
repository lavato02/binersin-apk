import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

import '../../qr.dart';
import '../../servis/oturum.dart';

void main() => runApp(const MaterialApp(home: AnaSayfa()));

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({Key? key}) : super(key: key);

  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final Oturum oturum = Oturum();
  String? kullaniciEmail;
  TextEditingController _koopNoController = TextEditingController();
  final player=AudioPlayer();

  @override
  void initState() {
    super.initState();
    kullaniciEmail = oturum.getKullaniciEmail();
  }

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.lightGreen,

        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: const Text('BİNERSİN'),
          actions: [
            IconButton(
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => QRViewExample(),
                ));
              },
              icon: const Icon(Icons.qr_code),
            ),
            IconButton(
              onPressed: () async {
                GetStorage box = GetStorage();
                await box.remove('kullanici');
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.exit_to_app),
            ),
            if (kullaniciEmail != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(kullaniciEmail!),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<String>(
                future: _getBakiye(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Hata: ${snapshot.error}');
                  } else {
                    return Text('₺: ${snapshot.data}');
                  }
                },
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 4, child: _buildQrView(context)),
              Expanded(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      if (result != null)
                        Text('Taranan Kod: ${result!.code}')
                      else
                        const Text(
                          'Barkodu Tara',
                          style: TextStyle(fontSize: 1),
                        ),
                    ],
                  ),
                ),
              ),
              TextField(
                controller: _koopNoController,
                decoration: InputDecoration(
                  labelText: 'QR kodu tara veya Komperatif no girin.',
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await qrislem(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Gri renk
                  onPrimary: Colors.black, // Beyaz yazı rengi
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "Ödeme Yap",
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

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

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        _koopNoController.text = result?.code ?? '';
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yetkiniz yok.')),
      );
    }
  }

  Future<String> _getBakiye() async {
    try {
      final response = await http.post(
        Uri.parse('https://binersin.com/panel/islemler/islem.php'),
        body: {
          'bakiyesor': 'true',
          'kul_mail': kullaniciEmail!,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(response.body);

        if (result['durum'] == 'ok') {
          return result['bakiye'];
        } else {
          throw 'Bakiye sorgulama başarısız oldu: ${result['mesaj']}';
        }
      } else {
        throw 'Sunucu hatası: ${response.reasonPhrase}';
      }
    } catch (e) {
      throw 'Bir hata oluştu: $e';
    }
  }

  Future<void> qrislem(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('https://binersin.com/panel/islemler/islem.php'),
        body: {
          'qrislem': 'true',
          'koop_no': _koopNoController.text,
          'kul_mail': kullaniciEmail!,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(response.body);

        if (result['durum'] == 'ok') {
          player.play(AssetSource('ses.mp3'));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['mesaj']),
              backgroundColor: Colors.green,
            ),
          );
        } else if (result['durum'] == 'baki') {
          player.play(AssetSource('ses2.mp3')); // Play different sound
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['mesaj']),
              backgroundColor: Colors.blue, // You can customize the color
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['mesaj']),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sunucu hatası: ${response.reasonPhrase}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bir hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  void dispose() {
    controller?.dispose();
    _koopNoController.dispose();
    super.dispose();
    }
}