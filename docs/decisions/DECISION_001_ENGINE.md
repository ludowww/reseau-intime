# DECISION 001 — Moteur de jeu

## Statut

Validé.

## Décision

Utiliser **Godot 4.6.2** comme moteur principal pour le prototype et la production initiale.

## Raisons

- L’interface smartphone demande une UI custom très libre.
- Les applications fictives, notifications, galerie et conversations multiples sont plus faciles à contrôler dans Godot.
- Le projet peut commencer sur PC avec un smartphone simulé, puis envisager Android plus tard.
- GDScript est suffisant pour le prototype.
- Les données narratives peuvent être chargées depuis des fichiers JSON.
- Verrouiller une version précise de Godot évite les écarts de rendu, de comportement UI ou d’API entre machines.

## Version cible

```text
Godot 4.6.2
```

Cette version doit être utilisée pour le prototype, sauf décision explicite ultérieure.

## Alternatives étudiées

### Ren’Py

Très bon pour un visual novel classique, mais moins adapté à une simulation de smartphone avec plusieurs applications interactives.

### Flutter

Très bon pour une application mobile, mais moins adapté à une structure de jeu avec progression narrative, sauvegarde, galerie et logique de routes.

### Yarn Spinner

À étudier plus tard pour l’écriture de dialogues branchés, mais pas retenu comme base initiale. Le format JSON maison semble plus adapté à la messagerie instantanée.

## Conséquence

La première architecture technique doit être pensée autour de :

- scènes Godot 4.6.2 ;
- UI smartphone ;
- gestionnaire de conversations ;
- gestionnaire de notifications ;
- gestionnaire de galerie ;
- système de variables ;
- sauvegarde JSON ou Resource.

## Règle

Toute contribution technique doit être pensée et testée pour **Godot 4.6.2**.