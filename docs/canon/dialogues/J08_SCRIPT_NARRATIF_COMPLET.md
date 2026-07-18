# Réseau Intime — J08 Script narratif complet

## Statut

**Catégorie : Canon validé narrativement — source pré-runtime consolidée**

**Périmètre : J08 uniquement**

**Surface : messagerie texte uniquement**

Ce document définit la version narrative complète de J08 avant toute adaptation technique.

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

J08 devient :

```text
Mardi — Ce qui ne tient pas ensemble
```

Sa fonction n’est pas de choisir une route.

Sa fonction est :

```text
montrer qu’une promesse professionnelle,
une parole donnée à un ami
et une présence domestique
ne peuvent pas toujours être tenues de la même manière.
```

Le joueur ne choisit pas :

- Raphaëlle ;
- Nico ;
- Marie ;
- Mathilde.

Il choisit :

- ce qu’il traite d’abord ;
- ce qu’il amende honnêtement ;
- ce qu’il laisse dériver ;
- la différence entre annoncer une limite et laisser les autres attendre.

---

# 2. Position dans la saison

## État d’entrée depuis J07

J07 peut avoir créé jusqu’à trois attentes, chacune lue uniquement si son `promise_id` est actif :

```text
Raphaëlle : relecture mobile avant mardi 19 h
Nico : passage à L’Annexe mardi à 18 h 45
foyer : présence mardi à 19 h 15,
ou alternative à 18 h 30,
ou refus honnête et report au mercredi
```

Nico connaît une contradiction limitée.

Il a déclaré :

- que Marie lui plaît ;
- que Mathilde lui plaît différemment ;
- que cela ne lui donne aucun droit ;
- que son avis n’est pas neutre.

Aucune femme n’a été autorisée par cette confidence.

## Fonction de sortie

À la fin de J08 :

- au moins une obligation a été payée, amendée ou échouée ;
- Nico sait si Player tient une parole simple ;
- Raphaëlle sait si Player prévient avant de disparaître ;
- Marie sait si Player distingue une heure donnée d’une bonne intention ;
- Mathilde a été aidée, laissée autonome ou contrainte d’agir sans lui ;
- une conséquence réelle est active ;
- la ligne privée a désormais un coût ;
- aucune route extérieure n’est définitivement verrouillée ;
- J09 peut remettre Marie au centre par sa visibilité sociale.

---

# 3. Question dramatique

> Que fait Player lorsque plusieurs personnes ont de bonnes raisons de croire qu’il sera là ?

La journée doit distinguer :

- promesse tenue ;
- promesse amendée ;
- promesse ratée ;
- priorité assumée ;
- absence de décision.

La journée ne doit pas produire :

- un score de culpabilité ;
- un gagnant de route ;
- une femme récompense ;
- une réussite cachée du choix vague.

---

# 4. Architecture générale

```text
08:42  Marie confirme ou ferme la question du constat
17:03  Raphaëlle envoie la version mobile
18:21  Nico rappelle la chaise et l’heure
18:27  la superposition devient concrète
18:30–19:20  choix, événements hors téléphone et conséquences
21:36  retours textuels
22:18  Marie ouvre J09 sans nouvelle demande immédiate
```

J08 ne contient :

- aucun groupe ;
- aucun message Sandra ;
- aucun message Pauline ;
- aucune nouvelle progression Mathilde ;
- aucune image obligatoire ;
- aucune scène adulte.

---

# 5. Trois états domestiques d’entrée

La superposition doit respecter le choix effectué avec Marie en J07.

## État A — Présence confirmée à 19 h 15

Player a écrit :

```text
oui. 19 h 15, je serai là
```

La présence domestique devient une vraie obligation.

## État B — Alternative à 18 h 30

Player a proposé :

```text
je peux être là à 18 h 30, pas 19 h 15
```

Le propriétaire accepte.

Cette alternative précise réduit la collision sans la supprimer totalement.

## État C — Refus honnête

Player a écrit :

```text
je ne peux pas demain. dis-lui de voir avec moi mercredi
```

Marie et Mathilde organisent le mercredi.

Aucune obligation domestique mardi ne doit réapparaître artificiellement.

---

# 6. Fenêtre A — 08:42 — Marie confirme le foyer

## Carte de voix

```text
principal_speaker: Marie
voice_state: practical_morning
public_or_private: private_couple
message_burst_shape: 2 à 4 messages
humor_mode: concret domestique
punctuation_mode: normal
emoji_budget: 0
forbidden_leakage: aucune jalousie, aucun commentaire sur Nico ou Raphaëlle
```

---

## 6.1 État A — 19 h 15 confirmé

**08:42 — Marie**

> C’est confirmé pour 19 h 15.

**08:42 — Marie**

> Il a dit qu’il arriverait peut-être dix minutes avant.

**08:43 — Marie**

> La pochette bleue est sur le meuble de l’entrée.

**Réponse Player guidée**

> je serai là avant lui

**08:43 — Marie**

> Parfait.

**08:44 — Marie**

> Mathilde finit à 19 h 30. Elle te doit donc officiellement un café et officieusement rien du tout.

La dernière phrase empêche de transformer l’aide en monnaie de route.

---

## 6.2 État B — 18 h 30 accepté

**08:42 — Marie**

> Il peut passer à 18 h 30.

**08:42 — Marie**

> Ton alternative a fonctionné.

**08:43 — Marie**

> C’est presque agaçant.

**Réponse Player guidée**

> je prends la victoire administrative

**08:43 — Marie**

> Prends surtout la pochette bleue.

**08:44 — Marie**

> Et sois là à 18 h 25. Les propriétaires qui disent 18 h 30 vivent parfois dans un autre fuseau horaire.

La précision J07 produit donc un bénéfice réel.

---

## 6.3 État C — Refus accepté

**08:42 — Marie**

> C’est déplacé à mercredi.

**08:42 — Marie**

> Mathilde sera là.

**08:43 — Marie**

> Donc c’est réglé.

**Réponse Player guidée**

> merci d’avoir géré

**08:43 — Marie**

> On a géré.

**08:44 — Marie**

> Tu avais dit non clairement. C’était plus simple que de t’attendre.

Il n’existe plus d’obligation domestique mardi.

Le refus propre n’est pas puni.

---

# 7. Fenêtre B — 17:03 — Raphaëlle envoie la version mobile

## Fonction

Cette fenêtre :

- rappelle l’obligation créée en J07 ;
- permet une anticipation réelle ;
- montre que Raphaëlle ne retient pas Player ;
- donne au choix vague un coût professionnel lisible.

## Contexte

Player et Raphaëlle sont dans des espaces de travail distincts.

Le correctif peut être relu depuis le poste de Player ou un ordinateur accessible.

Le travail restant représente environ douze minutes concentrées.

## Carte de voix

```text
principal_speaker: Raphaëlle
voice_state: focused_professional
public_or_private: work_private
message_burst_shape: 4 messages puis choix
humor_mode: exact, léger
punctuation_mode: complete
emoji_budget: 0
forbidden_leakage: pas de cadre amoureux, pas de morale, pas d’attente affective
```

## Script commun

**17:03 — Raphaëlle**

> Le lien est à jour.

**17:03 — Raphaëlle**

> Sur mobile, le bouton retour perd encore le focus après validation.

**17:04 — Raphaëlle**

> J’ai corrigé ma partie.

**17:04 — Raphaëlle**

> La tienne prend environ douze minutes si tu ne découvres pas un nouveau problème par principe.

À cet instant, un choix de préparation apparaît.

---

# 8. Choix de préparation Raphaëlle

## Choix R1 — Anticiper maintenant

**Player**

> je m’y mets maintenant. tu as mes notes avant 18 h

**17:05 — Raphaëlle**

> Très bien.

**17:05 — Raphaëlle**

> Je garde le fichier ouvert.

### Événement hors téléphone

Player relit la version entre 17:06 et 17:42.

À 17:44 :

**Player**

> j’ai corrigé le retour clavier et laissé une note sur le message d’erreur

**17:45 — Raphaëlle**

> Reçu.

**17:45 — Raphaëlle**

> Il restera seulement la vérification finale du build.

### Effet narratif

```text
travail presque payé
reste 3 à 4 minutes de confirmation
```

L’anticipation réduit réellement la superposition.

---

## Choix R2 — Programmer à 18 h 20

**Player**

> je termine ce que j’ai là et je fais ta partie à 18 h 20

**17:05 — Raphaëlle**

> 18 h 20.

**17:05 — Raphaëlle**

> Pas « autour de 18 h 20 ».

**Player**

> oui

**17:06 — Raphaëlle**

> Parfait.

### Effet narratif

```text
travail entier encore dû à 18 h 20
```

---

## Choix R3 — Réponse vague

**Player**

> vu

**17:05 — Raphaëlle**

> Ce n’est pas une heure.

**Player**

> je regarde avant 19 h

**17:06 — Raphaëlle**

> D’accord.

**17:06 — Raphaëlle**

> Je vais donc prévoir que « avant » peut devenir très proche de « après ».

### Effet narratif

```text
travail entier dû
confiance professionnelle légèrement réduite
```

Raphaëlle ne transforme pas cela en conflit sentimental.

---

# 8 bis. Garde d’éligibilité Nico

La fenêtre Nico existe uniquement si :

```text
promise_id: nico_j07_tuesday_1845
status: ACTIVE
```

Si la promesse a été refusée, amendée vers jeudi ou expirée, Nico ne garde aucune chaise et n’envoie aucun rappel mardi.

# 9. Fenêtre C — 18:21 — Nico rappelle la chaise

## Fonction

Nico ne force pas la continuation.

Il demande seulement si Player tient la parole simple donnée en J07.

## Carte de voix

```text
principal_speaker: Nico
voice_state: before_service
public_or_private: private_friendship
message_burst_shape: 3 messages courts
humor_mode: chaise / service
punctuation_mode: oral direct
emoji_budget: 0
forbidden_leakage: pas de nouveau conseil, pas de demande d’image, pas de commentaire sur les femmes
```

## Script commun

**18:21 — Nico**

> J’ouvre à 19 h.

**18:21 — Nico**

> Ta chaise existe jusqu’à 18 h 50.

**18:22 — Nico**

> Après, elle travaille.

**Réponse Player guidée**

> j’arrive ou j’annule avant

**18:22 — Nico**

> C’est tout ce que je demande.

Aucun nouveau contenu de confidence n’est échangé avant la décision.

---

# 10. La superposition devient concrète

Le moment exact varie selon l’état domestique.

---

## 10.1 État A — Triple superposition

À 18:27 :

**18:27 — Raphaëlle**

> Le build est prêt.

### Si R1 anticipation

> Il reste la validation finale.

### Si R2 ou R3

> Ta partie n’est pas encore relue.

À 18:28 :

**18:28 — Marie**

> Il vient de m’écrire.

**18:28 — Marie**

> Il sera là à 19 h 05.

**18:29 — Marie**

> Tu es bien en route après ton travail ?

Nico attend à 18 h 45.

Raphaëlle attend avant 19 h.

Marie et Mathilde comptent sur une présence à 19 h 05.

Trois attentes sont réelles.

---

## 10.2 État B — Foyer payé avant la collision restante

À 18:24 :

**18:24 — Marie**

> Il est déjà en bas.

**18:24 — Marie**

> Je t’avais prévenu pour le fuseau horaire.

**Réponse Player guidée**

> j’y vais

La messagerie s’arrête.

### Événement hors téléphone

```text
18:26–18:46
Player accueille le propriétaire.
Le mur et les papiers sont vérifiés.
Mathilde n’est pas présente.
Aucune conversation orale n’est jouée.
```

À 18:47, Player récupère son téléphone.

Nico a encore quelques minutes avant le service.

Raphaëlle attend la validation avant 19 h.

L’alternative précise a payé le foyer et réduit la collision à deux attentes.

---

## 10.3 État C — Superposition à deux attentes

Aucun message domestique urgent n’apparaît.

À 18:27 :

**18:27 — Raphaëlle**

> Le build est prêt.

### Si R1 anticipation

> Il reste la validation finale.

### Si R2 ou R3

> Ta partie n’est pas encore relue.

Nico attend à 18 h 45.

Le foyer n’attend rien de Player mardi soir.

Le refus honnête J07 a donc supprimé une obligation réelle.

---

# 10 bis. Fallback sans superposition

Si moins de deux obligations sont actives après lecture des registres :

- Player paie l’unique obligation due ;
- ou la ferme clairement ;
- la journée ne fabrique aucun conflit ;
- Marie ouvre J09 par une respiration ordinaire ;
- aucun personnage absent n’est puni.

La superposition n’existe que lorsque plusieurs personnes ont réellement organisé leur temps autour de réponses acceptées.

# 11. Choix principal de superposition

Les choix gardent la même logique dans les trois états :

```text
A — payer l’engagement le plus ancien
B — payer la présence physique la plus immédiate
C — ne pas choisir clairement
```

Le résultat concret varie selon l’état domestique.

---

# 12. Choix A — Payer l’engagement le plus ancien

L’obligation Raphaëlle a été créée la première.

Player traite donc le travail.

---

## 12.1 Message Raphaëlle

### Si R1 anticipation

**Player**

> je valide le build maintenant. tu as la réponse dans quatre minutes

**18:30 — Raphaëlle**

> Très bien.

### Si R2 ou R3

**Player**

> je termine ma partie maintenant. envoi avant 19 h

**18:30 — Raphaëlle**

> D’accord.

**18:30 — Raphaëlle**

> Je reste disponible jusqu’à l’envoi.

---

## 12.2 Message Nico

**Player**

> je ne viens pas. ne garde pas la chaise

**18:31 — Nico**

> Reçu.

**18:31 — Nico**

> Elle survivra.

**18:32 — Nico**

> On ne remet pas automatiquement.

Nico ne punit pas.

Il refuse simplement que la continuation soit considérée comme acquise.

---

## 12.3 Conséquence domestique selon l’état

### État A — présence 19 h 05

**Player**

> je termine le correctif et je pars. j’arrive pour 19 h 05

**18:32 — Marie**

> 19 h 05.

**18:32 — Marie**

> Pas 19 h 20 avec une bonne explication.

#### Si R1 anticipation

Player termine à 18:35 et part immédiatement.

Il arrive avant le propriétaire.

#### Si R2

Player termine autour de 18:43.

Il arrive au moment où le propriétaire entre.

La promesse est tenue de façon serrée, sans marge.

#### Si R3

Le travail prend plus longtemps parce que Player n’avait pas ouvert le fichier.

À 18:50 :

**18:50 — Player**

> je vais être en retard

**18:51 — Marie**

> Mathilde a trouvé une voisine pour ouvrir.

**18:51 — Marie**

> Ne cours pas pour arriver après.

Le travail est payé.

Le foyer est amendé trop tard et agit sans lui.

### État B — foyer déjà payé

Aucune nouvelle conséquence domestique.

Player paie :

- le foyer ;
- le travail ;
- pas Nico.

### État C — foyer fermé

Aucune conséquence domestique.

Player paie le travail et annule Nico proprement.

---

## 12.4 Clôture Raphaëlle

### Travail payé

**18:56 — Raphaëlle**

> C’est bon.

**18:56 — Raphaëlle**

> J’envoie.

**18:57 — Raphaëlle**

> Merci d’avoir choisi une heure et de l’avoir tenue.

### Travail payé en retard après R3

**19:06 — Raphaëlle**

> J’ai envoyé à 19 h 06.

**19:06 — Raphaëlle**

> Le correctif est bon.

**19:07 — Raphaëlle**

> La prochaine fois, « vu » ne sera pas considéré comme une planification.

Elle juge le comportement professionnel, pas la vie privée.

---

# 13. Choix B — Payer la présence physique la plus immédiate

La personne ou responsabilité physiquement imminente dépend de l’état domestique.

---

## 13.1 État A — Le foyer est prioritaire

Player part immédiatement pour l’appartement.

### Message Marie

**Player**

> je pars maintenant. je serai là avant lui

**18:30 — Marie**

> Merci.

**18:30 — Marie**

> La pochette bleue. Je répète parce que je nous connais.

### Message Nico

**Player**

> je ne viens pas. problème au foyer. ne garde pas la chaise

**18:31 — Nico**

> Reçu.

**18:31 — Nico**

> Va gérer le mur.

**18:32 — Nico**

> La philosophie attendra.

### Message Raphaëlle

**Player**

> je dois partir. je n’ai pas fini. tu peux reprendre ou on décale l’envoi ?

**18:31 — Raphaëlle**

> Je reprends ta partie.

**18:31 — Raphaëlle**

> Le point client reste demain à 9 h.

**18:32 — Raphaëlle**

> Tu porteras l’explication si quelque chose manque.

### Événement hors téléphone

Player arrive avant le propriétaire.

Le constat est réalisé.

Mathilde n’est pas présente.

Marie reste à La Verrière.

### Conséquence

```text
foyer payé
Nico annulé honnêtement
travail transféré avec dette professionnelle
```

---

## 13.2 État B — Nico est la présence restante la plus immédiate

Le foyer a déjà été payé à 18 h 30.

À 18:47 :

**Player**

> j’arrive. j’ai six minutes si ta chaise existe encore

**18:47 — Nico**

> Elle existe.

**18:47 — Nico**

> Six minutes, donc.

### Message Raphaëlle

**Player**

> le constat a débordé. je ne termine pas avant 19 h. tu peux reprendre ?

**18:48 — Raphaëlle**

> Oui.

**18:48 — Raphaëlle**

> J’envoie sans attendre ton retour.

**18:49 — Raphaëlle**

> Tu reprends le sujet demain matin.

### Événement hors téléphone

Player rejoint Nico avant le service.

Ils parlent environ six minutes.

Aucun dialogue oral n’est montré.

Le contenu exact reste borné par J07 :

- Nico ne demande pas de noms ;
- Player ne donne aucune image ;
- Nico ne devient pas alibi ;
- aucune femme n’est autorisée.

### Conséquence

```text
foyer payé
Nico payé de façon brève
travail transféré avec dette professionnelle
```

---

## 13.3 État C — Nico est la seule présence physique attendue

**Player**

> j’arrive. garde-moi dix minutes

**18:29 — Nico**

> Dix.

**18:29 — Nico**

> Après je travaille.

### Message Raphaëlle

**Player**

> je pars. je n’ai pas fini. tu peux reprendre et je prends le point demain ?

**18:30 — Raphaëlle**

> Oui.

**18:30 — Raphaëlle**

> C’est une modification claire.

**18:31 — Raphaëlle**

> Je reprends.

### Événement hors téléphone

Player rejoint Nico.

Ils parlent dix minutes avant le service.

Aucun dialogue oral n’est joué.

### Conséquence

```text
Nico payé
travail honnêtement transféré
aucune obligation domestique
```

---

## 13.4 Retour Nico après rencontre

Dans les états B et C, à 21:36 :

**21:36 — Nico**

> Tu es venu.

**21:36 — Nico**

> C’était court.

**21:37 — Nico**

> Mais court et réel, c’est mieux que long dans ta tête.

**Réponse Player guidée**

> et ce que je t’ai dit hier

**21:38 — Nico**

> Reste avec moi.

**21:38 — Nico**

> Je n’en fais rien.

**21:39 — Nico**

> Si un jour il faut agir, les personnes concernées seront dans la pièce.

La formulation confirme la limite sans transformer Nico en arbitre moral parfait.

---

# 14. Choix C — Ne pas choisir clairement

Player tente de préserver toutes les attentes.

Il envoie des messages insuffisants.

---

## 14.1 Messages vagues

### Raphaëlle

**Player**

> j’y suis

**18:30 — Raphaëlle**

> Sur le fichier ou sur le départ ?

Player ne répond pas immédiatement.

### Nico

**Player**

> j’arrive

**18:31 — Nico**

> Quelle heure ?

Player répond :

> bientôt

**18:31 — Nico**

> Non.

**18:32 — Nico**

> Bientôt n’a pas de chaise.

### Marie — État A seulement

**Player**

> cinq minutes

**18:32 — Marie**

> Cinq minutes avant de partir ou avant d’arriver ?

Player ne donne pas de réponse claire.

---

## 14.2 Résultats

### Raphaëlle

À 18:52 :

**18:52 — Raphaëlle**

> J’ai repris ta partie.

**18:52 — Raphaëlle**

> J’envoie sans attendre.

**18:53 — Raphaëlle**

> Je ne savais plus si tu étais encore dessus.

Le travail est terminé par Raphaëlle.

Player ne peut pas revendiquer l’avoir payé.

### Nico

À 18:51 :

**18:51 — Nico**

> J’ai rendu la chaise.

**18:51 — Nico**

> La prochaine fois, annule.

Il commence son service.

Aucune continuation n’est automatiquement reproposée.

### Marie — État A

À 19:08 :

**19:08 — Marie**

> C’est réglé.

**19:08 — Marie**

> Mathilde a demandé à la voisine d’ouvrir.

**19:09 — Marie**

> On a arrêté d’attendre.

Le foyer agit sans Player.

### État B

Le foyer a déjà été payé.

Player échoue néanmoins à traiter clairement Raphaëlle et Nico.

### État C

Aucune conséquence domestique.

Player échoue seulement sur les deux attentes qu’il a maintenues ouvertes.

---

# 15. Retour Marie et Mathilde

Mathilde ne possède pas un fil de progression dans J08.

Elle apparaît uniquement par la conséquence du constat.

---

## 15.1 Foyer payé

À 20:14 :

**20:14 — Marie**

> C’est fait.

**20:14 — Marie**

> Il a pris les photos du mur et signé le constat.

**20:15 — Marie**

> Mathilde te remercie.

**20:15 — Marie**

> Moi aussi.

**Réponse Player guidée**

> la pochette bleue a survécu

**20:16 — Marie**

> De peu.

**20:16 — Marie**

> La verte a essayé de participer.

Le remerciement ne crée aucune dette Mathilde envers Player.

---

## 15.2 Foyer amendé trop tard ou raté

À 20:14 :

**20:14 — Marie**

> C’est fait.

**20:14 — Marie**

> Mathilde et la voisine ont géré.

**20:15 — Marie**

> Je ne te demande pas de refaire la soirée.

**20:15 — Marie**

> Juste ne dis pas que tu étais là.

Cette ligne distingue :

- culpabilité performée ;
- acte réellement absent.

---

## 15.3 Refus J07 déjà assumé

À 20:14 :

**20:14 — Marie**

> Mercredi est confirmé pour le constat.

**20:14 — Marie**

> Mathilde sera là.

**20:15 — Marie**

> Rien à rattraper ce soir.

Le jeu ne punit pas un refus qui a permis aux autres de s’organiser.

---

# 16. Retour Raphaëlle

## Travail payé directement

Raphaëlle confirme l’envoi et ferme le fil.

Aucune nouvelle scène privée n’est ouverte.

## Travail transféré honnêtement

À 21:02 :

**21:02 — Raphaëlle**

> La version est envoyée.

**21:02 — Raphaëlle**

> J’ai repris la navigation clavier.

**21:03 — Raphaëlle**

> Demain, tu portes le point si le client demande pourquoi cela a bougé tard.

**Réponse Player guidée**

> oui

**21:03 — Raphaëlle**

> Bien.

La dette est professionnelle, pas affective.

## Travail abandonné vaguement

À 21:02 :

**21:02 — Raphaëlle**

> La version est envoyée.

**21:02 — Raphaëlle**

> J’ai repris sans savoir si tu revenais.

**21:03 — Raphaëlle**

> Demain, nous parlerons de la méthode. Pas du résultat.

Elle ne fait pas de la précision un flirt ou une punition personnelle.

---

# 17. Fermeture J08 — 22:18 — Marie prépare J09

Après les conséquences principales, Marie ouvre la journée suivante sans créer une nouvelle obligation immédiate.

**22:18 — Marie**

> Demain je finis tard à La Verrière.

**22:18 — Marie**

> Élodie a prévu une rallonge noire et trois personnes qui ne savent pas lire un plan.

**22:19 — Marie**

> Je te redis pour l’heure.

### Si le foyer a été payé

**Réponse Player guidée**

> d’accord. repose-toi avant de sauver la rallonge

**22:20 — Marie**

> C’est elle qui nous sauvera tous.

### Si le foyer a été raté

**Réponse Player guidée**

> d’accord

**22:20 — Marie**

> D’accord.

La différence reste légère mais lisible.

J09 commence ainsi avec Marie en mouvement et une visibilité sociale indépendante.

---

# 18. État de sortie par posture

## Choix A — Ancien engagement

### Peut produire

- Raphaëlle payée ;
- Nico annulé honnêtement ;
- foyer payé si Player avait anticipé ou donné une heure réaliste ;
- foyer raté si la préparation était vague ;
- aucune route extérieure sélectionnée.

## Choix B — Présence immédiate

### État A

- foyer payé ;
- Nico annulé ;
- Raphaëlle reprend le travail ;
- dette professionnelle claire.

### État B

- foyer déjà payé ;
- Nico payé brièvement ;
- Raphaëlle reprend ;
- dette professionnelle claire.

### État C

- Nico payé ;
- Raphaëlle reprend ;
- aucune obligation domestique.

## Choix C — Vague

- Raphaëlle finit sans savoir si Player revient ;
- Nico attend puis commence son service ;
- le foyer agit sans lui si nécessaire ;
- aucune réussite cachée ;
- plusieurs confiances diminuent sans verrou irréversible.

---

# 19. États narratifs de sortie

## Raphaëlle

Un des états :

```text
travail payé à l’heure
travail transféré honnêtement
travail abandonné vaguement
```

Elle possède éventuellement une dette professionnelle, jamais une dette romantique.

## Nico

Un des états :

```text
annulation honnête
rencontre courte réellement payée
attente vague et confiance réduite
```

Il ne possède :

- aucune image ;
- aucun alibi ;
- aucune autorisation concernant Marie ou Mathilde.

## Marie

Un des états :

```text
présence domestique payée
présence amendée trop tard
présence ratée
refus J07 correctement absorbé
```

## Mathilde

Un des états :

```text
constat aidé par Player
constat géré avec une voisine
constat déplacé au mercredi
```

Aucun état ne signifie :

```text
Mathilde doit quelque chose à Player
```

## Player

La journée mémorise :

- priorité ;
- capacité d’amendement ;
- anticipation ;
- ou dérive vague.

Elle ne mémorise pas un score moral global.

---

# 20. Ancien matériau J08

La scène runtime historique :

```text
chapter_08_marie_black_dress
```

ne doit pas être supprimée pendant la phase narrative.

Elle est reclassée comme matériau possible pour l’ouverture de J09.

Éléments réutilisables :

- Marie demande un avis réel ;
- robe noire ;
- distinction entre image entière et version plus privée ;
- La Verrière ;
- L’Annexe ;
- Pauline et Bastien ;
- une heure précise.

Éléments à corriger avant réutilisation :

- aucune obligation créée avant que J08 soit payé ;
- aucune journée visual-first imposée par trois images techniques ;
- aucune sélection `join / table / jeudi privé` avant le contexte J09 ;
- la visibilité sociale de Marie doit rester le pivot ;
- les images seront fournies plus tard par Ludovic.

---

# 21. Matériau Raphaëlle réutilisé

L’ancienne scène :

```text
chapter_03_raphaelle_late_review
```

fournit une bonne règle :

```text
Raphaëlle ne retient pas Player.
Elle exige seulement une décision claire sur le travail.
```

Le script J08 reprend cette fonction sans réutiliser :

- l’ancien vernissage J03 ;
- la promesse historique à Marie ;
- les anciens flags ;
- la topologie technique.

---

# 22. Audit des voix

## Marie

Reconnaissable par :

- heures ;
- pochette bleue ;
- problème concret ;
- alternative acceptée si elle est réelle ;
- absence de jalousie ;
- vie qui continue sans Player.

## Raphaëlle

Reconnaissable par :

- problème exact ;
- durée estimée ;
- choix professionnel ;
- refus du vague ;
- responsabilité du lendemain ;
- aucune demande affective.

## Nico

Reconnaissable par :

- chaise ;
- service ;
- horaire simple ;
- annulation acceptée ;
- agacement contre le vague ;
- aucune relance automatique.

## Player

Reconnaissable par :

- minuscules ;
- messages courts ;
- possibilité de donner une heure ;
- possibilité de rester vague ;
- modification précise lorsqu’il assume ;
- aucune confession supplémentaire inutile.

---

# 23. Test sans nom

```text
La tienne prend environ douze minutes si tu ne découvres pas un nouveau problème par principe.
→ Raphaëlle

Ta chaise existe jusqu’à 18 h 50.
→ Nico

La verte a essayé de participer.
→ Marie

j’y suis
→ Player vague

On a arrêté d’attendre.
→ Marie blessée mais concrète

Demain, nous parlerons de la méthode. Pas du résultat.
→ Raphaëlle
```

---

# 24. Test de substitution

## Raphaëlle → Nico

```text
Demain, nous parlerons de la méthode. Pas du résultat.
```

Échec : trop structurée et professionnelle pour Nico.

## Nico → Marie

```text
Bientôt n’a pas de chaise.
```

Échec : humour de lieu et d’ami, pas mouvement domestique.

## Marie → Pauline

```text
La verte a essayé de participer.
```

Friction : Pauline pourrait être sèche, mais la phrase appartient ici à un objet du foyer et à une vie commune.

---

# 25. Audit anti-dialogue générique

La journée évite :

- un choix de femme ;
- trois personnages qui disent la même morale ;
- une crise créée par une panne arbitraire ;
- une urgence sexuelle ;
- un personnage omniscient ;
- une route donnée en récompense ;
- une conséquence uniquement abstraite ;
- un choix vague secrètement efficace ;
- un long chat pendant la co-présence ;
- un faux appel au propriétaire ;
- une résolution par audio.

Messages ordinaires présents :

- lien de build ;
- bouton retour ;
- pochette bleue ;
- heure du propriétaire ;
- chaise ;
- ouverture du service ;
- photos du mur.

---

# 26. Contrat visuel différé

Aucune image n’est conçue.

Trois slots fonctionnels minimum :

1. responsabilité Raphaëlle ;
2. Nico / L’Annexe ou chaise non utilisée ;
3. foyer / constat / autonomie de Mathilde.

Le choix vague peut produire des fonctions visuelles de conséquence :

- poste de travail quitté ;
- chaise rendue ;
- constat signé sans Player.

Ludovic fournira les images plus tard via ComfyUI.

---

# 27. Critères de validation J08

- [ ] les obligations proviennent réellement de J07 ;
- [ ] le refus domestique J07 ferme vraiment l’obligation mardi ;
- [ ] l’alternative précise réduit réellement la collision ;
- [ ] Raphaëlle ne devient pas une route sentimentale ;
- [ ] Nico accepte une annulation claire ;
- [ ] Nico ne reçoit aucune information privée supplémentaire ;
- [ ] Marie reste centrale dans la conséquence ;
- [ ] Mathilde conserve son autonomie ;
- [ ] aucun choix ne sélectionne une personne ;
- [ ] le choix vague n’est pas récompensé ;
- [ ] au moins une obligation est payée, amendée ou échouée ;
- [ ] la co-présence arrête la messagerie ;
- [ ] aucun appel ou audio ;
- [ ] aucune image n’est conçue ;
- [ ] l’ancien matériau robe noire est déplacé vers J09 ;
- [ ] J09 s’ouvre sur Marie en mouvement.

---

# 28. Résumé canonique candidat

J08 commence par la confirmation des conséquences du choix domestique de J07.

Raphaëlle envoie ensuite une version mobile à relire avant 19 h. Player peut anticiper, donner une heure précise ou répondre vaguement.

Nico rappelle qu’il garde une chaise jusqu’à 18 h 50.

La soirée superpose alors :

- le travail ;
- la parole donnée à Nico ;
- et, selon J07, la présence liée au constat de Mathilde.

Player peut payer l’engagement le plus ancien, payer la présence physique la plus immédiate ou tenter de garder toutes les options ouvertes.

Une alternative précise donnée la veille peut permettre de payer le foyer avant la collision. Un refus honnête peut supprimer entièrement l’obligation domestique. Le jeu récompense donc l’anticipation et l’amendement, pas seulement le choix du dernier moment.

Raphaëlle, Nico, Marie et Mathilde continuent tous d’agir lorsque Player ne vient pas.

La journée se ferme sur Marie, qui annonce qu’elle terminera tard à La Verrière le lendemain.

> **J08 ne demande pas qui compte le plus. Elle montre que les autres n’attendent pas de la même manière, et que leur temps continue lorsque Player refuse de choisir.**

---

# Annexe canonique — Identifiants consolidés

```text
promise_id: raphaelle_j07_mobile_review
promise_id: nico_j07_tuesday_1845
promise_id: marie_j07_household_request
```

Une fenêtre lit le statut de sa promesse ; elle ne suppose jamais que l’attente existe.
