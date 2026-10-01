# Highly Available Flask Infrastructure on Google Cloud with Terraform

Terraform-based implementation of a highly available web application architecture on Google Cloud Platform.

The project provisions a private Compute Engine application tier behind a regional external Application Load Balancer, with autoscaling, health checks, controlled outbound internet access through Cloud NAT, and optional public DNS through Cloud DNS.

The infrastructure is organized into reusable Terraform modules with environment-specific composition for development and production deployments.

---

## Architecture

```text
                               Internet
                                  │
                                  ▼
                         Public DNS / Cloud DNS
                                  │
                                  ▼
                          External Static IP
                                  │
                                  ▼
                           Forwarding Rule
                                  │
                                  ▼
                         Target HTTP Proxy
                                  │
                                  ▼
                              URL Map
                                  │
                                  ▼
                         Backend Service
                                  │
                     ┌────────────┴────────────┐
                     │                         │
                     ▼                         ▼
                Regional Managed Instance Group
                     │
             ┌───────┴────────┐
             ▼                ▼
        Flask VM          Flask VM
        Zone A            Zone B
             │                │
             └───────┬────────┘
                     │
                App Subnet
                     │
                     ▼
                 Cloud NAT
                     │
                     ▼
                  Internet
             (outbound access)
```

### Request flow

```text
User
  ↓
External IP
  ↓
Forwarding Rule
  ↓
Target HTTP Proxy
  ↓
URL Map
  ↓
Backend Service
  ↓
Managed Instance Group
  ↓
Healthy Flask VM :8080
```

The regional Application Load Balancer terminates the client HTTP connection and forwards requests through Google-managed proxy infrastructure to healthy instances in the managed instance group.

---

## Key Components

### Networking

A custom-mode VPC provides isolated networking for the application.

The architecture uses:

- Private application subnet for Compute Engine instances
- Proxy-only subnet for the regional Application Load Balancer
- Cloud Router and Cloud NAT for controlled outbound internet access
- No external IP addresses on application VMs

Cloud NAT allows private instances to download packages and reach external services without exposing them directly to the internet.

### Compute

Application instances are created from a regional Compute Engine instance template.

Each instance runs:

- Ubuntu 24.04 LTS
- Python Flask
- Gunicorn
- Systemd-managed application service

The application exposes:

```text
/         Application endpoint
/health   Load balancer health endpoint
```

A regional Managed Instance Group distributes instances across multiple zones and provides:

- Automatic instance recreation
- Horizontal autoscaling
- Multi-zone availability
- Consistent instance configuration

### Load Balancing

The regional external Application Load Balancer is composed of several GCP resources:

```text
External IP
    ↓
Forwarding Rule
    ↓
Target HTTP Proxy
    ↓
URL Map
    ↓
Backend Service
    ↓
Regional MIG
```

The backend service uses utilization-based balancing and routes traffic only to healthy instances.

### Health Checks

The load balancer continuously checks:

```text
http://<instance>:8080/health
```

Instances failing the health check are removed from active traffic until they recover.

### Security

Application instances are not directly exposed to the internet.

Ingress to the application port is restricted to:

- Google health-check ranges
- Regional load-balancer proxy subnet

Administrative SSH access can be enabled through Google Cloud IAP rather than assigning public IP addresses to the VMs.

The application instances use a dedicated runtime service account instead of relying on the default Compute Engine service account.

IAM permissions can be added to this service account only when required by the application.

### DNS

The optional Cloud DNS module creates:

- Public managed DNS zone
- A record pointing to the load balancer's static external IP

The DNS module consumes the load balancer IP directly through Terraform outputs rather than using a hard-coded address.

---

## Terraform Design

The project separates reusable infrastructure components from environment-specific configuration.

```text
modules/
├── network
├── nat
├── firewall
├── compute
├── load-balancer
├── dns
└── project-services

environments/
├── dev
└── prod
```

Each module owns a logical infrastructure responsibility and exposes only the outputs required by dependent modules.

Example dependency flow:

```text
network
   │
   ├── network_id ──────────────┐
   ├── app_subnet_id ───────┐   │
   └── proxy_subnet_cidr ─┐ │   │
                          │ │   │
                          ▼ ▼   ▼
                       firewall
                          │
                          ▼
                         NAT
                          │
                          ▼
                       compute
                          │
                  instance_group
                          │
                          ▼
                   load-balancer
                          │
                  load_balancer_ip
                          │
                          ▼
                         DNS
```

This approach keeps infrastructure components reusable while allowing environment-specific values such as region, CIDR ranges, machine size, and scaling limits to remain outside the modules.

---

## Deployment

From the target environment:

```bash
cd environments/dev
```

Initialize Terraform:

```bash
terraform init
```

Format and validate:

```bash
terraform fmt -recursive
terraform validate
```

Review the execution plan:

```bash
terraform plan
```

Deploy:

```bash
terraform apply
```

After deployment, verify:

- Managed Instance Group instances are healthy
- Load balancer backend health is healthy
- External IP responds successfully
- `/health` returns HTTP 200
- DNS resolves to the load balancer IP if Cloud DNS is configured

---


## Design Decisions

**Private application instances**  
Compute Engine instances do not receive external IP addresses. Internet egress is provided through Cloud NAT.

**Regional Managed Instance Group**  
Instances are distributed across multiple zones to avoid a single-zone dependency.

**Regional external Application Load Balancer**  
Provides Layer 7 HTTP routing, backend health awareness, and integration with the regional MIG.

**Proxy-only subnet**  
Provides address space for Google-managed Envoy proxies used by the regional Application Load Balancer.

**Dedicated runtime service account**  
Avoids relying on the default Compute Engine service account and supports least-privilege IAM permissions.

**Modular Terraform structure**  
Separates networking, compute, security, load balancing, DNS, and API enablement into reusable modules.

---

## Technologies

- Google Cloud Platform
- Terraform
- Compute Engine
- Managed Instance Groups
- Application Load Balancing
- Cloud NAT
- Cloud Router
- Cloud DNS
- IAM / Service Accounts
- VPC Firewall Rules
- Python Flask
- Gunicorn
- Ubuntu Linux

---