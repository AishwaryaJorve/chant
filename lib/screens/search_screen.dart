import 'package:flutter/material.dart';
import '../widgets/theme_background.dart';
import '../widgets/bottom_nav.dart';
import '../models/meditation.dart';
import '../mixins/auth_required_mixin.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with AuthRequiredMixin {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  List<Meditation> _searchResults = [];

  final _categories = [
    {
      'title': 'Sleep',
      'icon': Icons.nightlight_outlined,
      'color': Colors.indigo,
      'description': 'Better sleep meditation',
    },
    {
      'title': 'Focus',
      'icon': Icons.lens_outlined,
      'color': Colors.orange,
      'description': 'Improve concentration',
    },
    {
      'title': 'Anxiety',
      'icon': Icons.healing_outlined,
      'color': Colors.teal,
      'description': 'Reduce anxiety',
    },
    {
      'title': 'Stress',
      'icon': Icons.spa_outlined,
      'color': Colors.purple,
      'description': 'Stress relief',
    },
    {
      'title': 'Mindfulness',
      'icon': Icons.self_improvement_outlined,
      'color': Colors.green,
      'description': 'Be present',
    },
    {
      'title': 'Breathing',
      'icon': Icons.air_outlined,
      'color': Colors.blue,
      'description': 'Breathing exercises',
    },
  ];

  // Sample meditation data
  final List<Meditation> _meditations = [
    Meditation(
      title: 'Morning Meditation',
      category: 'Focus',
      duration: 10,
      description: 'Start your day with mindfulness',
    ),
    Meditation(
      title: 'Deep Sleep',
      category: 'Sleep',
      duration: 20,
      description: 'Peaceful sleep meditation',
    ),
    Meditation(
      title: 'Anxiety Relief',
      category: 'Anxiety',
      duration: 15,
      description: 'Calm your mind and reduce anxiety',
    ),
    Meditation(
      title: 'Stress Management',
      category: 'Stress',
      duration: 12,
      description: 'Release stress and tension',
    ),
  ];

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    final results = _meditations.where((meditation) {
      final titleMatch = meditation.title.toLowerCase().contains(query.toLowerCase());
      final categoryMatch = meditation.category.toLowerCase().contains(query.toLowerCase());
      final descriptionMatch = meditation.description.toLowerCase().contains(query.toLowerCase());
      return titleMatch || categoryMatch || descriptionMatch;
    }).toList();

    setState(() {
      _isSearching = true;
      _searchResults = results;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ThemeBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  autofocus: false,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search meditations...',
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        _performSearch(_searchController.text);
                      },
                    ),
                    suffixIcon: _isSearching
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _performSearch('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: _performSearch,
                  onSubmitted: _performSearch,
                ),
              ),
              if (!_isSearching) ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Popular Categories',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      return _buildCategoryCard(_categories[index]);
                    },
                  ),
                ),
              ],
              if (_isSearching)
                Expanded(
                  child: _searchResults.isEmpty
                      ? Center(
                          child: Text(
                            'No results found',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        )
                      : ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final meditation = _searchResults[index];
                            return ListTile(
                              leading: const Icon(Icons.self_improvement),
                              title: Text(meditation.title),
                              subtitle: Text(
                                '${meditation.duration} minutes • ${meditation.category}',
                              ),
                              onTap: () {
                                // TODO: Navigate to meditation details
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Selected: ${meditation.title}'),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 1,
        totalMalas: 0,
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Card(
      elevation: 0,
      color: category['color'].withOpacity(0.1),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Selected: ${category['title']}')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                category['icon'],
                size: 32,
                color: category['color'],
              ),
              const SizedBox(height: 8),
              Text(
                category['title'],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: category['color'],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                category['description'],
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 