import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ai_business_assistant_screen.dart';

class SettingsScreen extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });
  String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (entry) =>
              '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}',
        )
        .join('&');
  }

  Future<void> _sendFeedback(BuildContext context) async {
    const supportEmail = 'i.laiba0348@gmail.com';

    final emailUri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: _encodeQueryParameters({
        'subject': 'CalcPro Business Feedback',
        'body':
            'Hi,\n\nI would like to share some feedback about CalcPro Business:\n\n',
      }),
    );

    final opened = await launchUrl(emailUri);

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No email app found on this device.'),
        ),
      );
    }
  }

  Future<void> _shareApp() async {
    await SharePlus.instance.share(
      ShareParams(
        title: 'CalcPro Business',
        subject: 'CalcPro Business',
        text:
            'Check out CalcPro Business — smart tools for profit margin, markup, tax, discount, ROI, break-even and more.',
      ),
    );
  }

  Future<void> _rateApp(BuildContext context) async {
    final uri = Uri.parse(
      'https://play.google.com/store/search?q=Pocket%20Business%20Calculator&c=apps',
    );

    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open Google Play Store.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showHelp(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Help & Support'),
          content: const SingleChildScrollView(
            child: Text(
              'CalcPro Business helps you with everyday '
              'business calculations such as profit margin, markup, '
              'sales tax, discount, ROI, break-even and percentages.\n\n'
              'If you need help or want to report a problem, use '
              'Send Feedback to contact our support team.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _sendFeedback(context);
              },
              child: const Text('Contact Support'),
            ),
          ],
        );
      },
    );
  }
void _showPrivacyPolicy(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'CalcPro Business is designed to provide '
            'business calculation tools.\n\n'
            'The basic calculator features do not require you to '
            'create an account.\n\n'
            'Your calculator inputs are used to perform calculations '
            'within the app.\n\n'
            'If you contact us by email, the information you provide '
            'may be used to respond to your request.\n\n'
            'Privacy contact:\n'
            'i.laiba0348@gmail.com',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final background =
        isDark ? const Color(0xFF08111F) : const Color(0xFFF2F6FC);

    final cardColor = isDark ? const Color(0xFF131E31) : Colors.white;

    final primaryText =
        isDark ? const Color(0xFFF7F9FF) : const Color(0xFF10295A);

    final secondaryText =
        isDark ? const Color(0xFF8E9BB0) : const Color(0xFF718096);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Settings',
          style: TextStyle(
            color: primaryText,
            fontWeight: FontWeight.w900,
            fontSize: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            18,
            8,
            18,
            32,
          ),
          children: [
            // TOP APP HERO
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0B2E70),
                    Color(0xFF176BEF),
                    Color(0xFF43A4FF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF176BEF).withValues(alpha: .18),
                    blurRadius: 16,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        'assets/images/app_icon.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pocket Business',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Calculator',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          'Smart business tools in your pocket',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Upgrade your experience',
              style: TextStyle(
                color: primaryText,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 12),

            // PREMIUM HERO
            InkWell(
              borderRadius: BorderRadius.circular(26),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AiBusinessAssistantScreen(),
                  ),
                );
              },
              child: Ink(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF271154),
                      Color(0xFF6336E5),
                      Color(0xFF3178FF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6336E5).withValues(alpha: .18),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: .14,
                        ),
                        borderRadius: BorderRadius.circular(18),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'AI Business Assistant',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(width: 8),
                              _ProBadge(),
                            ],
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Get smarter calculations and business help',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white70,
                      size: 17,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 26),

            Text(
              'Quick actions',
              style: TextStyle(
                color: primaryText,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 12),

            // ACTION GRID
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.45,
              children: [
                _ActionCard(
                  icon: Icons.feedback_rounded,
                  title: 'Feedback',
                  subtitle: 'Tell us what you think',
                  accent: const Color(0xFF2F80ED),
                  cardColor: cardColor,
                  titleColor: primaryText,
                  subtitleColor: secondaryText,
                  onTap: () {
                    _sendFeedback(context);
                  },
                ),
                _ActionCard(
                  icon: Icons.star_rounded,
                  title: 'Rate App',
                  subtitle: 'Support us',
                  accent: const Color(0xFFFFB000),
                  cardColor: cardColor,
                  titleColor: primaryText,
                  subtitleColor: secondaryText,
                  onTap: () {
                    _rateApp(context);
                  },
                ),
                _ActionCard(
                  icon: Icons.share_rounded,
                  title: 'Share',
                  subtitle: 'Tell your friends',
                  accent: const Color(0xFF13B878),
                  cardColor: cardColor,
                  titleColor: primaryText,
                  subtitleColor: secondaryText,
                  onTap: () {
                    _shareApp();
                  },
                ),
                _ActionCard(
                  icon: Icons.help_outline_rounded,
                  title: 'Help',
                  subtitle: 'Get support',
                  accent: const Color(0xFF7C5CFC),
                  cardColor: cardColor,
                  titleColor: primaryText,
                  subtitleColor: secondaryText,
                  onTap: () {
                    _showHelp(context);
                  },
                ),
              ],
            ),

            const SizedBox(height: 26),

            Text(
              'Information',
              style: TextStyle(
                color: primaryText,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: .04,
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _InfoTile(
                    icon: Icons.privacy_tip_outlined,
                    iconColor: const Color(0xFF00A8E8),
                    title: 'Privacy Policy',
                    titleColor: primaryText,
                    subtitleColor: secondaryText,
                    onTap: () {
                      _showPrivacyPolicy(context);
                    },
                  ),
                  _Divider(isDark: isDark),
                  _InfoTile(
                    icon: Icons.description_outlined,
                    iconColor: const Color(0xFFE94E77),
                    title: 'Terms of Service',
                    titleColor: primaryText,
                    subtitleColor: secondaryText,
                    onTap: () {
                      _showTermsOfService(context);
                    },
                  ),
                  _Divider(isDark: isDark),
                  _InfoTile(
                    icon: Icons.info_outline_rounded,
                    iconColor: const Color(0xFF7C5CFC),
                    title: 'App Version',
                    titleColor: primaryText,
                    subtitleColor: secondaryText,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C5CFC).withValues(alpha: .10),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '1.0.0',
                        style: TextStyle(
                          color: Color(0xFF7C5CFC),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            Center(
              child: Text(
                'Made for smarter business decisions',
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showTermsOfService(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'By using CalcPro Business, you agree to use '
            'the application responsibly and for lawful purposes.\n\n'
            'The calculations provided by the app are intended for '
            'general informational and business-planning purposes. '
            'You should verify important financial, tax, accounting '
            'or business decisions with a qualified professional.\n\n'
            'The app is provided as a calculation tool and does not '
            'constitute financial, tax, legal or accounting advice.\n\n'
            'For questions or support, contact:\n'
            'i.laiba0348@gmail.com',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

class _ProBadge extends StatelessWidget {
  const _ProBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD65C).withValues(alpha: .16),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'PRO',
        style: TextStyle(
          color: Color(0xFFFFD65C),
          fontSize: 9,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.cardColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final Color cardColor;
  final Color titleColor;
  final Color subtitleColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                color: accent,
                size: 21,
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                color: titleColor,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: subtitleColor,
                fontSize: 10.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.titleColor,
    required this.subtitleColor,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final Color titleColor;
  final Color subtitleColor;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: .11),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 21,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: trailing ??
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: subtitleColor,
          ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 70,
      color: isDark
          ? Colors.white.withValues(alpha: .06)
          : Colors.black.withValues(alpha: .05),
    );
  }
}
