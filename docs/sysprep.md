# sysprep

`sysprep` is a **dvm** script that prepares the system for distribution.

The script
- Executes `remove-kernels` to remove all old kernels and their associated headers/modules
- Cleans APT
- Resets the `machine-id`
- Removes SSH host keys
- Cleans all user histories
- Clears logs
- Trims the filesystem

## Variables

To disable a specific part of the script, you can use these variables.

- `SYSPREP_SKIP_BOOTCOUNT`: if `true`, skips boot counter reset
- `SYSPREP_SKIP_POWEROFF`: if `true`, skips poweroff after completing execution
- `SYSPREP_SKIP_SSH`: if `true`, skips removing SSH host keys

Log in as root with `su -` and export them, for example, `export SYSPREP_SKIP_POWEROFF=true`.
