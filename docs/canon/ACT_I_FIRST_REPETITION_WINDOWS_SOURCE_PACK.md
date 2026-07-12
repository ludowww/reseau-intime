# Act I First Repetition Windows Source Pack — V0.87

> Canon line, state, selection, and voice source for the first post-opening repetition wave.  
> Begins after V0.86 writes `opening_band_complete`.  
> Documentation only: this file does not authorize a runtime, JSON, GDScript, test, scene, or asset change.

## 1. Status and authority

This source pack is current canon for the first narrative wave after the Tuesday–Friday opening.

Read it after:

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/NARRATIVE_CANON_STATUS.md
docs/canon/CHOICE_DESIGN_CANON.md
docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md
docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md
docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md
docs/canon/CHARACTER_VOICE_DISTINCTION_CANON.md
```

Then read:

```text
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SCENE_CARDS.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_TEMPORAL_DELIVERY_MAP.md
```

The relevant full character canon and deprecation map remain primary for every character scene.

This pack supersedes any older fixed-day assumption that would automatically move from Friday into:

- a private Pauline crop;
- a Nico photo request;
- a Mathilde seduction scene;
- a Raphaëlle private-account reveal;
- a new Sandra image;
- an explicit adult scene;
- a character-selection menu.

Later character engines remain valid. This pack decides which repetitions must occur before those engines can become earned.

---

## 2. Act placement

Blueprint position:

```text
Act I — La place qu'on laisse
S4 — Private attention repeats
```

The opening has already established ordinary access.

V0.87 asks:

```text
When ordinary access repeats,
which attention changes meaning first?
```

Expected diegetic duration:

```text
roughly the weekend after Friday
through the first one or two workdays
```

This is one first-repetition wave, not the rest of Act I.

---

## 3. Baseline inherited from V0.86

```text
opening_band_complete = true
household_rhythm_confirmed = true

Marie / Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE

Sandra = soft trace / ordinary continuity
Mathilde = R1 Ordinary Access, temporary stay active
Raphaëlle = R1 Ordinary Work Access
Pauline = R1 Legitimate Social Access
Nico = R1 Ordinary Friendship / Social Access

hard secrets = none
adult frames = none
routes R2+ = none
```

Opening history remains readable:

- Player's quality of presence with Marie;
- whether he participated actively, playfully, or passively in making room;
- Mathilde arrival posture;
- Thursday topology;
- whether Sandra's Thursday window was seen or expired;
- whether Player joined Marie, stayed home, or worked then joined;
- whether a work promise was kept, amended, or missed;
- Pauline's public-photo posture;
- Nico's friendship posture;
- all existing trace origins and audiences.

No generic affection score replaces those observable facts.

---

## 4. Product boundary

V0.87 may create:

- repeated ordinary access;
- clearly readable private attention;
- one first `R2 Charged Access` transition at most;
- active-reconnection evidence with Marie;
- parallel-drift evidence;
- a concrete promise and its payment or failure;
- a deferred or missed opportunity;
- a character-specific cooldown;
- a mandatory return toward Marie/shared life.

V0.87 does not create:

- explicit sexual content;
- an adult image;
- a private alternate Pauline crop;
- a Nico image exchange or photo pact;
- an alibi;
- a hard secret;
- a hidden affair;
- a negotiated open frame;
- sharing, cuckold, NTR, trio, or group content;
- Raphaëlle's private creative-account reveal;
- Mathilde deliberate seduction;
- a new Sandra photo;
- a relationship-frame change;
- a permanent route lock.

```text
Charged access is not adult permission.
Private attention is not a hard secret.
Arousal or jealousy is not consent.
```

---

## 5. Voice separation contract

The six non-Player voices must not collapse into one shared style of clever, procedural dialogue.

```text
A memorable phrase belongs to the person whose life produced it.
It is not communal vocabulary for the whole cast.
```

### 5.1 Legal vocabulary belongs primarily to Mathilde

Mathilde may use legal seasoning such as:

```text
objection
irrecevable
dossier
pièce à conviction
preuve insuffisante
je plaide...
```

Dosage in this wave:

```text
ordinary Mathilde scene = zero or one legal turn
work-centered or earned complicity scene = one or two maximum
```

Other characters may use a legal word only when it is literally required by context. They do not borrow legal vocabulary as recurring flirt, humor, or emotional shorthand.

Forbidden voice leakage in non-Mathilde dialogue includes:

```text
base contractuelle
j'enregistre la dette sans intérêts
je classe le dossier
objection
verdict
accusé
pièce à conviction
```

### 5.2 Character-specific lexical anchors

```text
Marie
= shared life, food, movement, invitations, social energy,
  practical teasing, concrete action before reassurance

Sandra
= traces, minimization, quiet work absurdity, warmth,
  hesitation, chosen distance, soft boundary

Mathilde
= speed, correction, embarrassment, bad faith,
  image control, occasional legal seasoning

Pauline
= dry control, timing, audience, public/private versions,
  practical social competence, a line closed then reopened

Nico
= food, service, chairs, rooms, social rhythm,
  blunt ordinary language, humor that can fall quiet

Raphaëlle
= process, detail, one clear question, selected information,
  calm space, precise invitation or limit

Player
= short, dry, imperfect, occasionally work-tired,
  observant without becoming a perfect stylistic mimic
```

### 5.3 Review rule

Before approving any line, ask:

```text
Could another character say this unchanged?
Is the joke borrowed from Mathilde's profession?
Is everyone sounding administratively clever?
Does the line arise from this person's actual work, home, wound, and rhythm?
```

If the answer reveals voice borrowing, rewrite before runtime planning.

---

## 6. First-repetition wave architecture

```text
W9  — Marie claims one shared hour                    fixed foreground
W10 — Weekend repetition opportunity                 variable foreground
W11 — Weekend couple return                          fixed consequence / anchor
W12 — First-workday repetition opportunity           variable foreground
W13 — Wave close / couple balance                    fixed consequence / anchor
```

### 6.1 Foreground budget

Across `W10` and `W12`:

```text
maximum external foregrounds = 2
maximum foregrounds per window = 1
maximum echoes per window = 2
same character foreground twice = forbidden
```

Selection order:

```text
safety / consequence due
-> fixed spine due
-> obligation due
-> compatible continuation
-> physical and temporal context fit
-> unseen eligible scene
-> longest deferred
-> least recently foregrounded pool
-> authored deterministic order
```

No random choice occurs before these rules.

A quiet window is valid.

### 6.2 Charged-access budget

Only these scenes can create the first charged-access transition in V0.87:

```text
Mathilde — morning gaze acknowledged
Sandra — work-afterglow confidence
Raphaëlle — outside-work person
```

Global rule:

```text
charged_access_owner = none | mathilde | sandra | raphaelle
maximum one owner in V0.87
```

If one route reaches R2:

- all other charged candidates remain ordinary or defer;
- a Marie/shared-life consequence becomes due before another external foreground;
- no sexual permission is inferred;
- no image permission is inferred;
- no relationship frame changes.

Pauline and Nico remain R1 throughout this pack. Their dangerous engines require another validated cycle.

---

# 7. W9 — Marie claims one shared hour

## 7.1 Scene identity

```text
scene_id: marie_saturday_shared_hour_01
window: PRIVATE_MESSAGE -> OFFLINE_SHARED_TIME
primary relationship: Player / Marie
function: positive couple agency + concrete presence test
intensity: ordinary / warm
route effect: none
```

## 7.2 Calendar and delivery

Preferred anchor:

```text
Saturday morning after the Friday opening close
09:30–10:20
```

Marie has already left the apartment to return La Verrière keys, visit the market, or pick up one practical item.

Player is still at home or on his way out.

Mathilde is asleep, on an insurer call, showering, or handling her own morning.

Communication mode:

```text
REMOTE_ASYNC
```

The shared hour happens offline if Player joins. No fake Messenger transcript replaces the café, market, or walk.

## 7.3 Canon line source

```text
Marie : J'ai rendu les clés de La Verrière.
Marie : Et j'ai trouvé des tomates qui n'ont pas l'air tristes.
Marie : J'ai une heure avant de redevenir une adulte utile.
Marie : Tu me rejoins pour un café ?
```

The humor comes from Marie's lived morning, not from Mathilde's legal vocabulary or Player's office language.

## 7.4 Choice M2 — What Player does with the hour

Primary axis:

```text
Does Player actively make shared time,
make a concrete alternative,
or leave Marie to move without him?
```

### M2A — Join now

```text
Player : oui
Player : donne-moi dix minutes
Player : je viens sans ordinateur

Marie : C'est surtout la dernière phrase qui m'intéresse.
Marie : Je suis près du marché.
```

Writes:

- `marie_shared_hour_joined`;
- active-reconnection evidence;
- no later promise for this hour;
- Marie feels actively chosen;
- later external attention does not erase the shared act.

### M2B — Offer a real alternative

```text
Player : je peux pas tout de suite
Player : mais je fais le déjeuner et on marche après
Player : vraie proposition, pas report flou

Marie : Accepté.
Marie : Je garde l'heure, pas la bonne intention.
Marie : À tout à l'heure.
```

Writes:

- `marie_shared_hour_rescheduled`;
- concrete shared-time obligation due before the weekend return;
- active-reconnection evidence only if paid;
- drift evidence if missed.

### M2C — Let Marie act independently

```text
Player : je dois finir deux trucs
Player : profite
Player : je te retrouve plus tard

Marie : Je vais profiter.
Marie : Le plus tard est à toi cette fois.
```

Writes:

- `marie_moves_without_player`;
- Marie retains independent agency and enjoyment;
- concrete return due;
- soft parallel-drift evidence only;
- no punishment route and no crisis speech.

## 7.5 Offline result

If M2A:

- Player joins Marie;
- they drink coffee, walk through the market, or carry one bag together;
- the phone is not used for a long conversation while they are together.

If M2B and paid:

- the promised lunch/walk happens later;
- the exact action may be represented through subsequent tone and state rather than an explanatory card.

If M2C:

- Marie completes her hour alone;
- she may buy flowers, sit with coffee, or call Pauline briefly;
- she is not frozen until Player becomes available.

## 7.6 Exit state

- Marie has done something for herself;
- Player's weekend presence posture is observable;
- the first external repetition window may open;
- a concrete return is due after any external foreground;
- couple mode remains `HABITUAL_WARMTH`.

---

# 8. W10 / W12 candidate — Mathilde morning gaze acknowledged

## 8.1 Scene identity

```text
scene_id: mathilde_morning_kitchen_afterglow_01
pool: ATTENTION
primary relationship: Player / Mathilde
secondary relationship: Player / Marie
function: ordinary domestic sensuality becomes a readable gaze
route range: R1 -> optional R2 Charged Access
intensity: soft charge
```

## 8.2 Entry conditions

Required:

- Mathilde temporary stay active;
- an ordinary kitchen moment occurred while Marie was elsewhere;
- Player and Mathilde are no longer in the same room when messages begin;
- no Mathilde boundary violation is unresolved;
- no Marie consequence is overdue;
- exact morning-gaze engine not recently seen.

Soft preferences:

- Player helped with the room or household;
- Mathilde ordinary trust or playful complicity exists;
- Player did not treat her arrival as an inconvenience;
- O5B was not the immediately previous foreground.

Excluded:

- deliberate outfit selection for Player already established;
- Mathilde route closed;
- explicit aftermath due;
- Marie present in the kitchen and free to speak;
- Player secretly photographing or describing Mathilde to another person.

## 8.3 Physical event and message reason

The kitchen moment is ordinary:

- coffee;
- a cupboard or filter question;
- Mathilde in normal fitted homewear;
- Player looking slightly too long;
- Mathilde noticing;
- no touch and no staged pose.

Messaging begins after Mathilde leaves for work, an insurer appointment, laundry, or a contractor call.

Mode:

```text
AFTERGLOW_REMOTE
```

## 8.4 Canon line source

```text
Mathilde : Tu sais que tu n'es pas discret avant le café ?

Player : sur quoi

Mathilde : Mauvaise défense.
Mathilde : Et c'est ma tenue normale.
Mathilde : Donc ne transforme pas ça en scénario.
```

## 8.5 Choice MT1 — How Player owns the gaze

Primary axis:

```text
Does Player acknowledge the gaze respectfully,
enter playful complicity,
or deliberately restore distance?
```

### MT1A — Respectful acknowledgement

```text
Player : j'ai regardé
Player : oui
Player : pas une raison pour te mettre mal à l'aise

Mathilde : Ça ne m'a pas mise mal à l'aise.
Mathilde : C'est justement pénible.
Mathilde : Bref.
```

Writes:

- `mathilde_gaze_acknowledged_soft`;
- Mathilde knows Player noticed;
- Player owns his gaze without claiming her clothing as permission;
- R2 only if prior household trust is positive and no other charged owner exists;
- deliberate Mathilde intent remains false.

### MT1B — Playful but readable

```text
Player : j'étais surtout inquiet pour le café
Player : la tenue n'a pas aidé

Mathilde : Très mauvaise défense.
Mathilde : Je la garde pour le dossier.
Mathilde : Et je refuse de préciser pourquoi je souris.
```

This is the one legal-flavored turn in the scene. It belongs to Mathilde's established voice.

Writes:

- `mathilde_gaze_playful_soft`;
- ordinary complicity gains charge;
- R2 only if prior playful trust exists and no other charged owner exists;
- no image, invitation, or sexual permission.

### MT1C — Restore distance

```text
Player : j'aurais dû être plus discret
Player : on garde ça simple

Mathilde : Oui.
Mathilde : Simple, ça me va.
Mathilde : Et le café était quand même mauvais.
```

Writes:

- `mathilde_distance_respected`;
- route remains R1;
- no punishment;
- Mathilde does not respond by escalating harder.

## 8.6 Exit state

- Mathilde knows whether Player can own a gaze without taking control of its meaning;
- Marie remains family trust and household context;
- no deliberate provocation has occurred;
- outfit-opinion and chosen-image scenes remain locked;
- exact engine cooldown: two compatible foreground windows.

---

# 9. W10 / W12 candidate — Sandra work-afterglow

## 9.1 Scene identity

```text
scene_id: sandra_ticket_ghost_hot_chocolate_01
pool: ATTENTION / CONFIDENCE
primary relationship: Player / Sandra
function: a second chosen private rhythm without a new image
route range: R1 -> optional R2 Charged Access
intensity: soft charge
```

## 9.2 Entry conditions

Required:

- J1 Sandra trace remains active or warmly unresolved;
- no clear Sandra route closure;
- no pressure after her prior boundary;
- one full compatible window since her last foreground;
- Sandra has a credible end-of-post or late quiet interval;
- no overdue Marie consequence.

Preferred:

- J1 precise observation or safe warmth;
- Thursday Sandra scene completed rather than ignored;
- Player previously accepted Sandra ending an exchange.

If Thursday was missed:

- do not replay the exact `button returned` exchange immediately;
- defer to a later colder work-afterglow variant;
- do not punish a route that had already cooled.

Excluded:

- a new Sandra photo;
- direct Jeff-villain exposition;
- a late-night message while Sandra is asleep or unavailable;
- Player repeatedly trying to reopen a closed subject.

## 9.3 Canon line source

```text
Sandra : Le bouton fantôme est revenu.
Sandra : J'ai fermé le ticket.
Sandra : Il s'est rouvert par principe.

Player : il a une vie intérieure

Sandra : Plus structurée que la mienne ce soir.
Sandra : J'ai fait un chocolat chaud.
Sandra : C'est mon escalade professionnelle.
```

Sandra uses her own SentryCore rhythm and soft understatement. She does not borrow Mathilde's legal humor.

## 9.4 Choice S2 — What Player answers to the chosen contact

Primary axis:

```text
Does Player read the private reason,
offer ordinary care,
or respect the closing hour?
```

### S2A — Precise, not magical

```text
Player : le bouton non
Player : le chocolat chaud peut-être
Player : tu voulais parler à quelqu'un encore réveillé

Sandra : Tu as une façon pénible de viser juste.
Sandra : Oui.
Sandra : Mais ne transforme pas ça en grande vérité.
```

Writes:

- `sandra_chosen_contact_read_precisely`;
- Sandra admits she selected Player for this quiet interval;
- R2 only if prior precise warmth and respected boundary exist and no other charged owner exists;
- no confession and no image.

### S2B — Ordinary care

```text
Player : je vote pour le chocolat chaud
Player : le ticket survivra dix minutes sans toi

Sandra : Il a déjà survécu à trois équipes.
Sandra : Moi aussi, probablement.
Sandra : Merci.
```

Writes:

- `sandra_ordinary_warmth_repeated`;
- route remains R1;
- Sandra feels accompanied without being read through;
- future work-afterglow remains eligible after cooldown.

### S2C — Respect the hour

```text
Player : va dormir
Player : je te laisse décrocher
Player : bonne nuit Sandra

Sandra : C'est raisonnable.
Sandra : Étonnamment agréable aussi.
Sandra : Bonne nuit.
```

Writes:

- `sandra_boundary_respected_again`;
- route remains R1 but trust stays open;
- no missed-opportunity penalty.

## 9.5 Exit state

- Sandra has chosen a second private rhythm or remained ordinary;
- Player's precision is not automatic virtue;
- no new trace exists;
- Jeff remains a real but unexploited part of Sandra's life;
- exact engine cooldown: two compatible private-message windows.

---

# 10. W12 candidate — Raphaëlle outside-work person

## 10.1 Scene identity

```text
scene_id: raphaelle_lunch_walk_outside_work_01
pool: ACCESS / ATTENTION
primary relationship: Player / Raphaëlle
function: move from work competence to one selected ordinary personal layer
route range: R1 -> optional R2 Charged Access
intensity: ordinary to soft charge
```

## 10.2 Entry conditions

Required:

- Raphaëlle work access established;
- normal peer relationship intact;
- a real work task has just resolved;
- separate workstations or a remote written handoff justify the opening messages;
- lunch or short-walk time exists;
- no Marie consequence overdue.

Preferred:

- Player respected Raphaëlle's correction;
- O5C was completed or a later work task gives a fresh context;
- no recent after-hours work foreground.

Excluded:

- Player using work to avoid an immediate Marie obligation;
- private creative account reveal;
- costume, fitting, garment bag, or adult image;
- emotional confession during deadline pressure;
- workplace hierarchy or leverage.

## 10.3 Canon line source

```text
Raphaëlle : Le prototype est validé.
Raphaëlle : Tu peux cesser de protéger le bouton avec ton corps.

Player : c'était une relation sérieuse

Raphaëlle : Elle a survécu.
Raphaëlle : Je vais marcher dix minutes avant le point de 14h.
Raphaëlle : Tu viens ?
```

Raphaëlle's humor comes from process and observation, not legal vocabulary.

## 10.4 Choice R1 — Whether Player enters the selected ordinary layer

Primary axis:

```text
Does Player join outside-work time,
defer honestly,
or remain inside work as shelter?
```

### R1A — Join

```text
Player : oui
Player : je ferme mes onglets
Player : et je ne parle pas du bouton

Raphaëlle : C'est presque une promenade normale.
Raphaëlle : On va tester.
```

Offline walk:

- no relationship diagnosis;
- one ordinary detail about fabric, a market, tea, Maud, or a useless purchase;
- Player and Raphaëlle return to work separately.

After separation:

```text
Raphaëlle : J'ai quand même acheté du tissu sans projet.
Raphaëlle : Information inutile mais vraie.
```

Writes:

- `raphaelle_outside_work_access`;
- one selected personal layer;
- R2 only if Player joined without using Raphaëlle as refuge and no other charged owner exists;
- creative account remains private.

### R1B — Honest defer

```text
Player : pas aujourd'hui
Player : j'ai besoin de finir proprement
Player : mais je veux bien la prochaine fois

Raphaëlle : D'accord.
Raphaëlle : Je te proposerai une autre fois.
Raphaëlle : Une seule.
```

Writes:

- `raphaelle_walk_deferred_once`;
- concrete opportunity may return once;
- route remains R1;
- no penalty if the later promise is paid.

### R1C — Stay in work

```text
Player : je vais rester
Player : j'ai trop de retard

Raphaëlle : Très bien.
Raphaëlle : Je te laisse avec ton bouton.
Raphaëlle : Il avait l'air inquiet.
```

Writes:

- `raphaelle_professional_frame_maintained`;
- route remains R1;
- no private invitation waits forever;
- a later scene needs a fresh reason.

## 10.5 Exit state

- Raphaëlle may become a person Player knows outside the office, not yet a chosen transformed version;
- no private account, photo, costume, or adult frame exists;
- a deferred walk expires after one compatible workday;
- exact engine cooldown: one full work cycle.

---

# 11. W10 / W12 candidate — Pauline legitimate social repetition

## 11.1 Scene identity

```text
scene_id: pauline_bastien_sunday_table_01
pool: ORDINARY_LIFE / ACCESS
primary relationship: Player / Pauline
secondary relationships: Player / Marie; Pauline / Bastien
function: second legitimate social cycle with Bastien visibly real
route range: R1 only
intensity: ordinary
```

## 11.2 Entry conditions

Required:

- Pauline public/social access established;
- Marie and Pauline friendship active;
- Bastien current-partner reality visible in the setup;
- at least one full cycle since the Friday public-photo relay;
- no private Pauline compartment active;
- no overdue Marie consequence.

Excluded:

- private alternate crop;
- one-view image;
- body-focused selection;
- old-affair disclosure to Player;
- unnecessary alibi;
- choir used as sexual shorthand;
- Bastien conveniently erased.

## 11.3 Canon line source

```text
Pauline : Bastien a décidé que les restes du vernissage méritaient une seconde carrière.
Pauline : On mange à 19h.
Pauline : Marie dit oui.
Pauline : Elle te laisse gérer ta propre existence.
```

Pauline sounds dry and controlled. She does not borrow Mathilde's legal jokes merely because she is organized.

## 11.4 Choice P1 — How Player enters a real social plan

Primary axis:

```text
Does Player join the shared social life,
help inside it,
or leave Marie free to attend without him?
```

### P1A — Join with Marie

```text
Player : on vient
Player : on apporte le dessert

Pauline : Très bien.
Pauline : Je vais prévenir Bastien qu'il n'a pas besoin de nourrir huit personnes.
Pauline : Il va quand même essayer.
```

Writes:

- `pauline_legitimate_social_repetition`;
- `bastien_visible_again`;
- Player joins Marie socially;
- Pauline remains R1.

### P1B — Help before the group arrives

```text
Player : je peux passer plus tôt aider
Player : Marie nous rejoint après

Pauline : D'accord.
Pauline : Bastien te donnera une tâche trop précise.
Pauline : Je corrigerai discrètement.
```

Writes:

- `pauline_practical_access_repeated`;
- Player and Pauline share brief legitimate logistics while Bastien remains present;
- Pauline may notice Player's public/private rhythm;
- no private selection and no charged route stage.

### P1C — Decline without speaking for Marie

```text
Player : pas pour moi ce soir
Player : mais demande à Marie directement
Player : je décide pas pour elle

Pauline : C'est déjà fait.
Pauline : Elle vient.
Pauline : Je prends la réponse. Malgré l'absence de dessert.
```

Writes:

- `marie_social_independence_respected`;
- Pauline observes whether Player withdraws without controlling Marie;
- route remains R1;
- soft `pauline_reads_player_nondecision` only if this repeats an existing pattern.

## 11.5 Offline result

If the dinner occurs:

- Bastien cooks or changes the recipe;
- Marie remains socially alive;
- Pauline and Player do not conduct a secret chat while sitting at the same table;
- any later message requires physical separation and a fresh reason.

## 11.6 Exit state

- Pauline has completed the required second legitimate social cycle;
- Bastien and Marie remain active people rather than cover;
- private selectivity remains locked for at least one later compatible cycle;
- no R2, private version, or secret test exists.

---

# 12. W10 / W12 candidate — Nico quiet friendship repetition

## 12.1 Scene identity

```text
scene_id: nico_pre_shift_lunch_friendship_01
pool: ORDINARY_LIFE / ACCESS
primary relationship: Player / Nico
function: second real friendship cycle before shared gaze
route range: R1 only
intensity: ordinary
```

## 12.2 Entry conditions

Required:

- Nico ordinary friendship access established;
- at least one full cycle since the Friday saved-seat follow-up;
- Nico has a credible pre-shift lunch or quiet afternoon;
- no Nico route closure;
- no overdue Marie consequence.

Excluded:

- domestic photo request;
- body commentary about Marie, Mathilde, or Pauline;
- alibi proposal;
- shared-gaze formula;
- rivalry used as the only scene function;
- Nico treated as a route machine instead of a friend.

## 12.3 Canon line source

```text
Nico : J'ai une heure avant le service.
Nico : Et une omelette qui a besoin de soutien moral.
Nico : Tu manges ?
```

Nico's joke comes from food and service life, not legal or banking language.

## 12.4 Choice N1 — Whether Player invests in the friendship

Primary axis:

```text
Does Player show up,
make a concrete later plan,
or withdraw without pretending it is neutral?
```

### N1A — Show up

```text
Player : oui
Player : garde une chaise pour une personne cette fois

Nico : Elle est déjà méfiante.
Nico : Mais elle accepte.
```

Offline lunch:

- food, work, football failure, or the quiet after a loud service;
- no photo exchange;
- no catalogue of women;
- one moment where Nico does not need to animate the room.

After separation:

```text
Nico : C'était bien de parler d'autre chose qu'une soirée.
Nico : Ne t'habitue pas.
```

Writes:

- `nico_friendship_repeated`;
- `nico_quiet_access_seen`;
- shared-gaze engine remains locked;
- no R2.

### N1B — Concrete defer

```text
Player : pas aujourd'hui
Player : mais je te dois le déjeuner
Player : mardi ?

Nico : Mardi.
Nico : Si tu me plantes, je mange ta part.
```

Writes:

- `nico_lunch_deferred_once`;
- real friendship obligation;
- route remains R1;
- a missed promise later mutates into distance, not instant rivalry.

### N1C — Withdraw plainly

```text
Player : non
Player : je vais rester dans mon trou
Player : très bon programme

Nico : Comme tu veux.
Nico : Je garde pas une chaise à quelqu'un qui a choisi le canapé.
```

Writes:

- `nico_friendship_invite_declined`;
- no route penalty by itself;
- Nico does not immediately weaponize Marie or Mathilde;
- a later invitation needs a new reason.

## 12.5 Exit state

- Nico is proven as a friend with an ordinary quiet mode;
- the future male-gaze route has something real to corrupt or transform;
- image request, alibi, and domestic envy remain locked;
- exact engine cooldown: one full social cycle.

---

# 13. W11 / W13 — Marie concrete return

## 13.1 Scene identity

```text
scene_id: marie_concrete_return_due_01
class: consequence / couple anchor
primary relationship: Player / Marie
function: pay shared-time promise and return external attention to the couple
intensity: ordinary, warm, or lightly hurt
```

This function is mandatory after every external foreground.

It may be represented through:

- a short remote exchange if Marie and Player are apart;
- an off-phone action if they are together;
- changed next-message tone when the act is already paid.

It must not create a fake Messenger conversation between co-present partners.

## 13.2 Warm paid variant

Used when M2A occurred or M2B was paid.

```text
Marie : Le café compte.
Marie : On a même réussi à marcher sans regarder nos téléphones.

Player : performance historique

Marie : Je demande une seconde saison.
```

Writes:

- `marie_return_paid`;
- active-reconnection evidence;
- no abstract relationship speech;
- the next opportunity may proceed if no other obligation is due.

## 13.3 Unpaid or external-attention variant

```text
Marie : J'ai fait ma journée quand même.
Marie : C'était bien.
Marie : Le plus tard est toujours à toi.
```

### Choice M3 — What Player does with the return

Primary axis:

```text
Does Player perform a real act now,
commit to a bounded act later,
or stop making promises he is not paying?
```

#### M3A — Immediate act

```text
Player : je rentre
Player : je prends de quoi dîner
Player : je suis là dans trente minutes

Marie : D'accord.
Marie : Trente minutes. Là, je sais quoi attendre.
```

Writes:

- immediate couple-return obligation;
- active-reconnection evidence if paid;
- `marie_return_paid`.

#### M3B — Bounded next act

```text
Player : demain 9h30
Player : café dehors
Player : je bloque l'heure

Marie : D'accord.
Marie : À 9h31, je commande sans toi.
```

Writes:

- bounded next-morning obligation;
- no repair until paid;
- missed-opportunity mutation if broken.

#### M3C — Honest non-repair

```text
Player : je vais pas te vendre une autre promesse
Player : j'ai été ailleurs aujourd'hui

Marie : Merci pour la phrase.
Marie : Elle ne remplace pas le reste.
```

Writes:

- honest drift evidence;
- no false repair;
- couple mode remains `HABITUAL_WARMTH` in this pack;
- the next pack may evaluate the accumulated pattern.

## 13.4 Charged-route consequence variant

If Mathilde, Sandra, or Raphaëlle reaches R2:

- the Marie return is mandatory before another external foreground;
- Player is not required to confess a thought or private conversation that crossed no named couple boundary;
- he is required to decide whether he re-enters shared life concretely;
- private attention remains psychologically meaningful without becoming a hard secret.

```text
Private attention can be real
before it becomes a confession obligation.
The couple consequence is opportunity cost and changed presence.
```

---

# 14. Selection pools

## 14.1 Weekend repetition pool

Eligible:

```text
mathilde_morning_kitchen_afterglow_01
pauline_bastien_sunday_table_01
nico_pre_shift_lunch_friendship_01
sandra_ticket_ghost_hot_chocolate_01
```

Context priority:

1. due consequence or promise;
2. exact home context for Mathilde;
3. real invitation from Pauline or Nico;
4. Sandra's actual work rhythm;
5. breather if none fits.

Do not compress all four into one weekend.

## 14.2 First-workday repetition pool

Eligible:

```text
raphaelle_lunch_walk_outside_work_01
sandra_ticket_ghost_hot_chocolate_01 if not used
mathilde_morning_kitchen_afterglow_01 if a weekday morning fits
pauline_bastien_sunday_table_01 only as a fresh social-plan variant
nico_pre_shift_lunch_friendship_01 if not used
```

The first workday does not guarantee Raphaëlle foreground. It guarantees only that work and schedules remain real.

## 14.3 Ordinary fallback pool

If no foreground fits:

- Marie / Player shared-life breather;
- Mathilde practical household echo;
- Raphaëlle one-line work closure;
- Nico ordinary group logistics;
- Pauline public scheduling note;
- no notification at all.

```text
The game does not owe the player a route scene every time the clock advances.
```

---

# 15. Route-stage contract

## 15.1 Marie

Marie does not use the external R0–R5 ladder.

V0.87 may write evidence toward:

```text
ACTIVE_RECONNECTION candidate
or
PARALLEL_DRIFT candidate
```

It does not change couple mode from `HABITUAL_WARMTH` after one weekend choice.

## 15.2 Mathilde

```text
end-of-pack ceiling: R1 or R2 Charged Access
```

R2 means only:

- Player's gaze was acknowledged;
- Mathilde did not reject the acknowledgement;
- deliberate seduction remains unconfirmed;
- Marie's trust remains active;
- no image or adult permission exists.

## 15.3 Sandra

```text
end-of-pack ceiling: R1 or R2 Charged Access
```

R2 means only:

- Sandra deliberately selected a quiet private contact;
- Player read the reason without pressure;
- Sandra kept a soft limit;
- no confession, image, or affair exists.

## 15.4 Raphaëlle

```text
end-of-pack ceiling: R1 or R2 Charged Access
```

R2 means only:

- Raphaëlle chose one ordinary outside-work layer;
- Player joined without turning her into refuge;
- work and private contexts remain distinct;
- no creative account, costume, image, or attraction statement exists.

## 15.5 Pauline

```text
end-of-pack ceiling: R1
```

Required result:

- second legitimate social cycle completed or deferred;
- Bastien visible;
- Marie active;
- no private alternate;
- no secret test;
- private selectivity remains future material.

## 15.6 Nico

```text
end-of-pack ceiling: R1
```

Required result:

- second friendship cycle completed or deferred;
- quiet Nico exists;
- no photo request;
- no domestic-view exchange;
- no alibi;
- shared gaze remains future material.

---

# 16. Cooldown, missed opportunity, and mutation matrix

| Scene | Cooldown | If declined | If ignored / missed | Future mutation |
|---|---|---|---|---|
| Marie shared hour | never repeats exactly | Marie acts independently | return obligation remains | later concrete-act consequence |
| Mathilde morning gaze | two compatible foreground windows | route stays R1 | she stops asking about the moment | later work or outfit scene needs fresh intent |
| Sandra work-afterglow | two private-message windows | Sandra closes warmly | exact late window expires | colder work echo or later chosen contact |
| Raphaëlle lunch walk | one work cycle | professional frame remains | invitation expires after one defer | fresh work reason required |
| Pauline Sunday table | one social cycle | Marie may attend independently | dinner occurs without Player | later legitimate social scene, not automatic private crop |
| Nico pre-shift lunch | one social cycle | friendship remains | meal and service move on | fresh invitation; missed promise may cool trust |
| Marie return | until paid or explicitly failed | not applicable | drift evidence accumulates | next couple consequence gains priority |

No exact scene waits forever unchanged.

No refusal is bypassed by repeating the same wording.

---

# 17. Knowledge and trace contract

## 17.1 No new image inventory

V0.87 creates no required image or visual asset.

Existing traces remain in their original frame:

| Trace | Allowed read | Forbidden mutation in V0.87 |
|---|---|---|
| `j1_sandra_lunch_memory_soft` | prior shared memory | new crop, sexual proof, forwarding |
| `mathilde_arrival_room_01` | household arrival history | sexual recrop, Nico circulation |
| `marie_laverriere_setup_01` | event participation history | private jealousy proof |
| `laverriere_public_group_photo_set_01` | authorized public/social trace | Pauline private alternate, Nico forwarding game |

## 17.2 Private does not equal secret

These facts may remain ordinary private knowledge:

- Mathilde noticed Player's gaze;
- Sandra selected Player for a late quiet conversation;
- Raphaëlle and Player took a lunch walk;
- Pauline or Nico sent an individual practical invitation.

They do not automatically create:

- a hard secret;
- an alibi;
- a discovery scene;
- a confession obligation.

A hard secret begins only when a later scene creates a named deception, hidden boundary crossing, or evidence-control obligation.

## 17.3 Knowledge limits

- Marie does not know private threads by default.
- Mathilde does not know Sandra, Pauline, Raphaëlle, or Nico route states.
- Sandra does not know the household gaze.
- Pauline is not omniscient.
- Nico does not know Mathilde's domestic version unless Player or Mathilde legitimately tells or shows him.
- Raphaëlle knows Player is with Marie, not the entire couple state.
- Player may misread every character.

---

# 18. Foreground and echo budget

Per authored window:

```text
1 foreground
0–2 echoes
```

Allowed echoes:

- Marie practical or social echo;
- Mathilde household joke;
- Sandra delayed work line;
- Pauline public-plan confirmation;
- Nico ordinary logistics;
- Raphaëlle work closure.

Echoes may not:

- create R2;
- create adult consent;
- reveal a private image;
- open Pauline's compartment;
- open Nico's gaze exchange;
- replace Marie's mandatory return;
- hide a major choice.

---

# 19. Replay and exit guarantees

A single playthrough should contain:

```text
fixed Marie foreground
+ zero to two selected external foregrounds
+ mandatory couple returns
+ ordinary echoes from zero to three other characters
```

Replay changes:

- who receives the first repetition ticket;
- whether one route reaches R2;
- whether Marie's shared hour is paid;
- whether a social invitation is accepted;
- which opportunities defer or mutate;
- whether the weekend feels joined or parallel.

Replay does not change:

- character identity;
- voice ownership;
- image consent rules;
- Bastien, Jeff, and Marie's humanity;
- relationship frame at pack start;
- maximum one charged owner;
- adult-content exclusion.

At pack end:

```text
opening_band_complete = true
first_repetition_wave_complete = true

couple mode = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE

active-reconnection evidence = possible
parallel-drift evidence = possible

external foreground repetitions seen = 0–2
charged_access_owner = none | mathilde | sandra | raphaelle

Pauline = R1
Nico = R1
Mathilde = R1 or R2
Sandra = R1 or R2
Raphaëlle = R1 or R2

hard secrets = none
adult frames = none
adult images = none
routes R3+ = none
```

At least one Marie/shared-life return must be resolved after the last external foreground.

No new runtime scene may begin from this exit state until a V0.88 integration plan maps the approved concepts onto the existing state model.

---

# 20. Explicit exclusions

Reject any V0.87 implementation or rewrite that adds:

- all five external foregrounds in one run;
- more than two external foreground tickets;
- more than one route reaching R2;
- a private Pauline alternate;
- a Nico request for Marie or Mathilde photos;
- an alibi or cover;
- a new Sandra image;
- Mathilde choosing clothing for Player;
- Raphaëlle revealing her private creative account;
- sexual language presented as an adult frame;
- relationship-frame change;
- a character-name route menu;
- fake long chats between co-present characters;
- visible explanatory `Moments hors ligne` cards;
- old blank time-of-day interstitials;
- legal wordplay copied from Mathilde into other voices;
- a runtime refactor bundled into this documentation pass.

---

# 21. Final rule

```text
The opening proved access.
V0.87 proves repetition.

One repeated look,
one chosen late message,
one walk outside work,
one ordinary dinner,
or one quiet lunch
can change meaning.

Each person must still sound like themselves.
It does not yet change permission.
```
