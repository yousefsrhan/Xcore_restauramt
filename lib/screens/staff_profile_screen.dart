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
    if (!_idResolved) {
      _idResolved = true;
      _resolveId();
    }
  }

  Future<void> _resolveId() async {
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is String && arg.isNotEmpty) {
      setState(() => _currentId = arg.trim());
      return;
    }
    final snap = await FirebaseFirestore.instance.collection('staff').limit(1).get();
    if (snap.docs.isNotEmpty && mounted) {
      setState(() => _currentId = snap.docs.first.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      drawer: const AppDrawer(),
      bottomNavigationBar: const BottomNavBar(currentIndex: -1),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('staff').snapshots(),
        builder: (context, snapshot) {
          if (!_idResolved || !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allDocs = snapshot.data?.docs ?? [];

          QueryDocumentSnapshot? currentDoc;
          for (final doc in allDocs) {
            if (doc.id == _currentId) {
              currentDoc = doc;
              break;
            }
          }
          currentDoc ??= allDocs.isNotEmpty ? allDocs.first : null;

          final teamDocs = allDocs.where((d) => d.id != currentDoc?.id).toList();

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(theme),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: currentDoc != null ? _HeroCard(doc: currentDoc) : const SizedBox(),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList.separated(
                  itemCount: teamDocs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _TeamTile(doc: teamDocs[i]),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                  child: _LogoutButton(
                    onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme) => SliverAppBar(
    pinned: true,
    title: Text('XCORE',
        style: theme.textTheme.headlineSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w900,
        )),
    leading: Builder(
      builder: (ctx) => IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => Scaffold.of(ctx).openDrawer(),
      ),
    ),
  );
}

class _HeroCard extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  const _HeroCard({required this.doc});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = doc.data() as Map<String, dynamic>;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: _Avatar(imgUrl: data['img'] ?? '', radius: 35),
              title: Text(data['name'] ?? '', style: theme.textTheme.headlineSmall),
              subtitle: Text(
                data['role']?.toString().toUpperCase() ?? '',
                style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary),
              ),
            ),
            const SizedBox(height: 24),
            _SalaryBox(salary: data['salary']),
          ],
        ),
      ),
    );
  }
}

class _TeamTile extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  const _TeamTile({required this.doc});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = doc.data() as Map<String, dynamic>;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: AppRadius.cardAll,
      ),
      child: Row(
        children: [
          _Avatar(imgUrl: data['img'] ?? '', radius: 25),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['name'] ?? '', style: theme.textTheme.titleMedium),
                Text(
                  data['role'] ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Text('${data['salary']} ج', style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _SalaryBox extends StatelessWidget {
  final dynamic salary;
  const _SalaryBox({required this.salary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: AppRadius.cardAll,
      ),
      child: Row(
        children: [
          Icon(Icons.payments_outlined, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('MONTHLY SALARY', style: theme.textTheme.labelSmall),
              Text('$salary ج', style: theme.textTheme.titleLarge),
            ],
          ),
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CircleAvatar(
      radius: radius,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      backgroundImage: imgUrl.isNotEmpty ? NetworkImage(imgUrl) : null,
      child: imgUrl.isEmpty ? Icon(Icons.person, color: theme.colorScheme.onSurfaceVariant) : null,
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.logout),
      label: const Text('LOGOUT / END SHIFT'),
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.colorScheme.error,
        side: BorderSide(color: theme.colorScheme.error.withOpacity(0.2)),
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonAll),
      ),
    );
  }
}
