# V0.72 — Canonical J2 Source Pack

## 0. Statut

Ce document est la **source canonique narrative J2**.

Règle V0.71 appliquée :

```text
Brut narratif validé > JSON runtime.
JSON runtime = implémentation technique fidèle.
Toute divergence doit être auditée avant correction.
```

Ce document ne modifie pas le runtime.
Il sert à figer le texte, le ton, l’ordre émotionnel et les garde-fous J2 avant tout réalignement JSON.

---

## 1. Intention J2

J2 ouvre le monde sans disperser le récit.

Marie reste le centre affectif.
Mathilde devient concrète, sportive, gênée de prendre de la place, mais non sexualisée.
Raphaëlle apparaît comme présence extérieure / pro / utile, liée au travail et au jeu vidéo.
Sandra revient en écho doux, lac / roman / pudeur.
Nico et Pauline restent absents.

J2 doit donner l’impression que la maison change, mais pas que les routes explosent.

---

## 2. Garde-fous J2

Obligatoire :

* pas de vocal ;
* pas de contenu explicite ;
* pas de photo non consentie ;
* pas de route lock ;
* pas Nico actif ;
* pas Pauline active ;
* pas de groupe actif ;
* Player envoie toujours ses messages via choix, même les réponses uniques ;
* Mathilde reste non sexualisée ;
* Raphaëlle ne devient pas refuge romantique ;
* Sandra reste distante, pudique, émotionnelle ;
* Marie reste aimante, vivante, drôle, gourmande, pas seulement fragile.

---

## 3. Structure canonique J2

Ordre canonique :

1. Marie matin — petit-déjeuner, biscuits, arrivée de Mathilde.
2. Raphaëlle midi — outil / jeu narratif, extérieur pro.
3. Marie fin d’après-midi — Mathilde est là, maison déplacée.
4. Mathilde début de soirée — arrivée directe, sacs, sport, gêne.
5. Sandra soir — lac, roman, tomates, écho doux.
6. Marie fin de journée — Mathilde reste dormir, Marie garde le centre.
7. Mathilde fin de journée privée — clarification douce, canapé / installation, pas de pivot.

Les scènes 6 et 7 sont une **extension douce**.
Elles ne doivent pas être lues comme le vrai pivot Mathilde.
Le premier vrai pivot Mathilde reste J3.

---

## 4. Visuels canoniques J2

### 4.1 `marie_j2_morning_soft_placeholder`

Photo domestique envoyée par Marie le matin : café, biscuits, petit-déjeuner improvisé.
Fonction : ancrer Marie comme centre quotidien, gourmand, vivant.

Statut :

* `is_proof: false`
* `risk_level: 1`

### 4.2 `raphaelle_j2_work_badge_placeholder`

Capture / image liée à une recommandation d’outil ou de petit jeu narratif.
Fonction : Raphaëlle aide, partage, reste extérieure/pro.

Statut :

* `is_proof: false`
* `risk_level: 1`

### 4.3 `mathilde_j2_arrival_marie_placeholder`

Photo de l’entrée : sac de sport, baskets, raquette.
Aucun corps, aucune pose.
Fonction : rendre Mathilde concrète par les objets et l’énergie domestique.

Statut :

* `is_proof: false`
* `risk_level: 1`

### 4.4 `mathilde_j2_couch_innocent_selfie_placeholder`

Photo quotidienne et non suggestive : Mathilde installée / fatiguée / canapé / plaid / sac proche.
Fonction : confirmer la présence de Mathilde dans la maison, mais sans tension sexuelle.

Statut :

* `is_proof: false`
* `risk_level: 1`

### 4.5 `sandra_j2_lake_book_soft_placeholder`

Photo douce : lac, banc, livre, roman, lumière calme.
Fonction : Sandra existe à distance, par une trace pudique.

Statut :

* `is_proof: false`
* `risk_level: 1`

---

# Conversation 1 — Marie matin

## ID cible

`chapter_02_marie_morning`

## Titre

Jour 2 — On lui fait une place

## Intention

Marie ouvre J2 depuis le quotidien.
Elle parle d’abord de biscuits et de petit-déjeuner, puis de Mathilde.
Le sujet réel : est-ce que Player est avec elle dans ce changement ?

Marie doit être :

* drôle ;
* tendre ;
* un peu fatiguée ;
* gourmande ;
* aimante ;
* lucide sans être en crise.

---

## Segment 1 — Photo importante

**Marie :**
Tu es réveillé ?

**Marie :**
Je demande avant de t’envoyer une photo de très haute importance.

**Player — guidé :**
Ça dépend du niveau d’importance.

**Marie :**
Domestique.

**Marie :**
Gourmand.

**Marie :**
Donc, très haut.

---

## Segment 2 — Biscuits

**Marie :**
Photo envoyée.

**Marie :**
J’ai officiellement transformé les restes de biscuits en petit-déjeuner.
`content_id: marie_j2_morning_soft_placeholder`

**Marie :**
Je ne suis pas certaine que ce soit recommandé par les nutritionnistes.

**Marie :**
Mais émotionnellement, c’est solide.

### Choix Player

**A — tendre**
Tu as toute ma confiance.

**Marie :**
C’est dangereux.

**Marie :**
Ta confiance m’encourage dans mes pires décisions sucrées.

---

## Segment 3 — Mathilde arrive

**Marie :**
Et dans les autres nouvelles : Mathilde arrive aujourd’hui.

**Marie :**
Elle a écrit “en début d’après-midi”.

**Marie :**
Donc je prévois entre midi et 18h.

### Choix Player

**A — tendre**
On va gérer ça ensemble.

**Marie :**
Tu n’es pas obligé.

**Marie :**
Mais j’aime bien que tu proposes.

**Marie :**
Ça me donne l’impression qu’on ne fait pas juste entrer des sacs dans la maison.

**Marie :**
Qu’on décide vraiment quelque chose à deux.

---

**B — taquin**
Je note : carton + raquette = adrénaline.

**Marie :**
Moque-toi.

**Marie :**
Mais si la raquette tombe au milieu de la nuit, tu iras vérifier.

**Marie :**
Moi je resterai sous la couette avec dignité.

---

**C — sincère**
Je crois que ça va nous faire bizarre.

**Marie :**
Oui.

**Marie :**
C’est un peu ça.

**Marie :**
Je suis contente que tu le dises comme ça.

---

**D — taquin domestique**
Si son sac de sport attaque mes chaussures, je reste neutre.

**Marie :**
Traître.

**Marie :**
Mais je comprends.

**Marie :**
Ses baskets ont l’air plus disciplinées que les tiennes.

**Marie :**
C’est peut-être une bonne influence.

---

**E — prudent / pratique**
Dis-moi juste où il faut mettre ses affaires.

**Marie :**
Oui.

**Marie :**
Je te dirai.

**Marie :**
Mais j’aurais bien aimé que tu demandes aussi comment moi je le vis.

**Marie :**
Enfin.

**Marie :**
Tu peux encore te rattraper.

---

## Segment 4 — Sensations fortes

**Marie :**
Le plus drôle, c’est que je fais semblant d’être dépassée.

**Marie :**
Mais une partie de moi aime bien.

**Player — guidé :**
Que la maison change ?

**Marie :**
Oui.

**Marie :**
Tu sais bien que j’aime quand ça bouge un peu.

**Marie :**
Pas forcément les cartons dans l’entrée.

**Marie :**
Mais l’idée que la journée ne soit pas exactement celle prévue.

**Marie :**
Certaines personnes sautent à l’élastique.

**Marie :**
Moi j’accepte qu’une sportive arrive chez nous avec une raquette et un sac trop grand.

**Marie :**
Chacun son vertige.

### Choix Player

**A — tendre**
J’aime bien quand tu admets que tu aimes ça.

**Marie :**
N’en profite pas.

**Marie :**
Je reste une femme responsable.

**Marie :**
Une femme responsable qui mange des biscuits au petit-déjeuner, mais responsable quand même.

---

**B — taquin**
Je note : carton + raquette = adrénaline.

**Marie :**
Moque-toi.

**Marie :**
Mais si la raquette tombe au milieu de la nuit, tu iras vérifier.

**Marie :**
Moi je resterai sous la couette avec dignité.

---

**C — sincère**
Je crois que ça va nous faire bizarre.

**Marie :**
Oui.

**Marie :**
C’est un peu ça.

**Marie :**
Je suis contente que tu le dises comme ça.

---

## Segment 5 — Fermeture

**Marie :**
Je vais lui préparer un coin.

**Marie :**
Et manger un autre biscuit.

**Marie :**
Parce que visiblement, c’est devenu mon système de gestion émotionnelle.

**Player — guidé :**
C’est un système respectable.

**Marie :**
Merci.

**Marie :**
Je savais que tu comprendrais les priorités.

**Marie :**
Sois gentil si elle t’écrit.

**Marie :**
Elle fait la fille qui gère, mais elle est plus gênée qu’elle veut bien le montrer.

---

# Conversation 2 — Raphaëlle midi

## ID cible

`chapter_02_raphaelle_midday`

## Titre

Jour 2 — Petite recommandation

## Intention

Raphaëlle existe dehors.
Elle n’est pas une romance active.
Elle est utile, calme, précise, liée au travail / outil / jeu vidéo.
Elle aime faire plaisir en trouvant le bon outil.

---

## Segment 1 — Recommandation

**Raphaëlle :**
Salut Player.

**Raphaëlle :**
Je t’envoie ça avant d’oublier.

**Raphaëlle :**
Tu parlais l’autre jour d’un outil simple pour tester des embranchements ?

**Raphaëlle :**
À la base, c’est presque un petit jeu narratif.

**Raphaëlle :**
Mais ça peut aider à visualiser des choix.

**Raphaëlle :**
Capture envoyée.
`content_id: raphaelle_j2_work_badge_placeholder`

**Raphaëlle :**
Ce n’est pas exactement un outil pro.

### Choix Player

**A — pro**
Merci, c’est utile. Je regarderai ça.

**Raphaëlle :**
Parfait.

**Raphaëlle :**
Je me suis dit que ça pouvait te faire gagner du temps.

**Raphaëlle :**
Et j’aime bien quand les choses font gagner du temps aux gens.

---

**B — curieux**
Donc tu fais plaisir aux gens avec des jeux vidéo ?

**Raphaëlle :**
Formulé comme ça, j’ai l’air étrange.

**Raphaëlle :**
Mais oui.

**Raphaëlle :**
J’aime bien trouver le truc qui tombe juste.

**Raphaëlle :**
Même si c’est un jeu.

---

**C — distance pro**
Envoie-moi le lien, je le regarderai quand j’aurai un moment.

**Raphaëlle :**
Bien sûr.

**Raphaëlle :**
Je ne voulais pas t’interrompre.

**Raphaëlle :**
Tu me diras si ça t’aide.

---

## Segment 2 — Jeux vidéo

**Raphaëlle :**
Je sais, c’est très moi de transformer un problème pratique en recommandation de jeu.

### Choix Player

**A — pro léger**
Parfait, j’aime bien les gens utiles.

**Raphaëlle :**
Moi aussi.

**Raphaëlle :**
Surtout quand on peut les aider sans drame.

---

**B — guidé**
Tu joues beaucoup ?

**Raphaëlle :**
Je dis “par périodes” pour que ça semble raisonnable.

**Raphaëlle :**
En vrai, quand j’accroche à un jeu, je disparais un peu.

**Raphaëlle :**
Mais poliment.

---

**C — distance**
Je t’écris dès que je l’ai regardé.

**Raphaëlle :**
Ça me va.

**Raphaëlle :**
Je te laisse retourner à ta journée.

---

## Segment 3 — Fermeture

**Raphaëlle :**
Bon courage pour ta journée.

**Raphaëlle :**
Et si tu testes, ne juge pas trop vite les graphismes.

**Player — guidé :**
Je peux donner trois minutes.

**Raphaëlle :**
Alors tu es officiellement le public cible.

---

# Conversation 3 — Marie fin d’après-midi

## ID cible

`chapter_02_marie_afternoon`

## Titre

Jour 2 — Elle est là

## Intention

Marie garde le centre pendant l’arrivée de Mathilde.
La scène ne doit pas devenir “Mathilde arrive donc route Mathilde”.
Elle doit rester vue par Marie : sa maison, son entrée, son couple, son humour.

---

## Segment 1 — Elle est là

**Marie :**
Elle est là.

**Marie :**
Enfin, ses sacs sont là.

**Marie :**
Mathilde aussi, quelque part derrière.

### Choix Player

**A — tendre**
Tu as le droit de trouver ça bizarre.

**Marie :**
Merci.

**Marie :**
C’est exactement le mélange.

**Marie :**
Contente.

**Marie :**
Et un peu déplacée dans ma propre entrée.

---

**B — prudent**
Elle a l’air de faire attention à ne pas trop prendre de place.

**Marie :**
Oui.

**Marie :**
Et c’est presque pire.

**Marie :**
Parce que du coup, j’ai envie de lui dire de se détendre.

**Marie :**
Et après c’est moi qui ne suis plus détendue.

---

**C — taquin**
La raquette a déjà plus de présence que moi ?

**Marie :**
Ne me tente pas.

**Marie :**
Elle au moins ne laisse pas sa tasse dans la chambre.

**Marie :**
Mais elle ne sait pas acheter le pain.

**Marie :**
Tu gardes une utilité.

---

## Segment 2 — Pâtes

**Marie :**
Je crois que ça va aller.

**Marie :**
Pas parce que tout est simple.

**Marie :**
Mais parce qu’on arrive encore à en rire.

**Player — guidé :**
Elle sait cuisiner ?

**Marie :**
Oui.

**Marie :**
Et puis elle a proposé de faire des pâtes ce soir.

**Marie :**
Elle dit que oui.

**Marie :**
Donc non, probablement.

**Marie :**
Mais elle avait l’air motivée.

---

# Conversation 4 — Mathilde début de soirée

## ID cible

`chapter_02_mathilde_evening`

## Titre

Jour 2 — Je suis devant

## Intention

Première conversation directe Mathilde.
Elle doit être sportive, drôle, gênée, réceptive au soin.
Pas de séduction frontale.
Pas de photo corporelle suggestive.
Le lien vient du soin et de l’accueil, pas du désir.

---

## Segment 1 — Entrée

**Mathilde :**
Salut Player, c’est Mathilde.

**Mathilde :**
Marie m’a dit que je pouvais t’écrire si je me perdais entre la porte et l’entrée.

**Mathilde :**
Bonne nouvelle : j’ai trouvé la porte.

**Mathilde :**
Mauvaise nouvelle : je crois que j’ai pris trop d’affaires.

**Player — guidé :**
Tu veux que je prévienne l’entrée ?

**Mathilde :**
Oui.

**Mathilde :**
Dis-lui d’être forte.

---

## Segment 2 — Photo

**Mathilde :**
Photo envoyée.
`content_id: mathilde_j2_arrival_marie_placeholder`

**Mathilde :**
Je promets que ce n’est pas aussi énorme que ça en a l’air.

**Mathilde :**
Enfin.

**Mathilde :**
Peut-être un peu.

### Choix Player

**A — accueillant**
Tu peux prendre la place qu’il faut.

**Mathilde :**
Merci.

**Mathilde :**
Je sais que je débarque un peu avec ma vie sous le bras.

**Mathilde :**
Enfin, sous les deux bras.

**Mathilde :**
Et sur l’épaule.

**Mathilde :**
Mais merci.

---

**B — taquin**
Si ta raquette prend ma place, je négocie directement avec elle.

**Mathilde :**
Elle est dure en affaire.

**Mathilde :**
Mais juste.

**Mathilde :**
Et elle a un meilleur revers que moi quand je suis fatiguée.

---

## Segment 3 — Sport

**Mathilde :**
Il y a surtout mon sac de sport.

**Mathilde :**
Et ma raquette.

**Mathilde :**
Et des chaussures.

**Mathilde :**
Plusieurs chaussures.

**Mathilde :**
Je fais du foot et du tennis.

**Mathilde :**
Donc j’ai officiellement le droit d’avoir une logistique ridicule.

**Mathilde :**
C’est dans le règlement.

### Choix Player

**A — tendre**
Tu n’as pas besoin de tout gérer tout de suite.

**Mathilde :**
D’accord.

**Mathilde :**
Ça me va bien, comme phrase.

---

**B — humour**
Le sac ne sera jugé qu’après la première semaine.

**Mathilde :**
Ouf.

**Mathilde :**
Je vais lui dire qu’il a une période d’essai.

**Mathilde :**
Il avait besoin d’être rassuré.

---

**C — distance**
Demande à Marie, elle connaît mieux l’organisation.

**Mathilde :**
Oui, tu as raison.

**Mathilde :**
Je vais lui demander.

**Mathilde :**
Merci quand même.

---

## Segment 4 — Demander de l’aide

**Mathilde :**
Je vais être honnête.

**Mathilde :**
Je fais la fille qui gère.

**Mathilde :**
Mais j’aime bien quand quelqu’un me dit juste où poser les trucs.

### Choix Player

**A — tendre**
Pose déjà les sacs. On s’occupe du reste après.

**Mathilde :**
D’accord.

**Mathilde :**
Ça me va bien, comme phrase.

---

**B — humour**
Le sac ne sera jugé qu’après la première semaine.

**Mathilde :**
Ouf.

**Mathilde :**
Je vais lui dire qu’il a une période d’essai.

**Mathilde :**
Il avait besoin d’être rassuré.

---

**C — distance**
Demande à Marie, elle connaît mieux l’organisation.

**Mathilde :**
Oui, tu as raison.

**Mathilde :**
Je vais lui demander.

**Mathilde :**
Merci quand même.

---

## Segment 5 — Fermeture

**Mathilde :**
Bon, je vais respirer deux secondes avant d’ouvrir le deuxième sac.

**Player — guidé :**
Bienvenue, alors.

**Mathilde :**
Merci.

**Mathilde :**
Vraiment.

---

# Conversation 5 — Sandra soir

## ID cible

`chapter_02_sandra_evening`

## Titre

Jour 2 — Trois pages et un lac

## Intention

Sandra revient en écho doux.
Elle ne concurrence pas Marie.
Elle n’intensifie pas la route.
Elle parle du lac, du roman, de tomates, de calme.

---

## Segment 1 — Lac et roman

**Sandra :**
Je n’ai pas racheté de tomates.

**Sandra :**
Je tenais à te rassurer.

**Sandra :**
À la place, je suis passée marcher près du lac.

**Sandra :**
Et j’ai lu trois pages de mon roman beaucoup trop sentimental.

**Sandra :**
Photo envoyée.
`content_id: sandra_j2_lake_book_soft_placeholder`

**Sandra :**
Il y avait du vent.

**Sandra :**
Et une dame très investie dans la vie de son chien.

**Sandra :**
Difficile de se concentrer sur une déclaration d’amour dans ces conditions.

### Choix Player

**A — doux**
J’aime bien t’imaginer là-bas.

**Sandra :**
Ne rends pas ça trop joli.

**Sandra :**
J’avais froid aux mains.

**Sandra :**
Et mon marque-page s’est envolé.

**Sandra :**
Mais… oui.

**Sandra :**
C’était bien.

---

**B — taquin**
Le chien a ruiné la romance ?

**Sandra :**
Totalement.

**Sandra :**
Il s’appelait Mozart.

**Sandra :**
Impossible de rivaliser avec un chien qui s’appelle Mozart.

---

**C — prudent**
Ça avait l’air calme.

**Sandra :**
Oui.

**Sandra :**
C’est ce que je cherchais.

**Sandra :**
Un endroit où il n’y avait rien à expliquer.

---

## Segment 2 — Maison

**Sandra :**
Et toi ?

**Sandra :**
Ta journée a survécu ?

**Player — guidé :**
La maison a gagné une raquette.

**Sandra :**
Pardon ?

**Sandra :**
Un jour, tu m’expliqueras pourquoi ta maison gagne des équipements sportifs.

**Sandra :**
Je note.

**Player — guidé :**
Un jour.

**Sandra :**
Très bien.

**Sandra :**
Je vais retourner à mon roman.

**Sandra :**
Les gens dedans sont sur le point de se dire une phrase évidente qu’ils repoussent depuis 200 pages.

**Player — guidé :**
Tu vas survivre ?

**Sandra :**
Non.

**Sandra :**
Mais je lirai quand même.

---

# Conversation 6 — Marie fin de journée

## ID cible

`chapter_02_marie_night`

## Titre recommandé

Jour 2 — Elle reste dormir

## Statut

Extension douce canonique.
Ne doit pas devenir un pivot dramatique.
Ne doit pas faire de Mathilde un danger déjà explicite.

## Intention

Marie reste le centre affectif après l’arrivée de Mathilde.
Elle annonce que Mathilde dort là, mais le ton reste domestique, tendre, un peu drôle.
Player peut rassurer, plaisanter ou rester pratique.

---

## Segment 1 — Elle reste dormir

**Marie :**
Bon.

**Marie :**
Elle reste dormir.

**Marie :**
Je dis ça comme si c’était un événement diplomatique.

**Marie :**
Mais ce n’est pas une première.

**Marie :**
C’est juste que là, on sent vraiment qu’elle est là.

### Choix Player

**A — tendre**
Ça va pour toi ?

**Marie :**
Oui.

**Marie :**
Je crois.

**Marie :**
C’est étrange, mais pas mauvais.

**Marie :**
J’ai juste besoin qu’on reste un peu nous au milieu du bazar.

---

**B — taquin**
Je prépare un traité de paix avec les sacs.

**Marie :**
Merci.

**Marie :**
Commence par le sac de sport.

**Marie :**
Il a l’air d’avoir des revendications territoriales.

---

**C — pratique**
Dis-moi juste ce qu’il faut faire.

**Marie :**
Pour l’instant, rien.

**Marie :**
C’est peut-être ça le plus difficile pour toi.

**Marie :**
Ne pas optimiser la maison comme un fichier mal rangé.

---

## Segment 2 — Fermeture couple

**Marie :**
Je vais essayer de dormir tôt.

**Marie :**
Enfin.

**Marie :**
Après avoir vérifié que la raquette n’a pas pris ma place.

**Player — guidé :**
Je garde ta place.

**Marie :**
J’espère bien.

**Marie :**
Bonne nuit, mon amour.

---

# Conversation 7 — Mathilde fin de journée privée

## ID cible

`chapter_02_mathilde_night`

## Titre recommandé

Jour 2 — Je ne colonise rien

## Statut

Extension douce canonique, mais basse intensité.

Cette scène ne doit pas devenir :

* un pivot nocturne fort ;
* une scène de séduction ;
* une scène de secret ;
* une preuve ;
* une route lock.

Le vrai pivot Mathilde nocturne reste J3.

## Intention

Mathilde clarifie qu’elle ne veut pas prendre trop de place.
Elle peut envoyer une trace douce du canapé / installation, mais l’image doit rester quotidienne et non suggestive.
Player peut être accueillant, taquin, ou prudent.

---

## Segment 1 — Colonisation

**Mathilde :**
Je tiens à préciser que je ne colonise rien.

**Mathilde :**
Même si, visuellement, mon sac de sport donne une autre impression.

**Player — guidé :**
Je note la déclaration officielle.

**Mathilde :**
Merci.

**Mathilde :**
C’est important de défendre sa réputation.

---

## Segment 2 — Canapé / installation

**Mathilde :**
Je suis sur le canapé deux minutes.

**Mathilde :**
Le temps de comprendre où j’ai mis mon chargeur.

**Mathilde :**
Et ma dignité.

**Mathilde :**
Photo envoyée.
`content_id: mathilde_j2_couch_innocent_selfie_placeholder`

**Mathilde :**
Preuve que je suis presque rangée.

### Choix Player

**A — accueillant**
Tu as le droit de prendre un peu de place.

**Mathilde :**
Je vais essayer de croire ça sans abuser.

**Mathilde :**
Ce qui est un sport à part entière.

---

**B — taquin**
Presque rangée, c’est déjà un concept ambitieux.

**Mathilde :**
Attention.

**Mathilde :**
Je peux progresser vite.

**Mathilde :**
Ou faire semblant très correctement.

---

**C — prudent**
Marie sait que tu as trouvé le canapé ?

**Mathilde :**
Oui.

**Mathilde :**
Elle m’a même donné un plaid.

**Mathilde :**
Je crois que c’est officiellement une autorisation temporaire.

---

## Segment 3 — Fermeture

**Mathilde :**
Bon.

**Mathilde :**
Je vais arrêter d’envoyer des communiqués sur mon installation.

**Player — guidé :**
Bonne nuit, Mathilde.

**Mathilde :**
Bonne nuit, Player.

**Mathilde :**
Demain, je serai discrète.

**Mathilde :**
Enfin.

**Mathilde :**
Je vais essayer.

---

## 5. Décision produit sur les scènes nuit J2

Les scènes nuit J2 sont canonisées comme **pont doux**.

Elles ne doivent pas :

* accélérer Mathilde ;
* créer une preuve ;
* créer un secret ;
* installer un désir actif ;
* concurrencer J3.

Elles peuvent :

* montrer que Mathilde reste dormir ;
* confirmer que Marie accepte la situation ;
* montrer que Player peut accueillir sans draguer ;
* préparer J3 par la présence domestique.

Si le runtime actuel rend ces scènes trop suggestives, trop secrètes ou trop fortes, elles devront être réalignées sur ce document.

---

## 6. Verdict J2 canonique

J2 doit finir avec cette impression :

```text
La maison a changé.
Marie le sait.
Player le sent.
Mathilde est là, mais pas encore dangereuse.
Raphaëlle existe dehors, utile et claire.
Sandra reste une douceur à distance.
Rien n’est verrouillé.
Le vrai trouble peut commencer ensuite.
```