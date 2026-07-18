# Réseau Intime — J17 Script narratif complet

## Statut

**Catégorie : Canon validé narrativement — source pré-runtime consolidée**

**Périmètre : J17 uniquement**

**Surface : messagerie texte uniquement**

Ce document définit la version narrative complète de J17 avant toute adaptation technique.

Il s’appuie sur :

- `J16_SCRIPT_NARRATIF_COMPLET.md` ;
- `S31 — La fin du séjour de Mathilde` ;
- `S29 — La conversation qui ne peut plus être repoussée` ;
- les états concrets du foyer produits en J16 ;
- l’heure de couple réellement acceptée, déplacée ou refusée ;
- les règles d’agence, de conséquence, de consentement et de connaissance limitée ;
- le canon text-only.

Il ne contient :

- aucun JSON ;
- aucun flag runtime définitif ;
- aucun script Godot ;
- aucune migration ;
- aucun asset ;
- aucun prompt ComfyUI ;
- aucune scène audio ;
- aucun appel joué ;
- aucun message vocal.

---

# 1. Décision principale de la journée

J17 devient :

```text
Jeudi — Le foyer ne peut plus rester le même
```

Sa fonction principale est :

```text
transformer matériellement le foyer
afin que le couple ne puisse plus revenir
à son ancienne définition par simple habitude
```

J17 associe deux mouvements appartenant à la même chaîne :

```text
Mathilde quitte l’espace temporaire
→ la place qu’elle occupait devient visible
→ Marie et Player doivent définir
ce qu’ils font du foyer redevenu vide
```

J17 n’est pas :

- une scène finale Mathilde suivie d’une scène finale Marie sans rapport ;
- un choix entre Marie et Mathilde ;
- un menu de formes de couple ;
- une confession exhaustive de toutes les routes ;
- une récompense après les journées de conséquence ;
- une journée de progression adulte.

Le départ de Mathilde retire une présence concrète.

Il ne retire pas ce que son séjour a révélé.

---

# 2. Question dramatique

> Que devient le couple lorsque la personne qui occupait provisoirement son espace s’en va, mais que les désirs, mensonges, distances et choix produits pendant son séjour restent présents ?

La journée doit répondre à deux questions pratiques :

```text
comment Mathilde quitte-t-elle le foyer ?
```

puis :

```text
quelle règle Marie et Player peuvent-ils réellement tenir maintenant ?
```

La seconde réponse dépend de l’accumulation.

Elle ne dépend jamais d’une unique bonne phrase en J17.

---

# 3. États d’entrée obligatoires

J17 lit les sorties réelles de J16.

## 3.1 Mathilde

Un état existe parmi :

```text
départ ordinaire
départ avec distance
départ accéléré
départ sans Player
départ avec aide pratique possible
```

## 3.2 Foyer

Un état existe parmi :

```text
accès ordinaire
accès Player temporairement limité
chambres séparées
Marie dort ailleurs
Player dort ailleurs
organisation par intermédiaire
```

## 3.3 Couple

Un état existe parmi :

```text
discussion J17 acceptée
discussion J17 refusée
discussion déplacée une fois
espace demandé
vérité minimale obtenue
mensonge encore contesté
fracture avancée
```

## 3.4 Route Mathilde

La continuité Mathilde peut être :

```text
familiale et ordinaire
attirance reconnue mais arrêtée
secret actif
proximité ou passage physique avec après-coup
distance protectrice
confiance rompue
```

J17 n’invente aucune continuité plus avancée que celle réellement vécue.

## 3.5 Routes extérieures

Sandra, Pauline, Raphaëlle et Nico possèdent déjà un état issu de J16.

Leurs fils ne viennent pas remplir J17.

Ils peuvent rester silencieux.

Une fermeture ou une attente déjà fixée reste valide sans rappel.

---

# 4. Priorités de la journée

Ordre invisible :

```text
1. respecter toute condition de sécurité ou de distance
2. accomplir le départ réel de Mathilde
3. fixer ce que le foyer devient matériellement
4. traiter l’heure Marie réellement choisie ou refusée
5. donner au couple un état provisoire
6. préparer J18 sans utiliser Sandra comme consolation
```

Si une condition de sécurité Mathilde existe, elle ne peut être amendée par :

- une excuse affectueuse ;
- la présence de Marie ;
- une offre d’aide ;
- un objet à rendre ;
- une promesse de discussion future ;
- le fait que Mathilde quitte de toute façon le logement.

---

# 5. Budget de la journée

Dans chaque partie :

```text
1 chaîne principale : départ → foyer → couple
1 état Mathilde lisible
1 état matériel du foyer
1 définition provisoire du couple
0 nouvelle route
0 nouvelle séduction
0 progression adulte
0 image intime nouvelle
0 retour à la normale automatique
3 contenus visuels minimum
```

Une seule conséquence majeure reste foreground :

```text
le foyer change de définition
```

Le départ de Mathilde et la conversation du couple servent cette même conséquence.

---

# 6. Architecture générale

```text
08:00–09:00
Mathilde confirme l’organisation du départ

11:00–13:00
Player accepte sa place réelle dans cette organisation

17:30
récupération des clés ou ouverture de l’appartement Mathilde

17:45–18:30
départ physique du foyer
le chat s’arrête pendant la co-présence

18:30–19:00
retour textuel Mathilde

19:00–20:00
Marie constate le foyer transformé

20:30–21:30
discussion hors téléphone si elle a été acceptée

après séparation
état provisoire du couple confirmé par messages
```

Les heures peuvent varier légèrement selon :

- La Verrière ;
- le rendez-vous avec l’agence ou l’entreprise ;
- la disponibilité de Marie ;
- la condition de présence de Player ;
- la nécessité d’un intermédiaire.

La structure ne change pas.

---

# 7. Ouverture commune — Mathilde trie

La première voix de J17 appartient à Mathilde.

## 7.1 Départ ordinaire ou aide autorisée

**08:12 — Mathilde**

> J’ai retrouvé mon chargeur.

**08:12 — Mathilde**

> Dans le tote bag où je l’avais rangé.

**08:13 — Mathilde**

> Je retire donc officiellement les accusations contre l’appartement.

**08:13 — Mathilde**

> Pas toutes.

**08:13 — Mathilde**

> Le tiroir de la salle de bain reste hostile.

**08:14 — Mathilde**

> L’agence me rend les clés à 17 h 30.

**08:14 — Mathilde**

> Marie vient pour le premier trajet.

**08:15 — Mathilde**

> Pour toi, je préfère qu’on décide maintenant plutôt qu’au milieu d’une valise dans l’entrée.

Player reçoit un vrai choix.

## 7.2 Départ avec distance

**08:12 — Mathilde**

> Je récupère mes clés à 17 h 30.

**08:13 — Mathilde**

> Marie sera avec moi.

**08:13 — Mathilde**

> Je prends mes affaires ensuite.

**08:14 — Mathilde**

> Je ne veux pas que tu sois dans l’appartement pendant ce temps.

**08:14 — Mathilde**

> Je préfère l’écrire clairement une fois.

Aucune proposition d’aide n’apparaît.

## 7.3 Départ déjà avancé

Si Mathilde dort déjà ailleurs :

**08:12 — Mathilde**

> Je passe avec Marie à 18 h.

**08:12 — Mathilde**

> Il reste la valise, le garment bag et la moitié de ma salle de bain apparemment.

**08:13 — Mathilde**

> J’ai déjà le nécessaire.

**08:13 — Mathilde**

> Ce soir je récupère le reste.

Selon la condition J16 :

> Tu peux ne pas être là.

ou :

> Je ne veux pas que tu sois là.

La nuance est conservée.

---

# 8. Choix Player — Sa place dans le départ

## D17-A — Aider concrètement

Éligible seulement si Mathilde n’a demandé aucune exclusion.

**Player**

> je peux prendre la valise et le garment bag. je serai là à 17 h 45

**08:17 — Mathilde**

> D’accord.

**08:17 — Mathilde**

> La valise roule très mal.

**08:18 — Mathilde**

> Je précise avant que tu découvres un défaut de conception dans l’escalier.

**Player**

> noté

**08:18 — Mathilde**

> Et tu aides.

**08:19 — Mathilde**

> Tu ne transformes pas le trajet en conversation sur tout le reste.

### Sortie provisoire

```text
aide acceptée
aucun droit relationnel créé
conversation émotionnelle différée
Marie reste présente dans l’organisation
```

---

## D17-B — Respecter une distance

**Player**

> je ne serai pas là. je laisse l’entrée libre et je te dis où sont les dernières affaires

### Si la distance était seulement préférable

**08:17 — Mathilde**

> Merci.

**08:17 — Mathilde**

> C’est probablement plus simple.

**08:18 — Mathilde**

> Je déteste quand `plus simple` devient une phrase sérieuse.

### Si la distance était obligatoire

**08:17 — Mathilde**

> D’accord.

**08:17 — Mathilde**

> Envoie la liste à Marie.

Aucun adoucissement n’est ajouté.

### Sortie provisoire

```text
distance respectée
départ organisé sans Player
aucune compensation
```

---

## D17-C — Essayer de préserver une ligne privée

Cette réponse existe uniquement si :

- une attirance ou un secret a réellement été reconnu ;
- aucune limite de sécurité n’a été posée ;
- Mathilde n’a pas demandé l’absence de Player ;
- aucune pression antérieure ne bloque la scène.

**Player**

> je peux aider. et j’aimerais qu’on ait cinq minutes seuls avant que tu partes

Silence.

**08:18 — Mathilde**

> Pour quoi faire ?

Player choisit :

- `pour ne pas faire comme si rien n’avait changé` ;
- `pour parler de ce qu’on garde entre nous` ;
- `je sais pas. juste cinq minutes`.

### Réponse honnête

**Player**

> pour ne pas faire comme si rien n’avait changé

**08:20 — Mathilde**

> D’accord.

**08:20 — Mathilde**

> Mais pas seuls dans la petite chambre.

**08:20 — Mathilde**

> Et pas pour décider de Marie sans Marie.

### Réponse sur le secret

**Player**

> pour parler de ce qu’on garde entre nous

**08:20 — Mathilde**

> Non.

**08:21 — Mathilde**

> On ne décide pas d’un secret supplémentaire le jour où je rends les clés de chez vous.

**08:21 — Mathilde**

> Tu peux aider ou ne pas être là.

### Réponse vague

**Player**

> je sais pas. juste cinq minutes

**08:20 — Mathilde**

> Alors non.

**08:20 — Mathilde**

> Je ne garde pas cinq minutes ouvertes pour découvrir ce qu’elles voulaient dire une fois dedans.

Un refus ferme réellement la fenêtre.

---

# 9. Contestation d’une distance

Si Player conteste une exclusion :

**Player**

> Marie sera là. je peux au moins venir prendre mes affaires

**08:17 — Mathilde**

> Non.

**08:17 — Mathilde**

> Marie présente ne transforme pas mon non en oui collectif.

**08:18 — Mathilde**

> Tes affaires sont déjà séparées des miennes.

**08:18 — Mathilde**

> Elle te dira quand tu peux passer.

Mathilde ne répond plus sur ce sujet.

**08:26 — Marie**

> Mathilde m’a montré ta réponse.

**08:26 — Marie**

> Tu ne seras pas là à 18 h.

**08:27 — Marie**

> Je ne vais pas lui demander de reformuler encore.

### Sortie

```text
exclusion maintenue
Player absent du départ
confiance Mathilde aggravée
Marie confirme la règle du foyer
```

---

# 10. Trace pratique avant le départ

À 12 h 04, Mathilde peut envoyer une trace ordinaire.

**VISUEL J17-V1 — À PRODUIRE PLUS TARD**

```text
type:
PHOTO_DIÉGÉTIQUE ORDINAIRE
ou IMAGE_DE_SCÈNE

creator:
Mathilde ou source de scène autorisée

origin:
appartement Mathilde redevenu accessible
ou préparation du départ au foyer

center:
Mathilde principalement

function:
confirmer que son retour possède une réalité indépendante de Player

initial_audience:
Mathilde

intended_audience:
Marie
ou fil familial légitime incluant Player selon la branche

saving:
ordinaire selon le fil

transfer:
aucune circulation extérieure automatique

withdrawal:
contrôlé par Mathilde
```

Commentaire possible :

**12:04 — Mathilde**

> C’est habitable.

**12:05 — Mathilde**

> Si on accepte que le plafond ait encore une opinion.

ou :

> La chambre existe de nouveau.

> Le mur fait moins peur en photo.

Cette image ne constitue :

- ni une invitation ;
- ni un selfie de route ;
- ni une permission de visite ;
- ni une récompense de départ.

---

# 11. Fenêtre physique — Récupération et départ

## 11.1 Aide autorisée

À 17 h 45, Player rejoint Marie et Mathilde.

La messagerie s’arrête.

```text
17:45–18:25
chargement des affaires
trajet ou premier dépôt
aucun dialogue oral transcrit
Marie présente
aucune scène adulte
aucun geste implicite transformé en permission
```

La scène peut contenir uniquement comme narration fonctionnelle :

- la valise déplacée ;
- le garment bag repris ;
- les chaussures rassemblées ;
- la trousse retrouvée ;
- la petite chambre vidée ;
- les clés de Mathilde récupérées ;
- une porte fermée ;
- un objet oublié découvert plus tard.

## 11.2 Distance choisie ou imposée

Player quitte le foyer avant l’arrivée de Marie et Mathilde.

La messagerie s’arrête pendant leur passage.

```text
18:00–18:35
Marie et Mathilde récupèrent les affaires
Player absent
aucun accès à leur conversation
aucun compte rendu automatique
```

## 11.3 Départ accéléré

Mathilde ne fait pas de mise en scène d’adieu.

Elle récupère le nécessaire.

Le reste peut être repris par Marie ou lors d’un second trajet pratique non joué.

Le départ ne devient pas plus tendre parce qu’il est rapide.

---

# 12. État visuel du départ

**VISUEL J17-V2 — À PRODUIRE PLUS TARD**

```text
type:
IMAGE_DE_SCÈNE

center:
Mathilde

function:
montrer la fin réelle de l’occupation temporaire du foyer

elements_narratifs_possibles:
valise
garment bag
tote bag juridique
trousse
porte-clés
petite chambre
porte de sortie

creator:
mise en scène narrative

origin:
départ J17

audience:
joueur uniquement

saving:
non diégétique

circulation:
false
```

Le visuel doit montrer une transformation.

Il ne doit pas simplement illustrer Mathilde avec des bagages.

---

# 13. Retour Mathilde après séparation

Le résultat revient par messages.

## 13.1 Départ ordinaire

**18:41 — Mathilde**

> Clés récupérées.

**18:41 — Mathilde**

> Valise montée.

**18:42 — Mathilde**

> Garment bag vivant.

**18:42 — Mathilde**

> Moi aussi, globalement.

**Player guidé**

> bonne nouvelle pour le garment bag

**18:43 — Mathilde**

> Il a beaucoup donné.

Puis :

**18:44 — Mathilde**

> Merci pour l’aide.

**18:44 — Mathilde**

> Je vais laisser le reste se poser.

Cette formule ferme la journée Mathilde.

Elle ne promet aucune prochaine scène.

---

## 13.2 Aide concrète avec attirance reconnue

**18:41 — Mathilde**

> Je suis rentrée.

**18:42 — Mathilde**

> Chez moi.

**18:42 — Mathilde**

> Ça fait bizarre de devoir préciser.

Silence.

**18:44 — Mathilde**

> Ce qui s’est passé chez vous ne devient pas faux parce que je suis partie.

**18:44 — Mathilde**

> Mais rien ne recommence tant que tu n’as pas une règle réelle avec Marie.

Player peut répondre :

- `d’accord` ;
- `tu veux que ça recommence` ;
- `on peut au moins continuer à parler`.

### `d’accord`

**Mathilde**

> Bien.

**Mathilde**

> Pour une fois je vais éviter d’ajouter une correction qui détruit la phrase.

### Question sur une reprise

**Player**

> tu veux que ça recommence

**Mathilde**

> Ce n’est pas la question que je t’ai posée.

**Mathilde**

> Et aujourd’hui je ne t’en pose aucune.

### Demande de maintenir le fil

**Player**

> on peut au moins continuer à parler

**Mathilde**

> On se parle déjà depuis des années.

**Mathilde**

> Je ne vais pas inventer une urgence privée pour empêcher le départ d’être un départ.

### Sortie

```text
attirance ou histoire reconnue
aucune reprise autorisée
route Mathilde suspendue jusqu’à définition du couple
départ réel
```

---

## 13.3 Route de loyauté

**18:41 — Mathilde**

> Je suis chez moi.

**18:42 — Mathilde**

> Marie est repartie.

**18:43 — Mathilde**

> Je vous aime tous les deux.

**18:43 — Mathilde**

> Je précise : phrase familiale.

**18:44 — Mathilde**

> Et je ne veux pas devenir l’explication pratique de ce qui n’allait déjà pas entre vous.

**Player**

> je comprends

**18:45 — Mathilde**

> J’espère.

**18:45 — Mathilde**

> Parce que je n’ai pas envie d’avoir été hébergée quinze jours et de finir en théorie conjugale.

### Sortie

```text
loyauté Mathilde affirmée
elle refuse le rôle d’arbitre
affection familiale maintenue
route intime fermée ou mise à distance
```

---

## 13.4 Distance protectrice

**18:41 — Mathilde**

> J’ai tout récupéré.

**18:42 — Mathilde**

> Il reste un chargeur noir qui n’est pas à moi.

**18:42 — Mathilde**

> Pour le reste, je ne veux pas parler aujourd’hui.

Player ne reçoit aucune réponse ouvrant une relance.

### Sortie

```text
départ accompli
distance active
aucune disponibilité émotionnelle
objet éventuel rendu plus tard par Marie
```

---

## 13.5 Confiance rompue

**18:41 — Mathilde**

> J’ai récupéré mes affaires.

**18:41 — Mathilde**

> Je ne veux plus que tu m’écrives directement pour le moment.

**18:42 — Mathilde**

> Pour les objets ou la famille, passe par Marie.

Le fil se ferme.

### Sortie

```text
contact direct fermé
intermédiaire Marie limité à la logistique
aucune promesse de réouverture
```

---

# 14. Objet oublié

Un objet peut rester seulement s’il était réellement présent.

Exemple prioritaire :

```text
chargeur régulièrement perdu
```

Mathilde découvre son absence après le départ.

## Objet réellement oublié

**19:02 — Mathilde**

> J’ai oublié mon chargeur.

**19:02 — Mathilde**

> Oui.

**19:03 — Mathilde**

> Le même.

**19:03 — Mathilde**

> Non, ce n’est pas un symbole.

**19:03 — Mathilde**

> Je sais que tu allais penser la phrase avant moi.

Player peut répondre :

> Marie te le donnera demain.

ou :

> je le laisse à l’entrée.

Une remise future reste strictement pratique.

## Interdit

Player ne peut pas transformer l’objet en :

- prétexte de visite privée ;
- preuve que Mathilde souhaite revenir ;
- dette intime ;
- nouvelle fenêtre de route.

Si Player écrit :

> je peux te l’apporter ce soir

Mathilde répond :

> Non.

> L’objet survivra jusqu’à demain.

---

# 15. Le foyer après le départ

Après le départ de Mathilde, Marie revient dans l’appartement ou reçoit une trace de l’espace vide.

Elle ne commence pas immédiatement par une analyse du couple.

## 15.1 Marie présente au départ

**19:08 — Marie**

> La petite chambre est vide.

**19:08 — Marie**

> Enfin vide selon les critères d’une pièce qui contient encore trois cintres, un ticket de caisse et une chaussette sans nationalité.

**Player guidé**

> la chaussette est peut-être à toi

**19:09 — Marie**

> Elle vient de perdre son droit à la défense.

Puis le ton change.

**19:10 — Marie**

> Ça fait bizarre.

**19:10 — Marie**

> Pas seulement parce que Mathilde est partie.

## 15.2 Player absent du départ

**19:08 — Marie**

> Mathilde a tout récupéré.

**19:08 — Marie**

> J’ai laissé ton sac dans l’entrée.

ou, si l’accès est suspendu :

> J’ai gardé tes clés.

> Je te dirai demain pour tes affaires.

Puis :

**19:10 — Marie**

> Le foyer a changé avant même qu’on décide ce qu’on faisait de nous.

## 15.3 Marie dort ailleurs

**19:08 — Marie**

> Mathilde est chez elle.

**19:09 — Marie**

> Moi je ne rentre pas ce soir.

**19:09 — Marie**

> Je serai à l’heure qu’on a fixée si elle tient toujours.

Elle ne donne pas son lieu.

---

# 16. État visuel du foyer

**VISUEL J17-V3 — À PRODUIRE PLUS TARD**

```text
type:
IMAGE_DE_SCÈNE

center:
Marie principalement

function:
montrer que le départ de Mathilde a modifié
la lecture du foyer et du couple

origin:
petite chambre vidée
entrée
cuisine
couloir
ou espace partagé après le départ

audience:
joueur uniquement

circulation:
false
```

Le foyer vide ne doit pas être représenté comme :

- un retour rassurant au couple d’avant ;
- une victoire de Marie sur Mathilde ;
- une invitation sexuelle ;
- une punition esthétique.

Il est un espace qui demande une nouvelle règle.

---

# 17. Conditions de la conversation Marie

## 17.1 Heure acceptée en J16

Marie confirme sans demander une seconde validation complète.

**19:12 — Marie**

> 20 h 30 tient de mon côté.

**19:12 — Marie**

> Une heure.

**19:13 — Marie**

> Ensuite je ne veux pas continuer jusqu’à deux heures du matin parce qu’on aura attendu quinze jours pour commencer.

Player peut confirmer :

> ça tient

ou refuser maintenant avec conséquence.

## 17.2 Heure refusée en J16

Marie ne propose pas artificiellement une nouvelle soirée.

**19:12 — Marie**

> Tu as refusé qu’on bloque ce soir.

**19:13 — Marie**

> Donc je ne vais pas te demander encore.

**19:13 — Marie**

> Je te dis seulement ce que je fais à partir de maintenant.

La définition du couple devient plus unilatérale.

## 17.3 Heure déplacée une fois

Marie fixe un état intermédiaire.

**19:12 — Marie**

> Notre discussion est déplacée.

**19:13 — Marie**

> Notre ancien fonctionnement ne l’est pas.

**19:13 — Marie**

> Jusqu’à l’heure qu’on a fixée, je ne considère pas qu’on a repris comme avant.

La conversation future ne maintient pas le couple intact par défaut.

## 17.4 Player ne répond pas

Marie attend uniquement jusqu’à l’heure pratique nécessaire.

Puis :

> Je ne garde plus la soirée ouverte.

Elle agit sans Player.

---

# 17 bis. Garde text-only consolidée

La conversation ne peut commencer par messages que lorsque Marie et Player se trouvent dans des lieux distincts.

Changer de pièce ne suffit pas. Si aucune séparation réelle n’existe, la conversation hors téléphone est payée à l’heure choisie et le prochain message n’intervient qu’après un départ, un trajet séparé ou un retour dans deux logements distincts.

# 18. Ouverture Marie — La conversation qui ne peut plus être repoussée

Lorsque la discussion existe, elle commence par messages alors que Marie et Player sont séparés.

Marie peut être :

- encore à La Verrière ;
- en trajet ;
- dans un lieu distinct après une séparation physique réelle ;
- dehors après le départ de Mathilde.

**19:18 — Marie**

> Je ne veux pas un inventaire de tous tes messages.

**19:18 — Marie**

> Je ne veux pas les photos.

**19:19 — Marie**

> Je ne veux pas non plus une phrase où tu me dis que tu m’aimes et où tout le reste devient un problème de formulation.

**19:20 — Marie**

> Je veux savoir ce que tu veux réellement tenir maintenant.

Player ne reçoit pas un menu de personnes.

Il reçoit trois postures sur le couple.

---

# 19. Posture C17-A — Rester activement

**Player**

> je veux rester avec toi

Silence.

**19:22 — Marie**

> D’accord.

**19:22 — Marie**

> Maintenant la partie moins facile.

**19:23 — Marie**

> Qu’est-ce qui change demain ?

Player doit donner un acte ou une règle.

## C17-A1 — Arrêter les versions fausses

**Player**

> plus de faux horaires ou de faux lieux. et je ne laisse pas une relation avancer en secret jusqu’à ce que tu la découvres

**19:25 — Marie**

> D’accord.

**19:25 — Marie**

> Ça ne veut pas dire que tu dois me transmettre la vie privée des autres.

**19:26 — Marie**

> Ça veut dire que tu ne décides plus seul quand une chose qui change notre accord devient assez importante pour exister.

Cette réponse peut produire :

```text
reconquête active
ou accord provisoire
```

selon l’histoire antérieure.

## C17-A2 — Proposer une présence concrète

**Player**

> jeudi prochain 20 h 30 pour notre point. et si on décide encore d’essayer, je bloque le dimanche d’après avec toi

**Marie**

> Jeudi 20 h 30.

**Marie**

> Une heure réelle.

**Marie**

> Le dimanche d’après n’existe pas encore comme récompense.

**Marie**

> On le confirme jeudi si on est toujours capables de tenir la même règle.

```text
promise_id: couple_review_due_at
status: ACTIVE
possible_future_promise: couple_shared_day_due_at
status: CONDITIONAL
```

## C17-A3 — Promesse abstraite

**Player**

> je vais faire mieux

**19:24 — Marie**

> Non.

**19:24 — Marie**

> Cette phrase n’a pas d’heure, pas de lieu et pas de comportement.

**19:25 — Marie**

> Je ne peux pas vivre dans `mieux`.

Player doit préciser ou la posture échoue.

---

# 20. Posture C17-B — Refuser le retour à l’ancien cadre

**Player**

> je veux pas te promettre qu’on revient comme avant

**19:22 — Marie**

> Moi non plus.

**19:22 — Marie**

> Ce n’était pas ma question.

**19:23 — Marie**

> Est-ce que tu veux construire une autre règle avec moi, ou garder toutes les portes ouvertes sans que j’aie de prise dessus ?

Player doit préciser.

## C17-B1 — Demander une règle provisoire

**Player**

> une autre règle. provisoire. pas une permission après coup

Silence.

**19:25 — Marie**

> D’accord.

**19:25 — Marie**

> Alors provisoire veut dire précis.

Marie propose seulement les règles nécessaires :

```text
aucun nouveau passage physique ou adulte extérieur
avant une discussion explicite

aucun faux horaire, faux lieu ou faux alibi

les images privées restent dans leur audience

les conversations privées ne sont pas dues
tant qu’elles ne changent pas l’accord du couple

nouveau point : jeudi suivant J21, 20 h 30
```

```text
promise_id: couple_review_due_at
status: ACTIVE
```

**19:27 — Marie**

> Ça ne veut pas dire que j’accepte rétroactivement ce qui a déjà été caché.

**19:27 — Marie**

> Ça veut dire que je refuse de décider sous la menace de la prochaine découverte.

Cette branche peut produire :

```text
accord provisoire
ou reconfiguration négociée précoce
```

La reconfiguration est éligible uniquement si :

- aucune limite de sécurité n’a été violée ;
- les audiences ont été respectées ou réparées ;
- Player a reconnu les faits affectant Marie ;
- Marie possède une véritable capacité de refus ;
- aucune personne extérieure n’est engagée par la décision du couple ;
- aucune route adulte ne reçoit une permission rétroactive.

## C17-B2 — Garder les portes ouvertes

**Player**

> je sais pas encore ce que je veux fermer

**19:25 — Marie**

> D’accord.

**19:25 — Marie**

> Alors je ferme ce qui dépend de moi.

**19:26 — Marie**

> Je ne maintiens pas notre ancien accord pendant que tu décides tranquillement ce qu’il t’empêche de faire.

Cette branche produit :

```text
espace
fracture
ou double vie fragile si Player continue à cacher
```

Marie ne menace pas.

Elle retire sa participation à un cadre devenu unilatéral.

---

# 21. Posture C17-C — Ne pas demander à Marie de continuer

**Player**

> je sais pas si je peux te demander de continuer

**19:22 — Marie**

> Ne me le demande pas.

**19:22 — Marie**

> Dis-moi seulement si tu veux encore être dans ce couple.

Player reçoit une dernière précision :

- `oui, mais je ne sais pas comment` ;
- `je ne sais pas` ;
- `non`.

## Oui, sans solution prête

**Player**

> oui. mais je sais pas comment

**19:24 — Marie**

> C’est une réponse.

**19:25 — Marie**

> Pas une solution.

**19:25 — Marie**

> On peut partir de là si tu acceptes qu’entre-temps rien ne redevienne automatique.

Cette branche peut produire un accord provisoire fragile.

## Incertitude maintenue

**Player**

> je ne sais pas

**19:24 — Marie**

> D’accord.

**19:24 — Marie**

> Moi je sais que je ne peux plus vivre comme si ta réponse était oui.

Le foyer passe en séparation pratique.

## Fin du couple reconnue

**Player**

> non

Silence.

**19:25 — Marie**

> D’accord.

**19:26 — Marie**

> Je ne vais pas rendre la phrase plus grande pour te faire changer d’avis.

**19:26 — Marie**

> On organise l’appartement demain.

Cette sortie est une fracture ou séparation.

Elle n’ouvre aucune route de consolation.

---

# 22. Minimisation ou retour forcé à la normale

Si Player écrit :

> Mathilde est partie. on peut souffler et revenir à nous

Marie répond :

> Non.

> Mathilde n’était pas la cause de tout ce qui s’est passé pendant qu’elle était là.

> Son départ libère une chambre.

> Il ne répare pas notre couple.

Si Player écrit :

> on dramatise beaucoup pour quelques messages et horaires

Marie répond :

> Ce ne sont pas `quelques horaires`.

> Ce sont les moments où tu as décidé ce que j’avais le droit de savoir pour continuer à t’attendre.

Si Player écrit :

> je t’aime, ça devrait compter plus que le reste

Marie répond :

> Ça compte.

> Ça ne remplace pas le reste.

La minimisation ferme l’accès à la reconquête active.

---

# 23. Rencontre hors téléphone

Si l’heure a été acceptée et maintenue, les personnages se rejoignent.

La messagerie s’arrête.

```text
20:30–21:30
conversation physique hors téléphone
aucun dialogue oral transcrit
aucune scène sexuelle
aucune image intime
aucun reset émotionnel
```

Le résultat dépend :

- de la posture textuelle choisie avant la rencontre ;
- des actes J01–J16 ;
- de la vérité réellement donnée ;
- des mensonges encore actifs ;
- de la sécurité ;
- des audiences ;
- de la qualité des retours Marie antérieurs ;
- du refus ou du respect des limites.

Le résultat revient ensuite par texte lorsque les personnages sont de nouveau séparés :

- Marie sort marcher ;
- Player quitte temporairement l’appartement ;
- Marie retourne terminer une tâche ;
- les personnages se séparent réellement avant toute reprise textuelle avec une demande d’espace.

---

# 24. Sortie couple — Reconquête active

## Éligibilité

- Player a choisi Marie par des actes répétés, pas uniquement en J17 ;
- les mensonges graves sont absents ou reconnus ;
- aucune violation de sécurité active ;
- les routes extérieures ne progressent pas en secret pendant la discussion ;
- Marie veut encore essayer ;
- Player a formulé une règle concrète.

## Retour textuel

**21:46 — Marie**

> Je rentre.

**21:46 — Marie**

> Et avant que tu interprètes trop vite : rentrer n’est pas pardonner.

**21:47 — Marie**

> C’est décider qu’on essaie encore ici.

**Player**

> d’accord

**21:48 — Marie**

> Demain tu fais les courses.

**21:48 — Marie**

> Il n’y a plus rien sauf des tomates fatiguées et le fromage que Mathilde prétend ne pas avoir fini.

**Player guidé**

> elle l’a fini

**21:49 — Marie**

> Je le savais.

Le retour à l’ordinaire est concret et vivant.

### Règle de sortie

```text
couple maintenu
reconquête active
aucun mensonge d’heure ou de lieu toléré
aucune progression extérieure nouvelle avant la prochaine clarification
acte ordinaire prévu
```

Cette sortie ne constitue pas une fermeture définitive des routes extérieures.

Elle leur impose une conséquence et une limite actuelle.

---

# 25. Sortie couple — Accord provisoire

## Éligibilité

- le problème est reconnu ;
- le couple veut éviter une rupture immédiate ;
- toutes les réponses ne sont pas disponibles ;
- Marie refuse de revenir à l’ancien contrat ;
- Player accepte des règles temporaires.

## Retour textuel

**21:46 — Marie**

> Je dors dans la chambre.

**21:47 — Marie**

> Tu peux prendre le canapé ou la petite chambre.

**21:47 — Marie**

> Ce n’est pas une punition.

**21:48 — Marie**

> C’est la place nécessaire pour ne pas transformer notre discussion en fausse réconciliation avant de dormir.

**Player**

> combien de temps

**21:49 — Marie**

> Jusqu’à jeudi prochain, 20 h 30.

**21:49 — Marie**

> Après on ne pourra pas appeler `provisoire` quelque chose qui n’a aucune date.

### Règle de sortie

```text
couple encore actif
chambres ou espaces séparés
nouvelle progression extérieure suspendue
aucun faux alibi
nouvelle discussion datée
```

---

# 26. Sortie couple — Reconfiguration négociée

Cette sortie est rare.

Elle ne signifie pas automatiquement :

- couple ouvert ;
- permission générale ;
- partage des images ;
- autorisation des actes passés ;
- accès de Nico ;
- disponibilité de Sandra, Mathilde, Pauline ou Raphaëlle.

## Éligibilité

- les désirs extérieurs ont été reconnus sans être imposés ;
- Marie ne répond pas sous la menace d’un départ immédiat ;
- aucune violation de consentement ou d’audience active ;
- les partenaires extérieurs restent libres et non engagés ;
- Player accepte qu’une reconfiguration puisse aboutir à un refus ;
- une période sans nouvelle progression est acceptée.

## Retour textuel

**21:46 — Marie**

> On n’a pas décidé d’ouvrir quoi que ce soit.

**21:47 — Marie**

> On a décidé d’arrêter de prétendre que la seule alternative était le silence ou la trahison.

**21:47 — Marie**

> C’est beaucoup moins confortable qu’un mot simple.

**Player**

> oui

**21:48 — Marie**

> Jusqu’à jeudi prochain, 20 h 30 : aucune nouvelle étape avec personne.

**21:48 — Marie**

> Après, on parle de ce que chacun peut réellement accepter.

### Règle de sortie

```text
reconfiguration en négociation
aucune permission rétroactive
aucun accès extérieur automatique
pause actuelle
Marie conserve un droit complet de refus
```

---

# 27. Sortie couple — Double vie fragile

Cette sortie existe si :

- Player donne une vérité partielle mais maintient un secret important ;
- Marie connaît une contradiction sans posséder toute la preuve ;
- le couple reste matériellement ensemble ;
- l’ancien cadre est officiellement maintenu mais ne correspond plus entièrement aux faits.

## Retour textuel

**21:46 — Marie**

> Je vais rentrer.

**21:47 — Marie**

> Je ne crois pas que tu m’aies tout dit.

**21:47 — Marie**

> Je ne vais pas passer la nuit à te demander une meilleure version.

**21:48 — Marie**

> Mais ne confonds pas mon retour avec le fait que ta version me suffit.

### Règle de sortie

```text
couple officiellement maintenu
confiance contestée
preuve ou soupçon actif
dette majeure non résolue
future découverte plus grave
```

Le jeu ne présente jamais cette sortie comme une réussite propre.

---

# 28. Sortie couple — Fracture ou séparation

## Éligibilité

- refus de la conversation ;
- répétition du mensonge ;
- minimisation persistante ;
- sécurité du foyer contestée ;
- Player ne souhaite plus le couple ;
- Marie refuse de maintenir seule l’ancien contrat ;
- absence de règle praticable.

## Retour textuel

### Fracture pratique

**21:46 — Marie**

> Je prends la petite chambre.

**21:46 — Marie**

> Maintenant qu’elle est vide.

**21:47 — Marie**

> On organise les dépenses et l’appartement ce week-end.

**21:47 — Marie**

> D’ici là, je ne veux pas qu’on se présente comme si rien n’avait changé.

### Séparation plus nette

**21:46 — Marie**

> Je ne rentre pas ce soir.

**21:47 — Marie**

> Demain je récupère des affaires.

**21:47 — Marie**

> Pour l’appartement, on décide avec des heures et une liste.

**21:48 — Marie**

> Pas entre deux discussions sur ce qu’on ressent.

### Règle de sortie

```text
ancien contrat terminé ou suspendu
vie commune à réorganiser
affection possible
aucune route extérieure récompensée immédiatement
```

---

# 29. Discussion refusée ou déplacée

## 29.1 Discussion refusée

Marie ne force aucune rencontre.

**19:18 — Marie**

> Tu n’as pas voulu bloquer l’heure.

**19:19 — Marie**

> Je ne vais pas utiliser le départ de Mathilde pour créer une urgence artificielle.

**19:19 — Marie**

> Mais je ne reprends pas notre ancien fonctionnement.

Elle choisit un état pratique selon l’historique :

- petite chambre ;
- nuit ailleurs ;
- accès limité ;
- organisation financière ;
- absence de présentation publique comme couple ;
- date ultérieure non garantie.

Le refus devient une décision relationnelle.

## 29.2 Discussion déplacée

Marie écrit :

> Jusqu’à notre heure, on est en suspension.

Puis elle précise :

- espaces séparés ;
- aucune nouvelle progression extérieure ;
- aucune attente de soirée commune ;
- aucune fausse présentation privée du couple.

La discussion future ne rend pas J17 vide.

La suspension est l’état provisoire du couple.

---

# 30. Mathilde n’arbitre pas le couple

Marie et Mathilde peuvent avoir parlé.

Player ne reçoit pas leur conversation complète.

Marie peut dire :

> Mathilde m’a parlé de ce qui la concernait.

Elle ne dit pas automatiquement :

- ce que Mathilde ressent pour Player ;
- chaque détail d’une proximité ;
- ce que Mathilde pense du couple ;
- si Mathilde souhaite une suite.

Mathilde peut dire :

> J’ai parlé à Marie.

Puis :

> Je ne vais pas te faire le compte rendu.

Si Player demande :

> elle t’a dit quoi sur nous

Mathilde répond :

> Ce que je lui ai dit lui appartient maintenant aussi.

> Je ne vais pas circuler entre vous avec deux versions.

---

# 31. Marie ne demande pas les images

Même lors d’une reconfiguration ou d’une vérité plus large, Marie ne demande pas :

- l’image Sandra ;
- la version privée Pauline ;
- l’image masquée Raphaëlle ;
- une image Mathilde ;
- les captures d’un fil ;
- les confidences Nico.

Elle peut demander :

- si une image existe encore ;
- si son audience a été compromise ;
- si Player a respecté la règle ;
- si une relation a franchi un seuil qui affecte l’accord du couple ;
- si Player a menti sur une heure ou un lieu.

Vie privée et secret affectant le couple restent distincts.

---

# 32. Aucun personnage extérieur comme consolation

Après une sortie difficile avec Marie :

- Sandra n’envoie pas soudainement une photo ;
- Mathilde ne propose pas de revenir ;
- Pauline ne rouvre pas un compartiment ;
- Raphaëlle ne crée pas une invitation ;
- Nico ne propose pas une soirée pour oublier.

Si un fil extérieur était déjà fermé jusqu’à une date, il reste fermé.

Si une obligation future existe déjà, elle ne change pas de fonction.

J18 commence par Sandra parce que sa résolution est due, pas parce que Marie a refusé Player.

---

# 33. Contrat visuel global

Minimum : 3.

Maximum recommandé : 5.

Aucune pose, aucun cadrage et aucun prompt ComfyUI ne sont définis.

## V1 — Retour Mathilde

```text
type:
PHOTO_DIÉGÉTIQUE ORDINAIRE
ou IMAGE_DE_SCÈNE

center:
Mathilde

function:
confirmer que son appartement et sa vie
existent de nouveau hors du foyer

creator:
Mathilde ou source légitime

origin:
appartement récupéré ou préparation du départ

audience:
Marie
ou fil familial légitime selon la branche

conservation:
ordinaire

circulation:
aucune extension automatique
```

## V2 — Départ

```text
type:
IMAGE_DE_SCÈNE

center:
Mathilde

function:
matérialiser la fin du séjour temporaire

circulable:
false
```

## V3 — Foyer transformé

```text
type:
IMAGE_DE_SCÈNE

center:
Marie principalement

function:
montrer que la petite chambre,
l’entrée ou l’espace partagé
ne possède plus son ancienne signification

circulable:
false
```

## V4 — Objet repris ou oublié

```text
type:
TRACE_DIÉGÉTIQUE

function:
chargeur, clés, trousse ou garment bag
comme conséquence pratique

creator:
source de scène

audience:
limitée au foyer ou au fil concerné

circulation:
aucune
```

## V5 — État de couple

```text
type:
IMAGE_DE_SCÈNE

center:
Marie

function:
retour, distance, chambre séparée,
départ ou ordinaire reconstruit

circulable:
false
```

Aucun contenu visuel de J17 ne constitue une permission adulte.

---

# 34. Connaissances de sortie

## Mathilde sait

Selon la branche :

- si Player a respecté son départ ;
- s’il a essayé de préserver un secret ;
- si Marie et Player possèdent une discussion réelle ;
- uniquement ce que Marie ou Player lui a dit directement.

Elle ne connaît pas automatiquement le résultat complet de la conversation conjugale.

## Marie sait

- comment Mathilde est partie ;
- ce que Mathilde lui a choisi de dire ;
- la posture Player envers le couple ;
- les faits déjà établis par J14–J16 ;
- la règle provisoire choisie ou refusée.

Elle ne connaît pas automatiquement chaque route privée.

## Player sait

- la place que Mathilde lui laisse après son départ ;
- l’état matériel du foyer ;
- ce que Marie accepte actuellement ;
- ce qu’elle refuse ;
- ce qui reste à résoudre.

## Personnages extérieurs

Ils ne reçoivent aucune connaissance automatique de la définition du couple.

Player pourra leur parler seulement dans leurs scènes de résolution, avec les limites d’information correspondantes.

---

# 35. États de sortie Mathilde

Un état unique et lisible doit exister.

## Famille préservée

```text
départ ordinaire
affection familiale maintenue
aucune proximité privée active
```

## Loyauté consciente

```text
attirance reconnue ou soupçonnée
Mathilde refuse de devenir une trahison active
relation intime suspendue ou fermée
```

## Secret suspendu

```text
ce qui s’est passé reste réel
aucune reprise avant définition claire du couple
dette encore active
```

## Distance protectrice

```text
contact réduit
aucune invitation
Marie ou un intermédiaire pour la logistique
```

## Rupture de confiance

```text
contact direct fermé
foyer quitté
future réparation non garantie
```

J17 ne laisse jamais Mathilde dans l’état :

```text
toujours disponible parce qu’elle a oublié un objet
```

---

# 36. États de sortie du couple

Un état unique doit être produit :

```text
reconquête active
accord provisoire
reconfiguration en négociation
double vie fragile
fracture
séparation
```

Le résultat dépend de toute la saison.

Le choix J17 ne peut pas convertir seul :

- une accumulation de mensonges en reconquête ;
- une violation de sécurité en couple négocié ;
- une route extérieure secrète en accord ouvert ;
- une phrase d’amour en pardon ;
- un refus en disponibilité future de Marie.

---

# 37. Handoff vers J18

J18 devient :

```text
Vendredi — Sandra choisit ce qu’elle garde
```

J18 commence avec :

- Mathilde qui n’habite plus le foyer ;
- un état provisoire du couple ;
- l’état exact de l’image Sandra ;
- une audience connue ;
- un retrait, une confiance ou une violation déjà fixé ;
- Jeff toujours réel ;
- aucune urgence du foyer à payer avant Sandra.

J18 doit décider :

- ce que Sandra conserve ;
- ce qu’elle retire ;
- quelle place future elle accorde à Player ;
- si l’ancienne amitié survit ;
- si le désir obtient une forme ;
- ou si la confiance est fermée.

J18 ne peut pas servir :

- de consolation après une fracture Marie ;
- de récompense après le départ Mathilde ;
- de suppression de Jeff ;
- de nouveau départ de route sans tenir compte des images et audiences antérieures.

---

# 38. Audit des voix

## Mathilde

- messages rapides ;
- correction ;
- mauvaise foi légère si la sécurité le permet ;
- humour qui s’arrête face à une limite ;
- objets concrets ;
- refus de devenir l’arbitre du couple.

Exemples :

> Je retire officiellement les accusations contre l’appartement. Pas toutes.

> Tu aides. Tu ne transformes pas le trajet en conversation sur tout le reste.

> On ne décide pas d’un secret supplémentaire le jour où je rends les clés de chez vous.

## Marie

- mouvement ;
- heures ;
- pièces ;
- courses ;
- vie partagée ;
- refus des abstractions ;
- capacité à rester drôle sans annuler la gravité.

Exemples :

> La petite chambre est vide.

> Fais plus concret.

> Je ne peux pas vivre dans `mieux`.

> Son départ libère une chambre. Il ne répare pas notre couple.

## Player

- minuscules ;
- première réponse courte ;
- précision demandée ensuite ;
- possibilité d’être honnête, vague ou défensif ;
- aucune confession parfaitement construite.

Exemples :

> je veux rester avec toi

> je veux pas te promettre qu’on revient comme avant

> je sais pas si je peux te demander de continuer

---

# 39. Test sans nom

```text
Je ne garde pas cinq minutes ouvertes pour découvrir ce qu’elles voulaient dire une fois dedans.
→ Mathilde

Son départ libère une chambre. Il ne répare pas notre couple.
→ Marie

La valise roule très mal.
→ Mathilde

Je ne peux pas vivre dans `mieux`.
→ Marie

On ne décide pas d’un secret supplémentaire le jour où je rends les clés de chez vous.
→ Mathilde

Je ne maintiens pas notre ancien accord pendant que tu décides ce qu’il t’empêche de faire.
→ Marie
```

---

# 40. Audit anti-générique

J17 évite :

- la valise utilisée comme symbole romantique automatique ;
- Mathilde laissant volontairement un sous-vêtement ou une image comme hook ;
- un objet oublié créant une nouvelle rencontre ;
- Marie et Mathilde comparant leurs versions devant Player ;
- Mathilde donnant des conseils parfaits sur le couple ;
- Marie demandant toutes les conversations ;
- une confession exhaustive ;
- un choix `Marie ou Mathilde` ;
- une ouverture de couple improvisée sous pression ;
- une permission rétroactive ;
- une scène sexuelle de réparation ;
- le retour à la normale parce que Mathilde est partie ;
- une reconquête obtenue par une seule bonne réponse ;
- un refus Marie suivi d’une photo Sandra ;
- un humour constant pendant une scène de sécurité ;
- une petite chambre vide qui ne produit aucun changement pratique ;
- un départ Mathilde repoussé pour maintenir sa route.

---

# 41. Critères de validation J17

- [ ] le départ de Mathilde est matériellement accompli ;
- [ ] son mode de départ découle de J16 ;
- [ ] toute condition de sécurité est respectée ;
- [ ] Player ne peut pas négocier une exclusion ;
- [ ] Mathilde possède une vie autonome hors du foyer ;
- [ ] l’objet oublié éventuel reste pratique ;
- [ ] aucune invitation de compensation n’est créée ;
- [ ] la messagerie s’arrête pendant le départ physique ;
- [ ] aucun dialogue oral n’est transcrit ;
- [ ] le foyer possède un état visuel et matériel nouveau ;
- [ ] Marie reste active et désirable, pas seulement blessée ;
- [ ] la discussion de couple dépend d’une heure réellement choisie ;
- [ ] un refus de discussion produit un état réel ;
- [ ] le couple ne revient pas automatiquement à son ancien cadre ;
- [ ] aucune confession exhaustive n’est exigée ;
- [ ] Marie ne demande aucune image privée ;
- [ ] vie privée et secret significatif restent distincts ;
- [ ] aucune nouvelle progression adulte ;
- [ ] aucune permission rétroactive ;
- [ ] Mathilde n’arbitre pas le couple ;
- [ ] l’accumulation J01–J16 pèse davantage que le choix final ;
- [ ] un état de couple provisoire unique est produit ;
- [ ] les routes extérieures ne servent pas de consolation ;
- [ ] trois fonctions visuelles minimum sont définies ;
- [ ] J18 peut résoudre Sandra sans dette urgente du foyer.

---

# 42. Résumé canonique candidat

J17 commence par le départ réel de Mathilde.

Elle retrouve son appartement, reprend ses clés et retire ses affaires du foyer de Marie et Player.

Player peut :

- aider concrètement ;
- respecter une distance ;
- ou tenter de préserver une ligne privée lorsque cette demande reste légitime.

Aider ne crée aucun droit.

Un refus ferme réellement la fenêtre.

Une condition de sécurité ne peut pas être négociée parce que Marie est présente.

Après le départ, Mathilde obtient un état clair :

- famille préservée ;
- loyauté consciente ;
- secret suspendu ;
- distance ;
- ou rupture de confiance.

La petite chambre devient vide.

Ce vide ne répare rien.

Il rend visible que le couple ne peut plus attribuer ses tensions à la présence temporaire de Mathilde.

Marie demande alors une vérité praticable :

```text
qu’est-ce que Player veut réellement tenir maintenant ?
```

Player peut vouloir rester activement, demander une autre règle ou reconnaître qu’il ne sait plus demander à Marie de continuer.

Marie exige ensuite du concret :

- comportement ;
- heure ;
- limite ;
- suspension ;
- espace ;
- ou organisation de la séparation.

La discussion se poursuit hors téléphone si elle a été réellement acceptée.

Son résultat revient ensuite par messages.

Le couple obtient une définition provisoire :

- reconquête active ;
- accord provisoire ;
- reconfiguration en négociation ;
- double vie fragile ;
- fracture ;
- ou séparation.

Aucun état n’efface les actes antérieurs.

Aucune route extérieure ne reçoit automatiquement la place libérée.

J17 ferme le séjour de Mathilde et ouvre l’acte des résolutions personnelles.

> **Mathilde quitte une pièce. Ce qui s’est produit dans le foyer, lui, ne peut plus être rangé avec ses affaires.**

---

# Annexe canonique — Identifiants consolidés

```text
promise_id: marie_j16_couple_conversation_j17
promise_id: couple_review_due_at
promise_id: couple_shared_day_due_at
trace_id: j17_couple_definition_record_01
fact_id: fact_couple_state_defined
fact_id: fact_mathilde_left_household
```

Le checkpoint du couple se situe après J21. J20 ne paie aucune journée Marie promise en J17.
