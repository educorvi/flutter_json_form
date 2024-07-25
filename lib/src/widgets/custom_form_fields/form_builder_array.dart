import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

// class FormBuilderArray<T> extends FormBuilderFieldDecoration<T> {
//   const FormBuilderArray({super.key, required super.name, required super.builder});
//
//   @override
//   FormBuilderFieldDecorationState<FormBuilderArray<T>, T>
//   createState() => _FormBuilderFieldDecorationState<T>();
// }
//
// class _FormBuilderFieldDecorationState<T>
//     extends FormBuilderFieldDecorationState<FormBuilderArray<T>, T> {
//
//   List<ListItem> items = [];
//   int _idCounter = 0;
//
//   void addItem() {
//     setState(() {
//       _idCounter++;
//       items.add(ListItem<T>(id: _idCounter));
//     });
//   }
//
//   void removeItem(int index) {
//     setState(() {
//       items.removeAt(index);
//     });
//   }
//
//   // build function
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ReorderableListView.builder(
//           shrinkWrap: true,
//           physics: const ClampingScrollPhysics(),
//           itemCount: items.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               key: Key('$index'),
//               leading: Icon(Icons.drag_handle), // This is the drag indicator
//               title: FormBuilderTextField(
//                 name: 'field_${items[index].id}',
//                 initialValue: items[index].value.toString(),
//                 decoration: InputDecoration(
//                   labelText: 'Item ${index + 1}',
//                   border: OutlineInputBorder(),
//                 ),
//                 onChanged: (value) {
//                   items[index].value = value;
//                 },
//               ),
//               trailing: IconButton(
//                 icon: Icon(Icons.close),
//                 onPressed: () => removeItem(index),
//               ),
//             );
//           },
//           onReorder: (oldIndex, newIndex) {
//             setState(() {
//               if (newIndex > oldIndex) {
//                 newIndex -= 1;
//               }
//               final ListItem item = items.removeAt(oldIndex);
//               items.insert(newIndex, item);
//             });
//           },
//         ),
//         ElevatedButton(
//           child: Text('Add Item'),
//           onPressed: addItem,
//         ),
//       ],
//     );
//   }
// }
//
//
// class ListItem<T> {
//   final int id;
//   T? value;
//
//   ListItem({required this.id, this.value});
// }

// class FormBuilderArray extends StatefulWidget {
//   const FormBuilderArray({super.key, required this.text});
//
//   @override
//   State<FormBuilderArray> createState() => _FormBuilderArrayState();
// }
//
// class _FormBuilderArrayState extends State<FormBuilderArray> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               _getLabel(),
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             FilledButton.tonal(
//               onPressed: () {
//                 addItem();
//               },
//               child: Icon(Icons.add),
//             ),
//           ],
//         ),
//         ReorderableListView.builder(
//           shrinkWrap: true,
//           physics: const ClampingScrollPhysics(),
//           itemCount: items.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               key: Key('${items[index].id}'),
//               // leading: Icon(Icons.drag_handle), // This is the drag indicator
//               title: FormBuilderTextField(
//                 name: '$scope/${items[index].id}',
//                 initialValue: items[index].value.toString(),
//                 decoration: InputDecoration(
//                   // prefixIcon: Icon(Icons.drag_handle), // This is the drag indicator
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.close),
//                     onPressed: () => removeItem(index),
//                   ),
//                   //labelText: 'Item ${index + 1}',
//                   border: OutlineInputBorder(),
//                 ),
//                 onChanged: (value) {
//                   items[index].value = value;
//                 },
//               ),
//               // trailing: IconButton(
//               //   icon: Icon(Icons.close),
//               //   onPressed: () => removeItem(index),
//               // ),
//             );
//           },
//           onReorder: (oldIndex, newIndex) {
//             setState(() {
//               if (newIndex > oldIndex) {
//                 newIndex -= 1;
//               }
//               final ListItem item = items.removeAt(oldIndex);
//               items.insert(newIndex, item);
//             });
//           },
//         ),
//       ],
//     );
//   }
// }
