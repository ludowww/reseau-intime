# Réseau Intime — J10 Script narratif complet

## Statut

**Catégorie : Canon validé narrativement — source pré-runtime consolidée**

**Périmètre : J10 uniquement**

**Surface : messagerie texte uniquement**

Ce document définit la version narrative complète de J10 avant toute adaptation technique.

Il applique les corrections de :

```text
J01_J09_AUDIT_CONFORMITE_NARRATIVE.md
```

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

J10 devient :

```text
Jeudi — Une ligne devient réelle
```

Une seule continuité extérieure peut recevoir le pivot principal :

```text
Sandra — S16 Le café enfin tenu
Mathilde — S17 La tenue remarquée devient choisie
Raphaëlle — S21 La fermeture cassée
Nico — S22 Le regard de l’intérieur et de l’extérieur
aucune continuité — conséquence Marie ou respiration
```

Le joueur ne voit jamais cette liste.

Il ne choisit jamais un nom comme destination.

La journée lui présente uniquement la scène rendue possible par son histoire réelle.

---

# 2. Question dramatique

> Une possibilité répétée devient-elle enfin un acte réel, une limite claire ou une occasion qui cesse d’attendre ?

J10 doit distinguer :

- disponibilité ;
- intention ;
- proximité ;
- permission ;
- promesse ;
- occasion perdue ;
- frontière maintenue.

Une scène plus intense n’est pas automatiquement une meilleure sortie.

---

# 3. État d’entrée

À la fin de J09 :

- Marie possède un état secondaire de couple ;
- un dîner J10 peut être confirmé, déplacé à vendredi ou refusé ;
- Sandra peut avoir une continuité de confiance et un café encore possible ;
- Mathilde peut avoir reconnu un regard sans avoir encore choisi son effet ;
- Raphaëlle peut disposer d’une confiance professionnelle et d’un accès au processus encore fermé ;
- Nico peut avoir reçu une confidence et une continuation acceptée, différée ou fermée ;
- aucune route extérieure n’est définitivement verrouillée ;
- aucune permission adulte n’est créée ;
- aucune conséquence prioritaire de sécurité ou de consentement ne peut être ignorée.

---

# 4. Priorité avant sélection du pivot

Avant toute nouvelle opportunité, J10 paie les obligations déjà dues.

## 4.1 Dîner Marie confirmé jeudi 20 h 30

À 08:21 :

**Marie**

> 20 h 30 tient toujours ?

Player choisit réellement.

### M1 — Maintenir

**Player**

> oui. 20 h 30

**Marie**

> Parfait.

**Marie**

> Je prends du pain. Toi, quelque chose qui ressemble à un dîner.

État :

```text
dîner Marie dû à 20 h 30
```

La continuité extérieure J10 doit se terminer suffisamment tôt.

### M2 — Amender précisément

**Player**

> ce soir non. vendredi 20 h 30 tient si tu peux

**Marie**

> Vendredi, oui.

**Marie**

> Je déplace. Je ne garde pas les deux soirs en attente.

État :

```text
aucun dîner dû jeudi
obligation vendredi 20 h 30
```

### M3 — Annuler honnêtement

**Player**

> je ne peux pas. ne m’attends pas ce soir

**Marie**

> D’accord.

**Marie**

> Je n’attends pas.

État :

```text
aucune obligation couple jeudi
```

## 4.2 Dîner déjà placé vendredi

Aucun nouveau choix jeudi.

Marie peut envoyer seulement :

> Vendredi 20 h 30 tient toujours de mon côté.

Player répond :

> du mien aussi

Cette réponse confirme un engagement déjà choisi, sans créer le pivot J10.

## 4.3 Aucun dîner créé

Aucun message Marie artificiel n’est ajouté le matin.

La vie du couple reste présente dans les conséquences ou la respiration du soir.

---

# 5. Sélection narrative invisible

## 5.1 Conditions communes

Une variante extérieure exige :

- accès ordinaire déjà établi ;
- aucune limite bloquante ;
- aucune conséquence prioritaire impayée ;
- contexte horaire crédible ;
- moteur non utilisé trop récemment ;
- personnage disponible pour une raison indépendante de Player ;
- scène capable d’expirer ou de muter.

## 5.2 Ordre de décision sans score visible

Lorsqu’au moins une variante est éligible :

1. une rencontre ou promesse explicitement due aujourd’hui passe en premier ;
2. sinon, une initiative directe du personnage avec une fenêtre qui expire passe avant une possibilité abstraite ;
3. sinon, la question relationnelle la plus spécifique et non payée peut devenir foreground ;
4. une relation récemment foreground recule devant une continuité construite mais encore non incarnée ;
5. si l’égalité reste artificielle, aucune route extérieure n’est sélectionnée.

Le jeu préfère :

```text
respiration crédible
```

à :

```text
choix arbitraire d’un personnage
```

## 5.3 Une seule variante

Une fois le pivot choisi :

- les autres variantes n’apparaissent pas ;
- aucune notification ne les annonce ;
- aucune route non choisie n’est punie ;
- les autres personnages continuent leur vie hors champ ;
- un écho secondaire ne peut pas accomplir la même progression.

---

# 6. Variante Sandra — S16 Le café enfin tenu

## 6.1 Éligibilité

Sandra peut devenir le pivot si :

- J01 a établi une représentation choisie ;
- la continuité J03 n’a pas été violée ;
- aucun refus clair n’est ignoré ;
- le café n’a jamais eu lieu ;
- son horaire de poste rend la rencontre crédible ;
- la scène peut encore expirer sans bloquer Sandra.

## 6.2 Carte de scène

```text
scene_id: sandra_cafe_finally_held_01
source_sequence_id: S16
scene_class: ROUTE_CONTINUATION
primary_function: donner un corps réel à la proximité retrouvée
principal_character: Sandra
primary_relationship: Player / Sandra
communication_mode: REMOTE_ASYNC → OFF_PHONE → AFTERGLOW_REMOTE
```

## 6.3 Contexte

Sandra termine un poste du matin.

Elle possède trente-cinq minutes avant son train.

Le café est près de la gare.

Player est suffisamment proche pour que la proposition soit réelle, mais pas automatiquement disponible.

## 6.4 Carte de voix

```text
voice_state: cautious_available
message_burst_shape: 3 messages, choix, silence
humor_mode: minimisation et logistique
emoji_budget: 0
forbidden_leakage: aucune poésie du flou, aucune déclaration, aucun surnom fréquent
```

## 6.5 Ouverture

**12:21 — Sandra**

> Je sors plus tôt.

**12:21 — Sandra**

> J’ai trente-cinq minutes avant mon train.

**12:22 — Sandra**

> Le café près de la gare existe toujours, apparemment.

Player reçoit un vrai choix de disponibilité.

---

## 6.6 Choix de disponibilité Sandra

### S-A — Accepter maintenant

**Player**

> j’arrive. 12 h 40

**12:23 — Sandra**

> D’accord.

**12:23 — Sandra**

> Trente minutes. Je garde cinq minutes pour rater mon quai seule.

La messagerie s’arrête à la rencontre.

### Événement hors téléphone

```text
12:40–13:10
café bref
aucun dialogue oral montré
Sandra et Player parlent de choses concrètes : poste, trajet, dernier déjeuner, vie actuelle
aucune photo obligatoire
aucune déclaration complète
```

Le résultat revient après séparation.

### S-B — Proposer une seule alternative précise

**Player**

> pas aujourd’hui. samedi 11 h au même endroit si tu peux

**12:23 — Sandra**

> Samedi, peut-être.

**12:24 — Sandra**

> Je te confirme vendredi avant 18 h.

**12:24 — Sandra**

> Si je ne confirme pas, ne garde pas ta matinée pour ça.

État :

```text
promise_id: sandra_cafe_saturday_1100
status: CONDITIONAL
confirmation_deadline: J11 vendredi 18 h
possible_due_at: J12 samedi 11 h
aucune escalade J11
```

### S-C — Fermer l’occasion

**Player**

> je ne peux pas. et je préfère qu’on ne garde pas ce rendez-vous en suspens

**12:23 — Sandra**

> D’accord.

**12:24 — Sandra**

> Merci de le dire comme ça.

**12:24 — Sandra**

> Je prends mon train.

État :

```text
occasion S16 fermée
relation non détruite
aucune compensation
```

---

# 7. Après le café Sandra

À 13:27 :

**Sandra**

> Train attrapé.

**Sandra**

> J’ai eu le train.

**Sandra**

> On ne va pas en faire un événement.

**Player guidé**

> tu as couru

**Sandra**

> J’ai marché très vite avec dignité.

Le choix relationnel apparaît ensuite.

## S1 — Présence calme

**Player**

> c’était simple. ça m’a fait du bien de te voir

**Sandra**

> Moi aussi.

**Sandra**

> C’était bien.

**Sandra**

> On peut laisser ça comme ça pour aujourd’hui.

État :

```text
confiance renforcée
future image destinée possible mais non due
```

## S2 — Nommer le manque avec prudence

**Player**

> ça m’avait manqué de te voir comme ça

**Sandra**

> Je sais pas encore quoi faire de cette phrase.

**Sandra**

> Mais je ne vais pas faire semblant qu’elle ne me touche pas.

**Sandra**

> Doucement.

État :

```text
manque soupçonné comme partagé
intention à clarifier en J11
aucune permission d’image ou adulte
```

## S3 — Maintenir une amitié plus distante

**Player**

> j’étais content de te voir. je préfère qu’on garde ça dans une amitié simple

**Sandra**

> D’accord.

**Sandra**

> Le café reste le café.

**Sandra**

> Ça me va.

État :

```text
rencontre réelle
frontière amicale reconnue
pas de S19 immédiat
```

---

# 8. Visuels — Variante Sandra

## V1 — Café Sandra

```text
type: IMAGE_DE_SCÈNE
center: Sandra
function: rencontre enfin réelle
circulable: false
```

Aucune caméra diégétique n’est inventée.

## V2 — Marie / conséquence de couple

```text
type: IMAGE_DE_SCÈNE ou PHOTO_DIÉGÉTIQUE selon l’état J09
center: Marie
function: dîner payé, déplacé ou soirée autonome
```

## V3 — Mathilde au foyer

```text
type: IMAGE_DE_SCÈNE
center: Mathilde
function: vie domestique autonome, sans progression de route
circulable: false
```

---

# 9. Sortie Sandra vers J11

- S1 : confiance, possibilité future sans obligation ;
- S2 : intention due, S19 éligible ;
- S3 : amitié bornée, S19 non éligible ;
- alternative : S16 reste conditionnelle, aucune intensification ;
- fermeture : Sandra continue sa vie, aucune route de remplacement.

---

# 10. Variante Mathilde — S17 La tenue remarquée devient choisie

## 10.1 Éligibilité

Mathilde peut devenir le pivot si :

- le séjour au foyer est encore actif ;
- J06 a reconnu un regard sans limite brisée ;
- sa distance n’a pas été explicitement restaurée puis ignorée ;
- Marie est temporairement absente pour une raison réelle ;
- Mathilde possède un motif social indépendant ;
- la demande d’avis n’a pas déjà eu lieu.

## 10.2 Carte de scène

```text
scene_id: mathilde_outfit_effect_chosen_01
source_sequence_id: S17
scene_class: ROUTE_CONTINUATION
primary_function: faire passer l’effet remarqué à une intention encore défendable
principal_character: Mathilde
primary_relationship: Player / Mathilde
communication_mode: TRACE_DELIVERY → REMOTE_ASYNC
```

## 10.3 Contexte

Mathilde rejoint Inès pour un verre après sa journée.

Marie est à La Verrière ou en trajet.

Player est au travail, dehors ou dans une autre partie de la ville.

Mathilde choisit d’envoyer une image à Player avant de demander à Inès.

## 10.4 Carte de voix

```text
voice_state: fast_embarrassed_intent
message_burst_shape: 5 messages, correction, choix
humor_mode: mauvaise foi et auto-correction
emoji_budget: 0 ou 1
forbidden_leakage: droit dosé, aucune confession parfaite, aucune disponibilité sexuelle
```

## 10.5 Ouverture

**17:14 — Mathilde**

> Question vêtement.

**17:14 — Mathilde**

> Inès me rejoint dans une heure.

**17:15 — Mathilde**

> J’hésite entre deux.

**17:15 — Mathilde**

> Je t’envoie avant de lui demander.

**17:15 — Mathilde**

> C’est probablement une mauvaise idée.

**VISUEL M1 — À PRODUIRE PLUS TARD**

```text
type: PHOTO_DIÉGÉTIQUE
creator: Mathilde
origin: miroir ou préparation au foyer
intended_audience: Player
function: avis demandé et effet possible
saving: consultable dans le fil
transfer: interdit sans nouvel accord
```

Player reçoit trois lectures.

---

# 11. Choix Mathilde

## M-A — Avis précis sans appropriation

**Player**

> la première. la veste donne une ligne plus nette et ça ressemble plus à toi qu’à une tenue fabriquée

**Mathilde**

> Bon.

**Mathilde**

> C’est exactement ce que je pensais.

**Mathilde**

> J’avais changé la veste après l’autre matin.

**Mathilde**

> Je voulais voir si tu le remarquerais.

**Mathilde**

> Ne prends pas trop confiance.

État :

```text
effet choisi reconnu
limite nommée
S20 possible en J11
```

## M-B — Reconnaître l’effet possible

**Player**

> tu sais très bien que la première me fera regarder

**Mathilde**

> Je savais que tu pouvais.

**Mathilde**

> Je savais moins que tu l’écrirais.

**Mathilde**

> Et ne pars pas trop loin avec ça.

**Mathilde**

> Mais oui. Je l’avais un peu choisie pour l’effet.

État :

```text
désir potentiel nommé
permission générale refusée
S20 possible avec vigilance élevée
```

## M-C — Ramener au contexte pratique

**Player**

> la deuxième. et prends une veste, il va pleuvoir

**Mathilde**

> Merci papa.

**Mathilde**

> Je demandais aussi si tu remarquerais la première.

**Mathilde**

> Mais on peut garder la réponse météo.

**Mathilde**

> C’est plus simple.

État :

```text
intention laissée défendable
proximité non niée
aucune escalade J11 automatique
```

---

# 12. Après la sortie Mathilde

À 22:06 :

**Mathilde**

> Inès a choisi la même que toi.

**Mathilde**

> Donc tu n’étais pas complètement perdu.

### Après M-A

**Player guidé**

> et toi

**Mathilde**

> J’ai gardé la première.

**Mathilde**

> C’était mon choix avant les deux avis.

### Après M-B

**Player guidé**

> et l’effet

**Mathilde**

> A existé.

**Mathilde**

> Fin du compte rendu pour ce soir.

### Après M-C

**Player guidé**

> tu as pris la veste

**Mathilde**

> Oui.

**Mathilde**

> L’intimité a ses limites. La pluie aussi.

---

# 13. Visuels — Variante Mathilde

## V1 — Image d’avis

```text
type: PHOTO_DIÉGÉTIQUE
center: Mathilde
creator: Mathilde
audience: Player
function: intention testée
```

## V2 — Résultat social

```text
type: PHOTO_DIÉGÉTIQUE ou IMAGE_DE_SCÈNE
center: Mathilde
creator: Inès si diégétique
initial_audience: Mathilde / Inès
private_relay: seulement si Mathilde choisit de l’envoyer
function: choix maintenu hors du regard de Player
```

L’envoi à Player n’est pas obligatoire.

## V3 — Marie

```text
type: IMAGE_DE_SCÈNE ou trace ordinaire
center: Marie
function: vie propre / dîner / retour La Verrière
```

---

# 14. Sortie Mathilde vers J11

- M-A : intention reconnue et bornée ;
- M-B : effet assumé, limite explicite, S20 possible ;
- M-C : ambiguïté maintenue mais non récompensée ;
- aucun choix n’autorise une scène sexuelle ;
- Marie reste une responsabilité réelle ;
- Mathilde conserve le droit de ne pas revenir dans la pièce.

---

# 15. Variante Raphaëlle — S21 La fermeture cassée

## 15.1 Éligibilité

Raphaëlle peut devenir le pivot si :

- confiance professionnelle suffisante ;
- J08 payé ou amendé honnêtement ;
- aucune rupture de confiance due ;
- Maud et le projet créatif existent réellement ;
- un problème de fabrication survient indépendamment de Player ;
- Player n’a pas déjà obtenu le même accès.

## 15.2 Carte de scène

```text
scene_id: raphaelle_broken_fastener_process_01
source_sequence_id: S21
scene_class: ROUTE_CONTINUATION
primary_function: inviter Player dans le processus sans confondre aide, regard et permission
principal_character: Raphaëlle
primary_relationship: Player / Raphaëlle
communication_mode: TRACE_DELIVERY → REMOTE_ASYNC → OFF_PHONE_OPTIONAL → AFTERGLOW_REMOTE
```

## 15.3 Contexte

Raphaëlle prépare avec Maud une séance courte le lendemain.

Une fermeture magnétique tient mal sur une pièce de costume.

Maud est partie chercher un remplacement.

Raphaëlle a deux solutions imparfaites et veut un regard extérieur sur ce qui se lit à l’image.

## 15.4 Carte de voix

```text
voice_state: focused_process_access
message_burst_shape: 4 messages précis, choix, espace
humor_mode: processus exact
emoji_budget: 0
forbidden_leakage: pas de “cadre” répété, pas de séduction professionnelle, pas de perfection permanente
```

## 15.5 Ouverture

**17:38 — Raphaëlle**

> J’ai un problème concret.

**17:38 — Raphaëlle**

> La fermeture magnétique tient debout et abandonne dès que le tissu bouge.

**17:39 — Raphaëlle**

> Maud cherche un remplacement.

**17:39 — Raphaëlle**

> J’ai deux réparations visibles. J’ai besoin d’un regard qui n’a pas passé trois heures à les fabriquer.

**VISUEL R1 — À PRODUIRE PLUS TARD**

```text
type: PHOTO_DIÉGÉTIQUE
creator: Raphaëlle
origin: détail de fabrication
intended_audience: Player
function: accès au processus
saving: consultable dans le fil
transfer: interdit
```

---

# 16. Choix Raphaëlle

## R-A — Aider le processus

**Player**

> envoie les deux versions et une vue un peu plus loin. je te dis ce qui ressemble à un choix, pas à une réparation

**Raphaëlle**

> Exactement.

**Raphaëlle**

> Je t’envoie la seconde série.

**VISUEL R2 — À PRODUIRE PLUS TARD**

```text
type: PHOTO_DIÉGÉTIQUE
creator: Raphaëlle ou Maud
function: comparaison de processus
intended_audience: Player
```

Player répond :

> la deuxième. la ligne reste volontaire quand elle bouge

**Raphaëlle**

> C’est aussi mon avis.

**Raphaëlle**

> Si tu peux passer à 18 h 15, j’ai besoin de deux mains pendant vingt minutes.

Player reçoit un vrai choix.

### R-A1 — Accepter la visite bornée

**Player**

> oui. 18 h 15 à 18 h 40

**Raphaëlle**

> Très bien.

**Raphaëlle**

> Maud sera là au début.

La messagerie s’arrête à la rencontre.

```text
18:15–18:38
atelier
Maud présente au début
Player aide à maintenir la pièce ou vérifier le mouvement
aucune conversation orale jouée
aucun accès corporel déduit de l’aide
```

Après séparation :

**19:02 — Raphaëlle**

> La fermeture tient.

**19:02 — Raphaëlle**

> Et tu es parti à l’heure annoncée.

**19:03 — Raphaëlle**

> Les deux sont appréciables.

État :

```text
accès processus accordé
confiance créative limitée
J11 continuation possible
```

### R-A2 — Refuser précisément

**Player**

> je ne peux pas passer. mon avis reste la deuxième, mais ne m’attends pas

**Raphaëlle**

> Reçu.

**Raphaëlle**

> Maud revient dans vingt minutes.

État :

```text
avis utile
aucune visite
aucune dette
```

## R-B — S’intéresser au résultat seulement

**Player**

> je risque de voir une réparation parce que tu me l’as dit. envoie-moi plutôt le résultat demain

**Raphaëlle**

> C’est une réponse valable.

**Raphaëlle**

> Elle ne m’aide pas maintenant.

**Raphaëlle**

> Mais elle évite un faux avis.

État :

```text
processus fermé
résultat futur possible
confiance professionnelle maintenue
```

## R-C — Préserver la frontière

**Player**

> demande à Maud. je préfère rester hors de l’essayage et du processus

**Raphaëlle**

> D’accord.

**Raphaëlle**

> C’est clair.

**Raphaëlle**

> Je t’enverrai seulement ce qui devient public, si quelque chose le devient.

État :

```text
frontière professionnelle maintenue
aucune image privée supplémentaire
S21 fermée pour cette fenêtre
```

---

# 17. Visuels — Variante Raphaëlle

## V1 — Détail du problème

```text
type: PHOTO_DIÉGÉTIQUE
center: Raphaëlle / craft
creator: Raphaëlle
audience: Player
function: accès au processus
```

## V2 — Version comparée ou résultat

```text
type: PHOTO_DIÉGÉTIQUE
center: Raphaëlle
creator: Raphaëlle ou Maud
audience: selon choix
function: évolution du processus ou frontière
```

## V3 — Marie

```text
type: IMAGE_DE_SCÈNE ou photo ordinaire
center: Marie
function: conséquence du dîner J10 ou autonomie
```

---

# 18. Sortie Raphaëlle vers J11

- R-A1 : accès atelier limité, continuation possible ;
- R-A2 : avis utile sans proximité ;
- R-B : résultat uniquement, aucune intimité de processus ;
- R-C : frontière maintenue ;
- aucune branche ne transforme l’aide en permission corporelle ;
- Maud reste réelle ;
- le dîner Marie dû reste prioritaire et la visite se termine avant lui.

---

# 19. Variante Nico — S22 Le regard de l’intérieur et de l’extérieur

## 19.1 Éligibilité

Nico peut devenir le pivot si :

- sa confidence J07 existe ;
- Player a accepté une continuation réelle ou l’a différée précisément vers jeudi puis confirmée ;
- aucune attente vague J08 n’est encore impayée ;
- Nico n’a pas fermé la chaise ;
- il possède une observation sociale réelle ;
- aucune image privée n’est nécessaire.

## 19.2 Carte de scène

```text
scene_id: nico_inside_outside_gaze_01
source_sequence_id: S22
scene_class: ROUTE_CONTINUATION
primary_function: confronter regard social et version domestique sans transférer d’image
principal_character: Nico
primary_relationship: Player / Nico
communication_mode: REMOTE_ASYNC ou OFF_PHONE_DUE → AFTERGLOW_REMOTE
```

## 19.3 Origine de l’observation

Marie et Mathilde sont passées à L’Annexe à midi pour récupérer quelque chose ou boire rapidement avec une connaissance.

Player n’était pas présent.

Un set public autorisé de L’Annexe peut exister, mais Nico ne demande ni ne reçoit aucune image privée.

## 19.4 Visuels publics associés

**VISUEL N1**

```text
type: PHOTO_DIÉGÉTIQUE PUBLIQUE
creator: personne autorisée de L’Annexe
center: Marie
function: Marie dans une interaction sociale ordinaire
audience: publication ou groupe autorisé
```

**VISUEL N2**

```text
type: PHOTO_DIÉGÉTIQUE PUBLIQUE distincte
creator: personne autorisée de L’Annexe
center: Mathilde
function: version sociale distincte de la version domestique
audience: publication ou groupe autorisé
```

Les deux images sont individuellement consultables.

Elles ne sont pas des crops privés.

## 19.5 Entrée si rencontre jeudi différée depuis J07

À 18:12 :

**Nico**

> Tu confirmes 18 h 20 ?

Player choisit :

### N-A — Confirmer

> oui. dix minutes avant ton service

Nico :

> Dix minutes.

> Après je travaille.

La messagerie s’arrête à la rencontre.

```text
18:20–18:30
rencontre hors téléphone
aucun dialogue oral montré
```

À 18:42, Nico ouvre le retour écrit.

### N-B — Annuler clairement

> non. ne m’attends pas

Nico :

> Reçu.

> Je ne repropose pas ce soir.

La variante S22 mute en court écho textuel ou ferme pour J10.

## 19.6 Entrée si rencontre J08 déjà payée

À 22:11, après le service :

**Nico**

> Marie et Mathilde sont passées à midi.

**Nico**

> Elles ne prennent pas la même place dehors que chez vous.

## 19.7 Noyau commun

**Nico**

> Marie parle à une pièce comme si elle avait déjà décidé qu’elle allait vivre.

**Nico**

> Mathilde regarde d’abord qui la regarde, puis fait une blague pour reprendre la main.

**Player guidé**

> et tu veux savoir quoi

**Nico**

> Ce que toi tu vois quand il n’y a pas la salle autour.

Le choix principal apparaît.

---

# 20. Choix Nico

## N1 — Reconnaître la différence sans image

**Player**

> chez nous Marie laisse plus de silences. Mathilde prend moins de place qu’elle le prétend

**Nico**

> Ça ressemble à elles.

**Nico**

> Et je précise : je ne te demande pas de me montrer quoi que ce soit.

**Nico**

> Je voulais savoir si tu voyais une différence ou seulement un privilège.

État :

```text
comparaison admise
aucune image transmise
complicité possible avec garde-fou
```

## N2 — Demander ce que Nico a perçu

**Player**

> qu’est-ce que tu as vu exactement

**Nico**

> Marie bien dans la salle.

**Nico**

> Mathilde contente d’être remarquée et agacée de l’être.

**Nico**

> Et moi intéressé, donc pas neutre.

**Nico**

> C’est tout ce que je peux affirmer.

État :

```text
regard social borné
Nico reconnaît son intérêt
aucun fait privé ajouté
```

## N3 — Fermer la comparaison

**Player**

> je ne veux pas qu’on compare ce qu’elles sont dehors et chez moi

**Nico**

> D’accord.

**Nico**

> Je ne redemande pas.

**Nico**

> Et ce que tu m’as dit reste avec moi.

État :

```text
limite posée
Nico garde la confidence
S22 fermée pour cette phase
```

---

# 21. Visuels — Variante Nico

## V1 — Marie publique à L’Annexe

```text
type: PHOTO_DIÉGÉTIQUE PUBLIQUE
center: Marie
function: regard extérieur réel
```

## V2 — Mathilde publique à L’Annexe

```text
type: PHOTO_DIÉGÉTIQUE PUBLIQUE
center: Mathilde
function: différence social / domestique
```

## V3 — Marie ou Mathilde hors regard de Nico

```text
type: IMAGE_DE_SCÈNE ou trace ordinaire
center: Marie ou Mathilde
function: rappeler que leur vie ne se résume pas à son observation
circulable: false si image de scène
```

Une image Nico peut être ajoutée en quatrième contenu.

Elle ne remplace pas le minimum féminin.

---

# 22. Sortie Nico vers J11

- N1 : complicité et garde-fou ;
- N2 : regard social borné, rivalité possible ;
- N3 : comparaison fermée ;
- aucune image privée ;
- aucune permission concernant Marie ou Mathilde ;
- aucune route Player / Nico ;
- aucune autorisation adulte entre les hommes.

---

# 23. Fallback — Aucune continuité extérieure

## 23.1 Conditions

Le fallback est utilisé si :

- aucune variante n’est éligible ;
- plusieurs variantes restent artificiellement à égalité ;
- une conséquence Marie doit passer avant ;
- les refus précédents ont fermé les opportunités ;
- le cooldown rend toute progression extérieure répétitive.

## 23.2 Carte de scène

```text
scene_id: j10_no_external_respiration_01
source_sequence_id: S15_CONSEQUENCE_OR_RESPIRATION
scene_class: CONSEQUENCE_OR_RESPIRATION
primary_function: montrer que l’absence de route extérieure est un état réel
principal_relationship: Player / Marie ou foyer
communication_mode: REMOTE_ASYNC → OFF_PHONE
```

Cette désignation utilise une conséquence de S15 ou une respiration canonique.

Elle ne crée pas une nouvelle séquence.

## 23.3 Si dîner Marie dû

Le dîner à 20 h 30 devient le pivot réel.

**19:52 — Marie**

> J’ai le pain.

**19:52 — Marie**

> Tu as la partie qui transforme ça en dîner ?

Player choisit :

### F-A — Payer

> oui. j’arrive à 20 h 25

Marie :

> Parfait.

La messagerie s’arrête à la co-présence.

```text
20:25–soir
repas hors téléphone
aucun dialogue oral joué
```

### F-B — Amender trop tard

> je serai là à 21 h

Marie :

> Non.

> Je mange avec Mathilde.

> Il restera de quoi pour toi.

### F-C — Annuler

> je ne rentre pas pour dîner. ne m’attends pas

Marie :

> D’accord.

> On mange.

## 23.4 Si aucun dîner dû

À 19:48 :

**Marie**

> Mathilde et moi mangeons à 20 h 30.

**Marie**

> Il y aura assez pour trois, mais ce n’est pas une convocation.

Player choisit :

- rejoindre à 20 h 30 ;
- annoncer 21 h et manger séparément ;
- ne pas rentrer.

Aucune réponse ne déclenche une route de compensation.

## 23.5 Visuels fallback

### V1 — Marie

```text
type: IMAGE_DE_SCÈNE
center: Marie
function: vie commune ou autonomie
```

### V2 — Mathilde

```text
type: IMAGE_DE_SCÈNE
center: Mathilde
function: foyer temporaire réel, sans intention
```

### V3 — Pauline / Bastien ou Marie

```text
type: PHOTO_DIÉGÉTIQUE PUBLIQUE ou respiration Marie
center: femme principale
function: réseau vivant sans nouvelle progression
```

Pauline n’obtient aucun accès privé.

---

# 24. Retour Marie commun

J10 ne doit pas effacer Marie parce qu’une route extérieure devient foreground.

## Si dîner dû et payé

Le dîner se déroule hors téléphone.

Un message après séparation n’est pas nécessaire si Player et Marie restent au foyer.

Le résultat est mémorisé par l’acte.

## Si dîner amendé à vendredi

Marie ne relance pas jeudi.

L’obligation reste vendredi 20 h 30.

## Si dîner annulé

Marie n’attend pas.

Elle peut vivre une soirée avec Mathilde, travailler ou se reposer.

## Si J09 n’avait créé aucun dîner

Un écho Marie peut montrer :

- retour La Verrière ;
- repas avec Mathilde ;
- fatigue ;
- vie ordinaire.

Cet écho ne crée pas un nouveau conflit.

---

# 25. Budget de premier plan

Dans chaque partie :

```text
1 pivot extérieur maximum
0 ou 1 conséquence Marie
0 ou 1 écho de respiration
```

Les variantes non sélectionnées :

- ne parlent pas ;
- ne perdent pas de points ;
- ne sont pas annoncées ;
- peuvent muter ou expirer plus tard.

---

# 26. Conformité des promesses

Toute promesse importante possède un choix réel :

- dîner Marie maintenu, déplacé ou annulé ;
- café Sandra accepté, reprogrammé une seule fois ou fermé ;
- visite atelier Raphaëlle acceptée ou refusée ;
- rencontre Nico confirmée ou annulée ;
- aucune réponse guidée unique ne crée une dette future majeure.

---

# 27. Conformité text-only

- préparation par messages ;
- arrêt du chat à la rencontre ;
- aucun transcript du café ;
- aucun transcript de l’atelier ;
- aucun transcript de la rencontre Nico ;
- retour après séparation ;
- aucun appel ;
- aucun audio ;
- aucune parole orale choisie en direct.

---

# 28. Conformité des connaissances

## Sandra

Ne connaît que :

- le café ;
- ce que Player lui écrit ;
- sa propre réaction.

## Mathilde

Ne sait pas ce que Player dit à Nico, Sandra ou Raphaëlle.

## Raphaëlle

Ne sait rien du couple au-delà de ce qui affecte un horaire ou le travail.

## Nico

Ne connaît :

- que sa confidence ;
- ses observations sociales ;
- les descriptions que Player choisit de donner.

Il ne connaît aucune image privée.

## Marie

Ne reçoit aucune omniscience sur la route extérieure.

Elle connaît seulement :

- les engagements de couple ;
- les actes visibles ;
- les retards ou absences qui la concernent.

---

# 29. Handoff J11

J11 ne propose pas un catalogue.

Il continue uniquement :

- la variante J10 réellement foreground ;
- ou la conséquence du refus / de la frontière ;
- ou Marie si aucune route extérieure n’est dominante.

## Sandra

- S2 rend S19 éligible ;
- S1 permet une continuité plus lente ;
- S3 ferme l’intention ;
- reprogrammation ne permet aucune escalade J11.

## Mathilde

- M-A ou M-B peuvent rendre S20 éligible ;
- M-C conserve l’ambiguïté sans progression garantie.

## Raphaëlle

- R-A1 peut ouvrir une continuation du processus ;
- R-A2 ou R-B maintiennent une confiance limitée ;
- R-C ferme l’accès privé.

## Nico

- N1 peut devenir complicité / garde-fou ;
- N2 peut devenir rivalité bornée ;
- N3 ferme la comparaison.

## Fallback

J11 continue Marie ou paie une respiration.

Aucune route extérieure n’apparaît pour compenser le vide.

---

# 30. Audit des voix

## Sandra

- peu de rafales ;
- minimisation ;
- train et poste ;
- fermeture douce ;
- `doucement` gagné par le contexte.

## Mathilde

- messages rapides ;
- corrections ;
- mauvaise foi ;
- droit dosé ;
- intention qui se trahit sans monologue parfait.

## Raphaëlle

- problème exact ;
- processus ;
- durée ;
- limite ;
- Maud réelle ;
- aucun flirt de bureau générique.

## Nico

- salle ;
- observation concrète ;
- intérêt reconnu ;
- limite sur les images ;
- aucune thérapie.

## Marie

- heures ;
- dîner ;
- pain ;
- attente ou autonomie ;
- aucune fonction de police des routes.

---

# 31. Test sans nom

```text
Je garde cinq minutes pour rater mon quai seule.
→ Sandra

Réponse dangereusement correcte.
→ Mathilde

J’ai deux réparations visibles. J’ai besoin d’un regard qui n’a pas passé trois heures à les fabriquer.
→ Raphaëlle

Bientôt n’a pas de chaise.
→ Nico

Il y aura assez pour trois, mais ce n’est pas une convocation.
→ Marie
```

---

# 32. Audit anti-générique

J10 évite :

- un menu de personnages ;
- quatre messages reçus au même moment ;
- une scène de tenue interchangeable ;
- une photo comme permission ;
- un café-confession obligatoire ;
- un atelier comme prétexte sexuel ;
- Nico recevant une image privée ;
- Marie punissant chaque présence extérieure ;
- une progression de consolation ;
- une promesse forcée ;
- un jour vide artificiellement rempli.

---

# 33. Critères de validation J10

- [ ] une seule variante extérieure est visible ;
- [ ] la sélection dépend de faits vécus ;
- [ ] une conséquence due passe avant l’opportunité ;
- [ ] chaque variante cite sa séquence source ;
- [ ] chaque scène possède une fonction principale ;
- [ ] toute promesse importante est choisie ;
- [ ] chaque variante peut expirer ou fermer ;
- [ ] le fallback ne sélectionne aucune route ;
- [ ] trois contenus principalement féminins existent dans chaque configuration ;
- [ ] type, créateur, audience et permanence sont précisés ;
- [ ] aucune image ne vaut permission ;
- [ ] la co-présence arrête les messages ;
- [ ] aucune connaissance impossible ;
- [ ] Marie reste présente comme couple ou conséquence ;
- [ ] J11 continue uniquement la variante réellement vécue.

---

# 34. Résumé canonique candidat

J10 ne montre qu’une seule continuité extérieure.

Sandra peut enfin tenir le café plusieurs fois évoqué, le reprogrammer une seule fois ou fermer l’occasion.

Mathilde peut transformer un regard remarqué en choix vestimentaire destiné, tout en refusant qu’un effet devienne une permission générale.

Raphaëlle peut admettre Player dans un problème de fabrication réel, limiter l’accès au résultat ou maintenir une frontière professionnelle.

Nico peut mettre en regard la version sociale de Marie et Mathilde avec ce que Player connaît du foyer, sans demander ni recevoir d’image privée.

Si aucune variante n’est légitime, J10 devient une conséquence Marie ou une respiration du foyer.

Aucune relation n’est choisie dans un menu.

Aucune promesse n’est forcée.

Aucune route non sélectionnée n’est punie.

> **J10 ne récompense pas la personne la plus disponible. Elle donne une forme réelle à la continuité que les actes précédents ont effectivement construite.**

---

# Annexe canonique — Handoff lot C

La branche Sandra alternative est payée, refusée ou expirée dans le préambule J12.

```text
promise_id: sandra_cafe_saturday_1100
trace_id: j10_mathilde_outfit_choice_01
```

Une alternative conditionnelle ne devient jamais une progression J11.
