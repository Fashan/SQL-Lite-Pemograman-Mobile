import 'package:flutter/material.dart';
// change `flutter_database` to whatever your project name is
import 'package:flutter_database/database_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'belajar database',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DBhelper _dbmanager = new DBhelper();
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _formkey = new GlobalKey<FormState>();
  Mahasiswa mahasiswa;
  List<Mahasiswa>listmhs;
  int updateIndex;
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Learn SQL LITE"),

      ),
      body: ListView(
        children: <Widget>[

          Form(key: _formkey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: <Widget>[
                  TextFormField(
                    decoration: new InputDecoration(
                      labelText: 'Nama Lengkap Mahasiswa',
                    ),
                    controller: _namaController,
                    validator: (val) => val.isNotEmpty? null: 'Anda harus mengisi nama mahasiswa',
                  ),
                  TextFormField(
                    decoration: new InputDecoration(
                      labelText: 'NIM Mahasiswa',
                    ),
                    controller: _nimController,
                    validator: (val) => val.isNotEmpty? null: 'Anda harus mengisi NIM mahasiswa',
                  ),
                  RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Container(
                        width: width*0.9,
                        child: Text('Submit',textAlign: TextAlign.center,),),
                      onPressed: (){
                        _submitMahasiswa(context);
                      }),
                  Padding(padding: EdgeInsets.all(20),),
                  Text('Data tabel mahasiswa akan muncul dibawah'),
                  FutureBuilder(
                    future: _dbmanager.getMahasiswaList(),
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        listmhs = snapshot.data;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: listmhs == null?0 : listmhs.length,
                          itemBuilder: (BuildContext context, int index){
                            Mahasiswa mhs = listmhs[index];
                            return Card(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: width*0.6,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Nama Mahasiswa: ${mhs.nama}',style: TextStyle(fontSize: 15),),
                                        Text('NIM Mahasiswa: ${mhs.nim}',style: TextStyle(fontSize: 15,color: Colors.black54)),
                                      ],
                                    ),
                                  ),
                                  IconButton(icon: Icon(Icons.edit),color: Colors.blue , onPressed: (){
                                    _namaController.text = mhs.nama;
                                    _nimController.text = mhs.nim;
                                    mahasiswa = mhs;
                                    updateIndex = index;


                                  }),
                                  IconButton(icon: Icon(Icons.delete),color: Colors.red , onPressed: (){
                                    _dbmanager.deleteMahasiswa(mhs.id);
                                    setState(() {
                                      listmhs.removeAt(index);
                                    });
                                  }),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  )

                ],),
              ))
        ],
      ),
    );
  }

  void _submitMahasiswa(BuildContext context) {
    if(_formkey.currentState.validate()){
      if(mahasiswa == null){
        Mahasiswa mhs = new Mahasiswa(nama: _namaController.text, nim: _nimController.text);
        _dbmanager.insertmahasiswa(mhs).then((id) =>{
          _namaController.clear(),
          _nimController.clear(),
          print('Mahasiswa telah di tambah dengan id: ${id}')
        });
      }else{
        mahasiswa.nama = _namaController.text;
        mahasiswa.nim = _nimController.text;
        _dbmanager.updateMahasiswa(mahasiswa).then((id) =>{
          setState((){
            listmhs[updateIndex].nama = _namaController.text;
            listmhs[updateIndex].nim = _nimController.text;
          }),
          _namaController.clear(),
          _nimController.clear(),
          mahasiswa = null
        });
      }
    }
  }
}