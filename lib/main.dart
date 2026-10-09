 import ‘package:flutter/material.dart’;

void main() {
runApp(const SultanporaApp());
}

class SultanporaApp extends StatelessWidget {
const SultanporaApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
title: ‘Sultanpora Khata Book’,
theme: ThemeData(
colorSchemeSeed: Colors.green,
useMaterial3: true,
),
home: const KhataHome(),
);
}
}

class KhataHome extends StatefulWidget {
const KhataHome({super.key});

@override
State createState() => _KhataHomeState();
}

class _KhataHomeState extends State {
final List<Map<String, dynamic>> customers = [];
final TextEditingController nameController =
TextEditingController();
final TextEditingController amountController =
TextEditingController();

double get totalDue => customers.fold(
0,
(sum, customer) => sum + customer[‘balance’],
);

void addCustomer() {
nameController.clear();
amountController.clear();

showDialog(
  context: context,
  builder: (dialogContext) => AlertDialog(
    title: const Text('Add Customer'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Customer name',
          ),
        ),
        TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Opening balance (₹)',
          ),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(dialogContext),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () {
          final name = nameController.text.trim();
          final amount =
              double.tryParse(amountController.text) ?? 0;
          if (name.isEmpty || amount < 0) return;
          setState(() {
            customers.add({
              'name': name,
              'balance': amount,
            });
          });
          Navigator.pop(dialogContext);
        },
        child: const Text('Save'),
      ),
    ],
  ),
);

}

@override
void dispose() {
nameController.dispose();
amountController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text(
‘Sultanpora Khata Book’,
style: TextStyle(fontWeight: FontWeight.bold),
),
backgroundColor: Colors.green,
foregroundColor: Colors.white,
),
body: Column(
children: [
Card(
margin: const EdgeInsets.all(16),
color: Colors.green.shade50,
child: Padding(
padding: const EdgeInsets.all(20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(‘Total Customer Balance’),
const SizedBox(height: 8),
Text(
‘₹${totalDue.toStringAsFixed(2)}’,
style: const TextStyle(
fontSize: 30,
fontWeight: FontWeight.bold,
color: Colors.green,
),
),
const SizedBox(height: 8),
Text(‘Customers: ${customers.length}’),
],
),
),
),
Padding(
padding: const EdgeInsets.symmetric(horizontal: 16),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
const Text(
‘Customer Accounts’,
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),
FilledButton.icon(
onPressed: addCustomer,
icon: const Icon(Icons.person_add),
label: const Text(‘Add’),
),
],
),
),
Expanded(
child: customers.isEmpty
? const Center(
child: Text(
‘No customers yet.\nTap Add to create an account.’,
textAlign: TextAlign.center,
),
)
: ListView.builder(
itemCount: customers.length,
itemBuilder: (context, index) {
final customer = customers[index];
return ListTile(
leading: const CircleAvatar(
child: Icon(Icons.person),
),
title: Text(customer[‘name’]),
subtitle: const Text(‘Outstanding balance’),
trailing: Text(
‘₹${(customer[‘balance’] as double).toStringAsFixed(2)}’,
style: const TextStyle(
fontWeight: FontWeight.bold,
),
),
);
},
),
),
],
),
floatingActionButton: FloatingActionButton(
onPressed: addCustomer,
backgroundColor: Colors.green,
foregroundColor: Colors.white,
child: const Icon(Icons.add),
),
);
}
}
