# Contribution guidelines

Contributions are welcome.

Before submitting a pull request, please discuss your proposed changes in an
issue first.

## Issues

Before creating a new issue, ensure a similar one has not already been created
by searching on GitHub under [Issues](https://github.com/tgrants/dev-vm-ansible/issues/).

## Branches

We use the following branch structure:

- **main**: Main branch. Contains stable and tested releases.
- **version branches**: Release development branch. They are functional, but
	could be less stable.
- **feature branches**: When a feature is large, it can be developed in a
	seperate branch.

```
main
└── v7
	└── feat/self-destruct-button
```

### Branch Naming Convention

- **Versions**: `release-name` (e.g., `v7`, `7-dev.6`)
- **Features**: `feat/short-description` (e.g., `feat/self-destruct-button`)
