# Character Canon Index — Current

> Canon index for character writing after V0.86 opening completion.  
> Full principal-character files are the first source for scenes.  
> Supporting characters use the supporting-character policy and the full canon of the principal character whose life they anchor.

## 1. Core rule

```text
Write principal characters from their full canon files.
Write adult escalation from the global NSFW canon.
Do not confuse a later character engine with its current runtime activation.
Do not promote a supporting character into an independent route by accident.
```

## 2. Principal characters — full canon complete

| Character | Full canon file | Current status |
|---|---|---|
| Marie | `docs/canon/characters/MARIE_CANON_FULL.md` | Full concrete current canon |
| Sandra | `docs/canon/characters/SANDRA_CANON_FULL.md` | Full concrete current canon |
| Player | `docs/canon/characters/PLAYER_CANON_FULL.md` | Full concrete current canon |
| Mathilde | `docs/canon/characters/MATHILDE_CANON_FULL.md` | Full concrete + NSFW current canon |
| Pauline | `docs/canon/characters/PAULINE_CANON_FULL.md` | Full concrete + NSFW double-life canon |
| Nico | `docs/canon/characters/NICO_CANON_FULL.md` | Full concrete + NSFW social-mirror, domestic-access, voyeur and image-exchange canon |
| Raphaëlle | `docs/canon/characters/RAPHAELLE_CANON_FULL.md` | Full concrete + NSFW chosen-transformation and clear-secret canon |

All seven principal characters are fully concrete.

No separate Nico correction file is required. His validated Mathilde attraction, domestic-access envy, voyeurism, image-consent matrix, photo exchange, and mutual-cover material remain consolidated directly into `NICO_CANON_FULL.md` and the global NSFW canon.

## 3. Current implementation ceiling

V0.86 completes the first ordinary-access band.

```text
Marie/Player = HABITUAL_WARMTH
Sandra = soft trace / ordinary continuity
Mathilde = R1 Ordinary Access
Raphaëlle = R1 Ordinary Work Access
Pauline = R1 Legitimate Social Access
Nico = R1 Ordinary Friendship / Social Access
opening_band_complete = true
```

Important distinction:

```text
A later engine existing in full canon
is not proof that it is active in runtime.
```

Currently inactive examples:

- Mathilde deliberate intention;
- Pauline private compartment or double-addressed image;
- Nico domestic envy, shared gaze, image request, or cover arrangement;
- Raphaëlle private creative frame;
- any route R2+;
- any adult consent frame.

## 4. Global adult canon

```text
docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md
```

Read it for:

- sexual tension;
- explicit escalation;
- adult image and message logic;
- roleplay and transformation;
- cheating;
- voyeurism;
- NTR / cuckold;
- sharing;
- open arrangements;
- trio / quatuor / group content;
- consent, risk, aftermath, and dark-route distinctions.

## 5. Character deprecation maps

```text
docs/canon/characters/MATHILDE_CANON_DEPRECATION_MAP.md
docs/canon/characters/PAULINE_CANON_DEPRECATION_MAP.md
docs/canon/characters/NICO_CANON_DEPRECATION_MAP.md
docs/canon/characters/RAPHAELLE_CANON_DEPRECATION_MAP.md
```

Use a deprecation map when older runtime or documentation may still suggest an obsolete identity, scene order, route state, image rule, or consent frame.

## 6. Supporting characters

Official policy:

```text
docs/canon/SUPPORTING_CHARACTER_CANON_POLICY.md
```

Supporting characters are not incomplete principal characters.

They need enough concrete truth to:

- make the world credible;
- preserve the principal character's history and consequences;
- avoid caricature;
- support modular scenes;
- remain human when affected by betrayal or adult routes.

They do not automatically need a standalone full-canon file.

### Jeff

Jeff remains a supporting character anchored to Sandra.

First source:

```text
docs/canon/characters/SANDRA_CANON_FULL.md
```

Current decision:

- no standalone route or full principal profile;
- not a playable route or independent engine;
- exists to make Sandra's relationship, house, fatigue, choices, and consequences credible;
- must not become a monster, disposable obstacle, or second protagonist.

### Bastien and Élodie in the opening

- Bastien remains visibly present in Pauline's authorized Friday social image;
- his trust does not make him stupid or grant retroactive consent;
- Élodie remains La Verrière work/social support and may appear in event imagery;
- neither becomes a route or consent proxy.

The same proportional rule applies to Maud, Nora, Julie, Clara, Sophie, Malik, and other supporting anchors unless their function materially changes.

## 7. Reading rule

When writing a scene:

1. Read the relevant principal full-canon file.
2. Read `NARRATIVE_CANON_STATUS.md` for current runtime/route activation.
3. Read `NSFW_CHARACTER_ROUTE_CANON.md` when adult tension, images, voyeurism, roleplay, cheating, sharing, NTR/cuckold, trio, or explicit content is involved.
4. Read the relevant deprecation map when older material may conflict.
5. Read `SUPPORTING_CHARACTER_CANON_POLICY.md` when a support character appears or is affected.
6. Read the validated modular-window source pack, scene card, and temporal map.
7. Use old addenda, arcs, route matrices, and legacy runtime only as history or isolated material to revalidate.

## 8. Character-specific reminders

### Mathilde

```text
ordinary sensuality is not consent
progression comes from changed intention
current runtime = R1 household access only
Marie and family trust remain active
```

### Pauline

```text
current relationship with Bastien
prior hidden infidelity
Marie's partial knowledge
double life and compartmentalization
current runtime = public/social R1 only
```

### Nico

```text
real attraction to Marie and Mathilde exists in canon
domestic-access envy and shared gaze are later engines
image origin and consent always matter
current runtime = ordinary friend/social mirror only
```

### Raphaëlle

```text
chosen version
explicit frame
role and image authorship
local clarity does not erase global consequence
current runtime = work R1 only
```

## 9. Maintenance rule

When a validated correction changes a character's identity, route engine, consent frame, image logic, ensemble function, or current activation, update in the same pass:

- the full character canon when identity changes;
- the relevant deprecation map;
- the global NSFW canon when adult rules change;
- this index;
- `DOCUMENTATION_READING_ORDER.md`;
- `NARRATIVE_CANON_STATUS.md`;
- `CHARACTERS_CANON_CURRENT.md`;
- the active version report;
- implementation guidance and PR description.

```text
A character correction is not complete
while the full file, current activation status, and general canon disagree.
```

## 10. Sandra terminology policy

Do not use the English word `shift` in current writing.

Use:

- `horaires décalés`;
- `poste du matin`;
- `poste du soir`;
- `poste de nuit`;
- `fin de poste`;
- `week-end travaillé`.

This is life color, not a gameplay system.
