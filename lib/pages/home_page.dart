import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/drink_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/drink_card.dart';
import '../widgets/search_bar_widget.dart';
import 'details_page.dart';

/// Tela principal com lista de drinks e busca
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Carrega os drinks iniciais
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DrinkProvider>().loadInitialDrinks();
    });

    // Adiciona listener para paginação ao rolar
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Detecta quando o usuário chega ao final da lista
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<DrinkProvider>();
      if (!provider.isLoading && !provider.isSearching) {
        provider.loadNextPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DrinkFinder'),
        centerTitle: true,
        actions: [
          // Botão para alternar tema
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return IconButton(
                icon: Icon(themeProvider.themeIcon),
                onPressed: () => themeProvider.toggleTheme(),
                tooltip: 'Alternar tema',
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de busca
          const SearchBarWidget(),

          // Lista de drinks
          Expanded(
            child: Consumer<DrinkProvider>(
              builder: (context, provider, _) {
                // Estado de erro
                if (provider.errorMessage != null && provider.drinks.isEmpty) {
                  return _buildErrorState(provider);
                }

                // Estado de carregamento inicial
                if (provider.isLoading && provider.drinks.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Lista vazia
                if (provider.drinks.isEmpty) {
                  return _buildEmptyState();
                }

                // Lista com drinks
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount:
                      provider.drinks.length + (provider.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Indicador de carregamento no final da lista
                    if (index == provider.drinks.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final drink = provider.drinks[index];
                    return DrinkCard(
                      drink: drink,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsPage(drink: drink),
                          ),
                        );
                      },
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

  /// Widget para estado de erro
  Widget _buildErrorState(DrinkProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Ops! Algo deu errado',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              provider.errorMessage ?? 'Erro desconhecido',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => provider.retry(),
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget para lista vazia
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum drink encontrado',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Tente buscar por outro nome',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
