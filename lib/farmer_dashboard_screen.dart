import 'package:flutter/material.dart';
import 'color_typography.dart';
import 'app_state.dart';
import 'farmer_add_product_screen.dart';
import 'farmer_manage_products_screen.dart';
import 'farmer_orders_screen.dart';
import 'farmer_profile_screen.dart';
import 'product_image_view.dart';

class FarmerDashboardScreen extends StatefulWidget {
  const FarmerDashboardScreen({super.key});

  @override
  State<FarmerDashboardScreen> createState() => _FarmerDashboardScreenState();
}

class _FarmerDashboardScreenState extends State<FarmerDashboardScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final pages = [
          _DashboardHome(onNavigate: (i) => setState(() => _navIndex = i)),
          const FarmerManageProductsScreen(),
          const FarmerOrdersScreen(),
          const FarmerProfileScreen(),
        ];
        return Scaffold(
          backgroundColor: AppColors.surfaceScaffoldOld,
          body: SafeArea(child: pages[_navIndex]),
          bottomNavigationBar: _buildBottomNav(),
        );
      },
    );
  }

  Widget _buildBottomNav() {
    final items = [
      _NavItem(Icons.home_rounded, Icons.home_outlined, 'Home'),
      _NavItem(
          Icons.inventory_2_rounded, Icons.inventory_2_outlined, 'Products'),
      _NavItem(
          Icons.receipt_long_rounded, Icons.receipt_long_outlined, 'Orders'),
      _NavItem(Icons.person_rounded, Icons.person_outline, 'Profile'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.97),
        border: const Border(
            top: BorderSide(color: AppColors.slate200, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: List.generate(items.length, (i) {
                  final selected = i == _navIndex;
                  final item = items[i];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _navIndex = i),
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Icon(
                                  selected ? item.activeIcon : item.icon,
                                  size: 22,
                                  color: selected
                                      ? AppColors.brand700
                                      : AppColors.slate500,
                                ),
                                if (i == 2 &&
                                    AppState.instance.pendingOrders > 0)
                                  Positioned(
                                    right: -6,
                                    top: -4,
                                    child: Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 1),
                                      constraints: const BoxConstraints(
                                          minWidth: 15, minHeight: 15),
                                      decoration: BoxDecoration(
                                        color: AppColors.notificationDot,
                                        borderRadius: AppRadii.pillR,
                                        border: Border.all(
                                            color: Colors.white, width: 1.5),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${AppState.instance.pendingOrders}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: selected
                                    ? AppColors.brand700
                                    : AppColors.slate500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Container(
              width: 128,
              height: 4,
              margin: const EdgeInsets.only(bottom: 4, top: 2),
              decoration: BoxDecoration(
                color: AppColors.slate300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData activeIcon;
  final IconData icon;
  final String label;
  const _NavItem(this.activeIcon, this.icon, this.label);
}

// ═══════════════════════════════════════════════════════════════════
//  HOME TAB
// ═══════════════════════════════════════════════════════════════════
class _DashboardHome extends StatelessWidget {
  final void Function(int) onNavigate;
  const _DashboardHome({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildSummaryCards(s),
          const SizedBox(height: 20),
          _buildActionGrid(context),
          const SizedBox(height: 24),
          _buildRecentOrders(s),
          const SizedBox(height: 24),
          _buildInventoryPreview(s),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final p = AppState.instance.profile;
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage: NetworkImage(p.avatarUrl),
          backgroundColor: AppColors.brand200,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Good Morning,',
                  style: TextStyle(fontSize: 11, color: AppColors.slate500)),
              Text(p.name,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.slate900)),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => onNavigate(2),
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
                color: AppColors.slate100, shape: BoxShape.circle),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.notifications_none,
                    size: 18, color: AppColors.slate600),
                if (AppState.instance.pendingOrders > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: AppColors.notificationDot,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(AppState s) {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            label: 'Total Products',
            value: '${s.totalProducts}',
            subtitle: '${s.activeProducts} active',
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.brand700, AppColors.brand800],
            ),
            icon: Icons.inventory_2_outlined,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _summaryCard(
            label: 'Pending Orders',
            value: '${s.pendingOrders}',
            subtitle: '${s.totalOrders} total',
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.brand800, AppColors.brand900],
            ),
            icon: Icons.receipt_long_outlined,
          ),
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String label,
    required String value,
    required String subtitle,
    required Gradient gradient,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: AppRadii.lgR,
        boxShadow: AppShadows.heroGlow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(label,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
              Icon(icon, color: Colors.white.withOpacity(0.6), size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(subtitle,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _actionButton(Icons.add_circle_outline, 'Add Product', () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const FarmerAddProductScreen()));
        }),
        _actionButton(Icons.inventory_2_outlined, 'Manage Products',
            () => onNavigate(1)),
        _actionButton(Icons.receipt_long_outlined, 'View Orders',
            () => onNavigate(2)),
        _actionButton(Icons.person_outline, 'Profile', () => onNavigate(3)),
      ],
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadii.mdR,
          border: Border.all(color: AppColors.slate200),
          boxShadow: AppShadows.softSmall,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.brand700, size: 20),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                    color: AppColors.slate800)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOrders(AppState s) {
    final recent = s.orders.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Orders',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.slate900)),
            GestureDetector(
              onTap: () => onNavigate(2),
              child: const Text('See All',
                  style: TextStyle(
                      color: AppColors.brand700,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (recent.isEmpty)
          _emptyBox('No orders yet')
        else
          ...recent.map(_orderMiniCard),
      ],
    );
  }

  Widget _orderMiniCard(CustomerOrder o) {
    final color = _statusColor(o.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadii.mdR,
        border: Border.all(color: AppColors.slate200),
      ),
      child: Row(
        children: [
          ProductImageView(
            imageUrl: o.image,
            width: 44,
            height: 44,
            borderRadius: AppRadii.smR,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${o.id} • ${o.customerName}',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate900)),
                const SizedBox(height: 2),
                Text(o.itemSummary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.slate500)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: AppRadii.pillR,
                ),
                child: Text(o.status,
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: color)),
              ),
              const SizedBox(height: 4),
              Text('UGX ${AppState.formatPrice(o.total)}',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.brand700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryPreview(AppState s) {
    final list = s.products.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Your Products',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.slate900)),
            GestureDetector(
              onTap: () => onNavigate(1),
              child: const Text('See All',
                  style: TextStyle(
                      color: AppColors.brand700,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (list.isEmpty)
          _emptyBox('No products yet — tap Add Product')
        else
          ...list.map(_productMiniCard),
      ],
    );
  }

  Widget _productMiniCard(Product p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadii.mdR,
        border: Border.all(color: AppColors.slate200),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          ProductImageView(
            imageUrl: p.image,
            localImagePath: p.localImagePath,
            width: 50,
            height: 50,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColors.slate900)),
                Text(
                    'UGX ${AppState.formatPrice(p.price)}/${p.unit.replaceAll("per ", "")}',
                    style: const TextStyle(
                        color: AppColors.slate600,
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
                Text('Stock: ${p.stock}',
                    style: TextStyle(
                        color: p.stock <= 5
                            ? AppColors.statusRejectedText
                            : AppColors.brand700,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyBox(String msg) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.slate50,
          borderRadius: AppRadii.mdR,
          border: Border.all(color: AppColors.slate200),
        ),
        child: Text(msg,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: AppColors.slate500)),
      );

  Color _statusColor(String status) {
    switch (status) {
      case 'Pending':
        return AppColors.statusPendingText;
      case 'Accepted':
        return AppColors.statusAcceptedText;
      case 'Delivered':
        return AppColors.statusDeliveredText;
      default:
        return AppColors.statusRejectedText;
    }
  }
}