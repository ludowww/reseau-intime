# R8C-A10 — Vertical slice d’orchestration et simplification API

> **Statut :** `IMPLEMENTED_PROTOTYPE_NON_CANONIQUE`
> **Base :** R8C-A9 verrouillé au SHA `1ea5a382d875940e09f0d82b3ba61897fd12b9af`
> **Contenu :** fixture synthétique A3 adaptée en mémoire; aucun contenu Saison 1.

## Responsabilité A10

`R8CNarrativeOrchestrationFacade` est une façade mince devant A1–A9. Elle
assemble une tranche technique complète et masque le graphe d’objets interne au
futur appelant runtime. Elle ne remplace aucune couche et ne devient la source
de vérité d’aucune règle narrative.

La tranche prend un seul conflit A8 par créneau A9. Ce conflit contient au
moins deux options authored concurrentes. Ce bornage suffit pour prouver le
parcours de bout en bout sans transformer A10 en constructeur de journée ou en
moteur de séquence. A9 conserve sa capacité propre à composer plusieurs
fenêtres pour ses callers spécialisés.

## Parcours complet

Le scénario synthétique suit cet ordre :

1. le test prépare un état A1 et charge deux définitions non canoniques dans A6;
2. `find_candidates` interroge A6 et rend uniquement les identités utiles;
3. `compose_slot` projette la requête unique vers une fenêtre A8, puis vers un
   créneau A9 à ordre auteur explicite;
4. `activate_option` revalide d’abord le plan A9, transmet l’option et la
   proposition explicites à A8, qui délègue la matérialisation à A7/A5, puis
   ferme le conflit selon les politiques A8 existantes;
5. `resolve_scene` retrouve l’instance A5 et sa définition A6 avant de déléguer
   la résolution, les six évaluations et la transaction A1 à A3;
6. `save_state` obtient le snapshot A5 current-only;
7. `restore_state` laisse A5 reconstruire atomiquement le moteur et A1, puis
   recâble les coordinateurs éphémères A7–A9;
8. la même résolution après recharge est reconnue comme idempotente par A3/A5.

La fermeture `CLOSE_SILENTLY` de l’alternative jamais proposée ne crée ni
instance A5, ni `MISSED`, ni conséquence A1. La politique
`MARK_MISSED_IF_PROPOSED` demeure entièrement celle d’A8 : elle ne produit
`MISSED` que pour une instance réellement `PROPOSED`; ses tests A8 restent la
preuve de cette frontière.

## Façade publique retenue

Le budget est exactement de sept opérations publiques, construction comprise :

| Opération | Rôle | Délégation autoritative |
| --- | --- | --- |
| `create(library, narrative_state)` | construit le moteur A3/A5 et câble A7–A9 | factories A7/A8/A9 |
| `find_candidates(context)` | rend les couples définition/variante éligibles | A6 puis six évaluations A3 |
| `compose_slot(slot_request)` | ouvre un conflit A8 et compose son créneau | A8 puis A9 |
| `activate_option(plan, option_id, action)` | revalide, propose et ferme le conflit | A9 puis A8/A7/A5 |
| `resolve_scene(instance_id, choice_id, resolution_id, context)` | résout une instance sans exposer définition ou moteur | A6/A5 puis A3/A1 |
| `save_state()` | rend le snapshot current-only existant | A5 |
| `restore_state(snapshot)` | restaure atomiquement et recâble les couches éphémères | A5 puis factories A7–A9 |

`action` contient l’intention A7 explicite `PROPOSE` et le contexte courant.
`RESERVE` est refusé avant toute mutation : fermer immédiatement une fenêtre
après réservation laisserait une instance `ELIGIBLE` sans chemin public de
proposition. A10 préfère donc une opération complète à une flexibilité en
cul-de-sac; A7 conserve sa capacité `RESERVE` pour ses callers spécialisés.

`slot_request` contient les bornes du créneau, son contexte et une unique
entrée `window`. Cette entrée réunit l’identité et les bornes A8, les contraintes
de placement A9 et les options authored A8. Chaque option référence directement
le petit descripteur `{scene_definition_id, variant_id}` rendu par
`find_candidates`; le caller complète seulement `option_id`, `instance_id` et
`conflict_policy`. La façade en produit les projections A8/A9 sans recopier leur
validation métier. L’ordre A9 vaut exactement `[window_id]`; aucune permutation
n’est possible ou recherchée.

## Ce qui reste interne

La surface runtime ne rend jamais :

- la preuve opaque `preuve_provenance` A6;
- une définition de scène autoritative;
- les diagnostics `*_dev` A6–A9;
- les objets moteur, état, registre ou coordinateurs;
- les candidats et caches privés A8;
- les diagnostics de signal ou de revalidation détaillés produits par A3.

Les plans A9 et résumés A8 restent leurs projections runtime déjà assainies.
L’empreinte A9 est conservée parce qu’elle est nécessaire à la revalidation,
pas comme diagnostic.

## Simplifications réalisées

- Le caller ne construit plus A3, A7, A8 et A9 ni leurs liens de dépendance.
- Le contexte stable A8 est dérivé une fois du contexte courant fourni; le
  caller ne duplique plus les trois mêmes champs.
- Les descripteurs trouvés par A6 alimentent directement les options du créneau;
  le caller ne reconstruit plus les identités définition/variante.
- La preuve A6 ne traverse plus la surface haut niveau : A8 relance A6 et
  vérifie sa provenance comme auparavant.
- La résolution exige seulement les trois identités d’action et le contexte de
  base; la façade injecte `instance_id`, puis retrouve l’instance A5 et la
  définition A6 en interne.
- Sauvegarde et restauration ne demandent plus au caller de maintenir le couple
  cohérent moteur A5/état A1 ni de recâbler A7–A9 après recharge.

Aucun type commun supplémentaire ni nouvelle hiérarchie n’a été créé. Les
helpers A10 sont des projections pures et bornées au transport entre contrats
existants.

## Budget de complexité

| Contrainte | Budget A10 |
| --- | --- |
| Opérations publiques | 7 exactement, factory incluse |
| Nouvelles classes | 1 façade |
| Fenêtres A8 par appel `compose_slot` | 1 |
| Nouvel état persistant | 0 |
| Nouvelle politique narrative | 0 |
| Nouveau format de snapshot | 0 |
| Appels internes requis par le scénario vertical | 0 après construction de la fixture et de l’état initial |

La façade conserve seulement l’identité éphémère d’une activation par empreinte
de plan. Elle compare le plan, l’option et l’action complets avant un rejeu, puis
reconstruit le résultat depuis le résumé A8 et l’instance A5 courante. Elle ne
mémorise aucun résultat métier : `activation_state` décrit l’activation A8
historique et `scene_state` l’état A5 courant. La quittance n’est ni sérialisée
ni autoritative; elle est effacée lors d’un `restore_state`. Une nouvelle
activation doit toujours passer par la revalidation A9 avant toute mutation.

Si A8 a créé une nouvelle fenêtre mais qu’A9 refuse ensuite la composition, la
façade demande à A8 d’abandonner cette fenêtre. Cette compensation technique est
strictement limitée à une fenêtre encore `OPEN`, dont toutes les options sont
`CANDIDATE` et sans instance A5. Une ouverture A8 idempotente préexistante n’est
jamais supprimée. Le refus reste ainsi sans consommation cachée de la capacité
A8 et sans mutation A1/A5.

La façade ne recopie pas :

- les six évaluations A3;
- le registre, le codec ou la cohérence croisée A5;
- le loader, le schéma ou la preuve A6;
- la revalidation et la matérialisation A7;
- les contrats, politiques et transitions A8;
- l’algorithme `earliest-fit`, le validateur ou l’empreinte A9;
- la transaction et les reducers A1.

## Responsabilités refusées à A10

A10 n’ajoute aucun score, seuil, poids, priorité numérique, classement, hasard,
sélection automatique ou préférence implicite. Il n’ajoute pas non plus :

- de constructeur de journée ou de calendrier multi-créneaux;
- de séquence narrative, graphe de scènes ou réordonnancement;
- de nouvelle politique de conflit, d’absence ou de conséquence;
- de rollback ou de snapshot A8/A9;
- de persistance disque ou migration;
- de branchement vers `PortraitMain`, le runtime Saison 1, ses conversations ou
  ses données;
- de contenu canonique.

Le rollback d’ouverture A8 est une compensation technique, pas une politique
narrative : il ne peut ni annuler une instance, ni fermer un conflit, ni produire
une absence ou une conséquence.

## Pipeline génératif futur

L’IA est d’abord un outil d’auteur. Elle peut produire des brouillons
structurés de scènes, variantes, choix et résolutions. Ces brouillons doivent
être relus, validés contre le ton et les limites des personnages, contrôlés par
les outils de qualité éditoriale, puis intégrés explicitement à un bundle A6.
A6 et les couches suivantes ne consomment donc que du contenu structuré déjà
validé.

La génération de dialogues ou d’histoires au runtime, la modification dynamique
du ton des personnages et l’injection directe d’une sortie de modèle dans A6
restent hors périmètre. Elles nécessiteraient leurs propres contrats de sûreté,
de continuité, de validation humaine et de reproductibilité.

## Validation ciblée

```bash
python -m unittest tests.test_r8c_a1_narrative_state_static tests.test_r8c_a3_minimal_scene_prototype_static tests.test_r8c_a5_persistent_scene_registry_static tests.test_r8c_a6_minimal_narrative_library_static tests.test_r8c_a7_candidate_reservation_proposal_static tests.test_r8c_a8_opportunity_windows_exclusive_conflicts_static tests.test_r8c_a9_controlled_narrative_slot_composition_static tests.test_r8c_a10_vertical_slice_orchestration_static -v
godot --headless --path game res://tests/R8CAVerticalSliceOrchestrationSmokeTest.tscn
```

Le smoke A8 reste inclus dans les régressions ciblées lorsque la politique
`MARK_MISSED_IF_PROPOSED` doit être rejouée intégralement.
