import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_practice13/features/countries/logic/countries_cubit.dart';
import 'package:flutter_practice13/features/countries/logic/countries_state.dart';

class CountriesListScreen extends StatefulWidget {
  const CountriesListScreen({super.key});

  @override
  State<CountriesListScreen> createState() => _CountriesListScreenState();
}

class _CountriesListScreenState extends State<CountriesListScreen> {
  final _searchController = TextEditingController();
  bool _searchByCapital = false; // false = по стране, true = по столице

  @override
  void initState() {
    super.initState();
    // Загружаем все страны при открытии экрана
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CountriesCubit>().loadAllCountries();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String value) {
    if (value.isEmpty) return;
    
    if (_searchByCapital) {
      context.read<CountriesCubit>().searchCountryByCapital(value);
    } else {
      context.read<CountriesCubit>().searchCountryByName(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Справочник стран'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: _searchByCapital 
                        ? 'Поиск по столице...' 
                        : 'Поиск по названию страны...',
                    prefixIcon: Icon(_searchByCapital ? Icons.location_city : Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                  onSubmitted: _performSearch,
                ),
                const SizedBox(height: 12),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment<bool>(
                      value: false,
                      label: Text('По стране'),
                      icon: Icon(Icons.public, size: 18),
                    ),
                    ButtonSegment<bool>(
                      value: true,
                      label: Text('По столице'),
                      icon: Icon(Icons.location_city, size: 18),
                    ),
                  ],
                  selected: {_searchByCapital},
                  onSelectionChanged: (Set<bool> newSelection) {
                    setState(() {
                      _searchByCapital = newSelection.first;
                      // Очищаем поле поиска при переключении режима
                      _searchController.clear();
                    });
                  },
                ),
              ],
            ),
          ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildAllCountriesChip(context),
                    _buildRegionChip(context, 'Европа', 'Europe'),
                    _buildRegionChip(context, 'Азия', 'Asia'),
                    _buildRegionChip(context, 'Африка', 'Africa'),
                    _buildRegionChip(context, 'Америка', 'Americas'),
                    _buildRegionChip(context, 'Океания', 'Oceania'),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<CountriesCubit, CountriesState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          state.error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Выберите регион для просмотра стран',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state.countries.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.public,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Найдите страну',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Используйте поиск по названию или столице,\nлибо выберите регион',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.countries.length,
                  itemBuilder: (context, index) {
                    final country = state.countries[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: country.flagUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  country.flagUrl!,
                                  width: 48,
                                  height: 32,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.flag),
                                ),
                              )
                            : const Icon(Icons.flag),
                        title: Text(
                          country.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          country.capital ?? 'Столица не указана',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (country.countryCode != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  country.countryCode!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 8),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                        onTap: () {
                          if (country.countryCode != null && country.countryCode!.isNotEmpty) {
                            context.push('/reference/countries/${country.countryCode!.toLowerCase()}');
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllCountriesChip(BuildContext context) {
    final isSelected = context.watch<CountriesCubit>().state.selectedRegion == null;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: const Text('Все'),
        selected: isSelected,
        onSelected: (_) {
          context.read<CountriesCubit>().loadAllCountries();
        },
      ),
    );
  }

  Widget _buildRegionChip(BuildContext context, String label, String region) {
    final isSelected = context.watch<CountriesCubit>().state.selectedRegion == region;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          context.read<CountriesCubit>().loadCountriesByRegion(region);
        },
      ),
    );
  }
}

