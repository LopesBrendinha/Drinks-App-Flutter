import 'package:drinks_app/service/drink_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 85, 167, 206),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/imgs/logo.png',
              fit: BoxFit.contain,
              height: 40,
            ), 
          ],
        ),
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Pesquise Seu Drink Aqui",
                labelStyle: TextStyle(color: Color.fromARGB(255, 85, 167, 206), fontSize: 18),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Color.fromARGB(255, 85, 167, 206), fontSize: 18),
              textAlign: TextAlign.center,
              onSubmitted: (value) {
                setState(() {
                  _search = value;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getDrinkApi(_search),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return exibeResultado(context, snapshot);
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget exibeResultado(BuildContext context, AsyncSnapshot snapshot) {
  FocusScope.of(context).unfocus();
  return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: snapshot.data["drinks"][0].strDrink,
              labelStyle: TextStyle(color: Color.fromARGB(255, 90, 159, 248)),
              border: OutlineInputBorder(),
            ),
            style: TextStyle(color: Color.fromARGB(255, 90, 159, 248), fontSize: 18),
          ),
          SizedBox(height: 10),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: snapshot.data["drinks"][0]["strCategory"],
              labelStyle: TextStyle(color: Color.fromARGB(255, 90, 159, 248)),
              border: OutlineInputBorder(),
            ),
            style: TextStyle(color: Color.fromARGB(255, 90, 159, 248), fontSize: 18),
          ),
          SizedBox(height: 10),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: snapshot.data["drinks"][0]["strInstructions"],
              labelStyle: TextStyle(color: Color.fromARGB(255, 90, 159, 248)),
              border: OutlineInputBorder(),
            ),
            style: TextStyle(color: Color.fromARGB(255, 90, 159, 248), fontSize: 18),
          ),
          SizedBox(height: 10),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Ingredientes:",
              labelStyle: TextStyle(color: Color.fromARGB(255, 90, 159, 248)),
              border: OutlineInputBorder(),
            ),
            style: TextStyle(color: Color.fromARGB(255, 90, 159, 248), fontSize: 18),
          ),
          SizedBox(height: 10),
          ...List.generate(15, (index) {
            String ingredientKey = "strIngredient${index + 1}";
            String measureKey = "strMeasure${index + 1}";
            if (snapshot.data["drinks"][0][ingredientKey] != null) {
              return TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "${snapshot.data["drinks"][0][ingredientKey]} - ${snapshot.data["drinks"][0][measureKey] ?? ''}",
                  labelStyle: TextStyle(color: Color.fromARGB(255, 90, 159, 248)),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(color: Color.fromARGB(255, 90, 159, 248), fontSize: 18),
              );
            } else {
              return Container();
            }
          }),
        ],
      ),
    );
  }
}