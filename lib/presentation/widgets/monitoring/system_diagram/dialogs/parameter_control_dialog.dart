// lib/presentation/widgets/monitoring/system_diagram/overlays/parameter_control_dialog.dart
import 'package:experiment_planner/domain/entities/machine/parameter.dart';
import 'package:flutter/material.dart';

class ParameterControlDialog extends StatefulWidget {
  final Parameter parameter;
  final Function(double) onValueChanged;

  const ParameterControlDialog({
    Key? key,
    required this.parameter,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  State<ParameterControlDialog> createState() => _ParameterControlDialogState();
}

class _ParameterControlDialogState extends State<ParameterControlDialog> {
  late double _currentValue;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.parameter.currentValue;
    _controller = TextEditingController(
      text: _currentValue.toStringAsFixed(1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Adjust ${widget.parameter.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _currentValue,
                  min: widget.parameter.minValue,
                  max: widget.parameter.maxValue,
                  onChanged: (value) {
                    setState(() {
                      _currentValue = value;
                      _controller.text = value.toStringAsFixed(1);
                    });
                  },
                ),
              ),
              SizedBox(
                width: 60,
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final newValue = double.tryParse(value);
                    if (newValue != null) {
                      setState(() {
                        _currentValue = newValue.clamp(
                          widget.parameter.minValue,
                          widget.parameter.maxValue,
                        );
                      });
                    }
                  },
                  decoration: InputDecoration(
                    suffixText: widget.parameter.unit,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ),
            ],
          ),
          Text(
            'Range: ${widget.parameter.minValue} - ${widget.parameter.maxValue} ${widget.parameter.unit}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onValueChanged(_currentValue);
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
