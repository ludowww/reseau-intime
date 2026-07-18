# Réseau Intime — J13 Script narratif complet

## Statut

**Catégorie : Canon validé narrativement — source pré-runtime consolidée**

**Périmètre : J13 uniquement**

**Surface : messagerie texte uniquement**

Ce document définit la version narrative complète de J13 avant toute adaptation technique.

Il s’appuie sur :

- `J12_SCRIPT_NARRATIF_COMPLET.md` ;
- `J11_SCRIPT_NARRATIF_COMPLET.md` ;
- `S24 — Les deux versions de Pauline` ;
- `S25 — Le masque change la posture` ;
- `S26 — Nico demande un alibi ou une image` ;
- les canons de voix, d’image, de consentement, de conséquence et de communication text-only.

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

J13 devient :

```text
Dimanche — Ce qui réclame une réponse
```

J13 ne crée aucune nouvelle route dominante.

Elle paie uniquement la conséquence la plus urgente née de J12.

Une seule relation devient foreground.

Les autres dettes :

- restent en attente ;
- ferment leur fenêtre ;
- ou reviennent plus tard selon leur urgence réelle.

---

# 2. Question dramatique

> Quelle relation réclame en premier que Player assume ce qui a été visible, différé, gardé ou caché la veille ?

La bonne réponse n’est pas toujours :

- avouer tout ;
- préserver le secret ;
- continuer la route ;
- demander davantage.

La bonne réponse peut être :

- supprimer ;
- confirmer une audience ;
- poser une règle ;
- accepter une distance ;
- reconnaître une dette ;
- dire une vérité limitée ;
- laisser une relation se refroidir.

---

# 3. Ordre de priorité invisible

Le joueur ne voit jamais cette liste.

Le pivot J13 est sélectionné selon :

```text
1. sécurité ou consentement
2. image compromise ou audience incertaine
3. après-coup adulte
4. promesse ou présence non payée
5. ligne privée devenue socialement visible
6. respiration si rien n’est dû
```

## 3.1 Sécurité ou consentement

Passe en premier si :

- une limite a été ignorée ;
- un stop a été contesté ;
- une dépendance a été exploitée ;
- une image a quitté son audience ;
- une personne demande une suppression immédiate ;
- un après-coup adulte n’a pas été traité.

Aucune nouvelle image séduisante ou opportunité n’est alors proposée.

## 3.2 Image compromise

Passe avant l’attirance si :

- une image privée reste ouverte dans un contexte incertain ;
- une conservation n’est pas claire ;
- une promesse de réponse sur l’audience a été manquée ;
- une version publique risque d’être confondue avec une version privée.

## 3.3 Après-coup adulte

Passe avant toute nouvelle progression.

Une scène physique J11 doit produire :

- règle ;
- gêne ;
- dette ;
- responsabilité ;
- ou retrait.

## 3.4 Promesse et présence

Une heure annoncée et manquée peut devenir le pivot si aucune question de sécurité ou d’image ne passe avant.

## 3.5 Ligne privée visible

Une connaissance partielle née de J12 peut devenir foreground sans constituer une découverte totale.

## 3.6 Respiration

Si rien n’est dû, J13 reste une journée forte par :

- Marie ;
- le foyer ;
- la sélection publique des images ;
- le retour à l’ordinaire.

Aucune route de compensation n’apparaît.

---

# 4. Budget de la journée

Dans chaque partie :

```text
1 conséquence principale
0 nouvelle scène adulte
0 ou 1 écho Marie si elle n’est pas le pivot
3 fonctions visuelles minimum
1 trace potentiellement recontextualisable pour J14
```

---

# 5. Ouverture commune minimale

J13 ne commence pas par un résumé de la soirée.

Le premier message appartient directement à la personne ou à la conséquence prioritaire.

Les autres fils restent silencieux jusqu’au paiement du pivot.

---

# 6. Variante Pauline — S24 Les deux versions

## 6.1 Éligibilité

Pauline devient le pivot si :

- elle a produit ou sélectionné le set J12 ;
- Player a respecté l’audience publique ;
- aucune dette de sécurité plus urgente n’existe ;
- une version non publiée du même moment possède un sens différent ;
- Bastien reste réel et visible dans la situation ;
- la double adresse vient de Pauline, pas d’une demande de Player.

Elle n’est pas éligible si :

- Player a demandé un crop privé en public ;
- une image a été transférée hors cadre ;
- Pauline a explicitement fermé la sélection ;
- la scène servirait seulement à compenser l’absence d’une autre route.

## 6.2 Carte de scène

```text
scene_id: pauline_two_versions_after_convergence_01
source_sequence_id: S24
scene_class: CONSEQUENCE_ROUTE_OPENING
primary_function: distinguer version publique et double adresse privée
principal_character: Pauline
primary_relationship: Player / Pauline
communication_mode: TRACE_DELIVERY → REMOTE_ASYNC
```

## 6.3 Contexte

Pauline est chez elle avec Bastien.

Bastien trie ou regarde les images publiques avec elle.

Pauline possède une quatrième image du même moment qu’elle n’a pas mise dans le groupe.

Cette image n’est pas nécessairement plus exposée.

Sa différence vient de :

- l’instant ;
- le regard ;
- la posture ;
- le cadrage ;
- le destinataire ;
- le commentaire privé.

## 6.4 Carte de voix

```text
voice_state: controlled_private_test
message_burst_shape: courtes rafales, fermeture nette
humor_mode: sec, audience et version
emoji_budget: 0
forbidden_leakage: pas de confession romantique, pas de Bastien effacé, pas de séduction générique
```

## 6.5 Ouverture

**11:18 — Pauline**

> J’ai terminé le tri d’hier.

**11:18 — Pauline**

> La 2 reste dans le groupe.

**11:19 — Pauline**

> Bastien préfère la 1 parce qu’il y ressemble à quelqu’un qui connaît le photographe.

**11:19 — Pauline**

> Il ne le connaît pas.

**11:20 — Pauline**

> La 4 ne partira pas dans le groupe.

**VISUEL P1 — À PRODUIRE PLUS TARD**

```text
type: PHOTO_DIÉGÉTIQUE
creator: Pauline ou personne autorisée
origin: L’Annexe J12
selected_by: Pauline
center: Pauline principalement
initial_audience: Pauline
new_intended_audience: Player
function: double adresse encore défendable
saving: non défini avant réponse
transfer: interdit sans accord explicite
```

**11:20 — Pauline**

> Je te l’envoie parce que tu as vu pourquoi je l’ai écartée.

Player reçoit trois réponses.

---

# 7. Choix Pauline

## P-A — Reconnaître la différence et demander la règle

**Player**

> je vois la différence. tu veux qu’elle reste seulement dans ce fil ?

**11:21 — Pauline**

> Oui.

**11:21 — Pauline**

> Pas de sauvegarde ailleurs.

**11:22 — Pauline**

> Pas de commentaire dans le groupe.

**11:22 — Pauline**

> Bastien était là. Ne l’efface pas parce qu’il n’est pas sur la photo.

**Player guidé**

> compris

**11:23 — Pauline**

> Bien.

### Sortie

```text
version privée consultable dans le fil
règle d’audience claire
Bastien reste réel
compartiment non encore autonome
```

---

## P-B — Entrer consciemment dans la double adresse

**Player**

> la 2 dit ce qui s’est passé. la 4 dit que tu savais que je la verrais autrement

**11:21 — Pauline**

> Oui.

**11:21 — Pauline**

> Et maintenant tu sais que je l’ai choisie pour ça.

**11:22 — Pauline**

> Ça ne va pas plus loin tout seul.

**11:22 — Pauline**

> Je te l’envoie, c’est tout.

**Player**

> je la garde dans le cadre que tu donnes

**11:23 — Pauline**

> Alors elle reste.

### Sortie

```text
double adresse reconnue
compartiment possible
preuve réciproque encore absente
aucun accès sexuel
```

---

## P-C — Refuser le compartiment

**Player**

> garde-la. je ne veux pas d’une version séparée de la soirée

Silence court.

**11:22 — Pauline**

> D’accord.

**11:22 — Pauline**

> Je retire le message.

Le contenu devient inaccessible.

**11:23 — Pauline**

> La photo du groupe reste.

**11:23 — Pauline**

> Elle n’a rien fait.

### Sortie

```text
surface restaurée
ligne privée fermée proprement
aucune compensation
Bastien et Marie restent dans la réalité officielle
```

---

# 8. Variante Pauline — mauvaise gestion

Si Player :

- sauvegarde ailleurs ;
- mentionne la 4 dans le groupe ;
- demande une version plus exposée ;
- traite Bastien comme un décor ;

Pauline écrit :

**11:28 — Pauline**

> Non.

**11:28 — Pauline**

> Ce n’était pas pour ça.

**11:29 — Pauline**

> Supprime-la de l’endroit où tu l’as mise.

Player reçoit :

- `je supprime maintenant` ;
- `je n’ai fait que la sauvegarder` ;
- `tu savais que c’était risqué`.

Seule la première réponse commence à payer la dette.

La minimisation ou le renversement de responsabilité ferme la ligne et prépare une conséquence J14/J15.

---

# 9. Visuels Pauline J13

## V1 — Version publique

```text
type: PHOTO_DIÉGÉTIQUE SOCIALE
center: Pauline et Bastien ou groupe
function: surface officielle authentique
audience: groupe autorisé
```

## V2 — Version privée

```text
type: PHOTO_DIÉGÉTIQUE
center: Pauline
creator: origine crédible de J12
selected_by: Pauline
audience: Player selon branche
function: double adresse
```

## V3 — Marie ordinaire

```text
type: IMAGE_DE_SCÈNE ou trace ordinaire
center: Marie
function: rappeler l’amitié et la réalité affectée par le compartiment
```

## Trace J14 possible

```text
notification ou aperçu de la version privée Pauline
```

Elle existe seulement si P-A ou P-B a maintenu l’image.

---

# 10. Variante Raphaëlle — S25 Le masque change la posture

## 10.1 Éligibilité

Raphaëlle devient le pivot si :

- elle était présente ou reliée professionnellement à J12 ;
- le cadre public/privé a tenu ou a été mis sous tension ;
- aucune dette d’image plus urgente n’existe ;
- une version avec masque ou posture a une origine réelle ;
- Maud reste l’autrice ou la collaboratrice lorsque c’est le cas ;
- Raphaëlle choisit elle-même l’audience.

## 10.2 Carte de scène

```text
scene_id: raphaelle_mask_posture_aftermath_01
source_sequence_id: S25
scene_class: CONSEQUENCE_ROUTE_CONTINUATION
primary_function: vérifier que Player distingue transformation, effet et permission
principal_character: Raphaëlle
primary_relationship: Player / Raphaëlle
communication_mode: TRACE_DELIVERY → REMOTE_ASYNC
```

## 10.3 Ouverture si le cadre J12 a tenu

**12:36 — Raphaëlle**

> Maud a terminé le tri des tests.

**12:36 — Raphaëlle**

> Il y en a une où le masque change toute la posture.

**12:37 — Raphaëlle**

> Je te l’envoie parce qu’hier tu n’as pas insisté.

**VISUEL R1 — À PRODUIRE PLUS TARD**

```text
type: PHOTO_DIÉGÉTIQUE
creator: Maud
selected_by: Raphaëlle
center: Raphaëlle
origin: test de costume établi
intended_audience: Player
function: version choisie / posture transformée
saving: dans le fil
transfer: interdit
role_status: actif dans l’image, terminé dans la conversation
```

**12:37 — Raphaëlle**

> Le rôle est dans l’image.

**12:38 — Raphaëlle**

> Il n’est pas dans cette conversation.

---

# 11. Choix Raphaëlle

## R-A — S’intéresser au processus

**Player**

> le masque déplace les épaules et le centre du regard. on voit la construction, pas seulement le résultat

**12:39 — Raphaëlle**

> Oui.

**12:39 — Raphaëlle**

> C’est pour ça que j’ai gardé celle-là.

**12:40 — Raphaëlle**

> La plus spectaculaire cachait le travail.

### Sortie

```text
confiance créative renforcée
version privée maintenue
aucune permission physique nouvelle
```

---

## R-B — Reconnaître l’effet sans dépasser le cadre

**Player**

> l’effet est attirant. je sais que ça ne prolonge pas le rôle ici

**12:39 — Raphaëlle**

> Bien.

**12:39 — Raphaëlle**

> Je voulais que tu voies l’effet.

**12:40 — Raphaëlle**

> Je voulais aussi vérifier si tu savais où il s’arrêtait.

### Sortie

```text
attractivité reconnue
frontière tenue
clarification future possible
```

---

## R-C — Traiter la version comme un produit fini

**Player**

> celle-là est meilleure. tu devrais en faire une série plus sexy

**12:39 — Raphaëlle**

> Ce n’est pas la question.

**12:40 — Raphaëlle**

> Et ce n’est pas ton brief.

**12:40 — Raphaëlle**

> Je retire l’image privée.

Le contenu devient inaccessible.

**12:41 — Raphaëlle**

> Le résultat public suffira.

### Sortie

```text
accès privé refroidi
processus réduit à tort au produit
aucune nouvelle invitation
```

---

# 12. Raphaëlle si le cadre J12 a été pressé

Aucune image n’est envoyée.

**12:36 — Raphaëlle**

> Hier, tu m’as demandé de trancher alors qu’on était en public.

**12:37 — Raphaëlle**

> Je ne vais pas répondre avec une photo plus privée.

Player peut :

- reconnaître la pression ;
- expliquer sans minimiser ;
- insister sur son besoin de clarté.

Une excuse claire peut maintenir la relation professionnelle.

L’insistance ferme l’accès privé.

---

# 13. Visuels Raphaëlle J13

## V1 — Trace publique J12

```text
type: PHOTO_DIÉGÉTIQUE PUBLIQUE
center: Raphaëlle ou travail présenté
function: cadre commun
```

## V2 — Masque et posture

```text
type: PHOTO_DIÉGÉTIQUE PRIVÉE
creator: Maud
selected_by: Raphaëlle
audience: Player selon branche
function: transformation choisie
```

## V3 — Raphaëlle sans rôle ou Marie ordinaire

```text
type: IMAGE_DE_SCÈNE ou trace ordinaire
function: rappeler que la personne existe après la version
```

## Trace J14 possible

```text
aperçu de l’image masquée dans une notification ou une galerie
```

Seulement si l’image est maintenue.

---

# 14. Variante Nico — S26 L’alibi devient une demande réelle

## 14.1 Éligibilité

Nico devient le pivot si :

- J12 a rendu son rôle de garde-fou ou rival concret ;
- une heure, une présence ou une version donnée à Marie est contredite par la réalité ;
- Nico possède l’information par son propre lieu ;
- il ne doit pas mentir pour couvrir une situation qu’il ne comprend pas ;
- aucune image privée n’est nécessaire.

## 14.2 Carte de scène

```text
scene_id: nico_alibi_truth_limit_01
source_sequence_id: S26
scene_class: CONSEQUENCE_ROLE_DEFINITION
primary_function: transformer la confidence en demande ou refus d’acte
principal_character: Nico
primary_relationship: Player / Nico
communication_mode: REMOTE_ASYNC
```

## 14.3 Ouverture

**13:42 — Nico**

> Marie m’a demandé à quelle heure la table s’est vidée.

**13:42 — Nico**

> J’ai répondu l’heure réelle.

### Si Player avait dépassé l’heure annoncée

**13:43 — Nico**

> Elle ne correspond pas à celle que tu avais donnée.

### Si Player était parti à l’heure

**13:43 — Nico**

> Elle correspond à ce que tu avais dit.

**13:43 — Nico**

> Je te le dis avant que ça devienne une discussion sur ce que je suis censé couvrir.

Player reçoit trois réponses.

---

# 15. Choix Nico

## N-A — Accepter la vérité limitée

**Player**

> tu as bien fait. si elle me demande, je réponds pour moi

**13:44 — Nico**

> Bien.

**13:44 — Nico**

> Je peux garder une confidence.

**13:45 — Nico**

> Je ne change pas une heure pour la protéger.

### Sortie

```text
Nico garde-fou
aucun alibi
vérité couple due si nécessaire
```

---

## N-B — Demander un alibi clair

**Player**

> si elle te redemande, dis qu’on a fermé plus tôt

Silence court.

**13:44 — Nico**

> Non.

**13:44 — Nico**

> Et je ne vais pas négocier une meilleure version du mensonge.

**13:45 — Nico**

> Tu peux lui dire la vérité ou lui dire autre chose toi-même.

**13:45 — Nico**

> Mon nom ne sera pas dedans.

### Sortie

```text
alibi refusé
amitié sous tension
mensonge éventuel non externalisé
```

---

## N-C — Fermer la circulation et la couverture

**Player**

> ne réponds plus à ma place. et ne me couvre pas

**13:44 — Nico**

> D’accord.

**13:44 — Nico**

> C’est simple.

**13:45 — Nico**

> Je garde ce que tu m’as confié. Je ferme le reste.

### Sortie

```text
confidence conservée
rôle d’alibi fermé
regard partagé borné
```

---

# 16. Nico et les images

Nico ne demande aucune image privée en J13.

Il peut demander seulement :

- si une image publique de L’Annexe peut être republiée par le compte officiel ;
- et uniquement à l’audience collective prévue.

Cette demande sociale ne constitue pas une progression de route.

Player ne peut jamais autoriser seul une image de Marie, Mathilde, Pauline ou Raphaëlle.

---

# 17. Visuels Nico J13

## V1 — Trace publique L’Annexe

```text
type: PHOTO_DIÉGÉTIQUE SOCIALE
center: Marie, Mathilde, Pauline ou groupe
function: heure et présence observables
```

## V2 — Nico dans son lieu

```text
type: IMAGE_DE_SCÈNE ou photo professionnelle ordinaire
center: Nico
function: source crédible de l’heure
```

## V3 — Marie ordinaire

```text
type: IMAGE_DE_SCÈNE
center: Marie
function: personne affectée par la vérité ou le mensonge
```

## Trace J14 possible

```text
message Nico, heure publique ou photo horodatée
```

---

# 18. Variante Sandra — La règle de l’image doit tenir le lendemain

## 18.1 Éligibilité

Sandra devient le pivot si :

- une image destinée est encore accessible ;
- une réponse d’audience était due après J12 ;
- Player a promis une heure et l’a manquée ;
- ou Sandra demande une clarification précise.

Elle n’est pas éligible si l’image a été retirée et que Sandra a demandé du silence.

Dans ce cas, le silence est respecté.

## 18.2 Carte de scène

```text
scene_id: sandra_image_rule_next_day_01
source_sequence_id: S19_AFTERMATH
scene_class: CONSEQUENCE
primary_function: vérifier audience, conservation et parole tenue
principal_character: Sandra
primary_relationship: Player / Sandra
communication_mode: REMOTE_ASYNC
```

## 18.3 Ouverture — promesse tenue

**09:14 — Sandra**

> Merci pour hier.

**09:14 — Sandra**

> Tu as répondu sur la règle sans me raconter toute la soirée.

**09:15 — Sandra**

> C’était exactement ce que je demandais.

Player peut :

- confirmer que l’image reste dans le cadre ;
- demander si Sandra veut la retirer ;
- transformer la confiance en demande supplémentaire.

## 18.4 Ouverture — promesse manquée

**09:14 — Sandra**

> Tu avais dit après la fermeture.

**09:15 — Sandra**

> Je n’ai pas besoin d’une explication longue.

**09:15 — Sandra**

> J’ai besoin de savoir si la règle tient toujours.

---

# 19. Choix Sandra

## S-A — Confirmer précisément

**Player**

> oui. elle reste seulement dans notre fil. rien n’a été sauvegardé ailleurs ni montré

**09:16 — Sandra**

> D’accord.

### Si la réponse était en retard

**09:16 — Sandra**

> La règle tient.

**09:17 — Sandra**

> Ma confiance dans les heures, un peu moins.

### Si la réponse était à l’heure

**09:17 — Sandra**

> Merci.

**09:17 — Sandra**

> On peut laisser l’image tranquille maintenant.

### Sortie

```text
audience confirmée
promesse payée ou dette horaire persistante
```

---

## S-B — Offrir le retrait

**Player**

> si tu préfères, tu peux la retirer. je ne te demanderai pas de la laisser

**09:16 — Sandra**

> Je sais.

Silence.

### Variante maintien

**09:18 — Sandra**

> Je la laisse.

**09:18 — Sandra**

> C’est différent quand je sais que je peux l’enlever sans négocier.

### Variante retrait

**09:18 — Sandra**

> Je la retire pour aujourd’hui.

**09:18 — Sandra**

> Ce n’est pas une punition.

**09:19 — Sandra**

> J’ai besoin que le geste redevienne à moi.

### Sortie

```text
contrôle Sandra renforcé
image maintenue ou retirée par son choix
```

---

## S-C — Demander davantage

**Player**

> la règle tient. tu pourrais m’en envoyer une autre quand tu as le temps

**09:16 — Sandra**

> Non.

**09:16 — Sandra**

> C’est précisément ce que je ne voulais pas vérifier ce matin.

**09:17 — Sandra**

> Je retire celle-ci.

Le contenu devient inaccessible.

### Sortie

```text
image retirée
confiance refroidie
aucune nouvelle demande éligible
```

---

# 20. Visuels Sandra J13

## V1 — Image destinée existante

```text
type: PHOTO_DIÉGÉTIQUE
center: Sandra
function: audience et permanence
```

## V2 — État de retrait ou maintien

```text
type: ÉTAT VISUEL DU CONTENU
function: contrôle exercé par Sandra
```

## V3 — Marie ou vie ordinaire

```text
type: IMAGE_DE_SCÈNE
center: Marie
function: réseau réel affecté sans omniscience
```

## Trace J14 possible

Seulement si l’image est encore accessible :

```text
notification, aperçu ou galerie du fil Sandra
```

---

# 21. Variante Mathilde — Le foyer redevient réel

## 21.1 Éligibilité

Mathilde devient le pivot si :

- J11 a créé proximité, baiser, secret ou limite ;
- J12 a rendu leur comportement observable ;
- le séjour au foyer continue ;
- Marie est réellement présente dans la structure domestique ;
- aucune question de sécurité plus urgente n’existe.

## 21.2 Carte de scène

```text
scene_id: mathilde_household_rule_after_convergence_01
source_sequence_id: S20_AFTERMATH
scene_class: CONSEQUENCE
primary_function: définir comment vivre dans le foyer après une intention ou un secret
principal_character: Mathilde
primary_relationship: Player / Mathilde / Marie structurally affected
communication_mode: SEPARATE_ROOMS_PING → REMOTE_ASYNC
```

## 21.3 Contexte

Dimanche matin ou début d’après-midi.

Marie est dans une autre pièce, sortie faire une course ou occupée pour une raison ordinaire.

Mathilde et Player ne sont pas isolés par un dispositif artificiel.

Mathilde écrit parce qu’elle refuse une discussion improvisée dans le couloir.

## 21.4 Ouverture après J11 physique

**10:42 — Mathilde**

> On doit décider comment on vit ici maintenant.

**10:42 — Mathilde**

> Pas ce qu’on appelle vendredi.

**10:43 — Mathilde**

> Comment on ouvre une porte, comment on s’assoit, comment on parle à Marie.

**10:43 — Mathilde**

> Les choses très romantiques, donc.

## 21.5 Ouverture après proximité non sexuelle

**10:42 — Mathilde**

> Hier a prouvé qu’on pouvait être dans la même soirée.

**10:43 — Mathilde**

> Maintenant il faut éviter de transformer chaque cuisine en test.

## 21.6 Ouverture après distance restaurée

**10:42 — Mathilde**

> Merci d’avoir gardé la distance hier.

**10:43 — Mathilde**

> Je veux qu’on la traite comme une vraie règle, pas comme une pause frustrée.

---

# 22. Choix Mathilde

## M-A — Règle de non-répétition immédiate

**Player**

> on ne recommence rien dans l’appartement. on reste ordinaires et on reparle avant tout geste

**10:44 — Mathilde**

> D’accord.

**10:44 — Mathilde**

> Et `ordinaire` ne veut pas dire que tu me surveilles pour vérifier si je le suis.

**Player guidé**

> compris

**10:45 — Mathilde**

> On verra.

### Sortie

```text
secret ou intention maintenu
aucune répétition automatique
foyer protégé provisoirement
```

---

## M-B — Reconnaître le désir et la dette envers Marie

**Player**

> j’ai envie que ça existe encore. mais ça change déjà quelque chose avec Marie et dans l’appartement

Silence.

**10:45 — Mathilde**

> Oui.

**10:45 — Mathilde**

> C’est la phrase la moins confortable.

**10:46 — Mathilde**

> Donc probablement la première utile.

**10:46 — Mathilde**

> Aujourd’hui, rien ne se répète.

**10:47 — Mathilde**

> Ensuite on décide si on arrête, si on parle ou si on accepte d’avoir un secret réel.

### Sortie

```text
désir reconnu
secret et responsabilité reconnus
clarification future due
aucune scène adulte J13
```

---

## M-C — Minimiser

**Player**

> on n’a pas besoin d’en faire une règle. on s’est juste mal comportés une fois

**10:44 — Mathilde**

> Non.

**10:44 — Mathilde**

> `Juste` est exactement le mot qui me donne envie de partir plus tôt.

**10:45 — Mathilde**

> Je vais demander à l’assurance si je peux récupérer mon appartement avant la fin des travaux.

**10:45 — Mathilde**

> Et d’ici là, distance.

### Sortie

```text
confiance refroidie
fin de séjour potentiellement avancée
route physique fermée provisoirement
```

---

# 23. Mathilde si une limite a été ignorée

La scène de règle est remplacée par une demande de distance.

**10:42 — Mathilde**

> Je t’ai dit stop et tu as essayé de discuter le stop.

**10:43 — Mathilde**

> Je ne veux pas d’une explication sur ton intention.

**10:43 — Mathilde**

> Je veux de la distance et une solution pour ne pas rester seule avec toi dans l’appartement.

Player peut :

- accepter immédiatement et organiser avec Marie ou un tiers ;
- minimiser ;
- contester la lecture.

Seule l’acceptation commence une réparation.

Cette conséquence passe avant toute protection de secret.

---

# 24. Visuels Mathilde J13

## V1 — Foyer ordinaire

```text
type: IMAGE_DE_SCÈNE
center: Mathilde
function: vivre après la scène dans le même espace
```

## V2 — Distance ou règle

```text
type: IMAGE_DE_SCÈNE
center: Mathilde
function: porte, place, circulation ou autonomie
circulable: false
```

## V3 — Marie

```text
type: IMAGE_DE_SCÈNE ou photo ordinaire
center: Marie
function: responsabilité familiale réelle
```

## Trace J14 possible

```text
notification Mathilde visible dans le foyer
ou image de tenue encore présente dans le fil
```

---

# 25. Variante Marie — La photo publique ne répond pas au couple privé

## 25.1 Éligibilité

Marie devient le pivot si :

- aucune dette de sécurité ou d’image extérieure ne passe avant ;
- J12 a rendu le couple lisible en public ;
- une distance, reconquête ou promesse reste à vérifier ;
- Player et Marie doivent distinguer apparence publique et réalité privée.

## 25.2 Carte de scène

```text
scene_id: marie_public_couple_private_truth_01
source_sequence_id: S23_AFTERMATH / MARIE_COUPLE_CONSEQUENCE
scene_class: CONSEQUENCE
primary_function: vérifier ce que la photo de couple ne prouve pas
principal_character: Marie
primary_relationship: Player / Marie
communication_mode: REMOTE_ASYNC → OFF_PHONE_OPTIONAL
```

## 25.3 Ouverture

**18:18 — Marie**

> Pauline a envoyé la sélection finale.

**VISUEL M1 — À PRODUIRE PLUS TARD**

```text
type: PHOTO_DIÉGÉTIQUE SOCIALE
creator: Pauline ou Élodie
center: Marie et Player lisibles comme couple
origin: J12
intended_audience: groupe autorisé
function: version officielle du couple
```

**18:19 — Marie**

> On a l’air bien.

**18:19 — Marie**

> J’ai besoin de savoir si on l’était.

Player reçoit trois réponses.

---

# 26. Choix Marie

## C-A — Répondre par la vérité du moment

### Si le couple était proche

**Player**

> oui. pas parfaitement. mais j’étais avec toi et je ne jouais pas la photo

**18:20 — Marie**

> D’accord.

**18:21 — Marie**

> C’est aussi ce que j’ai senti.

**18:21 — Marie**

> Alors on garde l’image sans lui demander de prouver plus.

### Si le couple était distant

**Player**

> non. on a bien tenu la soirée. ce n’est pas la même chose

**18:20 — Marie**

> Merci.

**18:20 — Marie**

> C’est difficile à entendre et beaucoup moins difficile que de le découvrir seule.

**18:21 — Marie**

> Demain, on bloque une heure pour parler. Pas ce soir si on est épuisés.

### Sortie

```text
vérité couple reconnue
photo conservée comme trace publique, pas comme preuve privée
```

---

## C-B — Proposer un acte ordinaire

**Player**

> la photo ne répond pas. je te propose qu’on marche une heure ce soir et qu’on parle après

**18:20 — Marie**

> Une heure réelle ?

**Player**

> 19 h 30 à 20 h 30

**18:21 — Marie**

> D’accord.

**18:21 — Marie**

> Pas de téléphone sauf urgence.

La messagerie s’arrête à la co-présence.

```text
19:30–20:30
marche hors téléphone
aucun dialogue oral transcrit
la présence paie la proposition
```

### Sortie

```text
acte couple concret
clarification amorcée sans reset
```

---

## C-C — Utiliser la photo comme preuve

**Player**

> on a l’air bien parce qu’on va bien. tu compliques quelque chose qui fonctionne

Silence.

**18:21 — Marie**

> Non.

**18:21 — Marie**

> La photo fonctionne.

**18:22 — Marie**

> Ce n’est pas la même affirmation.

**18:22 — Marie**

> Je ne vais pas argumenter contre notre propre image.

### Sortie

```text
version officielle utilisée comme défense
conversation privée due
confiance réduite
```

---

# 27. Après-coup Marie adulte J11

Si J11 comportait une reconquête sexuelle :

Marie ajoute :

**18:24 — Marie**

> Et vendredi ne répond pas non plus à tout.

**18:24 — Marie**

> J’ai aimé ce qui s’est passé.

**18:25 — Marie**

> Je veux aussi savoir si tu me choisis quand il n’y a ni robe noire ni retour tardif.

Le choix J13 reste celui des actes ordinaires, pas une nouvelle scène sexuelle.

---

# 28. Visuels Marie J13

## V1 — Photo publique du couple

```text
type: PHOTO_DIÉGÉTIQUE SOCIALE
center: Marie et Player
function: version officielle insuffisante
```

## V2 — Marie hors événement

```text
type: IMAGE_DE_SCÈNE
center: Marie
function: personne ordinaire après visibilité
```

## V3 — Marche, foyer ou autonomie

```text
type: IMAGE_DE_SCÈNE
center: Marie
function: acte concret ou distance
```

## Trace J14 possible

```text
photo publique du couple ouverte au mauvais moment
ou notification d’une autre ligne visible près de Marie
```

---

# 29. Fallback — Rien d’urgent n’est dû

## 29.1 Conditions

Le fallback existe si :

- aucune limite n’a été violée ;
- aucune image privée n’est active ;
- aucun après-coup adulte n’est dû ;
- les heures annoncées ont été tenues ;
- aucune ligne privée n’est devenue visible ;
- les routes dominantes ont été fermées ou laissées tranquilles.

## 29.2 Carte de scène

```text
scene_id: j13_sunday_network_respiration_01
source_sequence_id: S23_AFTERMATH_RESPIRATION
scene_class: RESPIRATION
primary_function: montrer que le réseau continue sans dette fabriquée
principal_relationship: Marie / foyer / réseau
communication_mode: REMOTE_ASYNC → OFF_PHONE
```

## 29.3 Script

**11:52 — Marie**

> Pauline a terminé le tri des photos.

**11:52 — Marie**

> Elle en a validé trois et condamné deux pour crimes contre les yeux ouverts.

**11:53 — Marie**

> Mathilde veut du pain.

**11:53 — Marie**

> Moi je veux ne plus voir une rallonge avant lundi.

**11:54 — Marie**

> Tu participes à quel niveau ?

Player choisit :

- aller chercher le pain et rentrer ;
- proposer une marche précise ;
- annoncer qu’il reste seul de son côté.

Chaque réponse ferme proprement son attente.

Aucune route extérieure n’apparaît.

---

# 30. Retour Marie lorsque la route principale n’est pas Marie

Un écho court existe en fin de journée.

Il ne concurrence pas la conséquence principale.

## Si Player a été clair

**19:42 — Marie**

> Journée calme ici.

**19:42 — Marie**

> Mathilde a retrouvé un sac qu’elle cherchait depuis mardi dans le sac où elle l’avait mis.

**Player guidé**

> enquête résolue

**19:43 — Marie**

> La justice triomphe.

## Si une dette couple existe

**19:42 — Marie**

> On doit parler de l’heure d’hier.

**19:42 — Marie**

> Pas maintenant si tu es au milieu d’autre chose.

**19:43 — Marie**

> Donne-moi une heure réelle pour demain.

Player doit choisir une heure ou refuser clairement.

Aucune réponse guidée ne crée l’obligation.

---

# 31. Trace prioritaire pour J14

J13 ne crée pas encore la découverte.

Elle définit seulement la trace existante la plus crédible à recontextualiser en J14.

## Pauline

```text
aperçu de la version privée P1
```

## Raphaëlle

```text
image masquée sélectionnée
```

## Nico

```text
message sur l’heure réelle ou demande d’alibi
```

## Sandra

```text
image destinée encore accessible ou notification du fil
```

## Mathilde

```text
notification domestique ou image de tenue déjà existante
```

## Marie

```text
photo publique du couple juxtaposée à une notification privée
```

## Fallback

```text
photo publique de groupe sans trace privée obligatoire
```

J14 utilise uniquement une trace qui existe réellement dans cette partie.

---

# 32. Connaissances de sortie

À la fin de J13 :

- une audience, une limite ou une dette est précise ;
- la personne principale sait comment Player a répondu ;
- Marie reste présente ou affectée ;
- une autre conséquence peut rester en attente ;
- une trace réelle peut devenir dangereuse en J14 ;
- aucune nouvelle route dominante n’est créée ;
- aucune escalade adulte n’écrase l’après-coup.

---

# 33. Contrat visuel global

Minimum : 3.

## V1 — Trace recontextualisée

Image publique ou privée déjà existante.

## V2 — Conséquence de la relation principale

Personnage principal dans l’après-coup, retrait, règle ou autonomie.

## V3 — Vie ordinaire / couple

Marie, foyer ou partenaire réel affecté.

Aucune image de remplissage.

Une suppression ou un retrait peut compter comme événement visuel seulement si le contenu avait déjà une fonction narrative établie.

---

# 34. Conformité text-only

- aucun appel ;
- aucun vocal ;
- aucune scène audio ;
- aucune nouvelle scène sexuelle ;
- messages comme négociation ;
- co-présence éventuelle hors téléphone ;
- retour par messages ;
- aucune conversation orale transcrite.

---

# 35. Audit des voix

## Pauline

- contrôle d’audience ;
- version publique vraie ;
- Bastien réel ;
- fermeture nette ;
- désir par compartiment, pas par confession.

## Raphaëlle

- processus ;
- rôle ;
- posture ;
- frontière ;
- Maud réelle ;
- précision qui peut se fermer.

## Nico

- heure réelle ;
- langage direct ;
- refus de l’alibi ;
- amitié sans thérapie ;
- aucun droit sur les femmes.

## Sandra

- image choisie ;
- faible volume ;
- règle simple ;
- retrait disponible ;
- aucune demande de supplément récompensée.

## Mathilde

- foyer ;
- vitesse ;
- embarras ;
- mauvaise foi réduite lorsque la responsabilité apparaît ;
- droit léger, puis phrase directe.

## Marie

- photo publique ;
- vie ordinaire ;
- demande d’acte ;
- refus d’utiliser l’image comme preuve ;
- aucune omniscience.

---

# 36. Test sans nom

```text
La version publique reste vraie.
→ Pauline

Le rôle est dans l’image. Il n’est pas dans cette conversation.
→ Raphaëlle

Je peux garder une confidence. Je ne change pas une heure pour la protéger.
→ Nico

La règle tient. Ma confiance dans les heures, un peu moins.
→ Sandra

Comment on ouvre une porte, comment on s’assoit, comment on parle à Marie.
→ Mathilde

La photo fonctionne. Ce n’est pas la même affirmation.
→ Marie
```

---

# 37. Audit anti-générique

J13 évite :

- nouvelle scène sexuelle après J11 ;
- tous les fils qui réclament une réponse ;
- Pauline injectée sans image issue de J12 ;
- Bastien réduit à un obstacle ;
- Raphaëlle envoyant un masque comme permission ;
- Nico acceptant automatiquement un alibi ;
- Sandra récompensant une demande de supplément ;
- Mathilde utilisant le foyer comme disponibilité ;
- Marie utilisant la photo comme preuve magique ;
- trace créée uniquement pour préparer J14 ;
- respiration remplacée par une route de consolation.

---

# 38. Critères de validation J13

- [ ] une seule conséquence est foreground ;
- [ ] la priorité respecte sécurité, image et après-coup ;
- [ ] aucune nouvelle route dominante ;
- [ ] Pauline n’existe que par une version issue de J12 ;
- [ ] Bastien reste réel ;
- [ ] Raphaëlle distingue rôle et conversation ;
- [ ] Nico peut refuser l’alibi ;
- [ ] aucune image privée n’est transmise à Nico ;
- [ ] Sandra contrôle maintien ou retrait ;
- [ ] Mathilde définit une règle du foyer ;
- [ ] Marie distingue photo publique et couple privé ;
- [ ] aucune scène adulte ;
- [ ] toute co-présence arrête le chat ;
- [ ] trois fonctions visuelles minimum ;
- [ ] une trace J14 existe déjà dans la partie ;
- [ ] aucune trace n’est inventée pour la découverte ;
- [ ] une dette peut rester en attente ;
- [ ] aucune opportunité forte n’écrase la conséquence.

---

# 39. Résumé canonique candidat

J13 ne demande pas quelle relation Player veut poursuivre.

Elle demande quelle dette doit être payée la première.

Pauline peut distinguer une version publique authentique d’une image à double adresse, ouvrir un compartiment prudent ou restaurer la surface.

Raphaëlle peut envoyer une version masquée parce que le cadre public a été respecté, vérifier si Player voit encore le processus ou retirer l’accès privé lorsqu’il réduit la transformation à un produit plus sexy.

Nico peut refuser de devenir un alibi lorsque l’heure réelle contredit la version donnée à Marie.

Sandra peut confirmer l’audience de son image, la maintenir parce que son retrait reste possible ou la retirer si Player réclame immédiatement davantage.

Mathilde peut définir comment vivre dans le foyer après une proximité ou un secret, reconnaître la dette envers Marie ou avancer son départ si Player minimise.

Marie peut demander si la photographie publique d’un couple correspondait réellement à leur soirée privée, obtenir une vérité, un acte concret ou constater que Player utilise l’image comme défense.

Si rien n’est dû, le dimanche reste calme et aucune route extérieure ne vient remplir artificiellement le vide.

J13 se termine avec une trace réelle susceptible d’être vue hors contexte en J14.

> **Une conséquence devient sérieuse lorsqu’elle cesse d’être une ambiance et exige enfin une règle, une suppression, une vérité ou un acte.**
