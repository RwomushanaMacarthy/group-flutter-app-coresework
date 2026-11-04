import 'package:flutter/material.dart';
import 'color_typography.dart';
import 'app_state.dart';
import 'product_image_view.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _selectedFilter = 0;
  String _searchQuery = '';

  final _filters = ['All Orders', 'Pending', 'Accepted', 'Delivered', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance;
    return AnimatedBuilder(
      animation: s,
      builder: (context, _) {
        final filtered = _applyFilter(s.orders);
        return Scaffold(
          backgroundColor: AppColors.slate50,
          body: SafeArea(
            top: true,
            bottom: false,
            child: Column(
              children: [
                _buildHeader(),
                _buildFilterTabs(s),
                Expanded(
                  child: filtered.isEmpty
                      ? _emptyState()
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, i) =>
                              _buildOrderCard(filtered[i]),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<CustomerOrder> _applyFilter(List<CustomerOrder> all) {
    var list = all.toList();
    if (_selectedFilter != 0) {
      final status = _filters[_selectedFilter];
      list = list.where((o) => o.status == status).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((o) =>
              o.id.toLowerCase().contains(q) ||
              o.customerName.toLowerCase().contains(q) ||
              o.itemSummary.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border: const Border(
          bottom: BorderSide(color: AppColors.slate100, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.eco,
                          color: AppColors.brand600, size: 14),
                      SizedBox(width: 5),
                      Text('AGROTRADE FRESH',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: AppColors.brand700)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text('My Orders',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                          color: AppColors.slate900)),
                ],
              ),
            ),
            _IconRoundButton(
              icon: Icons.search,
              onTap: _openSearch,
              tooltip: 'Search Orders',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs(AppState s) {
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
            final selected = _selectedFilter == index;
            final label = _filters[index];
            final count = index == 0
                ? s.orders.length
                : s.orders.where((o) => o.status == label).length;
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
                      color:
                          selected ? AppColors.brand700 : AppColors.slate200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? Colors.white
                                : AppColors.slate600)),
                    if (count > 0) ...[
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
                        child: Text('$count',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: selected
                                    ? Colors.white
                                    : AppColors.amber700)),
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

  Widget _buildOrderCard(CustomerOrder order) {
    final isDelivered = order.status == 'Delivered';
    final isPending = order.status == 'Pending';
    final isAccepted = order.status == 'Accepted';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadii.lgR,
        border: Border.all(color: AppColors.slate200.withOpacity(0.9)),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.id,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate900)),
                    const SizedBox(height: 3),
                    Text(_formatDate(order.dateTime),
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.slate500)),
                  ],
                ),
              ),
              _StatusPill(
                label: order.status,
                bg: _statusColors(order.status)[0],
                border: _statusColors(order.status)[1],
                text: _statusColors(order.status)[2],
              ),
            ],
          ),
          Container(height: 1, color: AppColors.slate100, margin: const EdgeInsets.symmetric(vertical: 12)),
          Row(
            children: [
              ProductImageView(
                imageUrl: order.image,
                width: 56,
                height: 56,
                borderRadius: AppRadii.mdR,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.itemSummary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.slate800)),
                    const SizedBox(height: 3),
                    Text(
                        '${order.items.length} item${order.items.length > 1 ? "s" : ""} • ${order.deliveryAddress}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.slate500)),
                  ],
                ),
              ),
            ],
          ),
          Container(height: 1, color: AppColors.slate100, margin: const EdgeInsets.symmetric(vertical: 12)),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isDelivered ? 'TOTAL PAID' : 'TOTAL BILL',
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                            color: AppColors.slate400)),
                    const SizedBox(height: 1),
                    Text('UGX ${AppState.formatPrice(order.total)}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.brand700,
                            letterSpacing: -0.2)),
                  ],
                ),
              ),
              if (isPending)
                _ActionButton(
                  label: 'Confirm Order',
                  variant: _ActionVariant.primary,
                  onTap: () => _confirmOrder(order),
                )
              else if (isAccepted)
                _ActionButton(
                  label: 'Track Dispatch',
                  variant: _ActionVariant.primary,
                  onTap: () => _trackDispatch(order),
                )
              else if (isDelivered)
                _ActionButton(
                  label: 'Reorder',
                  variant: _ActionVariant.tertiary,
                  onTap: () => _reorder(order),
                ),
              const SizedBox(width: 8),
              _ActionButton(
                label: 'Details',
                variant: _ActionVariant.secondary,
                onTap: () => _showDetails(order),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmOrder(CustomerOrder o) async {
    await AppState.instance.updateOrderStatus(o.id, 'Accepted');
    if (!mounted) return;
    _snack('Order ${o.id} confirmed — waiting for dispatch');
  }

  Future<void> _trackDispatch(CustomerOrder o) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadii.lgR),
        title: const Text('Confirm delivery?'),
        content: Text(
            'Mark order ${o.id} as delivered?\n\nOnly do this after you have received the goods.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Not yet')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes, delivered',
                  style: TextStyle(color: AppColors.brand700))),
        ],
      ),
    );
    if (ok == true) {
      await AppState.instance.updateOrderStatus(o.id, 'Delivered');
      if (!mounted) return;
      _snack('Order ${o.id} marked as delivered');
    }
  }

  Future<void> _reorder(CustomerOrder o) async {
    final s = AppState.instance;
    final newOrder = CustomerOrder(
      id: s.newOrderId(),
      dateTime: DateTime.now(),
      customerName: s.profile.name,
      customerPhone: s.profile.phone,
      deliveryAddress: o.deliveryAddress,
      items: o.items
          .map((i) =>
              OrderItem(productName: i.productName, price: i.price, qty: i.qty))
          .toList(),
      status: 'Pending',
      paymentMethod: o.paymentMethod,
      image: o.image,
    );
    await s.addOrder(newOrder);
    if (!mounted) return;
    _snack('Reorder placed — ${newOrder.id}');
  }

  void _showDetails(CustomerOrder o) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Order ${o.id}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.slate900)),
                const Spacer(),
                _StatusPill(
                  label: o.status,
                  bg: _statusColors(o.status)[0],
                  border: _statusColors(o.status)[1],
                  text: _statusColors(o.status)[2],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _detailRow('Customer', o.customerName),
            _detailRow('Phone', o.customerPhone),
            _detailRow('Address', o.deliveryAddress),
            _detailRow('Payment', o.paymentMethod),
            _detailRow('Date', _formatDate(o.dateTime)),
            const Divider(height: 24),
            const Text('Items',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate900)),
            const SizedBox(height: 8),
            ...o.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text('${item.productName} × ${item.qty}',
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.slate700))),
                      Text('UGX ${AppState.formatPrice(item.subtotal)}',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.slate900)),
                    ],
                  ),
                )),
            const Divider(height: 20),
            Row(
              children: [
                const Text('Total',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate900)),
                const Spacer(),
                Text('UGX ${AppState.formatPrice(o.total)}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.brand700)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openSearch() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search by order #, name, or item…',
            prefixIcon: const Icon(Icons.search, size: 20),
            border: OutlineInputBorder(borderRadius: AppRadii.mdR),
          ),
          onSubmitted: (v) {
            setState(() => _searchQuery = v.trim());
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.brand700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.mdR),
      ));
  }

  Widget _detailRow(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 80,
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate500))),
            Expanded(
                child: Text(value,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.slate800))),
          ],
        ),
      );

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final hour = d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour);
    final ampm = d.hour >= 12 ? 'PM' : 'AM';
    final min = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${months[d.month - 1]}, $hour:$min $ampm';
  }

  List<Color> _statusColors(String status) {
    switch (status) {
      case 'Pending':
        return [
          AppColors.statusPendingBg,
          AppColors.amber200,
          AppColors.statusPendingText
        ];
      case 'Accepted':
        return [
          AppColors.statusAcceptedBg,
          AppColors.brand200,
          AppColors.statusAcceptedText
        ];
      case 'Delivered':
        return [
          AppColors.statusDeliveredBg,
          const Color(0xFFBFDBFE),
          AppColors.statusDeliveredText
        ];
      case 'Cancelled':
      case 'Rejected':
        return [
          AppColors.statusRejectedBg,
          const Color(0xFFFECACA),
          AppColors.statusRejectedText
        ];
      default:
        return [
          AppColors.slate100,
          AppColors.slate200,
          AppColors.slate600
        ];
    }
  }

  Widget _emptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                  color: AppColors.brand50, shape: BoxShape.circle),
              child: const Icon(Icons.receipt_long_outlined,
                  size: 44, color: AppColors.brand700),
            ),
            const SizedBox(height: 16),
            const Text('No orders in this view',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.slate700)),
            const SizedBox(height: 4),
            const Text('Try another filter, or place an order',
                style: TextStyle(fontSize: 12, color: AppColors.slate500)),
          ],
        ),
      );
}

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
            color: AppColors.slate100, shape: BoxShape.circle),
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
      case 'Rejected':
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
          Text(label,
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700, color: text)),
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
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 11.5, fontWeight: FontWeight.w600, color: fg)),
      ),
    );
  }
}