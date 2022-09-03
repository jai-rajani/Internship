import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:internship/widgets/PetDocument.dart';
import 'package:internship/widgets/loading.dart';


class Documents extends StatefulWidget {
  const Documents({Key? key}) : super(key: key);



  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  String clicker="";
  String link="";
  String download_url="";
  String file_type="";

  dynamic pet_data;

  //function to send GET request to the api to get details of all documents uploaded
  void sendRequest() async{


    var headers = {
      'access-token': 'Mjk6dGVzdC5wbXNAZ21haWwuY29tOkFkbWluOjhkODI0NzExLTdlZWMtNGUzZS05NDU1LTMyYzA4M2JlMWJhZg=='
    };
    var request = http.Request('GET', Uri.parse('http://api.pawsense.ca/api/document/documents_by_pet/47'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    //print(response.statusCode);


    if (response.statusCode == 200) {
      clicker=await response.stream.bytesToString();

      final decodedMap = json.decode(clicker) as Map;
      setState(() {
        pet_data=decodedMap['data'] as List;

      });
      //print(decodedMap.length);

      final decoded2=decodedMap['data'] as List;
      //print(decoded2.length);

      final temp=decoded2[14];
      link = temp['documentLink'];
      setState(() {
        download_url=link;
      });
      if(temp['fileType']=='application/pdf'){
        setState(() {
          file_type='pdf';
        });
      }
      else{
        setState(() {
          file_type='jpg';
        });
      }

      print('working');
    }

    else {
      print(response.reasonPhrase);
    }

  }
  @override
  Widget build(BuildContext context) {
    sendRequest();
    if(pet_data==null){
      return (
      Loading()
      );
    }
    //Navigator.pop(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,

        title: Text('My Documents'),
          actions: <Widget>[
            TextButton(

              onPressed: sendRequest,
              child: Text("Refresh",
              style:TextStyle(
              fontSize: 17,
              color:Colors.white,
              )),

            ),]


    ),
    body: SingleChildScrollView(
      child:Container(
        margin: EdgeInsets.fromLTRB(30, 10, 0, 0),
        child: Wrap(
          children: [
            for ( var index=0;index<pet_data.length;index++) PetDocument(name: pet_data[index]['name'], link: pet_data[index]['documentLink'],filetype:pet_data[index]['fileType'],documenttype:pet_data[index]['documentType'])
          ],
        ),
      ),
    ),

         );
       }
}

