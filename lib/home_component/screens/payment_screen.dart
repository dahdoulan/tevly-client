import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();
  String? _cardType;

  String _formatCardNumber(String text) {
    text = text.replaceAll(' ', '');
    if (text.length < 4) return text;
    String result = '';
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        result += ' ';
      }
      result += text[i];
    }
    return result;
  }

  void _formatExpiryDate(String value) {
    var newText = value.replaceAll('/', '');
    if (newText.length >= 2) {
      newText = '${newText.substring(0, 2)}/${newText.substring(2)}';
      if (newText != _expiryController.text) {
        _expiryController.text = newText;
        _expiryController.selection = TextSelection.fromPosition(
          TextPosition(offset: newText.length),
        );
      }
    }
  }

  bool _isValidExpiryDate(String value) {
    if (value.length != 5) return false;
    if (!value.contains('/')) return false;

    final parts = value.split('/');
    if (parts.length != 2) return false;

    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;

    final now = DateTime.now();
    final currentYear = now.year % 100;
    final currentMonth = now.month;

    final fullYear = 2000 + year;

    if (fullYear < now.year) return false;
    if (fullYear == now.year && month < currentMonth) return false;
    if (year > currentYear + 10) return false;

    return true;
  }

  bool _isValidCardNumber(String number) {
    number = number.replaceAll(' ', '');
    if (number.length != 16) return false;

    int sum = 0;
    bool alternate = false;
    for (int i = number.length - 1; i >= 0; i--) {
      int digit = int.parse(number[i]);
      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }
      sum += digit;
      alternate = !alternate;
    }
    return sum % 10 == 0;
  }

  void _updateCardType(String number) {
    setState(() {
      _cardType = _getCardType(number);
    });
  }

  String? _getCardType(String number) {
    number = number.replaceAll(' ', '');
    if (number.isEmpty) return null;

    if (number.startsWith('4')) {
      return 'Visa';
    } else if (RegExp(r'^5[1-5]').hasMatch(number)) {
      return 'MasterCard';
    } else if (RegExp(r'^3[47]').hasMatch(number)) {
      return 'American Express';
    } else if (RegExp(r'^6(?:011|5)').hasMatch(number)) {
      return 'Discover';
    }
    return null;
  }

  Widget _getCardTypeIcon() {
    if (_cardType == null) return const Icon(Icons.credit_card);

    switch (_cardType) {
      case 'Visa':
        return const Icon(Icons.credit_card, color: Colors.blue);
      case 'MasterCard':
        return const Icon(Icons.credit_card, color: Colors.orange);
      case 'American Express':
        return const Icon(Icons.credit_card, color: Colors.green);
      case 'Discover':
        return const Icon(Icons.credit_card, color: Colors.red);
      default:
        return const Icon(Icons.credit_card);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
        backgroundColor: Color.fromARGB(225, 255, 214, 64),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  border: const OutlineInputBorder(),
                  prefixIcon: _getCardTypeIcon(),
                  hintText: '1234 5678 9012 3456',
                  suffixText: _cardType ?? '',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
                onChanged: (value) {
                  final formattedText = _formatCardNumber(value);
                  if (formattedText != value) {
                    _cardNumberController.text = formattedText;
                    _cardNumberController.selection =
                        TextSelection.fromPosition(
                      TextPosition(offset: formattedText.length),
                    );
                  }
                  _updateCardType(formattedText);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card number';
                  }
                  String cleanNumber = value.replaceAll(' ', '');
                  if (cleanNumber.length != 16) {
                    return 'Card number must be 16 digits';
                  }
                  if (!_isValidCardNumber(cleanNumber)) {
                    return 'Invalid card number';
                  }
                  if (_cardType == null) {
                    return 'Unsupported card type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryController,
                      decoration: const InputDecoration(
                        labelText: 'MM/YY',
                        border: OutlineInputBorder(),
                        hintText: '12/25',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      onChanged: _formatExpiryDate,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (!_isValidExpiryDate(value)) {
                          return 'Invalid date';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(),
                        hintText: '123',
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (value.length != 3) {
                          return 'Must be 3 digits';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Cardholder Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Ahmad Malkawi',
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cardholder name';
                  }
                  if (value.trim().split(' ').length < 2) {
                    return 'Please enter full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                onPressed: () async {
  if (_formKey.currentState!.validate()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Processing Payment...'),
        duration: Duration(seconds: 2),
      ),
    );

    await Future.delayed(const Duration(seconds: 4));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment Completed Successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      // Wait for the success message to show, then navigate to login
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }
},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(225, 255, 214, 64),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Pay Now',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}

// Visa Cards (Start with 4):

// 4532 7153 3790 9024
// 4556 7375 8689 9855
// 4532 8853 7440 3289

// MasterCard (Start with 51-55):

// 5425 2334 3010 9903
// 5105 1051 0510 5100
// 5555 5555 5555 4444

// American Express (Start with 34 or 37):

// 3782 822463 10005
// 3714 496353 98431
// 3787 344936 71000

// Discover (Start with 6011 or 65):

// 6011 0009 9013 9424
// 6011 1111 1111 1117
// 6511 0999 9999 9999
