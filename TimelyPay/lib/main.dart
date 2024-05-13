// ignore_for_file: library_private_types_in_public_api

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const TimelyPayApp());
}

class TimelyPayApp extends StatelessWidget {
  const TimelyPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TimelyPay',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PaymentRemindersScreen(),
    );
  }
}

class PaymentReminder {
  final String reminder;
  final DateTime dueDate;
  final Color color;

  PaymentReminder({required this.reminder, required this.dueDate, required this.color});
}

class PaymentRemindersScreen extends StatefulWidget {
  const PaymentRemindersScreen({super.key});

  @override
  _PaymentRemindersScreenState createState() => _PaymentRemindersScreenState();
}

class _PaymentRemindersScreenState extends State<PaymentRemindersScreen> {
  List<PaymentReminder> paymentReminders = [];
  Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TimelyPay'),
      ),
      body: ListView.builder(
        itemCount: paymentReminders.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(paymentReminders[index].reminder),
            direction: DismissDirection.startToEnd,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 16.0),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              setState(() {
                paymentReminders.removeAt(index);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: paymentReminders[index].color,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                title: Text(
                  paymentReminders[index].reminder,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Due Date: ${DateFormat('yyyy-MM-dd').format(paymentReminders[index].dueDate)}',
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddReminderDialog(context);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddReminderDialog(BuildContext context) {
    TextEditingController reminderController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    Color randomColor = Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Payment Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: reminderController,
                decoration: const InputDecoration(hintText: 'Enter reminder'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Due Date:'),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      _selectDate(context, selectedDate);
                    },
                    child: Text(
                      DateFormat('yyyy-MM-dd').format(selectedDate),
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                setState(() {
                  paymentReminders.add(PaymentReminder(
                    reminder: reminderController.text,
                    dueDate: selectedDate,
                    color: randomColor,
                  ));
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime selectedDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate; 
      });
    }
  }
}