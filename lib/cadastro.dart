import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NovoCarro extends StatefulWidget {
  @override
  _NovoCarroState createState() => _NovoCarroState();
}

class _NovoCarroState extends State<NovoCarro> {
  bool loading = false;
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  var _modeloCarro = TextEditingController();
  var _anoCarro = TextEditingController();
  var _urlImagemCarro = TextEditingController();

  var _codCarro = TextEditingController();
  // var _serieCarro = TextEditingController();
  var _numSerieCarro = TextEditingController();
  var _corCarro = TextEditingController();

  File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(title: Text('Adicionar novo Carro'),
      backgroundColor: Colors.red,),
      body: _body(),
    );
  }

  Container _body() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _modeloCarro,
            keyboardType: TextInputType.name,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(labelText: 'Modelo:'),
          ),
          TextFormField(
            controller: _codCarro,
            keyboardType: TextInputType.name,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(labelText: 'Código do Carro'),
          ),
          TextFormField(
            controller: _anoCarro,
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(labelText: 'Ano de fabricação:'),
          ),
          TextFormField(
            controller: _corCarro,
            keyboardType: TextInputType.name,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(labelText: 'Cor predominante:'),
          ),
          // TextFormField(
          //   controller: _serieCarro,
          //   keyboardType: TextInputType.name,
          //   style: TextStyle(fontSize: 20),
          //   decoration: InputDecoration(labelText: 'Serie do Carro'),
          // ),
          // TextFormField(
          //   controller: _numSerieCarro,
          //   keyboardType: TextInputType.number,
          //   style: TextStyle(fontSize: 20),
          //   decoration: InputDecoration(labelText: 'Número da Serie'),
          // ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                iconSize: 40,
                color: Colors.red,
                alignment: AlignmentDirectional.centerEnd,
                icon: Icon(Icons.photo_camera),
                onPressed: () {
                  _getImage();
                },
              ),
            ],
          ),
          Expanded(
              child: _image == null
                  ? Container()
                  : Image.file(
                      _image,
                      fit: BoxFit.cover,
                    )),
          SizedBox(
            height: 10,
          ),
          loading ? LinearProgressIndicator() : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 40,
                child: RaisedButton(

                  onPressed: () {
                    if (!loading) {
                      _salvar();
                    }
                  },
                  color: loading ? Colors.grey : Colors.red,
                  child: Text(
                    'Salvar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _salvar() async {
    if (_modeloCarro.text.isEmpty ||
        _anoCarro.text.isEmpty ||
        _corCarro.text.isEmpty) {
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                title: new Text('Atenção...'),
                content: new Text('Por favor, preencha todos os campos.'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
      return;
    }
    await Firestore.instance.collection('cars').add({
      'modelo': _modeloCarro.text.toUpperCase(),
      'ano': _anoCarro.text.toUpperCase(),
       'codCarro': _codCarro.text.toUpperCase(),
      // 'seriaCarro': _serieCarro.text,
      //  'numSerie': _numSerieCarro.text,
      'cor': _corCarro.text.toUpperCase(),
      'urlImagem': _urlImagemCarro.text,
    });
    setState(() {
      _modeloCarro.text = '';
      _anoCarro.text = '';
       _codCarro.text = '';
      // _serieCarro.text = '';
       _numSerieCarro.text = '';
      _corCarro.text = '';
      _urlImagemCarro.text = '';
      _image = null;
    });

    scaffoldkey.currentState.showSnackBar(SnackBar(
      content: Text("Salvo com sucesso!"),
    ));
  }

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _salvarImagem();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _salvarImagem() async {
    if (_image != null) {
      setState(() {
        loading = true;
      });
      final StorageUploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        loading = false;
      });
      _urlImagemCarro.text = url;
    }
  }


}
