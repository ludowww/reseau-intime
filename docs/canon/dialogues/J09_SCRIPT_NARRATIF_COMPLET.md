# Réseau Intime — J09 Script narratif complet

## Statut

**Catégorie : Canon validé narrativement — source pré-runtime consolidée**

**Périmètre : J09 uniquement**

**Surface : messagerie texte uniquement**

Ce document définit la version narrative complète de J09 avant toute adaptation technique.

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

J09 devient :

```text
Mercredi — Dans son élément
```

Sa fonction principale est :

```text
montrer Marie dans une vie visible,
professionnelle, sociale et désirable,
qui existe avec ou sans Player.
```

La journée ne demande pas :

- si Player autorise Marie à sortir ;
- si Marie cherche à le rendre jaloux ;
- si une autre route doit gagner ;
- si la robe noire ouvre un accès adulte ;
- si l’absence de Player doit être punie.

Elle demande :

> Player rejoint-il réellement la vie visible de Marie, vient-il seulement la regarder, ou lui laisse-t-il une autonomie qu’il assume sans transformer ensuite l’absence en reproche ?

---

# 2. Position dans la saison

## État d’entrée depuis J08

J08 a montré que :

- le temps des autres continue sans Player ;
- une alternative précise peut fonctionner ;
- un refus honnête peut fermer une obligation ;
- une réponse vague fait agir les autres sans lui ;
- Raphaëlle ne transforme pas le travail en dette sentimentale ;
- Nico accepte une annulation claire mais ne garde pas une place indéfiniment ;
- Marie et Mathilde savent organiser le foyer autrement.

Marie a annoncé :

```text
Demain je finis tard à La Verrière.
Élodie a prévu une rallonge noire et trois personnes qui ne savent pas lire un plan.
Je te redis pour l’heure.
```

## Fonction de sortie

À la fin de J09 :

- Marie a été vue dans son monde professionnel et social ;
- sa soirée a réussi ou vécu indépendamment de Player ;
- Player a démontré une qualité de présence, une présence de spectateur ou une absence assumée ;
- la différence entre `venir`, `aider`, `regarder` et `être avec elle` est lisible ;
- un retour de couple concret peut exister pour J10 ;
- aucune route extérieure n’est sélectionnée ;
- le pivot J10 peut être choisi selon les continuités déjà construites ;
- la robe noire reste un symbole de visibilité, pas une récompense.

---

# 3. Architecture de la journée

```text
matin      aucune scène de remplissage
15:48      Marie prépare La Verrière et donne les heures
16:02      trace privée de préparation / robe noire
18:00      montage ou absence assumée
19:00      ouverture de l’événement
20:15      arrivée tardive éventuelle
22:35      fermeture de la salle
23:07      retour textuel après séparation
```

J09 possède :

- un pivot unique : Marie ;
- un seul choix principal de présence ;
- une évaluation secondaire de la qualité de présence si Player vient ;
- aucun message Sandra, Mathilde, Pauline, Raphaëlle ou Nico au premier plan ;
- aucune superposition nouvelle ;
- aucune scène adulte ;
- aucune obligation extérieure créée en compensation.

---

# 4. Échos de J08 avant la proposition

J09 ne recommence pas par un procès sur la veille.

Une seule courte variante peut modifier le ton d’ouverture.

## 4.1 Si Player a payé ou amendé clairement J08

**15:48 — Marie**

> Hier, merci d’avoir donné des heures qui existaient vraiment.

**15:48 — Marie**

> Je vais tenter la même méthode aujourd’hui.

## 4.2 Si Player avait refusé proprement l’obligation domestique

**15:48 — Marie**

> Hier, merci d’avoir dit non avant qu’on organise autour de toi.

**15:48 — Marie**

> Aujourd’hui, même principe.

## 4.3 Si Player est resté vague ou a laissé les autres attendre

**15:48 — Marie**

> Hier, on a fini par organiser sans savoir où tu étais.

**15:48 — Marie**

> Aujourd’hui je te donne les heures avant.

Ces variantes ne modifient pas le droit de Marie à vivre la soirée.

---

# 5. Fenêtre A — 15:49 — La Verrière avant l’ouverture

## Fonction

Marie distingue clairement :

```text
besoin logistique
≠
envie personnelle de voir Player
```

La journée doit donner envie de rejoindre Marie avant d’introduire la moindre conséquence.

## Contexte

Marie est à La Verrière.

Elle :

- coordonne l’installation ;
- gère Élodie et les intervenants ;
- corrige des problèmes ordinaires ;
- se prépare pour elle-même ;
- n’attend pas chez elle que Player décide de sa soirée.

Player est :

- au travail ;
- en trajet ;
- au foyer ;
- ou ailleurs, séparé d’elle.

Mode :

```text
REMOTE_ASYNC
```

## Carte de voix

```text
principal_speaker: Marie
voice_state: moving_professional_warm
public_or_private: private_couple
message_burst_shape: 5 messages, réponse guidée, choix principal
humor_mode: chaos concret de La Verrière
punctuation_mode: normal
emoji_budget: 0 ou 1
forbidden_leakage: pas de jalousie, pas de diagnostic du couple, pas de permission demandée pour la tenue
```

## Script commun

**15:49 — Marie**

> Portes à 19 h.

**15:49 — Marie**

> Trente-cinq personnes annoncées.

**15:50 — Marie**

> Donc probablement cinquante et une dame qui demandera pourquoi le logo est petit.

**15:50 — Marie**

> J’ai besoin de deux bras à 18 h.

**15:51 — Marie**

> Et j’ai envie que tu viennes.

**15:51 — Marie**

> Ce sont deux raisons différentes.

**Réponse Player guidée**

> et la rallonge noire

**15:52 — Marie**

> Arrivée.

**15:52 — Marie**

> La grise est toujours maudite.

**15:53 — Marie**

> Nous respectons les traditions.

---

# 6. Fenêtre B — 16:02 — La robe noire

## Fonction

Cette trace :

- reprend le matériau historique de J08 ;
- montre que Marie choisit sa représentation ;
- ne demande pas une nouvelle autorisation ;
- rappelle qu’elle peut être visible pour elle-même ;
- rend la soirée désirable avant le choix de Player.

## Script

**16:02 — Marie**

> Et j’ai gardé la robe noire.

**16:02 — Marie**

> Je te préviens. Je ne relance pas le vote.

**Réponse Player guidée**

> bonne décision

**16:03 — Marie**

> Je sais 🙂

**16:03 — Marie**

> Elle a survécu au trajet dans mon tote bag. C’est déjà un signe.

**VISUEL 1 — À FOURNIR PLUS TARD**

```text
fonction : préparation privée / représentation choisie par Marie
audience : Player
permanence : à définir selon le canon visuel
conception : différée à Ludovic / ComfyUI
```

Le visuel ne donne :

- aucune permission sexuelle ;
- aucun droit de transfert ;
- aucune promesse de version plus privée ;
- aucune obligation de venir.

---

# 7. Choix principal de présence

Les trois choix portent sur l’action réelle de Player.

---

## Choix A — Rejoindre tôt et participer

**Player**

> je viens à 18 h. envoie-moi la liste

**15:55 — Marie**

> Marché conclu.

**15:55 — Marie**

> Chaises, rallonges, deux tables et décisions de dernière minute.

**15:56 — Marie**

> Arrive vraiment à 18 h et je serai presque impressionnée.

### Conséquence immédiate

```text
Player est attendu au montage à 18 h
```

---

## Choix B — Venir plus tard avec une heure précise

**Player**

> je ne peux pas pour le montage. je viens à 20 h 15 et je reste jusqu’à 21 h 30

**15:55 — Marie**

> 20 h 15.

**15:55 — Marie**

> Je ne te garde pas la partie montage.

**15:56 — Marie**

> Je garde juste l’envie de te voir.

**15:56 — Marie**

> Et à 21 h 30, tu pars si tu as dit que tu partais.

### Conséquence immédiate

```text
Marie organise le montage sans Player
Player est attendu à 20 h 15 jusqu’à 21 h 30
```

---

## Choix C — Ne pas venir et l’annoncer honnêtement

**Player**

> je ne viens pas ce soir. je te le dis maintenant pour que tu ne m’attendes pas

**15:55 — Marie**

> D’accord.

**15:56 — Marie**

> Je ne garde pas de place.

**15:56 — Marie**

> Et je mets quand même la robe noire.

**15:57 — Marie**

> La soirée aura lieu, donc autant qu’elle soit jolie.

### Conséquence immédiate

```text
aucune présence Player attendue
Marie organise et vit la soirée sans lui
```

Ce choix n’est pas formulé comme :

- `vas-y sans moi` ;
- `je te laisse sortir` ;
- `profite bien si tu veux` ;
- une permission donnée à Marie.

---

# 8. Branche A — Player arrive à 18 h

## 8.1 Co-présence hors téléphone

Player et Marie sont dans le même lieu.

Le chat direct s’arrête.

```text
17:57–ouverture
montage hors téléphone
aucun dialogue oral transcrit
Player prend les tâches déjà annoncées
Marie et Élodie poursuivent leur travail
```

Les anciennes lignes logistiques `Tu es où ?`, `derrière les chaises` et `rallonge noire côté scène` deviennent un état de scène non dialogué.

Le prochain échange direct a lieu après une séparation réelle.

# 9. Qualité de la présence au montage — état hors téléphone

La qualité de présence n’est pas choisie par un échange de messages pendant la co-présence.

Elle est déterminée par les actes observables.

## A1 — Initiative réelle

```text
Player prend les tables du fond et la rallonge noire sans attendre une relance.
Marie n’a pas besoin de guider chaque geste.
présence active
```

## A2 — Humour mais action réelle

```text
Player plaisante brièvement mais accomplit les tâches annoncées.
présence joueuse et utile
```

## A3 — Présence distraite

```text
Player reste physiquement présent mais consulte plusieurs fois un autre fil.
Marie observe seulement l’attention déplacée.
présence physique
attention insuffisante
conséquence de couple active
```

Aucun dialogue oral n’est transcrit. Marie ne demande pas qui reçoit les messages.

# 10. Événement branche A

## 10.1 Trace publique

À 19:08 :

**19:08 — Marie**

> Élodie vient de nous envoyer ça.

**VISUEL 2 — À FOURNIR PLUS TARD**

```text
fonction : Marie dans sa vie professionnelle et sociale
audience : groupe photographié / partage autorisé
permanence : trace publique ou sociale
conception : différée à Ludovic / ComfyUI
```

### Si A1 ou A2

**19:09 — Marie**

> On a l’air étonnamment fonctionnels.

**Réponse Player guidée**

> ne regarde pas les rallonges

**19:09 — Marie**

> Trop tard. Elles ont porté la soirée.

### Si A3

**19:09 — Marie**

> Tu es même sur la photo.

**19:09 — Marie**

> Ton téléphone aussi, un peu.

Aucun conflit supplémentaire n’est joué sur place.

## 10.2 Logistique en salle

À 20:26 :

**20:26 — Marie**

> Les verres propres sont derrière le rideau.

**Réponse Player guidée**

> je les prends

**20:27 — Marie**

> Merci.

Si A3, la réponse Player peut devenir :

> j’arrive

et Marie répond :

> Maintenant, oui.

---

# 11. Branche B — Player arrive à 20 h 15

Marie a réalisé le montage sans lui.

Elle ne lui fait pas payer une absence qu’il avait annoncée.

## Script d’arrivée

**20:12 — Marie**

> Tu es où ?

**Réponse Player guidée**

> côté cour

**20:13 — Marie**

> Passe par la porte scène.

**20:13 — Marie**

> Évite l’entrée principale. Il y a six manteaux et personne ne sait à qui ils appartiennent.

---

# 12. Choix secondaire B — Ce que Player fait de sa présence tardive

## B1 — Rejoindre le mouvement

**Player**

> donne-moi un truc à faire

**20:14 — Marie**

> Cartons vides côté cuisine.

**20:14 — Marie**

> Puis les verres propres derrière le rideau.

**20:15 — Marie**

> Et après tu peux me dire bonsoir normalement.

### Effet

```text
arrivée tardive mais présence active
```

---

## B2 — Venir surtout regarder

**Player**

> je prends un verre et je te regarde finir

**20:14 — Marie**

> D’accord.

**20:14 — Marie**

> Mais ne me dis pas ensuite que tu étais avec moi.

**20:15 — Marie**

> Tu es venu me voir.

### Effet

```text
présence de spectateur
Marie apprécie le regard mais distingue l’action
```

Cette branche n’est pas un échec absolu.

Elle crée une différence claire.

---

## B3 — Présence bornée et assumée

**Player**

> je reste jusqu’à 21 h 30 comme dit. dis-moi ce qui aide jusque-là

**20:14 — Marie**

> Parfait.

**20:14 — Marie**

> Les vestiaires jusqu’à 21 h.

**20:15 — Marie**

> Après, profite de la salle avant de partir.

### Effet

```text
présence limitée mais fiable
```

---

# 13. Événement branche B

À 20:28 :

**20:28 — Marie**

> Élodie vient de nous envoyer ça.

**VISUEL 2 — À FOURNIR PLUS TARD**

```text
fonction : résultat public / Marie visible dans son monde
audience : groupe photographié / partage autorisé
permanence : sociale
conception : différée à Ludovic / ComfyUI
```

### Si B1

**20:29 — Marie**

> Tu es arrivé après le chaos et tu as quand même trouvé les cartons.

**Réponse Player guidée**

> talent rare

**20:29 — Marie**

> Je vais le mentionner dans ton évaluation annuelle.

### Si B2

**20:29 — Marie**

> Tu as ton image.

**20:29 — Marie**

> Moi j’ai encore trois personnes à saluer.

### Si B3

**20:29 — Marie**

> 21 h 30 existe toujours.

**Réponse Player guidée**

> je sais

**20:30 — Marie**

> Bien.

---

# 14. Branche C — Marie vit la soirée sans Player

Marie ne relance pas Player pendant le montage.

Elle ne lui envoie pas :

- une succession de preuves qu’elle va bien ;
- une photo destinée à provoquer ;
- un message passif-agressif ;
- une invitation tardive.

À 20:37 :

**20:37 — Marie**

> Élodie a envoyé ça au groupe.

**VISUEL 2 — À FOURNIR PLUS TARD**

```text
fonction : trace publique de la soirée réussie sans Player
audience : groupe / Player par relais privé
permanence : sociale
conception : différée à Ludovic / ComfyUI
```

**20:38 — Marie**

> Je te l’envoie parce que je l’aime bien.

**20:38 — Marie**

> Pas pour te faire venir à 21 h.

**Réponse Player guidée**

> tu as l’air bien

**20:39 — Marie**

> Je le suis.

**20:39 — Marie**

> Et j’ai toujours deux cartons à descendre, donc l’émotion reste contenue.

Cette branche affirme l’autonomie sans nier l’envie initiale de voir Player.

---

# 15. Fin de l’événement

La fermeture de La Verrière a lieu vers 22:35.

Player et Marie sont séparés avant le retour textuel :

- Marie termine avec Élodie ;
- Player est rentré ou reparti ;
- ou Marie est en trajet après avoir rendu les clés.

Mode :

```text
AFTERGLOW_REMOTE
```

À 23:05 :

**23:05 — Marie**

> Élodie vient de me renvoyer la dernière.

**VISUEL 3 — À FOURNIR PLUS TARD**

```text
fonction : fin de soirée / autonomie / mémoire de présence ou d’absence
audience : Player
permanence : à définir selon le résultat et le canon visuel
conception : différée à Ludovic / ComfyUI
```

La fonction du troisième visuel varie :

- présence active : mémoire partagée ;
- présence de spectateur : Marie regardée dans son monde ;
- absence : autonomie et soirée vécue ;
- présence distraite : contraste entre être visible et être réellement rejointe.

---

# 16. Retour après branche A1 ou A2 — Présence active

**23:07 — Marie**

> Merci pour ce soir.

**23:07 — Marie**

> C’était bien de te voir porter des chaises, parler à Élodie et ne pas me demander toutes les cinq minutes si ça allait.

**Réponse Player guidée**

> j’étais bien là

**23:08 — Marie**

> Oui.

**23:08 — Marie**

> Je l’ai vu.

**23:09 — Marie**

> Demain, 20 h 30, on mange ensemble ?

Player reçoit trois choix :

```text
M1 accepter → marie_j09_dinner_j10_2030 ACTIVE
M2 proposer vendredi → marie_j09_dinner_friday_2030 ACTIVE
M3 refuser → marie_j09_dinner_j10_2030 REFUSED
```

Aucune réponse guidée ne crée automatiquement le dîner.

### État de sortie

```text
présence active mémorisée
retour couple J10 conditionnel au choix réel
```

Aucune récompense sexuelle automatique.

# 17. Retour après branche A3 — Présence distraite

**23:07 — Marie**

> Merci d’être venu.

**23:07 — Marie**

> Tu as passé une partie de la soirée dans ton téléphone.

**Réponse Player guidée**

> je sais

**23:08 — Marie**

> Je ne fais pas un procès.

**23:08 — Marie**

> Je note la différence.

**23:09 — Marie**

> Demain, ne bloque rien pour moi.

**23:09 — Marie**

> Dis-moi juste si tu rentres.

### État de sortie

```text
présence physique non suffisante
aucun rendez-vous couple verrouillé pour J10
retour domestique à confirmer
```

---

# 18. Retour après branche B1 — Arrivée tardive active

**23:07 — Marie**

> Tu es arrivé à l’heure que tu avais donnée.

**23:07 — Marie**

> Et tu as pris un bout de la soirée en charge.

**Réponse Player guidée**

> j’aurais préféré être là plus tôt

**23:08 — Marie**

> Peut-être.

**23:08 — Marie**

> Mais tu n’as pas promis plus tôt.

**23:09 — Marie**

> Ce soir, ce que tu as dit et ce que tu as fait se ressemblent.

**23:10 — Marie**

> Demain 20 h 30 ?

Player accepte, propose vendredi ou refuse selon les choix M1–M3 définis en section 16.

### État de sortie

```text
présence tardive fiable
retour couple J10 conditionnel au choix réel
```

# 19. Retour après branche B2 — Player est venu regarder

**23:07 — Marie**

> J’étais contente de te voir.

**23:07 — Marie**

> Mais tu es venu me regarder.

**23:08 — Marie**

> Pas vraiment être avec moi.

**Réponse Player guidée**

> c’est pas faux

**23:08 — Marie**

> Non.

**23:09 — Marie**

> Et ce n’est pas rien.

**23:09 — Marie**

> Mais ce n’est pas pareil.

### État de sortie

```text
Marie se sait désirée visuellement
qualité de présence insuffisante pour une reconquête active
aucun rendez-vous couple automatique
```

Cette branche est importante :

- le regard de Player compte ;
- il ne remplace pas l’action ;
- Marie n’est pas ingrate ;
- Player ne peut pas appeler `présence` tout ce qu’il ressent à distance.

---

# 20. Retour après branche B3 — Présence bornée

**23:07 — Marie**

> Tu es parti à 21 h 30.

**23:07 — Marie**

> Exactement comme annoncé.

**Réponse Player guidée**

> tu vérifies mes sorties maintenant

**23:08 — Marie**

> Non.

**23:08 — Marie**

> J’apprécie simplement les heures qui ne fondent pas.

**23:09 — Marie**

> Demain 20 h 30, tu peux ?

Player reçoit un vrai choix.

### M1 — Accepter

**Player**

> oui. 20 h 30

**Marie**

> Alors je bloque.

```text
promise_id: marie_j09_dinner_j10_2030
status: ACTIVE
```

### M2 — Proposer vendredi

**Player**

> demain non. vendredi 20 h 30 si tu peux

**Marie**

> Vendredi, oui.

```text
promise_id: marie_j09_dinner_friday_2030
status: ACTIVE
```

### M3 — Refuser

**Player**

> non. ne bloque pas pour moi

**Marie**

> D’accord.

```text
promise_id: marie_j09_dinner_j10_2030
status: REFUSED
```

### État de sortie

```text
présence limitée mais fiable
retour couple conditionnel au choix réel
```

# 21. Retour après branche C — Absence honnête

**23:07 — Marie**

> Je ferme.

**23:07 — Marie**

> La soirée était bien.

**23:08 — Marie**

> Vraiment.

**Réponse Player guidée**

> je suis content

**23:08 — Marie**

> Moi aussi.

**23:09 — Marie**

> Et merci d’avoir dit non avant.

**23:09 — Marie**

> Je n’ai attendu personne.

**23:10 — Marie**

> Demain 20 h 30, tu es là ?

Player accepte, propose vendredi ou refuse exactement comme dans la branche B3.

Aucune réponse guidée ne crée automatiquement le dîner.

### État de sortie

```text
absence honnête correctement absorbée
Marie autonome
retour couple conditionnel au choix réel
```

Le jeu ne traduit pas cette branche par une soirée ratée, une autre personne qui remplace Player ou une punition de route.

# 22. Effets de la qualité J08 sur le ton J09

J09 doit reconnaître J08 sans devenir une journée de règlement de comptes.

## J08 anticipation / amendement clair

Marie accorde plus facilement du crédit aux heures données.

## J08 vague / attentes ratées

Marie demande une réponse plus nette à 15:48.

Si Player donne ensuite une vraie heure J09 et la tient, cette amélioration compte.

Le jeu ne fige donc pas Player dans son erreur précédente.

## J08 refus honnête

Marie traite Player comme quelqu’un qui peut dire non sans détruire le lien.

La branche C J09 reste donc pleinement valable.

---

# 23. Personnages secondaires dans J09

## Élodie

Élodie existe comme :

- collègue ;
- témoin de travail ;
- source légitime d’une trace visuelle ;
- personne qui partage le chaos de La Verrière.

Elle n’est :

- ni route ;
- ni analyste du couple ;
- ni messagère de jalousie ;
- ni personne omnisciente.

## Pauline et Bastien

Ils peuvent être présents socialement dans la salle ou hors champ.

Ils ne possèdent aucun fil J09.

Leur convergence reste réservée à J12.

## Nico

Il n’est pas utilisé comme observateur jaloux de la robe noire dans J09.

Son rôle J07–J08 reste distinct.

## Mathilde

Elle ne devient pas automatiquement responsable du foyer pendant l’absence de Marie.

Sa vie continue hors champ.

## Sandra et Raphaëlle

Aucun message.

J10 décidera si une continuité extérieure devient réellement foreground.

---

# 24. Handoff vers J10

J09 ne choisit pas le pivot J10.

Elle crée seulement un état de couple secondaire.

## États possibles Marie

```text
M1 présence active + dîner J10 possible selon choix
M2 présence tardive fiable + dîner J10 possible selon choix
M3 présence bornée + dîner J10 accepté, amendé ou refusé
M4 absence honnête + dîner J10 accepté, amendé ou refusé
M5 présence distraite + retour à confirmer
M6 présence de spectateur + désir vu mais action insuffisante
```

## Sélection future J10

Le pivot extérieur pourra être :

- Sandra ;
- Mathilde ;
- Raphaëlle ;
- Nico ;
- ou aucune route extérieure.

La décision dépendra de la continuité réellement construite avant J10.

J09 n’accorde aucun avantage automatique à une route extérieure.

---

# 25. Ancien matériau J03 réutilisé

Les anciennes scènes :

```text
chapter_03_marie_event_offer
chapter_03_marie_event_joined
chapter_03_marie_event_return
```

fournissent une bonne base fonctionnelle.

Éléments conservés :

- La Verrière ;
- besoin de deux bras ;
- envie personnelle distincte ;
- rallonge noire ;
- salle bruyante ;
- montage hors téléphone pendant la co-présence ;
- différence entre présence et attention ;
- retour après séparation.

Éléments retirés :

- rôle d’ouverture J03 ;
- topologie exclusive ;
- superposition prématurée ;
- dépendance à Raphaëlle J03 ;
- dépendance au chargeur Mathilde ;
- flags de route ;
- vocabulaire de vague ou ticket.

---

# 26. Ancien matériau J08 réutilisé

La scène historique :

```text
chapter_08_marie_black_dress
```

fournit :

- robe noire ;
- demande d’un avis réel ;
- distinction entre représentation sociale et privée ;
- désir de visibilité.

Le script J09 retire :

- trois images imposées techniquement ;
- choix `La Verrière / L’Annexe / jeudi privé` ;
- obligation de produire les assets maintenant ;
- promesse de version privée ;
- logique visual-first comme condition de fermeture de journée.

Marie choisit la robe noire avant le choix de Player.

---

# 27. Audit des voix

## Marie

Reconnaissable par :

- heures ;
- mouvement ;
- humour pratique ;
- La Verrière ;
- demande de deux bras ;
- distinction entre envie et besoin ;
- capacité à vivre la soirée sans Player ;
- refus des promesses décoratives ;
- plaisir réel lorsque les actes et les heures correspondent.

Marie n’est pas :

- une femme fatale générique ;
- une victime silencieuse ;
- une partenaire qui surveille toutes les autres routes ;
- une machine à punchlines.

## Player

Reconnaissable par :

- minuscules ;
- réponses courtes ;
- capacité à donner une heure ;
- possibilité d’être honnêtement absent ;
- possibilité de confondre regard et présence ;
- humour léger ;
- aucune déclaration parfaite.

## Élodie

Elle existe par :

- une trace envoyée ;
- la vie de La Verrière ;
- aucune analyse supplémentaire.

---

# 28. Test sans nom

```text
Trente-cinq personnes annoncées. Donc probablement cinquante et une dame qui demandera pourquoi le logo est petit.
→ Marie

Je ne te garde pas la partie montage. Je garde juste l’envie de te voir.
→ Marie

Tu es venu me voir. Pas vraiment être avec moi.
→ Marie

je ne viens pas ce soir. je te le dis maintenant pour que tu ne m’attendes pas
→ Player

J’apprécie simplement les heures qui ne fondent pas.
→ Marie

la rallonge demande une pause et une revalorisation salariale mais je l’apporte
→ Player dans le rythme du couple
```

---

# 29. Test de substitution

## Marie → Pauline

```text
Je ne te garde pas la partie montage. Je garde juste l’envie de te voir.
```

Friction : Pauline contrôlerait plutôt une audience ou un compartiment ; Marie parle de mouvement partagé et d’envie directe.

## Marie → Sandra

```text
Tu es venu me voir. Pas vraiment être avec moi.
```

Friction : Sandra fermerait plus doucement ou déplacerait la phrase vers une représentation ; Marie demande un acte et nomme la différence.

## Player → Nico

```text
la rallonge demande une pause et une revalorisation salariale mais je l’apporte
```

Nico pourrait faire une blague de travail, mais ici le message reste une participation domestique/sociale au monde de Marie.

---

# 30. Audit anti-dialogue générique

La journée évite :

- un événement où tout le casting apparaît ;
- un rival masculin utilisé pour rendre Marie désirable ;
- une robe noire réduite à une récompense sexuelle ;
- une photo destinée uniquement à provoquer ;
- une absence transformée automatiquement en crise ;
- un choix `venir ou perdre Marie` ;
- une longue confrontation dans la même salle ;
- un message toutes les cinq minutes pendant l’événement ;
- une conclusion parfaitement morale ;
- une route extérieure cachée derrière l’événement.

Messages ordinaires présents :

- portes à 19 h ;
- chaises ;
- rallonge noire ;
- porte scène ;
- manteaux ;
- cartons ;
- verres ;
- heure de départ.

---

# 31. Contrat visuel différé

Aucune image n’est conçue.

Trois slots fonctionnels minimum :

## V1 — Préparation privée

```text
fonction : représentation choisie par Marie avant l’événement
audience : Player
```

## V2 — Vie sociale et professionnelle

```text
fonction : Marie visible dans son monde
audience : groupe / public autorisé
```

## V3 — Fin de soirée

```text
fonction : mémoire partagée, autonomie ou conséquence selon la branche
audience : Player
```

Ludovic fournira les images plus tard via ComfyUI.

Le document ne fixe :

- ni pose ;
- ni cadrage ;
- ni tenue détaillée au-delà de l’ancre canonique `robe noire` ;
- ni décor précis ;
- ni prompt ;
- ni workflow.

---

# 32. Critères de validation J09

- [ ] Marie possède une vraie raison professionnelle et sociale ;
- [ ] sa soirée existe sans Player ;
- [ ] la robe noire est choisie avant le choix du joueur ;
- [ ] besoin logistique et envie personnelle sont distincts ;
- [ ] rejoindre tôt crée une vraie participation ;
- [ ] venir tard avec une heure précise reste valable ;
- [ ] l’absence honnête n’est pas punie ;
- [ ] la présence distraite a une conséquence ;
- [ ] venir regarder n’est pas traité comme être avec Marie ;
- [ ] la co-présence limite les messages à la logistique ;
- [ ] le retour émotionnel arrive après séparation ;
- [ ] aucun autre personnage ne vole le pivot ;
- [ ] aucune route extérieure n’est sélectionnée ;
- [ ] aucune permission adulte n’est créée ;
- [ ] trois slots visuels sont réservés sans conception ;
- [ ] J10 reçoit un état de couple secondaire mais garde son pivot extérieur variable.

---

# 33. Résumé canonique candidat

J09 remet Marie au centre après la première superposition.

Elle prépare un événement à La Verrière, choisit la robe noire pour elle-même et dit clairement à Player qu’elle a besoin de deux bras mais qu’elle a aussi simplement envie de le voir.

Player peut venir à 18 h et participer, arriver à 20 h 15 avec une heure de départ précise, ou annoncer qu’il ne viendra pas.

S’il vient tôt, sa qualité de présence devient lisible : initiative, humour utile ou distraction.

S’il vient tard, il peut rejoindre le mouvement, venir surtout regarder ou tenir une présence bornée.

S’il ne vient pas, Marie vit une soirée réussie sans l’utiliser comme provocation.

Après séparation, Marie distingue :

- le regard ;
- l’aide ;
- la présence ;
- l’attention ;
- l’absence annoncée ;
- l’absence déplacée dans un téléphone.

J09 ne verrouille aucune route extérieure.

Elle donne seulement au couple une nouvelle vérité : Marie est désirable parce qu’elle possède une vie à rejoindre, pas parce qu’elle menace de partir.

> **Player peut regarder Marie vivre. Il peut aussi entrer dans cette vie. J09 montre que ce ne sont pas les mêmes actes.**

---

# Annexe canonique — Identifiants consolidés

```text
trace_id: j09_marie_black_dress_private_01
trace_id: j09_marie_laverriere_public_01
trace_id: j09_marie_laverriere_after_01
promise_id: marie_j09_dinner_j10_2030
promise_id: marie_j09_dinner_friday_2030
fact_id: fact_player_received_marie_black_dress_image
fact_id: fact_marie_public_professional_version_visible
```

Créateurs : Marie pour la trace privée ; Élodie pour les traces La Verrière.
