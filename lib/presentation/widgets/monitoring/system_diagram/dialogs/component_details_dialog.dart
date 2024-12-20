// lib/presentation/widgets/monitoring/system_diagram/dialogs/component_details_dialog.dart
import 'package:experiment_planner/domain/entities/machine/component.dart';
import 'package:flutter/material.dart';

class ComponentDetailsDialog extends StatefulWidget {
  final Component component;

  const ComponentDetailsDialog({
    Key? key,
    required this.component,
  }) : super(key: key);

  @override
  State<ComponentDetailsDialog> createState() => _ComponentDetailsDialogState();
}

class _ComponentDetailsDialogState extends State<ComponentDetailsDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.component.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Parameters'),
                Tab(text: 'History'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildParametersTab(),
                  _buildHistoryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return ListView(
      children: [
        _buildStatusCard(),
        const SizedBox(height: 16),
        _buildMaintenanceInfo(),
        const SizedBox(height: 16),
        _buildAlerts(),
      ],
    );
  }

  Widget _buildParametersTab() {
    return ListView.builder(
      itemCount: widget.component.parameters.length,
      itemBuilder: (context, index) {
        final parameter = widget.component.parameters[index];
        return ParameterListTile(
          parameter: parameter,
          onAdjust: (value) {
            context.read<MachineBloc>().add(
                  UpdateParameter(
                    componentId: widget.component.id,
                    parameterId: parameter.id,
                    value: value,
                  ),
                );
          },
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    // Implementation for history tab...
    return const Center(
      child: Text('Historical data view'),
    );
  }

  // Additional helper methods for building UI components...
}