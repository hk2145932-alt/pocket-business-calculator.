import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ai_business_assistant_screen.dart';
import 'business_calculator_screen.dart';
import 'quick_calculator_screen.dart';
import 'settings_screen.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  static const List<CalculatorType> _toolOrder = [
    CalculatorType.profitMargin,
    CalculatorType.markup,
    CalculatorType.salesTax,
    CalculatorType.discount,
    CalculatorType.roi,
    CalculatorType.breakEven,
    CalculatorType.percentage,
    CalculatorType.compoundGrowth,
  ];

  static const List<Color> _toolColors = [
    Color(0xFF2F80ED),
    Color(0xFF00BFA6),
    Color(0xFFFF8A36),
    Color(0xFF7C5CFC),
    Color(0xFF13B878),
    Color(0xFFE94E77),
    Color(0xFF00A8E8),
    Color(0xFFFFB000),
  ];

  Route<void> _route(Widget page) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 80),
      reverseTransitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        final slide = Tween<Offset>(
          begin: const Offset(0.035, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );

        return SlideTransition(
          position: slide,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final isPhone = width < 600;

    final columns = width >= 900
        ? 4
        : width >= 620
            ? 3
            : 2;

    final background =
        isDark ? const Color(0xFF080E1A) : const Color(0xFFF1F5FB);

    final primaryText =
        isDark ? const Color(0xFFF7F9FF) : const Color(0xFF0C2250);

    final secondaryText =
        isDark ? const Color(0xFF8998B1) : const Color(0xFF66758B);

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            // HEADER
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                isPhone ? 16 : 20,
                16,
                isPhone ? 16 : 20,
                6,
              ),
              sliver: SliverToBoxAdapter(
                child: _Header(
                  isDark: isDark,
                  width: width,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                  onThemeTap: () {
                    onThemeChanged(
                      isDark ? ThemeMode.light : ThemeMode.dark,
                    );
                  },
                  onSettingsTap: () {
                    Navigator.push(
                      context,
                      _route(
                        SettingsScreen(
                          themeMode: themeMode,
                          onThemeChanged: onThemeChanged,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // QUICK CALCULATOR
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                isPhone ? 16 : 20,
                16,
                isPhone ? 16 : 20,
                10,
              ),
              sliver: SliverToBoxAdapter(
                child: RepaintBoundary(
                  child: _QuickCalculatorCard(
                    compact: isPhone,
                    onTap: () {
                      Navigator.push(
                        context,
                        _route(
                          const QuickCalculatorScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            // AI BUSINESS ASSISTANT
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                isPhone ? 16 : 20,
                4,
                isPhone ? 16 : 20,
                8,
              ),
              sliver: SliverToBoxAdapter(
                child: RepaintBoundary(
                  child: _AiPremiumCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        _route(
                          const AiBusinessAssistantScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // BUSINESS TOOLS TITLE
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                isPhone ? 16 : 20,
                18,
                isPhone ? 16 : 20,
                13,
              ),
              sliver: SliverToBoxAdapter(
                child: _SectionHeader(
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                ),
              ),
            ),

            // BUSINESS TOOLS GRID
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                isPhone ? 16 : 20,
                0,
                isPhone ? 16 : 20,
                28,
              ),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: isPhone ? 12 : 16,
                  crossAxisSpacing: isPhone ? 12 : 16,
                  mainAxisExtent: isPhone ? 170 : 180,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final type = _toolOrder[index];
                    final accent = _toolColors[index];

                    return RepaintBoundary(
                      child: _ToolCard(
                        number:
                            (index + 1).toString().padLeft(2, '0'),
                        title: type.title,
                        subtitle: type.subtitle,
                        icon: type.icon,
                        accent: accent,
                        isDark: isDark,
                        onTap: () {
                          Navigator.push(
                            context,
                            _route(
                              BusinessCalculatorScreen(
                                type: type,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  childCount: _toolOrder.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.isDark,
    required this.width,
    required this.primaryText,
    required this.secondaryText,
    required this.onThemeTap,
    required this.onSettingsTap,
  });

  final bool isDark;
  final double width;
  final Color primaryText;
  final Color secondaryText;
  final VoidCallback onThemeTap;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    final tight = width < 390;

    return Row(
      children: [
        _Logo3D(
          isDark: isDark,
          compact: tight,
        ),

        SizedBox(
          width: tight ? 10 : 13,
        ),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tight
                    ? 'Pocket Business'
                    : 'CalcPro Business',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: primaryText,
                  fontSize: tight ? 16 : 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.35,
                ),
              ),

              if (!tight) ...[
                const SizedBox(height: 3),
                Text(
                  'Business math, simplified.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(width: 8),

        _RoundButton(
          tooltip: isDark
              ? 'Light mode'
              : 'Dark mode',
          isDark: isDark,
          onTap: onThemeTap,
          child: Icon(
            isDark
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            color: isDark
                ? const Color(0xFFFFC84A)
                : const Color(0xFF246FEF),
            size: 21,
          ),
        ),

        const SizedBox(width: 7),

        _RoundButton(
          tooltip: 'Settings',
          isDark: isDark,
          onTap: onSettingsTap,
          child: Icon(
            Icons.settings_rounded,
            color: primaryText,
            size: 21,
          ),
        ),
      ],
    );
  }
}

class _QuickCalculatorCard extends StatelessWidget {
  const _QuickCalculatorCard({
    required this.compact,
    required this.onTap,
  });

  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Pressable(
      onTap: onTap,
      child: Container(
        height: compact ? 132 : 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),

          gradient: const LinearGradient(
            colors: [
              Color(0xFF071B4A),
              Color(0xFF104FAF),
              Color(0xFF2477F4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),

          border: Border.all(
            color: Colors.white.withValues(
              alpha: .10,
            ),
          ),

          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2475F5)
                  .withValues(
                alpha: .13,
              ),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: Stack(
          children: [
            Positioned(
              right: -44,
              top: -56,
              child: Container(
                width: 165,
                height: 165,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(
                    alpha: .045,
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(
                compact ? 18 : 21,
              ),
              child: Row(
                children: [
                  const _CalculatorCube(),

                  SizedBox(
                    width: compact ? 15 : 19,
                  ),

                  const Expanded(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Calculator',
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight:
                                FontWeight.w900,
                            letterSpacing: -0.4,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          'Fast everyday calculations',
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: .10,
                      ),
                      borderRadius:
                          BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AiPremiumCard extends StatelessWidget {
  const _AiPremiumCard({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),

          gradient: const LinearGradient(
            colors: [
              Color(0xFF24104F),
              Color(0xFF6536E8),
              Color(0xFF2D70F5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),

          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6536E8)
                  .withValues(
                alpha: .11,
              ),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: .13,
                ),
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 29,
              ),
            ),

            const SizedBox(width: 14),

            const Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Business Assistant',
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    'Smart business help powered by AI',
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: .13,
                ),
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_rounded,
                    color: Color(0xFFFFD65C),
                    size: 13,
                  ),

                  SizedBox(width: 4),

                  Text(
                    'PRO',
                    style: TextStyle(
                      color:
                          Color(0xFFFFD65C),
                      fontSize: 10,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.primaryText,
    required this.secondaryText,
  });

  final Color primaryText;
  final Color secondaryText;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Business Tools',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 22,
                  fontWeight:
                      FontWeight.w900,
                  letterSpacing: -0.45,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                'Everything you need for daily business calculations',
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),

          decoration: BoxDecoration(
            color: const Color(0xFF2475F5)
                .withValues(
              alpha: .10,
            ),
            borderRadius:
                BorderRadius.circular(18),
          ),

          child: const Text(
            '8 tools',
            style: TextStyle(
              color: Color(0xFF2475F5),
              fontWeight: FontWeight.w800,
              fontSize: 10.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _Logo3D extends StatelessWidget {
  const _Logo3D({
    required this.isDark,
    required this.compact,
  });

  final bool isDark;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 48.0 : 54.0;

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(3),

      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(17),

        color: isDark
            ? const Color(0xFF162238)
            : Colors.white,

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? .15 : .06,
            ),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(14),
        child: Image.asset(
          'assets/images/app_icon.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _CalculatorCube extends StatelessWidget {
  const _CalculatorCube();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 66,
      height: 66,
      alignment: Alignment.center,

      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(20),

        gradient: const LinearGradient(
          colors: [
            Color(0xFF496FAE),
            Color(0xFF213F75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        border: Border.all(
          color: Colors.white.withValues(
            alpha: .13,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: .10,
            ),
            blurRadius: 7,
            offset: const Offset(3, 4),
          ),
        ],
      ),

      child: const Icon(
        Icons.calculate_rounded,
        color: Colors.white,
        size: 33,
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.child,
    required this.onTap,
    required this.isDark,
    required this.tooltip,
  });

  final Widget child;
  final VoidCallback onTap;
  final bool isDark;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,

      child: _Pressable(
        onTap: onTap,

        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,

          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF151F32)
                : const Color(0xFFF8FAFE),

            borderRadius:
                BorderRadius.circular(14),

            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(
                      alpha: .045,
                    )
                  : Colors.white,
            ),

            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withValues(
                  alpha:
                      isDark ? .14 : .05,
                ),
                blurRadius: 6,
                offset:
                    const Offset(2, 3),
              ),
            ],
          ),

          child: child,
        ),
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.isDark,
    required this.onTap,
  });

  final String number;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final card = isDark
        ? const Color(0xFF151F32)
        : const Color(0xFFF8FAFE);

    final titleColor = isDark
        ? Colors.white
        : const Color(0xFF10295A);

    final subColor = isDark
        ? const Color(0xFF8E9BB0)
        : const Color(0xFF718096);

    return _Pressable(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: card,

          borderRadius:
              BorderRadius.circular(22),

          border: Border.all(
            color: isDark
                ? Colors.white.withValues(
                    alpha: .045,
                  )
                : Colors.white,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha:
                    isDark ? .14 : .05,
              ),
              blurRadius: 7,
              offset:
                  const Offset(3, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _IconCube(
                  icon: icon,
                  accent: accent,
                ),

                const Spacer(),

                Text(
                  number,
                  style: TextStyle(
                    color: accent.withValues(
                      alpha: .48,
                    ),
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ],
            ),

            const Spacer(),

            Text(
              title,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              style: TextStyle(
                color: titleColor,
                fontSize: 16,
                fontWeight:
                    FontWeight.w900,
                letterSpacing: -0.25,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              subtitle,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              style: TextStyle(
                color: subColor,
                fontSize: 11.5,
              ),
            ),

            const SizedBox(height: 9),

            Row(
              children: [
                Text(
                  'Open tool',
                  style: TextStyle(
                    color: accent,
                    fontSize: 10.5,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(width: 4),

                Icon(
                  Icons.arrow_forward_rounded,
                  color: accent,
                  size: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IconCube extends StatelessWidget {
  const _IconCube({
    required this.icon,
    required this.accent,
  });

  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accent.withValues(
              alpha: .20,
            ),
            accent.withValues(
              alpha: .08,
            ),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius:
            BorderRadius.circular(15),

        border: Border.all(
          color: accent.withValues(
            alpha: .15,
          ),
        ),
      ),

      child: Icon(
        icon,
        color: accent,
        size: 24,
      ),
    );
  }
}

class _Pressable extends StatefulWidget {
  const _Pressable({
    required this.child,
    required this.onTap,
  });

  final Widget child;
  final VoidCallback onTap;

  @override
  State<_Pressable> createState() =>
      _PressableState();
}

class _PressableState
    extends State<_Pressable> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value || !mounted) {
      return;
    }

    setState(() {
      _pressed = value;
    });
  }

  void _tap() {
    HapticFeedback.selectionClick();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,

      child: GestureDetector(
        behavior: HitTestBehavior.opaque,

        onTapDown: (_) {
          _setPressed(true);
        },

        onTapCancel: () {
          _setPressed(false);
        },

        onTapUp: (_) {
          _setPressed(false);
        },

        onTap: _tap,

        child: AnimatedScale(
          scale: _pressed
              ? 0.995
              : 1.0,

          duration:
              const Duration(
            milliseconds: 35,
          ),

          curve: Curves.easeOutCubic,

          child: widget.child,
        ),
      ),
    );
  }
}