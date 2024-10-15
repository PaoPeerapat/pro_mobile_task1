import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date
import '../services/task_service.dart';
import 'add_task_screen.dart';
import 'schedule_screen.dart';

class HomeScreen extends StatefulWidget {
  final TaskService taskService;

  const HomeScreen({super.key, required this.taskService});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final tasks = widget.taskService.getTasks();

    return Scaffold(
      appBar: AppBar(
        title: const Text('หน้าแจ้งเตือน', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 219, 197, 255), // สี AppBar
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
              ? const Center(
                  child: Text('สวัสดีนินิว ,ช่วงนี้ไม่มีภารกิจช่วยโลกเลยหรอหน่ะ เพิ่มได้แล้ว!', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                )
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final formattedDeadline = DateFormat('yyyy-MM-dd').format(task.deadline); // Format deadline

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      elevation: 5, // เพิ่มเงา
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // เพิ่มความโค้งมน
                      ),
                      child: ListTile(
                        title: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.isCompleted ? Colors.green : Colors.black,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.category,
                              style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'สิ้นสุด: $formattedDeadline', // Display the deadline
                              style: const TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            task.isCompleted
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            color: task.isCompleted ? Colors.green : Colors.grey,
                            size: 28,
                          ),
                          onPressed: () {
                            setState(() {
                              widget.taskService.toggleTaskStatus(task.id);
                            });
                          },
                        ),
                        onLongPress: () {
                          setState(() {
                            _isLoading = true;
                          });
                          Future.delayed(const Duration(seconds: 1), () {
                            widget.taskService.deleteTask(task.id);
                            setState(() {
                              _isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Task deleted successfully!')),
                            );
                          });
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTaskScreen(
                                taskService: widget.taskService,
                                taskId: task.id,
                              ),
                            ),
                          ).then((_) {
                            setState(() {});
                          });
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(taskService: widget.taskService),
            ),
          ).then((_) {
            setState(() {});
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
