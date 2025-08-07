import 'package:musa/sabitler/ext.dart';
import 'package:musa/sayfalar/oturum/anasayfa.dart';
import 'package:musa/sayfalar/oturum/giris.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

main() async {
  await  GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Binersin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: oturum_kontrol()? AnaSayfa(): GirisSayfasi(),
    );
  }
}
