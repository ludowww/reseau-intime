# R8C-A6 — Brief de bibliothèque narrative minimale

> **Statut :** `BRIEF_ONLY_RECOMMENDATIONS_AWAITING_PRODUCT_APPROVAL`
> **Dépendance :** R8C-A5 verrouillé au SHA `bf443e35edd563d87270ba8980736642794b9985`
> **Objet :** préparer la bibliothèque de définitions et la requête de scènes compatibles, sans modifier le runtime.

## Résultat attendu du futur lot

A6 doit fournir un catalogue minimal, validé et déterministe de définitions A3,
puis une requête en lecture seule qui explique quelles scènes sont compatibles
avec un état A1, un contexte narratif et le registre A5 courants. La bibliothèque
ne choisit, ne propose, ne résout et ne planifie aucune scène.

Le futur lot réutilise sans les dupliquer :

- `SceneDefinition` pour valider chaque définition ;
- `MinimalSceneEngine.evaluer_definition` pour l'éligibilité et ses diagnostics ;
- le registre A5 du moteur pour l'unicité durable et les opportunités existantes ;
- `EtatNarratif` comme état de lecture, sans mutation pendant une requête.

## Périmètre minimal

1. Charger un petit bundle JSON versionné depuis un chemin explicite sous
   `res://data/narrative_scenes/`, puis construire atomiquement la bibliothèque.
2. Indexer chaque entrée par `scene_id` et conserver `version_contrat`.
3. Refuser une définition invalide, un identifiant dupliqué ou une version
   ambiguë sans bibliothèque partiellement utilisable.
4. Obtenir une définition par identifiant sous forme de copie défensive.
5. Requêter toutes les définitions compatibles avec un contexte donné.
6. Retourner les candidats éligibles dans un ordre stable. Les diagnostics de
   refus complets restent accessibles seulement aux outils de développement et
   aux tests, jamais à un modèle ou une surface joueur.
7. Garantir qu'une requête ne crée aucune instance, opportunité, transition,
   trace, transaction A1 ou mutation du registre A5.

Un bundle de trois à cinq définitions synthétiques suffit pour développer le
contrat. Aucun contenu narratif de production ni migration des 88 JSON actuels
n'est demandé. `DataLoader` reste un lecteur générique : la bibliothèque A6
porte seule la validation fermée de la racine et des définitions.

Dans les résultats A6, `scene_definition_id` est le nom explicite de la valeur
issue de `definition["scene_id"]`, déjà persistée sous ce nom par A5. Ce renommage
de projection ne change pas le contrat A3.

## API candidates

Noms provisoires à confirmer pendant l'implémentation :

```gdscript
R8CSceneDefinitionLibrary.charger_depuis_json(path: String) -> Dictionary
# {ok, erreur, bibliotheque}

bibliotheque.obtenir_definition(scene_id: String) -> Dictionary
bibliotheque.obtenir_ids_tries() -> Array[String]

bibliotheque.requerir_compatibles(
    moteur,
    etat_narratif,
    contexte: Dictionary
) -> Dictionary
# {ok, erreur, candidats: [{scene_definition_id, definition_version,
#  variant_id, diagnostic}]}

bibliotheque.requerir_compatibles_dev(
    moteur,
    etat_narratif,
    contexte: Dictionary
) -> Dictionary
# Même résultat, avec diagnostics_refuses; réservé aux builds de développement
# et aux tests.
```

`requerir_compatibles` appelle le moteur A3 pour chaque définition. Elle ne doit
pas réimplémenter les fenêtres, participants, événements requis/interdits,
revalidation, politiques `UNIQUE`/`REPETABLE` ou validité d'opportunité. Un tri
par le tuple structuré `(scene_definition_id, variant_id)` rend le résultat
indépendant de l'ordre de chargement. Ces champs restent distincts : aucune
concaténation de chaînes ne fabrique une identité.

## Invariants proposés

- Une bibliothèque construite est immuable depuis l'extérieur.
- Un `scene_definition_id` désigne exactement une définition et une version de
  contrat; un éventuel `variant_id` est stable, explicite et séparé.
- Toute erreur de construction ferme la bibliothèque entière.
- Deux requêtes sur les mêmes entrées donnent le même ordre et les mêmes
  diagnostics.
- Une scène `UNIQUE` déjà connue du registre A5 n'est pas candidate.
- Une scène `REPETABLE` peut redevenir candidate si toutes ses conditions A3
  sont satisfaites.
- La requête ne transforme jamais un diagnostic en score, poids ou préférence.
- Aucun chargement legacy ou tolérance partielle de définition n'est ajouté.
- Une requête ne crée aucun `instance_id`. Le candidat reste une valeur de
  lecture jusqu'à une réservation/proposition réelle par un consommateur futur.

## Critères de test du futur lot

- bibliothèque valide construite et index trié de façon déterministe ;
- copie défensive à la lecture ;
- `scene_id` dupliqué refusé atomiquement ;
- définition A3 invalide refusée atomiquement ;
- contexte compatible retourne le candidat et son diagnostic A3 ;
- acte, fenêtre, participant, événement requis/interdit et opportunité invalide
  produisent les refus A3 attendus ;
- `UNIQUE` exclue après round-trip A5 ;
- `REPETABLE` reste requêtable après round-trip A5 ;
- ordre identique pour deux collections sources permutées ;
- état A1, registre A5 et instances strictement inchangés après requête ;
- absence de `route_points`, scores, accumulateurs, hasard ou classement caché ;
- tests A1/A3/A5 et smokes UX canoniques toujours verts ;
- 88 JSON toujours valides si aucune nouvelle donnée n'est introduite.

## Hors périmètre

- sélection automatique d'une scène parmi les candidats ;
- pondération, score, priorité implicite, personnalisation psychologique ou
  apprentissage ;
- hasard, seed, cooldown, quota ou économie d'opportunités ;
- planificateur ou constructeur de journée ;
- création automatique d'instances ou passage à `PROPOSED` ;
- résolution, effets, transactions, autosave ou migration de snapshots ;
- éditeur d'auteur, hot reload, localisation ou validation éditoriale massive ;
- bibliothèque narrative définitive et contenu Saison 1 ;
- branchement à `PortraitMain` ou remplacement du runtime canonique.

## Recommandations produit en attente d'approbation

Le document complémentaire
[`R8C_A6_DECISIONS_PRODUIT_ET_AUDIT_PREPARATOIRE.md`](R8C_A6_DECISIONS_PRODUIT_ET_AUDIT_PREPARATOIRE.md)
recommande :

1. une source data-first JSON strictement validée sous `res://data/` ;
2. les diagnostics refusés complets seulement en développement et dans les tests ;
3. un `variant_id` stable et explicite, distinct de `scene_definition_id` ;
4. la création d'une instance A5 seulement lors d'une réservation/proposition
   réelle, jamais pendant la recherche de compatibilité.

Ces recommandations restent soumises à validation produit explicite. Aucune
implémentation A6, connexion joueur ou évolution de snapshot A5 ne doit commencer
avant cette approbation.
