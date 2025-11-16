import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool obscure = true;
  bool robotChecked = false;
  bool isValid = false;
  String? errorMessage;

  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  void _checkFormValidity() {
    setState(() {
      isValid = _formKey.currentState?.validate() ?? false;
    });
  }

  Future<void> _tryLogin() async {
    if (!_formKey.currentState!.validate() || !robotChecked) return;

    try {
      // 🔥 Login ke FirebaseAuth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );

      setState(() => errorMessage = null);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login berhasil!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() => errorMessage = 'Email tidak ditemukan.');
      } else if (e.code == 'wrong-password') {
        setState(() => errorMessage = 'Password salah.');
      } else {
        setState(() => errorMessage = 'Terjadi kesalahan: ${e.message}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Form(
                    key: _formKey,
                    onChanged: _checkFormValidity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Masuk ke Akunmu untuk Akses Luarsekolah',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 20),

                        // Email Field
                        TextFormField(
                          controller: emailCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Masukkan Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Email wajib diisi';
                            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(v)) return 'Format email tidak valid';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // Password Field
                        TextFormField(
                          controller: passwordCtrl,
                          obscureText: obscure,
                          decoration: InputDecoration(
                            labelText: 'Masukkan Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => obscure = !obscure),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Password wajib diisi';
                            if (v.length < 6) return 'Minimal 6 karakter';
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        // Pesan error Firebase
                        if (errorMessage != null)
                          Text(errorMessage!, style: const TextStyle(color: Colors.red)),

                        Row(
                          children: [
                            Checkbox(
                              value: robotChecked,
                              onChanged: (v) => setState(() => robotChecked = v ?? false),
                            ),
                            const Text("I'm not a robot"),
                          ],
                        ),

                        ElevatedButton(
                          onPressed: isValid && robotChecked ? _tryLogin : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isValid && robotChecked ? const Color(0xFF00A86B) : Colors.grey,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Masuk',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Belum punya akun? '),
                            GestureDetector(
                              onTap: () =>
                                  Navigator.pushReplacementNamed(context, '/register'),
                              child: const Text(
                                'Daftar sekarang',
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
