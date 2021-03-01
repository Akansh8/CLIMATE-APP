import 'package:flutter/material.dart';
import '../util/utils.dart' as util;
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class climate extends StatefulWidget {
  @override
  _climateState createState() =>new _climateState();
}

class _climateState extends State<climate> {
  String _cityEntered;

  Future _goToNextScreen(BuildContext context)async {
    Map results =await Navigator.of(context).push(new MaterialPageRoute<Map>(builder : (BuildContext context){
      return new ChangeCity();
    }
    ));
    if(results!=null&&results.containsKey('enter'))
      {
        setState(() {
          _cityEntered=results['enter'];
        });
        //print(results['enter'].toString());
      }
  }
  void showStuff() async
  {
    Map data = await getWeather(util.apiId, util.defaultCity);
    print(data.toString());
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('CLi_MaTE'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade800,
        actions: <Widget>[
          new IconButton(icon: Icon(Icons.house_rounded,
          color: Colors.tealAccent,),
              onPressed:() {_goToNextScreen(context);}),
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/umbrella.png',
              height: 700,
              fit: BoxFit.fill,),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 11, 30, 0),
            child: Text("${_cityEntered==null?util.defaultCity:_cityEntered}",
            style: new TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
          ),),
          ),
          new Container(
          margin: const EdgeInsets.fromLTRB(0,180,0,0),
          child: new Image.asset('images/temp.png',
          color: Colors.tealAccent,),
          height: 100,
          width: 90,),
          new Container(
            margin: const EdgeInsets.fromLTRB(230,220,0.0,0.0),
            child:new Image.asset('images/light_rain.png'),
          ),
          new Container(
            margin: const EdgeInsets.fromLTRB(50, 200, 0, 0),
            child:  updateTempWidget(_cityEntered),
    )

//            new Text('70.7',
//              style: new TextStyle(
//                color: Colors.red,
//                fontWeight: FontWeight.w600,
//                fontSize: 50.0,
//             ),),
        ],
      ),
    );
  }

  Future<Map> getWeather(String apiId,String city) async
  {
    String apiUrl = 'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.apiId}&units=metric';
    http.Response response=await http.get(apiUrl);
    return jsonDecode(response.body);
  }
  Widget updateTempWidget(String city)
  {
      return new FutureBuilder(
          future: getWeather(util.apiId, city==null?util.defaultCity:city),
          builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
            if(snapshot.hasData)
              {
                Map content = snapshot.data;
                return new Container(
                  child: new Column(
                  children: <Widget>[
                    // ignore: missing_return
                    new ListTile(
                      title: new Text((content['main']['temp'].toStringAsFixed(2)+'°C'),
                      style: new TextStyle(
                      color: Colors.purple.shade800,
                      fontWeight: FontWeight.w500,
                      fontSize: 45.0,
                        ),
                      ),
                      subtitle: new ListTile(
                        title: new Text(
                              "(feels like : ${content['main']['feels_like'].toStringAsFixed(2)} °C)\n\n"
                              "• Description: ${content['weather'][0]['main'].toString()}\n"
                                  "  (${content['weather'][0]['description'].toString()})\n\n"
                                "• Humidity: ${content['main']['humidity'].toString()}\n\n"
                                "• Wind Speed: ${content['wind']['speed'].toStringAsFixed(2)} m/s\n\n"
                                "• Min: ${content['main']['temp_min'].toString()} °C\n\n"
                                "• Max: ${content['main']['temp_max'].toString()} °C \n\n",
//                                "• Sunrise: ${DateFormat.jm(DateTime.fromMicrosecondsSinceEpoch((content['timezone']['id']+content['sys']['sunrise'])*1000,isUtc: true).toString())}\n\n"
//                                "• Sunset: ${content['sys']['sunset'].toString()}",
                          style: new TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontSize: 18.0,
                          ),
                        ),
                      ),
                    )
                  ],
                  ),
                );
              }
            else
              {
                return new Container();
              }
      });
  }

}

class ChangeCity extends StatelessWidget {
  var _cityFieldController =new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Change City'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade800,
      ),
      backgroundColor: Colors.blueGrey,
      body: new Stack(
        children: [
          new ListView(
            children: [
              new Center(
                child: new Image.asset('images/white_snow.png',
                colorBlendMode: BlendMode.darken,
                height: 700,
                width: 400,
                fit: BoxFit.fill,),
              )
            ]
          ),
          new ListView(
            children: [

              new ListTile(
                title: new TextField(
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                    labelText: 'Enter City Name',
                    hintText: 'in Camelcase(e.g. Kolkata)',
                  ),
                ),
              ),
              new ListTile(
                title: new RaisedButton(
                    child: Text('CHECK WEATHER',),
                    color: Colors.black12,
                    onPressed:()
                    {
                      Navigator.pop(context,{
                      'enter': _cityFieldController.text
                      });
                    },

                ),
                    ),
            ],
          ),

        ],
      ),
    );
  }
}


