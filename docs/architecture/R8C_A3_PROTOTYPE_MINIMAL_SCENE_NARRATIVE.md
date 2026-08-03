# R8C-A3 — Prototype minimal de scène narrative

## Statut et périmètre

**Catégorie :** brief technique de branche

**Statut :** prototype synthétique, non canonique et non connecté au runtime historique

**Base :** R8C-A1 et contrat produit R8C-A2, depuis `5484a4dfbd94a4c7da947362a4b9a40fc7eab1ef`

Ce lot prouve le trajet minimal d'une scène écrite : déclaration, évaluation, instance située, proposition perceptible, résolution liée au choix ou occasion manquée, puis éventuelle conséquence qualitative par la frontière transactionnelle existante d'`EtatNarratif`.

Il ne modifie ni R8C-A1, ni R8C-A2, ni `docs/15_PLAYER_FLOW_AND_PASSIVE_SIGNALS.md`.

## Contrat réellement consommé

Les définitions sont des dictionnaires provenant d'une fixture JSON marquée `FIXTURE_NON_CANONIQUE`. Le noyau obligatoire contient : identité et version, nature, fonction, participants, conditions et exclusions bornées, contrat temporel, politique `UNIQUE` ou `REPETABLE`, et dictionnaire de résolutions. Les choix sont optionnels et limités à trois.

Chaque choix écrit déclare un `choix_id`, une formulation, un `signal_emis` et les `resolution_ids` autorisés. Chaque résolution déclare le même signal comme `signal_recu`, sa portée, sa réception, son interprétation et sa convergence. Une définition avec zéro choix et zéro résolution est valide. Une résolution durable n'est valide qu'avec réception non locale, interprétation explicite et au moins un fait relationnel.

Les anciens champs décoratifs `lectures_etat`, `observabilite`, `sortie` et `referentiel_calendrier` ont été retirés de la fixture. Il n'existe aucun langage d'expression général.

Le contrat temporel valide les vraies dates civiles et les heures `HH:MM`. Les horaires sont convertis en minutes avant comparaison. Le diagnostic expose `revalidation_requise_avant`, qui vaut réellement la fermeture de la fenêtre écrite.

## Évaluation et cycle de vie

`R8CMinimalSceneEngine` évalue six familles :

- acte compatible ;
- événements requis présents et événements interdits absents ;
- participants requis disponibles ;
- politique d'unicité ;
- fenêtre datée et horaire ouverte ;
- opportunité contextuelle encore valide.

Le diagnostic énumère chaque condition avec son résultat et un code de raison. Une instance peut naître `INELIGIBLE` ou `ELIGIBLE`. Une réévaluation autorise `INELIGIBLE -> ELIGIBLE` et `ELIGIBLE -> INELIGIBLE`.

Le cycle implémenté emploie exactement `INELIGIBLE`, `ELIGIBLE`, `PROPOSED`, `RESOLVED`, `MISSED` et `CANCELLED`. Depuis `ELIGIBLE`, seule une proposition peut mener à `PROPOSED`. Depuis `PROPOSED`, seules une résolution, une occasion manquée ou une annulation peuvent terminer l'instance. `RESOLVED`, `MISSED` et `CANCELLED` sont immuables. Toute autre transition est refusée avant mutation.

`PLANIFIEE` reste hors prototype : A3 ne construit pas de journée.

Une définition éligible jamais proposée expire silencieusement. Une proposition peut devenir `MISSED` ou `CANCELLED` après fermeture selon sa politique. Une conséquence d'occasion manquée n'existe que si elle est explicitement écrite.

## Choix, revalidation et transaction

La résolution prend explicitement `choix_id` et `resolution_id`. Le moteur vérifie que le choix existe, que la résolution lui est autorisée, puis que `signal_emis == signal_recu`. Une formulation sobre ne peut donc produire ni la réception chaleureuse ni la limite audacieuse.

Avec `AVANT_PROPOSITION_ET_RESOLUTION`, le contexte courant est réévalué juste avant toute préparation de résolution. Une fenêtre fermée, un participant indisponible, un acte changé, une exclusion nouvelle, une opportunité expirée ou une résolution UNIQUE concurrente refusent l'opération sans modifier A1 ni l'instance.

La séquence terminale est :

1. validation définition, choix, résolution, signal et contexte ;
2. construction des données terminales et de l'éventuelle trace temporaire ;
3. préparation complète et sans mutation de la transition d'instance ;
4. construction et vérification de la conséquence candidate si la portée est durable ;
5. appel atomique unique à A1 si la portée est durable ;
6. application sans validation restante de la transition déjà préparée.

Un rejet A1 laisse l'instance `PROPOSED`. Après un retour `APPLIQUE` ou `IDEMPOTENT`, aucune opération susceptible de refuser la transition n'est exécutée.

L'identifiant `r8c-a3:<instance_id>:resolution:<resolution_id>` est déterministe. L'instance mémorise cette terminaison avec le choix et la résolution. Une reprise strictement identique est `IDEMPOTENT`; toute autre résolution terminale est refusée. Si A1 avait déjà accepté l'événement mais que l'instance était encore `PROPOSED`, le candidat existant identique peut être repris puis la transition préparée appliquée.

## Unicité

`instance_id` identifie une occurrence et ne peut jamais être enregistré deux fois dans un même moteur.

`UNIQUE` s'applique à la définition : le registre du moteur interdit deux instances non terminales simultanées. Après une résolution durable, la provenance A1 empêche aussi une nouvelle résolution par un autre moteur. `REPETABLE` permet plusieurs occurrences et plusieurs résolutions.

Limite assumée du prototype : une résolution UNIQUE purement LOCAL ou TEMPORAIRE n'écrit volontairement rien dans A1. Son unicité post-résolution est donc conservée par le moteur vivant, pas restaurée après reconstruction complète du moteur. Résoudre ce point demanderait un registre persistant d'instances, hors A3 et contradictoire avec l'interdiction de persister un signal local.

## Trois portées de micro-signaux

- `LOCALE` : aucune écriture A1 et aucune trace de séquence ; seul le diagnostic retourné décrit l'effet immédiat.
- `TEMPORAIRE` : aucune écriture A1 ; une trace explicitement déclarée vit dans `SceneInstance` et peut être nettoyée à la fin de la courte séquence.
- `DURABLE` : un événement relationnel A1 est produit avec provenance de scène, instance, choix, signal et résolution.

`DURABLE + NON_PERSISTANTE` est invalide. Les branches convergent toutes vers `RETOUR_NOYAU_COMMUN`. Aucune accumulation, aucun score, aucun compteur ni profil psychologique ne relie ces branches.

La fixture démontre une réponse Sandra sobre locale, une attention chaleureuse durable, une audace durable ou une limite durable accessible seulement depuis le choix audacieux, ainsi qu'un écho Sandra temporaire. Le module Raphaëlle conserve des participants, conditions, horaires, signaux et conséquences distincts malgré un `structure_id` partagé.

## Frontière A1 et hors périmètre

A3 n'ajoute aucun type d'événement et aucune fonction publique à A1. Les scripts de scène ne mutent jamais directement `EtatRelation`, `EtatRelationCentrale` ni les registres d'`EtatNarratif`.

Restent exclus : runtime Saison 1 historique, dialogues canoniques, UI, sauvegarde, migration, constructeur de journée, planificateur, séquences, sélection entre candidates, hasard, priorité numérique, texte dynamique, moteur universel, rollback générique, transaction multi-événements, médias et démarrage de R8C-A4.
