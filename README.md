# Réseau Intime

**Réseau Intime** est un jeu narratif adulte en interface smartphone.

Le joueur incarne **Player** — nom générique temporaire du protagoniste, remplacé à terme par le prénom choisi par le joueur — en couple avec **Marie**, alors que la routine, les secrets, les notifications et les désirs croisés fragilisent leur relation. Le jeu se déroule principalement via messagerie instantanée, posts sociaux, notifications, photos, vidéos, conversations de groupe et contenus privés.

La promesse du jeu :

> Toutes les routes racontent la même histoire : un couple en routine entouré de désirs qui se réveillent. Ce qui change, c’est la façon dont le personnage joueur gère cette vérité : mentir, avouer, partager, contrôler, subir ou partir.

## Décisions validées

```text
Titre officiel : Réseau Intime
Moteur : Godot 4.6.2
Structure : tronc commun + route dominante + route secondaire + menace + mode relationnel
Cadre : explicite progressif, non moralisateur, conséquences fortes, placeholders d’abord
```

## Piliers

- Interface de smartphone immersive.
- Conversations multiples avec notifications.
- Photos et vidéos comme récompenses, preuves et risques narratifs.
- Routes relationnelles : tromperie, réparation, libertinage, polyamour, NTR, harem, chaos.
- Personnages liés entre eux : les choix envers une personne modifient les autres relations.
- Rejouabilité fondée sur des dynamiques différentes, pas seulement sur des scènes à collectionner.

## Structure du projet

```text
README.md
ROADMAP.md
docs/
  00_PROJECT_VISION.md
  01_NARRATIVE_BIBLE.md
  02_CHARACTER_BIBLE.md
  03_ROUTE_ARCHITECTURE.md
  04_ENDINGS_MATRIX.md
  05_CONTENT_VISUAL_RULES.md
  06_SMARTPHONE_UX.md
  07_TECHNICAL_ARCHITECTURE.md
  08_DATA_FORMATS.md
  09_WRITING_GUIDELINES.md
  10_VERTICAL_SLICE_SCOPE.md
  J2_WRITING_FOUNDATION.md
  J3_J5_Desire_Tension_Visual_Routes_Spec.md
  J3_WRITING_FOUNDATION.md
  story_state/
    GLOBAL_STORY_STATE.md
    J1_SUMMARY.md
    J2_SUMMARY.md
    CHARACTER_CONTINUITY_MATRIX.md
  decisions/
    DECISION_001_ENGINE.md
    DECISION_002_CORE_STRUCTURE.md
    DECISION_003_GAME_TITLE.md
    DECISION_004_FOUNDATIONAL_BOUNDARIES.md
    DECISION_005_J2_VISUAL_RHYTHM_AND_MATHILDE.md
    DECISION_006_PLAYER_NAME_AND_THREAD_MODEL.md
    DECISION_007_J3_J5_DESIRE_TENSION_VISUAL_ROUTES.md
```

## Règle de conception

Le jeu ne doit pas devenir six histoires séparées. Il doit garder un tronc commun :

1. Player et Marie sont en couple.
2. La routine a affaibli le désir.
3. Chaque personnage ouvre une faille différente.
4. Une soirée pivot révèle les tensions.
5. Une preuve ou un contenu intime met les choix en danger.
6. Le personnage joueur choisit entre secret, vérité, ouverture, contrôle ou fuite.
7. Le réseau relationnel se recompose en fin de partie.

## Cadre adulte

Le niveau est explicite progressif, pouvant aller jusqu’au porno assumé dans les routes avancées. Le jeu ne moralise pas, mais il ne banalise jamais : tout choix intime doit créer une trace, une conséquence ou une tension.

## Statut

Prototype data-first en cours : J1/J2 intégrés avec placeholders, documentation en alignement continu. J3-J5 sont cadrés côté désir, tensions, contenus visuels, routes et preuves avant écriture détaillée ; J3 dispose maintenant d’une fondation d’écriture exploitable.