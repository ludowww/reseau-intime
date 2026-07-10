# Documentation Reading Order — Canon Current

> Canon entry point.  
> Use this file before reading older narrative, character, route, or runtime-planning documentation.  
> No runtime, JSON, tests, assets, or playable content are changed here.

## 1. Core rules

```text
Write from full canon, not summaries.
Write adult escalation from NSFW route canon, not implied tone.
Use three choices by default; four or more require explicit justification.
Existing runtime is not automatic narrative canon.
```

## 2. Current canon entry points

Read in this order:

1. `docs/canon/NARRATIVE_CANON_STATUS.md`
2. `docs/canon/CHOICE_DESIGN_CANON.md`
3. `docs/canon/characters/CHARACTER_CANON_INDEX.md`
4. the relevant full character canon file:
   - `docs/canon/characters/MARIE_CANON_FULL.md`
   - `docs/canon/characters/SANDRA_CANON_FULL.md`
   - `docs/canon/characters/PLAYER_CANON_FULL.md`
   - `docs/canon/characters/MATHILDE_CANON_FULL.md`
   - `docs/canon/characters/PAULINE_CANON_FULL.md`
   - `docs/canon/characters/RAPHAELLE_CANON_FULL.md`
   - `docs/canon/characters/NICO_CANON_FULL.md`
5. `docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md` for sexual tension, explicit escalation, adult-photo or social-trace logic, tromperie, NTR/cuckold, sharing, trio/quatuor, or dark-route planning
6. character-specific deprecation maps when present:
   - `docs/canon/characters/MATHILDE_CANON_DEPRECATION_MAP.md`
   - `docs/canon/characters/PAULINE_CANON_DEPRECATION_MAP.md`
   - `docs/canon/characters/NICO_CANON_DEPRECATION_MAP.md`
7. the validated day source pack or modular-window source
8. for J1 exact text: `docs/V0_69_J1_Canon_Text_Review_And_Final_Line_Source.md`
9. voice / intensity bibles only as support material
10. older arcs, spine, proof maps, route plans, or runtime only after explicit cross-checking

`docs/canon/CHARACTERS_CANON_CURRENT.md` is a doorway only.

## 3. Character-profile status

### Full concrete canon ready

- Marie
- Sandra
- Player
- Mathilde
- Pauline
- Nico

Mathilde's full canon includes:

- age;
- exact job direction;
- temporary living arrangement;
- family history with Marie;
- social anchors;
- recurring objects;
- everyday sensual clothing canon;
- wound and desire;
- modular scenes;
- NSFW progression and route consequences.

Pauline's full canon includes:

- age and explicit adult status;
- exact work as a retail client adviser in a local mutual bank;
- current five-year relationship and shared home with Bastien;
- a prior physical infidelity committed during that current relationship;
- Bastien's ignorance and Marie's partial knowledge;
- double life / compartmentalization as primary dramatic function;
- eight-year friendship history with Marie, real but breakable;
- family and community background;
- parish choir as genuine ordinary-life anchor;
- controlled, fitted clothing and double-addressed image logic;
- recurring objects and social anchors;
- desires she can express sexually but struggles to integrate morally;
- proof, alibi, deletion, and reciprocal-risk NSFW engine;
- modular scene pools;
- route consequences for Marie, Bastien, Player, and both couples.

Nico's full canon includes:

- age 34 and explicit adult status;
- exact work as floor manager and private-event coordinator at `Le Sillage`;
- a credible late-working social environment;
- solo apartment and quiet after-closing life;
- upbringing above his parents' café-brasserie;
- younger sister Camille;
- former four-year relationship with Clara;
- one prior consensual-third adult experience with imperfect aftermath;
- real friendship with Player;
- genuine attraction and established social chemistry with Marie;
- physical appearance, clothing, objects, work habits, family, and ordinary-life material;
- desire to be chosen after the room is empty;
- wound around being wanted for an effect rather than as a person;
- social-mirror contradiction: he reveals real desire while sometimes creating the conditions that intensify it;
- modular friend, rival, hidden-affair, sharing, cuckold, trio, withdrawal, and dark-opportunist routes;
- explicit distinction between betrayal-NTR and negotiated cuckold / sharing;
- no automatic direct Nico / Player sexual route.

### Concrete-profile expansion still needed

- Raphaëlle

Her current file remains usable calibration canon, but major biography should not be invented as hard truth without a profile pass.

## 4. Rule for old files

Older files are not deleted automatically, but they do not act as direct truth when they contradict current canon.

This applies especially to:

- old J1-J10 spine material;
- old character arcs;
- old proof / secret maps;
- old route-reachability assumptions;
- runtime JSON produced before character refoundation;
- isolated addenda already consolidated into full canon.

For Mathilde specifically, current canon overrides:

```text
old photo/canapé foundation
sport/racket identity
mathilde_seed as an active J1 route
long grey sweater as recurring signature
old J7 runtime as narrative truth
automatic Marie–Mathilde sexual group assumptions
```

For Pauline specifically, current canon preserves the old identity pillar but not the old schedule.

Current canon restores:

```text
current relationship with Bastien
prior unconfessed infidelity during that relationship
Marie knowing part of the truth
double life / compartmentalization
proof and control grounded in lived betrayal
```

Current canon overrides or suspends:

```text
Pauline as single by default
ex-boyfriend-only wound
indestructible friendship with Marie
omniscient social/photo-controller framing
one-way exposure without reciprocal risk
constant halo / church joke
religious-repression or virgin-corruption framing
playable choir voice-message assumptions
fixed old J4 invitation / J5 photo / later route order
early route lock
consequence-free betrayal of Marie or Bastien
automatic group-sex or consensual cuckold assumptions
```

For Nico specifically, current canon also preserves identity pillars without preserving old chronology.

Current canon retains:

```text
genuine attraction to Marie
social charm
real but ambiguous friendship with Player
Marie may consciously use Nico's gaze on some routes
mixed helpfulness and self-interest
possibility of hidden betrayal, NTR, sharing, cuckold, and trio routes
```

Current canon overrides or suspends:

```text
flat rival
villain who steals Marie
automatic Don Juan attracted to everyone
neutral mirror with no self-interest
false friendship as his only strategy
automatic manipulation of Marie
Nico as only a revenge lever
permanent crude commentary
fantasy-professor role
automatic dominant role
Player reduced to passive victim
Marie without agency
hidden affair called consensual cuckold
direct Nico / Player sexual contact inferred from trio proximity
fixed old J6 / J7+ revenge chronology
```

## 5. Choice rule

Default:

```text
3 choices per runtime node
```

Four or more choices are exceptional and require written justification.

Draft variants must be collapsed before runtime integration.

## 6. Runtime rule

```text
runtime existing != narrative canon
```

Any J2+ narrative JSON must be reviewed against current character canon and the current day or modular-window source.

For Mathilde runtime:

- keep J1 indirect;
- do not use old J7 as a fixed target;
- preserve ordinary sensuality vs deliberate sexual intent;
- keep Marie's trust and family context active;
- avoid early route locks.

For Pauline runtime:

- keep her absent from current J1;
- preserve the background truth that she is with Bastien and has already cheated on him;
- do not assume the old J4/J5/later scenes define her first entry or route order;
- begin from a legitimate social or practical window;
- make her temptation about non-decision and compartmentalization, not immediate romance;
- keep Bastien human and present even when offscreen;
- distinguish public image competence from privately selected intent;
- require reciprocal risk before major adult escalation;
- keep Marie's partial knowledge and breakable friendship active;
- never promise a playable choir voice message;
- avoid early route locks;
- distinguish hidden cheating from later informed cuckold, sharing, or open-couple consent.

For Nico runtime:

- keep him absent from current J1;
- establish an ordinary social person before making him a jealousy or adult mechanism;
- do not assume old J6/J7+ revenge beats define his first entry or route order;
- preserve genuine attraction to Marie before route escalation;
- preserve real friendship with Player rather than making every helpful sentence a trap;
- use `Le Sillage`, work, family, and quiet-life material outside sexual scenes;
- keep Marie as direct choice subject rather than a prize;
- keep Player active through boundary, jealousy, fantasy, consent, or refusal choices;
- do not treat Player's jealousy or arousal as consent;
- do not use Player's permission as Marie's permission;
- distinguish hidden Marie / Nico betrayal from consensual cuckold / sharing;
- let Nico refuse being used only as a jealousy or fantasy instrument;
- do not assume direct Nico / Player sexual contact;
- avoid early group-route locks;
- keep max three choices unless a written exception is justified.

## 7. Adult-tone rule

`Réseau Intime` may become pornographic when routes escalate.

Character depth exists to strengthen adult scenes, not to remove them.

Use:

```text
docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md
```

This governs:

- direct / crude escalation;
- adult photo and social-trace logic;
- cheating;
- trio / quatuor;
- NTR / cuckold / sharing;
- consent, agency, risk, and consequences;
- character-specific pornographic engines.

For Pauline specifically:

```text
current couple and prior hidden infidelity
-> recognition of Player's denied desire
-> legitimate private channel
-> selected double-addressed version
-> plausible deniability
-> reciprocal proof
-> acknowledged double life
-> adult decision and consequence
```

Loss of polish, timing, or emotional control is never loss of consent.

Bastien's ignorance is never consent.

Marie's partial knowledge is never permission.

A later negotiated open, sharing, cuckold, trio, or group route cannot retroactively erase earlier betrayal.

For Nico specifically:

```text
ordinary social friendship
-> genuine attraction to Marie becomes visible
-> Player's jealousy or arousal is named
-> Nico admits he is not neutral
-> Marie chooses whether to answer
-> route separates boundary, betrayal, rivalry, or negotiation
-> adult decision and consequence
```

A direct compliment, social story, look, or Player reaction alone is not consent or route activation.

Hidden Marie / Nico affair:

```text
betrayal / possible NTR from Player's perspective
```

Explicit Player + Marie + Nico agreement:

```text
consensual sharing / cuckold / trio frame
```

Player's arousal is not consent.

Player cannot consent for Marie.

Marie cannot consent for Player to acts that directly involve him.

Trio proximity does not automatically establish direct Nico / Player contact.

## 8. Sandra terminology

Do not use English `shift` in current writing.

Use:

```text
horaires décalés
poste du matin
poste du soir
poste de nuit
week-end travaillé
fin de poste
```

This is life color, not a gameplay system.

## 9. Maintenance rule

When a character profile, day source pack, route rule, choice rule, or narrative audit changes the story:

- update the relevant full canon file first;
- update the character index;
- update the narrative status if runtime / day interpretation changes;
- add or update a deprecation map when old material could still mislead implementation;
- update `NSFW_CHARACTER_ROUTE_CANON.md` when an adult engine, consent rule, route family, image rule, social-trace rule, or dark-route distinction changes;
- update `CHARACTERS_CANON_CURRENT.md`, the version report, and the PR description so all general entry points describe the final corrected version;
- do not leave important decisions stranded in conversation or addenda.

```text
Character correction complete
= full file
+ deprecation map
+ general canon
+ version report
+ implementation guidance aligned.
```
