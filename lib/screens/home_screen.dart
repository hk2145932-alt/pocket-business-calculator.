import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/business_tool_card.dart';
import 'business_calculator_screen.dart';
import 'quick_calculator_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              sliver: SliverToBoxAdapter(child: _Header()),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              sliver: SliverToBoxAdapter(child: _QuickCalculatorBanner()),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Business tools',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppTheme.navy,
                      ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              sliver: SliverGrid(
             gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 340,
  mainAxisExtent: 165,
  mainAxisSpacing: 14,
  crossAxisSpacing: 14,
),
                
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final type = CalculatorType.values[index];
                    return BusinessToolCard(
                      title: type.title,
                      subtitle: type.subtitle,
                      icon: type.icon,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BusinessCalculatorScreen(type: type),
                        ),
                      ),
                    );
                  },
                  childCount: CalculatorType.values.length,
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
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(
            'assets/images/app_logo.png',
            width: 58,
            height: 58,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pocket Business Calculator',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.navy,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Business math, simplified.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.blueGrey.shade600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickCalculatorBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const QuickCalculatorScreen()),
      ),
      child: Ink(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [Color(0xFF071A46), Color(0xFF0867E8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.blue.withOpacity(.18),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.14),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.calculate_rounded, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Calculator',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Fast everyday calculations',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(.78),
                        ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 18),
          ],
        ),
      ),
    );
  }
}
