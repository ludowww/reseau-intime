# R8B — Vue d'état narratif en lecture seule

`EtatNarratifLecture` reçoit un `Season1State` et construit trois dictionnaires reconstructibles : `obtenir_resume_relation_centrale`, `obtenir_resume_relation` et `obtenir_resume_etat_narratif`. La classe ne possède aucun état, n'appelle aucune méthode de mutation et ne participe ni au snapshot ni à sa restauration.

## Lisible, projeté, indéterminable

- **Lisible** : états de route, `couple_state`, jour, registres, `foreground_history` et connaissances sont lus sans les modifier.
- **Projeté** : l'acte historique J01–J21, le statut de disponibilité relationnelle et les tables d'arc par personnage. `etat_arc` conserve une valeur canonique précise seulement lorsque la correspondance est explicite; la valeur legacy reste exclusivement dans `debug.valeur_runtime_legacy`.
- **Indéterminable** : contrat de couple, divulgation, confiance, désir (hors Nico), intimité et secret en l'absence de preuve relationnelle dédiée. Marie ne possède pas de trajectoire individuelle fiable dans le runtime historique : son `etat_arc` est donc `INDETERMINE`; son `statut_relation` peut seulement refléter prudemment la disponibilité du couple.

## Taxonomies de vue

`statut_couple` est strictement borné à `ENSEMBLE`, `SEPARES`, `EN_CLARIFICATION` ou `INDETERMINE`. `RECONQUEST_ACTIVE`, `PROVISIONAL_AGREEMENT` et `FRACTURE` ne sont jamais retournés par ce champ : ils restent legacy dans `debug`.

`etat_arc` et `statut_relation` sont distincts. `statut_relation` exprime seulement la disponibilité (`NON_ETABLI`, `ACTIVE`, `PAUSED`, éventuellement `CLOSED` ou `INDETERMINE`). Les mappings d'arc sont volontairement bornés et par personnage :

| Personnage | Runtime fiable → `etat_arc` | Autres valeurs runtime |
|---|---|---|
| Marie | aucune trajectoire individuelle | `INDETERMINE` |
| Sandra | `PROTECTIVE_DISTANCE` → `PROTECTIVE_WITHDRAWAL`; `TRUST_BROKEN`, `PRIVILEGED_CONFIDENCE`, `FRIENDSHIP_RESTORED` | `INDETERMINE` |
| Mathilde | `DISTANCE` → `TAKING_DISTANCE`; `TRUST_BROKEN`, `SECRET_SUSPENDED` | `INDETERMINE` |
| Pauline | `SURFACE_RESTORED`, `COMPARTMENT_PROTECTED`, `COMPARTMENT_CLOSED` | `INDETERMINE` |
| Raphaëlle | `CREATIVE_CONFIDENCE` → `CREATIVE_TRUST`; `FUTURE_INVITATION`, `BOUNDARY_REINFORCED`, `COLLEAGUE_ONLY` | `INDETERMINE` |
| Nico | `DISTANCE` → `TAKING_DISTANCE`; `ORDINARY_FRIEND`, `GUARDRAIL`, `LIMITED_CONFIDANT` | `INDETERMINE` |

Les états non établis donnent `NON_ETABLI` (sauf Marie, qui reste `INDETERMINE`).

## Événements et connaissances

Le dernier événement provient uniquement de `foreground_history`, registre append-only où l'ordre et `character_id` sont sourcés. Une trace n'est jamais renommée en événement, et l'absence d'entrée fiable donne une chaîne vide documentée dans `debug`. La vue globale conserve le dernier segment de cet ordre d'insertion; elle ne trie jamais des IDs de traces.

Pour les faits utiles, `current_knowers` est toujours prioritaire. `initial_knowers` n'est utilisé que si le premier champ est absent, et ce fallback est indiqué dans `debug.provenance_connaissances`. Un fait privé, même connu, ne suffit pas à projeter `secret = PRESENT`; il faut une preuve dédiée portant à la fois `relation_scope` et `secret_status = PRESENT`.

## Identifiants publics

Chaque alias est `PREFIXE_` suivi de l'encodage hexadécimal UTF-8 de l'ID legacy complet. Cette représentation déterministe est injective : deux IDs legacy distincts, y compris avec le même suffixe après jour, restent donc distincts. Elle ne publie pas une clé lisible `jNN_*`; l'ID legacy reste disponible seulement dans la provenance `debug` lorsque celle-ci est fournie.

Les listes sont stabilisées là où elles n'ont pas de sémantique chronologique. Les événements conservent au contraire l'ordre sourcé du registre append-only.
