# R8C-A11.1 — Vertical slice d’atelier auteur assisté

> **Statut :** `IMPLEMENTED_PROTOTYPE_NON_CANONIQUE`
> **Base :** `f5d9723ee3e95f3c4f34288c600bd036bad59840`
> **Contenu :** fixtures synthétiques A11 et export A6 explicite uniquement.

## Responsabilité

A11 est un outil auteur hors ligne :

`plan humain → contexte déterministe → brouillon structuré → validation → approbation humaine → export A6`

Il ne génère aucun texte, ne connaît aucun fournisseur de génération et ne
s’exécute pas dans le jeu. Il ne lit ni n’écrit A1, A3, A5, A7, A8, A9 ou A10.
Sa seule sortie d’intégration est un bundle A6 synthétique conforme au contrat
existant. A6 reste responsable de valider sa définition A3.

## Architecture minimale

[`tools/a11_authoring_workshop.py`](../../tools/a11_authoring_workshop.py)
regroupe volontairement le petit pipeline pur :

- cinq validateurs de documents JSON fermés et current-only ;
- une factory atomique qui ne rend aucun workspace partiel ;
- une compilation de contexte texte canonique, triée et reproductible ;
- une validation éditoriale séparant erreurs bloquantes et avertissements ;
- une approbation portant l’identité, la révision et une empreinte composite
  des personnages, relations, plan, brouillon et version du validateur ;
- une projection A6 refusée si cette approbation ne correspond pas exactement.

Il n’existe ni registre global, ni cache, ni nouvel état sérialisé. Les données
A11 sont confinées à [`narrative_tool/a11/fixtures/`](../../narrative_tool/a11/fixtures/).

## Cinq formats JSON

Tous portent `version: 1`, refusent les champs inconnus à chaque niveau et sont
validés avant les références croisées.

| Format | Rôle |
| --- | --- |
| `R8C_A11_CHARACTER_SHEET` | voix compacte et faits explicitement connus/inconnus |
| `R8C_A11_RELATIONSHIP_REGISTER` | relations Sandra–Player, Marie–Player et Sandra–Marie |
| `R8C_A11_SCENE_PLAN` | intention humaine, beats, choix, média, limites et projection A6 |
| `R8C_A11_DIALOGUE_DRAFT` | bulles structurées, rafales, messages faibles et réceptions locales |
| `R8C_A11_VALIDATION_REPORT` | erreurs, avertissements et approbation de la révision exacte |

Le contexte compilé est un texte éphémère, pas un sixième format persistant.

## A11.1 minimal contract

Les schémas restent volontairement étroits. Le tableau donne le contrat exact,
les omissions assumées, leur raison et l’invariant protégé.

| Format | Inclus | Délibérément absent | Pourquoi | Invariant protégé |
| --- | --- | --- | --- | --- |
| fiche personnage | `format`, `version`, `character_id`, `display_name`, `role`, `voice`, `known_facts`, `unknown_facts` | biographie exhaustive, état runtime, valeurs relationnelles chiffrées | le prototype a seulement besoin de distinguer la parole et l’accès aux faits | aucune omniscience et aucune évaluation agrégée de la voix |
| registre relationnel | `format`, `version`, `relations` ; chaque relation porte identité, paire, nature, faits partagés et limites | historique canonique, progression persistante, conséquences | A11 contextualise sans écrire l’état du jeu | les trois relations sont disponibles sans accès à A1/A3/A5/A7/A8/A9/A10 |
| plan de scène | identité/titre, `participant_ids`, `premise`, `shared_detail`, `required_beats`, `choice`, `media_requirement`, `limits`, `a6_projection` | graphe de routes, configuration de génération, sélection automatique | le plan humain demeure l’unique intention source | aucune route verrouillée et aucune dépendance à un fournisseur |
| brouillon de dialogue | identité/révision/plan, `messages` avec locuteur, type, texte, faits, beat, micro-branche, rafale, force et média, puis `choice` | temporisation runtime, état de lecture, effets persistants | A11 prépare une matière éditoriale, pas une conversation jouable | seuls les participants du plan parlent et toute référence factuelle est contrôlée |
| rapport de validation | identité/révision, `approval_fingerprint`, `status`, `blocking_errors`, `warnings`, `human_approval` | horodatage, historique d’approbations, métriques et décision automatique | une seule preuve révisable suffit au slice hors ligne | tout changement éditorial ou de validateur révoque l’export |

L’empreinte d’approbation est le SHA-256 canonique des trois fiches personnage
triées par identité, du registre relationnel, du plan, du brouillon et de
`a11-validator-1.1`. Le rapport n’entre pas dans sa propre empreinte. Une
modification de l’un de ces éléments exige donc une nouvelle validation et une
nouvelle approbation humaine.

## Prototype Sandra exact

Le plan `a11_sandra_last_lunch_detail` produit un brouillon de 50 bulles avec
Sandra et Player comme seuls participants visibles. Sandra ressort une photo
banale de la table du dernier
déjeuner. Le détail concret est la petite fêlure en étoile de son verre, près de
frites froides dont Player avait défendu la « cuisson lente ». Player écrit que
l’après-déjeuner était « plus calme », puis « un peu trop peut-être ». Sandra
prend d’abord l’allusion pour une élégie comique aux frites.

Après une clarification douce, le choix expose deux SMS :

- `careful_warmth`, attitude `chaleur prudente` : « Je plaisante pas
  complètement. J’aimais bien ce moment-là. » ; Sandra reçoit localement
  `intriguée_touchée` ;
- `ironic_withdrawal`, attitude `retrait ironique` : « Oublie, c’était mon
  hommage aux frites molles. » ; Sandra reçoit localement
  `défensive_embarrassée`.

Les deux branches convergent au message `m35`, quand Sandra refuse simplement de
retourner au restaurant. La fin revient à une question banale sur les horaires
du café voisin. Aucune déclaration,
séduction immédiate, conséquence majeure ou route verrouillée n’est produite.
Le brouillon contient trois rafales identifiées et cinq messages `WEAK`. La voix
de Sandra reste nostalgique et protectrice. Marie ne parle pas, n’intervient pas
dans le choix ou la convergence et n’est pas exportée vers A6 ; sa fiche et ses
relations restent présentes dans le contexte comme calibration qualitative.

La preuve de voix emploie deux corpus anonymes. Celui de Sandra s’ancre dans la
photo du déjeuner, le verre fêlé et les frites froides ; celui de Marie dans le
pain, le café et le sac de courses. Chaque corpus satisfait les garde-fous de sa
fiche et échoue sur les ancrages de l’autre. Des exemples interdits démontrent
également la détection d’une déclaration frontale pour Sandra et d’une reprise
des motifs de Sandra par Marie. Cette preuve est qualitative : elle ne calcule
ni note, ni classement, ni priorité.

La fixture invalide fait employer à Sandra `marie_private_concern`, fait marqué
comme inconnu pour elle. Le rapport est donc `BLOCKED` et l’export impossible.

## Mapping A11 vers A6

Le contrat A6/A3 ne possède aucun champ pour les bulles, le média éditorial, les
faits de contexte ou l’approbation. Ces éléments restent dans A11. La projection
est donc volontairement stricte :

| A11 | A6/A3 |
| --- | --- |
| `a6_projection.scene_definition_id` | `scene_definition_id` et `definition.scene_id` |
| `a6_projection.variant_id` | `variant_id` |
| participants du plan | `participants_requis` |
| fenêtre synthétique | `conditions_dures`, `exclusions_dures`, `contrat_temporel` |
| formulation de chaque option | `choix[].formulation` |
| signal de chaque option | `signal_emis` puis `signal_recu` |
| état local de Sandra | `resolutions[].interpretation` |
| convergence autorisée | `RETOUR_NOYAU_COMMUN` |
| absence de conséquence | portée `LOCALE`, réception `NON_PERSISTANTE`, aucun fait |

La fixture
[`r8c_a11_sandra_last_lunch_export.json`](../../game/data/narrative_scenes/r8c_a11_sandra_last_lunch_export.json)
est synthétique et non canonique. Aucun catalogue ne la découvre : le smoke la
charge uniquement via son chemin exact.

## Validation ciblée

```bash
python -m unittest tests.test_r8c_a11_authoring_workshop -v
python -m unittest tests.test_r8c_a3_minimal_scene_prototype_static tests.test_r8c_a6_minimal_narrative_library_static -v
python tools/a11_authoring_workshop.py smoke
godot --headless --path game res://tests/R8CA11AuthoringExportSmokeTest.tscn
git diff --check
```

La gate finale ajoute la validation JSON du jeu, la simulation existante et la
suite Python globale. Les smokes Portrait, le démarrage Godot standard et la
résolution 1280×720 restent hors périmètre puisque aucun chargeur Godot, fichier
joueur, UI ou runtime Saison 1 n’est modifié.
