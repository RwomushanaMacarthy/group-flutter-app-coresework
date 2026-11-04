import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'color_typography.dart';
import 'app_state.dart';
import 'product_image_view.dart';

class FarmerAddProductScreen extends StatefulWidget {
  final Product? existing;
  const FarmerAddProductScreen({super.key, this.existing});

  @override
  State<FarmerAddProductScreen> createState() => _FarmerAddProductScreenState();
}

class _FarmerAddProductScreenState extends State<FarmerAddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _stockCtrl;
  late TextEditingController _unitCtrl;
  late TextEditingController _tagCtrl;
  late TextEditingController _imageUrlCtrl;

  String _category = 'Vegetables';
  String _localImagePath = '';
  final _picker = ImagePicker();

  final _categories = ['Vegetables', 'Fruits', 'Grains', 'Legumes'];

  final _sampleUrls = [
    'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1551754655-cd27e38d2076?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1551462147-ff29053bfc14?auto=format&fit=crop&w=400&q=80',
  ];

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _priceCtrl = TextEditingController(text: e?.price.toString() ?? '');
    _stockCtrl = TextEditingController(text: e?.stock.toString() ?? '');
    _unitCtrl = TextEditingController(text: e?.unit ?? 'per kg');
    _tagCtrl = TextEditingController(text: e?.tag ?? '');
    _imageUrlCtrl = TextEditingController(text: e?.image ?? '');
    _category = e?.category ?? 'Vegetables';
    _localImagePath = e?.localImagePath ?? '';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    _unitCtrl.dispose();
    _tagCtrl.dispose();
    _imageUrlCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source,
        imageQuality: 75,
        maxWidth: 1200,
      );
      if (file != null) {
        setState(() => _localImagePath = file.path);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not pick image: $e'),
          backgroundColor: AppColors.statusRejectedText,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.mdR),
        ),
      );
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final s = AppState.instance;

    final url = _imageUrlCtrl.text.trim();
    final finalUrl = url.isNotEmpty ? url : '';

    // Require at least a URL or a local image
    if (finalUrl.isEmpty && _localImagePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pick a photo or paste an image URL'),
          backgroundColor: AppColors.statusPendingText,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.mdR),
        ),
      );
      return;
    }

    if (widget.existing == null) {
      await s.addProduct(Product(
        id: s.newProductId(),
        name: _nameCtrl.text.trim(),
        price: int.parse(_priceCtrl.text),
        unit: _unitCtrl.text.trim(),
        stock: int.parse(_stockCtrl.text),
        category: _category,
        farm: s.profile.farmName,
        image: finalUrl,
        localImagePath: _localImagePath,
        tag: _tagCtrl.text.trim().isEmpty ? 'Fresh' : _tagCtrl.text.trim(),
      ));
    } else {
      await s.updateProduct(Product(
        id: widget.existing!.id,
        name: _nameCtrl.text.trim(),
        price: int.parse(_priceCtrl.text),
        unit: _unitCtrl.text.trim(),
        stock: int.parse(_stockCtrl.text),
        category: _category,
        farm: widget.existing!.farm,
        image: finalUrl,
        localImagePath: _localImagePath,
        tag: _tagCtrl.text.trim().isEmpty ? 'Fresh' : _tagCtrl.text.trim(),
        rating: widget.existing!.rating,
        active: widget.existing!.active,
      ));
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.existing == null
            ? '${_nameCtrl.text} added to inventory'
            : 'Product updated successfully'),
        backgroundColor: AppColors.brand700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.mdR),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceScaffoldOld,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(widget.existing == null ? 'Add Product' : 'Edit Product',
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.slate900)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.slate900),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _imagePreview(),
                const SizedBox(height: 10),
                _imageButtons(),
                const SizedBox(height: 14),
                _label('Image URL (optional — loads from internet)'),
                TextFormField(
                  controller: _imageUrlCtrl,
                  style: const TextStyle(fontSize: 13),
                  keyboardType: TextInputType.url,
                  decoration: _dec('https://example.com/photo.jpg'),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 8),
                // Quick sample URLs
                SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _sampleUrls.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 6),
                    itemBuilder: (context, i) {
                      final url = _sampleUrls[i];
                      final sel = _imageUrlCtrl.text == url;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _imageUrlCtrl.text = url;
                            _localImagePath = '';
                          });
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: AppRadii.smR,
                            border: Border.all(
                              color: sel
                                  ? AppColors.brand700
                                  : AppColors.slate200,
                              width: sel ? 2 : 1,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: ProductImageView(imageUrl: url),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                _label('Product Name'),
                TextFormField(
                  controller: _nameCtrl,
                  style: const TextStyle(fontSize: 13),
                  decoration: _dec('e.g. Fresh Vine Tomatoes'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Price (UGX)'),
                          TextFormField(
                            controller: _priceCtrl,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 13),
                            decoration: _dec('4000'),
                            validator: (v) {
                              final n = int.tryParse(v ?? '');
                              if (n == null || n <= 0) return 'Invalid';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Stock'),
                          TextFormField(
                            controller: _stockCtrl,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 13),
                            decoration: _dec('30'),
                            validator: (v) {
                              final n = int.tryParse(v ?? '');
                              if (n == null || n < 0) return 'Invalid';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _label('Unit'),
                TextFormField(
                  controller: _unitCtrl,
                  style: const TextStyle(fontSize: 13),
                  decoration: _dec('per kg'),
                ),
                const SizedBox(height: 12),
                _label('Category'),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categories.map((c) {
                    final sel = _category == c;
                    return GestureDetector(
                      onTap: () => setState(() => _category = c),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel ? AppColors.brand700 : Colors.white,
                          borderRadius: AppRadii.pillR,
                          border: Border.all(
                            color:
                                sel ? AppColors.brand700 : AppColors.slate200,
                          ),
                        ),
                        child: Text(c,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: sel
                                    ? Colors.white
                                    : AppColors.slate700)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                _label('Short tag (optional)'),
                TextFormField(
                  controller: _tagCtrl,
                  style: const TextStyle(fontSize: 13),
                  decoration: _dec('e.g. Grade A • Fresh'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brand700,
                      shape:
                          RoundedRectangleBorder(borderRadius: AppRadii.mdR),
                    ),
                    child: Text(
                      widget.existing == null
                          ? 'Save Product'
                          : 'Update Product',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imagePreview() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadii.mdR,
        border: Border.all(color: AppColors.slate200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ProductImageView(
            imageUrl: _imageUrlCtrl.text.trim().isEmpty
                ? null
                : _imageUrlCtrl.text.trim(),
            localImagePath: _localImagePath,
          ),
          if (_localImagePath.isNotEmpty)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.brand700,
                  borderRadius: AppRadii.pillR,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.phone_android,
                        size: 12, color: Colors.white),
                    SizedBox(width: 4),
                    Text('From phone',
                        style: TextStyle(
                            fontSize: 10,
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

  Widget _imageButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _pickImage(ImageSource.camera),
            icon: const Icon(Icons.camera_alt, size: 18),
            label: const Text('Camera'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _pickImage(ImageSource.gallery),
            icon: const Icon(Icons.photo_library, size: 18),
            label: const Text('Gallery'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        if (_localImagePath.isNotEmpty) ...[
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => setState(() => _localImagePath = ''),
            icon: const Icon(Icons.delete_outline,
                color: AppColors.statusRejectedText),
            tooltip: 'Remove picked photo',
          ),
        ],
      ],
    );
  }

  Widget _label(String t) => Text(t,
      style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.slate700));

  InputDecoration _dec(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.slate400, fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
          borderSide: const BorderSide(color: AppColors.brand600, width: 2),
        ),
      );
}