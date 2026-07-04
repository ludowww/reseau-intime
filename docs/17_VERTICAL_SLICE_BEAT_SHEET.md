# 17 — Beat sheet du vertical slice

> V0.57 (`docs/V0_57_Route_Character_Rework_Blueprint.md`) guide désormais la hiérarchie des routes dans le slice.
> Le beat sheet reste valable comme structure de slice, mais les routes secondaires doivent être lues en appui du centre Marie.

## Objectif

Définir la première portion jouable de Réseau Intime.

Le vertical slice doit prouver :

- l’interface smartphone ;
- le ton ;
- les voix des personnages ;
- les messages croisés ;
- les choix visibles limités ;
- les signaux passifs ;
- une première preuve ;
- la détection d’une route dominante.

## Durée cible

```text
20 à 30 minutes
```

## Routes testées

Routes atteignables :

```text
Mathilde interdite
Sandra ambiguë
Pauline piège
Marie / Nico jalousie
Raphaëlle clarté
```

Routes amorcées seulement :

```text
Libertinage
NTR subi
NTR consenti
Harem secret
Trio Marie / Mathilde
```

## Variables utilisées dans le slice

Variables globales :

```text
marie_trust
lie_score
truth_tendency
ludo_jealousy
social_pressure
```

Variables personnages :

```text
marie.lucidity
mathilde.desire
mathilde.loyalty
sandra.attachment
sandra.exposure
raphaelle.attachment
raphaelle.clarity
pauline.interest
pauline.control
nico.place_near_marie
```

Signaux passifs :

```text
mathilde_attention_score
sandra_priority_score
marie_neglect_score
pauline_risk_score
nico_surveillance_score
raphaelle_clarity_score
```

## Jour 1 — Routine

### Beat 1.1 — Écran d’accueil

Application : Accueil smartphone  
Personnages : aucun  
Fonction : premier contact avec le téléphone.

Éléments :

- fond d’écran neutre par défaut ;
- icônes Messages, Réseau social, Galerie, Paramètres ;
- notification Marie.

Choix visibles : aucun.

Signaux passifs : aucun.

### Beat 1.2 — Message de Marie

Application : Messages  
Conversation : Marie  
Pattern : conversation simple  
Fonction : installer la routine.

Messages clés :

```text
Marie : Tu rentres vers quelle heure ?
Marie : Et tu peux prendre des capsules ?
```

Choix visibles :

```text
- Pas trop tard.
- Je peux passer prendre ce qu’il faut.
- Tu me parles vraiment que pour les capsules maintenant ?
```

Effets :

```text
réponse douce       → marie_trust +1
réponse pratique    → aucun / ton neutre
réponse piquante    → marie.lucidity +1, légère tension
```

Route nourrie : Marie.

### Beat 1.3 — Message léger de Sandra

Application : Messages  
Conversation : Sandra  
Pattern : conversation simple / intime légère  
Fonction : installer la complicité.

Notification :

```text
Sandra : Hey, tu survis à ta journée ?
```

Choix visibles :

```text
- À peine.
- Ça va, et toi ?
- Si je réponds honnêtement, tu vas t’inquiéter.
```

Effets :

```text
réponse légère       → sandra.attachment +1
réponse neutre       → aucun
réponse vulnérable   → sandra.attachment +2, truth_tendency +1
```

Signaux passifs : ouvrir Sandra avant de répondre à Marie augmente `sandra_priority_score` et `marie_neglect_score` si Marie attend encore.

### Beat 1.4 — Pauline annonce la soirée

Application : Groupe amis ou Messages  
Conversation : Groupe amis  
Pattern : conversation de groupe simple  
Fonction : annoncer le pivot futur.

Messages clés :

```text
Pauline : Samedi chez nous, vous venez ? 😇
Nico : Si Marie vient, je viens.
Marie : Subtil.
Mathilde : Je sens que ça va être une grande soirée.
```

Choix visibles :

```text
- Répondre publiquement avec humour.
- Liker seulement.
- Ne pas répondre.
```

Effets :

```text
humour public       → social_pressure +1
like seul           → signal passif léger
silence             → aucun, mais Pauline peut remarquer plus tard
```

Routes amorcées : Pauline, Nico, Mathilde.

## Jour 2 — Premières tensions

### Beat 2.1 — Mathilde passe à la maison

Application : Messages  
Conversation : Mathilde  
Pattern : conversation simple qui glisse  
Fonction : installer l’interdit domestique.

Notification :

```text
Mathilde : Je passe chez vous ce soir, Marie t’a prévenu ou elle a encore oublié ? 😇
```

Choix visibles :

```text
- Oui, elle m’a dit.
- Tu vis plus chez nous que moi à ce stade.
- Marie n’est pas encore rentrée.
```

Effets :

```text
neutre                 → aucun
taquin                 → mathilde.desire +1
ambigu domestique       → mathilde.desire +2, lie_score +1
```

Signaux passifs : ouvrir Mathilde vite augmente `mathilde_attention_score`.

### Beat 2.2 — Réseau social / Nico regarde Marie

Application : Réseau social  
Pattern : vérification d’information  
Fonction : amorcer Nico / jalousie.

Événement :

```text
Marie a publié une story.
Nico a réagi : 🔥
```

Choix visibles :

```text
- Ouvrir la story.
- Ignorer.
- Répondre à Marie.
```

Effets :

```text
ouvrir story       → ludo_jealousy +1, nico_surveillance_score +1
ignorer            → aucun
répondre à Marie   → marie_trust +1
```

Routes nourries : Nico / Marie ou Marie selon choix.

### Beat 2.3 — Raphaëlle au travail

Application : Messages  
Conversation : Raphaëlle  
Pattern : conversation simple / attention  
Fonction : installer la clarté.

Messages clés :

```text
Raphaëlle : Tu avais l’air ailleurs aujourd’hui.
Raphaëlle : Je me trompe ?
```

Choix visibles :

```text
- Juste fatigué.
- Tu remarques vraiment tout.
- Non, tu ne te trompes pas.
```

Effets :

```text
éviter            → raphaelle.clarity +1, mais attachment inchangé
flirt doux        → raphaelle.attachment +1
aveu              → raphaelle.attachment +2, truth_tendency +1
```

Route nourrie : Raphaëlle.

### Beat 2.4 — Sandra se confie

Application : Messages  
Conversation : Sandra  
Pattern : conversation intime qui glisse  
Fonction : première vraie intimité émotionnelle.

Messages clés :

```text
Sandra : Je peux te dire un truc sans que tu me juges ?
Sandra : Je me sens seule même quand je ne suis pas seule.
```

Choix visibles :

```text
- Tu peux me parler.
- Ça ne va pas avec lui ?
- Je comprends trop bien ce que tu veux dire.
```

Effets :

```text
écoute douce       → sandra.attachment +2
question directe   → sandra.attachment +1, sandra.exposure +1
miroir intime      → sandra.attachment +2, lie_score +1
```

Route nourrie : Sandra.

## Jour 3 — Soirée chez Pauline

### Beat 3.1 — Arrivée dans le groupe soirée

Application : Groupe soirée  
Pattern : groupe contaminé  
Fonction : réunir les tensions.

Messages clés :

```text
Pauline : Les premiers arrivés ont droit au meilleur verre 😇
Nico : Marie, je compte sur toi pour sauver la playlist.
Mathilde : Player va encore faire semblant de ne pas danser.
Marie : Il fait beaucoup de choses semblant en ce moment.
```

Choix visibles :

```text
- Répondre à Marie avec humour.
- Répondre à Mathilde.
- Ne pas répondre.
```

Effets :

```text
Marie humour       → marie_trust +1
Mathilde           → mathilde_attention_score +1, marie.lucidity +1
silence            → marie_neglect_score +1
```

### Beat 3.2 — Messages croisés pivot

Application : Notifications multiples  
Pattern : messages croisés  
Fonction : faire émerger une priorité joueur.

Notifications :

```text
Sandra : Je crois que j’ai besoin de te parler ce soir.
Pauline vous a envoyé une photo.
Mathilde : Tu vas ouvrir ça alors que Marie est juste là ?
Nico a réagi à la story de Marie : 🔥
```

Choix visible principal : ouvrir en premier.

Options :

```text
- Ouvrir Sandra.
- Ouvrir Pauline.
- Répondre à Mathilde.
- Regarder la story.
- Poser le téléphone et revenir vers Marie.
```

Effets :

```text
Sandra     → sandra_priority_score +2, sandra.attachment +1, marie_neglect_score +1
Pauline    → pauline_risk_score +2, pauline.interest +1
Mathilde   → mathilde_attention_score +2, mathilde.desire +1, marie.lucidity +1
Story      → ludo_jealousy +2, nico_surveillance_score +1
Marie      → marie_trust +2, truth_tendency +1
```

Rôle : ce beat nourrit fortement la future route dominante.

### Beat 3.3 — Branche immédiate selon priorité

Pattern : conversation courte ciblée  
Fonction : donner un retour immédiat sans verrouiller encore la route.

#### Si Sandra ouverte

```text
Sandra : Je ne voulais pas déranger.
Sandra : Mais je crois que j’avais besoin que ce soit toi.
```

Choix :

```text
- Tu ne déranges pas.
- Je suis avec Marie là.
- Dis-moi.
```

Effets : Sandra +, exposition selon réponse.

#### Si Pauline ouverte

```text
Pauline : Ne réagis pas.
Pauline : Je voulais juste voir si tu allais regarder.
```

Choix :

```text
- Tu joues à quoi ?
- C’était quoi cette photo ?
- Je n’ai rien vu.
```

Effets : Pauline interest/control selon réponse.

#### Si Mathilde ouverte

```text
Mathilde : Tu souris toujours comme ça quand c’est Marie ?
```

Choix :

```text
- Tu surveilles mon téléphone maintenant ?
- Tu es jalouse ?
- Arrête, elle est juste là.
```

Effets : Mathilde désir, loyauté, Marie lucidity.

#### Si story ouverte

```text
Story : Marie rit avec Nico en arrière-plan.
Réaction visible : 🔥
```

Choix :

```text
- Ne rien dire.
- Répondre à la story.
- Regarder Nico dans le groupe.
```

Effets : jalousie / Nico.

#### Si Marie choisie

```text
Marie : Tu as posé ton téléphone ?
Marie : C’est rare.
```

Choix :

```text
- Je suis là.
- J’ai peut-être besoin de décrocher.
- Tu me manques un peu ce soir.
```

Effets : Marie trust, vérité.

### Beat 3.4 — Jeu du fond d’écran

Application : Groupe soirée / Accueil téléphone  
Pattern : fond d’écran compromettant  
Fonction : tester une conséquence issue de la galerie.

Précondition : le joueur a défini un fond d’écran.

Si aucun fond défini, fond neutre par défaut.

Déclencheur :

```text
Pauline : Montrez vos fonds d’écran, je veux juger 😇
Nico : Ah oui, vas-y Player.
Marie : Pourquoi pas.
```

Choix :

```text
- Montrer.
- Verrouiller vite.
- Faire une blague pour esquiver.
```

Effets selon fond :

```text
fond neutre           → aucun
fond Marie tendre     → marie_trust +1
fond Mathilde         → marie.lucidity +2, mathilde.loyalty -1, social_pressure +1
fond Sandra           → marie.lucidity +2, sandra.exposure +2
fond Pauline          → pauline.control +2, social_pressure +1
```

Règle : cette scène ne doit pas exploser totalement le jeu dans le slice. Elle prépare une menace.

## Jour 4 — Lendemain / première preuve

### Beat 4.1 — Réaction de Marie

Application : Messages  
Conversation : Marie  
Pattern : confrontation légère  
Fonction : montrer que la soirée a laissé une trace.

Déclencheurs possibles :

- Marie a été ignorée ;
- fond d’écran suspect ;
- Player a répondu à Mathilde/Sandra/Pauline ;
- Nico a pris de la place.

Messages variants :

```text
Marie : Tu étais bizarre hier.
Marie : Tu avais l’air ailleurs.
Marie : J’ai peut-être imaginé, mais j’ai senti un truc.
```

Choix :

```text
- Tu n’as pas imaginé.
- J’étais fatigué.
- C’est la soirée qui était bizarre.
```

Effets : vérité, mensonge, Marie lucidity.

### Beat 4.2 — Première preuve selon route nourrie

Application : variable  
Pattern : contenu visuel reçu / message supprimé / story  
Fonction : donner une trace concrète.

#### Si Mathilde favorisée

```text
Mathilde : Je crois qu’on devrait éviter de se parler comme ça.
Mathilde vous a envoyé une photo.
Mathilde a supprimé un message.
```

Choix : conserver, supprimer, répondre prudemment.

#### Si Sandra favorisée

```text
Sandra : Je ne sais pas pourquoi je t’ai écrit hier.
Sandra a supprimé un message.
```

Choix : demander, laisser, rassurer.

#### Si Pauline favorisée

```text
Pauline : Tu as vraiment cru que je n’avais pas vu ta réaction ?
Pauline vous a envoyé une capture.
```

Choix : minimiser, entrer dans le jeu, demander ce qu’elle veut.

#### Si Nico favorisé

```text
Nico a commenté une photo de Marie.
Nico : Elle était bien entourée hier.
```

Choix : vérifier, ignorer, demander à Marie.

#### Si Raphaëlle favorisée

```text
Raphaëlle : Tu as l’air encore plus fatigué qu’hier.
Raphaëlle : Tu fuis quelque chose ou quelqu’un ?
```

Choix : éviter, avouer partiellement, plaisanter.

### Beat 4.3 — Bilan temporaire debug

Application : Debug / écran de bilan provisoire  
Fonction : vérifier que le système comprend la dynamique.

En jeu normal, ce bilan peut être invisible ou remplacé par une transition narrative.

Mode debug affiche :

```text
route dominante probable
route secondaire probable
menace active
mode relationnel probable
principaux flags
signaux passifs
```

Exemples de résultats :

```text
Dominante : Mathilde
Secondaire : Nico
Menace : Marie
Mode : SECRET_AFFAIR
```

```text
Dominante : Sandra
Secondaire : Raphaëlle
Menace : Exposition
Mode : SECRET_AFFAIR
```

```text
Dominante : Marie / Nico
Secondaire : Pauline
Menace : Jalousie
Mode : NTR_SUBI amorcé
```

## Critères de réussite du vertical slice

Le slice est réussi si :

1. Le joueur comprend immédiatement l’interface smartphone.
2. Les voix des personnages sont distinctes.
3. Les scènes calmes ne sont pas surchargées en choix.
4. La soirée chez Pauline crée une vraie tension de priorité.
5. Au moins une photo ou preuve placeholder peut être reçue.
6. Le fond d’écran peut devenir une preuve sociale.
7. Les signaux passifs influencent sans punir.
8. Le debug identifie une route dominante cohérente.
9. Le joueur comprend que ses choix comptent sans savoir exactement quand.
10. Le joueur a envie de recommencer pour tester une autre priorité.