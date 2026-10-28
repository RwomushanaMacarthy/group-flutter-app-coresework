import 'package:flutter/material.dart';
import 'color_typography.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _selectedNavIndex = 0;

  // Dynamic Cart State: Map of Product Name -> {price, count, image}
  final Map<String, Map<String, dynamic>> _cartItems = {};

  void _addToCart(String name, int price, String image) {
    setState(() {
      if (_cartItems.containsKey(name)) {
        _cartItems[name]!['count'] += 1;
      } else {
        _cartItems[name] = {'price': price, 'count': 1, 'image': image};
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

  int get _cartTotalItemCount {
    int total = 0;
    _cartItems.forEach((key, item) => total += (item['count'] as int));
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      CustomerHomeContent(onAddToCart: _addToCart),
      const Center(
        child: Text("Categories Screen",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      CartScreenBody(cartItems: _cartItems, onUpdateCount: _updateCartCount),
      const CustomerOrdersContent(),
      const Center(
        child: Text("Profile Page",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.surfaceScaffold,
      body: SafeArea(child: pages[_selectedNavIndex]),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── Custom iOS-style bottom navigation ──────────────────────────
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
        border: const Border(top: BorderSide(color: AppColors.slate200, width: 1)),
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
                                          color: Colors.white,
                                          width: 1.5,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '$_cartTotalItemCount',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                        ),
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

class _NavItem {
  final IconData activeIcon;
  final IconData icon;
  final String label;
  const _NavItem(this.activeIcon, this.icon, this.label);
}

// ═══════════════════════════════════════════════════════════════════
// 1. HOME TAB CONTENT
// ═══════════════════════════════════════════════════════════════════
class CustomerHomeContent extends StatefulWidget {
  final Function(String name, int price, String image) onAddToCart;

  const CustomerHomeContent({super.key, required this.onAddToCart});

  @override
  State<CustomerHomeContent> createState() => _CustomerHomeContentState();
}

class _CustomerHomeContentState extends State<CustomerHomeContent> {
  String _selectedCategory = 'Vegetables';
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _productsKey = GlobalKey();

  final List<Map<String, dynamic>> _allProducts = [
    {
      'name': 'Fresh Vine Tomatoes',
      'price': 4000,
      'category': 'Vegetables',
      'unit': 'per kg',
      'farm': 'Mukono Farms',
      'rating': '4.9',
      'tag': 'Grade A • Fresh',
      'image':
          'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=400&q=80',
    },
    {
      'name': 'Crisp Red Onions',
      'price': 3500,
      'category': 'Vegetables',
      'unit': 'per kg',
      'farm': 'Wakiso Organics',
      'rating': '4.8',
      'tag': 'Dry Cured • Pungent',
      'image':
          'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?auto=format&fit=crop&w=400&q=80',
    },
    {
      'name': 'Kabale Irish Potatoes',
      'price': 2800,
      'category': 'Vegetables',
      'unit': 'per kg',
      'farm': 'Kabale Fresh',
      'rating': '4.7',
      'tag': 'Washed • Starchy',
      'image':
          'https://images.unsplash.com/photo-1518977676601-b53f82aba655?auto=format&fit=crop&w=400&q=80',
    },
    {
      'name': 'Green Bell Peppers',
      'price': 3200,
      'category': 'Vegetables',
      'unit': 'per 500g',
      'farm': 'Mpigi Greenhouse',
      'rating': '4.9',
      'tag': 'Sweet • Crunchy',
      'image':
          'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?auto=format&fit=crop&w=400&q=80',
    },
    {
      'name': 'Red Apples',
      'price': 6000,
      'category': 'Fruits',
      'unit': 'per kg',
      'farm': 'Mbale Orchards',
      'rating': '4.8',
      'tag': 'Sweet • Crisp',
      'image':
          'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?auto=format&fit=crop&w=400&q=80',
    },
    {
      'name': 'Sweet Bananas',
      'price': 3000,
      'category': 'Fruits',
      'unit': 'per bunch',
      'farm': 'Masaka Farms',
      'rating': '4.6',
      'tag': 'Ripe • Sweet',
      'image':
          'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?auto=format&fit=crop&w=400&q=80',
    },
    {
      'name': 'Yellow Maize',
      'price': 2500,
      'category': 'Grains',
      'unit': 'per kg',
      'farm': 'Gulu Grain Co.',
      'rating': '4.5',
      'tag': 'Dried • Clean',
      'image':
          'https://images.unsplash.com/photo-1551754655-cd27e38d2076?auto=format&fit=crop&w=400&q=80',
    },
    {
      'name': 'Kidney Beans',
      'price': 5000,
      'category': 'Legumes',
      'unit': 'per kg',
      'farm': 'Lira Growers',
      'rating': '4.7',
      'tag': 'Protein-Rich',
      'image':
          'https://images.unsplash.com/photo-1551462147-ff29053bfc14?auto=format&fit=crop&w=400&q=80',
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {
      'label': 'Vegetables',
      'image':
          'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=200&q=80',
    },
    {
      'label': 'Fruits',
      'image':
          'https://images.unsplash.com/photo-1610832958506-aa56368176cf?auto=format&fit=crop&w=200&q=80',
    },
    {
      'label': 'Grains',
      'image':
          'https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&w=200&q=80',
    },
    {
      'label': 'Legumes',
      'image':
          'https://images.unsplash.com/photo-1596797038530-2c107229654b?auto=format&fit=crop&w=200&q=80',
    },
    {'label': 'Others', 'image': null},
  ];

  void _scrollToProducts() {
    final ctx = _productsKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _allProducts
        .where((p) =>
            _selectedCategory == 'Others' || p['category'] == _selectedCategory)
        .toList();

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // ─── Sticky Header (brand, location, notification, search) ──
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
              // Products header with anchor
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

        // ─── Products Grid ─────────────────────────────────────────
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
              (context, index) {
                final product = filteredProducts[index];
                return _buildProductCard(product);
              },
              childCount: filteredProducts.length,
            ),
          ),
        ),

        // ─── Farmer callout + spacing ──────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          sliver: SliverToBoxAdapter(child: _buildFarmerCallout()),
        ),
      ],
    );
  }

// ─── Header (brand, location, notification) ────────────────────
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
            boxShadow: [
              BoxShadow(
                color: AppColors.brand700.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(6),
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Text(
                    'AGRO TRADE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AppColors.slate600,
                    ),
                  ),
                  SizedBox(width: 3),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 12,
                    color: AppColors.slate500,
                  ),
                ],
              ),
              const Text(
                'Kampala, Uganda',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate900,
                ),
              ),
            ],
          ),
        ),
        _IconCircleButton(
          icon: Icons.notifications_none_rounded,
          onTap: () {},
          showDot: true,
        ),
      ],
    ),
  );
}
  // ─── Search bar ────────────────────────────────────────────────
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
                border: Border.all(color: Colors.transparent),
              ),
              child: TextField(
                style: const TextStyle(
                    fontSize: 12, color: AppColors.slate800),
                decoration: const InputDecoration(
                  hintText: 'Search vegetables, fruits, grains...',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: AppColors.slate500,
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 18,
                    color: AppColors.slate600,
                  ),
                  suffixIcon: Icon(
                    Icons.mic_none,
                    size: 16,
                    color: AppColors.slate500,
                  ),
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
            child: const Icon(Icons.tune,
                size: 18, color: AppColors.slate700),
          ),
        ],
      ),
    );
  }

  // ─── Hero Banner ───────────────────────────────────────────────
  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: AppRadii.xlR,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.brand800,
            AppColors.brand700,
            Color(0xFF064E3B),
          ],
        ),
        border: Border.all(color: AppColors.brand700.withOpacity(0.4)),
        boxShadow: AppShadows.heroGlow,
      ),
      child: Stack(
        children: [
          // Decorative glow
          Positioned(
            right: -30,
            bottom: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 62,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.mint400.withOpacity(0.22),
                        borderRadius: AppRadii.pillR,
                        border: Border.all(
                          color: AppColors.mint400.withOpacity(0.35),
                        ),
                      ),
                      child: const Text(
                        'Farm-Gate Direct',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.emerald200,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Fresh Produce Direct from Farmers',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Support local Ugandan farmers & get the best harvest at wholesale prices.',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.35,
                        color: Colors.white.withOpacity(0.85),
                      ),
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Shop Now',
                          style: TextStyle(
                            color: AppColors.brand800,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Hero image with badge
              Expanded(
                flex: 38,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=400&q=80',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: AppColors.brand700,
                                ),
                              ),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.4),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: -6,
                        left: -6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.amber500,
                            borderRadius: AppRadii.pillR,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Text(
                            '25% OFF',
                            style: TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w900,
                              color: AppColors.slate900,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
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

  // ─── Trust banner ──────────────────────────────────────────────
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
              color: AppColors.brand600,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              '500+ Verified Farmers Across Uganda',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.slate700,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadii.pillR,
              border: Border.all(color: AppColors.emerald200),
            ),
            child: const Text(
              '100% Traceable',
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: AppColors.brand700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Section Header ────────────────────────────────────────────
  Widget _buildSectionHeader(String title, {String? subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate900,
                  letterSpacing: -0.2,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.slate600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: const Text(
            'See All',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.brand700,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Category Row ──────────────────────────────────────────────
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
                  color: selected ? AppColors.brand800 : AppColors.slate200,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: AppColors.brand800.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cat['image'] == null
                          ? AppColors.slate100
                          : null,
                      border: Border.all(
                        color: selected
                            ? Colors.white.withOpacity(0.8)
                            : AppColors.slate200,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: cat['image'] != null
                        ? Image.network(
                            cat['image'],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.slate100,
                              child: const Icon(Icons.image_outlined,
                                  size: 18, color: AppColors.slate500),
                            ),
                          )
                        : const Icon(Icons.more_horiz,
                            size: 20, color: AppColors.slate500),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cat['label'],
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w600,
                      color: selected
                          ? Colors.white
                          : AppColors.slate800,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── Product Card ──────────────────────────────────────────────
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
          // Image with farm + rating badges
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: AppRadii.mdR,
                    child: Image.network(
                      product['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.slate100,
                        child: const Icon(Icons.image_outlined,
                            color: AppColors.slate500),
                      ),
                    ),
                  ),
                ),
                // Farm badge
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: AppRadii.xsR,
                    ),
                    child: Text(
                      product['farm'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Rating badge
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: AppRadii.xsR,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '★',
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.amber500,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          product['rating'],
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Info
          Text(
            product['name'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.slate900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            product['tag'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10.5,
              color: AppColors.slate600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          const Divider(height: 12, color: AppColors.slate100),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'UGX ${_formatPrice(product['price'])}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: AppColors.brand700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      product['unit'],
                      style: const TextStyle(
                        fontSize: 9.5,
                        color: AppColors.slate600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => widget.onAddToCart(
                  product['name'],
                  product['price'],
                  product['image'],
                ),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.brand700,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brand700.withOpacity(0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child:
                      const Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Farmer Callout ────────────────────────────────────────────
  Widget _buildFarmerCallout() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.amber50, AppColors.brand50],
        ),
        borderRadius: AppRadii.lgR,
        border: Border.all(color: AppColors.amber200),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Are you a commercial or smallholder farmer?',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'List your harvest directly to 40,000+ urban buyers',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.slate600,
                  ),
                ),
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
            child: const Text(
              'Join Agro Trade',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }
}

// ─── Reusable icon circle button ─────────────────────────────────
class _IconCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool showDot;

  const _IconCircleButton({
    required this.icon,
    required this.onTap,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: AppColors.slate100,
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 18, color: AppColors.slate600),
            if (showDot)
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
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// 2. CART SCREEN BODY
// ═══════════════════════════════════════════════════════════════════
class CartScreenBody extends StatelessWidget {
  final Map<String, Map<String, dynamic>> cartItems;
  final Function(String name, int change) onUpdateCount;

  const CartScreenBody(
      {super.key, required this.cartItems, required this.onUpdateCount});

  int get _cartTotal {
    int sum = 0;
    cartItems.forEach((_, item) {
      sum += (item['price'] as int) * (item['count'] as int);
    });
    return sum;
  }

  String _formatPrice(int price) => price.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );

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
                color: AppColors.brand50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shopping_cart_outlined,
                  size: 44, color: AppColors.brand700),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.slate700,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Add items from the Home tab',
              style: TextStyle(fontSize: 12, color: AppColors.slate500),
            ),
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
              const Text(
                'Your Shopping Cart',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.slate900,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.brand50,
                  borderRadius: AppRadii.pillR,
                ),
                child: Text(
                  '${cartItems.length} item${cartItems.length == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brand700,
                  ),
                ),
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
                    ClipRRect(
                      borderRadius: AppRadii.smR,
                      child: Image.network(
                        data['image'],
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 56,
                          height: 56,
                          color: AppColors.slate100,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: AppColors.slate900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'UGX ${_formatPrice(data['price'])}/kg',
                            style: const TextStyle(
                              color: AppColors.brand700,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _QuantityControl(
                      count: data['count'] as int,
                      onDec: () => onUpdateCount(name, -1),
                      onInc: () => onUpdateCount(name, 1),
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
                  const Text(
                    'Total Amount',
                    style:
                        TextStyle(color: AppColors.slate500, fontSize: 11),
                  ),
                  Text(
                    'UGX ${_formatPrice(_cartTotal)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.brand700,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Order placed successfully!'),
                      backgroundColor: AppColors.brand700,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadii.mdR,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brand700,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.smR,
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Checkout',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuantityControl extends StatelessWidget {
  final int count;
  final VoidCallback onDec;
  final VoidCallback onInc;

  const _QuantityControl({
    required this.count,
    required this.onDec,
    required this.onInc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.slate100,
        borderRadius: AppRadii.pillR,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(Icons.remove, onDec, AppColors.slate600),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$count',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppColors.slate900,
              ),
            ),
          ),
          _btn(Icons.add, onInc, AppColors.brand700),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// 3. ORDERS TAB CONTENT
// ═══════════════════════════════════════════════════════════════════
class CustomerOrdersContent extends StatefulWidget {
  const CustomerOrdersContent({super.key});

  @override
  State<CustomerOrdersContent> createState() => _CustomerOrdersContentState();
}

class _CustomerOrdersContentState extends State<CustomerOrdersContent> {
  int _selectedFilter = 0;
  final List<String> _filters = ["All", "Pending", "Accepted", "Delivered"];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Orders',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.slate900,
            ),
          ),
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
              return GestureDetector(
                onTap: () => setState(() => _selectedFilter = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        selected ? AppColors.brand700 : Colors.white,
                    borderRadius: AppRadii.pillR,
                    border: Border.all(
                      color: selected
                          ? AppColors.brand700
                          : AppColors.slate200,
                    ),
                  ),
                  child: Text(
                    _filters[index],
                    style: TextStyle(
                      color: selected ? Colors.white : AppColors.slate700,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _orderCard(
                orderId: '#AGT001',
                dateTime: '10 Oct 2026, 10:24 AM',
                items: 'Tomatoes (5 kg), Onions (2 kg)',
                total: 'UGX 32,000',
                status: 'Pending',
                statusBgColor: AppColors.statusPendingBg,
                statusTextColor: AppColors.statusPendingText,
                imgUrl:
                    'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=200&q=80',
              ),
              _orderCard(
                orderId: '#AGT002',
                dateTime: '11 Oct 2026, 04:15 PM',
                items: 'Maize (10 kg), Beans (5 kg)',
                total: 'UGX 45,000',
                status: 'Accepted',
                statusBgColor: AppColors.statusAcceptedBg,
                statusTextColor: AppColors.statusAcceptedText,
                imgUrl:
                    'https://images.unsplash.com/photo-1551754655-cd27e38d2076?auto=format&fit=crop&w=200&q=80',
              ),
              _orderCard(
                orderId: '#AGT003',
                dateTime: '12 Oct 2026, 09:30 AM',
                items: 'Potatoes (15 kg), Tomatoes (2 kg)',
                total: 'UGX 58,000',
                status: 'Delivered',
                statusBgColor: AppColors.statusDeliveredBg,
                statusTextColor: AppColors.statusDeliveredText,
                imgUrl:
                    'https://images.unsplash.com/photo-1518977676601-b53f82aba655?auto=format&fit=crop&w=200&q=80',
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _orderCard({
    required String orderId,
    required String dateTime,
    required String items,
    required String total,
    required String status,
    required Color statusBgColor,
    required Color statusTextColor,
    required String imgUrl,
  }) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order $orderId',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: AppColors.slate900,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: AppRadii.pillR,
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusTextColor,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              dateTime,
              style: const TextStyle(
                color: AppColors.slate500,
                fontSize: 11,
              ),
            ),
          ),
          const Divider(height: 16, color: AppColors.slate200),
          Row(
            children: [
              ClipRRect(
                borderRadius: AppRadii.smR,
                child: Image.network(
                  imgUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 48,
                    height: 48,
                    color: AppColors.slate100,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      items,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Total: $total',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brand700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: AppColors.slate500, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}