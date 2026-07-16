# Réseau Intime — 12 Plans détaillés des scènes et audit runtime J01–J08

## Statut du document

**Catégorie : Canon**

**Niveau : Audit de l’ouverture jouable et première tranche de cartes de scènes**

Ce document accomplit deux fonctions :

1. auditer le runtime actif J01–J06 contre les documents canoniques `08–11` ;
2. définir les cartes narratives détaillées de J05–J08 avant toute nouvelle intégration runtime.

Il complète :

- `07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md` ;
- `08_REGLES_DES_SCENES_MODULAIRES.md` ;
- `09_PROGRESSION_VISUELLE_ET_PHOTOGRAPHIQUE.md` ;
- `10_CARTE_CONSEQUENCES_DETTES_SECRETS_OBLIGATIONS.md` ;
- `11_DISTRIBUTION_SEQUENCES_SCENES_IMAGES_CONSEQUENCES_JOURNEES.md` ;
- les canons complets des personnages.

Il ne contient :

- aucun dialogue définitif ;
- aucun JSON directement intégrable ;
- aucune modification runtime ;
- aucun prompt d’image ;
- aucun cadrage, pose, tenue ou composition visuelle ;
- aucun asset ;
- aucune instruction ComfyUI ;
- aucun système générique de route ou de score.

---

# 1. Limite de responsabilité visuelle

Les images finales seront fournies ultérieurement par Ludovic via ComfyUI.

Ce document définit uniquement :

- le nombre de contenus visuels nécessaires ;
- la journée et la fenêtre où ils deviennent disponibles ;
- le personnage ou la relation qu’ils servent ;
- leur fonction narrative générale ;
- leur statut diégétique ou de souvenir lorsque cette distinction est nécessaire ;
- les règles d’audience, de sauvegarde ou de retrait déjà imposées par le canon.

Ce document ne décide pas :

- de la pose ;
- du vêtement précis ;
- du décor précis ;
- de l’angle ;
- de la lumière ;
- du modèle ComfyUI ;
- du workflow ;
- du prompt ;
- du sampler ;
- du nombre d’étapes ;
- de la résolution finale ;
- de la sélection de l’image produite.

Les emplacements visuels sont donc écrits sous la forme :

```text
slot visuel
→ propriétaire narratif
→ fonction
→ audience / permanence si nécessaire
→ asset fourni plus tard
```

---

# 2. Correction du périmètre runtime

Le runtime actif charge actuellement :

```text
J01
J02
J03
J04
J05
J06
```

Les index actifs sont :

```text
chapter_01_modular_index.json
chapter_02_modular_index.json
chapter_03_modular_index.json
chapter_04_modular_index.json
chapter_05_modular_index.json
chapter_06_modular_index.json
```

Les anciens index J07 et J09 restent historiques et ne sont pas chargés par le runtime actuel.

Conséquence documentaire :

- J01–J04 constituent l’ouverture active ;
- J05–J06 constituent déjà une première tranche active de l’acte II ;
- J07–J08 ne sont pas encore jouables ;
- les cartes J05–J08 doivent donc préserver les bonnes briques de J05–J06 au lieu de supposer une page blanche.

---

# 3. Méthode d’audit

Chaque journée et scène est classée selon les catégories suivantes.

## `COMPATIBLE`

La fonction, le personnage, le temps, les choix et la conséquence peuvent rester tels quels, hors enrichissement visuel et mise à jour mineure de métadonnées.

## `ADAPTABLE`

Le noyau est bon, mais une partie doit être corrigée :

- formulation ;
- chronologie ;
- origine d’image ;
- source sequence ;
- état écrit ;
- intensité ;
- position dans le calendrier ;
- nombre de visuels.

## `RELOCATE`

La scène est utile mais accomplit trop tôt ou trop tard une fonction canonique. Elle doit être déplacée sans être reconstruite depuis zéro.

## `REWRITE`

La fonction ou la logique contredit le canon actuel. La scène peut conserver quelques ancrages, mais son architecture doit être réécrite.

## `ARCHIVE`

La scène ou l’état ne doit plus être utilisé dans la saison active.

## Audit visuel

Pour chaque journée :

```text
contenus actifs actuels / minimum canonique
```

Un `photo_set` porté par un seul identifiant et non consultable image par image compte comme un seul contenu actif.

L’audit ne conçoit pas les images manquantes.

---

# 4. Résumé exécutif de l’audit J01–J06

| Jour | État global | Noyau conservé | Correction principale | Visuels actifs actuels |
|---|---|---|---|---|
| J01 | ADAPTABLE | Marie, retour hors ligne, Sandra choisit de rouvrir le lien | Réécrire le langage du flou autour de Sandra et préciser le contrôle de la photo | 1 / 3 |
| J02 | COMPATIBLE avec déficit visuel | urgence, accueil, séjour, arrêt du chat à la co-présence | Ajouter deux emplacements visuels ultérieurement | 1 / 3 |
| J03 | RESTRUCTURE / RELOCATE | Raphaëlle travail, écho Sandra, promesse et retour Marie | Retirer le vernissage et la première superposition de l’acte I | 0 ou 1 / 3 selon branche |
| J04 | ADAPTABLE après J03 | Pauline publique, Nico ami, foyer ordinaire | Donner une origine sociale indépendante du vernissage déplacé | 1 / 3 |
| J05 | COMPATIBLE FOUNDATION | heure concrète de Marie, alternative bornée, autonomie | Compléter la journée par un slot de continuité extérieure et trois visuels futurs | 0 / 3 |
| J06 | ADAPTABLE | scène Mathilde, agence, retour obligatoire vers Marie | Remplacer la propriété automatique Mathilde par un slot variable de continuité | 0 / 3 |

Aucune journée active ne satisfait encore entièrement le contrat visual-first du document `09`.

Cette insuffisance ne rend pas les scènes narratives mauvaises. Elle signifie que la production visuelle reste incomplète.

---

# 5. Audit détaillé J01 — Mardi

## Fonction canonique attendue

```text
couple vivant
+ retour discret de Sandra
+ Mathilde indirecte
+ aucun groupe
+ aucune route active
```

## 5.1 `chapter_01_marie_opening`

**Classification : `COMPATIBLE`**

### Raisons

- Marie possède une vie concrète à La Verrière ;
- la demande porte sur un acte réel ;
- les trois choix modifient la qualité de présence ;
- la marche et le dîner ont lieu hors téléphone ;
- Mathilde reste indirecte ;
- aucune route adulte n’est ouverte ;
- le retour final vers Marie est obligatoire.

### Éléments à conserver

- pain ;
- tomates ;
- marche de dix minutes ;
- humour pratique ;
- La Verrière ;
- Élodie ;
- acte plutôt que meilleure promesse ;
- différence entre présence et retard assumé.

### Ajustements mineurs futurs

- remplacer le nom interne `ludo` par la variable Player lorsque la couche de personnalisation sera traitée ;
- rattacher explicitement la scène à la fonction S02 / couple ordinaire et à la préparation de S08 ;
- conserver les trois postures, sans score.

## 5.2 Beats hors ligne Marie

**Classification : `COMPATIBLE`**

### Raisons

- ils paient immédiatement l’engagement ;
- ils arrêtent le téléphone lorsque les personnages se rejoignent ;
- ils différencient présence et retard ;
- ils ferment la journée sur la vie commune.

### Règle

Ne pas remplacer ces beats par une conversation plus longue.

## 5.3 `chapter_01_sandra_trace`

**Classification : `ADAPTABLE — réécriture ciblée obligatoire`**

### Noyau à conserver

- Sandra initie ;
- elle revient après son poste ;
- la photo vient du dernier déjeuner ;
- SentryCore et le ticket fantôme existent ;
- Player dispose de trois lectures ;
- Sandra ferme elle-même la fenêtre ;
- l’échange reste léger et sans route active.

### Contradictions actuelles

Le texte fait encore du flou son moteur principal :

```text
juste ratée
photo floue
comme si elle allait devenir nette
elle ne deviendra pas nette
```

Le canon actuel exige que le moteur soit :

```text
Sandra a revu la photo
→ elle l’a conservée
→ elle choisit la version qu’elle renvoie
→ Player lit le choix, pas seulement l’imperfection
```

### Origine canonique à intégrer

- photo prise avec l’accord de Sandra ;
- appareil appartenant à Sandra ;
- Player peut avoir déclenché sous sa direction ;
- Sandra a revu le cliché ;
- elle ne l’a pas publié ;
- elle a choisi de le garder ;
- elle sélectionne ou recadre la version envoyée.

### Axe du vrai choix

Les trois réponses doivent différencier :

1. reconnaître le choix de conservation ;
2. reconnaître Sandra avec précision sans s’approprier l’image ;
3. répondre prudemment sans forcer une signification.

### À retirer

- toute idée que Sandra aime principalement parce que la photo est floue ;
- toute idée que l’image cherche symboliquement à devenir nette ;
- toute ambiguïté sur la sauvegarde automatique par Player.

### État de sortie

```text
Sandra a choisi de renvoyer une représentation déjà validée.
Player a montré comment il lit ce geste.
Aucun droit futur sur une autre image n’est créé.
```

## 5.4 Audit visuel J01

```text
actif : 1 / 3
```

Actif :

- photographie du déjeuner Sandra.

Manquent :

- deux emplacements visuels centrés personnage.

Le document ne définit pas leur conception.

### Métadonnées Sandra à corriger

La métadonnée actuelle `ancienne photo imparfaite` peut rester, mais doit préciser :

- accord ;
- appareil ;
- revue ;
- sélection ;
- audience Player ;
- sauvegarde non automatiquement autorisée.

---

# 6. Audit détaillé J02 — Mercredi

## Fonction canonique attendue

```text
urgence concrète
→ Marie propose l’accueil
→ Player choisit sa participation
→ Mathilde arrive
→ le foyer change
```

## 6.1 `chapter_02_marie_make_room`

**Classification : `COMPATIBLE`**

### Forces

- dégât des eaux précis ;
- Marie agit avant Player ;
- l’urgence ne devient pas une opportunité sexuelle ;
- trois qualités de participation ;
- aucune possibilité artificielle de refuser un lit à Mathilde ;
- Marie reste propriétaire de sa décision familiale.

### État à conserver

```text
qualité de participation de Player à l’accueil
```

Ne pas transformer cet état en score Mathilde.

## 6.2 `chapter_02_marie_arrival_trace`

**Classification : `COMPATIBLE`**

### Forces

- trace sans faux choix ;
- origine de la photo claire ;
- Marie et Mathilde sont physiquement au foyer ;
- Player est encore absent ;
- la durée du séjour est nommée ;
- la photographie a une fonction logistique.

### Ajustement futur

Le mot `preuve` dans le message peut rester humoristique, mais la métadonnée ne doit pas classer l’image comme preuve de route.

## 6.3 `chapter_02_mathilde_arrival`

**Classification : `COMPATIBLE`**

### Forces

- Mathilde répond à la photographie sans la sexualiser ;
- voix précise et professionnelle ;
- trois postures d’accueil ;
- arrêt du chat lors du retour de Player ;
- installation terminée hors téléphone ;
- accès domestique R1 seulement.

### Garde-fous

- la plaisanterie sur les sacs ne doit pas devenir son identité entière ;
- le logement ne devient jamais permission ;
- la présence de Marie reste structurelle.

## 6.4 Audit visuel J02

```text
actif : 1 / 3
```

Actif :

- arrivée pratique de Mathilde.

Manquent :

- deux emplacements visuels centrés personnage.

Aucune conception n’est imposée ici.

---

# 7. Audit détaillé J03 — Jeudi

## Fonction canonique attendue

```text
Raphaëlle existe au travail
+ Sandra peut avoir un écho
+ la journée revient vers Marie
+ aucune superposition majeure
+ aucune route R2
```

## 7.1 `chapter_03_raphaelle_blue_folder`

**Classification : `COMPATIBLE`**

### Forces

- rapport de pairs ;
- UX et accessibilité ;
- correction concrète ;
- trois postures ;
- Raphaëlle ne diagnostique pas le couple ;
- aucun accès créatif prématuré.

### À conserver

Cette scène reste le pivot principal de J03.

## 7.2 `chapter_03_sandra_continuity`

**Classification : `COMPATIBLE`**

### Forces

- écho court ;
- SentryCore ;
- horaires plausibles ;
- aucun nouveau visuel ;
- aucune promesse ;
- possibilité d’expiration.

### Règle

Cette scène ne doit pas être utilisée pour compenser l’insuffisance visuelle de J01.

## 7.3 `chapter_03_marie_event_offer`

**Classification : `RELOCATE`**

### Problème

La scène ouvre dès J03 :

- un événement La Verrière ;
- un choix topologique fort ;
- une promesse horaire ;
- une compétition avec travail ou foyer.

Ces fonctions appartiennent désormais aux actes II–III.

### Destination recommandée

- noyau de demande et de présence : adaptation possible en J05 ;
- événement social et visibilité : adaptation principale en J09 ;
- superposition et promesse : adaptation en J08.

La scène ne doit plus rester entière en J03.

## 7.4 `chapter_03_marie_event_joined`

**Classification : `RELOCATE J09`**

### Raisons

- excellente scène SAME_VENUE_LOGISTICS ;
- montre Marie dans son monde ;
- mesure la qualité de présence ;
- produit une image La Verrière ;
- correspond à S15 plus qu’à l’ouverture.

### À conserver

- rallonge noire ;
- salle bruyante ;
- aide réelle ;
- différence entre être venu et être présent ;
- origine Élodie de l’image.

## 7.5 `chapter_03_mathilde_home_charger`

**Classification : `RELOCATE J05–J06`**

### Raisons

- excellente scène domestique ordinaire ;
- arrêt du chat à la co-présence ;
- aucune intention sexuelle ;
- fonction compatible avec S10.

Elle ne doit pas être mise en concurrence avec La Verrière dès J03.

Elle devient un candidat de première continuité dans J05 ou J06.

## 7.6 `chapter_03_raphaelle_late_review`

**Classification : `RELOCATE J08`**

### Raisons

- très bonne architecture d’obligation ;
- promesse tenue, amendée ou ratée ;
- Raphaëlle ne retient pas Player ;
- la scène représente exactement une superposition fondée sur des engagements.

Elle doit devenir une variante possible de S14, lorsque la promesse envers Marie a réellement été construite auparavant.

## 7.7 `chapter_03_marie_event_return`

**Classification : `RELOCATE / SPLIT`**

### Noyau à conserver

- conséquence obligatoire ;
- aucune annulation par un nouveau choix topologique ;
- Marie distingue présence, amendement et absence ;
- plusieurs contextes possibles.

### Destination

- retour après S14 : J08 ;
- retour après visibilité sociale : J09 ;
- certaines variantes domestiques peuvent nourrir J06.

La scène doit être divisée par fonction plutôt que conservée comme réponse universelle à trois branches précoces.

## 7.8 Audit visuel J03

```text
actif selon branche : 0 ou 1 / 3
```

L’unique contenu actif est lié à la branche où Player rejoint Marie.

Les autres branches peuvent terminer la journée sans contenu visuel actif propre.

Le futur J03 doit disposer de trois emplacements indépendants de la topologie, sans que ce document les conçoive.

---

# 8. Audit détaillé J04 — Vendredi

## Fonction canonique attendue

```text
Pauline et Bastien existent dans une vie officielle
+ Nico redevient un ami réel
+ le foyer confirme son nouveau rythme
+ l’ouverture se ferme sans route adulte
```

## 8.1 `chapter_04_pauline_public_photo_relay`

**Classification : `ADAPTABLE`**

### Forces

- Pauline maîtrise une image publique légitime ;
- l’audience est connue ;
- Bastien reste visible ;
- aucune version privée ;
- Player peut renvoyer la décision à Marie.

### Problème

La scène dépend du vernissage déplacé hors de J03.

### Correction

Elle doit recevoir une origine sociale indépendante et déjà légitime.

Deux possibilités canoniques :

- un événement antérieur à l’ouverture mais connu du groupe ;
- une interaction sociale réelle ayant lieu dans J04 avant le relais.

Le document ne choisit pas le contenu visuel final.

## 8.2 `chapter_04_nico_saved_seat_followup`

**Classification : `ADAPTABLE`**

### Forces

- Nico varie selon ce qu’il sait réellement ;
- l’amitié existe avant l’alibi ;
- son intérêt pour Marie reste social ;
- il apprend le séjour Mathilde sans le sexualiser ;
- aucune ambiguïté avec Player.

### Problème

Le suivi repose sur l’événement déplacé de J03.

### Correction

Le noyau `place gardée à L’Annexe` peut devenir une invitation ou un souvenir récent autonome dans J04.

## 8.3 `chapter_04_marie_household_report`

**Classification : `COMPATIBLE`**

## 8.4 `chapter_04_mathilde_bathroom_correction`

**Classification : `COMPATIBLE`**

### Fonction commune

Ces deux échos ferment l’ouverture par une friction domestique légère sans faire progresser Mathilde.

## 8.5 Beat final du foyer

**Classification : `COMPATIBLE`**

### À conserver

- retour hors téléphone ;
- bureau transformé ;
- rythme à trois ;
- absence de discours ;
- flag de fermeture de l’ouverture.

## 8.6 Audit visuel J04

```text
actif : 1 / 3
```

Le set public est actuellement porté par un seul identifiant et un seul asset. Il compte donc comme un contenu, même s’il représente trois versions dans le texte.

Manquent :

- deux emplacements visuels.

Aucune conception d’image n’est définie.

---

# 9. Audit détaillé J05 — Samedi

## 9.1 `chapter_05_marie_shared_hour`

**Classification : `COMPATIBLE FOUNDATION`**

### Forces

- Marie possède déjà sa journée ;
- elle propose une heure bornée ;
- Player peut rejoindre, proposer une alternative précise ou la laisser avancer seule ;
- les engagements promis sont payés hors téléphone ;
- l’autonomie de Marie existe sans punition théâtrale ;
- la scène correspond au noyau de S08 : être présent avant que l’extérieur ne devienne le seul moteur du regard.

### Source sequence

```text
S08 — adaptation de fonction
```

Les ancrages diffèrent de la version robe / miroir, mais la fonction stable est conservée :

```text
Marie offre une place réelle dans sa vie en mouvement.
Player agit, amende ou laisse l’occasion vivre sans lui.
```

### État de sortie à conserver

- temps partagé payé ;
- alternative payée ;
- ou Marie a vécu l’heure seule et un retour reste dû.

## 9.2 Limite actuelle

J05 ne contient qu’une scène de couple et aucun contenu visuel actif.

Elle est une excellente scène, mais pas encore une journée canonique complète.

## 9.3 Audit visuel J05

```text
actif : 0 / 3
```

Trois emplacements devront être fournis plus tard.

Le document définit seulement leurs fonctions :

1. présence ou autonomie de Marie ;
2. résultat de l’heure ou de l’alternative ;
3. première continuité extérieure sélectionnée pour la journée.

---

# 10. Audit détaillé J06 — Dimanche

## 10.1 `chapter_06_mathilde_morning_afterglow`

**Classification : `ADAPTABLE — candidat valide, propriété automatique invalide`**

### Forces

- le moment physique est terminé avant le chat ;
- Mathilde rappelle que sa tenue est ordinaire ;
- Player peut reconnaître, plaisanter ou restaurer la distance ;
- aucune tenue ne vaut permission ;
- Mathilde conserve son agence.

### Problème

Le runtime actuel fait de Mathilde l’unique candidate de la première répétition et peut la déclarer propriétaire R2.

Le canon `11` exige :

- plusieurs continuités possibles ;
- aucune route dominante automatique ;
- un seul pivot sélectionné selon l’histoire réelle ;
- possibilité d’aucune progression extérieure.

### Nouvelle fonction

Cette scène devient :

```text
candidat Mathilde de J05 ou J06
```

Elle ne doit pas être automatiquement proposée dans toutes les parties.

Elle ne doit pas écrire seule un statut de propriétaire de vague.

### Intensité

La scène reste :

```text
regard reconnu
pas intention choisie
pas disponibilité sexuelle
```

## 10.2 `chapter_06_marie_concrete_return`

**Classification : `COMPATIBLE`**

### Forces

- retour Marie obligatoire ;
- chaleur lorsque le temps a été payé ;
- acte immédiat, acte borné ou non-réparation honnête ;
- le couple ne change pas de mode d’un seul clic ;
- les conséquences sont liées aux actes précédents.

### Ajustement

Les conditions ne doivent plus dépendre uniquement du foreground Mathilde. Elles doivent lire la continuité extérieure réellement sélectionnée dans J05–J06.

## 10.3 Candidate pool et tickets

**Classification : `NEEDS_RECONCILIATION`**

Les éléments suivants ne deviennent pas une autorité narrative :

```text
external_ticket_limit
wave_id
first_repeat_weekend_household_a
unique owner R2
```

Ils peuvent éventuellement survivre comme détails techniques internes si :

- ils ne sont jamais visibles ;
- ils ne remplacent pas l’éligibilité narrative ;
- ils ne favorisent pas Mathilde par défaut ;
- ils ne généralisent pas un moteur avant validation des scènes.

## 10.4 Audit visuel J06

```text
actif : 0 / 3
```

Trois emplacements devront être fournis plus tard.

Fonctions seulement :

1. propriétaire de la continuité sélectionnée ;
2. conséquence ou autonomie de la continuité non sélectionnée ;
3. retour Marie / couple.

---

# 11. Synthèse scène par scène

| Scène | Classification | Destination |
|---|---|---|
| J01 Marie opening | COMPATIBLE | J01 |
| J01 Sandra trace | ADAPTABLE | J01, réécriture ciblée |
| J01 Marie offline beats | COMPATIBLE | J01 |
| J02 Marie make room | COMPATIBLE | J02 |
| J02 arrival trace | COMPATIBLE | J02 |
| J02 Mathilde arrival | COMPATIBLE | J02 |
| J03 Raphaëlle blue folder | COMPATIBLE | J03 |
| J03 Sandra continuity | COMPATIBLE | J03 |
| J03 Marie event offer | RELOCATE | J05 / J08 / J09 selon fonction |
| J03 Marie event joined | RELOCATE | J09 |
| J03 Mathilde charger | RELOCATE | J05 ou J06 |
| J03 Raphaëlle late review | RELOCATE | J08 |
| J03 Marie event return | SPLIT / RELOCATE | J08 / J09 / J06 |
| J04 Pauline public relay | ADAPTABLE | J04 avec nouvelle origine |
| J04 Nico saved seat | ADAPTABLE | J04 avec contexte autonome |
| J04 household echoes | COMPATIBLE | J04 |
| J04 household close | COMPATIBLE | J04 |
| J05 Marie shared hour | COMPATIBLE FOUNDATION | J05 |
| J06 Mathilde afterglow | ADAPTABLE CANDIDATE | J05 ou J06 |
| J06 Marie return | COMPATIBLE | J06 |
| J06 candidate pool | NEEDS_RECONCILIATION | runtime futur minimal |

Aucune scène active n’est classée `ARCHIVE` dans cette tranche.

Le travail consiste principalement à déplacer et réconcilier, pas à jeter.

---

# 12. Architecture canonique détaillée J05–J08

## Vue d’ensemble

```text
J05 — Marie possède le pivot ; une première continuité extérieure peut apparaître
J06 — une continuité extérieure devient le pivot, puis retour obligatoire vers Marie
J07 — Nico reçoit la confidence ; Pauline ou Raphaëlle obtient un accès secondaire
J08 — deux engagements incompatibles créent la première superposition
```

À la fin de J08 :

- au moins deux attentes existent ;
- au moins une obligation est due ou payée ;
- aucune route extérieure n’est définitivement verrouillée ;
- aucune scène adulte complète n’est ouverte ;
- Marie sait si Player agit ou accumule des formulations ;
- le temps est devenu une ressource relationnelle lisible.

---

# 13. Carte détaillée J05 — Samedi — Une heure avant les autres

## Identité

```text
day_id: J05
day_type: NORMAL
act: II
principal_relationship: Marie / Player
main_sequence: S08 adaptation
runtime_status: ACTIVE_PARTIAL
```

## Question dramatique

> Player sait-il faire une place réelle à Marie lorsqu’elle ne l’attend pas immobile ?

## Pivot principal

`chapter_05_marie_shared_hour`

Cette scène reste le pivot.

## Fenêtre A — Matin — Marie

### Fonction

- Marie avance déjà dans sa journée ;
- Player reçoit une invitation bornée ;
- les trois réponses sont des actions complètes ;
- le résultat se paie hors téléphone.

### Choix

1. rejoindre maintenant ;
2. proposer une alternative précise ;
3. laisser Marie vivre son heure et accepter qu’un retour reste dû.

### États

```text
marie_shared_hour_paid
marie_shared_time_paid
marie_moves_without_player
```

Ces états doivent être interprétés comme faits, pas comme score de route.

## Fenêtre B — Après-midi ou début de soirée — Slot A

Une seule première continuité extérieure peut apparaître.

### Candidat Sandra — S09 faible

**Fonction :** Sandra matérialise ou sélectionne une trace sans l’envoyer automatiquement.

**Éligibilité :**

- J01 Sandra vue ;
- aucune violation ;
- cooldown respecté ;
- horaire compatible.

**Sorties :**

- continuité ouverte ;
- image gardée par Sandra ;
- ou silence choisi.

### Candidat Mathilde — S10 ordinaire

**Matériau réutilisable :** `chapter_03_mathilde_home_charger`.

**Fonction :** compétence et familiarité domestique, sans intention.

**Éligibilité :**

- séjour actif ;
- présence physique crédible ;
- scène non déjà utilisée ;
- aucun foreground Mathilde récent.

**Sorties :**

- aide ;
- jeu familial ;
- distance ;
- aucune route automatique.

### Candidat Raphaëlle — S12 faible

**Fonction :** un détail créatif devient visible sans révéler tout le compte.

**Éligibilité :**

- R1 professionnel établi ;
- détail de fabrication déjà semé ;
- Raphaëlle choisit l’audience ;
- aucun prétexte de travail artificiel pendant le week-end.

**Sorties :**

- accès créatif futur ;
- détail gardé privé ;
- ou frontière professionnelle maintenue.

## Règle de sélection

Le candidat est choisi selon :

1. conséquences dues ;
2. éligibilité ;
3. continuité la moins récemment foreground ;
4. cohérence du temps ;
5. aucune compensation automatique après refus Marie.

Un refus ou une absence de candidat produit une respiration, pas le remplacement immédiat par une autre route.

## Visuels J05

```text
minimum: 3
asset_design: deferred_to_user_comfyui
```

Fonctions :

1. Marie / heure partagée ou autonomie ;
2. conséquence de la réponse à Marie ;
3. continuité extérieure sélectionnée ou équivalent de respiration centré personnage.

## Sortie J05

- Marie a vécu son heure ;
- Player a payé, programmé ou laissé un retour dû ;
- zéro ou une continuité extérieure est active ;
- aucune route dominante.

---

# 14. Carte détaillée J06 — Dimanche — La première attention répétée

## Identité

```text
day_id: J06
day_type: NORMAL_OR_CONSEQUENCE
act: II
principal_relationship: variable external continuity
required_return: Marie
runtime_status: ACTIVE_PARTIAL
```

## Question dramatique

> Une attention extérieure devient-elle une continuité, une limite ou une chose que Player laisse passer ?

## Fenêtre A — Matin — Slot B

Le pivot est choisi parmi les continuités non foreground en J05.

### Mathilde

Matériau : `chapter_06_mathilde_morning_afterglow`.

Fonction : regard remarqué, tenue ordinaire, agence maintenue.

La scène reste en dessous de l’intention choisie.

### Sandra

Fonction : Sandra revient sur la matérialité ou la sélection d’une image sans offrir un nouveau fichier comme récompense.

Axe :

- Player comprend le choix ;
- Player demande trop ;
- Player respecte la limite.

### Pauline

Fonction : première compétence d’audience publique ou préparation de S11, sans cadrage privé automatique.

### Raphaëlle

Fonction : accès limité à un détail créatif ou au compte sous pseudonyme, selon l’état J05.

## Absence de candidat

La journée peut ne produire aucune progression extérieure.

Dans ce cas :

- la vie ordinaire continue ;
- Marie reste le pivot du soir ;
- aucun ticket narratif n’est « perdu » ;
- aucune autre femme n’est injectée artificiellement.

## Fenêtre B — Soir — Retour Marie obligatoire

Matériau : `chapter_06_marie_concrete_return`.

### Fonction

- payer J05 ;
- intégrer la continuité extérieure réelle ;
- distinguer acte immédiat, acte borné et non-réparation honnête.

### Réconciliation des conditions

Les conditions doivent lire :

```text
selected_external_continuity
marie_shared_hour_paid
marie_shared_time_paid
marie_moves_without_player
active_obligations
```

Elles ne doivent pas supposer que Mathilde est la seule route possible.

## Visuels J06

```text
minimum: 3
asset_design: deferred_to_user_comfyui
```

Fonctions :

1. continuité extérieure foreground ou autonomie ;
2. conséquence / limite de cette continuité ;
3. retour Marie.

## Sortie J06

- une continuité a progressé, refroidi ou expiré ;
- Marie a reçu un acte, une échéance ou une vérité ;
- aucune propriété R2 automatique ;
- la journée ouvre la possibilité d’une confidence J07.

---

# 15. Carte détaillée J07 — Lundi — Ce qui ne se dit qu’à une personne

## Identité

```text
day_id: J07
day_type: NORMAL
act: II
principal_relationship: Nico / Player
main_sequence: S13
runtime_status: NOT_IMPLEMENTED
```

## Question dramatique

> Player cherche-t-il auprès de Nico une écoute, une permission ou un complice ?

## Fenêtre A — Matin / journée de travail — Écho secondaire

Une ligne secondaire peut apparaître avant Nico :

- Pauline S11 si le set public J04 existe et si aucune différence privée n’a encore été ouverte ;
- Raphaëlle S12 si l’accès créatif n’a pas été traité ;
- Sandra ou Mathilde seulement comme conséquence courte, pas comme progression majeure.

Cette fenêtre ne possède pas le pivot de la journée.

## Fenêtre B — Avant service ou fin de salle — S13 Nico

### Ancrages obligatoires

- L’Annexe ;
- café avant service ou salle qui se vide ;
- amitié réelle ;
- attirance de Nico pour Marie ou Mathilde selon ce qu’il a réellement vu ;
- humour qui cesse au moment où la confidence devient concrète.

### Axe de décision

Les choix ne doivent pas être :

```text
parler de Sandra
parler de Mathilde
parler de Pauline
```

Cela deviendrait un menu de routes.

Les trois postures sont :

1. reconnaître une contradiction précise ;
2. demander ce que Nico a perçu sans solliciter une permission ;
3. rester vague et conserver la distance.

Le contenu exact de la confidence dépend des faits actifs.

### Agence de Nico

Nico peut :

- répondre franchement ;
- signaler son propre intérêt ;
- refuser d’être utilisé comme alibi ;
- rappeler que la femme concernée décide ;
- garder la confidence sans promettre de couvrir.

### État créé

```text
nico_knows_player_contradiction
```

Cet état doit préciser le fait connu. Il ne doit pas devenir `Nico sait tout`.

## Fenêtre C — Respiration

Retour bref à la vie ordinaire :

- foyer ;
- travail ;
- message non urgent ;
- absence assumée.

## Visuels J07

```text
minimum: 3
asset_design: deferred_to_user_comfyui
```

Fonctions :

1. ligne secondaire éventuelle ;
2. Nico / L’Annexe / amitié ;
3. vie ordinaire ou retour Marie.

## Sortie J07

- Nico connaît une contradiction limitée ;
- Pauline ou Raphaëlle possède éventuellement un accès futur ;
- au moins deux attentes sont désormais capables d’entrer en conflit ;
- aucune femme n’est autorisée par la confidence.

---

# 16. Carte détaillée J08 — Mardi — La première superposition

## Identité

```text
day_id: J08
day_type: RICH_CONSEQUENCE
act: II_END
principal_function: time_becomes_choice
main_sequence: S14
runtime_status: NOT_IMPLEMENTED
```

## Question dramatique

> Que fait Player lorsque deux engagements réels ne peuvent plus être tenus exactement comme promis ?

## Conditions d’entrée

La journée exige :

- au moins deux attentes créées en J05–J07 ;
- deux personnes ou responsabilités réellement concernées ;
- une incompatibilité de temps ou de lieu ;
- au moins une possibilité d’amendement honnête.

Aucune superposition ne doit être inventée entre une obligation réelle et une simple notification sans enjeu.

## Sources possibles d’obligations

### Marie

- heure ou retour reprogrammé ;
- aide à La Verrière ;
- présence au foyer ;
- rendez-vous précis.

### Sandra

- fenêtre liée à un poste ;
- réponse attendue ;
- rendez-vous ou appel borné ;
- image qui exige clarification.

### Mathilde

- aide pratique ;
- retour lié au foyer ;
- assurance ;
- engagement logistique.

### Pauline / Bastien

- sélection sociale ;
- repas ;
- présence de groupe ;
- retour sur une audience.

### Raphaëlle

- dossier à terminer ;
- revue d’accessibilité ;
- problème créatif réel ;
- promesse de réponse.

### Nico

- place gardée ;
- rencontre avant service ;
- confidence à continuer ;
- demande d’avis précise.

## Matériau réutilisable

`chapter_03_raphaelle_late_review` constitue une excellente variante de S14 lorsque :

- une promesse Marie existe ;
- un travail réel doit être terminé ;
- Raphaëlle ne retient pas Player ;
- Player peut tenir, amender ou laisser dériver.

Certaines variantes de `chapter_03_marie_event_return` peuvent payer la conséquence.

## Structure de choix

Les choix expriment des actes, pas des routes.

### Choix A — Payer l’engagement le plus ancien

Player agit immédiatement pour A et prévient B avec une modification précise.

### Choix B — Payer l’engagement le plus urgent

Player agit pour B et assume le coût envers A.

### Choix C — Refuser de choisir clairement

Player reste vague, tente de préserver les deux ou laisse le temps décider.

Cette troisième posture ne doit pas produire un succès caché.

## Mutations

La personne différée peut :

- agir seule ;
- annuler ;
- déplacer le rendez-vous ;
- demander à quelqu’un d’autre ;
- retirer une image ;
- noter la différence ;
- fermer une future occasion.

## Retour Marie

Après une superposition qui implique ou affecte Marie, un retour est obligatoire.

Il doit distinguer :

- promesse tenue ;
- promesse amendée ;
- promesse ratée ;
- choix extérieur assumé ;
- absence de décision.

## Visuels J08

```text
minimum: 3
asset_design: deferred_to_user_comfyui
```

Fonctions :

1. engagement choisi ;
2. personne ou responsabilité différée agissant indépendamment ;
3. retour ou conséquence Marie.

## Sortie J08

- au moins une obligation payée, amendée ou échouée ;
- une relation a gagné du temps au détriment d’une autre ;
- une conséquence est active ;
- le joueur comprend que les lignes privées ont un coût ;
- acte II terminé ;
- aucune route extérieure définitivement verrouillée.

---

# 17. Matrice d’éligibilité J05–J08

| Personnage | J05 | J06 | J07 | J08 |
|---|---|---|---|---|
| Marie | pivot obligatoire | retour obligatoire | présence ou conséquence | obligation / retour possible |
| Sandra | candidat A | candidat B | conséquence courte | obligation possible |
| Mathilde | candidat A | candidat B actuel adaptable | conséquence courte | obligation domestique possible |
| Pauline | contexte ou absence | candidat B public | accès secondaire S11 | engagement social possible |
| Raphaëlle | candidat A créatif faible | candidat B | accès secondaire S12 | travail / promesse possible |
| Nico | absence ou écho | absence / vie propre | pivot S13 | engagement possible |

La matrice ne garantit aucune scène.

Elle définit les fenêtres compatibles.

---

# 18. Règles de sélection J05–J08

1. Vérifier les conséquences dues.
2. Vérifier les hard requirements.
3. Écarter les hard exclusions.
4. Respecter le cooldown.
5. Préserver Marie.
6. Ne sélectionner qu’une progression extérieure dominante par journée.
7. Ne pas compenser un refus par une autre route immédiate.
8. Autoriser aucune progression extérieure.
9. Préserver la vie propre des personnages absents.
10. Écrire la conséquence avant d’ouvrir la scène suivante.

## Interdit

Le runtime ne doit pas demander :

```text
Quel personnage doit gagner le ticket de route aujourd’hui ?
```

Il doit demander :

```text
Quelle scène est réellement éligible,
quelle conséquence est due,
et quelle relation possède déjà une continuité crédible ?
```

---

# 19. États narratifs minimaux recommandés

Ce document n’impose pas leur forme technique.

## Marie

- temps partagé payé ;
- alternative bornée payée ;
- retour dû ;
- présence active ;
- dérive honnêtement reconnue.

## Sandra

- continuité vue ;
- représentation sélectionnée par Sandra ;
- limite respectée ;
- réponse due ;
- image retirée.

## Mathilde

- séjour actif ;
- scène domestique ordinaire vue ;
- regard reconnu ;
- distance respectée ;
- aucune intention encore déclarée.

## Pauline

- vie officielle établie ;
- image publique existante ;
- différence d’audience non encore ouverte ou ouverte ;
- Bastien visible.

## Raphaëlle

- R1 professionnel ;
- détail créatif semé ;
- accès créatif limité ;
- obligation professionnelle réelle.

## Nico

- amitié R1 ;
- séjour Mathilde connu ;
- contradiction précise connue ;
- aucun alibi promis automatiquement.

## Anti-états

Ne pas créer :

```text
route_owner
woman_selected
external_ticket_winner
guilt_score
secret_pressure_score
```

---

# 20. Contrat de production visuelle différée

Les images seront produites plus tard par Ludovic.

Pour chaque journée, la future intégration devra seulement fournir :

```text
3 content_ids distincts minimum
```

Chaque contenu devra ensuite recevoir les métadonnées du document `09`.

Ce document ne fournit aucun prompt.

## Audit actuel

```text
J01 : 1 / 3
J02 : 1 / 3
J03 : 0 ou 1 / 3
J04 : 1 / 3
J05 : 0 / 3
J06 : 0 / 3
J07 : non implémenté
J08 : non implémenté
```

## Règle de développement

L’absence actuelle d’asset ne doit pas bloquer l’écriture des cartes de scènes.

Mais une journée ne pourra pas être déclarée visual-first finalisée avant réception et intégration des trois contenus.

---

# 21. Ordre recommandé des futurs travaux

## Tranche 12A — Réconciliation documentaire

- intégrer le présent audit ;
- corriger le statut runtime J01–J06 ;
- ne modifier aucun JSON.

## Tranche narrative suivante

1. réécrire Sandra J01 ;
2. restructurer J03 ;
3. réconcilier J04 avec la nouvelle chronologie ;
4. conserver J05 ;
5. transformer J06 en slot variable ;
6. écrire J07 ;
7. écrire J08.

## Tranche visuelle

Après fourniture des images par Ludovic :

- ajouter les content IDs ;
- compléter les métadonnées ;
- relier les déverrouillages ;
- valider trois contenus par journée ;
- vérifier la galerie.

## Tranche runtime

Seulement après validation narrative :

- patchs courts ;
- pas de moteur générique massif ;
- réutilisation des scènes compatibles ;
- tests par journée ;
- sauvegardes préservées.

---

# 22. Critères d’acceptation de la tranche J01–J08

- [ ] J01 Sandra parle de sélection et de contrôle, pas de flou comme identité ;
- [ ] J02 reste une urgence familiale non sexuelle ;
- [ ] J03 ne contient plus la première grande superposition ;
- [ ] J04 introduit Pauline/Bastien et Nico sans dépendance incohérente ;
- [ ] J05 conserve l’heure Marie ;
- [ ] J05 peut ouvrir zéro ou une continuité extérieure ;
- [ ] J06 ne favorise pas automatiquement Mathilde ;
- [ ] J06 revient toujours vers Marie ;
- [ ] J07 ne devient pas un menu de routes dans la confidence Nico ;
- [ ] J08 repose sur deux engagements réels ;
- [ ] aucune scène adulte complète avant la fin de J08 ;
- [ ] chaque refus possède une mutation ;
- [ ] les scènes physiquement partagées arrêtent le chat ;
- [ ] aucun score ou ticket n’est visible ;
- [ ] chaque journée prévoit trois slots visuels sans en imposer la conception ;
- [ ] J07–J08 ne sont pas décrits comme déjà jouables.

---

# 23. Risques et effets de bord

## Déplacement du vernissage

Les flags et conséquences actuellement reliés à J03 devront être migrés ou remplacés lors du futur patch runtime.

Risque : anciennes sauvegardes J03–J06.

Réponse : plan de migration séparé avant modification.

## Pauline J04

Son set public doit recevoir une nouvelle origine ou être déplacé.

Risque : disparition de son unique visuel actif.

Réponse : ne rien supprimer avant réception du remplacement narratif et visuel.

## Candidate pool J06

Le système technique peut être utilisé par d’autres tests.

Risque : suppression prématurée d’un mécanisme stable.

Réponse : ne pas le retirer dans le document ; le marquer `NEEDS_RECONCILIATION` et décider au moment du patch minimal.

## J05–J06 déjà jouables

La réécriture future ne doit pas supposer que ces jours sont neufs.

Risque : casser progression et sauvegarde.

Réponse : audit des flags, des transitions et des tests avant patch.

## Charge visuelle

Le déficit actuel est important.

Risque : confondre absence d’image avec défaut de scène.

Réponse : dissocier validation narrative et validation visual-first finale.

---

# 24. Résumé canonique

Le runtime actif couvre J01 à J06.

J01 possède une bonne structure de couple, mais Sandra doit être réécrite autour de la représentation choisie plutôt que du flou.

J02 est narrativement compatible et installe correctement Mathilde.

J03 contient de bonnes scènes, mais le vernissage, la superposition et plusieurs conséquences arrivent trop tôt. Ces briques doivent être déplacées vers J08–J09.

J04 conserve Pauline publique, Nico ami et le foyer ordinaire, mais doit recevoir une chronologie indépendante du vernissage déplacé.

J05 est une excellente fondation centrée sur l’heure réelle offerte par Marie.

J06 conserve une bonne scène Mathilde et un bon retour Marie, mais Mathilde ne doit plus être l’unique propriétaire automatique de la première répétition.

J07 crée une confidence précise avec Nico sans ouvrir un menu de routes.

J08 transforme deux engagements réels en première superposition.

Les visuels ne sont pas conçus dans ce document.

Ils seront fournis plus tard par Ludovic via ComfyUI.

> **Le but de l’audit n’est pas de remplacer tout ce qui existe. Il est de conserver les scènes qui comprennent déjà les personnages, de déplacer celles qui arrivent trop tôt et de réécrire seulement les contradictions devenues visibles grâce à la Bible.**