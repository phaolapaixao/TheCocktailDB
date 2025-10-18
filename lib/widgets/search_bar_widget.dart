import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/drink_provider.dart';

/// Widget de barra de busca para filtrar drinks
class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Executa a busca
  void _performSearch(String query) {
    final provider = context.read<DrinkProvider>();
    provider.searchDrinks(query).then((_) {
      // Mostra snackbar se não houver resultados
      if (provider.drinks.isEmpty && query.isNotEmpty && !provider.isLoading) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Nenhum drink encontrado para "$query"'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    });
  }

  /// Limpa a busca
  void _clearSearch() {
    _controller.clear();
    setState(() {
      _isSearching = false;
    });
    context.read<DrinkProvider>().clearSearch();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Buscar drinks...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _isSearching
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
        ),
        onChanged: (value) {
          setState(() {
            _isSearching = value.isNotEmpty;
          });
        },
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            _performSearch(value);
          }
        },
        textInputAction: TextInputAction.search,
      ),
    );
  }
}
