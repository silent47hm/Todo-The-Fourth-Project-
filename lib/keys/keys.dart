import 'package:flutter/material.dart';
import 'checkable_todo_item.dart';
// import 'package:flutter_internals/keys/checkable_todo_item.dart';
// import 'package:flutter_internals/keys/todo_item.dart';

class Todo {
  const Todo(this.text, this.priority);

  final String text;
  final Priority priority;
}

class Keys extends StatefulWidget {
  const Keys({super.key});

  @override
  State<Keys> createState() {
    return _KeysState();
  }
}

class _KeysState extends State<Keys> {
  final TextEditingController titleController = TextEditingController();
  var _order = 'asc';
  final _todos = [
    const Todo(
      'Learn Flutter',
      Priority.urgent,
    ),
    const Todo(
      'Practice Flutter',
      Priority.normal,
    ),
    const Todo(
      'Explore other courses',
      Priority.low,
    ),
  ];

  List<Todo> get _orderedTodos {
    final sortedTodos = List.of(_todos);
    sortedTodos.sort((a, b) {
      final bComesAfterA = a.text.compareTo(b.text);
      return _order == 'asc' ? bComesAfterA : -bComesAfterA;
    });
    return sortedTodos;
  }

  void _changeOrder() {
    setState(() {
      _order = _order == 'asc' ? 'desc' : 'asc';
    });
  }

  void addItem(String titleText, Priority priority) {
    setState(() {
      _todos.add(Todo(titleText, priority));
    });
  }

  void showSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 600,
          color: Color.fromARGB(255, 241, 249, 253),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('AddTodoItem'),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Enter Name',
                      hintText: 'Enter Your Name'),
                ),
                ElevatedButton(
                    child: const Text('Close BottomSheet'),
                    onPressed: () {
                      addItem(titleController.text, Priority.normal);
                      Navigator.pop(context);
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Internals'),
        actions: [IconButton(onPressed: showSheet, icon: Icon(Icons.add))],
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _changeOrder,
              icon: Icon(
                _order == 'asc' ? Icons.arrow_downward : Icons.arrow_upward,
              ),
              label:
                  Text('Sort ${_order == 'asc' ? 'Descending' : 'Ascending'}'),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                // for (final todo in _orderedTodos) TodoItem(todo.text, todo.priority),
                for (final todo in _orderedTodos)
                  Dismissible(
                    key: ObjectKey(todo),
                    child: CheckableTodoItem(
                      // ValueKey()
                      todo.text,
                      todo.priority,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
