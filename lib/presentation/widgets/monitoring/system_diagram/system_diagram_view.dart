// lib/presentation/widgets/monitoring/system_diagram/system_diagram_view.dart
import 'package:experiment_planner/presentation/bloc/machine/machine_bloc.dart';
import 'package:experiment_planner/presentation/bloc/machine/machine_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/machine/machine.dart';
import 'overlays/component_overlay.dart';
import 'overlays/parameter_overlay.dart';
import 'overlays/graph_overlay.dart';

class SystemDiagramView extends StatefulWidget {
  final double zoomFactor;
  final bool enableOverlaySwiping;

  const SystemDiagramView({
    Key? key,
    this.zoomFactor = 1.0,
    this.enableOverlaySwiping = true,
  }) : super(key: key);

  @override
  State<SystemDiagramView> createState() => _SystemDiagramViewState();
}

class _SystemDiagramViewState extends State<SystemDiagramView> {
  late PageController _overlayController;
  int _currentOverlay = 0;

  final List<Widget> _overlays = [];

  @override
  void initState() {
    super.initState();
    _overlayController = PageController();
    _initializeOverlays();
  }

  void _initializeOverlays() {
    _overlays.addAll([
      ComponentOverlay(key: const ValueKey('component')),
      ParameterOverlay(key: const ValueKey('parameter')),
      GraphOverlay(key: const ValueKey('graph')),
    ]);
  }

  @override
  void dispose() {
    _overlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MachineBloc, MachineState>(
      builder: (context, state) {
        return Stack(
          children: [
            // Base System Diagram
            _buildBaseDiagram(),

            // Active Overlays
            if (state is MachineMonitoring)
              _buildOverlays(state.machine),

            // Overlay Controls
            if (widget.enableOverlaySwiping && _overlays.length > 1)
              _buildOverlayControls(),
          ],
        );
      },
    );
  }

  Widget _buildBaseDiagram() {
    return Positioned.fill(
      child: InteractiveViewer(
        maxScale: 4.0,
        minScale: 0.5,
        boundaryMargin: const EdgeInsets.all(double.infinity),
        child: Transform.scale(
          scale: widget.zoomFactor,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Image.asset(
              'assets/images/ald_system_diagram.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverlays(Machine machine) {
    if (widget.enableOverlaySwiping) {
      return Positioned.fill(
        child: PageView(
          controller: _overlayController,
          onPageChanged: (index) {
            setState(() => _currentOverlay = index);
          },
          children: _overlays,
        ),
      );
    }

    return Positioned.fill(
      child: _overlays[_currentOverlay],
    );
  }

  Widget _buildOverlayControls() {
    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.layers),
              color: _currentOverlay == 0 ? Colors.blue : Colors.white,
              onPressed: () => _overlayController.animateToPage(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              tooltip: 'Component View',
            ),
            IconButton(
              icon: const Icon(Icons.developer_board),
              color: _currentOverlay == 1 ? Colors.blue : Colors.white,
              onPressed: () => _overlayController.animateToPage(
                1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              tooltip: 'Parameter View',
            ),
            IconButton(
              icon: const Icon(Icons.show_chart),
              color: _currentOverlay == 2 ? Colors.blue : Colors.white,
              onPressed: () => _overlayController.animateToPage(
                2,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              tooltip: 'Graph View',
            ),
          ],
        ),
      ),
    );
  }
}