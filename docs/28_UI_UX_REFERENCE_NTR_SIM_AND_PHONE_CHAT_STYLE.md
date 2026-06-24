# 28 — Référence UI/UX : NTR Sim et style messagerie mobile

## Statut

Référence visuelle et ergonomique pour les prochaines passes UI/UX de Réseau Intime.

## Source de référence

Cette note se base sur les captures fournies par Ludovic montrant plusieurs écrans de NTR Sim :

- écran verrouillé / heure ;
- écran d’accueil smartphone ;
- liste des discussions ;
- conversation privée avec image ;
- conversation avec choix guidés ;
- notification en haut de conversation ;
- conversation de groupe ;
- transition temporelle plein écran.

Objectif : s’inspirer de la lisibilité, du rythme et de l’ergonomie, sans copier directement l’habillage exact, les icônes, les couleurs ou les assets.

## Ce qu’il faut retenir

NTR Sim fonctionne bien parce qu’il assume une vraie interface mobile :

```text
écran vertical lisible
barre de statut téléphone
top bar contact claire
bulles gauche/droite
réponses guidées en bas
images intégrées naturellement au fil
liste de conversations simple
notifications en surimpression
transitions de temps claires
```

Pour Réseau Intime, cette structure est pertinente parce que le jeu repose lui aussi sur :

```text
messages privés
groupes
réseau social
galerie
preuves
photos reçues
priorités de réponse
rythme de journée
```

## Écran verrouillé / reprise

Éléments observés :

```text
fond sombre minimal
grande heure centrée
jour ou date sous l’heure
consigne discrète : taper pour continuer
barre de statut en haut
icônes système très simples
```

Usage possible dans Réseau Intime :

- transition entre moments de journée ;
- retour au téléphone après ellipse ;
- début de chapitre ;
- réveil après soirée ;
- passage nuit / matin.

À adapter :

```text
08:12 — Le lendemain matin
12:27 — Pause déjeuner
23:18 — Trop tard pour une conversation normale
```

## Écran d’accueil smartphone

Éléments observés :

```text
grille d’apps large et espacée
icônes très identifiables
fond sombre
barre de statut persistante
boutons de navigation bas simples
```

Application à Réseau Intime :

Apps prioritaires :

```text
Messages
Social
Galerie
Contacts
Archives / Preuves
Paramètres
```

Règle : l’accueil doit être très lisible, pas surchargé. L’utilisateur doit comprendre où aller sans tutoriel lourd.

## Liste de discussions

Éléments observés :

```text
header avec retour + titre Discussions
liste verticale de cartes arrondies
avatar à gauche
nom du contact
dernier message en sous-texte
point vert en ligne
badge/point de notification si non lu
beaucoup d’espace vide assumé
```

Application à Réseau Intime :

Chaque conversation devrait afficher :

```text
avatar placeholder
nom du personnage ou groupe
dernier message ou dernier événement
statut : en ligne, vu, écrit..., absent, occupé
badge si message non lu ou preuve nouvelle
```

Exemples :

```text
Marie — Tu rentres vers quelle heure ?
Sandra — Je ne devrais pas écrire.
Mathilde — Je suis en bas.
Groupe amis — Pauline : Samedi chez nous.
```

## Conversation privée

Éléments observés :

```text
header fixe avec retour, avatar, nom, statut ou lieu
fond sombre avec motif discret
messages entrants à gauche
messages joueur à droite
bulles arrondies
couleur de bulle liée au contact
réponses guidées en bas sous forme de bouton large
images grandes intégrées au fil
```

Application à Réseau Intime :

Conversation privée cible :

```text
Top bar : avatar + nom + statut/lieu
Fil : bulles entrantes et sortantes
Image : carte visuelle / placeholder intégré au fil
Réponse guidée : bouton bas unique
Choix narratif : plusieurs boutons bas empilés
Debug : caché par défaut
```

Règle clé : Ludo doit être visiblement présent dans la conversation. Ses réponses ne doivent pas ressembler à des labels techniques.

## Bulles de messages

Règles à reprendre :

```text
entrant = aligné gauche
sortant = aligné droite
texte court ou moyen
largeur maximale pour éviter les lignes trop longues
marge verticale entre bulles
groupe de messages du même auteur possible
```

Dans les groupes, afficher le nom du personnage au-dessus ou dans la bulle.

Exemple :

```text
Sandra
Je ne devrais pas écrire.

Ludo
Tu peux me parler.
```

## Images et contenus visuels

Éléments observés :

```text
image grande dans le fil
bordure colorée selon interlocuteur ou contexte
image avant / au milieu des messages
réactions verbales après l’image
```

Application à Réseau Intime :

Pour les placeholders :

```text
[Image placeholder]
ID : photo_mathilde_home_tier1_placeholder
Tags : mathilde, home, ambiguous
Risque : 3
```

Plus tard : remplacer par vrais assets IA / placeholders illustrés.

Important : une image ne doit pas être un simple lien technique. Elle doit exister comme événement dans le fil.

## Réponses guidées

Éléments observés :

```text
bouton large en bas
texte court
souvent une seule réponse
sert à faire avancer la parole
ne ressemble pas à un menu de choix lourd
```

Application à Réseau Intime :

Si une seule réponse :

```text
Réponse guidée en bas
clic → Ludo envoie la phrase
puis messages suivants
```

Si plusieurs réponses :

```text
choix narratif visible
les options peuvent porter des conséquences
```

Règle validée :

```text
Le bouton unique fait avancer la parole.
Le choix multiple oriente l’histoire.
```

## Transitions temporelles

Éléments observés :

```text
overlay sombre
jour + heure au centre
conversation en arrière-plan assombrie
```

Application à Réseau Intime :

Utiliser pour :

- changement de moment dans une journée ;
- lendemain matin ;
- passage à la nuit ;
- attente d’une réponse ;
- coupure après message supprimé.

Exemples :

```text
Mercredi — 10:47
Samedi — 20:34
Le lendemain — 09:18
```

## Notifications

Éléments observés :

```text
bannière en haut
avatar
nom du contact
texte court : New message
instruction discrète : appuyer pour ouvrir
conversation en arrière-plan
```

Application à Réseau Intime :

Utiliser pour :

```text
message privé pendant une autre conversation
Pauline qui interrompt
Sandra qui écrit au mauvais moment
Nico qui tague Marie
preuve galerie
fond d’écran révélé
```

## Conversations de groupe

Éléments observés :

```text
header de groupe avec nom collectif
bulles colorées par participant
nom du participant affiché
messages courts
indicateur typing avec trois points
```

Application à Réseau Intime :

Le groupe doit avoir une couleur sociale différente des messages privés.

Exemples de groupes :

```text
Groupe amis
Soirée chez Pauline
Famille / cercle Marie-Mathilde plus tard si besoin
```

Le groupe sert surtout à :

- pression sociale ;
- sous-entendus publics ;
- Nico qui vise Marie ;
- Pauline qui teste ;
- Mathilde qui observe ;
- traces visibles.

## Ce qu’il ne faut pas copier directement

Ne pas copier :

```text
icônes exactes
palette exacte
assets personnages
motifs de fond exacts
layout pixel-perfect
noms / structures propres à NTR Sim
```

À reprendre uniquement :

```text
principes de lisibilité
rythme de chat
hiérarchie visuelle
confort mobile
placement des réponses
simplicité de navigation
```

## Direction visuelle Réseau Intime

Réseau Intime doit être plus :

```text
adulte
intime
élégant
ambigu
moins cartoon
moins jeu mobile générique
```

Palette possible :

```text
fond : bleu nuit / graphite
bulles Ludo : bleu gris sobre
Marie : rose doux / chaud
Mathilde : prune ou beige rosé
Sandra : violet doux / gris intime
Raphaëlle : bleu clair / vert calme
Pauline : rouge sombre / magenta contrôlé
Nico : vert olive / orange social
```

Ces couleurs sont indicatives, à tester plus tard.

## Prochaine passe UI recommandée

Milestone : `godot-chat-bubbles-ui-prototype`

Scope :

```text
Créer un rendu chat vertical plus proche d’une messagerie.
Afficher bulles entrantes / sortantes.
Mettre Ludo à droite.
Mettre interlocuteur à gauche.
Ajouter header conversation avec avatar / nom / statut.
Afficher réponses guidées en bas.
Afficher choix narratifs en bas, empilés.
Garder debug caché par défaut.
Ne pas créer de galerie complète.
Ne pas ajouter de nouveaux contenus narratifs.
```

Fichiers probablement concernés :

```text
game/scenes/smartphone/ConversationView.tscn
game/scenes/smartphone/PhonePrototype.tscn
game/scripts/ui/ConversationView.gd
game/scripts/ui/PhonePrototype.gd
game/scripts/ui/DebugPanel.gd
tests/test_godot_prototype_static.py
```

## Critère de réussite manuel

Ouvrir Jour 1 — Sandra.

Le résultat doit ressembler à :

```text
Header : Sandra — En ligne / statut
Sandra à gauche : Hey, tu survis à ta journée ?
Sandra à gauche : J’ai pensé à toi tout à l’heure.
Réponse en bas : À peine. Pourquoi ?
Ludo à droite : À peine. Pourquoi ?
Sandra à gauche : Rien.
Sandra à gauche : Enfin si.
Continuer
Segment suivant : choix narratif multiple
```

## Règle finale

> L’interface doit disparaître derrière la sensation de tenir un téléphone.