import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'helpers/preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimatedSplashScreen(
        duration: 3000,
        splash: const Icon(Icons.book, size: 50),
        nextScreen: const MyNote(),
        splashTransition: SplashTransition.sizeTransition,
      ),
    );
  }
}

class MyNote extends StatefulWidget {
  const MyNote({super.key});

  @override
  State<MyNote> createState() => _MyNoteState();
}

class _MyNoteState extends State<MyNote> {
  final formKey = GlobalKey<FormState>();
  final prefs = Preferences();

  TextEditingController? _controller;

  String pin = '14045'; // ini pin nyah
  bool isAuth = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catatan Rahasia')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: isAuth ? _buildNote() : _buildAuth(),
      ),
    );
  }

  _buildAuth() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Masukkan Pin Anda'),
          const SizedBox(height: 10),
          TextFormField(
            obscureText: true,
            controller: _controller,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Tidak boleh kosong';
              } else if (value != pin) {
                return 'PIN nya salah :(';
              }

              return null;
            },
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  if (_controller?.text == pin) {
                    setState(() {
                      isAuth = !isAuth;
                    });

                    _controller!.text = await prefs.getValue('catatan');
                  }
                }
              },
              child: const Text('Buka'),
            ),
          ),
          const SizedBox(height: 10),
          const Text('Ahmad Ridlo Suhardi | TSA Mobile 2022'),
        ],
      ),
    );
  }

  _buildNote() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Catatan Rahasiaku'),
          const SizedBox(height: 10),
          TextFormField(
            controller: _controller,
            maxLines: 10,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Tidak boleh kosong';
              }

              return null;
            },
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                prefs.setValue('catatan', _controller!.text);
              },
              child: const Text('Simpan'),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isAuth = !isAuth;
                });
                _controller!.clear();
              },
              child: const Text('Tutup Catatan Rahasia'),
            ),
          ),
        ],
      ),
    );
  }
}
