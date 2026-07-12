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

Les routes utilisent R0–R5, mais le runtime actuel reste en R1 maximum.

## Runtime jouable actuel — V0.86 + V0.86a

Le contenu est jouable du mardi au vendredi avec jours et phases déverrouillés chronologiquement.

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
-> horloge accélérée pendant 4 secondes
-> notification du prochain message
```

Le changement de journée utilise le même principe avec franchissement de minuit. Il n’existe plus de page vide indiquant seulement le jour ou le moment de la journée.

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

L’ouverture se termine sur la vie ordinaire à trois, pas sur une tentation. Le runtime n’explique pas explicitement ce que Player fait hors téléphone : le joueur l’infère par l’heure, les objets, les échanges suivants et les conséquences.

## Temps autoritaire

Source :

```text
docs/canon/TEMPORAL_FLOW_AND_DAY_TRANSITION_CANON.md
```

Cycle des jours :

```text
LOCKED -> AVAILABLE -> ACTIVE -> COMPLETE -> ARCHIVED
```

Cycle des phases :

```text
LOCKED -> CURRENT -> COMPLETE / SKIPPED / EXPIRED
```

```text
Les timestamps décrivent la chronologie.
L'état temporel contrôle l'accès.
```

## Simulation smartphone du temps

La barre fixe située au-dessus du nom du contact affiche :

```text
heure                         Wi‑Fi / batterie
```

À `Speed x1` :

```text
pause après le dernier message = 2 secondes
animation accélérée de l'horloge = 4 secondes
```

La conversation reste visible pendant que l’heure avance. La notification suivante apparaît ensuite sous l’en-tête et permet d’ouvrir directement le nouveau fil.

Le panneau gauche temporaire ne duplique plus visuellement l’heure. Il sera supprimé dans une future refonte aux dimensions réelles d’un smartphone.

## Activité hors téléphone

Les phases hors téléphone restent utiles à la cohérence interne : variantes, flags, ordre, conséquences et débogage.

Elles ne sont toutefois pas exposées au joueur sous forme de :

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

## État narratif courant

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

## Fondation runtime

```text
game/scripts/core/TimelineState.gd
game/scripts/ui/PhonePrototypeV084.gd
game/scripts/ui/PhonePrototypeV085.gd
game/scripts/ui/PhonePrototypeV086A.gd
game/scripts/ui/ConversationViewV084.gd
game/scripts/ui/ConversationViewV086A.gd
```

V0.86 ajoute le vendredi. V0.86a rapproche l’interface d’une messagerie réelle sans modifier les scènes, les routes ou le canon personnages.

## Sources

Commencer par :

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
```

Rapports actuels :

```text
docs/V0_86_Friday_Public_Traces_And_Opening_Completion_Report.md
docs/V0_86A_Temporal_UX_Notification_Polish_Report.md
```

## Prochaine version

```text
V0.87 — Next Act I Windows Source Pack
```

La prochaine étape revient à la documentation avant toute extension runtime. Elle doit définir les premières répétitions et attentions privées sans sauter automatiquement vers R2.

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
V0.86a fait ressentir le temps comme une vraie messagerie,
sans expliquer ce qui doit rester hors champ.
```