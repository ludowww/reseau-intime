# Modular Narrative Arc Blueprint — V0.78

> Canon architecture for the post-J1 narrative.  
> Defines the fixed dramatic spine, acts, couple states, narrative windows, modular scene pools, route emergence, consequences, and replayability rules.  
> This document does **not** write J2, change runtime, create variables, modify JSON, or validate old J2+ content.

## 1. Purpose

`Réseau Intime` must become less linear without becoming psychologically arbitrary.

The target architecture is:

```text
fixed dramatic spine
+ choices that change context
+ modular narrative windows
+ character-specific scene pools
+ persistent obligations and traces
+ consequences that return to the couple
```

The story is not six independent romances.

The central question remains:

```text
Can Player and Marie make their couple an active choice again?
```

Every other principal character creates a different answer, temptation, mirror, or consequence around that question.

This blueprint replaces fixed J2–J10 chronology as the forward design model.

Older day plans, arcs, route matrices, proof maps, and runtime may provide isolated material to revalidate. They do not determine the order of future scenes.

---

## 2. Scope

This blueprint defines:

- the main narrative spine;
- act structure;
- starting state after J1;
- couple-state dimensions and derived modes;
- the universal route lifecycle;
- narrative cycles;
- window topology;
- scene-pool taxonomy;
- character-specific pool functions;
- scene selection priorities;
- intensity and secret-pressure rules;
- traces, knowledge, consent, promises, debts, and aftermath;
- cross-character interaction hubs;
- route compatibility principles;
- replayability rules;
- resolution families;
- authoring and runtime boundaries.

It does not define:

- exact J2 dialogue;
- exact day count;
- exact scene IDs for production;
- Godot implementation;
- JSON schema;
- variable names that runtime must use;
- final ending text;
- mandatory appearance of every optional scene in one playthrough.

The next source pack must translate this architecture into concrete early windows before runtime work begins.

---

## 3. Canon invariants

The modular architecture must preserve all of the following.

### 3.1 Marie remains the living center

Marie must remain:

- desirable;
- funny;
- social;
- active;
- capable of initiative;
- capable of jealousy and adult desire;
- capable of going out, staying, confronting, inviting, refusing, or redefining the couple;
- more than the woman harmed by external routes.

```text
External routes may pressure the couple.
They may not freeze Marie into waiting for Player's decision.
```

### 3.2 Player remains an active choice subject

Player cannot disappear behind other characters' monologues.

His choices must reveal:

- presence;
- delay;
- observation;
- desire;
- jealousy;
- bad faith;
- curiosity;
- respect;
- secrecy;
- willingness to act;
- willingness to refuse;
- willingness to return.

### 3.3 Character-specific engines remain distinct

```text
Marie      = the couple and active reconquest
Sandra     = confidence and chosen private truth
Mathilde   = domestic proximity and changed intention
Pauline    = image, compartmentalization, and double life
Nico       = social gaze, domestic envy, voyeuristic complicity, and rivalry
Raphaëlle  = chosen version, explicit frame, and responsibility after the role
Player     = the gaze becoming an act, choice, or bad faith
```

No modular scene may become interchangeable simply because it contains flirtation, a photo, or a private message.

### 3.4 Three choices remain the default

```text
3 choices per runtime node
```

Four or more require explicit written justification.

Choices should alter posture, context, topology, or consequence—not merely offer three synonyms.

### 3.5 Adult content remains character-specific and consequential

The game may become pornographic.

It must preserve:

- adult agency;
- current consent;
- image and audience rules;
- the distinction between hidden betrayal and informed adult play;
- supporting-character humanity;
- aftermath;
- character-specific desire.

### 3.6 Runtime is not canon by inheritance

```text
existing runtime != narrative canon
```

No old J2+ sequence becomes current merely because data already exists.

---

## 4. Starting state after J1

Current J1 is:

```text
J1 — Les choses qu'on remarque
```

Its narrative output is intentionally soft.

### 4.1 Fixed J1 outcome

After J1:

- Player and Marie are still together;
- their shared life remains warm and real;
- the couple problem is passive presence, not declared crisis;
- Sandra has re-entered through a soft trace;
- Mathilde is still indirect;
- Pauline, Nico, and Raphaëlle are not active threads;
- no route is locked;
- no explicit sexual escalation exists;
- no hard secret system exists;
- no relationship agreement has changed.

### 4.2 Soft J1 signals

J1 choices may leave soft tendencies such as:

- Player was present with Marie;
- Player was joking but present;
- Player was flat or delayed;
- Player noticed Sandra precisely;
- Player responded warmly but safely;
- Sandra remained cautious;
- Marie experienced a small act of participation or another small delay.

These signals color early variants.

They do not create:

- an active Sandra route;
- a damaged couple state;
- a secret;
- a jealousy state;
- an adult permission.

### 4.3 Initial couple mode

The couple begins post-J1 in:

```text
HABITUAL_WARMTH
```

Meaning:

- love is real;
- trust is broadly intact;
- exclusivity is assumed rather than freshly discussed;
- desire exists but is underexpressed;
- shared life is functioning;
- Player's presence is inconsistent;
- Marie has not yet stopped asking.

---

## 5. Narrative architecture hierarchy

The story is organized through five nested units.

```text
Act
-> Spine Anchor
-> Narrative Cycle
-> Narrative Window
-> Modular Scene / Echo / Consequence
```

### 5.1 Act

An act defines:

- the dramatic question;
- the maximum intensity available;
- the mandatory spine functions;
- the kinds of route states that may exist;
- the exit conditions.

Acts are not fixed day ranges.

### 5.2 Spine Anchor

A spine anchor is a mandatory dramatic function.

It is not necessarily one exact scene.

Examples:

- Mathilde's stay changes the household;
- Marie creates a meaningful social invitation;
- Player's private attention becomes repeatable;
- a boundary is named;
- a private version collides with ordinary life;
- the couple frame becomes explicit.

A spine anchor may have multiple authored variants according to state.

### 5.3 Narrative Cycle

A narrative cycle is the basic story rhythm:

```text
1. fixed setup or ordinary-life anchor
2. Player choice
3. topology changes
4. one foreground modular scene becomes eligible
5. optional echoes or traces appear
6. the story returns to shared life or consequence
7. obligations and state are updated
```

A day may contain one or more cycles.

The blueprint does not require every cycle to equal one day.

### 5.4 Narrative Window

A window is a context bundle that determines which scenes are plausible.

It contains:

- location;
- time band;
- available characters;
- privacy level;
- witnesses;
- channel;
- time pressure;
- current couple visibility;
- current intensity ceiling;
- pending obligations.

### 5.5 Foreground scene

A foreground scene:

- consumes the main attention of a window;
- has one primary dramatic function;
- may contain up to three-choice nodes by default;
- can change route stage or create a major consequence;
- must update state explicitly in its authoring card.

### 5.6 Echo

An echo is a small contextual beat:

- a short message;
- a photo notification;
- a remembered phrase;
- an object moved;
- a social reaction;
- a change in tone.

An echo does not:

- replace a foreground scene;
- create a major route stage alone;
- grant adult consent;
- resolve a consequence by itself.

### 5.7 Consequence scene

A consequence scene pays an existing obligation:

- promised follow-up;
- lie or alibi;
- image rule;
- discovery risk;
- unresolved boundary;
- jealousy;
- confession;
- adult aftermath;
- return to work or home.

Consequences outrank new opportunities when due.

---

## 6. Fixed dramatic spine

The fixed spine is defined by function, not by mandatory day order.

### S0 — Attention

Current J1.

```text
Marie is the life Player must join.
Sandra is the trace Player can read.
```

### S1 — Household change

Mathilde's temporary stay becomes active.

Functions:

- change the apartment topology;
- create new ordinary routines;
- make Marie / Player shared space less closed;
- establish Mathilde as family and person before sexual tension;
- make Player's domestic gaze consequential later.

### S2 — Movement offered

Marie proposes or creates movement:

- La Verrière event;
- small outing;
- social evening;
- practical event help;
- walk or plan that matters beyond one message.

Player's choice changes topology:

- join Marie;
- remain home while Marie goes;
- choose a separate plan or responsibility.

The exact three choices belong to the future source pack.

### S3 — Outside lives become visible

The remaining principal characters enter through ordinary life, in variable order:

- Raphaëlle through work;
- Nico through L'Annexe / social orbit / Player friendship;
- Pauline through Marie / Bastien / group legitimacy;
- Mathilde through the household;
- Sandra through continued traces and private rhythm.

Every principal character must receive ordinary presence before major adult escalation.

### S4 — Private attention repeats

At least one optional connection becomes repeatable rather than accidental:

- Sandra sends or keeps another trace;
- Mathilde asks or notices Player's gaze;
- Pauline returns without a practical pretext;
- Nico and Player begin sharing a gaze or social observation;
- Raphaëlle reveals an outside-work layer.

This anchor does not require sex or betrayal.

### S5 — A boundary becomes explicit

Someone names what the current interaction is or is not.

Examples:

- Marie asks for an act rather than reassurance;
- Sandra states a soft limit;
- Mathilde says Player is going too fast;
- Pauline demands reciprocal risk or refuses an excuse;
- Nico asks what the woman knows;
- Raphaëlle separates work, fantasy, affair, and informed frame.

### S6 — Desire becomes consequential

Player makes at least one decision that cannot remain only tone:

- stop;
- disclose;
- hide;
- send or save;
- ask permission;
- accept an alibi;
- cross physically;
- refuse a route;
- actively choose Marie;
- begin a real negotiation.

### S7 — Private and ordinary life collide

A collision is mandatory, but its content is route-dependent.

Possible forms:

- image or crop recognized;
- alibi tested;
- behavior changes;
- social joke reveals private knowledge;
- Mathilde asks who saw;
- Marie knows Nico knows;
- Bastien or Jeff becomes a real consequence;
- Raphaëlle returns to the office after a private frame;
- Sandra's chosen distance changes her home behavior;
- Marie directly asks what is happening.

### S8 — Couple frame declared

Player and Marie can no longer rely only on assumed stability.

The relationship becomes explicitly one of:

- recommitted exclusive couple;
- couple in active repair;
- informed negotiation;
- informed non-exclusive / shared frame;
- separation;
- concealed fracture / continued lie;
- exposed rupture.

### S9 — What remains

The final act resolves:

- what Player and Marie are;
- what affected adults know;
- what route relationships remain;
- what trust was repaired, redefined, or destroyed;
- what ordinary life looks like after the erotic climax;
- which versions can coexist without lying.

---

## 7. Act structure

The blueprint uses one prologue act and five post-J1 acts.

The number of days inside each act remains open.

## Act 0 — `Les choses qu'on remarque`

Status: current J1.

Dramatic question:

```text
How does Player pay attention before routes exist?
```

Mandatory functions:

- Marie domestic warmth;
- Marie outside-life color;
- Sandra soft trace;
- small Player choices;
- return to Marie / shared life.

Intensity ceiling:

```text
ordinary / soft charge only
```

Exit state:

- `HABITUAL_WARMTH`;
- soft presence tendency;
- Sandra trace seed;
- no active route.

---

## Act I — `La place qu'on laisse`

Dramatic question:

```text
Will Player enter ordinary life before desire forces him to react?
```

Mandatory spine functions:

- Mathilde's temporary stay begins;
- household routines change;
- Marie creates one meaningful movement / invitation;
- Player makes at least one topology choice;
- ordinary entry begins for Raphaëlle, Nico, and Pauline in variable order;
- Sandra remains available through a defensible trace or rhythm;
- Marie remains desirable and active before jealousy becomes central.

Allowed modular functions:

- domestic help;
- work anecdotes;
- ordinary invitations;
- group planning;
- lunch walk;
- saved seat;
- morning kitchen;
- harmless relay;
- old photo / trace;
- small missed opportunity;
- first boundary respected.

Route ceiling:

```text
R0 Background
R1 Ordinary Access
R2 Charged Access at most
```

Adult ceiling:

- no full explicit adult scene;
- no negotiated group content;
- no hidden affair completion;
- sensuality and voyeuristic curiosity may become readable;
- image origin and audience still matter.

Act I exit conditions:

- Mathilde is a real household presence;
- Player has made at least one meaningful presence/absence choice;
- at least two external principal characters beyond Sandra/Mathilde have ordinary access;
- any remaining external principal character is guaranteed early Act II entry;
- no character has skipped ordinary characterization before tension;
- Marie has one positive scene not defined by reaction to another route;
- couple mode remains `HABITUAL_WARMTH`, becomes `ACTIVE_RECONNECTION`, or begins `PARALLEL_DRIFT`.

---

## Act II — `Les regards circulent`

Dramatic question:

```text
What does Player do when private attention becomes rewarding?
```

Mandatory spine functions:

- Marie becomes socially visible outside Player's passive gaze;
- all principal characters have ordinary presence by the end of the act;
- at least one private channel repeats;
- at least one character-specific tension engine becomes active;
- one trace, promise, debt, invitation, selected version, or missed opportunity persists;
- one cross-character awareness appears without omniscience;
- Player receives a real opportunity to choose Marie actively.

Allowed modular functions:

- Sandra precise trace;
- Mathilde gaze acknowledged;
- Pauline private selectivity;
- Nico social gaze or two-women-under-one-roof curiosity;
- Raphaëlle outside-work person / creative layer;
- Marie social visibility and reconquest;
- first controlled image or social trace;
- first route cooling if Player repeatedly avoids it.

Route ceiling:

```text
R1 Ordinary Access
R2 Charged Access
R3 Acknowledged Intent may begin
```

Adult ceiling:

- explicit fantasy may be discussed;
- charged or chosen images may appear with rules;
- full adult physical scenes remain exceptional and normally wait for Act III;
- no route may call hidden betrayal `informed sharing`.

Act II exit conditions:

- at least one route has meaningful tension or has been clearly declined;
- Marie / Player state has moved toward reconnection, drift, or concealed fracture;
- at least one pending obligation exists;
- no major trace is forgotten;
- route order differs according to choices without changing the spine question.

---

## Act III — `Les lignes choisies`

Dramatic question:

```text
Can desire remain hypothetical once a boundary has been named?
```

Mandatory spine functions:

- Marie makes or demands a concrete couple act;
- at least one character names attraction, limit, secrecy, or frame;
- Player chooses whether to stop, hide, disclose, ask permission, or cross;
- one private route becomes consequential or closes;
- one obligation returns before a new high-intensity opportunity replaces it;
- repeated passivity causes another character to act independently.

Allowed modular functions:

- Sandra distance revelation;
- Mathilde chosen provocation;
- Pauline reciprocal evidence;
- Nico photo / alibi pact or respectful rivalry;
- Raphaëlle chosen version and frame question;
- Marie active reconquest or explicit limit;
- first physical adult scene;
- first clear hidden betrayal;
- first informed open discussion;
- deliberate route refusal.

Route range:

```text
R2 Charged Access
R3 Acknowledged Intent
R4 Consequential Frame
```

R4 must be labeled as one of:

- hidden betrayal;
- informed adult frame;
- post-separation frame;
- negative / broken-boundary frame.

Act III exit conditions:

- Player has made at least one consequential choice;
- couple truth is no longer purely implicit;
- at least one route is active, paused, closed, or transformed by consequence;
- any explicit adult scene creates an aftermath obligation;
- multiple hidden routes create collision pressure rather than unlimited silent accumulation.

---

## Act IV — `Les versions se rencontrent`

Dramatic question:

```text
Who pays when private versions begin changing ordinary life?
```

Mandatory spine functions:

- at least one collision, discovery, direct confirmation, or explicit negotiation occurs;
- Marie acts from her own information and desire;
- supporting characters remain human where they are affected;
- one route's consequence changes another route or shared context;
- the Player / Marie relationship frame becomes explicit;
- high-intensity scenes include aftermath rather than resetting to neutral.

Allowed modular functions:

- Marie discovery or informed invitation;
- Mathilde family confrontation;
- Pauline exposed-exposer / Bastien consequence;
- Nico alibi or image-circulation collision;
- Raphaëlle clear-secret consequence / direct Marie confirmation;
- Sandra home-life consequence;
- confession;
- negotiated NTR/cuckold or sharing;
- trio / group content when every participant is separately eligible;
- route withdrawal;
- social-group fracture.

Route range:

```text
R3 Acknowledged Intent
R4 Consequential Frame
R5 Integration / Aftermath
```

Act IV exit conditions:

- Player and Marie are explicitly recommitting, negotiating, separating, lying deeper, or rupturing;
- affected adults' knowledge states are updated;
- hidden and informed routes are no longer conflated;
- no unresolved explicit scene lacks an aftermath path;
- the final act has a defined resolution family.

---

## Act V — `Ce qu'on choisit de garder`

Dramatic question:

```text
What remains after desire, exposure, and choice?
```

Mandatory functions:

- answer the Player / Marie question;
- resolve or deliberately leave unstable the active relationship frame;
- show ordinary life after major adult or betrayal content;
- resolve image, proof, alibi, workplace, family, and social consequences;
- give route characters agency in the ending;
- distinguish being desired, being chosen, and being used;
- avoid an ending that is only a sexual climax.

Possible resolution families:

- active exclusive couple;
- active redefined / informed non-exclusive couple;
- honest separation;
- post-separation external relationship;
- independent Player;
- concealed double life;
- exposed rupture;
- unstable negotiated arrangement;
- group arrangement that remains specific rather than generic.

End-state rule:

Every ending must answer:

```text
1. What are Player and Marie now?
2. What truth is known by each affected adult?
3. What relationship remains with the route character(s)?
4. What ordinary consequence remains after the erotic material?
```

---

## 8. Couple state model

The couple must not be represented by one love score.

The blueprint uses five conceptual dimensions.

### 8.1 Presence

```text
ABSENT
RESPONSIVE
PROACTIVE
```

Measures whether Player and Marie actively join one another.

### 8.2 Desire

```text
DORMANT
REACTIVE
EXPRESSED
SHARED_OR_REDEFINED
```

Measures whether desire is merely assumed, triggered by jealousy, actively expressed, or consciously redefined.

### 8.3 Trust

```text
INTACT
STRAINED
DAMAGED
BROKEN_OR_REBUILDING
```

Trust changes through actions, lies, disclosure, image handling, repeated presence, and aftermath.

### 8.4 Truth

```text
IMPLICIT
PARTIAL
CONCEALED
EXPLICIT
```

Truth is not a morality score.

It records how closely the lived relationship matches what both partners believe.

### 8.5 Relationship frame

```text
ASSUMED_EXCLUSIVE
REAFFIRMED_EXCLUSIVE
UNDER_NEGOTIATION
INFORMED_NON_EXCLUSIVE
SEPARATED
```

A frame is explicit structure, not mood.

### 8.6 Derived couple modes

#### `HABITUAL_WARMTH`

- love and trust broadly intact;
- presence inconsistent;
- desire underexpressed;
- exclusivity assumed;
- current start state.

#### `ACTIVE_RECONNECTION`

- Player and Marie choose concrete acts;
- desire becomes expressed before crisis alone forces it;
- external attention may exist without controlling the couple.

#### `PARALLEL_DRIFT`

- ordinary life continues;
- outside channels receive more active attention;
- Marie begins moving without waiting;
- truth may still be technically intact.

#### `CONCEALED_FRACTURE`

- public couple life continues;
- one or more meaningful secrets exist;
- trust appears intact because information is unequal;
- alibis, image circulation, or hidden intimacy matter.

#### `OPEN_CRISIS`

- the problem is named or discovered;
- trust and frame are unstable;
- characters act rather than only imply.

#### `NEGOTIATED_REDESIGN`

- relevant truths are explicit enough to negotiate;
- the couple may recommit exclusively or define a non-exclusive / shared frame;
- consent remains activity- and participant-specific.

#### `SEPARATED_TRANSITION`

- the couple is no longer current;
- shared history, housing, guilt, social ties, and prior betrayal remain consequential.

#### `RECONSTRUCTED_COUPLE`

- the relationship is actively chosen after consequence;
- may be exclusive or informed non-exclusive;
- maintained through action rather than assumed stability.

### 8.7 Transition rule

Couple mode changes through events, not one dialogue choice or hidden arithmetic alone.

Examples:

```text
repeated present acts
-> ACTIVE_RECONNECTION

repeated missed invitations + stronger private channels
-> PARALLEL_DRIFT

secret image / affair / alibi + normal public life
-> CONCEALED_FRACTURE

discovery or direct truth scene
-> OPEN_CRISIS

explicit agreement + sustained follow-through
-> NEGOTIATED_REDESIGN or RECONSTRUCTED_COUPLE

explicit end of relationship
-> SEPARATED_TRANSITION
```

J1 choices color the first transition but cannot skip directly to crisis.

---

## 9. Marie-centrality rules

To prevent external routes from replacing the main story:

1. Every act must contain at least one Marie scene where she is alive for her own sake, not only reacting to threat.
2. Across any two consecutive narrative cycles, at least one must materially involve Marie, shared life, or a consequence returning home.
3. After a major external escalation, a Marie/couple consequence becomes due in the next compatible cycle.
4. Marie may create windows independently when Player remains passive.
5. Marie's social life, work, desire, and friendships continue regardless of route selection.
6. External routes cannot suspend Marie until Player returns.
7. A repair route must include action before forgiveness.
8. An informed open route requires Marie's direct voice, not Player's summary.
9. A hidden route must preserve Marie's humanity even while she is absent.
10. A final route cannot answer only `who Player gets`; it must answer what happened to the couple.

---

## 10. Universal route lifecycle

Routes emerge from accumulated decisions.

They are not chosen from a character menu.

### R0 — Background

- character exists in the world;
- no active private access;
- attraction may exist in canon but is not a playable route state.

### R1 — Ordinary Access

- work, family, social, domestic, or message legitimacy;
- character becomes recognizable outside desire;
- no route promise.

### R2 — Charged Access

- character-specific tension becomes readable;
- gaze, trace, private rhythm, image, role, or social attention gains meaning;
- intent may still be denied.

### R3 — Acknowledged Intent

- at least one adult names attraction, risk, or boundary;
- repeated access is no longer accidental;
- route can be refused, paused, or deepened.

### R4 — Consequential Frame

The route becomes one of:

```text
HIDDEN_BETRAYAL
INFORMED_ADULT_FRAME
POST_SEPARATION_FRAME
NEGATIVE_BROKEN_BOUNDARY
```

A physical act is not the only possible R4 event.

Saving, forwarding, creating an alibi, explicit reciprocal proof, or a chosen role may also create consequence.

### R5 — Integration / Aftermath

- discovery;
- confession;
- repeat pattern acknowledged;
- role ends;
- relationship becomes ordinary enough to test;
- route closes, stabilizes, or transforms;
- consequences reach the couple, work, family, or group.

### `PAUSED`

A route remains possible but receives no escalation until context changes.

### `CLOSED`

A boundary or consequence closes access.

Reopening requires a materially changed context—not repeated pressure.

### Route-pressure rule

Many characters may exist at R1 or R2.

The story should not maintain unlimited hidden R3/R4 routes without collision.

```text
one unresolved secret
= pressure

two unresolved secrets
= cross-pressure and jealousy

three or more unresolved consequential secrets
= mandatory collision, exposure, confession, or structural choice
```

An informed group frame counts as one explicit multi-person arrangement, not as several hidden affairs.

---

## 11. Narrative windows

A window is created by a meaningful context change.

### 11.1 Window properties

Every window must identify:

- `location`;
- `time_band`;
- `available_characters`;
- `privacy`;
- `witnesses`;
- `channel`;
- `time_pressure`;
- `couple_visibility`;
- `intensity_ceiling`;
- `foreground_capacity`;
- `echo_capacity`;
- `pending_obligations`.

### 11.2 Canonical window families

#### `COUPLE_HOME`

Typical participants:

- Player;
- Marie;
- Mathilde when her stay is active.

Functions:

- ordinary life;
- participation;
- reconquest;
- domestic tension;
- return after outside scenes.

#### `HOME_WITHOUT_MARIE`

Typical candidates:

- Mathilde foreground;
- Sandra message;
- Nico private message / photo request;
- Pauline private relay;
- Marie social echo.

Guardrail:

Only one foreground route scene should dominate the window.

#### `MARIE_SOCIAL`

Typical candidates:

- Marie visibility;
- Nico;
- Pauline;
- La Verrière;
- group interaction;
- Player present or absent;
- social image / later trace.

#### `PLAYER_WITH_MARIE_SOCIAL`

Functions:

- active couple presence;
- Nico's saved seat / outside gaze;
- Pauline's social bridge;
- Marie choosing how visible to become;
- Player acting before jealousy becomes explanation.

#### `PLAYER_SEPARATE_OUTING`

Typical candidates:

- Nico ordinary friendship;
- Raphaëlle after-work walk;
- Sandra private rhythm;
- a choice that leaves Marie with her own evening.

#### `PLAYER_WORK`

Primary route candidate:

- Raphaëlle.

Possible echoes:

- Marie;
- Sandra;
- Pauline;
- Nico.

Work cannot become a universal route hub.

#### `PRIVATE_MESSAGE`

Typical candidates:

- Sandra;
- Pauline;
- Nico;
- Raphaëlle after private access exists;
- Marie couple exchange.

The window must state why the character is available.

#### `GROUP_EVENT`

Typical participants:

- Marie;
- Pauline;
- Nico;
- Player;
- Mathilde when context supports it;
- supporting characters when relevant.

Functions:

- social visibility;
- image origin;
- cross-character tension;
- public/private version contrast.

#### `TRACE_OR_IMAGE`

Created when:

- an image arrives;
- a crop differs;
- a trace is discovered;
- a saving rule matters;
- someone recognizes context.

It can be an echo or full foreground consequence depending on stakes.

#### `AFTERMATH`

Mandatory after:

- explicit adult scene;
- major boundary crossing;
- discovery;
- clear secret;
- group scene;
- image breach;
- confession.

Possible forms:

- morning after;
- return home;
- return to work;
- ordinary meal;
- deletion discussion;
- changed social behavior.

#### `COUPLE_TRUTH`

A high-priority window where Player and Marie must name or act on the relationship frame.

It cannot be replaced indefinitely by another optional route scene.

---

## 12. Window capacity and pacing

Default window budget:

```text
1 foreground scene
0–2 echoes
```

Rules:

1. A major explicit, discovery, or confrontation scene consumes the foreground capacity.
2. An echo cannot advance a route stage by itself.
3. One foreground scene should have one primary dramatic function.
4. A cross-character scene may affect several states, but one relationship remains primary.
5. Two high-intensity foreground scenes should not occur back-to-back without aftermath or ordinary-life return.
6. A consequence due outranks a new opportunity.
7. A route character cannot appear merely because their abstract score is high; the window must make them available.
8. Work schedules, household presence, partners, and social commitments create believable absence as well as access.
9. Supporting characters may affect context without consuming foreground capacity unless the consequence truly centers them.
10. A window can end with no optional route scene when ordinary life is the correct dramatic choice.

---

## 13. Scene-pool taxonomy

Every principal character can have multiple scenes in the following functional pools.

### `ORDINARY_LIFE`

Purpose:

- establish personhood;
- create rhythm;
- prevent route-only characterization;
- provide fallback scenes.

### `ACCESS`

Purpose:

- open a legitimate channel;
- establish location or relationship grammar;
- create repeatable availability without attraction promise.

### `ATTENTION`

Purpose:

- make Player notice a character-specific detail;
- reveal what quality of attention means to that character;
- create soft state.

### `TENSION`

Purpose:

- acknowledge gaze, desire, jealousy, image, version, or private rhythm;
- remain reversible.

### `BOUNDARY`

Purpose:

- state what is allowed, refused, slowed, or required;
- increase trust when respected;
- close or darken route when broken.

### `ESCALATION`

Purpose:

- move from intent to consequence;
- create hidden or informed adult frame;
- create proof, alibi, role, touch, image, or explicit act.

### `COLLISION`

Purpose:

- bring private and ordinary life together;
- pay a trace, lie, partner, work, family, or group consequence.

### `AFTERMATH`

Purpose:

- show what survives the intense scene;
- update trust, meaning, image rules, work rhythm, family, and future access.

### `REPAIR_OR_WITHDRAWAL`

Purpose:

- active couple repair;
- route stop;
- confession;
- respected distance;
- changed relationship form.

### `BREATHER`

Purpose:

- restore ordinary life;
- avoid permanent escalation;
- allow character humor, work, family, food, or craft to exist.

A scene pool is not a day.

A character may have several authored scenes in each pool, reusable in compatible windows.

---

## 14. Character-specific pool map

### Marie

```text
ORDINARY_LIFE      domestic participation / La Verrière / social energy
ACCESS             shared plans / walks / errands / event help
ATTENTION          Player notices effort, outfit, mood, initiative
TENSION            social visibility / outside gaze / jealousy / desire
BOUNDARY            concrete act instead of reassurance
ESCALATION          reconquest / explicit couple desire / informed sharing
COLLISION           discovery / confrontation / direct agreement
AFTERMATH           ordinary shared life after choice
REPAIR_WITHDRAWAL   recommit / redefine / separate / stop asking
```

### Sandra

```text
ORDINARY_LIFE      SentryCore / books / home refuge / family rhythm
ACCESS             trace / work-afterglow / old memory
ATTENTION          Player reads one concrete detail
TENSION            chosen confidence / distance becomes courage
BOUNDARY            soft limit / no pressure / chosen showing
ESCALATION          selected image / secret intimacy / post-separation route
COLLISION           Jeff context / home consequence / trace discovered
AFTERMATH           retreat, chosen return, confession, or closure
REPAIR_WITHDRAWAL   preserve home, leave, stop route, or redefine contact
```

### Mathilde

```text
ORDINARY_LIFE      temporary stay / work / family / kitchen / practical chaos
ACCESS             household help / spider / late return / outfit opinion
ATTENTION          Player's domestic gaze becomes readable
TENSION            Mathilde admits she likes the effect
BOUNDARY            loyalty to Marie / too fast / no pressure
ESCALATION          chosen provocation / image / hidden or informed adult frame
COLLISION           Marie / family trust / Nico gaze / who saw the image
AFTERMATH           leave, confess, hide, stay, or reset the household
REPAIR_WITHDRAWAL   loyalty route / post-separation continuation / route closure
```

### Pauline

```text
ORDINARY_LIFE      bank / Bastien / choir / hosting / friendship with Marie
ACCESS             legitimate relay / group plan / after-rehearsal return
ATTENTION          alternate wording / unnecessary alibi / private selection
TENSION            reciprocal question / double-addressed image
BOUNDARY            image rule / equal risk / no blame shifting
ESCALATION          reciprocal proof / controlled double life / adult instruction
COLLISION           Bastien, Marie, exposed exposer, repeated affair pattern
AFTERMATH           guilt, integration, deeper lie, confession, discovery
REPAIR_WITHDRAWAL   recognition and stop / leave / renegotiate / lose friendship
```

### Nico

```text
ORDINARY_LIFE      L'Annexe / football / closing / friendship
ACCESS             saved seat / invitation / La Verrière collaboration
ATTENTION          Marie / Mathilde attraction / Player's reaction
TENSION            domestic-access envy / voyeuristic questions / rivalry
BOUNDARY            what does she know / image origin / no proxy consent
ESCALATION          photo pact / alibi / shared gaze / affair / trio
COLLISION           image circulation / alibi tested / woman confronts both men
AFTERMATH           deletion, morning after, lost friendship, informed redesign
REPAIR_WITHDRAWAL   friend-mirror / refuse instrument role / step back
```

### Raphaëlle

```text
ORDINARY_LIFE      UX work / accessibility / walk / travel / craft / panda fault
ACCESS             lunch walk / garment bag / outside-work person
ATTENTION          process, detail, chosen version, creative account
TENSION            attraction named / fitting image / role discussed
BOUNDARY            work vs private / what Marie knows / image and touch rules
ESCALATION          roleplay / chosen adult image / clear secret / informed frame
COLLISION           return to office / Marie confirmation / account exposure
AFTERMATH           after the mask / ordinary version / professional consequence
REPAIR_WITHDRAWAL   colleague-only / post-separation / open / stop / confess
```

### Player

Player is present across pools through posture:

```text
join
notice
joke
avoid
ask
send
save
refuse
set boundary
hide
disclose
return
```

Player must never be reduced to a scheduler choosing which woman appears.

---

## 15. Scene-selection priority

Selection should be state-driven and context-driven, not random route roulette.

### Priority A — Safety, consent, and aftermath due

Examples:

- stop after boundary violation;
- delete / image consequence;
- post-explicit check-in;
- return to work after roleplay;
- immediate discovery response.

### Priority B — Fixed spine anchor due

Examples:

- Mathilde household entry;
- Marie invitation;
- couple frame conversation;
- mandatory collision.

### Priority C — Explicit obligation due

Examples:

- promised call;
- invitation accepted;
- alibi owed;
- unanswered direct question;
- saved-image rule;
- debt;
- trace with expiry;
- `we will talk tomorrow`.

### Priority D — Active route continuation

A route at R2–R4 may continue when context fits and no higher obligation is due.

### Priority E — Ordinary entry or new opportunity

Used to:

- introduce a principal character;
- prevent one route from monopolizing the story;
- provide ordinary life;
- create replay variation.

### Priority F — Breather / fallback

Used when:

- no route scene is eligible;
- pacing needs ordinary life;
- high intensity must cool;
- a character needs non-route presence.

Within the same priority band, prefer:

1. strongest context fit;
2. most overdue obligation;
3. unseen scene;
4. longest-deferred eligible scene;
5. least recently used character/pool;
6. authored deterministic tie-breaker.

Randomness must not override psychological coherence.

---

## 16. Obligations and persistent consequence

A choice may create an obligation even when no immediate route state changes.

Canonical obligation types:

- promise;
- invitation;
- unanswered question;
- debt;
- alibi;
- lie;
- image rule;
- deletion rule;
- boundary;
- confession owed;
- aftermath owed;
- missed opportunity;
- practical task;
- social expectation.

Every obligation must define:

- who owes it;
- who expects it;
- what window can pay it;
- whether it expires;
- what happens if ignored;
- whether it is known, hidden, or suspected;
- whether it creates route pressure.

```text
Nothing important waits forever unchanged.
```

An ignored obligation must:

- expire;
- mutate;
- damage trust;
- create withdrawal;
- become a trace;
- or force consequence.

---

## 17. Trace ledger

Every meaningful trace should record:

- origin;
- creator;
- current holder;
- intended audience;
- actual audience;
- consent level;
- whether it may be saved;
- whether it may be forwarded;
- who knows it exists;
- who suspects it exists;
- narrative meaning;
- discovery risk;
- possible payoff windows;
- current status: active, disclosed, deleted, lost, exposed, or transformed.

Trace classes:

### Soft trace

- ordinary;
- low risk;
- context creates meaning.

### Ambiguous trace

- can be read in multiple ways;
- does not prove route state alone.

### Chosen adult trace

- intentional sexual or intimate function;
- audience and rules matter.

### Dangerous trace

- hidden circulation;
- contradictory timestamp;
- alibi;
- saved image against rule;
- private knowledge visible publicly;
- behavior that reveals a secret.

### Severe prohibited capture

- hidden camera;
- incapacitated capture;
- intimate theft;
- secret sexual recording;
- coercive image threat.

This is not a standard reward loop and belongs only to severe negative/harm treatment if used at all.

---

## 18. Knowledge model

Characters cannot act on information they do not possess.

For every important fact, distinguish:

```text
KNOWN
SUSPECTED
MISREAD
UNKNOWN
```

Examples:

- Marie knows Pauline's old affair but not a future Player route;
- Bastien does not know Pauline cheated;
- Nico may suspect Pauline controls an audience without knowing why;
- Mathilde may know Player looked but not know an image was forwarded;
- Raphaëlle may know Player is unhappy without knowing the couple agreement;
- Sandra may sense distance without knowing another route exists.

No character becomes omniscient because they are perceptive.

A suspicion can influence tone.

It cannot substitute for fact in a confrontation unless the scene is about misreading.

---

## 19. Consent-frame ledger

Adult consent is specific.

A consent frame should record:

- participants;
- activity;
- location or channel;
- audience;
- touch permissions;
- image permissions;
- saving / forwarding rules;
- humiliation or power-exchange limits;
- duration or expiry;
- stop / slow signals;
- aftermath expectation;
- whether another relationship partner is informed.

Core rules:

```text
one yes != every yes
one participant's consent != another participant's consent
one image permission != permanent forwarding permission
one trio != consent for every contact pair
one informed scene != retroactive permission for prior betrayal
```

Hidden betrayal can be an adult route.

It must be labeled honestly as hidden betrayal.

---

## 20. Intensity budget

Intensity is a ceiling, not a target.

A playthrough may remain slower.

Rules:

1. Ordinary life must precede major erotic function for each character.
2. R2 tension may coexist across several characters.
3. R3 acknowledged intent requires a character-specific boundary scene.
4. R4 adult content requires a named hidden, informed, post-separation, or negative frame.
5. Explicit content creates aftermath due.
6. No repeated explicit escalation can indefinitely replace ordinary consequences.
7. Group content requires separately established motive and consent for each participant.
8. Adult tone may become direct and pornographic once earned.
9. Character voice must survive explicitness.
10. A route may close before sex and still be narratively complete.

---

## 21. Cross-character interaction hubs

Cross-character scenes should occur through credible hubs, not arbitrary pairings.

### 21.1 Shared home

Primary:

- Marie;
- Player;
- Mathilde.

Possible external pressure:

- Nico through messages / gaze;
- Pauline through Marie / visit / image;
- Sandra through private messages;
- Raphaëlle through work spillover only.

### 21.2 La Verrière / L'Annexe / social events

Primary:

- Marie;
- Nico;
- Pauline;
- Player;
- Mathilde when invited.

Functions:

- visibility;
- saved seat;
- group photo;
- public/private version;
- ordinary social proof.

### 21.3 Player's work

Primary:

- Player;
- Raphaëlle.

Functions:

- professional trust;
- outside-work access;
- return-to-office consequence.

Other routes may echo by message but should not crowd the workplace hub.

### 21.4 Private message channels

Primary:

- Sandra;
- Pauline;
- Nico;
- Raphaëlle after access;
- Marie.

Each channel needs its own legitimate rhythm.

### 21.5 Image circulation hub

Primary interaction tensions:

```text
Pauline = selected audience
Nico = circulation and reciprocal access
Mathilde = domestic safety and changed intention
Marie = couple privacy and active gaze
Raphaëlle = authored version and explicit frame
Sandra = chosen private trace, not default circulation
```

### 21.6 Couple-truth hub

Marie intersects every external route here.

Possible forms:

- suspicion;
- discovery;
- direct question;
- confession;
- explicit agreement;
- refusal;
- separation;
- reconquest.

Marie is not required to interact personally with every route character before consequences exist.

---

## 22. Cross-character coherence rules

### Marie / Mathilde

- family trust remains active;
- Mathilde cannot become only forbidden body;
- Marie's home must not become a consequence-free sexual set.

### Marie / Pauline

- friendship and old partial confession matter;
- Pauline's betrayal affects Marie's trust in her social world, not only Player.

### Marie / Nico

- Nico's gaze may wake desire or jealousy;
- Marie remains the person choosing whether to answer it.

### Marie / Raphaëlle

- direct confirmation is required for healthy open routes;
- local clarity between Player and Raphaëlle does not create Marie's consent.

### Sandra / Pauline

- privacy is not the same as compartmentalized deception;
- neither becomes the other's moral lecturer.

### Mathilde / Nico

- Nico genuinely desires Mathilde;
- Player's domestic view does not grant Nico access;
- Mathilde may choose the gaze, refuse it, or turn it back on both men.

### Pauline / Nico

- selected audience conflicts with circulation;
- consensual shared gaze can be erotic;
- unauthorized forwarding is severe betrayal.

### Pauline / Raphaëlle

```text
Pauline asks whether anything must change yet.
Raphaëlle asks who benefits from waiting.
```

### Nico / Raphaëlle

- Nico names desire;
- Raphaëlle asks who knew and what the image or role permitted;
- neither is automatically more ethical.

### Sandra / Raphaëlle

- silence can be an active boundary;
- clarity must not become pressure.

---

## 23. Route compatibility principles

### Active exclusive couple

Compatible with:

- Marie reconquest;
- external R1/R2 attraction;
- respected route closure;
- friendships;
- fantasies discussed but not enacted outside agreement.

### Hidden affair

Requires:

- R3 acknowledged intent;
- R4 hidden frame;
- affected partner not informed;
- consequence and trace;
- no euphemistic relabeling as openness.

Character-specific forms:

- Sandra chosen secret;
- Mathilde domestic betrayal;
- Pauline controlled double life;
- Nico / Marie or Nico / Mathilde hidden affair;
- Raphaëlle clear secret.

### Informed non-exclusive / open frame

Requires:

- Player and Marie's direct agreement;
- route character's direct agreement;
- participant-specific limits;
- current image and contact rules;
- no retroactive absolution.

### NTR / cuckold / sharing

Nico is the primary male route engine.

Requires:

- Marie or another relevant woman speaking for herself;
- Player's explicit role;
- Nico's acceptance;
- distinction between watching, participating, receiving images, humiliation, and absence;
- aftermath.

Hidden betrayal may be experienced as NTR by Player.

It is not consensual cuckold content.

### Trio / quatuor / group

Requires:

- each participant already has ordinary characterization;
- attraction and motive established;
- separate consent for each meaningful contact;
- image rules;
- a frame that does not erase earlier betrayal;
- capacity for aftermath.

No character enters merely because they are available in the cast.

### Post-separation route

Requires an explicit separation state.

It does not erase:

- prior secrecy;
- family impact;
- friendship betrayal;
- workplace consequences;
- social-group consequences.

### Dark image route

Requires:

- identifiable image origin;
- known or avoided consent state;
- deliberate choice by Player / Nico / Pauline or another participant;
- consequence;
- no clean collectible framing.

### Route withdrawal

A character may decide the context no longer respects them.

Withdrawal is a valid route outcome, not failure.

---

## 24. Replayability model

Replayability comes from meaningful variation, not random content order alone.

### 24.1 Sources of variation

- Player's topology choices;
- which character is available in a window;
- which obligation is due;
- route stage;
- couple mode;
- knowledge differences;
- image/trace history;
- respected or broken boundaries;
- scenes previously seen;
- opportunities deferred or missed;
- informed vs hidden frame;
- character withdrawal.

### 24.2 What remains fixed

- central couple question;
- act functions;
- Mathilde household change;
- Marie's active life;
- ordinary entry before major escalation;
- a boundary anchor;
- a consequential choice;
- collision;
- couple-frame declaration;
- aftermath.

### 24.3 Scene lifecycle

```text
DORMANT
-> ELIGIBLE
-> OFFERED
-> SEEN / DEFERRED / MISSED
-> MUTATED / EXPIRED
-> CONSEQUENCE_DUE
-> RESOLVED
```

A skipped scene must not remain unchanged forever.

It may:

- return in a different context;
- become colder;
- become more direct;
- expire;
- create missed-opportunity consequence;
- be replaced by another scene serving the same spine function.

### 24.4 Repetition rule

Reuse an engine, not exact dialogue.

Examples:

- several Mathilde morning scenes may use the same domestic-gaze engine;
- several Pauline public/private scenes may use different objects and audiences;
- several Raphaëlle version scenes may use different construction stages;
- several Nico photo-pact scenes may use different origins and consent levels;
- several Sandra traces may reveal different aspects of chosen confidence.

Exact scenes require cooldown and should not repeat unchanged.

### 24.5 Variety without incoherence

Within the same priority band, unseen and least-recent scenes are preferred.

Variety never overrides:

- hard conditions;
- character availability;
- knowledge;
- consent;
- pending consequence;
- act intensity ceiling.

---

## 25. Route monopolization and secret load

To prevent one route from erasing the ensemble:

1. Ordinary Marie/shared-life scenes remain mandatory.
2. A route cannot advance in every consecutive window.
3. At least one breather or consequence follows major escalation.
4. Characters ignored repeatedly may cool or withdraw.
5. New low-intensity opportunities may still appear while one route is active.
6. Multiple R3/R4 secrets create cross-pressure.
7. A third consequential hidden route forces collision before further escalation.
8. Informed group routes are not treated as secret overload when every relevant adult knows the frame.
9. A character may refuse to remain only one item in Player's route collection.
10. Endings reward coherent accumulated choices, not maximal route count.

---

## 26. Worked topology example — Marie proposes an evening

This is an architecture example, not final J2 text.

### Fixed setup

Marie proposes a meaningful evening connected to:

- La Verrière;
- a social plan;
- a small event;
- or a need to move together.

The source pack authors three final choices.

They should resolve into three distinct topologies.

### Topology A — Player joins Marie

Context:

- public/social;
- Marie and Player visible together;
- Nico / Pauline may be naturally present;
- Mathilde may join only if invited;
- Sandra and Raphaëlle are normally echoes, not foreground.

Eligible foreground examples:

- Marie social visibility;
- Nico saved seat / respectful gaze;
- Pauline group photo / legitimate relay;
- couple participation at La Verrière.

Possible consequences:

- active reconnection;
- Player sees Marie desired;
- Nico attraction becomes readable;
- Pauline notices couple presentation;
- social image created.

### Topology B — Marie goes, Player stays home

Context:

- Marie has independent social life;
- Player is in shared home;
- Mathilde may be present;
- private messages become plausible;
- Marie social trace may arrive later.

Eligible foreground examples:

- Mathilde domestic scene;
- Sandra private trace;
- Pauline private relay;
- Nico asks what Player sees at home;
- ordinary solitary Player scene if no route fits.

Only one foreground scene is selected.

Possible echoes:

- Marie photo;
- Nico social message;
- Sandra goodnight;
- Mathilde object in the apartment.

### Topology C — Player chooses a separate responsibility or outing

Context:

- Player and Marie spend the window apart by explicit choice;
- Player may be at work, with Nico, or on an independent errand;
- Raphaëlle or Nico may become foreground;
- Marie continues her plan.

Eligible foreground examples:

- Raphaëlle work / walk;
- Nico ordinary friendship;
- Sandra private message;
- no route scene, followed by Marie consequence.

### Return anchor

Every topology creates a later return:

- Player joins Marie and returns home with shared memory;
- Player stayed home and receives Marie's changed energy;
- Player chose separately and must answer what the separation meant.

The route scene never replaces the return anchor.

```text
The choice does not select a woman.
It creates a context in which different scenes become plausible.
```

---

## 27. Authoring rules against combinatorial explosion

1. Do not write every possible character combination.
2. Give each scene one primary dramatic function.
3. Use a small number of validated context variants.
4. Reuse engines with new concrete objects, not generic name substitution.
5. Do not dynamically assemble intimate dialogue from arbitrary fragments.
6. Cross-character scenes require a credible hub and existing relationship.
7. A scene can read several states but should write only the states its function justifies.
8. Supporting characters appear proportionally.
9. A consequence scene may replace a new opportunity.
10. If a context changes the scene's meaning completely, author a different scene rather than an excessive variant.
11. Do not create a route flag for every sentence.
12. Preserve readable state categories and explicit obligations.

---

## 28. Implementation boundary

This document is runtime-neutral.

Future runtime work may represent the architecture through:

- tags;
- enums;
- small counters;
- ledgers;
- scene history;
- condition predicates;
- explicit route frames.

It must not require:

- one giant refactor;
- a universal simulation engine;
- procedural dialogue generation;
- a route score that replaces character logic;
- rewriting all existing runtime at once.

Recommended implementation sequence after documentation validation:

```text
1. Act I / opening-window source pack
2. modular scene inventory
3. runtime state mapping
4. one small vertical slice
5. validation
6. expand pool by pool
```

Documentation first.

Runtime second.

---

## 29. Acceptance criteria

V0.78 succeeds if:

- the central story remains Player / Marie;
- acts are defined without fixed day dependence;
- J1 has a clear output state;
- Mathilde's household role becomes a spine function;
- every principal character has a modular entry and progression path;
- choices change context rather than directly selecting routes;
- three choices remain the default;
- scenes have windows, conditions, consequences, and follow-ups;
- due consequences outrank new temptation;
- image, knowledge, and consent rules are explicit;
- multiple secrets create collision pressure;
- adult content can become direct and pornographic without becoming generic;
- Marie remains active in every act;
- supporting characters remain proportional and human;
- replayability comes from meaningful context variation;
- the architecture can be implemented incrementally;
- no J2 dialogue or runtime is changed.

---

## 30. Anti-patterns

Avoid:

- fixed J2–J10 route schedules;
- a character-selection menu disguised as dialogue;
- one affection score controlling all scenes;
- six parallel stories with Marie as obstacle;
- one route monopolizing every window;
- every character messaging in the same evening;
- random scene choice before obligations and context;
- exact scene repetition;
- permanent escalation without breathers;
- explicit scenes without aftermath;
- forgotten promises or images;
- omniscient characters;
- group content unlocked by route count alone;
- domestic access treated as consent;
- a photo treated as route activation;
- route closure ignored by repeated pressure;
- support characters receiving principal-level mass without function;
- procedural generic dialogue;
- large runtime refactor before a validated vertical slice;
- writing J2 before the opening-window source pack exists.

---

## 31. Final rule

```text
The spine asks one fixed question:
can Player and Marie make their couple an active choice again?

The windows decide where Player is,
who is plausibly available,
and what private possibility appears.

The scenes reveal how he acts.

The traces remember.

The consequences force every private version
back into the same human life.
```
