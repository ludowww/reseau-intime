# Documentation Reading Order — Bible Narrative Current

> **Phase actuelle : Bible Narrative / North Star**
>
> La Bible Narrative est la source de vérité principale pour la promesse du jeu, l’expérience joueur, les fantasmes, la structure globale, les routes et les transformations. Le canon complet des personnages reste l’autorité sur leur identité et leur voix. Le runtime décrit ce qui est implémenté et jouable.

---

# 1. Règles fondamentales

```text
Commencer par la North Star et l’expérience joueur.
Définir les fantasmes avant les routes.
Définir les routes avant les actes.
Définir les actes avant les séquences.
Définir les séquences avant les scènes.
Écrire les dialogues et les photos après la fonction relationnelle.
Découper en journées après la validation des séquences.
Utiliser le runtime pour savoir ce qui est jouable.
Un ancien plan par journée ne peut pas contredire la Bible.
```

Les journées restent une couche de diffusion, de respiration et de rythme.

---

# 2. Ordre de lecture officiel

## 1. README de la Bible

`docs/canon/bible/README.md`

Définit la gouvernance, la hiérarchie, les différences entre les couches et les règles de réutilisation.

## 2. North Star

`docs/canon/bible/00_NORTH_STAR.md`

Définit l’identité du jeu, la promesse centrale et les principes non négociables.

## 3. Expérience joueur

`docs/canon/bible/01_EXPERIENCE_JOUEUR.md`

Définit ce que le joueur doit ressentir, comprendre et attribuer à ses propres actes.

## 4. Fantasmes centraux

`docs/canon/bible/02_FANTASMES_CENTRAUX.md`

Définit les promesses transversales, leurs formes négociées, leurs formes sombres, leurs limites et les personnages capables de les incarner différemment.

## 5. Grammaire narrative

`docs/canon/bible/03_GRAMMAIRE_NARRATIVE.md`

Définit les fonctions réutilisables des séquences sans fournir de scènes interchangeables.

## 6. Trame principale et actes de saison

`docs/canon/bible/04_TRAME_PRINCIPALE_ET_ACTES_SAISON_1.md`

Définit la crise commune, les transformations globales, les fantasmes activés, les types de séquences utiles, les états de sortie et les hooks d’extension.

## 7. Futures routes macro

Futur document canonique.

Définira les transformations durables de chaque relation, leurs bascules, résistances, conséquences et états de fin de saison.

## 8. Bibliothèque de séquences

Futur document canonique.

Déclinera la grammaire en séquences mémorables servant les routes et les actes.

## 9. Règles des scènes modulaires

Futur document canonique.

Définira comment une séquence s’adapte à l’état réel de la partie sans créer une nouvelle route.

## 10. Progression visuelle

Futur document canonique.

Définira les étapes, audiences, intentions, limites, risques et conséquences des photos.

## 11. Découpage des journées

Futur document canonique.

Répartira les séquences, silences, respirations et photos une fois l’architecture relationnelle validée.

## 12. Canon complet des personnages

Lire :

- `docs/canon/characters/CHARACTER_CANON_INDEX.md` ;
- le fichier canon complet du personnage concerné ;
- `docs/canon/CHARACTER_VOICE_DISTINCTION_CANON.md` ;
- `docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md` lorsque les moteurs adultes, les images, les risques ou les conséquences sont impliqués ;
- la carte de dépréciation correspondante lorsqu’elle existe ;
- `docs/canon/SUPPORTING_CHARACTER_CANON_POLICY.md` pour Jeff, Bastien et les autres personnages secondaires.

Le canon complet des personnages reste l’autorité sur :

- l’identité ;
- le passé ;
- la proximité initiale ;
- la voix ;
- les contradictions ;
- les limites personnelles ;
- les désirs spécifiques ;
- la continuité individuelle.

## 13. Contrats narratifs

Lire selon le besoin :

- `docs/canon/CHOICE_DESIGN_CANON.md` ;
- `docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md` ;
- `docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md` ;
- `docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md` ;
- `docs/canon/TEMPORAL_FLOW_AND_DAY_TRANSITION_CANON.md`.

Ces documents définissent les règles de choix, de modularité, de communication et de temporalité compatibles avec la Bible.

## 14. Runtime

Lire les plans, rapports, index de chapitres, conversations actives, données visuelles, tests, ledgers et validations de la version concernée.

Le runtime répond à :

> « Qu’est-ce qui est effectivement implémenté et jouable ? »

Il ne répond pas seul à :

> « Quelle doit être la vision définitive du jeu ? »

---

# 3. Hiérarchie de conception officielle

```text
North Star
-> Expérience joueur
-> Fantasmes centraux
-> Routes macro
-> Actes
-> Séquences
-> Scènes modulaires
-> Dialogues et photos
-> Découpage en journées
-> Runtime
```

Précisions :

- la grammaire narrative fournit le vocabulaire des séquences ;
- les routes macro donnent une direction aux actes ;
- les actes expriment des transformations globales ;
- les séquences accomplissent des fonctions ;
- les scènes adaptent ces fonctions à la partie ;
- les scènes ne créent pas les routes ;
- les journées sont construites après les séquences.

---

# 4. Hiérarchie d’autorité

## Bible Narrative

Autorité sur :

- la promesse du jeu ;
- l’expérience joueur ;
- les fantasmes ;
- la structure globale ;
- les routes et transformations ;
- les actes ;
- la progression visuelle ;
- la fonction des séquences.

## Canon complet des personnages

Autorité sur :

- l’identité ;
- la voix ;
- l’histoire ;
- les responsabilités ;
- les limites ;
- les réactions propres ;
- la continuité individuelle.

## Contrats narratifs

Autorité sur les règles techniques d’écriture compatibles :

- choix ;
- modularité ;
- temps ;
- communication ;
- adaptation des scènes.

## Runtime

Autorité uniquement sur l’état effectivement implémenté et validé.

## Archive et À réécrire

Contexte historique ou intention à requalifier, sans autorité en cas de contradiction.

---

# 5. Règle de spécificité

La grammaire peut être partagée.

> **Les fonctions de scène peuvent être réutilisées. Les dialogues, les réactions, les risques et les conséquences doivent rester propres au personnage.**

Une scène ne devient pas spécifique parce que le nom du personnage a été remplacé.

Le canon complet doit être relu avant toute écriture de dialogue.

---

# 6. Règle sur les anciens documents

Les anciens source packs, plans de vagues, cartes de scènes, matrices de routes et plans par journée restent utiles pour :

- comprendre le runtime existant ;
- retrouver l’origine d’une décision ;
- préserver un détail compatible ;
- identifier une scène réutilisable dans une séquence.

Ils ne constituent plus l’architecture principale.

Un ancien document peut être classé :

- Canon ;
- Runtime ;
- Archive ;
- À réécrire.

Un document non classé ne peut pas prévaloir sur la Bible.

---

# 7. Règle sur le moteur

Le moteur narratif est considéré comme acquis.

Sauf nécessité narrative exceptionnelle, la Bible se construit au-dessus du téléphone, des conversations persistantes, de la galerie, des notifications, des photos, des ledgers, des obligations, des scènes modulaires, des tests et de l’architecture générale.

---

# 8. Règle finale

```text
Utiliser la Bible pour savoir ce que le jeu doit faire ressentir et devenir.
Utiliser le canon complet pour écrire une personne précise.
Utiliser la grammaire pour identifier la fonction d’une séquence.
Utiliser les contrats narratifs pour adapter la scène.
Utiliser les journées pour distribuer le rythme.
Utiliser le runtime pour décrire ce qui est jouable.
```
