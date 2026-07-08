# V0.60 — J1 Reworked Script Plan

> Documentation-only script plan.  
> Builds on the reworked character profiles for Marie, Sandra, and Player.  
> Refines the V0.59 macro intent for Jour 1 into a concrete writing plan.  
> No runtime, narrative JSON, tests, assets, or playable content are changed.

## 1. Purpose

V0.60 turns the J1 macro plan into a detailed script plan.

The goal is not to write the final JSON yet.

The goal is to define:

- J1 emotional structure;
- active conversations;
- scene order;
- concrete anchors;
- visual / trace functions;
- choices and consequences;
- tone rules;
- anti-patterns;
- acceptance criteria for later playable writing.

J1 must introduce the core of the game without overloading the player.

```text
J1 is not the day where routes begin loudly.
J1 is the day where the couple breathes, and an old trace quietly reopens.
```

---

## 2. Source hierarchy

For J1, use this source hierarchy:

1. `docs/Marie_Concrete_Profile_V2.md`
2. `docs/Marie_Concrete_Profile_V2_Details_Addendum.md`
3. `docs/Sandra_Concrete_Profile_V2.md`
4. `docs/Sandra_Concrete_Profile_V2_Details_Addendum.md`
5. `docs/Sandra_Concrete_Profile_V2_Final_Choices_Addendum.md`
6. `docs/Player_Concrete_Profile_V2.md`
7. `docs/Character_Playable_Voice_Cards.md`
8. `docs/Character_Voice_Post_Etalons_Addendum.md`
9. `docs/V0_59_Reworked_J1_J9_Beat_Plan.md` only as macro context.

Important: V0.59 is useful for principles, but it explicitly says day-by-day details are superseded by later source packs. V0.60 becomes the new J1 writing source.

---

## 3. J1 locked constraints

J1 must keep a narrow focus.

### Active characters

- Marie
- Sandra
- Player

### Indirect only

- Mathilde may be mentioned indirectly through Marie.

### Absent from runtime J1

- Nico
- Pauline
- Raphaëlle
- group conversations
- panel scenes
- dark routes
- adult visual escalation
- strong route lock

### Structural rule

J1 has two main threads:

1. Marie / Player — the living couple.
2. Sandra / Player — the old trace returning.

No third active conversation should compete with these two.

---

## 4. J1 narrative intention

J1 must establish three things:

1. **Marie and Player still have a real couple.**
   They joke, share logistics, live together, and still have warmth.

2. **Player is already slightly absent.**
   Not cruel. Not checked out. But passive, late, distracted, too much observer.

3. **Sandra reappears through a trace, not a seduction move.**
   She does not arrive as a rival. She arrives as an old connection that Player can still read.

J1 should leave the player with this feeling:

```text
Nothing dramatic has happened yet.
But Player has already been asked to choose where his attention goes.
```

---

## 5. Tone target

J1 must feel like a real first day in a phone narrative.

Tone:

- grounded;
- intimate;
- readable;
- lightly playful;
- slightly melancholic underneath;
- no melodrama;
- no immediate lust escalation;
- no excessive cleverness.

Messenger rhythm:

- short to medium messages;
- ordinary replies allowed;
- imperfect timing;
- small jokes;
- not every line is a punchline;
- silences and delays matter.

---

## 6. J1 high-level structure

Recommended J1 flow:

1. **Marie morning / day-life opening**
   Couple logistics, warmth, practical life.

2. **Player micro-choice: participate or answer flat**
   Soft establishes Player's tendency.

3. **Marie second beat: invitation to shared life**
   Dinner, walk, couch, or small plan.

4. **Sandra re-entry through trace**
   Old photo / shift trace / book trace / terrace memory.

5. **Player choice: read Sandra or stay guarded**
   Opens emotional color without making route active.

6. **Marie evening beat**
   Tests whether Player is present after Sandra interruption.

7. **End-of-day state**
   Marie still central; Sandra now quietly present; Player's attention split but not yet exposed.

---

## 7. Marie thread — function

Marie is the J1 anchor.

She must show why Player's life with her matters.

Do not begin Marie as suspicious, jealous, or already wounded.

She should begin alive:

- teasing;
- practical;
- warm;
- slightly impatient;
- trying to make the evening real.

### Marie J1 anchors

Choose one or two, not all:

- tomatoes / bread / dinner;
- couch evening;
- after-dinner walk;
- La Verrière small problem;
- entrance mirror / earrings / shoes;
- Mathilde mentioned as family context;
- household logistics.

### Recommended primary anchor

For J1, use **dinner logistics + evening presence**.

Why:

- it is ordinary;
- it makes the couple alive;
- it gives Player something practical to do;
- it allows a soft failure without drama;
- it contrasts well with Sandra's trace.

Example tone:

```text
Marie : On a des tomates, du fromage, et aucun plan cohérent.
Marie : Donc je propose qu'on appelle ça un dîner.

Player : il manque du pain

Marie : Exact.
Marie : Voilà pourquoi tu es utile quand tu participes.
```

---

## 8. Marie thread — beats

### Beat M1 — Life is still warm

Marie opens with something ordinary and vivid.

Possible triggers:

- groceries;
- dinner;
- small La Verrière frustration;
- invitation to walk later;
- light teasing about Player being useful if he participates.

Goal:

```text
The player must feel Marie is not a problem.
She is a life.
```

### Beat M2 — Participation test

Marie asks for a small participation:

- buy bread;
- choose dinner;
- come walk;
- help with a tiny task;
- answer with energy instead of a flat message.

Player choices should color him:

- present / warm;
- joking but present;
- flat / delayed;
- evasive.

No route lock.

### Beat M3 — First micro-absence

If Player answers too flat or late, Marie notices lightly.

Not a fight.

A small line:

```text
Marie : Tu es là ou tu fais décor réaliste ?
```

or:

```text
Marie : Ne me réponds pas une phrase molle.
Marie : Pas dès J1, s'il te plaît.
```

This is not a final line for runtime, but the function is correct.

### Beat M4 — Evening presence check

After Sandra has re-entered, Marie should come back with a concrete, ordinary request.

Possible:

- dinner status;
- couch plan;
- walk;
- she is putting shoes near the door;
- she wants him to join the evening.

Goal:

```text
The player feels the phone split: Sandra asks to be read; Marie asks to be joined.
```

### Beat M5 — End state

Marie should end J1:

- still warm;
- not broken;
- aware enough to notice Player's presence quality;
- not yet in crisis;
- central.

Possible end tone:

```text
Marie : Message reçu.
Marie : Tomates à prouver.
```

Use `message reçu` carefully; it is strong and should not feel like a conflict if used J1.

---

## 9. Sandra thread — function

Sandra re-enters through a trace.

She must not arrive as a direct temptation.

She is not trying to steal Player.

She sends something defensible, concrete, and lightly intimate because Player is one of the few people who can understand the hidden layer.

### Sandra J1 anchors

Choose one:

- old photo from a previous lunch / terrace;
- end of shift / SentryCore trace;
- paper book trace;
- photo printed / scrapbooking trace;
- family house memory, only if not too heavy.

### Recommended primary anchor

For J1, use **old photo + concrete work/life pretext**.

Best version:

Sandra has been sorting / printing photos after a shift, finds a slightly blurry photo linked to their last lunch or an old terrace, and sends it because it made her smile.

Why:

- connects to established past;
- uses Sandra's trace logic;
- allows photo without seduction;
- opens memory and missing feeling;
- lets Player notice too precisely.

---

## 10. Sandra thread — beats

### Beat S1 — Defensible re-entry

Sandra sends a trace with a small excuse.

Possible setup:

```text
Sandra : J'ai retrouvé une photo.
Sandra : Elle est floue.
Sandra : Donc assez fidèle à nous, finalement 🙂
```

Or more V2 concrete:

```text
Sandra : J'ai imprimé trois photos après mon shift.
Sandra : Deux sont ratées.
Sandra : Évidemment, c'est celle de notre dernier déjeuner que je préfère.
```

### Beat S2 — Player reads the trace

Player can answer:

- warm and safe;
- lightly teasing;
- too precise;
- evasive;
- delayed.

Good Player tone:

```text
Player : elle est floue
Player : mais je me souviens très bien de ton sourire
Player : donc techniquement la photo échoue à cacher le sujet
```

This is strong; use a simpler runtime version if needed.

### Beat S3 — Sandra deflects

Sandra should respond with `haha`, false reasonableness, or a soft limit.

```text
Sandra : Haha.
Sandra : Tu es très pénible quand tu regardes correctement.
```

or:

```text
Sandra : Ne donne pas trop d'importance à cette phrase.
```

### Beat S4 — Hidden lack

The exchange should reveal a small missing feeling, not a declaration.

Sandra may suggest:

- their last lunch felt good;
- she had not realized she missed that ease;
- she is in a quiet hour after a shift;
- she should sleep but is writing instead.

No direct confession.

### Beat S5 — Soft boundary

End Sandra J1 with a soft boundary:

- she says she should sleep;
- she says they will not make it important;
- she changes topic;
- she thanks him without saying too much.

Possible:

```text
Sandra : Je vais dormir avant de devenir moins raisonnable que prévu.
Sandra : Bonne nuit, mon cher Player.
```

Use `mon cher Player` only if the scene earned it.

---

## 11. Player function on J1

Player must be playable, not perfect.

J1 should allow Player to be:

- present with Marie;
- gently curious with Sandra;
- delayed;
- evasive;
- too precise;
- banal;
- honest in small flashes.

J1 should not make Player:

- manipulative;
- already cheating;
- a perfect seducer;
- a pure victim;
- a blank camera.

### Player J1 conflict

His conflict is attention.

Not yet sex.

Not yet betrayal.

Not yet secrecy as a strategy.

```text
Player is not choosing a woman on J1.
He is choosing what kind of attention he gives.
```

---

## 12. Choice design

J1 choices should be low-intensity but meaningful.

They should color future routes without locking them.

### Marie choice types

- **Participate**: warm, concrete, helps with dinner / walk.
- **Joke but join**: Player is awkward but present.
- **Flat answer**: Marie notices mild absence.
- **Delay / phone drift**: colors slight distance.

### Sandra choice types

- **Safe warmth**: acknowledges memory without overstepping.
- **Precise observation**: validates Sandra's hidden self.
- **Playful deflection**: keeps it light.
- **Distance**: keeps Sandra at the edge.

### No J1 choice should do this

- lock Sandra route;
- break Marie trust;
- introduce explicit sexuality;
- create a hard lie;
- launch Nico / Pauline / Raphaëlle;
- produce irreversible proof.

---

## 13. Visual / trace plan

J1 may use one visual or trace maximum from Sandra, and maybe one light Marie trace.

Do not overload.

### Sandra visual

Recommended: **old blurry lunch / terrace photo**.

Function:

- reopens a past link;
- is defensible;
- can be about memory rather than seduction;
- lets Player notice her, not only the scene.

Possible visual description:

```text
Photo slightly blurry, terrace table, two cups or plates, Sandra partly visible or implied, warm ordinary light, not erotic.
```

Important: no adult content, no explicit body focus, no voyeurism.

### Marie trace

Optional, not required.

If used, keep it domestic:

- tomatoes / bread;
- shoes near door;
- dinner photo;
- small mirror edge before a casual walk.

Function:

- invites Player to join daily life;
- not a jealousy test yet.

---

## 14. Mathilde J1 role

Mathilde may be mentioned indirectly by Marie.

Possible:

- Marie says Mathilde might pass another day;
- Mathilde sent a chaotic message to Marie;
- family joke;
- Marie mentions her as someone who will probably exaggerate something later.

No Mathilde thread.

No Mathilde photo.

No Mathilde active tension.

Function:

```text
Mathilde exists in Marie's family world, but does not compete with Marie/Sandra on J1.
```

---

## 15. Suggested J1 scene list

### Scene 1 — Marie / day opening

Thread: Marie / Player.

Anchor: dinner logistics or La Verrière + dinner.

Function:

- show Marie alive;
- show couple warmth;
- ask Player to participate.

Example beat:

```text
Marie has had a small La Verrière annoyance and turns it into dinner humor.
She asks Player to pick up bread or help make the evening not sad.
```

### Scene 2 — Marie / participation micro-choice

Thread: Marie / Player.

Function:

- first player color;
- warm participation vs flat passivity.

Possible outcome flags later, not runtime yet:

- `j1_marie_present`
- `j1_marie_flat`
- `j1_marie_delayed`

Names are illustrative only, not implementation decisions.

### Scene 3 — Sandra / trace re-entry

Thread: Sandra / Player.

Anchor: old blurry photo found after shift / printing.

Function:

- reintroduce Sandra;
- give Player a trace to read;
- reopen old complicity.

### Scene 4 — Sandra / reading micro-choice

Thread: Sandra / Player.

Function:

- safe warmth vs precise observation vs distance;
- Sandra responds with `haha` / soft limit.

Possible outcome colors later:

- `j1_sandra_safe`
- `j1_sandra_precise`
- `j1_sandra_distance`

Illustrative only.

### Scene 5 — Marie / evening return

Thread: Marie / Player.

Anchor: dinner / walk / couch.

Function:

- Marie reclaims center;
- Player must return to shared life;
- contrast Sandra trace with Marie living presence.

### Scene 6 — End state

J1 ends with:

- Marie still central and warm, lightly alert;
- Sandra present at distance, not demanding;
- Player colored by attention choices;
- no route lock;
- no hard betrayal.

---

## 16. Conversation length target

J1 should stay digestible.

Recommended:

- Marie thread: 60–90 messages total, depending on choices.
- Sandra thread: 45–70 messages total, depending on choices.
- Total J1 runtime messages: approximately 110–160.

Do not repeat the earlier goal of making Sandra Day 1 alone 150–200 messages.

That was useful as a benchmark scene exercise, not ideal for a playable J1 with Marie also active.

J1 should feel focused.

---

## 17. Writing examples by function

These are not final script, only tone samples.

### Marie ordinary warmth

```text
Marie : On a des tomates, du fromage, et aucun plan cohérent.
Marie : Je propose qu'on appelle ça un dîner.

Player : il manque du pain

Marie : Voilà.
Marie : C'est dans ces moments-là que ton cerveau devient utile.
```

### Marie soft absence

```text
Marie : Tu es là ou tu fais décor réaliste ?

Player : je suis là

Marie : Phrase de décor réaliste.
Marie : Améliore.
```

### Sandra trace

```text
Sandra : J'ai retrouvé une photo de notre déjeuner.
Sandra : Elle est floue.
Sandra : Donc assez fidèle à ma capacité à assumer les souvenirs.
```

### Sandra hidden approval

```text
Player : on voit mal la photo
Player : mais je me souviens que tu souriais plus que prévu

Sandra : Haha.
Sandra : Tu as une mémoire pénible.
```

### Player late honesty

```text
Player : j'ai attendu d'avoir une bonne réponse
Player : donc j'ai surtout attendu
Player : mauvaise méthode
```

---

## 18. Anti-patterns

Avoid:

- making Sandra too available too fast;
- making Marie jealous on J1;
- making Player already dishonest in a heavy way;
- overusing `message reçu`;
- overusing `mon cher Player`;
- using all Sandra motifs at once: Jeff + SentryCore + plaid + book + family house;
- using all Marie motifs at once: La Verrière + dress + Nico + Pauline + family;
- making every line witty;
- making every choice sound like a route label;
- making J1 feel like a trailer for all characters.

J1 must not show the whole game.

It must make the player want to open J2.

---

## 19. Acceptance criteria for later script writing

A J1 script draft is acceptable if:

- Marie feels alive before she feels hurt;
- Player has at least one concrete chance to participate in the couple;
- Sandra re-enters through a trace, not seduction;
- Mathilde is indirect only;
- no Nico / Pauline / Raphaëlle active thread appears;
- no strong route lock appears;
- no explicit adult escalation appears;
- Player choices color attention, not definitive allegiance;
- the final state preserves both Marie's centrality and Sandra's quiet return;
- at least one scene would still work if no romance route existed, because the daily life feels real.

---

## 20. Implementation guidance for Hermes later

When this becomes runtime work:

- do not modify runtime systems unless necessary;
- do not add new mechanics for V0.60;
- add or rewrite J1 conversation data only after script validation;
- keep active J1 threads limited to Marie and Sandra;
- ensure pending/unread behavior stays consistent with existing message runtime;
- keep visuals as placeholders if needed;
- no asset dependency should block script integration;
- preserve validation suite expectations.

Suggested later steps:

1. Draft J1 full text in plain script form.
2. Run anti-pattern pass.
3. Validate with user.
4. Convert into JSON/runtime with Hermes.
5. Run existing data/runtime validations.

---

## 21. Final J1 rule

```text
Marie is the life Player must join.
Sandra is the trace Player can read.
Player is not choosing a route yet.
He is revealing how he pays attention.
```
