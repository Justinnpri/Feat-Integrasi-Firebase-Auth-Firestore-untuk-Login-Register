import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AkunPage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const AkunPage({super.key, required this.onToggleTheme});

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  // ===== Data Kelas / Program (overview) =====
  final List<Map<String, String>> daftarKelasProgram = const [
    {'title': 'Teknik Pemilahan dan Pengolahan Sampah', 'subtitle': 'Kelas SPL • Online'},
    {'title': 'Pembuatan Produk Pestisida', 'subtitle': 'Kelas Prakerja • Offline'},
    {'title': 'Program Pelatihan Lingkungan Hidup', 'subtitle': 'Program • Online'},
    {'title': 'Program Sertifikasi SPL', 'subtitle': 'Program • Offline'},
  ];

  // ===== Profil (ringkasan yang ditampilkan di overview) =====
  String nama   = 'Boris Justin Prima Dylan';
  String gender = 'Laki-Laki';
  String job    = 'Pelajar / Mahasiswa';
  String lahir  = '12 Januari 2002';
  String alamat = 'Jl. Pangeran Diponegoro, Malang';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Kartu lebih kontras di dark
    final cardBg = isDark ? cs.surfaceContainerHigh : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun'),
        centerTitle: true,
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            tooltip: 'Toggle tema',
            onPressed: widget.onToggleTheme,
            icon: Icon(isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== Header ringkasan =====
          Card(
            elevation: 0,
            color: cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: cs.outlineVariant),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: cs.secondaryContainer,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/header.jpg',
                        width: 72, height: 72, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(Icons.person, color: cs.onSecondaryContainer, size: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(nama, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(job, style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                        const SizedBox(height: 2),
                        Text('$gender • $lahir', style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push<Map<String, String>>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfilePage(
                            initial: {'nama': nama, 'gender': gender, 'job': job, 'lahir': lahir, 'alamat': alamat},
                          ),
                        ),
                      );
                      if (result != null && mounted) {
                        setState(() {
                          nama   = result['nama']   ?? nama;
                          gender = result['gender'] ?? gender;
                          job    = result['job']    ?? job;
                          lahir  = result['lahir']  ?? lahir;
                          alamat = result['alamat'] ?? alamat;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: const Text('Profil diperbarui'), behavior: SnackBarBehavior.floating, showCloseIcon: true),
                        );
                      }
                    },
                    icon: const Icon(Icons.edit_rounded),
                    label: const Text('Edit Profil'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ===== Alamat (ringkasan) =====
          Card(
            elevation: 0,
            color: cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: cs.outlineVariant),
            ),
            child: ListTile(
              iconColor: cs.onSurface,
              textColor: cs.onSurface,
              leading: const Icon(Icons.location_on_outlined),
              title: const Text('Alamat'),
              subtitle: Text(alamat, style: TextStyle(color: cs.onSurfaceVariant)),
            ),
          ),

          const SizedBox(height: 24),

          // ===== Kelas & Program =====
          Row(
            children: [
              Expanded(child: Text('Kelas & Program Saya', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
              TextButton(onPressed: () {}, child: const Text('Lihat semua')),
            ],
          ),
          const SizedBox(height: 8),

          ...daftarKelasProgram.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  elevation: 0,
                  color: cardBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: cs.outlineVariant),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    iconColor: cs.onSurface,
                    textColor: cs.onSurface,
                    title: Text(item['title'] ?? '-'),
                    subtitle: Text(item['subtitle'] ?? '-', style: TextStyle(color: cs.onSurfaceVariant)),
                    leading: const Icon(Icons.menu_book_rounded),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {},
                  ),
                ),
              )),

          const SizedBox(height: 24),

          // ===== Logout =====
          Card(
            elevation: 0,
            color: cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: cs.outlineVariant),
            ),
            child: ListTile(
              iconColor: cs.error,
              textColor: cs.onSurface,
              leading: const Icon(Icons.logout_rounded),
              title: const Text('Keluar'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: _confirmLogout,
            ),
          ),
        ],
      ),
    );
  }

  // ===== Logout bottom sheet =====
  void _confirmLogout() async {
    final cs = Theme.of(context).colorScheme;
    final ok = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      backgroundColor: cs.surfaceContainerHigh, // lebih terang di dark
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: cs.errorContainer,
                child: Icon(Icons.logout, color: cs.onErrorContainer),
              ),
              title: const Text('Konfirmasi'),
              subtitle: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal'))),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      backgroundColor: cs.errorContainer,
                      foregroundColor: cs.onErrorContainer,
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Keluar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    if (ok == true && mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}

/// ===========================================================================
/// Halaman Edit (terpisah) – aman & kontras di dark mode.
/// ===========================================================================

class EditProfilePage extends StatefulWidget {
  final Map<String, String> initial;
  const EditProfilePage({super.key, required this.initial});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late String nama   = widget.initial['nama']   ?? '';
  late String gender = widget.initial['gender'] ?? 'Laki-Laki';
  late String job    = widget.initial['job']    ?? 'Pelajar / Mahasiswa';
  late String lahir  = widget.initial['lahir']  ?? '1 Januari 2000';
  late String alamat = widget.initial['alamat'] ?? '';

  final genders = const ['Laki-Laki', 'Perempuan'];
  final jobs = const ['Pelajar / Mahasiswa', 'Karyawan', 'Wirausaha', 'Freelancer', 'Lainnya'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? cs.surfaceContainerHigh : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        centerTitle: true,
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        scrolledUnderElevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop<Map<String, String>>(context, {
                'nama': nama, 'gender': gender, 'job': job, 'lahir': lahir, 'alamat': alamat,
              });
            },
            icon: const Icon(Icons.check_rounded),
            label: const Text('Simpan'),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: 'Data Diri',
            color: cardBg,
            children: [
              _Tile(icon: Icons.badge_outlined, title: 'Nama Lengkap', subtitle: nama,
                onTap: () => _editText(context, title: 'Nama Lengkap', initial: nama, onSave: (v) => setState(() => nama = v))),
              _Tile(icon: Icons.cake_outlined, title: 'Tanggal Lahir', subtitle: lahir,
                onTap: () => _editDate(context, initialText: lahir, onSave: (v) => setState(() => lahir = v))),
              _Tile(icon: Icons.wc_outlined, title: 'Jenis Kelamin', subtitle: gender,
                onTap: () => _editPicker(context, title: 'Jenis Kelamin', options: genders, selected: gender, onSave: (v) => setState(() => gender = v))),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Pekerjaan & Alamat',
            color: cardBg,
            children: [
              _Tile(icon: Icons.work_outline_rounded, title: 'Status Pekerjaan', subtitle: job,
                onTap: () => _editPicker(context, title: 'Status Pekerjaan', options: jobs, selected: job, onSave: (v) => setState(() => job = v))),
              _Tile(icon: Icons.location_on_outlined, title: 'Alamat', subtitle: alamat,
                onTap: () => _editMultiline(context, title: 'Alamat', initial: alamat, onSave: (v) => setState(() => alamat = v))),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop<Map<String, String>>(context, {
                'nama': nama, 'gender': gender, 'job': job, 'lahir': lahir, 'alamat': alamat,
              });
            },
            icon: const Icon(Icons.save_rounded),
            label: const Text('Simpan Perubahan'),
          ),
        ],
      ),
    );
  }

  // ====== Editor helpers (bottom sheets) ======
  Future<void> _editText(BuildContext context,
      {required String title, required String initial, required ValueChanged<String> onSave}) async {
    final controller = TextEditingController(text: initial);
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _Sheet(
        title: title,
        child: TextField(
          controller: controller,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(hintText: 'Tulis di sini'),
        ),
        onSave: () {
          final v = controller.text.trim();
          if (v.isNotEmpty) onSave(v);
        },
      ),
    );
  }

  Future<void> _editMultiline(BuildContext context,
      {required String title, required String initial, required ValueChanged<String> onSave}) async {
    final controller = TextEditingController(text: initial);
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _Sheet(
        title: title,
        child: TextField(
          controller: controller,
          minLines: 3,
          maxLines: 6,
          decoration: const InputDecoration(hintText: 'Tulis di sini'),
        ),
        onSave: () {
          final v = controller.text.trim();
          if (v.isNotEmpty) onSave(v);
        },
      ),
    );
  }

  Future<void> _editPicker(BuildContext context,
      {required String title, required List<String> options, required String selected, required ValueChanged<String> onSave}) async {
    String current = selected;
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _Sheet(
        title: title,
        child: StatefulBuilder(
          builder: (_, setS) => Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((e) {
              final picked = current == e;
              return ListTile(
                iconColor: Theme.of(context).colorScheme.onSurface,
                textColor: Theme.of(context).colorScheme.onSurface,
                leading: Icon(picked ? Icons.radio_button_checked : Icons.radio_button_off),
                title: Text(e),
                onTap: () => setS(() => current = e),
              );
            }).toList(),
          ),
        ),
        onSave: () => onSave(current),
      ),
    );
  }

  Future<void> _editDate(BuildContext context,
      {required String initialText, required ValueChanged<String> onSave}) async {
    final init = _parseIndoDate(initialText) ?? DateTime(2000, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: init,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) onSave(_formatIndoDate(picked));
  }

  // ====== Indo date helpers ======
  static String _formatIndoDate(DateTime date) {
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

/// ====== UI Building Blocks ======

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Color? color;
  const _Section({required this.title, required this.children, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Card(
      elevation: 0,
      color: color ?? (theme.brightness == Brightness.dark ? cs.surfaceContainerHigh : Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  Expanded(child: Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700))),
                ],
              ),
            ),
            const Divider(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _Tile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      iconColor: cs.onSurface,
      textColor: cs.onSurface,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle.isEmpty ? '-' : subtitle, style: TextStyle(color: cs.onSurfaceVariant)),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}

class _Sheet extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onSave;
  const _Sheet({required this.title, required this.child, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: viewInsets + 16, top: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          child,
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Batal'))),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () { onSave(); Navigator.pop(context); },
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
