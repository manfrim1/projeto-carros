import 'package:cached_network_image/cached_network_image.dart';
import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/carros/carro.dart';

import 'package:carros/pages/carros/carros_api.dart';
import 'package:carros/pages/carros/loripsum_api.dart';


import 'package:carros/utils/alert.dart';

import 'package:carros/utils/nav.dart';
import 'package:carros/widgets/text.dart';
import 'package:flutter/material.dart';


class CarroPage extends StatefulWidget {
  final Carro carro;

  CarroPage(this.carro);

  @override
  _CarroPageState createState() => _CarroPageState();
}

class _CarroPageState extends State<CarroPage> {
  final _loripsumApiBloc = LoripsumBloc();

  Color color = Colors.grey;

  Carro get carro => widget.carro;

  @override
  void initState() {
    super.initState();

    _loripsumApiBloc.fetch();

    FavoritoService().isFavorito(carro).then((bool favorito) {
      setState(() {
        color = favorito ? Colors.red : Colors.grey;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.carro.nome),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.place),
            onPressed: _onClickMapa,
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: _onClickVideo,
          ),
          PopupMenuButton<String>(
            onSelected: _onClickPopupMenu,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: "Editar",
                  child: Text("Editar"),
                ),
                PopupMenuItem(
                  value: "Deletar",
                  child: Text("Deletar"),
                ),
                PopupMenuItem(
                  value: "Share",
                  child: Text("Share"),
                )
              ];
            },
          )
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView(
        children: <Widget>[
          CachedNetworkImage(
              imageUrl:widget.carro.urlFoto ??
                  "http://www.livroandroid.com.br/livro/carros/esportivos/Ferrari_FF.png"),
          _bloco1(),
          Divider(),
          _bloco2(),
        ],
      ),
    );
  }

  Row _bloco1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              text(widget.carro.nome ),
              text(widget.carro.tipo),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: color,
                size: 40,
              ),
              onPressed: _onClickFavorito,
            ),
            IconButton(
              icon: Icon(
                Icons.share,
                size: 40,
              ),
              onPressed: _onClickShare,
            )
          ],
        )
      ],
    );
  }

  _bloco2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        text(widget.carro.descricao, bold: true),
        SizedBox(
          height: 20,
        ),
        StreamBuilder<String>(
          stream: _loripsumApiBloc.stream,
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return text(snapshot.data);
          },
        ),
      ],
    );
  }





  _onClickPopupMenu(String value) {
    switch (value) {
      case "Editar":
        push(context, CarroFormPage(carro: carro));
        break;
      case "Deletar":
        deletar();
        break;
      case "Share":
        print("Share !!!");
        break;
    }
  }

  void _onClickFavorito() async {
    bool favorito = await FavoritoService().favoritar(carro);

    setState(() {
      color = favorito ? Colors.red : Colors.grey;
    });
  }

  void _onClickShare() {}

  void deletar() async {
    ApiResponse<bool> response = await CarrosApi.delete(carro);

    if(response.ok) {
      alert(context, "Carro deletado com sucesso", callback: (){
        EventBus.get(context).sendEvent(CarroEvent("carro_deletado",carro.tipo));

        pop(context);
      });
    } else {
      alert(context, response.msg);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _loripsumApiBloc.dispose();
  }
}