library globals;

String currentDepartment = ""; // e.g., "CSE", "IT", etc.
String currentUserRole = ""; // "admin" or "student"

// Global map to store the completion status for placement materials.
// The key is the material ID and the value is true if the user has ticked it.
Map<String, bool> placementCompletion = {};
