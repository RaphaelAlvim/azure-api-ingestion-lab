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

---

#### Next Steps
- [ ] Create ADF Datasets (HubSpot source + ADLS raw sink)
- [ ] Create Pipeline with Copy Activity
- [ ] Test contacts ingestion
- [ ] Configure pagination
- [ ] Configure incremental load with watermark
- [ ] Databricks — Bronze → Silver → Gold

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
```