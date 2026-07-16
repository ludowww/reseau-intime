# Documentation Reading Order — Bible Narrative Current

> **Phase actuelle : Bible Narrative / North Star**
>
> La Bible Narrative est la source de vérité principale pour la promesse du jeu, l’expérience joueur, les fantasmes, la structure globale, les routes, l’évolution érotique, les actes, les séquences et les règles des scènes modulaires.
>
> Les canons complets des personnages restent l’autorité première sur leur identité, leur voix, leur vie concrète, leurs désirs, leurs limites et leurs conséquences propres.
>
> Le runtime décrit ce qui est implémenté et jouable.

---

# 1. Règles fondamentales

```text
Commencer par la North Star et l’expérience joueur.
Définir les fantasmes transversaux.
Relire les canons complets des personnages.
Définir les routes macro.
Définir l’évolution érotique.
Définir les actes.
Choisir les séquences concrètes.
Adapter les scènes modulaires à l’état réel de la partie.
Écrire les dialogues et les photos.
Découper en journées.
Planifier le runtime en dernier.
```

Les journées restent une couche de diffusion, de respiration et de rythme.

Un ancien plan, une ancienne carte de scène ou une implémentation existante ne peut pas contredire la Bible ou le canon complet d’un personnage.

---

# 2. Ordre de lecture officiel

## 1. README de la Bible

`docs/canon/bible/README.md`

Définit la gouvernance, la hiérarchie, les différences entre les couches et les règles de spécificité.

## 2. North Star

`docs/canon/bible/00_NORTH_STAR.md`

Définit l’identité du jeu, la promesse centrale et les principes non négociables.

## 3. Expérience joueur

`docs/canon/bible/01_EXPERIENCE_JOUEUR.md`

Définit responsabilité, causalité, limites, opportunités, dettes et conséquences.

## 4. Fantasmes centraux

`docs/canon/bible/02_FANTASMES_CENTRAUX.md`

Définit les promesses transversales, leurs formes négociées et leurs formes risquées.

## 5. Canon complet des personnages

Lire :

- `docs/canon/characters/CHARACTER_CANON_INDEX.md` ;
- le ou les fichiers `*_CANON_FULL.md` concernés ;
- `docs/canon/CHARACTER_VOICE_DISTINCTION_CANON.md` ;
- `docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md` lorsque désir, images, risques ou conséquences adultes sont impliqués ;
- la carte de dépréciation correspondante lorsqu’elle existe ;
- `docs/canon/SUPPORTING_CHARACTER_CANON_POLICY.md` pour les personnages secondaires.

Le canon complet est l’autorité sur :

- identité ;
- passé ;
- proximité initiale ;
- métier ;
- lieux ;
- objets ;
- proches ;
- voix ;
- contradictions ;
- limites ;
- désirs ;
- rapport au corps et aux images ;
- continuité individuelle.

## 6. Grammaire narrative

`docs/canon/bible/03_GRAMMAIRE_NARRATIVE.md`

Définit les fonctions réutilisables des séquences.

## 7. Trame principale et actes

`docs/canon/bible/04_TRAME_PRINCIPALE_ET_ACTES_SAISON_1.md`

Définit la crise commune, les cinq actes et le contrat d’incarnation des personnages.

## 8. Routes macro

`docs/canon/bible/05_ROUTES_MACRO_SAISON_1.md`

Définit les transformations durables de Marie, Sandra, Mathilde, Pauline, Raphaëlle et Nico.

## 9. Évolution érotique des routes

`docs/canon/bible/06_EVOLUTION_EROTIQUE_DES_ROUTES.md`

Définit comment le désir devient intention, disponibilité, sexualité et éventuellement représentation pornographique spécifique.

## 10. Bibliothèque de séquences

`docs/canon/bible/07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md`

Définit les événements concrets et mémorables de la première saison à partir des actes, routes et canons complets.

## 11. Règles des scènes modulaires

`docs/canon/bible/08_REGLES_DES_SCENES_MODULAIRES.md`

Définit comment une séquence devient une scène compatible avec l’état réel de la partie.

Le document fixe notamment :

- une séquence source obligatoire ;
- une fonction et une relation principales ;
- au moins deux ancrages du canon complet ;
- les conditions, exclusions, préférences et raisons de disponibilité ;
- un noyau stable et des règles de mutation ;
- le budget `1 foreground + 0–2 échos` ;
- trois choix par nœud par défaut ;
- la priorité aux conséquences ;
- les contrats de temps, communication, images, connaissances et consentement ;
- l’audit des anciennes scènes.

Le document historique `docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md` reste une référence technique compatible. En cas de contradiction narrative, le document `08` prévaut.

## 12. Progression visuelle et photographique

Futur document canonique.

Définira les étapes, audiences, intentions, limites, risques et conséquences des photos.

## 13. Carte des conséquences, dettes, secrets et obligations

Futur document canonique.

Définira ce qui circule entre les routes et ce qui doit être payé, révélé, réparé ou porté.

## 14. Découpage des journées

Futur document canonique.

Répartira les séquences, scènes, silences, respirations et photos après validation de l’architecture.

## 15. Dialogues et plans de scènes

Futurs documents canoniques.

Ils rédigeront les cartes détaillées, dialogues et productions visuelles à partir des documents `07` et `08`.

## 16. Contrats narratifs complémentaires

Lire selon le besoin :

- `docs/canon/CHOICE_DESIGN_CANON.md` ;
- `docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md` ;
- `docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md` ;
- `docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md` ;
- `docs/canon/TEMPORAL_FLOW_AND_DAY_TRANSITION_CANON.md`.

Ils fournissent des détails compatibles. Ils ne peuvent pas contredire le document `08` sur la direction des scènes.

## 17. Runtime

Lire les plans, rapports, index de chapitres, conversations actives, données visuelles, tests, ledgers et validations de la version concernée.

Le runtime répond à :

> « Qu’est-ce qui est effectivement implémenté et jouable ? »

Il ne répond pas seul à :

> « Quelle doit être la vision définitive du jeu ? »

---

# 3. Hiérarchie de conception officielle

```text
North Star
→ Expérience joueur
→ Fantasmes centraux
→ Canon complet des personnages
→ Routes macro
→ Évolution érotique des routes
→ Actes
→ Séquences
→ Scènes modulaires
→ Dialogues et photos
→ Découpage en journées
→ Runtime
```

Précisions :

- le canon complet est une autorité transversale ;
- la grammaire fournit le vocabulaire des fonctions ;
- les routes donnent une direction aux actes ;
- les actes expriment des transformations globales ;
- les séquences accomplissent ces transformations par des événements concrets ;
- les scènes adaptent les séquences à la partie ;
- les scènes ne créent pas les routes ;
- les journées sont construites après validation des séquences et des règles de scènes.

---

# 4. Hiérarchie d’autorité

## Bible Narrative

Autorité sur :

- promesse ;
- expérience joueur ;
- fantasmes ;
- structure globale ;
- routes et transformations ;
- évolution érotique ;
- actes ;
- fonction et sélection des séquences ;
- conception et adaptation des scènes ;
- progression visuelle globale.

## Canon complet des personnages

Autorité sur :

- identité ;
- voix ;
- histoire ;
- métier ;
- lieux ;
- objets ;
- proches ;
- responsabilités ;
- limites ;
- désirs ;
- réactions propres ;
- continuité individuelle.

## NSFW canon

Autorité sur :

- progression adulte ;
- consentement ;
- images et audiences ;
- secrets et trahisons ;
- roleplay ;
- partage ;
- voies sombres ;
- après-coup explicite.

## Contrats narratifs complémentaires

Autorité sur les détails compatibles de choix, temps, communication et adaptation technique.

## Runtime

Autorité uniquement sur l’état effectivement implémenté et validé.

## Archive et À réécrire

Contexte historique ou intention à requalifier, sans autorité en cas de contradiction.

---

# 5. Règle de spécificité

> **Une fonction peut être partagée. Une séquence doit déjà être spécifique. Une scène doit rendre cette spécificité concrète.**

Toute scène importante doit :

- pointer vers une séquence de `S01` à `S35` ou déclarer un candidat à la bibliothèque ;
- employer au moins deux ancrages du canon complet ;
- définir une relation principale ;
- préserver l’agence du personnage ;
- prévoir un état de sortie, un suivi, une expiration et une mutation.

---

# 6. Audit des anciennes scènes

Les anciennes cartes, source packs, conversations et scènes jouables ne deviennent pas automatiquement conformes.

Elles doivent être classées :

```text
COMPATIBLE
ADAPTABLE
REWRITE
ARCHIVE
```

L’audit narratif précède toute réutilisation ou planification runtime.

---

# 7. Décision Nico

Le canon actuel fixe :

```text
Nico est hétérosexuel.
```

Conséquences :

- aucune attirance romantique ou sexuelle envers Player ;
- aucune ambiguïté homosexuelle cachée ;
- aucune route de contact sexuel entre eux ;
- aucun changement d’orientation déduit d’un trio ou d’une scène plus explicite ;
- complicité masculine, rivalité, regard partagé, alibi et tiers invité restent possibles autour de femmes adultes consentantes.

---

# 8. Règle sur le moteur

Le moteur narratif est considéré comme acquis.

Sauf nécessité narrative exceptionnelle, la Bible se construit au-dessus du téléphone, des conversations persistantes, de la galerie, des notifications, des photos, des ledgers, des obligations, des scènes modulaires, des tests et de l’architecture générale.

---

# 9. Règle finale

```text
Utiliser la Bible pour savoir ce que le jeu doit devenir.
Utiliser le canon complet pour savoir qui vit la transformation.
Utiliser le NSFW canon pour savoir comment l’adulte peut progresser.
Utiliser la grammaire pour identifier la fonction.
Utiliser la bibliothèque pour choisir l’événement concret.
Utiliser le document 08 pour concevoir et adapter la scène.
Utiliser les journées pour distribuer le rythme.
Utiliser le runtime pour décrire ce qui est jouable.

Aucune architecture abstraite ne doit remplacer la personne concrète.
```