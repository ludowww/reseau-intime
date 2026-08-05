# R8C-N9 — Contrat authored des payoffs W4, aftercares et continuité vers J21

> **Projet :** `ludowww/reseau-intime`
>
> **Baseline vérifiée :** `18261885d60845ed2e2138973e1c3f4180c697b1`
>
> **Tag stable vérifié :** `r8c-n8-j17-six-state-runtime-resolution`
>
> **Branche de livraison :** `work/r8c-n9-w4-payoff-aftercare-j21-continuity-contract`
>
> **Statut final :** `W4_PAYOFF_AFTERCARE_J21_CONTINUITY_CONTRACT_APPROVED`
>
> **Approbation produit :** commit revu `81ba4070d5b032c935b5c85c67b3f560c1c9c101` ; approuvé sans réserve ; août 2026.
>
> **Nature :** contrat documentaire autoritatif ; aucune écriture finale W4, aucun dialogue final, aucune implémentation J21.

## 1. Verdict, portée et autorité

Le présent document ferme le contrat authored des trois payoffs W4 suivants et de
leurs conséquences :

| Identité authored durable | Alias historiques de projection | Parent actuel | Payoff | Sortie visuelle / aftercare |
|---|---|---|---|---|
| payoff W4 Marie/Player `#051` | `N7-PAY-MARIE-J11-051`, `MARIE_J11_RECONQUEST` | `C11-06` | `S1_A3_J11_SCN_MARIE_RECONQUEST_ADULT_PAYOFF_01` | `#052` — `S1_A3_J11_SCN_MARIE_RECONQUEST_AFTERCARE_01` |
| payoff W4 Mathilde/Player `#045` | `N7-PAY-MATHILDE-J11-045`, `MATHILDE_J11_SECRET_INTIMACY` | `C11-03` | `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_CENTRAL_01` | `#046` — `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_AFTERCARE_01` |
| payoff W4 Sandra/Player `#079` | `N7-PAY-SANDRA-J18-079`, `SANDRA_J18_LATE_INTIMACY` | branche adulte de `C18-02` | `S1_A5_J18_SCN_SANDRA_LATE_INTIMACY_CENTRAL_01` | `#080` — `S1_A5_J18_SCN_SANDRA_FINAL_STATE_01_LATE_INTIMACY_AFTERCARE` |

Les numéros de jour présents dans certains identifiants existants restent des
aliases historiques opaques. Ils ne définissent ni l'identité canonique du payoff,
ni son ordre durable. Si la projection temporelle change, les trois identités de la
première colonne et leurs relations authored restent inchangées.

Le contrat applique l'ordre d'autorité suivant sur les périmètres concernés :

1. `docs/narrative/R8C_N7_1_SEASON_STRUCTURE_RUNTIME_PROJECTION_AND_N8_ENTRY_CONTRACT.md` pour la hiérarchie authored, la projection et le contrat J17/J21 ;
2. `docs/narrative/R8C_N7_W4_PAYOFF_WRITTEN_RECONCILIATION.md`, `docs/narrative/R8C_N7_J17_J21_CONTINUITY_AND_AFTERCARE_PLAN.md` et `docs/narrative/R8C_N7_REVISION_PACKETS_AND_ACCEPTANCE_GATES.md` pour les payoffs, aftercares et raccords ;
3. l'implémentation N8 dans `game/scripts/runtime/season_1/Season1State.gd`, `game/scripts/runtime/season_1/J17RuntimeProvider.gd`, `game/data/conversations/chapter_17_departure_and_couple.json`, `game/tests/RUNTIME_S1_17J17PlayableSmokeDriver.gd` et `tests/test_runtime_s1_17_j17_playable_static.py` pour la réalité runtime J17 ;
4. les documents N6 et les canons/scripts signés pour les détails non supersédés.

Aucune contradiction ne requiert `BLOCKED_PRODUCT_DECISION`. L'ancien
`docs/canon/dialogues/NAR_ADULT_02_PAYOFF_SANDRA_J18.md` indiquait que le type exact
d'acte n'était pas verrouillé ; N7, plus récent sur ce périmètre, le supersède par la
décision canonique explicite reprise en section 6. Les scripts historiques restent
inchangés et traçables.

## 2. Frontière authored, projection et runtime

La hiérarchie normative est :

`Saison → mouvement dramatique → séquence authored → scène ou beat → dialogue → média → conséquence → projection temporelle`

| Couche | Ce que N9 verrouille | Ce que N9 ne fait pas |
|---|---|---|
| Canon authored | Identité, fonction, préconditions, actes autorisés, limites, aftercare, faits, audiences, conséquences et transport | Aucun dialogue complet ; aucune nouvelle route ; aucun quatrième payoff |
| Projection temporelle | Marie et Mathilde actuellement projetées sur J11 avec retombées J12/J17 ; Sandra actuellement projetée sur J18 avec aftercare prioritaire J19 ; rappel possible J21 | Le jour n'identifie pas la séquence et ne crée pas une dette si l'occasion n'a jamais été proposée |
| Runtime actuel | Marie/Mathilde : états et obligations existants ; J17 : six états, huit règles et deux micro-retours N8 ; Sandra adulte/J19 : absence runtime constatée | Aucun changement de `Season1State`, conversation, map, provider, test, scène ou asset |
| Runtime futur | Doit projeter le contrat sans score et sans inférer d'audience, de consentement ou de pardon | N9 n'alloue aucun nouvel identifiant machine et n'autorise aucun cutover A1–A10 |

Les médias `#045`, `#046`, `#051`, `#052`, `#079` et `#080` sont des images de
scène non diégétiques. Ils peuvent mémoriser pour le joueur une séquence réellement
vécue ; ils ne sont jamais un fichier possédé par Player, une preuve accessible à un
personnage, une photographie prise dans la fiction ou une autorisation de diffusion.

## 3. Sources réconciliées

### 3.1 Sources transversales

- `docs/narrative/R8C_N7_1_SEASON_STRUCTURE_RUNTIME_PROJECTION_AND_N8_ENTRY_CONTRACT.md` — contrat approuvé de structure, six états, huit règles et identité `s1_m5_marie_player_final_conversation`.
- `docs/narrative/R8C_N7_W4_PAYOFF_WRITTEN_RECONCILIATION.md` — trois payoffs W4, chaînes d'images et aftercares.
- `docs/narrative/R8C_N7_J17_J21_CONTINUITY_AND_AFTERCARE_PLAN.md` — transport J17/J21, priorité Sandra J19, zéro nouveau fichier J21.
- `docs/narrative/R8C_N7_REVISION_PACKETS_AND_ACCEPTANCE_GATES.md` — préconditions, beats, choix, interdits et gates prêts pour scriptage.
- `docs/narrative/R8C_N6_CANONICAL_SCENE_PORTFOLIO_INVENTORY.md` — portefeuille des séquences et projection J01–J21.
- `docs/narrative/R8C_N6_CONTENT_PRODUCTION_FORECAST_AND_ROADMAP.md` — dépendances de production et zéro nouveau fichier J21.
- `docs/narrative/R8C_N6_VISUAL_REWARD_AND_PHOTO_COVERAGE_AUDIT.md` — inventaire exact des 84 fichiers, niveaux V/NV et rôles média.
- `docs/narrative/R8C_N6_EROTIC_AND_PORNOGRAPHIC_PROGRESSION_MAP.md` — niveaux W et progression par personnage.
- `docs/canon/dialogues/ASSET_01_MANIFESTE_PRODUCTION_VISUELLE_SAISON_1_84_FICHIERS.md` — manifeste des six identifiants physiques concernés.
- `docs/canon/bible/14_CONTRAT_NARRATIF_SAISON_1_RECONCILIE.md` — ordre de la finale et autonomie de la conversation Marie/Player.
- `docs/canon/bible/07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md` — mouvements et séquences `S19`, `S20`, `S29`, `S30`, `S31`, `S35`.

### 3.2 Sources Marie et Mathilde

- `docs/canon/dialogues/NAR_ADULT_01_PAYOFFS_J11_MARIE_MATHILDE.md`.
- `docs/canon/dialogues/J11_SCRIPT_NARRATIF_COMPLET.md`.
- `docs/canon/dialogues/J12_SCRIPT_NARRATIF_COMPLET.md`.
- `docs/canon/dialogues/NAR_PROD_04_PAQUET_PRODUCTION_ACTE_III_J09_J12.md`.
- `docs/canon/characters/MARIE_CANON_FULL.md`.
- `docs/canon/characters/MATHILDE_CANON_FULL.md`.
- `game/data/conversations/chapter_11_marie_return.json`.
- `game/data/conversations/chapter_11_mathilde_return.json`.
- `game/data/conversations/chapter_12_obligations.json`.
- `game/data/runtime/season_1/j11_runtime_map.json`.
- `game/data/runtime/season_1/j12_runtime_map.json`.

### 3.3 Sources Sandra et fin de saison

- `docs/canon/dialogues/NAR_ADULT_02_PAYOFF_SANDRA_J18.md`.
- `docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md`.
- `docs/canon/dialogues/J18_SCRIPT_NARRATIF_COMPLET.md`.
- `docs/canon/dialogues/J19_SCRIPT_NARRATIF_COMPLET.md`.
- `docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md`.
- `docs/canon/dialogues/NAR_PROD_06_PAQUET_PRODUCTION_ACTE_V_J17_J21.md`.
- `docs/canon/characters/SANDRA_CANON_FULL.md`.
- `game/data/conversations/chapter_18_sandra_resolution.json`.
- `game/data/conversations/chapter_19_private_versions.json`.
- `game/data/conversations/chapter_21_final_trace.json`.
- `game/data/runtime/season_1/j18_runtime_map.json`.
- `game/data/runtime/season_1/j19_runtime_map.json`.
- `game/data/runtime/season_1/j21_runtime_map.json`.

## 4. Invariants communs des trois payoffs

1. Marie, Mathilde, Sandra et Player sont adultes.
2. Le consentement est `CONSENTED_PRIVATE`, spécifique à la scène, actuel, explicite, révocable et vérifié à chaque hausse d'intensité.
3. Une hésitation, un retrait verbal ou gestuel, une immobilité non confirmée ou un `stop` entraîne ralentissement ou arrêt observable. Aucun arrêt n'est puni.
4. Une scène vécue ne crée aucune permission future, disponibilité permanente, répétition, pratique supplémentaire, exclusivité, photographie, conservation, archive, transfert ou diffusion.
5. Un média non diégétique n'étend aucune audience et ne devient jamais une preuve dans la fiction.
6. Aucun score de désir, confiance ou consentement ; aucun total de points ; aucun hasard ; aucune scène obtenue par accumulation abstraite.
7. Le payoff découle uniquement de faits authored et de préconditions fermées. Il peut ne pas se produire.
8. Le sexe ne paie pas une dette, ne répare pas automatiquement un mensonge, une audience violée, une promesse rompue, une obligation impayée ou une version incompatible.
9. L'aftercare est une obligation narrative distincte : sortie d'intensité, soin physique, soin émotionnel, clarification relationnelle et réparation d'une faute antérieure ne sont pas interchangeables.
10. Une scène positive ne retire ni l'autonomie du personnage, ni ses obligations, ni les conséquences envers Marie ou Jeff, ni le droit de choisir autrement ensuite.
11. Une scène non déclenchée n'est ni une faute du joueur, ni un échec relationnel, ni une perte de progression, sauf conséquence authored d'une proposition ou obligation réellement créée.
12. Une seule variante principale du pivot historique J11 est vécue ; la branche adulte Sandra remplace `C18-02` standard au lieu de s'y ajouter.

## 5. Payoff authored Marie/Player `#051`

### 5.1 Identité, projection et fonction

| Champ | Contrat |
|---|---|
| Identité canonique | payoff W4 Marie/Player `#051`, enfant authored de `C11-06` ; l'alias `MARIE_J11_RECONQUEST` n'impose pas J11 comme identité |
| Mouvement | III — explorations, puis conséquences du mouvement IV |
| Projection actuelle | centre adulte historique J11 ; retombée immédiate ; paiement/continuité J12 ; lecture des faits à J17 ; transport possible J21 |
| Scènes/beats internes | entrée choisie dans l'intimité ; progression W4 ; sortie d'intensité ; quotidien/aftercare `#052` |
| Fonction | exprimer l'intimité réelle du couple et une reprise physique possible, sans confondre désir, réparation et résolution |
| Consentement/média | `CONSENTED_PRIVATE`; `#051` et `#052` non diégétiques, joueur uniquement |

### 5.2 Préconditions authored exactes

La scène est éligible seulement si toutes les conditions suivantes sont prouvées :

- le pivot actuel est Marie : runtime historique `j11_pivot == "MARIE"` ;
- aucune route extérieure J10 ne sert de repli : `j10_pivot == "NONE"` ;
- `j10_pivot_outcome` vaut `DUE_DINNER_PAID` ou `ORDINARY_MEAL_JOINED` ;
- `marie_j09_presence_outcome` vaut `presence_active`, `presence_playful_useful`, `presence_late_active` ou `presence_bounded_reliable` ;
- l'état de couple à cette projection vaut `BASELINE_SHARED_LIFE` ou `STRAIN_VISIBLE` ;
- P09 est terminale ; si P09 est `AMENDED`, elle désigne P10 et P10 est `PAID` ;
- P10 est absente ou `PAID` ; aucune obligation `DUE` ou `FAILED` non traitée ;
- aucune fermeture de route extérieure n'est utilisée comme consolation ;
- la reconquête a été construite par des actes antérieurs, sans jalousie comme pression, sans refus antérieur ignoré et sans dette Marie active ;
- le choix de reconquête réellement présenté (`choice_j11_marie_reconquest` ou `choice_j11_marie_post_reconquest`) est sélectionné ;
- Marie initie ou co-initie, Player nomme le désir sans promettre de réparation, et le consentement actuel/révocable est confirmé ;
- une retombée immédiate et l'aftercare `aftercare_marie_j11` peuvent être servis.

Le déclencheur précis est la convergence de ces preuves avec la réponse de
reconquête ; il n'est ni le niveau de désir, ni le seul dîner payé, ni le label du
choix. Le runtime historique matérialise le fait par
`j11_physical_level == "MARIE_ADULT_RECONQUEST"` et
`j11_pivot_outcome == "MARIE_ADULT_RECONQUEST"`.

### 5.3 Initiative, consentement, acte autorisé et arrêt

- Marie choisit le retour à la proximité, initie ou co-initie le premier geste et reste active ; Player répond à ce choix au présent.
- Avant la transition hors téléphone : désir mutuel nommé, distinction explicite entre la scène et la réparation du couple, droit de changer d'avis.
- Pendant : confirmation verbale ou gestuelle au premier déshabillage, avant l'acte central et après toute hésitation/changement d'intensité.
- La progression autorisée est une sexualité conjugale explicite pouvant aller jusqu'à un rapport sexuel complet : un acte central unique ou une courte progression spatialement lisible, avec action et réponse mutuelles. N9 ne substitue pas un acte précis aux bornes déjà verrouillées par N7.
- L'arrêt reste possible avant et pendant l'acte ; il coupe immédiatement l'escalade et conduit à une sortie non punitive correspondant seulement à ce qui a été vécu.
- Sont exclus : passivité-récompense de Marie, humiliation, coercition, jalousie comme moteur, acte ajouté après un arrêt, performance pour une audience, caméra/appareil, photographie, diffusion, ouverture du couple, droit futur ou conclusion de pardon.

### 5.4 Sortie, aftercare, faits et conséquences

| Élément | Contrat fermé |
|---|---|
| Sortie d'intensité immédiate | souffle, vérification de l'état de Marie, proximité ou espace choisi, retour corporel au calme avant toute ellipse |
| Aftercare physique | confort concret demandé/accepté, eau/vêtement/drap/espace, aucun nouveau rapport |
| Aftercare émotionnel | reconnaître que la scène est vraie et désirée sans lui faire porter le conflit |
| Clarification relationnelle | rappeler que désir et reconquête ne valent ni résolution, ni pardon, ni ouverture |
| Réparation antérieure | aucune ; toute dette, audience, promesse ou version incompatible conserve son propre mécanisme |
| Obligation existante | `aftercare_marie_j11`, créée `DUE`, due avant route extérieure ou convergence J12 |
| `PAID` | sortie immédiate servie puis raccord matinal J12 présenté ; le runtime porte `pay_j12_marie_aftercare()` et `paid_by = "Marie et Player — aftercare matinal J12 présenté"` |
| `FAILED` | refus explicite de l'aftercare, négligence de la sortie ou convergence/route extérieure tentée avant son paiement ; la scène vécue reste consentie mais l'obligation et sa conséquence restent actives |
| Fait durable | Marie et Player ont pu reprendre une intimité sexuelle complète, consentie et non réparatrice ; runtime actuel : `MARIE_ADULT_RECONQUEST` |
| Trace transportable | fait authored de l'intimité vécue + statut de `aftercare_marie_j11`; `#051/#052` restent des souvenirs joueur non diégétiques |
| Audience | Marie et Player pour le fait ; joueur pour les médias ; aucun tiers ne sait sans révélation authored ultérieure |
| Effet immédiat | proximité réelle et quotidien possible ; aucune route extérieure avant aftercare |
| Effet différé | comportement public J12 choisi par Marie ; contribution possible aux actes Marie répétés de N8 ; vérité, violations et mensonges continuent séparément |

### 5.5 Compatibilité J17 et rappel J21

Les six états N8 sont des sorties provisoires ultérieures. Le fait `#051` est
compatible comme historique avec `RECONQUEST_ACTIVE`, `PROVISIONAL_AGREEMENT`,
`RECONFIGURATION_NEGOTIATION`, `DOUBLE_LIFE_FRAGILE`, `FRACTURE` et `SEPARATION`.
Il ne produit automatiquement aucun de ces états. N8 peut compter
`MARIE_ADULT_RECONQUEST` parmi les preuves de reconnexion répétée, mais les huit
règles, leurs gardes, la vérité suffisante, les audiences et les violations gardent
leur priorité.

J21 peut rappeler explicitement que le couple a retrouvé une intimité si Marie et
Player la connaissent tous deux, constater l'aftercare payé/échoué et laisser ce fait
infléchir leur posture. J21 ne peut conclure de `#051` que le couple est réparé, que
Marie accepte une ouverture, que les mensonges sont pardonnés, que les limites sont
levées ou que Player a obtenu un droit sur son corps.

## 6. Payoff authored Mathilde/Player `#045`

### 6.1 Identité, projection et fonction

| Champ | Contrat |
|---|---|
| Identité canonique | payoff W4 Mathilde/Player `#045`, enfant authored de `C11-03`, plafond M-B3 ; l'alias `MATHILDE_J11_SECRET_INTIMACY` n'impose pas J11 comme identité |
| Mouvement | III — interdit domestique choisi ; conséquences mouvements IV et V |
| Projection actuelle | centre adulte historique J11 ; comportement/conséquence J12 ; départ J16/J17 ; transport possible J21 |
| Scènes/beats internes | retour volontaire ; baiser négocié ; progression M-B3 ; séparation réelle ; aftercare `#046` |
| Fonction | progression explicite fondée sur l'ambiguïté domestique et le regard, sans convertir proximité passée ou rôle domestique en permission présente |
| Consentement/média | `CONSENTED_PRIVATE`; `#045/#046` non diégétiques, joueur uniquement |

### 6.2 Préconditions authored exactes

Toutes les conditions suivantes sont nécessaires :

- regard reconnu depuis J06, trace runtime `j06_mathilde_look_acknowledged_01` et fait `fact_mathilde_knows_player_noticed_her` lorsqu'ils existent dans la projection ;
- effet choisi en J10 et limite respectée ; Mathilde sait que son retour est intentionnel ;
- pivot Mathilde actif ; choix de proximité, puis `choice_j11_mathilde_m_b3_accept` réellement sélectionné ; M-B2 aurait été crédible dans le même état ;
- Marie est absente pour une raison indépendante, jamais organisée par Player ;
- Mathilde prend l'initiative, ne dépend pas du logement et conserve une solution indépendante pour dormir ;
- `mathilde_has_independent_sleep_option`, `mathilde_can_leave_safely` et `marie_absence_not_engineered` sont vrais dans le runtime historique ;
- vêtements, téléphone, transport, clés/affaires et solution de repli restent accessibles ;
- aucune conséquence prioritaire, dette domestique ou matérielle n'est impayée ; aucune limite n'a été négociée à la baisse ;
- Player n'a ni comparé Mathilde à Marie, ni organisé l'absence de Marie, ni réclamé une récompense pour une limite respectée, ni insisté après une réponse partielle ;
- le secret envers Marie est reconnu comme conséquence, jamais comme permission ou simple excitation ;
- aucune demande de répétition, photographie ou conservation n'existe avant l'après-coup ;
- consentement présent renouvelé à chaque étape et fin possible avant le retour de Marie.

Le déclencheur précis est la succession authored : proximité choisie → baiser
autorisé avec interdiction de compléter seul → proposition M-B3 par Mathilde →
acceptation bornée de Player → transition hors téléphone. L'éligibilité seule ne
sert jamais `#045`.

### 6.3 Position dans le foyer, initiative, acte et retrait

- Mathilde reste l'hôte temporaire disposant d'un logement propre ; sa présence chez Marie et Player ne constitue jamais une dépendance exploitable ou une permission.
- Mathilde revient volontairement, initie le dépassement du baiser et fixe chaque étape ; Player est actif seulement en réponse à ce qui vient d'être accepté.
- Progression autorisée : baiser négocié, nudité explicite et contact sexuel mutuel explicite, précis et successif, sans aucune pénétration. La scène doit dépasser sans ambiguïté un simple baiser tout en restant dans cette borne.
- Vérifications : avant chaque contact nouveau, lors du passage à la nudité, au changement de geste/intensité et à toute hésitation ; une réaffirmation partielle ne vaut que pour l'étape nommée.
- Retrait : Mathilde peut corriger, ralentir, remettre un vêtement, créer de la distance, dire stop ou partir. Player cesse le geste sans négocier et facilite la sortie.
- Sont exclus : pénétration ou ambiguïté de pénétration, sommeil/intoxication, violence, posture de dépendance, voyeurisme depuis une porte, humiliation de Marie, symbole de victoire sur le foyer, répétition future, nouvelle pratique, relation durable, caméra, photographie ou diffusion.

### 6.4 Sortie, aftercare, faits et conséquences

| Élément | Contrat fermé |
|---|---|
| Sortie d'intensité immédiate | arrêt net du contact, retour au calme et distinction explicite entre acte vécu et décision de dormir/partir |
| Aftercare physique | présence, espace ou geste pratique choisi par Mathilde ; vêtements, clés, sac, transport et couchage indépendant accessibles |
| Aftercare émotionnel | ne pas réclamer de définition ou reconnaître la conséquence envers Marie ; ne pas faire porter seule la faute à Mathilde |
| Clarification relationnelle | aucun droit de répétition ; clarification future seulement ; départ matériel inchangé |
| Réparation antérieure | aucune ; la loyauté envers Marie et tout mensonge/audience se traitent séparément |
| Obligation existante | `aftercare_mathilde_j11`, initialement `DUE`, due avant toute progression nouvelle et convergence J12 |
| `PAID` | choix `choice_j11_mathilde_after_no_definition` ou `choice_j11_mathilde_after_marie`, soin pratique respecté, départ/couchage indépendant non entravé |
| `FAILED` | `choice_j11_mathilde_after_repeat`, refus explicite de l'aftercare, pression pour répéter/définir, entrave au départ ou omission de la clôture due avant J12 |
| Fait durable | `fact_mathilde_physical_event_occurred` avec `physical_level = MATHILDE_M_B3`; la scène reste consentie même si l'aftercare échoue |
| Trace durable | `j11_mathilde_physical_aftercare_01`, `TEXT_MESSAGE`, `PRIVATE_ACTIVE`, audience Mathilde/Player, `IN_THREAD_ONLY`, transfert `FORBIDDEN` |
| Effet immédiat | `mathilde_j11_state = PHYSICAL_SECRET`, `j11_physical_level = MATHILDE_M_B3`, secret et responsabilité actifs |
| Effet différé | `PAID` permet une clarification ultérieure sans la promettre ; `FAILED` donne priorité à Mathilde en J12, l'exclut de la convergence normale, ferme la progression physique et peut conduire à distance/confiance rompue |

### 6.5 J12, J17 et J21

À J12, Mathilde sait ce qui s'est produit et que Marie reste une responsabilité.
Après M-B3 payé, son comportement peut montrer effort de normalité, distance,
départ plus tôt, refus d'aparté ou absence volontaire ; aucune deuxième scène. Après
échec, le préambule prioritaire traite l'obligation, enregistre son absence et ferme
la progression.

N8 transporte exactement M-B3 et l'aftercare : le micro-retour Mathilde varie selon
`PAID`/`FAILED`; `fact_mathilde_physical_event_occurred` est un fait matériel caché
qui conduit, après les gardes supérieures, à `DOUBLE_LIFE_FRAGILE` si Marie ne le
connaît pas. Si Marie connaît l'échec et la trace selon les conditions N8, la
violation grave non réparée peut conduire à `FRACTURE`. Le départ réel J17 reste
obligatoire et Mathilde n'est jamais une option de couple face à Marie.

J21 peut rappeler le départ, le secret connu, le statut d'aftercare et leurs effets.
Il ne rejoue ni le baiser, ni le contact, ni `#045/#046`; il ne conclut ni
disponibilité, ni répétition, ni annulation du départ, ni permission née du rôle
domestique.

## 7. Payoff authored Sandra/Player `#079`

### 7.1 Identité, projection et fonction

| Champ | Contrat |
|---|---|
| Identité canonique | payoff W4 Sandra/Player `#079`, branche adulte authored de `C18-02` dans `S30 — Sandra choisit ce qu'elle garde` ; l'alias `SANDRA_J18_LATE_INTIMACY` n'impose pas J18 comme identité |
| Mouvement | V — résolution de la ligne Sandra après clarification provisoire du couple |
| Projection actuelle | proposition/intimité historique J18 ; aftercare prioritaire J19 ; conséquence transportable J21 |
| Scènes/beats internes | décision de trace `C18-01`; invitation ; entrée `S1_A5_J18_SCN_SANDRA_LATE_INTIMACY_ENTRY_01`; centre `#079`; sortie `#080`; messages immédiats ; module J19 |
| Fonction | payer confiance ancienne, tentation et passé partagé par une intensité contrôlée par Sandra, jamais par escalade mécanique |
| Consentement/média | `CONSENTED_PRIVATE`; aucun appareil dans la fiction ; `#079/#080` joueur uniquement |

### 7.2 Préconditions authored exactes

Toutes les conditions suivantes sont nécessaires :

- aucune intimité Sandra/Player antérieure ; route Sandra avancée et foreground ; ancienne amitié réellement reconstruite ; désir réciproque reconnu ;
- aucune demande de supplément récompensée, aucune limite ignorée, aucune rupture de confiance, aucune audience violée ou copie incertaine ; voir/garder/transférer ont toujours été distingués ;
- l'état de la photographie ou impression Sandra a d'abord été résolu dans `C18-01` sans que cette trace serve de monnaie d'accès ;
- Sandra initie, choisit lieu et heure, peut retirer la proposition et demander le départ sans explication ;
- Player accepte le cadre sans demander à l'avance « jusqu'où », sans transformer l'invitation en permission générale et en confirmant l'absence de photo ;
- adultes capables de choisir, sobres, lieu quittable, arrêt possible avant et pendant, téléphone hors d'usage, aucun appareil/enregistrement ;
- la projection du couple rend la scène possible seulement après `SEPARATION` réelle ou dans la famille authored de double vie sombre consciemment maintenue ;
- la scène est bloquée après `RECONQUEST_ACTIVE`, `PROVISIONAL_AGREEMENT`, `RECONFIGURATION_NEGOTIATION`, mensonge sur le statut du couple, violation active ou pause interdisant la progression ;
- Jeff reste le partenaire réel de Sandra, absent physiquement seulement, non informé automatiquement et jamais transformé en permission ;
- la proposition n'a pas été retirée, Sandra a maintenu son accord à chaque étape et le centre pénétratif est réellement atteint.

Le déclencheur précis de `#079` est l'atteinte effective du rapport central après
l'invitation et l'entrée consenties. Une invitation, une nudité, un début de
rencontre ou l'éligibilité ne suffisent pas. Le runtime J18 actuel ne représente ni
cette branche, ni son état, ni son aftercare ; N9 ne prétend pas le contraire.

### 7.3 Initiative, acte canonique, maintien et arrêt

- Sandra initie la proposition, la proximité et le passage à l'acte. Player répond activement, sans prendre le contrôle du rythme ou de la représentation.
- Acte verrouillé : rapport vaginal pénétratif consensuel ; Sandra au-dessus de Player, tournée vers lui et contrôlant le rythme ; l'image `#079` correspond au milieu de l'acte.
- Vérifications : consentement écrit avant la rencontre ; confirmation gestuelle ou verbale avant la pénétration ; maintien lisible par initiative/rythme de Sandra ; contrôle explicite après tout ralentissement ou hésitation.
- Signaux de maintien : Sandra ajuste volontairement la distance et le rythme, répond à Player et reconfirme l'étape présente. Ils ne valent jamais pour une étape future.
- Signaux d'arrêt : retrait verbal/gestuel, immobilité non reconfirmée, éloignement, changement d'avis ou demande de départ. Player cesse immédiatement, rend l'espace et part si demandé.
- Si l'arrêt précède l'atteinte de `#079`, `#079` n'est pas servi et `#080` est `NOT_APPLICABLE`; l'aftercare reste néanmoins `DUE` sous la forme adaptée à l'arrêt précoce définie en section 7.5. Si l'arrêt suit une intimité vécue, seules les étapes réellement vécues sont conservées.
- Sont exclus : autre acte substitué au centre canonique, Sandra passive/capturée, Player contrôlant le rythme, violence, humiliation, ivresse, pose triomphale, cadrage de performance, Jeff participant ou permission, Marie effacée, appareil, photographie, fichier, répétition promise ou route automatique.

### 7.4 Cadrage, sortie émotionnelle et séparation des promesses

`#079` doit cadrer Sandra comme sujet actif ; Player est partiellement visible mais
non identifiable. Le point de vue n'est ni un téléphone, ni une caméra cachée, ni le
regard d'un tiers. Le contrôle du rythme matérialise narrativement le passage de la
confiance de représentation à une intimité choisie : il ne transforme pas Sandra en
spectacle et ne cède pas le contrôle de son récit.

La sortie immédiate distingue quatre vérités : la rencontre a pu être désirée ; elle
n'est pas simple ; elle ne décide pas d'une prochaine fois ; Sandra conserve seule
ce qu'elle dit à Jeff tandis que Player répond de ce qu'il dit à Marie. L'intensité
sexuelle ne produit ni relation garantie, ni exclusivité, ni droit futur, ni secret
commun à cogérer.

### 7.5 Aftercare J18/J19, faits et conséquences

L'obligation d'aftercare devient `DUE` dès le début de la rencontre intime. Son
contenu et l'applicabilité des médias dépendent ensuite de ce qui a réellement été
atteint. Aucun identifiant runtime n'existe sur la baseline.

#### 7.5.1 Branche A — arrêt précoce avant `#079`

Cette branche couvre tout arrêt ou retrait avant que le payoff pénétratif complet et
son média `#079` soient atteints.

- `#079` n'est pas produit.
- `#080` est `NOT_APPLICABLE`.
- L'absence de `#080` ne peut pas provoquer à elle seule un statut `FAILED`.
- L'aftercare reste `DUE` sous une forme adaptée à l'arrêt précoce.

L'aftercare est `PAID` uniquement si tous les éléments suivants sont présents :

- l'arrêt est respecté immédiatement ;
- aucune tentative de reprise ou négociation n'est exercée ;
- Sandra reçoit un check-in centré sur son état présent ;
- Player lui offre explicitement de l'espace ou une sortie ;
- aucune reassurance, promesse ou absolution n'est exigée d'elle ;
- la clôture reconnaît qu'aucun droit futur n'a été créé.

L'aftercare est `FAILED` si au moins un des éléments suivants est présent :

- pression pour continuer ;
- insistance ou négociation après l'arrêt ;
- froideur punitive ou retrait destiné à la culpabiliser ;
- demande de reassurance ;
- traitement de l'arrêt comme une dette ou un rejet personnel ;
- absence complète de check-in ou de clôture.

#### 7.5.2 Branche B — payoff `#079` atteint

Lorsque le payoff `#079` est atteint :

- `#080` devient une sortie d'intensité obligatoire ;
- l'absence injustifiée de `#080` rend l'aftercare `FAILED` ;
- la présence de `#080` ne suffit pas seule à rendre l'aftercare `PAID` ;
- le suivi J19 reste obligatoire.

L'aftercare est `PAID` uniquement si tous les éléments suivants sont présents :

- `#080` remplit sa fonction de sortie d'intensité ;
- Sandra conserve une capacité d'arrêt et de retrait lisible ;
- le suivi J19 centre son état présent et son autonomie ;
- Player n'exige aucune confirmation que la scène était acceptable ;
- aucun droit futur, exclusivité ou promesse de répétition n'est déduit.

L'aftercare est `FAILED` si au moins un des éléments suivants est présent :

- `#080` manque alors que `#079` a été atteint ;
- la sortie d'intensité est brusque, froide ou centrée sur la satisfaction de Player ;
- J19 demande à Sandra de rassurer ou d'absoudre Player ;
- Player transforme la scène en promesse relationnelle ;
- Player suppose une disponibilité future ;
- les limites ou l'autonomie de Sandra sont minimisées.

#### 7.5.3 Posture J19 « demander si elle regrette »

La posture authored actuelle « demander si elle regrette » est classée `FAILED`.
Elle demande à Sandra de statuer rétrospectivement sur la scène et de rassurer
implicitement Player ; elle ne constitue pas un check-in suffisamment centré sur son
état présent, ses besoins ou son autonomie. Elle n'est jamais `PAID`
conditionnellement.

Une future formulation ouverte et distincte, centrée sur la manière dont Sandra se
sent maintenant, pourrait appartenir à un chemin `PAID`. Elle ne doit pas être
confondue avec la posture authored actuelle.

#### 7.5.4 Faits et conséquences transportables

| Élément | Contrat fermé |
|---|---|
| Aftercare physique | espace, sortie, eau/vêtement/temps selon Sandra ; aucune relance sexuelle ; téléphone seulement pour écrire ensuite, jamais photographier |
| Aftercare émotionnel | check-in centré sur l'état présent et l'autonomie ; aucune reassurance, définition, répétition, simplification ou absolution exigée |
| Clarification relationnelle | aucun droit futur ; « aucune prochaine fois prévue » si `#079` est atteint ; l'arrêt précoce ne devient ni dette ni rejet personnel |
| Réparation antérieure | aucune ; dette envers Marie, vérité du couple, Jeff et audiences gardent leurs conséquences propres |
| Fait durable | Sandra et Player ont pu partager l'acte canonique ; ou une rencontre a commencé puis s'est arrêtée avant `#079` ; la distinction doit rester exacte |
| Trace durable | fait authored privé connu de Sandra/Player + branche et statut de l'aftercare ; `#079/#080` ne sont pas des traces diégétiques |
| Effet immédiat | autonomie et état présent de Sandra ; aucune prochaine fois ; décision future de Sandra envers Jeff et dette possible envers Marie |
| Effet différé | J19 transporte la branche exacte et le statut ; J21 transporte conséquence/posture seulement, sans flashback ni nouveau média |

### 7.6 Marie, Jeff et J21

Si Player était réellement séparé, Marie ne connaît pas automatiquement la scène et
la scène reste sans effet rétroactif sur la séparation. En double vie sombre, le fait
est caché à Marie jusqu'à une révélation authored ; la dette active et la version
incompatible demeurent. Sandra décide seule de ce qu'elle dit à Jeff ; Player ne
parle ni pour Sandra, ni pour Marie.

J21 peut constater le fait connu, le statut d'aftercare, la dette, une révélation ou
une posture actuelle. Il ne peut afficher `#079` comme preuve, rejouer l'acte,
reproduire son intensité, créer une permission de photographie/diffusion, promettre
une relation, effacer Marie/Jeff ou obliger Sandra à recommencer. Les détails qui ne
concernent que la route Sandra restent hors de la conversation du couple tant qu'ils
ne constituent ni fait révélé, ni violation active, ni incompatibilité de version.

## 8. Registre consolidé des aftercares

| Payoff | Sortie d'intensité | Aftercare | Responsables / participants | Fenêtre | Action due | Initial | `PAID` | `FAILED` | Immédiat | Différé / trace | Audience | Réparation possible | Projection |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Marie `#051` | souffle, check, proximité/espace choisi | `aftercare_marie_j11`; visuel `#052` | Marie et Player | immédiat puis matin J12, avant route extérieure/convergence | soin corporel, quotidien partagé, distinction sexe/conflit | `DUE` | sortie + raccord matinal J12 servis | refus/omission ou convergence prématurée | désir réel, conflit non résolu | statut obligation + `MARIE_ADULT_RECONQUEST`; comportement J12/J17/J21 | Marie/Player ; média joueur | l'aftercare peut être payé ; les fautes antérieures exigent leur propre réparation | J12, J17, J21 |
| Mathilde `#045` | fin nette du contact et séparation de la décision de couchage | `aftercare_mathilde_j11`; visuel `#046` | Mathilde et Player | immédiat, avant toute progression/convergence J12 | espace/geste pratique, départ libre, non-définition ou responsabilité Marie | `DUE` | MA1/MA2 : ne pas définir ou reconnaître Marie + sortie respectée | MA3 répétition, refus/pression/entrave/omission | secret reconnu, départ réel | `fact_mathilde_physical_event_occurred`, `j11_mathilde_physical_aftercare_01`; priorité J12, micro-retour J17 | Mathilde/Player ; trace privée ; média joueur | aftercare réparable tant que dû ; échec déjà produit reste un fait ; autre faute séparée | J12, J17, J21 |
| Sandra — arrêt avant `#079` | arrêt immédiat, check-in, espace ou sortie | `#080` `NOT_APPLICABLE`; aftercare adapté à l'arrêt | Sandra et Player | immédiat J18 ; état transporté à J19 | respecter l'arrêt sans reprise/négociation, centrer l'état présent, n'exiger aucune reassurance | `DUE` dès rencontre commencée | tous les critères de 7.5.1 réunis | au moins un critère d'échec de 7.5.1 ; l'absence de `#080` seule ne suffit jamais | arrêt reconnu sans dette ni rejet personnel | fait privé d'arrêt + statut exact ; aucune image `#079/#080` | Sandra/Player ; aucun média de payoff/aftercare | une limite ultérieurement respectée n'efface pas un échec déjà produit | J19, J21 |
| Sandra — `#079` atteint | `#080` obligatoire puis check-in/autonomie | `#080` + module authored prioritaire J19 | Sandra et Player | immédiat J18 puis ouverture J19 avant Pauline/Raphaëlle | sortie fidèle, état présent, aucune confirmation/absolution, aucun droit futur | `DUE` dès rencontre commencée | tous les critères de 7.5.2 réunis | `#080` absent ou au moins un critère d'échec de 7.5.2 ; « demander si elle regrette » est `FAILED` | acte reconnu, aucune prochaine fois | fait privé + statut J19 ; dette éventuelle | Sandra/Player ; médias joueur | les limites peuvent être respectées ensuite ; violation antérieure garde sa réparation propre | J19, J21 |

### 8.1 Fonctions non interchangeables

| Fonction | Définition | Ne paie pas automatiquement |
|---|---|---|
| Sortie d'intensité | faire cesser l'escalade et rendre l'état corporel lisible | soin différé, promesse, vérité |
| Aftercare physique | répondre aux besoins concrets post-scène | clarification de la relation |
| Aftercare émotionnel | reconnaître l'expérience, l'autonomie et l'absence de dette sexuelle | mensonge, audience, obligation externe |
| Clarification relationnelle | nommer ce que la scène change ou ne change pas | réparation d'une faute passée |
| Réparation | répondre à la faute précise avec vérité, restitution, notification ou action due | aucune autre faute par contagion |

Un moment tendre n'efface donc jamais un mensonge, une violation d'audience, une
promesse rompue, une obligation impayée ou une version incompatible.

## 9. Contrat des six médias W4

L'échelle d'inventaire N6 `NV0–NV4` et l'échelle visuelle canonique `V0–V5`
restent distinctes. Aucune ne remplace l'autre.

> `W4` décrit la maturité de l'écriture du payoff. Il ne signifie ni que le média existe, ni qu'il a été généré, validé ou intégré. Les six médias restent `SPECIFIED_NOT_PRODUCED`.

| Média | N6 inventory level | Canonical visual level | Production status | Writing maturity | Personnage / fonction / statut | Moment et cadrage | Obligatoire | Interdit | Player / continuité / espace / émotion | Dialogue, aftercare, production, description auteur et nécessité |
|---|---|---|---|---|---|---|---|---|---|---|
| `#045` `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_CENTRAL_01` | `NV4` | `V5` | `SPECIFIED_NOT_PRODUCED` | `W4` | Mathilde ; `PORNOGRAPHIC_PAYOFF`; non diégétique | milieu du contact mutuel M-B3 réellement atteint ; Mathilde sujet actif ; décor du foyer crédible, jamais studio | nudité explicite ; contact mutuel lisible ; non-pénétration incontestable ; autonomie/arrêt lisibles | pénétration, sommeil, ivresse, dépendance, voyeurisme, humiliation de Marie, caméra/téléphone, victoire sur le foyer | Player non identifiable ; vêtements issus de l'entrée et accessibles ; Mathilde désirante, concentrée, capable de corriger | suit le consentement étape par étape ; précède la séparation/#046 ; dépend références Mathilde/Player, décor, continuité vêtements et script M-B3 ; **description auteur :** Mathilde guide un contact sexuel mutuel explicite dans le foyer, sans pénétration, avec sortie possible ; existe pour rendre le premier interdit sexuel réel sans créer une disponibilité |
| `#046` `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_AFTERCARE_01` | `NV2` | `V4` | `SPECIFIED_NOT_PRODUCED` | aftercare défini dans le contrat W4 | Mathilde ; `TRUST_OR_INTIMACY_REWARD`; sortie/aftercare ; non diégétique | après séparation réelle, Player absent, dans le couchage indépendant ou un espace autonome | vêtements repris partiellement/entièrement ; sac, clés, téléphone/transport accessibles ; désir, gêne et réflexion | nouvel acte, victime, conquête, Player présent comme pression, photo prise dans la fiction | Player absent/non identifiable ; continuité directe #045 ; espace de repli réel ; autonomie lisible | correspond à MA1/MA2/MA3 et à `PAID/FAILED`; dépend du lieu de couchage, accessoires, version d'aftercare ; **description auteur :** Mathilde, seule après la scène, reprend ses affaires et mesure désir, secret et responsabilité ; existe pour matérialiser le départ libre et la dette d'aftercare |
| `#051` `S1_A3_J11_SCN_MARIE_RECONQUEST_ADULT_PAYOFF_01` | `NV4` | `V5` | `SPECIFIED_NOT_PRODUCED` | `W4` | Marie ; `PORNOGRAPHIC_PAYOFF`; non diégétique | point culminant d'une progression conjugale explicite réellement atteinte ; Marie centrale et active ; espace du couple | acte central/position corporelle lisibles ; réciprocité ; familiarité spécifique du couple ; autonomie de Marie | passivité-récompense, humiliation, jalousie, pose pour audience, caméra, pardon visuel, ouverture implicite | Player non identifiable ; continuité entrée/vêtements/lieu ; désir mutuel sans bonheur définitif | suit le check de consentement et précède la sortie/#052 ; dépend références couple, décor commun, acte choisi au futur script et continuité ; **description auteur :** Marie et Player reprennent une sexualité explicite choisie dans leur espace commun, sans résoudre leur conflit ; existe pour distinguer intimité réelle et réparation |
| `#052` `S1_A3_J11_SCN_MARIE_RECONQUEST_AFTERCARE_01` | `NV2` | `V4` | `SPECIFIED_NOT_PRODUCED` | aftercare défini dans le contrat W4 | Marie ; `TRUST_OR_INTIMACY_REWARD`; sortie/aftercare ; non diégétique | retombée immédiate ou matin J12 ; Marie engagée dans une action ordinaire | vêtements repris ou drap non théâtral ; café/cuisine/préparation ; proximité réelle ; problème toujours lisible | nouvel acte, béatitude finale, tristesse punitive, possession, preuve publique | Player hors champ/non identifiable ; continuité corporelle/vêtements #051 ; espace du couple ; calme concret | paie `aftercare_marie_j11` avec le raccord J12 ; dépend décor quotidien et script de retombée ; **description auteur :** Marie revient au quotidien avec une proximité réelle, sans que la nuit ait réparé le couple ; existe pour faire de l'aftercare une conséquence narrative |
| `#079` `S1_A5_J18_SCN_SANDRA_LATE_INTIMACY_CENTRAL_01` | `NV4` | `V5` | `SPECIFIED_NOT_PRODUCED` | `W4` | Sandra ; `PORNOGRAPHIC_PAYOFF`; non diégétique | milieu du rapport vaginal pénétratif ; Sandra au-dessus, tournée vers Player, contrôle le rythme ; point de vue sans appareil | acte canonique sans ambiguïté ; Sandra active ; rythme/arrêt lisibles ; téléphone hors d'usage | autre acte substitué, Sandra passive, Player identifiable/triomphal, violence, humiliation, appareil, pose détachée, Jeff/Marie effacés | Player partiellement cadré non identifiable ; continuité entrée/vêtements/espace ordinaire ; confiance, désir et contrôle | seulement après consentement maintenu ; précède séparation/#080 ; dépend références Sandra/Player, anatomie/position, décor et continuité ; **description auteur :** Sandra contrôle un rapport vaginal au milieu de l'acte, face à Player, sans caméra ni droit futur ; existe pour payer confiance et tentation par une intimité propre à Sandra |
| `#080` `S1_A5_J18_SCN_SANDRA_FINAL_STATE_01_LATE_INTIMACY_AFTERCARE` | `NV2` | `V4` | `SPECIFIED_NOT_PRODUCED` | aftercare défini dans le contrat W4 | Sandra ; `TRUST_OR_INTIMACY_REWARD`; sortie d'intensité ; non diégétique | après `#079`, Player parti ou distinct ; espace ordinaire de Sandra ; réutilisable seule à J19 | distance/proximité choisie ; vêtements/plaid/boisson/livre possibles ; Jeff conséquence invisible ; aucune prochaine fois | nouvel acte, flashback, regret forcé, joie de conquête, téléphone-caméra ; composition prétendant #079 si centre non atteint | Player absent ou distinct/non identifiable ; continuité directe du payoff atteint ; calme, fatigue, trouble ou réflexion | porte messages J18 et module J19 quand `#079` est atteint ; dépend de la branche réellement vécue et du retour ordinaire ; `NOT_APPLICABLE` lors d'un arrêt précoce avant `#079` ; **description auteur :** Sandra reprend son espace après le payoff atteint et conserve contrôle, calme ou recul sans promettre la suite ; existe pour sortir de l'intensité et porter l'aftercare |

### 9.1 Contraintes de production communes

- Ne produire un média qu'après verrouillage du script correspondant et de la version de branche réellement illustrée.
- Conserver références physiques, proportions, peau, coiffure, accessoires, vêtements, décor, lumière et axe spatial entre entrée, payoff et aftercare.
- Le cadre Player doit permettre action/réciprocité sans identité faciale exploitable.
- Ne jamais ajouter appareil, interface, reflet de caméra, photographe implicite ou métadonnée diégétique.
- Prévoir variantes de sortie uniquement lorsqu'elles correspondent à des états authored distincts ; aucune variante ne prétend un acte non vécu.
- Les descriptions auteur ci-dessus sont des textes alternatifs fonctionnels, pas des prompts graphiques définitifs.
- Aucun nouveau fichier J21 : J21 peut seulement réutiliser un contenu déjà vécu et encore admissible, en conservant sa fonction et son audience.

## 10. Matrices de continuité J17, J19 et J21

### 10.1 Marie `#051/#052`

| Dimension | Valeur transportable |
|---|---|
| Fait connu de Player | intimité complète éventuellement vécue ; choix/retrait ; état de `aftercare_marie_j11` |
| Fait connu du personnage | Marie connaît exactement sa propre scène, ses limites, l'aftercare et le conflit encore actif |
| Fait connu de Marie | identique ; aucune inférence nécessaire |
| Fait encore caché | aucun fait propre à `#051`; peuvent rester cachés des faits extérieurs sans lien d'audience avec le média |
| Trace durable | `j11_physical_level/j11_pivot_outcome = MARIE_ADULT_RECONQUEST` et obligation `aftercare_marie_j11`; médias non diégétiques |
| Promesse | aucune promesse future créée par la scène ; la revue de couple J17, si créée en J16, est indépendante |
| Obligation | `aftercare_marie_j11`; les obligations antérieures demeurent séparées |
| Aftercare | immédiat + `#052`/matin J12, `PAID` ou `FAILED` selon section 5.4 |
| Audience | fait : Marie/Player ; médias : joueur ; aucune audience sociale automatique |
| Conséquence immédiate | proximité réelle, conflit non résolu, route extérieure/convergence bloquée avant aftercare |
| Disponible à J17 | preuve possible d'un acte Marie répété ; statut aftercare ; jamais garde suffisante pour un état favorable |
| Disponible à J19 | état déjà transporté, sans nouveau module ni répétition ; peut seulement infléchir posture/obligations |
| Disponible à J21 | souvenir commun, aftercare payé/échoué, différence entre intimité et résolution ; aucun nouveau média |

### 10.2 Mathilde `#045/#046`

| Dimension | Valeur transportable |
|---|---|
| Fait connu de Player | niveau M-B3, limites, départ, statut d'aftercare et secret envers Marie |
| Fait connu du personnage | Mathilde connaît acte, contrôle, sortie, responsabilité envers Marie et qualité de l'aftercare |
| Fait connu de Marie | aucun détail automatique ; seulement ce qu'elle observe/acquiert via une révélation ou une trace authored |
| Fait encore caché | `fact_mathilde_physical_event_occurred` tant que Marie ne l'a pas acquis ; `#045/#046` ne peuvent pas le révéler |
| Trace durable | `j11_mathilde_physical_aftercare_01` + `fact_mathilde_physical_event_occurred(physical_level=MATHILDE_M_B3)` |
| Promesse | aucune répétition ni relation promise ; clarification future possible seulement |
| Obligation | `aftercare_mathilde_j11`; départ matériel et vérité/conséquence envers Marie restent distincts |
| Aftercare | `PAID` ou `FAILED`; micro-retour Mathilde N8 varie selon ce statut |
| Audience | trace et fait privés Mathilde/Player ; Marie seulement après acquisition authored ; médias joueur |
| Conséquence immédiate | `PHYSICAL_SECRET`, départ/couchage indépendant, progression fermée jusqu'à traitement approprié |
| Disponible à J17 | fait matériel caché → garde `DOUBLE_LIFE_FRAGILE`; échec connu de Marie selon N8 → possible `FRACTURE`; micro-retour sans nouvelle scène |
| Disponible à J19 | conséquence seulement ; aucun replay, aucune nouvelle progression ni compensation par un autre personnage |
| Disponible à J21 | secret révélé/caché, aftercare et départ comme faits de vérité/posture ; jamais détail sexuel exhaustif |

### 10.3 Sandra `#079/#080`

| Dimension | Valeur transportable |
|---|---|
| Fait connu de Player | rencontre exacte ou arrêt, acte canonique si atteint, absence de droit futur, aftercare et dette éventuelle |
| Fait connu du personnage | Sandra connaît acte/arrêt, contrôle, non-regret ou recul, ce qu'elle décide ou non de dire à Jeff |
| Fait connu de Marie | rien automatiquement ; uniquement révélation directe ou conséquence authored ultérieure |
| Fait encore caché | rencontre et dette envers Marie/Jeff tant qu'elles ne sont pas révélées ; médias incapables de révéler |
| Trace durable | fait authored privé de rencontre/acte/arrêt + statut J18/J19 ; aucun identifiant runtime sur la baseline |
| Promesse | aucune prochaine fois, relation, exclusivité ou secret commun promis |
| Obligation | `DUE` dès le début de la rencontre ; arrêt précoce : check-in/espace/sortie sans `#080`; `#079` atteint : `#080` obligatoire puis suivi J19 ; vérité de Player envers Marie selon état du couple, récit Sandra/Jeff sous contrôle de Sandra |
| Aftercare | branche arrêt précoce : `#080` `NOT_APPLICABLE`, `PAID/FAILED` selon 7.5.1 ; branche `#079` atteint : `#080` + J19, `PAID/FAILED` selon 7.5.2 ; « demander si elle regrette » est `FAILED` |
| Audience | fait Sandra/Player ; Marie/Jeff seulement par révélation authored ; médias joueur |
| Conséquence immédiate | aucune prochaine fois ; Jeff revient ; Sandra décide son récit ; dette envers Marie possible |
| Disponible à J17 | aucun fait de `#079` car la projection actuelle est postérieure ; J17 fournit seulement l'état qui autorise ou bloque la future scène |
| Disponible à J19 | priorité absolue du module Sandra dans les deux branches ; arrêt précoce : état présent/autonomie sans `#080`; `#079` atteint : `#080` seule réutilisation et suivi obligatoire ; « demander si elle regrette » reste `FAILED` |
| Disponible à J21 | branche exacte, statut `PAID/FAILED`, fait révélé/caché, dette et posture ; `#080` absent car `NOT_APPLICABLE` n'est jamais un échec à lui seul ; jamais `#079`, flashback, preuve ou répétition |

### 10.4 Lecture obligatoire de N8 et ordre J21

N9 ne modifie ni les six états N8 — `RECONQUEST_ACTIVE`,
`PROVISIONAL_AGREEMENT`, `RECONFIGURATION_NEGOTIATION`,
`DOUBLE_LIFE_FRAGILE`, `FRACTURE`, `SEPARATION` — ni les huit règles ordonnées de
`_resolve_j17_couple_state()` dans `game/scripts/runtime/season_1/Season1State.gd`.
Les traces W4 ne sont que des entrées factuelles autorisées ; elles n'ajoutent aucun
choix et ne changent aucune priorité.

J21 doit suivre partout :

`conséquences → trace/posture → s1_m5_marie_player_final_conversation → décision/logistique → épilogues`

J21 peut rappeler un fait acquis, constater `PAID/FAILED`, réutiliser une trace dans
son audience, confronter une version à un fait et préparer la conversation. J21 ne
rejoue aucune scène W4, ne reproduit aucune intensité sexuelle, ne transforme aucun
média non diégétique en preuve, n'ajoute aucun consentement rétroactif, ne convertit
aucun payoff en pardon/droit futur et ne paie aucun aftercare manquant.

## 11. États de non-déclenchement

L'absence de scène n'engendre aucun état `MISSED`, aucune faute, punition, absence
narrative ou perte de progression par défaut.

### 11.1 Marie `#051`

| Catégorie | Cas authored | Conséquence autorisée |
|---|---|---|
| Préconditions non réunies | pivot non-Marie, présence/dîner insuffisants, P09/P10 non conformes, dette ou obligation active | branche Marie non adulte correspondant aux choix existants ; aucun payoff dû |
| Refus/retrait | choix sexe différé/refus, Marie ou Player change d'avis, hésitation non reconfirmée | arrêt respecté ; désir peut rester vrai ; aucune pénalité |
| Contexte incompatible | jalousie/route extérieure utilisée comme repli, intoxication, impossibilité d'aftercare | scène bloquée ; conséquence du contexte seulement |
| Obligation antérieure non résolue | P10/obligation `DUE` ou `FAILED` non traitée | priorité à l'obligation ; aucun droit reporté |
| Vérité insuffisante | reconquête non construite ou désir utilisé comme promesse de réparation | proximité/refus authored ; pas de W4 |
| Opportunité non proposée | conditions sans proposition Marie | aucune dette, aucun refus implicite |
| Proposition refusée | choix Player de différer/refuser | réponse Marie non punitive ; pas de compensation |
| Scène interrompue | arrêt avant/pendant progression | seuls beats vécus ; pas de `#051`; aftercare ajusté au vécu |
| Branche différente | autre pivot principal J11 | branche choisie uniquement ; Marie n'est pas une récompense de repli |

### 11.2 Mathilde `#045`

| Catégorie | Cas authored | Conséquence autorisée |
|---|---|---|
| Préconditions non réunies | regard/effet/initiative/sécurité absents, M-B2 non crédible | M-A, M-B1, M-B2 ou distance selon choix réels ; aucun M-B3 dû |
| Refus/retrait | M-B2 maintenu, arrêt physique, correction ou départ Mathilde | arrêt non punitif ; autonomie et départ conservés |
| Contexte incompatible | dépendance au logement, absence Marie organisée, transport/couchage indisponible | scène bloquée ; aucune punition sexuelle |
| Obligation antérieure non résolue | dette domestique/matérielle ou conséquence prioritaire | priorité à l'obligation ; pas de progression |
| Vérité insuffisante | secret envers Marie nié, intention de Mathilde non nommée | branche bornée/fermée ; aucune scène inventée |
| Opportunité non proposée | Mathilde ne propose pas M-B3 | aucune faute ni manque authored |
| Proposition refusée | Player refuse ou maintient M-B2 | Mathilde conserve initiative et sortie ; pas de sanction |
| Scène interrompue | arrêt avant contact central ou pendant | pas de `#045`; sortie/aftercare fidèle au vécu |
| Branche différente | autre pivot J11 ou route loyauté/distance | conséquence de cette branche seulement ; aucune compensation |

### 11.3 Sandra `#079`

| Catégorie | Cas authored | Conséquence autorisée |
|---|---|---|
| Préconditions non réunies | confiance/audiences/désir/route insuffisants, `C18-01` non résolu | `C18-02` standard ou fermeture réelle ; aucun payoff dû |
| Refus/retrait | proposition retirée, refus honnête Player, changement d'avis Sandra | désir peut rester vrai ; aucune image adulte centrale ni punition |
| Contexte incompatible | état J17 bloque, mensonge sur couple, violation de trace, intoxication, Jeff/Marie utilisés comme permission | branche adulte bloquée ; conséquence de vérité/audience conservée |
| Obligation antérieure non résolue | audience/trace/dette/limite non réparée | priorité à la conséquence ; pas d'intimité compensatoire |
| Vérité insuffisante | statut du couple falsifié ou double vie non consciemment reconnue | scène bloquée ; contradiction transportée |
| Opportunité non proposée | Sandra ne propose pas | aucune dette, aucun accès futur |
| Proposition refusée | refus Player | désir reconnu sans compensation ni nouvelle proposition automatique |
| Scène interrompue | avant rencontre : aucune image et aucune obligation ; après début de rencontre mais avant `#079` : `#079` non produit et `#080` `NOT_APPLICABLE` | aftercare `DUE` adapté à l'arrêt précoce ; absence de `#080` jamais `FAILED` à elle seule ; critères `PAID/FAILED` de 7.5.1 ; pas de complétion inventée |
| Branche différente | résolution standard/protective/trust broken | `C18-02` standard et conséquences propres ; aucun contenu adulte compensatoire |

## 12. Contrats des futurs lots de scriptage

### 12.1 Lot Marie `#051/#052`

| Champ | Fiche de scriptage |
|---|---|
| Objectif dramatique | rendre explicite l'intimité du couple sans faire du sexe une réparation |
| Point d'entrée | choix de reconquête éligible, après consentement écrit, transition hors téléphone |
| Préconditions | section 5.2, toutes nécessaires |
| Participants | Marie, Player ; aucun tiers, aucun appareil |
| Beats obligatoires | initiative/co-initiative Marie ; réponse Player ; check avant acte ; acte/progression W4 lisible ; réaction mutuelle ; arrêt possible ; sortie ; quotidien/#052 |
| Beats interdits | ellipse W3, Marie passive/générique, pardon, ouverture, jalousie, droit futur, média diégétique |
| Choix | conserver le point UI existant à trois options ; checks/arrêt internes, aucun nouveau bouton |
| Convergence | toutes les branches reviennent au quotidien/J12 sans prétendre le même fait sexuel |
| Acte physique | sexualité conjugale explicite, acte central unique ou courte progression, rapport complet possible selon section 5.3 |
| Média | `#051` seulement si centre atteint ; `#052` pour sortie/quotidien ; table section 9 |
| Sortie/aftercare | check corporel immédiat, `aftercare_marie_j11`, paiement J12 |
| Conséquences/traces/audiences | `MARIE_ADULT_RECONQUEST`, obligation, Marie/Player ; médias joueur |
| Réussite éditoriale | W4 par action compréhensible, voix domestique Marie, consentement actuel, conflit toujours actif |
| Risques | séductrice générique, sexe-pansement, répétition de la scène Mathilde, conclusion trop heureuse |
| Fichiers futurs probablement concernés | `game/data/conversations/chapter_11_marie_return.json`, `game/data/conversations/chapter_12_obligations.json`, `game/data/runtime/season_1/j11_runtime_map.json`; leur modification n'est pas autorisée par N9 |

### 12.2 Lot Mathilde `#045/#046`

| Champ | Fiche de scriptage |
|---|---|
| Objectif dramatique | rendre explicite le premier secret sexuel domestique tout en maintenant contrôle, non-pénétration, départ et Marie comme conséquence |
| Point d'entrée | proximité puis M-B3 proposés par Mathilde, après baiser négocié |
| Préconditions | section 6.2, toutes nécessaires |
| Participants | Mathilde, Player ; Marie absente indépendamment mais moralement présente |
| Beats obligatoires | initiative Mathilde ; consentement à chaque étape ; contact mutuel précis ; correction/retrait ; sortie nette ; couchage indépendant ; MA1/MA2/MA3 ; #046 |
| Beats interdits | pénétration, permission domestique, dépendance, victoire sur Marie, répétition promise, photographie, deuxième scène J12 |
| Choix | conserver trois points UI existants à trois options ; aucun bouton pendant la co-présence |
| Convergence | M-B3, M-B2 et arrêt convergent sans prétendre les mêmes faits ; J12 lit aftercare réel |
| Acte physique | nudité explicite + contact sexuel mutuel explicite et successif, aucune pénétration |
| Média | `#045` seulement si centre atteint ; `#046` selon sortie réelle |
| Sortie/aftercare | séparation de l'acte et du couchage ; `PAID/FAILED` exacts section 6.4 |
| Conséquences/traces/audiences | `fact_mathilde_physical_event_occurred`, `j11_mathilde_physical_aftercare_01`, `aftercare_mathilde_j11`, Mathilde/Player |
| Réussite éditoriale | voix en fragments/corrections, contrôle sans juridisme, non-pénétration incontestable, départ libre, conséquence J12/J17 lisible |
| Risques | juridisme uniforme, crudité générique, consentement global, domestique = permission, répétition de Marie |
| Fichiers futurs probablement concernés | `game/data/conversations/chapter_11_mathilde_return.json`, `game/data/conversations/chapter_12_obligations.json`, `game/data/runtime/season_1/j11_runtime_map.json`; leur modification n'est pas autorisée par N9 |

### 12.3 Lot Sandra `#079/#080` et aftercare J19

| Champ | Fiche de scriptage |
|---|---|
| Objectif dramatique | payer confiance ancienne et tentation par l'acte canonique contrôlé par Sandra, puis rendre les conséquences ordinaires prioritaires |
| Point d'entrée | `C18-01` résolu, état du couple compatible, invitation/consentement maintenus |
| Préconditions | section 7.2, toutes nécessaires |
| Participants | Sandra, Player ; Jeff et Marie absents de l'acte mais présents comme conséquences |
| Beats obligatoires | invitation Sandra ; droit de départ ; téléphone hors d'usage ; progression lente ; confirmation avant pénétration ; Sandra au-dessus/rythme ; arrêt ; #080 ; messages J18 ; module J19 en premier |
| Beats interdits | autre acte central, Sandra passive, photo, appareil, droit futur, secret cogéré, Jeff permission/participant, flashback J19 |
| Choix | conserver les trois points authored J18–J19 décrits par N7 ; aucun choix oral pendant l'acte |
| Convergence | proposition retirée, arrêt, intimité et branche standard convergent avec des faits distincts ; aucune complétion inventée |
| Acte physique | rapport vaginal pénétratif, Sandra au-dessus face à Player et contrôlant le rythme |
| Média | `#079` au milieu de l'acte atteint ; `#080` sortie fidèle, seule réutilisation adulte J19 |
| Sortie/aftercare | vérification/distance immédiates puis module J19 prioritaire ; états section 7.5 |
| Conséquences/traces/audiences | fait privé Sandra/Player, dette Marie/Jeff selon contexte, médias joueur uniquement |
| Réussite éditoriale | voix Sandra précise, humour/détour protecteur, intensité par confiance, arrêt lisible, non-regret sans permission |
| Risques | explicite abrupt, performance générique, double vie triomphale, Jeff monstrueux/effacé, #079 traité comme photo |
| Fichiers futurs probablement concernés | `game/data/conversations/chapter_18_sandra_resolution.json`, `game/data/conversations/chapter_19_private_versions.json`, `game/data/runtime/season_1/j18_runtime_map.json`, `game/data/runtime/season_1/j19_runtime_map.json`, `game/scripts/runtime/season_1/Season1State.gd`; leur modification n'est pas autorisée par N9 |

## 13. Préparation de `s1_m5_marie_player_final_conversation`

| Payoff | Explicitement discutable | Posture seulement | Inconnu de Marie | Révélation préalable | Violation active possible | Réparation réelle | Sans rapport direct avec la décision du couple |
|---|---|---|---|---|---|---|---|
| Marie `#051` | reprise d'intimité, distinction désir/réparation, statut aftercare | familiarité, prudence, confiance non absolue | rien de la scène elle-même | non | aftercare échoué ou faute séparée, jamais le sexe consenti | payer l'aftercare ; traiter chaque mensonge/audience/promesse par son mécanisme | détail physique, composition de `#051/#052`, intensité sexuelle |
| Mathilde `#045` | fait seulement si Marie l'a acquis/révélé ; aftercare et effet sur vérité | gêne, distance, départ, contradiction de Player | acte/trace privés tant qu'aucune acquisition authored | oui avant discussion explicite | fait matériel caché, version incompatible, aftercare échoué connu, audience violée | aftercare payé + vérité/audience/obligation effectivement traitées ; jamais la scène elle-même | détail des gestes, média non diégétique, disponibilité future Mathilde |
| Sandra `#079` | fait révélé seulement s'il touche vérité, version du couple, règles ou dette | silence, contradiction, dette ou posture Player | rencontre/acte/aftercare sans révélation | oui avant accusation ou discussion explicite | double vie, mensonge de statut, dette active, aftercare/limite violés | vérité, notification/restitution/limite et conséquence payées ; sexe non réparateur | détail de l'acte, média `#079/#080`; après séparation réelle, tout élément sans effet sur accord/logistique |

La conversation finale ne résume pas les scènes sexuelles. Elle décide à partir de
la vérité réellement disponible, de la compatibilité des versions, des règles, des
conséquences, de l'autonomie et du droit de refus de Marie, du choix de relation et
de la logistique future. Une révélation doit précéder toute conclusion qui l'utilise.
La trace ou son contrôleur ne décide jamais le couple.

## 14. Gouvernance documentaire

La colonne « supersédé » ne demande aucune modification du document historique ;
elle borne seulement son autorité pour les futurs lots.

| Chemin exact | Statut | Autorité retenue | Éléments encore valides | Éléments supersédés | Impact futurs scripts W4 | Impact J21 |
|---|---|---|---|---|---|---|
| `docs/narrative/R8C_N7_1_SEASON_STRUCTURE_RUNTIME_PROJECTION_AND_N8_ENTRY_CONTRACT.md` | Canon | première sur structure/projection | hiérarchie, six états, huit règles, finale autonome | anciens jours comme identités, J17 comme finale | séquences indépendantes des jours | ordre normatif et identité finale |
| `docs/narrative/R8C_N7_W4_PAYOFF_WRITTEN_RECONCILIATION.md` | Canon | première sur bornes W4 N7 | trois payoffs, niveaux, aftercares, #045/#051/#079 | toute lecture W3 comme livraison finale | base directe des trois scripts | conséquences sans replay |
| `docs/narrative/R8C_N7_J17_J21_CONTINUITY_AND_AFTERCARE_PLAN.md` | Canon | première sur raccords N7 | micro-retours, transport, priorité Sandra J19, zéro asset J21 | quatre sorties J17 avant N8 | aftercares porteurs de conséquences | trois fonctions réutilisées, pas trois assets |
| `docs/narrative/R8C_N7_REVISION_PACKETS_AND_ACCEPTANCE_GATES.md` | Canon | première sur gates de scriptage | préconditions, choix, beats, actes autorisés/interdits | écarts runtime désormais fermés par N8 sur J17 | critères éditoriaux exacts | paquet final reste futur |
| `docs/narrative/R8C_N6_CANONICAL_SCENE_PORTFOLIO_INVENTORY.md` | Canon | inventaire de portefeuille | mouvements, séquences, parents, projection, gaps | tout constat runtime remplacé par N8 sur J17 | garde les unités C11-03/C11-06/C18-02 | J21 zéro nouveau fichier |
| `docs/narrative/R8C_N6_CONTENT_PRODUCTION_FORECAST_AND_ROADMAP.md` | Canon | prévision de production | dépendances, 84 fichiers, cinq révisions ciblées | état des révisions après N7/N8 | ordre de production et QA | réutilisations seulement |
| `docs/narrative/R8C_N6_VISUAL_REWARD_AND_PHOTO_COVERAGE_AUDIT.md` | Canon | inventaire média | IDs #045/#046/#051/#052/#079/#080, V/NV, rôles | lecture de couverture J17 antérieure à N8 | niveaux et fonctions des six médias | aucune production nouvelle |
| `docs/narrative/R8C_N6_EROTIC_AND_PORNOGRAPHIC_PROGRESSION_MAP.md` | Canon | taxonomie éditoriale | échelles W et V/NV, progression différenciée | trois centres W3 comme état final | cible W4 et non-redondance | aucun contenu sexuel final |
| `docs/canon/dialogues/NAR_ADULT_01_PAYOFFS_J11_MARIE_MATHILDE.md` | Canon | canon adulte non contredit | éligibilités, non-pénétration Mathilde, rapport complet possible Marie, J12 | libellés de jours comme architecture durable | source détaillée Marie/Mathilde | fait/aftercare seulement |
| `docs/canon/dialogues/NAR_ADULT_02_PAYOFF_SANDRA_J18.md` | Canon | canon adulte sauf arbitrage N7 | éligibilité, initiative, arrêt, chaîne entrée/centre/aftercare, J19 | acte exact « non verrouillé » remplacé par N7 | garder structure, appliquer acte N7 | conséquence, jamais flashback |
| `docs/canon/dialogues/NAR_PROD_04_PAQUET_PRODUCTION_ACTE_III_J09_J12.md` | Canon | canon production acte III | parents C11-03/C11-06, audiences joueur, enfants conditionnels | projection jour comme identité | dépendances catalogue et continuité | aucun média comme preuve |
| `docs/canon/dialogues/NAR_PROD_06_PAQUET_PRODUCTION_ACTE_V_J17_J21.md` | Canon | canon production acte V | C18-02, réutilisation #080 J19, zéro fichier J21 | J21 `READY` ne prouve pas la conversation finale | production Sandra et aftercare | budget média nul, ordre N7.1 |
| `docs/canon/dialogues/ASSET_01_MANIFESTE_PRODUCTION_VISUELLE_SAISON_1_84_FICHIERS.md` | Canon | manifeste physique | six IDs, parents et cardinalité | aucune autorisation narrative implicite | noms physiques immuables | aucune création |
| `docs/canon/bible/07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md` | Canon | canon des séquences historiques | S19/S20/S29/S30/S31/S35 et fonctions | projection ancienne de S29/J17 comme finale | mouvement et fonction | S35 recontextualisation, conversation ajoutée par N7.1 |
| `docs/canon/bible/14_CONTRAT_NARRATIF_SAISON_1_RECONCILIE.md` | Canon | canon structure/finale | décision du couple après conséquences et posture | finale réduite à une trace | borne la fonction Marie | ordre final obligatoire |
| `docs/canon/characters/MARIE_CANON_FULL.md` | Canon | première sur voix/autonomie Marie | vie partagée, désir, refus, monde propre, réparation concrète | aucune lecture obstacle/récompense | voix et quotidien #051/#052 | autonomie et logistique |
| `docs/canon/characters/MATHILDE_CANON_FULL.md` | Canon | première sur voix/route Mathilde | adulte, loyauté Marie, contrôle du regard, indépendance | disponibilité domestique ou groupe automatique | voix fragmentée, contrôle, départ | secret et vérité seulement |
| `docs/canon/characters/SANDRA_CANON_FULL.md` | Canon | première sur voix/route Sandra | adulte, Jeff, audience, trace, contrôle, retrait | Sandra définie par provocation/passivité | lenteur, humour/détour, contrôle | récit et audience, pas média-preuve |
| `docs/canon/dialogues/J01_J21_TRACE_REGISTRY.md` | Canon | registre des traces | audiences, contrôle, permanence/retrait | tout usage des médias W4 comme traces diégétiques | ne pas créer de trace-photo depuis #045/#051/#079 | conserver audience/absence |
| `docs/canon/dialogues/J01_J21_PROMISE_REGISTRY.md` | Canon | registre des promesses | promesse créée seulement par proposition explicite | toute promesse future déduite du sexe | aucune répétition/exclusivité implicite | payer/rappeler seulement promesses réelles |
| `docs/canon/dialogues/J01_J21_KNOWLEDGE_REGISTRY.md` | Canon | registre de connaissances | connaissance bornée par acquisition | omniscience Marie/Jeff | audiences des faits | révélation avant confrontation |
| `docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md` | Canon | contrat d'état narratif | faits, traces, promesses, obligations distincts | score relationnel ou consentement calculé | sémantique future sans nouvel ID N9 | transporte des records, pas des scènes |
| `docs/canon/dialogues/J11_SCRIPT_NARRATIF_COMPLET.md` | À réécrire | matière signée sous gates N7/N9 | entrées, choix, voix, sorties existantes | centres W3 Marie/Mathilde | futur lot doit atteindre W4 sans changer choix | faits transportés seulement |
| `docs/canon/dialogues/J12_SCRIPT_NARRATIF_COMPLET.md` | À réécrire | canon valide, raccord ciblé | priorités, modules Marie/Mathilde, aftercare échoué | tout raccord incomplet aux scripts W4 finaux | conserver conséquence, ajuster seulement si script l'exige | aucun replay |
| `docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md` | À réécrire | matière historique sous N7.1/N8 | départ, foyer, six familles, faits de route | J17 finale et toute logique non conforme aux huit règles | lecture des traces seulement | état provisoire uniquement |
| `docs/canon/dialogues/J18_SCRIPT_NARRATIF_COMPLET.md` | À réécrire | matière canon Sandra sous N7/N9 | invitation, décision de trace, arrêt, retombée | centre W3/acte indéterminé | futur script #079/#080 | conséquence à transporter |
| `docs/canon/dialogues/J19_SCRIPT_NARRATIF_COMPLET.md` | À réécrire | matière canon du module prioritaire | Sandra en premier, trois postures, aucune prochaine fois | absence dans le runtime actuel | lot Sandra doit fermer le module | statut aftercare, aucun flashback |
| `docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md` | À réécrire | matière historique sous N7.1 | matin, trace, posture, logistique/épilogues utilisables | ordre ancien et absence de conversation autonome servie | aucun script W4 ici | appliquer l'ordre normatif sans nouveau média |
| `game/scripts/runtime/season_1/Season1State.gd` | Runtime | réalité N8 et états existants | obligations Marie/Mathilde, faits/trace Mathilde, six états, huit règles | aucune branche adulte Sandra/J19 | lire sans modifier dans N9 | J21 actuel incomplet au regard du canon |
| `game/scripts/runtime/season_1/J17RuntimeProvider.gd` | Runtime | projection N8 | livraison des deux micro-retours, record de continuité | aucune fonction finale | lire les traces W4 existantes | ne remplace pas J21 |
| `game/data/conversations/chapter_17_departure_and_couple.json` | Runtime | texte servi N8 | micro-retours Mathilde `PAID/FAILED` et Marie six états | aucune réécriture W4 | réactions J17 seulement | état provisoire transporté |
| `game/data/conversations/chapter_11_marie_return.json` | Runtime | texte actuellement servi | choix et raccords existants | centre Marie encore sous cible W4 | futur lot Marie seulement | fait runtime actuel |
| `game/data/conversations/chapter_11_mathilde_return.json` | Runtime | texte actuellement servi | M-B3, aftercare et sorties | centre Mathilde encore sous cible W4 | futur lot Mathilde seulement | fait/échec transportés |
| `game/data/conversations/chapter_12_obligations.json` | Runtime | conséquence actuellement servie | priorité échec Mathilde, paiement Marie | aucun dialogue W4 final | raccord futur conservateur | conséquence seulement |
| `game/data/conversations/chapter_18_sandra_resolution.json` | Runtime | réalité servie J18 | décision standard de trace Sandra | branche adulte absente | futur lot Sandra distinct | ne prouve aucun #079 |
| `game/data/conversations/chapter_19_private_versions.json` | Runtime | réalité servie J19 | foreground Pauline/Raphaëlle/fallback | aftercare Sandra absent | futur lot Sandra doit précéder | ne remplace pas l'aftercare |
| `game/data/conversations/chapter_21_final_trace.json` | Runtime | réalité servie J21 | matin, trace, posture | conversation finale autonome absente | aucun script W4 | futur lot J21 séparé |

## 15. Contrat de transport vers le runtime futur

1. Réutiliser les identifiants runtime existants pour Marie et Mathilde ; ne pas les renommer selon un nouveau jour.
2. Ne créer un futur identifiant Sandra qu'au lot d'implémentation autorisé, après validation produit et script ; N9 n'en réserve aucun.
3. Persister séparément : fait de scène, niveau réellement atteint, arrêt éventuel, obligation d'aftercare, statut d'aftercare, audience et conséquence. Un booléen d'éligibilité ne prouve pas la scène.
4. Ne jamais persister un score de consentement/confiance/désir ou une permission future dérivée.
5. Une trace média non diégétique n'entre pas dans `traces` comme photographie ; seul un fait/record authored peut être transporté.
6. À J17, employer exclusivement les six états et huit règles N8. Les payoffs n'ajoutent ni règle, ni choix, ni priorité.
7. À J19, l'aftercare Sandra précède tout autre foreground si la rencontre a commencé ; après arrêt précoce, `#080` est `NOT_APPLICABLE`; si `#079` a été atteint, `#080` est la seule réutilisation adulte autorisée.
8. À J21, lire les états terminaux (`PAID`, `FAILED`, retrait, révélation, dette) sans les rouvrir et sans servir un média jamais atteint.
9. `s1_m5_marie_player_final_conversation` reste une future séquence authored autonome ; elle n'est ni J17, ni la trace, ni un résumé des payoffs.
10. Aucune connexion ou migration A1–A10 n'est autorisée par ce contrat.

## 16. Gates de revue produit et de livraison

### 16.1 Gate des trois payoffs

- [x] Marie `#051/#052`, Mathilde `#045/#046` et Sandra `#079/#080` ont une identité authored, une projection, des préconditions, une initiative, un acte autorisé, un arrêt, une sortie, un aftercare, des faits, traces, audiences et conséquences.
- [x] Le consentement est spécifique, révocable et non transférable.
- [x] Aucun payoff ne crée pardon, ouverture, disponibilité, répétition, exclusivité ou droit corporel.
- [x] Sandra conserve l'acte exact N7 ; Mathilde reste sans pénétration ; Marie conserve l'enveloppe conjugale complète autorisée sans décision narrative ajoutée.

### 16.2 Gate aftercare et continuité

- [x] Les fonctions immédiate, physique, émotionnelle, relationnelle et réparatrice sont distinguées.
- [x] `PAID` et `FAILED` sont fermés pour les trois chaînes.
- [x] J12, J17, J19 et J21 transportent uniquement des faits acquis.
- [x] Les six états et huit règles N8 restent inchangés.
- [x] J19 reste prioritaire pour Sandra et ne rejoue pas `#079`.
- [x] J21 suit `conséquences → trace/posture → conversation Marie/Player → décision/logistique → épilogues`.
- [x] J21 ne produit aucun nouveau fichier et ne remplace aucun aftercare manquant.

### 16.3 Gate média et production

- [x] Les six médias ont personnage, fonction, niveau d'inventaire N6, niveau visuel canonique, statut de production, maturité d'écriture, diégèse, moment, cadrage, obligatoires/interdits, identification Player, continuité, espace, émotion, autonomie, relations dialogue/aftercare, dépendances, description auteur et justification.
- [x] Les six médias sont `SPECIFIED_NOT_PRODUCED`; `W4` qualifie l'écriture du payoff et ne prouve ni existence, ni génération, ni validation, ni intégration du média.
- [x] Aucun média n'a été généré et aucun prompt graphique définitif n'est fourni.
- [x] Aucun média non diégétique n'est traité comme preuve ou fichier de la fiction.

### 16.4 Gate de non-déclenchement et scriptage

- [x] Chaque payoff couvre préconditions absentes, refus/retrait, contexte incompatible, obligation, vérité, opportunité, proposition, interruption et branche différente.
- [x] Aucun état `MISSED`, faute ou punition n'est créé par défaut.
- [x] Les trois lots futurs sont séparables et leurs fichiers probables ne sont pas autorisés à modification par N9.
- [x] Aucun dialogue complet W4, aucun dialogue final J21 et aucune nouvelle décision produit ne sont écrits.

## 17. Statut

Le contrat est approuvé sans réserve avec le statut :

`W4_PAYOFF_AFTERCARE_J21_CONTINUITY_CONTRACT_APPROVED`

Approbation produit : commit revu `81ba4070d5b032c935b5c85c67b3f560c1c9c101` ;
août 2026.

Blocages produit : aucun. Si une future revue demande un quatrième payoff, la
suppression d'un payoff, un autre acte Sandra, un média diégétique, une scène comme
réparation, un nouveau score/état, une modification des six états J17, un autre ordre
J21, une conversation finale complète, un changement de volume secondaire ou une
connexion A1–A10, la réponse contractuelle est `BLOCKED_PRODUCT_DECISION` jusqu'à
décision produit explicite.
