import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'kelas_dashboard.dart';
import 'akun_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const HomePage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const HomeDashboard(),
      const KelasDashboardPage(),
      const KoinLSPage(),
      AkunPage(onToggleTheme: widget.onToggleTheme),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.class_outlined),
            selectedIcon: Icon(Icons.class_),
            label: 'Kelas',
          ),
          NavigationDestination(
            icon: Icon(Icons.monetization_on_outlined),
            selectedIcon: Icon(Icons.monetization_on),
            label: 'KoinLS',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'To-Do',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}

// ================== BERANDA MODERN ==================
class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final bannerImages = const [
    'assets/images/banner.png',
    'assets/images/teknikpemilahan.png',
    'assets/images/membangunusaha.png',
  ];

  int _currentBanner = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? cs.surfaceContainerHigh : cs.surfaceContainerHighest;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/images/header.jpg'),
            ),
            const SizedBox(width: 12),
            Text(
              'Boris Justin Prima D 👋',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Toggle tema',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Belum ada notifikasi baru.'), duration: Duration(seconds: 2)),
            ),
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                CarouselSlider(
                  items: bannerImages
                      .map((img) => Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(img, fit: BoxFit.cover),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [Colors.black26, Colors.transparent],
                                  ),
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                  options: CarouselOptions(
                    height: 180,
                    autoPlay: true,
                    enlargeCenterPage: false,
                    viewportFraction: 1,
                    onPageChanged: (index, _) =>
                        setState(() => _currentBanner = index),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: bannerImages.asMap().entries.map((e) {
                      final active = _currentBanner == e.key;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: active ? 20 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: active
                              ? cs.primary
                              : cs.onSurfaceVariant.withOpacity(.4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: cardBg,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: cs.outlineVariant),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: const [
                  _MenuItem(image: 'assets/images/prakerja.png', label: 'Prakerja'),
                  _MenuItem(image: 'assets/images/magang.png', label: 'Magang+'),
                  _MenuItem(image: 'assets/images/subs.png', label: 'Subscribe'),
                  _MenuItem(image: 'assets/images/lainnya.png', label: 'Learning'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [cs.primaryContainer, cs.secondaryContainer],
              ),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Redeem Voucher Prakerja',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: cs.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Segera tukarkan voucher Prakerja-mu dengan kelas pilihan!',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onPrimaryContainer.withOpacity(.85),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: () {},
                    child: const Text('Masukkan Voucher'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Kelas Terpopuler',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              TextButton(onPressed: () {}, child: const Text('Lihat semua')),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _ClassCard(
                  image: 'assets/images/teknikpemilahan.png',
                  title: 'Teknik Pemilahan & Pengolahan',
                  price: 'Rp 1.500.000',
                  rating: 4.8,
                  badge: 'Terpopuler',
                ),
                _ClassCard(
                  image: 'assets/images/meningkatkan.png',
                  title: 'Meningkatkan Pertumbuhan Tanaman',
                  price: 'Rp 1.250.000',
                  rating: 4.9,
                  badge: 'Baru',
                ),
                _ClassCard(
                  image: 'assets/images/bdart.png',
                  title: 'Digital Marketing untuk Pemula',
                  price: 'Rp 1.300.000',
                  rating: 4.7,
                  badge: 'Terpopuler',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ========================= COMPONENTS =========================
class _MenuItem extends StatelessWidget {
  final String image;
  final String label;
  const _MenuItem({required this.image, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: cs.secondaryContainer,
          child: Image.asset(image, width: 28, height: 28),
        ),
        const SizedBox(height: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _ClassCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final double rating;
  final String? badge;
  const _ClassCard({
    required this.image,
    required this.title,
    required this.price,
    required this.rating,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? cs.surfaceContainerHigh : cs.surface;

    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(image, height: 110, width: double.infinity, fit: BoxFit.cover),
              ),
              if (badge != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: cs.tertiary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                    ),
                    child: Text(badge!, style: theme.textTheme.labelSmall?.copyWith(color: cs.onTertiary)),
                  ),
                )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, size: 16, color: cs.secondary),
                        const SizedBox(width: 2),
                        Text(rating.toStringAsFixed(1), style: theme.textTheme.bodySmall),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================== KOIN LS MODERN ==================
class KoinLSPage extends StatefulWidget {
  const KoinLSPage({super.key});

  @override
  State<KoinLSPage> createState() => _KoinLSPageState();
}

class _KoinLSPageState extends State<KoinLSPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> transactions = [];
  int saldo = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final saldoDoc = await _firestore.collection('users').doc('user1').get();
    final userSaldo = saldoDoc.exists ? saldoDoc['saldo'] as int : 0;

    final txSnapshot = await _firestore
        .collection('users')
        .doc('user1')
        .collection('transactions')
        .orderBy('date', descending: true)
        .get();

    final txList = txSnapshot.docs.map((doc) => doc.data()).toList();

    setState(() {
      saldo = userSaldo;
      transactions = txList;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? cs.surfaceContainerHigh : cs.surface;

    if (loading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(
        title: const Text('KoinLS'),
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [cs.primaryContainer, cs.secondaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Saldo Koin Kamu',
                      style: theme.textTheme.titleSmall?.copyWith(color: cs.onPrimaryContainer)),
                  const SizedBox(height: 6),
                  Text('$saldo Koin',
                      style: theme.textTheme.headlineSmall?.copyWith(
                          color: cs.onPrimaryContainer, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Top-up Koin'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: () {},
                    icon: const Icon(Icons.redeem),
                    label: const Text('Redeem Koin'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Riwayat',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: transactions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final tx = transactions[index];
                  final positif = tx['amount'] > 0;
                  return Card(
                    elevation: 0,
                    color: cardBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: cs.outlineVariant),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: positif ? cs.primaryContainer : cs.errorContainer,
                        child: Icon(
                          positif ? Icons.add : Icons.remove,
                          color: positif ? cs.onPrimaryContainer : cs.onErrorContainer,
                        ),
                      ),
                      title: Text(tx['title']),
                      subtitle: Text(tx['date'], style: TextStyle(color: cs.onSurfaceVariant)),
                      trailing: Text(
                        '${positif ? '+' : ''}${tx['amount']} Koin',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: positif ? cs.primary : cs.error,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
