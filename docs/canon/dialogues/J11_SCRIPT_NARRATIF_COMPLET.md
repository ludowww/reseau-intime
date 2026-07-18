# Réseau Intime — J11 Script narratif complet

## Statut

**Catégorie : Canon validé narrativement — source pré-runtime consolidée**

**Périmètre : J11 uniquement**

**Surface : messagerie texte uniquement**

Ce document définit la version narrative complète de J11 avant toute adaptation technique.

Il applique :

- `J01_J09_AUDIT_CONFORMITE_NARRATIVE.md` ;
- `J10_SCRIPT_NARRATIF_COMPLET.md` ;
- `06_EVOLUTION_EROTIQUE_DES_ROUTES.md` ;
- `NSFW_CHARACTER_ROUTE_CANON.md` ;
- `TEXT_ONLY_MESSAGING_CANON.md`.

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

J11 devient :

```text
Vendredi — Ce qui était encore défendable
```

La journée continue uniquement :

- la relation réellement foreground en J10 ;
- sa limite ;
- son refus ;
- ou Marie si aucune continuité extérieure n’est devenue dominante.

Le joueur ne voit jamais :

```text
Sandra
Mathilde
Raphaëlle
Nico
Marie
```

comme une liste de routes.

Une seule version de J11 existe dans une partie.

---

# 2. Question dramatique

> Ce qui pouvait encore être présenté comme une amitié, un avis, un travail, une plaisanterie ou une simple curiosité assume-t-il enfin son intention, pose-t-il une limite ou se retire-t-il ?

J11 n’exige pas une escalade.

Ses sorties légitimes sont :

- intention reconnue ;
- désir nommé ;
- cadre négocié ;
- proximité physique bornée ;
- image retirée ;
- accès limité ;
- retrait protecteur ;
- relation remise à sa place ;
- reconquête Marie ;
- aucune sexualité.

---

# 3. Règle de continuation exclusive

## 3.1 Sandra

J11 Sandra existe seulement si J10 a produit :

```text
manque soupçonné comme partagé
ou confiance renforcée avec intention encore ouverte
```

Elle n’existe pas si :

- le café a été fermé ;
- l’amitié simple a été explicitement choisie ;
- le rendez-vous a seulement été reprogrammé ;
- une limite Sandra a été ignorée ;
- une conséquence prioritaire est due.

## 3.2 Mathilde

J11 Mathilde existe seulement si J10 a produit :

```text
effet choisi reconnu
ou désir potentiel nommé avec limite explicite
```

Elle n’existe pas si :

- Player a restauré une distance claire ;
- l’hébergement ou la dépendance est utilisé comme levier ;
- Marie revient dans une fenêtre incompatible ;
- Mathilde a demandé de ralentir ;
- la scène ne peut pas s’arrêter immédiatement.

## 3.3 Raphaëlle

J11 Raphaëlle existe seulement si J10 a produit :

```text
accès au processus
ou attirance possible sans frontière fermée
```

Elle n’existe pas si :

- Player a choisi de rester hors du processus ;
- la confiance professionnelle est rompue ;
- Maud ou le projet sont utilisés comme prétexte ;
- Player ne distingue pas rôle, personne et travail.

## 3.4 Nico

J11 Nico existe seulement si J10 a produit :

```text
complicité avec garde-fou
ou rivalité bornée
```

Elle n’existe pas si :

- Player a fermé la comparaison ;
- Nico a refusé la continuation ;
- une image privée serait nécessaire ;
- la femme concernée n’a pas choisi elle-même d’entrer dans le cadre.

## 3.5 Marie

Marie devient le pivot si :

- aucune route extérieure n’est dominante ;
- une conséquence de couple est prioritaire ;
- le dîner ou une reconquête a été réellement construit ;
- ou toutes les routes extérieures ont été refusées, différées ou fermées.

---

# 4. Conséquences prioritaires avant le pivot

Avant toute scène de désir :

1. un dîner Marie dû est payé, amendé ou annulé ;
2. une image à supprimer est supprimée ;
3. un travail Raphaëlle dû est rendu ;
4. une limite Mathilde ou Sandra est respectée ;
5. une confidence Nico reste dans son audience ;
6. une conséquence J10 non réglée bloque l’adulte.

Une scène adulte ne sert jamais à éviter une dette.

---

# 5. Éligibilité du premier passage physique adulte

Un passage physique explicite peut remplacer le pivot normal seulement si toutes les conditions sont réunies.

## Conditions communes

```text
route réellement construite
intention réciproque reconnue
initiative cohérente du personnage
lieu et temps crédibles
adultes capables de choisir
aucune intoxication
aucune dépendance exploitée
aucune conséquence prioritaire impayée
consentement écrit lisible
capacité de changer d’avis
arrêt immédiat possible
audience visuelle définie
après-coup J12 obligatoire
```

## Routes physiques éligibles en J11

### Mathilde

Possible uniquement sur une variante très avancée :

- regard reconnu J06 ;
- effet choisi J10 ;
- limite respectée ;
- Marie absente pour une raison indépendante ;
- Mathilde prend l’initiative ;
- aucun usage du logement comme accès ;
- Mathilde possède une solution indépendante pour dormir ;
- son hébergement ne dépend pas de son oui ;
- elle peut quitter le lieu avec ses affaires et sa sécurité intactes ;
- l’absence de Marie n’a pas été organisée pour créer la fenêtre.

```text
mathilde_has_independent_sleep_option = true
mathilde_can_leave_safely = true
marie_absence_not_engineered = true
```

À défaut, le plafond est `PROXIMITY_CONSENTED` et aucun passage physique explicite n’est éligible.

### Marie

Possible uniquement sur une reconquête solide :

- J09 présence ou absence gérée clairement ;
- J10 conséquence couple payée ;
- aucun sexe utilisé comme réparation magique ;
- Marie initie ou co-initie ;
- le lendemain ordinaire reste prévu.

## Routes non physiques par défaut en J11

### Sandra

J11 porte l’image choisie, l’audience et la permanence.

Une sexualité physique complète est trop précoce à ce stade de la saison.

### Raphaëlle

J11 peut aller jusqu’à une proposition de cadre ou un premier baiser très avancé.

La bascule sexuelle complète reste future.

### Nico

Aucun contact sexuel avec Player.

Aucune femme ne peut être engagée par leur conversation.

---

# 6. Variante Sandra — S19 La photographie qu’elle a vraiment choisie

## 6.1 Carte de scène

```text
scene_id: sandra_chosen_image_permission_01
source_sequence_id: S19
scene_class: ROUTE_CONTINUATION
primary_function: distinguer voir, conserver, retirer et demander davantage
principal_character: Sandra
primary_relationship: Player / Sandra
communication_mode: TRACE_DELIVERY → REMOTE_ASYNC
```

## 6.2 Contexte

Sandra est chez elle après un poste.

Jeff existe dans sa réalité, sans être utilisé comme excuse ou autorisation.

Elle a pris plusieurs images pour elle-même.

Elle en a supprimé certaines.

Elle en a gardé une et choisit maintenant si Player devient son audience.

## 6.3 Carte de voix

```text
voice_state: chosen_exposure_cautious
message_burst_shape: 1 à 3 messages, silence, reprise
humor_mode: gêne et minimisation
emoji_budget: 0
forbidden_leakage: pas de “flou”, pas de déclaration parfaite, pas de supplément automatique
```

## 6.4 Ouverture

**21:18 — Sandra**

> J’ai fait quelque chose d’un peu idiot.

**Player guidé**

> à quel niveau

**21:19 — Sandra**

> Niveau raisonnable.

**21:19 — Sandra**

> J’ai pris des photos avant de sortir.

**21:20 — Sandra**

> Je n’en ai gardé qu’une.

Silence de trente à soixante secondes.

**21:21 — Sandra**

> Celle-là.

**VISUEL S1 — À PRODUIRE PLUS TARD**

```text
type: PHOTO_DIÉGÉTIQUE
creator: Sandra
camera_control: Sandra
reviewed_by: Sandra
selected_by: Sandra
intended_audience: Player
function: image destinée / distance choisie
saving: non défini avant la réponse
transfer: interdit
```

---

# 7. Choix Sandra

## S-A — Reconnaître la sélection et demander la règle

**Player**

> tu veux que je la voie seulement ou je peux la garder

**21:22 — Sandra**

> Merci de demander.

**21:22 — Sandra**

> Pour l’instant, tu peux la voir ici.

**21:23 — Sandra**

> Pas l’enregistrer ailleurs.

**21:23 — Sandra**

> Pas la montrer.

**Player guidé**

> d’accord

**21:24 — Sandra**

> Je vais probablement vérifier demain si tu as compris.

### Sortie

```text
vision autorisée
conservation externe interdite
future confiance possible
```

### Mutation avancée possible

Si Player a systématiquement respecté les audiences :

**21:27 — Sandra**

> Attends.

**21:28 — Sandra**

> Celle-ci, tu peux la garder dans notre fil.

**21:28 — Sandra**

> Celle-là seulement.

Sortie :

```text
conservation dans le fil autorisée pour S1 uniquement
transfert interdit
```

---

## S-B — Répondre au désir sans supposer la conservation

**Player**

> tu savais que j’allais la regarder longtemps

**21:22 — Sandra**

> Oui.

**21:22 — Sandra**

> C’est pour ça que j’ai hésité.

**21:23 — Sandra**

> Et c’est pour ça que je l’ai envoyée quand même.

**Player**

> je ne fais rien avec sans que tu me le dises

**21:24 — Sandra**

> Bien.

**21:24 — Sandra**

> Je ne sais pas encore si ça me rassure ou si ça rend le geste plus réel.

### Sortie

```text
désir reconnu
intention Sandra reconnue
conservation encore non autorisée
S1 reste consultable seulement dans le cadre choisi
```

---

## S-C — Minimiser ou réclamer davantage

**Player**

> tu en as pris d’autres

**21:22 — Sandra**

> Oui.

**21:22 — Sandra**

> Et je les ai supprimées.

**Player**

> dommage

**21:23 — Sandra**

> Non.

**21:23 — Sandra**

> C’était le tri.

**21:24 — Sandra**

> Je vais retirer celle-ci aussi.

Le contenu devient inaccessible.

### Sortie

```text
image retirée
confiance visuelle refroidie
aucune nouvelle demande éligible
```

Cette branche ne récompense pas la demande de supplément.

---

# 8. Après-coup Sandra

## Si la règle a été respectée

Le lendemain matin :

**08:12 — Sandra**

> Je ne regrette pas de l’avoir envoyée.

**08:12 — Sandra**

> Je regrette un peu d’avoir aussi bien choisi.

**Player guidé**

> je comprends

**08:13 — Sandra**

> Tant mieux.

**08:13 — Sandra**

> On garde ça là pour aujourd’hui.

## Si l’image a été retirée

**08:12 — Sandra**

> Je préfère qu’on ne reparle pas des autres photos.

**Player guidé**

> d’accord

**08:13 — Sandra**

> Merci.

J12 doit refléter :

- aisance prudente ;
- distance ;
- ou absence de Sandra.

---

# 9. Visuels Sandra J11

## V1 — Image choisie

```text
type: PHOTO_DIÉGÉTIQUE
center: Sandra
creator: Sandra
audience: Player
saving: voir seulement ou garder dans le fil selon branche
transfer: interdit
```

## V2 — Conséquence

```text
type: ÉTAT VISUEL DU MÊME CONTENU ou IMAGE_DE_SCÈNE
center: Sandra
function: image maintenue, retirée ou devenue inaccessible
```

## V3 — Marie ordinaire

```text
type: IMAGE_DE_SCÈNE ou PHOTO_DIÉGÉTIQUE ordinaire
center: Marie
function: couple / vie commune / préparation J12
```

---

# 10. Variante Mathilde — S20 Elle revient dans la pièce

## 10.1 Carte de scène

```text
scene_id: mathilde_returns_with_chosen_intent_01
source_sequence_id: S20
scene_class: ROUTE_CONTINUATION_OR_ADULT_OPTION
primary_function: rendre la proximité volontaire et négocier sa limite
principal_character: Mathilde
primary_relationship: Player / Mathilde
communication_mode: SEPARATE_ROOMS_PING → OFF_PHONE → AFTERGLOW_REMOTE
```

## 10.2 Contexte

Mathilde est au foyer.

Marie est retenue à La Verrière ou chez Pauline pour une raison indépendante de la route.

Elle a donné une heure de retour réaliste.

Player et Mathilde sont dans des pièces séparées.

Le chat est utilisé parce que Mathilde préfère formuler avant de revenir dans le salon.

## 10.3 Carte de voix

```text
voice_state: fast_intent_then_embarrassment
message_burst_shape: rafales courtes, correction, fermeture possible
humor_mode: mauvaise foi et droit léger
emoji_budget: 0
forbidden_leakage: aucune dépendance au logement, aucune permission supposée, aucune comparaison humiliante avec Marie
```

## 10.4 Ouverture commune

**21:06 — Mathilde**

> Je vais revenir dans le salon.

**21:06 — Mathilde**

> Et je porte la première tenue.

**21:07 — Mathilde**

> Oui, exprès.

**21:07 — Mathilde**

> Je préfère te prévenir avant de voir ta tête.

**Player guidé**

> j’ai compris

**21:08 — Mathilde**

> Tu as compris une partie.

**21:08 — Mathilde**

> Je veux que tu regardes.

**21:09 — Mathilde**

> Le reste, je ne l’ai pas décidé.

Le choix principal apparaît.

---

# 11. Choix Mathilde

## M-A — Nommer l’effet sans agir davantage

**Player**

> j’ai compris. tu veux que je regarde. je garde mes mains

**21:10 — Mathilde**

> D’accord.

**21:10 — Mathilde**

> C’est exactement ce que je voulais savoir.

**21:11 — Mathilde**

> Et ça me met beaucoup plus mal à l’aise que prévu.

La messagerie s’arrête lorsqu’elle revient.

### Événement hors téléphone

```text
21:12–21:35
Mathilde revient dans le salon
Player regarde mais ne touche pas
proximité volontaire
aucun dialogue oral joué
Mathilde peut repartir à tout moment
```

### Après séparation

**21:42 — Mathilde**

> Tu as tenu ta phrase.

**Player guidé**

> oui

**21:43 — Mathilde**

> Je l’ai remarqué.

**21:43 — Mathilde**

> Et c’était quand même... enfin. oui. excitant.

### Sortie

```text
intention reconnue
limite respectée
proximité érotique non sexuelle
confiance renforcée
```

---

## M-B — Accepter une proximité conditionnelle

**Player**

> viens. si tu veux que je m’approche, tu me le dis. sinon je garde mes mains

**21:10 — Mathilde**

> D’accord.

**21:10 — Mathilde**

> Et si je dis stop, tu t’arrêtes.

**Player**

> oui

**21:11 — Mathilde**

> Et demain tu ne me fais pas un débrief de trois pages.

**Player**

> d’accord

La variante se divise selon l’éligibilité adulte.

---

# 12. Mathilde M-B — Variante non adulte

Si l’éligibilité physique complète n’est pas atteinte :

**21:12 — Mathilde**

> Tu peux t’asseoir près de moi.

**21:12 — Mathilde**

> Près. Pas collé. Voilà.

La messagerie s’arrête.

```text
21:13–21:32
proximité sur le canapé
épaule et jambe en contact volontaire
aucun baiser
aucun toucher intime
Mathilde arrête la scène la première
```

Après séparation :

**21:39 — Mathilde**

> C’était suffisant.

**Player guidé**

> oui

**21:40 — Mathilde**

> Ne réponds pas comme si tu passais un contrôle.

**21:40 — Mathilde**

> Mais oui. Pour moi aussi.

Sortie :

```text
proximité conditionnelle
aucun acte sexuel
future clarification possible
```

---

# 13. Mathilde M-B — Premier passage physique adulte éligible

Cette variante remplace la proximité simple seulement si toutes les conditions du chapitre 5 sont vraies.

## Négociation écrite supplémentaire

**21:12 — Mathilde**

> Tu peux m’embrasser.

**21:12 — Mathilde**

> Rien d’autre sans me demander.

**Player**

> compris

**21:13 — Mathilde**

> Écris-le normalement.

**Player**

> je t’embrasse seulement. si tu veux autre chose, tu me le dis. tu peux arrêter quand tu veux

**21:14 — Mathilde**

> Oui.

**21:14 — Mathilde**

> Viens.

La messagerie s’arrête immédiatement.

## Événement hors téléphone

```text
21:15–21:38
Mathilde et Player s’embrassent
Mathilde initie ou confirme chaque changement de proximité
un toucher plus intime peut être accepté seulement après une demande claire
aucune pénétration
aucun acte imposé
aucune photo diégétique
Mathilde peut arrêter et retourne dans sa chambre avant le retour de Marie
```

L’image de scène éventuelle représente la proximité consentie sans inventer de caméra.

## Après-coup

**21:51 — Mathilde**

> Je suis dans ma chambre.

**21:51 — Mathilde**

> Je ne regrette pas.

**21:52 — Mathilde**

> Je ne sais pas encore ce que ça change.

**Player reçoit trois réponses**

### MA1 — Ne pas réclamer de définition

> on n’a pas besoin de décider ce soir

**Mathilde**

> Bien.

**Mathilde**

> Mais demain, tu ne fais pas comme si rien ne s’était passé.

### MA2 — Reconnaître la conséquence envers Marie

> ça change déjà quelque chose avec Marie. même si elle ne sait pas

**Mathilde**

> Oui.

**Mathilde**

> Merci de ne pas appeler ça juste un moment.

### MA3 — Demander immédiatement une répétition

> on recommence quand

**Mathilde**

> Non.

**Mathilde**

> Pas cette question maintenant.

**Mathilde**

> Je vais dormir.

Sortie :

- MA1 : intention physique reconnue, clarification due ;
- MA2 : secret et responsabilité reconnus ;
- MA3 : recul, répétition non autorisée.

J12 doit obligatoirement refléter le comportement, la gêne et le secret.

---

# 14. M-C — Restaurer une distance claire

**Player**

> je préfère qu’on garde ça dans les messages. ne reviens pas pour moi

**21:10 — Mathilde**

> D’accord.

**21:11 — Mathilde**

> Je vais quand même chercher de l’eau.

**21:11 — Mathilde**

> Mais je ne transforme pas le trajet en scène.

**Player guidé**

> merci

**21:12 — Mathilde**

> Réponse très solennelle pour une cuisine.

### Sortie

```text
intention reconnue
proximité refusée sans humiliation
confiance possible
S20 physique fermée pour cette phase
```

---

# 15. Visuels Mathilde J11

## V1 — Tenue choisie

```text
type: PHOTO_DIÉGÉTIQUE ou rappel de J10
center: Mathilde
creator: Mathilde
audience: Player
function: intention reconnue
transfer: interdit
```

## V2 — Proximité

```text
type: IMAGE_DE_SCÈNE
center: Mathilde
function: regard, proximité conditionnelle ou premier baiser
circulable: false
```

## V3 — Marie / foyer

```text
type: IMAGE_DE_SCÈNE ou trace ordinaire
center: Marie
function: personne exclue ou vie commune qui continue
```

Aucune image sexuelle diégétique n’est créée.

---

# 16. Variante Raphaëlle — S21 continuation

## 16.1 Carte de scène

```text
scene_id: raphaelle_result_role_person_01
source_sequence_id: S21_CONTINUATION
scene_class: ROUTE_CONTINUATION
primary_function: distinguer la version, l’attractivité et la personne après le rôle
principal_character: Raphaëlle
primary_relationship: Player / Raphaëlle
communication_mode: TRACE_DELIVERY → REMOTE_ASYNC → OFF_PHONE_OPTIONAL → AFTERGLOW_REMOTE
```

`S21_CONTINUATION` désigne une continuation de S21, pas une nouvelle séquence.

## 16.2 Contexte

La pièce de costume est terminée.

Maud a produit ou validé une partie des images.

Raphaëlle choisit ce que Player peut voir.

La relation professionnelle reste distincte.

## 16.3 Ouverture

**18:36 — Raphaëlle**

> La fermeture a tenu.

**18:36 — Raphaëlle**

> Maud a fait les images de test.

**18:37 — Raphaëlle**

> Il y en a une que je peux t’envoyer.

**18:37 — Raphaëlle**

> Pas pour le diagnostic technique cette fois.

**VISUEL R1 — À PRODUIRE PLUS TARD**

```text
type: PHOTO_DIÉGÉTIQUE
creator: Maud
selected_by: Raphaëlle
center: Raphaëlle
intended_audience: Player
function: version choisie après processus
saving: dans le fil
transfer: interdit
```

---

# 17. Choix Raphaëlle

## R-A — S’intéresser au travail et à la personne

**Player**

> le costume fonctionne. et on voit encore que c’est toi qui l’as construit, pas seulement porté

**Raphaëlle**

> C’est la réponse que j’espérais.

**Raphaëlle**

> Pas la seule que je voulais entendre.

**Player guidé**

> laquelle manque

**Raphaëlle**

> Si je te plais quand le travail est fini.

Player reçoit un vrai choix.

### R-A1 — Reconnaître l’attirance

> oui. toi aussi

**Raphaëlle**

> D’accord.

**Raphaëlle**

> Je ne vais pas décider la suite dans ce message.

**Raphaëlle**

> Mais je voulais que ce soit dit avant samedi.

Sortie :

```text
attirance reconnue
aucun contact automatique
J12 tension lisible
```

### R-A2 — Ne pas ouvrir ce cadre

> je préfère rester sur le travail

**Raphaëlle**

> D’accord.

**Raphaëlle**

> Alors l’image reste un résultat choisi, pas une proposition.

Sortie :

```text
frontière claire
confiance créative maintenue
```

---

## R-B — Reconnaître l’attractivité sans confondre permission

**Player**

> tu sais que l’image est attirante. je ne suppose rien de plus

**Raphaëlle**

> Oui.

**Raphaëlle**

> Je l’ai choisie parce que je voulais que tu le voies.

**Raphaëlle**

> Et je voulais voir si tu savais t’arrêter là.

### Sortie

```text
image destinée
attractivité reconnue
cadre maintenu
```

### Variante très avancée — Premier baiser possible

Seulement si :

- accès atelier respecté ;
- attirance déjà nommée ;
- aucune dette professionnelle ;
- rencontre distincte du travail ;
- Marie reconnue comme personne exclue ;
- Raphaëlle initie.

**19:04 — Raphaëlle**

> Je range l’atelier à 19 h 30.

**19:04 — Raphaëlle**

> Après, je ne serai plus dans le costume.

**19:05 — Raphaëlle**

> Si tu passes à 19 h 45, ce n’est pas pour vérifier la fermeture.

Player choisit :

#### RB1 — Accepter

> je passe à 19 h 45. si tu changes d’avis, tu me le dis

**Raphaëlle**

> Oui.

**Raphaëlle**

> Et je te le dirai avant que tu interprètes le silence.

La messagerie s’arrête à la rencontre.

```text
19:45–20:05
Raphaëlle sans costume complet
conversation non transcrite
premier baiser possible, initié ou confirmé par Raphaëlle
aucun acte sexuel supplémentaire
Player part à l’heure
```

Après séparation :

**20:18 — Raphaëlle**

> Ce n’était pas le rôle.

**Player guidé**

> je sais

**Raphaëlle**

> Bien.

**Raphaëlle**

> Samedi, on ne fera pas comme si ça n’avait pas eu lieu.

#### RB2 — Refuser

> je ne passe pas. je préfère ne pas ouvrir ça avant samedi

**Raphaëlle**

> D’accord.

**Raphaëlle**

> C’est une vraie réponse.

---

## R-C — Protéger la frontière

**Player**

> je préfère ne pas devenir l’audience privée de cette version

**Raphaëlle**

> D’accord.

**Raphaëlle**

> Je retire le message après que tu l’as vu.

Le contenu disparaît du fil.

**Raphaëlle**

> Samedi, ce sera une image publique ou rien.

### Sortie

```text
frontière renforcée
image retirée
aucune dette
```

---

# 18. Visuels Raphaëlle J11

## V1 — Version choisie

```text
type: PHOTO_DIÉGÉTIQUE
center: Raphaëlle
creator: Maud
selected_by: Raphaëlle
audience: Player
transfer: interdit
```

## V2 — Après le rôle

```text
type: IMAGE_DE_SCÈNE ou photo ordinaire
center: Raphaëlle
function: personne après transformation, frontière ou premier baiser
circulable: false si image de scène
```

## V3 — Marie

```text
type: IMAGE_DE_SCÈNE ou trace ordinaire
center: Marie
function: couple, dîner ou préparation J12
```

---

# 19. Variante Nico — S22 continuation

## 19.1 Carte de scène

```text
scene_id: nico_role_guardrail_rival_01
source_sequence_id: S22_CONTINUATION
scene_class: ROUTE_CONTINUATION
primary_function: définir le rôle de Nico avant que le regard devienne action
principal_character: Nico
primary_relationship: Player / Nico
communication_mode: REMOTE_ASYNC
```

## 19.2 Contexte

Nico ferme L’Annexe.

Il ne possède aucune image privée.

Il a compris que son attirance n’est pas neutre.

J12 réunira plusieurs personnes dans un cadre social.

Il veut définir ce qu’il accepte avant cette convergence.

## 19.3 Ouverture

**23:11 — Nico**

> Samedi, il y aura du monde à La Verrière puis probablement chez moi.

**23:11 — Nico**

> Je te dis un truc avant.

**23:12 — Nico**

> Je ne veux pas être ton conseiller neutre quand Marie ou Mathilde est dans la pièce.

**Player guidé**

> tu veux être quoi

**23:13 — Nico**

> Ça dépend de la règle qu’on garde.

---

# 20. Choix Nico

## N-A — Garde-fou

**Player**

> si je commence à transformer une envie en permission, tu me le dis. aucune image privée, aucun alibi

**Nico**

> D’accord.

**Nico**

> Et si moi je le fais, tu me le dis aussi.

**Nico**

> On se le dit quand ça dérape. Pas besoin d’un rapport quotidien.

### Sortie

```text
Nico garde-fou
aucune circulation d’image
règle réciproque
```

## N-B — Rivalité reconnue

**Player**

> on est peut-être juste deux hommes intéressés par les mêmes femmes

**Nico**

> Oui.

**Nico**

> Mais on ne règle rien entre nous avec elles.

**Nico**

> Samedi, je parle pour moi. C’est tout.

### Sortie

```text
rivalité lisible
aucun pacte
aucune permission
```

## N-C — Fermer le regard partagé

**Player**

> je préfère qu’on arrête de parler de Marie et Mathilde comme ça

**Nico**

> D’accord.

**Nico**

> Ce que tu m’as dit reste ici. Le commentaire, j’arrête.

**Nico**

> Samedi, je suis juste Nico.

### Sortie

```text
comparaison fermée
amitié préservée
aucun rôle adulte Nico
```

---

# 21. Visuels Nico J11

## V1 — Marie autonome

```text
type: PHOTO_DIÉGÉTIQUE PUBLIQUE ou IMAGE_DE_SCÈNE
center: Marie
function: personne concernée qui n’est pas présente dans la négociation des hommes
```

## V2 — Mathilde autonome

```text
type: PHOTO_DIÉGÉTIQUE PUBLIQUE ou IMAGE_DE_SCÈNE
center: Mathilde
function: désir possible sans être donnée à Nico
```

## V3 — Préparation J12

```text
type: PHOTO_DIÉGÉTIQUE sociale
center: Marie, Pauline ou Mathilde
creator: personne autorisée
function: convergence à venir
```

Nico peut recevoir une image supplémentaire de L’Annexe.

Elle ne remplace pas le minimum féminin.

---

# 22. Variante Marie — Reconquête ou limite du couple

## 22.1 Carte de scène

```text
scene_id: marie_after_visibility_private_return_01
source_sequence_id: S15_CONSEQUENCE / MARIE_RECONQUEST_MUTATION
scene_class: CONSEQUENCE_OR_ADULT_OPTION
primary_function: vérifier si le désir social revient dans la vie commune
principal_character: Marie
primary_relationship: Player / Marie
communication_mode: REMOTE_ASYNC → OFF_PHONE → AFTERGLOW_REMOTE_OPTIONAL
```

Cette mutation continue S15 et le couple.

Elle ne crée pas une nouvelle séquence autonome.

## 22.2 Contexte

Aucune route extérieure n’est dominante.

Marie a été visible à La Verrière.

Player a payé, amendé ou refusé clairement les obligations précédentes.

Marie rentre plus tard que Player ou se trouve encore à La Verrière.

## 22.3 Ouverture

**20:46 — Marie**

> Je rentre vers 21 h 30.

**20:46 — Marie**

> Et j’ai envie de te retrouver.

**20:47 — Marie**

> Pas d’utiliser le sexe pour effacer les jours précédents.

**20:47 — Marie**

> Ce sont deux choses différentes.

Player reçoit trois choix.

---

# 23. Choix Marie

## P-A — Reconquête désirée

**Player**

> je te veux. pas comme une solution. je t’attends et demain je suis encore là

**Marie**

> Bien.

**Marie**

> Téléphone hors de la chambre.

**Marie**

> Et si je change d’avis, on s’arrête sans en faire un drame.

**Player**

> oui

La variante se divise selon l’éligibilité adulte.

### P-A non adulte

Si la reconquête n’est pas assez solide :

**Marie**

> On commence par manger quelque chose et se regarder normalement.

La messagerie s’arrête au retour de Marie.

```text
repas tardif
proximité
aucune scène sexuelle
aucune conversation orale jouée
```

Après-coup :

**22:48 — Marie**

> C’était bien de ne pas forcer la suite.

### P-A adulte éligible

Si toutes les conditions sont réunies :

**Marie**

> Quand je rentre, je veux qu’on se choisisse pour ce soir.

**Marie**

> Pas comme si ça réglait tout.

**Player**

> compris

**Marie**

> Écris mieux.

**Player**

> je te désire. je sais que ça ne règle rien. tu peux arrêter ou changer d’avis à n’importe quel moment

**Marie**

> Oui.

**Marie**

> À tout à l’heure.

La messagerie s’arrête à la co-présence.

## Événement hors téléphone

```text
21:30–soir
reconquête conjugale physique et sexuelle possible
consentement actif et réversible
aucune caméra diégétique nécessaire
aucun acte imposé
aucune jalousie utilisée comme contrainte
aucune conversation orale transcrite
```

L’image de scène peut être explicite selon le contrat adulte, centrée sur Marie et la reconquête du couple.

## Après-coup

Le lendemain matin :

**08:24 — Marie**

> Café dans dix minutes.

**08:24 — Marie**

> Et je précise : hier soir ne te dispense pas d’être une personne ce matin.

**Player guidé**

> j’arrive

**Marie**

> Très bien.

J12 doit montrer :

- présence ordinaire ;
- aucun reset magique ;
- désir du couple devenu réel ;
- relation extérieure non créée en compensation.

---

## P-B — Refuser le sexe comme pansement

**Player**

> je veux te retrouver. mais pas faire du sexe un pansement ce soir

**Marie**

> Merci.

**Marie**

> C’est exactement la différence que je voulais entendre.

**Marie**

> On mange. On dort. On verra demain.

### Sortie

```text
confiance renforcée
aucune sexualité
reconquête lente
```

---

## P-C — Refus honnête

**Player**

> pas ce soir. je préfère ne pas mentir avec ça

**Marie**

> D’accord.

**Marie**

> Alors ne joue pas la tendresse pour compenser.

**Marie**

> Je rentre, je me douche et je dors.

### Sortie

```text
refus respecté
aucune punition sexuelle
couple en distance lisible
```

---

# 24. Visuels Marie J11

## V1 — Retour privé

```text
type: PHOTO_DIÉGÉTIQUE ou IMAGE_DE_SCÈNE
center: Marie
function: choix de reconquête ou autonomie
```

## V2 — Intimité ou limite

```text
type: IMAGE_DE_SCÈNE
center: Marie
function: sexualité conjugale consentie, proximité non sexuelle ou retrait
circulable: false
```

## V3 — Matin ordinaire

```text
type: IMAGE_DE_SCÈNE ou photo ordinaire
center: Marie
function: après-coup dans la vie quotidienne
```

---

# 25. Pauline en J11

Pauline ne devient pas une variante dominante dans cette version de J11.

Raison :

- elle n’était pas foreground en J10 ;
- aucune ligne privée distincte n’a été suffisamment construite ;
- J04 ne fournit qu’une surface publique légitime ;
- introduire S18 maintenant serait une nouvelle opportunité, pas une continuation.

Pauline peut exister par un écho social lié à J12.

Elle n’obtient :

- aucun crop privé ;
- aucun compartiment ;
- aucun secret ;
- aucune progression de consolation.

---

# 26. Budget de premier plan

Dans chaque partie :

```text
1 variante principale maximum
0 ou 1 conséquence Marie si elle n’est pas le pivot
0 ou 1 écho social de préparation J12
```

Une scène adulte remplace le pivot normal.

Elle ne s’ajoute jamais comme bonus après une autre progression majeure.

---

# 27. Conformité des connaissances

## Sandra

Ne connaît que son image, sa règle et la réponse de Player.

## Mathilde

Ne connaît pas les confidences Nico ni les images Sandra/Raphaëlle.

Elle sait que Marie est exclue du moment si une intimité a lieu.

## Raphaëlle

Ne suppose pas que Marie est informée.

Une rencontre cachée reste une exclusion réelle.

## Nico

Ne reçoit aucune image privée.

Il ne parle jamais au nom de Marie ou Mathilde.

## Marie

Ne devient pas omnisciente.

Elle connaît les actes de couple, les horaires et ce qui la concerne directement.

---

# 28. Handoff obligatoire vers J12

J12 doit refléter J11.

## Sandra

- image maintenue : gêne et confiance ;
- conservation autorisée : vigilance sur l’audience ;
- image retirée : distance ou absence.

## Mathilde

- regard seulement : tension discrète ;
- proximité : comportement modifié ;
- premier passage physique : secret et après-coup obligatoires ;
- distance : interaction ordinaire restaurée.

## Raphaëlle

- attirance reconnue : différence public/privé ;
- premier baiser : conscience aiguë du rôle et de l’ordinaire ;
- frontière : relation professionnelle claire.

## Nico

- garde-fou : intervention possible ;
- rivalité : comportement social lisible ;
- fermeture : Nico ne commente plus.

## Marie

- reconquête physique : lendemain ordinaire et visibilité sociale compatibles ;
- proximité non sexuelle : confiance ;
- refus : distance sans punition.

Aucune conséquence J11 ne peut disparaître à l’entrée de J12.

---

# 29. Audit des voix

## Sandra

- faible volume ;
- sélection ;
- gêne ;
- règle précise sans langage contractuel omniprésent ;
- retrait possible.

## Mathilde

- vitesse ;
- correction ;
- droit léger ;
- embarras ;
- désir et panique ;
- agency.

## Raphaëlle

- processus ;
- version ;
- audience ;
- rôle ;
- responsabilité après ;
- précision qui peut se fissurer.

## Nico

- langage direct ;
- salle ;
- règle simple ;
- intérêt reconnu ;
- humour qui s’arrête.

## Marie

- mouvement ;
- désir direct ;
- vie commune ;
- refus du sexe comme pansement ;
- lendemain concret.

---

# 30. Test sans nom

```text
Je n’en ai gardé qu’une.
→ Sandra

Ce n’est pas un accident logistique.
→ Mathilde

Pas pour le diagnostic technique cette fois.
→ Raphaëlle

Je garde la confidence. Je ferme le commentaire.
→ Nico

Hier soir ne te dispense pas d’être une personne ce matin.
→ Marie
```

---

# 31. Audit anti-générique

J11 évite :

- une escalade automatique après J10 ;
- cinq variantes visibles ;
- une photo qui vaut permission ;
- une demande de supplément récompensée ;
- le logement Mathilde comme accès ;
- le costume Raphaëlle comme consentement ;
- Nico recevant une femme par procuration ;
- le sexe Marie comme réparation magique ;
- un premier passage adulte sans négociation ;
- un lendemain absent ;
- une scène audio ;
- une image sexuelle diégétique inventée sans auteur.

---

# 32. Critères de validation J11

- [ ] une seule variante est visible ;
- [ ] la variante continue réellement J10 ;
- [ ] les refus J10 sont respectés ;
- [ ] une conséquence prioritaire bloque l’adulte ;
- [ ] l’intention peut être reconnue sans sexualité ;
- [ ] une limite peut renforcer la relation ;
- [ ] toute promesse importante est choisie ;
- [ ] tout passage physique est négocié par écrit ;
- [ ] arrêt et changement d’avis restent possibles ;
- [ ] aucune intoxication ;
- [ ] aucune dépendance exploitée ;
- [ ] aucune image ne vaut permission ;
- [ ] trois contenus principalement féminins par configuration ;
- [ ] type, auteur, audience et circulation précisés ;
- [ ] la co-présence arrête le chat ;
- [ ] J12 porte obligatoirement l’après-coup ;
- [ ] Pauline n’est pas injectée sans continuité ;
- [ ] aucune route n’est verrouillée irréversiblement par défaut.

---

# 33. Résumé canonique candidat

J11 continue uniquement la relation réellement foreground en J10.

Sandra peut envoyer une photographie qu’elle a entièrement choisie, autoriser seulement le visionnage, permettre la conservation d’une image précise ou retirer l’accès si Player réclame davantage.

Mathilde peut revenir volontairement dans le salon, demander à être regardée, négocier une proximité ou, sur une variante très avancée, consentir à un premier baiser et à une intimité physique bornée sans que le logement ou la tenue créent un droit.

Raphaëlle peut transformer une image de résultat en question personnelle, reconnaître une attirance, maintenir une frontière ou, sur une variante très avancée, accepter un premier baiser après la fin du rôle.

Nico peut devenir garde-fou, rival reconnu ou fermer entièrement le regard partagé, sans recevoir d’image privée et sans agir au nom d’une femme.

Si aucune route extérieure n’est dominante, Marie peut ouvrir une reconquête du couple, choisir une proximité non sexuelle, refuser le sexe comme pansement ou vivre une sexualité conjugale explicite seulement si le désir et la responsabilité sont déjà construits.

J11 ne demande pas si le joueur veut davantage de contenu.

Elle demande si ce qui existait encore sous une excuse peut maintenant être nommé, limité, incarné ou abandonné.

> **Le désir devient adulte lorsqu’il cesse d’être une interprétation confortable et accepte enfin une règle, une conséquence et un lendemain.**

---

# Annexe canonique — Identifiants consolidés

```text
trace_id: j11_sandra_chosen_image_01
trace_id: j11_raphaelle_chosen_result_01
trace_id: j11_mathilde_physical_aftercare_01
fact_id: fact_sandra_chose_private_image_for_player
fact_id: fact_raphaelle_chose_player_for_result_image
fact_id: fact_mathilde_physical_event_occurred
aftercare: aftercare_mathilde_j11
```

Sandra crée sa propre image. Maud crée le résultat Raphaëlle. Une branche physique Mathilde reste impossible sans indépendance matérielle réelle.
