import 'package:flutter/material.dart';

class AddExpenseScreen extends StatelessWidget {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Expense"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
              
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder()
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16.0,)
            ,ElevatedButton(onPressed: (){

              String? titleText = _titleController.text;
              String? amountText = _amountController.text;

              if(titleText.isNotEmpty && amountText.isNotEmpty){
                double? amount = double.tryParse(amountText);
                if(amount!=null){
                  Navigator.pop(context,{
                    "title":titleText,
                    "amount":amount,
                  });
                }else{
                  debugPrint("Invalid input try again");
                }
              }else{
                debugPrint("Title or Amount Can't be empty");
              }


            }, child: Text("Add"))
          ],
        ),
      ), 
    );
  }
}