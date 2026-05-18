from flask import Flask, render_template, jsonify
import os
import re

app = Flask(__name__)

LOG_FILE = os.path.join(os.path.dirname(__file__), '..', 'logs', 'events.log')

def parse_log():
    agent_stats = {
        'fault_detection': {'messages': 0, 'status': 'idle'},
        'diagnostic':      {'messages': 0, 'status': 'idle'},
        'dispatch':        {'messages': 0, 'status': 'idle'},
        'people_flow':     {'messages': 0, 'status': 'idle'},
        'reporting':       {'messages': 0, 'status': 'idle'},
    }
    events    = []
    incidents = []
    kpis      = {'total': 0, 'emergency': 0, 'scheduled': 0, 'passengers': 0}

    if not os.path.exists(LOG_FILE):
        return events, agent_stats, incidents, kpis

    with open(LOG_FILE, 'r', encoding='utf-16', errors='ignore') as f:
        raw = f.read()

    # Join broken lines — Windows Tee-Object wraps long lines
    # Merge continuation lines (lines not starting with [)
    lines = raw.splitlines()
    merged = []
    current = ''
    for line in lines:
        line = line.strip()
        if not line:
            continue
        if line.startswith('['):
            if current:
                merged.append(current)
            current = line
        else:
            current += ' ' + line
    if current:
        merged.append(current)

    for line in merged:
        match = re.match(r'\[(\w+)\]\s+(.+)', line)
        if not match:
            continue

        agent   = match.group(1)
        message = match.group(2).strip()

        if agent not in agent_stats:
            continue

        # Event type
        if 'EMERGENCY' in message:
            etype = 'emergency'
        elif 'ALERT' in message or 'SCHEDULED' in message:
            etype = 'alert'
        elif 'Started' in message:
            etype = 'system'
        elif 'SHIFT REPORT' in message or 'Equipment' in message:
            etype = 'report'
        else:
            etype = 'info'

        events.append({'agent': agent, 'message': message, 'type': etype})

        # Agent stats
        agent_stats[agent]['messages'] += 1
        if 'EMERGENCY' in message or 'ALERT' in message:
            agent_stats[agent]['status'] = 'alert'
        else:
            agent_stats[agent]['status'] = 'active'

        # KPIs
        if 'DISPATCH: EMERGENCY for' in message:
            eq = message.split('for ')[-1].strip()
            incidents.append({'equipment': eq, 'severity': 'EMERGENCY', 'technician': ''})
            kpis['emergency'] += 1
            kpis['total'] += 1

        if 'DISPATCH: SCHEDULED for' in message:
            eq = message.split('for ')[-1].strip()
            incidents.append({'equipment': eq, 'severity': 'SCHEDULED', 'technician': ''})
            kpis['scheduled'] += 1
            kpis['total'] += 1

        if 'Passengers expected:' in message:
            num = re.search(r'(\d+)', message)
            if num:
                kpis['passengers'] = int(num.group(1))

        if 'Assigning:' in message and incidents:
            tech = message.replace('Assigning: ', '').strip()
            incidents[-1]['technician'] = tech

    return events, agent_stats, incidents, kpis


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/api/data')
def api_data():
    events, agent_stats, incidents, kpis = parse_log()
    return jsonify({
        'events':    events[-50:],
        'agents':    agent_stats,
        'incidents': incidents,
        'kpis':      kpis
    })


if __name__ == '__main__':
    app.run(debug=True, port=5000)