import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class QuickCalculatorScreen extends StatefulWidget {
  const QuickCalculatorScreen({super.key});

  @override
  State<QuickCalculatorScreen> createState() => _QuickCalculatorScreenState();
}

class _QuickCalculatorScreenState extends State<QuickCalculatorScreen> {
  String _display = '0';
  double? _storedValue;
  String? _operator;
  bool _replaceDisplay = false;

  void _tap(String key) {
    setState(() {
      if ('0123456789.'.contains(key)) {
        _inputNumber(key);
        return;
      }

      switch (key) {
        case 'AC':
          _display = '0';
          _storedValue = null;
          _operator = null;
          _replaceDisplay = false;
          break;
        case '⌫':
          if (!_replaceDisplay && _display.length > 1) {
            _display = _display.substring(0, _display.length - 1);
          } else {
            _display = '0';
          }
          break;
        case '+/−':
          final value = _currentValue;
          _display = _format(-value);
          break;
        case '%':
          _display = _format(_currentValue / 100);
          _replaceDisplay = true;
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

  void _inputNumber(String key) {
    if (_replaceDisplay) {
      _display = key == '.' ? '0.' : key;
      _replaceDisplay = false;
      return;
    }

    if (key == '.' && _display.contains('.')) return;
    if (_display == '0' && key != '.') {
      _display = key;
    } else if (_display.length < 14) {
      _display += key;
    }
  }

  void _chooseOperator(String operator) {
    if (_storedValue != null && !_replaceDisplay && _operator != null) {
      _equals();
    }
    _storedValue = _currentValue;
    _operator = operator;
    _replaceDisplay = true;
  }

  void _equals() {
    if (_storedValue == null || _operator == null) return;
    final right = _currentValue;
    final left = _storedValue!;

    double result;
    switch (_operator) {
      case '+':
        result = left + right;
        break;
      case '−':
        result = left - right;
        break;
      case '×':
        result = left * right;
        break;
      case '÷':
        if (right == 0) {
          _display = 'Error';
          _storedValue = null;
          _operator = null;
          _replaceDisplay = true;
          return;
        }
        result = left / right;
        break;
      default:
        return;
    }

    _display = _format(result);
    _storedValue = null;
    _operator = null;
    _replaceDisplay = true;
  }

  double get _currentValue => double.tryParse(_display) ?? 0;

  String _format(double value) {
    if (value.isNaN || value.isInfinite) return 'Error';
    final text = value.toStringAsFixed(8);
    return text.replaceFirst(RegExp(r'\.?0+$'), '');
  }

  @override
  Widget build(BuildContext context) {
    const buttons = [
      'AC', '⌫', '%', '÷',
      '7', '8', '9', '×',
      '4', '5', '6', '−',
      '1', '2', '3', '+',
      '+/−', '0', '.', '=',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Quick Calculator')),
      body: SafeArea(
  child: SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(18, 10, 18, 22),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 170,
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF071A46), Color(0xFF0A4CB9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.bottomRight,
                child: Text(
                  _display,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 58,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: buttons.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.25,
              ),
              itemBuilder: (context, index) {
                final key = buttons[index];
                final isOperator =
                    ['÷', '×', '−', '+', '='].contains(key);
                final isUtility =
                    ['AC', '⌫', '%'].contains(key);

                return _CalcButton(
                  label: key,
                  onTap: () => _tap(key),
                  background: isOperator
                      ? (key == '='
                          ? AppTheme.green
                          : AppTheme.blue)
                      : isUtility
                          ? const Color(0xFFE5ECF7)
                          : Colors.white,
                  foreground:
                      isOperator ? Colors.white : AppTheme.navy,
                );
              },
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

class _CalcButton extends StatelessWidget {
  const _CalcButton({
    required this.label,
    required this.onTap,
    required this.background,
    required this.foreground,
  });

  final String label;
  final VoidCallback onTap;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: foreground,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
