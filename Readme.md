# Homelab Cloud (Terraform Infrastructure)

## Overview

This project provisions a homelab cloud infrastructure using Terraform.

## Stack

* Terraform
* Hetzner VPS
* Docker

## Architecture

* Modular Terraform structure
* Infrastructure as Code approach
* Scalable and reproducible environments

## Features

* Automated infrastructure provisioning
* Modular design (VPC, compute, services)
* Ready for CI/CD integration

## Project Structure

```
modules/        # reusable terraform modules
/      # main infrastructure config
```

## Future Improvements

* Add remote backend (S3/MinIO)
* Introduce CI/CD pipeline
* Split environments (dev/prod)

## What I learned
- Terraform module design
- Infrastructure structuring
- Basics of IaC best practices