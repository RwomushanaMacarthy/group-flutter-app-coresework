import 'package:flutter/material.dart';
import 'color_typography.dart';
import 'app_state.dart';
import 'product_image_view.dart';

class FarmerOrdersScreen extends StatefulWidget {
  const FarmerOrdersScreen({super.key});

  @override
  State<FarmerOrdersScreen> createState() => _FarmerOrdersScreenState();
}

class _FarmerOrdersScreenState extends State<FarmerOrdersScreen> {
  String _filter = 'All';
  final _filters = ['All', 'Pending', 'Accepted', 'Delivered', 'Rejected'];

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance;
    return AnimatedBuilder(
      animation: s,
      builder: (context, _) {
        final list = _filter == 'All'
            ? s.orders.toList()
            : s.orders.where((o) => o.status == _filter).toList();
        return Column(
          children: [
            _buildHeader(s),
            _buildFilters(s),
            Expanded(
              child: list.isEmpty
                  ? _empty()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: list.length,
                      itemBuilder: (context, i) =>
                          _orderCard(context, list[i], s),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(AppState s) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Orders',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.slate900)),
          Text('${s.totalOrders} orders • ${s.pendingOrders} pending',
              style:
                  const TextStyle(fontSize: 11, color: AppColors.slate500)),
        ],
      ),
    );
  }

  Widget _buildFilters(AppState s) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, i) {
          final sel = _filter == _filters[i];
          final count = _filters[i] == 'All'
              ? s.totalOrders
              : s.orders.where((o) => o.status == _filters[i]).length;
          return GestureDetector(
            onTap: () => setState(() => _filter = _filters[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: sel ? AppColors.brand700 : Colors.white,
                borderRadius: AppRadii.pillR,
                border: Border.all(
                  color: sel ? AppColors.brand700 : AppColors.slate200,
                ),
              ),
              child: Row(
                children: [
                  Text(_filters[i],
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color:
                              sel ? Colors.white : AppColors.slate600)),
                  if (count > 0) ...[
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: sel
                            ? Colors.white.withOpacity(0.25)
                            : AppColors.amber100,
                        borderRadius: AppRadii.pillR,
                      ),
                      child: Text('$count',
                          style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: sel
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
    );
  }

  Widget _orderCard(BuildContext context, CustomerOrder o, AppState s) {
    final color = _statusColor(o.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadii.lgR,
        border: Border.all(color: AppColors.slate200),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(o.id,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate900)),
                    const SizedBox(height: 2),
                    Text('${o.customerName} • ${o.customerPhone}',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.slate600)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: AppRadii.pillR,
                ),
                child: Text(o.status,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: color)),
              ),
            ],
          ),
          const Divider(height: 14, color: AppColors.slate100),
          Row(
            children: [
              ProductImageView(
                imageUrl: o.image,
                width: 56,
                height: 56,
                borderRadius: AppRadii.smR,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(o.itemSummary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.slate800)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 11, color: AppColors.slate500),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(o.deliveryAddress,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.slate500)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text('Payment: ${o.paymentMethod}',
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.slate500)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 14, color: AppColors.slate100),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TOTAL',
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: AppColors.slate400)),
                  Text('UGX ${AppState.formatPrice(o.total)}',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.brand700)),
                ],
              ),
              const Spacer(),
              _actionBtn('Details', AppColors.slate100, AppColors.slate700,
                  () => _showDetails(context, o)),
              const SizedBox(width: 6),
              if (o.status == 'Pending') ...[
                _actionBtn('Reject', AppColors.statusRejectedBg,
                    AppColors.statusRejectedText,
                    () => s.updateOrderStatus(o.id, 'Rejected')),
                const SizedBox(width: 6),
                _actionBtn('Accept', AppColors.brand700, Colors.white,
                    () => s.updateOrderStatus(o.id, 'Accepted')),
              ] else if (o.status == 'Accepted') ...[
                _actionBtn('Mark Delivered', AppColors.brand700, Colors.white,
                    () => s.updateOrderStatus(o.id, 'Delivered')),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(String label, Color bg, Color fg, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadii.mdR,
          boxShadow: bg == AppColors.brand700
              ? [
                  BoxShadow(
                    color: AppColors.brand700.withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
      ),
    );
  }

  void _showDetails(BuildContext context, CustomerOrder o) {
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(o.status).withOpacity(0.15),
                    borderRadius: AppRadii.pillR,
                  ),
                  child: Text(o.status,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _statusColor(o.status))),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _detailRow('Customer', o.customerName),
            _detailRow('Phone', o.customerPhone),
            _detailRow('Address', o.deliveryAddress),
            _detailRow('Payment', o.paymentMethod),
            _detailRow(
                'Date',
                '${o.dateTime.day}/${o.dateTime.month}/${o.dateTime.year} '
                    '${o.dateTime.hour.toString().padLeft(2, '0')}:${o.dateTime.minute.toString().padLeft(2, '0')}'),
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
                                  fontSize: 12,
                                  color: AppColors.slate700))),
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

  Widget _empty() => Center(
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
            const Text('No orders here',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.slate700)),
            const SizedBox(height: 4),
            const Text('Orders from customers appear here',
                style: TextStyle(fontSize: 12, color: AppColors.slate500)),
          ],
        ),
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