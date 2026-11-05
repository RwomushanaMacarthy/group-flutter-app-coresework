import 'package:flutter/material.dart';
import 'customer_home_screen.dart';
import 'farmer_dashboard_screen.dart';
import 'color_typography.dart';
import 'app_state.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoginMode = true;
  bool isFarmerRole = false;
  bool obscurePassword = true;
  bool rememberDevice = true;

  final _identifierCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _identifierCtrl.text = 'customer';
    _passwordCtrl.text = 'password';
  }

  @override
  void dispose() {
    _identifierCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _switchRole(bool farmer) {
    setState(() {
      isFarmerRole = farmer;
      _identifierCtrl.text = farmer ? 'farmer' : 'customer';
      _passwordCtrl.text = 'password';
    });
  }

  void _toggleMode() => setState(() => isLoginMode = !isLoginMode);

  void _handleSubmit() {
    final s = AppState.instance;

    if (isLoginMode) {
      final err = s.login(
        identifier: _identifierCtrl.text,
        password: _passwordCtrl.text,
        role: isFarmerRole ? 'farmer' : 'customer',
      );
      if (err != null) {
        _snack(err, error: true);
        return;
      }
    } else {
      if (_nameCtrl.text.trim().isEmpty ||
          _emailCtrl.text.trim().isEmpty ||
          _passwordCtrl.text.isEmpty) {
        _snack('Please fill in all required fields', error: true);
        return;
      }
      final err = s.register(
        name: _nameCtrl.text,
        email: _emailCtrl.text,
        password: _passwordCtrl.text,
        role: isFarmerRole ? 'farmer' : 'customer',
        phone: _phoneCtrl.text,
      );
      if (err != null) {
        _snack(err, error: true);
        return;
      }
    }

    if (isFarmerRole) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const FarmerDashboardScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
      );
    }
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor:
            error ? AppColors.statusRejectedText : AppColors.brand700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.mdR),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.stone50, AppColors.brand50, AppColors.stone100],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    _buildBrandHeader(),
                    const SizedBox(height: 20),
                    _buildRoleSwitcher(),
                    const SizedBox(height: 24),
                    _buildHeadline(),
                    const SizedBox(height: 24),
                    _buildForm(),
                    const SizedBox(height: 24),
                    _buildSocialSection(),
                    const SizedBox(height: 24),
                    _buildFooter(),
                    const SizedBox(height: 8),
                    _buildHomeBar(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/logo.png',
          width: 100,
          height: 100,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.eco, size: 60, color: AppColors.brand700),
        ),
      ],
    );
  }

  Widget _buildRoleSwitcher() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.stone200.withOpacity(0.7),
          borderRadius: AppRadii.pillR,
        ),
        child: Row(
          children: [
            _buildRoleTab('Farmer', true),
            _buildRoleTab('Customer', false),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleTab(String label, bool isFarmer) {
    final selected = isFarmerRole == isFarmer;
    return Expanded(
      child: GestureDetector(
        onTap: () => _switchRole(isFarmer),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.brand800 : Colors.transparent,
            borderRadius: AppRadii.pillR,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              color: selected ? Colors.white : AppColors.stone600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeadline() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.brand50,
            borderRadius: AppRadii.xxlR,
            border: Border.all(color: AppColors.brand200),
            boxShadow: [
              BoxShadow(
                color: AppColors.brand500.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            isFarmerRole ? Icons.agriculture : Icons.person,
            size: 44,
            color: AppColors.brand800,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          isFarmerRole ? 'FARMER PORTAL' : 'CUSTOMER PORTAL',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: AppColors.brand900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isLoginMode ? 'Welcome Back' : 'Create an Account',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.stone900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          isFarmerRole
              ? 'Sign in to manage your harvest batches, inventory & fresh produce orders'
              : 'Sign in to discover fresh produce from local farmers',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.stone500,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isLoginMode) ...[
          _buildLabel('Full Name'),
          const SizedBox(height: 6),
          _buildInputField(
            hint: 'e.g. Jane Doe',
            icon: Icons.person_outline,
            controller: _nameCtrl,
          ),
          const SizedBox(height: 14),
          _buildLabel('Phone Number'),
          const SizedBox(height: 6),
          _buildInputField(
            hint: '+256 700 000 000',
            icon: Icons.phone_outlined,
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 14),
        ],
        _buildLabel(isLoginMode
            ? (isFarmerRole ? 'Farmer ID / Email' : 'Customer ID / Email')
            : 'Email'),
        const SizedBox(height: 6),
        _buildInputField(
          hint: isLoginMode
              ? (isFarmerRole ? 'farmer' : 'customer')
              : 'you@example.com',
          icon: Icons.alternate_email,
          controller: _identifierCtrl,
          keyboardType: isLoginMode
              ? TextInputType.text
              : TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _buildLabel('Password'),
        const SizedBox(height: 6),
        _buildInputField(
          hint: 'Enter your password',
          icon: Icons.lock_outline,
          controller: _passwordCtrl,
          obscureText: obscurePassword,
          suffix: IconButton(
            onPressed: () =>
                setState(() => obscurePassword = !obscurePassword),
            icon: Icon(
              obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 18,
              color: AppColors.stone400,
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (isLoginMode)
          Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: rememberDevice,
                  onChanged: (v) =>
                      setState(() => rememberDevice = v ?? false),
                  activeColor: AppColors.brand700,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Remember my device',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.stone700,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brand700,
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 14),
        _buildPrimaryButton(),
        const SizedBox(height: 12),
        _buildBiometricButton(),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.stone700,
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffix,
    TextEditingController? controller,
  }) {
    return Container(
      decoration: BoxDecoration(boxShadow: AppShadows.softSmall),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 13, color: AppColors.stone900),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.stone400, fontSize: 13),
          prefixIcon: Icon(icon, size: 18, color: AppColors.stone400),
          suffixIcon: suffix,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: AppRadii.mdR,
            borderSide: const BorderSide(color: AppColors.stone200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadii.mdR,
            borderSide: const BorderSide(color: AppColors.stone200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadii.mdR,
            borderSide: const BorderSide(color: AppColors.brand600, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return GestureDetector(
      onTap: _handleSubmit,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.brand700,
              AppColors.brand800,
              AppColors.brand900,
            ],
          ),
          borderRadius: AppRadii.mdR,
          boxShadow: AppShadows.brandGlow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLoginMode ? 'Log In' : 'Register',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.arrow_forward,
              size: 16,
              color: AppColors.brand200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBiometricButton() {
    return OutlinedButton.icon(
      onPressed: () {
        final err = AppState.instance.login(
          identifier: isFarmerRole ? 'farmer' : 'customer',
          password: 'password',
          role: isFarmerRole ? 'farmer' : 'customer',
        );
        if (err != null) {
          _snack(err, error: true);
          return;
        }
        if (isFarmerRole) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const FarmerDashboardScreen()));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const CustomerHomeScreen()));
        }
      },
      icon: const Icon(Icons.fingerprint, size: 18, color: AppColors.brand700),
      label: const Text(
        'Log In with Face ID / Biometrics',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.brand800,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: AppColors.brand50,
        side: const BorderSide(color: AppColors.brand200),
        shape: RoundedRectangleBorder(borderRadius: AppRadii.mdR),
      ),
    );
  }

  Widget _buildSocialSection() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
                child: Divider(color: AppColors.stone200, thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'OR CONTINUE WITH',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: AppColors.stone400,
                ),
              ),
            ),
            const Expanded(
                child: Divider(color: AppColors.stone200, thickness: 1)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _socialButton(_googleLogo(), 'Google')),
            const SizedBox(width: 12),
            Expanded(child: _socialButton(_facebookLogo(), 'Facebook')),
            const SizedBox(width: 12),
            Expanded(child: _socialButton(_linkedinLogo(), 'LinkedIn')),
          ],
        ),
      ],
    );
  }

  Widget _socialButton(Widget logo, String label) {
    return Tooltip(
      message: 'Sign in with $label',
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadii.mdR,
            border: Border.all(color: AppColors.stone200),
          ),
          alignment: Alignment.center,
          child: logo,
        ),
      ),
    );
  }

  Widget _googleLogo() => SizedBox(
        width: 18,
        height: 18,
        child: CustomPaint(painter: _GoogleLogoPainter()),
      );

  Widget _facebookLogo() => const SizedBox(
        width: 18,
        height: 18,
        child: Icon(Icons.facebook, color: AppColors.facebookBlue, size: 20),
      );

  Widget _linkedinLogo() => Container(
        width: 18,
        height: 18,
        decoration: const BoxDecoration(
          color: AppColors.linkedinBlue,
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        alignment: Alignment.center,
        child: const Text('in',
            style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold)),
      );

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLoginMode ? "Don't have an account? " : 'Already have an account? ',
          style: const TextStyle(fontSize: 12, color: AppColors.stone600),
        ),
        GestureDetector(
          onTap: _toggleMode,
          child: Text(
            isLoginMode ? 'Register' : 'Log In',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.brand700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHomeBar() => Center(
        child: Container(
          width: 128,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.homeBarLight,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final center = rect.center;
    final radius = size.width / 2;
    final stroke = size.width * 0.22;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - stroke / 2),
      -0.35,
      1.9,
      false,
      Paint()
        ..color = AppColors.googleBlue
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - stroke / 2),
      -1.75,
      1.4,
      false,
      Paint()
        ..color = AppColors.googleRed
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - stroke / 2),
      1.15,
      1.0,
      false,
      Paint()
        ..color = AppColors.googleYellow
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - stroke / 2),
      2.15,
      1.0,
      false,
      Paint()
        ..color = AppColors.googleGreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}