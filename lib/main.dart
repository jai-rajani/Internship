import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:internship/Documents.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  FilePickerResult? result;
  bool docTYpe_selected=false;
  String fileFormat="";
  String docType="";
  bool prescription=false;
  bool certificate=false;
  bool identity=false;
  bool receipt=false;
  String clicker="";
  String imagePath="";
  String pdfPath="";

  String petName="";
  String documentName="";
  dynamic pet_data;
  String error="";
  String file_selected="";
  bool fileselected=false;


  String download_url='';
  String file_type='pdf';
  File? _image;
  PickedFile? _pickedFile;
  final _picker = ImagePicker();
  final formKey = GlobalKey<FormState>();

  //function to pick image from gallery and store the path
  _pickImage() async {
    _pickedFile = await _picker.getImage(
      source: ImageSource.gallery,

    );
    if(_pickedFile != null) {
      setState(() {

        //_image = File(_pickedFile!.path);
        imagePath=_pickedFile!.path;
        fileselected=true;
        file_selected="Image File Selected !";
      });
    }
  }

  //function to take a pciture from phone camera and store the path
  _pickImageCamera() async {
    _pickedFile = await _picker.getImage(
      source: ImageSource.camera,

    );
    if(_pickedFile != null) {
      setState(() {
        //_image = File(_pickedFile!.path);
        imagePath=_pickedFile!.path;
        fileselected=true;
        file_selected="Image File Selected !";
      });

    }
  }


  //function to send HTTP Post request to the api to upload form data
  void uploadFilePDF() async{



    var headers = {
      'access-token': 'Mjk6dGVzdC5wbXNAZ21haWwuY29tOkFkbWluOjhkODI0NzExLTdlZWMtNGUzZS05NDU1LTMyYzA4M2JlMWJhZg==','Content-Type':'application/json'
    };
    var request = http.MultipartRequest('POST', Uri.parse('http://api.pawsense.ca/api/document'));


    setState(() {
      certificate? docType="CERTIFICATE":identity? docType="IDENTITY": prescription? docType="PRESCRIPTION":receipt?docType="RECEIPT":docType="";
    });
    final h={"name":petName,"document_type": docType,"pet_id":47};
    final j=jsonEncode(h);
    request.fields.addAll({'documentRequest': j.toString()});

    if(fileFormat=="PDF") {
      request.files.add(await http.MultipartFile.fromPath(
          'file', pdfPath, contentType: MediaType('application', 'pdf')));
    }
    else {
      request.files.add(await http.MultipartFile.fromPath(
          'file', _image!.path, contentType: MediaType('image', 'jpeg')));
    }

     request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      Navigator.push(context, MaterialPageRoute(builder: (context) =>  Documents()));
    }
    else {
      setState(() {
        error="File Size Too Large";
      });


    }

  }

  @override
  Widget build(BuildContext context) {
    Future<void> _showMyDialog() async {

      //function to open a alert dialog to select image source
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Image Source'),
            content: SingleChildScrollView(
              child: ListBody(
                children:  <Widget>[

                  Text('Select Image Source : '),
                  SizedBox(height: 10,),
                  ElevatedButton(
                      onPressed:() {
                        _pickImage();
                        setState(() {
                          fileFormat="IMG";
                        });
                      },
                      child: Text('Gallery Image')),
                  SizedBox(width: 10,),
                  ElevatedButton(
                      onPressed:() {
                        _pickImageCamera();
                        setState(() {
                          fileFormat="IMG";
                        });
                      },
                      child: Text('Camera Image')),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    //function to create an alert dialog popup to display error message
    Future<void> _errorDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('ERROR'),
            content: SingleChildScrollView(
              child: ListBody(
                children:  <Widget>[

                  Text('Error Message : '),
                  SizedBox(height: 10,),
                  Text(error),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
            'PawSense',
        style: TextStyle(

        ),),
      ),
      body: Center(

        child: SingleChildScrollView(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Form(
                key: formKey,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  width: 5000,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(10),


                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,


                    children: [
                      Text(
                          'Enter the name of the document',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,

                          )
                      ),
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Row(

                          children: [
                            Container(

                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),

                              width: 300,
                              height: 60,
                              child: TextFormField(

                                  validator: (value) {
                                    if (value == null || value.isEmpty ) {
                                      return 'Please enter some text';

                                    }
                                    if(value.length<2 || value.length>20){
                                      return 'Please enter text between 2-20!';
                                    }
                                    setState(() {
                                      petName=value;
                                      print(petName);
                                    });
                                    return null;
                                  },
                                  //keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          10.0),
                                    ),
                                    hintText: 'Enter Document Name',
                                    label: Text(
                                      'Document Name',
                                    ),
                                  )
                              ),
                            ),



                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text(
                          'Enter the type of the document',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,

                          )
                      ),
                      SizedBox(height: 10,),
                      Container(
                        margin: EdgeInsets.fromLTRB(50, 10, 0, 0),
                        child: Row(

                          children: [
                            SizedBox(
                              height: 40,
                              width: 120,
                              child:
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    certificate = true;
                                    prescription=false;
                                    identity=false;
                                    receipt=false;
                                    docTYpe_selected=true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: certificate ? Colors.blue : Colors.grey,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                    textStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                child:
                                Text(
                                  'Certificate',
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            SizedBox(
                              height: 40,
                              width: 120,
                              child:
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    certificate = false;
                                    prescription=false;
                                    identity=true;
                                    docTYpe_selected=true;
                                    receipt=false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: identity ? Colors.blue : Colors.grey,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                    textStyle: TextStyle(
                                        fontSize: 18,

                                        fontWeight: FontWeight.bold)),
                                child:
                                Text(
                                  'Identity',
                                ),

                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(50, 10, 0, 0),
                        child:
                        Row(
                          children:
                          [
                            SizedBox(
                              height: 40,
                              width: 120,
                              child:
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    certificate = false;
                                    prescription=true;
                                    identity=false;
                                    receipt=false;
                                    docTYpe_selected=true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: prescription ? Colors.blue : Colors.grey,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                    textStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                child:
                                Text(
                                  'Prescription',
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            SizedBox(
                              height: 40,
                              width: 120,
                              child:
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    certificate = false;
                                    prescription=false;
                                    identity=false;
                                    receipt=true;
                                    docTYpe_selected=true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: receipt ? Colors.blue : Colors.grey,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                    textStyle: TextStyle(
                                        fontSize: 18,

                                        fontWeight: FontWeight.bold)),
                                child:
                                Text(
                                  'Receipt',
                                ),

                              ),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text(
                          'Select Format of File to Upload',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,

                          )
                      ),
                      SizedBox(height: 10,),
                      Center(
                        child: Row(
                          children: [
                            SizedBox(width: 80,),
                            ElevatedButton(onPressed: _showMyDialog, child: Text("Image")),
                            SizedBox(width: 10,),

                            ElevatedButton(
                                onPressed: () async {
                                  result =
                                  await FilePicker.platform.pickFiles(type: FileType.custom,
                                    allowedExtensions: ['pdf'],);
                                  if (result == null) {
                                    print("No file selected");
                                  } else {
                                    setState(() {
                                      pdfPath=result!.files.single.path!;
                                      fileselected=true;
                                      file_selected="PDF File Selected !";
                                      fileFormat="PDF";


                                    });
                                  }
                                },
                                child:Text('PDF File')
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Center(
                        child: Text(file_selected,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      SizedBox(height: 20,),



                      Center(
                        child: ElevatedButton(
                            onPressed:() {
                              if(formKey.currentState!.validate()==true && docTYpe_selected==true && fileselected==true){
                                print('uploading');
                                uploadFilePDF();
                              }
                              else if (formKey.currentState!.validate()) {

                              setState(() {
                                documentName=petName;
                              });
                              }

                              else if(docTYpe_selected==false)
                              {
                              setState(() {
                                error="Please select document type!";
                              });
                              _errorDialog();
                              }
                              else if(fileselected==false){
                                setState(() {
                                  error="Please select a file!";
                                });
                                _errorDialog();
                              }


                            },


                            child: Text('Upload')
                        ),
                      ),

                    ],

                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {

                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  const Documents()));


                  },

                  child:Text('View Documents')
                  ),



    ],
    ),
    ),
    ),
    );
    }
  }

