import 'package:flutter/material.dart';

import 'premium_paywall_screen.dart';

class AiBusinessAssistantScreen extends StatelessWidget {
  const AiBusinessAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final background = isDark
        ? const Color(0xFF080E1A)
        : const Color(0xFFF3F6FC);

    final cardColor = isDark
        ? const Color(0xFF151F32)
        : Colors.white;

    final primaryText = isDark
        ? Colors.white
        : const Color(0xFF10295A);

    final secondaryText = isDark
        ? const Color(0xFF95A3B8)
        : const Color(0xFF6B7A90);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: Text(
          'AI Business Assistant',
          style: TextStyle(
            color: primaryText,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF25135A),
                          Color(0xFF6536E8),
                          Color(0xFF2B7CFF),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6536E8)
                              .withValues(alpha: .28),
                          blurRadius: 30,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 78,
                          height: 78,
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withValues(alpha: .14),
                            borderRadius:
                                BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'AI Business Assistant',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Ask business questions, calculate smarter and understand your numbers with AI.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withValues(alpha: .14),
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.lock_rounded,
                                color: Color(0xFFFFD65C),
                                size: 17,
                              ),
                              SizedBox(width: 6),
                              Text(
                                '7-DAY FREE TRIAL',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [
                        _FeatureRow(
                          icon:
                              Icons.chat_bubble_outline_rounded,
                          title: 'Ask in natural language',
                          subtitle:
                              'Describe your business problem normally.',
                          isDark: isDark,
                        ),
                        const SizedBox(height: 18),
                        _FeatureRow(
                          icon: Icons.calculate_outlined,
                          title: 'Smart calculations',
                          subtitle:
                              'Profit, pricing, ROI, growth and more.',
                          isDark: isDark,
                        ),
                        const SizedBox(height: 18),
                        _FeatureRow(
                          icon: Icons.insights_rounded,
                          title: 'Business explanations',
                          subtitle:
                              'Understand what your results actually mean.',
                          isDark: isDark,
                        ),
                        const SizedBox(height: 18),
                        _FeatureRow(
                          icon:
                              Icons.lightbulb_outline_rounded,
                          title: 'AI suggestions',
                          subtitle:
                              'Get useful ideas based on your numbers.',
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder<void>(
                            transitionDuration:
                                const Duration(
                              milliseconds: 100,
                            ),
                            reverseTransitionDuration:
                                const Duration(
                              milliseconds: 280,
                            ),
                            pageBuilder:
                                (_, animation, __) =>
                                    const PremiumPaywallScreen(),
                            transitionsBuilder:
                                (_, animation, __, child) {
                              final curved =
                                  CurvedAnimation(
                                parent: animation,
                                curve:
                                    Curves.easeOutCubic,
                                reverseCurve:
                                    Curves.easeInOutCubic,
                              );

                              return FadeTransition(
                                opacity: curved,
                                child: SlideTransition(
                                  position:
                                      Tween<Offset>(
                                    begin:
                                        const Offset(
                                      0.01,
                                      0,
                                    ),
                                    end:
                                        Offset.zero,
                                  ).animate(curved),
                                  child: child,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF6536E8),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                      ),
                      icon: const Icon(
                        Icons.workspace_premium_rounded,
                      ),
                      label: const Text(
                        'Start 7-Day Free Trial',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    '7 days free. Continue with a paid plan after the trial.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF6536E8)
                .withValues(alpha: .12),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF7B50F4),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isDark
                      ? Colors.white
                      : const Color(0xFF10295A),
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFF95A3B8)
                      : const Color(0xFF6B7A90),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}