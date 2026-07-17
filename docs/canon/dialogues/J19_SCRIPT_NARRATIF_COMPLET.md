# Réseau Intime — J19 Script narratif complet

## Statut

**Catégorie : Canon candidat à validation narrative**

**Périmètre : J19 uniquement**

**Surface : messagerie texte uniquement**

Ce document définit la version narrative complète de J19 avant toute adaptation technique.

Il s’appuie sur :

- `J18_SCRIPT_NARRATIF_COMPLET.md` ;
- `S32 — Pauline choisit entre surface et compartiment` ;
- `S33 — Après avoir retiré le costume` ;
- l’état provisoire du couple Marie / Player ;
- la direction définitive ou provisoire de Sandra ;
- la présence réelle de Bastien ;
- la présence réelle de Maud ;
- l’état des versions publiques, privées et retirées ;
- les règles d’audience, de preuve, de consentement et de responsabilité ;
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

J19 devient :

```text
Samedi — Ce que les versions privées deviennent
```

Sa fonction est :

```text
donner une forme durable à une seule version privée dominante
tout en donnant à l’autre relation un état court,
autonome et non concurrent
```

J19 ne demande pas :

```text
Pauline ou Raphaëlle ?
```

Le joueur ne voit jamais cette sélection.

La journée demande :

> Que devient une version privée lorsqu’elle doit encore exister le lendemain, à côté du travail, du couple officiel, des proches et de la personne ordinaire qui l’a créée ?

Une version privée peut devenir :

- un accès limité ;
- une confiance créative ;
- un compartiment secret ;
- une dette réciproque ;
- une invitation future ;
- une attirance contenue ;
- une frontière renforcée ;
- une preuve compromettante ;
- une fermeture ;
- une version que son autrice refuse désormais de maintenir.

---

# 2. Règle de pivot invisible

Une seule relation reçoit le développement principal.

Ordre de sélection :

```text
1. après-coup Sandra adulte encore dû
2. sécurité, audience ou preuve matérielle non réglée
3. conséquence directe Pauline ou Raphaëlle née de J14–J16
4. passage physique ou cadre privé Raphaëlle déjà vécu
5. compartiment Pauline réellement actif ou exposé
6. relation possédant le plus de décisions directes accumulées
7. fallback ordinaire sans progression artificielle
```

## 2.1 Après-coup Sandra prioritaire

Si J18 contenait une intimité physique avec Sandra, J19 commence obligatoirement par son après-coup.

Dans ce cas :

- Sandra reçoit le premier plan ;
- Pauline reçoit une direction courte ;
- Raphaëlle reçoit une direction courte ;
- aucune nouvelle scène adulte n’est autorisée ;
- aucun personnage ne vient compenser la difficulté Sandra.

## 2.2 Pivot Pauline

Pauline devient foreground si :

- son compartiment privé existe encore ;
- sa version privée a été exposée ;
- Bastien a reçu une information partielle ;
- Marie sait qu’une double adresse existe ;
- une preuve réciproque existe ou est proposée ;
- Pauline a fermé temporairement la ligne mais doit définir si cette fermeture est durable ;
- la relation est devenue une première trahison autonome envers Marie.

## 2.3 Pivot Raphaëlle

Raphaëlle devient foreground si :

- Player possède encore un accès créatif ;
- une image choisie ou un compte privé reste accessible ;
- un baiser, une proximité ou une rencontre privée a eu lieu ;
- le travail a servi de cadre, de trace ou d’alibi ;
- Raphaëlle doit décider si Player voulait le rôle, la personne ou seulement l’évasion ;
- une invitation future doit être acceptée, refusée ou fermée ;
- le secret avec Marie a été explicitement nommé.

## 2.4 Relation secondaire

La relation non choisie reçoit uniquement :

- une fermeture ;
- une limite ;
- un accès futur borné ;
- une conséquence courte ;
- ou un état autonome.

Elle ne reçoit :

- ni trois choix ;
- ni une nouvelle photographie intime ;
- ni une seconde résolution complète ;
- ni un faux suspense.

---

# 3. États d’entrée

## 3.1 Couple Marie / Player

Un état existe parmi :

```text
reconquête active
accord provisoire
reconfiguration en négociation
double vie fragile
fracture
séparation
```

Pauline et Raphaëlle ne le connaissent que par une source légitime.

Une séparation de Player ne constitue pas une permission.

Une reconfiguration en négociation n’engage aucune personne extérieure.

## 3.2 Sandra

Sandra possède désormais un état clair :

```text
amitié retrouvée
confidence privilégiée
désir reconnu et contenu
relation parallèle tendre
intimité tardive
recul protecteur
rupture de confiance
```

Son état n’est pas utilisé pour mesurer ou provoquer Pauline ou Raphaëlle.

## 3.3 Pauline

La version publique reste authentique.

Son état privé peut être :

```text
jamais ouvert
retiré
fermé
exposé
actif avec règle
actif sans règle suffisante
Bastien partiellement informé
Marie partiellement informée
preuve réciproque possible
première trahison autonome envers Marie
```

## 3.4 Raphaëlle

Son état peut être :

```text
collègue uniquement
confiance professionnelle
accès créatif limité
image privée retirée
image choisie encore accessible
attirance reconnue
premier baiser ou proximité vécue
secret clair
cadre rompu
travail ou processus continuant sans Player
```

## 3.5 Images

Aucun contenu supprimé ne revient.

Une version publique ne devient pas fausse parce qu’une version privée a existé.

Une version privée ne crée aucun droit futur.

---

# 4. Budget de la journée

Dans une partie standard :

```text
1 relation foreground développée
1 relation secondaire courte
1 état précis Pauline
1 état précis Raphaëlle
0 comparaison visible
0 nouvelle route
0 permission rétroactive
0 confession exhaustive
0 image intime de récompense
3 contenus visuels minimum
```

Dans une partie avec après-coup Sandra adulte :

```text
1 après-coup Sandra foreground
1 état court Pauline
1 état court Raphaëlle
0 nouvelle progression adulte
```

---

# 5. Architecture générale

## Configuration standard

```text
09:00–11:00
état court de la relation secondaire

14:00–16:00
vie ordinaire de la relation foreground

17:00–19:00
question de la version privée

19:00–20:00
réponse Player

20:00–21:00
décision autonome

fin de journée
état définitif ou provisoire clairement borné
```

## Configuration après-coup Sandra

```text
matin
après-coup Sandra

midi
état court Pauline

fin d’après-midi
état court Raphaëlle

soir
aucune nouvelle opportunité
```

---

# 6. Module prioritaire — Après-coup Sandra

## 6.1 Éligibilité

Seulement si J18 contenait une rencontre physique ou une intimité tardive.

## 6.2 Ouverture

**09:18 — Sandra**

> Je suis réveillée.

Silence.

**09:20 — Sandra**

> Jeff rentre cet après-midi.

**09:20 — Sandra**

> Je ne te dis pas ça pour provoquer une réponse.

**09:21 — Sandra**

> Je te le dis parce que ce qui s’est passé existe encore quand la maison redevient normale.

Player reçoit trois postures.

### A — Reconnaître sans réclamer

**Player**

> je sais. je ne vais pas te demander de décider pour la prochaine fois

**09:23 — Sandra**

> Bien.

**09:24 — Sandra**

> Il n’y a pas de prochaine fois prévue.

**09:24 — Sandra**

> Ce qui ne rend pas hier faux.

### B — Demander si elle regrette

**Player**

> tu regrettes ?

**09:23 — Sandra**

> Non.

**09:23 — Sandra**

> Et je n’aime pas que ce soit la première chose que tu aies besoin de savoir.

**09:24 — Sandra**

> Mon absence de regret n’est pas une permission future.

### C — Chercher à maintenir le secret à deux

**Player**

> on doit se mettre d’accord sur ce qu’on dit

**09:23 — Sandra**

> Non.

**09:24 — Sandra**

> Je déciderai ce que je dis à Jeff.

**09:24 — Sandra**

> Tu décideras ce que tu dis à Marie.

**09:25 — Sandra**

> On ne transforme pas le secret en projet commun pour se rassurer.

## 6.3 Sorties

### Après-coup assumé

```text
intimité reconnue
aucune prochaine fois promise
Sandra garde le contrôle de Jeff et de son propre récit
```

### Recul protecteur

```text
Sandra demande plusieurs jours de silence
aucune relance
aucune image
```

### Relation parallèle sombre

```text
désir maintenu
Jeff et Marie exclus
dette active
aucune présentation comme résultat propre
```

## 6.4 Pauline et Raphaëlle après ce module

Elles reçoivent uniquement leurs modules courts définis plus loin.

---

# 7. Sélection secondaire courte

La relation secondaire intervient avant la scène principale afin que sa direction soit connue sans rivaliser avec le pivot.

---

# 8. Pauline secondaire — Surface restaurée

Utilisée si le compartiment est fermé ou trop peu développé pour devenir foreground.

**10:14 — Pauline**

> Bastien fait les courses.

**10:14 — Pauline**

> Il a encore pris la liste comme une suggestion.

**10:15 — Pauline**

> La version privée reste retirée.

**10:15 — Pauline**

> Je préfère l’écrire un jour normal.

**10:16 — Pauline**

> Pas uniquement quand quelqu’un découvre quelque chose.

Player peut répondre :

> compris

Pauline ferme :

> Bien.

> La photo publique reste dans l’album du groupe.

> Elle était vraie aussi.

### Sortie

```text
surface restaurée
compartiment fermé
Bastien réel
version publique authentique
```

---

# 9. Pauline secondaire — Compartiment encore actif

Si la ligne continue mais n’est pas foreground :

**10:14 — Pauline**

> Je ne ferme pas notre fil.

**10:15 — Pauline**

> Je ne l’approfondis pas aujourd’hui non plus.

**10:15 — Pauline**

> Nuance peu spectaculaire mais utile.

**10:16 — Pauline**

> Aucun nouveau contenu.

**10:16 — Pauline**

> Et pas de message quand je suis avec Bastien.

Cette règle ne garantit pas une sécurité durable.

### Sortie

```text
compartiment actif mais gelé
aucune nouvelle image
dette maintenue
```

---

# 10. Pauline secondaire — Fermeture après exposition

**10:14 — Pauline**

> Je garde uniquement ce qui est nécessaire pour répondre si Marie ou Bastien me pose une question précise.

**10:15 — Pauline**

> Le reste est fermé.

**10:15 — Pauline**

> Ne teste pas si `fermé` voulait dire `pour aujourd’hui`.

Le fil se ferme.

### Sortie

```text
accès privé fermé
traces de responsabilité conservées
aucune nouvelle attente
```

---

# 11. Raphaëlle secondaire — Confiance créative maintenue

**11:02 — Raphaëlle**

> J’ai remis les fichiers du costume dans mon compte créatif.

**11:03 — Raphaëlle**

> Ton accès au dossier de fabrication reste actif.

**11:03 — Raphaëlle**

> Le dossier privé de l’image, non.

**11:04 — Raphaëlle**

> Ce sont deux décisions différentes.

Player peut répondre :

> compris

**Raphaëlle**

> Bien.

> Maud reprend la couture cet après-midi.

### Sortie

```text
accès au processus
image privée fermée
Maud active
aucune invitation automatique
```

---

# 12. Raphaëlle secondaire — Frontière professionnelle

**11:02 — Raphaëlle**

> Lundi, on reprend le dossier bleu.

**11:03 — Raphaëlle**

> Pour le reste, je préfère qu’on revienne au cadre professionnel.

**11:03 — Raphaëlle**

> L’attirance ne disparaît pas parce que je ferme un accès.

**11:04 — Raphaëlle**

> L’accès disparaît quand même.

### Sortie

```text
collègue uniquement
attirance possible
accès privé fermé
travail préservé
```

---

# 13. Raphaëlle secondaire — Invitation future bornée

Seulement si l’invitation était déjà légitime.

**11:02 — Raphaëlle**

> Maud travaille avec moi samedi prochain.

**11:03 — Raphaëlle**

> 15 h à 17 h.

**11:03 — Raphaëlle**

> Atelier uniquement.

**11:04 — Raphaëlle**

> Tu peux venir si tu veux voir le processus.

**11:04 — Raphaëlle**

> Pas si tu cherches à reprendre la scène là où elle s’est arrêtée.

Player choisit réellement :

- accepter ;
- refuser ;
- proposer une seule alternative précise.

---

# 14. Pivot Pauline — Ouverture

## 14.1 Situation ordinaire

Pauline est chez elle ou revient d’une matinée de travail.

Bastien est réellement présent dans sa journée.

**16:38 — Pauline**

> Bastien a rangé les courses.

**16:38 — Pauline**

> Enfin.

**16:39 — Pauline**

> Il a rangé les pâtes avec le riz et considère que le débat est clos.

**Player guidé**

> position défendable

**16:39 — Pauline**

> non

**16:40 — Pauline**

> mais merci de révéler aussi vite tes faiblesses

Silence.

**16:42 — Pauline**

> J’ai remis la photo publique dans le dossier du groupe.

**16:42 — Pauline**

> Celle où Bastien est à côté de moi.

**16:43 — Pauline**

> Je ne l’avais pas retirée.

**16:43 — Pauline**

> J’avais juste arrêté de la regarder normalement.

---

# 15. Visuel Pauline — Surface réelle

**VISUEL J19-V1P — À PRODUIRE PLUS TARD**

```text
type:
PHOTO_DIÉGÉTIQUE PUBLIQUE EXISTANTE
ou IMAGE_DE_SCÈNE

center:
Pauline principalement

function:
montrer que la surface officielle
reste une vie réelle et pas un décor mensonger

creator:
source J12 ou source sociale déjà établie

origin:
vie Pauline / Bastien / groupe

audience:
publique ou groupe autorisé

saving:
ordinaire selon son cadre initial

circulation:
aucune extension nouvelle
```

Bastien ne doit pas être réduit à un détail hors champ sans existence narrative.

---

# 16. Pauline nomme la décision

**16:45 — Pauline**

> La version publique est vraie.

**16:45 — Pauline**

> La version privée l’était aussi.

**16:46 — Pauline**

> Mon problème est que j’ai traité leur séparation comme une solution.

Silence.

**16:47 — Pauline**

> Je dois décider si je ferme le compartiment.

**16:47 — Pauline**

> Ou si j’arrête de prétendre qu’il est sans conséquence.

Player reçoit trois postures.

---

# 17. Nœud Pauline

## P19-A — Respecter une fermeture

**Player**

> si tu le fermes, je respecte. je ne te demanderai pas une autre version

## P19-B — Accepter consciemment le compartiment

**Player**

> je veux qu’on le garde. mais pas en prétendant que c’est innocent

## P19-C — Réclamer une vérité que Pauline refuse de livrer

Formulations possibles :

> tu devrais tout dire à Bastien et Marie

ou :

> dis-moi au moins ce que tu ressens vraiment pour moi

ou :

> si tu continues avec Bastien, ça veut dire que notre version ne compte pas assez

Cette posture transforme Player en demandeur d’une décision qui appartient à Pauline.

---

# 18. Pauline — Surface restaurée

## 18.1 Après P19-A

**16:50 — Pauline**

> D’accord.

Silence.

**16:52 — Pauline**

> Je ferme.

**16:52 — Pauline**

> Pas seulement les images.

**16:53 — Pauline**

> Le réflexe de t’écrire une phrase différente de celle que je peux assumer dans la pièce où je suis.

**Player**

> d’accord

**16:54 — Pauline**

> La version publique ne devient pas plus vraie grâce à ça.

**16:54 — Pauline**

> Elle était déjà vraie.

**16:55 — Pauline**

> Je vais simplement arrêter de lui construire une pièce cachée à côté.

## 18.2 Ce que Pauline conserve

Elle peut conserver :

- le souvenir ;
- un message de responsabilité ;
- la preuve qu’elle a retiré une image ;
- aucune image privée active.

Elle ne conserve pas une trace comme levier.

## 18.3 Bastien

**16:57 — Pauline**

> Je ne sais pas encore ce que je vais dire à Bastien.

**16:57 — Pauline**

> Fermer avec toi ne règle pas ce que je lui ai déjà caché.

Player ne conseille pas automatiquement.

## 18.4 Marie

Si Marie a été affectée :

> Et Marie ne redevient pas automatiquement mon amie comme avant parce que j’ai pris une bonne décision samedi.

### Sortie

```text
surface restaurée
compartiment fermé
vie officielle reconnue comme réelle
dette Bastien et Marie encore possible
aucune nouvelle image
```

---

# 19. Pauline — Compartiment protégé

## 19.1 Après P19-B

Silence prolongé.

**16:51 — Pauline**

> D’accord.

**16:52 — Pauline**

> Alors on enlève le mot `test`.

**16:52 — Pauline**

> Et le mot `accident`.

**16:53 — Pauline**

> Ce fil existe parce qu’on veut qu’il existe.

**Player**

> oui

**16:54 — Pauline**

> Bien.

**16:54 — Pauline**

> Ça le rend plus honnête entre nous.

**16:55 — Pauline**

> Pas plus honnête pour Bastien ou Marie.

## 19.2 Règles minimales

Pauline fixe :

```text
aucun contenu lorsque Bastien ou Marie est physiquement présent
aucune image publique détournée sans décision explicite
aucune fausse information attribuée à l’autre
aucune demande d’alibi
aucune circulation
aucun droit de répétition
fermeture immédiate possible
```

## 19.3 Dette

**16:57 — Pauline**

> Je ne vais pas appeler ça un cadre propre.

**16:57 — Pauline**

> C’est un compartiment conscient.

**16:58 — Pauline**

> Le risque est justement qu’il fonctionne.

## 19.4 Sortie

```text
compartiment protégé
secret conscient
Bastien et Marie exclus
dette forte
aucun accès permanent
```

Cette branche est séduisante mais instable.

---

# 20. Pauline — Preuve réciproque

## 20.1 Éligibilité

- une version privée existe ;
- des messages reconnaissent l’exclusion de Bastien ou Marie ;
- Pauline veut éviter que Player puisse nier seul ;
- aucune nouvelle image intime n’est nécessaire.

## 20.2 Proposition

**16:56 — Pauline**

> Je vais garder ta phrase où tu reconnais que tu savais pour Bastien.

**Player**

> comme preuve ?

**16:57 — Pauline**

> Comme trace.

**16:57 — Pauline**

> Le mot `preuve` donne une impression de sécurité que nous n’avons pas.

**16:58 — Pauline**

> Toi, tu as déjà mes messages.

**16:58 — Pauline**

> Voilà notre très mauvaise égalité.

Player peut :

- accepter ;
- demander la suppression de ses messages ;
- menacer d’utiliser la trace ;
- refuser de reconnaître la réciprocité.

## 20.3 Accepter

**Player**

> je comprends

**Pauline**

> Non.

> Tu acceptes.

> Ce n’est pas tout à fait pareil.

## 20.4 Demander une suppression mutuelle

**Player**

> on supprime tout les deux

**Pauline**

> On peut supprimer les contenus.

> On ne peut pas supprimer ce qu’on sait.

> Et je ne te donnerai pas une attestation d’oubli.

## 20.5 Menace ou pression

**Player**

> donc si je parle tu parles

**Pauline**

> Non.

> Là tu viens de transformer une dette en menace.

Pauline ferme la ligne et conserve uniquement les traces nécessaires à sa protection.

## 20.6 Sortie

```text
preuve ou trace réciproque
aucune sécurité réelle
risque de réseau
possible transfert vers J20
```

---

# 21. Pauline — Première trahison envers Marie

## 21.1 Éligibilité

- Pauline est une amie proche de Marie ;
- elle sait désormais que la ligne privée affecte le couple ;
- elle choisit de continuer malgré cela ;
- aucune reconfiguration consensuelle ne l’autorise.

## 21.2 Script

**17:02 — Pauline**

> Il y a autre chose.

**17:03 — Pauline**

> Bastien était déjà dans le problème.

**17:03 — Pauline**

> Marie, je pouvais encore prétendre qu’elle ne l’était pas directement.

Silence.

**17:04 — Pauline**

> Ce n’est plus vrai.

**Player**

> je sais

**17:05 — Pauline**

> Non.

**17:05 — Pauline**

> Tu sais qu’elle existe.

**17:06 — Pauline**

> Moi je sais ce qu’elle m’a déjà confié sur votre couple.

**17:06 — Pauline**

> Et je continue quand même à créer un endroit privé avec toi.

Pauline ne révèle aucune confidence de Marie.

## 21.3 Choix Pauline

Elle peut :

### Fermer

> Je ne veux pas devenir cette amie-là.

### Continuer consciemment

> Je ne vais pas prétendre que ça ne la trahit pas.

> Je vais continuer quand même.

### Demander du temps fermé

> Je ne t’écris pas pendant une semaine.

> Ce n’est pas une attente.

> Je reviendrai ou non.

## 21.4 Sortie

```text
relation Pauline devenue autonome
Marie directement affectée
route sombre coûteuse
aucune justification par le couple de Player
```

---

# 22. Pauline — Collision Bastien

## 22.1 Conditions

Une collision existe seulement si Bastien possède une raison crédible de poser une question :

- Pauline lui a déjà parlé d’une version non publiée ;
- il a vu un objet photographique déjà établi ;
- une notification réelle est apparue ;
- une incohérence d’heure existe ;
- Pauline a modifié un comportement visible.

Aucun soupçon n’est inventé pour accélérer la résolution.

## 22.2 Message Pauline

**18:12 — Pauline**

> Bastien m’a demandé pourquoi je lui avais parlé de la version non publiée.

**18:13 — Pauline**

> Il n’a pas vu l’image.

**18:13 — Pauline**

> Il ne connaît pas nos messages.

**18:14 — Pauline**

> Il sait seulement que j’ai retiré quelque chose avant de lui en parler.

Player ne reçoit pas l’option de fournir une version à Pauline.

## 22.3 Réponse Player correcte

> décide ce que tu lui dis. je ne vais pas écrire ta version

**Pauline**

> Bien.

> C’était la seule réponse acceptable.

## 22.4 Recherche de coordination

> on devrait dire la même chose

**Pauline**

> Non.

> Je réponds de ce que j’ai fait.

> Toi, de ce que tu as fait avec Marie.

## 22.5 Sorties

```text
Bastien connaît une anomalie limitée
aucune omniscience
Pauline garde ou ferme le compartiment
conséquence réseau possible J20
```

---

# 23. P19-C — Exiger une vérité à la place de Pauline

## 23.1 Exiger qu’elle avoue tout

**Player**

> tu dois tout dire à Bastien

**Pauline**

> Peut-être.

**Pauline**

> Mais tu ne vas pas utiliser ma faute pour te donner le rôle de la personne honnête dans cette conversation.

**Pauline**

> Ce que je lui dis m’appartient.

## 23.2 Exiger une déclaration

**Player**

> dis-moi ce que tu ressens vraiment pour moi

**Pauline**

> Je te désire.

Silence.

**Pauline**

> Et tu vois déjà comment tu transformes cette phrase en réponse à toutes les autres.

**Pauline**

> Elle ne l’est pas.

## 23.3 Opposer Bastien et Player

**Player**

> si tu restes avec lui, je vois pas ce que je représente

**Pauline**

> C’est exactement le compartiment que tu dis vouloir comprendre.

**Pauline**

> Tu représentes quelque chose.

**Pauline**

> Tu ne remplaces pas tout le reste.

## 23.4 Conséquence

Pauline choisit fermeture ou compartiment durci selon l’accumulation.

Player ne reçoit aucune preuve affective comme récompense.

---

# 24. Visuel Pauline — Statut du compartiment

**VISUEL J19-V2P — À PRODUIRE PLUS TARD**

```text
type:
IMAGE_DE_SCÈNE

center:
Pauline

function:
montrer la décision sur la version privée

éléments narratifs possibles:
planner fermé
téléphone posé
bague tournée
deux clés dans le bol
photo publique rangée
fil privé fermé ou maintenu

audience:
joueur uniquement

circulation:
false
```

Pauline doit rester le sujet du visuel.

Le téléphone ou la preuve ne doit pas la remplacer.

---

# 25. Pivot Raphaëlle — Ouverture

## 25.1 Situation ordinaire après le rôle

Raphaëlle a rangé ou commencé à ranger le matériel.

Maud continue sa propre journée.

**16:21 — Raphaëlle**

> Le masque est dans sa boîte.

**16:22 — Raphaëlle**

> La perruque aussi.

**16:22 — Raphaëlle**

> Le costume, moins bien.

**Player guidé**

> problème ?

**16:23 — Raphaëlle**

> Une couture intérieure a décidé de commenter la soirée.

**16:23 — Raphaëlle**

> Maud la reprend demain.

Silence.

**16:25 — Raphaëlle**

> J’ai également remis mes lunettes.

**16:25 — Raphaëlle**

> Information apparemment nécessaire, puisque tu me connais surtout dans les transitions maintenant.

---

# 26. Visuel Raphaëlle — Après le rôle

**VISUEL J19-V1R — À PRODUIRE PLUS TARD**

```text
type:
PHOTO_DIÉGÉTIQUE PRIVÉE ORDINAIRE
ou IMAGE_DE_SCÈNE

center:
Raphaëlle

function:
montrer la personne et l’ordinaire après la version choisie

creator:
Raphaëlle
Maud si présence et autorisation établies
ou mise en scène narrative

origin:
atelier ou appartement après rangement

audience:
Player seulement si Raphaëlle choisit l’envoi
sinon joueur uniquement

saving:
aucun droit nouveau

circulation:
interdite

withdrawal:
contrôlé par Raphaëlle
```

L’image ne doit pas fonctionner comme une version « moins sexy ».

Elle montre une autre version réelle.

---

# 27. Raphaëlle nomme la question

**16:28 — Raphaëlle**

> Le costume, je sais quoi en faire.

**16:28 — Raphaëlle**

> Le lendemain, moins.

Silence.

**16:30 — Raphaëlle**

> Je te pose la question simplement.

**16:30 — Raphaëlle**

> Est-ce que tu voulais entrer dans mon processus ?

**16:31 — Raphaëlle**

> Ou seulement dans la version terminée ?

Player reçoit trois postures.

---

# 28. Nœud Raphaëlle

## R19-A — Reconnaître la personne et le processus

**Player**

> les deux. mais l’accès au processus t’appartient toujours

## R19-B — Demander une invitation future bornée

**Player**

> j’aimerais revenir. avec un cadre précis, pas comme si la dernière fois continuait

## R19-C — Réduire à la version ou à la clarté

Formulations possibles :

> le costume te va mieux que la version bureau

> au moins avec toi tout est clair

> je voulais surtout voir jusqu’où tu pouvais aller

Cette posture révèle que Player peut désirer la version sans assumer la personne ou le lendemain.

---

# 29. Raphaëlle — Confiance créative

## 29.1 Après R19-A

**16:34 — Raphaëlle**

> Bien.

**16:34 — Raphaëlle**

> Tu n’as pas répondu parfaitement.

**16:35 — Raphaëlle**

> Tu as répondu à la bonne question.

**Player**

> ça change quoi

**16:36 — Raphaëlle**

> Tu gardes l’accès au compte créatif.

**16:36 — Raphaëlle**

> Et au dossier de fabrication.

**16:37 — Raphaëlle**

> Pas au dossier privé de l’image.

**16:37 — Raphaëlle**

> Je préfère que les permissions restent en phrases séparées.

## 29.2 Maud

**16:39 — Raphaëlle**

> Maud sait que tu as vu le résultat.

**16:39 — Raphaëlle**

> Elle ne connaît pas nos messages.

**16:40 — Raphaëlle**

> Et je n’ai aucune raison de les lui donner.

Maud reste collaboratrice, pas gardienne de la relation.

## 29.3 Sortie

```text
confiance créative
accès au processus
image privée distincte
aucune permission corporelle ou adulte
```

---

# 30. Raphaëlle — Invitation future

## 30.1 Après R19-B

**16:34 — Raphaëlle**

> D’accord.

**16:35 — Raphaëlle**

> Samedi prochain.

**16:35 — Raphaëlle**

> 15 h à 17 h.

**16:36 — Raphaëlle**

> Maud sera là la première heure.

**16:36 — Raphaëlle**

> Ensuite elle part avec la pièce de couture.

**16:37 — Raphaëlle**

> Je te donne les informations parce qu’elles changent le cadre.

Player choisit :

- accepter ;
- refuser ;
- proposer une alternative précise.

## 30.2 Règle

> Atelier.

> Pas une reprise automatique du rôle.

> Si autre chose apparaît, on le décide alors.

## 30.3 Sortie

```text
invitation future bornée
processus créatif actif
aucun résultat intime promis
Maud présente dans la réalité
```

---

# 31. Raphaëlle — Attirance reconnue et contenue

## 31.1 Conditions

- attirance réelle ;
- état du couple incompatible avec une progression ;
- Raphaëlle refuse d’être un cas pratique ;
- Player respecte la limite.

## 31.2 Script

**16:34 — Raphaëlle**

> J’ai envie de te revoir.

Silence.

**16:35 — Raphaëlle**

> Voilà la phrase simple.

**16:36 — Raphaëlle**

> Et je ne vais pas le faire maintenant.

**Player**

> à cause de Marie

**16:37 — Raphaëlle**

> À cause de la règle que tu as avec Marie.

**16:37 — Raphaëlle**

> Et de la mienne.

**16:38 — Raphaëlle**

> Ne réduis pas mon refus à la présence d’une autre femme.

## 31.3 Sortie

```text
attirance reconnue
frontière actuelle
aucune invitation active
confiance possible
```

---

# 32. Raphaëlle — Secret clair mais infidèle

## 32.1 Éligibilité

- Player et Raphaëlle savent que Marie est exclue ;
- aucune fausse affirmation de consentement ;
- attirance ou passage antérieur réel ;
- les deux choisissent éventuellement de continuer.

## 32.2 Script

**16:34 — Raphaëlle**

> Marie ne sait pas.

**16:35 — Raphaëlle**

> Ou elle ne sait pas la même chose que nous.

**16:35 — Raphaëlle**

> Ne me remercie pas d’être claire.

**16:36 — Raphaëlle**

> Ça ne rend pas la décision propre.

Player choisit :

### Fermer

> alors on arrête

**Raphaëlle**

> D’accord.

> Lundi, nous reprenons le travail normalement.

> Pas comme si rien n’avait existé.

### Continuer consciemment

> je veux continuer en sachant ce que c’est

**Raphaëlle**

> D’accord.

> Alors la phrase exacte est : nous choisissons un secret.

> Pas un cadre libre.

### Utiliser sa clarté comme absolution

> au moins on ne se ment pas

**Raphaëlle**

> Nous ne nous mentons peut-être pas entre nous.

> Marie reste exclue.

> Tu fais de ma précision un alibi.

Cette troisième réponse ferme ou durcit la route.

## 32.3 Sortie

```text
secret clair
infidélité nommée
aucune absolution
travail et Marie deviennent des conséquences
```

---

# 33. Raphaëlle — Frontière renforcée

## 33.1 Après réduction au costume

**Player**

> le costume te va mieux que la version bureau

Silence.

**16:34 — Raphaëlle**

> Non.

**16:34 — Raphaëlle**

> Il te plaît davantage.

**16:35 — Raphaëlle**

> Ce n’est pas la même information.

## 33.2 Après valorisation de sa clarté

**Player**

> au moins avec toi tout est clair

**16:34 — Raphaëlle**

> Tu utilises encore ma clarté pour ne pas répondre.

**16:35 — Raphaëlle**

> Je peux relire un dossier.

**16:35 — Raphaëlle**

> Pas décider ce que tu veux à ta place.

## 33.3 Après curiosité sur ses limites

**Player**

> je voulais surtout voir jusqu’où tu pouvais aller

**16:34 — Raphaëlle**

> Voilà.

**16:35 — Raphaëlle**

> Tu voulais la limite comme spectacle.

**16:35 — Raphaëlle**

> Pas le lendemain.

## 33.4 Décision

> Je ferme l’accès privé.

> Le compte créatif aussi.

> Pour le travail, nous verrons lundi si la confiance reste praticable.

### Sortie

```text
frontière renforcée
accès privé fermé
confiance professionnelle possiblement réduite
attirance non niée
```

---

# 34. Raphaëlle — Après un baiser ou une proximité antérieure

## 34.1 Ouverture adaptée

**Raphaëlle**

> Le baiser était voulu.

> Je ne le retire pas.

> Je ne veux pas non plus qu’il devienne une autorisation sans fin.

## 34.2 Question

> Est-ce que tu voulais me revoir après ?

> Ou voulais-tu surtout que le cadre t’autorise enfin à le faire ?

## 34.3 Réponses Player

### Personne entière

> je veux te revoir quand il n’y a ni costume ni urgence

Raphaëlle peut ouvrir une invitation ordinaire.

### Version uniquement

> c’était surtout ce moment-là

Raphaëlle ferme avec dignité :

> D’accord.

> Alors je garde ce moment à sa taille.

### Vague

> je sais pas encore

> Tu sais que tu en avais envie.

> Tu ne sais pas ce que tu veux après.

> C’est une réponse.

La route reste contenue ou se ferme.

---

# 35. Rencontre physique éventuelle Raphaëlle

J19 peut contenir une rencontre hors téléphone seulement si :

- elle était déjà prévue ;
- elle sert la résolution ;
- elle n’ajoute pas une nouvelle progression adulte après une conséquence impayée ;
- l’état Marie / Player le permet ou le secret est explicitement nommé ;
- Raphaëlle initie ou confirme ;
- le cadre est écrit avant la rencontre.

Exemples :

- rendre un élément de costume ;
- montrer un atelier ;
- marcher après rangement ;
- boire un thé ;
- confirmer ou fermer une invitation.

La messagerie s’arrête à la co-présence.

Aucun dialogue oral n’est transcrit.

Une rencontre physique ne produit pas automatiquement :

- un baiser ;
- une scène adulte ;
- une image ;
- une permission future.

---

# 36. Visuel Raphaëlle — Direction finale

**VISUEL J19-V2R — À PRODUIRE PLUS TARD**

```text
type:
IMAGE_DE_SCÈNE

center:
Raphaëlle

function:
montrer l’état du processus et de la personne après la décision

états possibles:
atelier encore accessible
costume rangé
compte créatif fermé
retour au travail
invitation datée
ordinaire après rôle
frontière professionnelle

audience:
joueur uniquement

circulation:
false
```

---

# 37. Effet du couple J17 sur Pauline

## Reconquête active

Pauline ne devient pas une exception cachée par défaut.

> Je ne vais pas être la petite récompense secrète à côté de votre réparation.

Elle ferme ou gèle.

## Accord provisoire

> `Provisoire` n’est pas une permission.

Le compartiment peut rester fermé ou sombrement actif, avec dette explicite.

## Reconfiguration en négociation

> Marie n’a pas donné son accord à notre version.

> Vous avez décidé de discuter.

> Pas de m’inclure.

## Double vie fragile

Pauline peut reconnaître le terrain familier :

> Tu es en train de construire exactement ce que je sais construire.

Cette branche peut approfondir le compartiment sombre.

## Fracture

> Une fracture n’est pas une séparation.

## Séparation

> Ça retire Marie de votre contrat.

> Pas Bastien du mien.

---

# 38. Effet du couple J17 sur Raphaëlle

## Reconquête active

Raphaëlle contient l’attirance ou ferme.

## Accord provisoire

Aucune progression nouvelle.

## Reconfiguration en négociation

> Je ne suis pas le prototype de votre futur accord.

Elle attend une règle réelle.

## Double vie fragile

Elle exige que le secret soit nommé comme tel.

## Fracture

> Une fracture reste un cadre.

> Même mauvais.

## Séparation

Elle vérifie que Player ne l’utilise pas comme fuite :

> Est-ce que tu me choisis, ou est-ce que tu cherches l’endroit le plus clair après une rupture ?

La séparation ne garantit aucune invitation.

---

# 39. Comparaison interdite

Player ne peut pas écrire à Pauline :

> Raphaëlle est plus honnête que toi.

Ni à Raphaëlle :

> Pauline au moins sait garder un secret.

Si une comparaison est tentée :

## Pauline

> Ne m’utilise pas pour évaluer une autre femme.

## Raphaëlle

> Je ne suis pas une réponse comparative.

La relation concernée se ferme ou se refroidit.

---

# 40. Contrat visuel global

Minimum : 3.

Maximum recommandé : 5.

## Configuration Pauline foreground

1. surface Pauline / Bastien réelle ;
2. Pauline décidant du compartiment ;
3. Raphaëlle dans son état court et ordinaire ;
4. preuve ou planner optionnel ;
5. conséquence sociale optionnelle.

## Configuration Raphaëlle foreground

1. Pauline dans son état court ;
2. Raphaëlle après le rôle ;
3. direction finale du processus ;
4. Maud ou travail comme conséquence ;
5. invitation future optionnelle.

## Configuration Sandra après-coup

1. Sandra après l’intimité ;
2. état court Pauline ;
3. état court Raphaëlle ;
4. vie officielle ou professionnelle ;
5. retour ordinaire.

Aucune pose ou composition définitive n’est fixée.

---

# 41. Connaissances de sortie

## Pauline sait

- si Player accepte une fermeture ou un compartiment ;
- ce qu’elle décide pour Bastien ;
- ce que Marie sait uniquement par une source légitime ;
- quelles traces existent encore.

Elle ne connaît pas automatiquement J18 Sandra ou le détail Raphaëlle.

## Raphaëlle sait

- si Player veut le processus, la personne ou la version ;
- l’état de son accès ;
- ce que Player affirme sur Marie ;
- ce que Maud sait réellement.

Elle ne connaît pas automatiquement la ligne Pauline.

## Marie

Ne connaît rien automatiquement de J19.

## Bastien

Possède uniquement les faits reçus par une source crédible.

## Maud

Connaît uniquement :

- son travail ;
- le processus créatif ;
- les présences auxquelles elle a réellement assisté ;
- ce que Raphaëlle choisit de lui dire.

---

# 42. États de sortie Pauline

Un état précis doit exister :

```text
surface restaurée
compartiment fermé
compartiment protégé
preuve réciproque
trahison Marie consciente
collision Bastien
contact privé limité
```

Aucun état ne reste :

```text
peut-être une route plus tard
```

sans règle ou fermeture.

---

# 43. États de sortie Raphaëlle

Un état précis doit exister :

```text
confiance créative
invitation future bornée
attirance reconnue et contenue
secret clair mais infidèle
frontière renforcée
collègue uniquement
```

Aucun accès ne reste ambigu.

---

# 44. Handoff vers J20

J20 devient :

```text
Dimanche — Ce que l’amitié peut porter
```

J20 reçoit :

- la place future de Nico ;
- l’état des alibis ;
- une éventuelle preuve réciproque Pauline ;
- une collision limitée Bastien ;
- une conséquence professionnelle ou sociale Raphaëlle ;
- Maud si son implication est réelle ;
- Jeff si l’après-coup Sandra le rend nécessaire ;
- un seul élément secondaire fort.

J20 ne doit pas :

- résoudre de nouveau Pauline ou Raphaëlle ;
- exposer toutes les routes à Nico ;
- faire de Nico le juge des couples ;
- transformer les partenaires en obstacles ;
- inventer une découverte générale.

---

# 45. Audit des voix

## Pauline

- faits courts ;
- correction sèche ;
- précision d’audience ;
- Bastien réel ;
- contrôle qui peut devenir érotique ou défensif ;
- aucun long discours moral parfait.

Exemples :

> La version publique est vraie.

> La version privée l’était aussi.

> Alors on enlève le mot `test`.

> Ce fil existe parce qu’on veut qu’il existe.

> Notre très mauvaise égalité.

## Raphaëlle

- observation concrète ;
- une question simple ;
- espace ;
- cadre précis ;
- ordinaire après le rôle ;
- refus de servir d’absolution.

Exemples :

> Le costume, je sais quoi en faire. Le lendemain, moins.

> Est-ce que tu voulais entrer dans mon processus ?

> Ne me remercie pas d’être claire.

> Tu voulais la limite comme spectacle. Pas le lendemain.

## Player

- minuscules ;
- réponses courtes ;
- possibilité d’assumer, demander ou réduire ;
- aucune parfaite maturité automatique.

---

# 46. Test sans nom

```text
Alors on enlève le mot test.
→ Pauline

Le costume, je sais quoi en faire. Le lendemain, moins.
→ Raphaëlle

Notre très mauvaise égalité.
→ Pauline

Tu voulais la limite comme spectacle. Pas le lendemain.
→ Raphaëlle

La version publique est vraie. La version privée l’était aussi.
→ Pauline

Je préfère que les permissions restent en phrases séparées.
→ Raphaëlle
```

---

# 47. Audit anti-générique

J19 évite :

- un menu Pauline / Raphaëlle ;
- deux résolutions complètes ;
- une photo intime pour chacune ;
- Pauline réduite à une fausse amie manipulatrice ;
- Bastien réduit à un idiot ;
- Raphaëlle réduite à la route saine ;
- Maud transformée en chaperon ou confidente omnisciente ;
- Pauline qui avoue parce que Player lui ordonne ;
- Raphaëlle qui absout un secret parce qu’il est bien nommé ;
- une reconfiguration Marie utilisée comme accord extérieur ;
- une séparation utilisée comme disponibilité ;
- une preuve présentée comme sécurité ;
- une suppression présentée comme oubli ;
- un costume présenté comme permission ;
- une nouvelle scène adulte après l’intimité Sandra ;
- un panda ou une blague contournant une limite ;
- un accès créatif équivalent à un accès corporel ;
- une surface publique décrite comme entièrement fausse ;
- une route sombre présentée comme propre.

---

# 48. Critères de validation J19

- [ ] un seul premier plan est développé ;
- [ ] la relation secondaire reçoit un état court ;
- [ ] l’après-coup Sandra devient prioritaire si nécessaire ;
- [ ] Bastien reste réel ;
- [ ] Maud reste réelle ;
- [ ] la surface Pauline reste authentique ;
- [ ] le compartiment Pauline reçoit une règle ou une fermeture ;
- [ ] une preuve réciproque n’est pas présentée comme sécurité ;
- [ ] Marie est reconnue dans la trahison Pauline si nécessaire ;
- [ ] Raphaëlle distingue processus, image et personne ;
- [ ] la fin du rôle produit un lendemain ;
- [ ] un secret Raphaëlle est nommé sans être absous ;
- [ ] le travail reste une conséquence possible ;
- [ ] aucune personne extérieure n’est engagée par le couple ;
- [ ] aucune séparation ne crée une permission automatique ;
- [ ] aucune image supprimée ne revient ;
- [ ] aucune image de consolation ;
- [ ] toute co-présence arrête le chat ;
- [ ] aucun dialogue oral ;
- [ ] trois contenus visuels minimum ;
- [ ] Pauline possède une direction précise ;
- [ ] Raphaëlle possède une direction précise ;
- [ ] J20 reçoit au maximum une conséquence secondaire forte.

---

# 49. Résumé canonique candidat

J19 ne compare pas Pauline et Raphaëlle.

La relation qui possède la version privée la plus engagée, la conséquence la plus urgente ou le lendemain le plus lourd reçoit le premier plan.

L’autre relation reçoit un état court et autonome.

Pauline doit décider ce que devient le compartiment construit à côté de sa vie officielle.

Elle peut :

- restaurer la surface ;
- fermer la ligne privée ;
- protéger consciemment le compartiment ;
- accepter une trace réciproque ;
- reconnaître une trahison envers Marie ;
- ou affronter un soupçon limité de Bastien.

Sa vie publique reste vraie.

Sa vie privée reste vraie aussi.

Le problème est sa tentative de les maintenir séparées afin que personne n’ait à répondre de leur contradiction.

Raphaëlle doit décider ce qui reste après le costume, le rôle, l’image et le processus.

Elle peut :

- maintenir une confiance créative ;
- proposer une invitation future bornée ;
- reconnaître et contenir l’attirance ;
- nommer un secret infidèle ;
- renforcer la frontière ;
- ou revenir à une relation strictement professionnelle.

Sa clarté ne devient jamais une absolution.

Un cadre précis entre deux personnes peut encore exclure Marie.

Si J18 contenait une intimité Sandra, son après-coup passe avant tout et aucune nouvelle progression adulte n’est ajoutée.

À la fin de J19, Pauline possède une direction.

Raphaëlle possède une direction.

Aucune n’est réduite à un hook vide.

> **Une version privée ne reste jamais seulement une image. Avec le temps, elle devient une règle, une dette, une place — ou une porte que son autrice décide de fermer.**
