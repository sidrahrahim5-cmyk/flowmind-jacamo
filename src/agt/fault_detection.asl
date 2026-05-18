{ include("$jacamo/templates/common-cartago.asl") }

// Fault Detection Agent
// SCENARIO 1: Rush Hour Fault
sensor(elv01, vibration, 8.5).
sensor(elv01, temperature, 70.0).
sensor(elv01, door_cycles, 500.0).

// SCENARIO 2: Cascading Fault
sensor(esc_a, vibration, 9.2).
sensor(esc_a, temperature, 60.0).
sensor(esc_a, door_cycles, 400.0).

sensor(esc_b, vibration, 3.0).
sensor(esc_b, temperature, 78.0).
sensor(esc_b, door_cycles, 300.0).

// INITIAL GOAL
!start.

+!start <-
    .print("=== Fault Detection Agent Started ===");
    .print("--- Scenario 1: Rush Hour Fault ---");
    !check_sensor(elv01);
    .print("--- Scenario 2: Cascading Fault ---");
    !check_sensor(esc_a);
    !check_sensor(esc_b).

+!check_sensor(Equipment) <-
    ?sensor(Equipment, vibration, V);
    ?sensor(Equipment, temperature, T);
    ?sensor(Equipment, door_cycles, D);
    .print("Checking ", Equipment, " | Vib:", V, " Temp:", T, " Doors:", D);
    if (V > 7.0) {
        .print("ALERT: High vibration on ", Equipment);
        !classify_by_vibration(Equipment, V, T, D)
    } else { if (T > 75.0) {
        .print("ALERT: High temperature on ", Equipment);
        !classify_by_temperature(Equipment, V, T, D)
    } else {
        .print("OK: ", Equipment, " is normal.")
    }}.

+!classify_by_vibration(Equipment, V, T, D) <-
    if (V > 8.0) {
        .print("Severity: HIGH on ", Equipment);
        .send(diagnostic, tell, fault(Equipment, high, V, T, D))
    } else {
        .print("Severity: MEDIUM on ", Equipment);
        .send(diagnostic, tell, fault(Equipment, medium, V, T, D))
    }.

+!classify_by_temperature(Equipment, V, T, D) <-
    if (T > 75.0) {
        .print("Severity: MEDIUM on ", Equipment);
        .send(diagnostic, tell, fault(Equipment, medium, V, T, D))
    } else {
        .print("Severity: LOW on ", Equipment);
        .send(diagnostic, tell, fault(Equipment, low, V, T, D))
    }.