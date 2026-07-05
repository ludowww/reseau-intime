# V0.77 — Canonical J5 Source Pack

## 0. Statut

Ce document est la **source canonique narrative J5**.

Règle V0.71 appliquée :

```text id="2k6eso"
Brut narratif validé > JSON runtime.
JSON runtime = implémentation technique fidèle.
Toute divergence doit être auditée avant correction.
```

Ce document ne modifie pas le runtime.
Il définit le texte, le ton, l’ordre émotionnel, les visuels et les garde-fous de J5.

---

## 1. Décision produit : J5 récupère V0.64b

Le contenu V0.64b “Marie & Pauline Outing” est conservé comme base, mais il est déplacé en J5.

J4 a été redéfini comme :

```text id="d3orai"
J4 = lendemain domestique post-Mathilde.
```

J5 devient donc :

```text id="8zx6b9"
J5 = première sortie Marie + Pauline.
Marie redevient visible hors de la maison.
Pauline apparaît comme énergie sociale, pas encore comme menace.
Player regarde Marie autrement parce qu’elle existe ailleurs que dans le quotidien domestique.
```

J5 n’est pas une journée de preuve forte.
J5 n’est pas une soirée panel.
J5 n’est pas une activation Nico / Mathilde / Sandra / Raphaëlle.

---

## 2. Intention J5

J5 doit faire respirer Marie hors de la maison.

Après J3 et J4, la maison a porté :

* Mathilde ;
* l’araignée ;
* le secret léger ;
* la transparence ou l’esquive ;
* la fatigue domestique.

J5 ouvre une autre respiration :

```text id="kxqob6"
Marie sort.
Pauline l’accompagne.
Player n’est pas là.
Le téléphone devient une fenêtre sur Marie visible, vivante, jolie, sociale.
```

L’enjeu n’est pas encore la jalousie lourde.
L’enjeu est plus doux :

* Player regarde-t-il Marie avec désir ?
* Lui laisse-t-il de l’espace ?
* Sait-il être présent sans contrôler ?
* Pauline aide-t-elle Marie à respirer ?
* Les photos restent-elles des souvenirs consentis ou deviennent-elles déjà des traces que Player surinvestit ?

---

## 3. Garde-fous J5

Obligatoire :

* pas de vocal ;
* pas de contenu explicite ;
* pas de photo non consentie ;
* pas de proof fort ;
* pas de route lock ;
* pas de Nico actif ;
* pas de Mathilde active ;
* pas de Sandra active ;
* pas de Raphaëlle active ;
* pas de panel ;
* pas de groupe large ;
* pas de NTR ;
* pas de harem ;
* pas de Pauline manipulatrice ;
* pas de Pauline qui parle comme si elle contrôlait déjà des preuves ;
* pas de messages Marie / Player quand ils sont physiquement ensemble ;
* minimum 3 contenus visuels ;
* emojis sobres et caractérisés ;
* Player envoie toujours ses messages via choix, même les réponses uniques.

---

## 4. Passions / habitudes à maintenir

### Marie

Marie doit rester :

* gourmande ;
* drôle ;
* vivante ;
* encore amoureuse ;
* sensible au regard de Player ;
* capable d’avoir envie de sortir sans que cela signifie fuir le couple.

Motifs utiles :

* tenue ;
* biscuits / verre / dessert ;
* “petit danger” ironique ;
* envie d’être regardée ;
* besoin de ne pas être seulement la personne qui tient la maison ;
* sensations fortes miniatures : sortir, se laisser entraîner, être vue.

Marie ne doit pas devenir uniquement fragile, jalouse ou victime.

---

### Pauline

Pauline doit être :

* vive ;
* sociale ;
* complice ;
* un peu taquine ;
* protectrice à sa manière ;
* liée à Marie ;
* capable de prendre des photos, mais sans devenir inquiétante.

Motifs utiles :

* danse ;
* sorties ;
* terrasse ;
* photos validées ;
* cocooning social ;
* énergie “je l’embarque prendre l’air” ;
* humour léger envers Player.

Pauline ne doit pas encore être :

* manipulatrice ;
* trop provocatrice ;
* trop consciente de “tenir une preuve” ;
* trop dominante ;
* sexualisée comme route active.

---

### Player

Player doit être placé face à un regard simple :

```text id="lvx8mg"
Marie est belle ailleurs que dans la maison.
Est-ce qu’il la regarde, la soutient, la contrôle, ou se sent déjà menacé ?
```

---

## 5. Structure canonique J5

Ordre canonique :

1. **Pauline fin de matinée** — elle annonce qu’elle embarque Marie ce soir.
2. **Marie fin d’après-midi** — photo avant sortie, demande de regard.
3. **Groupe Marie + Pauline début de soirée** — arrivée, selfie, terrasse.
4. **Marie retour / trajet** — petit message avant de rentrer, recentrage doux du couple.

J5 reste focalisé :

```text id="jd12dr"
Marie + Pauline + Player à distance.
```

Les autres personnages ne sont pas actifs.

---

## 6. Visuels canoniques J5

### 6.1 `marie_j5_outfit_before_outing_placeholder`

Photo envoyée par Marie avant de partir.
Elle est prête ou presque prête, cadrage miroir ou tenue simple.
La photo est jolie, consentie, douce, non explicite.

Fonction :

* Marie demande le regard de Player ;
* Player peut être tendre, joueur, jaloux léger ou rassurant ;
* Marie existe comme femme désirée, pas seulement comme centre domestique.

Statut :

* `is_proof: false`
* `risk_level: 1`

---

### 6.2 `marie_pauline_j5_selfie_placeholder`

Selfie Marie + Pauline en début de sortie.
Marie sourit sans trop poser. Pauline est vive, contente de l’avoir entraînée dehors.

Fonction :

* rendre Marie visible hors maison ;
* introduire Pauline socialement ;
* installer une image consentie et défendable.

Statut :

* `is_proof: false`
* `risk_level: 1`

---

### 6.3 `j5_terrace_evening_placeholder`

Photo de terrasse : table, verre, lumière de début de soirée, dessert ou petite assiette.
Pas de corps suggestif.

Fonction :

* ancrer la sortie ;
* rappeler la gourmandise de Marie ;
* montrer que Marie respire ailleurs.

Statut :

* `is_proof: false`
* `risk_level: 1`

---

### 6.4 `pauline_j5_social_smile_placeholder`

Photo ou fragment où Pauline apparaît comme présence sociale : sourire sûr, énergie vive, cadrage simple.
L’image sert à installer Pauline comme amie de Marie, pas comme provocation.

Fonction :

* donner une texture à Pauline ;
* préparer son retour futur ;
* ne pas la transformer en menace.

Statut :

* `is_proof: false`
* `risk_level: 1`

---

# Conversation 1 — Pauline fin de matinée

## ID cible

`chapter_05_pauline_late_morning`

## Moment

Fin de matinée.
Player n’est pas avec Pauline.
Marie n’est pas dans la conversation.

## Titre

Jour 5 — Je l’embarque prendre l’air

## Intention

Première vraie présence directe de Pauline.

Elle annonce qu’elle va sortir avec Marie.
Elle doit sembler vive, sociale, bienveillante, un peu taquine.
Elle ne doit pas sembler manipulatrice.

---

## Segment 1 — Ouverture

**Pauline :**
Coucou 🙂

**Pauline :**
Je t’écris avant que Marie parte.

**Player — guidé :**
Ça sonne comme une annonce officielle.

**Pauline :**
Un peu.

**Pauline :**
Mais une annonce douce.

**Pauline :**
Je l’embarque prendre l’air ce soir.

---

## Segment 2 — La sortie

**Pauline :**
Rien de fou.

**Pauline :**
Un verre, une terrasse, et une tentative de lui faire oublier la maison deux heures.

**Pauline :**
Elle fait semblant de râler.

**Pauline :**
Donc je considère qu’elle est presque prête.

### Choix Player

**A — tendre**
Je veux bien la voir avant qu’elle parte.

**Pauline :**
Je lui dirai.

**Pauline :**
Elle fera semblant de râler aussi.

**Pauline :**
Mais je pense que ça lui fera plaisir.

---

**B — curieux**
Vous allez où ?

**Pauline :**
Pas loin.

**Pauline :**
Une terrasse tranquille.

**Pauline :**
Le genre d’endroit où elle peut respirer sans se demander si tout est à sa place.

---

**C — confiance**
Je te fais confiance pour la faire sourire.

**Pauline :**
Ah, la pression.

**Pauline :**
Mais j’accepte.

**Pauline :**
Je vais essayer de ne pas trop l’épuiser socialement 😅

---

**D — jalousie légère**
Je dois m’inquiéter si elle s’amuse trop sans moi ?

**Pauline :**
Un peu.

**Pauline :**
Mais élégamment.

**Pauline :**
Tu as le droit d’être jaloux.

**Pauline :**
Pas de devenir pénible.

---

## Segment 3 — Photos

**Pauline :**
Je t’enverrai peut-être une photo si elle valide.

**Pauline :**
Pas de dossier compromettant, promis.

**Pauline :**
Juste la preuve qu’elle est sortie 🙂

**Player — guidé :**
Ça me va.

**Pauline :**
Parfait.

**Pauline :**
Je compte sur toi pour ne pas lui envoyer dix messages de contrôle.

### Choix Player

**A — léger**
Je vais essayer de rester digne.

**Pauline :**
C’est déjà beaucoup demander.

**Pauline :**
Mais j’encourage l’effort.

---

**B — sincère**
Je suis content qu’elle sorte un peu.

**Pauline :**
Elle en a besoin.

**Pauline :**
Pas pour fuir.

**Pauline :**
Juste pour redevenir un peu légère.

---

**C — taquin**
Si elle sourit, je prends une partie du crédit.

**Pauline :**
Non.

**Pauline :**
Si elle sourit, je prends le crédit.

**Pauline :**
Si elle râle, je te laisse gérer.

---

## Segment 4 — Fermeture

**Pauline :**
Je te tiens au courant.

**Pauline :**
Enfin, raisonnablement.

**Pauline :**
On sort, on ne lance pas une cellule de crise.

**Player — guidé :**
Compris.

**Pauline :**
Bien.

**Pauline :**
À plus tard, alors.

---

# Conversation 2 — Marie fin d’après-midi

## ID cible

`chapter_05_marie_before_outing`

## Moment

Fin d’après-midi.
Marie est chez elle ou en train de se préparer.
Player n’est pas physiquement avec elle.

## Titre

Jour 5 — Regarde vraiment

## Intention

Marie envoie une photo avant de sortir.
Elle ne demande pas seulement un avis de tenue : elle demande le regard de Player.

La scène doit recentrer Marie comme femme désirée.

---

## Segment 1 — Préparation

**Marie :**
J’ai besoin d’un avis.

**Marie :**
Avant que Pauline débarque et décide que “ça va très bien” même si je porte un sac poubelle.

**Player — guidé :**
Je prends cette responsabilité très au sérieux.

**Marie :**
J’espère bien.

**Marie :**
C’est un poste à haute pression.

---

## Segment 2 — Photo tenue

**Marie :**
Je t’envoie une photo avant de partir.

**Marie :**
Comme ça tu dois me regarder vraiment.

**Marie :**
Photo envoyée.
`content_id: marie_j5_outfit_before_outing_placeholder`

**Marie :**
Dis-moi franchement.

**Marie :**
Mais gentiment.

### Choix Player

**A — tendre**
Tu es belle, Marie.

**Marie :**
...

**Marie :**
D’accord.

**Marie :**
Je voulais un avis, pas forcément une attaque directe au cœur.

**Marie :**
Mais je prends.

---

**B — désir doux**
Ça te va vraiment bien. Je regrette presque de ne pas venir.

**Marie :**
Presque ?

**Marie :**
Je note le manque d’engagement dramatique.

**Marie :**
Mais je souris quand même.

---

**C — joueur**
Je valide. Même le sac poubelle aurait eu une chance, mais là c’est mieux.

**Marie :**
Merci pour cette déclaration très raffinée.

**Marie :**
Je vais l’imprimer.

**Marie :**
Ou la nier.

---

**D — jalousie légère**
Tu vas attirer des regards.

**Marie :**
Peut-être.

**Marie :**
Mais c’est toi que je viens de forcer à regarder.

**Marie :**
Donc je considère que la priorité est respectée.

---

## Segment 3 — Sortir vraiment

**Marie :**
Ça me fait bizarre de sortir comme ça.

**Marie :**
Pas bizarre mauvais.

**Marie :**
Juste...

**Marie :**
Comme si j’avais oublié que je pouvais être ailleurs que dans la maison.

### Choix Player

**A — soutien**
Ça va te faire du bien.

**Marie :**
Oui.

**Marie :**
Je crois.

**Marie :**
Et j’aime que tu le dises sans faire semblant que ça ne te fait rien.

---

**B — amoureux**
J’aime te voir exister ailleurs aussi.

**Marie :**
Oh.

**Marie :**
Tu sais que c’est dangereux, ce genre de phrase ?

**Marie :**
Je pourrais sortir plus souvent.

---

**C — possessif doux**
Reviens quand même vers moi après.

**Marie :**
Ça, oui.

**Marie :**
Je peux sortir.

**Marie :**
Je peux même rire dehors.

**Marie :**
Mais je rentre.

---

**D — prudent**
Je veux juste que tu sois bien.

**Marie :**
C’est déjà beaucoup.

**Marie :**
Et c’est peut-être exactement ce qu’il faut.

---

## Segment 4 — Fermeture

**Marie :**
Pauline vient de dire “j’arrive” avec trois points d’exclamation.

**Marie :**
Je crois que je n’ai plus le choix.

**Player — guidé :**
Amuse-toi.

**Marie :**
Je vais essayer.

**Marie :**
Et je vais essayer de ne pas renverser quelque chose dans les dix premières minutes 😅

---

# Conversation 3 — Groupe Marie + Pauline début de soirée

## ID cible

`chapter_05_marie_pauline_outing_group`

## Moment

Début de soirée.
Marie et Pauline sont dehors.
Player n’est pas avec elles.

## Titre

Jour 5 — Elle est bien sortie

## Intention

La scène montre Marie dehors.
Pauline reste complice, sociale, non manipulatrice.
Player reçoit des photos consenties.

---

## Segment 1 — Arrivée

**Pauline :**
On est arrivées 🙂

**Marie :**
Je confirme.

**Marie :**
Je suis dehors.

**Pauline :**
C’est dit comme une survivante.

**Marie :**
Je découvre un monde avec du bruit et des chaises bancales.

**Marie :**
C’est intense.

**Player — guidé :**
Je suis fier de toi.

**Marie :**
Moque-toi.

**Marie :**
Mais doucement.

---

## Segment 2 — Selfie

**Pauline :**
Preuve visuelle.

**Marie :**
Validée par moi.

**Pauline :**
Je précise avant qu’on m’accuse de journalisme sauvage.

**Pauline :**
Photo envoyée.
`content_id: marie_pauline_j5_selfie_placeholder`

### Choix Player

**A — tendre**
Vous êtes très belles toutes les deux.

**Marie :**
Oh.

**Marie :**
Ça, je garde 🙂

**Pauline :**
Je note : compliment validé.

---

**B — centré Marie**
Marie, tu as l’air vraiment bien.

**Marie :**
Oui.

**Marie :**
Je crois que ça me fait du bien.

**Pauline :**
C’était l’idée.

---

**C — léger Pauline**
Pauline, tu la fais rire exprès ?

**Pauline :**
J’essaie.

**Pauline :**
Mais elle résiste bien.

**Marie :**
Je confirme.

**Marie :**
Je ne suis pas si facile à distraire 😅

---

**D — jalousie douce**
Je vois que je suis remplacé par une terrasse et Pauline.

**Marie :**
Temporairement.

**Pauline :**
La terrasse a de bons arguments.

**Marie :**
Mais elle ne sait pas où sont les biscuits à la maison.

**Marie :**
Donc tu gardes une avance.

---

## Segment 3 — Terrasse

**Pauline :**
Voilà l’environnement hostile.

**Pauline :**
Photo envoyée.
`content_id: j5_terrace_evening_placeholder`

**Marie :**
Il y a un dessert qui me regarde depuis la carte.

**Pauline :**
Elle a dit ça très sérieusement.

**Marie :**
Parce que c’est sérieux.

### Choix Player

**A — gourmand**
Prends le dessert. Je soutiens cette décision.

**Marie :**
Voilà.

**Marie :**
Un partenaire fiable.

**Pauline :**
Je note aussi : influence gourmande acceptée.

---

**B — taquin**
Le dessert n’a aucune chance contre toi.

**Marie :**
Tu me connais trop.

**Marie :**
C’est inquiétant.

**Pauline :**
Ou pratique.

---

**C — attentif**
Tu as l’air plus légère.

**Marie :**
Je crois que je le suis un peu.

**Marie :**
Pas complètement.

**Marie :**
Mais un peu.

**Pauline :**
Un peu, c’est déjà une victoire.

---

## Segment 4 — Pauline visible

**Pauline :**
Marie menace de commander le dessert “pour deux”.

**Marie :**
Je n’ai jamais dit que j’étais seule dans cette décision.

**Pauline :**
Je suis témoin.

**Pauline :**
Et peut-être complice.

**Pauline :**
Photo envoyée.
`content_id: pauline_j5_social_smile_placeholder`

**Pauline :**
Je précise : photo autorisée.

**Marie :**
Elle a demandé.

**Marie :**
J’ai dit oui parce qu’elle avait l’air beaucoup trop fière d’elle.

### Choix Player

**A — social doux**
Vous avez l’air de passer une bonne soirée.

**Marie :**
Oui.

**Marie :**
Je crois que oui.

**Pauline :**
Réponse officielle : oui.

---

**B — centré couple**
Je suis content de te voir comme ça, Marie.

**Marie :**
Ça me touche.

**Marie :**
Plus que je ne vais l’admettre devant Pauline.

**Pauline :**
Trop tard.

**Pauline :**
J’ai vu.

---

**C — taquin Pauline**
Pauline, tu prends ton rôle très au sérieux.

**Pauline :**
Complètement.

**Pauline :**
Mais avec élégance.

**Marie :**
Elle dit ça depuis qu’elle a failli renverser la carte.

---

## Segment 5 — Fermeture de groupe

**Pauline :**
Je vais lui rendre son téléphone.

**Marie :**
Tu ne me l’avais pas pris.

**Pauline :**
Mentalement, si.

**Marie :**
C’est inquiétant.

**Pauline :**
C’est amical.

**Player — guidé :**
Profitez.

**Marie :**
On va essayer.

**Pauline :**
Elle dit ça, mais elle sourit.

---

# Conversation 4 — Marie retour / trajet

## ID cible

`chapter_05_marie_return_message`

## Moment

Fin de soirée.
Marie est en trajet retour ou juste avant de rentrer.
Player n’est pas physiquement avec elle au moment du message.

## Titre

Jour 5 — Je rentre

## Intention

Recentrer la journée sur le couple.
Marie a été dehors, visible, vivante. Elle revient vers Player.

La scène ne doit pas devenir une dispute ni une preuve.
Elle doit faire sentir que sortir ne retire pas Marie au couple, mais change légèrement le regard de Player.

---

## Segment 1 — Retour

**Marie :**
Je rentre.

**Marie :**
Pauline dit que j’ai “tenu très honorablement”.

**Marie :**
Je ne sais pas ce que ça veut dire.

**Player — guidé :**
Ça veut dire que tu as survécu à la terrasse.

**Marie :**
Exactement.

**Marie :**
Et au dessert.

**Marie :**
Enfin, le dessert n’a pas survécu, lui.

---

## Segment 2 — Ressenti

**Marie :**
Ça m’a fait du bien.

**Marie :**
Je crois que j’avais besoin de sortir sans que ce soit un grand sujet.

### Choix Player

**A — tendre**
J’ai aimé te voir comme ça.

**Marie :**
Moi aussi.

**Marie :**
Enfin.

**Marie :**
J’ai aimé que tu me voies comme ça.

---

**B — honnête**
Ça m’a fait un peu bizarre, mais dans le bon sens.

**Marie :**
Je comprends.

**Marie :**
Je crois que moi aussi.

**Marie :**
C’est peut-être normal.

---

**C — possessif doux**
Je suis content que tu rentres.

**Marie :**
Je rentre.

**Marie :**
Et je souris en lisant ça.

**Marie :**
Ce qui est un peu agaçant, mais agréable.

---

**D — prudent**
Je ne veux pas que tu te sentes obligée de tout me raconter.

**Marie :**
Merci.

**Marie :**
Mais j’ai envie de t’en raconter un peu.

**Marie :**
Pas par devoir.

**Marie :**
Parce que c’était ma soirée, et que tu comptes dedans.

---

## Segment 3 — Téléphone posé

**Marie :**
Je vais bientôt arriver.

**Marie :**
Quand je rentre, on ne continue pas par messages.

**Marie :**
Tu me raconteras ta journée en vrai.

**Player — guidé :**
Je poserai le téléphone.

**Marie :**
Phrase historique, épisode deux 🙂

**Marie :**
À tout de suite.

---

## 7. Décision produit J5

J5 est la première journée de visibilité sociale de Marie.

Elle doit installer :

* Marie hors de la maison ;
* Pauline comme présence sociale douce ;
* des photos consenties ;
* Player qui regarde Marie avec désir, tendresse ou jalousie légère ;
* aucune preuve forte ;
* aucun panel ;
* aucune activation Nico / Mathilde / Sandra / Raphaëlle.

---

## 8. Projection J5 → J12

J5 ne clôt rien.
Il prépare la montée sociale sans brûler les étapes.

Projection recommandée :

```text id="hk9mky"
J5 : Marie + Pauline outing, visibilité sociale consentie.
J6 : retombée douce des photos, première trace sociale réinterprétée.
J7 : Nico miroir léger ou mention sociale indirecte.
J8 : deuxième sortie Marie / Pauline / Mathilde, type piscine / spa / plage / sauna soft.
J9 : Sandra revient avec plus de poids émotionnel.
J10 : première bifurcation de cadre : transparence, secret, ouverture, jalousie, fuite.
J11 : coût social ou preuve faible.
J12 : orientation forte possible, sans lock définitif obligatoire.
```

---

## 9. Verdict J5 canonique

J5 doit finir avec cette impression :

```text id="ihc5mq"
Marie est sortie.
Pauline l’a aidée à respirer.
Player l’a regardée à distance.
Les photos sont belles, consenties, défendables.
Rien n’est encore dangereux.
Mais Marie existe maintenant aussi hors de la maison, et le regard de Player commence à changer.
```