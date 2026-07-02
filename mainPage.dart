import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {
  final url = Uri.parse('http://192.168.1.5/APP_PENJUALAN_API/catatan.php');
Future <List<dynamic>> getCatatanFinansial() async { 
  try {
    final response = await http.get(url);
    if (response.statusCode==200) {
      List <dynamic> data = jsonDecode(response.body);
      return data;
      
    } else { 
      throw Exception('Gagal memuat data');
    }
  } catch (e) {
    throw Exception('error koneksi: $e');   
  }
}

//fungsi post catatan finansial:
Future<void> postCatatanFinansial(String nominal, String kategori) async {
  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nominal": nominal,
        "kategori": kategori,
      })
    );
    
    if (response.statusCode==200) {
      var responseData = jsonDecode(response.body);
      if (responseData['status']=='sukses') {
        //tampilkan pesan sukses dengan Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('data berhasil ditambahkan'), backgroundColor: Colors.greenAccent),
        );

      } else {
        //tampilkan pesan error dengan Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menambahkan data'), backgroundColor: Colors.redAccent),
        );
      }
    } else {
      throw Exception('gagal menyimpan ke server');

    } 
    
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal menambahkan data: $e'), backgroundColor: Colors.redAccent),
        );
    
  }
  }
  //fungsi update catatan finansial:
  Future<void> updateCatatanFinansial(
    String id,
    String nominal,
    String kategori,
) async {
  try {
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": id,
        "nominal": nominal,
        "kategori": kategori,
      }),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);

      if (responseData['status'] == 'sukses') {
        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Data berhasil diupdate"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal update data"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error : $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
}
//fungsi delete catatan finansial:
Future<void> deleteCatatanFinansial(String id) async {
  try {
    final response = await http.delete(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": id,
      }),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);

      if (responseData['status'] == 'sukses') {
        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Data berhasil dihapus"),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error : $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
}
void tampilkanFormUpdate(
  BuildContext context,
  String id,
  String nominal,
  String kategoriAwal,
) {
  final TextEditingController nominalController =
      TextEditingController(text: nominal);

  final List<String> listKategori = ['pemasukan','belanja'];
  String kategoriDipilih = kategoriAwal.trim().toLowerCase();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Text(
                  'Update Catatan Keuangan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20),

                TextField(
                  controller: nominalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Nominal',
                    prefixText: 'Rp. ',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: kategoriDipilih,
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                  items: listKategori.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setModalState(() {
                      kategoriDipilih = value!;
                    });
                  },
                ),

                SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {

                    await updateCatatanFinansial(
                      id,
                      nominalController.text,
                      kategoriDipilih,
                    );

                    Navigator.pop(context);

                    setState(() {});
                  },
                  child: Text("Update"),
                ),

                SizedBox(height: 20),
              ],
            ),
          );
        },
      );
    },
  );
}
          
 void tampilkanForm(BuildContext context) {
    //deklarasi Controllers dan variable:
    final TextEditingController _nominal = TextEditingController();
    final List<String> _listKategori = ['pemasukan','belanja'];
    String _kategoriDipilih = 'pemasukan';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: ( BuildContext context, StateSetter setModelState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tambah Catatan Keuangan'),
                  const SizedBox(height: 20,),
                  TextField(
                    controller: _nominal,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Nominal (Rp)',
                      prefixText: 'Rp.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20,),
                  DropdownButtonFormField(
                    value: _kategoriDipilih,
                    decoration: InputDecoration(
                      labelText: 'Kategori',
                      border: OutlineInputBorder(),
                    ),
                    items: _listKategori.map((String value){
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: ( String? newValue) {
                      setModelState(() {
                        _kategoriDipilih=newValue!;
                      },);
                      
                    },

                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.all(12),
                    ),
                    onPressed: () async{
                      //validasi dulu : nominal tidak boleh kosong
                      if (_nominal.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('nominal harus diisi'),backgroundColor: Colors.redAccent),
                        );
                        return;
                      }
                     await postCatatanFinansial(_nominal.text, _kategoriDipilih);
                      _nominal.clear();
                      setState(() {
                        _kategoriDipilih='pemasukan';
                      });
                      Navigator.pop(context);
                      
                    },
                    child: Text('Simpan'),
                  ),
                ],
              ),
            );
            
          },
        );
        
      },
    );

   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplikasi Penjualan Makananan'),
        centerTitle: true,
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder <List<dynamic>>(
        future: getCatatanFinansial(),
        builder: (context, snapshot) {
          //jika masih loading:
          if (snapshot.connectionState==ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());  
          }
          //jika terjadi error, misal server API nya mati.
          if (snapshot.hasError) {
             return Center(child: Text('Terjadi Kesalahan : ${snapshot.error}'));  
          }
          //jika datanya kosong
          if (!snapshot.hasData||snapshot.data!.isEmpty) {
            return Center(child: Text('Belum ada catatan transaksi'));  
          }
          //jika sukses, tampilkan data  dalam bentuk ListView
          List<dynamic> listData = snapshot.data!;
          return ListView.builder(
            itemCount: listData.length,
            itemBuilder: (context, index) {
              var catatan = listData[index];

              //agar warna dan icon pemasukan  dan belanja berbeda
              bool isPemasukan =catatan['kategori'].toString().toLowerCase() == 'pemasukan';
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isPemasukan?Colors.blue.shade100: Colors.redAccent.shade100,
                    child: Icon(
                      isPemasukan? Icons.arrow_upward: Icons.arrow_downward,
                      color: isPemasukan?Colors.purple : Colors.redAccent, 
                    ),
                  ),
                  title: Text(
                    'Rp. ${catatan['nominal']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text('keterangan: ${catatan['kategori']}'),
                  trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    IconButton(
      icon: Icon(Icons.edit, color: Colors.blue),
      onPressed: () {
        tampilkanFormUpdate(
          context,
          catatan['id'].toString(),
          catatan['nominal'].toString(),
          catatan['kategori'].toString(),
        );
      },
    ),
    IconButton(
      icon: Icon(Icons.delete, color: Colors.red),
      onPressed: () async {
        await deleteCatatanFinansial(
          catatan['id'].toString(),
        );
      },
    ),
  ],
),
                ),

              );
            },
          );
        },

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //menampilkan form input;
          tampilkanForm(context);

        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,

      ),
    );
  }
}