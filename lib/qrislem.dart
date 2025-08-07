import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:musa/sabitler/ext.dart';

class QRIIslem {
  GetStorage box = GetStorage();

  Future<void> qrislem(BuildContext context, String girisYapanID) async {
    http.Response bakiyeSonuc = await http.post(Uri.parse(api_link), body: {
      'qrislem': 'true',
      'girisYapanID': girisYapanID,
    });

    if (bakiyeSonuc.statusCode == 200) {
      try {
        Map<String, dynamic> bakiyeJson = jsonDecode(bakiyeSonuc.body);

        if (bakiyeJson != null && bakiyeJson is Map<String, dynamic>) {
          if (bakiyeJson["durum"] == "ok") {
            print("Bakiye işlemleri başarıyla tamamlandı");
          } else if (bakiyeJson["durum"] == "no") {
            print("Bakiye işlemleri sırasında bir hata oluştu");
          } else {
            print("Bilinmeyen bir durum oluştu");
          }
        } else {
          print("JSON dönüşüm hatası: Geçersiz format");
        }
      } catch (e) {
        print("JSON dönüşüm hatası: $e");
      }
    } else {
      print(
          "İşleminizi şu anda gerçekleştiremiyoruz, Lütfen daha sonra tekrar deneyiniz");
    }
  }
}
