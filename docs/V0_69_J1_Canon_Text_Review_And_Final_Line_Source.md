# V0.69 — J1 Canon Text Review & Final Line Source

> Documentation-only J1 text review after V0.65–V0.68 canon consolidation.  
> This file becomes the current exact line source for J1 planning.  
> No runtime, JSON, tests, assets, or playable content are changed here.

## 1. Purpose

This pass rechecks the J1 text after:

- V0.65 consolidated canon docs;
- V0.66 full per-character canon;
- V0.67 NSFW character route canon;
- V0.68 narrative refoundation audit.

V0.64 remains useful history, but this file is now the corrected J1 line source.

---

## 2. Review verdict

J1 remains structurally valid.

It still satisfies the current J1 canon:

- Marie + Sandra + Player active;
- Mathilde indirect only;
- no Nico / Pauline / Raphaëlle;
- no group;
- no route lock;
- no hard secret system;
- no explicit escalation;
- final emotional center returns to Marie / shared life;
- Sandra returns through a trace, not seduction;
- Player has imperfect but visible replies.

However V0.64 needed small corrections before runtime planning:

1. Replace English `shift` wording with French concrete wording: `poste`, `fin de poste`, `horaires décalés`.
2. Avoid repeating `officiellement / officieusement` in a way that could become a Sandra gimmick.
3. Update outdated runtime-planning references from older version numbers.
4. Keep the NSFW canon as future route context only: J1 remains low-intensity / non-explicit.

---

## 3. Current J1 title

```text
J1 — Les choses qu'on remarque
```

Working intention:

```text
Marie is the life Player must join.
Sandra is the trace Player can read.
Player is not choosing a route yet.
He is revealing how he pays attention.
```

---

## 4. Current constraints

- Active characters: Marie, Sandra, Player.
- Mathilde indirect only.
- No Nico active thread.
- No Pauline active thread.
- No Raphaëlle active thread.
- No group conversation.
- No hard secret system.
- No route lock.
- No explicit escalation.
- No adult explicit content on J1.
- Final emotional center: Marie / shared life.

---

## 5. Thread Marie / Player — Opening domestic warmth

### Function

- Establish the couple as real and still warm.
- Give Marie daily-life energy before any wound.
- Give Player a small concrete opportunity to participate.

### Canon line source

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
Marie : C'est pour ça que je t'écris avant que tu t'installes trop profondément dans le canapé.

Player : je suis pas installé profondément

Marie : Tu mens moins bien quand je connais le canapé.

Player : ok
Player : pain

Marie : Et petite marche après.
Marie : Dix minutes.
Marie : Pas une randonnée de couple en crise.

Player : on est en crise ?

Marie : Non.
Marie : Justement.
Marie : Je refuse qu'on attende d'être tristes pour sortir marcher.
```

### Choice M1 — Player response

#### M1A — Present

```text
Player : ok
Player : pain + marche
Player : je participe à la survie du dîner

Marie : Voilà 🙂
Marie : C'est beau, un homme qui accepte sa mission.
```

#### M1B — Joke, but present

```text
Player : je viens
Player : mais je râle un peu pour la forme

Marie : Accepté.
Marie : Râle en marchant, c'est cardio.
```

#### M1C — Flat

```text
Player : oui ok

Marie : Quelle énergie.

Player : j'ai dit oui

Marie : Oui.
Marie : Mais en gris clair.
```

#### M1D — Delayed / work drift

```text
Player : désolé
Player : j'avais un mail

Marie : À 19h ?

Player : oui

Marie : Ton mail peut acheter du pain ?

Player : non

Marie : Alors je préfère toi.
Marie : Mais en version présente, si possible.
```

---

## 6. Thread Marie / Player — La Verrière color beat

### Function

- Give Marie a life outside the couple.
- Keep her social / active / concrete.
- Add texture without adding a new active character.

### Canon line source

```text
Marie : Sinon La Verrière a survécu à sa journée.
Marie : Moi aussi, à peu près.

Player : journée compliquée ?

Marie : Petit événement jeudi.
Marie : Deux logos inversés sur l'affiche.
Marie : Un traiteur qui répond "normalement oui" à une question où la seule bonne réponse était "oui".

Player : dangereux le normalement

Marie : Très.
Marie : Élodie m'a dit que je souriais comme quelqu'un qui allait écrire un mail poli mais violent.

Player : elle te lit bien

Marie : Trop bien.
Marie : C'est agaçant, les gens attentifs.
```

### Optional Mathilde indirect seed

Use only if J1 needs a light family seed.

```text
Marie : Mathilde veut passer voir l'installation demain.
Marie : Enfin elle dit "voir l'installation".
Marie : Je pense surtout qu'elle veut juger l'éclairage.

Player : ça lui ressemble

Marie : Oui.
Marie : Elle a une relation très personnelle avec les lumières qui la trahissent.
```

Guardrail: no Mathilde active thread on J1.

---

## 7. Thread Sandra / Player — Trace re-entry

### Function

- Reintroduce Sandra through a trace, not seduction.
- Use one concrete anchor: old lunch photo found after work.
- Let Player read without making him perfect.

### Trigger placement

This thread should unlock after the first Marie beat.

Marie has asked Player to participate in the evening. Sandra then reappears through a defensible memory.

### Canon line source

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

Player : encore ?

Sandra : Oui.
Sandra : Le bouton disparaissait.
Sandra : Enfin d'après le client.
Sandra : Le bouton avait l'air innocent sur la capture.

Player : dossier compliqué

Sandra : Très.
Sandra : J'ai tranché avec un chocolat chaud.
Sandra : Justice approximative.
```

### Choice S1 — Player response

#### S1A — Safe warmth

```text
Player : je suis content que tu l'aies gardée

Sandra : C'est gentil.
Sandra : Et presque raisonnable.

Player : presque ?

Sandra : Oui.
Sandra : Ne gâchons pas tout de suite.
```

#### S1B — Precise observation

```text
Player : elle est floue
Player : mais je me souviens que tu souriais

Sandra : Haha.
Sandra : Tu as une mémoire pénible.

Player : désolé

Sandra : Je n'ai pas dit mauvaise.
```

#### S1C — Playful, light

```text
Player : officiellement, c'est une photo de verres

Sandra : Officiellement.

Player : officieusement, tu gardes les photos ratées

Sandra : J'aime bien les choses qui ratent doucement.
Sandra : Ne donne pas trop d'importance à cette phrase.
```

#### S1D — Distant / cautious

```text
Player : ah oui
Player : je me souviens

Sandra : Réponse prudente.

Player : c'est mal ?

Sandra : Non.
Sandra : Juste un peu propre.
```

---

## 8. Thread Marie / Player — Evening presence check

### Function

- Bring Marie back after Sandra.
- Keep the tension about attention, not betrayal.
- Recenter the day on shared life.

### Canon line source

```text
Marie : Point pain ?

Player : j'y vais

Marie : Là maintenant ?

Player : oui

Marie : Bien.
Marie : Je mets mes chaussures aussi.

Player : pression ?

Marie : Un peu.
Marie : Mais douce.

Player : je peux gérer une pression douce

Marie : Parfait.
Marie : Après on marche dix minutes.
Marie : Tu peux râler à partir de la sixième.

Player : généreux

Marie : Je suis une femme très équilibrée 🙂
```

### Conditional beat if Player was flat or delayed earlier

```text
Marie : Et tu reviens avec ton cerveau ?

Player : il était parti ?

Marie : Un peu.
Marie : Rien de grave.
Marie : Mais je l'ai vu passer en mode veille.

Player : pas faux

Marie : Je ne demande pas un miracle.
Marie : Juste toi, vraiment là, dix minutes.
```

### Choice M2 — Player returns to Marie

#### M2A — Active return

```text
Player : ok
Player : pain, marche, moi là

Marie : Très bon programme.
Marie : Court, mais solide.
```

#### M2B — Awkward but sincere

```text
Player : je suis pas très bon ce soir
Player : mais j'arrive

Marie : Ça me va.
Marie : Je préfère ça à un grand discours immobile.
```

#### M2C — Joke again

```text
Player : je promets une présence correcte

Marie : Correcte, c'est déjà mieux que décorative.

Player : rude

Marie : Motivante.
```

#### M2D — Still distant

```text
Player : oui oui

Marie : Ah.
Marie : Double oui.

Player : ça veut dire oui

Marie : Souvent ça veut dire "je veux que la conversation finisse".

Player : pas complètement

Marie : Voilà.
```

---

## 9. Thread Sandra / Player — Soft boundary

### Function

- Close Sandra gently.
- Keep her present but not demanding.
- Avoid confession and strong route activation.

### Canon line source

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

### Optional warmer ending if S1B precise observation was chosen

Use only if the branch earned it.

```text
Sandra : Et pour la photo...
Sandra : Tu avais raison.
Sandra : Je souriais.

Player : je savais pas si je devais le dire

Sandra : Tu l'as dit assez doucement.
Sandra : C'est pire, je crois.

Player : pire ?

Sandra : Plus difficile à ignorer.
Sandra : Bonne nuit, mon cher Player.
```

Guardrail: `mon cher Player` remains optional and earned.

---

## 10. Thread Marie / Player — End-of-day close

### Function

- End on Marie / shared life.
- Keep J1 soft but meaningful.
- Show that ordinary presence matters.

### Canon line source

```text
Marie : Pain récupéré.
Marie : Dîner sauvé.
Marie : Les tomates ont l'air soulagées.

Player : elles le cachent bien

Marie : Elles ont de la pudeur.

Player : la marche était bien

Marie : Oui.
Marie : Tu vois.
Marie : Dix minutes dehors, et on redevient presque des gens.

Player : presque

Marie : Je ne veux pas viser trop haut un premier soir 😅

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

Marie : Bien.
Marie : On gardera cette information pour les prochains soirs où tu prétends que le canapé est une destination.
```

### Conditional close if Player was distant

```text
Marie : Tu étais un peu loin ce soir.

Player : je sais

Marie : Je ne te fais pas une scène.
Marie : Je le dis juste maintenant.
Marie : Sinon après je fais comme si je ne l'avais pas vu.

Player : je vais faire mieux

Marie : Ne promets pas mieux.
Marie : Fais un petit truc vrai.
Marie : Ce sera déjà bien.
```

---

## 11. Canon compliance notes

### Marie

Compliant:

- alive before hurt;
- domestic anchors;
- La Verrière color;
- asks for participation, not surveillance;
- no jealousy on J1;
- no Nico / Pauline pressure;
- final beat returns to shared life.

Watch in runtime conversion:

- keep her lively without making every line a punchline;
- preserve ordinary action beats, especially bread / walk / cheese.

### Sandra

Compliant:

- concrete trace first;
- old blurry photo;
- SentryCore / ticket fantôme;
- French `poste` terminology instead of `shift`;
- soft boundary;
- no Jeff exposition on J1;
- no romance-reading exposition;
- no direct route activation.

Watch in runtime conversion:

- do not overuse `officiellement`;
- do not add extra `haha`;
- do not make Sandra available.

### Player

Compliant:

- active but imperfect;
- short replies;
- banal options;
- delayed / flat choices;
- precise Sandra reading possible, but not mandatory;
- return to Marie possible.

Watch in runtime conversion:

- do not let Player become a perfect reader;
- do not let him disappear behind long incoming monologues.

### NSFW canon compatibility

J1 remains Tier 1 / everyday charge only.

Do not add:

- explicit sexual language;
- adult photo reward;
- route lock;
- cheating consequence;
- NTR / sharing / trio seed;
- intense jealousy.

The NSFW canon remains future-route context, not J1 content.

---

## 12. Runtime conversion guidance

Do not integrate directly from V0.64 anymore.

When planning runtime integration, use:

```text
docs/V0_69_J1_Canon_Text_Review_And_Final_Line_Source.md
docs/canon/J1_CANON_SOURCE_PACK.md
docs/canon/characters/MARIE_CANON_FULL.md
docs/canon/characters/SANDRA_CANON_FULL.md
docs/canon/characters/PLAYER_CANON_FULL.md
docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md only as future-route context
```

When converting later:

- keep active J1 threads limited to Marie and Sandra;
- keep Player visible through real replies;
- do not introduce Nico / Pauline / Raphaëlle;
- keep Mathilde indirect only;
- use one Sandra visual trace if scope allows;
- keep choice labels natural / invisible if possible;
- do not create route locks;
- do not create new systems;
- preserve existing validations.

Suggested next step:

```text
V0.70 — J1 Runtime Integration Plan From Canon
```

---

## 13. Final rule

```text
J1 should feel like a real evening where nothing explicit happens yet,
but the player can already feel that attention itself is becoming dangerous.
```
