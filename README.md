Concierge
=========

[![dockeri.co](http://dockeri.co/image/vshn/concierge)](https://hub.docker.com/r/vshn/concierge/)

[![GitHub issues](https://img.shields.io/github/issues-raw/vshn/docker-concierge.svg)](https://github.com/vshn/docker-concierge/issues
) [![GitHub PRs](https://img.shields.io/github/issues-pr-raw/vshn/docker-concierge.svg)](https://github.com/vshn/docker-concierge/pulls
) [![MIT License](https://img.shields.io/github/license/vshn/docker-concierge.svg)](https://github.com/vshn/docker-concierge/blob/master/LICENSE)

Config Management + CI
----------------------

Concierge is configuration management for your Git repositories driven by the CI service of your choice (GitLab CI, Bitbucket Pipelines, Travis CI, Circle CI -- you name it).
Concierge builds on [ModuleSync](https://github.com/vshn/docker-modulesync/) and loops over a number of [ModuleSync configurations](
https://github.com/puppetlabs/modulesync_configs) in a `configs/` directory.

This Docker image is ready for use with OpenShift and Kubernetes.

Supported Tags
--------------

- [![latest](
  https://img.shields.io/badge/latest-blue.svg?colorA=22313f&colorB=4a637b&logo=docker)](
  https://github.com/vshn/docker-concierge/blob/master/Dockerfile) [![image layers](
  https://img.shields.io/microbadger/layers/vshn/concierge/latest.svg)](
  https://microbadger.com/images/vshn/concierge) [![image size](
  https://img.shields.io/microbadger/image-size/vshn/concierge/latest.svg)](
  https://microbadger.com/images/vshn/concierge) [![based on](
  https://img.shields.io/badge/Git-master-grey.svg?colorA=5a5b5c&colorB=9a9b9c&logo=github)](
  https://github.com/vshn/docker-concierge)

Getting Started
---------------

1. Create a CI configuration file (see below for examples).
1. Create a `configs/` folder.
1. Add a `<repository-config>/` folder inside of it, and populate it with a [
   ModuleSync configuration](https://github.com/puppetlabs/modulesync_configs).
1. Add more ModuleSync config folders inside `configs/` for different repository setups.
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
  script: concierge
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
- `GIT_USER_NAME`, `GIT_USER_EMAIL` ... override Git user (otherwise derived from last commit)
- `GIT_COMMIT_MESSAGE` ... override Git commit message (otherwise derived from last commit)

Other environment values can be set as of the official [Git documentation](
https://git-scm.com/book/en/v2/Git-Internals-Environment-Variables
), but be warned that Git (or ModuleSync) can be very stubborn and may behave counterintuitively.

### GitLab CI

1. Add `SSH_PRIVATE_KEY` and `SSH_KNOWN_HOSTS` to your repository project at Settings > CI/CD > Variables. See the [
   GitLab CI docs on SSH keys](https://docs.gitlab.com/ce/ci/ssh_keys/) for background information.
1. Add the corresponding SSH public key to Settings > Repository > Deploy Keys, enabling "Write access allowed", for all Git repositories you want to allow Concierge to manage.

### Bitbucket Pipelines

Follow steps 1, 2, 3 from the [Use SSH keys in Bitbucket Pipelines](
https://confluence.atlassian.com/bitbucket/use-ssh-keys-in-bitbucket-pipelines-847452940.html
) article in the Bitbucket documentation.

Security and Safety Considerations
----------------------------------

Consider activating required code reviews and manual triggers of merge requests.
Ideally, you enforce this policy in a tool-driven fashion leveraging the API of your code repository.

Development
-----------

Please, open an issue in our [issue tracker](https://github.com/vshn/docker-concierge/issues
) on GitHub for bugs or feature requests. [Pull requests](
https://github.com/vshn/docker-concierge/pulls) are always welcome!
