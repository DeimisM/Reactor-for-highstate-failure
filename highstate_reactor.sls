
{% if data['fun'] == 'state.highstate' and data.get('retcode', 0) != 0 %}
{% set timestamp = salt['cmd.run']('date "+%Y-%m-%d %H:%M:%S"') %}

create_log_dir:
  local.file.mkdir:
    - tgt: "{{ data['id'] }}"
    - arg:
      - "/var/lib/prometheus/node-exporter"

create_log_file:
  local.file.write:
    - tgt: "{{ data['id'] }}"
    - arg:
      - "/var/lib/prometheus/node-exporter/salt_highstate_monitoring.prom"
      - |-
        # Metric return codes:
        # 0 - Highstate completed successfully; no state failures.
        # 1 - Highstate execution failed due to a general error.
        # 2 - Highstate completed with changes, but at least one state failed.
        salt_highstate{timestamp="{{ timestamp }}"} {{ data['retcode'] }}
    - require:
      - create_log_dir
{% endif %}
