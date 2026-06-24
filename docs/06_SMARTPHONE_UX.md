# 06 — UX smartphone

## Principe

Le jeu se joue à travers un smartphone fictif. Le joueur ne consulte pas un menu classique : il navigue dans des applications, reçoit des notifications et bascule entre plusieurs conversations.

Objectif : immersion maximale.

## Scope audio / voix

Le prototype et le scope initial n’incluent pas de vocaux ou d’appels simulés avec voix.

Sont exclus du scope initial :

```text
messages vocaux avec audio
appels vocaux simulés
doublage des personnages
système de son narratif lié aux voix
```

Les appels manqués peuvent éventuellement exister sous forme de notification textuelle, mais aucune voix ne doit être produite ou gérée.

## Écran principal

L’écran principal représente l’accueil du téléphone de Ludo.

Applications proposées :

```text
Messages
Réseau social
Galerie
Contacts
Notes
Archives
Paramètres
```

Éléments système importants :

```text
Fond d’écran
Notifications
Badge d’applications
Mode discret / confidentialité visuelle
```

## Application Messages

Cœur du jeu.

Fonctions :

- conversations privées ;
- conversations de groupe ;
- messages entrants ;
- choix de réponse ;
- messages supprimés ;
- photos ;
- vidéos ;
- indicateur « en train d’écrire » ;
- horodatage narratif ;
- statut lu / non lu.

Conversations principales :

```text
Marie
Mathilde
Sandra
Raphaëlle
Pauline
Nico
Groupe soirée
Groupe amis
```

## Réseau social

Application utile pour les tensions publiques.

Fonctions :

- posts ;
- stories ;
- réactions ;
- commentaires ;
- identifications ;
- photos de groupe ;
- archives de stories.

Exemples :

```text
Nico a réagi à la story de Marie : 🔥
Pauline a publié une photo de la soirée.
Mathilde a commenté : « On dirait que quelqu’un était ailleurs hier soir. »
```

## Galerie

La galerie garde les contenus reçus ou capturés.

Catégories :

```text
Photos
Vidéos
Captures
Preuves
Archives
Favoris
Fonds d’écran
```

Chaque contenu doit afficher :

- personnage ;
- date ou chapitre ;
- contexte ;
- niveau de risque ;
- statut : conservé, supprimé, capturé, découvert ;
- statut fond d’écran si applicable.

Actions possibles :

- ouvrir ;
- conserver ;
- supprimer ;
- capturer ;
- archiver ;
- définir comme fond d’écran ;
- retirer comme fond d’écran ;
- montrer à quelqu’un si la scène le permet.

## Fond d’écran

Le joueur peut définir une image reçue comme fond d’écran du téléphone.

Ce choix est expressif tant que le téléphone reste privé, mais peut devenir une preuve si le téléphone est montré.

Types de fonds possibles :

```text
neutre
Marie tendre
Marie provocante
Mathilde ambiguë
Sandra intime
Raphaëlle douce
Pauline provocante
Marie + Nico
```

### Révélation du fond d’écran

Certaines scènes peuvent demander au joueur de montrer son téléphone ou son fond d’écran.

Exemple :

```text
Pauline : Montre ton fond d’écran, on va voir qui est le plus cringe 😇
Nico : Ah oui, vas-y Ludo.
Marie : Pourquoi pas.
```

Si le fond d’écran est compromettant, les personnages réagissent selon leurs liens avec l’image.

Exemple avec Mathilde :

```text
Marie : C’est Mathilde ?
Mathilde : Attends, quoi ?
Pauline : Ah.
Nico : Joli choix.
```

### Conséquences possibles

- Marie rassurée si le fond est une photo tendre d’elle.
- Marie soupçonneuse si le fond est une autre femme.
- Mathilde gênée ou excitée si elle découvre qu’elle est le fond d’écran.
- Pauline peut utiliser le fond comme preuve sociale.
- Nico peut provoquer Ludo.
- Le groupe peut rendre public un secret jusque-là privé.

## Notifications

Les notifications sont un système narratif central.

Types :

```text
Message privé
Message de groupe
Photo reçue
Vidéo reçue
Story
Réaction
Message supprimé
Appel manqué textuel éventuel
Alerte galerie
Alerte fond d’écran
```

Le joueur peut parfois choisir quelle notification ouvrir en premier. Ce choix peut modifier l’histoire.

Exemple de scène :

```text
Sandra : Je crois que j’ai besoin de te parler ce soir.
Pauline vous a envoyé une photo.
Mathilde : Tu vas ouvrir ça alors que Marie est juste là ?
Nico a identifié Marie dans une story.
```

Ouvrir Sandra nourrit l’intime.  
Ouvrir Pauline nourrit le piège.  
Répondre à Mathilde nourrit l’interdit.  
Regarder la story nourrit la jalousie.

## Notes

Application optionnelle pour :

- journal de Ludo ;
- indices ;
- souvenirs ;
- pensées après choix importants ;
- résumé des relations.

À utiliser prudemment : le jeu doit rester principalement porté par les messages.

## Archives

Application utile pour :

- messages supprimés ;
- captures cachées ;
- contenus verrouillés ;
- preuves conservées ;
- anciens fonds d’écran si cela sert une route.

Les archives peuvent devenir importantes dans les routes enquête, Pauline, Sandra ou harem chaos.

## Paramètres

Fonctions possibles :

- sauvegarder ;
- charger ;
- régler vibration / sons d’interface simples ;
- voir statistiques de partie en debug uniquement ;
- accessibilité ;
- mode discret pour masquer contenus visuels dans les menus ;
- confidentialité des notifications ;
- fond d’écran actif.

## Rythme d’une séquence type

```text
1. Notification reçue.
2. Le joueur ouvre ou ignore.
3. Conversation.
4. Choix de réponse.
5. Effets variables.
6. Éventuel contenu visuel.
7. Choix sur le contenu : conserver, supprimer, répondre, montrer, cacher, mettre en fond d’écran.
8. Conséquence immédiate ou différée.
```

## Règle UX

Le joueur doit toujours comprendre :

- qui écrit ;
- dans quelle application ;
- si la conversation est privée ou publique ;
- si un contenu est risqué ;
- si une réponse est anodine, ambiguë ou dangereuse ;
- si un contenu est actuellement utilisé comme fond d’écran.

Mais le jeu ne doit pas tout expliciter de façon mécanique. Une part de doute doit rester.