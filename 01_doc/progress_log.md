### Progress Log — azure-api-ingestion-lab

#### Project Goal
End-to-end data ingestion pipeline using REST APIs and the Azure enterprise stack:
`HubSpot API → ADF → ADLS Gen2 (raw/bronze/silver/gold) → Databricks`

---

#### Session 01 — Base Infrastructure with Terraform

##### Repository
- Name: `azure-api-ingestion-lab`
- Description: `End-to-end Azure data ingestion pipeline using REST APIs, ADF, ADLS Gen2 and Databricks — built for study and portfolio purposes.`
- `.gitignore` configured with Terraform, Python, Databricks and Power BI templates

##### Folder Structure

azure-api-ingestion-lab/
├── 01_doc/
├── 02_infra/
│   ├── 01_terraform/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── terraform.tfvars
│   │   └── modules/
│   │       ├── resource_group/
│   │       ├── adls/
│   │       ├── adf/
│   │       └── key_vault/
│   ├── 02_data_factory/
│   └── 03_databricks/
└── README.md

##### Technical Decisions
- Modular structure — each Azure resource has its own Terraform module
- Resource names are built internally by each module, not passed manually
- `random_string.suffix` used to ensure global uniqueness of the storage account name
- `backend "local"` — Terraform state stored locally
- `terraform.tfvars` added to `.gitignore` — sensitive values never pushed to GitHub

##### Resources Created via Terraform
| Resource | Name |
|---|---|
| Resource Group | `rg-apiingestionlab-dev-we` |
| ADLS Gen2 | `stapiingestionlabdevrql4` |
| ADLS Containers | `raw`, `bronze`, `silver`, `gold` |
| ADF | `adf-apiingestionlab-dev-we` |
| Key Vault | `kv-apiingestionlab-dev` |

##### Permissions Configured
- ADF Managed Identity → Key Vault: `Get`, `List`
- ADF Managed Identity → ADLS: `Storage Blob Data Contributor`

##### Secrets Stored in Key Vault
| Secret Name | Description |
|---|---|
| `hubspot-access-token` | Access token for the HubSpot Private App |

---

#### Session 01 — HubSpot API

##### App Created
- **Type:** Private App
- **Name:** `azure-api-ingestion-lab`
- **Description:** `Private app for data ingestion study project. Connects HubSpot CRM to Azure Data Lake via ADF pipeline.`

##### Scopes Configured
- `crm.objects.contacts.read`
- `crm.objects.deals.read`
- `crm.objects.companies.read`
- `crm.objects.owners.read`
- `crm.pipelines.orders.read`

##### Authentication
- Type: Bearer Token via Private App Access Token
- Token stored in Key Vault — never exposed in code

##### HubSpot Dataset
- 15 companies created
- 102 contacts created
- 45 deals created across all pipeline stages
- Deals distributed across: `appointmentscheduled`, `qualifiedtobuy`, `presentationscheduled`, `decisionmakerboughtin`, `contractsent`, `closedwon`, `closedlost`
- `createdate` on deals distributed across 2026 (Jan–Nov) — useful for incremental load simulation
- `lastmodifieddate` recommended as watermark field for contacts and companies

---

#### Session 01 — ADF Linked Services

| Name | Type | Authentication |
|---|---|---|
| `ls_keyvault` | Azure Key Vault | Managed Identity |
| `ls_hubspot_api` | REST | Bearer Token via Key Vault |
| `ls_adls` | ADLS Gen2 | Managed Identity |

##### Notes
- `ls_hubspot_api` uses `Anonymous` at the Linked Service level — the token is injected into the `Authorization` header at runtime via Key Vault
- `ls_adls` uses System Assigned Managed Identity — no credentials exposed
- In a production environment all resources would use private access only, with Managed VNet IR and Private Endpoints for ADLS, Key Vault and Databricks. Public access is enabled here for study purposes only.

---

#### Session 01 — ADF Datasets

| Name | Type | Description |
|---|---|---|
| `ds_hubspot_contacts` | REST | Source — HubSpot contacts endpoint |
| `ds_adls_raw_json` | ADLS Gen2 JSON | Sink — raw layer with dynamic date partitioning |

##### ds_adls_raw_json Parameters
| Parameter | Value in Pipeline |
|---|---|
| `folder_date` | `@{formatDateTime(utcNow(),'yyyy/MM/dd')}` |
| `file_name` | `@{concat('contacts_',formatDateTime(utcNow(),'yyyyMMdd_HHmmss'),'.json')}` |

##### ADLS Raw Partition Structure

raw/hubspot/contacts/2026/05/24/contacts_20260524_104912.json

---

#### Session 01 — ADF Pipeline

##### pl_ingest_hubspot_contacts
- **Activity:** Copy Activity — `copy_hubspot_contacts_to_raw`
- **Source:** `ds_hubspot_contacts` — GET `/crm/v3/objects/contacts`
- **Pagination:** `AbsoluteUrl` → `Body` → `$.paging.next.link`
- **Request interval:** 1000ms between pages — respects HubSpot rate limit
- **Sink:** `ds_adls_raw_json` — dynamic date partitioning
- **Fault tolerance:** Skip incompatible rows
- **Logging:** `raw/hubspot/logs/contacts`
- **Retry:** 3 attempts — 60s interval
- **Timeout:** 30 minutes
- **Parallelism:** 1 — avoids rate limit 429

##### First Successful Run
- Date: 2026-05-24
- Duration: 28 seconds
- Output: `raw/hubspot/contacts/2026/05/24/contacts_20260524_104912.json`
- Records ingested: 102 contacts (11 pages)

##### ADF Git Integration
- Repository: `azure-api-ingestion-lab`
- Branch: `main`
- Publish branch: `adf_publish`
- Root folder: `/02_infra/02_data_factory`
- All ADF resources versioned automatically on publish

---

#### Next Steps
- [ ] Create pipelines for deals and companies ingestion
- [ ] Configure incremental load with watermark
- [ ] Databricks workspace setup
- [ ] Bronze layer — read raw JSON
- [ ] Silver layer — flatten nested JSON, validate schema
- [ ] Gold layer — analytics, joins, aggregations
- [ ] Power BI connection to Gold layer

---

#### Useful Commands

```powershell
# Authenticate to Azure
az login --use-device-code

# Confirm active subscription
az account show --output table

# Store a secret in Key Vault
az keyvault secret set --vault-name "kv-apiingestionlab-dev" --name "NAME" --value "VALUE"

# Terraform workflow
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply

# Sync ADF changes to local repo
git pull
```