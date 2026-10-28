import 'package:flutter/material.dart';
import 'color_typography.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _selectedFilter = 0;

  final List<Map<String, dynamic>> _filters = [
    {'label': 'All Orders', 'count': 8},
    {'label': 'Pending', 'count': 1},
    {'label': 'Processing', 'count': null},
    {'label': 'Delivered', 'count': null},
    {'label': 'Cancelled', 'count': null},
  ];

  final List<Map<String, dynamic>> _orders = [
    {
      'orderId': '#AGT-001',
      'dateTime': '16 Oct, 10:24 AM',
      'farm': 'Mukono Farm Hub',
      'items': 'Tomatoes (5 kg), Red Onions (2 kg)',
      'meta': '2 farm produce items • Batch #MK42',
      'payment': 'MTN Mobile Money',
      'paymentBg': const Color(0xFFFFFBEB),      // yellow-50
      'paymentBorder': const Color(0xFFFDE68A),  // yellow-200
      'paymentText': const Color(0xFF854D0E),    // yellow-800
      'total': 'UGX 32,000',
      'status': 'Pending',
      'statusBg': const Color(0xFFFFFBEB),       // amber-50
      'statusBorder': const Color(0xFFFDE68A),   // amber-200
      'statusText': const Color(0xFFB45309),     // amber-700
      'imgUrl':
          'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=200&q=80',
      'primaryAction': 'Confirm Order',
      'secondaryAction': 'Details',
      'showRating': false,
    },
    {
      'orderId': '#AGT-002',
      'dateTime': '11 Oct, 04:15 PM',
      'farm': 'Wakiso Organics Ltd',
      'items': 'Maize (10 kg), Yellow Beans (5 kg)',
      'meta': 'Dry Grain Stock • In packaging',
      'payment': 'Airtel Money',
      'paymentBg': const Color(0xFFFEF2F2),      // red-50
      'paymentBorder': const Color(0xFFFECACA),  // red-200
      'paymentText': const Color(0xFFB91C1C),    // red-700
      'total': 'UGX 45,000',
      'status': 'Accepted',
      'statusBg': const Color(0xFFECFDF5),       // emerald-50
      'statusBorder': const Color(0xFFA7F3D0),   // emerald-200
      'statusText': const Color(0xFF065F46),     // emerald-800
      'imgUrl':
          'https://images.unsplash.com/photo-1551754655-cd27e38d2076?auto=format&fit=crop&w=200&q=80',
      'primaryAction': 'Track Dispatch',
      'secondaryAction': 'Invoice',
      'showRating': false,
    },
    {
      'orderId': '#AGT-003',
      'dateTime': '08 Oct, 09:30 AM',
      'farm': 'Kabale Highlands Depot',
      'items': 'Irish Potatoes (15 kg), Tomatoes (2 kg)',
      'meta': 'Delivered to Kampala Central',
      'payment': 'MTN Mobile Money',
      'paymentBg': const Color(0xFFFFFBEB),
      'paymentBorder': const Color(0xFFFDE68A),
      'paymentText': const Color(0xFF854D0E),
      'total': 'UGX 58,000',
      'status': 'Delivered',
      'statusBg': const Color(0xFFEFF6FF),       // blue-50
      'statusBorder': const Color(0xFFBFDBFE),   // blue-200
      'statusText': const Color(0xFF1D4ED8),     // blue-700
      'imgUrl':
          'https://images.unsplash.com/photo-1518977676601-b53f82aba655?auto=format&fit=crop&w=200&q=80',
      'primaryAction': 'Reorder',
      'secondaryAction': null,
      'showRating': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slate50,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterTabs(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                itemCount: _orders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) =>
                    _buildOrderCard(_orders[index]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── Header ─────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border: const Border(
          bottom: BorderSide(color: AppColors.slate100, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Status bar (time + signal icons) ─────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '9:41',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                    color: AppColors.slate900,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.signal_cellular_alt,
                        size: 14, color: AppColors.slate800),
                    SizedBox(width: 5),
                    Icon(Icons.wifi, size: 14, color: AppColors.slate800),
                    SizedBox(width: 5),
                    Icon(Icons.battery_full,
                        size: 16, color: AppColors.slate800),
                  ],
                ),
              ],
            ),
          ),

          // ─── Brand + Title + Action buttons ──────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand line
                      Row(
                        children: const [
                          Icon(Icons.eco,
                              color: AppColors.brand600, size: 14),
                          SizedBox(width: 5),
                          Text(
                            'AGROTRADE FRESH',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: AppColors.brand700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      // Title
                      const Text(
                        'My Orders',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                          color: AppColors.slate900,
                        ),
                      ),
                    ],
                  ),
                ),
                _IconRoundButton(
                  icon: Icons.search,
                  onTap: () {},
                  tooltip: 'Search Orders',
                ),
                const SizedBox(width: 8),
                _IconRoundButton(
                  icon: Icons.tune,
                  onTap: () {},
                  tooltip: 'Filter Orders',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Filter chips ───────────────────────────────────────────────
  Widget _buildFilterTabs() {
    return Container(
      color: Colors.white.withOpacity(0.95),
      child: SizedBox(
        height: 52,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          itemCount: _filters.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final filter = _filters[index];
            final selected = _selectedFilter == index;
            final count = filter['count'] as int?;
            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? AppColors.brand700 : Colors.white,
                  borderRadius: AppRadii.pillR,
                  border: Border.all(
                    color: selected ? AppColors.brand700 : AppColors.slate200,
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppColors.brand700.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      filter['label'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : AppColors.slate600,
                      ),
                    ),
                    if (count != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: selected
                              ? Colors.white.withOpacity(0.25)
                              : AppColors.amber100,
                          borderRadius: AppRadii.pillR,
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: selected
                                ? Colors.white
                                : AppColors.amber700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ─── Order card ─────────────────────────────────────────────────
  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadii.lgR, // rounded-2xl ≈ 16
        border: Border.all(color: AppColors.slate200.withOpacity(0.9)),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── Header row: ID + date + farm + status ──────────
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order ID • date
                      Row(
                        children: [
                          Text(
                            order['orderId'],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.slate900,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              '•',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.slate400,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              order['dateTime'],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.slate500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      // Farm line
                      Row(
                        children: [
                          const Icon(Icons.storefront,
                              size: 12, color: AppColors.brand600),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              order['farm'],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF065F46),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _StatusPill(
                  label: order['status'],
                  bg: order['statusBg'],
                  border: order['statusBorder'],
                  text: order['statusText'],
                ),
              ],
            ),
          ),

          // ─── Divider ───────────────────────────────────────
          Container(height: 1, color: AppColors.slate100),

          // ─── Product row ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: AppRadii.mdR,
                  child: Image.network(
                    order['imgUrl'],
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 56,
                      height: 56,
                      color: AppColors.slate100,
                      child: const Icon(Icons.image_outlined,
                          size: 20, color: AppColors.slate400),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['items'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.slate800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        order['meta'],
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.slate500,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // ── Payment badge OR rating ──
                      if (order['showRating'] == true)
                        Row(
                          children: [
                            ...List.generate(
                              5,
                              (_) => const Icon(
                                Icons.star,
                                size: 12,
                                color: AppColors.amber500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '(Rated 5.0)',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppColors.slate400,
                              ),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            const Text(
                              'Payment:',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.slate500,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: order['paymentBg'],
                                  borderRadius: AppRadii.xsR,
                                  border: Border.all(
                                    color: order['paymentBorder'],
                                    width: 0.8,
                                  ),
                                ),
                                child: Text(
                                  order['payment'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: order['paymentText'],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ─── Divider ───────────────────────────────────────
          Container(height: 1, color: AppColors.slate100),

          // ─── Footer: total + actions ───────────────────────
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['status'] == 'Delivered'
                            ? 'TOTAL PAID'
                            : 'TOTAL BILL',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: AppColors.slate400,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        order['total'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.brand700,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                if (order['secondaryAction'] != null) ...[
                  _ActionButton(
                    label: order['secondaryAction'],
                    variant: _ActionVariant.secondary,
                    onTap: () {},
                  ),
                  const SizedBox(width: 8),
                ],
                _ActionButton(
                  label: order['primaryAction'],
                  variant: order['status'] == 'Delivered'
                      ? _ActionVariant.tertiary
                      : _ActionVariant.primary,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Bottom nav (5 tabs, Orders active with dot) ────────────────
  Widget _buildBottomNav() {
    final items = [
      _NavItem(Icons.home_rounded, Icons.home_outlined, 'Home'),
      _NavItem(Icons.grid_view_rounded, Icons.grid_view_outlined,
          'Categories'),
      _NavItem(Icons.shopping_cart_rounded, Icons.shopping_cart_outlined,
          'Cart'),
      _NavItem(Icons.receipt_long_rounded, Icons.receipt_long_outlined,
          'Orders'),
      _NavItem(Icons.person_rounded, Icons.person_outline, 'Profile'),
    ];
    const activeIndex = 3;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.97),
        border: const Border(
          top: BorderSide(color: AppColors.slate200, width: 1),
        ),
        boxShadow: AppShadows.elevated,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (i) {
                  final selected = i == activeIndex;
                  final item = items[i];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {},
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
                                      : AppColors.slate400,
                                ),
                                // Cart badge
                                if (i == 2)
                                  Positioned(
                                    right: -6,
                                    top: -4,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 1),
                                      constraints: const BoxConstraints(
                                          minWidth: 15, minHeight: 15),
                                      decoration: BoxDecoration(
                                        color: AppColors.brand600,
                                        borderRadius: AppRadii.pillR,
                                        border: Border.all(
                                            color: Colors.white, width: 1.5),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '3',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                // Orders dot indicator (HTML style)
                                if (i == 3 && selected)
                                  Positioned(
                                    right: -1,
                                    bottom: 0,
                                    child: Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: AppColors.brand600,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 1.5),
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
                                    : AppColors.slate400,
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
            // iOS home bar
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

// ═══════════════════════════════════════════════════════════════════
//  Supporting widgets
// ═══════════════════════════════════════════════════════════════════

class _IconRoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  const _IconRoundButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final child = GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.slate100,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: AppColors.slate700),
      ),
    );
    if (tooltip == null) return child;
    return Tooltip(message: tooltip!, child: child);
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color bg;
  final Color border;
  final Color text;

  const _StatusPill({
    required this.label,
    required this.bg,
    required this.border,
    required this.text,
  });

  IconData get _icon {
    switch (label) {
      case 'Pending':
        return Icons.schedule;
      case 'Accepted':
        return Icons.local_shipping_outlined;
      case 'Delivered':
        return Icons.check_circle_outline;
      case 'Cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadii.pillR,
        border: Border.all(color: border, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 12, color: text),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: text,
            ),
          ),
        ],
      ),
    );
  }
}

enum _ActionVariant { primary, secondary, tertiary }

class _ActionButton extends StatelessWidget {
  final String label;
  final _ActionVariant variant;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.variant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final Color fg;
    late final Color? borderColor;

    switch (variant) {
      case _ActionVariant.primary:
        bg = AppColors.brand700;
        fg = Colors.white;
        borderColor = null;
        break;
      case _ActionVariant.secondary:
        bg = AppColors.slate100;
        fg = AppColors.slate700;
        borderColor = null;
        break;
      case _ActionVariant.tertiary:
        bg = AppColors.brand50;
        fg = AppColors.brand700;
        borderColor = AppColors.brand200;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadii.mdR,
          border: borderColor != null
              ? Border.all(color: borderColor, width: 1)
              : null,
          boxShadow: variant == _ActionVariant.primary
              ? [
                  BoxShadow(
                    color: AppColors.brand700.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: fg,
          ),
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