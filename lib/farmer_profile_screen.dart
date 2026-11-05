import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'color_typography.dart';
import 'app_state.dart';

class FarmerProfileScreen extends StatefulWidget {
  const FarmerProfileScreen({super.key});

  @override
  State<FarmerProfileScreen> createState() => _FarmerProfileScreenState();
}

class _FarmerProfileScreenState extends State<FarmerProfileScreen> {
  final _picker = ImagePicker();

  Future<void> _pickAvatar() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Change Profile Photo',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.slate900)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined,
                  color: AppColors.brand700),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: AppColors.brand700),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, 'gallery'),
            ),
            if (AppState.instance.currentUser != null &&
                AppState.instance.currentUser!.localAvatarPath.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.delete_outline,
                    color: AppColors.statusRejectedText),
                title: const Text('Remove photo'),
                onTap: () => Navigator.pop(context, 'remove'),
              ),
          ],
        ),
      ),
    );
    if (choice == null) return;
    if (choice == 'remove') {
      await AppState.instance
          .updateCurrentUserAvatar(localAvatarPath: '');
      return;
    }
    final src = choice == 'camera' ? ImageSource.camera : ImageSource.gallery;
    final f =
        await _picker.pickImage(source: src, imageQuality: 75, maxWidth: 600);
    if (f != null) {
      await AppState.instance
          .updateCurrentUserAvatar(localAvatarPath: f.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance;
    return AnimatedBuilder(
      animation: s,
      builder: (context, _) {
        final p = s.profile;
        final user = s.currentUser;

        // Build avatar widget with fallback
        Widget avatar;
        if (user != null &&
            user.localAvatarPath.isNotEmpty &&
            File(user.localAvatarPath).existsSync()) {
          avatar = CircleAvatar(
            radius: 44,
            backgroundImage: FileImage(File(user.localAvatarPath)),
            backgroundColor: AppColors.brand200,
          );
        } else if (user != null && user.avatarUrl.isNotEmpty) {
          avatar = CircleAvatar(
            radius: 44,
            backgroundImage: NetworkImage(user.avatarUrl),
            backgroundColor: AppColors.brand200,
          );
        } else if (p.avatarUrl.isNotEmpty) {
          avatar = CircleAvatar(
            radius: 44,
            backgroundImage: NetworkImage(p.avatarUrl),
            backgroundColor: AppColors.brand200,
          );
        } else {
          avatar = CircleAvatar(
            radius: 44,
            backgroundColor: AppColors.brand200,
            child: Text(
              (user?.name.isNotEmpty ?? false)
                  ? user!.name[0].toUpperCase()
                  : 'F',
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          );
        }

        final displayName = user?.name ?? p.name;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.brand700, AppColors.brand800],
                  ),
                  borderRadius: AppRadii.lgR,
                  boxShadow: AppShadows.heroGlow,
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        avatar,
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickAvatar,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.brand200, width: 2),
                              ),
                              child: const Icon(Icons.camera_alt,
                                  size: 14, color: AppColors.brand700),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(displayName,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 2),
                    Text(p.farmName,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.85))),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(
                            5,
                            (_) => const Icon(Icons.star,
                                size: 14, color: AppColors.amber500)),
                        const SizedBox(width: 6),
                        Text('${p.rating} (${p.totalReviews} reviews)',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.85))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Stats row
              Row(
                children: [
                  _statCard(
                      '${s.totalProducts}', 'Products', Icons.inventory_2),
                  const SizedBox(width: 8),
                  _statCard('${s.totalOrders}', 'Orders', Icons.receipt_long),
                  const SizedBox(width: 8),
                  _statCard(
                      'UGX ${_short(s.totalRevenue)}',
                      'Revenue',
                      Icons.trending_up),
                ],
              ),
              const SizedBox(height: 20),

              // Contact info
              _sectionCard(
                title: 'Contact Information',
                children: [
                  _detailRow(Icons.phone_outlined, 'Phone', p.phone),
                  _detailRow(Icons.email_outlined, 'Email', p.email),
                  _detailRow(
                      Icons.location_on_outlined, 'Location', p.location),
                ],
              ),
              const SizedBox(height: 12),
              _sectionCard(
                title: 'About',
                children: [
                  Text(p.bio,
                      style: const TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: AppColors.slate700)),
                ],
              ),
              const SizedBox(height: 12),

              // Reviews
              _sectionCard(
                title: 'Customer Reviews',
                children: s.reviews
                    .map((r) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ...List.generate(
                                      r.rating,
                                      (_) => const Icon(Icons.star,
                                          size: 11,
                                          color: AppColors.amber500)),
                                  const SizedBox(width: 6),
                                  Text(r.customerName,
                                      style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.slate700)),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(r.comment,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.slate600)),
                            ],
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),

              // Edit + Logout
              SizedBox(
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: () => _showEditDialog(context, s),
                  icon: const Icon(Icons.edit_outlined,
                      size: 16, color: Colors.white),
                  label: const Text('Edit Profile',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand700,
                    shape:
                        RoundedRectangleBorder(borderRadius: AppRadii.mdR),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 46,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await AppState.instance.logout();
                    if (!context.mounted) return;
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  },
                  icon: const Icon(Icons.logout,
                      size: 16, color: AppColors.statusRejectedText),
                  label: const Text('Log Out',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.statusRejectedText)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: AppColors.statusRejectedText),
                    shape:
                        RoundedRectangleBorder(borderRadius: AppRadii.mdR),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statCard(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadii.mdR,
          border: Border.all(color: AppColors.slate200),
          boxShadow: AppShadows.softSmall,
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: AppColors.brand700),
            const SizedBox(height: 4),
            Text(value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.slate900)),
            Text(label,
                style: const TextStyle(
                    fontSize: 9.5, color: AppColors.slate500)),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard(
      {required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadii.mdR,
        border: Border.all(color: AppColors.slate200),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate900)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.slate500),
          const SizedBox(width: 8),
          SizedBox(
              width: 70,
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.slate500))),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.slate800)),
          ),
        ],
      ),
    );
  }

  String _short(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }

  void _showEditDialog(BuildContext context, AppState s) {
    final nameCtrl = TextEditingController(text: s.profile.name);
    final farmCtrl = TextEditingController(text: s.profile.farmName);
    final phoneCtrl = TextEditingController(text: s.profile.phone);
    final emailCtrl = TextEditingController(text: s.profile.email);
    final locCtrl = TextEditingController(text: s.profile.location);
    final bioCtrl = TextEditingController(text: s.profile.bio);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Edit Profile',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.slate900)),
              const SizedBox(height: 16),
              _field('Name', nameCtrl),
              _field('Farm Name', farmCtrl),
              _field('Phone', phoneCtrl),
              _field('Email', emailCtrl),
              _field('Location', locCtrl),
              _field('Bio', bioCtrl, maxLines: 3),
              const SizedBox(height: 12),
              SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: () async {
                    await s.updateProfile(
                      name: nameCtrl.text.trim(),
                      farmName: farmCtrl.text.trim(),
                      phone: phoneCtrl.text.trim(),
                      email: emailCtrl.text.trim(),
                      location: locCtrl.text.trim(),
                      bio: bioCtrl.text.trim(),
                    );
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Profile updated'),
                        backgroundColor: AppColors.brand700,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: AppRadii.mdR),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand700,
                    shape:
                        RoundedRectangleBorder(borderRadius: AppRadii.mdR),
                  ),
                  child: const Text('Save Changes',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate700)),
          const SizedBox(height: 4),
          TextField(
            controller: ctrl,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: AppRadii.mdR,
                borderSide: const BorderSide(color: AppColors.slate200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadii.mdR,
                borderSide: const BorderSide(color: AppColors.slate200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadii.mdR,
                borderSide:
                    const BorderSide(color: AppColors.brand600, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}