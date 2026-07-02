import 'package:flutter/material.dart';
import 'package:flutter_application_4/db_helper.dart';
import 'package:flutter_application_4/mainPage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLogin = true;
  //controllers:
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _konfigurasi_password = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Image.asset('images/banner1.jpeg'),
            SizedBox(height: 40,),
            TextField(
              controller: _username,
              decoration: InputDecoration(
                labelText: 'Username',
                icon: Icon(Icons.person_2),
              ),
            ),
            SizedBox(height: 25,),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                icon: Icon(Icons.lock),
              ),
            ),
            if(isLogin==false)...[
              SizedBox(height: 25,),
              TextField(
                controller: _konfigurasi_password,
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: "Konfigurasi Password",
                ),
              ),
              
            ],

            SizedBox(height: 30,),
           
              ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
              ),
              child: Text(isLogin?'Login':'Registrasi'),
              onPressed: () async {
                DbHelper _db = DbHelper();
              if (isLogin) {
                //logika untuk login:
                bool loginSukses = await _db.checkLogin(_username.text, _password.text);
                 if (loginSukses) {
                 //masuk ke halaman utama
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>const MainPage() ));
               } else {
                 //tampilkan pesan username/password salah
                 ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Username atau Password salah'),
                    backgroundColor: Colors.redAccent,
                    duration: Duration(seconds: 7),
                  )
                 );
               } 
                
                
              } else {
                //logika untuk registrasi:
                if (_password.text==_konfigurasi_password.text&&_username.text.isNotEmpty) {
                  await _db.register(_username.text, _password.text);
                   ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Registrasi berhasil! Anda sudah bisa login'),
                    backgroundColor: Colors.blue,
                    duration: Duration(seconds: 7),
                  )
                 );
                 //kembali ke mode login
                 setState(() {
                   isLogin=true;
                 });
                } else {
                   ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Registrasi gagal! Pastikan nama dan password sesuia ketentuan'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 7),
                  )
                 );

                }
                
              }
              },
            ),
            SizedBox(height: 25,),
            TextButton(
              onPressed: () {
                setState(() {
                 isLogin= !isLogin; 
                });
                
              },
              child: Text(
                isLogin
                ? 'belum punya akun? daftar'
                : 'sudah punya akun? login'
              ),
            )
          ],
        ),
      ),
    );      
  }
}