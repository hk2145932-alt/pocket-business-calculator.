import 'package:flutter/material.dart';

class PremiumPaywallScreen extends StatefulWidget {
  const PremiumPaywallScreen({super.key});

  @override
  State<PremiumPaywallScreen> createState() =>
      _PremiumPaywallScreenState();
}

class _PremiumPaywallScreenState extends State<PremiumPaywallScreen> {
  bool yearlySelected = true;

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final background = isDark
        ? const Color(0xFF080E1A)
        : const Color(0xFFF3F6FC);

    final card = isDark
        ? const Color(0xFF151F32)
        : Colors.white;

    final primaryText =
        isDark ? Colors.white : const Color(0xFF10295A);

    final secondaryText = isDark
        ? const Color(0xFF95A3B8)
        : const Color(0xFF6B7A90);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: const Text(
          'Premium',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF7447F7),
                          Color(0xFF3478F6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6536E8)
                              .withValues(alpha: .28),
                          blurRadius: 26,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                      color: Colors.white,
                      size: 44,
                    ),
                  ),

                  const SizedBox(height: 22),

                  Text(
                    'Unlock AI Premium',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Get full access to your AI Business Assistant and smarter business tools.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 28),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: .06)
                            : const Color(0xFFE5EBF4),
                      ),
                    ),
                    child: Column(
                      children: [
                        _Benefit(
                          icon: Icons.auto_awesome_rounded,
                          text: 'AI Business Assistant',
                          isDark: isDark,
                        ),
                        _Benefit(
                          icon: Icons.calculate_rounded,
                          text: 'Smart business calculations',
                          isDark: isDark,
                        ),
                        _Benefit(
                          icon: Icons.insights_rounded,
                          text: 'Business insights and explanations',
                          isDark: isDark,
                        ),
                        _Benefit(
                          icon: Icons.lightbulb_rounded,
                          text: 'AI suggestions based on your numbers',
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: _PlanCard(
                          title: 'Monthly',
                          subtitle: 'Store price',
                          selected: !yearlySelected,
                          isDark: isDark,
                          onTap: () {
                            setState(() {
                              yearlySelected = false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _PlanCard(
                          title: 'Yearly',
                          subtitle: 'Store price',
                          badge: 'BEST VALUE',
                          selected: yearlySelected,
                          isDark: isDark,
                          onTap: () {
                            setState(() {
                              yearlySelected = true;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),
const Padding(
  padding: EdgeInsets.only(bottom: 16),
  child: Text(
    '7 days free • Cancel anytime during the trial',
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Color(0xFF9AA8BE),
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
  ),
),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: FilledButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Google Play / App Store payment will be connected next.',
                            ),
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
                      child: Text(
                        'Start 7-Day Free Trial',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () {},
                    child: const Text('Restore Purchase'),
                  ),

                  Text(
                    'Cancel anytime. Store billing terms will apply.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 11,
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

class _Benefit extends StatelessWidget {
  const _Benefit({
    required this.icon,
    required this.text,
    required this.isDark,
  });

  final IconData icon;
  final String text;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF6536E8)
                  .withValues(alpha: .12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF7447F7),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isDark
                    ? Colors.white
                    : const Color(0xFF10295A),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF14B87A),
            size: 21,
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.isDark,
    required this.onTap,
    this.badge,
  });

  final String title;
  final String subtitle;
  final String? badge;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF6536E8)
                  .withValues(alpha: .12)
              : isDark
                  ? const Color(0xFF151F32)
                  : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected
                ? const Color(0xFF7447F7)
                : isDark
                    ? Colors.white.withValues(alpha: .06)
                    : const Color(0xFFE5EBF4),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC857),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    color: Color(0xFF3B2B00),
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 9),
            ],
            Text(
              title,
              style: TextStyle(
                color: isDark
                    ? Colors.white
                    : const Color(0xFF10295A),
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFF7C8AA0),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}