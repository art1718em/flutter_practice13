import 'package:flutter/material.dart';
import 'package:flutter_practice13/core/di/injection_container.dart';
import 'package:flutter_practice13/domain/usecases/countries/get_country_by_code_usecase.dart';
import 'package:flutter_practice13/domain/entities/country.dart';
import 'package:go_router/go_router.dart';

class CountryDetailsScreen extends StatefulWidget {
  final String countryCode;

  const CountryDetailsScreen({
    super.key,
    required this.countryCode,
  });

  @override
  State<CountryDetailsScreen> createState() => _CountryDetailsScreenState();
}

class _CountryDetailsScreenState extends State<CountryDetailsScreen> {
  Country? _country;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCountry();
  }

  Future<void> _loadCountry() async {
    if (widget.countryCode.isEmpty) {
      setState(() {
        _error = 'Неверный код страны';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final getCountryByCodeUseCase = getIt<GetCountryByCodeUseCase>();
      final country = await getCountryByCodeUseCase(widget.countryCode);
      
      if (!mounted) return;
      
      setState(() {
        _country = country;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_country?.name ?? 'Загрузка...'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadCountry,
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                )
              : _country == null
                  ? const Center(child: Text('Страна не найдена'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_country!.flagUrl != null) ...[
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  _country!.flagUrl!,
                                  height: 150,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.flag, size: 100),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                          Text(
                            'Основная информация',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoCard(
                            icon: Icons.flag,
                            title: 'Официальное название',
                            value: _country!.officialName ?? 'Не указано',
                          ),
                          _buildInfoCard(
                            icon: Icons.location_city,
                            title: 'Столица',
                            value: _country!.capital ?? 'Не указана',
                          ),
                          _buildInfoCard(
                            icon: Icons.public,
                            title: 'Регион',
                            value: _country!.region ?? 'Не указан',
                          ),
                          if (_country!.subregion != null)
                            _buildInfoCard(
                              icon: Icons.place,
                              title: 'Субрегион',
                              value: _country!.subregion!,
                            ),
                          _buildInfoCard(
                            icon: Icons.code,
                            title: 'Коды страны',
                            value: '${_country!.countryCode} / ${_country!.countryCode3 ?? "N/A"}',
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Для автомобилистов',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          if (_country!.phonePrefix != null)
                            _buildInfoCard(
                              icon: Icons.phone,
                              title: 'Телефонный код',
                              value: _country!.phonePrefix!,
                            ),
                          if (_country!.currency != null)
                            _buildInfoCard(
                              icon: Icons.attach_money,
                              title: 'Валюта',
                              value: '${_country!.currency} ${_country!.currencySymbol ?? ""}',
                            ),
                          if (_country!.languages.isNotEmpty)
                            _buildInfoCard(
                              icon: Icons.language,
                              title: 'Языки',
                              value: _country!.languages.join(', '),
                            ),
                          if (_country!.timezones.isNotEmpty)
                            _buildInfoCard(
                              icon: Icons.access_time,
                              title: 'Часовые пояса',
                              value: _country!.timezones.join(', '),
                            ),
                          if (_country!.borders.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            Text(
                              'Соседние страны',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _country!.borders.map((border) {
                                return ActionChip(
                                  avatar: const Icon(Icons.flag, size: 18),
                                  label: Text(border),
                                  onPressed: () {
                                    context.push('/reference/countries/${border.toLowerCase()}');
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

