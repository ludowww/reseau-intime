# R8C-A9 — Composition contrôlée d’un créneau narratif

> **Statut :** `IMPLEMENTED_PROTOTYPE_NON_CANONIQUE`
> **Base :** R8C-A8 verrouillé au SHA `0d5805e9f45279983222d15a2e51786df754c06c`
> **Contenu :** fenêtres A8 synthétiques uniquement; aucun contenu Saison 1.

## Responsabilité A9

`R8CControlledNarrativeSlotCompositionCoordinator` reçoit un créneau et un
ensemble de fenêtres A8 déjà choisi par l’appelant. Il vérifie que cet ensemble
tient dans le créneau, puis calcule un programme temporel déterministe. A9 ne
choisit ni les fenêtres, ni leur ordre, ni une option à l’intérieur d’une
fenêtre.

La seule dépendance opérationnelle du coordinateur est la surface A8. A9 réutilise
les primitives ISO stables de `SceneDefinition` pour ne pas créer un second
parseur temporel, mais il n’appelle ni le moteur A3/A5, ni la bibliothèque A6, ni
le coordinateur A7. Toute vérification d’identité, de provenance et d’éligibilité
reste déléguée à A8. Toute exécution future d’une opportunité devra repasser
explicitement par A8/A7 après revalidation du plan.

## Entrée fermée du créneau

Une spécification contient exactement :

| Champ | Contrat |
| --- | --- |
| `slot_id` | identité stable, authored, en minuscules ASCII/chiffres/`_` |
| `narrative_date` | date ISO du créneau |
| `starts_at`, `ends_at` | instants ISO normalisés, même date et même offset |
| `context` | contexte courant A8 borné, avec `moment_diegetique` |
| `windows` | descriptions explicites des fenêtres à composer |
| `author_order` | liste explicite des `window_id` dans l’ordre auteur |

Chaque description de fenêtre contient exactement `window_id`,
`duration_minutes`, `not_before` et `not_after`. Les durées sont des entiers
strictement positifs. A9 accepte au plus 32 fenêtres et travaille à la minute,
sur une seule date narrative et un offset unique. Les secondes doivent donc être
`00`.

Les deux collections ont le même cardinal. Chaque fenêtre apparaît une fois
dans `windows` et une fois dans `author_order`. Les doublons, identités inconnues,
champs supplémentaires, bornes hors créneau et contextes incompatibles sont
refusés. A9 ne maintient aucun registre global de `slot_id` : la stabilité de
l’identité est prouvée par l’empreinte du plan, sans transformer les plans en
état persistant. La coordination de plusieurs appels portant le même `slot_id`
reste donc une responsabilité du caller.

## Implantation `earliest-fit`

Le curseur part de `starts_at`. Pour chaque `window_id` de `author_order`, A9
prend le plus tardif entre :

- le curseur courant ;
- `not_before` ;
- l’ouverture effective de la fenêtre A8.

La fin calculée est ce début plus `duration_minutes`. Elle doit rester avant les
trois limites applicables : `ends_at`, `not_after` et la fermeture A8. Après une
implantation valide, la fin devient le curseur de la fenêtre suivante.

L’algorithme ne trie pas, ne permute pas et ne cherche pas de meilleur
arrangement. Si l’ordre auteur ne tient pas, toute la composition est refusée et
aucun plan partiel n’est publié. L’absence de chevauchement découle du curseur
monotone et est revérifiée lors de la lecture d’un plan.

## Format du plan éphémère

Un succès retourne `plan` avec :

- `format = R8C_A9_CONTROLLED_NARRATIVE_SLOT_PLAN` et `version = 1` ;
- l’identité et les bornes du créneau ;
- la projection stable du contexte, sans l’instant courant ;
- `author_order` inchangé ;
- les fenêtres planifiées dans cet ordre, chacune avec position auteur, durée,
  contraintes, horaires calculés et empreinte de la fenêtre A8 observée ;
- `fingerprint`, empreinte SHA-256 du contenu canonique complet du plan.

L’empreinte lie le slot, ses bornes, son contexte stable, l’ordre auteur, les
fenêtres A8, leurs contraintes et leurs horaires. La sérialisation trie les clés
des dictionnaires mais préserve l’ordre des tableaux. Une variation de contexte,
d’ordre ou de fenêtres produit donc une autre empreinte.

Le coordinateur ne conserve aucun plan, n’expose aucun snapshot et ne fournit
aucune restauration. Rejouer la même entrée valide recalcule exactement le même
plan et la même empreinte : l’idempotence est une propriété du calcul pur, pas
d’un cache.

## Revalidation avant utilisation

`revalider_plan` vérifie d’abord la forme fermée du plan, ses horaires, ses
durées, l’ordre auteur, les chevauchements et son empreinte. Il recalcule ensuite
l’implantation `earliest-fit` complète depuis les contraintes et les fenêtres A8
courantes : les horaires reçus doivent être exactement égaux au résultat
canonique. Il compare enfin le contexte stable courant au contexte capturé, puis
demande à A8 de revalider chaque fenêtre sur ses deux bornes planifiées.

La nouvelle lecture A8 `revalider_fenetre_planifiable` vérifie sans mutation :

- fenêtre connue, encore `OPEN` et sans option sélectionnée ;
- contexte authored inchangé et fenêtre non expirée ;
- début et fin planifiés dans les bornes A8, avec début non dépassé ;
- toutes les options encore `CANDIDATE`, sans instance A5 ;
- propriété des identités A8 ;
- rechargement et revalidation de chaque candidat A6/A3.

Elle retourne seulement le résumé A8 assaini et une empreinte de sa
spécification. Elle n’expose ni candidat, ni définition, ni preuve de provenance.
Si le contexte change, si la fenêtre expire, si son état devient incompatible ou
si une identité/provenance ne se revalide plus, le plan est refusé comme obsolète
sans modification A1, A5, A7 ou A8.

## Atomicité, diagnostics et frontières

Composer et revalider sont des lectures. A9 ne crée aucune instance A5, ne
réserve et ne propose rien via A7, ne produit aucun `MISSED`, ne ferme aucune
fenêtre A8 et n’émet aucun événement A1. Les plans ne sont jamais ajoutés aux
snapshots A5.

Les méthodes runtime rendent un résultat borné et un code d’erreur générique.
Les variantes `*_dev`, disponibles seulement en build de développement, dans
l’éditeur et les tests, ajoutent le code précis, la position auteur et la fenêtre
concernée. Les preuves A6 demeurent privées à A8.

A9 n’est pas :

- un sélecteur de fenêtre ou d’option ;
- un moteur de classement, de poids, de priorité numérique ou d’aléatoire ;
- un moteur de séquence ;
- un constructeur de journée ou une composition multi-jour ;
- un gestionnaire de déplacement, de ressources personnages ou de parallélisme ;
- une connexion au runtime Portrait/Saison 1.

Le futur constructeur de journée pourra fournir plusieurs créneaux et leurs
fenêtres explicites à A9. Il ne devra pas réinterpréter un plan A9 comme une
décision automatique ni contourner la revalidation A8/A7.

## Validation ciblée

```bash
python -m unittest tests.test_r8c_a1_narrative_state_static tests.test_r8c_a3_minimal_scene_prototype_static tests.test_r8c_a5_persistent_scene_registry_static tests.test_r8c_a6_minimal_narrative_library_static tests.test_r8c_a7_candidate_reservation_proposal_static tests.test_r8c_a8_opportunity_windows_exclusive_conflicts_static tests.test_r8c_a9_controlled_narrative_slot_composition_static -v
godot --headless --path game res://tests/R8CAControlledNarrativeSlotCompositionSmokeTest.tscn
```
