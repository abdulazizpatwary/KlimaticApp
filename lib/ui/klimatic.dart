import 'dart:convert';

import 'package:flutter/material.dart';
import '../util/utils.dart'as util;
import 'dart:async';
import 'package:http/http.dart'as http;
class  Klimatic extends StatefulWidget {


  @override
  Klmatic_State createState() => Klmatic_State();
}

class Klmatic_State extends State<Klimatic> {
  String? _cityEntered;
  Future _gotoNextScreen(BuildContext context)async{
    Map results= await Navigator.of(context)
        .push(MaterialPageRoute<dynamic>(builder: (BuildContext context){
          return ChangeCity();
    }));
    if(results != null && results.containsKey('enter')){
      setState(() {
        _cityEntered=results['enter'];
      });

    }
  }
  void showStuff()async{
    Map data= await getWeather(util.appId, util.defaultCity);
    print(data.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Klimatic',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          IconButton(
              style: IconButton.styleFrom(foregroundColor: Colors.white),
              onPressed:(){ _gotoNextScreen(context);},
              icon: Icon(Icons.menu))
          
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset('images/umbrella.png',
            width: 490.0,
                height: 1200.0,
                fit: BoxFit.fill,),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: Text(_cityEntered ?? util.defaultCity,
            style: cityStyle(),),
          ),
          Container(
            alignment: Alignment.center,
            child: Image.asset('images/light_rain.png'),
          ),
          updateTempWudget(_cityEntered ?? util.defaultCity)
          // Container(
          //   //margin: const EdgeInsets.fromLTRB(30.0, 310.0, 0.0, 0.0),
          //   child: updateTempWudget(_cityEntered ?? util.defaultCity)
          // )
        ],
      ),
    );
  }
  Future<Map>getWeather(String appId,String city)async{
    String apiUrl='https://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.appId}&units=imperial';
    http.Response response = await http.get(Uri.parse(apiUrl));
    return json.decode(response.body);

  }
  Widget updateTempWudget(String city){
    return FutureBuilder(
        future: getWeather(util.appId, city ==null? util.defaultCity:city) ,
        builder: (BuildContext context,AsyncSnapshot<Map> snapshot){
      if(snapshot.hasData){
        Map content = snapshot.data!;
        return Container(
          margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListTile(
                title: Text("${content['main']['temp']} F",
                style: TextStyle(fontStyle: FontStyle.normal, fontSize: 49.0,fontWeight: FontWeight.w500, color: Colors.white),),
                subtitle: ListTile(
                  title: Text('Humidity: ${content['main']['humidity'].toString()}\n'
                  "Min: ${content['main']['temp_min'].toString()} F\n"
                  "Max: ${content['main']['temp_max'].toString()} F",style: extraTemp(),),
                ),
              )
            ],
          ),
        );
      }else{
        return Container();
      }

    });
  }
}

class ChangeCity extends StatelessWidget {

  var _cityFieldController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Change City"),
        centerTitle: true,
      ) ,
      body: Stack(
        children:<Widget> [
         Center(
           child: Image.asset('images/white_snow.png',width: 490.0,
             height: 1200.0,
             fit: BoxFit.fill,),
         ),
          ListView(
            children: [
              ListTile(
                title: TextField(
                  decoration: InputDecoration(
                    hintText: "Enter City"
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
              ListTile(
                title: TextButton(
                    onPressed: (){
                      Navigator.pop(context,{
                        'enter':_cityFieldController.text
                      });
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.white70,backgroundColor: Colors.redAccent),
                    child: Text("Get Weather")),
              )
            ],
          )

        ],
      ),
    );
  }
}



TextStyle cityStyle(){
  return TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic
  );
}
TextStyle extraTemp(){
  return TextStyle(
      color: Colors.white70,
      fontStyle: FontStyle.normal,
      fontSize: 17.0
  );
}
TextStyle tempStyle(){
  return TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 49.9

  );
}
