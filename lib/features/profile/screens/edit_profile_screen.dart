import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_practice13/features/profile/logic/profile_cubit.dart';
import 'package:flutter_practice13/features/profile/logic/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _licenseController;
  late TextEditingController _experienceController;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileCubit>().state.profile;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _phoneController = TextEditingController(text: profile?.phone ?? '');
    _licenseController = TextEditingController(text: profile?.drivingLicenseNumber ?? '');
    _experienceController = TextEditingController(
      text: profile?.drivingExperienceYears?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      await context.read<ProfileCubit>().updateProfile(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            drivingLicenseNumber: _licenseController.text.trim(),
            drivingExperienceYears: int.tryParse(_experienceController.text),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Профиль обновлен')),
        );
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать профиль'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Имя',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите имя';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Телефон',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _licenseController,
                    decoration: const InputDecoration(
                      labelText: 'Водительское удостоверение',
                      prefixIcon: Icon(Icons.credit_card),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _experienceController,
                    decoration: const InputDecoration(
                      labelText: 'Стаж вождения (лет)',
                      prefixIcon: Icon(Icons.timeline),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final years = int.tryParse(value);
                        if (years == null || years < 0) {
                          return 'Введите корректное число';
                        }
                        if (years > 70) {
                          return 'Введите реальное значение';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state.isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: state.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Сохранить',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

