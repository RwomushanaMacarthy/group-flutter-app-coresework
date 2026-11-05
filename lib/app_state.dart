import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ═══════════════════════════════════════════════════════════════════
//  MODELS
// ═══════════════════════════════════════════════════════════════════

class Product {
  String id;
  String name;
  int price;
  String unit;
  int stock;
  String category;
  String farm;
  String image;
  String localImagePath;
  String tag;
  double rating;
  bool active;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
    required this.stock,
    required this.category,
    required this.farm,
    required this.image,
    this.localImagePath = '',
    required this.tag,
    this.rating = 4.5,
    this.active = true,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'price': price,
        'unit': unit,
        'stock': stock,
        'category': category,
        'farm': farm,
        'image': image,
        'localImagePath': localImagePath,
        'tag': tag,
        'rating': rating,
        'active': active,
      };

  factory Product.fromMap(Map<String, dynamic> m) => Product(
        id: m['id'],
        name: m['name'],
        price: m['price'],
        unit: m['unit'],
        stock: m['stock'],
        category: m['category'],
        farm: m['farm'],
        image: m['image'] ?? '',
        localImagePath: m['localImagePath'] ?? '',
        tag: m['tag'] ?? '',
        rating: (m['rating'] as num?)?.toDouble() ?? 4.5,
        active: m['active'] ?? true,
      );
}

class OrderItem {
  final String productName;
  final int price;
  final int qty;

  const OrderItem({
    required this.productName,
    required this.price,
    required this.qty,
  });

  int get subtotal => price * qty;

  Map<String, dynamic> toMap() => {
        'productName': productName,
        'price': price,
        'qty': qty,
      };

  factory OrderItem.fromMap(Map<String, dynamic> m) => OrderItem(
        productName: m['productName'],
        price: m['price'],
        qty: m['qty'],
      );
}

class CustomerOrder {
  final String id;
  final DateTime dateTime;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final List<OrderItem> items;
  String status;
  final String paymentMethod;
  final String image;

  CustomerOrder({
    required this.id,
    required this.dateTime,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.items,
    required this.status,
    required this.paymentMethod,
    required this.image,
  });

  int get total => items.fold(0, (s, i) => s + i.subtotal);

  String get itemSummary => items
      .map((i) =>
          '${i.productName} (${i.qty}${i.qty > 1 ? " units" : " unit"})')
      .join(', ');

  Map<String, dynamic> toMap() => {
        'id': id,
        'dateTime': dateTime.toIso8601String(),
        'customerName': customerName,
        'customerPhone': customerPhone,
        'deliveryAddress': deliveryAddress,
        'items': items.map((i) => i.toMap()).toList(),
        'status': status,
        'paymentMethod': paymentMethod,
        'image': image,
      };

  factory CustomerOrder.fromMap(Map<String, dynamic> m) => CustomerOrder(
        id: m['id'],
        dateTime: DateTime.parse(m['dateTime']),
        customerName: m['customerName'],
        customerPhone: m['customerPhone'],
        deliveryAddress: m['deliveryAddress'],
        items: (m['items'] as List)
            .map((e) => OrderItem.fromMap(e as Map<String, dynamic>))
            .toList(),
        status: m['status'],
        paymentMethod: m['paymentMethod'],
        image: m['image'],
      );
}

class Review {
  final String customerName;
  final int rating;
  final String comment;
  final DateTime date;

  const Review({
    required this.customerName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
        'customerName': customerName,
        'rating': rating,
        'comment': comment,
        'date': date.toIso8601String(),
      };

  factory Review.fromMap(Map<String, dynamic> m) => Review(
        customerName: m['customerName'],
        rating: m['rating'],
        comment: m['comment'],
        date: DateTime.parse(m['date']),
      );
}

class FarmerProfile {
  String name;
  String farmName;
  String phone;
  String email;
  String location;
  String bio;
  String avatarUrl;
  double rating;
  int totalReviews;

  FarmerProfile({
    required this.name,
    required this.farmName,
    required this.phone,
    required this.email,
    required this.location,
    required this.bio,
    required this.avatarUrl,
    this.rating = 4.8,
    this.totalReviews = 128,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'farmName': farmName,
        'phone': phone,
        'email': email,
        'location': location,
        'bio': bio,
        'avatarUrl': avatarUrl,
        'rating': rating,
        'totalReviews': totalReviews,
      };

  factory FarmerProfile.fromMap(Map<String, dynamic> m) => FarmerProfile(
        name: m['name'],
        farmName: m['farmName'],
        phone: m['phone'],
        email: m['email'],
        location: m['location'],
        bio: m['bio'],
        avatarUrl: m['avatarUrl'],
        rating: (m['rating'] as num?)?.toDouble() ?? 4.8,
        totalReviews: m['totalReviews'] ?? 0,
      );
}

// ═══════════════════════════════════════════════════════════════════
//  APP USER MODEL (AUTH)
// ═══════════════════════════════════════════════════════════════════

class AppUser {
  final String id;
  String name;
  String email;
  String password;
  String role; // 'farmer' | 'customer'
  String phone;
  String avatarUrl;
  String localAvatarPath;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.phone = '',
    this.avatarUrl = '',
    this.localAvatarPath = '',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'role': role,
        'phone': phone,
        'avatarUrl': avatarUrl,
        'localAvatarPath': localAvatarPath,
      };

  factory AppUser.fromMap(Map<String, dynamic> m) => AppUser(
        id: m['id'],
        name: m['name'],
        email: m['email'],
        password: m['password'],
        role: m['role'],
        phone: m['phone'] ?? '',
        avatarUrl: m['avatarUrl'] ?? '',
        localAvatarPath: m['localAvatarPath'] ?? '',
      );
}

// ═══════════════════════════════════════════════════════════════════
//  APP STATE
// ═══════════════════════════════════════════════════════════════════

class AppState extends ChangeNotifier {
  AppState._();
  static final AppState instance = AppState._();

  static const _kProducts = 'agt_products_v1';
  static const _kOrders = 'agt_orders_v1';
  static const _kReviews = 'agt_reviews_v1';
  static const _kProfile = 'agt_profile_v1';
  static const _kSeeded = 'agt_seeded_v1';
  static const _kUsers = 'agt_users_v2';
  static const _kSession = 'agt_session_v1';

  SharedPreferences? _prefs;
  bool _ready = false;
  bool get isReady => _ready;

  // ── AUTH ──────────────────────────────────────────────────────
  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  List<AppUser> _users = [];

  // ── CONNECTIVITY ──────────────────────────────────────────────
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  // ── In-memory copies ──────────────────────────────────────────
  List<Product> _products = [];
  List<CustomerOrder> _orders = [];
  List<Review> _reviews = [];
  FarmerProfile _profile = FarmerProfile(
    name: 'John Ssemakula',
    farmName: 'Green Acres Farm',
    phone: '+256 772 123 456',
    email: 'farmer',
    location: 'Mukono District, Uganda',
    bio:
        'Smallholder farmer growing fresh vegetables and grains for over 10 years.',
    avatarUrl:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
  );

  // Read-only views
  List<Product> get products => List.unmodifiable(_products);
  List<CustomerOrder> get orders => List.unmodifiable(_orders);
  List<Review> get reviews => List.unmodifiable(_reviews);
  FarmerProfile get profile => _profile;

  // ── Derived stats ─────────────────────────────────────────────
  int get totalProducts => _products.length;
  int get activeProducts => _products.where((p) => p.active).length;
  int get pendingOrders =>
      _orders.where((o) => o.status == 'Pending').length;
  int get totalOrders => _orders.length;
  int get totalRevenue => _orders
      .where((o) => o.status == 'Delivered')
      .fold(0, (s, o) => s + o.total);
  int get lowStockCount => _products.where((p) => p.stock <= 5).length;

  // ═══════════════════════════════════════════════════════════════
  //  INIT
  // ═══════════════════════════════════════════════════════════════
  Future<void> init() async {
    if (_ready) return;
    _prefs = await SharedPreferences.getInstance();
    final seeded = _prefs!.getBool(_kSeeded) ?? false;
    if (!seeded) {
      await _seedDefaults();
      await _prefs!.setBool(_kSeeded, true);
    } else {
      _loadFromDisk();
    }
    _loadUsers();
    _restoreSession();
    await _checkConnectivity();
    _ready = true;
    notifyListeners();
  }

  void _loadFromDisk() {
    final p = _prefs!;

    final rawProducts = p.getString(_kProducts);
    if (rawProducts != null) {
      _products = (jsonDecode(rawProducts) as List)
          .map((e) => Product.fromMap(e as Map<String, dynamic>))
          .toList();
    }

    final rawOrders = p.getString(_kOrders);
    if (rawOrders != null) {
      _orders = (jsonDecode(rawOrders) as List)
          .map((e) => CustomerOrder.fromMap(e as Map<String, dynamic>))
          .toList();
    }

    final rawReviews = p.getString(_kReviews);
    if (rawReviews != null) {
      _reviews = (jsonDecode(rawReviews) as List)
          .map((e) => Review.fromMap(e as Map<String, dynamic>))
          .toList();
    }

    final rawProfile = p.getString(_kProfile);
    if (rawProfile != null) {
      _profile = FarmerProfile.fromMap(
          jsonDecode(rawProfile) as Map<String, dynamic>);
    }
  }

  Future<void> _seedDefaults() async {
    _products = [
      Product(
        id: 'p1',
        name: 'Fresh Vine Tomatoes',
        price: 4000,
        unit: 'per kg',
        stock: 30,
        category: 'Vegetables',
        farm: _profile.farmName,
        image:
            'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=400&q=80',
        tag: 'Grade A • Fresh',
        rating: 4.9,
      ),
      Product(
        id: 'p2',
        name: 'Crisp Red Onions',
        price: 3500,
        unit: 'per kg',
        stock: 45,
        category: 'Vegetables',
        farm: _profile.farmName,
        image:
            'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?auto=format&fit=crop&w=400&q=80',
        tag: 'Dry Cured • Pungent',
        rating: 4.8,
      ),
      Product(
        id: 'p3',
        name: 'Yellow Maize',
        price: 2500,
        unit: 'per kg',
        stock: 50,
        category: 'Grains',
        farm: _profile.farmName,
        image:
            'https://images.unsplash.com/photo-1551754655-cd27e38d2076?auto=format&fit=crop&w=400&q=80',
        tag: 'Dried • Clean',
        rating: 4.5,
      ),
      Product(
        id: 'p4',
        name: 'Kidney Beans',
        price: 5000,
        unit: 'per kg',
        stock: 40,
        category: 'Legumes',
        farm: _profile.farmName,
        image:
            'https://images.unsplash.com/photo-1551462147-ff29053bfc14?auto=format&fit=crop&w=400&q=80',
        tag: 'Protein-Rich',
        rating: 4.7,
      ),
    ];

    final now = DateTime.now();
    _orders = [
      CustomerOrder(
        id: '#AGT-001',
        dateTime: now.subtract(const Duration(hours: 2)),
        customerName: 'Sarah Nakato',
        customerPhone: '+256 701 555 111',
        deliveryAddress: 'Kampala Central, Plot 12, Ntinda',
        items: const [
          OrderItem(productName: 'Fresh Vine Tomatoes', price: 4000, qty: 5),
          OrderItem(productName: 'Crisp Red Onions', price: 3500, qty: 2),
        ],
        status: 'Pending',
        paymentMethod: 'MTN Mobile Money',
        image:
            'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=200&q=80',
      ),
      CustomerOrder(
        id: '#AGT-002',
        dateTime: now.subtract(const Duration(days: 1, hours: 4)),
        customerName: 'Peter Ochieng',
        customerPhone: '+256 702 444 222',
        deliveryAddress: 'Wakiso, Entebbe Road, Kira',
        items: const [
          OrderItem(productName: 'Yellow Maize', price: 2500, qty: 10),
          OrderItem(productName: 'Kidney Beans', price: 5000, qty: 5),
        ],
        status: 'Accepted',
        paymentMethod: 'Airtel Money',
        image:
            'https://images.unsplash.com/photo-1551754655-cd27e38d2076?auto=format&fit=crop&w=200&q=80',
      ),
      CustomerOrder(
        id: '#AGT-003',
        dateTime: now.subtract(const Duration(days: 3)),
        customerName: 'Grace Auma',
        customerPhone: '+256 703 333 333',
        deliveryAddress: 'Mukono, Seeta',
        items: const [
          OrderItem(productName: 'Fresh Vine Tomatoes', price: 4000, qty: 2),
        ],
        status: 'Delivered',
        paymentMethod: 'MTN Mobile Money',
        image:
            'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=200&q=80',
      ),
    ];

    _reviews = [
      Review(
        customerName: 'Sarah Nakato',
        rating: 5,
        comment: 'Very fresh tomatoes! Will order again.',
        date: now.subtract(const Duration(days: 2)),
      ),
      Review(
        customerName: 'Peter Ochieng',
        rating: 4,
        comment: 'Good quality maize, delivery was on time.',
        date: now.subtract(const Duration(days: 5)),
      ),
    ];

    await _persistAll();
  }

  // ═══════════════════════════════════════════════════════════════
  //  PERSISTENCE
  // ═══════════════════════════════════════════════════════════════
  Future<void> _persistAll() async {
    final p = _prefs!;
    await p.setString(
        _kProducts, jsonEncode(_products.map((e) => e.toMap()).toList()));
    await p.setString(
        _kOrders, jsonEncode(_orders.map((e) => e.toMap()).toList()));
    await p.setString(
        _kReviews, jsonEncode(_reviews.map((e) => e.toMap()).toList()));
    await p.setString(_kProfile, jsonEncode(_profile.toMap()));
  }

  Future<void> _persistProducts() async {
    await _prefs!.setString(
        _kProducts, jsonEncode(_products.map((e) => e.toMap()).toList()));
  }

  Future<void> _persistOrders() async {
    await _prefs!.setString(
        _kOrders, jsonEncode(_orders.map((e) => e.toMap()).toList()));
  }

  Future<void> _persistReviews() async {
    await _prefs!.setString(
        _kReviews, jsonEncode(_reviews.map((e) => e.toMap()).toList()));
  }

  Future<void> _persistProfile() async {
    await _prefs!.setString(_kProfile, jsonEncode(_profile.toMap()));
  }

  Future<void> _persistUsers() async {
    await _prefs!.setString(
        _kUsers, jsonEncode(_users.map((e) => e.toMap()).toList()));
  }

  // ═══════════════════════════════════════════════════════════════
  //  CONNECTIVITY
  // ═══════════════════════════════════════════════════════════════
  Future<void> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      final online =
          result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      _setOnline(online);
    } catch (_) {
      _setOnline(false);
    }
  }

  void _setOnline(bool online) {
    if (_isOnline == online) return;
    _isOnline = online;
    notifyListeners();
  }

  Future<void> refreshConnectivity() async {
    await _checkConnectivity();
  }

  // ═══════════════════════════════════════════════════════════════
  //  AUTH / USERS
  // ═══════════════════════════════════════════════════════════════
  void _loadUsers() {
    final raw = _prefs!.getString(_kUsers);
    if (raw != null) {
      _users = (jsonDecode(raw) as List)
          .map((e) => AppUser.fromMap(e as Map<String, dynamic>))
          .toList();
    }
    // Seed default accounts if missing
    final hasCustomer = _users.any((u) => u.email == 'customer');
    final hasFarmer = _users.any((u) => u.email == 'farmer');
    bool changed = false;
    if (!hasCustomer) {
      _users.add(AppUser(
        id: 'u_customer_default',
        name: 'Customer',
        email: 'customer',
        password: 'password',
        role: 'customer',
        phone: '+256 700 000 001',
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80',
      ));
      changed = true;
    }
    if (!hasFarmer) {
      _users.add(AppUser(
        id: 'u_farmer_default',
        name: 'John Ssemakula',
        email: 'farmer',
        password: 'password',
        role: 'farmer',
        phone: '+256 772 123 456',
        avatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
      ));
      changed = true;
    }
    if (changed) _persistUsers();
  }

  void _restoreSession() {
    final raw = _prefs!.getString(_kSession);
    if (raw != null) {
      final id = jsonDecode(raw) as String;
      final match = _users.where((u) => u.id == id);
      if (match.isNotEmpty) {
        _currentUser = match.first;
        _applyUserToProfile();
      }
    }
  }

  void _applyUserToProfile() {
    if (_currentUser == null) return;
    if (_currentUser!.role == 'farmer') {
      _profile = FarmerProfile(
        name: _currentUser!.name,
        farmName: _profile.farmName,
        phone: _currentUser!.phone.isNotEmpty
            ? _currentUser!.phone
            : _profile.phone,
        email: _currentUser!.email,
        location: _profile.location,
        bio: _profile.bio,
        avatarUrl: _currentUser!.avatarUrl.isNotEmpty
            ? _currentUser!.avatarUrl
            : _profile.avatarUrl,
        rating: _profile.rating,
        totalReviews: _profile.totalReviews,
      );
    }
  }

  /// Returns null on success, error message otherwise.
  String? login({
    required String identifier,
    required String password,
    required String role,
  }) {
    final id = identifier.trim().toLowerCase();
    final match = _users.where((u) =>
        u.role == role &&
        (u.email.toLowerCase() == id ||
            u.name.toLowerCase() == id ||
            u.id == identifier.trim()));
    if (match.isEmpty) {
      return 'No $role account found for "$identifier".';
    }
    final user = match.first;
    if (user.password != password) {
      return 'Incorrect password.';
    }
    _currentUser = user;
    _prefs!.setString(_kSession, jsonEncode(user.id));
    _applyUserToProfile();
    notifyListeners();
    return null;
  }

  String? register({
    required String name,
    required String email,
    required String password,
    required String role,
    String phone = '',
  }) {
    final e = email.trim().toLowerCase();
    if (_users.any((u) =>
        u.email.toLowerCase() == e && u.role == role)) {
      return 'An account with this email already exists for $role.';
    }
    final u = AppUser(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: email.trim(),
      password: password,
      role: role,
      phone: phone.trim(),
    );
    _users.add(u);
    _persistUsers();
    _currentUser = u;
    _prefs!.setString(_kSession, jsonEncode(u.id));
    _applyUserToProfile();
    notifyListeners();
    return null;
  }

  Future<void> logout() async {
    _currentUser = null;
    await _prefs!.remove(_kSession);
    notifyListeners();
  }

  Future<void> updateCurrentUserAvatar({
    String? avatarUrl,
    String? localAvatarPath,
  }) async {
    if (_currentUser == null) return;
    if (avatarUrl != null) _currentUser!.avatarUrl = avatarUrl;
    if (localAvatarPath != null) {
      _currentUser!.localAvatarPath = localAvatarPath;
    }
    if (_currentUser!.role == 'farmer') {
      _profile = FarmerProfile(
        name: _currentUser!.name,
        farmName: _profile.farmName,
        phone: _currentUser!.phone.isNotEmpty
            ? _currentUser!.phone
            : _profile.phone,
        email: _currentUser!.email,
        location: _profile.location,
        bio: _profile.bio,
        avatarUrl: _currentUser!.avatarUrl.isNotEmpty
            ? _currentUser!.avatarUrl
            : _profile.avatarUrl,
        rating: _profile.rating,
        totalReviews: _profile.totalReviews,
      );
      await _persistProfile();
    }
    await _persistUsers();
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════
  //  PRODUCT MUTATIONS
  // ═══════════════════════════════════════════════════════════════
  Future<void> addProduct(Product p) async {
    _products.insert(0, p);
    notifyListeners();
    await _persistProducts();
  }

  Future<void> updateProduct(Product updated) async {
    final i = _products.indexWhere((p) => p.id == updated.id);
    if (i != -1) {
      _products[i] = updated;
      notifyListeners();
      await _persistProducts();
    }
  }

  Future<void> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
    await _persistProducts();
  }

  Future<void> toggleProductActive(String id) async {
    final i = _products.indexWhere((p) => p.id == id);
    if (i != -1) {
      _products[i].active = !_products[i].active;
      notifyListeners();
      await _persistProducts();
    }
  }

  // ═══════════════════════════════════════════════════════════════
  //  ORDER MUTATIONS
  // ═══════════════════════════════════════════════════════════════
  Future<void> updateOrderStatus(String orderId, String status) async {
    final i = _orders.indexWhere((o) => o.id == orderId);
    if (i != -1) {
      _orders[i].status = status;
      notifyListeners();
      await _persistOrders();
    }
  }

  Future<void> addOrder(CustomerOrder order) async {
    _orders.insert(0, order);
    notifyListeners();
    await _persistOrders();
  }

  // ═══════════════════════════════════════════════════════════════
  //  REVIEW MUTATIONS
  // ═══════════════════════════════════════════════════════════════
  Future<void> addReview({
    required String customerName,
    required int rating,
    required String comment,
  }) async {
    _reviews.removeWhere((r) => r.customerName == customerName);
    _reviews.insert(
      0,
      Review(
        customerName: customerName,
        rating: rating,
        comment: comment,
        date: DateTime.now(),
      ),
    );

    final total = _reviews.fold<int>(0, (s, r) => s + r.rating);
    final avg = _reviews.isEmpty ? 0.0 : total / _reviews.length;

    _profile = FarmerProfile(
      name: _profile.name,
      farmName: _profile.farmName,
      phone: _profile.phone,
      email: _profile.email,
      location: _profile.location,
      bio: _profile.bio,
      avatarUrl: _profile.avatarUrl,
      rating: double.parse(avg.toStringAsFixed(1)),
      totalReviews: _reviews.length,
    );

    notifyListeners();
    await _persistReviews();
    await _persistProfile();
  }

  // ═══════════════════════════════════════════════════════════════
  //  PROFILE MUTATIONS
  // ═══════════════════════════════════════════════════════════════
  Future<void> updateProfile({
    String? name,
    String? farmName,
    String? phone,
    String? email,
    String? location,
    String? bio,
  }) async {
    _profile = FarmerProfile(
      name: name ?? _profile.name,
      farmName: farmName ?? _profile.farmName,
      phone: phone ?? _profile.phone,
      email: email ?? _profile.email,
      location: location ?? _profile.location,
      bio: bio ?? _profile.bio,
      avatarUrl: _profile.avatarUrl,
      rating: _profile.rating,
      totalReviews: _profile.totalReviews,
    );
    if (_currentUser != null && _currentUser!.role == 'farmer') {
      if (name != null) _currentUser!.name = name;
      if (phone != null) _currentUser!.phone = phone;
      if (email != null) _currentUser!.email = email;
      await _persistUsers();
    }
    notifyListeners();
    await _persistProfile();
  }

  // ═══════════════════════════════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════════════════════════════
  String newProductId() => 'p${DateTime.now().millisecondsSinceEpoch}';

  String newOrderId() {
    final n = _orders.length + 1;
    return '#AGT-${n.toString().padLeft(3, "0")}';
  }

  static String formatPrice(int price) => price.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );

  static Future<void> bootstrap() async {
    await instance.init();
  }
}