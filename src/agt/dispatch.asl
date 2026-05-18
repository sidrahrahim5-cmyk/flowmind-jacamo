// Dispatch Coordinator Agent
// BELIEFS: technician availability
technician(mikael, elevator, available).
technician(anna, escalator, available).

// INITIAL GOAL
!start.

+!start <-
    .print("=== Dispatch Coordinator Started === Waiting for reports...").

+dispatch_request(Equipment, Severity, TTF, RootCause)
    : Severity == high <-
    .print("DISPATCH: EMERGENCY for ", Equipment);
    .print("Root cause: ", RootCause, " | TTF: ", TTF, "h");
    !assign_technician(Equipment, high).

+dispatch_request(Equipment, Severity, TTF, RootCause)
    : Severity == medium <-
    .print("DISPATCH: SCHEDULED for ", Equipment);
    .print("Root cause: ", RootCause, " | TTF: ", TTF, "h");
    !assign_technician(Equipment, medium).

+!assign_technician(Equipment, high) <-
    if (Equipment == elv01) {
        .print("Assigning: Mikael Virtanen - Elevator Specialist");
        .print("ACTION: Immediate dispatch!")
    } else {
        .print("Assigning: Anna Korhonen - Escalator Specialist");
        .print("ACTION: Immediate dispatch!")
    }.

+!assign_technician(Equipment, medium) <-
    .print("ACTION: Schedule within 24 hours.");
    if (Equipment == elv01) {
        .print("Assigned: Mikael Virtanen - next available slot")
    } else {
        .print("Assigned: Anna Korhonen - next available slot")
    }.

+demand(Level, Count)
    : Level == high <-
    .print("DISPATCH: Rush hour demand - ", Count, " passengers");
    .print("DISPATCH: Prioritizing all emergency repairs!").

+demand(Level, Count)
    : Level == low <-
    .print("DISPATCH: Low demand - ", Count, " passengers");
    .print("DISPATCH: Scheduled maintenance can proceed.").