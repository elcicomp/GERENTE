import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=1575bbbb";


// void main() async {
//   runApp(MaterialApp(home: CotacaoAtual(),
//     theme: ThemeData(
//         hintColor: Colors.red,
//         primaryColor: Colors.black,
//         inputDecorationTheme: InputDecorationTheme(
//           enabledBorder:
//           OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
//           focusedBorder:
//           OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
//           hintStyle: TextStyle(color: Colors.red),
//         )
//     ),
//   ));
// }

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class CotacaoAtual extends StatefulWidget {
  @override
  _CotacaoAtualState createState() => _CotacaoAtualState();
}

class _CotacaoAtualState extends State<CotacaoAtual> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }
  void _realChanged(String text){
    if (text.isEmpty){
      _clearAll();
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }
  void _dolarChanged(String text){
    if (text.isEmpty){
      _clearAll();
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }
  void _euroChanged(String text){
    if (text.isEmpty){
      _clearAll();
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text("Cotação atual para R\$ | \$ | €"),
          backgroundColor: Colors.indigo,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text(
                        "Carregando Dados...",
                        style: TextStyle(color: Colors.black, fontSize: 25.0),
                        textAlign: TextAlign.center,)
                  );
                default:
                  if(snapshot.hasError){
                    return Center(
                        child: Text("Erro ao Carregar Dados :(",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25.0),
                          textAlign: TextAlign.center,)
                    );
                  } else {
                    dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on, size: 100.0, color: Colors.amber),
                          buildTextField("Reais", "   R\$", realController, _realChanged),
                          Divider(),
                          buildTextField("Dólares", "US\$", dolarController, _dolarChanged),
                          Divider(),
                          buildTextField("Euros", "     €", euroController, _euroChanged),
                        ],
                      ),
                    );
                  }
              }
            })
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController c, Function f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(),
        prefixText: prefix
    ),
    style: TextStyle(
        color: Colors.black, fontSize: 25.0
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}