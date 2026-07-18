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

## Acte IV — J13–J16

Objectifs :

- conséquence prioritaire ;
- découverte limitée ;
- collision de promesses existantes ;
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
| `LATE_INTIMACY` | progression longue, consentement actuel, contexte crédible | aftercare dû, pression future | impression ou message après-coup | aucune répétition automatique |
| `PROTECTIVE_WITHDRAWAL` | Sandra choisit espace ou fermeture | relance après fermeture | image inaccessible ou conservée pour elle | retour uniquement par initiative Sandra |
| `TRUST_BROKEN` | audience violée, pression, comparaison, mensonge grave | aucune réouverture saison 1 | absence de trace / accès retiré | réparation future non garantie |

## Règles

- `sandra_cafe_saturday_1100 = ACTIVE` rend le préambule J12 obligatoire.
- `LATE_INTIMACY` rend `aftercare_sandra_j18 = DUE` puis `PAID` avant J19.
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
| `PHYSICAL_SECRET` | indépendance matérielle vraie, consentement, aftercare | secret et conséquence Marie | départ obligatoire ; aucune continuation domestique | trace retirée, familiale ou dette reconnue |
| `SECRET_SUSPENDED` | événement reconnu mais non poursuivi | aucune répétition | fermeture ou attente non promise | absence / relation bornée |
| `FAMILY_RELATION_PRESERVED` | limites respectées | pas de nouvel accès privé saison 1 | départ familial | photo de famille possible |
| `DISTANCE` | retrait Mathilde ou Player | aucune compensation | départ autonome | silence ou trace retirée |
| `TRUST_BROKEN` | pression, dépendance, audience violée | fermeture | départ protecteur | aucun accès Player |

## Branche physique

Atteignable seulement si :

```text
mathilde_has_independent_sleep_option
mathilde_can_leave_safely
marie_absence_not_engineered
current_consent
no_due_safety_obligation
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

---

# 10. Promesses critiques

| Promise ID | Création | Paiement / fermeture obligatoire | Si active et oubliée |
|---|---|---|---|
| `nico_j07_tuesday_1845` | J07 N1 | J08 | J08 non conforme |
| `marie_j09_dinner_j10_2030` | J09 M1 | J10 | pivot extérieur bloqué ou conséquence |
| `marie_j09_dinner_friday_2030` | J09/J10 | J11 | conséquence couple |
| `sandra_cafe_saturday_1100` | J10/J11 | préambule J12 | J12 non conforme |
| `marie_j12_laverriere_presence` | J12 choix L | J12 | conséquence J13 |
| `j14_witness_clarification` | J14 D-C | avant ou pendant J15 | dette prioritaire |
| `j14_inform_trace_controller` | audience compromise | avant progression | sécurité prioritaire |
| `marie_j16_couple_conversation_j17` | J16 | J17 | définition couple unilatérale ou fracture |
| `couple_review_due_at` | J17 | après J21 | hook futur, pas dette saison 1 |
| `raphaelle_future_atelier_saturday_1500` | J19 | extension | reste conditionnelle |
| `marie_player_boxes_wednesday_1830` | J21 séparation | extension pratique | conséquence future |

Aucune promesse active ne peut être remplacée par une scène plus séduisante.

---

# 11. Aftercares et obligations

| Obligation | Création | Doit être payée avant | Sortie si refus |
|---|---|---|---|
| `aftercare_mathilde_j11` | passage physique Mathilde | toute nouvelle progression, J12 convergence | recul / dette / fermeture |
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
respiration / préparation J15
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
→ J16 conséquence payée
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

## T2 — Café Sandra confirmé

```text
sandra_cafe_saturday_1100 = ACTIVE
```

Attendu : préambule J12 obligatoire.

## T3 — Café Sandra expiré

```text
confirmation absente à 9 h 30
```

Attendu : Sandra ne se déplace pas.

## T4 — Trace J14 absente

```text
aucune trace privée accessible
```

Attendu : aucun accident d’écran inventé.

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
PROMESSES CRITIQUES : TOUTES PAYABLES OU FERMABLES
AFTERCARES : BLOQUANTS JUSQU’AU PAIEMENT
TRACES J14 / J21 : SOURCÉES
FERMETURES : NON ROUVERTES AUTOMATIQUEMENT
FINALE : DÉTERMINISTE SANS SCORE
```

> **Une route est atteignable lorsque l’histoire a réellement construit ses conditions, pas lorsque le système a accumulé assez de points pour la déclarer ouverte.**
