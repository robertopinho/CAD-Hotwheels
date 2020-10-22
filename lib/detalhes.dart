import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Detalhes extends StatefulWidget {
  final DocumentSnapshot document;

  Detalhes(this.document);

  @override
  _DetalhesState createState() => _DetalhesState();
}

class _DetalhesState extends State<Detalhes> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              CollectionReference cars =
                  await Firestore.instance.collection('cars');
              await cars.document(widget.document.documentID).delete();
              Navigator.pop(context);
            },
            color: Colors.white,
            icon: Icon(Icons.delete),
          )
        ],
        title: Text('Hotwheels: ' +widget.document['modelo']),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(),
            SizedBox(
              height: 10,
            ),
            Image.network(
              widget.document['urlImagem'],
              height: 400,
              alignment: Alignment.center,
            ),

            ListTile(
              title: Text('Modelo: ' + widget.document['modelo'],
                  style: TextStyle(fontSize: 30, color: Colors.red)),
              subtitle: Text(
                'Código: ' +widget.document['codCarro']+
                  '\nCor predominante: ' +
                      widget.document['cor'] +
                      '\nAno Série: ' +
                      widget.document['ano'],
                  style: TextStyle(fontSize: 25)),
              // isThreeLine: true,
            )
          ],
        ),
      ),
    );
  }
}
