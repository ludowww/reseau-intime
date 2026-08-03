# État courant du projet

> **Baseline consolidée :** `4dda96f437d1e44658b7fc0748dca421ab98c0cc`

```text
Canon narratif        contrat R8A verrouillé
Architecture moteur  R8A-D1, R8B, R8C-A1/A2/A3
Maintenance active   R8C-A4 consolidation canonique
Runtime démarré       PortraitMain → Season1RuntimeProvider J01–J21
Persistance fichier   absente
Fixture A3            synthétique, isolée, non canonique
```

Le runtime Season1 demeure un oracle temporaire. Les nouveaux modules ne doivent
reprendre ni ses jours fixes, ni ses anciennes migrations, ni ses identifiants
`jNN_*`. Aucune donnée de production n'existe; un futur format incompatible peut
refuser ou réinitialiser les snapshots de développement.

Références :

- `docs/architecture/README.md` — canon moteur;
- `docs/runtime/README.md` — chaîne exécutable;
- `docs/maintenance/R8C_A4_CONSOLIDATION_CANONIQUE_ET_NETTOYAGE_LEGACY.md` — audit et gate;
- `ROADMAP.md` — ordre des lots.
