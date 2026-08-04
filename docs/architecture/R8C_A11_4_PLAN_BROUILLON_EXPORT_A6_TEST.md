# R8C-A11.4 — Passage auteur Plan → Brouillon → Export A6 de test

> **Statut :** `IMPLEMENTED_PROTOTYPE_NON_CANONIQUE`
> **Parent obligatoire :** `b924c50b6e17faf9fd25de120022c229f1595ae8`
> **Dépendances :** A11.1, A11.2 et plan Sandra A11.3 approuvé.

## Responsabilité

A11.4 prouve une première chaîne auteur complète, hors ligne et limitée à une
scène :

`plan approuvé → brouillon structuré → validation → relecture humaine → export A6 synthétique`

Le lot ne génère pas le dialogue. Le brouillon est écrit et relu humainement,
puis [`a11_plan_draft_export.py`](../../tools/a11_plan_draft_export.py) vérifie
sa conformité aux sources fermées. La seule sortie de jeu est une fixture A6
non canonique chargée par le chemin explicite du smoke. Elle n’est référencée
ni par `PortraitMain`, ni par le runtime Saison 1.

Le cas reste `sandra_recontact_after_silence`. Le plan, son diagnostic, la
sélection humaine, le contrat Sandra et le registre Player–Sandra ne sont pas
dupliqués dans les fixtures A11.4 : le chargeur relit directement leurs sources
A11.2–A11.3.

## Formats et budget d’abstraction

Le brouillon réutilise `R8C_A11_DIALOGUE_DRAFT` en `version: 2`. Il conserve la
structure A11.1 — messages, choix, branches et convergence — et ajoute à chaque
bulle les références absentes de la version 1 : objectif, mouvement
relationnel, état local et réponse. La version 1 et ses fixtures restent
inchangées. Le validateur canonique A11.1 distribue explicitement les versions
1 et 2; A11.4 ne redéfinit donc pas un second propriétaire du même format.

Le rapport technique réutilise exactement `R8C_A11_VALIDATION_REPORT` version
1 : `BLOCKED`, `READY` ou `READY_WITH_WARNINGS`, diagnostics localisés et aucune
évaluation agrégée. `human_approval` reste `null`, car l’approbation A11.1 ne
peut exprimer ni la grille A11.4 ni sa configuration de projection.

Deux nouveaux formats seulement sont ajoutés :

| Format | Problème réel résolu | Invariant protégé | Complexité évitée |
| --- | --- | --- | --- |
| `R8C_A11_COMPOSITE_APPROVAL` | le rapport A11.1 ne sait pas lier les quatre statuts A11.4, les dix réponses humaines et la configuration A6 à une révision | l’auteur approuve exactement les sources, le brouillon et la projection exportés | aucun historique éditorial, aucune base et aucun workflow générique |
| `R8C_A11_A6_PROJECTION_REPORT` | le schéma A6 fermé ne représente ni bulles ni métadonnées auteur | toute perte est nommée avec sa raison et son emplacement de conservation | aucune extension du runtime A3/A6 et aucun faux champ de dialogue |

## Brouillon approuvé

La fixture
[`sandra_recontact_after_silence.draft.json`](../../narrative_tool/a11/drafting/sandra_recontact_after_silence.draft.json)
contient :

- 60 bulles;
- 4 rafales;
- 7 messages faibles;
- exactement un choix;
- exactement deux options Player;
- quatre bulles de réception Sandra propres à chaque option;
- une convergence commune au début de `protective_exit`;
- aucun média.

Chaque message porte `message_id`, `speaker_id`, `beat_id`,
`objective_actor_id`, `conversation_move`, `fact_refs`, `local_state`,
`burst_id`, `text` et `reply_to`, ainsi que les champs A11.1 de branche, force,
type et média. Le validateur lie ces références au plan et au registre. Un
mouvement doit appartenir à l’acteur de la bulle et rester compatible avec
l’état local; un fait doit être utilisable dans le plan et connu du locuteur.

Les sept battements approuvés sont réalisés dans leur ordre :

| Battement | Réalisation du brouillon |
| --- | --- |
| `concrete_hook` | Player repense au ticket du cinéma conservé par Sandra et elle reconnaît immédiatement l’archive commune |
| `calibration` | Sandra mesure les quatre jours de silence par le détour administratif |
| `indirect_reopening` | Player distingue indirectement le ticket du moment récent sans réclamer de réponse |
| `sandra_test` | Sandra lui demande ce qu’il vérifie et refuse que le silence définisse seul le lien |
| `player_positioning` | Player accepte une réponse courte avant le point de choix |
| `reception` | Sandra reçoit séparément l’importance reconnue et le détour maintenu |
| `protective_exit` | le ticket revient dans sa boîte et un passage près du cinéma reste seulement possible |

Le ticket garde donc une fonction après l’accroche : Player se souvient de
l’objet détenu par Sandra, lui demande ensuite si elle l’a toujours, puis
Sandra confirme qu’il se trouve désormais dans une boîte. Il porte le test,
les deux réceptions et la fermeture sans créer un second ticket ni transférer
sa possession à Player. Le rendez-vous n’est ni daté avec Player, ni accepté,
ni acquis.

## Choix et réceptions

Les attitudes abstraites A11.3 restent identifiées par leurs `option_id` et
reçoivent les formulations finales suivantes :

1. `Parce que l'autre soir a compté.`
2. `Parce que ce ticket méritait mieux.`

Pour la première, Sandra enregistre l’importance, refuse d’en faire un
monument, dit préférer que Player l’ait formulée et protège le rythme. Pour la
seconde, elle répond au ticket, nomme le détour, l’accepte pour ce soir et lui
interdit de porter tout l’enjeu. Les ensembles de messages et de mouvements
sont distincts avant le retour au noyau commun.

## Validation plan → brouillon

Les erreurs bloquantes couvrent notamment : plan A11.3 non approuvé ou périmé,
message sans battement, acteur ou participant inattendu, objectif absent,
mouvement inconnu ou attribué au mauvais acteur, état local incompatible, fait
étranger, possession du ticket attribuée à Player malgré
`sandra_folded_ticket`, média malgré `NONE`, réponse traversant une branche, battement omis,
rafale structurellement invalide, déclaration romantique directe, silence
transformé en reproche, rendez-vous présenté comme acquis, conséquence durable,
choix ou réception manquants, dialogue interchangeable et convergence non
autorisée.

Les avertissements restent indépendants et non agrégés : messages faibles ou
rafales absents/hors borne, bulle longue, Player trop bavard, redondance,
formulation longue, réception cosmétique, ticket sans fonction après
l’accroche et Sandra trop directe.

La continuité du ticket dispose d’une régression locale, sans moteur sémantique
générique : elle refuse notamment « Je viens de retrouver le ticket dans ma
poche. » pour Player et accepte le souvenir ou la question de Player suivis de
la confirmation de Sandra. La non-interchangeabilité relit les messages réels
et vérifie ensemble les marqueurs de la stratégie Sandra — détour protecteur,
mémoire partagée, progression lente et réversible —, les mouvements, les faits,
les limites et l’état relationnel. Le même dialogue et ses métadonnées sont
compatibles avec Sandra, mais incompatibles avec les contrats Marie et Mathilde;
la substitution des textes de leurs corpus dans les métadonnées Sandra est
également bloquée.

La fixture approuvée produit `READY`, sans erreur ni avertissement. Les
mutations de tests démontrent séparément les refus et avertissements requis.

## Relecture et empreinte composite

Les statuts autorisés sont `DRAFT`, `NEEDS_REVISION`,
`APPROVED_FOR_A6_TEST_EXPORT` et `REJECTED`. La décision structurée contient les
dix questions obligatoires; son rendu lisible est
[`sandra_recontact_after_silence.human_review.md`](../../narrative_tool/a11/drafting/sandra_recontact_after_silence.human_review.md).

L’empreinte composite approuvée est :

`07d6c92278a1c6a59ca69cad752d559b8dc45efef2585bd6a4520d3192faa81e`

Elle couvre, sous une canonicalisation JSON déterministe :

1. `a11-plan-draft-validator-1.2`;
2. le contrat Sandra A11.2;
3. le registre Player–Sandra A11.2;
4. les contrats et registres Marie et Mathilde utilisés par la preuve de
   non-interchangeabilité;
5. le cas A11.3 complet, donc diagnostic, sélection humaine, plan et relecture;
6. le brouillon complet;
7. le rapport de validation exact;
8. la décision et les réponses de relecture;
9. la configuration de projection A6.

Seul le champ qui stocke l’empreinte est exclu du calcul, ce qui évite une
dépendance circulaire. Les mutations indépendantes du plan, du contrat, du
registre, d’une bulle, du choix, du rapport ou de la configuration révoquent
l’approbation. Ce SHA-256 est un checksum de cohérence dont l’identité humaine
repose sur la revue Git; il ne constitue pas une signature cryptographique
indépendante.

L’empreinte technique du rapport régénéré est :

`23d84e5fcf3eef23bbfa249584e0dc9798f6d6f7e4dcfb73ccfc422f2bb11313`

## Projection A6

La fixture
[`r8c_a11_4_sandra_recontact_after_silence_export.json`](../../game/data/narrative_scenes/r8c_a11_4_sandra_recontact_after_silence_export.json)
conserve l’identité scène/variante, Player et Sandra, les deux formulations,
les signaux et les deux réceptions distinctes. Chaque résolution est `LOCALE`,
`NON_PERSISTANTE`, sans fait relationnel et converge par
`RETOUR_NOYAU_COMMUN`. Aucun rendez-vous n’est encodé comme fait.
La sérialisation du schéma fermé réutilise la même fonction pure que l’export
A11.1; seules la normalisation des choix et les valeurs approuvées restent
spécifiques à ce cas.

Le schéma A6/A3 est fermé et ne représente pas les 60 bulles, battements,
objectifs, mouvements, états locaux, rafales, messages faibles, réponses ou
preuves de relecture. Ces éléments ne sont ni inventés dans A6 ni supprimés
silencieusement :
[`sandra_recontact_after_silence.projection_report.json`](../../narrative_tool/a11/drafting/sandra_recontact_after_silence.projection_report.json)
énumère les éléments exportés, les éléments non représentables, leur raison et
l’invariant préservé.

Le champ `canonical_json_sha256` du rapport désigne précisément l’empreinte
canonique du contenu JSON A6, et non le SHA-256 des octets du fichier. Sa valeur
pour cette projection est :

`ad3dc8aa5ed2f6b728f7cca946ed103681028558f098c7eed3a0d3a8c8198019`

Le smoke Godot charge uniquement le chemin exact de cette fixture. Il
instancie la bibliothèque A6, jamais une instance A5, puis vérifie identité,
participants, choix, réceptions, portée, convergence et absence de preuves
éditoriales dans la définition.

## Commandes ciblées

```powershell
python -m unittest tests.test_r8c_a11_4_plan_draft_a6_export -v
python -m unittest tests.test_r8c_a11_authoring_workshop tests.test_r8c_a11_2_voice_relationship_calibration tests.test_r8c_a11_3_assisted_scene_planning -v
python tools/a11_plan_draft_export.py validate-json
python tools/a11_plan_draft_export.py smoke
python -m unittest tests.test_r8c_a3_minimal_scene_prototype_static tests.test_r8c_a6_minimal_narrative_library_static -v
godot --headless --path game res://tests/R8CA114PlanDraftA6ExportSmokeTest.tscn
git diff --check
```

La gate finale ajoute la suite Python globale, les validations JSON, la
simulation A3 et le validateur A6 concerné. Les smokes Portrait complets et la
résolution 1280×720 restent hors périmètre : aucun fichier joueur, UI ou runtime
Saison 1 n’est modifié.
