import 'package:flutter/material.dart';
import 'color_typography.dart';
import 'app_state.dart';
import 'product_image_view.dart';

class CustomerHomeScreen extends StatefulWidget {
  final int initialIndex;
  const CustomerHomeScreen({super.key, this.initialIndex = 0});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  late int _selectedNavIndex;

  // Cart: product name -> {price, count, image, localImagePath}
  final Map<String, Map<String, dynamic>> _cartItems = {};

  @override
  void initState() {
    super.initState();
    _selectedNavIndex = widget.initialIndex.clamp(0, 4);
  }

  void _addToCart(
    String name,
    int price,
    String image, {
    String localImagePath = '',
  }) {
    setState(() {
      if (_cartItems.containsKey(name)) {
        _cartItems[name]!['count'] += 1;
      } else {
        _cartItems[name] = {
          'price': price,
          'count': 1,
          'image': image,
          'localImagePath': localImagePath,
        };
      }
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name added to cart!'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.brand700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.mdR),
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: () => setState(() => _selectedNavIndex = 2),
        ),
      ),
    );
  }

  void _updateCartCount(String name, int change) {
    setState(() {
      if (_cartItems.containsKey(name)) {
        _cartItems[name]!['count'] += change;
        if (_cartItems[name]!['count'] <= 0) {
          _cartItems.remove(name);
        }
      }
    });
  }

  void _clearCart() => setState(_cartItems.clear);

  int get _cartTotalItemCount {
    int total = 0;
    _cartItems.forEach((k, item) => total += (item['count'] as int));
    return total;
  }

  void _checkout() {
    if (_cartItems.isEmpty) return;
    final s = AppState.instance;
    final items = <OrderItem>[];
    _cartItems.forEach((name, data) {
      items.add(OrderItem(
        productName: name,
        price: data['price'] as int,
        qty: data['count'] as int,
      ));
    });

    // Prefer a URL for the order image; fall back to first product's URL
    final firstItem = _cartItems.values.first;
    final orderImage = (firstItem['image'] as String?) ?? '';

    s.addOrder(CustomerOrder(
      id: s.newOrderId(),
      dateTime: DateTime.now(),
      customerName: s.profile.name,
      customerPhone: s.profile.phone,
      deliveryAddress: 'Kampala Central',
      items: items,
      status: 'Pending',
      paymentMethod: 'MTN Mobile Money',
      image: orderImage,
    ));

    _clearCart();
    setState(() => _selectedNavIndex = 3);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Order placed successfully!'),
        backgroundColor: AppColors.brand700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.mdR),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      CustomerHomeContent(onAddToCart: _addToCart),
      const _CategoriesTab(),
      _CartTab(
        cartItems: _cartItems,
        onUpdateCount: _updateCartCount,
        onCheckout: _checkout,
        onShopNow: () => setState(() => _selectedNavIndex = 0),
      ),
      const _OrdersTab(),
      const _ProfileTab(),
    ];

    return Scaffold(
      backgroundColor: AppColors.surfaceScaffold,
      body: SafeArea(child: pages[_selectedNavIndex]),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      _NavItem(Icons.home_rounded, Icons.home_outlined, 'Home'),
      _NavItem(Icons.grid_view_rounded, Icons.grid_view_outlined, 'Categories'),
      _NavItem(Icons.shopping_cart_rounded, Icons.shopping_cart_outlined, 'Cart'),
      _NavItem(Icons.receipt_long_rounded, Icons.receipt_long_outlined, 'Orders'),
      _NavItem(Icons.person_rounded, Icons.person_outline, 'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.97),
        border:
            const Border(top: BorderSide(color: AppColors.slate200, width: 1)),
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
                children: List.generate(items.length, (i) {
                  final selected = i == _selectedNavIndex;
                  final item = items[i];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedNavIndex = i),
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
                                if (i == 2 && _cartTotalItemCount > 0)
                                  Positioned(
                                    right: -6,
                                    top: -4,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 1),
                                      constraints: const BoxConstraints(
                                          minWidth: 15, minHeight: 15),
                                      decoration: BoxDecoration(
                                        color: AppColors.brand700,
                                        borderRadius: AppRadii.pillR,
                                        border: Border.all(
                                            color: Colors.white, width: 1.5),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '$_cartTotalItemCount',
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
class CustomerHomeContent extends StatefulWidget {
  final Function(String name, int price, String image,
      {String localImagePath}) onAddToCart;

  const CustomerHomeContent({super.key, required this.onAddToCart});

  @override
  State<CustomerHomeContent> createState() => _CustomerHomeContentState();
}

class _CustomerHomeContentState extends State<CustomerHomeContent> {
  String _selectedCategory = 'Vegetables';
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _productsKey = GlobalKey();

  final List<Map<String, dynamic>> _categories = [
    {
      'label': 'Vegetables',
      'image':
          'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=200&q=80'
    },
    {
      'label': 'Fruits',
      'image':
          'https://images.unsplash.com/photo-1610832958506-aa56368176cf?auto=format&fit=crop&w=200&q=80'
    },
    {
      'label': 'Grains',
      'image':
          'https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&w=200&q=80'
    },
    {
      'label': 'Legumes',
      'image':
          'https://images.unsplash.com/photo-1596797038530-2c107229654b?auto=format&fit=crop&w=200&q=80'
    },
    {'label': 'Others', 'image': null},
  ];

  void _scrollToProducts() {
    final ctx = _productsKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild when AppState changes (new products, etc)
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        final allProducts = AppState.instance.products
            .where((p) => p.active)
            .map((p) => {
                  'name': p.name,
                  'price': p.price,
                  'category': p.category,
                  'unit': p.unit,
                  'farm': p.farm,
                  'rating': p.rating.toStringAsFixed(1),
                  'tag': p.tag,
                  'image': p.image,
                  'localImagePath': p.localImagePath,
                })
            .toList();

        final filteredProducts = allProducts
            .where((p) =>
                _selectedCategory == 'Others' ||
                p['category'] == _selectedCategory)
            .toList();

        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildSearchBar()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildHeroBanner(),
                  const SizedBox(height: 14),
                  _buildTrustBanner(),
                  const SizedBox(height: 20),
                  _buildSectionHeader('Categories'),
                  const SizedBox(height: 10),
                  _buildCategoryRow(),
                  const SizedBox(height: 20),
                  Container(
                    key: _productsKey,
                    child: _buildSectionHeader(
                      'Featured Products ($_selectedCategory)',
                      subtitle: 'Harvested within the last 24 hours',
                    ),
                  ),
                  const SizedBox(height: 12),
                ]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.62,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      _buildProductCard(filteredProducts[index]),
                  childCount: filteredProducts.length,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              sliver: SliverToBoxAdapter(child: _buildFarmerCallout()),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.brand700,
              borderRadius: AppRadii.mdR,
            ),
            padding: const EdgeInsets.all(6),
            child: const Icon(Icons.eco, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Text('AGRO TRADE',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: AppColors.slate600)),
                    SizedBox(width: 3),
                    Icon(Icons.keyboard_arrow_down,
                        size: 12, color: AppColors.slate500),
                  ],
                ),
                Text('Kampala, Uganda',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate900)),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                    color: AppColors.slate100, shape: BoxShape.circle),
                child: const Icon(Icons.notifications_none_rounded,
                    size: 18, color: AppColors.slate600),
              ),
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
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.slate100,
                borderRadius: AppRadii.mdR,
              ),
              child: const TextField(
                style: TextStyle(fontSize: 12, color: AppColors.slate800),
                decoration: InputDecoration(
                  hintText: 'Search vegetables, fruits, grains...',
                  hintStyle: TextStyle(
                      fontSize: 12,
                      color: AppColors.slate500,
                      fontWeight: FontWeight.w500),
                  prefixIcon:
                      Icon(Icons.search, size: 18, color: AppColors.slate600),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.slate100,
              borderRadius: AppRadii.mdR,
              border: Border.all(color: AppColors.slate200),
            ),
            child:
                const Icon(Icons.tune, size: 18, color: AppColors.slate700),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: AppRadii.xlR,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.brand800, AppColors.brand700, Color(0xFF064E3B)],
        ),
        boxShadow: AppShadows.heroGlow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 62,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.mint400.withOpacity(0.22),
                    borderRadius: AppRadii.pillR,
                  ),
                  child: const Text('Farm-Gate Direct',
                      style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.emerald200)),
                ),
                const SizedBox(height: 8),
                const Text('Fresh Produce Direct from Farmers',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2)),
                const SizedBox(height: 6),
                Text(
                  'Support local Ugandan farmers & get the best harvest at wholesale prices.',
                  style: TextStyle(
                      fontSize: 11,
                      height: 1.35,
                      color: Colors.white.withOpacity(0.85)),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _scrollToProducts,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadii.pillR,
                    ),
                    child: const Text('Shop Now',
                        style: TextStyle(
                            color: AppColors.brand800,
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 38,
            child: AspectRatio(
              aspectRatio: 1,
              child: ProductImageView(
                imageUrl:
                    'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=400&q=80',
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: AppRadii.mdR,
        border: Border.all(color: const Color(0xFFD1FAE5)),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
                color: AppColors.brand600, shape: BoxShape.circle),
            child: const Icon(Icons.check, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text('500+ Verified Farmers Across Uganda',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate700)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadii.pillR,
              border: Border.all(color: AppColors.emerald200),
            ),
            child: const Text('100% Traceable',
                style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brand700)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate900,
                      letterSpacing: -0.2)),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.slate600,
                        fontWeight: FontWeight.w500)),
              ],
            ],
          ),
        ),
        const Text('See All',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.brand700)),
      ],
    );
  }

  Widget _buildCategoryRow() {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final cat = _categories[i];
          final selected = _selectedCategory == cat['label'];
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat['label']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 76,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: selected ? AppColors.brand800 : Colors.white,
                borderRadius: AppRadii.lgR,
                border: Border.all(
                    color:
                        selected ? AppColors.brand800 : AppColors.slate200),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          cat['image'] == null ? AppColors.slate100 : null,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: cat['image'] != null
                        ? ProductImageView(imageUrl: cat['image'] as String)
                        : const Icon(Icons.more_horiz,
                            size: 20, color: AppColors.slate500),
                  ),
                  const SizedBox(height: 6),
                  Text(cat['label'],
                      style: TextStyle(
                          fontSize: 10.5,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w600,
                          color:
                              selected ? Colors.white : AppColors.slate800)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadii.lgR,
        border: Border.all(color: AppColors.slate200),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ProductImageView(
                    imageUrl: product['image'] as String?,
                    localImagePath: product['localImagePath'] as String?,
                    borderRadius: AppRadii.mdR,
                  ),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: AppRadii.xsR,
                    ),
                    child: Text(product['farm'] as String,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: AppRadii.xsR,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('★',
                            style: TextStyle(
                                fontSize: 9, color: AppColors.amber500)),
                        const SizedBox(width: 2),
                        Text(product['rating'] as String,
                            style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.slate800)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(product['name'] as String,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate900)),
          const SizedBox(height: 2),
          Text(product['tag'] as String,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 10.5,
                  color: AppColors.slate600,
                  fontWeight: FontWeight.w500)),
          const Spacer(),
          const Divider(height: 12, color: AppColors.slate100),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('UGX ${AppState.formatPrice(product['price'] as int)}',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: AppColors.brand700)),
                    Text(product['unit'] as String,
                        style: const TextStyle(
                            fontSize: 9.5,
                            color: AppColors.slate600,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => widget.onAddToCart(
                  product['name'] as String,
                  product['price'] as int,
                  product['image'] as String,
                  localImagePath: (product['localImagePath'] as String?) ?? '',
                ),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: AppColors.brand700,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFarmerCallout() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [AppColors.amber50, AppColors.brand50]),
        borderRadius: AppRadii.lgR,
        border: Border.all(color: AppColors.amber200),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Are you a commercial or smallholder farmer?',
                    style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate800)),
                SizedBox(height: 2),
                Text('List your harvest directly to 40,000+ urban buyers',
                    style:
                        TextStyle(fontSize: 10, color: AppColors.slate600)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.amber600,
              borderRadius: AppRadii.smR,
            ),
            child: const Text('Join Agro Trade',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  CATEGORIES TAB
// ═══════════════════════════════════════════════════════════════════
class _CategoriesTab extends StatelessWidget {
  const _CategoriesTab();

  @override
  Widget build(BuildContext context) {
    final cats = <String, List<Product>>{};
    for (final p in AppState.instance.products.where((p) => p.active)) {
      cats.putIfAbsent(p.category, () => []).add(p);
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Categories',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.slate900)),
        const SizedBox(height: 4),
        const Text('Browse produce by category',
            style: TextStyle(fontSize: 12, color: AppColors.slate500)),
        const SizedBox(height: 16),
        ...cats.entries.map((e) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppRadii.mdR,
                border: Border.all(color: AppColors.slate200),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.brand50,
                      borderRadius: AppRadii.mdR,
                    ),
                    child: const Icon(Icons.eco,
                        color: AppColors.brand700, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.key,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.slate900)),
                        Text('${e.value.length} products',
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.slate500)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right,
                      color: AppColors.slate400, size: 20),
                ],
              ),
            )),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  CART TAB
// ═══════════════════════════════════════════════════════════════════
class _CartTab extends StatelessWidget {
  final Map<String, Map<String, dynamic>> cartItems;
  final Function(String name, int change) onUpdateCount;
  final VoidCallback onCheckout;
  final VoidCallback onShopNow;

  const _CartTab({
    required this.cartItems,
    required this.onUpdateCount,
    required this.onCheckout,
    required this.onShopNow,
  });

  int get _cartTotal {
    int sum = 0;
    cartItems.forEach((_, item) {
      sum += (item['price'] as int) * (item['count'] as int);
    });
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                  color: AppColors.brand50, shape: BoxShape.circle),
              child: const Icon(Icons.shopping_cart_outlined,
                  size: 44, color: AppColors.brand700),
            ),
            const SizedBox(height: 16),
            const Text('Your cart is empty',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.slate700)),
            const SizedBox(height: 4),
            const Text('Add items from the Home tab',
                style: TextStyle(fontSize: 12, color: AppColors.slate500)),
            const SizedBox(height: 16),
            TextButton(onPressed: onShopNow, child: const Text('Shop Now')),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              const Text('Your Cart',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.slate900)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: AppColors.brand50,
                    borderRadius: AppRadii.pillR),
                child: Text(
                    '${cartItems.length} item${cartItems.length == 1 ? "" : "s"}',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brand700)),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final entry = cartItems.entries.elementAt(index);
              final name = entry.key;
              final data = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.slate200),
                ),
                child: Row(
                  children: [
                    ProductImageView(
                      imageUrl: data['image'] as String?,
                      localImagePath: data['localImagePath'] as String?,
                      width: 56,
                      height: 56,
                      borderRadius: AppRadii.smR,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: AppColors.slate900)),
                          const SizedBox(height: 2),
                          Text(
                              'UGX ${AppState.formatPrice(data['price'] as int)}',
                              style: const TextStyle(
                                  color: AppColors.brand700,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        _qtyBtn(Icons.remove, AppColors.slate600,
                            () => onUpdateCount(name, -1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text('${data['count']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: AppColors.slate900)),
                        ),
                        _qtyBtn(Icons.add, AppColors.brand700,
                            () => onUpdateCount(name, 1)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.slate200),
            boxShadow: AppShadows.elevated,
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Amount',
                      style: TextStyle(
                          color: AppColors.slate500, fontSize: 11)),
                  Text('UGX ${AppState.formatPrice(_cartTotal)}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.brand700)),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: onCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brand700,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  shape:
                      RoundedRectangleBorder(borderRadius: AppRadii.smR),
                  elevation: 0,
                ),
                child: const Text('Checkout',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _qtyBtn(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.slate100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  ORDERS TAB
// ═══════════════════════════════════════════════════════════════════
class _OrdersTab extends StatefulWidget {
  const _OrdersTab();

  @override
  State<_OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<_OrdersTab> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Pending', 'Accepted', 'Delivered'];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        final all = AppState.instance.orders;
        final orders = _selectedFilter == 0
            ? all.toList()
            : all.where((o) => o.status == _filters[_selectedFilter]).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('My Orders',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.slate900)),
            ),
            SizedBox(
              height: 44,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (context, index) {
                  final selected = _selectedFilter == index;
                  final label = _filters[index];
                  final count = index == 0
                      ? all.length
                      : all.where((o) => o.status == label).length;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected ? AppColors.brand700 : Colors.white,
                        borderRadius: AppRadii.pillR,
                        border: Border.all(
                            color: selected
                                ? AppColors.brand700
                                : AppColors.slate200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(label,
                              style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : AppColors.slate700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                          if (count > 0) ...[
                            const SizedBox(width: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: selected
                                    ? Colors.white.withOpacity(0.25)
                                    : AppColors.amber100,
                                borderRadius: AppRadii.pillR,
                              ),
                              child: Text('$count',
                                  style: TextStyle(
                                      fontSize: 9.5,
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
            const SizedBox(height: 12),
            Expanded(
              child: orders.isEmpty
                  ? _empty()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: orders.length,
                      itemBuilder: (context, i) => _orderCard(orders[i]),
                    ),
            ),
          ],
        );
      },
    );
  }

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
            const Text('No orders in this view',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.slate700)),
            const SizedBox(height: 4),
            const Text('Place an order from the Home tab',
                style: TextStyle(fontSize: 12, color: AppColors.slate500)),
          ],
        ),
      );

  Widget _orderCard(CustomerOrder o) {
    final isDelivered = o.status == 'Delivered';
    final isPending = o.status == 'Pending';
    final isAccepted = o.status == 'Accepted';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Order ${o.id}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppColors.slate900)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusBg(o.status),
                  borderRadius: AppRadii.pillR,
                ),
                child: Text(o.status,
                    style: TextStyle(
                        color: _statusText(o.status),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(_formatDate(o.dateTime),
                style: const TextStyle(
                    color: AppColors.slate500, fontSize: 11)),
          ),
          const Divider(height: 16, color: AppColors.slate200),
          Row(
            children: [
              ProductImageView(
                imageUrl: o.image,
                width: 48,
                height: 48,
                borderRadius: AppRadii.smR,
              ),
              const SizedBox(width: 12),
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
                    Text('Total: UGX ${AppState.formatPrice(o.total)}',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.brand700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (isPending)
                _btn('Confirm Order', AppColors.brand700, Colors.white,
                    () => _confirm(o))
              else if (isAccepted)
                _btn('Track Dispatch', AppColors.brand700, Colors.white,
                    () => _deliver(o))
              else if (isDelivered)
                _btn('Reorder', AppColors.brand50, AppColors.brand700,
                    () => _reorder(o)),
              const Spacer(),
              _btn('Details', AppColors.slate100, AppColors.slate700,
                  () => _details(o)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _btn(String label, Color bg, Color fg, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(color: bg, borderRadius: AppRadii.smR),
        child: Text(label,
            style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: fg)),
      ),
    );
  }

  Future<void> _confirm(CustomerOrder o) async {
    await AppState.instance.updateOrderStatus(o.id, 'Accepted');
    if (!mounted) return;
    _snack('Order ${o.id} confirmed');
  }

  Future<void> _deliver(CustomerOrder o) async {
    await AppState.instance.updateOrderStatus(o.id, 'Delivered');
    if (!mounted) return;
    _snack('Order ${o.id} marked delivered');
  }

  Future<void> _reorder(CustomerOrder o) async {
    final s = AppState.instance;
    await s.addOrder(CustomerOrder(
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
    ));
    if (!mounted) return;
    _snack('Reorder placed');
  }

  void _details(CustomerOrder o) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ${o.id}',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.slate900)),
            const SizedBox(height: 4),
            Text(_formatDate(o.dateTime),
                style: const TextStyle(
                    fontSize: 11, color: AppColors.slate500)),
            const Divider(height: 20),
            ...o.items.map((i) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text('${i.productName} × ${i.qty}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.slate700))),
                      Text('UGX ${AppState.formatPrice(i.subtotal)}',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.slate900)),
                    ],
                  ),
                )),
            const Divider(),
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

  Color _statusBg(String s) {
    switch (s) {
      case 'Pending':
        return AppColors.statusPendingBg;
      case 'Accepted':
        return AppColors.statusAcceptedBg;
      case 'Delivered':
        return AppColors.statusDeliveredBg;
      default:
        return AppColors.statusRejectedBg;
    }
  }

  Color _statusText(String s) {
    switch (s) {
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

  String _formatDate(DateTime d) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final h = d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour);
    final ap = d.hour >= 12 ? 'PM' : 'AM';
    return '${d.day} ${m[d.month - 1]}, $h:${d.minute.toString().padLeft(2, '0')} $ap';
  }
}

// ═══════════════════════════════════════════════════════════════════
//  PROFILE TAB
// ═══════════════════════════════════════════════════════════════════
class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        final p = AppState.instance.profile;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppColors.brand700, AppColors.brand800]),
                borderRadius: AppRadii.lgR,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(p.avatarUrl),
                    backgroundColor: AppColors.brand200,
                  ),
                  const SizedBox(height: 10),
                  Text(p.name,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(p.farmName,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.85))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _infoCard('Phone', p.phone),
            _infoCard('Email', p.email),
            _infoCard('Location', p.location),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (r) => false),
              child: const Text('Log Out',
                  style: TextStyle(color: AppColors.statusRejectedText)),
            ),
          ],
        );
      },
    );
  }

  Widget _infoCard(String label, String value) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadii.mdR,
          border: Border.all(color: AppColors.slate200),
        ),
        child: Row(
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
                        fontSize: 13, color: AppColors.slate800))),
          ],
        ),
      );
}