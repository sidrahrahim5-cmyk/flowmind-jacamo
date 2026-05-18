// People Flow Predictor Agent
// BELIEFS: time of day context
time_of_day(rush_hour).
expected_passengers(340).

// INITIAL GOAL
!start.

+!start <-
    .print("=== People Flow Agent Started ===");
    !assess_demand.

+!assess_demand <-
    ?time_of_day(Time);
    ?expected_passengers(Count);
    .print("Time context: ", Time, " | Passengers expected: ", Count);
    if (Time == rush_hour) {
        .print("DEMAND: HIGH - Rush hour detected!");
        .send(dispatch, tell, demand(high, Count))
    } else {
        .print("DEMAND: LOW - Off peak.");
        .send(dispatch, tell, demand(low, Count))
    }.