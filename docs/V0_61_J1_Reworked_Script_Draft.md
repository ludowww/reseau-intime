# V0.61 — J1 Reworked Script Draft

> Documentation-only script draft.  
> Builds on `docs/V0_60_J1_Reworked_Script_Plan.md`.  
> First plain-text draft for the future rewritten J1.  
> No runtime, narrative JSON, tests, assets, or playable content are changed.

## 1. Scope

This document is a **narrative draft**, not a JSON implementation.

It proposes the J1 conversation content in plain text, with choice branches written for validation.

Locked J1 constraints:

- active characters: Marie, Sandra, Player;
- Mathilde indirect only;
- no Nico active thread;
- no Pauline active thread;
- no Raphaëlle active thread;
- no group conversation;
- no route lock;
- no explicit escalation;
- no heavy betrayal;
- Player conflict = attention, not allegiance.

## 2. Day title

```text
J1 — Les choses qu'on remarque
```

Intention:

```text
Marie is the life Player must join.
Sandra is the trace Player can read.
Player is not choosing a route yet.
He is revealing how he pays attention.
```

---

## 3. Thread: Marie / Player — Opening domestic warmth

### Scene function

- Show Marie alive before she is hurt.
- Establish couple warmth and practical life.
- Give Player a small chance to participate.
- Keep tone light, grounded, domestic.

### Script draft

```text
Marie : Question importante.
Marie : Est-ce que deux tomates, un reste de fromage et une dignité moyenne peuvent devenir un dîner ?

Player : ça dépend de la dignité

Marie : Fragile.
Marie : Mais motivée.

Player : donc oui

Marie : Bonne réponse.
Marie : Incomplète, mais bonne.

Player : il manque du pain ?

Marie : Voilà.
Marie : Tu vois, quand tu participes, tu deviens immédiatement utile.

Player : je note que mon rôle dans ce couple est boulangerie d'urgence

Marie : Ne te rabaisse pas.
Marie : Tu es aussi très bon pour ouvrir les bocaux quand ils résistent.

Player : une polyvalence rare

Marie : Exactement.
Marie : Et ce soir j'aimerais une polyvalence avec chaussures.

Player : chaussures ?

Marie : Oui.
Marie : Pain + petite marche après.
Marie : Pas la grande expédition.
Marie : Juste assez pour qu'on ne devienne pas deux plantes mal arrosées.

Player : les plantes vont bien

Marie : Une des deux penche vers la mort.
Marie : Je ne dirai pas laquelle pour préserver l'ambiance.
```

### Choice M1 — Player response

#### M1A — Warm participation

```text
Player : ok
Player : pain + marche
Player : je sauve le dîner et notre dignité botanique

Marie : Voilà.
Marie : C'est le Player que j'ai choisi il y a cinq ans.
Marie : Enfin, une version mieux chaussée.
```

#### M1B — Joke but present

```text
Player : je viens
Player : mais si une plante me juge, je rentre

Marie : Marché conclu.
Marie : Je parlerai aux plantes avant.
```

#### M1C — Flat / distracted

```text
Player : oui ok

Marie : Quelle fougue.
Marie : Je vais devoir m'asseoir deux minutes.

Player : j'ai répondu oui

Marie : Oui.
Marie : Comme un formulaire administratif qui accepte les cookies.
```

#### M1D — Delay / phone drift

```text
Player : désolé
Player : j'avais un mail

Marie : À 19h ?

Player : malheureusement oui

Marie : Ton mail peut acheter le pain ?

Player : pas encore

Marie : Alors je garde toi.
Marie : Mais il va falloir redevenir humain rapidement.
```

---

## 4. Thread: Marie / Player — La Verrière color beat

### Scene function

- Add Marie's work-life color.
- Show she carries energy in several places.
- Keep it light; no drama yet.

### Script draft

```text
Marie : Au fait, La Verrière a encore prouvé qu'un petit événement pouvait générer un grand désordre.

Player : quelle surprise

Marie : L'imprimeur a inversé deux logos.
Marie : Le traiteur a oublié les serviettes.
Marie : Et Élodie m'a dit que j'avais mon sourire de femme qui va mordre quelqu'un poliment.

Player : elle te connaît bien

Marie : Trop.
Marie : C'est dangereux, les collègues attentives.

Player : tu as mordu quelqu'un ?

Marie : Non.
Marie : J'ai envoyé trois mails très courtois.
Marie : Donc presque.

Player : très La Verrière comme crise

Marie : Exactement.
Marie : On appelle ça culture locale.
Marie : Des affiches, des chaises, et une panique douce.
```

### Optional Mathilde indirect seed

Use only if needed to seed Mathilde without activating her.

```text
Marie : Mathilde m'a proposé de venir demain voir l'installation.
Marie : Traduction : elle veut commenter les tenues et prétendre qu'elle s'intéresse aux affiches.

Player : elle va survivre aux affiches ?

Marie : Mathilde survit à tout si elle peut dire que l'éclairage la trahit.
```

Guardrail: no Mathilde active thread on J1.

---

## 5. Thread: Sandra / Player — Trace re-entry

### Scene function

- Reintroduce Sandra through a trace, not seduction.
- Use concrete Sandra V2: shift / printed photo / old lunch.
- Let Player read something small.
- Keep Sandra prudent.

### Trigger placement

This thread should unlock after the first Marie beat, not before.

The phone split should be felt: Marie has just asked Player to join the evening; Sandra reappears through memory.

### Script draft

```text
Sandra : Je tombe peut-être mal.
Sandra : Mais j'ai retrouvé une photo.

Player : de quoi ?

Sandra : De notre dernier déjeuner.
Sandra : Enfin techniquement de deux verres, d'un coin de table, et d'une personne floue qui prétend ne pas être le sujet.

Player : toi ?

Sandra : Je n'ai pas confirmé.
Sandra : J'ai dit personne floue.

Player : c'est une catégorie très défendable

Sandra : Merci.
Sandra : Je tiens beaucoup à mes défenses bancales.

Player : tu l'as retrouvée comment ?

Sandra : J'ai imprimé trois photos après mon shift.
Sandra : Deux étaient ratées.
Sandra : Évidemment, c'est celle-là que j'ai gardée.

Player : tu as fini tard ?

Sandra : 22h.
Sandra : SentryCore a survécu.
Sandra : Moi aussi, dans une version moins glorieuse.

Player : ticket compliqué ?

Sandra : Ticket fantôme.
Sandra : Le client disait que le bouton disparaissait.
Sandra : Le bouton, lui, niait toute implication.

Player : une ambiance saine

Sandra : Très.
Sandra : J'ai pensé que ça méritait un chocolat chaud.
Sandra : Puis j'ai imprimé des photos, parce que manifestement mon cerveau voulait ranger des choses.
```

### Choice S1 — Player reads the trace

#### S1A — Safe warmth

```text
Player : je suis content que tu l'aies gardée

Sandra : C'est une réponse raisonnable.
Sandra : Suspect, venant de toi.

Player : je peux faire moins raisonnable si besoin

Sandra : Non.
Sandra : Pas trop vite.
```

#### S1B — Precise observation

```text
Player : elle est peut-être floue
Player : mais je me souviens que tu souriais plus que prévu

Sandra : Haha.
Sandra : Tu as une mémoire pénible.

Player : précise ?

Sandra : Pénible.
Sandra : Précise aussi, malheureusement.
```

#### S1C — Playful deflection

```text
Player : donc officiellement c'est une photo de verres

Sandra : Officiellement.

Player : officieusement c'est une preuve que tu gardes les choses ratées

Sandra : Je vais faire semblant que ce n'est pas une phrase beaucoup trop juste.
```

#### S1D — Distance

```text
Player : ah oui
Player : je me souviens

Sandra : Réponse très prudente.

Player : c'est mal ?

Sandra : Non.
Sandra : C'est juste moins drôle à relire.
```

---

## 6. Thread: Marie / Player — Evening presence check

### Scene function

- Bring Marie back after Sandra.
- Make the player feel the contrast: Sandra asks to be read; Marie asks to be joined.
- Do not punish immediately.
- Keep Marie central.

### Script draft

```text
Marie : Point pain ?

Player : en cours

Marie : Réponse mystérieuse.
Marie : Tu es dehors, debout, chaussé, ou en pleine négociation avec ton canapé ?

Player : je peux être chaussé dans deux minutes

Marie : Très bien.
Marie : Je mets mes chaussures aussi.
Marie : Ça va créer une pression sociale dans l'entrée.

Player : je résiste mal à la pression de chaussures

Marie : Je sais.
Marie : C'est une des bases de notre couple.

Player : j'arrive

Marie : Bien.
Marie : Et après on marche dix minutes.
Marie : Même si tu prétends que le pain est une activité sportive suffisante.

Player : ce n'est pas ?

Marie : Non.
Marie : Mais j'aime ton engagement dans la mauvaise foi.
```

### Conditional beat if Player was flat or delayed earlier

```text
Marie : Et tu reviens avec ton cerveau aussi ?

Player : il était où ?

Marie : Quelque part entre ton mail, ton téléphone, et une absence très réaliste.

Player : pas faux

Marie : Je ne demande pas un miracle.
Marie : Juste toi, vraiment là, dix minutes.
```

### Choice M2 — Player returns to Marie

#### M2A — Active return

```text
Player : ok
Player : pain, marche, et moi vraiment là
Player : dans cet ordre ou l'inverse

Marie : L'inverse me plaît.
Marie : Mais prends le pain quand même.
```

#### M2B — Awkward but sincere

```text
Player : je suis pas excellent aujourd'hui
Player : mais j'arrive

Marie : Ça me va.
Marie : Je préfère un homme moyen qui arrive qu'un homme parfait qui reste théorique.
```

#### M2C — Joke again

```text
Player : je peux promettre 72% de présence

Marie : Je prends 72% si les 28% restants achètent le pain.

Player : négociation rude

Marie : Couple solide, commerce impitoyable.
```

#### M2D — Still distant

```text
Player : oui oui

Marie : Ah.
Marie : Le fameux double oui qui veut dire non mentalement.

Player : c'est injuste

Marie : Peut-être.
Marie : Mais pas complètement faux.
```

---

## 7. Thread: Sandra / Player — Soft boundary

### Scene function

- Close Sandra J1 gently.
- Make her present but not demanding.
- No direct confession.
- No strong route lock.

### Script draft

```text
Sandra : Je vais te laisser.
Sandra : J'ai encore un rythme de sommeil à massacrer proprement.

Player : tu travailles demain ?

Sandra : Matin.
Sandra : Donc je dois dormir maintenant pour être fonctionnelle à une heure indécente.

Player : la photo valait quand même le détour

Sandra : C'est une phrase dangereusement gentille.

Player : je peux reformuler moins bien

Sandra : Non.
Sandra : Je vais la garder comme ça.
Sandra : Dans un coin raisonnable.

Player : raisonnable ?

Sandra : Officiellement.

Player : officieusement ?

Sandra : Haha.
Sandra : Bonne nuit, Player.
```

### Optional warmer ending if S1B precise observation was chosen

```text
Sandra : Et pour la photo...
Sandra : Tu avais raison.
Sandra : Je souriais plus que prévu.

Player : je savais

Sandra : Voilà exactement pourquoi je n'aurais pas dû te le dire.
Sandra : Bonne nuit, mon cher Player.
```

Guardrail: use `mon cher Player` only in the warmer branch. Never automatic.

---

## 8. Thread: Marie / Player — End-of-day close

### Scene function

- Marie remains the final emotional center.
- End J1 on shared life, not Sandra.
- Player's attention choices color the tone but do not lock the route.

### Script draft

```text
Marie : Pain récupéré.
Marie : Dîner sauvé.
Marie : Plantes encore suspectes, mais on ne peut pas tout régler le même soir.

Player : belle victoire

Marie : Très belle.
Marie : Presque historique.

Player : tu exagères rarement

Marie : Je travaille dans l'événementiel culturel.
Marie : Exagérer légèrement, c'est une compétence métier.

Player : la marche était bien

Marie : Oui.
Marie : Tu vois, quand tu sors de ton mode veille, tu redeviens fréquentable.

Player : je prends le compliment

Marie : Prends aussi les tomates.
Marie : Elles menacent de devenir molles si on continue à parler.

Player : message reçu

Marie : Non.
Marie : Message à prouver.
Marie : Coupe le fromage.
```

### Conditional close if Player was present

```text
Marie : Merci pour la marche.
Marie : Ça m'a fait du bien.

Player : à moi aussi

Marie : Tu vois.
Marie : Parfois je suis une excellente idée avec des chaussures.
```

### Conditional close if Player was distant

```text
Marie : Tu étais un peu loin ce soir.

Player : je sais

Marie : Je ne te fais pas une scène.
Marie : Je le note juste.
Marie : Parce que si je ne note pas, après je fais semblant de ne pas l'avoir vu.

Player : je vais faire mieux

Marie : Ne me promets pas mieux.
Marie : Fais un petit truc vrai.
Marie : Ça suffira pour ce soir.
```

---

## 9. J1 choice color summary

These are narrative colors, not implementation names.

### Marie attention color

- **Present**: Player participates in dinner / walk / ordinary life.
- **Awkward present**: Player jokes but still comes.
- **Flat**: Marie notices weak presence.
- **Delayed**: Marie notices phone / work drift.

### Sandra attention color

- **Safe**: Player receives the trace gently.
- **Precise**: Player reads Sandra more deeply.
- **Playful**: Player keeps the exchange light but alive.
- **Distant**: Sandra stays at the edge.

### End state matrix

J1 should end with:

- Marie still central;
- Sandra quietly present;
- Player colored, not locked;
- no active deception system;
- no irreversible route state;
- no explicit betrayal.

---

## 10. Anti-pattern pass notes

### Strong lines used carefully

- `Message reçu / message à prouver` appears only at the end and is domestic, not dramatic.
- `mon cher Player` appears only in optional warm Sandra branch.
- `Officiellement / officieusement` appears in Sandra thread but not everywhere.
- Marie does not say `Nico`, `Pauline`, or anything jealousy-based.
- Sandra does not mention Jeff on J1; too heavy too early.
- Sandra does not mention the romance novels on J1; keep one anchor: photo / shift.

### Risks to watch in next pass

- Some Player lines may be too clever; remove if needed.
- Marie should not sound like she is already diagnosing the whole couple.
- Sandra should not become too openly moved too quickly.
- The day must stay playable and light enough.

---

## 11. Visual / trace candidates

### Sandra visual placeholder

```text
id: j1_sandra_lunch_photo_blurry
function: old trace / emotional re-entry
content: blurry terrace photo from last lunch; table edge, glasses/cups, warm ordinary light; Sandra partly present but not the obvious subject
risk: no erotic framing, no adult content, no proof
```

### Marie optional trace placeholder

```text
id: j1_marie_dinner_trace
function: domestic invitation / couple life
content: tomatoes, cheese, missing bread implied; maybe shoes near door if evening walk is emphasized
risk: keep ordinary, not a jealousy or seduction image
```

Only one visual should be required for J1 if production scope is tight. Prefer Sandra photo because it drives the re-entry.

---

## 12. Draft acceptance criteria

This draft is acceptable if, after review:

- Marie feels alive and desirable before any wound;
- Player gets small real choices without route labels;
- Sandra re-enters through a trace, not direct seduction;
- the phone split is felt but not melodramatic;
- Mathilde remains indirect;
- no other character competes for J1 attention;
- the final beat returns to Marie / shared life;
- there is enough room to expand or trim during JSON integration.

---

## 13. Recommended next pass

Before runtime integration, do one narrative revision pass:

1. Trim repeated clever lines.
2. Reduce Player over-explanation.
3. Check Marie warmth-to-alertness progression.
4. Check Sandra's `haha` dosage.
5. Decide exact branch count for JSON.
6. Validate visual placeholder names with existing data conventions.

Only after that should Hermes convert J1 into runtime conversation data.
