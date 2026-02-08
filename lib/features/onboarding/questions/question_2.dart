import 'package:cocos_mobile_application/features/onboarding/questions/question_3.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Question2 extends StatefulWidget {
  final String answer1;
  const Question2({super.key, required this.answer1});

  @override
  State<Question2> createState() => _Question2State();
}

class _Question2State extends State<Question2> {
  final _customController = TextEditingController();
  String? _selectedOption;
  bool _showCustomField = false;

  final List<String> _options = [
    'Restaurant',
    'Retail Store',
    'Service Business',
    'E-commerce',
  ];

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  void _selectOption(String option) {
    setState(() {
      _selectedOption = option;
      _showCustomField = false;
      _customController.clear();
    });
  }

  void _selectCustom() {
    setState(() {
      _selectedOption = 'Custom';
      _showCustomField = true;
    });
  }

  void _next() {
    String answer = '';
    if (_selectedOption == 'Custom') {
      answer = _customController.text.trim();
    } else {
      answer = _selectedOption ?? '';
    }

    if (answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or enter an answer')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Question3(answer1: widget.answer1, answer2: answer),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                "Almost there...",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: 0.33,
                backgroundColor: Colors.grey.shade300,
                color: Colors.green,
                minHeight: 6,
              ),
              const SizedBox(height: 32),
              Text(
                "What type of business do you run?",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              // Pill buttons
              ..._options.map(
                (option) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildPillButton(option),
                ),
              ),
              const SizedBox(height: 8),
              _buildPillButton('Custom Answer', isCustom: true),
              if (_showCustomField) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _customController,
                  decoration: InputDecoration(
                    labelText: 'Your answer',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.green,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FloatingActionButton.extended(
                  onPressed: _next,
                  label: Text(
                    "Next",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.green,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillButton(String text, {bool isCustom = false}) {
    final isSelected = isCustom
        ? _selectedOption == 'Custom'
        : _selectedOption == text;

    return GestureDetector(
      onTap: isCustom ? _selectCustom : () => _selectOption(text),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade400,
            width: 1.5,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
