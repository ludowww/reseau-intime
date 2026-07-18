# Réseau Intime — Contrat d’état narratif borné — Saison 1

## Statut

**Catégorie : Contrat canonique pré-runtime**

**Périmètre : états nécessaires pour exécuter J01–J21 sans scores de route ni explosion de flags**

Ce document décrit la vérité narrative à stocker.

Il ne définit pas encore :

- la classe Godot ;
- le format JSON final ;
- la migration des sauvegardes ;
- les noms techniques définitifs ;
- les performances ou l’interface de debug.

---

# 1. Principe directeur

Le runtime futur ne doit pas chercher à mesurer les relations par :

```text
trust = 73
attachment = 61
route_score = 8
owner = Mathilde
```

La saison est construite par :

```text
actes observables
+ états relationnels bornés
+ promesses structurées
+ traces contrôlées
+ connaissances sourcées
+ conséquences dues
```

Un état ne remplace jamais l’historique.

Il résume uniquement ce qui doit être lisible pour la prochaine scène.

---

# 2. Vue conceptuelle

L’état narratif de saison contient :

```text
current_day
couple_state
household_state
sandra_state
mathilde_state
pauline_state
raphaelle_state
nico_state
active_promises
active_obligations
active_contradictions
trace_states
knowledge_entries
foreground_history
finale_state
```

Le runtime peut organiser ces données différemment.

La sémantique reste obligatoire.

---

# 3. Temps narratif

## 3.1 Jours

```text
J01 mardi
J02 mercredi
J03 jeudi
J04 vendredi
J05 samedi
J06 dimanche
J07 lundi
J08 mardi
J09 mercredi
J10 jeudi
J11 vendredi
J12 samedi
J13 dimanche
J14 lundi
J15 mardi
J16 mercredi
J17 jeudi
J18 vendredi
J19 samedi
J20 dimanche
J21 lundi
```

## 3.2 Horodatage

Toute promesse et obligation utilise un datetime diégétique résolu.

Les chaînes relatives seules sont interdites :

```text
dimanche
plus tard
la semaine prochaine
un de ces jours
```

sans date calculée ou fenêtre explicite.

## 3.3 État du couple après lot A

```text
couple_review_due_at = jeudi suivant J21, 20 h 30
```

uniquement pour les sorties concernées.

---

# 4. `couple_state`

Valeurs bornées :

```text
BASELINE_SHARED_LIFE
STRAIN_VISIBLE
RECONQUEST_ACTIVE
PROVISIONAL_AGREEMENT
RECONFIGURATION_NEGOTIATING
DOUBLE_LIFE_FRAGILE
FRACTURE
SEPARATION
```

## 4.1 `BASELINE_SHARED_LIFE`

- couple réel ;
- vie commune ordinaire ;
- tensions non encore définies ;
- aucune permission extérieure.

État initial J01.

## 4.2 `STRAIN_VISIBLE`

- absences, horaires ou attention deviennent lisibles ;
- le couple existe encore sans nouvelle règle ;
- Marie peut cesser d’attendre sur un fait précis.

État possible J05–J16.

## 4.3 `RECONQUEST_ACTIVE`

- Marie et Player choisissent encore le couple ;
- une règle concrète existe ;
- aucun faux horaire ou faux lieu toléré ;
- aucune nouvelle progression extérieure avant clarification ;
- l’acte ordinaire doit être répété.

## 4.4 `PROVISIONAL_AGREEMENT`

- couple encore actif ;
- espaces ou chambres éventuellement séparés ;
- règles temporaires ;
- `couple_review_due_at` actif ;
- aucune permission rétroactive.

## 4.5 `RECONFIGURATION_NEGOTIATING`

- l’ancien contrat n’est plus supposé suffisant ;
- aucune ouverture automatique ;
- aucune personne extérieure engagée ;
- pause de progression jusqu’au point de contrôle ;
- Marie possède un droit complet de refus.

## 4.6 `DOUBLE_LIFE_FRAGILE`

- couple officiellement maintenu ;
- contradiction importante encore active ;
- vérité partielle ou version incompatible ;
- future conséquence préparée ;
- jamais présenté comme succès propre.

## 4.7 `FRACTURE`

- ancien fonctionnement retiré ;
- vie pratique encore liée ;
- réparation non promise ;
- une discussion future peut exister sans attente automatique.

## 4.8 `SEPARATION`

- couple terminé ou organisation de fin active ;
- logistique explicite ;
- aucune route extérieure ouverte automatiquement ;
- les souvenirs du couple restent vrais.

## 4.9 Transitions autorisées

```text
BASELINE_SHARED_LIFE → STRAIN_VISIBLE
STRAIN_VISIBLE → RECONQUEST_ACTIVE
STRAIN_VISIBLE → PROVISIONAL_AGREEMENT
STRAIN_VISIBLE → RECONFIGURATION_NEGOTIATING
STRAIN_VISIBLE → DOUBLE_LIFE_FRAGILE
STRAIN_VISIBLE → FRACTURE
STRAIN_VISIBLE → SEPARATION
RECONQUEST_ACTIVE → PROVISIONAL_AGREEMENT ou FRACTURE dans une extension
PROVISIONAL_AGREEMENT → état décidé au point de contrôle
RECONFIGURATION_NEGOTIATING → état décidé au point de contrôle
DOUBLE_LIFE_FRAGILE → conséquence future
FRACTURE → RECONQUEST_ACTIVE ou SEPARATION seulement par nouvel acte
```

Aucun passage vers un état plus favorable par un seul message final J21.

---

# 5. `household_state`

```text
SHARED_HOME_MATHILDE_PRESENT
SHARED_HOME_AFTER_MATHILDE
SEPARATE_ROOMS
PLAYER_TEMPORARILY_ELSEWHERE
MARIE_TEMPORARILY_ELSEWHERE
SEPARATION_ORGANIZATION
SINGLE_OCCUPANT_HOME
```

## Invariants

- Mathilde quitte obligatoirement `SHARED_HOME_MATHILDE_PRESENT` en J17 ;
- son départ ne répare pas automatiquement le couple ;
- `SEPARATE_ROOMS` ne signifie pas séparation ;
- une personne dans une autre pièce reste en co-présence pour le canon text-only ;
- `SINGLE_OCCUPANT_HOME` exige une organisation de séparation déjà accomplie.

---

# 6. `sandra_state`

```text
DISTANT_FRIEND
RECONNECTION_OPEN
FRIENDSHIP_RESTORED
PRIVILEGED_CONFIDENCE
DESIRE_RECOGNIZED_CONTAINED
PARALLEL_TENDER_RELATION
LATE_INTIMACY
PROTECTIVE_WITHDRAWAL
TRUST_BROKEN
```

## 6.1 États

### `DISTANT_FRIEND`

Historique commun réel, contact faible, aucune attente.

### `RECONNECTION_OPEN`

Une continuité précise peut encore être proposée.

### `FRIENDSHIP_RESTORED`

Proximité amicale reconnue, sans ambiguïté obligatoire.

### `PRIVILEGED_CONFIDENCE`

Sandra choisit Player comme interlocuteur limité et contrôlé.

### `DESIRE_RECOGNIZED_CONTAINED`

Désir réel, aucune permission future automatique.

### `PARALLEL_TENDER_RELATION`

Relation secrète ou parallèle consciente, Jeff et Marie affectés, dette active.

### `LATE_INTIMACY`

Intimité physique tardive, consentement actuel, aftercare obligatoire, aucune répétition promise.

### `PROTECTIVE_WITHDRAWAL`

Sandra ferme ou ralentit sans effacer ce qui a existé.

### `TRUST_BROKEN`

Accès et confiance fermés après pression, transfert ou violation.

## 6.2 Invariants

- Jeff reste réel dans tous les états ;
- une séparation de Player ne change pas automatiquement Sandra ;
- `LATE_INTIMACY` exige `aftercare_sandra = PAID` avant toute nouvelle progression ;
- une image retirée ne revient pas lors d’une reconquête ;
- `FRIENDSHIP_RESTORED` n’est pas un échec de route.

---

# 7. `mathilde_state`

```text
FAMILY_GUEST
DOMESTIC_FAMILIARITY
LOOK_ACKNOWLEDGED
INTENT_OPEN
PROXIMITY_CONSENTED
PHYSICAL_SECRET
SECRET_SUSPENDED
FAMILY_RELATION_PRESERVED
DISTANCE
TRUST_BROKEN
```

## 7.1 Invariants

- aucune progression sexuelle fondée sur l’hébergement ;
- la branche physique exige une solution alternative de logement ;
- le refus ne modifie aucune sécurité matérielle ;
- Marie reste personne affectée, pas autorité sur le consentement Mathilde ;
- après J17, Mathilde n’est plus disponible comme présence domestique ;
- `FAMILY_RELATION_PRESERVED` peut inclure un trouble reconnu mais borné.

## 7.2 `PHYSICAL_SECRET`

Éligible uniquement si :

```text
mathilde_has_independent_sleep_option = true
mathilde_can_leave_safely = true
marie_absence_not_engineered = true
consent_current = true
aftercare_mathilde != FAILED
```

À défaut, plafond :

```text
PROXIMITY_CONSENTED
```

---

# 8. `pauline_state`

```text
PUBLIC_ONLY
PRIVATE_TEST
SURFACE_RESTORED
COMPARTMENT_CLOSED
COMPARTMENT_PROTECTED
RECIPROCAL_TRACE
CONSCIOUS_MARIE_BETRAYAL
LIMITED_BASTIEN_COLLISION
PRIVATE_CONTACT_LIMITED
```

## Invariants

- la surface publique reste authentique ;
- Bastien reste réel ;
- `COMPARTMENT_PROTECTED` active une contradiction sombre ;
- `RECIPROCAL_TRACE` n’est pas une sécurité ;
- Marie n’est directement trahie que si Pauline sait légitimement que le couple est affecté ;
- fermer avec Player ne résout pas automatiquement ce que Pauline a caché à Bastien ou Marie.

---

# 9. `raphaelle_state`

```text
PROFESSIONAL_ONLY
CREATIVE_ACCESS
CHOSEN_IMAGE_ACCESS
CREATIVE_TRUST
BOUNDED_FUTURE_INVITATION
ATTRACTION_CONTAINED
CLEAR_UNFAITHFUL_SECRET
BOUNDARY_REINFORCED
COLLEAGUE_ONLY
```

## Invariants

- travail, processus, image, corps et accès futur sont séparés ;
- Maud connaît uniquement sa participation réelle ;
- une clarté entre Player et Raphaëlle n’absout pas l’exclusion de Marie ;
- `BOUNDED_FUTURE_INVITATION` ne grandit pas automatiquement ;
- `CLEAR_UNFAITHFUL_SECRET` active une contradiction sombre ;
- un baiser voulu ne crée aucune permission permanente.

---

# 10. `nico_state`

```text
ORDINARY_FRIEND
CONFIDENCE_ACTIVE
GUARDRAIL
LIMITED_CONFIDANT
HONEST_RIVAL
AUTHORIZED_GAZE_PARTNER
CONSCIOUS_ACCOMPLICE
COMPROMISED_WITNESS
TAKING_DISTANCE
```

## Invariants

- aucune route romantique ou sexuelle Nico / Player ;
- Marie et Mathilde décident pour elles-mêmes ;
- Player ne peut pas donner une femme à Nico ;
- `AUTHORIZED_GAZE_PARTNER` exige un consentement direct et nominatif de la femme concernée ;
- Nico peut dire un fait observé sans révéler toute une confidence ;
- un alibi fermé ne se rouvre pas en J21 ;
- `CONSCIOUS_ACCOMPLICE` active une dette, pas une amitié intacte.

---

# 11. États de traces et promesses

Les enums des registres deviennent autoritatifs :

```text
TraceState
PromiseStatus
KnowledgeCertainty
```

Ils ne sont pas dupliqués en flags du type :

```text
photo_seen
photo_deleted
photo_removed
photo_still_visible
```

Une seule entrée structurée porte l’état.

---

# 12. Obligations et aftercare

## 12.1 Schéma

```text
obligation_id
obligation_type
created_at
concerned_people
due_before
status
paid_by
failure_effect
```

## 12.2 Types

```text
AFTERCARE
AUDIENCE_REPAIR
SAFETY_RESPONSE
PROMISE_FAILURE_RESPONSE
COUPLE_CLARIFICATION
PARTNER_CONSEQUENCE
```

## 12.3 Statuts

```text
DUE
PAID
REFUSED
FAILED
CLOSED
```

## 12.4 Invariants

- une obligation `DUE` bloque toute nouvelle progression adulte ;
- une obligation d’audience passe avant une opportunité ;
- l’aftercare n’est pas une option de dialogue décorative ;
- une obligation peut être refusée, mais la conséquence devient `FAILED` ;
- J13 et J16 sélectionnent les obligations par priorité, pas par personnage préféré.

## 12.5 Aftercares canoniques

```text
aftercare_mathilde_j11
aftercare_marie_j11 si scène physique couple
aftercare_sandra_j18
aftercare_raphaelle si proximité physique antérieure
```

---

# 13. Contradictions actives

`active_contradictions` est un ensemble borné.

Valeurs saison 1 :

```text
COUPLE_FALSE_HOUR
COUPLE_FALSE_PLACE
COUPLE_DOUBLE_LIFE
SANDRA_COPY_RETAINED_SECRETLY
PAULINE_COMPARTMENT
PAULINE_RECIPROCAL_TRACE
RAPHAELLE_CLEAR_SECRET
NICO_SHARED_ALIBI
NICO_ACCOMPLICE_DEBT
```

## Invariants

- une contradiction possède une source antérieure à J21 ;
- elle peut être fermée, payée ou maintenue ;
- J21 ne peut pas créer le premier exemplaire ;
- une contradiction de sécurité ou d’audience domine la sélection finale ;
- `active_contradictions` reste un ensemble court, pas un journal complet.

---

# 14. Foreground et routes invisibles

Le runtime peut mémoriser :

```text
foreground_history:
- day_id
- character_id
- function
```

Il ne stocke pas :

```text
chosen_route
route_owner
route_score
```

La sélection d’un pivot utilise :

```text
obligation due
→ promesse due
→ scène éligible
→ relation la moins récemment foreground
→ ordre authored
```

Une route est une lecture narrative de l’historique, pas une destination sélectionnée.

---

# 15. État de finale

À la fin de J20 :

```text
final_trace_id
final_trace_state
final_trace_controller
final_trace_audience
final_posture_options
existing_contradiction_id
```

## `final_posture_options`

```text
[RULE_ACTED, LOSS_ACKNOWLEDGED]
```

ou, si contradiction active :

```text
[RULE_ACTED, LOSS_ACKNOWLEDGED, EXISTING_CONTRADICTION_MAINTAINED]
```

## `final_posture`

```text
RULE_ACTED
LOSS_ACKNOWLEDGED
EXISTING_CONTRADICTION_MAINTAINED
```

La posture finale ne remplace aucun état relationnel.

Elle ajoute une interprétation de sortie.

---

# 16. Invariants transversaux

1. Aucun état relationnel n’est acquis par un choix isolé sans préconditions.
2. Une fermeture n’ouvre pas automatiquement une autre relation.
3. Une séparation n’est pas une permission extérieure.
4. Une reconfiguration n’engage personne hors du couple.
5. Une image n’est jamais une permission corporelle.
6. Un accès créatif n’est pas un accès privé général.
7. Une connaissance n’est pas effacée avec une trace.
8. Une promesse refusée ne reste pas en attente.
9. Une personne continue sa vie si Player ne répond pas.
10. Les partenaires et tiers restent capables d’agir.
11. Aucun score numérique de relation n’est nécessaire pour J01–J21.
12. Aucun état ne doit être créé uniquement pour produire une fin différente.

---

# 17. Compatibilités interdites

```text
couple_state = RECONQUEST_ACTIVE
+ nouvelle progression extérieure non clarifiée
→ interdit

couple_state = RECONFIGURATION_NEGOTIATING
+ permission extérieure automatique
→ interdit

sandra_state = TRUST_BROKEN
+ trace privée active pour Player
→ interdit

mathilde_state = PHYSICAL_SECRET
+ indépendance matérielle fausse
→ interdit

pauline_state = COMPARTMENT_CLOSED
+ PAULINE_COMPARTMENT active
→ interdit

raphaelle_state = COLLEAGUE_ONLY
+ accès privé actif
→ interdit

nico_state = TAKING_DISTANCE
+ nouvelle confidence Player obligatoire
→ interdit

trace_state = REMOVED
+ audience Player active
→ interdit
```

---

# 18. Compatibilités rares mais autorisées

```text
couple_state = DOUBLE_LIFE_FRAGILE
+ pauline_state = COMPARTMENT_PROTECTED

couple_state = SEPARATION
+ sandra_state = PROTECTIVE_WITHDRAWAL

couple_state = RECONFIGURATION_NEGOTIATING
+ raphaelle_state = ATTRACTION_CONTAINED

nico_state = HONEST_RIVAL
+ couple_state = RECONQUEST_ACTIVE
```

Ces combinaisons ne produisent aucune permission supplémentaire.

---

# 19. Taille du modèle

Le contrat recommande :

```text
7 enums relationnels principaux
1 household_state
1 ensemble court de contradictions
collections structurées de traces, promesses et connaissances
journal léger des scènes et foregrounds
```

Il interdit la création d’un flag pour chaque ligne de dialogue.

Les choix détaillés peuvent rester dans un journal d’événements compact lorsque leur texte exact est nécessaire à un rappel.

---

# 20. Legacy

Le document historique `16_ROUTE_REACHABILITY_MATRIX.md` conserve une valeur de conception ancienne.

Ses notions suivantes ne sont plus autoritaires pour la saison 1 :

```text
lie_score
truth_tendency
attachment score
route owner
R2 owner
candidate pool
social pressure score
```

Les décisions narratives validées sont exprimées par le présent contrat et la nouvelle matrice J01–J21.

---

# 21. Verdict

```text
ÉTATS RELATIONNELS : BORNÉS
PROMESSES ET TRACES : STRUCTURÉES
CONTRADICTIONS : LISTE COURTE
SCORES DE ROUTE : INUTILES
PROPRIÉTAIRE DE ROUTE : INTERDIT
FINALE : DÉTERMINABLE SANS EXPLOSION DE FLAGS
```

> **Le runtime ne doit pas deviner qui le joueur préfère. Il doit savoir ce qu’il a promis, ce que chacun sait et quelles limites existent encore.**
