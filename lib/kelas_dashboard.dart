import 'package:flutter/material.dart';
import 'edit_kelas_page.dart';

class KelasDashboardPage extends StatefulWidget {
  const KelasDashboardPage({super.key});

  @override
  State<KelasDashboardPage> createState() => _KelasDashboardPageState();
}

class _KelasDashboardPageState extends State<KelasDashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> _kelasList = [
    {
      'title': 'Teknik Pemilahan dan Pengolahan Sampah',
      'cat1': 'Prakerja',
      'cat2': 'SPL',
      'price': 'Rp 1.500.000',
      'image': 'assets/images/teknikpemilahan.png',
    },
    {
      'title': 'Pembuatan Produk Pestisida',
      'cat1': 'Prakerja',
      'cat2': 'SPL',
      'price': 'Rp 1.500.000',
      'image': 'assets/images/pembuatanpestisida.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _kelasCard(Map<String, String> kelas, int index) {
    return GestureDetector(
      onTap: () {},
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(kelas['image'] ?? 'assets/images/sample.png'),
                fit: BoxFit.cover,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.1)
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  kelas['title'] ?? '',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if ((kelas['cat1'] ?? '').isNotEmpty)
                      _chip(kelas['cat1']!, Colors.blueAccent),
                    const SizedBox(width: 6),
                    if ((kelas['cat2'] ?? '').isNotEmpty)
                      _chip(kelas['cat2']!, Colors.green),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  kelas['price'] ?? '',
                  style: const TextStyle(
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
          ),
          Positioned(
            top: 12,
            right: 24,
            child: PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'edit') {
                  final result = await Navigator.push<Map<String, String>>(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            EditKelasPage(kelas: _kelasList[index])),
                  );
                  if (result != null) {
                    setState(() {
                      _kelasList[index] = result;
                    });
                  }
                } else if (value == 'delete') {
                  setState(() {
                    _kelasList.removeAt(index);
                  });
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Hapus')),
              ],
              icon: const Icon(Icons.more_vert, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _kelasListView() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 12, bottom: 80),
      itemCount: _kelasList.length,
      itemBuilder: (context, index) {
        return _kelasCard(_kelasList[index], index);
      },
    );
  }

  // ===================== SIMPLER MULTI-KATEGORI =====================
  void _tambahKelasSimpler() {
    final titleCtrl = TextEditingController();
    final priceCtrl = TextEditingController();

    final List<String> categories = ['SPL', 'Prakerja'];
    final Set<String> selectedCategories = {};

    final List<String> presetImages = [
      'assets/images/teknikpemilahan.png',
      'assets/images/pembuatanpestisida.png'
    ];
    String selectedImage = presetImages[0];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Tambah Kelas'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Judul Kelas'),
                ),
                const SizedBox(height: 12),
                const Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 10,
                  children: categories.map((cat) {
                    final isSelected = selectedCategories.contains(cat);
                    return FilterChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (val) {
                        setDialogState(() {
                          if (val) {
                            selectedCategories.add(cat);
                          } else {
                            selectedCategories.remove(cat);
                          }
                        });
                      },
                      selectedColor: Colors.green,
                      labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceCtrl,
                  decoration: const InputDecoration(labelText: 'Harga'),
                ),
                const SizedBox(height: 12),
                const Text('Pilih Gambar',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 10,
                  children: presetImages.map((img) {
                    final isSelected = selectedImage == img;
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedImage = img;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: isSelected ? Colors.green : Colors.transparent,
                              width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(img,
                            width: 80, height: 80, fit: BoxFit.cover),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.isNotEmpty &&
                    priceCtrl.text.isNotEmpty &&
                    selectedCategories.isNotEmpty) {
                  setState(() {
                    _kelasList.add({
                      'title': titleCtrl.text,
                      'cat1': selectedCategories.elementAt(0),
                      'cat2': selectedCategories.length > 1
                          ? selectedCategories.elementAt(1)
                          : '',
                      'price': priceCtrl.text,
                      'image': selectedImage,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Kelas'),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Terpopuler'),
            Tab(text: 'SPL'),
            Tab(text: 'Prakerja'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _kelasListView(),
          _kelasListView(),
          _kelasListView(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambahKelasSimpler,
        backgroundColor: Colors.green,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Kelas'),
      ),
    );
  }
}
