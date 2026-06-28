# 28 — Référence UI/UX : NTR Sim et style messagerie mobile

## Statut

Référence visuelle et ergonomique pour les prochaines passes UI/UX de Réseau Intime.

Cette note est une **base forte d’orientation UI**, pas une simple inspiration vague.

## Source de référence

Cette note se base sur les captures fournies par Playervic montrant plusieurs écrans de NTR Sim :

- écran verrouillé / heure ;
- écran d’accueil smartphone ;
- liste des discussions ;
- conversation privée avec image ;
- conversation avec choix guidés ;
- notification en haut de conversation ;
- conversation de groupe ;
- transition temporelle plein écran ;
- indicateur de saisie avec bulle à trois points.

Objectif : reprendre très directement la logique d’habillage mobile, la palette sombre, la lisibilité, le placement des bulles, le rythme de conversation et les codes d’icônes génériques, tout en évitant d’importer directement des assets protégés du jeu de référence.

## Position sur la copie / reprise

On peut reprendre de très près :

```text
écran vertical type smartphone
barre de statut sombre
grille d’apps simple
icônes génériques lisibles
palette sombre
header contact
bulles gauche/droite
fonds de conversation sombres avec motif discret
réponses en bas
notifications en surimpression
transition heure/jour plein écran
bulle “écrit...” à trois points
```

À ne pas importer tel quel :

```text
assets personnages exacts
captures exactes
icônes propriétaires si elles existent comme fichiers du jeu
noms / personnages / textes du jeu de référence
layout pixel-perfect si cela donne une copie reconnaissable
```

Règle pratique : on copie le **langage UI mobile** et le confort d’usage, pas les fichiers ni l’identité artistique propriétaire.

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

Éléments à reprendre :

```text
fond sombre minimal
grande heure centrée
jour ou date sous l’heure
consigne discrète : taper pour continuer
barre de statut en haut
icônes système simples
```

Usage possible dans Réseau Intime :

- transition entre moments de journée ;
- retour au téléphone après ellipse ;
- début de chapitre ;
- réveil après soirée ;
- passage nuit / matin.

Exemples :

```text
08:12 — Le lendemain matin
12:27 — Pause déjeuner
23:18 — Trop tard pour une conversation normale
```

## Écran d’accueil smartphone

Éléments à reprendre :

```text
grille d’apps large et espacée
icônes très identifiables
fond sombre
barre de statut persistante
boutons de navigation bas simples
```

Apps prioritaires Réseau Intime :

```text
Messages
Social
Galerie
Contacts
Archives / Preuves
Paramètres
```

Règle : l’accueil doit être très lisible, pas surchargé. Le joueur doit comprendre où aller sans tutoriel lourd.

## Liste de discussions

Éléments à reprendre :

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

Éléments à reprendre :

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

Conversation privée cible :

```text
Top bar : avatar + nom + statut/lieu
Fil : bulles entrantes et sortantes
Image : carte visuelle / placeholder intégré au fil
Réponse guidée : bouton bas unique
Choix narratif : plusieurs boutons bas empilés
Debug : caché par défaut
```

Règle clé : Player doit être visiblement présent dans la conversation. Ses réponses ne doivent pas ressembler à des labels techniques.

## Bulles de messages

Règles à reprendre :

```text
entrant = aligné gauche
sortant = aligné droite
texte court ou moyen
largeur maximale pour éviter les lignes trop longues
marge verticale entre bulles
groupe de messages du même auteur possible
couleur entrante liée au personnage
couleur sortante constante pour Player
```

Dans les groupes, afficher le nom du personnage au-dessus ou dans la bulle.

Exemple :

```text
Sandra
Je ne devrais pas écrire.

Player
Tu peux me parler.
```

## Couleur par personnage

Chaque personnage important doit avoir une couleur de bulle reconnaissable. Le but est que le joueur identifie immédiatement la voix sociale ou intime d’une conversation.

Palette de départ, à ajuster visuellement :

```text
Player : bleu gris / ardoise
Marie : rose doux / mauve chaud
Mathilde : prune / beige rosé
Sandra : violet gris / bleu nuit intime
Raphaëlle : bleu clair / vert calme
Pauline : magenta sombre / rouge contrôlé
Nico : vert olive / orange social
Groupe amis : mélange social, avec couleur par intervenant
```

La couleur ne doit pas être agressive : elle sert à la lecture, pas à transformer l’interface en arcade.

## Rythme de messagerie et enchaînement

Décision validée : après une réponse de Player, il ne doit pas rester un bouton sélectionné / annulable dans la zone basse.

Règle :

```text
clic réponse ou choix
→ la zone de réponse disparaît ou se désactive proprement
→ bulle Player affichée à droite
→ indicateur “écrit...” du contact apparaît
→ messages suivants s’affichent un par un
→ si segment suivant : bouton Continuer seulement quand les messages courants sont terminés
→ si nouveau choix : choix disponibles seulement après les messages courants
```

Le bouton d’annulation après une réponse n’a pas de valeur dans ce prototype. Une réponse envoyée est envoyée.

## Indicateur “écrit...”

À ajouter dans le fil comme une vraie bulle de messagerie :

```text
bulle gauche
couleur du personnage
contenu : trois points animés ou trois pastilles statiques au début
```

Dans un groupe, l’indicateur doit pouvoir afficher le nom du personnage qui écrit :

```text
Valerie écrit...
Sandra écrit...
Pauline écrit...
```

Effet minimal acceptable en prototype :

```text
une bulle avec “...”
affichée pendant un court délai
puis remplacée par le message
```

Effet idéal plus tard : trois points animés.

## Temps d’écriture

Chaque message reçu doit avoir un temps d’écriture avant affichage.

Le temps dépend de la longueur du message :

```text
message très court : délai court
message moyen : délai moyen
message long : délai plus long
```

Formule indicative pour prototype :

```text
delay = clamp(0.35 + character_count * 0.018, 0.45, 2.4)
```

Contraintes :

```text
ne pas ralentir lourdement le debug
prévoir une manière simple d’accélérer plus tard
pas de hasard bloquant dans les tests
pas d’impact sur les routes ou effets
```

## Images et contenus visuels

Éléments à reprendre :

```text
image grande dans le fil
bordure colorée selon interlocuteur ou contexte
image avant / au milieu des messages
réactions verbales après l’image
```

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

Éléments à reprendre :

```text
bouton large en bas
texte court
souvent une seule réponse
sert à faire avancer la parole
ne ressemble pas à un menu de choix lourd
```

Si une seule réponse :

```text
Réponse guidée en bas
clic → Player envoie la phrase
zone basse nettoyée
messages suivants enchaînés avec typing
```

Si plusieurs réponses :

```text
choix narratif visible
les options peuvent porter des conséquences
après choix : zone basse nettoyée
```

Règle validée :

```text
Le bouton unique fait avancer la parole.
Le choix multiple oriente l’histoire.
```

## Transitions temporelles

Éléments à reprendre :

```text
overlay sombre
jour + heure au centre
conversation en arrière-plan assombrie
```

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

Éléments à reprendre :

```text
bannière en haut
avatar
nom du contact
texte court : nouveau message
instruction discrète : appuyer pour ouvrir
conversation en arrière-plan
```

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

Éléments à reprendre :

```text
header de groupe avec nom collectif
bulles colorées par participant
nom du participant affiché
messages courts
indicateur typing avec trois points
```

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

## Direction visuelle Réseau Intime

Réseau Intime doit être :

```text
adulte
intime
élégant
ambigu
lisible
sombre
mobile-first dans la sensation
```

Il peut assumer une forte proximité avec la base smartphone sombre de NTR Sim, puis évoluer par touches vers son identité propre.

## Prochaine passe UI recommandée

Milestone : `godot-chat-typing-flow-polish`

Scope :

```text
Supprimer l’état de bouton sélectionné/annulable après réponse.
Nettoyer la zone basse après envoi.
Ajouter un enchaînement automatique des messages reçus.
Afficher une bulle “écrit...” avant chaque message reçu.
Calculer le délai selon la longueur du message.
Ajouter couleurs de bulles par personnage.
Conserver Continuer entre segments.
Ne pas modifier les JSON narratifs.
Ne pas modifier les routes.
```

Fichiers probablement concernés :

```text
game/scripts/ui/ConversationView.gd
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
Clic réponse.
Player à droite : À peine. Pourquoi ?
Zone basse disparaît.
Bulle Sandra écrit... à gauche.
Sandra à gauche : Rien.
Bulle Sandra écrit... à gauche.
Sandra à gauche : Enfin si.
Bulle Sandra écrit... à gauche.
Sandra à gauche : Tu as cette façon de dire que ça va quand ça ne va pas.
Bouton Continuer apparaît.
Segment suivant : choix narratif multiple.
```

## Règle finale

> L’interface doit disparaître derrière la sensation de tenir un téléphone.