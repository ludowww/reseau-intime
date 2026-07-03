# Day 5 Pauline Understands — SMS Rewrite Prototype

## Purpose

Prototype a version of `chapter_05_pauline_understands` that feels more like a real SMS exchange:

- shorter bursts,
- faster alternance,
- fewer explanatory monologues,
- more natural Player replies,
- Pauline still dangerous, but through control and restraint rather than exposition.

This is a `narrative_tool` prototype only. It is not runtime.

## Source runtime diagnosis

Target runtime file:

- `game/data/conversations/chapter_05_pauline_photos.json`

Current runtime shape:

- 1 segment only.
- 21 Pauline messages before the first Player reply window.
- Average Pauline bubble length: about 28–29 characters.
- Longest Pauline bubble: 65 characters.
- 4 Player choices.
- Average Player choice length: about 16 words.
- Longest Player choice: 26 words.

Diagnosis:

| Élément source | Diagnostic | Action prototype |
|---|---|---|
| Burst Pauline | Trop long : effet bloc / scène parlée, pas vraie alternance SMS | Réduire à 2–3 messages max avant une réponse Player |
| Choix Player | Trop explicatifs, trop longs, pas assez envoyables | Raccourcir, viser 3 à 9 mots |
| Preuve photo | Présente mais encore trop “scène / preuve” dans le sous-texte | Garder faible, laisser Pauline l’utiliser comme appât léger |
| Ton Pauline | Lucide, joueuse, dangereuse, mais parfois trop démonstrative | Garder dangereux, mais pas omniscient ni explicatif |
| Rythme J5 | Densité correcte pour l’arc, mais pas pour le style SMS | Alléger et faire respirer |

What the runtime already does well:

- Pauline feels observatrice.
- The photo stays a weak trace, not a definitive proof.
- The scene keeps ambiguity around what Pauline actually knows.
- The control / fragility mix is already there.

What needs to be reduced or transformed:

- the long initial Pauline burst,
- the explanatory line that sounds like mini-analysis,
- Player replies that read like explanations instead of texts,
- the sense that Pauline is “announcing the theme” instead of texting.

Sources checked for style contrast:

- J1-J4 SMS rhythm references: Marie / Sandra scenes from days 1–3.
- V0.31 diagnosis in `narrative_tool/docs/j5_j8_narrative_arc_character_rhythm_reassessment.md`.
- Absent sources confirmed without failure:
  - `docs/dialogue_tool/` not found,
  - `game/narrative_memory/day_05.json` not found,
  - `game/narrative_routes/routes_schema.json` not found.

## What must be preserved

- Pauline as host / observer / light controller.
- Weak proofs only, no definitive reveal.
- Ambiguity about how much she really knows.
- No omniscience.
- No final revelation.
- No confrontation directe.
- No new flags, no new photo, no route lock.
- Pauline should remain unsettling because she retains information, not because she explains everything.

## What should change

- Pauline should speak in shorter SMS-sized bursts.
- Player should answer more often and more quickly.
- Player choices should sound sendable, not like labels.
- The scene should have more pauses and smaller turns.
- Pauline should imply instead of conclude.
- The photo should stay a weak trace / appât, not become a proof dump.

## Rewrite principles

1. Never more than 3 Pauline messages in a row before a Player reply.
2. One Pauline message = one idea.
3. Player choices should ideally be 3–9 words.
4. Avoid paragraphs that explain the scene’s meaning.
5. Let silence and suspension do part of the work.
6. Pauline can be sharp, but not all-knowing.
7. The Player should feel like he is replying to a real person, not to exposition.

## Prototype dialogue

### Segment 1 — Tri léger

Pauline: Je trie les photos d’hier.

Pauline: Enfin, “trie” est un peu ambitieux.

Player choice A: Tu gardes quoi ?

Pauline: Ce qui mérite de rester flou.

Player choice B: Tu cherches quoi ?

Pauline: Ta réaction, surtout.

Pauline: Ça en dit déjà assez.

### Segment 2 — Photo et sous-texte

Pauline: Photo prise dehors.

Pauline: Rien de spectaculaire. C’est le problème.

Pauline: Enfin, pour les gens qui ne regardent pas vraiment.

Player choice A: Tu me testes ?

Pauline: Peut-être.

Player choice B: Tu montres quoi, là ?

Pauline: Juste ce qu’il faut pour que tu te poses la question.

Pauline: Le reste, je le garde.

### Segment 3 — Comprendre sans expliquer

Pauline: Je ne te juge pas.

Pauline: Je crois surtout que tu préfères qu’on ne nomme pas les choses trop vite.

Player choice A: Tu fais ton cinéma.

Pauline: Bien sûr.

Player choice B: Qu’est-ce que tu as vu ?

Pauline: Suffisamment pour savoir quand quelqu’un fait semblant.

Pauline: Pas assez pour lui faire un procès.

### Segment 4 — Fin courte / crochet

Pauline: J’ai encore une image.

Pauline: Pas la plus gentille.

Player choice A: C’est tout ?

Pauline: Non.

Player choice B: Envoie-la pas.

Pauline: On verra.

Pauline: Bonne nuit. Ou presque.

## Choice mapping

| Runtime choice intent | Current issue | Prototype SMS option |
|---|---|---|
| `Je ne vois pas ce que tu crois avoir compris. Tu fais ton cinéma, Pauline.` | Trop long, trop défensif, trop “mini-thèse” | `Tu fais ton cinéma.` |
| `Qu’est-ce que tu as vu exactement ?` | Correct sur le fond, encore un peu lourd | `Tu as vu quoi ?` |
| `Et toi ? Tu préfères être regardée ou faire croire que tu ne fais qu’observer ?` | Trop analytique, trop meta | `Tu me testes ?` |
| `Tu dis que tu comprends très bien. C’est parce que tu observes les autres ou parce que tu as déjà été de ce côté-là ?` | Trop explicatif et trop long | `Tu me connais si bien ?` |
| `C’est tout ?` | Bon réflexe, gardable presque tel quel | `C’est tout ?` |
| `Je vais faire comme si je n’avais pas vu l’appât.` | Trop “position de scène”, pas assez SMS court | `Je fais quoi avec ça ?` |

## Runtime integration notes

If this prototype is ever integrated later, keep the current runtime identifiers and logic family intact:

- `chapter_05_pauline_understands`
- `j5_pauline_control_seed`
- `j5_pauline_fragility_seed`
- `j5_pauline_dangerous_understanding`
- `j5_pauline_street_selfie`
- `pauline_cheating_proof_seed_j5_placeholder`

Integration should preserve:

- weak proof only,
- no new proof event,
- no new flag family,
- no new route lock,
- no extra photo,
- no confrontation finale.

What can be integrated later:

- shorter Pauline turns,
- shorter Player choices,
- a smaller, more rhythmic choice chain,
- a weaker and more indirect appât photo moment,
- a more explicit pause before the final hook.

What should stay out of runtime for now:

- any definitive reveal of Pauline’s full knowledge,
- any hard chantage,
- any extra content id,
- any additional story branch.

## Risks

- If Pauline becomes too short, she may lose her control texture.
- If the photo is explained too clearly, it stops feeling like a weak trace.
- If Player choices become too clever, the scene becomes polished instead of lived.
- If one more explanatory line is added, the scene will slide back into exposition.

## Recommendation

Use this prototype as the SMS-style reference for Pauline J5.

Do not integrate it into runtime yet.

Next best step: prototype the same SMS discipline on a second risky scene, then compare both before touching `game/data/`.
