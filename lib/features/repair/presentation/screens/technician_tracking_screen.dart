import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../providers/repair_flow_provider.dart';

/// Screen tracking assigned technician GPS arrival with security OTP and live ETA.
class TechnicianTrackingScreen extends ConsumerStatefulWidget {
  final String orderId;

  const TechnicianTrackingScreen({
    super.key,
    required this.orderId,
  });

  @override
  ConsumerState<TechnicianTrackingScreen> createState() => _TechnicianTrackingScreenState();
}

class _TechnicianTrackingScreenState extends ConsumerState<TechnicianTrackingScreen> {
  Timer? _etaSimulationTimer;

  @override
  void initState() {
    super.initState();
    // Simulate technician moving closer every 10 seconds
    _etaSimulationTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      ref.read(repairFlowNotifierProvider.notifier).simulateTechnicianStep();
    });
  }

  @override
  void dispose() {
    _etaSimulationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repairState = ref.watch(repairFlowNotifierProvider);
    final tech = repairState.activeOrder?.technician;
    final eta = tech?.etaMinutes ?? 18;

    return Scaffold(
      appBar: CustomAppBar(title: 'Tracking Technician (${widget.orderId})'),
      body: Column(
        children: [
          // Simulated Google Map View
          Expanded(
            child: Container(
              color: const Color(0xFFE8ECEF),
              child: Stack(
                children: [
                  // Map Background Grid Lines Simulation
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _MapGridPainter(),
                    ),
                  ),

                  // Customer Location Pin
                  Positioned(
                    top: 100,
                    right: 80,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: AppSpacing.roundedSm,
                            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                          ),
                          child: const Text('Your Home', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                        ),
                        const Icon(Icons.location_pin, color: AppColors.error, size: 36),
                      ],
                    ),
                  ),

                  // Technician Moving Marker
                  Positioned(
                    bottom: 120,
                    left: 70,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryDark,
                            borderRadius: AppSpacing.roundedSm,
                          ),
                          child: Text(
                            'Vikram (${eta}m)',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
                          ),
                          child: const Icon(Icons.two_wheeler_rounded, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Technician Details & Handover OTP Sheet
          Container(
            padding: AppSpacing.screenPadding,
            decoration: const BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 20, offset: Offset(0, -6))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Live ETA Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: AppSpacing.roundedMd,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.access_time_filled_rounded, color: AppColors.primaryDark, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Arriving in approx $eta minutes',
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.primaryDark),
                          ),
                        ],
                      ),
                      const Text('On Schedule', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Technician Profile Row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.secondaryLight,
                      child: const Icon(Icons.person_rounded, size: 28, color: AppColors.secondaryDark),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(tech?.name ?? 'Vikram Singh', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                              const SizedBox(width: 6),
                              const Icon(Icons.verified_rounded, size: 16, color: AppColors.primary),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 14, color: AppColors.accent),
                              Text(' ${tech?.rating ?? 4.94} (${tech?.completedRepairs ?? 712} repairs)', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                              const SizedBox(width: 6),
                              Text('• ${tech?.vehicleNumber ?? 'KA 03 HM 4821'}', style: const TextStyle(fontSize: 11, color: AppColors.neutral500)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.call_rounded, color: AppColors.primaryDark),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Calling technician ${tech?.name ?? 'Vikram'}...')),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // Handover Security Code
                AppCard(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Handover Security OTP', style: TextStyle(fontSize: 11, color: AppColors.neutral500)),
                          Text(
                            'Share when technician arrives',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.neutral100,
                          borderRadius: AppSpacing.roundedSm,
                        ),
                        child: Text(
                          tech?.verificationOtp ?? '8492',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2, color: AppColors.neutral900),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                AppButton(
                  text: 'View Repair Quality Checklist',
                  variant: ButtonVariant.outline,
                  onPressed: () {
                    // Open checklist dialog / screen
                    showModalBottomSheet(
                      context: context,
                      builder: (ctx) => const _RepairChecklistSheet(),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 3;

    // Simulated roads
    canvas.drawLine(Offset(0, size.height * 0.4), Offset(size.width, size.height * 0.6), paint);
    canvas.drawLine(Offset(size.width * 0.3, 0), Offset(size.width * 0.7, size.height), paint);

    // Route Polyline
    final routePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(70, size.height - 120);
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.5, size.width - 80, 100);
    canvas.drawPath(path, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RepairChecklistSheet extends StatelessWidget {
  const _RepairChecklistSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.screenPadding,
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Doorstep Repair Checklist', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.check_circle_rounded, color: AppColors.primaryDark),
            title: Text('1. Pre-Repair Diagnosis', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            subtitle: Text('Technician tests screen, touch, camera and sound before disassembly.', style: TextStyle(fontSize: 11)),
          ),
          const ListTile(
            leading: Icon(Icons.build_circle_rounded, color: AppColors.secondary),
            title: Text('2. Live Doorstep Part Replacement', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            subtitle: Text('OEM grade spare parts installed right in front of you in 35 mins.', style: TextStyle(fontSize: 11)),
          ),
          const ListTile(
            leading: Icon(Icons.verified_user_rounded, color: AppColors.accent),
            title: Text('3. Post-Repair QC & Digital Sign-off', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            subtitle: Text('Customer validates all phone functions & receives 6-month digital warranty.', style: TextStyle(fontSize: 11)),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
