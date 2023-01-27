import 'dart:convert';
import 'dart:io';

import 'package:ceeb_mobile/controllers/reader_controller.dart';
import 'package:ceeb_mobile/models/reader.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class SynchronizeController {
  final uuid = Uuid();
  final baseUrl = 'https://ceeb-admin.vercel.app/api/';

  Future<void> synchronize() async {
    try {
      print('enviar dados');
      final readerController = ReaderController();
      final readers = await readerController.listForSynchronize();
      print(readers);

      final response = await http.post(
        Uri.parse('$baseUrl/synchronize'),
        // headers: <String, String>{
        //   'Content-Type': 'application/json; charset=UTF-8',
        // },
        body: jsonEncode(<String, String>{
          'title': "ola http",
        }),
      );

      // final response = await http.get(
      //   Uri.parse('http://192.168.1.6:3000/api/synchronize'),
      //   // headers: {
      //   //   HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
      //   //   HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      //   // },
      // );
    } catch (e) {
      print('----------');
      print(e);
    }
    //leitores
  }

  Future<void> sendReaders(List<Reader> readers) async {}
}
