# État global de l’histoire — V0.79

> Résumé opérationnel après écriture du premier source pack modulaire post-J1.  
> Ce fichier ne remplace ni le canon détaillé ni les cartes de scènes.  
> Il sert à vérifier rapidement l’état courant avant le plan d’intégration runtime.

## 1. Hiérarchie de vérité actuelle

```text
canon personnages complet
+ canon NSFW
+ canon des choix
+ V0.78 Modular Narrative Arc Blueprint
+ V0.78 Modular Scene Authoring Contract
+ V0.79 Act I Opening Windows Source Pack
+ V0.79 Act I Opening Scene Cards
= vérité narrative actuelle pour l'ouverture post-J1

runtime JSON
= implémentation technique, jamais vérité narrative automatique

anciens J2–J10 / day plans / foundations / summaries
= historiques ou techniques si contradiction
```

## 2. Sources actives

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/NARRATIVE_CANON_STATUS.md
docs/canon/CHOICE_DESIGN_CANON.md
docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md
docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md
docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_OPENING_SCENE_CARDS.md
docs/canon/characters/CHARACTER_CANON_INDEX.md
docs/canon/characters/*_CANON_FULL.md
docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md
docs/canon/SUPPORTING_CHARACTER_CANON_POLICY.md
```

Pour J1 exact :

```text
docs/canon/J1_CANON_SOURCE_PACK.md
docs/V0_69_J1_Canon_Text_Review_And_Final_Line_Source.md
```

## 3. Question centrale

```text
Le couple Player / Marie peut-il redevenir un choix actif ?
```

Les autres personnages ouvrent des réponses ou tentations distinctes sans remplacer cette histoire.

```text
Marie      = couple et reconquête active
Sandra     = confidence et vérité privée choisie
Mathilde   = proximité domestique et changement d'intention
Pauline    = image, compartimentation et double vie
Nico       = regard social, envie domestique, voyeurisme et rivalité
Raphaëlle  = version choisie, cadre explicite et après-rôle
Player     = regard devenant acte, choix ou mauvaise foi
```

## 4. État canonique après J1

Mode couple :

```text
HABITUAL_WARMTH
```

- amour réel ;
- confiance globalement intacte ;
- exclusivité supposée ;
- désir sous-exprimé ;
- vie commune fonctionnelle ;
- présence active de Player inégale ;
- Sandra réapparue par une trace douce ;
- aucune route externe active ;
- aucun secret dur ;
- aucun cadre adulte.

## 5. Ouverture Acte I désormais écrite

V0.79 couvre approximativement trois à cinq jours diégétiques sans imposer une étiquette fixe `J2`.

Ordre relatif :

```text
O0 — continuité J1
O1 — Marie / faire de la place
O2 — arrivée de Mathilde
O3 — Raphaëlle travail + écho Sandra possible
O4 — Marie propose un mouvement
O5 — une branche topologique
O6 — retour obligatoire vers Marie
O7 — relais photo publique Pauline
O8 — suivi place gardée Nico + respiration foyer
```

O7 et O8 peuvent s’inverser selon le rythme naturel des messages.

## 6. Contenu canonique de l’ouverture

### Mathilde

- dégât des eaux chez elle ;
- chambre et partie de la salle de bain inutilisables ;
- séjour chez Marie et Player pour environ dix à quinze jours ;
- valise trop pleine, housse à vêtements, tote bag juridique, chaussures et chargeur perdu ;
- photographie d’arrivée prise ouvertement par Marie ;
- accès domestique ordinaire R1 ;
- aucune intention sexuelle reconnue.

### Raphaëlle

- première présence par une revue UX/accessibilité normale ;
- collègue pair de Player ;
- trois réponses autour d’une correction professionnelle ;
- éventuelle housse de costume comme détail de vie, sans photo ou accès privé ;
- R1 travail uniquement.

### Sandra

- bref écho après un poste du matin ;
- continuité de la photo floue seulement si la branche J1 le justifie ;
- aucun nouveau visuel ;
- aucun rendez-vous nouveau verrouillé ;
- lien actif ou volontairement refroidi.

### Marie

- prend en charge l’urgence familiale sans effacer Player ;
- demande une participation concrète ;
- organise le vernissage local annoncé dans J1 ;
- sépare besoin pratique et envie de voir Player présent ;
- agit même lorsqu’il ne vient pas ;
- reçoit la conséquence de chaque topologie.

### Pauline

- entre par un set de photos de groupe autorisées ;
- agit à la demande de Marie ;
- Bastien reste visible dans le contexte social ;
- aucune version privée ou preuve réciproque ;
- R1 social/public.

### Nico

- entre comme ami et relais social ;
- garde une table ou une chaise après l’événement ;
- peut apprendre que Mathilde est hébergée ;
- aucune remarque sexuelle, demande de photo ou proposition d’alibi ;
- R1 amitié/social.

## 7. Premier choix topologique

Marie propose le vernissage de La Verrière.

Player choisit :

```text
1. venir tôt avec Marie
2. rester au foyer partagé
3. finir une vraie obligation de travail et promettre de venir ensuite
```

Cela ouvre exactement une scène principale :

```text
Marie / participation sociale
OU
Mathilde / accès domestique pratique
OU
Raphaëlle / travail et pression de la promesse
```

Chaque branche revient ensuite vers Marie.

Le choix ne sélectionne pas une femme ; il définit ce que Player fait.

## 8. Choix exacts documentés

```text
M0  — qualité de participation à l'hébergement
MT0 — accueil de Mathilde
R0  — réponse à une correction professionnelle
M1  — choix topologique de la soirée
MA0 — qualité de présence à La Verrière
MH0 — posture domestique avec Mathilde
RW0 — travail contre promesse explicite
P0  — sélection photo publique autorisée
N0  — réponse à l'amitié de Nico
```

Tous les nœuds utilisent trois choix.

Le retour vers Marie n’ajoute pas de faux choix permettant d’annuler la décision précédente.

## 9. Visuels et traces de l’ouverture

### Actifs

- `mathilde_arrival_room_01` : image privée ordinaire, prise par Marie ;
- `raphaelle_blue_folder` : visuel travail optionnel ;
- `marie_laverriere_setup_01` : image événement autorisée ;
- `laverriere_public_group_photo_set_01` : set social/public autorisé par les personnes photographiées.

### Absents

- selfie canapé Mathilde ;
- image délibérément provocante de Mathilde ;
- seconde photo Sandra ;
- photo personnelle/cosplay de Raphaëlle ;
- crop privé Pauline ;
- image privée proposée par Nico ;
- capture cachée ;
- vidéo sexuelle.

Aucune image n’a encore de fonction adulte.

## 10. État de fin du pack V0.79

```text
Mathilde stay = active
Marie event = completed
first topology = remembered
public group photo = exists
Raphaëlle R1 = established
Pauline R1 = established
Nico R1 = established
Sandra trace = active or intentionally cooled
hard secrets = none
adult frames = none
relationship frame = ASSUMED_EXCLUSIVE
```

Mode couple :

```text
HABITUAL_WARMTH
```

Tendances possibles uniquement :

- candidat `ACTIVE_RECONNECTION` ;
- candidat `PARALLEL_DRIFT`.

Un seul événement ne déclenche pas le changement de mode.

## 11. Tronc payé par V0.79

```text
S1 Changement du foyer = concrétisé
S2 Mouvement proposé = première occurrence concrétisée
S3 Vies extérieures visibles = ouverture concrétisée
```

S4–S9 restent régis par V0.78 mais ne disposent pas encore de texte exact dans ce pack.

## 12. Cycle des routes

```text
R0 Background
R1 Ordinary Access
R2 Charged Access
R3 Acknowledged Intent
R4 Consequential Frame
R5 Integration / Aftermath
```

Fin V0.79 :

- Mathilde R1 ;
- Raphaëlle R1 ;
- Pauline R1 ;
- Nico R1 ;
- Sandra trace douce / R1 refroidi ;
- aucune route R2 canonisée.

## 13. Obligations importantes du pack

Créées puis payées :

- faire de la place ;
- accueillir Mathilde ;
- corriger le dossier ;
- participer ou non au vernissage ;
- tenir, modifier honnêtement ou manquer la promesse de venir ;
- sélectionner la photo publique ;
- répondre à la place gardée.

Aucun secret conséquent ne reste ouvert.

## 14. Règles NSFW

V0.79 reste non explicite.

Les règles générales restent :

```text
Ignorer n'est pas consentir.
Une connaissance partielle n'est pas une permission.
La jalousie n'est pas une permission.
L'excitation n'est pas une permission.
Une image publique n'est pas une permission de transmettre.
Un vêtement ou costume n'est pas un consentement global.
Un secret clairement nommé reste une trahison.
```

## 15. Documents J2 historiques

Les documents suivants restent consultables mais ne définissent plus la continuité actuelle :

```text
docs/J2_WRITING_FOUNDATION.md
docs/story_state/J2_SUMMARY.md
runtime J2 existant
```

Sont notamment dépréciés comme obligations narratives :

- ordre fixe du Jour 2 ;
- Player physiquement absent jusqu’à J3 ;
- quatre visuels obligatoires ;
- selfie canapé Mathilde ;
- exclusion de Pauline/Nico uniquement par numéro de jour.

## 16. Prochaine étape

```text
V0.80 — First Modular Runtime Integration Plan
```

V0.80 doit :

- inspecter le runtime J2+ existant ;
- mapper le strict minimum d’états ;
- décider comment O0–O8 s’insèrent dans l’interface smartphone ;
- préserver un fil visible par personnage ;
- identifier les anciens nœuds et visuels à remplacer ou contourner ;
- conserver le budget une scène principale / zéro à deux échos ;
- garantir le retour obligatoire vers Marie ;
- éviter tout gros refactoring ;
- définir tests, validation et rollback.

Aucun runtime avant validation de V0.80.

## 17. Résumé opérationnel

```text
J1 : canon actuel et runtime aligné.
Ouverture Acte I : texte et cartes validables dans V0.79, runtime non intégré.
Ancien J2+ : historique / technique.
Routes : accès ordinaires seulement.
Couple : HABITUAL_WARMTH.
Prochaine documentation : V0.80 plan d'intégration runtime.
```
