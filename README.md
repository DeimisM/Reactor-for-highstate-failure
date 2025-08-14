# Reactor for Highstate Failure Monitoring

This repository contains a **SaltStack reactor configuration** for monitoring **`state.highstate`** failures using Salt's event bus.  
When a highstate run fails (retcode != 0), the reactor logs the failure as a Prometheus-compatible metric file on the target minion.  

---

## 📦 Contents

- **`master`**  
  Salt master configuration snippet that binds the reactor to the Salt event bus.
- **`highstate_reactor.sls`**  
  Reactor SLS file that creates a Prometheus `.prom` metric file when highstate fails.

---

## ⚙️ Setup:

1. **Master config**  
   This should go into your master config:  
   ```yaml
   reactor:
     - 'salt/job/*/ret/*':
       - /srv/salt/reactor/highstate_reactor.sls

2. **Reactor File**  
   Create `/srv/salt/reactor/highstate_reactor.sls` with its contents.

4. **Restart salt master**  
   `systemctl restart salt-master`

## Output:
`cat /var/lib/prometheus/node-exporter/salt_highstate_monitoring.prom`

## 📊 Example Prometheus Metric Output
 Metric return codes:
 - 0 - Highstate completed successfully; no state failures.
 - 1 - Highstate execution failed due to a general error.
 - 2 - Highstate completed with changes, but at least one state failed.
## Example:
`salt_highstate{timestamp="2025-06-14 12:34:56"} 2`

## 📅 Metadata
- Salt version: 3006 LTS
- Date: 2025-06-14
