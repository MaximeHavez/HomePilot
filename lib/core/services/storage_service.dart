import 'dart:convert';

import 'package:homepilot/features/home/models/task.dart';
import 'package:homepilot/features/shopping/models/shopping_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _tasksKey = 'homepilot_tasks';
  static const String _shoppingItemsKey = 'homepilot_shopping_items';
  static const String _roomsKey = 'homepilot_rooms';

  static List<Task> defaultTasks() {
    return [
      const Task(id: '1', title: 'Faire la vaisselle', room: 'Cuisine', done: false),
      const Task(id: '2', title: 'Sortir les poubelles', room: 'Extérieur', done: true),
      const Task(id: '3', title: 'Passer l’aspirateur', room: 'Salon', done: false),
      const Task(id: '4', title: 'Faire le linge', room: 'Buanderie', done: false),
    ];
  }

  static List<ShoppingItem> defaultShoppingItems() {
    return [
      const ShoppingItem(
        id: '1',
        name: 'Lait',
        category: 'Produits frais',
        checked: false,
      ),
      const ShoppingItem(
        id: '2',
        name: 'Pain',
        category: 'Boulangerie',
        checked: true,
      ),
      const ShoppingItem(
        id: '3',
        name: 'Pommes',
        category: 'Fruits',
        checked: false,
      ),
    ];
  }

  static List<String> defaultRooms() {
    return [
      'Cuisine',
      'Salon',
      'Chambre',
      'Salle de bain',
      'Extérieur',
    ];
  }

  static Future<List<String>> loadRooms() async {
    final prefs = await SharedPreferences.getInstance();
    final rawRooms = prefs.getStringList(_roomsKey);

    if (rawRooms == null || rawRooms.isEmpty) {
      return defaultRooms();
    }

    final rooms = rawRooms.where((room) => room.trim().isNotEmpty).toList();
    return rooms.isEmpty ? defaultRooms() : rooms;
  }

  static Future<void> saveRooms(List<String> rooms) async {
    final prefs = await SharedPreferences.getInstance();
    final cleanedRooms = rooms
        .map((room) => room.trim())
        .where((room) => room.isNotEmpty)
        .toSet()
        .toList();
    await prefs.setStringList(_roomsKey, cleanedRooms);
  }

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final rawTasks = prefs.getStringList(_tasksKey);

    if (rawTasks == null || rawTasks.isEmpty) {
      return defaultTasks();
    }

    final tasks = <Task>[];
    for (final rawTask in rawTasks) {
      try {
        final map = jsonDecode(rawTask) as Map<String, dynamic>;
        tasks.add(Task.fromJson(map));
      } catch (_) {
        continue;
      }
    }

    return tasks.isEmpty ? defaultTasks() : tasks;
  }

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedTasks = tasks
        .map((task) => jsonEncode(task.toJson()))
        .toList(growable: false);
    await prefs.setStringList(_tasksKey, encodedTasks);
  }

  static Future<List<ShoppingItem>> loadShoppingItems() async {
    final prefs = await SharedPreferences.getInstance();
    final rawItems = prefs.getStringList(_shoppingItemsKey);

    if (rawItems == null || rawItems.isEmpty) {
      return defaultShoppingItems();
    }

    final items = <ShoppingItem>[];
    for (final rawItem in rawItems) {
      try {
        final map = jsonDecode(rawItem) as Map<String, dynamic>;
        items.add(ShoppingItem.fromJson(map));
      } catch (_) {
        continue;
      }
    }

    return items.isEmpty ? defaultShoppingItems() : items;
  }

  static Future<void> saveShoppingItems(List<ShoppingItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedItems = items
        .map((item) => jsonEncode(item.toJson()))
        .toList(growable: false);
    await prefs.setStringList(_shoppingItemsKey, encodedItems);
  }
}
