# Game Playtest Squad Skill

Standalone Codex skill for running repeatable first-run game playtests with multiple player profiles.

The repository root is the skill folder. Codex can read it directly when it is linked or copied into the machine's global skills directory:

```text
$HOME\.codex\skills\game-playtest-squad
```

On Windows, `$HOME` resolves to the current user profile, for example `C:\Users\<username>`. Do not hardcode a specific username in install steps.

## Install On This Computer

From the repository root:

```powershell
.\scripts\install.ps1
```

The installer creates a junction from the current user's Codex global skills folder to this repository:

```text
$HOME\.codex\skills\game-playtest-squad -> <this repo>
```

Because the target is the current clone, the clone can live under `D:\Projects`, `E:\Work`, or another local path.

Preview without changing anything:

```powershell
.\scripts\install.ps1 -WhatIf
```

If junctions are not appropriate on a machine, use copy mode:

```powershell
.\scripts\install.ps1 -Copy
```

Copy mode is less convenient because future edits require reinstalling.

## Install On Another Computer

Clone this repository, then run the installer from that clone:

```powershell
git clone https://github.com/kanoan7643/game-playtest-squad-skill.git
cd game-playtest-squad-skill
.\scripts\install.ps1
```

After updating the skill on any machine:

```powershell
git pull
.\scripts\install.ps1
```

If the skill is installed as a junction, `git pull` is enough after the first install.

## Validate

```powershell
.\scripts\validate.ps1
```

If the Codex `skill-creator` validator is installed on the machine, the script runs it as an extra check.

## Layout

```text
SKILL.md              # Codex skill instructions
agents/openai.yaml   # UI metadata
scripts/install.ps1  # Link or copy into the current user's global Codex skills folder
scripts/validate.ps1 # Lightweight standalone validation
```
