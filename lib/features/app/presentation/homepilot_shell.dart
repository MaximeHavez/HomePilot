import 'package:flutter/material.dart';

import 'package:homepilot/core/services/storage_service.dart';
import 'package:homepilot/features/home/models/task.dart';
import 'package:homepilot/features/home/presentation/home_page.dart';
import 'package:homepilot/features/shopping/models/shopping_item.dart';
import 'package:homepilot/features/shopping/presentation/shopping_page.dart';

class HomePilotShell extends StatefulWidget {
  const HomePilotShell({super.key});

  @override
  State<HomePilotShell> createState() => _HomePilotShellState();
}

class _HomePilotShellState extends State<HomePilotShell> {
  int _selectedIndex = 0;
  List<String> _rooms = StorageService.defaultRooms();
  List<Task> _tasks = StorageService.defaultTasks();
  List<ShoppingItem> _shoppingItems = StorageService.defaultShoppingItems();

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadData);
  }

  Future<void> _loadData() async {
    final rooms = await StorageService.loadRooms();
    final tasks = await StorageService.loadTasks();
    final shoppingItems = await StorageService.loadShoppingItems();

    if (!mounted) {
      return;
    }

    setState(() {
      _rooms = rooms;
      _tasks = tasks;
      _shoppingItems = shoppingItems;
    });
  }

  void _addRoom(String roomName) {
    final normalizedRoom = roomName.trim();
    if (normalizedRoom.isEmpty) {
      return;
    }

    if (_rooms.any((room) => room.toLowerCase() == normalizedRoom.toLowerCase())) {
      return;
    }

    setState(() {
      _rooms = [..._rooms, normalizedRoom];
    });
    StorageService.saveRooms(_rooms);
  }

  void _deleteRoom(String roomName) {
    final normalizedRoom = roomName.trim();
    if (normalizedRoom.isEmpty) {
      return;
    }

    setState(() {
      _rooms.removeWhere((room) => room == normalizedRoom);
      if (_rooms.isEmpty) {
        _rooms = StorageService.defaultRooms();
      }
    });
    StorageService.saveRooms(_rooms);
  }

  void _toggleTask(String id) {
    setState(() {
      for (int index = 0; index < _tasks.length; index++) {
        final task = _tasks[index];
        if (task.id == id) {
          _tasks[index] = task.copyWith(done: !task.done);
          break;
        }
      }
    });
    StorageService.saveTasks(_tasks);
  }

  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });
    StorageService.saveTasks(_tasks);
  }

  Future<void> _addTask() async {
    final controller = TextEditingController();
    final roomController = TextEditingController();
    String roomValue = _rooms.isNotEmpty ? _rooms.first : 'Cuisine';

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final rooms = _rooms.isEmpty ? ['Cuisine'] : _rooms;
            if (!rooms.contains(roomValue)) {
              roomValue = rooms.first;
            }

            return AlertDialog(
              title: const Text('Ajouter une tâche du quotidien'),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      key: const ValueKey('task_name_input'),
                      controller: controller,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Nom de la tâche',
                        hintText: 'Ex: ranger la salle de bain',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      key: ValueKey(roomValue),
                      initialValue: roomValue,
                      decoration: const InputDecoration(
                        labelText: 'Lieu de la maison',
                        border: OutlineInputBorder(),
                      ),
                      items: rooms
                          .map(
                            (room) => DropdownMenuItem<String>(
                              value: room,
                              child: Text(room),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            roomValue = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Pièces de la maison'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: rooms.map((room) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(room),
                              IconButton(
                                key: ValueKey('remove_room_$room'),
                                visualDensity: VisualDensity.compact,
                                splashRadius: 16,
                                onPressed: () {
                                  _deleteRoom(room);
                                  if (roomValue == room) {
                                    roomValue = _rooms.isNotEmpty ? _rooms.first : 'Cuisine';
                                  }
                                  setDialogState(() {});
                                },
                                icon: const Icon(Icons.close, size: 16),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            key: const ValueKey('new_room_input'),
                            controller: roomController,
                            decoration: const InputDecoration(
                              labelText: 'Ajouter un lieu',
                              hintText: 'Garage, bureau...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          key: const ValueKey('add_room_button'),
                          onPressed: () {
                            final newRoom = roomController.text.trim();
                            if (newRoom.isEmpty) {
                              return;
                            }
                            _addRoom(newRoom);
                            roomController.clear();
                            roomValue = newRoom;
                            setDialogState(() {});
                          },
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
                FilledButton(
                  key: const ValueKey('add_task_dialog_button'),
                  onPressed: () {
                    final title = controller.text.trim();
                    if (title.isEmpty) {
                      return;
                    }

                    final newTask = Task(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: title,
                      room: roomValue,
                      done: false,
                    );

                    setState(() {
                      _tasks.insert(0, newTask);
                    });
                    StorageService.saveTasks(_tasks);
                    Navigator.pop(context);
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _toggleItem(String id) {
    setState(() {
      for (int index = 0; index < _shoppingItems.length; index++) {
        final item = _shoppingItems[index];
        if (item.id == id) {
          _shoppingItems[index] = item.copyWith(checked: !item.checked);
          break;
        }
      }
    });
    StorageService.saveShoppingItems(_shoppingItems);
  }

  void _deleteItem(String id) {
    setState(() {
      _shoppingItems.removeWhere((item) => item.id == id);
    });
    StorageService.saveShoppingItems(_shoppingItems);
  }

  Future<void> _addItem() async {
    final controller = TextEditingController();
    String categoryValue = 'Produits frais';

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter un produit'),
          content: SizedBox(
            width: 320,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Nom du produit',
                    hintText: 'Ex: yaourt, œufs, riz',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: categoryValue,
                  decoration: const InputDecoration(
                    labelText: 'Catégorie',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Produits frais',
                      child: Text('Produits frais'),
                    ),
                    DropdownMenuItem(
                      value: 'Boulangerie',
                      child: Text('Boulangerie'),
                    ),
                    DropdownMenuItem(value: 'Fruits', child: Text('Fruits')),
                    DropdownMenuItem(
                      value: 'Épicerie',
                      child: Text('Épicerie'),
                    ),
                    DropdownMenuItem(
                      value: 'Maison',
                      child: Text('Maison'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      categoryValue = value;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            FilledButton(
              key: const ValueKey('add_shopping_item_button'),
              onPressed: () {
                final name = controller.text.trim();
                if (name.isEmpty) {
                  return;
                }

                setState(() {
                  _shoppingItems.insert(
                    0,
                    ShoppingItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      category: categoryValue,
                      checked: false,
                    ),
                  );
                });
                StorageService.saveShoppingItems(_shoppingItems);
                Navigator.pop(context);
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePilotHomePage(
        tasks: _tasks,
        onToggleTask: _toggleTask,
        onDeleteTask: _deleteTask,
        onAddTask: _addTask,
      ),
      ShoppingPage(
        items: _shoppingItems,
        onToggleItem: _toggleItem,
        onDeleteItem: _deleteItem,
        onAddItem: _addItem,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? 'HomePilot' : 'Liste des courses',
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Courses',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _addTask,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter'),
            )
          : FloatingActionButton.extended(
              onPressed: _addItem,
              icon: const Icon(Icons.add_shopping_cart_outlined),
              label: const Text('Ajouter'),
            ),
    );
  }
}
