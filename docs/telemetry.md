# Telemetry

The purpose of telemetry in this project is to estimate the amount
of VMs in use and their versions.

## Data collected

The following data is collected:
- `public_ip`
- `timestamp`
- `id` - machine ID
- `version` - dvm version

## Configuration

Telemetry settings are defined in
[`dvm.conf`](../roles/base/templates/dvm.conf.j2).

Values:
- `enabled` - Whether data should be sent or not
- `timeout` - Timeout before the request fails
- `server` - Address of server to send the data to

You can edit these values direcrly or with the `dvmconf` utility.
For example, run:
- `dvmconf set combine enabled false` to disable sending data
- `dvmconf set combine enabled true` to enable sending data

## Implementation

Data collection and sending is done with
[combine](../roles/base/templates/combine.py.j2).

It is run as a systemd service with a timer.
- `sudo systemctl status combine`
- `sudo systemctl status combine.timer`

## Complete removal

If you don't want to include telemetry at all, disable the `combine.yml` task
in [roles/base/tasks/main.yml](../roles/base/tasks/main.yml) before building
the virtual machine.
