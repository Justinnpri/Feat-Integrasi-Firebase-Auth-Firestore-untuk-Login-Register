import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nameCtrl    = TextEditingController(text: 'Boris Justin Prima Dylan');
  final birthCtrl   = TextEditingController(text: '12 Januari 2002');
  final addressCtrl = TextEditingController(text: 'Jl. Pangeran Diponegoro, Malang');

  String gender    = 'Laki-Laki';
  String jobStatus = 'Pelajar / Mahasiswa';

  final List<String> genderOptions = const ['Laki-Laki', 'Perempuan'];
  final List<String> jobOptions = const [
    'Pelajar / Mahasiswa','Karyawan','Wirausaha','Freelancer','Lainnya'
  ];

  int _selectedIndex = 3; // akun
  final int koin = 1250;

  @override
  void dispose() {
    nameCtrl.dispose();
    birthCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== Header Avatar + Upload =====
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: cs.surfaceContainerHighest,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/header.jpg',
                          width: 96, height: 96, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(Icons.person, size: 48, color: cs.onSurfaceVariant),
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fitur upload belum aktif')),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      tooltip: 'Ubah foto',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Unggah JPG/PNG • < 1 MB', style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ===== Koin Card (modern, subtle gradient) =====
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [cs.primaryContainer, cs.secondaryContainer],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: cs.onPrimaryContainer.withOpacity(.12),
                  child: const Icon(Icons.monetization_on_rounded),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Saldo Koin', style: theme.textTheme.labelLarge?.copyWith(color: cs.onPrimaryContainer)),
                      const SizedBox(height: 2),
                      Text('$koin Koin',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800, color: cs.onPrimaryContainer)),
                    ],
                  ),
                ),
                FilledButton.tonal(
                  onPressed: () {},
                  child: const Text('Top up'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ===== Form Edit Profil =====
          Text('Data Diri', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            color: cs.surfaceContainerHighest,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _Field(
                      label: 'Nama Lengkap',
                      child: TextFormField(
                        controller: nameCtrl,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(hintText: 'Masukkan nama'),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama Lengkap wajib diisi' : null,
                      ),
                    ),
                    _Field(
                      label: 'Tanggal Lahir',
                      child: TextFormField(
                        controller: birthCtrl,
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: 'Pilih tanggal',
                          suffixIcon: Icon(Icons.calendar_today_outlined),
                        ),
                        onTap: () async {
                          final initial = _parseIndoDate(birthCtrl.text) ?? DateTime(2002, 1, 12);
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: initial,
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) birthCtrl.text = _formatIndoDate(picked);
                        },
                      ),
                    ),
                    _Field(
                      label: 'Jenis Kelamin',
                      child: SegmentedButton<String>(
                        segments: genderOptions
                            .map((e) => ButtonSegment(value: e, label: Text(e), icon: Icon(
                                  e == 'Laki-Laki' ? Icons.male_rounded : Icons.female_rounded)))
                            .toList(),
                        selected: {gender},
                        showSelectedIcon: false,
                        onSelectionChanged: (s) => setState(() => gender = s.first),
                      ),
                    ),
                    _Field(
                      label: 'Status Pekerjaan',
                      child: DropdownButtonFormField<String>(
                        initialValue: jobStatus,
                        items: jobOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (v) => setState(() => jobStatus = v ?? jobStatus),
                      ),
                    ),
                    _Field(
                      label: 'Alamat Lengkap',
                      child: TextFormField(
                        controller: addressCtrl,
                        minLines: 2, maxLines: 4,
                        decoration: const InputDecoration(hintText: 'Tulis alamat lengkap'),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Alamat Lengkap wajib diisi' : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.save_rounded),
                        label: const Text('Simpan Perubahan'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Data berhasil diperbarui!'),
                                behavior: SnackBarBehavior.floating,
                                showCloseIcon: true,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // ===== Material 3 NavigationBar =====
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.class_outlined), selectedIcon: Icon(Icons.class_), label: 'Kelas'),
          NavigationDestination(icon: Icon(Icons.monetization_on_outlined), selectedIcon: Icon(Icons.monetization_on), label: 'KoinLS'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }

  // ===== Helpers (tanggal Indonesia) =====
  static String _formatIndoDate(DateTime date) {
    // Pastikan package intl sudah ditambahkan di pubspec:
    // intl: ^0.19.0
    // (bisa juga tanpa intl dengan list bulan manual)
    try {
      return DateFormat("d MMMM y", "id_ID").format(date);
    } catch (_) {
      const months = [
        'Januari','Februari','Maret','April','Mei','Juni',
        'Juli','Agustus','September','Oktober','November','Desember'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }
  }

  static DateTime? _parseIndoDate(String? text) {
    if (text == null || text.isEmpty) return null;
    try {
      return DateFormat("d MMMM y", "id_ID").parseLoose(text);
    } catch (_) {
      return null;
    }
  }
}

// ====== Small reusable field wrapper ======
class _Field extends StatelessWidget {
  final String label;
  final Widget child;
  const _Field({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelLarge?.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
