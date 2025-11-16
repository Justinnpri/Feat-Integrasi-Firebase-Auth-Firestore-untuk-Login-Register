import 'package:flutter/material.dart';

class EditKelasPage extends StatefulWidget {
  final Map<String, String> kelas;
  const EditKelasPage({super.key, required this.kelas});

  @override
  State<EditKelasPage> createState() => _EditKelasPageState();
}

class _EditKelasPageState extends State<EditKelasPage> {
  late TextEditingController titleCtrl;
  late TextEditingController cat1Ctrl;
  late TextEditingController cat2Ctrl;
  late TextEditingController priceCtrl;
  late TextEditingController imageCtrl;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.kelas['title']);
    cat1Ctrl = TextEditingController(text: widget.kelas['cat1']);
    cat2Ctrl = TextEditingController(text: widget.kelas['cat2']);
    priceCtrl = TextEditingController(text: widget.kelas['price']);
    imageCtrl = TextEditingController(text: widget.kelas['image']);
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    cat1Ctrl.dispose();
    cat2Ctrl.dispose();
    priceCtrl.dispose();
    imageCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (titleCtrl.text.isNotEmpty &&
        cat1Ctrl.text.isNotEmpty &&
        cat2Ctrl.text.isNotEmpty &&
        priceCtrl.text.isNotEmpty &&
        imageCtrl.text.isNotEmpty) {
      Navigator.pop(context, {
        'title': titleCtrl.text,
        'cat1': cat1Ctrl.text,
        'cat2': cat2Ctrl.text,
        'price': priceCtrl.text,
        'image': imageCtrl.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Kelas'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Judul Kelas')),
            const SizedBox(height: 10),
            TextField(controller: cat1Ctrl, decoration: const InputDecoration(labelText: 'Kategori 1')),
            const SizedBox(height: 10),
            TextField(controller: cat2Ctrl, decoration: const InputDecoration(labelText: 'Kategori 2')),
            const SizedBox(height: 10),
            TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Harga')),
            const SizedBox(height: 10),
            TextField(controller: imageCtrl, decoration: const InputDecoration(labelText: 'Path Gambar (assets/images/...)')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Simpan'),
            )
          ],
        ),
      ),
    );
  }
}
