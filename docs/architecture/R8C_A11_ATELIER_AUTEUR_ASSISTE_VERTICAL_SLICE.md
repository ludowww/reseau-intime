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
- une approbation portant l’identité, la révision et l’empreinte complète du
  brouillon ;
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

## Prototype Sandra exact

Le plan `a11_sandra_last_lunch_detail` produit un brouillon de 50 bulles avec
Sandra, Marie et Player. Sandra ressort une photo banale de la table du dernier
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

Les deux branches convergent au message `m35`, quand Marie refuse simplement de
retourner au restaurant. La fin revient au pain à acheter. Aucune déclaration,
séduction immédiate, conséquence majeure ou route verrouillée n’est produite.
Le brouillon contient trois rafales identifiées et cinq messages `WEAK`. La voix
de Sandra reste nostalgique et protectrice ; celle de Marie est pratique,
familière et domestique.

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

La gate finale ajoute la validation JSON du jeu, la simulation existante, la
suite Python globale et le démarrage Godot headless standard. Les smokes Portrait
et la résolution 1280×720 restent hors périmètre puisque aucun fichier joueur,
UI ou runtime Saison 1 n’est modifié.

