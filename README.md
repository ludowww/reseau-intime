# Réseau Intime

**Réseau Intime** est un jeu narratif adulte en interface smartphone, développé avec Godot 4.6.x.

Le joueur incarne **Player**, en couple avec **Marie**. Leur vie commune reste réelle et désirable, mais la routine, les images, les secrets, la jalousie et les désirs croisés obligent chacun à choisir ce qu’il veut préserver, cacher, partager ou quitter.

```text
Quand les personnages sont ensemble, ils parlent.
Quand la distance, la logistique, la confidentialité, une trace ou l'après-coup le justifie, le téléphone enregistre l'échange.
```

## Question centrale

```text
Le couple Player / Marie
peut-il redevenir un choix actif ?
```

## Architecture

```text
tronc dramatique fixe
+ choix topologiques
+ fenêtres narratives
+ scènes modulaires
+ obligations et traces persistantes
+ conséquences revenant vers le couple
```

Les routes utilisent R0–R5.

Le runtime actif reste en R1 maximum. V0.87 documente un futur premier accès R2 pour un seul personnage au maximum. V0.88 définit la première tranche d’intégration possible, mais cette progression n’est pas encore jouable.

---

## Runtime jouable actuel — V0.86 + V0.86a

Le contenu est jouable du mardi au vendredi.

Au lancement :

```text
Mardi = actif
Mercredi = verrouillé
Jeudi = verrouillé
Vendredi = verrouillé
```

Progression :

```text
fin d'un échange
-> le contact passe hors ligne
-> pause de 2 secondes
-> horloge accélérée pendant 4 secondes à Speed x1
-> notification compacte du prochain autre contact
```

Si le nouvel épisode appartient au fil déjà ouvert :

```text
horloge
-> pas de notification même contact
-> reprise directe à la suite
```

Le changement de journée utilise le même principe avec franchissement de minuit.

Il n’existe plus de page vide indiquant seulement le jour ou le moment de la journée.

---

## Mardi — J1 réconcilié

```text
18:12 Marie / dîner, pain et marche + M1
19:15 ou 19:35 activité commune hors téléphone
22:57 Sandra / ancienne photo floue + S1
23:25 ou 23:28 retour final vers Marie
fin Mardi -> Mercredi
```

Garanties :

- le pain est encore à acheter quand Player répond ;
- M1 compare trois postures de présence cohérentes ;
- les timestamps restent mardi et progressent normalement ;
- Sandra partage une seule trace douce ;
- Mathilde reste indirecte ;
- aucun ancien score numérique ;
- la journée finit sur Marie et la vie commune.

## Mercredi — Faire de la place

```text
12:10 Marie / urgence Mathilde
18:18 trace d'arrivée
18:22 Mathilde / arrivée
installation poursuivie hors téléphone
```

État :

```text
Mathilde = R1 Ordinary Access
stay active
aucune intention sexuelle
```

## Jeudi — Être là

```text
09:10 Raphaëlle obligatoire
13:50 Sandra optionnelle
16:05 Marie obligatoire
soirée : une seule branche O5
22:10 retour Marie obligatoire
```

Si Sandra est ignorée :

```text
chapter_03_sandra_continuity = EXPIRED
thursday_sandra_echo_missed = true
```

Elle ne reste pas accessible après 16:05.

## Vendredi — Le lendemain

### Pauline — 08:35

Pauline relaie trois versions autorisées de la photo de groupe.

```text
P0
pratique
plaisanterie sèche
renvoyer vers Marie
```

Le set :

- vient de la télécommande de Pauline ;
- montre notamment Marie, Pauline, Bastien et Élodie ;
- peut inclure Nico et, selon la topologie, Player ;
- n’inclut pas Mathilde ;
- appartient au contexte public/événement de La Verrière ;
- ne possède aucun crop privé ou sens adulte.

Pauline atteint :

```text
R1 Legitimate Social Access
```

### Nico — 14:05

Nico reprend la plaisanterie de la place gardée selon ce que Player a réellement fait jeudi.

```text
N0
honnête
joueur
demander comment allait Marie
```

Il peut apprendre que Mathilde séjourne chez eux, mais son commentaire reste pratique.

Nico atteint :

```text
R1 Ordinary Friendship / Social Access
```

Aucun regard partagé dangereux, demande d’image, rivalité ou cadre adulte n’est activé.

### Foyer — 18:05 / 18:25

Marie et Mathilde envoient deux courts échos dans leurs fils séparés.

La continuité interne confirme ensuite :

```text
household_rhythm_confirmed
opening_band_complete
```

L’ouverture se termine sur la vie ordinaire à trois, pas sur une tentation.

Le runtime n’explique pas explicitement ce que Player fait hors téléphone : le joueur l’infère par l’heure, les objets, les échanges suivants et les conséquences.

---

## Simulation smartphone du temps

La barre fixe au-dessus du nom du contact affiche :

```text
heure                         Wi-Fi / batterie
```

À `Speed x1` :

```text
pause après le dernier message = 2 secondes
animation accélérée de l'horloge = 4 secondes
```

La conversation reste visible pendant que l’heure avance.

Une notification vers un autre contact :

- reste sous l’en-tête ;
- limite l’aperçu à dix caractères puis `...` ;
- utilise un bref effet d’insertion/flash ;
- conserve le transcript en bas ;
- sert de raccourci vers le nouveau fil.

Le panneau gauche temporaire ne duplique plus visuellement l’heure. Il sera supprimé dans une future refonte aux dimensions réelles d’un smartphone.

## Activité hors téléphone

Les phases hors téléphone restent utiles à la cohérence interne : variantes, flags, ordre, conséquences et débogage.

Elles ne sont pas exposées au joueur sous forme de :

- carte plein écran ;
- note explicative centrée ;
- rubrique `Moments hors ligne` ;
- indice d’archive rejouable.

Le joueur doit les imaginer ou les déduire.

## Archives

Une journée terminée reste consultable en lecture seule.

Une archive :

- n’affiche aucun badge ou notification ;
- ne propose aucun nouveau choix ;
- ne réapplique aucun effet ;
- ne change pas l’heure ;
- ne réactive pas une scène expirée ;
- filtre les fils persistants par épisode source ;
- n’expose pas le journal interne des activités hors téléphone.

---

## État narratif runtime courant

```text
Marie/Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE
Sandra = soft trace / continuité ordinaire
Mathilde = R1 domestique
Raphaëlle = R1 travail
Pauline = R1 social/public
Nico = R1 amitié/social
hard secrets = none
adult frames = none
routes R2+ = none
opening_band_complete = true
```

---

## V0.87 — First Repetition Windows Source Pack

V0.87 est une étape **documentation uniquement**.

Elle définit la première vague narrative suivant l’ouverture :

```text
W9  Marie réclame une heure partagée
W10 opportunité de répétition week-end
W11 retour obligatoire vers Marie
W12 opportunité de répétition premier jour ouvré
W13 fermeture de vague / équilibre du couple
```

Budget :

```text
1 foreground Marie fixe
+ 2 foregrounds externes maximum
+ 1 seul accès chargé maximum
+ conséquences Marie obligatoires
```

Scènes candidates :

```text
Mathilde — regard cuisine reconnu
Sandra — après-poste choisi
Raphaëlle — couche ordinaire hors travail
Pauline — deuxième cycle social légitime avec Bastien
Nico — deuxième cycle d'amitié calme
```

### Plafond V0.87 documenté

```text
charged_access_owner = none | mathilde | sandra | raphaelle
maximum one owner
```

| Personnage | Runtime actuel | Maximum documenté V0.87 |
|---|---|---|
| Marie | `HABITUAL_WARMTH` | même mode + preuves reconnexion/dérive |
| Sandra | R1/soft | R2 max |
| Mathilde | R1 | R2 max |
| Raphaëlle | R1 | R2 max |
| Pauline | R1 | R1 |
| Nico | R1 | R1 |

Toujours exclus :

- hard secret ;
- cadre adulte ;
- image adulte ;
- route R3+ ;
- changement de cadre du couple ;
- tous les personnages foreground dans une même partie.

### Pourquoi Pauline et Nico restent R1

Pauline doit d’abord répéter un contexte social/public légitime avec Bastien et Marie encore réels.

Nico doit d’abord exister comme ami calme avant de devenir complice d’un regard partagé.

Leur futur moteur NSFW n’est pas supprimé. Il est rendu crédible.

### Pourquoi aucune nouvelle image

V0.87 ne demande aucun nouvel asset visuel.

Les traces existantes gardent leur origine, public et fonction.

```text
j1_sandra_lunch_memory_soft
mathilde_arrival_room_01
marie_laverriere_setup_01
laverriere_public_group_photo_set_01
```

Aucun recadrage, transfert, second public ou sens sexuel n’est ajouté.

---

## V0.88 — First Repetition Runtime Integration Plan

V0.88 reste une étape **documentation uniquement**.

Elle sélectionne une petite preuve runtime au lieu de planifier l’intégration complète de V0.87 en une seule PR.

Tranche validée pour la future V0.89 :

```text
Samedi W9 — Marie réclame une heure partagée
-> Dimanche — Mathilde devient candidate ou est différée silencieusement
-> Dimanche W11 — retour Marie obligatoire
```

### Pourquoi Mathilde est la première candidate

- son séjour est déjà actif ;
- le rythme du foyer est déjà confirmé ;
- son fil persistant existe ;
- aucune nouvelle image n’est nécessaire ;
- la scène teste l’éligibilité, l’expiration, le maintien R1 ou le passage R2 ;
- Marie et la confiance familiale restent dans le sens de la scène ;
- le choix est fondé sur la cohérence et la surface technique, pas sur la priorité de sa future route adulte.

Sandra, Raphaëlle, Pauline et Nico restent dans le pack V0.87 pour des intégrations ultérieures et courtes.

### État planifié

```text
TimelineState
= jours, phases, épisodes, expiration

GameState.story_ledgers.first_repetition
= foregrounds, propriétaire R2, lifecycle des scènes,
  cooldowns et obligations

flags plats
= faits observables des choix

index narratifs
= limites et ordre déterministe des candidats
```

Le sélecteur futur retourne :

```text
un candidat éligible
ou aucun
```

Il n’utilise ni hasard libre ni menu de personnages.

### Fin de la première tranche

La future implémentation pourra écrire :

```text
first_repetition_slice_01_complete
```

Elle ne devra pas écrire :

```text
first_repetition_wave_complete
```

Lundi restera indisponible.

### Plafond Mathilde

Mathilde pourra rester R1 ou devenir l’unique propriétaire R2 si :

- MT1A ou MT1B est choisi ;
- l’historique positif du foyer le justifie ;
- aucune limite n’a été brisée ;
- aucun autre propriétaire n’existe ;
- aucune conséquence Marie due n’a été contournée.

R2 n’accordera toujours aucune :

```text
intention de séduction reconnue
permission d'image
permission adulte
secret dur
```

### Obligations Marie

Les obligations seront structurées comme :

```text
SCHEDULED
DUE
PAID
FAILED
CARRIED
```

Une conséquence Marie due bloquera toute nouvelle opportunité externe.

M3B pourra conserver une promesse concrète pour lundi comme `CARRIED` sans la marquer comme payée.

---

## Sources V0.87 et V0.88

```text
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SCENE_CARDS.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_TEMPORAL_DELIVERY_MAP.md
docs/canon/CHARACTER_VOICE_DISTINCTION_CANON.md
docs/runtime/V0_88_FIRST_REPETITION_RUNTIME_INTEGRATION_PLAN.md
docs/V0_87_Next_Act_I_Windows_Source_Pack_Report.md
docs/V0_88_First_Repetition_Runtime_Integration_Plan_Report.md
```

Commencer toujours par :

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
```

---

## Fondation runtime

```text
game/scripts/core/TimelineState.gd
game/scripts/ui/PhonePrototypeV084.gd
game/scripts/ui/PhonePrototypeV085.gd
game/scripts/ui/PhonePrototypeV086A.gd
game/scripts/ui/ConversationViewV084.gd
game/scripts/ui/ConversationViewV086A.gd
```

V0.87 et V0.88 ne modifient aucun de ces fichiers.

---

## Prochaine version

```text
V0.89 — First Repetition Vertical Slice
```

V0.89 pourra intégrer uniquement :

```text
W9 Marie
+ candidat Mathilde ou différé silencieux
+ retour Marie obligatoire
```

Elle ne devra pas ajouter dans la même PR :

- Sandra ;
- Raphaëlle ;
- Pauline ;
- Nico ;
- le deuxième ticket externe ;
- la vague W12/W13 complète ;
- une nouvelle image ;
- un cadre adulte.

---

## Règles adultes fondamentales

```text
Ignorer n'est pas consentir.
Une connaissance partielle n'est pas une permission.
La jalousie ou l'excitation n'est pas une permission.
Une image publique n'est pas une permission de transmettre.
Un vêtement ou costume n'est pas un consentement global.
Un secret clairement nommé reste une trahison.
Une négociation tardive ne réécrit pas une trahison antérieure.
```

## Final

```text
V0.84 rend le temps autoritaire.
V0.85 rend le premier soir cohérent.
V0.86 termine l'ouverture.
V0.86a fait ressentir le temps comme une vraie messagerie.
V0.87 décide quelles répétitions peuvent changer de sens.
V0.88 choisit la plus petite intégration honnête.
V0.89 pourra implémenter uniquement cette tranche.

Une répétition peut devenir chargée.
Elle ne devient pas encore permission.
```
