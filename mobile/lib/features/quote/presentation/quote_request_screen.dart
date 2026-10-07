import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/luxury_app_bar.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/quote_provider.dart';

class QuoteRequestScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? initialData;

  const QuoteRequestScreen({super.key, this.initialData});

  @override
  ConsumerState<QuoteRequestScreen> createState() => _QuoteRequestScreenState();
}

class _QuoteRequestScreenState extends ConsumerState<QuoteRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _cityController;
  late TextEditingController _surfaceController;
  late TextEditingController _messageController;
  String? _selectedRoomType;

  bool _isSubmitting = false;

  final List<String> _roomTypes = [
    'Living Room',
    'Bedroom',
    'Kitchen',
    'Bathroom',
    'Dining Room',
    'Full Apartment / Villa',
    'Office / Commercial',
  ];

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    final initial = widget.initialData ?? {};

    _nameController = TextEditingController(text: user?.fullName ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _cityController = TextEditingController(text: initial['city'] ?? '');
    _surfaceController = TextEditingController(text: initial['surfaceArea']?.toString() ?? '');
    _messageController = TextEditingController(text: initial['message'] ?? '');
    _selectedRoomType = initial['roomType'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _surfaceController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitQuote() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final repo = ref.read(quoteRepositoryProvider);
      final initial = widget.initialData ?? {};

      await repo.submitQuote(
        transformationId: initial['transformationId'] as int?,
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        city: _cityController.text.trim(),
        roomType: _selectedRoomType,
        surfaceArea: double.tryParse(_surfaceController.text.trim()),
        message: _messageController.text.trim(),
      );

      if (!mounted) return;
      setState(() => _isSubmitting = false);
      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit quote: $e')),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: AppColors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(26.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.goldGradient,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.black,
                    size: 42,
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Quote Request Received',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Thank you for your interest in RenoDesign. Our project architect will analyze your transformation and contact you within 24 hours with an estimate.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 26),
                CustomButton(
                  text: 'Back to Home',
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go('/home');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: LuxuryAppBar(
        title: 'Request a Quote',
        onBack: () => context.pop(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bring Your Vision to Reality',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Receive a detailed architectural estimate and material breakdown from our team.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Full Name
              _buildFieldLabel('FULL NAME *'),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: AppColors.textPrimary),
                validator: (val) => val == null || val.isEmpty ? 'Name required' : null,
                decoration: const InputDecoration(
                  hintText: 'John Doe',
                  prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),

              // Phone Number
              _buildFieldLabel('PHONE NUMBER *'),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: AppColors.textPrimary),
                validator: (val) => val == null || val.isEmpty ? 'Phone required' : null,
                decoration: const InputDecoration(
                  hintText: '+33 6 12 34 56 78',
                  prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),

              // Email Address
              _buildFieldLabel('EMAIL ADDRESS *'),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: AppColors.textPrimary),
                validator: (val) => val == null || !val.contains('@') ? 'Valid email required' : null,
                decoration: const InputDecoration(
                  hintText: 'client@example.com',
                  prefixIcon: Icon(Icons.mail_outline_rounded, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),

              // City
              _buildFieldLabel('CITY / REGION'),
              TextFormField(
                controller: _cityController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'e.g., Paris, Nice, Lyon...',
                  prefixIcon: Icon(Icons.location_city_outlined, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),

              // Room Type & Surface Area Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('ROOM TYPE'),
                        DropdownButtonFormField<String>(
                          value: _selectedRoomType,
                          dropdownColor: AppColors.surfaceElevated,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          ),
                          hint: const Text('Select room', style: TextStyle(color: AppColors.textMuted)),
                          items: _roomTypes
                              .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                              .toList(),
                          onChanged: (val) => setState(() => _selectedRoomType = val),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('SURFACE (M²)'),
                        TextFormField(
                          controller: _surfaceController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: const InputDecoration(hintText: '45'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Message / Notes
              _buildFieldLabel('PROJECT DETAILS & TIMELINE'),
              TextFormField(
                controller: _messageController,
                maxLines: 4,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Tell us about your desired timeline, budget range or specific requirements...',
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              CustomButton(
                text: 'Submit Quote Request',
                icon: Icons.send_rounded,
                isLoading: _isSubmitting,
                onPressed: _submitQuote,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
