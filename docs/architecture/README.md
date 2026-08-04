# Architecture narrative canonique — ordre de lecture

> **Statut : `ACTIVE_CANON_INDEX`**
> **Baseline de départ auditée :** `4dda96f437d1e44658b7fc0748dca421ab98c0cc`

Cet index est le point d'entrée minimal pour le moteur narratif R8A–R8C. En cas
de contradiction, le document placé plus haut dans la liste prévaut sur les
documents techniques qui le suivent.

1. [`14_CONTRAT_NARRATIF_SAISON_1_RECONCILIE.md`](../canon/bible/14_CONTRAT_NARRATIF_SAISON_1_RECONCILIE.md) — arbitrages narratifs verrouillés.
2. [`R8A_ROUTE_STATE_SIMPLIFICATION_BLUEPRINT.md`](R8A_ROUTE_STATE_SIMPLIFICATION_BLUEPRINT.md) — état qualitatif, frontières et interdictions.
3. [`R8A_D1_CONTRAT_PRODUIT_MOTEUR_NARRATIF.md`](R8A_D1_CONTRAT_PRODUIT_MOTEUR_NARRATIF.md) — capacités produit du nouveau moteur.
4. [`R8B_VUE_ETAT_NARRATIF_LECTURE_SEULE.md`](R8B_VUE_ETAT_NARRATIF_LECTURE_SEULE.md) — projection de lecture de l'oracle historique.
5. [`R8C_A1_FONDATION_ETAT_NARRATIF.md`](R8C_A1_FONDATION_ETAT_NARRATIF.md) — fondation transactionnelle commune.
6. [`R8C_A2_CONTRAT_SCENE_MODULAIRE_ET_MOTEUR_NARRATIF.md`](R8C_A2_CONTRAT_SCENE_MODULAIRE_ET_MOTEUR_NARRATIF.md) — scènes, séquences et micro-signaux.
7. [`R8C_A3_PROTOTYPE_MINIMAL_SCENE_NARRATIVE.md`](R8C_A3_PROTOTYPE_MINIMAL_SCENE_NARRATIVE.md) — preuve technique synthétique, non canonique comme contenu.
8. [`R8C_A4_CONSOLIDATION_CANONIQUE_ET_NETTOYAGE_LEGACY.md`](../maintenance/R8C_A4_CONSOLIDATION_CANONIQUE_ET_NETTOYAGE_LEGACY.md) — classement, suppressions et gate courante.
9. [`R8C_A5_PERSISTANCE_MINIMALE_SCENES_ET_OPPORTUNITES.md`](R8C_A5_PERSISTANCE_MINIMALE_SCENES_ET_OPPORTUNITES.md) — snapshot current-only, registre d'instances et reprise idempotente.
10. [`R8C_A6_BRIEF_BIBLIOTHEQUE_NARRATIVE_MINIMALE.md`](R8C_A6_BRIEF_BIBLIOTHEQUE_NARRATIVE_MINIMALE.md) — brief documentaire uniquement, non implémenté.

## Invariants de reprise

- Une route émerge de faits et d'événements qualitatifs ; elle n'est ni choisie
  dans un menu ni débloquée par un total numérique.
- Un micro-signal suit la chaîne `émission → réception → interprétation → effet`.
  Son effet est `LOCAL`, `TEMPORAIRE` ou `DURABLE`; la portée durable exige un
  événement explicite et sourcé.
- Aucun score d'attirance, de consentement ou de relation, aucun seuil d'emoji
  et aucune accumulation automatique de micro-signaux.
- Le consentement est local, actuel et retirable.
- Les jours sont des contenants diégétiques, pas une topologie rigide ni un
  quota de scènes. Les clés `jNN_*` appartiennent uniquement à l'oracle runtime
  historique conservé temporairement.
- La fixture R8C-A3 reste sous `game/tests/fixtures/`, marquée
  `FIXTURE_NON_CANONIQUE`, et n'est chargée par aucun loader de contenu.

## Frontière temporaire

Le runtime portrait `Season1RuntimeProvider` J01–J21 reste l'oracle exécutable
jusqu'à son remplacement par les lots R8C ultérieurs. Sa présence ne lui donne
pas autorité sur le modèle futur et n'autorise aucune nouvelle compatibilité
legacy. R8C-A5 ajoute la persistance minimale du nouveau moteur sans connecter
ni modifier cet oracle et sans démarrer de constructeur de journée.
