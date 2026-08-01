# R1 — Réconciliation de l’état canonique et de production

## Statut

```text
Catégorie : rapport documentaire historique
Statut : réconciliation bornée de portails
Périmètre : état affiché sur la baseline officielle
Base : fa2880c1ad168569b148ed85bedf4774324f87dd
Tag : runtime-s1-11e-j11-a5-scene-presentation
Autorité : aucune nouvelle autorité produit ou runtime
```

Ce rapport explique la synchronisation des portails. Les sources signées et le
runtime de la baseline restent les autorités de fond.

## Documents inspectés

- portails : `README.md`, `ROADMAP.md`, `docs/PROJECT_STATE.md`,
  `docs/CURRENT_NARRATIVE_SOURCE_OF_TRUTH.md` ;
- gouvernance et ordre : `docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md`,
  `docs/canon/DOCUMENTATION_READING_ORDER.md` ;
- index actifs : `docs/canon/NARRATIVE_CANON_STATUS.md`, les README de
  `docs/canon/bible/`, `docs/canon/dialogues/`, `docs/canon/ui/`,
  `docs/runtime/` et `game/data/` ;
- ancien contrat :
  `docs/runtime/SEASON_1_J01_J04_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md` ;
- autorités narratives : scripts J09–J12, registres TRACE, PROMISE, KNOWLEDGE,
  REACHABILITY, contrat d’état et sign-off J01–J21 ;
- autorités d’exécution : orchestrateur, providers, maps runtime et tests Saison 1 ;
- pipeline visuel : `VisualMediaResolver`, ImageMessage, Galerie, PhotoViewer et
  tests J11 A5.

## Contradictions corrigées

- anciennes baselines et ancien tag J01–J04 remplacés dans les portails actifs ;
- J01–J04, J01–J06 ou J05 comme état/priorité courants remplacés par la présence
  runtime J01–J21 sur la baseline ;
- J09–J12 distingués comme disposant de providers, données et tests dédiés ;
- J11 A5 identifié comme dernier jalon produit explicitement verrouillé ;
- ancien contrat J01–J04 et portails V0.xx trompeurs classés historiques au lieu
  d’être réécrits rétroactivement ;
- lecture active réorientée vers le runtime et les autorités de la baseline ;
- état des assets J11 A5 rendu explicite.

## Documents modifiés

```text
README.md
ROADMAP.md
docs/PROJECT_STATE.md
docs/CURRENT_NARRATIVE_SOURCE_OF_TRUTH.md
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/NARRATIVE_CANON_STATUS.md
docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md
docs/canon/bible/README.md
docs/canon/dialogues/README.md
docs/canon/ui/README.md
docs/runtime/README.md
docs/runtime/SEASON_1_J01_J04_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md
game/data/README.md
docs/R1_CANON_PRODUCTION_STATE_RECONCILIATION_REPORT.md
```

Les corrections sont limitées aux résumés d’état, à la navigation et au classement
historique. Aucun contenu canonique ou exécutable n’est modifié.

## Sources faisant autorité

```text
Canon signé : docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md
Scripts : docs/canon/dialogues/J09_SCRIPT_NARRATIF_COMPLET.md à J12_...md
État : registres J01_J21_* + docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md
Runtime : game/scripts/runtime/season_1/ + game/data/runtime/season_1/ + tests/
Portail runtime : docs/runtime/README.md
Gouvernance : docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md
```

## État réconcilié

- canon : Saison 1 J01–J21 signée ;
- runtime : J01–J21 présents dans l’orchestrateur sur la baseline ;
- tests : tests dédiés disponibles, notamment pour J09–J12 et J11 A5, sans
  affirmation que toute la gate globale est verte ;
- assets : architecture visuelle opérationnelle avec résolveur commun et
  `ResourceLoader` ; placeholders et prototypes non assimilés à une livraison ;
- J11 A5 : deux parents Galerie, six enfants de séquence, aucun des six assets
  finaux n’est livré, fallback attendu **« Visuel non livré »**.

## NAR-PROD-05 J10→J12

`NAR_PROD_05_AMENDEMENT_COHERENCE_J10_J12.md` conserve le statut historique
« candidat » de sa rédaction. Aucune validation produit formelle absente n’est
inventée. Ses décisions applicables ont ensuite été absorbées ou confirmées par les
scripts signés J10–J12, les registres narratifs, le contrat d’état Saison 1, le
runtime et les tests présents. Ces sources plus récentes priment ; l’amendement
n’est plus une source bloquante autonome.

Le fichier `RUNTIME-S1-11A_J11_READINESS_REPORT.md` cité par l’amendement n’existe
pas sur la baseline.

## Éléments conservés sans correction

- scripts signés, registres, contrat d’état, dialogues et sign-off ;
- code, données, tests, outils, scènes et assets ;
- texte historique de NAR-PROD-05 ; corps historique de l’ancien contrat J01–J04
  conservé, avec statut et encadrement documentaire actualisés ;
- documents V0.xx, anciens plans J01–J09 et outils historiquement bornés ;
- les 32 identités d’échec historiques connues, à comparer par identité exacte.

Ces éléments ne sont pas présentés comme des régressions de R1.

## Validations du lot

```text
git diff --check : PASS
python tools/validate_game_data.py : PASS, 161 JSON, 8 warnings historiques
python tools/simulate_route_paths.py : PASS, 6/6 chemins
python -m unittest discover -s tests -p 'test_*.py' -v :
  518 tests, 28 FAIL + 4 ERROR
  mêmes 32 identités historiques que la baseline, aucune identité nouvelle
Godot : non lancé, conformément au périmètre documentaire
```

## Travaux futurs hors périmètre

Un lot ultérieur peut préparer puis livrer les six assets enfants J11 A5 en
conservant les deux parents Galerie, l’ordre des triplets et le pipeline visuel
commun. Il ne doit pas être élargi à un manifeste Acte III complet.
