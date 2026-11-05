import 'package:flutter/material.dart';
import 'color_typography.dart';
import 'app_state.dart';

class ConnectivityBanner extends StatelessWidget {
  final Widget child;
  const ConnectivityBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        final s = AppState.instance;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: s.isOnline ? 0 : 34,
                child: s.isOnline
                    ? null
                    : Container(
                        width: double.infinity,
                        color: AppColors.statusRejectedText,
                        alignment: Alignment.center,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.wifi_off,
                                size: 14, color: Colors.white),
                            SizedBox(width: 6),
                            Text(
                              'You are offline — changes saved locally',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }
}