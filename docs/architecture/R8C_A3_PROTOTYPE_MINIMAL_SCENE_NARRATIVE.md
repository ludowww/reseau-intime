# R8C-A3 — Prototype minimal de scène narrative

## Statut et périmètre

**Catégorie :** brief technique de branche

**Statut :** prototype synthétique, non canonique et non connecté au runtime historique

**Base :** R8C-A1 et contrat produit R8C-A2, depuis `5484a4dfbd94a4c7da947362a4b9a40fc7eab1ef`

Ce lot prouve le trajet minimal d'une scène écrite : déclaration, évaluation, création d'une instance lors d'une intention réelle, proposition perceptible, résolution ou occasion manquée, puis conséquence qualitative via la frontière transactionnelle existante d'`EtatNarratif`.

## Représentation retenue

Les définitions sont des dictionnaires issus d'une fixture JSON explicitement non canonique. Elles portent l'identité stable, la version, la nature, la fonction, les participants, le noyau écrit, les lectures autorisées, les conditions bornées, le contrat temporel, les choix, les résolutions et la politique de non-résolution.

`R8CSceneDefinition` valide cette forme sans langage d'expression général. `R8CSceneInstance` conserve l'occurrence située, sa référence au contexte évalué et l'historique sourcé de ses transitions. `R8CMinimalSceneEngine` évalue six familles seulement :

- acte compatible ;
- événements requis présents et événements interdits absents ;
- participants requis disponibles ;
- définition non déjà résolue ;
- fenêtre datée et horaire ouverte ;
- opportunité contextuelle encore valide.

Le diagnostic liste chaque condition, son résultat et un code de raison stable. Une définition seulement éligible ne crée aucune instance. La création exige un identifiant d'instance et une intention de proposition explicite.

## Cycle de vie minimal

La surface A3 demandée emploie `INELIGIBLE`, `ELIGIBLE`, `PROPOSED`, `RESOLVED`, `MISSED` et `CANCELLED`. Ils correspondent respectivement aux concepts `INELIGIBLE`, `ELIGIBLE`, `PROPOSEE`, `RESOLUE`, `MANQUEE` et `ANNULEE` de R8C-A2.

`PLANIFIEE` n'est pas implémenté : le prototype ne planifie pas de journée et crée directement une instance `ELIGIBLE` au moment d'une intention concrète de proposition. Cette réduction est locale à A3 et ne redéfinit pas le cycle canonique complet d'A2.

Une définition éligible jamais proposée expire sans événement. `MISSED` n'est accessible que depuis `PROPOSED`, après la fin de la fenêtre écrite et seulement si la politique authored lui donne un sens narratif. `CANCELLED` reste une terminaison sourcée sans imputation automatique au joueur.

## Transaction et invariants A1

Le prototype n'ajoute aucun type d'événement à A1 et ne modifie pas son API. Une résolution produit un événement relationnel synthétique A1 comprenant une provenance de scène, d'instance et de résolution. Le reducer existant reçoit une liste complète de faits qualitatifs préservant les faits antérieurs.

L'instance ne passe à `RESOLVED` ou `MISSED` qu'après un retour `APPLIQUE` ou `IDEMPOTENT` d'`EtatNarratif`. Un rejet conserve l'instance dans `PROPOSED` et bénéficie de l'atomicité d'un événement unique déjà garantie par A1. Ce lot ne prétend pas fournir une transaction multi-événements.

Les scripts de scène ne mutent jamais directement `EtatRelation`, `EtatRelationCentrale` ni les registres d'`EtatNarratif`.

## Démonstration synthétique

La fixture contient :

- une signature Sandra bornée à une fenêtre réelle, unique après résolution, dépendante d'un événement relationnel synthétique et dotée de trois formulations : sobre, chaleureuse, audacieuse ;
- un module « conversation à distance avec une personne temporairement absente » écrit pour Sandra ;
- le même squelette technique écrit pour Raphaëlle avec participant, condition, noyau, horaire, réaction et conséquence distincts.

Les variantes modulaires partagent un `structure_id`, jamais leur identité ou leur contrat authored. Une instance créée depuis l'une refuse l'autre définition.

## Micro-signaux

Les branches convergent vers `RETOUR_NOYAU_COMMUN`.

La réponse sobre ne persiste ni sa formulation ni son identifiant de choix ; seul le fait neutre que la scène a été résolue est écrit. Une réponse chaleureuse ne produit un fait durable que lorsque Sandra la reçoit et l'interprète explicitement. La réponse audacieuse peut être reçue dans ce contexte sans créer de permission future, ou conduire Sandra à formuler une limite explicite persistée comme fait qualitatif sourcé.

Aucune accumulation ne relie ces branches et aucun micro-choix isolé ne débloque une escalade.

## Hors périmètre

Sont exclus : runtime Saison 1 historique, dialogues canoniques, UI, sauvegarde, migration, constructeur de journée, planificateur, séquences, sélection entre candidates, hasard, priorité numérique, texte dynamique, langage universel de règles, transaction multi-événements, taxonomie finale, traces temporaires, médias et réconciliation de `docs/15_PLAYER_FLOW_AND_PASSIVE_SIGNALS.md`.

Le prototype ne contient aucune jauge relationnelle cachée, aucun compteur de gestes et aucun profil psychologique inféré.
