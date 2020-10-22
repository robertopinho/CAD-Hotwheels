import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotwheels/cadastro.dart';
import 'package:hotwheels/detalhes.dart';
import 'package:hotwheels/search.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Search()));
              },
              icon: Icon(
                Icons.search,
                size: 37,
              ),
            )
          ],
          title: Text(
            'HOTWHEELS',
            style: TextStyle(
                fontSize: 30,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1
                  ..color = Colors.white),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            child: Text(
              'MINHA LISTA DE CARROS',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: _body(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NovoCarro()));
          },
          tooltip: 'Novo Carro',
          child: const Icon(Icons.add),
        ));
  }

  Column _body(context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('cars').snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  List<DocumentSnapshot> cars = snapshot.data.documents;
                  return ListView.builder(
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        selected: true,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Detalhes(cars[index])));
                        },
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(cars[index].data['urlImagem']),
                        ),
                        title: Text(cars[index].data['modelo']),
                        subtitle: Text(cars[index].data['ano']),
                      );
                    },
                  );
              }
            },
          ),
        ),
      ],
    );
  }
}
