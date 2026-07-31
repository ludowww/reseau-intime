# Réseau Intime — Matrice canonique d’atteignabilité J01–J21

## Statut

**Catégorie : Contrat narratif pré-runtime**

**Périmètre : chemins majeurs, fermetures, promesses, aftercares et finales de la saison 1**

Cette matrice vérifie que :

- aucune scène importante ne dépend d’un score arbitraire ;
- aucune route ne naît d’un seul choix ;
- chaque promesse active possède une sortie ;
- chaque état J17 atteint une finale J21 cohérente ;
- aucune route fermée ne se rouvre sans événement ;
- chaque scène adulte possède un aftercare ;
- la finale ne fabrique pas une trace ou une contradiction.

---

# 1. Autorités

Ordre de lecture :

```text
scripts J01–J21
→ audit J01–J09
→ audit global J01–J21
→ lot A
→ NAR_PROD_07_ADULT_PAYOFF_AUDIT_SPECIFICATION.md
→ NAR_ADULT_01_PAYOFFS_J11_MARIE_MATHILDE.md
→ NAR_ADULT_02_PAYOFF_SANDRA_J18.md
→ NAR_ADULT_03_PAYOFFS_PAULINE_RAPHAELLE.md
→ NAR_PROD_05_AMENDEMENT_COHERENCE_J10_J12.md
→ registres de traces / promesses / connaissances
→ contrat d’état borné
→ présente matrice
```

En cas de contradiction, le document le plus bas dans cette chaîne prévaut jusqu’au lot C de consolidation.

---

# 2. Principe d’atteignabilité

Une scène est atteignable si :

```text
préconditions relationnelles vraies
+ promesses nécessaires actives
+ traces nécessaires accessibles
+ connaissances nécessaires sourcées
+ aucune limite bloquante
+ aucune obligation prioritaire due
+ temps et lieu compatibles
```

Elle n’est pas atteignable par :

- score élevé ;
- personnage propriétaire d’une vague ;
- sélection d’un nom ;
- simple disponibilité calendaire ;
- absence d’une autre route ;
- fermeture récente d’une relation utilisée comme compensation.

---

# 3. Étapes de la saison

## Acte I — J01–J04

Sorties minimales :

```text
couple_state = BASELINE_SHARED_LIFE
mathilde_state = FAMILY_GUEST
sandra_state = DISTANT_FRIEND ou RECONNECTION_OPEN
pauline_state = PUBLIC_ONLY
raphaelle_state = PROFESSIONAL_ONLY
nico_state = ORDINARY_FRIEND
```

Aucune route adulte ni contradiction dure obligatoire.

## Acte II — J05–J08

Objectifs :

- heure Marie ;
- continuité extérieure optionnelle ;
- confidence Nico ;
- obligations réellement choisies ;
- première collision temporelle possible.

Sorties extérieures maximales :

```text
Sandra = RECONNECTION_OPEN
Mathilde = LOOK_ACKNOWLEDGED
Raphaëlle = CREATIVE_ACCESS préparatoire au maximum
Nico = CONFIDENCE_ACTIVE
```

Aucune propriété de route.

## Acte III — J09–J12

Objectifs :

- visibilité Marie ;
- une ligne extérieure incarnée ;
- intention, limite ou retrait J11 ;
- convergence J12.

Une seule relation extérieure reçoit le pivot principal J10–J11.

Les autres restent :

- fermées ;
- différées ;
- ou secondaires sans progression équivalente.

Les 22 outcomes J10 sont couverts par la matrice NAR-PROD-05 §3. Une fermeture
sans continuation légitime produit `RESPIRATION`, jamais une autre relation en
compensation.

La scène adulte Marie J11 exige cumulativement le pivot Marie, `j10_pivot ==
NONE`, un outcome dîner autorisé, une présence J09 dans l’ensemble signé, un
état couple autorisé, P09 terminale, P10 absente ou payée, aucune obligation
impayée, P-A sélectionné et un consentement actuel. Elle échoue fermée si une
preuve manque.

## Acte IV — J13–J16

Objectifs :

- conséquence prioritaire ;
- découverte limitée ;
- collision de promesses existantes lorsqu’elle est prouvée ;
- mutation sans collision lorsque moins de deux promesses admissibles subsistent ;
- paiement avant résolution.

Aucune nouvelle route majeure.

## Acte V — J17–J21

Objectifs :

- départ Mathilde ;
- état couple ;
- état Sandra ;
- états Pauline et Raphaëlle ;
- position Nico ;
- trace finale.

Aucune route tardive.

---

# 4. Matrice couple J17 → J21

| `couple_state` J17 | Conditions minimales | J18–J20 autorisé | J21 matin | Postures finales | Sortie cohérente |
|---|---|---|---|---|---|
| `RECONQUEST_ACTIVE` | actes répétés, règle concrète, pas de secret grave actif non reconnu | conséquences et fermetures seulement ; aucune nouvelle progression extérieure | heure réelle et présence ordinaire | A, B ; C seulement si contradiction préexistante compatible, cas rare | reconquête continue sans pardon total |
| `PROVISIONAL_AGREEMENT` | problème reconnu, règles temporaires, checkpoint post-J21 | états extérieurs figés ou contenus | chambres / espaces séparés, rappel jeudi 20 h 30 | A ou B ; C si contradiction déjà active | accord reste provisoire jusqu’au checkpoint |
| `RECONFIGURATION_NEGOTIATING` | audiences réparées, droit de refus Marie, pause active | aucune personne extérieure engagée ; attirances contenues | règle rappelée jusqu’au checkpoint | A ou B ; C uniquement pour secret déjà actif, qui menace la négociation | négociation réelle, aucune ouverture automatique |
| `DOUBLE_LIFE_FRAGILE` | secret ou version importante maintenue | résolutions extérieures sombres possibles | Marie demande une heure ou constate une incohérence observable | A, B ou C | contradiction maintenue ou première réparation |
| `FRACTURE` | ancien cadre retiré, pratique encore liée | aucune route de consolation ; relations extérieures gardent leur propre état | dépenses, documents, organisation | A ou B ; C si dette déjà active | fracture pratique, future discussion non garantie |
| `SEPARATION` | fin du couple reconnue ou organisation active | aucune disponibilité extérieure automatique | cartons, heure précise, logement distinct | A ou B ; C seulement pour dette extérieure préexistante | séparation digne ou contradiction emportée ailleurs |

## Invariants

1. J21 ne change jamais `couple_state` vers un état plus favorable par un seul message.
2. `PROVISIONAL_AGREEMENT` et `RECONFIGURATION_NEGOTIATING` possèdent `couple_review_due_at` après J21.
3. `SEPARATION` ne rend pas Sandra, Pauline ou Raphaëlle disponibles.
4. `RECONQUEST_ACTIVE` bloque une nouvelle progression extérieure non clarifiée.
5. `DOUBLE_LIFE_FRAGILE` ne peut pas être présenté comme fin propre.

---

# 5. Atteignabilité Sandra

| État final | Préconditions | Fermetures | Trace J21 possible | Extension possible |
|---|---|---|---|---|
| `FRIENDSHIP_RESTORED` | café ou échange réel, limites respectées, amitié choisie | pression, comparaison, transfert d’image | `j01_sandra_lunch_memory_soft` ou message de conservation | café amical précis |
| `PRIVILEGED_CONFIDENCE` | confiance répétée, aucune exigence de définition, audience respectée | usage de confidence comme alibi | photo déjeuner ou absence de nouvelle image | continuité de confidence |
| `DESIRE_RECOGNIZED_CONTAINED` | manque ou désir reconnu, rythme Sandra respecté | demande de répétition ou ultimatum | photo choisie gardée ou inaccessible | rencontre future non promise |
| `PARALLEL_TENDER_RELATION` | secret consciemment choisi, Jeff et Marie reconnus comme exclus | découverte, retrait Sandra, refus de dette | trace privée ou impression contrôlée | route sombre avec conséquence |
| `LATE_INTIMACY` | progression longue, consentement actuel, contexte crédible | aftercare dû, pression future | séquence visuelle conditionnelle réellement servie, puis impression ou message après-coup | aucune répétition automatique |
| `PROTECTIVE_WITHDRAWAL` | Sandra choisit espace ou fermeture | relance après fermeture | image inaccessible ou conservée pour elle | retour uniquement par initiative Sandra |
| `TRUST_BROKEN` | audience violée, pression, comparaison, mensonge grave | aucune réouverture saison 1 | absence de trace / accès retiré | réparation future non garantie |

## Règles

- `sandra_cafe_saturday_1100 = CONDITIONAL` avec confirmation Sandra renseignée rend le préambule J12 obligatoire ; la confirmation Player le passe ensuite à `ACTIVE`.
- `LATE_INTIMACY` rend `aftercare_sandra_j18 = DUE` puis `PAID` avant J19.
- `LATE_INTIMACY` ne crée aucun fichier sexuel diégétique.
- la séquence visuelle J18 sert uniquement les fichiers réellement atteints et l’aftercare J19 reste dû.
- une trace `REMOVED` ne peut pas être finale comme image visible ; son absence peut être finale.
- `TRUST_BROKEN` interdit toute invitation J21.

---

# 6. Atteignabilité Mathilde

| État | Préconditions | Plafond ou sortie | J17 | J21 |
|---|---|---|---|---|
| `FAMILY_GUEST` | arrivée J02 | familiarité ordinaire | départ accompli | souvenir familial ou absence |
| `LOOK_ACKNOWLEDGED` | J06 regard reconnu sans pression | `INTENT_OPEN` possible | départ avec gêne ou limite | trace du foyer non sexualisée |
| `INTENT_OPEN` | image J10 choisie, effet reconnu | proximité ou retrait | relation clarifiée au départ | photo de famille ou limite |
| `PROXIMITY_CONSENTED` | consentement clair, aucune dépendance exploitée | pas de sexualité complète nécessaire | après-coup et départ | relation familiale, suspendue ou distante |
| `PHYSICAL_SECRET` | indépendance matérielle vraie, consentement, aftercare ; M-B2 ou M-B3 selon historique | secret et conséquence Marie | départ obligatoire ; aucune continuation domestique | trace retirée, familiale ou dette reconnue |
| `SECRET_SUSPENDED` | événement reconnu mais non poursuivi | aucune répétition | fermeture ou attente non promise | absence / relation bornée |
| `FAMILY_RELATION_PRESERVED` | limites respectées | pas de nouvel accès privé saison 1 | départ familial | photo de famille possible |
| `DISTANCE` | retrait Mathilde ou Player | aucune compensation | départ autonome | silence ou trace retirée |
| `TRUST_BROKEN` | pression, dépendance, audience violée | fermeture | départ protecteur | aucun accès Player |

## Branche physique

Sous `PHYSICAL_SECRET` :

```text
M-B2: premier passage borné
M-B3: payoff explicite sans pénétration
```

Atteignable seulement si :

```text
mathilde_has_independent_sleep_option
mathilde_can_leave_safely
marie_absence_not_engineered
current_consent
no_due_safety_obligation
```

M-B3 exige en plus toutes les conditions de `NAR_ADULT_01_PAYOFFS_J11_MARIE_MATHILDE.md`, notamment l’initiative Mathilde, M-B2 déjà crédible dans le même état, le départ réel et l’absence de droit acquis.

Le consentement courant et l’initiative sont établis dans la scène J11 ; ils ne
sont jamais hérités de J10. Après MA3 ou refus d’aftercare :

```text
aftercare_mathilde_j11 = FAILED
→ conséquence prioritaire avant J12
→ Mathilde absente de la convergence normale
→ progression physique fermée
```

Sinon :

```text
PROXIMITY_CONSENTED maximum
```

---

# 7. Atteignabilité Pauline

| État final J19 | Entrée nécessaire | Contradiction | J21 trace |
|---|---|---|---|
| `SURFACE_RESTORED` | version privée fermée ou refusée | aucune nouvelle | set public Pauline / Bastien |
| `COMPARTMENT_CLOSED` | Pauline ferme images et réflexe privé | contradiction Pauline fermée | set public ou absence privée |
| `COMPARTMENT_PROTECTED` | double adresse reconnue, règles explicites | `PAULINE_COMPARTMENT` | version privée si encore accessible ou set public contradictoire |
| `RECIPROCAL_TRACE` | message compromettant mutuel existant | `PAULINE_RECIPROCAL_TRACE` | message conservé, jamais image restaurée |
| `CONSCIOUS_MARIE_BETRAYAL` | Pauline sait légitimement que Marie est affectée | `PAULINE_COMPARTMENT` ou dette distincte | surface publique / message de dette |
| `LIMITED_BASTIEN_COLLISION` | Bastien possède source crédible limitée | selon compartiment | trace publique ou fait limité |
| `PRIVATE_CONTACT_LIMITED` | fil maintenu avec règle étroite | possible, pas obligatoire | message de limite |

## Invariants

- `fact_pauline_knows_marie_couple_fragility` doit posséder une source avant `CONSCIOUS_MARIE_BETRAYAL` détaillée.
- `COMPARTMENT_CLOSED` désactive `PAULINE_COMPARTMENT`.
- la version publique reste vraie dans tous les états.
- Bastien ne devient pas omniscient par nécessité de finale.

`COMPARTMENT_PROTECTED` peut produire T25B `j19_pauline_adult_compartment_01` seulement si :

- P19-B a été choisi ;
- une fenêtre privée crédible existe ;
- aucune dette prioritaire n’est due ;
- Pauline est foreground ;
- aucune pression n’a eu lieu ;
- aucune circulation n’est autorisée.

T25B peut être trace J21 uniquement si elle reste accessible.

---

# 8. Atteignabilité Raphaëlle

| État final J19 | Préconditions | Accès | J21 trace |
|---|---|---|---|
| `CREATIVE_TRUST` | Player reconnaît personne et processus | dossier fabrication actif, image privée distincte | `j19_raphaelle_creative_access_01` |
| `BOUNDED_FUTURE_INVITATION` | invitation explicitement acceptée | samedi 15–17 h, Maud première heure | message d’invitation, pas promesse adulte |
| `ATTRACTION_CONTAINED` | désir reconnu, règle incompatible avec progression | aucun accès nouveau | image conservée par Raphaëlle ou limite |
| `CLEAR_UNFAITHFUL_SECRET` | Marie exclue et secret nommé | accès précis possible | image ou message de contradiction |
| `BOUNDARY_REINFORCED` | Player réduit Raphaëlle au rôle ou utilise sa clarté comme alibi | compte privé et créatif fermés selon branche | accès révoqué |
| `COLLEAGUE_ONLY` | retour professionnel choisi ou confiance privée rompue | travail seulement | trace professionnelle publique ou absence privée |

## Invariants

- `BOUNDED_FUTURE_INVITATION` n’est pas atteignable si une obligation d’audience est due.
- `CLEAR_UNFAITHFUL_SECRET` active `RAPHAELLE_CLEAR_SECRET`.
- `COLLEAGUE_ONLY` interdit une image privée active.
- Maud ne crée aucune permission à la place de Raphaëlle.
- aucune collision J15 complète Raphaëlle n’est atteignable sans seconde promesse antérieure réellement signée.
- le premier baiser J11 est atteignable le même jour uniquement après envoi réel, attirance nommée, réaction réciproque et consentement actuel, dans cet ordre ; l’aide distante J10 seule ne suffit pas.
- le baiser ne crée ni photo, ni trace diégétique, ni permission future et reste fermé si P10 est active ou maintenue.

`CREATIVE_TRUST` ou `ATTRACTION_CONTAINED` peut produire T18B `j13_raphaelle_masked_adult_selected_01` seulement si :

- T18 standard ou le processus antérieur est valide ;
- R-A ou R-B a été choisi ;
- Maud est créatrice ;
- Raphaëlle sélectionne l’audience ;
- aucun brief sexuel n’est imposé.

T18B peut être trace J14 ou J21 selon son état.

---

# 9. Atteignabilité Nico

| État final J20 | Préconditions | Ce que Nico porte | Ce qu’il refuse | J21 trace |
|---|---|---|---|---|
| `GUARDRAIL` | alibi refusé ou retiré, confiance minimale | vérité, peur, faits observés | faux horaires, faux lieux | fait exact ou photo de groupe |
| `LIMITED_CONFIDANT` | confidence centrée sur Player | désir et peur de Player | images et messages des femmes | fil de confidence non montré ou absence |
| `HONEST_RIVAL` | attirance reconnue, aucune action cachée | sa propre intention | propriété Player sur Marie/Mathilde | photo sociale + règle |
| `AUTHORIZED_GAZE_PARTNER` | consentement direct nominatif de la femme | une image ou situation précise | transfert et droit futur | trace autorisée précise |
| `CONSCIOUS_ACCOMPLICE` | mensonge partagé antérieur | fait précis et dette | extension automatique | alibi existant / dette |
| `COMPROMISED_WITNESS` | heure ou trace réellement vue | fait observé | tournée d’information | `j20_nico_exact_hour_record_01` ou absence supprimée |
| `TAKING_DISTANCE` | pression, menace, images non autorisées | contact social minimal | confidences et alibis | absence du fil privé |

## Invariants

- `AUTHORIZED_GAZE_PARTNER` n’est jamais créé par Player seul.
- `TAKING_DISTANCE` interdit une nouvelle confidence obligatoire.
- `CONSCIOUS_ACCOMPLICE` peut rendre C disponible en J21 seulement si la dette reste active.
- aucune route Nico / Player romantique ou sexuelle.
- Nico utilise `S28_MUTATION_NO_COLLISION` par défaut lorsqu’aucune seconde promesse antérieure incompatible n’est prouvée.

---

# 10. Promesses critiques

| Promise ID | Création | Paiement / fermeture obligatoire | Si active et oubliée |
|---|---|---|---|
| `nico_j07_tuesday_1845` | J07 N1 | J08 | J08 non conforme |
| `marie_j09_dinner_j10_2030` | J09 M1 | J10 | pivot extérieur bloqué ou conséquence |
| `marie_j09_dinner_friday_2030` | J09/J10 | décision J11 avant 18 h, paiement à 20 h 30 | `CANCELLED` ou `FAILED`, adulte fermé |
| `sandra_cafe_saturday_1100` | J10 conditionnelle, confirmation Sandra J11 | confirmation Player puis paiement J12 | expiration ; aucun déplacement |
| `marie_j12_laverriere_presence` | J12 choix L | J12 | conséquence J13 |
| `j14_witness_clarification` | J14 D-C avec heure précise uniquement | heure promise, ou amendement/échec/annulation explicite | admissible J15 seulement si encore `ACTIVE` |
| `j14_inform_trace_controller` | audience compromise | J14 avant progression | `PAID` ou `FAILED` avant J15 ; jamais maintenue artificiellement |
| sept promesses NAR-CANON-01 | responsabilités ou engagements signés J14, activés par confirmation J15 | paiement, refus, amendement, échec ou fermeture attribuable | S28 les lit seulement si `ACTIVE` et compatible |
| `j16_priority_consequence_payment` | fin J15 seulement si conséquence réelle due | J16 | absente après fermeture propre sans urgence |
| `marie_j16_couple_conversation_j17` | J16 | J17 | définition couple unilatérale ou fracture |
| `couple_review_due_at` | J17 | après J21 | hook futur, pas dette saison 1 |
| `raphaelle_future_atelier_saturday_1500` | J19 | extension | reste conditionnelle |
| `marie_player_boxes_wednesday_1830` | J21 séparation | extension pratique | conséquence future |

Aucune promesse active ne peut être remplacée par une scène plus séduisante.

---

# 11. Aftercares et obligations

| Obligation | Création | Doit être payée avant | Sortie si refus |
|---|---|---|---|
| `aftercare_mathilde_j11` | passage physique Mathilde | toute nouvelle progression, J12 convergence | `FAILED`, préambule prioritaire, absence Mathilde et fermeture physique |
| `aftercare_marie_j11` | scène physique couple | route extérieure ou convergence | couple fragilisé |
| `aftercare_sandra_j18` | intimité tardive Sandra | développement Pauline/Raphaëlle J19 | Sandra foreground en J19 |
| `audience_repair_j14` | trace privée vue | J15 opportunité | conséquence prioritaire |
| `promise_failure_response_j15` | promesse manquée | résolution J17 | dette lisible |

Une obligation `DUE` domine toujours une promesse romantique ou sexuelle.

---

# 12. Traces J14 et J21

## J14

Atteignable uniquement si :

```text
trace_id existe
trace_state permet affichage
witness présent
interface peut réellement montrer les champs
```

Sinon :

```text
S27_MUTATION_NO_DISCOVERY
→ engagements réellement existants seulement
→ aucune garantie de collision J15
```

## J15 — Validation NAR-CANON-01

S28 complet est atteignable uniquement avec deux fiches distinctes :

```text
promise_id
status = ACTIVE
created_at = source signée J14
activated_at < collision J15
source signée exacte
personne concernée
action_due
due_at ou fenêtre exacte
accepted_by_player attribuable
paid_or_closed_at = null
```

Les actions et les fenêtres doivent être distinctes. Les fenêtres doivent être objectivement incompatibles.

| Branche | Promise A | Promise B | Source signée des deux | Collision complète ? | Mutation sinon |
|---|---|---|---|---|---|
| Pauline | `marie_j14_pauline_player_account_j15` | `pauline_j14_post_breach_return_j15` | sortie Pauline J14 + J15 §§10.3–10.6 | Oui si deux `ACTIVE` | `S28_MUTATION_NO_COLLISION` |
| Sandra | `household_j14_sandra_rule_j15` | `sandra_j14_breach_account_j15` | J14 S14-C/§21/§25 + J15 §§11.3–11.4 | Oui si deux `ACTIVE` | `S28_MUTATION_NO_COLLISION` |
| Mathilde | `mathilde_j14_household_safety_rule_j15` | obligation extérieure antérieure admissible | J14 M14 + J15 §12.3 + source extérieure antérieure | Oui seulement avec O2 réelle | `S28_MUTATION_NO_COLLISION` |
| Raphaëlle | `marie_j14_raphaelle_position_j15` | aucune seconde fiche signée | J14 R14 + activation J15 de l’unique obligation Marie | Non ; collision complète `MISSING_SIGNED_SOURCE` | `S28_MUTATION_NO_COLLISION` |
| Nico | `marie_j14_nico_hour_account_j15` | seconde fiche antérieure à prouver | J14 N14 + J15 §16.2 + seconde source signée | Non par défaut | `S28_MUTATION_NO_COLLISION` |
| Composite | paire exacte du personnage identifié | seconde fiche de la paire | notification réelle + deux sources propres | Selon paire | `S28_MUTATION_NO_COLLISION` |

Verdicts :

```text
Pauline: READY_WITH_REGISTRY_PATCH
Sandra: READY_WITH_REGISTRY_PATCH
Mathilde avec seconde obligation réelle: READY_WITH_REGISTRY_PATCH
Mathilde sans seconde obligation réelle: S28_MUTATION_NO_COLLISION
Raphaëlle: S28_MUTATION_NO_COLLISION
Raphaëlle collision complète: MISSING_SIGNED_SOURCE
Nico par défaut: S28_MUTATION_NO_COLLISION
Composite avec paire exacte: READY_WITH_REGISTRY_PATCH
Composite sans paire exacte: S28_MUTATION_NO_COLLISION
```

### `S28_MUTATION_NO_COLLISION`

Éligible lorsque :

- moins de deux promesses sont admissibles ;
- les fenêtres ne sont pas incompatibles ;
- la seconde obligation n’est pas signée ;
- une bonne gestion antérieure a fermé les autres attentes.

La mutation :

- paie, amende, refuse ou ferme l’unique obligation réelle ;
- ne fabrique aucune seconde obligation ;
- montre les autres personnages continuant leur vie ;
- conserve une conséquence Marie ou foyer seulement si elle existe ;
- prépare J16 sans prétendre qu’une collision complète a eu lieu.

T21 reste un `FACT_RECORD` avec :

```text
trace_id: j15_obligation_collision_record_01
record_type: FACT_RECORD
collision_mode: NO_COLLISION
incompatible_windows_proven: false
second_signed_obligation_present: false
urgent_consequence_remaining: true | false
current_state: ACTIVE
visual_asset: none
```

Si aucun record n’est créé :

```text
trace_id: j15_obligation_collision_record_01
current_state: NOT_CREATED
```

La mutation n’ouvre aucune route, ne crée aucune progression adulte et n’ajoute aucun fichier visuel.

## J16 — Création conditionnelle de P17

P17 `j16_priority_consequence_payment` est créée seulement lorsqu’une conséquence réelle reste due après J15.

| Sortie J15 | P17 créé ? | T21 | Entrée J16 |
|---|---|---|---|
| obligation échouée, impayée ou mensonge avec conséquence | Oui | conséquence restante | priorité 1–7 |
| refus avec conséquence signée | Oui | conséquence identifiée | paiement précis |
| obligation payée | Non | aucune urgence | préparation Mathilde / Marie / J17 |
| attente proprement fermée | Non | aucune urgence | priorité 8 |
| aucune obligation admissible et aucune dette, aucun record nécessaire | Non | `current_state: NOT_CREATED` | passage direct vers préparation |

T22 distingue :

```text
CONSEQUENCE_PAID
CONSEQUENCE_FAILED
NO_URGENT_CONSEQUENCE
DIRECT_TO_MATHILDE_MARIE_J17_PREPARATION
```

## J21

Atteignable pour toute partie si :

```text
couple_state défini
états principaux définis
aucune obligation urgente inconnue
final_trace_id résolu
```

Une absence peut être la trace finale.

---

# 13. Matrice posture finale

| Situation avant J21 | A `RULE_ACTED` | B `LOSS_ACKNOWLEDGED` | C `EXISTING_CONTRADICTION_MAINTAINED` |
|---|---:|---:|---:|
| aucune contradiction active | oui | oui | non |
| dette reconnue mais fermée | oui | oui | non |
| `COUPLE_DOUBLE_LIFE` | oui | oui | oui |
| `PAULINE_COMPARTMENT` | oui | oui | oui |
| `RAPHAELLE_CLEAR_SECRET` | oui | oui | oui |
| `NICO_SHARED_ALIBI` | oui | oui | oui si Nico reste complice |
| copie Sandra déjà secrètement conservée | oui | oui | oui |
| alibi fermé en J20 | oui | oui | non |
| trace supprimée avant J21 sans copie active | oui | oui | non |

C ne crée jamais une nouvelle violation.

---

# 14. Chemins de référence

## R1 — Reconquête Marie

```text
J01–J09 présence réelle
→ promesses payées
→ J14 vérité limitée ou aucune découverte grave
→ J15 collision prouvée ou mutation propre
→ J16 conséquence payée ou priorité 8
→ J17 RECONQUEST_ACTIVE
→ J18–J20 limites extérieures respectées
→ J21 RULE_ACTED
```

Sortie : reconquête active, aucune route extérieure supprimée définitivement, aucune progression actuelle.

## R2 — Accord provisoire

```text
tensions et vérités incomplètes
→ discussion J17 acceptée
→ règles temporaires
→ PROVISIONAL_AGREEMENT
→ checkpoint post-J21
→ J21 A ou B
```

Sortie : couple encore actif, rien d’automatique.

## R3 — Séparation

```text
mensonge répété ou volonté de fin
→ J17 SEPARATION
→ résolutions extérieures autonomes
→ J21 organisation pratique
→ A ou B
```

Sortie : fin de couple crédible, aucune consolation automatique.

## R4 — Sandra amitié restaurée

```text
photo J01 respectée
→ café J10 ou J12 payé
→ absence de pression J11
→ J18 FRIENDSHIP_RESTORED
→ J21 photo du déjeuner ou livre Sandra
```

## R5 — Sandra intimité tardive

```text
confiance répétée
→ image et audience respectées
→ J18 consentement actuel
→ aftercare_sandra_j18
→ J19 aftercare foreground
→ J21 trace contrôlée par Sandra
```

## R6 — Mathilde famille préservée

```text
séjour aidé
→ regard reconnu puis limite
→ aucune exploitation du foyer
→ J17 départ
→ FAMILY_RELATION_PRESERVED
→ J21 photo de famille ou absence
```

## R7 — Mathilde secret physique

```text
indépendance matérielle vraie
→ intention J10
→ consentement J11
→ aftercare
→ conséquence Marie
→ départ J17
→ PHYSICAL_SECRET ou SECRET_SUSPENDED
→ J21 dette ou fermeture
```

## R8 — Pauline compartiment

```text
surface publique réelle
→ version privée J13
→ audience respectée
→ J19 COMPARTMENT_PROTECTED
→ PAULINE_COMPARTMENT active
→ J21 A, B ou C
```

## R9 — Raphaëlle confiance créative

```text
travail payé
→ processus respecté
→ image choisie
→ J19 CREATIVE_TRUST
→ J21 accès fabrication distinct de l’image privée
```

## R10 — Nico garde-fou

```text
confidence J07
→ refus d’alibi ou correction factuelle
→ J20 GUARDRAIL
→ J21 photo sociale ou fait exact
```

## R11 — Double vie sombre

```text
contradiction non réparée
→ J17 DOUBLE_LIFE_FRAGILE
→ état extérieur sombre maintenu
→ existing_contradiction_id actif
→ J21 C disponible
```

Sortie : saison résolue mais instable, aucune fin propre.

---

# 15. Transitions impossibles

```text
TRUST_BROKEN Sandra → LATE_INTIMACY sans nouvelle réparation
COMPARTMENT_CLOSED Pauline → COMPARTMENT_PROTECTED sans nouveau geste Pauline
COLLEAGUE_ONLY Raphaëlle → invitation privée par choix Player seul
TAKING_DISTANCE Nico → confident automatique
SEPARATION couple → route extérieure disponible automatiquement
RECONFIGURATION_NEGOTIATING → couple ouvert automatique
trace REMOVED → trace ACTIVE sans contrôleur
promise REFUSED → promise ACTIVE sans nouveau promise_id
promise PAID | FAILED | EXPIRED | CANCELLED | CLOSED → promise ACTIVE sans nouveau promise_id
```

---

# 16. Contrôle de cardinalité

Le runtime ne doit pas générer toutes les combinaisons possibles.

Une partie garde :

```text
1 couple_state
1 household_state
1 état par personnage principal
0–quelques promesses actives
0–quelques obligations dues
0–quelques contradictions actives
traces réellement créées
connaissances réellement acquises
```

La matrice vérifie les compatibilités.

Elle ne demande pas une scène unique pour chaque produit cartésien.

Les scènes lisent les états pertinents et utilisent un fallback lorsque leur configuration spécifique n’existe pas.

---

# 17. Tests de validation

## T1 — Refus Nico J07

```text
nico_j07_tuesday_1845 = REFUSED
```

Attendu : aucun message Nico d’attente en J08.

## T2 — Café Sandra confirmé par Sandra

```text
sandra_cafe_saturday_1100 = CONDITIONAL
counterparty_confirmed_at renseigné avant J11 18 h
counterparty_confirmed_by = Sandra
```

Attendu : préambule J12 obligatoire ; P11 devient `ACTIVE` seulement après la confirmation Player.

## T3 — Café Sandra expiré

```text
confirmation absente à 9 h 30
```

Attendu : Sandra ne se déplace pas.

## T4 — Trace J14 absente

```text
aucune trace privée accessible
```

Attendu : aucun accident d’écran inventé ; `S27_MUTATION_NO_DISCOVERY`.

## T5 — Aftercare dû

```text
aftercare_status = DUE
```

Attendu : aucune nouvelle progression adulte.

## T6 — Accord provisoire

Attendu : checkpoint après J21, J20 Nico non bloqué par une journée Marie.

## T7 — Finale sans contradiction

Attendu : A/B seulement.

## T8 — Finale avec compartiment Pauline

Attendu : A/B/C ; C maintient seulement le compartiment existant.

## T9 — Trace retirée

Attendu : absence finale possible, fichier jamais restauré.

## T10 — Séparation

Attendu : aucune relation extérieure auto-ouverte.

## T11 — S28 complet

```text
deux promesses ACTIVE
deux actions distinctes
deux fenêtres incompatibles
deux sources signées
```

Attendu : `collision_mode: FULL_COLLISION` admissible.

## T12 — S28 sans seconde promesse

Attendu : `S28_MUTATION_NO_COLLISION`, aucune dette de substitution.

## T13 — Raphaëlle sans tâche signée

Attendu : mutation ; collision complète `MISSING_SIGNED_SOURCE`.

## T14 — P17 après fermeture propre

Attendu : P17 absente ; J16 priorité 8.

---

# 18. Relation au legacy

Le document `docs/16_ROUTE_REACHABILITY_MATRIX.md` est une archive de conception antérieure.

La présente matrice remplace pour J01–J21 :

- les scores ;
- les propriétaires de route ;
- les tickets ;
- les flags passifs de préférence ;
- les fins calculées par dominante numérique.

Les routes restent lisibles comme conséquences narratives, pas comme modes sélectionnés.

---

# 19. Verdict

```text
ÉTATS J17 → J21 : TOUS ATTEIGNABLES
PROMESSES CRITIQUES : PAYABLES OU FERMABLES
S28 COMPLET : RÉSERVÉ AUX PAIRES PROUVÉES
S28 SANS PAIRE : MUTATION NO_COLLISION
AFTERCARES : BLOQUANTS JUSQU’AU PAIEMENT
TRACES J14 / J21 : SOURCÉES
FERMETURES : NON ROUVERTES AUTOMATIQUEMENT
FINALE : DÉTERMINISTE SANS SCORE
```

> **Une route est atteignable lorsque l’histoire a réellement construit ses conditions, pas lorsque le système a accumulé assez de points pour la déclarer ouverte.**
