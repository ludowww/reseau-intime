# R8C-N7.1 — Contrat de structure de Saison 1, projection runtime et entrée N8

> **Baseline inspectée :** `024f9f3dbdaedfbbac20956ad2a9918fb611101c`
> **Tag stable vérifié :** `r8c-n7-written-payoff-aftercare-reconciliation`
> **Branche de livraison :** `work/r8c-n7-1-season-structure-runtime-projection-contract`
> **Nature :** contrat documentaire ; aucun changement de dialogue, runtime, test, asset, JSON ou A1–A10
> **Statut du document :** `SEASON_RUNTIME_PROJECTION_CONTRACT_BLOCKED`
> **Statut produit possible après revue et verrouillage seulement :** `SEASON_RUNTIME_PROJECTION_CONTRACT_APPROVED`

## 1. Verdict et autorité

Ce document est l’unique point de réconciliation N7.1 entre la structure canonique
de Saison 1, les séquences authored, la projection historique J01–J21 et le
`Season1State` réellement exécutable sur la baseline. Il ne remplace pas les textes
de personnage ni les dialogues signés ; il prévaut, pour l’entrée N8, sur les
anciens découpages par jours, sur les anciennes lectures de J17 comme finale et sur
les anciens vocabulaires d’état incompatibles.

Le contrat n’est pas prêt à être approuvé. Le runtime permet de calculer exactement
la disponibilité de la discussion J17 et de vérifier les quatre choix, mais il ne
porte pas assez de preuves fermées pour calculer sans décision produit les gardes de
dommage et les conditions constructives des six sorties. Les décisions manquantes
sont isolées en `BLOCKED_PRODUCT_DECISION` dans la section 7. Conformément à la
règle de sécurité, une donnée obligatoire absente ou contradictoire invalide la
résolution ; elle ne choisit ni un fallback favorable, ni `FRACTURE` par défaut.

N8 demeure un correctif ciblé du runtime historique de Saison 1. Aucun cutover,
adaptateur, exécuteur de séquences, projection A6, double écriture ou migration vers
A1–A10 n’est autorisé.

## 2. Hiérarchie canonique complète

La hiérarchie normative est :

```text
Saison
→ mouvement dramatique
→ séquence authored
→ scène ou beat
→ dialogue
→ média
→ projection temporelle
→ jour et heure diégétiques
```

- La saison est l’unité de transformation et de clôture.
- Un mouvement est une unité dramatique canonique. Ce n’est ni un champ, ni une
  phase, ni un état runtime.
- La séquence authored est l’unité principale de composition narrative. Elle porte
  une identité, une fonction, des entrées et sorties ; elle peut contenir plusieurs
  scènes, beats, échanges, silences et médias.
- Une scène ou un beat situe une action concrète. Un dialogue et un média en sont
  des modes de livraison, pas des identités supérieures.
- La projection temporelle place ces unités dans le corpus actuellement jouable.
  Les jours et horaires sont des contenants diégétiques et techniques.
- Les dates et heures restent nécessaires aux rendez-vous, absences, repos,
  obligations, échéances et au rythme crédible de messagerie.
- `J01–J21` est la projection actuelle du corpus et du runtime, pas l’architecture
  canonique de la saison.
- L’identité canonique d’une séquence ne dépend jamais d’un identifiant `jNN_*`.

> **Règle normative :** Un déplacement, une fusion ou une subdivision de journée
> ne modifie pas l’identité canonique d’un mouvement, d’une séquence ou d’une scène.

### 2.1 Les cinq mouvements

| Mouvement | Matière principale | Fonction et sortie |
|---|---|---|
| I — Réouverture | `S01–S07` | Réactiver le réseau, faire revenir les liens anciens, installer les premières fissures et la question dramatique. La réouverture a un effet lisible sur Marie/Player. |
| II — Attirances | `S08–S14` | Rendre distincts regards, ambiguïtés, tentations et déplacements relationnels ; installer une progression visuelle et sociale. Une attirance ou une limite ne peut plus être réduite à une occasion. |
| III — Explorations | `S15–S22` | Autoriser expérimentations, franchissements conditionnels, scènes adultes, payoffs et découverte des limites réelles. Une exploration modifie ce qui est possible, dû ou difficile à dire. |
| IV — Limites et conséquences | `S23–S28` | Faire répondre aux conflits, audiences, promesses, paiements, réparations ou fractures. Les conséquences pertinentes sont résolues, transformées ou transportées. |
| V — Clarification | sous-mouvements ci-dessous | Construire ou terminer le couple après les conséquences, puis produire décision, logistique et épilogues compatibles. |

### 2.2 Sous-mouvements canoniques du mouvement V

Ces étapes sont indépendantes des jours et conservent cet ordre relatif :

1. départ de Mathilde et clarification intermédiaire, matière historique `S31` et
   `S29` ;
2. état provisoire du couple ;
3. résolution des lignes extérieures Sandra, Pauline, Raphaëlle et Nico, matière
   `S30`, `S32`, `S33` et `S34` ;
4. aftercares réellement dus ;
5. synthèse des conséquences et constitution de la trace ou posture ;
6. conversation finale autonome Marie/Player ;
7. décision, contrat ou séparation et logistique ;
8. épilogues et dernière image recontextualisée, fonction historique `S35`.

J17 et J21 localisent actuellement une partie de ces fonctions. Ils n’en sont pas
les identités canoniques.

## 3. J17, J21 et la véritable conversation finale

### 3.1 Contrat de J17

J17 porte le départ de Mathilde, les quatre choix de couple existants, une résolution
intermédiaire vers un des six états, un micro-retour Mathilde après le départ, un
micro-retour Marie après la résolution, une règle ou obligation de continuité et la
préparation des conséquences suivantes.

J17 n’est ni la conversation finale de la saison, ni la décision logistique
terminale, ni l’épilogue. Son choix local n’annule aucun fait J01–J16.

### 3.2 Identité de la conversation finale

| Propriété | Contrat |
|---|---|
| Identité canonique produit | `s1_m5_marie_player_final_conversation` |
| Collision | Aucune occurrence dans le dépôt à la baseline inspectée. |
| Compatibilité syntaxique | Compatible : chaîne authored non vide, stable, explicite et en snake_case ; les contrats A2/A6 n’imposent pas une casse différente à une identité documentaire de séquence. |
| Fonction | Faire décider Marie et Player à partir de l’historique réel, après les conséquences et la posture ; la trace ou son contrôleur ne décide pas le couple. |
| Prérequis | État provisoire J17 valide ; résolutions extérieures pertinentes ; aftercares dus payés, échoués ou explicitement transportés ; trace/posture constituée ; connaissances de Marie bornées aux faits réellement acquis. |
| Entrées | Choix J17 exact, état canonique dérivé, gardes déclenchées, conditions constructives prouvées, promesses, obligations, traces, connaissances, résolutions des lignes extérieures, posture et logistique déjà établie. |
| Sorties | Statut final du couple ; contrat et divulgation distincts si le couple continue, ou relation résiduelle et logistique si séparation ; obligations de suivi ; admissibilité des épilogues. |
| Position relative | `conséquences → trace/posture → s1_m5_marie_player_final_conversation → décision/logistique → épilogues` |
| Projection runtime actuelle | Absente. J21 sert un matin Marie avant la trace, puis la trace, une posture et une réponse courte de son contrôleur ; il ferme ensuite la saison. |
| Portée N8 | Aucune. N8 ne modifie pas J21 et n’implémente pas cette conversation. |

L’ancien `S29 — La conversation qui ne peut plus être repoussée` reste la matière de
clarification intermédiaire historiquement projetée sur J17 ; il ne nomme plus la
conversation finale. Le script J21 pré-runtime conserve de la matière de soirée,
mais son ordre et sa projection actuelle sont supersédés par le contrat de finale du
document `14` et par l’identité ci-dessus.

### 3.3 Documents historiquement associés à la fonction finale

- `docs/canon/bible/07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md` utilisait `S29`
  pour la définition du couple et `S35` pour la dernière image.
- `docs/canon/bible/11_DISTRIBUTION_SEQUENCES_SCENES_IMAGES_CONSEQUENCES_JOURNEES.md`
  projetait `S29` sur J17 et `S35` sur J21.
- `docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md` décrivait six sorties de
  couple à J17 ; ses sorties deviennent provisoires.
- `docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md` contient de la matière de
  finale mais reste lié à J21 et ne gouverne plus l’identité ni l’ordre final.
- `docs/canon/bible/14_CONTRAT_NARRATIF_SAISON_1_RECONCILIE.md` fixe l’autonomie
  et l’ordre de la conversation finale ; il est l’autorité narrative supérieure.
- `docs/narrative/R8C_N7_J17_J21_CONTINUITY_AND_AFTERCARE_PLAN.md` et
  `docs/narrative/R8C_N7_REVISION_PACKETS_AND_ACCEPTANCE_GATES.md` constatent le
  raccord manquant, sans lui attribuer l’identité produit désormais fixée ici.

## 4. Vocabulaire unique des six états J17

Identifiant explicitement interdit : `RECONFIGURATION_NEGOTIATING`. Toute donnée
nouvelle, formule N8, test ou micro-retour emploie le vocabulaire ci-dessous.

Le droit de refus de Marie est un invariant permanent dans les six états. Le
prédicat constructif de reconfiguration vérifie qu’une proposition le reconnaît
explicitement ; il ne crée, ne suspend et ne retire jamais ce droit.

| État | Définition narrative | Faits garantis | Faits explicitement exclus | Dépend encore du record | Statut provisoire du couple | Règle ou obligation immédiate | Finale compatible | Runtime actuel / N8 |
|---|---|---|---|---|---|---|---|---|
| `SEPARATION` | Fin du couple reconnue ou organisation de fin déjà active. | Ancien couple terminé ; logistique exigée ; histoire commune conservée. | Permission extérieure automatique ; effacement des promesses, dommages ou souvenirs. | Qualité résiduelle, objets, logement, rendez-vous, dettes et aftercares. | Séparés. | Organiser concrètement logement, objets, heure ou limites. | Oui, pour fixer logistique et relation après séparation. | Produit par `choice_j17_separation`; enrichissement du record et micro-retour N8. |
| `FRACTURE` | Ancien fonctionnement retiré, vie pratique encore liée et réparation non promise. | Cadre antérieur indisponible ; lien pratique possible ; conséquence active. | Réconciliation, séparation déjà accomplie, disponibilité d’une route de consolation. | Cause exacte, connaissance de Marie, réparation possible et logistique. | En clarification, fracturé. | Limite pratique immédiate ; aucune progression de consolation. | Oui, vers réparation nouvelle ou séparation, sans attente automatique. | Produit aujourd’hui seulement après refus/non-dû ; gardes dommageables à ajouter en N8. |
| `DOUBLE_LIFE_FRAGILE` | Couple matériellement maintenu alors qu’un fait important caché ou une version incompatible reste actif. | Contradiction active ; confiance contestée ; conséquence future nécessaire. | Contrat sain, succès propre, vérité complète, pardon. | Fait caché, personne qui sait quoi, preuve, dette et fermeture possible. | Ensemble matériellement, divulgation compromise. | Ne pas aggraver ; payer ou révéler la contradiction existante. | Oui, comme matière de révélation, décision ou séparation. | Accepté par snapshot/J21 mais jamais produit par le résolveur J17 actuel ; adaptation N8. |
| `PROVISIONAL_AGREEMENT` | Le couple évite la rupture immédiate avec des règles temporaires et une revue bornée. | Problème reconnu ; ancien cadre non restauré ; aucune permission rétroactive. | Résolution finale, ouverture implicite, oubli de l’historique. | Règle exacte, espaces, divulgation, date de revue et obligations. | Ensemble sous accord provisoire. | Règle temporaire et checkpoint explicite ; progression extérieure contenue. | Oui, la finale doit décider ou définir un provisoire complet. | Produit par `choice_j17_provisional` et fallback de reconquête ; record/règle à enrichir en N8. |
| `RECONQUEST_ACTIVE` | Marie et Player essaient encore activement, par des actes antérieurs prouvés et une règle concrète. | Choix du couple ; vérité suffisante ; absence de violation active ; acte ordinaire à répéter. | Pardon total, retour intact à l’ancien cadre, nouvelle progression extérieure non clarifiée. | Actes précis, règle, dommages réparés, obligations et divulgation. | Ensemble en reconquête. | Aucun faux horaire ou lieu ; aucune nouvelle progression extérieure avant clarification ; acte ordinaire concret. | Oui, sans transformer la reconquête en absolution. | Produit trop directement par le choix homonyme ; N8 doit appliquer les gardes et conditions. |
| `RECONFIGURATION_NEGOTIATION` | Négociation réelle du contrat, sans ouverture automatique ni engagement d’un tiers. | Désir extérieur reconnu ; audiences sûres ou réparées ; pause ; refus de Marie explicitement reconnu. | Permission rétroactive, couple déjà ouvert, tiers engagé, disponibilité automatique d’une personne. | Désirs exacts, limites, partenaires libres, date de revue et résultat de la négociation. | En clarification/négociation. | Aucune nouvelle étape ; droit de refus intact ; checkpoint borné. | Oui, la finale peut conclure refus, autre contrat ou séparation. | Accepté par snapshot/J21 mais jamais produit par J17 ; adaptation N8 et preuves manquantes. |

Aucun de ces états n’est un résumé exhaustif de l’histoire. Le record de continuité
reste la preuve de ce qui a déclenché l’état et de ce qui demeure ouvert.

## 5. Surface runtime réellement observée

Tous les champs ci-dessous sont déclarés et snapshotés dans
`game/scripts/runtime/season_1/Season1State.gd`.

| Donnée | Type réel | Valeurs observées ou validées | Écrivains réels |
|---|---|---|---|
| `j11_physical_level` | `String` | `NONE`, `PROXIMITY_ONLY`, `MATHILDE_M_B2`, `MATHILDE_M_B3`, `MARIE_ADULT_RECONQUEST`, `RAPHAELLE_FIRST_KISS` | `set_j11_mathilde_proximity`, `establish_j11_mathilde_physical_event`, `establish_j11_marie_adult_event`, `set_j11_raphaelle_outcome` ; scènes `chapter_11_*`. |
| `obligations["aftercare_mathilde_j11"]` | `Dictionary` optionnel ; `status: String` | absent, puis `DUE`, et obligatoirement `PAID` ou `FAILED` avant la fin J11 | `establish_j11_mathilde_physical_event`, `_create_j11_aftercare`, `resolve_j11_aftercare`; échec traité par `mark_j12_failed_aftercare_processed`. |
| `j14_outcome`, `j14_player_explanation` | `String` | `TRUTH_LIMITED`, `MINIMIZE_OR_LIE`, `PROTECT_AND_DEFER`, `PROTECT_AND_ANSWER_NOW`, ou `S27_MUTATION_NO_DISCOVERY` pour `j14_outcome` | `select_j14_variant`, `_set_j14_no_discovery_mutation`, `apply_j14_choice`; choix `choice_j14_<variant>_truth|lie|defer`. |
| `j14_witness` | `String` | vide, `Marie` ou `Mathilde` | `select_j14_variant`, d’après la trace J13/J11 projetée sur J14. |
| `j14_controller_notified` | `bool` | `false`, `true` | `resolve_j14_controller_informed` met `true`; `fail_j14_controller_notice` maintient/met `false`. |
| `promises["j14_inform_trace_controller"].status` | `String` dans un `Dictionary` optionnel | absent, `ACTIVE`, puis `PAID` ou `FAILED` avant fin J14 | `_create_j14_controller_notice`, `resolve_j14_controller_informed`, `fail_j14_controller_notice`. |
| `j15_mode` | `String` | `ACTIVE_CLARIFICATION`, `REPAIR`, `OPEN_CLARIFICATION`, `NO_OBLIGATION` après établissement | `select_j15_mode`, `establish_j15_mode`. |
| `j15_outcome` | `String` | `DUE_PAY`, `DUE_CANCEL`, `DUE_FAIL`, `REPAIR_TRUTH`, `REPAIR_LIE`, `OPEN_ANSWER`, `OPEN_REFUSE`, `OPEN_LIE`, `CLEAN_ACKNOWLEDGE` | `apply_j15_choice`; familles de choix homonymes de `chapter_15_obligation_mutation.json`. |
| `j15_urgent_consequence_remaining` | `bool` | `false`, `true` | `apply_j15_choice`; vrai pour échec dû ou mensonge renouvelé. |
| `j16_priority` | `String` | `MARIE`, `MATHILDE`, `FALLBACK` après établissement | `select_j16_priority`, `establish_j16_priority`. |
| `j16_consequence_outcome` | `String` | `MARIE_RESTITUTE`, `MARIE_PRACTICAL`, `MARIE_CONTEST`, `MATHILDE_RESTITUTE`, `MATHILDE_PRACTICAL`, `MATHILDE_CONTEST`, `FALLBACK_CONFIRM` | `apply_j16_consequence_choice`; choix de `chapter_16_priority_payment.json`. |
| `promises["j16_priority_consequence_payment"].status` | `String` dans un `Dictionary` optionnel | absent, `ACTIVE`, puis `PAID` ou `FAILED` | Créé par `apply_j15_choice`; résolu par `apply_j16_consequence_choice`; une contestation produit `FAILED`. |
| `j16_j17_outcome` | `String` | `ACCEPT`, `REFUSE`, `ALTERNATIVE` après choix | `apply_j16_j17_choice`; choix `choice_j16_j17_accept|refuse|alternative`. |
| `promises["marie_j16_couple_conversation_j17"]` | `Dictionary` optionnel ; `status: String` | absent, ou `ACTIVE` après acceptation, puis `PAID` au choix J17 | `apply_j16_j17_choice`, `apply_j17_couple_choice`. |
| `j17_departure_outcome` | `String` | `HELP`, `DISTANCE` | `apply_j17_departure_choice`; la variante UI `choice_j17_distance_required` est normalisée par le provider vers `choice_j17_distance`. |
| `j17_couple_outcome` | `String` | `RECONQUEST`, `PROVISIONAL`, `SEPARATION`, `REFUSED_ACKNOWLEDGE` | `apply_j17_couple_choice`; quatre choix de couple réels. |
| `couple_state` | `String` | huit valeurs validées par snapshot, dont les six états J17 ; le résolveur actuel n’en produit directement que quatre | `apply_j17_couple_choice` pour J17. |
| `selected_choice_ids` | `Array[String]` | identifiants exacts des choix acceptés | Toutes les méthodes `apply_*`; J17 y conserve le choix de départ et le choix de couple. |
| `traces["j17_couple_definition_record_01"]` | `Dictionary` | actuellement `trace_id`, `record_type`, `source_day`, `couple_state`, `discussion_was_due`, `current_state`, `visual_asset` | `apply_j17_couple_choice`. |

### 5.1 Faits authored candidats pour les actes envers Marie

Le runtime contient des preuves distinctes, mais aucun sous-ensemble produit n’est
désigné comme « actes Marie répétés ». Les candidats fermés, sans compteur, sont :

| Groupe authored distinct | Champs/preuves | Fonctions d’écriture |
|---|---|---|
| Présence initiale | `promises["marie_j01_shared_evening"].status/outcome` | `apply_choice`, `pay_marie_promise` |
| Place faite au foyer | `marie_make_room_outcome` | `apply_j02_choice` |
| Retour J03 | `marie_j03_return_outcome` | `apply_j03_choice` |
| Heure partagée | `marie_j05_shared_hour_outcome/resolution`, promesse associée | `apply_j05_marie_choice`, `resolve_j05_marie_hour` |
| Retour concret J06/J07 | `marie_j06_return_outcome/due_at/resolution` | `apply_j06_marie_choice`, résolution J07 |
| Demande du foyer J07/J08 | `marie_j07_household_outcome`, `marie_j08_household_resolution`, `marie_j08_echo_outcome`, promesse associée | `apply_j07_marie_choice`, méthodes de résolution J08 |
| Présence et dîner J09–J11 | `marie_j09_presence_choice/outcome`, `marie_j09_dinner_outcome`, `marie_j10_dinner_resolution`, promesses dîner | `apply_j09_presence_choice`, `apply_j09_presence_quality`, `apply_j09_dinner_choice`, méthodes J10 et `apply_j11_p10_choice`/`pay_j11_p10` |
| Retour Marie J11 | `j11_pivot == MARIE`, `j11_pivot_outcome`, `j11_physical_level`, aftercare Marie | `set_j11_semantic_outcome`, `establish_j11_marie_adult_event`, `pay_j12_marie_aftercare` |
| Présence La Verrière J12 | `promises["marie_j12_laverriere_presence"].status == PAID` | `apply_j12_choice`, `pay_j12_laverriere_presence` |
| Vérité/conséquence J14–J16 | `j14_witness`, `j14_outcome`, `j15_outcome`, `j16_priority`, `j16_consequence_outcome` | fonctions J14–J16 listées ci-dessus |

Ces groupes sont un inventaire, pas une formule. Les combiner par nombre, poids,
seuil ou somme est interdit.

## 6. Règles de calcul et invalidité

L’évaluation N8 doit être déterministe, ordonnée et faite avant la mutation de la
promesse J17 et de `couple_state`.

```text
entrée structurellement valide
→ validité du choix
→ gardes dommageables, dans l’ordre
→ conditions constructives propres au choix
→ fallback propre au choix
→ record de continuité
→ micro-retours
```

Une preuve constructive absente vaut `false`. Une violation vaut `true` seulement
si un fait existant l’établit explicitement. Une donnée obligatoire absente,
contradictoire ou impossible invalide l’entrée et empêche toute sortie.

Cas d’entrée invalides minimaux :

- choix inconnu ;
- `choice_j17_refused_acknowledge` alors que la discussion est due ;
- choix due-only alors que la discussion est refusée ou non due ;
- `j16_j17_outcome == ACCEPT` sans promesse active correspondante, ou promesse
  active avec `REFUSE`/`ALTERNATIVE` ;
- champ requis encore `UNESTABLISHED` ;
- preuve annoncée dans un record mais absente de `knowledge`, `promises`,
  `obligations` ou `traces` ;
- deux valeurs incompatibles pour le même fait ;
- condition constructive déclarée satisfaite sans preuve authored fermée.

Un cas invalide ne produit ni septième état, ni fallback, ni état de dommage par
prudence. Le résolveur doit refuser explicitement et laisser l’état antérieur
inchangé.

## 7. Traduction exacte des prédicats N7

### 7.1 Discussion J16 refusée ou non due

- **Nom stable :** `J17_DISCUSSION_REFUSED_OR_NOT_DUE`.
- **Définition :** Player a explicitement refusé l’heure J17 ou proposé une
  alternative qui ne crée pas la promesse due ; Marie n’attend donc pas la
  conversation.
- **Runtime :** `j16_j17_outcome: String` (`ACCEPT`, `REFUSE`, `ALTERNATIVE`) et
  `promises["marie_j16_couple_conversation_j17"]: Dictionary` optionnel, écrit par
  `apply_j16_j17_choice` dans `chapter_16_priority_payment.json`.
- **Valeurs satisfaisantes :** `REFUSE` ou `ALTERNATIVE`, avec promesse absente.
- **Valeur incompatible :** `ACCEPT` avec promesse `ACTIVE`.
- **Formule exacte à l’entrée J17 :**

```text
(j16_j17_outcome == REFUSE OR j16_j17_outcome == ALTERNATIVE)
AND NOT promises.has("marie_j16_couple_conversation_j17")
```

La discussion due, utilisée comme condition de validité des trois autres choix, est
exactement l’état complémentaire valide suivant :

```text
j16_j17_outcome == ACCEPT
AND promises.has("marie_j16_couple_conversation_j17")
AND promises["marie_j16_couple_conversation_j17"].status == ACTIVE
```

- **Information manquante :** `UNESTABLISHED`, promesse mal formée ou incohérence
  résultat/promesse invalide l’entrée.
- **Source canonique :** N7-RP-04 et la disponibilité réelle de
  `apply_j17_couple_choice`.
- **Conséquence N8 :** calculable sans nouveau champ ; conserver la cohérence
  stricte au lieu de réduire la notion à `promise.status != ACTIVE`.
- **Statut :** calculable.

### 7.2 Violation grave connue de Marie et non réparée

- **Nom stable :** `J17_MARIE_KNOWN_SEVERE_VIOLATION_UNREPAIRED`.
- **Définition :** un fait de sécurité, audience ou responsabilité classé grave est
  réellement connu de Marie et sa réparation requise a explicitement échoué ou
  reste impossible.
- **Runtime disponible :** `j11_physical_level: String`, aftercare Mathilde
  optionnel et son `status: String`, `j14_witness: String`,
  `knowledge["fact_witness_saw_limited_trace"]: Dictionary`,
  `j14_controller_notified: bool`, statuts des promesses J14/J16,
  `j15_outcome: String`, `j16_priority: String` et
  `j16_consequence_outcome: String`. Les écrivains sont les fonctions J11,
  `establish_j14_discovery`, les résolutions J14, `apply_j15_choice` et
  `apply_j16_consequence_choice`.
- **Valeurs explicitement dommageables observées :** aftercare `FAILED`, notice
  contrôleur `FAILED`, `DUE_FAIL`, `REPAIR_LIE`, `OPEN_LIE`, et sorties J16
  `*_CONTEST`. Elles prouvent chacune leur fait local, pas automatiquement gravité,
  connaissance de Marie et absence globale de réparation.
- **Valeurs potentiellement réparatrices observées :** aftercare `PAID`, notice
  `PAID`, `DUE_PAY`, `REPAIR_TRUTH`, `OPEN_ANSWER`, `*_RESTITUTE` et
  `*_PRACTICAL`; leur suffisance n’est pas définie.
- **Formule exacte :** `BLOCKED_PRODUCT_DECISION`.
- **Comportement si manque :** la garde ne peut pas être déclarée vraie ; si cette
  qualification est nécessaire pour départager `FRACTURE` d’une autre sortie,
  l’entrée est invalide et le résolveur refuse.
- **Décision/donnée absente :** liste fermée des faits « graves », preuve exacte que
  Marie les connaît et matrice fermée acte dommageable → réparation suffisante.
- **Source canonique :** N7-RP-04, script J17 sections de reconquête/fracture et
  contrat d’état Saison 1.
- **Conséquence N8 :** aucun codage avant arbitrage ; ne pas assimiler tout échec à
  une violation grave ni toute restitution à une réparation.
- **Statut :** `BLOCKED_PRODUCT_DECISION`.

### 7.3 Fait matériel caché

- **Nom stable :** `J17_MATERIAL_FACT_HIDDEN`.
- **Définition :** un fait qui change raisonnablement le contrat du couple existe,
  Player le connaît et Marie ne le connaît pas suffisamment.
- **Runtime disponible :** `j11_physical_level: String`, faits/traces J11,
  `j14_variant/outcome/witness: String`, `j14_visible_values: Dictionary`,
  `j15_outcome: String` et connaissances à audience bornée. Les scènes et écrivains
  sont les payoffs J11, `establish_j14_discovery`, `apply_j14_choice` et
  `apply_j15_choice`.
- **Valeurs observées candidates :** `MATHILDE_M_B2`, `MATHILDE_M_B3`,
  `RAPHAELLE_FIRST_KISS`, une explication `MINIMIZE_OR_LIE`, ou une vérité limitée.
  Le runtime ne dit pas lesquelles sont matériellement dues au couple ni lesquelles
  ont ensuite été intégralement divulguées à Marie.
- **Valeurs satisfaisantes/incompatibles :** aucune liste produit fermée.
- **Formule exacte :** `BLOCKED_PRODUCT_DECISION`.
- **Comportement si manque :** une trace privée n’est pas automatiquement un secret
  dû à Marie ; l’absence de champ de divulgation interdit aussi de conclure que le
  fait est révélé. Le cas est invalide s’il influence la sortie.
- **Décision/donnée absente :** liste fermée des faits matériels et preuve de
  divulgation par fait et par destinataire.
- **Source canonique :** contrat final du document `14`, N7-RP-04 et règles
  d’audience J11–J14.
- **Conséquence N8 :** décision produit requise ; ne pas créer un booléen vague
  `has_secret`.
- **Statut :** `BLOCKED_PRODUCT_DECISION`.

### 7.4 Version incompatible encore active

- **Nom stable :** `J17_INCOMPATIBLE_VERSION_ACTIVE`.
- **Définition :** deux affirmations ou une affirmation et un fait matériel ne
  peuvent être vrais ensemble, et aucune clôture explicite n’a retiré la
  contradiction.
- **Runtime disponible :** `j14_outcome/player_explanation: String`,
  `knowledge["fact_player_explanation_to_witness"]: Dictionary`, `j15_outcome:
  String`, `j16_consequence_outcome: String`. `existing_contradiction_id` n’est
  calculé qu’à l’entrée J21 à partir d’un `couple_state` déjà résolu ou de Pauline ;
  il ne peut pas servir à résoudre J17 sans circularité.
- **Valeurs candidates actives :** `MINIMIZE_OR_LIE`, `REPAIR_LIE`, `OPEN_LIE`,
  `*_CONTEST`. Les valeurs `TRUTH_LIMITED`, `REPAIR_TRUTH`, `OPEN_ANSWER`,
  `*_RESTITUTE` ou `*_PRACTICAL` n’ont pas de règle fermée de clôture.
- **Formule exacte :** `BLOCKED_PRODUCT_DECISION`.
- **Comportement si manque :** ne pas déduire l’activité d’une contradiction d’un
  simple texte de branche ni utiliser le futur `couple_state` comme entrée ; refuser
  la résolution si ce prédicat départage la sortie.
- **Décision/donnée absente :** couples fermés version/fait, identifiant de leur
  source et événement exact de clôture.
- **Source canonique :** N7-RP-04, registre de contradictions du contrat d’état et
  script J17.
- **Conséquence N8 :** un record borné de preuves peut être ajouté après décision ;
  aucun journal générique.
- **Statut :** `BLOCKED_PRODUCT_DECISION`.

### 7.5 Actes Marie répétés

- **Nom stable :** `J17_REPEATED_MARIE_ACTS_PROVEN`.
- **Définition :** au moins une combinaison authored fermée de plusieurs actes
  distincts envers Marie montre une continuité antérieure à J17 ; le choix J17 seul
  ne suffit pas.
- **Runtime disponible :** groupes distincts de la section 5.1, sous forme de
  `String`, `Dictionary` de promesse et faits de connaissance ; écrivains J01–J16.
- **Valeurs candidates :** présences payées, alternatives précises, refus honnêtes,
  retours accomplis, dîner payé, reconnection J11 et présence J12. Certaines valeurs
  sont positives dans leur scène sans prouver une reconquête globale.
- **Combinaisons fermées satisfaisantes/incompatibles :** non décidées. Un total ou
  un test « au moins N » est interdit.
- **Formule exacte :** `BLOCKED_PRODUCT_DECISION`.
- **Comportement si manque :** `false` comme condition constructive ; si les autres
  preuves sont cohérentes, la branche reconquête tombe sur son fallback
  `PROVISIONAL_AGREEMENT`.
- **Décision/donnée absente :** liste explicite d’ensembles, par exemple des couples
  ou triplets nommés d’actes distincts, et leurs valeurs admises ; aucun compteur.
- **Source canonique :** script J17, matrice d’atteignabilité et N7-RP-04.
- **Conséquence N8 :** produit doit valider les combinaisons exactes avant code.
- **Statut :** `BLOCKED_PRODUCT_DECISION`.

### 7.6 Vérité suffisante

- **Nom stable :** `J17_SUFFICIENT_TRUTH_PROVEN`.
- **Définition :** tous les faits matériels dus à Marie pour la posture considérée
  ont une divulgation explicite compatible avec ce qu’elle sait réellement.
- **Runtime disponible :** `j14_outcome/player_explanation`,
  `fact_player_explanation_to_witness`, résolutions J15/J16 et promesses associées ;
  types `String`/`Dictionary`.
- **Valeurs candidates :** `TRUTH_LIMITED`, `REPAIR_TRUTH`, `OPEN_ANSWER`,
  `DUE_PAY`, `*_RESTITUTE`, `*_PRACTICAL`. Aucun champ ne relie ces actes à une
  liste fermée de faits matériels dus.
- **Valeurs incompatibles candidates :** `MINIMIZE_OR_LIE`, `REPAIR_LIE`,
  `OPEN_LIE`, `*_CONTEST`; leur portée exacte reste locale.
- **Formule exacte :** `BLOCKED_PRODUCT_DECISION`.
- **Comportement si manque :** `false` comme condition constructive ; aucune
  reconquête active ne peut être prouvée.
- **Décision/donnée absente :** liste des faits matériels et relation
  fait → divulgation complète/partielle/non due.
- **Source canonique :** document `14`, script J17 et N7-RP-04.
- **Conséquence N8 :** ne pas assimiler une vérité limitée unique à la vérité
  suffisante globale.
- **Statut :** `BLOCKED_PRODUCT_DECISION`.

### 7.7 Aucune violation active

- **Nom stable :** `J17_NO_ACTIVE_VIOLATION`.
- **Définition :** aucune violation explicitement établie ne demeure active après
  application des réparations reconnues.
- **Runtime disponible :** mêmes champs et écrivains que les trois gardes
  dommageables précédentes.
- **Nature :** prédicat dérivé, jamais un nouveau champ destiné uniquement à
  matérialiser une négation.
- **Formule normative :**

```text
NOT J17_MARIE_KNOWN_SEVERE_VIOLATION_UNREPAIRED
AND NOT J17_MATERIAL_FACT_HIDDEN
AND NOT J17_INCOMPATIBLE_VERSION_ACTIVE
```

- **Valeurs satisfaisantes/incompatibles :** dépendent des trois décisions produit
  non fermées ; l’absence de preuve d’une violation ne constitue pas à elle seule
  une preuve constructive générale, mais une violation ne devient jamais vraie sans
  fait explicite.
- **Comportement si manque :** prédicat non calculable ; l’entrée constructive est
  bloquée, sans nouveau champ de négation.
- **Source canonique :** ordre N7 des gardes avant conditions constructives.
- **Conséquence N8 :** dériver après validation des gardes, ne rien persister de
  redondant.
- **Statut :** `BLOCKED_PRODUCT_DECISION` par dépendance.

### 7.8 Règle concrète

- **Nom stable :** `J17_CONCRETE_RULE_PROVEN`.
- **Définition :** une règle actuelle, observable et applicable est acceptée ; une
  promesse abstraite de « faire mieux » ne suffit pas.
- **Runtime disponible :** `selected_choice_ids: Array[String]`, choix J17 et
  `j17_couple_definition_record_01: Dictionary`. La phrase du choix reconquête
  mentionne l’arrêt des versions fausses, mais aucune règle normalisée n’est stockée.
- **Valeurs satisfaisantes/incompatibles :** aucune valeur runtime fermée. Le choix
  favorable seul est explicitement insuffisant selon N7.
- **Formule exacte :** `BLOCKED_PRODUCT_DECISION`.
- **Comportement si manque :** `false`; la reconquête valide utilise le fallback
  `PROVISIONAL_AGREEMENT` si aucune autre donnée n’est invalide.
- **Décision/donnée absente :** vocabulaire fermé des règles et événement authored
  qui prouve leur acceptation avant résolution.
- **Source canonique :** script J17, contrat d’état et N7-RP-04.
- **Conséquence N8 :** enrichissement borné du record après arbitrage ; pas de texte
  libre servant de pseudo-règle.
- **Statut :** `BLOCKED_PRODUCT_DECISION`.

### 7.9 Désir extérieur reconnu

- **Nom stable :** `J17_EXTERNAL_DESIRE_ACKNOWLEDGED`.
- **Définition :** un désir extérieur précis est nommé comme désir, sans imposer la
  personne concernée ni transformer l’acte passé en permission.
- **Runtime disponible :** `j11_pivot_outcome: String`, `j11_physical_level: String`,
  traces/connaissances de routes et explications J14. Des valeurs comme
  `SANDRA_DESIRE_BOUNDED` ou `RESULT_SENT_ATTRACTION_NAMED` nomment un désir dans
  leur scène, mais aucune preuve ne dit que Marie et Player l’ont reconnu dans la
  proposition de reconfiguration.
- **Valeurs satisfaisantes/incompatibles :** non fermées.
- **Formule exacte :** `BLOCKED_PRODUCT_DECISION`.
- **Comportement si manque :** `false`; la reconfiguration tombe sur
  `PROVISIONAL_AGREEMENT` si l’entrée reste cohérente.
- **Décision/donnée absente :** liste des désirs admissibles et acte de
  reconnaissance par Marie/Player, distinct de l’existence d’une route.
- **Source canonique :** script J17 et N7-RP-04.
- **Conséquence N8 :** ne pas utiliser un niveau physique comme substitut à une
  reconnaissance.
- **Statut :** `BLOCKED_PRODUCT_DECISION`.

### 7.10 Audiences sûres ou réparées

- **Nom stable :** `J17_AUDIENCES_SAFE_OR_REPAIRED`.
- **Définition :** chaque audience privée pertinente est restée conforme ou sa
  violation explicite a reçu la réparation reconnue par son contrôleur.
- **Runtime disponible :** `traces[*].current_audience/current_state`,
  `fact_witness_saw_limited_trace`, promesse de notification contrôleur,
  `j14_controller_notified: bool`, résolutions J15/J16 ; types `Array`, `String`,
  `bool`, `Dictionary`.
- **Valeurs candidates :** absence d’événement de découverte, notice `PAID`, trace
  retirée ou audience inchangée. Informer le contrôleur ne définit pas à lui seul
  toute la réparation, et l’absence de découverte J14 ne prouve pas la sûreté de
  toutes les audiences.
- **Valeurs incompatibles candidates :** notice `FAILED`, mensonge renouvelé,
  contestation ; portée produit non fermée.
- **Formule exacte :** `BLOCKED_PRODUCT_DECISION`.
- **Comportement si manque :** `false` comme condition constructive ; ne pas
  conclure par absence d’incident observé.
- **Décision/donnée absente :** ensemble fermé des traces pertinentes et événement
  de réparation suffisant par type de brèche.
- **Source canonique :** registres d’audience, script J17 et N7-RP-04.
- **Conséquence N8 :** aucune agrégation ou compteur d’audiences.
- **Statut :** `BLOCKED_PRODUCT_DECISION`.

### 7.11 Pause acceptée

- **Nom stable :** `J17_EXTERNAL_PROGRESSION_PAUSE_ACCEPTED`.
- **Définition :** Marie et Player acceptent explicitement qu’aucune nouvelle étape
  extérieure n’ait lieu avant le checkpoint.
- **Runtime disponible :** choix `choice_j17_provisional`,
  `j17_couple_outcome: String` et record J17. Le texte actuel demande des règles
  révisables mais ne nomme ni pause ni checkpoint.
- **Valeurs satisfaisantes/incompatibles :** aucune preuve runtime actuelle ; la
  condition vaut donc `false` sur la baseline.
- **Formule actuelle exacte :** `false` faute de preuve explicite.
- **Comportement si manque :** `false`; fallback `PROVISIONAL_AGREEMENT`.
- **Décision/donnée absente :** acte authored autorisé par le périmètre N8 qui
  établit la pause avant la dérivation, ou décision que le choix existant la porte —
  décision qui n’est pas prise ici.
- **Source canonique :** script J17 et N7-RP-04.
- **Conséquence N8 :** la branche de reconfiguration est inatteignable tant que la
  preuve n’est pas validée.
- **Statut :** `BLOCKED_PRODUCT_DECISION` pour rendre la condition atteignable.

### 7.12 Droit complet de refus de Marie explicitement reconnu

- **Nom stable :** `J17_MARIE_FULL_REFUSAL_RIGHT_EXPLICITLY_ACKNOWLEDGED`.
- **Définition :** la proposition de reconfiguration reconnaît explicitement que
  Marie peut refuser la reconfiguration sans perdre ce droit préexistant.
- **Runtime disponible :** choix `choice_j17_provisional` et record J17 ; aucun
  champ ni fait n’enregistre cette reconnaissance.
- **Valeurs satisfaisantes/incompatibles :** aucune preuve runtime actuelle ; la
  condition vaut `false` sur la baseline. Le droit lui-même demeure vrai dans tous
  les états.
- **Formule actuelle exacte :** `false` faute de preuve explicite.
- **Comportement si manque :** `false`; fallback `PROVISIONAL_AGREEMENT`.
- **Décision/donnée absente :** événement authored précis de reconnaissance avant
  dérivation, distinct du droit invariant.
- **Source canonique :** script J17, contrat d’état et N7-RP-04.
- **Conséquence N8 :** ne jamais créer ou retirer le droit en calculant le prédicat ;
  la branche reste inatteignable avant validation de la preuve.
- **Statut :** `BLOCKED_PRODUCT_DECISION` pour rendre la condition atteignable.

## 8. Table exhaustive et ordonnée : quatre choix vers six états

L’ordre UI existant reste inchangé et ne doit pas être confondu avec l’ordre des
gardes : lorsque la discussion est due, l’interface présente
`choice_j17_reconquest`, puis `choice_j17_provisional`, puis
`choice_j17_separation`; lorsqu’elle est refusée ou non due, elle présente seulement
`choice_j17_refused_acknowledge`. Aucun cinquième ou sixième bouton n’est créé.

La condition « entrée valide » inclut la cohérence structurelle de la section 6.
Les gardes dommageables précèdent les conditions constructives ; les gardes
spécifiques précèdent le fallback du choix.

| Ordre | Choix et validité | Prédicats exacts | Sortie | Justification et fallback | Cas contradictoire | Test N8 ciblé |
|---:|---|---|---|---|---|---|
| 1 | `choice_j17_separation`; valide seulement si discussion due | Aucun prédicat narratif supplémentaire après validation | `SEPARATION` | Le choix explicite de fin prime ; aucun fallback. | Choix reçu sans promesse active ou avec résultat J16 refus/alternative : entrée invalide. | Séparation due ; historique conservé ; record/logistique présents. |
| 2 | `choice_j17_refused_acknowledge`; uniquement `J17_DISCUSSION_REFUSED_OR_NOT_DUE` | Formule section 7.1 | `FRACTURE` | Reconnaît que l’ancien cadre n’est plus disponible ; aucun fallback. | Si discussion due, refuser explicitement l’entrée et ne pas muter l’état. | Cas `REFUSE`, cas `ALTERNATIVE`, puis cas dû rejeté. |
| 3 | `choice_j17_reconquest` ou `choice_j17_provisional`; discussion due | `J17_MARIE_KNOWN_SEVERE_VIOLATION_UNREPAIRED` | `FRACTURE` | Une formulation favorable n’efface pas une violation grave non réparée. | Preuve absente/ambiguë : résolution bloquée, pas `FRACTURE` arbitraire. | Chaque fait grave approuvé ; priorité sur toutes les lignes suivantes ; cas de preuve incomplète rejeté. |
| 4 | Même validité que ligne 3 | `J17_MATERIAL_FACT_HIDDEN OR J17_INCOMPATIBLE_VERSION_ACTIVE` | `DOUBLE_LIFE_FRAGILE` | Couple matériellement maintenu sous contradiction ; après la ligne 3. | Si ligne 3 vraie aussi, ligne 3 gagne ; fait non qualifié matériel invalide le départage. | Fait caché seul, version active seule, les deux, et concurrence avec ligne 3. |
| 5 | `choice_j17_reconquest`; discussion due | `J17_REPEATED_MARIE_ACTS_PROVEN AND J17_SUFFICIENT_TRUTH_PROVEN AND J17_NO_ACTIVE_VIOLATION AND J17_CONCRETE_RULE_PROVEN` | `RECONQUEST_ACTIVE` | Les quatre preuves sont nécessaires ; le choix seul ne suffit pas. | Condition annoncée vraie sans preuve : entrée invalide. | Cas nominal ; une variante par condition constructive fausse ; guards précédents prioritaires. |
| 6 | `choice_j17_reconquest`; discussion due ; lignes 3–5 non retenues | Négation évaluée des gardes et au moins une condition constructive de ligne 5 fausse | `PROVISIONAL_AGREEMENT` | Fallback propre à la reconquête, jamais fallback d’une entrée invalide. | Prédicat non calculable n’est pas simplement faux si sa donnée est structurellement obligatoire. | Fallback pour chaque condition absente de façon valide ; données corrompues rejetées. |
| 7 | `choice_j17_provisional`; discussion due | `J17_EXTERNAL_DESIRE_ACKNOWLEDGED AND J17_AUDIENCES_SAFE_OR_REPAIRED AND J17_EXTERNAL_PROGRESSION_PAUSE_ACCEPTED AND J17_MARIE_FULL_REFUSAL_RIGHT_EXPLICITLY_ACKNOWLEDGED` | `RECONFIGURATION_NEGOTIATION` | Négociation sans ouverture automatique ; quatre preuves requises. | Droit ou pause supposé par le label du choix : interdit ; guards 3–4 restent prioritaires. | Cas nominal ; une variante par condition fausse ; aucune permission de tiers créée. |
| 8 | `choice_j17_provisional`; discussion due ; lignes 3, 4 et 7 non retenues | Négation évaluée des gardes et au moins une condition constructive de ligne 7 fausse | `PROVISIONAL_AGREEMENT` | Fallback propre au choix provisoire. | Entrée invalide ou preuve obligatoire contradictoire : aucun fallback. | Fallback par condition constructive ; corruption et choix inconnu rejetés. |

Un identifiant de choix inconnu est refusé explicitement. Il ne produit aucun état.

### 8.1 Situation exécutable actuelle

La ligne 1 et la validité de la ligne 2 sont calculables. Les lignes 3 à 8 ne sont
pas implémentables de façon complète tant que les décisions de la section 7 ne sont
pas fermées. N8 ne peut donc pas commencer sur ce contrat au statut actuel.

## 9. Record de continuité minimal attendu pour N8

Le support naturel est l’actuel
`traces["j17_couple_definition_record_01"]`, un `FACT_RECORD` déjà persisté dans le
snapshot de `Season1State`. N8 doit l’enrichir de façon bornée, sans créer de journal
générique.

| Champ du record | Type | Statut baseline | Contrat N8 |
|---|---|---|---|
| `trace_id` | `String` | existe | Conserver `j17_couple_definition_record_01`. |
| `record_type` | `String` | existe | Conserver `FACT_RECORD`. |
| `source_day` | `String` | existe | Conserver `J17` comme projection informative. |
| `choice_id` | `String` | absent | Ajouter l’identifiant exact parmi les quatre choix de couple. |
| `couple_state` | `String` | existe | Stocker exactement l’un des six états canoniques. |
| `discussion_was_due` | `bool` | existe | Conserver ; doit correspondre au résultat J16 et à la promesse. |
| `triggered_guard_fact_ids` | `Array[String]` | absent | Ajouter une liste fermée de faits réellement présents ayant déclenché les lignes 3 ou 4 ; vide pour les autres sorties. Les identifiants admissibles restent bloqués par les décisions produit de la section 7. |
| `satisfied_constructive_condition_ids` | `Array[String]` | absent | Ajouter uniquement les noms stables des conditions effectivement prouvées ; aucune condition implicite. |
| `mathilde_micro_return_delivered` | `bool` | absent | Ajouter ; `true` seulement après insertion effective du micro-retour dans le fil Mathilde. |
| `marie_micro_return_delivered` | `bool` | absent | Ajouter ; `true` seulement après insertion effective du micro-retour dans le fil Marie. |
| `temporal_projection` | `Dictionary` fermé | absent ; seul `source_day` existe | Ajouter `day_id`, `departure_at`, `couple_discussion_due_at` et `resolved_at`. `day_id` vaut `J17`, `departure_at` reprend `J17 17:30`, la fenêtre due reprend `J17 20:30–21:30` ou reste absente si non due, et `resolved_at` est l’horloge effective du provider au succès, jamais une heure inventée par le résolveur. |
| `current_state` | `String` | existe | Conserver `ACTIVE`. |
| `visual_asset` | `String` | existe | Conserver `none`. |

Le record n’est ni un score, ni un journal A1, ni une route, ni une sauvegarde
disque, ni un résumé psychologique. Les tableaux `promises`, `obligations`, `traces`
et `knowledge` restent les sources des preuves ; le record référence les faits qui
ont effectivement décidé J17 et ne les recopie pas en prose.

### 9.1 Contrat des deux micro-retours

| Retour | Position | Contenu fonctionnel obligatoire | Interdits | Marqueur |
|---|---|---|---|---|
| Mathilde | Dans `thread_mathilde_private`, après l’application du choix de départ et avant la conversation de couple | Confirmer seulement départ, aide ou distance, état pratique et absence de réinterprétation relationnelle | nouveau choix, scène, asset, promesse amoureuse, disponibilité future | `mathilde_micro_return_delivered` |
| Marie | Dans `thread_marie_private`, après dérivation et enregistrement de l’état | Nommer naturellement le statut provisoire réel, la règle/limite immédiate et le checkpoint, la conséquence ou la logistique suivante | label décidé par le seul texte du choix, pardon rétroactif, finale de saison, nouvelle permission extérieure | `marie_micro_return_delivered` |

Le retour Marie varie selon les six états : logistique de fin pour `SEPARATION`,
cadre retiré pour `FRACTURE`, contradiction non résolue pour
`DOUBLE_LIFE_FRAGILE`, règle et revue pour `PROVISIONAL_AGREEMENT`, tentative sans
pardon pour `RECONQUEST_ACTIVE`, négociation sans permission et avec refus intact
pour `RECONFIGURATION_NEGOTIATION`.

## 10. Projection informative J01–J21

Chaque ligne correspond au provider et à la runtime map réels. Dans la colonne
abrégée, les providers résident sous `game/scripts/runtime/season_1/` et les maps
sous `game/data/runtime/season_1/`. Pour J01–J10, les maps ne déclarent pas la clé
`implementation_status`, mais les providers, données, tests et la chaîne
`Season1RuntimeProvider` sont présents. J11–J21 déclarent `PLAYABLE`.

| Jour projeté | Mouvement | Séquences canoniques projetées | Provider / runtime map | État du contenu | Dépendance utile à J17 | Contradiction ou décalage documentaire |
|---|---|---|---|---|---|---|
| J01 | I | `S01`, fonction Marie `S02`, ouverture `S03` | `J01RuntimeProvider.gd` / `j01_runtime_map.json` | Runtime présent ; statut absent de la map | Présence/promesse initiale Marie, fait de couple | Ancien jour fixe ; les séquences restent indépendantes. |
| J02 | I | `S04` | `J02RuntimeProvider.gd` / `j02_runtime_map.json` | Runtime présent ; statut absent | Acte « faire de la place », arrivée Mathilde | Le foyer est projection, pas identité de `S04`. |
| J03 | I | `S06`, écho `S03`, retour Marie | `J03RuntimeProvider.gd` / `j03_runtime_map.json` | Runtime présent ; statut absent | Retour Marie, traces Sandra/Raphaëlle | Plusieurs séquences partagent le jour. |
| J04 | I | `S05`, `S07`, fermeture `S01` | `J04RuntimeProvider.gd` / `j04_runtime_map.json` | Runtime présent ; statut absent | Réseau public, Nico, foyer | Fin de mouvement par fonction, non par numéro. |
| J05 | II | `S08` et slot `S09`/`S10`/`S12` | `J05RuntimeProvider.gd` / `j05_runtime_map.json` | Runtime présent ; statut absent | Heure partagée Marie ; continuité Sandra | Le slot authored n’est pas une route persistée. |
| J06 | II | pivot `S09`/`S10`/`S11`/`S12` | `J06RuntimeProvider.gd` / `j06_runtime_map.json` | Runtime présent ; statut absent | Retour concret Marie ; proximité Mathilde | Projection variable liée aux champs J06. |
| J07 | II | `S13`, ou continuité `S11`/`S12` | `J07RuntimeProvider.gd` / `j07_runtime_map.json` | Runtime présent ; statut absent | Demande de foyer Marie, promesses de présence | Identifiants et échéances encore liés au jour. |
| J08 | II | `S14` | `J08RuntimeProvider.gd` / `j08_runtime_map.json` | Runtime présent ; statut absent | Paiement/échec foyer, écho Marie | La superposition est canonique, J08 informatif. |
| J09 | III | `S15` | `J09RuntimeProvider.gd` / `j09_runtime_map.json` | Runtime présent ; statut absent | Présence Marie, dîner, apparition possible de `STRAIN_VISIBLE` | Mouvement III commence par fonction d’exploration. |
| J10 | III | `S16`, `S17`, `S18`, `S21` ou `S22` selon pivot | `J10RuntimeProvider.gd` / `j10_runtime_map.json` | Runtime présent ; statut absent | Résolution dîner Marie, sélection du pivot J11 | L’ancien acte III/J10 ne fixe pas l’identité de ces séquences. |
| J11 | III | `S19`, `S20`, `S18`, `S21`, `S22`, payoff Marie conditionnel | `J11RuntimeProvider.gd` / `j11_runtime_map.json` | `PLAYABLE` | Niveau physique, aftercares, acte/reconnexion Marie | Plusieurs payoffs authored sont comprimés dans un pivot journalier. N8 ne les modifie pas. |
| J12 | IV | `S23` | `J12RuntimeProvider.gd` / `j12_runtime_map.json` | `PLAYABLE` | Traitement aftercare échoué, présence Marie, audiences publiques | Ancien document classe J12 dans l’acte III ; N7.1 rattache `S23` au mouvement IV. |
| J13 | IV | `S24`, `S25` ou `S26` | `J13RuntimeProvider.gd` / `j13_runtime_map.json` | `PLAYABLE` | Trace sélectionnée pour J14, version privée/alibi | Le pivot journalier est une projection technique. |
| J14 | IV | `S27` | `J14RuntimeProvider.gd` / `j14_runtime_map.json` | `PLAYABLE` | Mensonge/minimisation, témoin, audience et notification | La mutation sans découverte ne prouve ni vérité complète ni audience globalement sûre. |
| J15 | IV | `S28` | `J15RuntimeProvider.gd` / `j15_runtime_map.json` | `PLAYABLE` | Paiement, refus ou mensonge de clarification ; urgence J16 | Résolution locale non équivalente à une réparation globale. |
| J16 | IV → V | conséquences de `S28`, préparation historique `S31`/`S29` | `J16RuntimeProvider.gd` / `j16_runtime_map.json` | `PLAYABLE` | Paiement/contestation, départ, acceptation/refus/alternative J17 | Aucune séquence autonome nouvelle ; journée de pont. |
| J17 | V | `S31` puis `S29` réinterprété comme clarification intermédiaire | `J17RuntimeProvider.gd` / `j17_runtime_map.json` | `PLAYABLE`, sémantiquement incomplet | Quatre choix, état provisoire, record et deux micro-retours | Runtime produit quatre sorties directes, pas six ; J17 n’est pas la finale. |
| J18 | V | `S30` | `J18RuntimeProvider.gd` / `j18_runtime_map.json` | `PLAYABLE` | Conséquence Sandra en aval | Aftercare Sandra canonique absent du runtime ; hors N8. |
| J19 | V | `S32`, `S33` | `J19RuntimeProvider.gd` / `j19_runtime_map.json` | `PLAYABLE` | Résolutions Pauline/Raphaëlle en aval | Compression en foreground/secondary ; hors N8. |
| J20 | V | `S34`, sélection de trace | `J20RuntimeProvider.gd` / `j20_runtime_map.json` | `PLAYABLE` | Résolution Nico et trace finale en aval | La trace est choisie avant J21 ; elle ne décide pas le couple. |
| J21 | V | fonction `S35` : trace/posture et dernière image | `J21RuntimeProvider.gd` / `j21_runtime_map.json` | `PLAYABLE`, finale structurellement incomplète | Consommateur des six états ; aucune entrée N8 | Conversation finale autonome absente ; N8 ne touche pas J21. |

Les noms de fichiers `chapter_NN_*`, les segments `jNN_*`, les champs J01–J21,
les providers, les runtime maps et les heures de messages restent temporairement
liés aux jours. Les horaires, échéances, absences et rendez-vous peuvent rester
purement diégétiques. Le découplage général des identités de contenu, providers et
champs `jNN_*` appartient à un futur lot distinct. N8 ne touche à aucun de ces
éléments hors de J17 et ne recommande aucune migration générale.

## 11. Gouvernance documentaire réconciliée

Les statuts de cette table sont ceux exigés par N7.1 : `Canon`, `Runtime`,
`Archive`, `À réécrire`.

| Document réel | Statut | Autorité retenue et usage encore valide | Éléments supersédés | Effet sur N8 |
|---|---|---|---|---|
| `docs/narrative/R8C_N7_1_SEASON_STRUCTURE_RUNTIME_PROJECTION_AND_N8_ENTRY_CONTRACT.md` | Canon | Autorité N7.1 sur structure, projection J17, vocabulaire, blockers et entrée N8 ; statut produit encore bloqué. | Aucun document antérieur ne peut compléter silencieusement une formule manquante. | N8 attend sa revue et la fermeture des décisions. |
| `docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md` | Canon | Autorité sur les sources et statuts documentaires. | Aucun. | Impose code/données/tests comme vérité d’exécution. |
| `docs/canon/bible/14_CONTRAT_NARRATIF_SAISON_1_RECONCILIE.md` | Canon | Autorité supérieure sur cinq mouvements, centralité Marie/Player et ordre final. | Ancienne finale confondue avec J17/J21. | Interdit de faire de J17 une finale et interdit le cutover opportuniste. |
| `docs/canon/bible/04_TRAME_PRINCIPALE_ET_ACTES_SAISON_1.md` | À réécrire | Conserve phrase directrice et matière dramatique. | Quotas/ancienne formulation d’actes lorsque contradictoires avec `14`. | Aucune implémentation directe. |
| `docs/canon/bible/07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md` | À réécrire | Catalogue authored `S01–S35`, fonctions et dépendances. | `S29` comme conversation décidant le couple final ; articulation finale incomplète. | Sert à nommer la matière, jamais à modifier A6. |
| `docs/canon/bible/11_DISTRIBUTION_SEQUENCES_SCENES_IMAGES_CONSEQUENCES_JOURNEES.md` | À réécrire | Source informative de la projection historique J01–J21. | Jours comme architecture durable ; J12 dans ancien acte III ; J17/J21 comme identités de fin. | N8 conserve J17 technique sans généraliser le calendrier. |
| `docs/canon/bible/12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md` | À réécrire | Ancien plan détaillé J01–J08 utile pour provenance. | Découpage par bloc comme autorité structurelle. | Lecture seulement pour preuves antérieures. |
| `docs/canon/bible/12B_PLANS_SCENES_J09_J12.md` | À réécrire | Ancien plan J09–J12 utile aux faits Marie/J11/J12. | Bloc de jours et ancien passage d’acte. | Lecture seulement ; N8 ne modifie pas J09–J12. |
| `docs/canon/bible/12C_PLANS_SCENES_J13_J16.md` | À réécrire | Ancien plan des conséquences J13–J16. | Jour fixe comme identité. | Source secondaire, toujours vérifiée contre runtime. |
| `docs/canon/bible/12D_PLANS_SCENES_J17_J21.md` | À réécrire | Matière des résolutions tardives. | J17 résolution finale et ancien vocabulaire de couple. | Ne complète aucun prédicat absent. |
| `docs/canon/bible/12E_AUDIT_GLOBAL_COHERENCE_J01_J21.md` | Archive | Mémoire de cohérence du corpus par jours. | Verdict de complétude structurelle antérieur au contrat `14` et à N7. | Aucun. |
| `docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md` | À réécrire | Source pré-runtime des six sorties, règles, retours et logistique. | J17 comme décision de saison ; conditions non traduites en champs fermés. | Source sémantique des micro-retours, pas formule exécutable. |
| `docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md` | À réécrire | Matière de soirée, trace et sorties. | Projection/ordre ne satisfaisant pas la conversation finale autonome. | Hors allowlist N8. |
| `docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md` | Canon | Signoff du corpus historique J01–J21. | Ne prouve pas la conformité au contrat final plus récent. | Empêche une réouverture globale ; n’autorise que le correctif ciblé. |
| `docs/canon/dialogues/J01_J21_REACHABILITY_MATRIX.md` | À réécrire | Matrice historique des états et conséquences. | Ancien identifiant de reconfiguration et conditions non projetées sur le runtime. | Source de tests, vocabulaire remplacé par N7.1. |
| `docs/canon/dialogues/J01_J21_PROMISE_REGISTRY.md` | Canon | Identités, échéances et statuts des promesses. | Les promesses absentes du runtime ne sont pas réputées présentes. | Vérifier les preuves réelles avant toute formule. |
| `docs/canon/dialogues/J01_J21_TRACE_REGISTRY.md` | Canon | Sémantique des traces/audiences et de la trace finale. | Aucun droit média implicite. | Les preuves restent référencées, jamais résumées par score. |
| `docs/canon/dialogues/J01_J21_KNOWLEDGE_REGISTRY.md` | Canon | Sémantique des connaissances et knowers. | Toute connaissance non matérialisée dans `Season1State` reste absente du calcul N8. | Borne « Marie sait ». |
| `docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md` | À réécrire | Vocabulaire qualitatif et registres attendus. | Identifiant de reconfiguration antérieur, champs futurs non présents, finale trop liée à J21. | Ne pas importer ses champs absents ; adapter seulement le record J17 validé. |
| `docs/canon/dialogues/NAR_PROD_02_PAQUET_PRODUCTION_ACTE_I_J01_J04.md` | Archive | Ancien paquet de production du bloc J01–J04. | Bloc de jours comme structure. | Aucun. |
| `docs/canon/dialogues/NAR_PROD_03_PAQUET_PRODUCTION_ACTE_II_J05_J08.md` | Archive | Ancien paquet J05–J08. | Ancien découpage acte/jours. | Aucun. |
| `docs/canon/dialogues/NAR_PROD_04_PAQUET_PRODUCTION_ACTE_III_J09_J12.md` | Archive | Ancien paquet J09–J12. | Classement de J12 antérieur aux mouvements N7.1. | Aucun. |
| `docs/canon/dialogues/NAR_PROD_05_PAQUET_PRODUCTION_ACTE_IV_J13_J16.md` | Archive | Ancien paquet J13–J16. | Bloc journalier comme identité. | Aucun. |
| `docs/canon/dialogues/NAR_PROD_06_PAQUET_PRODUCTION_ACTE_V_J17_J21.md` | À réécrire | Budget/production de l’ancien acte V ; verdict visuel `NO_NEW_ASSET` encore utile. | J21 `READY` ne prouve pas la présence de la finale autonome. | Confirme qu’aucun asset N8 n’est requis. |
| `docs/narrative/R8C_N6_CANONICAL_SCENE_PORTFOLIO_INVENTORY.md` | Canon | Inventaire de scènes et mouvements, état de production. | Ne décide ni runtime ni prédicats J17. | Borne le portefeuille ; aucune migration. |
| `docs/narrative/R8C_N6_CONTENT_PRODUCTION_FORECAST_AND_ROADMAP.md` | À réécrire | Prévision N6 et dépendances de production encore traçables. | Ordre antérieur à N7/N7.1. | Ne gouverne pas l’entrée N8. |
| `docs/narrative/R8C_N7_J17_J21_CONTINUITY_AND_AFTERCARE_PLAN.md` | Canon | Décide quatre choix, six sorties, deux micro-retours et ordre final. | Notions de prédicats non traduites en formules runtime ; identité finale non fixée. | Source produit, complétée et bloquée par N7.1. |
| `docs/narrative/R8C_N7_REVISION_PACKETS_AND_ACCEPTANCE_GATES.md` | Canon | Décide le paquet N7-RP-04, l’ordre des huit lignes et le périmètre. | `READY_FOR_SCRIPTING` ne suffit pas à l’entrée runtime sans données fermées. | N8 attend les décisions de prédicats. |
| `docs/narrative/R8C_N7_W4_PAYOFF_WRITTEN_RECONCILIATION.md` | Canon | Autorité N7 sur les payoffs W4 et aftercares associés. | Aucun effet d’autorisation sur N8. | Payoffs W4 explicitement hors périmètre. |
| `ROADMAP.md` | À réécrire | Mémoire de l’ordre A4/cutover. | Baseline et roadmap ne mentionnent pas N7/N8. | Ne peut pas élargir N8 ni déclencher A1–A10. |
| `docs/PROJECT_STATE.md` | À réécrire | Constate le runtime J01–J21 et l’absence de sauvegarde fichier. | Baseline/phase A4 anciennes. | Confirme seulement l’oracle historique. |
| `docs/canon/NARRATIVE_CANON_STATUS.md` | À réécrire | Confirme corpus/runtime présents. | « aucun bloqueur narratif » contredit le raccord final et les décisions N7.1. | N8 ne peut pas s’appuyer sur ce verdict global. |
| `docs/canon/DOCUMENTATION_READING_ORDER.md` | Canon | Index actif des autorités narrative/runtime. | N7.1 n’y est pas encore indexé, volontairement dans ce lot. | Aucun index modifié ; N8 suit directement ce contrat validé. |
| `docs/architecture/README.md` | Canon | Index A1–A10 et frontière oracle historique/prototype futur. | Aucun. | Autorité de l’interdiction de cutover. |
| `docs/runtime/README.md` | Runtime | Portail de la chaîne `Season1RuntimeProvider` J01–J21 et de l’absence de sauvegarde disque. | Ne définit ni structure canonique ni formule produit. | Confirme que N8 reste dans l’oracle historique et le snapshot mémoire. |
| `docs/CURRENT_NARRATIVE_SOURCE_OF_TRUTH.md` | Archive | Portail V0.xx explicitement historique. | Toutes prétentions de courant. | Aucun. |

Aucun document attendu nommé « contrat N8 approuvé » n’existe sur la baseline.
Aucun fichier dédié ne porte encore l’identité
`s1_m5_marie_player_final_conversation`; sa fonction est répartie entre le contrat
`14`, les sources J17/J21 et N7. Ce document n’en crée pas et ne s’attribue pas
l’approbation produit.

## 12. Décision d’architecture et proposition d’allowlist N8

### 12.1 Décision

Le runtime historique sait présenter le corpus réel ; A1–A10 porte un modèle futur
plus durable mais reste déconnecté de Messages, Galerie, PhotoViewer et de la Saison
1 active. N8 corrige donc exclusivement la projection J17 de `Season1State` et son
provider. Il ne prépare aucun cutover.

### 12.2 Allowlist proposée, à valider produit

| Chemin réel | Modification N8 strictement autorisable |
|---|---|
| `game/scripts/runtime/season_1/Season1State.gd` | Résolveur ordonné, validation des quatre choix, six sorties, enrichissement/validation/snapshot du record J17. |
| `game/scripts/runtime/season_1/J17RuntimeProvider.gd` | Livraison conditionnelle et idempotente des deux micro-retours, sans nouveau point UI. |
| `game/data/conversations/chapter_17_departure_and_couple.json` | Données textuelles strictement nécessaires aux deux micro-retours dans les fils existants ; aucun nouveau choix/segment autonome/asset. |
| `tests/test_runtime_s1_17_j17_playable_static.py` | Contrat statique des quatre choix, six états, record et interdits. |
| `game/tests/RUNTIME_S1_17J17PlayableSmokeDriver.gd` | Cas ciblés du résolveur, micro-retours et absence de mutation sur entrée invalide. |
| `game/tests/RUNTIME_S1_J16J21ProviderSnapshotSmokeDriver.gd` | Round-trip ciblé des marqueurs et du record enrichi, sans modification J21. |

Cette allowlist n’est pas une autorisation d’implémenter : elle devient applicable
seulement après validation produit et fermeture des blockers. Aucun nouveau fichier
de test n’est nécessaire dans la proposition actuelle.

### 12.3 Denylist N8

N8 ne modifie pas : A1–A10 ; `Season1RuntimeProvider.gd` ; les providers hors J17 ;
J21 ; les payoffs W4 ; les assets ; Galerie ; PhotoViewer ; UI ; layouts ; sauvegarde
disque ; runtime général ; autres conversations ; contrat général de contenu ;
formats généraux de données ; bundles A6.

Il ne crée aucun adaptateur général, double écriture, projection A6, exécuteur de
séquences, migration de corpus ou abstraction de cutover.

## 13. Tests ciblés attendus pour N8

Sans lancer N8 dans ce lot, la future validation doit couvrir :

1. les quatre identifiants de choix et leur ordre UI inchangés ;
2. chaque ligne de la table ordonnée, dont la priorité `FRACTURE` avant
   `DOUBLE_LIFE_FRAGILE` puis avant les conditions constructives ;
3. les six sorties, aucune septième valeur et aucun fallback pour choix inconnu ;
4. refus explicite de `choice_j17_refused_acknowledge` lorsque la discussion est due ;
5. refus des trois choix due-only lorsque la discussion est refusée/non due ;
6. refus sans mutation pour promesse/champ/preuve absent ou contradictoire ;
7. reconquête positive avec toutes les preuves et fallback pour chaque condition
   constructive fausse dans une entrée valide ;
8. reconfiguration positive avec les quatre preuves et fallback pour chaque
   condition fausse ;
9. historique dommageable jamais effacé par le libellé du choix ;
10. droit de refus de Marie invariant dans les six états ;
11. record contenant choix exact, état, faits de garde, conditions prouvées,
    marqueurs et projection temporelle ;
12. micro-retour Mathilde puis micro-retour Marie, chacun exactement une fois,
    idempotents après snapshot/restore et sans choix supplémentaire ;
13. round-trip de snapshot du record enrichi et rejet d’un record mal formé ;
14. aucun changement de J18–J21, A1–A10, Galerie, PhotoViewer, UI ou assets.

## 14. Gates d’entrée N8

| Gate | État N7.1 | Motif |
|---|---|---|
| Hiérarchie canonique complète | Fixée | Section 2. |
| Cinq mouvements | Fixés | Section 2.1. |
| Identité finale distincte | Fixée | Section 3.2 ; aucune collision. |
| Six états | Fixés | Section 4. |
| Mapping champs réels | Audité | Sections 5 et 7. |
| Formules exactes des prédicats | Bloqué | Une seule notion pleinement calculable ; décisions section 7. |
| Table quatre choix/six états | Fixée normativement, non exécutable | Section 8. |
| Cas invalides/données absentes | Fixés | Sections 6–8. |
| Record minimal | Fixé sous réserve des identifiants de preuve | Section 9. |
| Deux micro-retours | Fixés fonctionnellement | Section 9.1. |
| Projection J01–J21 informative | Fixée | Section 10. |
| Gouvernance documentaire | Fixée | Section 11. |
| Allowlist N8 | Proposée, à valider | Section 12.2. |
| Tests ciblés | Fixés | Section 13. |
| Aucun cutover A1–A10 | Fixé | Sections 1 et 12. |

### 14.1 Décisions produit bloquantes consolidées

Le produit doit valider, sans score ni compteur :

1. la liste fermée des violations graves, la preuve de connaissance par Marie et
   la réparation suffisante pour chacune ;
2. la liste fermée des faits matériels, leur obligation de divulgation et leur
   preuve de divulgation ;
3. les paires version/fait incompatibles et leurs événements de clôture ;
4. les combinaisons authored fermées d’actes répétés envers Marie ;
5. la définition de vérité suffisante par faits dus ;
6. le vocabulaire fermé et la preuve d’acceptation d’une règle concrète ;
7. la preuve que le désir extérieur a été reconnu par Marie/Player ;
8. l’ensemble d’audiences pertinent et la réparation suffisante par brèche ;
9. l’acte authored, antérieur à la dérivation, qui prouve la pause ;
10. l’acte authored, antérieur à la dérivation, qui prouve la reconnaissance
    explicite du droit de refus ;
11. les identifiants de preuve fermés autorisés dans le record ;
12. l’allowlist proposée.

Tant que ces décisions ne sont pas verrouillées, le statut reste :

`SEASON_RUNTIME_PROJECTION_CONTRACT_BLOCKED`

Le statut `SEASON_RUNTIME_PROJECTION_CONTRACT_APPROVED` ne peut être attribué que
par la revue produit. Aucun travail N8 ou A1–A10 n’est autorisé par la présente
livraison.
