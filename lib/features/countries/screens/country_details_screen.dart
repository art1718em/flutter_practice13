import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice13/features/countries/logic/country_details_cubit.dart';
import 'package:flutter_practice13/features/countries/logic/country_details_state.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CountryDetailsCubit>().loadCountry(widget.countryCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountryDetailsCubit, CountryDetailsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.country?.name ?? 'Загрузка...'),
            centerTitle: true,
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : state.error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(state.error!),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<CountryDetailsCubit>().loadCountry(widget.countryCode);
                            },
                            child: const Text('Повторить'),
                          ),
                        ],
                      ),
                    )
                  : state.country == null
                      ? const Center(child: Text('Страна не найдена'))
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (state.country!.flagUrl != null) ...[
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      state.country!.flagUrl!,
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
                                context,
                                icon: Icons.flag,
                                title: 'Официальное название',
                                value: state.country!.officialName ?? 'Не указано',
                              ),
                              _buildInfoCard(
                                context,
                                icon: Icons.location_city,
                                title: 'Столица',
                                value: state.country!.capital ?? 'Не указана',
                              ),
                              _buildInfoCard(
                                context,
                                icon: Icons.public,
                                title: 'Регион',
                                value: state.country!.region ?? 'Не указан',
                              ),
                              if (state.country!.subregion != null)
                                _buildInfoCard(
                                  context,
                                  icon: Icons.place,
                                  title: 'Субрегион',
                                  value: state.country!.subregion!,
                                ),
                              _buildInfoCard(
                                context,
                                icon: Icons.code,
                                title: 'Коды страны',
                                value: '${state.country!.countryCode} / ${state.country!.countryCode3 ?? "N/A"}',
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Для автомобилистов',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              if (state.country!.phonePrefix != null)
                                _buildInfoCard(
                                  context,
                                  icon: Icons.phone,
                                  title: 'Телефонный код',
                                  value: state.country!.phonePrefix!,
                                ),
                              if (state.country!.currency != null)
                                _buildInfoCard(
                                  context,
                                  icon: Icons.attach_money,
                                  title: 'Валюта',
                                  value: '${state.country!.currency} ${state.country!.currencySymbol ?? ""}',
                                ),
                              if (state.country!.languages.isNotEmpty)
                                _buildInfoCard(
                                  context,
                                  icon: Icons.language,
                                  title: 'Языки',
                                  value: state.country!.languages.join(', '),
                                ),
                              if (state.country!.timezones.isNotEmpty)
                                _buildInfoCard(
                                  context,
                                  icon: Icons.access_time,
                                  title: 'Часовые пояса',
                                  value: state.country!.timezones.join(', '),
                                ),
                              if (state.country!.borders.isNotEmpty) ...[
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
                                  children: state.country!.borders.map((border) {
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
      },
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
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

