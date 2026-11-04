import 'package:flutter/material.dart';
import 'color_typography.dart';
import 'app_state.dart';
import 'farmer_add_product_screen.dart';
import 'product_image_view.dart';

class FarmerManageProductsScreen extends StatefulWidget {
  const FarmerManageProductsScreen({super.key});

  @override
  State<FarmerManageProductsScreen> createState() =>
      _FarmerManageProductsScreenState();
}

class _FarmerManageProductsScreenState
    extends State<FarmerManageProductsScreen> {
  String _filter = 'All';
  final _filters = ['All', 'Active', 'Low Stock', 'Inactive'];

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance;
    return AnimatedBuilder(
      animation: s,
      builder: (context, _) {
        var list = s.products.toList();
        if (_filter == 'Active') list = list.where((p) => p.active).toList();
        if (_filter == 'Inactive') list = list.where((p) => !p.active).toList();
        if (_filter == 'Low Stock')
          list = list.where((p) => p.stock <= 5).toList();

        return Column(
          children: [
            _buildHeader(context, s),
            _buildFilters(),
            Expanded(
              child: list.isEmpty
                  ? _emptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: list.length,
                      itemBuilder: (context, i) =>
                          _productCard(context, list[i], s),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, AppState s) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('My Products',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.slate900)),
              Text('${s.totalProducts} items • ${s.lowStockCount} low stock',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.slate500)),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const FarmerAddProductScreen())),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.brand700,
                borderRadius: AppRadii.mdR,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.brand700.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.add, size: 16, color: Colors.white),
                  SizedBox(width: 4),
                  Text('Add',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, i) {
          final sel = _filter == _filters[i];
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
              child: Text(_filters[i],
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: sel ? Colors.white : AppColors.slate600)),
            ),
          );
        },
      ),
    );
  }

  Widget _productCard(BuildContext context, Product p, AppState s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadii.mdR,
        border: Border.all(color: AppColors.slate200),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Row(
            children: [
              ProductImageView(
                imageUrl: p.image,
                localImagePath: p.localImagePath,
                width: 60,
                height: 60,
                borderRadius: AppRadii.smR,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(p.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppColors.slate900)),
                        ),
                        if (!p.active)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.slate100,
                              borderRadius: AppRadii.xsR,
                            ),
                            child: const Text('Hidden',
                                style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.slate500)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(p.category,
                        style: const TextStyle(
                            fontSize: 10.5,
                            color: AppColors.slate500,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('UGX ${AppState.formatPrice(p.price)}',
                            style: const TextStyle(
                                color: AppColors.brand700,
                                fontSize: 13,
                                fontWeight: FontWeight.w800)),
                        Text(' / ${p.unit.replaceAll("per ", "")}',
                            style: const TextStyle(
                                color: AppColors.slate500, fontSize: 10)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text('Stock: ${p.stock}',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: p.stock <= 5
                                ? AppColors.statusRejectedText
                                : AppColors.brand700)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 16, color: AppColors.slate100),
          Row(
            children: [
              _smallBtn('Edit', Icons.edit_outlined, () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => FarmerAddProductScreen(existing: p)));
              }),
              const SizedBox(width: 8),
              _smallBtn(
                  p.active ? 'Hide' : 'Show',
                  p.active
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  () => s.toggleProductActive(p.id)),
              const Spacer(),
              GestureDetector(
                onTap: () => _confirmDelete(context, p, s),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.statusRejectedBg,
                    borderRadius: AppRadii.smR,
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.delete_outline,
                          size: 14, color: AppColors.statusRejectedText),
                      SizedBox(width: 4),
                      Text('Delete',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.statusRejectedText)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallBtn(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.slate100,
          borderRadius: AppRadii.smR,
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: AppColors.slate700),
            const SizedBox(width: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate700)),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, Product p, AppState s) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadii.lgR),
        title: const Text('Delete product?'),
        content: Text('Remove "${p.name}" from your inventory?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete',
                  style: TextStyle(color: AppColors.statusRejectedText))),
        ],
      ),
    );
    if (ok == true) await s.deleteProduct(p.id);
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
              child: const Icon(Icons.inventory_2_outlined,
                  size: 44, color: AppColors.brand700),
            ),
            const SizedBox(height: 16),
            const Text('No products found',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.slate700)),
            const SizedBox(height: 4),
            const Text('Tap "+ Add" to create your first listing',
                style: TextStyle(fontSize: 12, color: AppColors.slate500)),
          ],
        ),
      );
}