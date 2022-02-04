import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Note> fetchNote() async {
  final response = await http.get(
      Uri.parse('https://mocki.io/v1/a4d88ff1-c2d9-4310-a92f-63cf66beaff1'));
//odbiera adres
  if (response.statusCode == 200) {
    return Note.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load note');
  }
  //flaga status code = 200 to wystwietli. Nie rozumiem o chuj chodzi ze akurat 200. Czy chodzi o response http 200 ok success status?
  //czyli zwyczajnie informacja zwrotna ze odebralo?
}

class Note {
  final String content;
  final String title;

  const Note({
    required this.content,
    required this.title,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      content: json['content'],
      title: json['title'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Note> futureNote;

  @override
  void initState() {
    super.initState();
    futureNote = fetchNote();
  }
//wywoluje fetch do zaciagania data z servera?

// Although it’s convenient, it’s not recommended to put an API call in a build() method.
// Flutter calls the build() method every time it needs to
// change anything in the view, and this happens surprisingly often.
// The fetchAlbum() method, if placed inside build(), is
// repeatedly called on each rebuild causing the app to slow down.
// Storing the fetchAlbum() result in a state variable ensures that
// the Future is executed only once and then cached for subsequent rebuilds.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Note>(
            //sluzy do wyswietlania daty na ekranie
            future: futureNote,
            //future ktora chce pracowac w wypadku kiedy bedzie fetchowany z serwera
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.title);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
              //jeśli sie nie uda to wypierdoli animacje myslenia socialisty
              // na pytanie odnosnie jaka plec aktualnie reprezentuje
            },
          ),
        ),
      ),
    );
  }
}
