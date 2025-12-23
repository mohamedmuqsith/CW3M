import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/food.dart';
import '../providers/food_providers.dart';

class AddEditFoodScreen extends ConsumerStatefulWidget {
  final Food? food; // If null, we are adding

  const AddEditFoodScreen({super.key, this.food});

  @override
  ConsumerState<AddEditFoodScreen> createState() => _AddEditFoodScreenState();
}

class _AddEditFoodScreenState extends ConsumerState<AddEditFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _carbsController;
  late TextEditingController _fatController;
  late String _selectedCategory;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final f = widget.food;
    _nameController = TextEditingController(text: f?.name ?? '');
    _descController = TextEditingController(text: f?.description ?? '');
    _priceController = TextEditingController(text: f?.price.toString() ?? '');
    _caloriesController = TextEditingController(text: f?.calories.toString() ?? '');
    _proteinController = TextEditingController(text: f?.protein.toString() ?? '');
    _carbsController = TextEditingController(text: f?.carbs.toString() ?? '');
    _fatController = TextEditingController(text: f?.fat.toString() ?? '');
    
    // Default valid category logic needed. For now hardcode one if null.
    _selectedCategory = f?.categoryId ?? '1'; 
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  Future<void> _saveFood() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final newFood = Food(
        id: widget.food?.id ?? const Uuid().v4(),
        name: _nameController.text,
        description: _descController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        categoryId: _selectedCategory,
        imageUrl: widget.food?.imageUrl ?? 'https://via.placeholder.com/150', // Placeholder
        calories: int.tryParse(_caloriesController.text) ?? 0,
        protein: int.tryParse(_proteinController.text) ?? 0,
        carbs: int.tryParse(_carbsController.text) ?? 0,
        fat: int.tryParse(_fatController.text) ?? 0,
      );

      if (widget.food == null) {
        await ref.read(addFoodProvider).call(newFood);
      } else {
        await ref.read(updateFoodProvider).call(newFood);
      }
      
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food == null ? 'Add Food' : 'Edit Food'),
        actions: [
          if (widget.food != null)
             IconButton(
               icon: const Icon(Icons.delete),
               onPressed: () async {
                 await ref.read(deleteFoodProvider).call(widget.food!.id);
                 if (mounted) Navigator.pop(context);
               },
             )
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                
                // Category Dropdown
                categoriesAsync.when(
                  data: (categories) => DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    items: categories.map((c) => DropdownMenuItem(
                      value: c.id,
                      child: Text(c.name),
                    )).toList(),
                    onChanged: (v) => setState(() => _selectedCategory = v!),
                    decoration: const InputDecoration(labelText: 'Category'),
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, s) => Text('Error loading categories: $e'),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _caloriesController,
                        decoration: const InputDecoration(labelText: 'Calories'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                     Expanded(
                      child: TextFormField(
                        controller: _proteinController,
                        decoration: const InputDecoration(labelText: 'Protein (g)'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                     Expanded(
                      child: TextFormField(
                        controller: _carbsController,
                        decoration: const InputDecoration(labelText: 'Carbs (g)'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                     Expanded(
                      child: TextFormField(
                        controller: _fatController,
                        decoration: const InputDecoration(labelText: 'Fat (g)'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _saveFood,
                  child: Text(widget.food == null ? 'Create Food Item' : 'Update Food Item'),
                ),
              ],
            ),
          ),
    );
  }
}
