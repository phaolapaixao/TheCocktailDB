import 'package:flutter/material.dart';
import '../models/drink.dart';

/// Tela de detalhes de um drink específico
class DetailsPage extends StatelessWidget {
  final Drink drink;

  const DetailsPage({super.key, required this.drink});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar com imagem
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                drink.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              background: Hero(
                tag: 'drink-${drink.id}',
                child: drink.thumbnail != null
                    ? Image.network(
                        drink.thumbnail!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            child: const Icon(Icons.local_bar, size: 64),
                          );
                        },
                      )
                    : Container(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.local_bar, size: 64),
                      ),
              ),
            ),
          ),

          // Conteúdo
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informações principais
                  _buildInfoCards(context),
                  const SizedBox(height: 24),

                  // Ingredientes
                  if (drink.ingredients.isNotEmpty) ...[
                    Text(
                      'Ingredientes',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _buildIngredientsList(context),
                    const SizedBox(height: 24),
                  ],

                  // Instruções
                  if (drink.instructions != null &&
                      drink.instructions!.isNotEmpty) ...[
                    Text(
                      'Modo de Preparo',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          drink.instructions!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Cards com informações principais
  Widget _buildInfoCards(BuildContext context) {
    return Row(
      children: [
        if (drink.category != null)
          Expanded(
            child: _buildInfoCard(
              context,
              icon: Icons.category,
              label: 'Categoria',
              value: drink.category!,
            ),
          ),
        if (drink.category != null && drink.glass != null)
          const SizedBox(width: 12),
        if (drink.glass != null)
          Expanded(
            child: _buildInfoCard(
              context,
              icon: Icons.wine_bar,
              label: 'Copo',
              value: drink.glass!,
            ),
          ),
      ],
    );
  }

  /// Card individual de informação
  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Lista de ingredientes
  Widget _buildIngredientsList(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: drink.ingredients.map((ingredient) {
            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              title: Text(
                ingredient.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: ingredient.measure != null
                  ? Text(ingredient.measure!)
                  : null,
            );
          }).toList(),
        ),
      ),
    );
  }
}
