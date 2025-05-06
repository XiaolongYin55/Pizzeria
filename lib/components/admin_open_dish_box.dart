import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:template01/components/dish_controllers.dart';
import 'package:template01/models/dishes.dart';
import 'package:template01/view_models/dish_view_model.dart';
import 'package:uuid/uuid.dart';

class OpenDishBox extends StatefulWidget {
  @override
  _OpenDishBoxState createState() => _OpenDishBoxState();

  void triggerOpenDishBox(BuildContext context, {Dishes? dish}) {
    showDialog(
      context: context,
      barrierColor:
          Colors.black.withOpacity(0.5), // Change background transparency here
      builder: (context) => OpenDishBoxDialog(dish: dish),
    );
  }
}

class _OpenDishBoxState extends State<OpenDishBox> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class OpenDishBoxDialog extends StatefulWidget {
  final Dishes? dish;
  OpenDishBoxDialog({Key? key, this.dish}) : super(key: key);

  @override
  _OpenDishBoxDialogState createState() => _OpenDishBoxDialogState();
}

class _OpenDishBoxDialogState extends State<OpenDishBoxDialog> {
  final MyController _myCtrls = MyController();
  // final FirestoreService firestroeService = FirestoreService();
  final DishesViewModel _dishesViewModel = DishesViewModel();
  String imageUrl = '';
  bool memberPrice = false; // Use non-nullable bool for switch input
  String selectedType = 'pizza'; // Default selected option
  bool soldOut = false; // 新增的销售状态状态

  @override
  void initState() {
    super.initState();
    if (widget.dish != null) {
      soldOut = widget.dish!.soldOut; // 初始化销售状态
      _myCtrls.nameController.text = widget.dish!.name;
      _myCtrls.typeController.text = widget.dish!.type;
      _myCtrls.descriptionController.text = widget.dish!.description;
      _myCtrls.imageController.text = widget.dish!.image;
      _myCtrls.priceController.text = widget.dish!.price.toString();
      _myCtrls.quantityController.text = widget.dish!.quantity.toString();
      _myCtrls.sizeController.text = widget.dish!.size.toString();
      memberPrice = widget.dish!.memberPrice;
      selectedType = widget.dish!.type; // Initialize the dropdown value
      imageUrl = widget.dish!
          .imageUrl; // Initialize imageUrl / Initialize the dropdown value
      _myCtrls.salesVolumeController.text = widget.dish!.salesVolume.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.dish == null ? 'Add Dish' : 'Update Dish'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _myCtrls.nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: InputDecoration(labelText: 'Type'),
              items: const [
                DropdownMenuItem<String>(value: 'pizza', child: Text('Pizza')),
                DropdownMenuItem<String>(value: 'snack', child: Text('Snack')),
                DropdownMenuItem<String>(value: 'rice', child: Text('Rice')),
                DropdownMenuItem<String>(value: 'pasta', child: Text('Pasta')),
                DropdownMenuItem<String>(value: 'bread', child: Text('Bread')),
                DropdownMenuItem<String>(
                    value: 'dessert', child: Text('Dessert')),
                DropdownMenuItem<String>(value: 'steak', child: Text('Steak')),
                DropdownMenuItem<String>(
                    value: 'beverage', child: Text('Beverage')),
                DropdownMenuItem<String>(value: 'soup', child: Text('Soup')),
                DropdownMenuItem<String>(
                    value: 'one-person', child: Text('One-Person')),
                DropdownMenuItem<String>(
                    value: 'multi-person', child: Text('Multi-Person')),
              ],
              onChanged: (newValue) {
                setState(() {
                  selectedType = newValue!;
                });
              },
            ),
            TextField(
              controller: _myCtrls.descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () async {
                final file =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (file == null) return;
                String fileName =
                    DateTime.now().microsecondsSinceEpoch.toString();
                Reference referenceRoot = FirebaseStorage.instance.ref();
                Reference referenceDireImages =
                    referenceRoot.child('my_images');
                Reference referenceImageToUpload =
                    referenceDireImages.child(fileName);
                try {
                  await referenceImageToUpload.putFile(File(file.path));
                  imageUrl = await referenceImageToUpload.getDownloadURL();
                } catch (error) {}
              },
            ),
            TextField(
              controller: _myCtrls.priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: _myCtrls.quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
            ),
            TextField(
              controller: _myCtrls.sizeController,
              decoration: InputDecoration(labelText: 'Size'),
            ),
            TextField(
              controller: _myCtrls.salesVolumeController,
              decoration: InputDecoration(labelText: 'Sales Volume'),
            ),
            Row(
              children: [
                Text('Member Price: '),
                Switch(
                  value: memberPrice,
                  onChanged: (value) {
                    setState(() {
                      memberPrice = value; // Update memberPrice state
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text('Sold Out: '),
                Switch(
                  value: soldOut,
                  onChanged: (value) {
                    setState(() {
                      soldOut = value; // 更新销售状态
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            int quantity;
            int salesVolume;
            try {
              quantity = int.parse(_myCtrls.quantityController.text);
              salesVolume = int.parse(_myCtrls.salesVolumeController.text);
            } catch (e) {
              // Show error message if quantity is not a valid integer
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please enter a valid quantity')),
              );
              return;
            }

            double price;
            try {
              price = double.parse(_myCtrls.priceController.text);
            } catch (e) {
              // Show error message if price is not a valid number
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please enter a valid price')),
              );
              return;
            }
//~ add & update dish by VM
if (widget.dish == null) {
  Dishes newDish = Dishes(
    id: Uuid().v1(), // 使用UUID生成新的ID
    name: _myCtrls.nameController.text,
    type: selectedType,
    description: _myCtrls.descriptionController.text,
    image: _myCtrls.imageController.text,
    price: double.parse(_myCtrls.priceController.text),
    quantity: int.parse(_myCtrls.quantityController.text),
    size: int.parse(_myCtrls.sizeController.text),
    memberPrice: memberPrice,
    imageUrl: imageUrl,
    salesVolume: int.parse(_myCtrls.salesVolumeController.text),
    soldOut: soldOut,
    createDate: Timestamp.now(),
    updateDate: Timestamp.now(),
  );

  await _dishesViewModel.addDish(newDish);
} else {
  Dishes updatedDish = Dishes(
    id: widget.dish!.id,
    name: _myCtrls.nameController.text,
    type: selectedType,
    description: _myCtrls.descriptionController.text,
    image: _myCtrls.imageController.text,
    price: price,
    quantity: quantity,
    size: int.parse(_myCtrls.sizeController.text),
    memberPrice: memberPrice,
    imageUrl: imageUrl,
    salesVolume: salesVolume,
    soldOut: soldOut,
    createDate: widget.dish!.createDate,
    updateDate: Timestamp.now(),
  );
  await _dishesViewModel.updateDish(updatedDish);
}

            // input cleaning
            _myCtrls.idController.clear();
            _myCtrls.nameController.clear();
            _myCtrls.typeController.clear();
            _myCtrls.descriptionController.clear();
            _myCtrls.imageController.clear();
            _myCtrls.priceController.clear();
            _myCtrls.quantityController.clear();
            _myCtrls.sizeController.clear();
            _myCtrls.salesVolumeController.clear(); // Clear salesVolume input
            Navigator.pop(context);
          },
          child: Text(widget.dish == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}
