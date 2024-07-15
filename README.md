# About

A [`gomplate`](https://github.com/hairyhenderson/gomplate) wrapper service for rendering configuration.

## Example

The following example demonstrates how to use the `genconfig` service to render a `prometheus` configuration file.

```yaml
# Example of using the `genconfig` service to render a `prometheus` configuration file.
# https://github.com/swarmlibs/promstack/blob/main/prometheus/docker-stack.yml

services:
  prometheus-server:
    image: prom/prometheus:v2.45.6
    command:
      - --config.file=/prometheus-configs.d/prometheus.yaml
      - --storage.tsdb.path=/prometheus
      - --web.console.libraries=/usr/share/prometheus/console_libraries
      - --web.console.templates=/usr/share/prometheus/consoles
      - --web.enable-lifecycle
      - --log.level=info
    volumes:
      # ...
      - type: volume
        source: prometheus-configs
        target: /prometheus-configs.d

  prometheus:
    image: swarmlibs/genconfig:main
    command:
      - --verbose
      - --file=/run/configs/prometheus.yaml.tmpl
      - --out=/prometheus-configs.d/prometheus.yaml
    environment:
      - PROMETHEUS_CLUSTER_NAME=${PROMETHEUS_CLUSTER_NAME:-{{ index .Service.Labels "com.docker.stack.namespace"}}}
      - PROMETHEUS_CLUSTER_REPLICA=${PROMETHEUS_CLUSTER_REPLICA:-replica-{{.Task.Slot}}}
    configs:
      - source: prometheus.yaml.tmpl
        target: /run/configs/prometheus.yaml.tmpl
    volumes:
      - type: volume
        source: prometheus-configs
        target: /prometheus-configs.d

volumes:
  prometheus-configs:
```

The template file example:

```yaml
# Example of a `prometheus` configuration file template.
# https://github.com/swarmlibs/promstack/blob/main/prometheus/configs/prometheus.yaml.tmpl

global:
  scrape_interval: '{{ getenv "PROMETHEUS_SCRAPE_INTERVAL" "10s" }}'
  scrape_timeout: '{{ getenv "PROMETHEUS_SCRAPE_TIMEOUT" "5s" }}'
  evaluation_interval: '{{ getenv "PROMETHEUS_EVALUATION_INTERVAL" "1m" }}'

scrape_config_files:
  - "/etc/prometheus/scrape-configs/*"
  - "/prometheus-configs.d/scrape-configs/*"
```
