# Characters Canon Current

> **Phase actuelle : Bible Narrative / North Star**  
> Concise doorway for character writing.  
> Use the full character files and the Bible rather than this summary when authoring scenes.

## 1. Principal sources of truth

| Character | Current full canon |
|---|---|
| Marie | `docs/canon/characters/MARIE_CANON_FULL.md` |
| Sandra | `docs/canon/characters/SANDRA_CANON_FULL.md` |
| Player | `docs/canon/characters/PLAYER_CANON_FULL.md` |
| Mathilde | `docs/canon/characters/MATHILDE_CANON_FULL.md` |
| Pauline | `docs/canon/characters/PAULINE_CANON_FULL.md` |
| Nico | `docs/canon/characters/NICO_CANON_FULL.md` |
| Raphaëlle | `docs/canon/characters/RAPHAELLE_CANON_FULL.md` |

Directory index:

```text
docs/canon/characters/CHARACTER_CANON_INDEX.md
```

Global adult canon:

```text
docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md
```

Bible Narrative:

```text
docs/canon/bible/README.md
docs/canon/bible/00_NORTH_STAR.md
docs/canon/bible/01_EXPERIENCE_JOUEUR.md
docs/canon/bible/02_FANTASMES_CENTRAUX.md
docs/canon/bible/03_GRAMMAIRE_NARRATIVE.md
docs/canon/bible/04_TRAME_PRINCIPALE_ET_ACTES_SAISON_1.md
docs/canon/bible/05_ROUTES_MACRO_SAISON_1.md
docs/canon/bible/06_EVOLUTION_EROTIQUE_DES_ROUTES.md
docs/canon/bible/07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md
docs/canon/bible/08_REGLES_DES_SCENES_MODULAIRES.md
```

---

## 2. Authority split

```text
Full character canon
= identity, past, voice, body logic, desires, wounds, limits, concrete anchors

Bible Narrative
= promise, acts, routes, transformations, sequence functions, modular-scene rules

NSFW canon
= adult escalation, image consent, explicit route rules, dark-route distinctions

Runtime
= what is currently implemented and playable
```

A scene must satisfy all relevant layers.

---

## 3. Current character direction

### Marie

Marie is the living center of the couple.

Required direction:

- La Verrière and active social life;
- shared domestic life;
- practical humor;
- movement instead of passive waiting;
- black dress and visibility;
- reconquest or reconfiguration through concrete action.

### Sandra

Sandra is a woman of concrete traces.

Required direction:

- SentryCore and horaires décalés;
- photos printed, moved, kept, or removed;
- books, frames, scrapbook, hot chocolate, plaid;
- Jeff as a real partner;
- Maison des Tilleuls;
- chosen distance and chosen showing.

### Mathilde

Mathilde is Marie's cousin and a temporary resident after water damage.

Required direction:

- ten-to-fifteen-day stay;
- spare room, suitcase, garment bag, work tote;
- legal-protection work;
- naturally fitted clothing that is not consent;
- image control, speed, bad faith;
- Marie's family trust as the weight of the route.

### Pauline

Pauline is Marie's close friend and Bastien's partner.

She has already cheated on Bastien and did not confess.

Required direction:

- real official life with Bastien;
- Marie's partial knowledge;
- bank and confidentiality;
- choir and community life;
- public/private versions;
- compartment, proof, and collision.

### Raphaëlle

Raphaëlle is Player's UX/accessibility peer and the character of chosen transformation.

Required direction:

- work competence;
- sewing, cosplay, craft, Maud, and creative account;
- workshop and process;
- chosen version and audience;
- explicit frame;
- role ending and responsibility remaining.

She must not be reduced to a colleague, a safe outside breath, or a cosplay gimmick.

### Nico

Nico is a heterosexual man, a real friend, a social mirror, and a possible rival or accomplice.

Required direction:

- L'Annexe;
- ordinary friendship;
- real attraction to Marie;
- real sexual attraction to Mathilde;
- outside social gaze against Player's domestic gaze;
- image and alibi distinctions;
- quiet private aftermath;
- no romantic or sexual route with Player.

### Player

Player is short, dry, observant, desirous, and responsible.

He does not select routes from a menu.

His gaze becomes an act through what he notices, asks, saves, hides, refuses, forwards, repairs, or chooses to join.

---

## 4. Scene-authoring rule

Before authoring a scene, read:

1. the relevant `*_CANON_FULL.md` files;
2. `NSFW_CHARACTER_ROUTE_CANON.md` when adult or image rules are involved;
3. the relevant Bible route and sequence;
4. `08_REGLES_DES_SCENES_MODULAIRES.md`.

Every major scene must:

- identify a source sequence from `S01` to `S35` or declare a new candidate;
- use at least two full-canon anchors;
- define one primary function and relationship;
- preserve character agency;
- define eligibility, mutation, exit state, and consequence;
- respect time and communication realism.

The historical `MODULAR_SCENE_AUTHORING_CONTRACT.md` remains a compatible technical reference. The Bible `08` prevails on narrative direction.

---

## 5. First-season depth

### Complete bascule possible

- Marie;
- Sandra;
- Mathilde.

### Strong extension promise

- Pauline.

### Structural seeds with real consequence

- Raphaëlle;
- Nico.

Raphaëlle must reach at least a chosen creative access or concrete future frame.

Nico must reach at least a meaningful position as guardrail, rival, confidant, accomplice, or compromised witness.

---

## 6. Runtime separation

The current runtime may still expose only ordinary access.

Do not confuse that ceiling with full canon or approved scene design.

Document `08` does not automatically validate or implement old scene cards, source packs, JSON conversations, or playable content.

---

## 7. Existing-scene audit

Old scenes must later be classified:

```text
COMPATIBLE
ADAPTABLE
REWRITE
ARCHIVE
```

A technically functional scene can remain narratively obsolete.

---

## 8. Supporting characters

- Jeff remains Sandra's real partner and consequence.
- Bastien remains Pauline's real partner and is never a consent proxy.
- Élodie supports Marie's La Verrière life.
- Maud anchors Raphaëlle's craft and image origin.
- Inès, Chloé, Léa, Amandine, Nora, Julie, Malik, Sophie, and others provide texture without omniscience.

---

## 9. Maintenance rule

When a character or scene decision changes:

- update the full canon if identity changes;
- update the deprecation map;
- update the NSFW canon if adult rules change;
- update the character index and this doorway;
- update Bible routes, sequences, or scene rules when affected;
- update reading order and narrative status;
- audit affected scenes;
- validate before runtime planning.

```text
The full character files define people.
The Bible defines how those people transform and how scenes adapt.
The runtime defines what is playable now.
```