import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/add_expense_screen.dart';

void main() {
  runApp(ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: ExpenseListScreen(),
    );
  }
}

class ExpenseListScreen extends StatefulWidget {
  @override
  _ExpenseListScreenState createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  List<Map<String, dynamic>> _expenses = [];

@override
void initState(){
  super.initState();
  _loadExpenses();
}


Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final expenseStrings = prefs.getStringList('expenses') ?? [];
    setState(() {
      _expenses = expenseStrings.map((expense) {
        final parts = expense.split('|');
        return {
          'title': parts[0],
          'amount': double.parse(parts[1]),
        };
      }).toList();
    });
  }

  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final expenseStrings = _expenses.map((expense) {
      return "${expense['title']}|${expense['amount']}";
    }).toList();
    await prefs.setStringList('expenses', expenseStrings);
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: _expenses.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_expenses[index]['title']),
            trailing: Text('\$${_expenses[index]['amount'].toStringAsFixed(2)}'),
            
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newExpense = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          );
          if (newExpense != null) {
            setState(() {
              _expenses.add(newExpense);
              debugPrint("Added expense: ${newExpense['title']} - \$${newExpense['amount']}");
            });
            _saveExpenses();

          }
        },
        child: Icon(Icons.add),
        tooltip: 'Add Expense',
      ),
    );
  }
}