# Auto Corp Infrastructure (archived)

> **This repository has moved to [mikebarkas/cloudlab](https://github.com/mikebarkas/cloudlab).**
> The code and its full commit history now live in the [`autocorp/`](https://github.com/mikebarkas/cloudlab/tree/main/autocorp) directory.
> This repository is archived and read-only. New work happens in cloudlab.

## Why it moved

All of my AWS infrastructure projects are now in one repository, cloudlab, so they're easier to find, review, and maintain together.

## What was here

Infrastructure as Code for Auto Corp, a practice project built around a fictitious automobile company:

- **Terraform** provisioned the AWS networking and EC2 host for the Go API, the web front end, and Cloudflare DNS records
- **Ansible** configured the servers and deployed the containerized applications
- **Jenkins** server setup

Related application repositories:

- [auto-corp-api](https://github.com/mikebarkas/auto-corp-api): Go API with Postgres
- [auto-corp-web](https://github.com/mikebarkas/auto-corp-web): Python web front end

## Release history

Tags `0.0.1` through `0.0.8` remain in this repository for reference.

