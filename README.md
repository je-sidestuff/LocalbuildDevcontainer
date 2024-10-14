# LocalbuildSubmoduleDevcontainer
A repository containing configurable docker images and build scripts which may be used to create and deploy portable devcontainers.

An LBDC (Local Build Devcontainer) is a dynamically composed devcontainer that reads externalized config for individual customization and relies on a locally built cached image to improve multi-repo efficiency.

# Get Started

To install an LBDC in a new repository, call the [install script](./scripts/client/install_lbdc.sh).

To call it from the latest version:

```TODO```

To call it for a specific version:

```
export VERSION="/refs/heads/feat/first_draft"
wget https://raw.githubusercontent.com/je-sidestuff/LocalbuildDevcontainer${VERSION}/scripts/client/install_lbdc.sh
bash install_lbdc.sh
rm install_lbdc.sh
```

Next, open your development environment and the LBDC will bootstrap itself and build.

# Configuration Concepts

- Base, Requirements, Recommendations, Disallowances
- Needs, Preferences, Refusals

# Conventions

- Bash by default
