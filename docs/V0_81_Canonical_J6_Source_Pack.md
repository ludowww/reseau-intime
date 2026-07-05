# V0.81 — Canonical J6 Source Pack

## 0. Statut

Ce document est la **source canonique narrative J6**.

Règle V0.71 appliquée :

```text
Brut narratif validé > JSON runtime.
JSON runtime = implémentation technique fidèle.
Toute divergence doit être auditée avant correction.
```

Ce document ne modifie pas le runtime.
Il définit le texte, le ton, l’ordre émotionnel, les visuels et les garde-fous de J6.

---

## 1. Décision produit : V0.65 rebasé en J6

Le contenu ancien “V0.65 — Reworked J5: Nico Notices Marie” est conservé comme matière narrative, mais il est **rebasé en J6**.

Raison :

```text
J5 est désormais verrouillé comme Marie + Pauline Outing.
J6 devient la retombée sociale de cette sortie.
```

J6 devient donc :

```text
J6 = Nico remarque Marie.
Nico voit ou commente une photo sociale consentie de Marie.
Player découvre qu’un autre homme peut regarder Marie avec désir.
La tension reste légère, sociale, défendable.
```

J6 n’est pas encore :

* un pivot Nico lourd ;
* une rivalité frontale ;
* une route NTR active ;
* une scène de partage assumé ;
* une route sombre ;
* une preuve forte.

J6 est le **premier miroir masculin**.

---

## 2. Intention J6

Après J5, Marie est sortie avec Pauline.
Elle a été vue, photographiée, complimentée, sortie du cadre domestique.

J6 doit faire apparaître une conséquence simple :

```text
Une photo sociale change de sens quand Nico la regarde.
```

Le sujet n’est pas encore “Nico veut Marie”.
Le sujet est plus fin :

```text
Player accepte-t-il que Marie soit désirable pour quelqu’un d’autre ?
Est-ce que ça le rend fier, jaloux, amusé, inquiet, ou complice ?
Est-ce qu’il protège Marie ou est-ce qu’il commence à jouer avec le regard de Nico ?
```

Nico doit rester un ami crédible.
Il plaisante, il chambre, il teste une limite, mais il peut toujours reculer derrière l’humour.

---

## 3. Garde-fous J6

Obligatoire :

* pas de vocal ;
* pas de contenu explicite ;
* pas de photo non consentie ;
* pas de photo intime ;
* pas de proof fort ;
* pas de route lock ;
* pas de NTR actif ;
* pas de harem ;
* pas de Nico manipulateur ;
* pas de demande de photo intime ;
* pas de commentaire vulgaire sur Marie ;
* pas de Pauline active ;
* pas de Mathilde active ;
* pas de Sandra active ;
* pas de Raphaëlle active ;
* pas de groupe large ;
* minimum 3 contenus visuels ;
* emojis sobres et caractérisés ;
* Player envoie toujours ses messages via choix, même les réponses uniques.

---

## 4. Passions / habitudes à maintenir

### Marie

Marie reste :

* gourmande ;
* vivante ;
* drôle ;
* encore amoureuse ;
* sensible au regard de Player ;
* capable d’avoir apprécié sa sortie sans que cela signifie fuir le couple.

Motifs utiles :

* dessert de la veille ;
* tenue / photo sociale ;
* fatigue douce après sortie ;
* envie d’être regardée ;
* plaisir d’avoir respiré ailleurs ;
* retour au couple.

Marie ne doit pas devenir un objet offert au regard de Nico.
Elle reste une personne, absente ou en arrière-plan, dont Player doit respecter le cadre.

---

### Nico

Nico est :

* ami de Player ;
* sportif / pote de verre / humour simple ;
* un peu chambreur ;
* observateur ;
* capable de dire une vérité gênante en plaisantant ;
* pas encore dangereux frontalement.

Motifs utiles :

* verre ;
* sortie entre potes ;
* sport ;
* blague de mec ;
* “je dis ça gentiment” ;
* recul derrière l’humour ;
* test de limite sans insistance lourde.

Nico ne doit pas encore être :

* prédateur ;
* manipulateur ;
* rival assumé ;
* complice sombre ;
* demandeur de contenu intime.

---

### Player

Player doit choisir sa posture face au regard de Nico :

* protéger Marie ;
* rire et laisser passer ;
* être fier ;
* être jaloux ;
* montrer une photo sociale consentie ;
* minimiser ;
* reconnaître que ça lui fait quelque chose.

---

## 5. Structure canonique J6

Ordre canonique :

1. **Marie matin** — retombée douce de la sortie, Marie existe encore dans le souvenir de J5.
2. **Nico midi** — Nico remarque Marie, blague, teste la réaction de Player.
3. **Nico fin d’après-midi** — selon la posture, Nico recule, plaisante ou ouvre une première confidence.
4. **Marie soir** — recentrage : Player peut garder pour lui, dire partiellement, ou transformer le compliment de Nico en regard tendre vers Marie.

J6 reste focalisé :

```text
Marie comme centre.
Nico comme miroir.
Player comme filtre moral.
```

Pauline, Mathilde, Sandra et Raphaëlle ne sont pas actives.

---

## 6. Visuels canoniques J6

### 6.1 `marie_j6_after_outing_soft_trace_placeholder`

Photo envoyée par Marie : détail du lendemain de sortie — ticket, boucle d’oreille posée, tasse, reste de dessert ou vêtement plié.
Pas de corps suggestif.

Fonction :

* rappeler J5 sans refaire la sortie ;
* montrer que Marie a vécu quelque chose hors maison ;
* garder la trace douce et consentie.

Statut :

* `is_proof: false`
* `risk_level: 1`

---

### 6.2 `j6_marie_social_photo_reframed_placeholder`

Reprise / miniature d’une photo sociale consentie de J5, montrable et défendable.
Elle peut être un selfie Marie + Pauline ou une photo où Marie est jolie mais non intime.

Fonction :

* permettre à Nico de remarquer Marie ;
* montrer qu’une photo sociale change de sens selon le regard ;
* ne pas créer de faute automatique.

Statut :

* `is_proof: false`
* `risk_level: 1`

---

### 6.3 `nico_j6_glass_social_context_placeholder`

Photo envoyée par Nico : verre, café, table de bar, sac de sport, banc extérieur ou contexte pote.
Nico existe socialement sans être réduit à une ligne de texte.

Fonction :

* installer Nico comme ami réel ;
* préparer l’idée d’un futur verre entre hommes ;
* rester neutre.

Statut :

* `is_proof: false`
* `risk_level: 1`

---

### 6.4 `j6_nico_chat_trace_placeholder`

Trace visuelle de la conversation Nico : aperçu stylisé / capture neutre d’un compliment léger sur Marie.
Pas une preuve forte. Pas un contenu compromettant.

Fonction :

* matérialiser que le regard de Nico existe ;
* créer une trace faible, défendable, non exploitable comme chantage.

Statut :

* `is_proof: false`
* `risk_level: 1`

---

# Conversation 1 — Marie matin

## ID cible

`chapter_06_marie_morning_after_outing`

## Moment

Matin.
Player n’est pas physiquement avec Marie : trajet, travail ou pause extérieure.

## Titre

Jour 6 — Le lendemain du dessert

## Intention

Marie revient doucement sur la sortie J5.
Elle n’est pas en crise.
Elle a aimé sortir, mais elle revient vers Player.

Cette scène rappelle que Marie reste le centre affectif avant que Nico ne commente son image.

---

## Segment 1 — Réveil doux

**Marie :**
Je confirme officiellement.

**Marie :**
Le dessert d’hier était une bonne décision.

**Marie :**
Même ce matin, je maintiens.

**Player — guidé :**
Je respecte ce courage.

**Marie :**
Merci.

**Marie :**
Il faut parfois défendre ses choix importants.

**Marie :**
Même quand ils contiennent beaucoup de sucre.

---

## Segment 2 — Trace visuelle

**Marie :**
J’ai retrouvé le ticket dans ma poche.

**Marie :**
Et une boucle d’oreille sur la table.

**Marie :**
Je crois que je suis rentrée entière, mais légèrement dispersée.

**Marie :**
Photo envoyée.
`content_id: marie_j6_after_outing_soft_trace_placeholder`

### Choix Player

**A — tendre**
J’aime bien ces traces-là.

**Marie :**
Oui ?

**Marie :**
Moi aussi.

**Marie :**
Ça fait moins “désordre” quand tu dis “trace”.

---

**B — joueur**
Le dessert a donc laissé des preuves.

**Marie :**
Des traces.

**Marie :**
Pas des preuves.

**Marie :**
Je refuse le vocabulaire policier pour un dessert.

---

**C — amoureux**
J’ai aimé te voir sortir comme ça.

**Marie :**
Ça me fait encore un petit truc de lire ça.

**Marie :**
Un bon petit truc.

**Marie :**
Mais je vais rester digne.

---

**D — prudent**
Tu avais l’air bien. Je ne veux pas trop analyser.

**Marie :**
C’est bien aussi.

**Marie :**
Tout n’a pas besoin d’être démonté pour être vrai.

---

## Segment 3 — Fermer sans fermer

**Marie :**
Pauline m’a écrit ce matin : “tu vois, tu as survécu”.

**Marie :**
Elle est insupportable.

**Marie :**
Mais utile.

**Player — guidé :**
C’est une compétence rare.

**Marie :**
Oui.

**Marie :**
Ne lui dis pas.

**Marie :**
Elle deviendrait impossible.

---

## Segment 4 — Fin

**Marie :**
Je te laisse travailler.

**Marie :**
Ou faire semblant.

**Player — guidé :**
Je vais faire une version crédible.

**Marie :**
Bonne chance.

**Marie :**
Et merci encore de m’avoir regardée hier.

---

# Conversation 2 — Nico midi

## ID cible

`chapter_06_nico_midday_notices_marie`

## Moment

Midi.
Nico écrit à Player.
Marie n’est pas dans la conversation.

## Titre

Jour 6 — T’as de la chance

## Intention

Nico entre comme ami masculin / miroir.
Il a vu ou entendu parler de la sortie J5.
Il remarque Marie, mais reste léger.

Il ne doit pas être vulgaire.
Il ne doit pas demander une photo intime.
Il ne doit pas devenir rival.

---

## Segment 1 — Nico ouvre

**Nico :**
Alors.

**Nico :**
Elle a survécu à sa sortie, madame ?

**Nico :**
Pauline ne l’a pas ramenée socialement irréparable ?

**Player — guidé :**
Elle a survécu. Le dessert, moins.

**Nico :**
Classique.

**Nico :**
Les desserts sont les vraies victimes des soirées réussies.

---

## Segment 2 — Contexte Nico

**Nico :**
Moi je suis sur un café qui essaie de me convaincre qu’il est bon.

**Nico :**
Photo envoyée.
`content_id: nico_j6_glass_social_context_placeholder`

**Nico :**
Je pense qu’il ment.

### Choix Player

**A — léger**
Tu as toujours eu une relation compliquée avec les cafés.

**Nico :**
Faux.

**Nico :**
J’ai une relation exigeante.

**Nico :**
C’est eux qui ne font pas l’effort.

---

**B — pote**
Tu aurais dû prendre un verre, c’était plus honnête.

**Nico :**
Midi.

**Nico :**
Mais j’apprécie l’ambition.

---

**C — direct**
Tu m’écris vraiment pour parler café ?

**Nico :**
Non.

**Nico :**
Mais je voulais une entrée élégante.

**Nico :**
C’est raté, visiblement.

---

## Segment 3 — Nico remarque Marie

**Nico :**
J’ai vu passer une photo de Marie.

**Nico :**
Enfin, une photo sociale hein.

**Nico :**
Rien d’espionnage.

**Nico :**
Elle avait l’air bien.

**Player — guidé :**
Oui, elle était bien.

**Nico :**
Franchement, t’as de la chance.

**Nico :**
Je dis ça gentiment 😅

### Choix Player

**A — recadrer doux**
Tu peux la trouver jolie, mais reste correct.

**Nico :**
Bien reçu.

**Nico :**
Sujet sensible.

**Nico :**
Je chambre, mais je reste correct.

**Nico :**
Promis.

---

**B — rire et laisser passer**
Je sais. Mais évite de prendre trop confiance.

**Nico :**
Ah.

**Nico :**
Donc j’ai le droit de dire que t’as de la chance.

**Nico :**
Mais pas de faire un PowerPoint.

**Nico :**
Je note.

---

**C — être fier**
Oui, elle était belle hier. Ça m’a fait quelque chose.

**Nico :**
Voilà.

**Nico :**
Ça, c’est honnête.

**Nico :**
C’est pas tous les jours qu’un mec sait dire ça sans devenir bizarre.

---

**D — jalousie légère**
Parle pas trop d’elle comme ça.

**Nico :**
Ok.

**Nico :**
Je recule de deux mètres.

**Nico :**
Virtuellement.

**Nico :**
Je voulais pas appuyer trop fort.

---

**E — photo sociale**
Je peux te montrer une photo sociale. Rien d’intime.

**Nico :**
Carré.

**Nico :**
Social, ça veut dire social.

**Nico :**
Je sais lire une limite.

**Nico :**
Enfin, la plupart du temps.

---

## Segment 4 — Si choix E / photo sociale

**Player — guidé :**
Celle-là. Elle l’avait validée.

**Système :**
Photo affichée.
`content_id: j6_marie_social_photo_reframed_placeholder`

**Nico :**
Oui.

**Nico :**
Elle est vraiment bien dessus.

**Nico :**
Et je vais m’arrêter là avant que tu m’envoies une mise en demeure.

**Player — guidé :**
Bonne décision.

**Nico :**
Je suis un homme prudent.

**Nico :**
Par intermittence.

---

## Segment 5 — Trace conversation

**Système :**
Trace visuelle créée.
`content_id: j6_nico_chat_trace_placeholder`

**Nico :**
Plus sérieusement.

**Nico :**
Ça se voit quand quelqu’un respire un peu.

**Nico :**
Elle avait cette tête-là.

**Player — guidé :**
Oui. Je crois que ça lui a fait du bien.

**Nico :**
Alors tant mieux.

**Nico :**
Je chambre, mais c’est pas une mauvaise chose.

---

# Conversation 3 — Nico fin d’après-midi

## ID cible

`chapter_06_nico_late_afternoon_limit`

## Moment

Fin d’après-midi.
Nico revient brièvement selon la tonalité du midi.

## Titre

Jour 6 — Je chambre, détends-toi

## Intention

Clore le premier test de Nico sans escalade.
Nico doit apprendre quelque chose de la posture de Player, mais il ne doit pas encore franchir une limite.

---

## Segment 1 — Retour léger

**Nico :**
Bon.

**Nico :**
Je précise quand même.

**Nico :**
Je chambre, hein.

**Nico :**
Je ne suis pas en train de monter un plan international autour de ta vie de couple.

**Player — guidé :**
Rassurant.

**Nico :**
Je trouve aussi.

**Nico :**
Je suis beaucoup trop désorganisé pour l’international.

---

## Segment 2 — Test de limite

**Nico :**
Mais ça m’a fait marrer de te voir réagir.

**Nico :**
Enfin.

**Nico :**
Façon de parler.

### Choix Player

**A — limite claire**
Marie n’est pas un sujet de jeu pour moi.

**Nico :**
Ok.

**Nico :**
Je respecte.

**Nico :**
Je peux être con, mais pas sourd.

---

**B — complicité légère**
C’était juste bizarre d’entendre quelqu’un d’autre la regarder.

**Nico :**
Ça, je comprends.

**Nico :**
C’est jamais neutre.

**Nico :**
Même quand c’est juste une blague.

---

**C — fierté assumée**
Ça m’a fait bizarre, mais j’étais fier aussi.

**Nico :**
Ça se tient.

**Nico :**
Un peu jaloux, un peu fier.

**Nico :**
Le combo classique du mec amoureux.

---

**D — ouverture prudente**
Je peux en parler tant que ça reste respectueux.

**Nico :**
Ça marche.

**Nico :**
Respectueux, c’est dans mes cordes.

**Nico :**
La plupart du temps.

---

## Segment 3 — Fermeture

**Nico :**
Allez.

**Nico :**
Je te laisse retourner à tes responsabilités d’homme chanceux.

**Player — guidé :**
Merci pour cette analyse.

**Nico :**
Service gratuit.

**Nico :**
Pour l’instant.

---

# Conversation 4 — Marie soir

## ID cible

`chapter_06_marie_evening_recenter`

## Moment

Soir.
Player n’est pas encore physiquement avec Marie ou il est en trajet retour.
La conversation prépare le retour au couple, elle ne remplace pas une scène en présence.

## Titre

Jour 6 — Tu avais l’air ailleurs

## Intention

Recentrer J6 sur Marie.
Player peut garder le compliment de Nico pour lui, le transformer en tendresse, ou être transparent de manière légère.

Marie ne doit pas être humiliée ni mise en scène.
Elle peut sentir que Player la regarde différemment.

---

## Segment 1 — Marie remarque

**Marie :**
Tu avais l’air un peu ailleurs tout à l’heure.

**Marie :**
Pas loin.

**Marie :**
Juste ailleurs de trois centimètres.

**Player — guidé :**
C’est très précis.

**Marie :**
Je suis une scientifique du presque rien.

---

## Segment 2 — Dire ou déplacer

### Choix Player

**A — transparent doux**
Nico a vu une photo de toi. Il a dit que j’avais de la chance.

**Marie :**
Oh.

**Marie :**
D’accord.

**Marie :**
Et toi, tu as répondu quoi ?

**Player — guidé :**
Que oui.

**Marie :**
...

**Marie :**
Bonne réponse.

**Marie :**
Un peu dangereuse, mais bonne.

---

**B — transformer en tendresse**
Je repensais à ta photo d’hier.

**Marie :**
Ah.

**Marie :**
Celle où tu devais me regarder vraiment ?

**Player — guidé :**
Oui.

**Marie :**
Je vois.

**Marie :**
Je ne regrette pas de t’avoir forcé.

---

**C — garder pour soi**
Rien de grave. Juste une journée un peu bizarre.

**Marie :**
D’accord.

**Marie :**
Je prends “bizarre”.

**Marie :**
Mais je garde le droit de redemander plus tard.

---

**D — jalousie tendre**
Je crois que je n’aime pas être le seul à remarquer quand tu es belle.

**Marie :**
Oh.

**Marie :**
C’est possessif.

**Marie :**
Mais dans une version presque mignonne.

**Marie :**
Presque.

---

## Segment 3 — Marie reste sujet, pas objet

**Marie :**
Je ne veux pas devenir un sujet de discussion entre mecs.

**Marie :**
Enfin.

**Marie :**
Pas sans que je sache que j’existe dans la pièce.

**Player — guidé :**
Je comprends.

**Marie :**
Bien.

**Marie :**
Tu peux être fier de moi.

**Marie :**
Ou jaloux.

**Marie :**
Ou les deux, si tu veux faire compliqué.

**Marie :**
Mais pas m’utiliser comme une histoire que je ne connais pas.

### Choix Player

**A — rassurer**
Tu ne seras pas une histoire racontée sans toi.

**Marie :**
Merci.

**Marie :**
Ça, c’est important.

---

**B — amoureux**
J’étais surtout content qu’on te voie comme moi je te vois parfois.

**Marie :**
Tu sais que tu peux dire des choses très injustes ?

**Marie :**
Là, par exemple.

**Marie :**
Je suis censée répondre comment ?

---

**C — léger**
Je vais créer un comité de validation avant toute discussion sur toi.

**Marie :**
Très bien.

**Marie :**
Je serai présidente.

**Marie :**
Et probablement très sévère.

---

## Segment 4 — Fermeture

**Marie :**
Tu rentres bientôt ?

**Player — guidé :**
Oui.

**Marie :**
Alors on en reparlera peut-être en vrai.

**Marie :**
Ou on mangera un truc.

**Marie :**
Les deux options ont du mérite.

**Player — guidé :**
J’arrive.

**Marie :**
Bien.

**Marie :**
Et pour information, je vote pour “manger un truc”.

---

## 7. Décision produit J6

J6 est le premier jour où Nico remarque Marie.

Il doit installer :

* Nico comme miroir masculin ;
* la première jalousie indirecte autour de Marie ;
* la possibilité future de confidence masculine ;
* la possibilité future de rivalité ou de partage soft ;
* la règle morale : Marie ne doit pas devenir un objet de discussion sans conscience ni respect.

J6 ne doit pas installer :

* NTR actif ;
* manipulation ;
* photo intime ;
* proof fort ;
* route lock ;
* Nico rival frontal ;
* Marie humiliée ;
* Pauline active ;
* Mathilde active ;
* Sandra active ;
* Raphaëlle active.

---

## 8. Conséquences possibles

### Si Player recadre Nico

Nico note la limite.
Marie reste protégée.
La route Nico reste au stade ami / miroir léger.

### Si Player rit

Nico comprend qu’il peut plaisanter.
La tension reste légère.

### Si Player est fier

Nico devient un confident potentiel.
Player assume que Marie peut être regardée sans être trahie.

### Si Player montre une photo sociale

Une première image a été partagée avec Nico.
Elle reste consentie et défendable, mais peut devenir une dette douce plus tard.

### Si Player est jaloux

Nico comprend que Marie est un point sensible.
Une future rivalité peut naître si Nico insiste.

---

## 9. Projection J6 → J12

Projection recommandée :

```text
J6 : Nico remarque Marie, premier miroir masculin.
J7 : conséquence domestique ou amicale de la réaction de Player ; Nico peut reculer, plaisanter ou devenir confident.
J8 : deuxième sortie Marie / Pauline / Mathilde, type piscine / spa / plage / sauna soft.
J9 : Sandra revient avec plus de poids émotionnel.
J10 : première bifurcation de cadre : transparence, secret, ouverture, jalousie, fuite.
J11 : coût social ou preuve faible.
J12 : orientation forte possible, sans lock définitif obligatoire.
```

J6 prépare les routes futures.
Il ne les verrouille pas.

---

## 10. Verdict J6 canonique

J6 doit finir avec cette impression :

```text
Nico a vu Marie.
Player a senti que ce regard lui faisait quelque chose.
Marie reste respectée.
Rien n’est encore dangereux.
Mais le désir n’est plus seulement dans le couple : il commence à circuler dans le regard des autres.
```
