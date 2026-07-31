# Réseau Intime — NAR-PROD-05 — Amendement de cohérence J10→J12

## 1. Statut et autorité

```text
document_id: NAR-PROD-05
scope: cohérence canonique J10 → J12 avant runtime J11
status: CANDIDAT À VALIDATION PRODUIT
runtime_changes: none
ui_changes: none
asset_changes: none
```

Ce document résout les six blockers produit identifiés par
`RUNTIME-S1-11A_J11_READINESS_REPORT.md`.

Il amende, sur son périmètre exact :

- `J11_SCRIPT_NARRATIF_COMPLET.md` ;
- `J12_SCRIPT_NARRATIF_COMPLET.md` ;
- `NAR_ADULT_01_PAYOFFS_J11_MARIE_MATHILDE.md` ;
- `J01_J21_PROMISE_REGISTRY.md` ;
- `J01_J21_REACHABILITY_MATRIX.md` ;
- `SEASON_1_NARRATIVE_STATE_CONTRACT.md`.

Les scripts et registres sources sont modifiés dans le même lot afin qu’aucune
ancienne règle contradictoire ne reste normative.

Cet amendement :

- ne crée aucune route ;
- n’ajoute aucun score ;
- n’implémente pas J11 ;
- ne produit aucun asset ;
- ne transforme jamais une fermeture en opportunité compensatoire ;
- maintient les retraits propres comme protecteurs et non optimaux.

---

## 2. Ordre de résolution J11

Avant le pivot narratif, J11 applique strictement :

```text
1. obligation de sécurité ou d’audience DUE
2. P10 ACTIVE : décision avant 18:00, résolution à 20:30
3. P11 CONDITIONAL : confirmation Sandra ou expiration avant 18:00
4. conséquence J10 réellement due
5. continuation exclusive dérivée de j10_pivot + j10_pivot_outcome
6. Marie seulement sur fallback NONE ou conséquence de couple réelle
7. RESPIRATION si aucune continuation légitime n’existe
```

Une fermeture n’appelle jamais une seconde fois le sélecteur pour chercher une
autre relation.

`RESPIRATION` est un résultat initialisé et terminal de sélection, jamais une
valeur vide.

---

## 3. Matrice déterministe des 22 outcomes J10

| `j10_pivot` | `j10_pivot_outcome` | `j11_pivot` | Raison / plafond |
|---|---|---|---|
| `SANDRA` | `CAFE_HELD_CALM_PRESENCE` | `RESPIRATION` | `J10_NO_LEGITIMATE_CONTINUATION`; aucune progression |
| `SANDRA` | `CAFE_HELD_MISSING_NAMED` | `SANDRA` | S19 normal ; mutation avancée seulement avec preuve d’audience |
| `SANDRA` | `CAFE_HELD_FRIENDSHIP_BOUNDED` | `RESPIRATION` | S19 fermé ; aucune compensation |
| `SANDRA` | `CAFE_SATURDAY_CONDITIONAL` | `RESPIRATION` | notification P11 administrative seulement |
| `SANDRA` | `CAFE_OPPORTUNITY_CLOSED` | `RESPIRATION` | occasion fermée ; aucune compensation |
| `MATHILDE` | `OUTFIT_PRECISE_NON_APPROPRIATIVE` | `MATHILDE` | S20 normal ; physique seulement avec toutes les portes positives |
| `MATHILDE` | `OUTFIT_EFFECT_ACKNOWLEDGED_BOUNDED` | `MATHILDE` | S20 normal, vigilance élevée ; mêmes portes physiques |
| `MATHILDE` | `OUTFIT_PRACTICAL_WEATHER` | `RESPIRATION` | `J10_NO_LEGITIMATE_CONTINUATION`; aucune progression |
| `RAPHAELLE` | `PROCESS_HELPED_VISIT_BOUNDED` | `RAPHAELLE` | continuation complète après envoi réel |
| `RAPHAELLE` | `PROCESS_HELPED_REMOTE` | `RAPHAELLE` | résultat et attirance possibles ; baiser non acquis |
| `RAPHAELLE` | `RESULT_ONLY` | `RAPHAELLE` | continuation seulement après nouvel envoi J11 réel |
| `RAPHAELLE` | `PROFESSIONAL_BOUNDARY` | `RESPIRATION` | accès privé fermé ; aucune compensation |
| `NICO` | `DIFFERENCE_ACKNOWLEDGED_NO_IMAGE` | `NICO` | garde-fou ou fermeture J11 |
| `NICO` | `NICO_OBSERVATION_REQUESTED` | `NICO` | rivalité bornée ou fermeture J11 |
| `NICO` | `COMPARISON_CLOSED` | `RESPIRATION` | comparaison fermée ; aucune compensation |
| `NICO` | `THURSDAY_MEETING_CANCELLED` | `RESPIRATION` | continuation annulée ; aucune compensation |
| `NONE` | `DUE_DINNER_PAID` | `MARIE` | couple ; adulte soumis au prédicat complet §6 |
| `NONE` | `DUE_DINNER_FAILED_LATE` | `MARIE` | conséquence non adulte uniquement |
| `NONE` | `DUE_DINNER_CANCELLED` | `MARIE` | conséquence non adulte uniquement |
| `NONE` | `ORDINARY_MEAL_JOINED` | `MARIE` | couple ordinaire ; adulte soumis au prédicat complet §6 |
| `NONE` | `LATE_RETURN_SEPARATE` | `MARIE` | limite/distance non adulte |
| `NONE` | `ABSENCE_ANNOUNCED` | `MARIE` | limite/distance non adulte |

Pour les deux outcomes sans continuation légitime explicitement relevés par
l’audit :

```text
j11_pivot = RESPIRATION
j11_pivot_reason = J10_NO_LEGITIMATE_CONTINUATION
```

La respiration :

- n’est pas une route ;
- n’est pas une reconquête Marie ;
- ne crée aucune progression relationnelle ;
- ne crée ni photo, ni trace, ni connaissance ;
- n’autorise aucune scène adulte ;
- ne déclenche aucun second appel au sélecteur ;
- peut seulement fermer calmement la journée ou montrer un instant ordinaire.

Une conséquence de couple réelle déjà due peut précéder cette matrice. Elle ne
transforme pas la fermeture extérieure en cause de reconquête.

---

## 4. P10 — Dîner Marie vendredi à 20 h 30

### 4.1 Fenêtre signée

**17:32 — Marie**

> 20 h 30 tient toujours ?

**17:32 — Marie**

> Dis-moi avant 18 h si je dois compter sur toi.

### 4.2 Maintenir

**Player**

> oui. je rentre à 20 h 25

**Marie**

> D’accord. Je prends le pain.

```text
17:32 : P10 reste ACTIVE
20:30 : dîner hors téléphone
20:30 : P10 devient PAID
```

### 4.3 Annuler proprement

**Player**

> non. ne m’attends pas pour dîner

**Marie**

> D’accord. Je n’attends pas.

```text
P10 devient CANCELLED
```

`CANCELLED` désigne l’annulation d’une promesse déjà acceptée. `REFUSED` ne doit
pas être utilisé rétroactivement.

### 4.4 Annoncer un retard incompatible

**Player**

> je serai là à 21 h

**Marie**

> Non. On mange à 20 h 30. Il restera de quoi pour toi.

```text
20:30 : P10 devient FAILED
```

### 4.5 Effets d’exclusivité

- tant que P10 est `ACTIVE`, toute progression physique ou adulte est bloquée ;
- `CANCELLED` ou `FAILED` ferme la scène adulte Marie en J11 ;
- P10 maintenue ferme les branches physiques Mathilde et Raphaëlle ce soir-là ;
- une continuation textuelle non physique reste possible après le traitement
  administratif ;
- P10 payée peut ouvrir Marie seulement si tout le prédicat §6 est vrai.

Après P10 payée, l’ouverture Marie n’utilise pas le retour à 21 h 30. Elle devient :

**21:12 — Marie**

> Je range la cuisine.

**21:12 — Marie**

> Après, j’ai envie de te retrouver.

**21:13 — Marie**

> Pas d’utiliser le sexe pour effacer les jours précédents.

**21:13 — Marie**

> Ce sont deux choses différentes.

L’ouverture existante à 20:46 reste réservée aux configurations où P10 n’a pas
été maintenue puis payée et où sa situation est déjà terminale sans dette.

---

## 5. P11 — Café Sandra samedi 11 h

### 5.1 Confirmation de Sandra en J11

**17:44 — Sandra**

> Samedi 11 h tient de mon côté.

**17:44 — Sandra**

> Je pars à 10 h 34.

**17:45 — Sandra**

> Tu me confirmes demain avant 9 h 30.

Effets :

```text
status reste CONDITIONAL
counterparty_confirmed_at = J11 avant 18:00
counterparty_confirmed_by = Sandra
```

Cette notification :

- paie seulement la confirmation administrative de Sandra ;
- ne devient pas le pivot Sandra ;
- ne crée aucune progression relationnelle ;
- ne compte pas comme une deuxième variante principale.

Si Sandra ne confirme pas avant vendredi 18 h :

```text
CONDITIONAL → EXPIRED
aucun préambule P11 en J12
```

### 5.2 Confirmation Player en J12

Le préambule de 09:18 est accessible seulement si :

```text
status == CONDITIONAL
counterparty_confirmed_at est renseigné
counterparty_confirmed_by == Sandra
```

Puis :

```text
Player confirme avant 09:30 → ACTIVE
Player refuse → REFUSED
aucune réponse à 09:30 → EXPIRED
café réellement tenu → PAID
```

P11 n’est jamais `ACTIVE` avant la confirmation de Player.

---

## 6. Prédicat adulte Marie exact

La branche `MARIE_ADULT_RECONQUEST` est éligible si et seulement si toutes les
conditions suivantes sont vraies :

```text
j11_pivot == MARIE
j10_pivot == NONE
j10_pivot_outcome in {DUE_DINNER_PAID, ORDINARY_MEAL_JOINED}
marie_j09_presence_outcome in {
  presence_active,
  presence_playful_useful,
  presence_late_active,
  presence_bounded_reliable
}
couple_state in {BASELINE_SHARED_LIFE, STRAIN_VISIBLE}
P09 terminale
P10 absente ou PAID
aucune obligation DUE ou FAILED non traitée
aucune progression extérieure J10 utilisée comme repli
choix J11 P-A réellement sélectionné
consentement Marie actuel, explicite et révocable
```

Dans ce prédicat, `P09 terminale` signifie : P09 absente ou `PAID`,
`CANCELLED`, `REFUSED`, `FAILED` ou `CLOSED`. Une P09 `AMENDED` est considérée
résolue seulement si elle pointe vers P10 et que cette P10 est `PAID` ; elle ne
constitue jamais, seule, une preuve favorable.

Ne sont jamais suffisants :

```text
presence_distracted
presence_spectator
absence_honest
fermeture d’une relation extérieure
DUE_DINNER_PAID seul
ORDINARY_MEAL_JOINED seul
```

`RECONQUEST_ACTIVE` ne peut pas être créé avant la scène pour justifier son
propre accès. Si une condition manque, P-A utilise sa branche non adulte.

---

## 7. Raphaëlle — premier baiser le même jour

Le premier baiser peut devenir éligible dans la même séquence J11 uniquement
selon cet ordre réellement vécu :

```text
résultat réellement envoyé
→ attirance explicitement nommée
→ réaction réciproque et consentement actuel
→ proposition de rencontre distincte du travail
→ possibilité du premier baiser
```

L’aide à distance J10 ne suffit jamais seule.

Le baiser :

- ne crée aucune photo ;
- ne crée aucune trace diégétique ;
- ne crée aucune permission future ;
- reste inaccessible si P10 est encore `ACTIVE` ou a été maintenue ;
- reste inaccessible si l’attirance n’a pas été nommée avant lui dans la
  séquence réellement vécue ;
- exige que Raphaëlle initie ou confirme le contact au moment présent.

Outcomes signés :

```text
FIRST_KISS
KISS_DECLINED
RESULT_SENT_ATTRACTION_NAMED
RESULT_SENT_BOUNDARY_HELD
```

---

## 8. Mathilde — aftercare échoué

Après M-B2 ou M-B3, l’obligation `aftercare_mathilde_j11` est créée `DUE`.

```text
MA1 → PAID
MA2 → PAID
MA3 → FAILED
refus explicite de l’aftercare → FAILED
```

En cas de `FAILED`, J12 doit :

1. traiter la conséquence avant toute convergence normale ;
2. utiliser un préambule prioritaire de conséquence ou de fermeture ;
3. exclure Mathilde de la convergence normale ;
4. fermer toute nouvelle progression physique Mathilde ;
5. interdire toute substitution vers une autre relation ;
6. enregistrer la conséquence avant les contenus non adultes sans rapport.

Préambule canonique minimal :

**09:06 — Mathilde**

> Hier, tu as demandé la suite avant de vérifier comment j’étais.

**09:07 — Mathilde**

> Je ne viens pas ce soir.

**09:07 — Mathilde**

> Et on ne recommence rien.

Ce préambule ferme la progression ; il ne répare pas rétroactivement
l’aftercare. La dette est enregistrée comme conséquence attribuable avant que
J12 puisse continuer.

---

## 9. Préconditions techniques Mathilde et obligations

Le futur état J11 doit matérialiser, sans score :

```text
mathilde_has_independent_sleep_option: bool
mathilde_can_leave_safely: bool
marie_absence_not_engineered: bool
obligations: Dictionary
```

Le consentement courant et l’initiative de Mathilde sont des événements de la
scène J11. Ils ne sont jamais hérités de J10 comme permission persistante.

Chaque obligation suit le schéma canonique existant :

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

Une absence de champ, un booléen faux ou une obligation incohérente ferme la
branche physique. Elle n’est jamais interprétée comme une permission.

---

## 10. Galerie — contrat maintenu, dépendance runtime/UI

Le présent lot ne développe pas la Galerie.

- C11-03 Mathilde est une seule tuile parent ;
- C11-06 Marie est une seule tuile parent ;
- chaque tuile adulte réellement vécue contient trois images internes ;
- les enfants ne sont jamais exposés comme trois entrées séparées ;
- toute image adulte reste non diégétique, non transférable et non découvrable ;
- la navigation interne sera livrée dans un futur lot runtime/UI.

L’absence actuelle de navigation interne est une dépendance technique, pas une
erreur narrative et pas une raison pour exposer les enfants séparément.

---

## 11. Critères de validation

- [ ] les 22 outcomes J10 possèdent une sortie J11 déterministe ;
- [ ] P10 est décidée avant 18 h et résolue à 20 h 30 ;
- [ ] P11 reste `CONDITIONAL` après la confirmation Sandra ;
- [ ] P11 ne devient `ACTIVE` qu’après confirmation Player J12 ;
- [ ] `RESPIRATION` est distinct d’un état non initialisé ;
- [ ] aucune fermeture ne sélectionne une autre relation en compensation ;
- [ ] le prédicat Marie échoue fermé si une preuve manque ;
- [ ] le baiser Raphaëlle respecte l’ordre intra-scène signé ;
- [ ] `aftercare_mathilde_j11 = FAILED` précède et modifie J12 ;
- [ ] aucune scène adulte n’est ouverte par défaut ;
- [ ] aucun score, aucune nouvelle route et aucune permission héritée ne sont ajoutés ;
- [ ] C11-03 et C11-06 restent chacun une seule tuile parent.

---

## 12. Verdict candidat

```text
P10 : RESOLVED_IN_CANON
P11 : RESOLVED_IN_CANON
J10_OUTCOME_COVERAGE : 22/22 DETERMINISTIC
MARIE_ADULT_PREDICATE : EXACT_AND_FAIL_CLOSED
RAPHAELLE_FIRST_KISS : ORDERED_AND_CONSENT_BOUND
MATHILDE_FAILED_AFTERCARE : PRIORITY_J12_CONSEQUENCE
GALLERY_SEQUENCE : CANON_STABLE / RUNTIME_UI_DEPENDENCY_REMAINING
RUNTIME_J11 : WAITING_FOR_PRODUCT_VALIDATION_AND_LOCK
```
