# Homelab Cloud (Terraform Infrastructure)

Šis projektas automatiškai sugeneruoja ir valdo saugią, minimalią namų laboratorijos (homelab) debesų infrastruktūrą, naudojant **Terraform**, **Hetzner Cloud (hcloud)**, **Tailscale** ir **Bitwarden Secrets Manager**.

Projektas sukonfigūruoja virtualų serverį (Debian 13), veikiantį saugiame, uždarame perimetre (IPv6-Only, be viešo IPv4 adreso) ir automatiškai prijungia jį prie jūsų **Tailscale** privataus tinklo (su Tailscale SSH palaikymu). Tai leidžia saugiai pasiekti ir valdyti serverį iš bet kurio jūsų Tailscale įrenginio nenaudojant viešų prievadų (ports) ir nelaikant atvirų jungčių išoriniame internete.

---

## 🏗️ Architektūra ir Technologijos

- **Infrastruktūra kaip Kodas (IaC):** Visas resursų gyvavimo ciklas valdomas per Terraform deklaratyvų kodą.
- **Būsenos saugykla (State Backend):** Saugojama nuotoliniu būdu **Cloudflare R2** (su S3 suderinama saugykla). Naudojamas integruotas būsenos užrakinimas (`use_lockfile = true`), veikiantis be papildomo DynamoDB analogo.
- **Paslapčių valdymas:** Visos jautrios prieigos (Hetzner token, SSH raktai, Tailscale API raktai) saugiai nuskaitomos iš **Bitwarden Secrets Manager** per specializuotą modulį `modules/bitwarden-secrets`.
- **Saugi operacinė sistema (Debian 13):** Provizionuojama automatiškai per **cloud-init**:
  - Sukuriamas paslaugų vartotojas `ansible` su jūsų SSH raktu.
  - Įjungiamas **SSH hardening** (uždraustas root prisijungimas, uždraustas slaptažodžių autentifikavimas).
  - Įdiegiami baziniai paketai, **Docker** bei **Docker Compose** (su log rotacija ir saugumo nustatymais).
  - Įdiegiama ir sukonfigūruojama **Tailscale** tarnyba.
  - Sukonfigūruojama **UFW** (Uncomplicated Firewall) užkarda tiesiai serveryje.
- **Uždaras tinklas (Zero-Trust):**
  - Serveris neturi viešo IPv4 adreso, o viešas IPv6 yra visiškai užblokuotas per Hetzner užkardą (`closed_perimeter`).
  - Vienintelis kelias prisijungti prie serverio yra per saugų **Tailscale** VPN tunelį.

---

## 📂 Projekto struktūra

```
├── modules/
│   ├── bitwarden-secrets/    # Modulis, atsakingas už paslapčių nuskaitymą iš Bitwarden SM
│   └── server/               # Modulis, atsakingas už Hetzner serverio ir užkardos valdymą
├── .gitignore                # Failų ignoravimo taisyklės
├── backend-secrets.hcl       # Jūsų Cloudflare R2 backend prieigos raktai (SENSITIVE - neviešinti!)
├── cloud-init.yaml           # OS konfigūracijos šablonas, vykdomas pirmojo paleidimo metu
├── main.tf                   # Pagrindinis Terraform failas (teikėjai, moduliai, backend)
├── outputs.tf                # Projekto išvesties kintamieji (IP adresai, būsenos)
├── Readme.md                 # Šis failas
├── secrets.tf                # Šakniniai duomenų šaltiniai (nuskaito paslaptis iš Bitwarden)
├── tailscale.tf              # Tailscale įrenginio registravimas ir laukimas
└── variables.tf              # Projekto kintamųjų deklaracijos
```

---

## 🛠️ Reikalavimai (Prerequisites)

Prieš paleidžiant projektą, įsitikinkite, kad turite:

1. **Terraform CLI** (rekomenduojama versija `>= 1.10.0` dėl vietinio būsenos fiksavimo palaikymo Cloudflare R2).
2. **Bitwarden Secrets Manager** prieigos raktą (Access Token) ir organizacijos ID.
3. Šiuos slaptus įrašus Bitwarden Secrets Manager saugykloje (reikės jų ID):
   - Hetzner Cloud API Token
   - Jūsų SSH Public Key (pagrindinis)
   - Egidijos SSH Public Key
   - Cloudflare API Token
   - Tailscale API Key
   - Tailscale Tailnet pavadinimas
4. **Cloudflare R2 kibirą (bucket)**, sukurti nuotolinės būsenos (state) saugojimui.

---

## ⚙️ Konfigūracija

### 1. Nuotolinio Backend konfigūracija (`backend-secrets.hcl`)
Sukurkite failą `backend-secrets.hcl` šakniniame kataloge ir nurodykite savo Cloudflare R2 raktus bei paskyros ID (šis failas privalo būti įtrauktas į `.gitignore`):

```hcl
access_key = "JŪSŲ_CLOUDFLARE_R2_ACCESS_KEY"
secret_key = "JŪSŲ_CLOUDFLARE_R2_SECRET_KEY"

endpoints = {
  s3 = "https://JŪSŲ_ACCOUNT_ID.r2.cloudflarestorage.com"
}
```

### 2. Kintamųjų užpildymas (`terraform.tfvars`)
Sukurkite `terraform.tfvars` failą (arba nustatykite aplinkos kintamuosius), nurodantį jūsų Bitwarden paslapčių ID:

```hcl
# Bitwarden Secrets Manager organizacijos ID (nebūtina, jei nustatyta aplinkos kintamuosiuose)
BW_ORGANIZATION_ID = "jūsų-org-id"

# Bitwarden įrašų ID (IDs galima rasti Bitwarden SM konsolėje)
secret_hcloud_token_id            = "jūsų-hcloud-token-id"
secret_ssh_public_key_id          = "jūsų-ssh-public-key-id"
secret_cloudflare_api_token_id    = "jūsų-cloudflare-api-token-id"
secret_tailscale_api_key_id       = "jūsų-tailscale-api-key-id"
secret_tailscale_tailnet_id       = "jūsų-tailscale-tailnet-id"

# Tailscale konfigūracija
tailscale_tailnet = "jūsų-tailnet-pavadinimas" # pvz. "user.gmail" arba "tailnet-xyz.ts.net"
```

---

## 🚀 Instaliavimas ir Naudojimas

### 1. Inicializavimas (Initialization)
Atsisiųskite reikiamus teikėjus (providers) ir sukonfigūruokite nuotolinį backend naudodami savo paslapčių failą:

```bash
terraform init -backend-config=backend-secrets.hcl
```

### 2. Paslaugos prieigos tokeno nustatymas
Prieš paleidžiant Terraform, nustatykite aplinkos kintamąjį `BW_ACCESS_TOKEN` jūsų terminale, kad Terraform galėtų autentifikuotis su jūsų Bitwarden Secrets Manager:

```bash
export BW_ACCESS_TOKEN="jūsų_bitwarden_access_token"
```

### 3. Infrastruktūros peržiūra (Plan)
Patikrinkite, kokius resursus sukurs arba modifikuos Terraform:

```bash
terraform plan
```

### 4. Infrastruktūros pritaikymas (Apply)
Sukurkite infrastruktūrą:

```bash
terraform apply
```
Įveskite `yes` patvirtinimui. Terraform atliks šiuos žingsnius:
1. Parsisiųs reikalingus raktus ir žetonus iš Bitwarden Secrets Manager.
2. Sukurs vienkartinį Tailscale prisijungimo raktą (Auth Key).
3. Sukurs Hetzner Cloud virtualų serverį su pritaikyta Debian 13 OS bei cloud-init konfiguracija.
4. Serveris automatiškai užsiregistruos jūsų Tailscale tinkle.
5. Terraform lauks iki 2 minučių, kol serveris pasirodys Tailscale API, ir tuomet išves jo gautą vidinį Tailscale IP adresą.

### 5. Prisijungimas prie serverio
Kai provizionavimas baigtas, prie serverio galite prisijungti per jūsų įgalintą Tailscale tinklą naudojant **Tailscale SSH** arba įprastą SSH raktą per Tailscale IP adresą:

```bash
ssh ansible@homelab-server
```
*(Arba naudojant tiesioginį Tailscale IP, nurodytą išvestyje).*

---

## 🔒 Saugumo rekomendacijos

1. **Saugokite `backend-secrets.hcl`:** Šis failas **jokiu būdu** neturi patekti į nuotolinę Git repozitoriją. Jei failas per klaidą buvo užfiksuotas repozitorijoje, skubiai atlikite `git rm --cached backend-secrets.hcl`, įrašykite failą į `.gitignore` ir pakeiskite Cloudflare R2 raktus.
2. **Užkardos taisyklės:** Hetzner užkarda blokuoja visus įeinančius sujungimus viešame tinkle. Visas administravimas vyksta tik per vidinę `tailscale0` sąsają. Jei norite aktyvuoti avarinį SSH prieigą (portas 22), atlikite tai per kodą (rekomenduojama įsidiegti kintamąjį `allowed_ssh_ips` ir pritaikyti dinaminę taisyklę, užuot keitus nustatymus rankiniu būdu per Hetzner konsolę).
