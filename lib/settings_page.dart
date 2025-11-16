import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Preferensi Aplikasi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            value: _notifEnabled,
            title: const Text('Notifikasi'),
            subtitle: const Text('Aktifkan atau nonaktifkan notifikasi.'),
            activeThumbColor: const Color(0xFF00A86B),
            onChanged: (v) => setState(() => _notifEnabled = v),
          ),
          const Divider(height: 32),

          const Text(
            'Akun',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Ubah Kata Sandi'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur ubah kata sandi belum aktif'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: const Text('Bahasa'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Tentang Aplikasi'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Luarsekolah Clone',
                applicationVersion: '1.0.0',
                children: const [
                  Text('Aplikasi simulasi pembelajaran Luarsekolah.'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
