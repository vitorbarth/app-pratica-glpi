import 'package:flutter/material.dart';
import 'inicial.dart';
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


class Edit extends StatefulWidget {
  final ListItem item;
  final String session;
  Edit({this.item, this.session});
  @override
  _EditState createState() => _EditState(item: this.item, session: this.session);
}

class _EditState extends State<Edit> {
  final ListItem item;
  final String session;
  _EditState({this.item, this.session});

  final txtTitulo = TextEditingController();
  final txtMensagem = TextEditingController();

  final lStatus = List<Valor>();
  final lPrioridade = List<Valor>();
  final lImpacto = List<Valor>();
  final lUrgencia = List<Valor>();

  Valor selectedStatus;
  Valor selectedPrioridade;
  Valor selectedImpacto;
  Valor selectedUrgencia;

  void initState() {
    _setValores();
    super.initState();
  }

  void _setValores(){



    lStatus.add(new Valor(1, "Novo"));
    lStatus.add(new Valor(2, "Atrubuído"));
    lStatus.add(new Valor(3, "Planejado"));
    lStatus.add(new Valor(4, "Pendente"));
    lStatus.add(new Valor(5, "Solucionado"));
    lStatus.add(new Valor(6, "Fechado"));

    lPrioridade.add(new Valor(1, "Muito Baixa"));
    lPrioridade.add(new Valor(2, "Baixa"));
    lPrioridade.add(new Valor(3, "Média"));
    lPrioridade.add(new Valor(4, "Alta"));
    lPrioridade.add(new Valor(5, "Muito Alta"));

    lImpacto.add(new Valor(1, "Muito Baixa"));
    lImpacto.add(new Valor(2, "Baixa"));
    lImpacto.add(new Valor(3, "Média"));
    lImpacto.add(new Valor(4, "Alta"));
    lImpacto.add(new Valor(5, "Muito Alta"));

    lUrgencia.add(new Valor(1, "Muito Baixa"));
    lUrgencia.add(new Valor(2, "Baixa"));
    lUrgencia.add(new Valor(3, "Média"));
    lUrgencia.add(new Valor(4, "Alta"));
    lUrgencia.add(new Valor(5, "Muito Alta"));


    if (item != null){
        txtTitulo.text = item.name;
        txtMensagem.text = item.content;
        selectedImpacto = GetValue(lImpacto, item.impact);
        selectedUrgencia = GetValue(lUrgencia, item.urgency);
        selectedPrioridade = GetValue(lPrioridade, item.priority);
        selectedStatus = GetValue(lStatus, item.status);
    }

  }

  Valor GetValue(List<Valor> lista, String texto) {
      for(Valor x in lista){
        if (x.valor == texto){
          return x;
        }
      }
      return null;

  }
  Future Salvar() async {
    String url = "http://187.109.233.147:55598/glpi/apirest.php/";
    String chave = "gP5Z23wHqItcI2Wc81lJ7fjQIAeBMehq7QAVgXoG";

    final response = await http.post(
        url + "ticket/",
        headers: {'App-Token': chave, 'Session-Token': this.session, 'Content-Type':'application/json'},
        body: '{"input": {"name": "${txtTitulo.text}", "content":"${txtMensagem.text}", "status": ${selectedStatus.chave}, "priority": ${selectedPrioridade.chave}, "impact": ${selectedImpacto.chave}, "urgency": ${selectedUrgencia.chave} }}'

    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      return null;
    }

    final res = json.decode(response.body);
    //String session =  responseJson['session_token'];
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Inicial(session: session)


      ),
    );

  }

  Future Editar() async {
    String url = "http://187.109.233.147:55598/glpi/apirest.php/";
    String chave = "gP5Z23wHqItcI2Wc81lJ7fjQIAeBMehq7QAVgXoG";

    final response = await http.put(
        url + "ticket/"+item.id.toString(),
        headers: {'App-Token': chave, 'Session-Token': this.session, 'Content-Type':'application/json'},
        body: '{"input": {"name": "${txtTitulo.text}", "content":"${txtMensagem.text}", "status": ${selectedStatus.chave}, "priority": ${selectedPrioridade.chave}, "impact": ${selectedImpacto.chave}, "urgency": ${selectedUrgencia.chave} }}'

    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      return null;
    }

    final res = json.decode(response.body);
    //String session =  responseJson['session_token'];
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Inicial(session: session)


      ),
    );

  }

  void _saveItem(){
    if (item == null){
      Salvar();
    } else {
      Editar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("Editar chamado"),
      ),
      body: Center(
        child: Column(

          children: <Widget>[
            new Padding(padding: EdgeInsets.only(top: 20.0,right: 10.0)),

            TextField(
              obscureText: false,
              controller: txtTitulo,
              decoration: InputDecoration(
                border: OutlineInputBorder(),

                labelText: 'Título',
              ),

            ),
            Padding(padding: EdgeInsets.only(top: 5)),
            TextField (
              controller: txtMensagem,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mensagem',
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Text('Status do chamado:'),
            Padding(padding: EdgeInsets.only(top: 5)),
            DropdownButton<Valor>(
              value: selectedStatus,
              onChanged: (Valor newValue) {
                setState(() {
                  selectedStatus = newValue;
                });
              },
              items: lStatus.map((Valor valor) {
                return new DropdownMenuItem<Valor>(
                  value: valor,
                  child: new Text(
                    valor.valor,
                    style: new TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),

            Padding(padding: EdgeInsets.only(top: 10)),
            Text('Prioridade:'),
            Padding(padding: EdgeInsets.only(top: 5)),
            DropdownButton<Valor>(
              value: selectedPrioridade,
              onChanged: (Valor newValue) {
                setState(() {
                  selectedPrioridade = newValue;
                });
              },
              items: lPrioridade.map((Valor valor) {
                return new DropdownMenuItem<Valor>(
                  value: valor,
                  child: new Text(
                    valor.valor,
                    style: new TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),

            Padding(padding: EdgeInsets.only(top: 10)),
            Text('Impacto:'),
            Padding(padding: EdgeInsets.only(top: 5)),
            DropdownButton<Valor>(
              value: selectedImpacto,
              onChanged: (Valor newValue) {
                setState(() {
                  selectedImpacto = newValue;
                });
              },
              items: lImpacto.map((Valor valor) {
                return new DropdownMenuItem<Valor>(
                  value: valor,
                  child: new Text(
                    valor.valor,
                    style: new TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),

            Padding(padding: EdgeInsets.only(top: 10)),
            Text('Urgência:'),
            Padding(padding: EdgeInsets.only(top: 5)),
            DropdownButton<Valor>(
              value: selectedUrgencia,
              onChanged: (Valor newValue) {
                setState(() {
                  selectedUrgencia = newValue;
                });
              },
              items: lUrgencia.map((Valor valor) {
                return new DropdownMenuItem<Valor>(
                  value: valor,
                  child: new Text(
                    valor.valor,
                    style: new TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),


          ],
        ),
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveItem,
          tooltip: 'Increment',
          child: Icon(Icons.save),
        )
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


class Valor {

  final int chave;
  final String valor;

  Valor(

      this.chave,
      this.valor
      );
}
