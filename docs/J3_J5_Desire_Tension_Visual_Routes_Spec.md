# J3-J5 — Désir, tensions, contenus visuels et routes

## Statut

Spécification produit pour enrichir la trajectoire J3-J5 avant écriture détaillée et intégration data-first.

Ce document complète :

- `docs/story_state/GLOBAL_STORY_STATE.md`
- `docs/story_state/J1_SUMMARY.md`
- `docs/story_state/J2_SUMMARY.md`
- `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md`
- `docs/03_ROUTE_ARCHITECTURE.md`
- `docs/05_CONTENT_VISUAL_RULES.md`
- `docs/09_WRITING_GUIDELINES.md`

## Objectif

J3-J5 doivent faire passer le prototype de :

```text
les personnages apparaissent et les traces s’accumulent
```

à :

```text
les traces produisent du désir, des risques, des mensonges et des possibilités concurrentes.
```

Le joueur doit ressentir que l’histoire adulte avance parce que chaque fil peut devenir :

- plus intime ;
- plus ambigu ;
- plus provocant ;
- plus dangereux ;
- plus difficile à cacher ;
- plus désirable à poursuivre.

## Règle fondamentale

Le jeu ne doit pas devenir un arbre infini.

J3-J5 doivent rester un tronc commun, mais ce tronc commun doit nourrir plusieurs lectures :

```text
route dominante + route secondaire + menace + mode relationnel
```

Chaque événement important doit donc pouvoir servir au moins trois fonctions :

```text
1. Faire monter le désir.
2. Créer ou renforcer une trace.
3. Nourrir une route ou une menace.
```

## Formule d’écriture à partir de J3

Chaque scène importante doit pouvoir être résumée ainsi :

```text
Quelqu’un désire.
Quelqu’un ment ou omet.
Quelqu’un peut voir.
Une image, un message ou une preuve peut rester.
```

Si une scène ne contient qu’une discussion sans désir, sans trace et sans risque, elle doit être renforcée ou supprimée.

---

# I. Fonction des jours

## J3 — Retour maison / premiers secrets conscients

Fonction : montrer que Player revient physiquement chez Marie, mais que son téléphone contient déjà plusieurs présences.

Intensité dominante :

```text
Palier 1 — Ambigu
```

J3 doit installer :

- le retour physique auprès de Marie ;
- la conséquence de Mathilde qui a dormi chez Marie / Player ;
- la première preuve domestique faible ;
- Sandra comme tension émotionnelle rare ;
- Raphaëlle comme clarté calme ;
- Marie comme désir et ancrage, pas comme obstacle.

J3 doit donner envie par l’ambiguïté.

## J4 — Soirée sociale / regards croisés

Fonction : faire passer les secrets du téléphone vers le réel social.

Intensité dominante :

```text
Palier 1 -> Palier 2 possible selon choix
```

J4 doit installer :

- Pauline comme observatrice sociale ;
- Nico comme regard posé sur Marie ;
- Marie comme femme désirée aussi par d’autres ;
- Mathilde comme témoin du trouble de Player ;
- Sandra comme notification au mauvais moment ;
- une photo / story / capture de soirée qui peut devenir preuve.

J4 doit donner envie par le vertige des possibilités simultanées.

## J5 — Lendemain / première preuve faible

Fonction : montrer que les images et les regards ne disparaissent pas quand la soirée est finie.

Intensité dominante :

```text
Palier 2 possible sur certaines routes.
```

J5 doit installer :

- Marie qui revient sur le comportement de Player ;
- Pauline qui teste parce qu’elle a vu quelque chose ;
- Sandra qui réagit au délai ou au ton de Player ;
- Raphaëlle qui pose une limite ;
- Mathilde qui recule ou provoque selon la route ;
- une première preuve faible que Player ne contrôle pas totalement.

J5 doit donner envie par la preuve et par la promesse d’un contenu plus intime.

---

# II. Courbe d’intimité visuelle

## Règle de cadence

À partir de J3, chaque journée doit proposer au minimum :

```text
1 photo réelle obtenable
1 photo conditionnelle
1 promesse visuelle ou trace
1 risque de preuve différée
```

Une photo réelle n’est pas forcément explicite. Elle peut être sociale, ambiguë, suggestive ou compromettante par contexte.

Une promesse visuelle peut être :

- une photo mentionnée mais non envoyée ;
- un message supprimé ;
- une story visible plus tard ;
- une capture évoquée ;
- une photo envoyée puis regrettée ;
- un aperçu verrouillé ;
- une preuve que quelqu’un possède mais ne montre pas encore.

## J3 — Opportunités visuelles

### Photo réelle obligatoire — Mathilde canapé matin

Type : photo.

Palier : 1 — Ambigu.

Fonction : preuve domestique faible.

Placeholder recommandé :

```text
Photo envoyée : Mathilde au réveil sur le canapé de Marie et Player, plaid autour d’elle, cheveux un peu défaits, tasse à moitié pleine près d’elle. Elle sourit comme si la situation était normale, mais le cadrage rend la scène plus intime qu’elle ne devrait l’être.
```

Risque : Marie peut reconnaître le canapé, le plaid ou le contexte.

### Photo conditionnelle — Marie maison / retour

Type : photo tendre ou domestique.

Palier : 0 ou 1.

Déblocage recommandé : Player revient vers Marie, répond avec tendresse ou valorise sa présence.

Fonction : rappeler que Marie est aussi une route de désir, pas seulement la personne à préserver.

Placeholder recommandé :

```text
Photo envoyée : Marie dans la cuisine ou le salon, lumière douce, tenue simple mais flatteuse, un détail de maison visible. L’image est tendre, intime, et rappelle que le couple possède encore une sensualité réelle.
```

### Promesse / trace — Sandra presque-photo

Type : photo mentionnée, message supprimé ou phrase corrigée.

Fonction : préserver la rareté de Sandra.

Exemples :

```text
Sandra dit qu’elle a failli envoyer quelque chose, puis change de sujet.
```

```text
Sandra a supprimé un message.
```

Risque : Player peut pousser trop vite et augmenter l’exposition.

### Risque différé — galerie Mathilde

Si Player conserve la photo Mathilde, elle devient une preuve faible mais sensible.

Flags possibles :

```text
photo_mathilde_canape_morning_j3_received
photo_mathilde_canape_morning_j3_kept
photo_mathilde_canape_morning_j3_deleted
```

## J4 — Opportunités visuelles

### Photo réelle obligatoire — soirée / story sociale

Type : photo de soirée, story ou image de groupe.

Palier : 0 ou 1.

Elle peut contenir :

- Marie en tenue de soirée ;
- Nico près de Marie ;
- Mathilde qui observe Player ;
- Pauline qui cadre trop bien ;
- Player regardant son téléphone ;
- un reflet ou détail réutilisable ;
- une notification partiellement visible, si cohérent.

Fonction : créer un objet visuel social qui peut devenir preuve.

### Photo conditionnelle — Marie, Mathilde ou Pauline

Selon route nourrie :

- Marie tenue de soirée, si Player nourrit la route couple ;
- Mathilde selfie social, si Player nourrit l’interdit ;
- Pauline photo provocante soft, si Player répond à ses tests ;
- story Marie/Nico, si la menace Nico monte.

### Promesse / trace — Sandra au mauvais moment

Sandra n’a pas besoin d’envoyer une photo réelle en J4.

Elle peut envoyer :

```text
Mauvais moment ?
Désolée. Je ne sais pas pourquoi j’ai pensé à toi maintenant.
```

Si Player tarde, elle peut supprimer ou corriger un message.

### Risque différé — Pauline a vu

Pauline peut voir ou capturer :

- une notification ;
- une expression ;
- un regard ;
- une proximité ;
- un mensonge mal tenu.

Le joueur ne doit pas savoir immédiatement combien elle a compris.

## J5 — Opportunités visuelles

### Photo réelle obligatoire — Pauline envoie une photo de soirée après coup

Type : photo de soirée.

Palier : 1 ou 2 selon cadrage.

Fonction : première preuve faible.

La photo doit sembler anodine au départ, mais contenir un détail exploitable :

- Player regardant son téléphone ;
- Nico trop proche de Marie ;
- Mathilde qui regarde Player ;
- Marie qui regarde Player regarder ailleurs ;
- Pauline visible dans un reflet ;
- une notification ou posture suspecte.

Phrase possible de Pauline :

```text
Très photogénique hier.
Pas forcément sur les photos.
```

### Photo conditionnelle — route haute

Selon route :

- Mathilde peut envoyer une photo plus provocante si Player a gardé la photo canapé et flirté ;
- Marie peut envoyer une photo de reconquête si Player revient vers elle ;
- Sandra peut évoquer une photo plus intime mais ne pas encore l’envoyer ;
- Pauline peut laisser entrevoir une preuve de sa propre tromperie ;
- Nico peut apparaître dans une story avec Marie.

### Promesse / trace — preuve Pauline

Une preuve liée à la tromperie de Pauline peut apparaître comme :

- image floue ;
- message capturé ;
- photo mentionnée ;
- notification ;
- story archivée ;
- allusion de Nico, Mathilde ou Pauline elle-même.

### Risque différé — quelqu’un possède une image non contrôlée par Player

À partir de J5, le joueur doit sentir que la galerie de Player n’est pas le seul lieu des preuves.

D’autres personnages peuvent garder :

- captures ;
- stories ;
- photos de soirée ;
- images supprimées ;
- preuves personnelles.

---

# III. Évolution du ton selon route

## Principe

Le ton des dialogues doit évoluer selon les choix et les routes nourries.

Une même scène peut rester structurellement commune, mais changer de couleur :

```text
neutre
tendre
ambigu
provocant
séducteur
dangereux
coupable
jaloux
clair
```

Le joueur doit sentir que ses choix précédents modifient la façon dont les personnages écrivent.

---

## Marie — Du quotidien vers la lucidité blessée

### Ton bas

```text
domestique, tendre, concret
```

Exemple :

```text
Tu veux un café ou tu vas encore faire semblant d’être déjà réveillé ?
```

### Ton moyen

```text
affectif, inquiet, lucide
```

Exemple :

```text
Je ne sais pas ce que tu as en ce moment.
Mais je sens quand tu me réponds depuis ailleurs.
```

### Ton haut

```text
blessé, sec, désir contrarié
```

Exemple :

```text
Je ne veux pas juste être celle à qui tu rentres.
Je veux encore être celle que tu regardes.
```

### Désir Marie

Marie doit parfois redevenir explicitement désirable dans la mise en scène visuelle.

Fonction : rappeler que réparer Marie n’est pas seulement moral, c’est aussi une route de désir.

Déclencheurs possibles :

- Player répond avec tendresse ;
- Player valorise une photo de Marie ;
- Player choisit Marie au lieu d’une notification secondaire ;
- Nico regarde Marie et provoque une jalousie qui réveille le regard de Player.

---

## Mathilde — Du jeu domestique vers l’interdit

### Ton bas

```text
taquin, familier, effronté
```

Exemple :

```text
Votre canapé est officiellement hostile.
J’ai des preuves.
```

### Ton moyen

```text
ambigu, provocant, teste la réaction de Player
```

Exemple :

```text
Tu réponds comme ça à tout le monde ou je dois m’inquiéter ?
```

### Ton haut

```text
séduction coupable, recul immédiat, risque Marie
```

Exemple :

```text
Ne dis pas ça.
Parce que si tu le dis bien, je vais devoir faire semblant de ne pas aimer.
```

### Désir Mathilde

Le désir Mathilde doit passer par le décor de Marie : canapé, plaid, entrée, cuisine, chambre d’amis, vêtements, objets partagés.

Règle :

```text
Plus l’image est domestique, plus elle est risquée.
```

Déclencheurs possibles :

- Player garde la photo canapé ;
- Player flirte ;
- Player ment à Marie ;
- Player répond à Mathilde pendant une scène avec Marie ;
- Mathilde voit que Player est troublé mais pas clair.

Garde-fou : Mathilde doit pouvoir reculer par loyauté envers Marie.

---

## Sandra — Du manque vers la dépendance émotionnelle

### Ton bas

```text
doux, prudent, complice
```

Exemple :

```text
Je fais semblant de ne pas penser à jeudi.
C’est très convaincant, dans ma tête.
```

### Ton moyen

```text
plus intime, plus vulnérable, toujours fuyant
```

Exemple :

```text
J’aime bien t’écrire.
C’est justement ça le problème.
```

### Ton haut

```text
désir émotionnel, peur, retrait possible
```

Exemple :

```text
Je crois que tu prends une place que je ne saurais pas expliquer à quelqu’un.
```

### Désir Sandra

Sandra doit donner envie par rareté.

Une photo non envoyée, un message supprimé ou un silence peut être plus fort qu’un nouveau contenu direct.

Déclencheurs possibles :

- Player répond vite ;
- Player la rassure ;
- Player pousse la confidence ;
- Player la traite comme unique ;
- Player ouvre Sandra au mauvais moment pendant J4.

Garde-fou : Sandra fuit ou se referme si Player force trop ou si elle sent qu’elle n’est qu’une option parmi d’autres.

---

## Raphaëlle — De la douceur vers l’exigence

### Ton bas

```text
calme, professionnel, attentif
```

Exemple :

```text
Tu avais l’air fatigué ce matin.
Pas juste sommeil.
```

### Ton moyen

```text
plus personnel, mais encore contrôlé
```

Exemple :

```text
Tu peux me parler.
Mais je ne veux pas devenir une pièce en plus dans ton mensonge.
```

### Ton haut

```text
désir clair, conditionné à la vérité
```

Exemple :

```text
J’aurais pu avoir envie de toi.
Mais pas comme ça.
Pas cachée dans une histoire que tu refuses de regarder.
```

### Désir Raphaëlle

Raphaëlle donne envie parce qu’elle ne se donne pas dans le mensonge.

Ses contenus visuels doivent être doux, sincères et conditionnés à la clarté, pas à la manipulation.

Déclencheurs possibles :

- Player cherche son appui ;
- Player reconnaît qu’il fuit ;
- Player avoue une fatigue réelle ;
- Player accepte une limite ;
- Player commence à sortir du secret.

Garde-fou : Raphaëlle refuse le rôle de refuge ou de pansement.

---

## Pauline — De l’observation vers la preuve provocante

### Ton bas

```text
piquant, social, fausse innocence
```

Exemple :

```text
T’es très expressif quand tu essaies de ne pas l’être.
```

### Ton moyen

```text
provocation, double sens, test
```

Exemple :

```text
Tu devrais faire attention.
Les gens qui cachent mal sont souvent les plus intéressants.
```

### Ton haut

```text
preuve, pouvoir, séduction dangereuse
```

Exemple :

```text
Tu croyais être le seul à avoir des choses à cacher ?
C’est adorable.
```

### Désir Pauline

Pauline doit être provocante parce qu’elle sait que les preuves excitent autant qu’elles menacent.

Ses contenus visuels doivent être des armes à double tranchant : photos de soirée, captures, cadrages trop précis, images gardées, preuves révélées partiellement.

---

# IV. Pauline — détail verrouillé à renforcer

## Situation

Pauline est en couple et a trompé son copain.

Ce fait doit devenir un levier narratif important.

Pauline ne doit pas être seulement celle qui piège Player. Elle cache aussi quelque chose.

Elle devient donc un miroir dangereux :

```text
Elle menace les secrets de Player.
Elle possède ou risque de posséder des preuves.
Elle a elle-même une faute qui peut être prouvée.
```

## Types de preuves Pauline

### Preuve douce

```text
Photo de Pauline trop proche de quelqu’un.
```

Fonction : doute, teasing, menace légère.

### Preuve moyenne

```text
Capture de message ambigu ou story archivée.
```

Fonction : Player peut la voir ; Pauline peut la montrer ; quelqu’un d’autre peut l’avoir.

### Preuve forte

```text
Photo intime ou compromettante.
```

Fonction : route Pauline, chaos, chantage social, renversement possible.

Cette preuve forte est à réserver pour une montée plus avancée, pas pour J3.

## Qui peut révéler une preuve Pauline ?

Possibilités :

- Pauline elle-même ;
- Player ;
- Nico ;
- Mathilde ;
- Marie par accident ;
- le copain de Pauline ;
- une story mal contrôlée ;
- une capture conservée.

## Fonctions narratives

Si Player découvre une preuve Pauline, il peut :

- la juger ;
- s’en servir ;
- devenir complice ;
- comprendre qu’elle lui ressemble ;
- être manipulé par elle ;
- la protéger pour obtenir quelque chose ;
- la confronter et déclencher une escalade.

Si Pauline révèle sa propre faute, elle peut :

- tester l’hypocrisie de Player ;
- normaliser la tromperie ;
- l’inviter à entrer dans son jeu ;
- garder le contrôle en avouant seulement ce qu’elle choisit ;
- faire croire à de la confiance alors qu’elle crée un levier.

Phrase-type :

```text
Tu vois ?
La différence entre toi et moi, ce n’est pas qu’on ment.
C’est que moi je sais où sont les preuves.
```

## Déclencheurs de route Pauline

Pauline monte si :

- Player ment mal ;
- Pauline voit une notification ;
- Pauline capture une scène ;
- Player répond à ses provocations ;
- Player découvre qu’elle trompe aussi son copain ;
- Player accepte de jouer avec une preuve ;
- Player essaie de la contrôler et échoue.

Garde-fou : Pauline doit garder de l’agence. Le renversement de son jeu ne doit pas l’effacer comme personnage.

---

# V. Nico — désir par symétrie

## Fonction

Nico ne doit pas être seulement le rival lourd.

Il crée une symétrie : Player désire ailleurs, mais supporte mal que Marie soit désirée.

## Ton bas

```text
amical, blagueur, un peu piquant
```

Exemple :

```text
Marie était en forme hier.
Ça fait plaisir à voir.
```

## Ton moyen

```text
rivalité douce, jalousie Player
```

Exemple :

```text
T’es jaloux ou juste surpris que quelqu’un la regarde encore ?
```

## Ton haut

```text
miroir brutal, NTR potentiel
```

Exemple :

```text
Tu veux regarder ailleurs.
Mais tu voudrais qu’elle, elle reste invisible.
C’est pratique.
```

## Visuels Nico / Marie

Nico ne donne pas une récompense photo centrée sur lui.

Il crée du désir via Marie :

- story avec Marie ;
- réaction à une photo de Marie ;
- photo de groupe où il est trop proche ;
- regard capté par Pauline ;
- image qui rend Player jaloux.

Fonction : faire comprendre que Marie peut aussi devenir objet de désir, de regard et de choix.

---

# VI. Moment de convergence

## Principe

Il faut un moment où le joueur sent que presque toutes les possibilités s’ouvrent en même temps.

Ce moment ne doit pas tout débloquer définitivement. Il doit donner une sensation de vertige.

Moment recommandé :

```text
J4 fin de soirée ou J5 début de journée.
```

## Exemple de convergence

```text
22:48 — Marie : Tu viens te coucher ?
22:49 — Sandra : Je sais que ce n’est pas le moment.
22:49 — Mathilde : J’ai vu ta tête quand Pauline a parlé de photos.
22:50 — Pauline vous a envoyé une image.
22:51 — Nico a réagi à la story de Marie.
```

Choix possibles :

```text
ouvrir Marie
ouvrir Sandra
ouvrir Mathilde
ouvrir Pauline
regarder la story / réaction Nico
ignorer tout
```

Chaque choix nourrit une route et fragilise une autre.

## Effet recherché

Le joueur doit sentir :

```text
Je peux réparer avec Marie.
Je peux continuer avec Sandra.
Je peux basculer avec Mathilde.
Je peux entrer dans le jeu de Pauline.
Je peux jalouser Nico.
Je peux chercher la clarté de Raphaëlle.
Mais je ne peux pas tout faire sans coût.
```

Ce moment doit être un pic de promesse narrative et visuelle.

---

# VII. Photos comme moteur d’envie

## Règle d’envie

Une bonne photo doit donner trois envies contradictoires :

```text
l’ouvrir
la garder
ne pas se faire prendre
```

La photo ne doit pas seulement être séduisante. Elle doit aussi pouvoir devenir une preuve.

## Évolution des photos

### Palier 0 — Social

Exemples :

- photo de soirée ;
- photo de groupe ;
- selfie simple ;
- story.

Fonction : installer le regard.

### Palier 1 — Ambigu

Exemples :

- cadrage flatteur ;
- moment privé mais défendable ;
- photo domestique trop intime ;
- message qui change le sens de l’image.

Fonction : faire douter.

### Palier 2 — Suggestif

Exemples :

- la personne sait l’effet qu’elle produit ;
- message accompagnant plus direct ;
- photo conservée comme secret ;
- provocation contrôlée.

Fonction : récompenser une route nourrie.

### Palier 3 — Intime

Exemples :

- contenu privé difficile à justifier ;
- image qui ne peut plus être expliquée comme anodine ;
- trace qui implique un vrai secret.

Fonction : créer une vraie faute ou une vraie intimité.

J3-J5 doivent surtout couvrir les paliers 0 à 2, avec promesse de palier 3 plus tard.

---

# VIII. Points de tension à injecter

## 1. Le téléphone retourné

Marie remarque que Player pose son téléphone face contre table.

Routes nourries : Marie, Sandra, Mathilde, Pauline, secret affair.

## 2. La photo gardée ou supprimée

Player reçoit la photo Mathilde canapé.

Routes nourries : Mathilde, Marie, galerie preuve, secret affair, réparation si supprimée.

## 3. Le message supprimé Sandra

Sandra écrit quelque chose de trop intime puis supprime.

Routes nourries : Sandra, Marie, secret émotionnel, exposition.

## 4. La réaction de Nico

Nico réagit à une photo/story de Marie.

Routes nourries : Nico, Marie, NTR, jalousie Player.

## 5. Pauline a vu

Pauline fait comprendre qu’elle a vu Player ouvrir une notification.

Routes nourries : Pauline, Marie, Sandra, secret affair, chaos.

## 6. Raphaëlle refuse le rôle de refuge

Player cherche à se confier sans dire la vérité.

Routes nourries : Raphaëlle, Marie réparation, poly honnête, secret affair incompatible.

## 7. Mathilde rappelle Marie

Mathilde fait une blague puis nomme Marie, ce qui casse la légèreté.

Routes nourries : Mathilde, Marie, trio fragile, catastrophe familiale.

## 8. Marie est désirée

Marie reçoit un compliment, une réaction, ou une photo la montre attirante.

Routes nourries : Marie, Nico, réparation, NTR, jalousie.

## 9. La preuve Pauline existe ailleurs

Player apprend ou soupçonne que Pauline a trompé son copain et qu’une image existe.

Routes nourries : Pauline, preuve, chaos, libertinage, hypocrisie de Player.

---

# IX. Lecture des routes après J5

## Marie dominante

Signes :

- Player répond sincèrement à Marie ;
- il supprime ou limite les preuves ;
- il valorise les photos de Marie ;
- il avoue une fatigue ou un trouble sans tout cacher.

Mode probable :

```text
EXCLUSIF_REPARATION
```

Menace : Mathilde ou Sandra selon secret conservé.

## Mathilde dominante

Signes :

- Player garde la photo canapé ;
- il flirte avec Mathilde ;
- il minimise auprès de Marie ;
- Mathilde recule puis revient.

Mode probable :

```text
SECRET_AFFAIR
```

Menace : Marie.

## Sandra dominante

Signes :

- Player répond à Sandra au mauvais moment ;
- il nourrit jeudi ;
- il pousse les confidences ;
- il laisse Sandra croire à une place unique.

Mode probable :

```text
SECRET_AFFAIR émotionnelle
```

Menace : exposition, Marie ou Pauline.

## Raphaëlle dominante

Signes :

- Player cherche la clarté ;
- il reconnaît qu’il fuit ;
- il accepte les limites de Raphaëlle ;
- il commence à envisager une vérité propre.

Mode probable :

```text
POLY_HONEST rare ou rupture propre
```

Menace : flou de Player.

## Pauline menace ou dominante future

Signes :

- Pauline voit une notification ;
- elle garde une capture ;
- Player ment trop vite ;
- elle commence à tester ;
- sa propre tromperie devient une preuve ou un levier.

Mode probable :

```text
SECRET_AFFAIR, LIBERTINE_NEGOTIATED ou CHAOS_EXPLOSION futur
```

Menace : preuve sociale.

## Nico menace

Signes :

- Nico prend de la place auprès de Marie ;
- Player devient jaloux ;
- Marie rit ou se sent vue ;
- Player reproche à Nico ce qu’il s’autorise ailleurs.

Mode probable :

```text
NTR_SUBI seed ou NTR_CONSENTED futur
```

Menace : place émotionnelle laissée vide.

---

# X. Garde-fous

## À ajouter dans l’écriture

```text
plus de photos conditionnelles
plus de promesses visuelles
plus de messages supprimés
plus de tons évolutifs
plus de provocation si route nourrie
plus de désir visible dans Marie, pas seulement chez les autres
plus de preuve Pauline
plus de moments où plusieurs fils s’ouvrent presque en même temps
```

## À éviter

```text
photos explicites trop tôt
routes sexuelles immédiates
tous les personnages disponibles au même rythme
Pauline manipulatrice cartoon
Nico méchant simple
Sandra trop directe
Mathilde sans culpabilité envers Marie
Raphaëlle pansement émotionnel
Marie réduite à la jalousie
```

## Règle de production des scènes

Avant d’écrire une conversation, remplir cette mini-fiche :

```text
Personnage :
Jour / scène :
Surface :
Sous-texte :
Désir perceptible :
Point de tension :
Mensonge possible :
Omission possible :
Photo / trace possible :
Route nourrie :
Risque différé :
Ton bas :
Ton moyen :
Ton haut :
Phrase interdite :
Dernier message fort :
```

## Conclusion

J3-J5 doivent créer la première vraie promesse adulte du jeu :

```text
Player ne choisit pas seulement une personne.
Il choisit quelle envie nourrir,
quelle image garder,
quelle vérité retarder,
et quelle preuve laisser exister.
```

La tension ne doit pas être seulement morale.

Elle doit être :

- affective ;
- visuelle ;
- corporelle par moments ;
- sociale ;
- dangereuse ;
- excitante à poursuivre ;
- inquiétante à conserver.
