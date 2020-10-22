import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'detalhes.dart';

class Lista extends StatelessWidget {
  List<DocumentSnapshot> cars = [];

  Lista(this.cars);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cars.length,
      itemBuilder: (context, index) {
        return ListTile(
          selected: true,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Detalhes(cars[index])));
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(cars[index]['urlImagem']),
          ),
          title: Text(cars[index]['modelo']),
          subtitle: Text(cars[index]['ano']),
        );
      },
    );
  }
}
