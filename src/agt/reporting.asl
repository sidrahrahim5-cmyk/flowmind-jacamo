// Reporting Agent
// BELIEFS
incidents_resolved(0).

// INITIAL GOAL
!start.

+!start <-
    .print("=== Reporting Agent Started === Waiting for work orders...").

+dispatch_request(Equipment, Severity, TTF, RootCause)
    : Severity == high <-
    ?incidents_resolved(Count);
    NewCount = Count + 1;
    -incidents_resolved(Count);
    +incidents_resolved(NewCount);
    .print("=== SHIFT REPORT UPDATE ===");
    .print("Equipment  : ", Equipment);
    .print("Severity   : EMERGENCY");
    .print("Root Cause : ", RootCause);
    .print("TTF        : ", TTF, " hours");
    .print("Status     : Technician Dispatched");
    .print("Total incidents resolved: ", NewCount);
    .print("===========================").

+dispatch_request(Equipment, Severity, TTF, RootCause)
    : Severity == medium <-
    ?incidents_resolved(Count);
    NewCount = Count + 1;
    -incidents_resolved(Count);
    +incidents_resolved(NewCount);
    .print("=== SHIFT REPORT UPDATE ===");
    .print("Equipment  : ", Equipment);
    .print("Severity   : SCHEDULED");
    .print("Root Cause : ", RootCause);
    .print("TTF        : ", TTF, " hours");
    .print("Status     : Maintenance Scheduled");
    .print("Total incidents resolved: ", NewCount);
    .print("===========================").
    