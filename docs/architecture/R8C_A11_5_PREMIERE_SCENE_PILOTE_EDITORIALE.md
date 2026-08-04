# R8C-A11.5 — Première scène pilote éditoriale

## Résultat

La scène verrouillée **Sandra — Les chaises bleues** est intégrée comme premier pilote du pipeline A11, avec le statut `APPROVED_FOR_CANON_REVIEW`.

Ce statut autorise uniquement une future revue canonique. Il ne vaut ni intégration au canon, ni export A6, ni branchement au runtime.

- Baseline obligatoire : `93d8bbf6095ceaaaffc281b8d42048e1389ba5d3`
- Tag de baseline : `r8c-a11-4-plan-draft-a6-test-export`
- Branche dédiée : `work/r8c-a11-5-first-editorial-scene-pilot`
- Empreinte du contenu source : `9167120abc55dbf4275ac67eb7b4f774a58322587d87c9310644e3bcf85982dd`
- Empreinte de validation : `88d863416f78b03ce9faa187745005dbb763a4680bd5486ea3bd4d469a7909a7`

## Périmètre

Le lot ajoute des données et contrôles purement éditoriaux sous `narrative_tool/a11`, la documentation et les tests associés. Aucun fichier de `game/` n'est modifié.

Le texte fourni est conservé strictement : aucun message n'est ajouté, supprimé ou reformulé. Les choix restent courts, leurs réceptions restent distinctes, puis les deux branches convergent sur `m52`.

## Artefacts

| Artefact | Rôle |
| --- | --- |
| `narrative_tool/a11/pilots/sandra_blue_chairs.source.json` | source éditoriale verrouillée et topologie de référence |
| `narrative_tool/a11/pilots/sandra_blue_chairs.provenance.json` | entrées canoniques, faits locaux et limites de persistance |
| `narrative_tool/a11/planning/sandra_blue_chairs.json` | plan en sept beats et contrat de sortie maximal |
| `narrative_tool/a11/drafting/sandra_blue_chairs.draft.json` | draft intégré avec métadonnées techniques |
| `narrative_tool/a11/drafting/sandra_blue_chairs.validation_report.json` | rapport déterministe des contrôles bloquants et avertissements |
| `narrative_tool/a11/drafting/sandra_blue_chairs.traceability_report.json` | traçabilité beats, voix, faits, média, choix et convergence |
| `narrative_tool/a11/drafting/sandra_blue_chairs.blind_reading.md` | lecture aveugle Voix A / Voix B et questionnaire humain |
| `narrative_tool/a11/drafting/sandra_blue_chairs.human_review.md` | compte rendu de la lecture éditoriale effectuée |
| `narrative_tool/a11/drafting/sandra_blue_chairs.canon_decision.json` | décision fermée et remarques transmises à la revue canonique |

## Structure vérifiée

- 98 éléments de message stockés : 46 avant le choix, 5 pour A, 5 pour B et 42 après convergence.
- 93 éléments de message sur chacun des deux parcours jouables.
- 13 groupes de rafales stockés, 11 sur chaque parcours.
- 15 messages faibles stockés, 14 sur chaque parcours.
- Un seul média requis : `photo_sandra_cafe_blue_chairs`, attaché à `m01` et justifié par `local_terrace_photo`.
- Deux participants seulement : `player` et `sandra`.

| Position | Beat | Messages | Fonction |
| --- | --- | --- | --- |
| 1 | `concrete_photo` | `m01`–`m10` | photo concrète et réaction immédiate |
| 2 | `familiar_complicity` | `m11`–`m22` | complicité familière autour du déjeuner |
| 3 | `lightly_charged_memory` | `m23`–`m35` | mémoire légèrement chargée |
| 4 | `indirect_relaunch` | `m36`–`m45` | relance indirecte et aveu imparfait |
| 5 | `sandra_test_and_choice` | `m46`, `m47A`–`m51A`, `m47B`–`m51B` | test de Sandra, choix et réceptions distinctes |
| 6 | `reception_and_limit` | `m52`–`m78` | reconnaissance limitée et absence de pression |
| 7 | `protective_exit` | `m79`–`m93` | déjeuner seulement possible et sortie protectrice |

La progression maximale reste volontairement faible : l'importance mutuelle est un peu reconnue et un déjeuner ultérieur demeure seulement possible. Aucune date, promesse, réciprocité stable ou conséquence durable n'est acquise.

## Provenance et non-persistance

Les entrées canoniques sont le contrat de Sandra, la relation Player–Sandra et leur distance actuelle. Les seuls faits introduits localement sont le café, les chaises bleues, les frites froides et la photo de terrasse.

Ces quatre faits sont marqués `SCENE_LOCAL_ONLY`. Ils ne modifient ni le registre canonique A1 ni les contrats A11.2 persistés. Leur utilisation par le validateur passe par une vue transitoire en mémoire.

## Lecture aveugle et décision

La lecture aveugle conserve l'intégralité de la scène en remplaçant les locuteurs par Voix A / Voix B. Le questionnaire humain demande l'identification des voix, les marqueurs distinctifs, les passages trop écrits, les recouvrements possibles avec les autres voix et les répétitions à discuter. Aucune notation automatique n'est calculée.

Résultat de la lecture : Voix A est identifiable comme Sandra par ses rafales, son détour humoristique, sa mémoire concrète et sa maîtrise du rythme; Voix B reste le Player indirect et non pressant.

Les remarques transmises à la future revue signalent notamment :

- la construction très nette de `m64`–`m69` et `m75`–`m78` ;
- une convergence moins immédiate de `m51A` vers `m52` ;
- des recouvrements ponctuels possibles avec Mathilde ou Marie une fois les marqueurs de Sandra retirés ;
- les répétitions de « je sais », « pas complètement », « sans promesse » et « non ».

Ces remarques ne donnent aucune autorisation de retoucher le texte dans ce lot.

## Validation et essais de mutation

Le validateur refuse notamment :

- tout ajout, retrait ou changement d'une bulle ;
- un média absent ou injustifié ;
- un déjeuner présenté comme acquis ;
- l'activation de Marie dans les participants ;
- deux réceptions de choix identiques ;
- la promotion d'un fait local en conséquence durable ;
- un fait non approuvé ou une incompatibilité avec le contrat de voix.

La scène est compatible avec Sandra et volontairement incompatible avec les contrats de Marie et Mathilde. L'unique avertissement non bloquant porte sur les répétitions du texte source verrouillé.

## Commandes

```powershell
python tools/a11_plan_draft_export.py validate-pilot
python tools/a11_plan_draft_export.py pilot-review
python tools/a11_plan_draft_export.py pilot-blind
python tools/a11_plan_draft_export.py pilot-smoke
python -m unittest discover -s tests -p "test_*.py"
```

Ces commandes restent hors ligne. Les commandes propres au pilote ne proposent aucun export et ne touchent pas au runtime.

## État de sortie

Le pipeline A11 est désormais validé sur une première vraie scène éditoriale, de la provenance à la décision de revue. Le lot s'arrête à `APPROVED_FOR_CANON_REVIEW` : aucune fusion, aucun tag, aucun verrouillage canonique et aucun lot suivant ne sont inclus.
