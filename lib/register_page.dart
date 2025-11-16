import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool obscure = true;
  bool robotChecked = false;
  String password = '';

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController waCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  bool get hasUpper => RegExp(r'[A-Z]').hasMatch(password);
  bool get hasDigit => RegExp(r'[0-9]').hasMatch(password);
  bool get hasSymbol => RegExp(r'[!@#\$&*~]').hasMatch(password);
  bool get hasMin => password.length >= 8;
  bool get isPasswordValid => hasUpper && hasDigit && hasSymbol && hasMin;

  bool isLoading = false;

  // 🔥 Fungsi Daftar Akun ke Firebase
  Future<void> registerUser() async {
    setState(() => isLoading = true);

    try {
      // 1️⃣ Daftarkan akun ke Firebase Authentication
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      // 2️⃣ Kirim email verifikasi
      await credential.user!.sendEmailVerification();

      // 3️⃣ Simpan data user ke Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'uid': credential.user!.uid,
        'name': nameCtrl.text.trim(),
        'email': emailCtrl.text.trim(),
        'whatsapp': waCtrl.text.trim(),
        'created_at': DateTime.now(),
      });

      // 4️⃣ Tampilkan popup sukses
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Email Verifikasi Dikirim'),
          content: Text(
            'Email verifikasi telah dikirim ke ${emailCtrl.text}. '
            'Silakan cek email untuk mengaktifkan akun.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Terjadi kesalahan')),
      );
    }

    setState(() => isLoading = false);
  }

  // 🔥 Validasi sebelum daftar
  void _tryRegister() {
    if (_formKey.currentState!.validate() && robotChecked && isPasswordValid) {
      registerUser();
    } else {
      if (!robotChecked) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tolong centang "I\'m not a robot"')),
        );
      } else {
        _formKey.currentState!.validate();
      }
    }
  }

  Widget ruleRow(bool passed, String text) {
    return Row(
      children: [
        Icon(
          passed ? Icons.check_circle : Icons.cancel,
          color: passed ? Colors.green : Colors.red,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: passed ? Colors.green : Colors.red)),
      ],
    );
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
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // --- Logo ---
                        SizedBox(
                          height: 56,
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const SizedBox(),
                          ),
                        ),

                        const SizedBox(height: 12),
                        const Text(
                          'Daftarkan Akun Untuk Lanjut Akses ke Luarsekolah',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 14),

                        // --- Nama ---
                        TextFormField(
                          controller: nameCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Nama Lengkap',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
                        ),
                        const SizedBox(height: 12),

                        // --- Email ---
                        TextFormField(
                          controller: emailCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Email Aktif',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => (v == null || !v.contains('@'))
                              ? 'Email tidak valid'
                              : null,
                        ),
                        const SizedBox(height: 12),

                        // --- No WA ---
                        TextFormField(
                          controller: waCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Nomor WhatsApp Aktif',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) =>
                              (v == null || v.length < 6) ? 'WA tidak valid' : null,
                        ),
                        const SizedBox(height: 12),

                        // --- Password ---
                        TextFormField(
                          controller: passCtrl,
                          obscureText: obscure,
                          onChanged: (v) => setState(() => password = v),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                  obscure ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => obscure = !obscure),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),
                        ruleRow(hasMin, 'Minimal 8 karakter'),
                        ruleRow(hasUpper, 'Ada huruf kapital'),
                        ruleRow(hasDigit, 'Ada angka'),
                        ruleRow(hasSymbol, 'Ada simbol (! @ # dll)'),

                        const SizedBox(height: 12),

                        // --- Checkbox ---
                        Row(
                          children: [
                            Checkbox(
                              value: robotChecked,
                              onChanged: (v) =>
                                  setState(() => robotChecked = v ?? false),
                            ),
                            const Text("I'm not a robot"),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // --- Tombol Daftar ---
                        ElevatedButton(
                          onPressed: isLoading ? null : _tryRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00A86B),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Daftarkan Akunmu'),
                        ),

                        const SizedBox(height: 12),

                        Center(
                          child: GestureDetector(
                            onTap: () =>
                                Navigator.pushReplacementNamed(context, '/login'),
                            child: const Text(
                              'Sudah punya akun? Masuk sekarang',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
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
