Chameleon Ultra — Brugervejledning (Linux/Debian)
Indholdsfortegnelse
Installation
Opstart
Forbind til enheden
Læs et HF-kort (MIFARE Classic)
Læs et LF-tag (EM410X)
Gem data (dump)
Skriv data til Chameleon (emulering)
Slot-styring
Nyttige kommandoer
Fejlfinding
---
1. Installation
Forudsætninger
```bash
sudo apt install -y python3-full python3-venv git gcc make cmake
```
Hent kildekode
```bash
git clone https://github.com/RfidResearchGroup/ChameleonUltra
cd ~/ChameleonUltra/software/script
```
Opret Python virtual environment
```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```
Byg angrebsværktøjer (nested, darkside, staticnested m.fl.)
```bash
cd ~/ChameleonUltra/software/src
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
# Binaries placeres automatisk i ~/ChameleonUltra/software/script/bin/
```
USB-adgang (én gang)
```bash
sudo usermod -aG dialout $USER
# Log ud og ind igen, eller kør:
newgrp dialout
```
Genvej (valgfri)
Tilføj til `~/.bashrc`:
```bash
alias chameleon='cd ~/ChameleonUltra/software/script && source venv/bin/activate && python3 chameleon_cli_main.py'
```
Aktivér med `source ~/.bashrc` — herefter starter du CLI med blot `chameleon`.
---
2. Opstart
```bash
cd ~/ChameleonUltra/software/script
source venv/bin/activate
python3 chameleon_cli_main.py
```
Du ser prompten `[Offline] chameleon -->` når CLI'en er startet.
---
3. Forbind til enheden
Sæt USB-kablet i og kør:
```
hw connect --port /dev/ttyACM0
```
Prompten skifter til `[USB] chameleon -->` ved succes.
Kan du ikke finde porten:
```bash
ls /dev/ttyACM* /dev/ttyUSB*
```
---
4. Læs et HF-kort (MIFARE Classic)
HF-antennen sidder på forsiden af Chameleon Ultra (siden med komponenterne). Læg kortet fladt mod forsiden.
Sæt i reader-mode
```
hw mode -r
```
Identificér kortet
```
hf 14a scan
```
Viser UID, ATQA og SAK. SAK `08` = MIFARE Classic 1K.
Automatisk nøgle-recovery og dump
```
hf mf autopwn
```
Forsøger darkside, nested og staticnested automatisk. Når alle nøgler er fundet:
Gem keys: `y` → angiv filnavn (f.eks. `mit_kort`)
Dump kort: `y` → samme filnavn
Resulterer i `mit_kort.bin`, `mit_kort.key` og `mit_kort.dic` i script-mappen.
Manuel nøgletjek med dictionary
```
hf mf fchk --1k --dic mf-default-keys.dic
```
---
5. Læs et LF-tag (EM410X)
LF-antennen sidder på bagsiden af Chameleon Ultra (PCB uden komponenter). Læg tagget fladt mod bagsiden.
Sæt i reader-mode
```
hw mode -r
```
Læs EM410X
```
lf em 410x read
```
Returnerer et 10-cifret hex-ID, f.eks. `4a00315b7a`.
Tjek LF-feltet (fejlfinding)
```
lf sniff
```
Mange "gaps" i output bekræfter at tagget svarer på feltet.
---
6. Gem data (dump)
MIFARE Classic dump (kræver nøgler)
```
hf mf dump -f mit_kort.bin -d mit_kort.dic
```
Gemmer hele korthukommelsen (16 sektorer × 4 blokke) som binær fil.
Vis dump-indhold
```
hf mf view -d mit_kort.bin -k mit_kort.key
```
Gem emulator-hukommelse fra en aktiv slot
```
hf mf esave -s 1 -f backup_slot1.bin
```
---
7. Skriv data til Chameleon (emulering)
HF — MIFARE Classic 1K i slot 1
```
slot change -s 1 -t MIFARE_1024
hf mf eload -s 1 -f mit_kort.bin
slot enable -s 1
```
LF — EM410X i samme slot (slot 1)
```
lf em 410x econfig -s 1 --id 4a00315b7a
```
En enkelt slot understøtter både HF og LF samtidigt — du behøver ikke to slots til en kombi-brik.
Aktivér emulering
```
hw mode -e
```
Chameleon Ultra opfører sig nu som det originale kort/tag. HF-læsere aktiverer MIFARE-delen, LF-læsere aktiverer EM410X-delen automatisk.
---
8. Slot-styring
Chameleon Ultra har 8 slots. Skift med knap A (frem) og knap B (tilbage).
LED-farver indikerer aktiv slot:
Rød = slot 1
Grøn = slot 2
Blå = slot 3
(Kombinationer for slot 4–8)
Vis alle slots
```
hw slot list
```
Skift aktiv slot via CLI
```
slot activate -s 2
```
Deaktivér en slot
```
hw slot disable -s 2 --hf
hw slot disable -s 2 --lf
```
Sleep (sluk)
Hold knap B nede i ~4 sekunder. Tryk knap A eller B for at vågne.
Via CLI:
```
hw sleep
```
---
9. Nyttige kommandoer
Kommando	Beskrivelse
`hw version`	Vis firmware-version
`hw battery`	Vis batteriniveau
`hw mode -r`	Skift til reader-mode
`hw mode -e`	Skift til emulator-mode
`hf 14a scan`	Scan for HF-kort
`lf em 410x read`	Læs LF EM410X tag
`hf mf autopwn`	Automatisk nøgle-recovery og dump
`hf mf eview -s 1`	Vis emulator-hukommelse for slot 1
`hw slot list`	Vis alle slottens konfiguration
`dump_help`	Vis alle tilgængelige kommandoer
---
10. Fejlfinding
"LF tag not found"
Flyt tagget til bagsiden af Chameleon Ultra
Læg det plant og centreret over hele PCB'et
Kør `lf sniff` — mange gaps bekræfter at tagget svarer
Prøv `lf hid read` eller `lf ioprox read` hvis EM410X ikke virker
"HF tag not found"
Flyt kortet til forsiden af Chameleon Ultra
Sørg for kortet ligger plant og dækker antennearealet
"Chameleon Connect fail: CMD timeout"
Tag USB-kablet ud, vent 5 sekunder, sæt det i igen
Kør `hw connect --port /dev/ttyACM0` igen
"externally-managed-environment" ved pip
Brug altid virtual environment: `source venv/bin/activate`
Port ikke fundet (`/dev/ttyACM0`)
Tjek USB-forbindelsen: `ls /dev/ttyACM* /dev/ttyUSB*`
Tjek gruppemedlemskab: `groups | grep dialout`
Tilføj til dialout-gruppen: `sudo usermod -aG dialout $USER`
Alle kommandoer viser kun hovedmenuen
Forbindelsen er ustabil — kør `exit` og genstart CLI
