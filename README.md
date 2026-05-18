# FlowMind — BDI Multi-Agent System

A JaCaMo-based Multi-Agent System (MAS) for predictive maintenance of elevators and escalators using BDI (Belief-Desire-Intention) reasoning.

## Agents

| Agent | Role |
|---|---|
| `fault_detection` | Monitors sensor readings and detects faults |
| `diagnostic` | Analyzes root cause and estimates time-to-failure |
| `dispatch` | Coordinates technician assignment |
| `people_flow` | Monitors passenger demand |
| `reporting` | Generates shift reports |

## Scenarios

**Scenario 1 — Rush Hour Fault (Helsinki Tower)**
ELV-01 bearing wear detected during peak load (340 passengers). Emergency dispatch triggered before failure.

**Scenario 2 — Cascading Fault (Shopping Mall)**
ESC-A emergency (vibration 9.2) + ESC-B scheduled (temp 78°C). BDI triage — dual technician dispatch.

## BDI Concepts Demonstrated

- **Beliefs:** Sensor readings, time-of-day context, passenger counts
- **Goals:** `!detect_fault`, `!diagnose`, `!dispatch`, `!assess_demand`
- **Plans:** Severity-based plan selection, conflict resolution via triage

## Tech Stack

- **JaCaMo** — BDI agent framework (Jason + CArtAgO)
- **AgentSpeak** — Agent programming language
- **Python Flask** — Real-time monitoring dashboard

## How to Run

**Run JaCaMo agents:**
```bash
.\gradlew -q --console=plain 2>&1 | Tee-Object -FilePath logs\events.log
```

**Run Flask dashboard:**
```bash
cd dashboard
python app.py
```

Open browser: http://127.0.0.1:5000