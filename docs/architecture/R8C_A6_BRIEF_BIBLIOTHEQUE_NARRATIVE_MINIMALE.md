# R8C-A6 — Brief de bibliothèque narrative minimale

> **Statut :** `BRIEF_ONLY_NOT_IMPLEMENTED`
> **Dépendance :** R8C-A5 au SHA `3aff9549134e79761ec4510c4176f394d87e27d1`
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

1. Construire atomiquement une bibliothèque depuis une petite collection de
   définitions explicites et non définitives.
2. Indexer chaque entrée par `scene_id` et conserver `version_contrat`.
3. Refuser une définition invalide, un identifiant dupliqué ou une version
   ambiguë sans bibliothèque partiellement utilisable.
4. Obtenir une définition par identifiant sous forme de copie défensive.
5. Requêter toutes les définitions compatibles avec un contexte donné.
6. Retourner, dans un ordre stable, les candidats éligibles et les diagnostics
   de refus utiles à l'auteur ou aux tests.
7. Garantir qu'une requête ne crée aucune instance, opportunité, transition,
   trace, transaction A1 ou mutation du registre A5.

Une collection de trois à cinq fixtures synthétiques suffit pour développer le
contrat. Aucun contenu narratif de production n'est demandé.

## API candidates

Noms provisoires à confirmer pendant l'implémentation :

```gdscript
R8CSceneDefinitionLibrary.creer(definitions: Array) -> Dictionary
# {ok, erreur, bibliotheque}

bibliotheque.obtenir_definition(scene_id: String) -> Dictionary
bibliotheque.obtenir_ids_tries() -> Array[String]

bibliotheque.requerir_compatibles(
    moteur,
    etat_narratif,
    contexte: Dictionary
) -> Dictionary
# {ok, erreur, candidats: [{scene_id, definition_version, diagnostic}],
#  diagnostics_refuses: [{scene_id, diagnostic}]}
```

`requerir_compatibles` appelle le moteur A3 pour chaque définition. Elle ne doit
pas réimplémenter les fenêtres, participants, événements requis/interdits,
revalidation, politiques `UNIQUE`/`REPETABLE` ou validité d'opportunité. Un tri
par `scene_id`, éventuellement suivi d'un identifiant de variante explicitement
déclaré, rend le résultat indépendant de l'ordre de chargement.

## Invariants proposés

- Une bibliothèque construite est immuable depuis l'extérieur.
- Un `scene_id` désigne exactement une définition et une version de contrat.
- Toute erreur de construction ferme la bibliothèque entière.
- Deux requêtes sur les mêmes entrées donnent le même ordre et les mêmes
  diagnostics.
- Une scène `UNIQUE` déjà connue du registre A5 n'est pas candidate.
- Une scène `REPETABLE` peut redevenir candidate si toutes ses conditions A3
  sont satisfaites.
- La requête ne transforme jamais un diagnostic en score, poids ou préférence.
- Aucun chargement legacy ou tolérance partielle de définition n'est ajouté.

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

## Décisions produit à revoir avant implémentation

1. Source initiale : tableau injecté par le test ou petit fichier JSON dédié.
2. Visibilité des diagnostics refusés en production : disponibles au moteur,
   journalisés en développement, ou réservés aux outils d'auteur.
3. Identité des variantes : `scene_id` distinct ou champ explicite futur.
4. Moment exact où un consommateur transforme un candidat en instance A5.

Ces choix ne bloquent pas le contrat minimal, mais doivent être tranchés avant
tout branchement au parcours joueur.
