# 🚀 Automatisierte Installation von Windows Server 2025 auf Proxmox PVE

Dieses Repository enthält Skripte und Konfigurationsdateien, um **Windows- und LinuxSysteme** vollständig automatisiert auf **Proxmox PVE 8** zu installieren.  
Die Installation bei Windows Systeme erfolgt unbeaufsichtigt über eine angepasste `autounattend.xml`, eingebettet in ein eigenes ISO‑Image.

---

## 📁 Inhalt des Repositories

| Datei                | Beschreibung                                                                |
| -------------------- | --------------------------------------------------------------------------- |
| **makeIso.sh**       | Erstellt ein Autounattend‑ISO für die automatische Installation             |
| **OSCreate.sh**      | Erstellt und konfiguriert für das jeweilige OS eine neue Proxmox‑VM         |
| **autounattend.xml** | Automatisiert die Windows‑Installation inkl. Partitionierung, Treiber, OOBE |

---

## 🧩 1. makeIso.sh – Autounattend‑ISO erzeugen

Dieses Skript erzeugt ein ISO‑Image, das die Datei `autounattend.xml` enthält.

Beispielzeile aus dem Script:

> `genisoimage -allow-limited-size -udf -o W2K25_Autoinstall.iso iso/`

### Verwendung

1. `autounattend.xml` in den Ordner `iso/` kopieren
2. Skript ausführen:

```bash
chmod +x makeIso.sh
./makeIso.sh
```

3. ISO nach Proxmox kopieren, z. B.:

```bash
cp W2K25_Autoinstall.iso /var/lib/vz/template/iso/
```

---

## 🧩 2. OSCreate.sh – VM automatisch erstellen

Dieses Skript erzeugt eine neue VM mit allen notwendigen Einstellungen für Windows Server 2025.

Wichtige Zeile:

> `vmid=\`pvesh get /cluster/nextid\``

### Features der VM

- UEFI (OVMF)
- TPM 2.0
- VirtIO‑Treiber
- NVMe‑Storage
- Automatische Bootreihenfolge
- Automatisches Mounten der Installations‑ISOs

### Verwendung

```bash
chmod +x W2K25Create.sh
./W2K25Create.sh
```

Optional: VM direkt starten

```bash
qm start <VMID>
```

---

## 🧩 3. autounattend.xml – Unbeaufsichtigte Installation von Windows

Die Datei automatisiert die komplette Windows‑Installation.

### Highlights

#### 🌍 Sprache & Region

> `<UILanguage>de-DE</UILanguage>`  
> `<InputLocale>de-AT</InputLocale>`

#### 💽 Automatische Partitionierung

- EFI (100 MB)
- MSR (16 MB)
- Primäre Partition (Rest)

Zitat:

> `<Extend>true</Extend>`

#### 🖥️ VirtIO‑Treiberintegration

Treiber werden von Laufwerk **F:** geladen:

> `<Path>F:\vioscsi\2k25\amd64</Path>`

#### 🔐 Automatisches Login & Passwort

Base64‑kodierte Passwörter:

> `<PlainText>false</PlainText>`

#### 🎛️ OOBE‑Automatisierung

Alle Setup‑Screens werden übersprungen:

> `<HideOnlineAccountScreens>true</HideOnlineAccountScreens>`

---

## 🚀 Installationsablauf

1. `autounattend.xml` in `iso/` ablegen
2. `makeIso.sh` ausführen → erzeugt **W2K25_Autoinstall.iso**
3. ISO in Proxmox‑Storage kopieren
4. `W2K25Create.sh` ausführen → VM wird erstellt
5. VM starten → Windows installiert sich automatisch

---

## 🛠️ Voraussetzungen

- Proxmox PVE 8.x
- Windows ISO
- VirtIO‑Treiber ISO
- Zugriff auf Proxmox‑Shell

## Passwörter im autounattend.xml

- Administrator:Pa$$w0rd (ist in Folge neben dem Hostnamen zu ändern!)

---
