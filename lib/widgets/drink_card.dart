import 'package:flutter/material.dart';
import '../models/drink.dart';

/// Card que exibe as informações resumidas de um drink
class DrinkCard extends StatelessWidget {
  final Drink drink;
  final VoidCallback onTap;

  const DrinkCard({super.key, required this.drink, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do drink
            Hero(
              tag: 'drink-${drink.id}',
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: drink.thumbnail != null
                    ? Image.network(
                        drink.thumbnail!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            child: const Center(
                              child: Icon(Icons.local_bar, size: 48),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        child: const Center(
                          child: Icon(Icons.local_bar, size: 48),
                        ),
                      ),
              ),
            ),

            // Informações do drink
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome do drink
                  Text(
                    drink.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Categoria e tipo
                  Row(
                    children: [
                      if (drink.category != null) ...[
                        Icon(
                          Icons.category,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            drink.category!,
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      if (drink.category != null && drink.alcoholic != null)
                        const SizedBox(width: 16),
                      if (drink.alcoholic != null) ...[
                        Icon(
                          drink.alcoholic!.toLowerCase().contains('alcoholic')
                              ? Icons.liquor
                              : Icons.no_drinks,
                          size: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            drink.alcoholic!,
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Número de ingredientes
                  if (drink.ingredients.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.format_list_bulleted,
                          size: 16,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${drink.ingredients.length} ingrediente${drink.ingredients.length != 1 ? 's' : ''}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
