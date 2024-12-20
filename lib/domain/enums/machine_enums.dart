enum MachineStatus {
  idle,
  running,
  maintenance,
  error,
  standby,
  initializing,
  shuttingDown
}

enum MachineType {
  thermalALD,
  plasmaALD,
  batchALD,
  rollToRollALD,
  spatialALD
}

enum MaintenanceState {
  upToDate,
  dueForMaintenance,
  overdue,
  inMaintenance,
  scheduledMaintenance
}

enum OperationalMode {
  automatic,
  manual,
  diagnostic,
  calibration,
  safety
}



