import 'package:flutter/material.dart';

class QuickCalculatorScreen extends StatefulWidget {
  const QuickCalculatorScreen({super.key});

  @override
  State<QuickCalculatorScreen> createState() =>
      _QuickCalculatorScreenState();
}

class _QuickCalculatorScreenState extends State<QuickCalculatorScreen> {
  String _display = '0';
  String _expression = '';

  double? _storedValue;
  String? _operator;

  bool _replaceDisplay = false;
  bool _justEvaluated = false;

  void _tap(String key) {
    setState(() {
      if ('0123456789.'.contains(key)) {
        _inputNumber(key);
        return;
      }

      switch (key) {
        case 'AC':
          _clear();
          break;

        case '⌫':
          _backspace();
          break;

        case '+/−':
          _toggleSign();
          break;

        case '%':
          _percentage();
          break;

        case '+':
        case '−':
        case '×':
        case '÷':
          _chooseOperator(key);
          break;

        case '=':
          _equals();
          break;
      }
    });
  }

  void _clear() {
    _display = '0';
    _expression = '';
    _storedValue = null;
    _operator = null;
    _replaceDisplay = false;
    _justEvaluated = false;
  }

  void _inputNumber(String key) {
    if (_justEvaluated) {
      _display = key == '.' ? '0.' : key;
      _expression = '';
      _storedValue = null;
      _operator = null;
      _replaceDisplay = false;
      _justEvaluated = false;
      return;
    }

    if (_replaceDisplay) {
      _display = key == '.' ? '0.' : key;
      _replaceDisplay = false;
      return;
    }

    if (key == '.' && _display.contains('.')) {
      return;
    }

    if (_display == '0' && key != '.') {
      _display = key;
    } else if (_display.length < 14) {
      _display += key;
    }
  }

  void _backspace() {
    if (_display == 'Error') {
      _clear();
      return;
    }

    if (_justEvaluated) {
      _justEvaluated = false;
    }

    if (_replaceDisplay) {
      _display = '0';
      return;
    }

    if (_display.length > 1) {
      _display = _display.substring(0, _display.length - 1);
    } else {
      _display = '0';
    }
  }

  void _toggleSign() {
    if (_display == '0' || _display == 'Error') {
      return;
    }

    _display = _format(-_currentValue);
    _justEvaluated = false;
  }

  void _percentage() {
    if (_display == 'Error') {
      return;
    }

    _display = _format(_currentValue / 100);
    _replaceDisplay = true;
    _justEvaluated = false;
  }

  void _chooseOperator(String operator) {
    if (_display == 'Error') {
      _clear();
      return;
    }

    if (_storedValue != null &&
        _operator != null &&
        !_replaceDisplay) {
      final result = _calculate(
        _storedValue!,
        _currentValue,
        _operator!,
      );

      if (result == null) {
        _display = 'Error';
        _expression = '';
        _storedValue = null;
        _operator = null;
        _replaceDisplay = true;
        return;
      }

      _display = _format(result);
      _storedValue = result;
    } else if (_storedValue == null) {
      _storedValue = _currentValue;
    }

    _operator = operator;
    _replaceDisplay = true;
    _justEvaluated = false;

    _expression = '${_format(_storedValue!)} $operator';
  }

  void _equals() {
    if (_storedValue == null || _operator == null) {
      return;
    }

    final left = _storedValue!;
    final right = _currentValue;
    final operation = _operator!;

    final result = _calculate(left, right, operation);

    if (result == null) {
      _display = 'Error';
      _expression = '';
      _storedValue = null;
      _operator = null;
      _replaceDisplay = true;
      return;
    }

    _expression =
        '${_format(left)} $operation ${_format(right)} =';

    _display = _format(result);

    _storedValue = null;
    _operator = null;
    _replaceDisplay = true;
    _justEvaluated = true;
  }

  double? _calculate(
    double left,
    double right,
    String operator,
  ) {
    switch (operator) {
      case '+':
        return left + right;

      case '−':
        return left - right;

      case '×':
        return left * right;

      case '÷':
        if (right == 0) {
          return null;
        }
        return left / right;

      default:
        return null;
    }
  }

  double get _currentValue {
    return double.tryParse(_display) ?? 0;
  }

  String _format(double value) {
    if (value.isNaN || value.isInfinite) {
      return 'Error';
    }

    final text = value.toStringAsFixed(8);

    return text.replaceFirst(
      RegExp(r'\.?0+$'),
      '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final background = isDark
        ? const Color(0xFF08111F)
        : const Color(0xFFF4F7FB);

    final numberColor = isDark
        ? const Color(0xFF17243A)
        : Colors.white;

    final utilityColor = isDark
        ? const Color(0xFF24334D)
        : const Color(0xFFE3EAF4);

    final operatorColor = isDark
        ? const Color(0xFF2475F5)
        : const Color(0xFF176BEF);

    const selectedOperatorColor =
        Color(0xFFFFA000);

    const equalsColor =
        Color(0xFF16B981);

    final primaryText =
        isDark ? Colors.white : const Color(0xFF122033);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Quick Calculator',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            12,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact =
                  constraints.maxHeight < 620;

              final displayHeight =
                  compact ? 125.0 : 145.0;

              final gap =
                  compact ? 8.0 : 10.0;

              final availableGridHeight =
                  constraints.maxHeight -
                      displayHeight -
                      gap;

              final cellWidth =
                  (constraints.maxWidth -
                          (gap * 3)) /
                      4;

              final maxCellHeight =
                  (availableGridHeight -
                          (gap * 4)) /
                      5;

              final cellHeight =
                  cellWidth < maxCellHeight
                      ? cellWidth
                      : maxCellHeight;

              final aspectRatio =
                  cellWidth / cellHeight;

              const buttons = [
                'AC',
                '⌫',
                '%',
                '÷',
                '7',
                '8',
                '9',
                '×',
                '4',
                '5',
                '6',
                '−',
                '1',
                '2',
                '3',
                '+',
                '+/−',
                '0',
                '.',
                '=',
              ];

              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: displayHeight,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF12377F),
                          Color(0xFF2475F5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                          BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2475F5)
                              .withValues(alpha: 0.18),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white
                                    .withValues(alpha: 0.14),
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'STANDARD',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight:
                                      FontWeight.w800,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        if (_expression.isNotEmpty)
                          Padding(
                            padding:
                                const EdgeInsets.only(
                              bottom: 5,
                            ),
                            child: Text(
                              _expression,
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment:
                              Alignment.centerRight,
                          child: Text(
                            _display,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 52,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: gap),

                  Expanded(
                    child: Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(),
                          itemCount: buttons.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: gap,
                            crossAxisSpacing: gap,
                            childAspectRatio:
                                aspectRatio,
                          ),
                          itemBuilder:
                              (context, index) {
                            final key =
                                buttons[index];

                            final isOperator = [
                              '÷',
                              '×',
                              '−',
                              '+',
                            ].contains(key);

                            final isEquals =
                                key == '=';

                            final isUtility = [
                              'AC',
                              '⌫',
                              '%',
                            ].contains(key);

                            final isSelected =
                                isOperator &&
                                    _operator == key &&
                                    _storedValue != null;

                            Color buttonColor;

                            if (isEquals) {
                              buttonColor =
                                  equalsColor;
                            } else if (isSelected) {
                              buttonColor =
                                  selectedOperatorColor;
                            } else if (isOperator) {
                              buttonColor =
                                  operatorColor;
                            } else if (isUtility) {
                              buttonColor =
                                  utilityColor;
                            } else {
                              buttonColor =
                                  numberColor;
                            }

                            final foreground =
                                isOperator ||
                                        isEquals
                                    ? Colors.white
                                    : primaryText;

                            return _CalcButton(
                              label: key,
                              background:
                                  buttonColor,
                              foreground:
                                  foreground,
                              selected:
                                  isSelected,
                              onTap: () =>
                                  _tap(key),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CalcButton extends StatelessWidget {
  const _CalcButton({
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
    this.selected = false,
  });

  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final isBackspace = label == '⌫';

    return Material(
      color: background,
      elevation: selected ? 4 : 1,
      shadowColor:
          Colors.black.withValues(alpha: 0.22),
      borderRadius:
          BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(22),
        splashColor:
            Colors.white.withValues(alpha: 0.18),
        highlightColor:
            Colors.white.withValues(alpha: 0.08),
        child: Center(
          child: isBackspace
              ? Icon(
                  Icons.backspace_rounded,
                  color: foreground,
                  size: 27,
                )
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: foreground,
                      fontSize:
                          label == '+/−'
                              ? 20
                              : 25,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}