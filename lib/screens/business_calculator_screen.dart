import 'dart:math' as math;

import 'package:flutter/material.dart';

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
        CalculatorType.compoundGrowth =>
          Icons.stacked_line_chart_rounded,
      };

  Color get accent => switch (this) {
        CalculatorType.profitMargin => const Color(0xFF176BEF),
        CalculatorType.markup => const Color(0xFF0DB3A6),
        CalculatorType.discount => const Color(0xFF7657F5),
        CalculatorType.salesTax => const Color(0xFFFF813B),
        CalculatorType.roi => const Color(0xFF10A96B),
        CalculatorType.breakEven => const Color(0xFFE54C78),
        CalculatorType.percentage => const Color(0xFF00A8D8),
        CalculatorType.compoundGrowth => const Color(0xFFF0A000),
      };
}

class BusinessCalculatorScreen extends StatefulWidget {
  const BusinessCalculatorScreen({
    super.key,
    required this.type,
  });

  final CalculatorType type;

  @override
  State<BusinessCalculatorScreen> createState() =>
      _BusinessCalculatorScreenState();
}

class _BusinessCalculatorScreenState
    extends State<BusinessCalculatorScreen> {
  late final List<TextEditingController> _controllers;

  Map<String, String>? _results;
  String? _error;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      _fields.length,
      (_) => TextEditingController(),
    );
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
    final text =
        _controllers[index].text.trim().replaceAll(',', '');

    return double.tryParse(text);
  }

  void _calculate() {
    FocusScope.of(context).unfocus();

    final values =
        List.generate(_controllers.length, _valueAt);

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
        CalculatorType.profitMargin =>
          _profitMargin(v[0], v[1]),
        CalculatorType.markup =>
          _markup(v[0], v[1]),
        CalculatorType.discount =>
          _discount(v[0], v[1]),
        CalculatorType.salesTax =>
          _salesTax(v[0], v[1]),
        CalculatorType.roi =>
          _roi(v[0], v[1]),
        CalculatorType.breakEven =>
          _breakEven(v[0], v[1], v[2]),
        CalculatorType.percentage =>
          _percentage(v[0], v[1]),
        CalculatorType.compoundGrowth =>
          _compoundGrowth(v[0], v[1], v[2]),
      };

      setState(() {
        _error = null;
        _results = result;
      });
    } on ArgumentError catch (e) {
      setState(() {
        _error =
            e.message?.toString() ?? 'Please check your values.';
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

  Map<String, String> _profitMargin(
    double revenue,
    double cost,
  ) {
    if (revenue == 0) {
      throw ArgumentError(
        'Revenue must be greater than zero.',
      );
    }

    final profit = revenue - cost;

    return {
      'Profit': _number(profit),
      'Profit margin':
          '${_number((profit / revenue) * 100)}%',
    };
  }

  Map<String, String> _markup(
    double cost,
    double sellingPrice,
  ) {
    if (cost == 0) {
      throw ArgumentError(
        'Cost price must be greater than zero.',
      );
    }

    final profit = sellingPrice - cost;

    return {
      'Profit': _number(profit),
      'Markup': '${_number((profit / cost) * 100)}%',
    };
  }

  Map<String, String> _discount(
    double originalPrice,
    double discountPercent,
  ) {
    final savings =
        originalPrice * (discountPercent / 100);

    return {
      'Final price':
          _number(originalPrice - savings),
      'You save': _number(savings),
    };
  }

  Map<String, String> _salesTax(
    double subtotal,
    double taxPercent,
  ) {
    final tax = subtotal * (taxPercent / 100);

    return {
      'Tax amount': _number(tax),
      'Total': _number(subtotal + tax),
    };
  }

  Map<String, String> _roi(
    double investment,
    double finalValue,
  ) {
    if (investment == 0) {
      throw ArgumentError(
        'Investment must be greater than zero.',
      );
    }

    final netReturn = finalValue - investment;

    return {
      'Net return': _number(netReturn),
      'ROI':
          '${_number((netReturn / investment) * 100)}%',
    };
  }

  Map<String, String> _breakEven(
    double fixedCosts,
    double sellingPrice,
    double variableCost,
  ) {
    final contribution =
        sellingPrice - variableCost;

    if (contribution <= 0) {
      throw ArgumentError(
        'Selling price must be higher than variable cost per unit.',
      );
    }

    final units = fixedCosts / contribution;

    return {
      'Break-even units': units.ceil().toString(),
      'Contribution / unit': _number(contribution),
    };
  }

  Map<String, String> _percentage(
    double value,
    double percentage,
  ) {
    return {
      '$percentage% of ${_number(value)}':
          _number(value * percentage / 100),
      'Remaining after deduction':
          _number(
        value - (value * percentage / 100),
      ),
    };
  }

  Map<String, String> _compoundGrowth(
    double principal,
    double rate,
    double periods,
  ) {
    if (periods < 0) {
      throw ArgumentError(
        'Periods cannot be negative.',
      );
    }

    final futureValue =
        principal *
        math.pow(
          1 + (rate / 100),
          periods,
        );

    return {
      'Future value': _number(futureValue),
      'Total growth':
          _number(futureValue - principal),
    };
  }

  String _number(num value) {
    final fixed = value.toStringAsFixed(2);

    return fixed.endsWith('.00')
        ? fixed.substring(0, fixed.length - 3)
        : fixed;
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final background = isDark
        ? const Color(0xFF0B1220)
        : const Color(0xFFF4F7FB);

    final card = isDark
        ? const Color(0xFF151F32)
        : Colors.white;

    final primaryText = isDark
        ? Colors.white
        : const Color(0xFF10295A);

    final secondaryText = isDark
        ? const Color(0xFF9AA8BE)
        : const Color(0xFF66758A);

    final accent = widget.type.accent;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: Text(
          widget.type.title,
          style: TextStyle(
            color: primaryText,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.fromLTRB(18, 8, 18, 30),
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: 650),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(26),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF0B255F),
                          accent,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              accent.withValues(alpha: .20),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 62,
                          height: 62,
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withValues(alpha: .14),
                            borderRadius:
                                BorderRadius.circular(19),
                          ),
                          child: Icon(
                            widget.type.icon,
                            color: Colors.white,
                            size: 31,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.type.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight:
                                      FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                widget.type.subtitle,
                                style: TextStyle(
                                  color: Colors.white
                                      .withValues(alpha: .78),
                                  fontSize: 14,
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
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius:
                          BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark
                            ? Colors.white
                                .withValues(alpha: .06)
                            : const Color(0xFFE4EAF3),
                      ),
                    ),
                    child: Column(
                      children: [
                        ...List.generate(
                          _fields.length,
                          (index) {
                            final field = _fields[index];

                            return Padding(
                              padding:
                                  const EdgeInsets.only(
                                bottom: 14,
                              ),
                              child: TextField(
                                controller:
                                    _controllers[index],
                                keyboardType:
                                    const TextInputType
                                        .numberWithOptions(
                                  decimal: true,
                                  signed: true,
                                ),
                                textInputAction:
                                    index ==
                                            _fields.length -
                                                1
                                        ? TextInputAction.done
                                        : TextInputAction.next,
                                onSubmitted: (_) {
                                  if (index ==
                                      _fields.length - 1) {
                                    _calculate();
                                  }
                                },
                                style: TextStyle(
                                  color: primaryText,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                                decoration:
                                    InputDecoration(
                                  labelText: field.label,
                                  hintText: field.hint,
                                  filled: true,
                                  fillColor: isDark
                                      ? const Color(
                                          0xFF101A2C,
                                        )
                                      : const Color(
                                          0xFFF7F9FC,
                                        ),
                                  labelStyle: TextStyle(
                                    color: secondaryText,
                                  ),
                                  hintStyle: TextStyle(
                                    color: secondaryText
                                        .withValues(
                                      alpha: .65,
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Icons
                                        .edit_rounded,
                                    color: accent,
                                    size: 20,
                                  ),
                                  border:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(16),
                                    borderSide:
                                        BorderSide.none,
                                  ),
                                  enabledBorder:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(16),
                                    borderSide:
                                        BorderSide(
                                      color: isDark
                                          ? Colors.white
                                              .withValues(
                                              alpha: .06,
                                            )
                                          : const Color(
                                              0xFFE5EBF4,
                                            ),
                                    ),
                                  ),
                                  focusedBorder:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(16),
                                    borderSide:
                                        BorderSide(
                                      color: accent,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        if (_error != null)
                          Container(
                            width: double.infinity,
                            margin:
                                const EdgeInsets.only(
                              bottom: 14,
                            ),
                            padding:
                                const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.red
                                  .withValues(alpha: .10),
                              borderRadius:
                                  BorderRadius.circular(
                                14,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color:
                                      Colors.redAccent,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _error!,
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.redAccent,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: FilledButton.icon(
                                onPressed: _calculate,
                                style:
                                    FilledButton.styleFrom(
                                  minimumSize:
                                      const Size.fromHeight(
                                    54,
                                  ),
                                  backgroundColor:
                                      accent,
                                  foregroundColor:
                                      Colors.white,
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(16),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons
                                      .calculate_rounded,
                                ),
                                label: const Text(
                                  'Calculate',
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _clear,
                                style:
                                    OutlinedButton.styleFrom(
                                  minimumSize:
                                      const Size.fromHeight(
                                    54,
                                  ),
                                  foregroundColor:
                                      primaryText,
                                  side: BorderSide(
                                    color: isDark
                                        ? Colors.white
                                            .withValues(
                                            alpha: .14,
                                          )
                                        : const Color(
                                            0xFFD8E0EB,
                                          ),
                                  ),
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(16),
                                  ),
                                ),
                                child:
                                    const Text('Clear'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  if (_results != null) ...[
                    const SizedBox(height: 20),
                    _ResultCard(
                      results: _results!,
                      accent: accent,
                      isDark: isDark,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InputField {
  const _InputField(
    this.label,
    this.hint,
  );

  final String label;
  final String hint;
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.results,
    required this.accent,
    required this.isDark,
  });

  final Map<String, String> results;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final primaryText = isDark
        ? Colors.white
        : const Color(0xFF10295A);

    final secondaryText = isDark
        ? const Color(0xFF9AA8BE)
        : const Color(0xFF66758A);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF151F32)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: accent.withValues(alpha: .22),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: .13),
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: accent,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Result',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ...results.entries.map(
            (entry) => Container(
              margin:
                  const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 13,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF101A2C)
                    : const Color(0xFFF7F9FC),
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    entry.value,
                    style: TextStyle(
                      color: accent,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
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