import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'kullanıcı.dart';
import 'servis/oturum.dart';

class ButonSayfasi extends StatefulWidget {
  @override
  _ButonSayfasiState createState() => _ButonSayfasiState();
}

class _ButonSayfasiState extends State<ButonSayfasi> {
  TextEditingController mailController = TextEditingController();
  TextEditingController koopNoController = TextEditingController();




  Future<void> qrislem(BuildContext context) async {
    final sessionMail = mailController.text;
    final koopNo = koopNoController.text;

    try {
      final response = await http.post(
        Uri.parse('https://binersin.com/panel/islemler/islem.php'),
        body: {
          'qrislem': 'true',
          'koop_no': koopNo,
          'kul_mail': sessionMail,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(response.body);

        if (result['durum'] == 'ok') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['mesaj']),
              backgroundColor: Colors.green,
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buton Sayfası'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: mailController,
              decoration: InputDecoration(labelText: 'E-Posta Adresi'),
            ),
            TextField(
              controller: koopNoController,
              decoration: InputDecoration(labelText: 'Koop No'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await qrislem(context);
              },
              child: Text('QR İşlemi Yap'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    mailController.dispose();
    koopNoController.dispose();
    super.dispose();
  }
}
