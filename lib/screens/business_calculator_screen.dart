import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum CalculatorType {
  profitMargin,
  markup,
  discount,
  salesTax,
  roi,
  breakEven,
  percentage,
  compoundGrowth,
}

extension CalculatorTypeUi on CalculatorType {
  String get title => switch (this) {
        CalculatorType.profitMargin => 'Profit Margin',
        CalculatorType.markup => 'Markup',
        CalculatorType.discount => 'Discount',
        CalculatorType.salesTax => 'Sales Tax',
        CalculatorType.roi => 'ROI',
        CalculatorType.breakEven => 'Break-even',
        CalculatorType.percentage => 'Percentage',
        CalculatorType.compoundGrowth => 'Growth',
      };

  String get subtitle => switch (this) {
        CalculatorType.profitMargin => 'Profit and margin %',
        CalculatorType.markup => 'Selling markup %',
        CalculatorType.discount => 'Sale price and savings',
        CalculatorType.salesTax => 'Tax amount and total',
        CalculatorType.roi => 'Return on investment',
        CalculatorType.breakEven => 'Units to break even',
        CalculatorType.percentage => 'Find percentage values',
        CalculatorType.compoundGrowth => 'Compound business growth',
      };

  IconData get icon => switch (this) {
        CalculatorType.profitMargin => Icons.trending_up_rounded,
        CalculatorType.markup => Icons.price_change_rounded,
        CalculatorType.discount => Icons.sell_rounded,
        CalculatorType.salesTax => Icons.receipt_long_rounded,
        CalculatorType.roi => Icons.insights_rounded,
        CalculatorType.breakEven => Icons.balance_rounded,
        CalculatorType.percentage => Icons.percent_rounded,
        CalculatorType.compoundGrowth => Icons.stacked_line_chart_rounded,
      };
}

class BusinessCalculatorScreen extends StatefulWidget {
  const BusinessCalculatorScreen({super.key, required this.type});

  final CalculatorType type;

  @override
  State<BusinessCalculatorScreen> createState() => _BusinessCalculatorScreenState();
}

class _BusinessCalculatorScreenState extends State<BusinessCalculatorScreen> {
  late final List<TextEditingController> _controllers;
  Map<String, String>? _results;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_fields.length, (_) => TextEditingController());
  }

  List<_InputField> get _fields => switch (widget.type) {
        CalculatorType.profitMargin => const [
            _InputField('Revenue', 'e.g. 10000'),
            _InputField('Total cost', 'e.g. 6500'),
          ],
        CalculatorType.markup => const [
            _InputField('Cost price', 'e.g. 80'),
            _InputField('Selling price', 'e.g. 120'),
          ],
        CalculatorType.discount => const [
            _InputField('Original price', 'e.g. 250'),
            _InputField('Discount %', 'e.g. 15'),
          ],
        CalculatorType.salesTax => const [
            _InputField('Subtotal', 'e.g. 1000'),
            _InputField('Tax %', 'e.g. 18'),
          ],
        CalculatorType.roi => const [
            _InputField('Investment', 'e.g. 5000'),
            _InputField('Final value', 'e.g. 6500'),
          ],
        CalculatorType.breakEven => const [
            _InputField('Fixed costs', 'e.g. 10000'),
            _InputField('Selling price / unit', 'e.g. 50'),
            _InputField('Variable cost / unit', 'e.g. 30'),
          ],
        CalculatorType.percentage => const [
            _InputField('Value', 'e.g. 1250'),
            _InputField('Percentage %', 'e.g. 12'),
          ],
        CalculatorType.compoundGrowth => const [
            _InputField('Starting amount', 'e.g. 10000'),
            _InputField('Growth rate %', 'e.g. 8'),
            _InputField('Periods', 'e.g. 5'),
          ],
      };

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  double? _valueAt(int index) {
    final text = _controllers[index].text.trim().replaceAll(',', '');
    return double.tryParse(text);
  }

  void _calculate() {
    FocusScope.of(context).unfocus();
    final values = List.generate(_controllers.length, _valueAt);

    if (values.any((value) => value == null)) {
      setState(() {
        _error = 'Enter a valid number in every field.';
        _results = null;
      });
      return;
    }

    final v = values.cast<double>();

    try {
      final result = switch (widget.type) {
        CalculatorType.profitMargin => _profitMargin(v[0], v[1]),
        CalculatorType.markup => _markup(v[0], v[1]),
        CalculatorType.discount => _discount(v[0], v[1]),
        CalculatorType.salesTax => _salesTax(v[0], v[1]),
        CalculatorType.roi => _roi(v[0], v[1]),
        CalculatorType.breakEven => _breakEven(v[0], v[1], v[2]),
        CalculatorType.percentage => _percentage(v[0], v[1]),
        CalculatorType.compoundGrowth => _compoundGrowth(v[0], v[1], v[2]),
      };

      setState(() {
        _error = null;
        _results = result;
      });
    } on ArgumentError catch (e) {
      setState(() {
        _error = e.message?.toString() ?? 'Please check your values.';
        _results = null;
      });
    }
  }

  void _clear() {
    for (final controller in _controllers) {
      controller.clear();
    }
    setState(() {
      _error = null;
      _results = null;
    });
  }

  Map<String, String> _profitMargin(double revenue, double cost) {
    if (revenue == 0) throw ArgumentError('Revenue must be greater than zero.');
    final profit = revenue - cost;
    return {
      'Profit': _number(profit),
      'Profit margin': '${_number((profit / revenue) * 100)}%',
    };
  }

  Map<String, String> _markup(double cost, double sellingPrice) {
    if (cost == 0) throw ArgumentError('Cost price must be greater than zero.');
    final profit = sellingPrice - cost;
    return {
      'Profit': _number(profit),
      'Markup': '${_number((profit / cost) * 100)}%',
    };
  }

  Map<String, String> _discount(double originalPrice, double discountPercent) {
    final savings = originalPrice * (discountPercent / 100);
    return {
      'Final price': _number(originalPrice - savings),
      'You save': _number(savings),
    };
  }

  Map<String, String> _salesTax(double subtotal, double taxPercent) {
    final tax = subtotal * (taxPercent / 100);
    return {
      'Tax amount': _number(tax),
      'Total': _number(subtotal + tax),
    };
  }

  Map<String, String> _roi(double investment, double finalValue) {
    if (investment == 0) throw ArgumentError('Investment must be greater than zero.');
    final netReturn = finalValue - investment;
    return {
      'Net return': _number(netReturn),
      'ROI': '${_number((netReturn / investment) * 100)}%',
    };
  }

  Map<String, String> _breakEven(double fixedCosts, double sellingPrice, double variableCost) {
    final contribution = sellingPrice - variableCost;
    if (contribution <= 0) {
      throw ArgumentError('Selling price must be higher than variable cost per unit.');
    }
    final units = fixedCosts / contribution;
    return {
      'Break-even units': units.ceil().toString(),
      'Contribution / unit': _number(contribution),
    };
  }

  Map<String, String> _percentage(double value, double percentage) {
    return {
      '$percentage% of ${_number(value)}': _number(value * percentage / 100),
      'Remaining after deduction': _number(value - (value * percentage / 100)),
    };
  }

  Map<String, String> _compoundGrowth(double principal, double rate, double periods) {
    if (periods < 0) throw ArgumentError('Periods cannot be negative.');
    final futureValue = principal * math.pow(1 + (rate / 100), periods);
    return {
      'Future value': _number(futureValue),
      'Total growth': _number(futureValue - principal),
    };
  }

  String _number(num value) {
    final fixed = value.toStringAsFixed(2);
    return fixed.endsWith('.00') ? fixed.substring(0, fixed.length - 3) : fixed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.type.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF071A46), Color(0xFF0867E8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.14),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(widget.type.icon, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.type.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.type.subtitle,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(.78),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(_fields.length, (index) {
              final field = _fields[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: TextField(
                  controller: _controllers[index],
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  textInputAction: index == _fields.length - 1
                      ? TextInputAction.done
                      : TextInputAction.next,
                  onSubmitted: (_) {
                    if (index == _fields.length - 1) _calculate();
                  },
                  decoration: InputDecoration(
                    labelText: field.label,
                    hintText: field.hint,
                  ),
                ),
              );
            }),
            if (_error != null) ...[
              const SizedBox(height: 2),
              Text(
                _error!,
                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
            ],
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: _calculate,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(54),
                      backgroundColor: AppTheme.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.calculate_rounded),
                    label: const Text('Calculate', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clear,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(54),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Clear'),
                  ),
                ),
              ],
            ),
            if (_results != null) ...[
              const SizedBox(height: 24),
              _ResultCard(results: _results!),
            ],
          ],
        ),
      ),
    );
  }
}

class _InputField {
  const _InputField(this.label, this.hint);

  final String label;
  final String hint;
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.results});

  final Map<String, String> results;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5ECF7)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D071A46),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: AppTheme.green),
              SizedBox(width: 8),
              Text(
                'Result',
                style: TextStyle(
                  color: AppTheme.navy,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...results.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      entry.key,
                      style: TextStyle(color: Colors.blueGrey.shade600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      entry.value,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: AppTheme.navy,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
