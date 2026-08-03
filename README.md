# Réseau Intime

Jeu narratif adulte en interface smartphone, développé avec Godot 4.6.x.

## État courant

La direction produit est définie par R8A–R8C : état narratif qualitatif, scènes
modulaires, événements sourcés et micro-signaux sans score caché. Le point
d'entrée est `docs/architecture/README.md`.

Le jeu démarre encore le runtime portrait Saison 1 J01–J21 via
`Season1RuntimeProvider`. Ce runtime est un oracle exécutable temporaire : il
préserve le corpus jouable pendant la construction R8C, sans imposer sa topologie
de jours, ses clés `jNN_*` ou ses snapshots au futur moteur.

R8C-A4 a retiré la seconde chaîne smartphone historique, les loaders et données
à scores qui n'étaient pas utilisés par le runtime démarré, ainsi que les tests
et documents qui les figeaient artificiellement.

## Lire avant de travailler

1. `docs/canon/DOCUMENTATION_READING_ORDER.md`
2. `docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md`
3. `docs/architecture/README.md`
4. `docs/runtime/README.md` pour l'oracle exécutable
5. `ROADMAP.md` pour la séquence des lots

## Invariants

- aucune route choisie comme menu ou débloquée par total numérique;
- aucun score d'attirance, de relation ou de consentement;
- aucun seuil ou compteur d'emoji;
- micro-signal : émission, réception, interprétation, effet
  `LOCAL`/`TEMPORAIRE`/`DURABLE`;
- consentement local, actuel et retirable;
- journées diégétiques sans quota fixe;
- aucune fixture de test chargée comme contenu canonique;
- aucune seconde chaîne runtime.

## Validation

```bash
python tools/validate_game_data.py
python tools/simulate_route_paths.py --godot godot
python -m unittest discover -s tests -p "test_*.py" -v
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
git diff --check
```

Les smokes R8C-A1/A3 sont décrits dans `docs/runtime/README.md`.
