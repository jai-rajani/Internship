import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';



class PetDocument extends StatelessWidget {
  String name="";
  String link="";
  String filetype="";
  String documenttype="";

  //function to get download path for image
  PetDocument({required this.name,required this.link,required this.filetype,required this.documenttype});
  Future<String> getFilePathJPG(uniqueFileName) async {
    String path = '';

    Directory dir = Directory('/storage/emulated/0/Download');

    path = '${dir.path}/$uniqueFileName.jpg';

    return path;
  }

  //function to get download path for pdf
  Future<String> getFilePathPDF(uniqueFileName) async {
    String path = '';

    Directory dir = Directory('/storage/emulated/0/Download');

    path = '${dir.path}/$uniqueFileName.pdf';

    return path;
  }

  //function to download file using aws s3 link
  Future<void> downloadFile() async {
    String savePath = "";

    if (filetype == 'application/pdf') {
      savePath = await getFilePathPDF(name);
    }
    else {
      savePath = await getFilePathJPG(name);
    }
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    Dio dio = Dio();

    dio.download(
      link,
      savePath,
      deleteOnError: true,
    );
    //_showMyDialog();



  }




  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.all(
              Radius.circular(20))
      ),
      width: 150,
      height: 140,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(10, 10, 20, 10),

      child:

      Column(
        children: [
          Text(name,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
          SizedBox(height: 5,),
          Text(documenttype,
               style: TextStyle(
                 fontSize: 15,
                 color: Color.fromRGBO(128, 0, 0,1),
               )),
          SizedBox(height: 5,),
          Container(

            child: TextButton(

              onPressed: () async{
                downloadFile();


              },
              style: TextButton.styleFrom(backgroundColor: Color.fromRGBO(191, 191, 191,1)),
              child: Text("Download",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  )),

            ),
          ),




        ],
      ),
    );

  }
}
