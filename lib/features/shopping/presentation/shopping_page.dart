import 'package:flutter/material.dart';

import '../models/shopping_item.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({
    super.key,
    required this.items,
    required this.onToggleItem,
    required this.onDeleteItem,
    required this.onAddItem,
  });

  final List<ShoppingItem> items;
  final void Function(String) onToggleItem;
  final void Function(String) onDeleteItem;
  final Future<void> Function() onAddItem;

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  @override
  Widget build(BuildContext context) {
    final total = widget.items.length;
    final checked = widget.items.where((item) => item.checked).length;
    final remaining = total - checked;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Courses du foyer',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Total',
                    value: '$total',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Restants',
                    value: '$remaining',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Achetés',
                    value: '$checked',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: widget.items.isEmpty
                  ? const Center(child: Text('Aucun produit dans la liste.'))
                  : ListView.separated(
                      itemCount: widget.items.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = widget.items[index];

                        return Material(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          elevation: 1,
                          child: CheckboxListTile(
                            value: item.checked,
                            onChanged: (_) => widget.onToggleItem(item.id),
                            title: Text(
                              item.name,
                              style: TextStyle(
                                decoration: item.checked
                                    ? TextDecoration.lineThrough
                                    : null,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(item.category),
                            secondary: IconButton(
                              onPressed: () => widget.onDeleteItem(item.id),
                              icon: const Icon(Icons.delete_outline),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
