Concierge
=========

[![dockeri.co](http://dockeri.co/image/vshn/concierge)](https://hub.docker.com/r/vshn/concierge/)

[![GitHub issues](https://img.shields.io/github/issues-raw/vshn/docker-concierge.svg)](https://github.com/vshn/docker-concierge/issues
) [![GitHub PRs](https://img.shields.io/github/issues-pr-raw/vshn/docker-concierge.svg)](https://github.com/vshn/docker-concierge/pulls
) [![MIT License](https://img.shields.io/github/license/vshn/docker-concierge.svg)](https://github.com/vshn/docker-concierge/blob/master/LICENSE)

Config Management + CI
----------------------

Concierge is configuration management for your Git repositories driven by the CI service of your choice (GitLab CI, Travis CI, Circle CI - you name it).
Concierge builds on [ModuleSync](https://github.com/vshn/docker-modulesync/) and loops over a number of [ModuleSync configurations](
https://github.com/puppetlabs/modulesync_configs) in a `configs/` directory.

This Docker image is ready for use with OpenShift and Kubernetes.

Supported Tags
--------------

- [`latest`](https://github.com/vshn/docker-concierge/blob/master/Dockerfile) [![Image Layers](
  https://img.shields.io/imagelayers/layers/vshn/concierge/latest.svg)](https://imagelayers.io/?images=vshn/concierge:latest
  ) (based on current GitHub `master`)

Getting Started
---------------

1. Create a CI configuration file (see below for examples).
1. Create a `configs/` folder.
1. Add a `<repository-config>/` folder inside of it, and populate it with a [
   ModuleSync configuration](https://github.com/puppetlabs/modulesync_configs).
1. Add more ModuleSync config folders inside `config/` for different repository setups.
1. Put everything under version control, and push it to your CI service.

From now on, for every change you make to one of your configuration setups, ModuleSync
will clone the repositories in question, apply your changes, and commit and push them.
Just as you did before, manually cloning and applying changes.
Now reliably, without forgetting any repo, and in a matter of seconds rather than hours.

### GitLab CI

```yaml
# FILE: .gitlab-ci.yml
---
concierge:
  image: vshn/concierge
  variables:
    GIT_COMMITTER_NAME: Concierge by VSHN
    GIT_COMMITTER_EMAIL: concierge@vshn.ch
  when: manual
```

### Bitbucket Pipelines

```yaml
# FILE: bitbucket-pipelines.yml
---
pipelines:
  default:
    - step:
        name: Concierge
        image: vshn/concierge
        script:
          - GIT_COMMITTER_NAME="Concierge by VSHN"
            GIT_COMMITTER_EMAIL="concierge@vshn.ch"
          - concierge
```

### Manual Use

With Docker on the command line:

```bash
$ docker run --rm -v "$PWD":/app vshn/concierge
```

In a Docker Compose file as a pseudo-service:

```yaml
  concierge:
    image: vshn/concierge
    volumes:
      - .:/app
```

Configuration
-------------

The Concierge image sports two main commands: `concierge` and `msync`

The ModuleSync `msync` command, which is called by the `concierge` script, uses Git and SSH. You can configure both of them via environment variables.

- `SSH_PRIVATE_KEY` (default: empty) ... the private key used to connect to your Git server and clone repositories
- `SSH_KNOWN_HOSTS` (default: empty) ... content for the `~/.ssh/known_hosts` file to identify trusted hosts
- `GIT_AUTHOR_NAME`, `GIT_COMMITTER_NAME`, etc. as of the official [Git documentation](
  https://git-scm.com/book/en/v2/Git-Internals-Environment-Variables) (Environment Variables)

### GitLab CI

1. Add `SSH_PRIVATE_KEY` and `SSH_KNOWN_HOSTS` as "Variables" to your repository project Settings > CI/CD.
1. Add the corresponding SSH public key as a "Deploy Key" with "Write access allowed" to Settings > Repository of all Git repositories you want Concierge to manage for you.

See the [GitLab CI docs on SSH keys](https://docs.gitlab.com/ce/ci/ssh_keys/) for background information.

### Bitbucket Pipelines

Follow steps 1, 2, 3 from the [Use SSH keys in Bitbucket Pipelines](
https://confluence.atlassian.com/bitbucket/use-ssh-keys-in-bitbucket-pipelines-847452940.html
) article in the Bitbucket documentation.

Development
-----------

Please, open an issue in our [issue tracker](https://github.com/vshn/docker-concierge/issues
) on GitHub for bugs or feature requests. [Pull requests](
https://github.com/vshn/docker-concierge/pulls) are always welcome!
