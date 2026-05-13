// ==========================================
// screens/staff_profile_screen.dart
// ==========================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/app_drawer.dart';

class StaffProfileScreen extends StatefulWidget {
  const StaffProfileScreen({super.key});

  @override
  State<StaffProfileScreen> createState() => _StaffProfileScreenState();
}

class _StaffProfileScreenState extends State<StaffProfileScreen> {
  String? _currentId;
  bool _idResolved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_idResolved) return;
    _idResolved = true;
    _resolveCurrentId();
  }

  void _setCurrentId(String id) {
    if (mounted) setState(() => _currentId = id);
  }

  Future<String?> _firstStaffId({String? role}) async {
    final collection = FirebaseFirestore.instance.collection('staff');
    final query = role == null
        ? collection.limit(1)
        : collection.where('role', isEqualTo: role).limit(1);
    final snap = await query.get();
    return snap.docs.isNotEmpty ? snap.docs.first.id : null;
  }

  Future<void> _resolveCurrentId() async {
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is String && arg.trim().isNotEmpty) return _setCurrentId(arg.trim());

    try {
      final id = await _firstStaffId(role: 'cashier') ?? await _firstStaffId();
      if (id != null) _setCurrentId(id);
    } catch (e) {
      debugPrint('[StaffProfile] Error resolving ID: $e');
    }
  }

  QueryDocumentSnapshot? _currentDoc(List<QueryDocumentSnapshot> allDocs) {
    for (final doc in allDocs) {
      if (doc.id == _currentId) return doc;
    }
    return allDocs.isNotEmpty ? allDocs.first : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      bottomNavigationBar: const BottomNavBar(currentIndex: -1),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('staff').snapshots(),
        builder: (context, snapshot) {
          if (!_idResolved || snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          final allDocs = snapshot.data?.docs ?? [];
          final currentDoc = _currentDoc(allDocs);
          final teamDocs = allDocs.where((d) => d.id != currentDoc?.id).toList();

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: currentDoc == null ? const SizedBox() : _HeroCard(doc: currentDoc),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 14),
                  child: _SectionHeader(count: teamDocs.length),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList.separated(
                  itemCount: teamDocs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _TeamTile(doc: teamDocs[i]),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 40),
                  child: _LogoutButton(onTap: () => Navigator.of(context).pushReplacementNamed('/login')),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar() => SliverAppBar(
    backgroundColor: AppColors.background,
    pinned: true,
    leading: Builder(
      builder: (ctx) => IconButton(
        icon: const Icon(Icons.menu, color: AppColors.primary),
        onPressed: () => Scaffold.of(ctx).openDrawer(),
      ),
    ),
    title: const Text('XCORE', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary)),
    actions: const [
      Center(
        child: Padding(
          padding: EdgeInsets.only(right: 20),
          child: Text(
            'STAFF',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.onSurfaceVariant),
          ),
        ),
      ),
    ],
  );
}

class _HeroCard extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  const _HeroCard({required this.doc});

  @override
  Widget build(BuildContext context) {
    final data = doc.data() as Map<String, dynamic>;
    final String name = data['name'] ?? 'Unknown';
    final String role = data['role'] ?? 'Staff';
    final String imgUrl = data['img'] ?? '';
    final salary = data['salary'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(28)),
      child: Column(
        children: [
          Row(
            children: [
              _Avatar(imgUrl: imgUrl, radius: 45),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        role.toUpperCase(),
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SalaryInfo(salary: salary),
        ],
      ),
    );
  }
}

class _TeamTile extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  const _TeamTile({required this.doc});

  @override
  Widget build(BuildContext context) {
    final data = doc.data() as Map<String, dynamic>;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          _Avatar(imgUrl: data['img'] ?? '', radius: 25),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['name'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(data['role'] ?? '', style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
              ],
            ),
          ),
          Text('${data['salary'] ?? 0} ج',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String imgUrl;
  final double radius;
  const _Avatar({required this.imgUrl, required this.radius});

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: radius,
    backgroundColor: AppColors.surfaceContainerHighest,
    backgroundImage: imgUrl.isNotEmpty ? NetworkImage(imgUrl) : null,
    child: imgUrl.isEmpty ? Icon(Icons.person, color: AppColors.onSurfaceVariant, size: radius) : null,
  );
}

class _SalaryInfo extends StatelessWidget {
  final dynamic salary;
  const _SalaryInfo({required this.salary});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppColors.surfaceContainerHighest, borderRadius: BorderRadius.circular(16)),
    child: Row(
      children: [
        const Icon(Icons.payments_outlined, color: AppColors.primary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('MONTHLY SALARY',
                style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.bold)),
            Text('$salary ج', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    ),
  );
}

class _SectionHeader extends StatelessWidget {
  final int count;
  const _SectionHeader({required this.count});

  @override
  Widget build(BuildContext context) => Row(children: [
    const Text('TEAM MEMBERS',
        style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
    const SizedBox(width: 8),
    CircleAvatar(
      radius: 10,
      backgroundColor: AppColors.surfaceContainerHighest,
      child: Text('$count', style: const TextStyle(fontSize: 10, color: Colors.white)),
    ),
  ]);
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
    onPressed: onTap,
    icon: const Icon(Icons.logout, color: Colors.redAccent),
    label: const Text('LOGOUT / END SHIFT', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red.withOpacity(0.1),
      minimumSize: const Size(double.infinity, 55),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
    ),
  );
}
