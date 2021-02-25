# Chorus One SKALE-tools
A collect of tools that may be of use to validator operators on the SKALE network.

## auto-accept
This script periodically (set to two minutes) polls the list of delegations for the given validator, and accepts any delegations in the PROPOSED state.

## skalemon
SKALEmon is a prometheus exporter for SKALE nodes; it connects to the SKALE watchdog daemon running on each node, and presents a single prometheus endpoint that can be monitored using Prometheus.

## Important Notice
These tools are provided free of charge, and free of liability, under the Apache 2.0 License, which can be found in this repository under LICENSE.md.

