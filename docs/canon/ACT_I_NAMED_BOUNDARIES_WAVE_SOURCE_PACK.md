# Act I Named Boundaries Wave Source Pack — V0.93

> Canon source for the Act I wave after the locked V0.92 first-repetition closure runtime.
> Begins only after `first_repetition_wave_complete` is true.
> Documentation only: this file does not authorize runtime, JSON, GDScript, test, scene, asset, save, merge, or tag changes by itself.

## 1. Status and authority

This pack is the current narrative proposal for the next playable wave after V0.92.

Locked baseline:

```text
version: V0.92 — First Repetition Wave Closure Runtime
main / origin/main: 536b0c89fa203ace6bbbe1c2c827a7426a04ed0e
tag: v0.92-first-repetition-wave-closure-runtime
engine: Godot 4.6.x
```

Read this pack after:

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/NARRATIVE_CANON_STATUS.md
docs/canon/CHOICE_DESIGN_CANON.md
docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md
docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md
docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md
docs/canon/TEMPORAL_FLOW_AND_DAY_TRANSITION_CANON.md
docs/canon/CHARACTER_VOICE_DISTINCTION_CANON.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SOURCE_PACK.md
docs/runtime/V0_91_FIRST_REPETITION_WAVE_CLOSURE_BLUEPRINT.md
```

Then read:

```text
docs/canon/ACT_I_NAMED_BOUNDARIES_WAVE_SCENE_CARDS.md
docs/canon/ACT_I_NAMED_BOUNDARIES_WAVE_TEMPORAL_DELIVERY_MAP.md
```

The full character canon remains primary for every line and reaction.

This pack supersedes any assumption that the next wave should immediately add:

- a third first-repetition ticket;
- a new erotic image;
- an explicit adult scene;
- a Pauline private compartment;
- a Nico photo request or alibi;
- a Raphaëlle creative-account reveal;
- a Sandra confession;
- a Mathilde R3 scene;
- a route-selection menu;
- an automatic Tuesday unlock without a validated runtime plan.

---

## 2. Act placement

Blueprint position:

```text
Act I — La place qu'on laisse
S5 — A boundary becomes explicit
```

The first repetition wave answered:

```text
Which attention changes meaning first?
```

V0.93 asks:

```text
Now that attention has repeated,
who is willing to say what it is,
what it is not,
and what action becomes due?
```

Expected diegetic duration:

```text
Tuesday of the following week
through Thursday evening
```

This wave does not complete Act I.

It prepares S6 by making desire, absence, gaze, or loyalty explicit enough that a later decision can become consequential.

---

## 3. Entry state inherited from V0.92

Required entry flag:

```text
first_repetition_wave_complete = true
```

Current relationship state:

```text
Marie / Player mode = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE
```

Historical first-repetition state remains readable and immutable as wave history:

```text
story_ledgers.first_repetition.opportunity_window_ordinal
story_ledgers.first_repetition.external_foreground_scene_ids
story_ledgers.first_repetition.external_foreground_character_ids
story_ledgers.first_repetition.charged_access_owner
story_ledgers.first_repetition.scene_status
story_ledgers.first_repetition.cooldown_until_ordinal
story_ledgers.first_repetition.obligations
```

Reachable historical outcomes include:

```text
external foregrounds = 0 to 2
foreground characters = none | mathilde | sandra | mathilde + sandra
charged_access_owner = none | mathilde
Marie evidence = reconnection | drift | mixed
```

Character ceilings at entry:

```text
Mathilde = R1 or R2 Charged Access
Sandra = R1 maximum
Pauline = R1 Legitimate Social Access
Nico = R1 Ordinary Friendship / Social Access
Raphaëlle = R1 Ordinary Work Access
hard secrets = none
adult frames = none
adult images = none
routes R3+ = none
```

No V0.93 scene may rewrite what happened in the first-repetition ledger merely to make the new wave easier to author.

---

## 4. Product decision

The next wave is not another temptation lottery.

It has four fixed dramatic functions:

```text
1. Marie asks for one real plan rather than another vague intention.
2. One prior external repetition may return as a named boundary consequence.
3. Nico receives a second ordinary friendship cycle and names the pattern he sees.
4. The story returns to Marie and records whether the promised action was paid, amended, or honestly failed.
```

Pauline and Bastien provide a legitimate social frame.

Raphaëlle remains an ordinary work presence only.

The wave may contain clear desire and strong tension.

It does not yet create adult permission.

```text
A named attraction is not consent.
A named boundary is not route closure.
A public social image is not private circulation permission.
A male conversation about desire is not permission to exchange women as content.
```

---

## 5. Wave architecture

```text
W14 — Tuesday: Marie asks for a real plan                 fixed foreground
W15 — Wednesday: prior attention names a boundary         variable consequence
W16 — Wednesday evening: legitimate social hub            fixed hub / echoes
W17 — late Wednesday or Thursday: Nico quiet truth        fixed foreground
W18 — Thursday: Marie plan payment and wave close         fixed consequence
```

### 5.1 Foreground budget

```text
fixed Marie foregrounds = 1
carry-over consequence foregrounds = 0 or 1
fixed Nico foregrounds = 1
social hub = 1, but not an independent route foreground
new route-stage transitions = 0
```

The carry-over consequence does not consume a new first-repetition ticket.

It exists because a prior foreground already occurred.

### 5.2 Carry-over selection order

The W15 consequence is selected deterministically:

```text
safety or overdue aftermath
-> existing charged-access owner consequence
-> most recent resolved external foreground
-> earlier resolved external foreground
-> quiet no-consequence variant
```

With the current runtime, this means:

```text
if charged_access_owner = mathilde
-> Mathilde boundary consequence

else if the most recent resolved foreground is Sandra
-> Sandra boundary consequence

else if Mathilde was resolved
-> Mathilde ordinary boundary consequence

else
-> no external foreground; the wave continues quietly
```

Only a character already present in the historical foreground list may receive this carry-over consequence.

No Pauline, Nico, or Raphaëlle scene may pretend to be a consequence of the first-repetition ledger.

### 5.3 Quiet path validity

A run with no completed external foreground remains valid.

The wave still advances through:

```text
Marie real-plan request
-> legitimate social hub
-> Nico ordinary repetition
-> Marie consequence
```

The game must not manufacture a private route scene to punish a quiet first wave.

---

## 6. New state ownership

The closed `first_repetition` ledger remains historical.

The next runtime plan should use a new dedicated state root, recommended as:

```text
story_ledgers.named_boundaries_wave
```

The exact runtime schema belongs to a later implementation plan.

The narrative contract requires the new root to own only new-wave concerns such as:

```text
window ordinal
scene lifecycle
named boundary identifiers
foreground history for this wave
primary carry-over source
structured obligations
social-hub resolution
Nico-cycle resolution
wave completion
```

It must not duplicate or reset:

```text
first_repetition.charged_access_owner
first_repetition external foreground history
first_repetition scene outcomes
first_repetition obligations
```

Recommended conceptual fields:

```text
window_ordinal
primary_carryover_source
named_boundary_ids
foreground_scene_ids
foreground_character_ids
scene_status
obligations
social_hub_status
wave_complete
```

Global rules:

```text
maximum carry-over consequence foreground = 1
maximum new Nico foreground = 1
same scene cannot resolve twice
obligations outrank new opportunities
no pending obligation may survive wave close without an explicit carried contract
```

---

# 7. W14 — Marie asks for a real plan

## 7.1 Scene identity

```text
scene_id: marie_next_week_real_plan_01
working title: Pas une semaine floue
window: Tuesday late afternoon / early evening
primary relationship: Player / Marie
primary function: explicit couple request + topology choice
intensity: warm pressure
route effect: none
```

Marie is dealing with a small La Verrière evening on Wednesday.

Pauline and Bastien plan to stop by L'Annexe afterward.

Nico is working there.

Marie does not ask Player to prove love in the abstract.

She asks what he will actually do.

Canon line source:

```text
Marie : Demain je termine vers dix-neuf heures.
Marie : Pauline et Bastien passent à L'Annexe après.
Marie : Nico nous garde une table si on lui confirme avant midi.
Marie : Tu viens vraiment, tu nous rejoins à une heure précise, ou on protège jeudi soir juste pour nous ?
Marie : Je prends les trois réponses.
Marie : Pas « on verra ».
```

Primary decision axis:

```text
What concrete place does Player choose inside the next two evenings?
```

### M4A — Join from the beginning

```text
Player : je viens à La Verrière avant la fin
Player : je t'aide à fermer et on va à L'Annexe ensemble
```

Writes:

- Player joins Marie's movement from the beginning;
- a Wednesday shared-presence obligation is scheduled;
- social-hub topology = joined;
- no route reward is guaranteed;
- Marie reads action before reassurance.

### M4B — Arrive at a precise time

```text
Player : je finis ce que j'ai à finir
Player : 20 h 45 à L'Annexe
Player : si ça bouge je te le dis avant, pas après
```

Writes:

- a precise arrival obligation is scheduled;
- social-hub topology = late arrival;
- payment creates active-reconnection evidence;
- unexplained lateness creates drift evidence;
- work remains real, but cannot become unlimited shelter.

### M4C — Refuse the group and protect Thursday

```text
Player : demain je ne viens pas au groupe
Player : mais jeudi soir je bloque pour nous
Player : dîner dehors, téléphones rangés, je réserve
```

Writes:

- Thursday couple-time obligation is scheduled;
- social-hub topology = Marie moves independently;
- Marie remains free to enjoy Wednesday without Player;
- refusal is not treated as moral failure;
- the promise must be paid or honestly failed on Thursday.

Exit:

```text
one concrete obligation exists
Marie is not waiting for a vague answer
Wednesday topology is known
```

---

# 8. W15 — Mathilde boundary consequence

## 8.1 Eligibility

Preferred when:

```text
first_repetition.charged_access_owner = mathilde
```

Also possible as an ordinary boundary variant when:

```text
Mathilde was a resolved external foreground
and no more urgent charged-owner consequence exists
```

Hard requirements:

- Mathilde's temporary stay is still active;
- the historical Mathilde scene is `RESOLVED`;
- Player did not break a clear boundary;
- no adult aftermath is due;
- Marie remains present in the meaning even when absent from the room.

Scene identity:

```text
scene_id: mathilde_named_gaze_boundary_01
working title: Pas innocent, pas autorisé
window: Wednesday morning kitchen
primary relationship: Player / Mathilde
primary function: name attraction and limit
intensity: acknowledged attraction
route stage: preserve R1 or R2; never create R3
```

Mathilde does not suddenly dress differently.

The scene follows from the fact that her ordinary clothing has acquired a different meaning inside Player's gaze.

Opening source:

```text
Mathilde : Je vais dire un truc très adulte et très mal organisé.
Mathilde : J'ai vu que tu me regardais dimanche.
Mathilde : Et oui, j'ai aimé que tu me regardes.
Mathilde : Ça ne transforme pas l'appartement de Marie en zone sans règles.
```

Primary decision axis:

```text
Does Player own the gaze and respect the limit,
try to negotiate the ambiguity,
or deny what Mathilde has already named?
```

### MT2A — Own and slow down

```text
Player : je ne vais pas te dire que tu as imaginé
Player : j'ai regardé
Player : et je ne veux pas en faire un secret qui te tombe dessus
```

Writes:

- gaze acknowledged without escalation;
- Mathilde boundary respected;
- charged owner remains unchanged if already Mathilde;
- no image or touch permission;
- trust remains possible.

### MT2B — Admit charge, restore ordinary distance

```text
Player : oui, ça a changé quelque chose
Player : donc on remet de la distance avant de faire n'importe quoi
```

Writes:

- attraction named;
- route held rather than advanced;
- Mathilde may be relieved and frustrated simultaneously;
- no closure unless her response independently closes it.

### MT2C — Minimize or deny

```text
Player : tu donnes trop de poids à un regard
```

Writes:

- Mathilde feels used as an accident Player refuses to own;
- access cools;
- she stops asking for his opinion for the rest of the wave;
- no punishment seduction follows;
- charged-owner history is not erased, but current access may pause.

Exit:

```text
Mathilde has named both pleasure and limit
Marie remains the moral and emotional weight
no adult permission exists
```

---

# 9. W15 — Sandra boundary consequence

## 9.1 Eligibility

Preferred when:

```text
charged_access_owner is empty
and Sandra is the most recent resolved historical foreground
```

Hard requirements:

- Sandra's Monday scene is `RESOLVED`;
- no clear Sandra route closure exists;
- no pressure or repeated unanswered pursuit occurred;
- Sandra has a concrete availability reason.

Scene identity:

```text
scene_id: sandra_not_a_secret_routine_01
working title: Pas une habitude cachée
window: Wednesday lunch break or end of post
primary relationship: Player / Sandra
primary function: name emotional repetition and soft limit
intensity: soft charge
route stage: R1 only in this wave
```

Sandra does not confess an affair.

She acknowledges that the twenty-minute interval mattered and that repetition could become a hidden routine.

Opening source:

```text
Sandra : J'ai pensé à notre café en passant devant ce matin.
Sandra : Ce qui est déjà un peu trop précis comme information.
Sandra : Je ne veux pas qu'on transforme chaque fin de poste en rendez-vous qui n'en est pas un.
Sandra : Et je ne veux pas non plus faire semblant que ça ne me fait rien.
```

Primary decision axis:

```text
Does Player accept the truth without pressure,
protect a lighter rhythm,
or use humor to avoid responsibility?
```

### S3A — Name attachment without demanding more

```text
Player : ça m'a fait quelque chose aussi
Player : je ne vais pas te demander d'en faire plus pour le prouver
```

Writes:

- mutual importance named;
- Sandra's limit respected;
- no new image, confession, or affair;
- future chosen contact remains possible.

### S3B — Protect a lighter rhythm

```text
Player : alors on garde ça rare
Player : et on arrête de faire comme si rare voulait dire faux
```

Writes:

- soft boundary stabilized;
- route remains warm but bounded;
- no promise is created.

### S3C — Deflect

```text
Player : tu prépares déjà le règlement intérieur du prochain café ?
```

Writes:

- Sandra reads avoidance;
- she shortens the exchange;
- access cools temporarily;
- no pursuit reward appears.

Exit:

```text
Sandra has named the danger of routine
Player cannot call the repetition accidental afterward
Sandra remains R1
```

---

# 10. W16 — Legitimate social hub

## 10.1 Hub identity

```text
scene_id: lannexe_legitimate_social_return_01
working title: La table gardée
window: Wednesday evening
primary relationships: Player / Marie, Marie / Pauline, group / Nico
primary function: make ordinary life visible after private repetition
intensity: ordinary social charge
foreground cost: hub, not a route-stage foreground
```

Participants may include:

```text
Marie
Player according to M4 topology
Pauline
Bastien
Nico while working
```

Functions:

- Marie is visible, active, funny, and socially chosen by others;
- Pauline completes a second legitimate social cycle;
- Bastien remains real and present;
- Nico is competent in a public room before any dangerous male complicity;
- Player's M4 promise can be paid, amended, or missed;
- no private alternate image exists;
- no one becomes a route reward merely by being attractive in public.

Pauline source color:

```text
Pauline : J'ai réservé pour quatre et demi.
Pauline : Nico compte comme la moitié d'une personne tant qu'il travaille.
Bastien : Il va surtout manger dans nos assiettes.
Nico : Je vous rappelle que je peux encore donner la table à des gens agréables.
```

Marie must have one active beat unrelated to monitoring Player:

- she tells a La Verrière detail;
- she laughs with Pauline;
- she chooses food or a later walk;
- she moves seats or joins Nico at the counter for a practical reason;
- she is visibly part of a life that does not pause when Player is late or absent.

### 10.2 Topology outcomes

If M4A:

```text
Player joins Marie from La Verrière
-> shared action is paid before the social table
```

If M4B and Player arrives on time:

```text
precise arrival is paid
-> Marie does not need to chase the promise
```

If M4B and Player misses without warning:

```text
obligation fails
-> Marie remains at the table
-> no immediate crisis speech
-> Thursday consequence becomes sharper
```

If M4C:

```text
Marie attends independently
-> Player receives no surveillance transcript
-> Thursday couple time remains due
```

### 10.3 Pauline ceiling

This hub may write:

```text
pauline_legitimate_social_cycle_02_complete
```

It may not write:

```text
Pauline private compartment
private crop
second audience
hidden test
reciprocal proof
Bastien ignorance used as consent
```

### 10.4 Image rule

No new image asset is required.

If a public group image is referenced:

- origin must be explicit;
- intended audience must be the group or public social circle;
- no private crop exists;
- no one may infer forwarding permission;
- the image does not create route progression.

---

# 11. W17 — Nico quiet truth

## 11.1 Scene identity

```text
scene_id: nico_quiet_truth_after_room_01
working title: La version confortable
window: late Wednesday after closing or Thursday midday follow-up
primary relationship: Player / Nico
primary function: second friendship cycle + explicit gaze boundary
intensity: ordinary friendship with named desire
route stage: R1 only
```

Availability variants:

```text
Player attended the hub
-> short quiet exchange after the room thins

Player arrived late
-> Nico comments on timing after service

Player did not attend
-> Thursday message about the empty seat and Marie's independent evening
```

Nico does not request an image.

He does not offer an alibi.

He names what he sees:

```text
Nico : Tu veux la vérité ou une version confortable ?
Nico : Tu regardes beaucoup de choses en attendant qu'elles se décident toutes seules.
Nico : Marie le voit.
Nico : Mathilde le voit probablement aussi.
Nico : Et toi tu appelles ça « ne pas faire n'importe quoi ».
```

Nico may directly acknowledge attraction without claiming permission:

```text
Nico : Oui, Marie est belle.
Nico : Oui, Mathilde est très sexy.
Nico : Non, ça ne veut pas dire qu'elles m'ont proposé quoi que ce soit.
```

Primary decision axis:

```text
Does Player answer honestly without exchanging private access,
enter a soft male complicity,
or set a clear boundary around the women in his life?
```

### N2A — Honest without exchange

```text
Player : je vois ce que tu veux dire
Player : mais je ne vais pas te raconter leur intimité pour avoir l'air honnête
```

Writes:

- Nico quiet-truth cycle completed;
- Player owns observation without circulating it;
- friendship trust increases;
- no shared-gaze frame exists.

### N2B — Soft complicity

```text
Player : je vais éviter de prétendre que je ne regarde rien
Player : toi aussi tu regardes beaucoup pour un homme très raisonnable
```

Writes:

- mutual attraction language becomes possible;
- `nico_complicity_risk_soft` may be recorded;
- no image, description exchange, or alibi occurs;
- a later shared-gaze proposal still requires a new validated scene.

### N2C — Set the boundary

```text
Player : parle-moi de ce que je fais
Player : pas de Marie et Mathilde comme si c'était du contenu entre nous
```

Writes:

- explicit male-gaze boundary;
- Nico may respect the line and become quieter;
- friendship remains possible;
- no route closure by default.

Exit:

```text
Nico has become a real mirror rather than a joke machine
Player has answered the gaze question once
shared gaze = false
image request = false
alibi = false
```

---

# 12. W18 — Marie plan payment and wave close

## 12.1 Scene identity

```text
scene_id: marie_named_boundary_return_01
working title: Ce qu'on fait vraiment
window: Thursday evening
primary relationship: Player / Marie
primary function: pay or fail the concrete plan + preserve Marie agency
intensity: warm, disappointed, or mixed
route effect: evidence only
```

The scene reads M4 and W16 outcomes.

It does not ask Player to repeat the same choice in different words.

### 12.2 Paid outcomes

M4A paid:

- Player joined Marie's movement;
- Thursday can be ordinary shared life rather than a repair ceremony;
- Marie may acknowledge that he acted before explaining.

M4B paid:

- Player arrived at the promised time or warned before a real change;
- precision becomes a concrete act;
- no bonus route scene is owed.

M4C paid:

- Thursday dinner or walk occurs;
- Marie is not treated as consolation for missing the group;
- Player actively created a separate couple space.

Possible Marie line:

```text
Marie : Tu sais ce qui est agréable ?
Marie : Ne pas avoir eu besoin de te relancer pour que la soirée existe.
```

### 12.3 Failed or amended outcomes

A missed promise may resolve through:

```text
paid
failed honestly
amended before the deadline
```

It may not remain vague.

If failed:

- Marie does not wait with a plate indefinitely;
- she may eat, walk, call Pauline, or continue her evening;
- drift evidence is recorded;
- couple mode does not change instantly;
- the next wave receives a real consequence rather than a reset.

Possible Marie line:

```text
Marie : Je ne te demande pas une meilleure explication.
Marie : Je te demande de voir que la soirée a eu lieu sans toi.
```

### 12.4 Wave close

The wave may close only when:

```text
first_repetition_wave_complete = true
M4 obligation is terminal
carry-over consequence is terminal or absent
social hub is terminal
Nico cycle is terminal or explicitly deferred
no named-boundary obligation remains SCHEDULED / DUE without a carried contract
```

Recommended completion fact:

```text
named_boundaries_wave_complete = true
```

The exact runtime flag name remains subject to the later integration plan.

---

## 13. Route and relationship ceiling

### Marie / Player

```text
start: HABITUAL_WARMTH
end ceiling: HABITUAL_WARMTH + explicit boundary evidence
relationship frame: ASSUMED_EXCLUSIVE
```

V0.93 may create:

- `couple_boundary_named`;
- concrete-plan paid evidence;
- concrete-plan failed evidence;
- active-reconnection evidence;
- parallel-drift evidence;
- mixed evidence.

V0.93 may not create:

- repair mode;
- breakup mode;
- open relationship;
- affair confession;
- final confrontation;
- permanent route lock.

### Mathilde

```text
start: R1 or R2 Charged Access
end ceiling: same stage, boundary named or access cooled
```

No R3.

No chosen provocative image.

No deliberate sexual scene.

No touching permission.

Historical Mathilde ownership remains preserved if it exists.

### Sandra

```text
start: R1
end ceiling: R1 with named emotional limit
```

No R2 in this pack.

No new photo.

No confession.

No affair.

### Pauline

```text
start: R1 Legitimate Social Access
end ceiling: R1 + second legitimate social cycle complete
```

No private compartment.

No private crop.

No secret test.

Bastien remains present and human.

### Nico

```text
start: R1 Ordinary Friendship / Social Access
end ceiling: R1 + quiet friendship repetition
```

No shared-gaze frame.

No image request.

No alibi.

No rivalry route stage.

### Raphaëlle

```text
start: R1 Ordinary Work Access
end ceiling: R1 Ordinary Work Access
```

She may appear only through ordinary work texture or a short echo.

No outside-work foreground.

No private account.

No explicit frame.

### Global ceiling

```text
hard secrets = none
adult frames = none
adult images = none
routes R3+ = none
relationship frame change = none
new charged-access owner = none
```

---

## 14. Voice separation contract

### Marie

```text
shared life
food
movement
plans
practical teasing
concrete action before reassurance
```

Marie does not become a therapist or a suspicious gatekeeper.

### Mathilde

```text
speed
embarrassment
bad faith
image control
one legal turn maximum in the scene
```

Her boundary must include both her desire and her loyalty conflict.

### Sandra

```text
trace
minimization
quiet work detail
hesitation
soft limit
```

She does not borrow Mathilde's legal vocabulary or Pauline's audience-control language.

### Pauline

```text
dry timing
social competence
public care
controlled reopening
```

In this pack she remains legitimate and public.

### Nico

```text
food
chairs
rooms
service rhythm
blunt ordinary language
humor that can fall quiet
```

He does not become a porn narrator or omniscient diagnostician.

### Raphaëlle

```text
work detail
one clear question
selected information
precise invitation or limit
```

She remains background in this wave.

### Player

```text
short
dry
observant
imperfect
responsible for action, absence, gaze, promise, and return
```

Player must not imitate each character's signature vocabulary.

---

## 15. Knowledge, consent, and trace contract

At wave entry:

```text
Marie does not know private Sandra details
Marie does not know the exact Mathilde gaze exchange
Nico does not know domestic details automatically
Pauline does not know the first-repetition ledger
Bastien knows no hidden route
Raphaëlle knows only ordinary work behavior
```

V0.93 may create knowledge only through direct participation or explicit disclosure.

It may not infer:

- Marie knows because Player feels guilty;
- Nico knows Mathilde's domestic version because he finds her attractive;
- Pauline knows a private route because she reads people well;
- Sandra knows about Mathilde;
- Mathilde knows about Sandra;
- Bastien consents because he is socially relaxed.

Image contract:

```text
new required assets = 0
private image circulation = 0
adult image permission = 0
forwarding permission = 0
```

Consent contract:

```text
named attraction != consent
public presence != private access
friendship != alibi
couple stability != permanent permission
charged access != adult permission
```

---

## 16. Explicit exclusions

Reject any V0.93 interpretation or later implementation that adds:

- a route-selection menu;
- more than three choices at a normal node;
- a third first-repetition candidate;
- a second charged-access owner;
- Mathilde R3;
- Sandra R2;
- Nico R2;
- Pauline private access;
- Raphaëlle outside-work foreground;
- an adult scene;
- an adult image;
- a private crop;
- a one-view image;
- an image request;
- unauthorized circulation;
- an alibi;
- a hard secret;
- a hidden affair flag;
- an open-couple frame;
- NTR, cuckold, sharing, trio, quatuor, or group content;
- a breakup or repair lock;
- Tuesday-to-Friday implementation in one oversized patch;
- a global scheduler rewrite;
- a save-system rewrite;
- ObjectDB cleanup bundled into narrative integration.

---

## 17. Recommended future implementation order

After Product Owner validation:

```text
V0.94 — Named Boundaries Runtime Integration Plan
V0.95 — Tuesday Marie Real-Plan Vertical Slice
V0.96 — Carry-Over Boundary Consequence Slice
V0.97 — Social Hub + Nico Quiet Truth Slice
V0.98 — Marie Return + Named Boundaries Wave Closure
```

This sequence is a recommendation, not an authorization.

Each runtime milestone should remain small and independently testable.

The first recommended runtime proof is:

```text
Tuesday W14 only
-> Marie real-plan choice
-> schedule one concrete obligation
-> unlock Wednesday
```

Do not implement the full three-day wave before the W14 contract has been proven in runtime.

---

## 18. Acceptance criteria

V0.93 is ready for Product Owner validation when:

- the next wave clearly occupies S5;
- Tuesday is the next calendar day;
- Marie asks for one concrete plan;
- the first-repetition ledger remains historical;
- a new dedicated ledger is recommended;
- maximum one prior external consequence may foreground;
- Mathilde owner consequence outranks other carry-over scenes;
- Sandra may name a limit without reaching R2;
- Pauline and Bastien receive a legitimate social cycle only;
- Nico receives a second ordinary friendship cycle;
- Nico does not request images or offer an alibi;
- Raphaëlle remains deferred;
- the wave returns to Marie;
- all obligations are terminal at close;
- no adult frame, image, hard secret, or route R3+ opens;
- future runtime can be sliced into short milestones.

---

## 19. Final rule

```text
The first wave proved that attention could repeat.

The next wave does not reward repetition with instant access.
It makes the characters name the cost of continuing.

Marie asks what Player will actually do.
Mathilde or Sandra may say what the attention meant.
Nico says what Player keeps editing.
Then the story returns to the life Player still shares with Marie.
```
