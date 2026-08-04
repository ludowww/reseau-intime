# R8C-A5 — Persistance minimale des scènes et opportunités

> **Statut :** `ACTIVE_CANON_IMPLEMENTATION`
> **Baseline :** R8C-A4 au SHA `941d1489f5f177bbc2ac00b602c9922349dbab1b`
> **Format :** snapshot R8C-A5 version `1`, current-only

## Objet

A5 rend reconstructibles l'état narratif A1 et le registre d'instances A3 dans
une même enveloppe de snapshot. `MinimalSceneEngine` reste l'unique point
d'orchestration; `PersistentSceneRegistry` remplace ses anciens dictionnaires
mémoire et ne constitue pas un second moteur. Le runtime portrait Saison 1 et
ses snapshots v21/v25 restent inchangés et séparés jusqu'au cutover explicite.

## Schéma

L'enveloppe contient exactement :

```text
version: 1
narrative_state: snapshot EtatNarratif A1
scene_registry: liste d'instances triée par instance_id
```

Chaque instance persistée contient exactement :

| Champ | Rôle |
| --- | --- |
| `instance_id` | Identifiant opaque et durable de l'occurrence. |
| `scene_definition_id` | Identifiant de la définition A3 (`scene_id` en mémoire). |
| `definition_version` | Version du contrat de définition à revalider au prochain usage. |
| `uniqueness_policy` | `UNIQUE` ou `REPETABLE`. |
| `state` | `INELIGIBLE`, `ELIGIBLE`, `PROPOSED`, `RESOLVED`, `MISSED` ou `CANCELLED`. |
| `created_at`, `last_transition_at` | Date/heure narrative de création et de dernière transition. |
| `operation` | `RESOLUTION`, `MANQUEE`, `ANNULATION`, ou chaîne vide pour une instance active. |
| `choice_id`, `resolution_id` | Choix et résolution terminaux, ou chaînes vides. |
| `transaction_id` | Identifiant transactionnel terminal, ou chaîne vide. |
| `temporary_traces` | Traces bornées d'une instance encore active seulement. |

`PROPOSED` est la preuve autoritative qu'une opportunité a réellement été
présentée; `MISSED` prouve qu'une proposition visible a expiré. Aucun booléen ou
registre d'opportunités parallèle ne duplique ces états.

## Invariants

- `instance_id` est unique dans le registre.
- Une définition `UNIQUE` ne possède qu'une occurrence durable, y compris après
  rechargement; une définition `REPETABLE` reste instanciable.
- Une terminaison conserve son `transaction_id`. Une reprise identique est
  idempotente; une résolution différente est refusée.
- Les effets `LOCAL`/`LOCALE`, signaux reçus et interprétations locales ne sont
  jamais sérialisés. Seuls les identifiants nécessaires à la reprise de la
  terminaison sont conservés.
- Une trace `TEMPORAIRE` n'est sérialisée que pour une instance `PROPOSED` qui
  doit reprendre. Sa forme fermée contient identité, portée `TEMPORAIRE`, contenu
  minimal, instance et résolution sources, et instant de création; le registre
  refuse plus de 16 traces par instance. Aucun point d'écriture générique ne
  permet d'y injecter un effet `LOCAL`.
  Toute transition vers `RESOLVED`, `MISSED` ou `CANCELLED` nettoie les traces.
- Les effets `DURABLE` restent des événements A1 sourcés; le registre ne les
  recopie pas.
- Une provenance A1 générique contient seulement `type` et `id`. Une provenance
  de scène possède une forme fermée de résolution ou d'occasion manquée, un
  identifiant transactionnel déterministe et une instance terminale A5
  correspondante. Un événement générique ne peut donc pas usurper l'unicité
  d'une scène, et un événement de scène orphelin invalide le snapshot entier.
- L'enveloppe et chaque instance ont une forme fermée. Tout champ, type, statut,
  doublon ou invariant inattendu invalide le snapshot entier.
- Les instants suivent exactement `YYYY-MM-DDTHH:MM:SS±HH:MM`; une instance et
  ses traces gardent le même offset, et aucun instant ne peut remonter le temps.

## Cycle sauvegarde / chargement

1. `MinimalSceneEngine.obtenir_snapshot(etat_narratif)` capture une copie A1 et
   la projection minimale, triée, du registre courant.
2. `creer_depuis_snapshot` valide d'abord l'enveloppe et sa version exacte.
3. Le codec current-only `A5NarrativeStateCodec` ferme et borne la projection
   A1 avant qu'un `EtatNarratif` candidat soit reconstruit; A1 reste indépendant
   de la version de persistance A5.
4. Un registre candidat reconstruit toutes les instances et les contraintes
   d'unicité.
5. Une fabrique retourne un nouveau couple moteur/état seulement après succès
   des deux candidats; aucun objet vivant fourni par l'appelant n'est muté.

Une version ancienne, une racine A1 inconnue ou un registre corrompu est donc
refusé sans chargement partiel ni risque de désynchronisation moteur/état. Aucune migration de
snapshot de développement n'est fournie.

## Limites et hors périmètre

A5 fournit un format `Dictionary` reconstructible, pas encore une écriture sur
disque, un autosave ou un menu de sauvegarde. Sont également exclus : migration
legacy, bibliothèque narrative, requête de scènes compatibles, constructeur ou
planificateur de journée, contenu narratif définitif, modification de
`PortraitMain` et remplacement du runtime Saison 1. Une instance `PROPOSED`
offre seulement l'opération bornée `declarer_reprise_temporaire`, destinée au
futur orchestrateur de séquence; la création et l'orchestration de ces séquences
relèvent d'un lot ultérieur.

## Validation ciblée

```bash
python -m unittest tests.test_r8c_a1_narrative_state_static tests.test_r8c_a3_minimal_scene_prototype_static tests.test_r8c_a5_persistent_scene_registry_static -v
godot --headless --path game res://tests/R8CANarrativeStateSmokeTest.tscn
godot --headless --path game res://tests/R8CAMinimalScenePrototypeSmokeTest.tscn
godot --headless --path game res://tests/R8CAPersistentSceneRegistrySmokeTest.tscn
```
