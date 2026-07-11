# J1 Runtime Reconciliation Source Pack — V0.83

> Canon replacement specification for the active Tuesday runtime.  
> Reconciles current J1 implementation with V0.69 exact-line intent, V0.70 three-choice design, V0.78 modular architecture, and the temporal/communication canon.  
> Documentation only: no runtime, JSON, GDScript, tests, assets, or playable content are changed here.

## 1. Purpose

The current active Tuesday runtime still derives from large legacy conversations.

Filtering the already-installed Mathilde messages fixed one visible contradiction, but the remaining files still contain:

- timestamps that move backward;
- an explicit Tuesday/Wednesday contradiction;
- excessive guided-reply fragmentation;
- Sandra material that advances too far for J1;
- old numeric route scores;
- a structure that ends on Sandra rather than Marie/shared life;
- no clear offline dinner/walk return;
- dialogue that diverges materially from the V0.69 line source.

The active runtime must stop filtering the legacy J1 files and instead use a small, newly authored modular Tuesday source.

Legacy files remain on disk for history and rollback.

---

## 2. J1 function

```text
J1 — Les choses qu'on remarque
```

Central intention:

```text
Marie is the life Player must join.
Sandra is the trace Player can read.
Player is not choosing a route.
He is revealing how he pays attention.
```

Required outcomes:

- Marie and Player remain a real, warm couple;
- Player is asked for one concrete act of presence;
- Sandra returns through one old trace;
- Mathilde remains indirect only;
- no Nico, Pauline, or Raphaëlle active thread;
- no route lock;
- no hard secret;
- no explicit adult content;
- no relationship-frame change;
- final emotional center returns to Marie/shared life.

---

## 3. Canonical Tuesday timeline

```text
T1 — 18:12
Marie / dinner, bread, walk, La Verrière
REMOTE_ASYNC

T2 — approximately 19:15
Player returns; dinner and walk happen face to face
OFFLINE_BEAT

T3 — 22:57
Sandra / old lunch photograph
REMOTE_ASYNC

T4 — approximately 23:25
Player puts the phone down and returns to Marie/shared life
OFFLINE_BEAT

T5
MARDI — FIN DE JOURNÉE
then Wednesday unlock
```

All message timestamps within one episode must be non-decreasing.

---

## 4. Physical and communication context

### Marie opening

```text
Marie is at La Verrière or returning from it.
Player is leaving work, commuting, or elsewhere.
They are not in the same room.
communication_mode = REMOTE_ASYNC
```

### Dinner and walk

```text
Player and Marie are physically together.
communication_mode = OFFLINE_BEAT
```

No Messenger transcript is shown for the face-to-face dinner/walk.

### Sandra trace

```text
Sandra is at home after work.
Player is at home but separately using his phone.
communication_mode = REMOTE_ASYNC
```

### Final Marie return

```text
Player and Marie are physically together.
communication_mode = OFFLINE_BEAT
```

The day does not end through an artificial late-night Marie chat from the same room.

---

# 5. T1 — Marie opening

## 5.1 Scene identity

```text
scene_id: j1_marie_dinner_walk_01
window: TUESDAY_EARLY_EVENING
primary relationship: Player / Marie
function: ordinary warmth + one concrete participation request
intensity: ordinary
```

## 5.2 Canon line source

```text
Marie : Question importante.
Marie : Deux tomates, un reste de fromage et beaucoup d'optimisme, ça fait un dîner ?

Player : ça dépend de l'optimisme

Marie : Moyen.
Marie : Mais courageux 😅

Player : donc oui

Marie : Bonne réponse.
Marie : Il manque juste le pain.

Player : évidemment

Marie : Évidemment.
Marie : Et petite marche après.
Marie : Dix minutes.
Marie : Pas une randonnée de couple en crise.

Player : on est en crise ?

Marie : Non.
Marie : Justement.
Marie : Je refuse qu'on attende d'être tristes pour sortir marcher.
```

The guided lines before the posture node may be presented in two or three compact interactions, not one button per sentence.

## 5.3 Choice M1 — Player presence posture

Exactly three choices.

### M1A — Present

```text
Player : ok
Player : pain + marche
Player : je participe à la survie du dîner

Marie : Voilà 🙂
Marie : C'est beau, un homme qui accepte sa mission.
```

Flags:

```text
j1_marie_present
j1_shared_evening_due
```

### M1B — Joke, but present

```text
Player : je viens
Player : mais je râle un peu pour la forme

Marie : Accepté.
Marie : Râle en marchant, c'est cardio.
```

Flags:

```text
j1_marie_playful_present
j1_shared_evening_due
```

### M1C — Delayed / flat

```text
Player : désolé
Player : j'avais un mail
Player : oui, pain + marche

Marie : Ton mail peut acheter du pain ?

Player : non

Marie : Alors je préfère toi.
Marie : Mais en version présente, si possible.
```

Flags:

```text
j1_marie_delayed_flat
j1_shared_evening_due
```

No numeric trust, neglect, attention, or truth score is written.

---

## 5.4 La Verrière color beat

Use after M1 in the same remote episode.

```text
Marie : Sinon La Verrière a survécu à sa journée.
Marie : Moi aussi, à peu près.

Player : journée compliquée ?

Marie : Petit événement jeudi.
Marie : Deux logos inversés sur l'affiche.
Marie : Un traiteur qui répond « normalement oui » à une question où la seule bonne réponse était « oui ».

Player : dangereux le normalement

Marie : Très.
Marie : Élodie m'a dit que je souriais comme quelqu'un qui allait écrire un mail poli mais violent.

Player : elle te lit bien

Marie : Trop bien.
Marie : C'est agaçant, les gens attentifs.
```

This beat establishes Thursday without unlocking it.

---

## 5.5 Optional Mathilde indirect seed

Use one concise seed only.

```text
Marie : Mathilde veut passer voir l'installation demain.
Marie : Enfin elle dit « voir l'installation ».
Marie : Je pense surtout qu'elle veut juger l'éclairage.

Player : ça lui ressemble

Marie : Oui.
Marie : Elle a une relation très personnelle avec les lumières qui la trahissent.
```

Guardrails:

- no Mathilde thread;
- no bag, shoe, charger, sport, racket, or already-installed trace;
- the Wednesday water-damage emergency may replace the planned installation visit naturally.

---

# 6. T2 — Shared evening offline beat

## 6.1 Required timing

Approximate:

```text
19:15–20:15
```

This is a mandatory phase between Marie's opening and Sandra's late-night trace.

## 6.2 Present/playful variant

Conditions:

```text
j1_marie_present OR j1_marie_playful_present
```

Authored beat:

```text
MARDI — SOIR

Player rentre avec le pain. Ils dînent, puis marchent dix minutes.
Marie râle une fois contre le traiteur, Player contre la météo.
Le téléphone reste dans sa poche.
```

Flags:

```text
j1_shared_evening_completed
j1_marie_return_active
```

## 6.3 Delayed/flat variant

Condition:

```text
j1_marie_delayed_flat
```

Authored beat:

```text
MARDI — SOIR

Player arrive plus tard que prévu, mais avec le pain.
Marie ne transforme pas le retard en scène.
Ils dînent et marchent quand même quelques minutes.
Elle remarque l'effort sans prétendre que le retard n'existe pas.
```

Flags:

```text
j1_shared_evening_completed
j1_marie_return_delayed
```

No new choice is required. The posture was already selected.

---

# 7. T3 — Sandra trace

## 7.1 Scene identity

```text
scene_id: j1_sandra_old_lunch_trace_01
window: TUESDAY_NIGHT
primary relationship: Player / Sandra
function: soft trace re-entry
intensity: ordinary / soft private attention
```

## 7.2 Canon line source

```text
Sandra : Je tombe peut-être mal.
Sandra : Mais j'ai retrouvé une photo.

Player : de quoi ?

Sandra : De notre dernier déjeuner.
Sandra : Enfin...
Sandra : Deux verres, un coin de table, et moi floue sur le bord.

Player : très artistique

Sandra : Non.
Sandra : Juste ratée.
Sandra : Mais je crois que je l'aime bien quand même.

Player : tu l'as retrouvée comment ?

Sandra : J'ai imprimé quelques photos après mon poste.
Sandra : Mauvaise idée à 22h, probablement.

Player : fin de poste compliquée ?

Sandra : Pas horrible.
Sandra : SentryCore a fait semblant de coopérer.
Sandra : Un ticket fantôme, quand même.
```

The photograph remains:

```text
j1_sandra_lunch_memory_soft
```

Do not add lake, romance novel, tomatoes, hidden body crop, or a second image.

## 7.3 Choice S1 — How Player reads the trace

Exactly three choices.

### S1A — Safe warmth

```text
Player : je suis content que tu l'aies gardée

Sandra : C'est gentil.
Sandra : Et presque raisonnable.

Player : presque ?

Sandra : Oui.
Sandra : Ne gâchons pas tout de suite.
```

Flag:

```text
j1_sandra_safe_warmth
```

### S1B — Precise observation

```text
Player : elle est floue
Player : mais je me souviens que tu souriais

Sandra : Haha.
Sandra : Tu as une mémoire pénible.

Player : désolé

Sandra : Je n'ai pas dit mauvaise.
```

Flag:

```text
j1_sandra_precise_observation
```

### S1C — Cautious

```text
Player : ah oui
Player : je me souviens

Sandra : Réponse prudente.

Player : c'est mal ?

Sandra : Non.
Sandra : Juste un peu propre.
```

Flag:

```text
j1_sandra_cautious
```

No attachment or priority score is written.

---

## 7.4 Sandra soft boundary

Common continuation:

```text
Sandra : Je vais te laisser.
Sandra : Je travaille tôt demain.

Player : poste du matin ?

Sandra : Oui.
Sandra : Donc je devrais dormir.
Sandra : Au lieu de relire une photo floue comme si elle allait devenir nette.

Player : elle ne deviendra pas nette

Sandra : Je sais.
Sandra : C'est peut-être pour ça que je l'aime bien.

Player : merci de me l'avoir envoyée

Sandra : De rien.
Sandra : Enfin...
Sandra : On va dire que c'était sans conséquence.

Player : on garde cette version ?

Sandra : Oui.
Sandra : Pour ce soir.

Player : bonne nuit Sandra

Sandra : Bonne nuit, Player 🙂
```

Optional precise echo, only for S1B:

```text
Sandra : Et pour la photo...
Sandra : Tu avais raison.
Sandra : Je souriais.
```

No `mon cher Player` is used in the active J1 runtime pass. It remains historical optional material for later review.

Flags:

```text
j1_sandra_trace_complete
```

---

# 8. T4 — Final Marie/shared-life beat

The day must not end on Sandra.

This is a mandatory offline consequence after Sandra completes.

Approximate time:

```text
23:25–23:35
```

## 8.1 Present/playful close

Conditions:

```text
j1_marie_present OR j1_marie_playful_present
```

Authored beat:

```text
MARDI — NUIT

Player pose le téléphone.
Dans la cuisine, Marie a laissé le pain, le fromage et deux assiettes.

Marie : Merci pour la marche.
Marie : Ça m'a fait du bien.

Elle lui tend le couteau.

Marie : Message à prouver.
Marie : Coupe le fromage.

Player range son téléphone. Ils restent encore quelques minutes ensemble, sans écran.
```

Flags:

```text
j1_marie_final_return_present
j1_day_complete
```

## 8.2 Delayed/flat close

Condition:

```text
j1_marie_delayed_flat
```

Authored beat:

```text
MARDI — NUIT

Player pose le téléphone.
Marie est encore dans la cuisine.

Marie : Tu étais un peu loin ce soir.
Marie : Je ne te fais pas une scène.
Marie : Je le dis juste maintenant.
Marie : Ne promets pas mieux.
Marie : Fais un petit truc vrai.

Elle lui tend le couteau à fromage.
Player le prend et laisse son téléphone sur la table.
```

Flags:

```text
j1_marie_final_return_delayed
j1_day_complete
```

The day-end transition may begin only after this beat.

---

# 9. New active-runtime file structure

V0.85 should create new active files rather than filter the legacy conversations.

Recommended files:

```text
game/data/conversations/chapter_01_marie_opening.json
game/data/conversations/chapter_01_sandra_trace.json
game/data/conversations/chapter_01_modular_index.json
```

Day-level offline beats belong to the new timeline-flow metadata introduced by V0.84.

The active index should stop referencing:

```text
game/data/conversations/chapter_01_marie.json
game/data/conversations/chapter_01_sandra.json
```

Those files remain legacy and inactive.

---

# 10. Legacy content disposition

## Remove from active runtime

- `msg_marie_291` / `msg_marie_292` and the bag/racket trace;
- every timestamp reset inside Marie or Sandra;
- `Player : On est mercredi.` on Tuesday;
- lake/nature expansion;
- romance-novel exposition;
- tomato diversion in Sandra's thread;
- the long `absent de moi-même` confidence sequence;
- `Moi aussi, ça m'avait manqué` / `Toi` escalation;
- old `sandra.attachment`, `sandra_priority_score`, `marie_neglect_score`, `marie_attention_score`, and similar J1 numeric effects;
- dozens of one-option guided-reply clicks;
- the current structure `all Marie -> all Sandra -> end`.

## Preserve or revalidate

- tomatoes / cheese / bread / walk anchors with Marie;
- La Verrière Thursday event seed;
- optional Mathilde lighting seed;
- Sandra's old blurry lunch photograph;
- SentryCore and `ticket fantôme`;
- poste du matin boundary;
- Marie's final `Message à prouver / Coupe le fromage` motif.

---

# 11. Choice audit

J1 active runtime contains two meaningful choice nodes:

| Node | Axis | Choice 1 | Choice 2 | Choice 3 |
|---|---|---|---|---|
| M1 | quality of presence with Marie | present | playful-present | delayed/flat |
| S1 | reading Sandra's trace | safe warmth | precise observation | cautious |

Guided replies may exist in compact form where necessary to preserve Player voice.

The runtime must not require thirty single-option clicks to reproduce a fixed transcript.

---

# 12. State ceiling

At J1 completion:

```text
couple mode = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE
Sandra = soft trace seed only
Mathilde = indirect only
hard secrets = none
adult frames = none
routes R2+ = none
```

Only observable flags are written.

---

# 13. Acceptance checklist

J1 is reconciled only if:

- [ ] Tuesday timestamps never move backward;
- [ ] no character says it is Wednesday;
- [ ] Mathilde is indirect only;
- [ ] Marie's opening is concise and grounded in dinner/bread/walk;
- [ ] La Verrière Thursday is seeded;
- [ ] dinner/walk occurs as an offline beat;
- [ ] Sandra receives one old trace only;
- [ ] Sandra does not discuss a romance novel, lake, or deep absence;
- [ ] Sandra uses three choices maximum;
- [ ] no numeric route/affection score is written;
- [ ] final mandatory beat returns to Marie/shared life;
- [ ] Tuesday completes only after that final beat;
- [ ] Wednesday unlocks through the day-transition system;
- [ ] legacy J1 files remain inactive but available for rollback.

---

# 14. Final rule

```text
J1 should feel like one ordinary evening with two meaningful attentional tests.

Marie asks Player to join real life.
Sandra sends one trace.
Player returns to Marie before the day ends.
```
