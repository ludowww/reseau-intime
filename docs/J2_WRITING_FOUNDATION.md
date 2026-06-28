# J2 — Fondation verrouillée / notes d’implémentation

## Statut

Document mis à jour pour refléter le J2 intégré dans le prototype data-first. La référence de continuité courte est `docs/story_state/J2_SUMMARY.md`.

## Objectif du Jour 2

Après un J1 centré sur Marie puis Sandra, J2 élargit le réseau sans saturer le joueur :

- Marie reste l’ancrage concret/domestique du couple ;
- Raphaëlle apparaît au travail avec une voix sobre/pro ;
- Mathilde devient présence familière dans la maison ;
- Sandra revient brièvement, prudente et émotionnelle.

Player est hors maison pendant la journée. Le retour physique est réservé à J3.

## Structure finale J2

```text
1. Marie matin
2. Raphaëlle badge / travail
3. Marie annonce / accompagne l’arrivée de Mathilde
4. Mathilde écrit directement
5. Sandra ping prudent
6. Marie fin de journée / maison
7. Mathilde selfie canapé
```

Côté téléphone : une discussion visible par personnage. Les épisodes internes reprennent dans le même fil : Marie reste `Marie`, Mathilde reste `Mathilde`.

## Contenus visuels verrouillés

J2 final contient 4 contenus visuels :

1. Marie matin.
2. Raphaëlle badge / travail.
3. Mathilde arrivée via Marie.
4. Mathilde selfie canapé.

Le motif domestique de Marie est la capsule de café / trace de routine, pas l’ancien motif de courses du matin.

## Tonalités après audit

- Marie : concrète, domestique, affective, jamais simple obstacle.
- Raphaëlle : sobre, professionnelle, claire, pas trop intime dès l’entrée.
- Mathilde : vive, familière, un peu effrontée ; éviter la voix trop avocate ou légaliste.
- Sandra : prudente, émotionnelle, retenue, sans nouvelle photo J2.

## Règles de cohérence

- Ne pas activer Pauline/Nico en J2.
- Ne pas créer de groupe actif en J2.
- Ne pas faire rentrer physiquement Player avant J3.
- Ne pas scinder les fils visibles par moment de journée.
- Ne pas remplacer le selfie canapé Mathilde par une simple promesse.
- Ne pas revenir aux anciens exemples de courses du matin ou aux formulations Mathilde trop judiciaires.

## Référence

Voir aussi :

- `docs/story_state/J2_SUMMARY.md`
- `docs/decisions/DECISION_005_J2_VISUAL_RHYTHM_AND_MATHILDE.md`
- `docs/decisions/DECISION_006_PLAYER_NAME_AND_THREAD_MODEL.md`
