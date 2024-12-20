enum StepType {
  precursorDelivery,
  precursorPurge,
  oxidantPurge,
  temperatureControl,
  pressureControl,
  wait,
  loop,
  substrateRotation,
}

/// Recipe tags for versioning
enum RecipeTag {
  stable,
  testing,
  optimized,
  experimental,
  deprecated
}

/// Export formats for recipes
enum RecipeExportFormat {
  json,
  yaml,
  xml,
  pdf
}

