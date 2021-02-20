import 'package:flutter/material.dart';

class SelectInput<T> extends StatefulWidget {
  final Function(T) onChange;
  final List<T> items;
  final String label;
  final Icon icon;

  SelectInput(
      {@required this.onChange, @required this.items, this.label, this.icon});

  @override
  _SelectInputState<T> createState() => _SelectInputState<T>();
}

class _SelectInputState<T> extends State<SelectInput<T>> {
  T value;

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      builder: (FormFieldState<T> state) {
        return InputDecorator(
          decoration: InputDecoration(
            icon: widget.icon ?? const Icon(Icons.list_outlined),
            labelText: widget.label ?? 'Select',
          ),
          isEmpty: value == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isDense: true,
              onChanged: (T newValue) {
                widget.onChange(newValue);
                setState(() => value = newValue);
              },
              items: widget.items.map((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(item.toString()),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
