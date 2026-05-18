// Diagnostic Agent

!start.

+!start <-
    .print("=== Diagnostic Agent Started === Waiting for faults...").

+fault(Equipment, Severity, V, T, D)
    : Severity == high <-
    .print("DIAGNOSTIC: Emergency case - ", Equipment);
    .print("Root cause: Bearing wear - vibration=", V);
    TTF = 1.5;
    .print("Time to failure: ", TTF, " hours");
    .send(dispatch, tell, dispatch_request(Equipment, high, TTF, bearing_wear));
    .send(reporting, tell, dispatch_request(Equipment, high, TTF, bearing_wear)).

+fault(Equipment, Severity, V, T, D)
    : Severity == medium <-
    if (T > 75.0) {
        .print("DIAGNOSTIC: Scheduled case - ", Equipment);
        .print("Root cause: Motor overheating - temp=", T);
        TTF = 5.0
    } else {
        .print("DIAGNOSTIC: Scheduled case - ", Equipment);
        .print("Root cause: Motor stress - vibration=", V);
        TTF = 4.0
    };
    .print("Time to failure: ", TTF, " hours");
    .send(dispatch, tell, dispatch_request(Equipment, medium, TTF, motor_issue));
    .send(reporting, tell, dispatch_request(Equipment, medium, TTF, motor_issue)).