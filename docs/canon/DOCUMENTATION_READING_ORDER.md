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
5. `docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md` for sexual tension, explicit escalation, adult-photo logic, tromperie, NTR/cuckold, sharing, trio/quatuor, or dark-route planning
6. character-specific deprecation maps when present:
   - `docs/canon/characters/MATHILDE_CANON_DEPRECATION_MAP.md`
   - `docs/canon/characters/PAULINE_CANON_DEPRECATION_MAP.md`
7. the validated day source pack
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
- solo apartment and edited domestic life;
- eight-year friendship history with Marie;
- family and community background;
- parish choir as genuine ordinary-life anchor;
- previous relationship and private-authorship wound;
- controlled, fitted clothing and body-image logic;
- recurring objects and social anchors;
- desire to be trusted after being seen;
- image selection and reciprocal-risk NSFW engine;
- modular scene pools;
- route consequences for Marie's friendship and the social group.

### Concrete-profile expansion still needed

- Raphaëlle
- Nico

Their current files remain usable calibration canon, but major biography should not be invented as hard truth without a profile pass.

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

For Pauline specifically, current canon overrides:

```text
omniscient social/photo-controller framing
one-way exposure without reciprocal risk
constant halo / church joke
religious-repression or virgin-corruption framing
playable choir voice-message assumptions
fixed old J4 invitation / J5 photo / later route order
early route lock
consequence-free betrayal of Marie
automatic group-sex organizer assumptions
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

Any J2+ narrative JSON must be reviewed against current character canon and the current day source pack.

For Mathilde runtime:

- keep J1 indirect;
- do not use old J7 as a fixed target;
- preserve ordinary sensuality vs deliberate sexual intent;
- keep Marie's trust and family context active;
- avoid early route locks.

For Pauline runtime:

- keep her absent from current J1;
- do not assume old J4/J5/later scenes define her first entry or route order;
- begin from a legitimate social or practical window;
- distinguish public image competence from privately selected intent;
- require reciprocal risk before major adult escalation;
- keep Marie's friendship active as trust and consequence;
- never promise a playable choir voice message;
- avoid early route locks.

## 7. Adult-tone rule

`Réseau Intime` may become pornographic when routes escalate.

Character depth exists to strengthen adult scenes, not to remove them.

Use:

```text
docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md
```

This governs:

- direct / crude escalation;
- adult photo logic;
- cheating;
- trio / quatuor;
- NTR / cuckold / sharing;
- consent, agency, risk, and consequences;
- character-specific pornographic engines.

For Pauline specifically:

```text
public trust
-> legitimate private channel
-> selected private version
-> reciprocal risk
-> acknowledged desire
-> adult decision and consequence
```

Loss of polish, timing, or emotional control is never loss of consent.

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
- add a deprecation map when old material could still mislead implementation;
- do not leave important decisions stranded in conversation or addenda.
