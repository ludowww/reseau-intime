# État courant du projet

## Statut

Ce fichier sert de note courte d’orientation pour éviter de confondre :

```text
- le tag stable runtime J5 ;
- le main actuel ;
- les outils d’aide à l’écriture ajoutés après J5.
```

## Baseline runtime stable

```text
tag : v0.5-j5-after-party-proofs
commit : e2bfc1adbbc431d5f813ce467b3565c63e429024
```

Ce tag correspond à :

```text
- J5 runtime data-first verrouillé ;
- polish J5 ;
- Raphaëlle renforcée ;
- story_state J5 à jour ;
- validations techniques OK ;
- warning connu non bloquant : held_sandra_space_day2.
```

## Main actuel

```text
main : 0c5bf52775374f9f53ce710f830c8e4739235e2d
```

`main` contient le tag J5 ci-dessus + les outils d’aide à l’écriture des dialogues.

Les outils ajoutés sont :

```text
docs/writing/dialogue_authoring_tools.md
docs/writing/characters/VOICE_PROFILES.md
game/data/writing/character_voice_profiles.json
game/data/writing/knowledge_state.json
tools/dialogue_context_pack.py
tools/dialogue_rhythm_report.py
tools/dialogue_voice_check.py
```

Ces outils sont authoring-only :

```text
- aucun changement gameplay ;
- aucun runtime narratif modifié ;
- aucun nouveau système de routes ;
- aucune génération automatique obligatoire ;
- uniquement aide au contexte, rythme, voix et cohérence.
```

## État narratif verrouillé

Le récit jouable est verrouillé jusqu’à J5 :

```text
J1 — couple + Sandra réactivée
J2 — réseau ouvert + Mathilde dans la maison + Raphaëlle travail
J3 — retour domestique + premières traces conscientes
J4 — soirée sociale chez Pauline
J5 — lendemain, redistribution des photos et premières preuves faibles
```

État personnage actuel :

```text
Marie : couple central, désir d’être regardée, suspicion douce.
Sandra : mauvais timing, “plus tard”, photo supprimée, retenue.
Mathilde : photo/trace gardée ou supprimée, Marie en sous-texte.
Pauline : contrôle des photos, preuve hors champ, secret personnel potentiel.
Raphaëlle : clarté concrète, travail/dossier, limite, pas une cachette.
Nico : miroir social autour de Marie, pas antagoniste caricatural.
```

## Prochaine branche recommandée

Pour J6 :

```text
work/j6-data-first-photo-consequences
```

Base recommandée :

```text
main = 0c5bf52775374f9f53ce710f830c8e4739235e2d
```

Objectif narratif recommandé :

```text
J6 doit traiter les conséquences concrètes des preuves faibles J5,
pas simplement ajouter une nouvelle série de photos.
```

## Workflow recommandé avant J6

Avant d’écrire une scène J6 :

```bash
python3 tools/dialogue_context_pack.py --character <personnage> --day 6
```

Après écriture :

```bash
python3 tools/dialogue_rhythm_report.py game/data/conversations/chapter_06_*.json
python3 tools/dialogue_voice_check.py game/data/conversations/chapter_06_<personnage>*.json --character <personnage>
```

Puis validations habituelles :

```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest tests.test_godot_prototype_static -v
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

## Garde-fous actuels

```text
routes ouvertes ≠ routes assumées
preuves faibles ≠ preuves définitives
désir visible ≠ bascule consommée
jalousie ≠ confrontation finale
outils d’écriture ≠ génération automatique incontrôlée
```
