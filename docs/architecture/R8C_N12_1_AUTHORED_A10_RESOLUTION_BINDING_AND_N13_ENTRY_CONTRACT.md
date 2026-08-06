# R8C-N12.1 — Liaison des résolutions authored à A10 et contrat d'entrée N13

> **Statut : `AUTHORED_A10_RESOLUTION_BINDING_CONTRACT_APPROVED`**
> **Baseline obligatoire :** `5571086d80ebffefaa54dc6c6b6e16f0af18d8d6`
> **Tag stable :** `r8c-n12-authored-schema-validation-projection-ports`

> **Approbation produit :** commit `ec005dde6e6cc1e8e72a01c6eca5ce1d2ebf799b`
> revu et approuvé sans réserve, date de référence : août 2026.

## 1. Portée de l'amendement

Le présent document amende le contrat N11 sur un seul point : la liaison
explicite entre une issue authored, le choix player-facing qui la sélectionne,
et le couple A3/A10 transmis à `A10.resolve_scene`. Il fixe aussi la nouvelle
entrée de N13.

Il n'autorise ni exécuteur, ni sauvegarde, ni projection UI, ni modification
d'A1–A10, ni nouvelle opération A10. N13 reste arrêté tant que ce lot n'est pas
revu et intégré.

## 2. Trois identités distinctes

| Identité | Sens |
|---|---|
| `resolution_id` | Identité authored de l'issue player-facing. Les reducers l'utilisent pour relire la définition authored validée. |
| `a10_choice_id` | Identité du choix racine A3/A10 présent dans `orchestration.a6_entry.definition.choix`. |
| `a10_resolution_id` | Identité de la résolution A3/A10 réellement transmise à `resolve_scene`. |

Ces identités sont liées par des champs explicites. Aucune inférence par nom,
préfixe, suffixe, ordre, index, position ou égalité accidentelle n'est admise.
En particulier, `resolution_id` n'est jamais transmis à A10 comme substitut de
`a10_resolution_id`.

## 3. Règle de commit et invariants de mapping

- `a10_resolution_id = null` désigne une résolution authored locale. Elle ne
  demande aucun commit durable A10.
- `a10_resolution_id != null` désigne une résolution committable par A10.
- Toute résolution authored dont au moins une collection d'effets durables est
  non vide doit posséder un `a10_resolution_id`. Les collections concernées
  sont `event_refs`, `fact_ids`, `knowledge_ids`, `trace_ids`,
  `promise_effects`, `obligation_effects`, `consequence_ids` et
  `media_effects`.
- Le couple `a10_choice_id/a10_resolution_id` doit exister dans la définition
  A6 embarquée : la clé `a10_resolution_id` existe dans `definition.resolutions`
  et figure dans `resolution_ids` du choix A3 nommé par `a10_choice_id`.
- Deux résolutions authored distinctes ne peuvent pas revendiquer le même
  `a10_resolution_id` dans la version 1.
- Une résolution authored locale sans effet durable peut conserver
  `a10_resolution_id = null`.
- Aucun mapping implicite ni valeur par défaut n'est accepté.

L'exécuteur futur conserve `resolution_id` dans son record d'exécution et dans
sa provenance. S'il demande un commit, il appelle A10 avec
`a10_choice_id` et `a10_resolution_id`.

## 4. Enveloppe `sequence_resolution`

La future enveloppe fermée `sequence_resolution` contient au minimum :

- `instance_id` ;
- `sequence_id` ;
- `authored_version` ;
- `choice_id` ;
- `resolution_id` ;
- `a10_choice_id` ;
- `a10_resolution_id` ;
- `terminal_checkpoint_id` ;
- `event_keys`.

Les reducers relisent la définition authored exacte avec `resolution_id`. La
frontière A10/A3 reçoit les deux identifiants A10,
`a10_choice_id` et `a10_resolution_id`. Le flux reste celui des sept opérations
A10 existantes ; aucune huitième opération, écriture latérale ou façade de
résolution générale n'est créée.

## 5. Exception pré-production du schéma v1

`AuthoredSequenceV1` conserve :

- `schema_id = reseau_intime.authored_sequence` ;
- `schema_version = 1`.

L'ajout fermé et obligatoire du champ nullable `a10_resolution_id` est une
exception explicitement autorisée avant production : aucun contenu de
production ni aucune sauvegarde réelle n'utilise encore ce schéma. Cette
exception ne constitue pas un précédent pour modifier silencieusement un
format persisté ou publié.

## 6. Fixture N12 de contrat

La fixture N12 minimale reste synthétique, non canonique et test-only. Elle
matérialise `sequence_entered` dans `checkpoint_before` du premier beat et lie :

| Résolution authored | `a10_resolution_id` |
|---|---|
| `resolution_start` | `null` |
| `resolution_complete` | `a3_resolution_continue` |
| `resolution_stop` | `a3_resolution_stop` |

Les deux résolutions A3 de cette fixture restent `LOCALE` et
`NON_PERSISTANTE`, sans fait relationnel. La fixture prouve le contrat de
liaison ; elle n'est pas la fixture d'intégration durable de N13.

## 7. Nouvelle entrée de N13

N13 crée une fixture d'intégration séparée au chemin recommandé :

`game/tests/fixtures/unified_runtime/n13_a10_durable_integration_valid.json`.

Cette future fixture doit :

- respecter `AuthoredSequenceV1` et déclarer `sequence_entered` ;
- aligner explicitement chaque issue authored et sa résolution A10 avec
  `a10_resolution_id` ;
- utiliser une résolution A3 de portée `DURABLE` ;
- produire uniquement un fait relationnel qualitatif déjà pris en charge par
  A1/A3/A5 ;
- ne produire ni obligation, ni promesse, ni connaissance, ni trace narrative,
  ni livraison média durable ;
- traverser opérationnellement les sept types de beats ;
- rester synthétique, non canonique et test-only.

A1 possédant six relations fixes, la fixture peut employer un identifiant de
personnage existant comme cible strictement technique du reducer. Sa provenance
test doit déclarer explicitement que cet emploi n'est pas du contenu canonique,
ne démarre aucune route, ne migre aucune scène et ne représente pas Mathilde
M-B3.

N13 implémente seulement l'exécuteur minimal et son snapshot autour de ce fait
relationnel durable existant. N13 ne modifie ni A1 ni A5 et reste arrêté dans la
présente branche.

## 8. Extensions reportées et découpage

Le support durable des obligations, promesses, connaissances, traces
narratives, livraisons média et états d'aftercare `DUE|PAID|FAILED` est reporté.

| Lot | Portée |
|---|---|
| N13 | Exécuteur minimal et snapshot avec un fait relationnel durable déjà supporté. |
| N14 | Reducers métier cibles et codec A5 étendu et versionné. Lot à risque élevé sur l'état narratif, les formats et la persistance. |
| N15 | Projections Messages et beat physique. |
| N16 | Cycle média, Galerie et PhotoViewer. |
| N17 | Tranche Mathilde M-B3. |

Cet ordonnancement remplace l'ancienne entrée N13 qui supposait l'extension
simultanée des reducers A1 et du codec A5.

## 9. Décision de sortie

N12.1 livre uniquement le contrat explicite et ses preuves de validation. Il ne
reprend pas N13. Jusqu'à revue produit de ce document et intégration du lot :

`N13_REMAINS_STOPPED`.
