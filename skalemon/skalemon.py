#!/usr/bin/env python3
import time
import requests
import yaml
import sys
from prometheus_client import start_http_server, Summary, Enum

metrics = {}

def fetch(l):

  for name, node in l.items():
    try:
      with metrics.get('skale_fetch_latency').labels(node=name).time():
        req = requests.get(node + "/status/core")
      res = req.json()
      for container in res.get('data'):
        metrics.get('skale_container_state').labels(container_name=container.get('name'), node=name, image=container.get('image')).state(container.get('state').get('Status'))

      if res.get('error') is None:
        metrics.get('skale_fetch_status').labels(node=name).state('OK')
      else:
        metrics.get('skale_fetch_status').labels(node=name).state('Error')
    except requests.exceptions.Timeout:
        metrics.get('skale_fetch_status').labels(node=name).state('Timeout')
    except requests.exceptions.TooManyRedirects:
        metrics.get('skale_fetch_status').labels(node=name).state('RedirectLoop')
    except requests.exceptions.RequestException as e:
        metrics.get('skale_fetch_status').labels(node=name).state('Exception')
    except Exception as e:
        metrics.get('skale_fetch_status').labels(node=name).state('Other')

if __name__ == '__main__':
    with open(sys.argv[1]) as file:
      config = yaml.load(file, Loader=yaml.FullLoader)
      file.close()
    # Start up the server to expose the metrics.
    start_http_server(config.get('port', 8000))

    metrics.update({'skale_container_state': Enum('skale_container_state', 'Container State',
        ['container_name', 'node', 'image'], states=['starting', 'running', 'stopped', 'error', 'restarting'])})
    metrics.update({'skale_fetch_status': Enum('skale_fetch_status', 'Metrics fetch status', ['node'], states=['OK', 'Error', 'Timeout', 'RedirectLoop', 'Exception', 'Other'])})
    metrics.update({'skale_fetch_latency': Summary('skale_fetch_latency', 'Time taken to fetch per node', ['node'])})
    # Generate some requests.
    while True:
      fetch(config.get('nodes'))
      time.sleep(config.get('interval', 15))
