# 13 — Patterns de rythme des scènes

## Objectif

Définir la grammaire des scènes smartphone.

Le jeu ne doit pas être une simple alternance :

```text
Message → Réponse → Message → Réponse
```

Il doit créer une tension entre :

- ce que le joueur lit ;
- ce qu’il choisit d’ouvrir ;
- ce qu’il laisse attendre ;
- ce qu’il conserve ;
- ce qu’il supprime ;
- ce qui pourra être découvert plus tard.

## Scope voix / audio

Les patterns de scènes n’utilisent pas de vocaux ou d’appels avec voix dans le scope initial. Les tensions doivent être portées par texte, images, vidéos, stories, notifications, captures, fonds d’écran et silences.

## Règle centrale

> Une scène smartphone doit créer une tension entre notification, priorité, réponse, trace et conséquence différée.

## Pattern 1 — Conversation simple

### Usage

- Routine avec Marie.
- Message professionnel avec Raphaëlle.
- Message léger de Sandra.
- Organisation avec Pauline.

### Structure

```text
Notification
Ouverture conversation
2 à 5 messages
Choix joueur
Réaction immédiate
Fin douce ou tension légère
```

### Choix recommandés

2 à 3 choix.

### Risque

Faible. Peut être purement relationnel ou tonal.

### Exemple

```text
Marie : Tu rentres vers quelle heure ?
Player : Pas trop tard.
Marie : Tu dis ça à chaque fois.
```

## Pattern 2 — Conversation intime qui glisse

### Usage

- Sandra se confie.
- Raphaëlle prend soin de Player.
- Mathilde écrit tard.
- Marie tente une reconquête ou exprime un doute.

### Structure

```text
Message banal
Confession ou sous-entendu
Choix prudent / ambigu / direct
Silence
Reprise plus intime
Petit risque
```

### Choix recommandés

3 choix : prudent, ambigu, direct.

### Risque

Moyen. Crée un début de route ou un flag.

### Exemple

```text
Sandra : Je peux te dire un truc sans que tu me juges ?
Sandra : Je me sens seule même quand je ne suis pas seule.
```

## Pattern 3 — Messages croisés

### Usage

- Soirée chez Pauline.
- Player est avec Marie, mais Sandra écrit.
- Pauline provoque pendant que Mathilde observe.
- Nico réagit à une story de Marie pendant une autre conversation.

### Structure

```text
Notification A : intime
Notification B : risquée
Notification C : jalousie
Choix d’ouverture
La conversation ouverte avance
Les autres attendent, changent ou produisent une conséquence différée
```

### Choix recommandés

Choix de priorité plutôt que choix de texte.

### Risque

Élevé, car ignorer une notification peut compter autant que l’ouvrir.

### Règle de lisibilité

Pas plus de trois tensions actives à la fois :

```text
1 conversation principale
1 interruption
1 menace visible
```

### Exemple

```text
Sandra : Je crois que j’ai besoin de te parler ce soir.
Pauline vous a envoyé une photo.
Mathilde : Tu vas ouvrir ça alors que Marie est juste là ?
Nico a réagi à la story de Marie : 🔥
```

## Pattern 4 — Vérification d’information

### Usage

- Regarder une story.
- Comparer un horaire.
- Vérifier un message supprimé.
- Relire une conversation.
- Fouiller la galerie.
- Ouvrir une archive.

### Structure

```text
Soupçon
Choix : vérifier ou ne pas vérifier
Ouverture app secondaire
Indice ambigu
Interprétation possible
Variable modifiée
Retour à la conversation principale
```

### Choix recommandés

2 à 3 choix : vérifier, ignorer, demander directement.

### Risque

Moyen à élevé.

### Exemple

```text
Nico a réagi à la story de Marie : 🔥

Choix :
- Ouvrir la story.
- Ignorer.
- Demander à Marie.
```

## Pattern 5 — Contenu visuel reçu

### Usage

- Photo ou vidéo reçue.
- Story ambiguë.
- Capture envoyée.
- Contenu supprimé.

### Structure

```text
Notification contenu
Message d’accompagnement
Ouverture ou ignorance
Affichage du contenu
Choix : répondre, conserver, supprimer, capturer, demander plus, mettre en fond d’écran
Effet immédiat
Risque différé
```

### Choix recommandés

3 à 5 choix, mais tous ne doivent pas être disponibles à chaque fois.

### Risque

Variable selon personnage.

### Exemples par personnage

Sandra : le cœur de la scène est le retrait.

```text
Sandra : Oublie. Je n’aurais pas dû.
```

Pauline : le cœur de la scène est le piège.

```text
Pauline : Ne réagis pas.
```

Mathilde : le cœur de la scène est l’interdit domestique.

```text
Mathilde : Tu ne montres pas ça à Marie, hein ?
```

## Pattern 6 — Silence et attente

### Usage

- Sandra fuit après une question trop directe.
- Marie répond froidement.
- Raphaëlle coupe si Player reste flou.
- Mathilde laisse un message en vu.
- Pauline attend que Player s’expose.

### Structure

```text
Message fort
Lu / pas de réponse
Autre notification arrive
Choix : relancer, attendre, changer de conversation
Conséquence selon personnage
```

### Risque

Moyen. Le silence peut déclencher une route ou une fuite.

### Exemple

```text
Player : Tu veux quoi avec moi, vraiment ?
Sandra a lu.
...
Sandra est hors ligne.
```

## Pattern 7 — Conversation de groupe contaminée

### Usage

- Soirée chez Pauline.
- Groupe amis.
- Photo de groupe.
- Sous-entendu public suivi d’un message privé.

### Structure

```text
Message public
Réaction d’un personnage
Message privé parallèle
Choix : répondre publiquement, répondre en privé, ignorer
Conséquence sociale
```

### Risque

Élevé. Le groupe donne de la visibilité à des tensions privées.

### Exemple

```text
Groupe soirée
Pauline : Photo de la soirée 😇
Nico : Marie vole encore la lumière.
Mathilde : Certains avaient l’air ailleurs pourtant.
Marie : Ah bon ?

Mathilde en privé : J’ai vu ton téléphone.
```

## Pattern 8 — Confrontation

### Usage

- Marie pose une question directe.
- Raphaëlle demande de la clarté.
- Sandra fuit ou avoue.
- Pauline révèle une preuve.
- Nico confronte Player.
- Mathilde culpabilise.

### Structure

```text
Question directe
Choix : mentir / minimiser / avouer / attaquer / ouvrir
Réaction forte
Changement de route ou menace
```

### Choix recommandés

4 à 5 choix.

### Risque

Très élevé. Une confrontation peut verrouiller ou fermer une route.

### Exemple

```text
Marie : Je ne te demande pas si tu as fait quelque chose. Je te demande si tu es encore vraiment là.
```

## Pattern 9 — Choix anodins

### Usage

Créer de la naturalité et empêcher le joueur d’associer automatiquement chaque choix à une conséquence majeure.

### Structure

```text
Moment banal
Choix de ton ou de préférence
Effet faible ou nul
Éventuelle couleur de relation
Aucune conséquence forte immédiate
```

### Exemples

```text
Marie : On mange quoi ce soir ?
- Comme tu veux.
- Je peux cuisiner.
- On commande ?
```

```text
Raphaëlle : Café ?
- Noir.
- Trop tôt pour décider.
- Seulement si tu m’accompagnes.
```

### Risque

Faible ou nul.

### Règle

Tous les choix ne doivent pas être des bifurcations. Certains doivent servir au rythme, à la couleur du personnage ou à l’immersion.

## Pattern 10 — Conséquence différée

### Usage

Empêcher les choix de paraître mécaniques.

### Structure

```text
Choix apparemment mineur
Flag discret
Plusieurs scènes sans effet visible
Réactivation du flag dans une scène ultérieure
Conséquence cohérente
```

### Exemple

Player dit à Marie qu’il ne connaît pas bien Pauline.
Plus tard, Pauline révèle une conversation privée.
Marie comprend l’incohérence.

### Risque

Élevé si mal préparé. Le joueur doit pouvoir comprendre la conséquence en relisant l’histoire.

## Pattern 11 — Fond d’écran compromettant

### Usage

Transformer une image privée en preuve sociale.

Ce pattern exploite une action apparemment expressive : définir une photo reçue comme fond d’écran.

### Structure

```text
Le joueur reçoit une photo
Choix : définir comme fond d’écran
Plusieurs scènes sans conséquence directe
Scène sociale ou groupe
Un personnage demande à voir le téléphone / fond d’écran
Révélation du fond actif
Réactions selon l’image
Conséquence immédiate ou différée
```

### Choix recommandés

Au moment de la révélation :

```text
Montrer sans réfléchir
Masquer le téléphone
Changer de sujet
Assumer
Mentir
```

### Risque

Variable selon le fond d’écran.

```text
Fond neutre                → risque faible
Marie tendre               → peut rassurer
Marie provocante           → peut gêner ou réveiller le couple
Mathilde ambiguë           → soupçon familial / domestique
Sandra intime              → infidélité émotionnelle visible
Raphaëlle douce            → soupçon de relation de travail
Pauline provocante         → preuve sociale / piège
Marie + Nico               → jalousie ou NTR
```

### Exemple

```text
Pauline : Montre ton fond d’écran, on va voir qui est le plus cringe 😇
Nico : Ah oui, vas-y Player.
Marie : Pourquoi pas.
```

Si fond Mathilde :

```text
Marie : C’est Mathilde ?
Mathilde : Attends, quoi ?
Pauline : Ah.
Nico : Joli choix.
```

### Règle

Le fond d’écran ne doit pas être vérifié partout. Il doit être utilisé dans des scènes prévues pour que la conséquence soit forte, lisible et non arbitraire.

## Règles de rythme

1. Alterner scènes calmes et scènes à tension.
2. Ne pas mettre des choix critiques dans chaque scène.
3. Utiliser les choix anodins pour rendre le téléphone vivant.
4. Limiter les messages croisés à des moments forts.
5. Utiliser les silences comme événements.
6. Une preuve doit avoir été préparée avant d’exploser.
7. Une conséquence différée doit sembler logique, pas arbitraire.
8. Une scène commune doit pouvoir changer de sens selon la route dominante.
9. Un contenu mis en fond d’écran devient un risque seulement s’il est révélé dans une scène prévue.
10. Les scènes ne doivent pas dépendre de voix ou d’appels audio dans le scope initial.