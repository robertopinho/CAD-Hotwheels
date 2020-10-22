import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotwheels/lista.dart';
import 'detalhes.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<DocumentSnapshot> cars =[];

  TextEditingController pesquisa = TextEditingController();

  bool loading = false;

  void Pesquisa(String texto) async {
    setState(() {
      loading = true;
    });
    List<DocumentSnapshot> documentList;
    documentList = (await Firestore.instance
            .collection("cars")
            .where('modelo', isEqualTo: texto.toUpperCase())
            .getDocuments())
        .documents;

    setState(() {
      cars.clear();
      cars = documentList;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesquisa HOTWHEELS'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(labelText: 'Pesquisa por modelo:'),
                onChanged: (valor) {
                  Pesquisa(valor);
                },
              ),
            ),
            Expanded(
              child:
                Lista(cars),
            )
          ],
        ),
      ),
    );
  }
}
