import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import this package for date formatting
import '../services/task_service.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskService taskService;
  final String? taskId;

  const AddTaskScreen({super.key, required this.taskService, this.taskId});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _controller = TextEditingController();
  String _selectedCategory = 'General';
  DateTime _deadline = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.taskId != null) {
      final task = widget.taskService.getTasks().firstWhere((t) => t.id == widget.taskId);
      _controller.text = task.title;
      _deadline = task.deadline;
      _selectedCategory = task.category;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    // Open a date picker dialog
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _deadline) {
      setState(() {
        _deadline = picked; // Update the _deadline variable
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.taskId == null ? 'เพิ่มเเจ้งเตือน' : 'แก้ไข')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          labelText: 'เรื่องที่ต้องทำ',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButton<String>(
                        value: _selectedCategory,
                        isExpanded: true,
                        items: <String>['General', 'Work', 'Personal', 'Shopping']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("สิ้นสุด: ${DateFormat('yyyy-MM-dd').format(_deadline)}"),
                          TextButton(
                            onPressed: () => _selectDate(context),
                            child: const Text('เลือกวันได้เลย'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final title = _controller.text.trim();
                  if (title.isNotEmpty) {
                    if (widget.taskId == null) {
                      widget.taskService.addTask(title, _selectedCategory, _deadline);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('เพิ่มสำเร็จ')),
                      );
                    } else {
                      final task = widget.taskService.getTasks().firstWhere((t) => t.id == widget.taskId);
                      task.title = title;
                      task.category = _selectedCategory;
                      task.deadline = _deadline; // Update deadline if editing
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('แก้ไขสำเร็จ')),
                      );
                    }
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a task title.')),
                    );
                  }
                },
                child: Text(widget.taskId == null ? 'เพิ่มข้อมูล' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
