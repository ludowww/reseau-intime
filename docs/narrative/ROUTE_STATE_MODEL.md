# Modèle d’état des routes

## Statut

Document de cadrage narratif.

Il ne définit pas encore un système runtime obligatoire.

Il propose une grammaire simple pour penser les scènes, les choix Player et les compatibilités entre routes.

Objectif : éviter les scènes qui sonnent bien mais ne changent rien.

## Principe

Chaque scène importante doit faire évoluer au moins un de ces axes :

```text
- état du couple Marie / Player ;
- posture de Player ;
- pression d’une route secondaire ;
- statut d’une preuve ;
- disponibilité d’un personnage ;
- degré de clarté ou de mensonge.
```

Si rien n’évolue, la scène est probablement décorative ou répétitive.

## Axe 1 — couple_state

État du couple Marie / Player.

Valeurs narratives possibles :

```text
stable
suspicious
truth_discussion
revenge
open_discussion
open_agreed
broken_trust
cold_war
reconnection
```

### stable

Le couple fonctionne encore comme centre naturel.

Utilisation : J1-J2.

### suspicious

Marie sent que quelque chose bouge.

Elle n’a pas forcément de preuve, mais elle n’est plus naïve.

### truth_discussion

Player ou Marie commence à nommer ce qui se passe.

Important : ce n’est pas encore ouverture consentie.

### revenge

Marie reprend du pouvoir par provocation, Nico, mensonge de retour ou distance active.

### open_discussion

Le couple commence à discuter d’un cadre ouvert.

Condition : vérité au moins partielle.

### open_agreed

Le couple a défini des règles claires.

À réserver pour plus tard.

### broken_trust

La confiance est rompue par mensonge, preuve ou humiliation.

### cold_war

Le couple reste ensemble, mais chacun cache ou teste.

### reconnection

Player et Marie réparent ou reviennent l’un vers l’autre, avec coût.

## Axe 2 — player_posture

Posture principale de Player dans une scène.

Valeurs :

```text
honest
partial_truth
hiding
minimizing
provocative
romanticizing
restrained
power_drunk
jealous
clarifying
```

### honest

Player dit clairement quelque chose qui lui coûte.

### partial_truth

Player dit une vraie phrase, mais garde une zone floue.

### hiding

Player cache activement.

### minimizing

Player réduit l’importance de ce qui arrive.

### provocative

Player teste une limite.

### romanticizing

Player transforme le désir en lien noble ou doux.

### restrained

Player pose une limite malgré le désir.

### power_drunk

Player est grisé par le fait d’être désiré ou d’avoir un effet.

### jealous

Player réagit à Marie ou Nico par possessivité.

### clarifying

Player cherche un cadre propre plutôt qu’un soulagement immédiat.

## Axe 3 — route_pressure

Chaque route secondaire peut avoir une pression narrative.

Valeurs indicatives :

```text
0 — dormant
1 — active légère
2 — tension installée
3 — risque clair
4 — conséquence ouverte
5 — verrou / crise
```

Routes suivies :

```text
sandra_trust
sandra_hidden_wound
mathilde_domestic_risk
mathilde_loyalty_conflict
pauline_control
pauline_fragility
raphaelle_clarity
raphaelle_recoil
marie_revenge
nico_mirror
```

Ces valeurs ne sont pas forcément des scores runtime. Elles servent à cadrer l’écriture.

## Axe 4 — proof_state

Statut d’une preuve, photo ou trace.

Valeurs :

```text
soft_trace
weak_proof
social_proof
dangerous_proof
buried
revealed
misread
weaponized
shared_by_consent
```

### soft_trace

Trouble doux, défendable.

### weak_proof

Trace ambiguë pouvant être interprétée.

### social_proof

Visible par le groupe ou une personne extérieure.

### dangerous_proof

Preuve pouvant créer un vrai coût.

### buried

Trace supprimée, cachée ou non utilisée.

### revealed

Trace montrée à quelqu’un.

### misread

Trace interprétée de travers.

### weaponized

Trace utilisée comme pression, vengeance ou contrôle.

### shared_by_consent

Trace intégrée à un cadre clair.

## Axe 5 — availability_state

Disponibilité émotionnelle ou narrative d’un personnage.

Valeurs :

```text
available
cautious
withdrawing
testing
provoking
hurt
clear_boundary
open_if_clear
closed_for_now
```

Exemples :

```text
Sandra : available → cautious → hurt → withdrawing / open_if_clear.
Mathilde : testing → provoking → clear_boundary → testing again if safe.
Pauline : provoking → controlling → fragile / weaponizing.
Raphaëlle : available as listener → open_if_clear → closed_for_now if used as refuge.
Marie : available → suspicious → revenge / open_discussion / broken_trust.
```

## Axe 6 — clarity_level

Niveau de clarté relationnelle.

Valeurs :

```text
unclear
named_privately
named_to_marie
negotiated
agreed
violated
```

Règle :

```text
Raphaëlle avancée exige au moins named_to_marie ou negotiated.
Ouverture consentie exige negotiated ou agreed.
Pauline contrôle prospère dans unclear ou violated.
Marie vengeance naît souvent de violated.
```

## Effets types des choix Player

### Choix de vérité

Effets narratifs :

```text
couple_state → truth_discussion ou open_discussion
player_posture → honest / partial_truth
raphaelle_clarity +
pauline_control -
marie_revenge - ou delayed
sandra_trust + si elle n’est pas cachée
```

Coût : Marie peut ouvrir elle aussi une porte, ce qui crée jalousie ou peur.

### Choix de mensonge

Effets :

```text
couple_state → suspicious / broken_trust / cold_war
player_posture → hiding / minimizing
pauline_control +
marie_revenge +
raphaelle_recoil +
sandra_hidden_wound +
mathilde_domestic_risk +
```

Coût : plus de routes possibles à court terme, mais plus instables.

### Choix de provocation

Effets :

```text
player_posture → provocative / power_drunk
mathilde_domestic_risk +
pauline_control +
sandra_trust + ou hidden_wound + selon contexte
marie_revenge + si elle voit ou sent
raphaelle_recoil +
```

Coût : désir plus fort, confiance plus fragile.

### Choix de retenue

Effets :

```text
player_posture → restrained
marie.trust narrative +
mathilde_loyalty_conflict + puis possible respect
sandra_trust + si formulé avec douceur
pauline_control -
raphaelle_clarity +
```

Coût : certaines opportunités immédiates se ferment.

### Choix d’ouverture claire

Effets :

```text
couple_state → open_discussion
clarity_level → named_to_marie / negotiated
raphaelle_clarity +
pauline_control - ou transformation vers défis consentis
sandra_trust + si non cachée
mathilde_loyalty_conflict complexe
marie_revenge - mais marie_agency +
```

Coût : Marie obtient aussi une liberté ou un pouvoir.

### Choix de jalousie

Effets :

```text
player_posture → jealous
marie_revenge + si Player est incohérent
nico_mirror +
truth_discussion possible si Player reconnaît l’effet miroir
```

Coût : Player voit son propre double standard.

## Compatibilité rapide par état

```text
couple_state stable:
  Sandra douce possible, Mathilde légère, Pauline dormante, Raphaëlle travail, Marie centrale.

couple_state suspicious:
  Pauline gagne, Mathilde risquée, Sandra cachée fragile, Raphaëlle prudente, Marie active.

couple_state truth_discussion:
  Raphaëlle compatible, Sandra compatible si non cachée, Marie ouvre ou pose règle.

couple_state revenge:
  Nico actif, Pauline observe, Player jaloux, routes secondaires instables.

couple_state open_discussion:
  Raphaëlle et Sandra plus compatibles, Pauline doit se transformer, Mathilde très délicate.

couple_state open_agreed:
  trios / quatuors / poly possibles seulement avec consentement clair et règles.

couple_state broken_trust:
  Pauline forte, Marie vengeance, Raphaëlle recule, Sandra souffre, Mathilde culpabilise.
```

## Format recommandé pour cadrer une scène

Avant d’écrire une scène, remplir :

```text
Scene:
Day:
Characters:
Initial couple_state:
Initial player_posture:
Route pressures affected:
Proofs affected:
Player choice families:
Expected state changes:
Routes made more compatible:
Routes made more costly:
Scene must not repeat:
```

Exemple :

```text
Scene: J5 Marie — le couple vacille
Initial couple_state: suspicious
Initial player_posture: unclear
Route pressures affected: marie_revenge, raphaelle_clarity, pauline_control
Proofs affected: social_proof J4/J5
Player choice families: truth / lie / minimize / open question
Expected state changes: suspicious → truth_discussion or revenge seed
Routes made more compatible: Marie truth, Marie revenge, Pauline control depending choice
Routes made more costly: Raphaëlle if lying, Sandra if hidden
Scene must not repeat: téléphone / pose ton écran
```

## Application obligatoire à J5/J6 rewrite

Avant de réécrire J5/J6, produire un plan listant :

```text
- état initial J5 ;
- état final J5 attendu ;
- état initial J6 ;
- acte concret Player J6 ;
- routes qui montent ;
- routes qui reculent ;
- motifs interdits ;
- réponses Player visibles.
```

Sans cette carte, ne pas écrire les dialogues.

## Règle finale

```text
Une scène doit modifier une compatibilité de route.
Sinon elle risque d’être seulement une variation de ton.
```
