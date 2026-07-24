# Réseau Intime — NAR-PROD-02 — Paquet de production Acte I / J01–J04

## 1. Statut, périmètre et autorités

### 1.1 Statut

**Catégorie : paquet de production narratif et visuel actif — documentation-only**

**Périmètre : Acte I, J01 à J04**

**Base stable de référence : `afa5d6ceeda03c5e566c5f9c35a422fdf6f0b590`**

**NAR-PROD-01 de référence : intégré à `main` au commit `afa5d6ceeda03c5e566c5f9c35a422fdf6f0b590`**

Ce document transforme le canon signé de J01–J04 en paquet de production. Il ne crée pas une seconde carte de saison et ne remplace ni la Bible Narrative, ni les canons personnages, ni les dialogues consolidés, ni les registres.

Il fixe :

- la fonction de production de chaque journée ;
- les scènes et fenêtres à servir ;
- les mutations de refus, silence, absence et limite ;
- les références exactes des dialogues existants, sans les réécrire ;
- les faits, traces, promesses et connaissances à préserver ;
- treize briefs visuels principaux ;
- quinze fichiers visuels sources, dont les trois frames enfants obligatoires du set T04 ;
- zéro variante conditionnelle ;
- la distinction entre photo diégétique, type interne `SOUVENIR_IMAGE_DE_SCÈNE` et fait sans image ;
- les règles d’audience, de permanence, de sauvegarde, de transfert, de retrait et de réutilisation.

Son intégration documentaire n’autorise aucune production d’asset, aucun prompt ComfyUI définitif, aucune adaptation runtime et aucune modification narrative supplémentaire.

### 1.2 Hors périmètre absolu

Ce lot ne modifie et ne produit :

- aucune modification Git hors intégration documentaire de ce paquet et synchronisation des portails ;
- aucun JSON ;
- aucun dialogue signé ;
- aucun script Godot ;
- aucun test ;
- aucune interface ;
- aucun asset final ou provisoire ;
- aucun prompt ComfyUI définitif ;
- aucune nouvelle route, séquence, promesse, trace ou connaissance ;
- aucune apparence physique non définie dans les canons personnages.

### 1.3 Hiérarchie d’autorité

En cas de divergence, l’ordre de résolution est :

1. `docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md` ;
2. `docs/canon/dialogues/J01_J06_SOURCE_CANON_CONSOLIDE.md` ;
3. registres `TRACE`, `PROMISE`, `KNOWLEDGE` et matrice d’atteignabilité ;
4. Bible Narrative et canons complets des personnages ;
5. `docs/canon/bible/12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md`, uniquement pour la traçabilité des scènes et des réservoirs de dialogue ;
6. fichiers JSON existants, uniquement comme localisation exacte des dialogues ou preuve de l’état historique du runtime.

Le plan `12` et le runtime ne peuvent pas réintroduire une origine d’image, une scène ou une dépendance que la source consolidée a retirée.

### 1.4 Sources principales relues

- `docs/canon/bible/00_NORTH_STAR.md`
- `docs/canon/bible/04_TRAME_PRINCIPALE_ET_ACTES_SAISON_1.md`
- `docs/canon/bible/05_ROUTES_MACRO_SAISON_1.md`
- `docs/canon/bible/07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md`
- `docs/canon/bible/08_REGLES_DES_SCENES_MODULAIRES.md`
- `docs/canon/bible/09_PROGRESSION_VISUELLE_ET_PHOTOGRAPHIQUE.md`
- `docs/canon/bible/10_CARTE_CONSEQUENCES_DETTES_SECRETS_OBLIGATIONS.md`
- `docs/canon/bible/11_DISTRIBUTION_SEQUENCES_SCENES_IMAGES_CONSEQUENCES_JOURNEES.md`
- `docs/canon/bible/12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md`
- `docs/canon/dialogues/J01_J06_SOURCE_CANON_CONSOLIDE.md`
- `docs/canon/dialogues/J01_J21_TRACE_REGISTRY.md`
- `docs/canon/dialogues/J01_J21_PROMISE_REGISTRY.md`
- `docs/canon/dialogues/J01_J21_KNOWLEDGE_REGISTRY.md`
- `docs/canon/dialogues/J01_J21_REACHABILITY_MATRIX.md`
- `docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md`
- `docs/canon/dialogues/NAR_PROD_01_AUDIT_PREPARATION_PRODUCTION_SAISON_1.md`
- canons complets de Marie, Sandra, Mathilde, Pauline, Raphaëlle, Nico et Player ;
- `docs/canon/characters/SANDRA_VISUAL_REPRESENTATION_RECONCILIATION.md`
- `docs/canon/CHARACTER_VOICE_DISTINCTION_CANON.md`
- `docs/canon/TEXT_ONLY_MESSAGING_CANON.md`

### 1.5 Vocabulaire opératoire

| Terme | Définition de production |
|---|---|
| `PHOTO_DIÉGÉTIQUE` | Fichier existant dans l’univers, avec créateur, capture, sujets, audience, permanence, sauvegarde et transfert. |
| `SOUVENIR_IMAGE_DE_SCÈNE` | Type interne d’une représentation pour le joueur d’un moment vécu. Il n’existe pas comme fichier diégétique et ne crée aucun onglet ou libellé visible « Souvenir ». |
| `TRACE` | Objet narratif enregistré pouvant être revu, retiré, découvert ou recontextualisé selon son registre. |
| `FACT_RECORD` | Fait narratif sans fichier image. Il ne doit jamais être transformé automatiquement en photo. |
| `contenu principal` | Unité narrative et Galerie avec `asset_id` unique. Un `PHOTO_SET` reste un seul contenu principal même lorsqu’il exige plusieurs fichiers enfants. |
| `fichier visuel source` | Fichier image distinct à produire. Un contenu principal peut en contenir plusieurs, comme les trois frames obligatoires de T04. |
| `variante` | Asset supplémentaire requis parce que le casting ou l’audience change réellement. Une différence de ton ou de posture ne suffit pas. |

Un `SOUVENIR_IMAGE_DE_SCÈNE` peut montrer le côté d’un personnage pendant un échange à distance. Il ne signifie pas que Player a vu cette composition exacte et ne lui accorde aucune connaissance visuelle au-delà des faits établis par le dialogue ou l’action.

Dans la Galerie :

- il est éligible dans l’onglet du ou des personnages concernés ;
- un contenu multi-personnages peut être référencé dans plusieurs onglets avec le même `asset_id` ;
- cette référence croisée ne duplique jamais l’asset ;
- il reste non transférable, non découvrable et `can_share: false` ;
- aucune catégorie visible « Souvenir » n’est créée.

---

## 2. Décisions produit verrouillées

1. L’Acte I contient exactement **13 contenus principaux** :
   - J01 : 3 ;
   - J02 : 3 ;
   - J03 : 3 ;
   - J04 : 4.
2. L’Acte I exige exactement **15 fichiers visuels sources** :
   - 12 fichiers pour les 12 contenus principaux hors T04 ;
   - 3 frames enfants pour l’unique contenu principal T04.
3. Le présent paquet retient **zéro variante conditionnelle**.
4. Player reste non identifiable visuellement pendant tout l’Acte I.
5. T04 est un seul contenu narratif `PHOTO_SET`, composé obligatoirement de trois fichiers enfants. Les trois frames conservent le même casting, le même lieu, les mêmes tenues, le même créateur, la même audience et ne constituent ni trois contenus principaux ni des variantes de branche.
6. Le casting définitif de T04 est Pauline, Bastien et Marie. Player est destinataire hors cadre. Nico et Mathilde sont absents du set.
7. Les photos diégétiques suivent strictement leur créateur, leur audience, leur permanence, leur règle de sauvegarde, leur transfert et leur retrait.
8. Les images de scène utilisent le type interne `SOUVENIR_IMAGE_DE_SCÈNE` :
   - non transférables ;
   - non découvrables par un personnage ;
   - non utilisables comme preuve ;
   - `can_share: false` ;
   - sans fichier diégétique possédé par Player.
9. La Galerie ne crée aucun onglet ou libellé visible « Souvenir ». Elle distingue :
   - l’éligibilité d’une image de scène dans l’onglet du personnage concerné ;
   - le droit de revoir une photo diégétique ;
   - la possession d’un fichier ;
   - le droit de transférer ce fichier.
10. Un contenu multi-personnages peut être référencé dans plusieurs onglets Galerie avec le même `asset_id`, sans duplication d’asset.
11. Un `FACT_RECORD` reste un fait sans image.
12. Les niveaux visuels de l’Acte I restent habituellement V0–V1. Aucun contenu ne crée une permission adulte.
13. Une route refusée ou une fenêtre expirée ne retire pas le minimum visuel quotidien.
14. Aucun prompt ComfyUI définitif n’est produit dans ce document.
15. Aucun dialogue n’est réécrit.
16. Le cadrage futur doit rester compatible avec une présentation verticale centrée personnage, sans figer ici résolution, sampler, modèle, LoRA, workflow ou paramètres de génération.

---

## 3. Tableau exécutif J01–J04

| Jour | Fonction | Séquences | Pivot | Contenus principaux | Fichiers sources | Répartition type | Variantes | Verdict du paquet |
|---|---|---|---|---:|---:|---|---:|---|
| J01 | Couple vivant, regard de Player, retour discret de Sandra | S01, fonction ordinaire S02, S03 ouverture | Marie + Sandra | 3 | 3 | 1 photo / 2 images de scène | 0 | `READY` |
| J02 | Installation concrète de Mathilde et modification du foyer | S04 | Marie + Mathilde | 3 | 3 | 0 photo / 3 images de scène | 0 | `READY` |
| J03 | Raphaëlle au travail, détail créatif, retour obligatoire vers Marie | S06, écho S03 | Raphaëlle + Marie | 3 | 3 | 0 photo / 3 images de scène | 0 | `READY` |
| J04 | Pauline/Bastien publics, Nico ami, foyer stabilisé, clôture de l’ouverture | S05, S07, fermeture S01 | Réseau social + Marie | 4 | 6 | 1 photo set / 3 images de scène | 0 | `READY` |
| **Total** |  |  |  | **13** | **15** | **2 photos diégétiques / 11 images de scène** | **0** | aucun `MISSING_SPEC` |

Les corrections ciblées de revue sont intégrées :

- J02 inscrit l’adaptation future exacte supprimant `msg_wed_marie_arrival_002` et `mathilde_arrival_room_01`, sans photo diégétique ;
- J03 cartographie ligne par ligne le fragment actif issu du `SPLIT` ;
- J04 fixe le casting Pauline/Bastien/Marie, Player hors cadre, et transforme les trois versions en trois frames enfants obligatoires d’un seul `PHOTO_SET`.

---

## 4. Dépendances et progression de l’Acte I

### 4.1 Progression dramatique

```text
J01
couple réel + regard de Player + trace Sandra
→
J02
foyer physiquement modifié par Mathilde
→
J03
monde professionnel Raphaëlle + monde autonome Marie
→
J04
Pauline/Bastien et Nico deviennent des personnes sociales réelles
→
sortie Acte I
réseau actif, aucune route adulte, plusieurs continuités possibles
```

### 4.2 Dépendances obligatoires

| Origine | Création | Dépendance ultérieure |
|---|---|---|
| J01 | `fact_marie_player_couple_exists` reste central | Toutes les relations extérieures sont interprétées depuis un couple encore réel. |
| J01 | `j01_sandra_lunch_memory_soft` | Peut rester active, restreinte, retirée ou inaccessible ; peut être recontextualisée J14/J21 selon registre. |
| J01 | `marie_j01_shared_evening` | Doit être payée, amendée ou fermée J01 ; elle ne reste pas artificiellement active. |
| J02 | `fact_mathilde_stay_started` via le `FACT_RECORD` T02 `j02_mathilde_arrival_room_01` | Rend crédibles les scènes domestiques J03–J04 et les futures fenêtres Mathilde, sans photo diégétique. |
| J02 | `mathilde_j02_arrival_help` | La qualité de participation appartient au couple/foyer, pas à un score Mathilde. |
| J03 | `fact_raphaelle_professional_relationship_exists` | Autorise une future question sur sa pratique créative, pas un accès privé. |
| J03 | `fact_marie_laverriere_world_exists` | Confirme le monde autonome de Marie sans créer une photo J03. |
| J04 | `j04_pauline_bastien_public_set_01` | Établit un unique set public légitime, composé de trois frames enfants, avant toute future différence d’audience. |
| J04 | `fact_nico_friendship_exists` | Rend crédibles de futures confidences, sans les créer. |

### 4.3 État de sortie canonique de l’Acte I

```text
couple_state = BASELINE_SHARED_LIFE
mathilde_state = FAMILY_GUEST
sandra_state = DISTANT_FRIEND ou RECONNECTION_OPEN
pauline_state = PUBLIC_ONLY
raphaelle_state = PROFESSIONAL_ONLY
nico_state = ORDINARY_FRIEND
```

États interdits à la sortie J04 :

- route adulte active ;
- droit de sauvegarde générale sur les images de Sandra ;
- intention sexuelle Mathilde établie ;
- crop privé Pauline ;
- accès créatif Raphaëlle ;
- confidence ou alibi Nico ;
- contradiction dure obligatoire ;
- photographie La Verrière J03 inventée ;
- photo d’arrivée Mathilde inventée à partir du `FACT_RECORD`.

---

## 5. Paquet complet J01

### 5.1 Identité de la journée

**Titre :** Mardi — Les choses que l’on remarque

**Fonction dramatique :** établir la vie commune Marie/Player, montrer la manière dont Player regarde et réactiver Sandra par une trace concrète sans triangle explicite.

**Question joueur :** est-ce que Player choisit activement ce qui existe déjà, et sait-il lire un geste sans s’approprier ce qu’il voit ?

**État d’entrée :** couple réel, réseau encore peu actif, Sandra distante, Mathilde indirecte.

**État de sortie :** couple encore chaud et quotidien ; Sandra redevient une présence possible ; aucune route active.

### 5.2 Séquences sources

- S01 — Le réseau recommence à circuler ;
- fonction ordinaire de S02 — La Verrière avant l’ouverture des portes ;
- S03 — Le ticket fantôme et la photo du déjeuner, version d’ouverture corrigée par le canon Sandra.

### 5.3 Scènes et fenêtres

| Fenêtre | Source scène | Mode | Fonction | Statut |
|---|---|---|---|---|
| début de soirée | `chapter_01_marie_opening` / `J1_MARIE_OPENING` | `REMOTE_ASYNC`, puis beat hors téléphone | pain, tomates, marche, La Verrière, présence concrète | obligatoire |
| soirée | beats hors ligne Marie, plan `12`, §5.2 | `OFFLINE_BEAT` | payer ou muter la présence ; arrêter le chat à la réunion physique | obligatoire, muté selon posture |
| nuit | `chapter_01_sandra_trace` / `J1_SANDRA_TRACE` | `REMOTE_ASYNC` | renvoi de la photo sélectionnée ; lecture du geste ; fermeture douce | obligatoire, peut se fermer rapidement |

### 5.4 Personnages

- présents/directs : Marie, Sandra, Player ;
- indirecte : Mathilde, uniquement à travers Marie ;
- absents : Pauline, Raphaëlle, Nico, Bastien, Jeff comme acteurs de scène ;
- Jeff ne sert pas d’explication négative à Sandra ;
- aucun groupe J01.

### 5.5 Choix et postures Player

#### Marie

1. **Présence concrète** : accepte un acte et le réalise.
2. **Amendement précis** : annonce une limite ou un retard avec une alternative vérifiable.
3. **Passivité / refus** : ne promet pas vaguement ; Marie continue sans attendre.

#### Sandra

1. **Reconnaître le choix de conservation** : Player lit qu’elle a revu, gardé et sélectionné l’image.
2. **Reconnaître Sandra précisément** : remarque un détail sans réclamer de droit sur l’image.
3. **Rester prudent** : répond sans forcer le sens ; Sandra conserve la maîtrise de la fenêtre.

### 5.6 Mutations de refus, silence, absence ou limite

| Condition | Mutation | Trace / promesse | Sortie |
|---|---|---|---|
| Player refuse le temps Marie | Marie gère dîner ou marche seule ; le retour reste possible, sans scène de punition | P01 `REFUSED` | couple réel, qualité de présence mémorisée |
| Player amende précisément | activité ou horaire réduit mais réel | P01 `AMENDED` puis `PAID` si tenu | pas de dette artificielle |
| Player promet vaguement | aucune promesse n’est créée | P01 absente | Marie agit seule |
| Player répond peu à Sandra | Sandra clôt doucement | T01 reste selon contrôle Sandra | `DISTANT_FRIEND` possible |
| Player force une signification | Sandra réduit ou retire l’accès | T01 `RESTRICTED`, `REMOVED` ou `INACCESSIBLE` selon scène future | aucun nouveau visuel |
| Player respecte la limite | aucune récompense supplémentaire automatique | T01 reste dans son état légitime | `RECONNECTION_OPEN` possible |

Le minimum de trois contenus ne dépend d’aucune récompense de route.

### 5.7 Dialogues sources exacts

Les dialogues ne sont pas reproduits ici.

| Autorité / fichier | Identifiant | Usage |
|---|---|---|
| `docs/canon/dialogues/J01_J06_SOURCE_CANON_CONSOLIDE.md`, §2 | J01 Marie et Sandra | autorité sur fonction, trace, fait, absence de transfert et P01 |
| `game/data/conversations/chapter_01_marie_opening.json` | `chapter_01_marie_opening` | source exacte existante Marie ; lire sous autorité consolidée |
| `game/data/conversations/chapter_01_sandra_trace.json` | `chapter_01_sandra_trace` | source exacte corrigée : photo revue, gardée, recadrée et choisie |
| `docs/canon/bible/12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md`, §5.2 | beats hors ligne Marie | source de fonction ; ne pas remplacer par du chat supplémentaire |

### 5.8 Faits, traces, promesses et connaissances

- F01 `fact_marie_player_couple_exists` ;
- F07 `fact_sandra_preexisting_friendship` ;
- T01 `j01_sandra_lunch_memory_soft` ;
- F08 `fact_player_saw_sandra_lunch_photo` ;
- P01 `marie_j01_shared_evening`, seulement après acceptation réelle ;
- Mathilde indirecte ne crée ni trace, ni promesse, ni photo.

### 5.9 Conséquences et état de sortie

- Marie sait si Player a transformé une intention en acte.
- Sandra sait comment Player lit une représentation qu’elle a choisie.
- Player a vu une image sans acquérir de droit général sur elle.
- Marie ne connaît pas automatiquement la photo Sandra.
- Aucun droit de sauvegarde hors fil.
- Aucun transfert à Marie, Nico ou un groupe.
- Aucune promesse Sandra structurée n’est créée en J01 : la « promesse de se revoir » de S03 doit être lue comme possibilité narrative, pas comme engagement enregistré.

### 5.10 Brief visuel J01-01

| Champ | Spécification |
|---|---|
| `asset_id` | `S1_A1_J01_SCN_MARIE_SHARED_KITCHEN_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Sujet visible | Marie, seule au premier plan ; Player reste point de vue, non visible |
| Fonction relationnelle | Faire désirer la vie commune avant toute peur de la perdre ; niveau Marie M0 |
| Contexte et moment | Début de soirée dans la cuisine ouverte, autour du dîner improvisé et du petit acte demandé |
| Composition de travail | Marie en mouvement, non posée ; pain et deux tomates comme ancres secondaires ; sac trop plein ou chaussures près de la porte, mais pas les deux si la composition devient chargée ; plan mi-corps ou trois-quarts vertical-compatible |
| Expression / posture | Vive, occupée, adresse familière vers Player ; aucune tristesse prémonitoire |
| Lumière / décor | Lumière domestique chaude et ordinaire ; appartement réellement vécu, pas décor publicitaire |
| Audience | joueur / mémoire de Player ; aucune audience diégétique |
| Permanence | image de scène persistante si la scène est vécue |
| Sauvegarde | aucun fichier diégétique ; `can_share: false` |
| Transfert | impossible |
| Galerie | éligible dans l’onglet Marie ; type interne `SOUVENIR_IMAGE_DE_SCÈNE` ; aucun onglet « Souvenir » |
| J14 / J21 | non / non |
| Variantes | aucune ; l’image ne doit pas encoder une réponse positive particulière |
| Dépendances | doit rester distincte de J01-03 ; continuité d’appartement et de tenue possible |
| Décision non déductible | choix du cadrage et de l’une des ancres `sac` ou `chaussures`, sans effet canonique |
| Interdits | Marie jalouse, abattue ou immobile ; image de nourriture sans personnage ; selfie ; photo supposée envoyée ; sexualisation V2 ; visage ou morphologie inventés hors canon |

### 5.11 Brief visuel J01-02

| Champ | Spécification |
|---|---|
| `asset_id` | `S1_A1_J01_DPH_SANDRA_LUNCH_SELECTED_01` |
| Type | `PHOTO_DIÉGÉTIQUE` |
| `trace_id` | `j01_sandra_lunch_memory_soft` |
| Sujet visible | Sandra comme sujet principal ; deux verres et bord de table comme contexte |
| Fonction relationnelle | Matérialiser une représentation revue, gardée puis choisie pour Player ; niveau Sandra SV0 |
| Contexte et moment | Photographie issue du dernier déjeuner Sandra/Player ; renvoyée J01 après le poste de Sandra |
| Créateur / capture | créatrice opératoire : Sandra ; téléphone de Sandra ; Player peut avoir physiquement déclenché ou tenu le téléphone sous sa direction, sans acquérir l’autorité ni la propriété de l’image |
| Composition de travail | Sandra clairement lisible comme sujet malgré un cadrage imparfait ; elle peut être légèrement au bord du cadre ; l’imperfection ne doit pas effacer son visage ni devenir un flou esthétique systématique |
| Intention | garder la trace du déjeuner, puis sélectionner le crop renvoyé ; aucune publication |
| Audience initiale | Sandra et Player |
| Permanence | `ACTIVE`, `RESTRICTED`, `REMOVED` ou `INACCESSIBLE` selon décision ultérieure de Sandra |
| Sauvegarde | `IN_THREAD_ONLY` par défaut ; aucune conservation hors fil automatiquement autorisée |
| Transfert | interdit |
| Galerie | oui si encore accessible ; en cas de retrait, seulement mémoire/accès perdu selon règle future, jamais restauration du fichier |
| J14 / J21 | J14 : oui si encore affichable ; J21 : oui, y compris par son absence ou retrait |
| Variantes | aucune |
| Dépendances | source de F08 ; peut recevoir une impression dérivée J18 avec propriétaire distinct |
| Ambiguïté explicitement résolue | le déclencheur physique peut être Player, mais le contrôle créatif, le fichier, la revue, le crop et la sélection appartiennent à Sandra |
| Interdits | capture volée ; image adulte ; preuve de tromperie ; préférence de Sandra pour le flou ; publication publique ; transfert ; crop sexualisant ; droit de sauvegarde implicite |

### 5.12 Brief visuel J01-03

| Champ | Spécification |
|---|---|
| `asset_id` | `S1_A1_J01_SCN_MARIE_EVENING_RETURN_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Sujet visible | Marie ; Player reste point de vue |
| Fonction relationnelle | Fermer la journée sur une vie partagée encore réelle, quelle que soit la qualité exacte de P01 |
| Contexte et moment | Pause à l’entrée ou au retour dans l’appartement, après la marche, le dîner, l’amendement ou l’activité autonome de Marie |
| Composition de travail | Marie près du miroir d’entrée ou du manteau posé ; geste quotidien de retour, chaussures ou clés secondaires ; distance neutre permettant plusieurs lectures de posture |
| Expression / posture | attentive mais non codée en victoire ou sanction ; pas de sourire romantique obligatoire, pas de froideur définitive |
| Audience | joueur / mémoire de Player |
| Permanence | image de scène persistante |
| Sauvegarde | aucun fichier diégétique ; `can_share: false` |
| Transfert | impossible |
| Galerie | éligible dans l’onglet Marie ; type interne `SOUVENIR_IMAGE_DE_SCÈNE` ; aucun onglet « Souvenir » |
| J14 / J21 | non / non |
| Variantes | aucune ; la même composition doit rester vraie pour P01 payée, amendée ou refusée |
| Dépendances | répond à J01-01 par un second moment et une autre fonction ; ne doit pas répéter cuisine, pain et tomates |
| Décision non déductible | miroir d’entrée recommandé plutôt que promenade extérieure afin de rester valide sur toutes les branches |
| Interdits | contact physique récompense ; solitude punitive ; cadrage de surveillance ; photo prise par Player ; indice de jalousie Sandra |

---

## 6. Paquet complet J02

### 6.1 Identité de la journée

**Titre :** Mercredi — La chambre qui change le foyer

**Fonction dramatique :** introduire Mathilde comme personne et besoin réel, mettre le foyer en mouvement et montrer la confiance de Marie.

**Question joueur :** Player participe-t-il à une nécessité familiale concrète, la limite-t-il proprement ou laisse-t-il Marie et Mathilde s’organiser sans lui ?

**État d’entrée :** couple réel, appartement partagé, Mathilde encore extérieure au foyer.

**État de sortie :** séjour Mathilde actif, foyer moins fermé, aucune intention sexuelle.

### 6.2 Séquence source

- S04 — La valise dans la petite chambre.

### 6.3 Scènes et fenêtres

| Fenêtre | Source scène | Mode | Fonction | Statut |
|---|---|---|---|---|
| midi | `chapter_02_marie_make_room` / `O1` | `REMOTE_ASYNC` | urgence, proposition de Marie, qualité de participation | obligatoire |
| fin d’après-midi | `chapter_02_marie_arrival_trace` / `O2_TRACE` | `TRACE_DELIVERY` historique | annoncer que l’installation a eu lieu | fonction obligatoire, métadonnée photo supersédée |
| soir | `chapter_02_mathilde_arrival` / `O2_MATHILDE` | `REMOTE_ASYNC_TO_OFFLINE_BEAT` | accueil direct, puis arrêt du chat à la réunion physique | obligatoire |
| soir | installation hors téléphone | `OFFLINE_BEAT` | rendre le séjour concret | obligatoire |

### 6.4 Personnages

- présents/directs : Marie, Mathilde, Player ;
- indirects possibles : propriétaires, voisin ou assurance seulement comme contexte du dégât des eaux, sans scène ;
- absents : Sandra, Pauline, Raphaëlle, Nico comme pivots ;
- Marie reste structurelle même lorsque Mathilde parle directement à Player.

### 6.5 Choix et postures Player

1. **Aide concrète** : libère du temps, déplace ou prépare réellement.
2. **Aide limitée et précise** : annonce ce qu’il peut faire et quand.
3. **Refus / indisponibilité assumée** : ne bloque pas l’hébergement ; Marie et Mathilde continuent.

À l’accueil de Mathilde :

- chaleur pratique ;
- humour léger sans sexualiser ;
- neutralité respectueuse.

### 6.6 Mutations de refus, silence, absence ou limite

| Condition | Mutation | État produit |
|---|---|---|
| Player accepte | aide visible avant ou pendant l’arrivée | P02 `PAID` |
| Player amende précisément | aide partielle, logistique reprise par Marie/Mathilde | P02 `PAID` ou `AMENDED` selon future implémentation |
| Player refuse | Mathilde arrive quand même ; Marie organise | P02 `REFUSED` |
| Player promet puis disparaît | arrivée autonome ; qualité de participation négative mais aucun score Mathilde | P02 `FAILED` |
| Player sexualise l’installation | Mathilde corrige ou ferme le ton ; aucune image privée | séjour inchangé, route non ouverte |
| Player est absent à l’arrivée | première rencontre visuelle produite lorsqu’il voit le résultat de l’installation | trois images de scène toujours accessibles |

### 6.7 Dialogues sources exacts

| Autorité / fichier | Identifiant | Usage |
|---|---|---|
| `docs/canon/dialogues/J01_J06_SOURCE_CANON_CONSOLIDE.md`, §3 | J02 Arrivée de Mathilde | autorité sur P02, autonomie de Mathilde et `FACT_RECORD` |
| `game/data/conversations/chapter_02_marie_make_room.json` | `chapter_02_marie_make_room` | source exacte Marie |
| `game/data/conversations/chapter_02_marie_arrival_trace.json` | `chapter_02_marie_arrival_trace` | source historique du passage du temps ; la future adaptation doit supprimer entièrement `msg_wed_marie_arrival_002`, et non seulement retirer sa métadonnée |
| `game/data/conversations/chapter_02_mathilde_arrival.json` | `chapter_02_mathilde_arrival` | source exacte Mathilde + transition hors téléphone |

### 6.8 Faits, traces, promesses et connaissances

- P02 `mathilde_j02_arrival_help` ;
- T02 `j02_mathilde_arrival_room_01` reste `FACT_RECORD` ;
- F02 `fact_mathilde_stay_started` ;
- connaisseurs initiaux : Marie, Player, Mathilde ;
- aucun créateur de photo ;
- aucune audience d’image ;
- aucune connaissance automatique de Nico, Pauline ou Sandra.

### 6.9 Contradiction explicitement résolue

Le plan `12`, §6.2, et le placeholder historique `mathilde_arrival_room_01` décrivent une photographie pratique prise par Marie. La source consolidée et T02 disent :

```text
creator: none
trace_type: FACT_RECORD
```

Le présent paquet suit l’autorité la plus récente et impose exactement, pour la future adaptation :

- aucune photo diégétique J02 ;
- aucun fichier envoyé par Marie ;
- suppression complète de la ligne `msg_wed_marie_arrival_002` (« Preuve jointe. ») ;
- suppression du `content_id` `mathilde_arrival_room_01` et de toute liaison visuelle correspondante ;
- aucun remplacement de cette ligne par une nouvelle ligne ou une nouvelle pièce jointe ;
- trois images de scène de type interne `SOUVENIR_IMAGE_DE_SCÈNE` ;
- maintien des trois contenus internes `SOUVENIR_IMAGE_DE_SCÈNE` définis par le paquet.

Cette correction exacte ne modifie pas le présent lot documentaire et ne rouvre pas le dialogue signé : elle constitue une instruction d’adaptation runtime future. J02 reste `READY`.

### 6.10 Conséquences et état de sortie

- Mathilde est installée pour une durée temporaire.
- Marie a agi comme centre du foyer.
- Player a une qualité de participation, pas un score d’accès à Mathilde.
- Le logement ne devient jamais une permission.
- L’installation fournit des fenêtres futures, pas une intention sexuelle.

### 6.11 Brief visuel J02-01

| Champ | Spécification |
|---|---|
| `asset_id` | `S1_A1_J02_SCN_MATHILDE_FIRST_INSTALLED_VIEW_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Sujet visible | Mathilde au premier plan |
| Fonction relationnelle | Donner une présence concrète à l’invitée et à son séjour temporaire ; Mathilde MT0 |
| Contexte et moment | Première fois où Player voit Mathilde après l’installation, dans l’encadrement ou l’intérieur de la petite chambre |
| Composition de travail | Mathilde visible en entier ou trois-quarts ; valise trop pleine ouverte, garment bag suspendu, tote bag juridique ; limiter les accessoires à trois ancres lisibles |
| Tenue | homewear ajusté conforme au canon, traité comme ordinaire et non comme intention |
| Expression / posture | légère gêne pratique ou mauvaise foi amusée ; elle ne pose pas pour Player |
| Audience | joueur / mémoire de Player |
| Permanence | image de scène persistante |
| Sauvegarde | aucun fichier diégétique ; `can_share: false` |
| Transfert | impossible |
| Galerie | éligible dans l’onglet Mathilde ; type interne `SOUVENIR_IMAGE_DE_SCÈNE` ; aucun onglet « Souvenir » |
| J14 / J21 | non / non |
| Variantes | aucune ; le moment est postérieur à l’arrivée et reste disponible si Player a manqué l’arrivée elle-même |
| Dépendances | visualise le résultat du `FACT_RECORD` sans devenir la trace T02 |
| Risque de confusion | élevé si le cadrage imite une photo de téléphone ; imposer une mise en scène vécue sans interface, flash, selfie ou regard caméra |
| Interdits | légende « preuve » ; créateur Marie ; envoi au fil ; pose sexuelle ; mini-short présenté comme invitation ; chambre vide comptée seule |

### 6.12 Brief visuel J02-02

| Champ | Spécification |
|---|---|
| `asset_id` | `S1_A1_J02_SCN_MARIE_HOLDS_HOUSEHOLD_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Sujet visible | Marie, seule au premier plan ; Mathilde peut être hors champ |
| Fonction relationnelle | Montrer que Marie prend une décision familiale et organise le foyer sans attendre passivement Player |
| Contexte et moment | Après l’arrivée, Marie réorganise un détail concret entre petite chambre, entrée et espace commun |
| Composition de travail | Marie avec draps pliés, chaise déplacée ou espace dégagé ; une seule action nette ; sac ou téléphone non nécessaire |
| Expression / posture | active, concentrée, chaleureuse mais ferme ; pas de martyr domestique |
| Audience | joueur / mémoire de Player |
| Permanence | image de scène persistante |
| Sauvegarde | aucun fichier diégétique ; `can_share: false` |
| Transfert | impossible |
| Galerie | éligible dans l’onglet Marie ; type interne `SOUVENIR_IMAGE_DE_SCÈNE` ; aucun onglet « Souvenir » |
| J14 / J21 | non / non |
| Variantes | aucune ; la scène montre ce que Marie fait, pas le niveau d’aide de Player |
| Dépendances | complète J02-01 sans répéter valise et garment bag au premier plan |
| Décision non déductible | choix recommandé des draps comme action visuelle ; sans conséquence narrative |
| Interdits | Marie jalouse de Mathilde ; foyer traité comme territoire sexuel ; photo envoyée ; absence totale de personnage |

### 6.13 Brief visuel J02-03

| Champ | Spécification |
|---|---|
| `asset_id` | `S1_A1_J02_SCN_FIRST_SHARED_EVENING_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Sujets visibles | Marie et Mathilde ; Player reste point de vue |
| Fonction relationnelle | Matérialiser le passage d’un couple seul à un foyer temporairement à trois sans bascule sexuelle |
| Contexte et moment | Premier temps calme après installation, dans cuisine ou séjour, une fois le chat arrêté |
| Composition de travail | Marie et Mathilde occupées par deux actions ordinaires compatibles : verre d’eau, rangement, chargeur recherché, discussion courte ; proximité familiale lisible |
| Expression / posture | familiarité ancienne entre elles ; Player accueilli dans la scène mais non central visuellement |
| Audience | joueur / mémoire de Player |
| Permanence | image de scène persistante |
| Sauvegarde | aucun fichier diégétique ; `can_share: false` |
| Transfert | impossible |
| Galerie | éligible dans les onglets Marie et Mathilde avec le même `asset_id`, sans duplication ; type interne `SOUVENIR_IMAGE_DE_SCÈNE` |
| J14 / J21 | non / non |
| Variantes | aucune |
| Dépendances | doit garder la même géographie d’appartement que J01 et la petite chambre de J02-01 |
| Risque de confusion | ne pas produire une « photo de colocataires » ; c’est une scène vécue |
| Interdits | triangle ; sous-entendu sexuel ; Player visible comme voyeur ; téléphone en conversation alors que tous sont co-présents ; objet seul |

---

## 7. Paquet complet J03

### 7.1 Identité de la journée

**Titre :** Jeudi — Les vies qui existent ailleurs

**Fonction dramatique :** établir Raphaëlle comme collègue compétente avec une pratique créative hors travail, prolonger Sandra sans forcer et revenir vers Marie.

**Question joueur :** Player sait-il reconnaître une personne au-delà de sa fonction sans exiger immédiatement l’accès à son monde privé ?

**État d’entrée :** séjour Mathilde actif ; Sandra distante ou rouverte ; couple stable ; Raphaëlle seulement collègue.

**État de sortie :** Raphaëlle `PROFESSIONAL_ONLY`, détail créatif connu, continuité Sandra prise en compte, Marie recentrée.

### 7.2 Séquences sources

- S06 — Le dossier bleu et le garment bag ;
- écho S03 facultatif ;
- fonction de retour Marie / foyer issue de la source consolidée.

### 7.3 Scènes et fenêtres

| Fenêtre | Source scène | Mode | Fonction | Statut |
|---|---|---|---|---|
| matin / travail | `chapter_03_raphaelle_blue_folder` / `O3` | `WORK_CHAT` + contexte professionnel | résoudre un vrai problème, établir les pairs | obligatoire |
| fin de fenêtre travail | même scène / beat S06 | interaction professionnelle ou hors chat si co-présence | faire voir le garment bag ou détail créatif sans accès privé | obligatoire dans la fonction, dosage court |
| début d’après-midi | `chapter_03_sandra_continuity` / `O3_ECHO` | `REMOTE_ASYNC` | écho court, sans nouvelle image ni promesse | conditionnel, expiration propre |
| fin de journée | `chapter_03_marie_evening_return` / `O4_MARIE_RETURN` | `REMOTE_ASYNC`, puis beat hors téléphone | recentrer la journée sur Marie par une heure et un repas réels | obligatoire |

### 7.4 Personnages

- directs : Raphaëlle, Marie, Player ;
- conditionnelle : Sandra ;
- Mathilde : état de foyer actif, sans pivot nécessaire ;
- absents comme acteurs : Pauline, Nico, Bastien ;
- Maud et Élodie ne deviennent pas photographes ou témoins sans source.

### 7.5 Choix et postures Player

#### Raphaëlle

1. **Collaboration précise** : répond au problème concret et reconnaît la compétence.
2. **Humour sec mais lisible** : reste pair sans transformer le travail en flirt.
3. **Évitement / délégation** : Raphaëlle résout ou ferme professionnellement, sans punition.

Face au détail créatif :

- question respectueuse ;
- remarque factuelle sans réduction sexuelle ;
- choix de ne pas demander.

#### Sandra

- répondre à l’écho ;
- rester bref ;
- laisser expirer.

#### Marie

- revenir à la vie commune ;
- amender précisément une disponibilité ;
- rester passif, ce qui est mémorisé sans créer une crise majeure J03.

### 7.6 Mutations de refus, silence, absence ou limite

| Condition | Mutation | Sortie |
|---|---|---|
| Player évite le sujet créatif | Raphaëlle ne propose rien ; le garment bag reste un détail connu | `PROFESSIONAL_ONLY` |
| Player sexualise le détail | Raphaëlle corrige et ferme ; aucun accès, aucune photo | `PROFESSIONAL_ONLY`, limite renforcée |
| Player respecte sans demander davantage | connaissance du monde créatif possible, pas d’accès | future question crédible |
| Sandra n’est pas active | aucun remplacement par une photo Sandra | troisième visuel garanti par Marie |
| Sandra écrit et Player se tait | fenêtre expire proprement | T01 inchangée selon son état |
| Player est indisponible pour Marie | Marie continue son rythme ; retour plus bref | couple encore stable, acte mémorisé |

### 7.7 Dialogues sources exacts

| Autorité / fichier | Identifiant | Usage |
|---|---|---|
| `docs/canon/dialogues/J01_J06_SOURCE_CANON_CONSOLIDE.md`, §4 | J03–J04 | autorité sur fonction finale et séparation monde professionnel / social |
| `game/data/conversations/chapter_03_raphaelle_blue_folder.json` | `chapter_03_raphaelle_blue_folder` | source exacte du pivot Raphaëlle |
| `game/data/conversations/chapter_03_sandra_continuity.json` | `chapter_03_sandra_continuity` | source exacte de l’écho facultatif |
| `game/data/conversations/chapter_03_marie_evening_return.json` | `chapter_03_marie_evening_return` | fragment J03 actif issu du `SPLIT` ; source exacte du retour domestique conservé |
| `game/data/conversations/chapter_03_marie_event_return.json` | `chapter_03_marie_event_return` | réservoir historique classé `RELOCATE / SPLIT` ; aucune de ses anciennes familles conditionnelles ne doit être réinjectée dans J03 |
| `docs/canon/bible/12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md`, §7.3–7.7 | anciennes scènes J03 | exclut de J03 `event_offer`, `event_joined`, `mathilde_home_charger`, `raphaelle_late_review` et la version entière d’`event_return` |

### 7.7.1 Cartographie ligne par ligne du fragment J03 conservé après le `SPLIT`

Le fichier historique `chapter_03_marie_event_return` ne reste pas une scène J03 universelle. Le fragment J03 autoritatif après le `SPLIT` est `chapter_03_marie_evening_return`. Le tableau ci-dessous référence chaque ligne exacte du fragment actif, sans la réécrire ni en modifier l’ordre.

| Ordre | Identifiant exact | Nature | Ligne exacte | Fonction / condition |
|---:|---|---|---|---|
| 1 | `msg_j3_marie_evening_001` | Marie | « Tu rentres vers quelle heure ? » | retour Marie obligatoire ; demande d’heure concrète |
| 2 | `msg_j3_marie_evening_002` | Marie | « Mathilde a retrouvé son chargeur. Enfin un chargeur. » | état ordinaire du foyer ; aucune scène `mathilde_home_charger` réintroduite |
| 3 | `choice_j3_marie_evening_why_guided` | Player | « Vers 19 h. Pourquoi ? » | réponse guidée de rythme ; aucune promesse héritée de l’ancien événement |
| 4 | `msg_j3_marie_evening_003` | Marie | « J'ai laissé une soupe au frigo. » | ancre domestique concrète |
| 5 | `msg_j3_marie_evening_004` | Marie | « Et j'aimerais bien qu'on mange ensemble sans déplacer ça à demain. » | demande actuelle ; ouvre les trois postures du fragment |
| 6 | `choice_j3_marie_return_active` | Player | « Je rentre à 19 h. Je prends quelque chose avec la soupe. » | posture `marie_j3_return_active` |
| 7 | `msg_j3_marie_evening_005a` | Marie | « Parfait. » | réponse à la présence active |
| 8 | `msg_j3_marie_evening_006a` | Marie | « Prends un truc qui croque. Cette soupe a besoin d'aide. » | paiement concret de la posture active |
| 9 | `choice_j3_marie_return_bounded` | Player | « Je finis ça et je rentre à 19 h 30. » | posture `marie_j3_return_bounded` |
| 10 | `msg_j3_marie_evening_005b` | Marie | « 19 h 30. » | reconnaissance de l’heure bornée |
| 11 | `msg_j3_marie_evening_006b` | Marie | « Je lance la soupe à 19 h 25. C'est de la confiance très concrète. » | conséquence domestique bornée |
| 12 | `choice_j3_marie_return_drift` | Player | « Je sais pas encore. Commencez sans moi. » | posture `marie_j3_return_drift` |
| 13 | `msg_j3_marie_evening_005c` | Marie | « D'accord. » | reconnaissance sans crise ajoutée |
| 14 | `msg_j3_marie_evening_006c` | Marie | « Mais ne m'écris pas à 21 h que tu aurais aimé être là. » | limite concrète ; la soirée continue sans Player |

### 7.7.2 Exclusions du fichier historique après le `SPLIT`

| Famille historique | Dépendance historique | Statut dans J03 | Destination documentaire |
|---|---|---|---|
| `msg_thu_return_join_warm_*`, `choice_thu_return_join_warm_guided` et suites | `marie_event_initiative OR marie_event_playful_help` | exclue | visibilité sociale / J09 |
| `msg_thu_return_join_distant_*`, `choice_thu_return_join_distant_guided` et suites | `marie_event_distracted` | exclue | visibilité sociale / J09 |
| `msg_thu_return_home_help_*`, `choice_thu_return_home_help_guided` et suites | `mathilde_home_help` | exclue | continuité domestique / J05–J06 |
| `msg_thu_return_home_playful_*`, `choice_thu_return_home_playful_guided` et suites | `mathilde_home_playful_help` | exclue | continuité domestique / J05–J06 |
| `msg_thu_return_home_distance_*`, `choice_thu_return_home_distance_guided` et suites | `mathilde_home_distance` | exclue | continuité domestique / J05–J06 |
| `msg_thu_return_work_kept_*` | `work_promise_kept` | exclue | superposition / J08 |
| `msg_thu_return_work_amended_*` | `work_promise_amended` | exclue | superposition / J08 |
| `msg_thu_return_work_missed_*`, `choice_thu_return_work_missed_guided` et suites | `work_promise_missed` | exclue | superposition / J08 |

Contrôle de conservation :

- aucune ligne du fragment actif n’est reformulée ;
- aucun `event_offer` ni `event_joined` n’est réintroduit ;
- aucune promesse de travail, de vernissage ou de superposition n’est créée ;
- aucun retour universel conditionné par trois branches précoces n’est restauré ;
- la fonction J03 reste strictement : heure réelle, repas concret, foyer qui continue.

La correction ciblée J03 est donc close et la journée passe à `READY`.

### 7.8 Faits, traces, promesses et connaissances

- F04 `fact_marie_laverriere_world_exists` ;
- F05 `fact_raphaelle_professional_relationship_exists` ;
- T03 `j03_marie_laverriere_setup_01` reste `FACT_RECORD` ;
- aucune photo La Verrière J03 ;
- aucune promesse Raphaëlle ;
- aucune nouvelle trace Sandra ;
- T01 peut rester active, restreinte, retirée ou inaccessible.

### 7.9 Contradiction explicitement résolue

Le placeholder historique `marie_laverriere_setup_01` a été déplacé vers une future fonction J09. T03 précise `creator: none`.

Conséquence :

- J03 ne produit aucune photo diégétique Marie ;
- les deux visuels Raphaëlle sont des images de scène professionnelles ;
- le visuel Marie est une image de scène de type interne `SOUVENIR_IMAGE_DE_SCÈNE` ;
- aucune image ne prétend que Player a assisté à un événement La Verrière J03.

### 7.10 Conséquences et état de sortie

- Raphaëlle existe comme collègue réelle.
- Player peut savoir qu’une pratique créative importante existe.
- Il ne possède ni compte créatif, ni photographie, ni accès cosplay.
- Marie demeure l’axe de retour.
- Sandra peut être active ou non sans modifier le budget visuel.

### 7.11 Brief visuel J03-01

| Champ | Spécification |
|---|---|
| `asset_id` | `S1_A1_J03_SCN_RAPHAELLE_ACCESSIBILITY_REVIEW_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Sujet visible | Raphaëlle au premier plan ; Player reste point de vue |
| Fonction relationnelle | Établir la compétence et le rapport de pairs avant toute curiosité privée ; Raphaëlle R0 |
| Contexte et moment | Vraie revue UX/accessibilité autour du dossier bleu |
| Composition de travail | Raphaëlle assise ou debout près d’un écran de travail non lisible ; dossier bleu, carnet bleu-vert, café froid ; lunettes écaille ; posture engagée dans une décision concrète |
| Tenue | signature de travail : pantalon structuré, haut ajusté sobre, cheveux attachés bas, un accessoire discret |
| Expression / posture | attention précise, calme, légère fatigue possible ; pas de regard séducteur construit |
| Audience | joueur / représentation de scène ; aucune connaissance visuelle diégétique supplémentaire pour Player |
| Permanence | image de scène persistante |
| Sauvegarde | aucun fichier diégétique ; `can_share: false` |
| Transfert | impossible |
| Galerie | éligible dans l’onglet Raphaëlle ; type interne `SOUVENIR_IMAGE_DE_SCÈNE` ; aucun onglet « Souvenir » |
| J14 / J21 | non / non |
| Variantes | aucune |
| Dépendances | continuité de tenue et de lieu avec J03-02 |
| Interdits | contenu lisible de client ; métaphore UI envahissante ; photo de bureau ; lunettes retirées comme code sexuel ; diagnostic du couple |

### 7.12 Brief visuel J03-02

| Champ | Spécification |
|---|---|
| `asset_id` | `S1_A1_J03_SCN_RAPHAELLE_GARMENT_BAG_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Sujet visible | Raphaëlle |
| Fonction relationnelle | Faire apparaître une vie créative sans ouvrir l’accès ; transition R0 vers simple indice R1 |
| Contexte et moment | Fin de la fenêtre de travail, Raphaëlle se prépare à partir avec un garment bag et son carnet |
| Composition de travail | Raphaëlle trois-quarts ou plein pied ; garment bag clairement pratique mais fermé ; carnet sombre ou épingle/craie comme détail secondaire ; environnement professionnel encore présent |
| Expression / posture | elle choisit d’expliquer, de dévier ou de ne pas répondre ; l’image reste compatible avec ces trois sorties |
| Audience | joueur / représentation de scène ; aucune connaissance visuelle diégétique supplémentaire pour Player |
| Permanence | image de scène persistante |
| Sauvegarde | aucun fichier diégétique ; `can_share: false` |
| Transfert | impossible |
| Galerie | éligible dans l’onglet Raphaëlle ; type interne `SOUVENIR_IMAGE_DE_SCÈNE` ; aucun onglet « Souvenir » |
| J14 / J21 | non / non |
| Variantes | aucune |
| Dépendances | même journée et tenue que J03-01 ; doit être visuellement différente par action, échelle et déplacement |
| Risque de confusion | le garment bag ne doit pas devenir silhouette érotique ni preuve secrète |
| Interdits | costume visible ; compte créatif ; masque ; invitation privée ; photo prise à son insu ; contenu V2 |

### 7.13 Brief visuel J03-03

| Champ | Spécification |
|---|---|
| `asset_id` | `S1_A1_J03_SCN_MARIE_HOME_FROM_LAVERRIERE_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Sujet visible | Marie |
| Fonction relationnelle | Recentrer la journée sur la partenaire réelle et matérialiser qu’elle possède un monde autonome |
| Contexte et moment | Marie revient ou se pose au foyer après sa journée La Verrière ; aucune scène d’événement public n’est prétendue |
| Composition de travail | Marie avec sac trop plein, manteau ou chaussures près de la porte ; un seul indice professionnel non textuel, par exemple coin d’affiche ou badge, sans document lisible |
| Expression / posture | vivante et fatiguée, encore en mouvement ; aucune blessure majeure |
| Audience | joueur / mémoire de Player |
| Permanence | image de scène persistante |
| Sauvegarde | aucun fichier diégétique ; `can_share: false` |
| Transfert | impossible |
| Galerie | éligible dans l’onglet Marie ; type interne `SOUVENIR_IMAGE_DE_SCÈNE` ; aucun onglet « Souvenir » |
| J14 / J21 | non / non |
| Variantes | aucune ; Sandra active ou expirée ne change pas cet asset |
| Dépendances | crée F04 par la scène et le dialogue, pas par un fichier photo |
| Interdits | faux événement La Verrière ; Élodie photographe ; image envoyée ; preuve de présence ; soirée noire/robe noire prématurée ; jalousie Raphaëlle |

---

## 8. Paquet complet J04

### 8.1 Identité de la journée

**Titre :** Vendredi — Le réseau social devient concret

**Fonction dramatique :** établir Pauline et Bastien dans une vie officielle réelle, Nico comme ami autonome, Marie comme centre social et le foyer Mathilde comme réalité ordinaire.

**Question joueur :** Player sait-il reconnaître les personnes et leurs vies officielles avant de chercher des sous-textes, des accès ou des complicités ?

**État d’entrée :** couple stable, séjour Mathilde actif, Raphaëlle professionnelle, Sandra distante ou rouverte.

**État de sortie :** tous les personnages principaux possèdent une présence ordinaire ; Pauline `PUBLIC_ONLY`, Nico `ORDINARY_FRIEND`, ouverture close.

### 8.2 Séquences sources

- S05 — Le repas que Pauline sait rendre simple ;
- S07 — La place gardée à L’Annexe ;
- fermeture de S01.

### 8.3 Scènes et fenêtres

| Fenêtre | Source scène | Mode | Fonction | Statut |
|---|---|---|---|---|
| matin | `chapter_04_pauline_public_photo_relay` / `O5_PAULINE` | `TRACE_DELIVERY` | relayer le set public issu d’un dîner récent chez Pauline/Bastien | obligatoire, origine réconciliée |
| après-midi | `chapter_04_nico_saved_seat_followup` / `O6_NICO` | `REMOTE_ASYNC` | place à L’Annexe, amitié avant confidence | obligatoire, dépendance J03 retirée |
| fin de journée | `chapter_04_marie_household_report` / `O8_HOUSEHOLD_MARIE` | `REMOTE_ASYNC` | état pratique du foyer | écho obligatoire ou équivalent |
| fin de journée | `chapter_04_mathilde_bathroom_correction` / `O8_HOUSEHOLD_MATHILDE` | `REMOTE_ASYNC` | voix Mathilde, friction légère | écho compatible |
| soir | beat final du foyer | `OFFLINE_BEAT` | bureau transformé, rythme à trois, clôture ouverture | obligatoire |

### 8.4 Personnages

- directs : Pauline, Bastien, Nico, Marie, Player ;
- Mathilde : présente dans le foyer, absente du set public ;
- indirects : groupe social nommé du dîner ;
- absents : Raphaëlle et Sandra comme pivots de J04 ;
- Nico reste séparé du set public principal ;
- Nico et Mathilde sont absents des trois frames du set ;
- Player est destinataire du set mais reste hors cadre et non identifiable.

### 8.5 Choix et postures Player

#### Pauline / set public

1. reconnaître la compétence sociale et le couple réel ;
2. commenter le groupe sans isoler sexuellement Pauline ;
3. choisir la version 2 ou la version 3, ou renvoyer la sélection à Marie sans créer un quatrième fichier.

#### Nico

1. accepter la place comme moment d’amitié ;
2. proposer un autre horaire précis ;
3. décliner sans créer d’alibi ni de confidence.

#### Foyer

- participation pratique ;
- humour léger ;
- limite claire sans hostilité.

### 8.6 Mutations de refus, silence, absence ou limite

| Condition | Mutation | Sortie |
|---|---|---|
| Player ne commente pas le set | Pauline conserve la version publique ; aucune relance privée | T04 `PUBLIC_ACTIVE` |
| Player sexualise Pauline | Pauline recadre ou ferme ; aucune version alternative | `PUBLIC_ONLY` |
| Player refuse L’Annexe | Nico garde sa vie et sa salle ; aucune chaise ne devient promesse | `ORDINARY_FRIEND` |
| Player amende | autre horaire éventuel seulement s’il est précis ; aucune dette implicite | amitié intacte |
| Player choisit la frame 2 | la frame 2 devient la représentation principale du set en Galerie | contenu T04 inchangé ; aucun nouvel asset |
| Player choisit la frame 3 | la frame 3 peut devenir la représentation principale du set en Galerie | contenu T04 inchangé ; aucun nouvel asset |
| Player renvoie la décision à Marie | Pauline/Marie retiennent la frame prévue par le dialogue ; le set garde ses trois fichiers enfants | contenu T04 inchangé ; aucune variante |
| Player est passif au foyer | Marie et Mathilde continuent ; beat final plus observé que partagé | ouverture tout de même close |

### 8.7 Dialogues sources exacts

| Autorité / fichier | Identifiant | Usage |
|---|---|---|
| `docs/canon/dialogues/J01_J06_SOURCE_CANON_CONSOLIDE.md`, §4 | J03–J04 | autorité sur Pauline/Bastien, Nico et séparation monde social/professionnel |
| `game/data/conversations/chapter_04_pauline_public_photo_relay.json` | `chapter_04_pauline_public_photo_relay` | source exacte du relais ; le `content_id` legacy ne doit pas être conservé comme identité canonique |
| `game/data/conversations/chapter_04_nico_saved_seat_followup.json` | `chapter_04_nico_saved_seat_followup` | source exacte Nico ; lire sans dépendance au vernissage J03 |
| `game/data/conversations/chapter_04_marie_household_report.json` | `chapter_04_marie_household_report` | source exacte écho Marie |
| `game/data/conversations/chapter_04_mathilde_bathroom_correction.json` | `chapter_04_mathilde_bathroom_correction` | source exacte écho Mathilde |
| `docs/canon/bible/12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md`, §8 | audit J04 | confirme les noyaux compatibles et les dépendances à retirer |

### 8.8 Faits, traces, promesses et connaissances

- T04 `j04_pauline_bastien_public_set_01` ;
- F03 `fact_pauline_bastien_couple_public` ;
- F06 `fact_nico_friendship_exists` ;
- F02 reste connu de Marie, Player et Mathilde ;
- Nico ne connaît le séjour Mathilde que si une déclaration directe ou un contexte social crédible le lui apprend ;
- aucune promesse structurée nouvelle ;
- aucune version privée Pauline ;
- aucun alibi Nico.

### 8.9 Contradictions et ambiguïtés explicitement signalées

1. Le fichier historique emploie encore `laverriere_public_group_photo_set_01`. T04 interdit un mapping automatique vers cette origine.
2. Le titre « Trois versions du dimanche » et les notes existantes décrivent un dîner récent chez Pauline et Bastien, relayé J04. Le moment de capture est donc antérieur au relais, tandis que `source_day: J04` désigne l’activation de la trace dans le corpus.
3. Le registre fixe Pauline comme créatrice via retardateur ; la revue produit fixe définitivement le casting visible `[Pauline, Bastien, Marie]`.
4. L’audience nommée du set est `[Pauline, Bastien, Marie, Player]`.
5. Nico et Mathilde sont absents des trois frames. Aucune variante de casting n’est autorisée.
6. Player est destinataire mais reste hors cadre et non identifiable, conformément à la règle verrouillée de l’Acte I.
7. Les trois versions réellement présentées par le dialogue exigent trois fichiers enfants ; elles restent un seul contenu principal `PHOTO_SET`.

### 8.10 Conséquences et état de sortie

- Pauline et Bastien existent comme couple réel.
- La version publique de Pauline précède toute future double adresse.
- Marie est visible dans un monde social qui ne dépend pas seulement de Player.
- Nico existe comme ami et professionnel de salle.
- Mathilde reste une invitée ordinaire du foyer.
- Aucune route adulte, aucun secret, aucun accès privé.

### 8.11 Brief visuel J04-01

| Champ | Spécification |
|---|---|
| `asset_id` | `S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01` |
| Type | `PHOTO_DIÉGÉTIQUE` |
| Type de trace | `PHOTO_SET` |
| `trace_id` | `j04_pauline_bastien_public_set_01` |
| Fichiers enfants obligatoires | `..._FRAME_01`, `..._FRAME_02`, `..._FRAME_03` |
| Sujets visibles | Pauline, Bastien et Marie |
| Fonction relationnelle | Établir la version publique légitime de Pauline/Bastien et la place sociale de Marie ; Pauline P0 |
| Contexte de capture | dîner récent chez Pauline et Bastien ; set relayé à Player J04 matin |
| Créateur / caméra | Pauline ; smartphone ou appareil sur retardateur ; déclencheur compact Bluetooth canonique |
| Composition de travail | groupe réellement posé mais chaleureux ; Pauline dans le cadre, Bastien lisible comme personne, Marie participante ; table extensible, cuisine ou lampes de l’appartement comme contexte secondaire ; composition stable entre les trois frames |
| Tenues | Pauline en tenue publique composée ; Bastien ordinaire et soigné ; Marie sociale mais sans robe noire de reconquête imposée |
| Audience initiale | groupe social nommé : Pauline, Bastien, Marie, Player |
| Permanence | `PUBLIC_ACTIVE` selon T04 |
| Sauvegarde | `PUBLIC_SOURCE_RULES` ; public ne signifie pas libre de recadrage sexuel |
| Transfert | `PUBLIC_SOURCE_RULES`, sans recontextualisation privée ou pornographique |
| Galerie | éligible dans les onglets Pauline et Marie avec le même `asset_id`, sans duplication ; la frame sélectionnée devient la représentation principale du set |
| J14 / J21 | J14 : non seule ; J21 : oui |
| Variantes | aucune ; les trois frames sont des fichiers enfants obligatoires, pas des variantes |
| Dépendances | même dîner et mêmes tenues que J04-02 ; trois fichiers sources mais un seul contenu principal |
| Décision verrouillée | casting `[Pauline, Bastien, Marie]` ; Player destinataire hors cadre ; Nico et Mathilde absents |
| Interdits | crop privé ; Bastien effacé ou humilié ; Player visible ; Nico ou Mathilde ajoutés ; origine La Verrière ; frames comptées comme contenus principaux distincts ; pose sexy adressée à Player |

#### Décomposition obligatoire du `PHOTO_SET`

```text
S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01
├── S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01_FRAME_01
├── S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01_FRAME_02
└── S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01_FRAME_03
```

| Fichier enfant | Timing / posture / expression | Usage |
|---|---|---|
| `S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01_FRAME_01` | première prise ; le groupe est encore en train de se caler ; variation légère uniquement, sans changer casting, lieu, tenue, caméra ou audience | première des trois versions présentées dans le message ; ne devient pas une branche |
| `S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01_FRAME_02` | groupe globalement réveillé, posture tenue et expression assez naturelle pour être retenue | version recommandée par Pauline pour le groupe ; peut devenir la représentation principale du set en Galerie |
| `S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01_FRAME_03` | même composition au moment précis où Bastien comprend que la télécommande n’est pas magique ; réaction lisible mais non humiliante | version humoristique réellement proposée au choix ; peut devenir la représentation principale du set en Galerie |

Contrat commun aux trois frames :

- même casting : Pauline, Bastien, Marie ;
- même lieu : dîner récent chez Pauline et Bastien ;
- mêmes tenues ;
- même créatrice : Pauline via retardateur ;
- même audience : Pauline, Bastien, Marie, Player ;
- Player hors cadre ;
- Nico absent ;
- Mathilde absente ;
- variations limitées au timing, à la posture et à l’expression ;
- aucune frame ne crée une version privée, une nouvelle audience, une branche ou un nouveau contenu principal ;
- le message peut présenter une planche de trois vues ;
- la frame finalement sélectionnée peut devenir la représentation principale du set en Galerie, sous le même `asset_id` parent.

### 8.12 Brief visuel J04-02

| Champ | Spécification |
|---|---|
| `asset_id` | `S1_A1_J04_SCN_MARIE_SOCIAL_MOTION_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Sujet principal | Marie ; Pauline et Bastien visibles secondairement |
| Fonction relationnelle | Montrer Marie vivante dans un groupe et Pauline fiable avant toute future trahison |
| Contexte et moment | représentation de scène vécue du même dîner récent, distincte de la photographie posée |
| Composition de travail | Player en point de vue ; Marie en mouvement près de la table, Pauline règle un détail ou rejoint la scène, Bastien actif en cuisine ou autour du repas ; aucune personne ne regarde un objectif |
| Expression / posture | chaleur ordinaire, échange social crédible, pas de compétition entre femmes |
| Audience | joueur / mémoire de Player |
| Permanence | image de scène persistante |
| Sauvegarde | aucun fichier diégétique ; `can_share: false` |
| Transfert | impossible |
| Galerie | éligible dans les onglets Marie et Pauline avec le même `asset_id`, sans duplication ; type interne `SOUVENIR_IMAGE_DE_SCÈNE` |
| J14 / J21 | non / non |
| Variantes | aucune ; Mathilde est absente du set et n’est pas nécessaire à cette composition |
| Dépendances | continuité de lieu et de tenue avec J04-01 ; angle et action doivent rendre impossible la confusion avec une photo du set |
| Risque de confusion | moyen : une scène de dîner peut ressembler à un candid ; exclure tout signe de capture, flash, téléphone posé face au groupe ou regard caméra |
| Interdits | photo volée ; image possédée par Pauline ; tension sexuelle ; Pauline isolée de Bastien ; Marie jalouse |

### 8.13 Brief visuel J04-03

| Champ | Spécification |
|---|---|
| `asset_id` | `S1_A1_J04_SCN_NICO_SAVED_SEAT_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Sujet visible | Nico |
| Fonction relationnelle | Réinstaller une amitié masculine réelle et le monde de L’Annexe avant alibi, rivalité ou regard partagé ; Nico N0 |
| Contexte et moment | Côté Nico à L’Annexe pendant l’échange à distance où il garde ou propose une place ; l’image reste vraie si Player accepte, amende ou décline |
| Composition de travail | Nico près d’une chaise ou de tabourets dépareillés ; tablier noir, montre analogique, ouvre-bouteille rayé ; salle réelle, pas vide décoratif |
| Expression / posture | accueil direct, fatigue de service, attention à Player ; aucune domination caricaturale |
| Audience | joueur / représentation de scène de l’échange ; aucune connaissance visuelle diégétique supplémentaire pour Player |
| Permanence | image de scène persistante |
| Sauvegarde | aucun fichier diégétique ; `can_share: false` |
| Transfert | impossible |
| Galerie | éligible dans l’onglet Nico ; type interne `SOUVENIR_IMAGE_DE_SCÈNE` ; aucun onglet « Souvenir » |
| J14 / J21 | non / non |
| Variantes | aucune ; acceptation ou refus de l’invitation ne modifie pas l’image d’établissement de l’amitié |
| Dépendances | indépendant du set public J04-01 ; ne crée aucune connaissance sur Mathilde ou Marie |
| Interdits | femme visible comme objet de son regard ; photo sociale prise par Nico ; alibi ; message compromettant ; ambiguïté sexuelle Player/Nico ; alcool comme moteur de consentement |

### 8.14 Brief visuel J04-04

| Champ | Spécification |
|---|---|
| `asset_id` | `S1_A1_J04_SCN_HOUSEHOLD_THREE_RHYTHM_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Sujets visibles | Marie et Mathilde ; Player reste point de vue |
| Fonction relationnelle | Fermer l’Acte I sur le foyer transformé mais encore ordinaire |
| Contexte et moment | fin de J04, bureau devenu chambre, retour hors téléphone ou passage dans l’espace commun |
| Composition de travail | Marie et Mathilde dans deux actions domestiques compatibles ; porte de la petite chambre visible ; un rappel discret des affaires Mathilde sans répéter J02-01 |
| Expression / posture | familiarité familiale, légère friction possible, aucune tension érotique choisie |
| Audience | joueur / mémoire de Player |
| Permanence | image de scène persistante |
| Sauvegarde | aucun fichier diégétique ; `can_share: false` |
| Transfert | impossible |
| Galerie | éligible dans les onglets Marie et Mathilde avec le même `asset_id`, sans duplication ; type interne `SOUVENIR_IMAGE_DE_SCÈNE` |
| J14 / J21 | non / non |
| Variantes | aucune |
| Dépendances | paie visuellement T02 sans le transformer en photo ; ferme S01 ; continuité appartement J02 |
| Interdits | trio implicite ; canapé comme code sexuel ; image prise depuis une porte entrouverte ; preuve du séjour ; téléphone actif en co-présence |

---

## 9. Registre consolidé des 13 contenus visuels

| # | Jour | `asset_id` | Type | Sujet principal | Fichiers sources | Niveau | Galerie | J14 | J21 |
|---:|---|---|---|---|---:|---|---|---|---|
| 1 | J01 | `S1_A1_J01_SCN_MARIE_SHARED_KITCHEN_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie | 1 | M0 / V0 | onglet Marie | non | non |
| 2 | J01 | `S1_A1_J01_DPH_SANDRA_LUNCH_SELECTED_01` | `PHOTO_DIÉGÉTIQUE` | Sandra | 1 | SV0 / V0 | selon accès | oui si affichable | oui |
| 3 | J01 | `S1_A1_J01_SCN_MARIE_EVENING_RETURN_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie | 1 | M0 / V0 | onglet Marie | non | non |
| 4 | J02 | `S1_A1_J02_SCN_MATHILDE_FIRST_INSTALLED_VIEW_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | Mathilde | 1 | MT0 / V0 | onglet Mathilde | non | non |
| 5 | J02 | `S1_A1_J02_SCN_MARIE_HOLDS_HOUSEHOLD_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie | 1 | M0 / V0 | onglet Marie | non | non |
| 6 | J02 | `S1_A1_J02_SCN_FIRST_SHARED_EVENING_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie + Mathilde | 1 | M0/MT0 / V0 | onglets Marie + Mathilde, même asset | non | non |
| 7 | J03 | `S1_A1_J03_SCN_RAPHAELLE_ACCESSIBILITY_REVIEW_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | Raphaëlle | 1 | R0 / V0 | onglet Raphaëlle | non | non |
| 8 | J03 | `S1_A1_J03_SCN_RAPHAELLE_GARMENT_BAG_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | Raphaëlle | 1 | R0–R1 / V0 | onglet Raphaëlle | non | non |
| 9 | J03 | `S1_A1_J03_SCN_MARIE_HOME_FROM_LAVERRIERE_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie | 1 | M0 / V0 | onglet Marie | non | non |
| 10 | J04 | `S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01` | `PHOTO_DIÉGÉTIQUE` / `PHOTO_SET` | Pauline + Bastien + Marie | 3 | P0 / V0–V1 | onglets Pauline + Marie, même asset | non seule | oui |
| 11 | J04 | `S1_A1_J04_SCN_MARIE_SOCIAL_MOTION_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie + Pauline + Bastien | 1 | M1 / V1 | onglets Marie + Pauline, même asset | non | non |
| 12 | J04 | `S1_A1_J04_SCN_NICO_SAVED_SEAT_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | Nico | 1 | N0 / V0 | onglet Nico | non | non |
| 13 | J04 | `S1_A1_J04_SCN_HOUSEHOLD_THREE_RHYTHM_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie + Mathilde | 1 | M0/MT0 / V0 | onglets Marie + Mathilde, même asset | non | non |
| **Total** |  | **13 contenus principaux** | **2 photos / 11 images de scène** |  | **15** |  |  |  |  |

Règles :

- chaque ligne correspond à un contenu principal distinct ;
- les trois frames T04 sont trois fichiers enfants du contenu principal no 10 ;
- elles ne créent ni quatorzième contenu ni variante ;
- les références croisées dans plusieurs onglets Galerie utilisent le même `asset_id` ;
- aucun placeholder existant n’est considéré comme asset livré ;
- aucun `FACT_RECORD` n’apparaît dans ce registre comme photo.

---

## 10. Matrice image de scène / photo diégétique / trace

| Contenu ou état | Existe comme fichier dans l’univers | Créateur requis | Découvrable | Transférable | Peut servir de preuve | Galerie |
|---|---:|---:|---:|---:|---:|---|
| `SOUVENIR_IMAGE_DE_SCÈNE` | non | non | non | non | non | éligible dans l’onglet du personnage concerné ; aucun onglet « Souvenir » |
| Photo Sandra J01 | oui | Sandra | seulement selon T01 | non | trace relationnelle, pas preuve de tromperie | selon accès |
| Set public Pauline/Bastien/Marie J04 | oui, trois frames enfants | Pauline via retardateur | selon audience publique/sociale | selon règles source | trace sociale, pas preuve privée seule | même `asset_id` parent dans les onglets Pauline et Marie |
| T02 arrivée Mathilde | non, `FACT_RECORD` | aucun | non | non | fait du séjour uniquement | aucun fichier |
| T03 monde La Verrière J03 | non, `FACT_RECORD` | aucun | non | non | fait du monde Marie uniquement | aucun fichier |

### 10.1 Règle anti-confusion

Une image de scène peut représenter le même événement qu’un fait ou qu’une photo, mais :

- elle conserve son propre `asset_id` ;
- elle ne reçoit pas le `trace_id` ;
- elle ne change pas l’audience ;
- elle ne crée pas de copie ;
- elle n’est jamais affichée sur le téléphone d’un personnage ;
- elle ne peut pas être la trace découverte J14 ;
- elle ne peut pas être choisie comme trace finale J21.

### 10.2 Contenus à risque de confusion

| Asset | Risque | Contrôle |
|---|---|---|
| J02-01 | pourrait ressembler à la photo historique Marie | aucun regard caméra, aucune interface, aucune mention d’envoi |
| J03-03 | pourrait être pris pour `j03_marie_laverriere_setup_01` | scène au foyer, aucun événement La Verrière photographié |
| J04-02 | pourrait être pris pour un candid du dîner | angle vécu, aucun appareil, aucune pose |
| J04-04 | pourrait être pris pour une preuve du séjour | image de scène non diégétique, aucun fichier |

---

## 11. Matrice des audiences, sauvegardes, transferts et retraits

| `asset_id` / groupe | Audience | Permanence | Sauvegarde | Transfert | Retrait |
|---|---|---|---|---|---|
| 11 contenus `SOUVENIR_IMAGE_DE_SCÈNE` | joueur / représentation de scène | persistants si la scène est vécue | aucun fichier diégétique ; `can_share: false` | impossible | retrait de Galerie seulement par future règle système, sans effet narratif automatique |
| `S1_A1_J01_DPH_SANDRA_LUNCH_SELECTED_01` | Sandra + Player | active, restreinte, retirée ou inaccessible | fil uniquement par défaut | interdit | Sandra peut retirer l’accès ; connaissance conservée |
| `S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01` et ses trois frames | Pauline, Bastien, Marie, Player | `PUBLIC_ACTIVE` | règles de la source publique/sociale | règles de la source, sans recontextualisation sexuelle | retrait futur seulement par source ou décision canonique |

Distinctions obligatoires :

```text
vu
!=
revu en Galerie
!=
fichier possédé
!=
fichier transférable
```

---

## 12. Variantes conditionnelles réellement nécessaires

### 12.1 Verdict

```text
VARIANTE CONDITIONNELLE : 0
```

Les trois frames de T04 ne sont pas des variantes. Elles sont les trois fichiers enfants obligatoires d’un même `PHOTO_SET`, parce que le dialogue affiche réellement trois versions et permet de retenir la version 2 ou 3.

### 12.2 Variantes refusées

| Variante envisagée | Décision | Motif |
|---|---|---|
| J01 Marie selon promesse payée/refusée | refusée | différence émotionnelle seulement ; une composition neutre reste vraie |
| J02 selon aide Player | refusée | l’installation existe dans tous les cas |
| J03 avec/sans Sandra | refusée | Sandra n’obtient aucun nouveau visuel ; le budget repose sur Raphaëlle + Marie |
| J04 version 1 / 2 / 3 comme contenus principaux | refusée | ce sont trois fichiers enfants d’un seul `PHOTO_SET` |
| J04 variante avec Mathilde | refusée | casting verrouillé ; Mathilde est absente du set |
| J04 Nico ajouté au dîner | refusée | fausse convergence ; S07 reste séparée |
| J04 Player visible | refusée | Player reste non identifiable pendant l’Acte I |
| J04 humeur positive/négative | refusée | aucune différence de casting ou d’audience |

### 12.3 Coût disproportionné explicitement signalé

Produire des combinaisons de casting :

```text
avec Mathilde
avec Nico
avec Player visible
```

serait à la fois disproportionné et contraire au casting verrouillé. Les trois seuls fichiers supplémentaires requis sont les frames 01–03 du même set, avec casting et audience constants.

---

## 13. Réutilisations et recontextualisations autorisées

### 13.1 Autorisées

1. Réafficher le même contenu `SOUVENIR_IMAGE_DE_SCÈNE` avec le même `asset_id`, sans le recompter comme nouveau contenu.
2. Réafficher T01 en J18 ou J21 selon son état réel.
3. Créer plus tard une impression dérivée de T01 avec :
   - nouvel identifiant ;
   - propriétaire distinct ;
   - origine explicitement liée ;
   - aucune restauration d’un accès retiré.
4. Réafficher T04 en J21 comme set public antérieur, avec la frame principale réellement sélectionnée et le même `asset_id` parent.
5. Utiliser les mêmes références de décor, tenue et lumière pour assurer la continuité d’un même set :
   - J03-01 / J03-02 ;
   - J04-01 / J04-02.
6. Référencer un contenu `SOUVENIR_IMAGE_DE_SCÈNE` dans un dialogue futur sans le rendre diégétique.
7. Référencer un contenu multi-personnages dans plusieurs onglets Galerie avec le même `asset_id`, sans copier le fichier.
8. Présenter T04 dans le message sous forme de planche de trois vues, puis utiliser la frame 2 ou 3 sélectionnée comme représentation principale en Galerie.

### 13.2 Interdites

- dupliquer un asset sous un nouvel identifiant pour augmenter le quota ;
- compter les trois frames du set Pauline comme trois contenus principaux ;
- réduire les trois frames obligatoires à un seul fichier ou à trois crops identiques ;
- transformer J02-01 en photo envoyée par Marie ;
- transformer J03-03 en photo La Verrière ;
- utiliser un `SOUVENIR_IMAGE_DE_SCÈNE` comme trace J14 ;
- envoyer un `SOUVENIR_IMAGE_DE_SCÈNE` à Nico, Marie ou un groupe ;
- dupliquer un asset multi-personnages pour chaque onglet Galerie ;
- restaurer la photo Sandra après retrait ;
- dériver un crop privé Pauline du set public sans scène et trace futures ;
- utiliser la photo publique comme permission érotique ;
- faire du déclencheur physique de T01 le propriétaire de l’image.

---

## 14. Contrôle des traces, promesses et connaissances

### 14.1 Traces

| ID | Jour | Contrôle NAR-PROD-02 |
|---|---|---|
| T01 `j01_sandra_lunch_memory_soft` | J01 | photo produite ; créateur, audience, sauvegarde et transfert fixés |
| T02 `j02_mathilde_arrival_room_01` | J02 | reste `FACT_RECORD` ; aucun asset photo ; future adaptation : suppression complète de `msg_wed_marie_arrival_002` et du `content_id mathilde_arrival_room_01` |
| T03 `j03_marie_laverriere_setup_01` | J03 | reste `FACT_RECORD` ; aucun asset photo |
| T04 `j04_pauline_bastien_public_set_01` | J04 | un `PHOTO_SET` principal, casting fixe Pauline/Bastien/Marie, composé de trois frames enfants obligatoires ; zéro variante |

### 14.2 Promesses

| ID | Création | Fermeture exigée |
|---|---|---|
| P01 `marie_j01_shared_evening` | seulement si Player accepte un temps concret | payée, amendée ou refusée J01 |
| P02 `mathilde_j02_arrival_help` | choix d’aide face à l’urgence | payée, refusée ou échouée J02 |

Ne sont pas des promesses :

- « on se revoit » implicite Sandra J01 ;
- curiosité sur Raphaëlle J03 ;
- place Nico J04 sans acceptation future structurée ;
- hospitalité Mathilde ;
- disponibilité sociale Pauline.

### 14.3 Connaissances

| Fait | Connaisseurs initiaux | Interdit |
|---|---|---|
| F01 couple Marie/Player | réseau proche selon contexte | connaître les règles privées du couple |
| F02 séjour Mathilde | Marie, Player, Mathilde | connaissance automatique par Nico/Pauline |
| F03 couple Pauline/Bastien | réseau social / public | déduire infidélité ou compartiment |
| F04 monde La Verrière Marie | Player selon scène, réseau concerné | déduire disponibilité ou jalousie |
| F05 Raphaëlle collègue | Player / cadre professionnel | déduire accès créatif |
| F06 Nico ami | Player / réseau concerné | déduire confidence ou alibi |
| F07 Sandra connaît Player d’avant Marie | personnes à qui l’historique est connu | déduire intimité privée actuelle |
| F08 Player a vu la photo Sandra | Sandra, Player | connaissance automatique de Marie |

### 14.4 Absence d’omniscience

- Marie ne connaît pas T01 automatiquement.
- Sandra ne connaît pas les postures de Player avec Raphaëlle ou Mathilde.
- Pauline ne connaît pas la règle privée du couple.
- Nico ne sait rien de l’intention de Mathilde ou de Marie sans déclaration/observation.
- Raphaëlle ne diagnostique pas le couple depuis un comportement professionnel.
- Bastien ne devient ni naïf caricatural ni témoin omniscient.

---

## 15. Contrôle de cohérence inter-journées

### 15.1 J01 → J02

- Mathilde est indirecte J01 et active seulement J02.
- Aucun asset Mathilde J01.
- Le couple reste suffisamment vivant pour que l’accueil de Mathilde soit une décision de foyer crédible.

### 15.2 J02 → J03

- Le séjour Mathilde est actif même si Player n’a pas aidé.
- J03 ne transforme pas immédiatement cette proximité en tension.
- Le pivot bascule vers le travail réel de Raphaëlle.

### 15.3 J03 → J04

- Raphaëlle reste professionnelle.
- Le monde La Verrière de Marie est un fait, pas une photographie active.
- J04 sépare le social Pauline/Bastien du professionnel Raphaëlle.
- Nico est introduit comme ami, pas comme observateur sexuel.

### 15.4 Sortie J04

- Marie reste centre dramatique et apparaît dans les quatre journées.
- Sandra possède une seule trace privée contrôlée.
- Mathilde possède une présence domestique, aucune photo diégétique.
- Pauline possède un seul `PHOTO_SET` public ; sa frame principale peut être la 2 ou la 3.
- Raphaëlle possède deux contenus `SOUVENIR_IMAGE_DE_SCÈNE`, aucun fichier diégétique.
- Nico possède un contenu `SOUVENIR_IMAGE_DE_SCÈNE` d’amitié, aucune image de femme.
- aucune route extérieure n’est dominante de manière irréversible.

### 15.5 Tests de cohérence

| Test | Résultat attendu |
|---|---|
| Retirer T01 | J01 conserve trois contenus vus comme expérience, mais l’image complète Sandra devient inaccessible selon état ; l’image de scène ne restaure pas le fichier |
| Refuser P01 | J01 reste à trois contenus, sans récompense romantique supplémentaire |
| Refuser P02 | Mathilde arrive ; J02 reste à trois contenus `SOUVENIR_IMAGE_DE_SCÈNE` |
| Laisser Sandra expirer J03 | aucun trou visuel ; Raphaëlle x2 + Marie x1 |
| Refuser Nico J04 | J04-03 reste l’image de scène d’amitié, pas une promesse |
| Sélectionner la frame 2 | même contenu T04 ; frame 2 comme représentation principale possible |
| Sélectionner la frame 3 | même contenu T04 ; frame 3 comme représentation principale possible |
| Chercher Mathilde, Nico ou Player dans T04 | aucune frame conforme ne les montre ; aucune variante autorisée |
| Chercher une trace J14 | seuls T01 si affichable ou autres traces enregistrées sont candidates ; aucun `SOUVENIR_IMAGE_DE_SCÈNE` |

---

## 16. Points de doute ou décisions encore nécessaires

### 16.1 Contradictions documentaires constatées

1. **Plan `12` vs consolidation J01**
   Le plan conserve le diagnostic « réécriture Sandra obligatoire ». Le fichier `chapter_01_sandra_trace` et la source consolidée ont absorbé la correction. Le diagnostic est historique.

2. **Photo J02 vs T02**
   Le plan et le placeholder historique attribuent une photo à Marie. La source consolidée et le registre fixent `FACT_RECORD`, `creator: none`. Le présent paquet interdit la photo et impose pour l’adaptation future la suppression complète de `msg_wed_marie_arrival_002` et du `content_id mathilde_arrival_room_01`.

3. **Photo La Verrière J03 vs T03**
   L’ancien asset J03 est déplacé vers J09. Le présent paquet interdit une photo La Verrière J03.

4. **S03 « promesse de se revoir » vs registre**
   Aucune promesse Sandra J01 n’existe dans le registre. Cette formulation reste une ouverture émotionnelle, pas une obligation.

5. **J04 `laverriere_public_group_photo_set_01` vs T04**
   L’alias historique ne peut pas devenir T04 automatiquement. L’origine retenue est le dîner récent chez Pauline et Bastien, relayé J04. Le contenu canonique est `S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01` avec trois frames enfants.

6. **J03 retour Marie**
   L’ancien fichier `chapter_03_marie_event_return` existe, mais il est `RELOCATE / SPLIT`. La cartographie ligne par ligne du fragment actif `chapter_03_marie_evening_return` est désormais inscrite en §7.7.1 ; les anciennes familles déplacées sont exclues en §7.7.2.

### 16.2 Décisions visuelles non directement déductibles du canon

Ces choix sont des recommandations de production, pas de nouveaux faits narratifs :

- J01-01 : cuisine avec pain/tomates et une seule ancre entrée ;
- J01-03 : miroir d’entrée plutôt que promenade ;
- J02-02 : draps comme action visuelle de Marie ;
- J04-02 : image de scène du dîner depuis le point de vue Player.

Ne sont plus des décisions ouvertes :

- casting de T04 ;
- présence visuelle de Player ;
- nombre de frames T04 ;
- variante Mathilde.

### 16.3 Ambiguïtés de créateur ou d’audience

| Point | Résolution proposée |
|---|---|
| T01 : Player peut déclencher | Sandra reste créatrice et contrôle le fichier ; Player n’acquiert aucun droit |
| T02 : Marie photographe dans legacy | rejeté ; `creator: none`, `FACT_RECORD` |
| T03 : Élodie photographe possible dans ancien plan | rejeté pour J03 ; `FACT_RECORD` |
| T04 : participants exacts | casting fixe `[Pauline, Bastien, Marie]`; Nico et Mathilde absents |
| T04 : créateur | Pauline via retardateur pour les trois frames |
| T04 : audience | `[Pauline, Bastien, Marie, Player]` pour les trois frames |
| Player dans T04 | destinataire hors cadre, non identifiable |

### 16.4 Décisions restant à Ludovic

```text
AUCUNE DÉCISION PRODUIT RESTANTE
```

Décisions closes par la revue :

- T04 : Pauline, Bastien, Marie ;
- Player : destinataire hors cadre et non identifiable pendant l’Acte I ;
- Nico et Mathilde : absents du set ;
- T04 : un `PHOTO_SET`, trois fichiers enfants, zéro variante ;
- J02 : suppression future exacte de la ligne et du `content_id` legacy ;
- J03 : cartographie ligne par ligne intégrée.

### 16.5 Verdict des doutes

- aucun point ne justifie une restructuration narrative ;
- aucun point ne justifie un nouveau runtime ;
- aucun point ne justifie une nouvelle trace ;
- aucune correction produit ciblée ne reste ouverte dans NAR-PROD-02 ;
- aucune journée n’est `MISSING_SPEC` après les treize briefs.

---

## 17. Checklist de validation avant intégration Git

### 17.1 Autorité et périmètre

- [x] Le document reste un paquet dérivé, pas une seconde carte de saison.
- [x] Le sign-off, la source consolidée et les registres prévalent sur le plan `12` et le runtime.
- [x] Aucun dialogue signé n’a été réécrit.
- [x] Aucun JSON, code, test, UI ou asset n’a été modifié.
- [x] Aucun prompt ComfyUI définitif n’a été ajouté.

### 17.2 Comptage

- [x] J01 contient exactement 3 contenus principaux.
- [x] J02 contient exactement 3 contenus principaux.
- [x] J03 contient exactement 3 contenus principaux.
- [x] J04 contient exactement 4 contenus principaux.
- [x] Le total principal est exactement 13.
- [x] Le total de fichiers visuels sources est exactement 15.
- [x] T04 compte comme un seul contenu principal et trois fichiers enfants.
- [x] Le total de variantes conditionnelles est exactement 0.
- [x] Aucun crop ou placeholder n’est compté comme contenu distinct.

### 17.3 Types et traces

- [x] T01 et T04 sont les seules photos diégétiques du paquet.
- [x] Les onze autres contenus sont de type interne `SOUVENIR_IMAGE_DE_SCÈNE`, non transférables, non découvrables et `can_share: false`.
- [x] Aucun onglet ou libellé visible « Souvenir » n’est créé.
- [x] Les contenus multi-personnages utilisent le même `asset_id` dans plusieurs onglets, sans duplication.
- [x] T02 et T03 restent des `FACT_RECORD`.
- [x] Aucun `SOUVENIR_IMAGE_DE_SCÈNE` ne reçoit de `trace_id`.
- [x] Aucun `SOUVENIR_IMAGE_DE_SCÈNE` n’est éligible J14 ou J21.
- [x] La photo Sandra conserve sa règle de retrait.
- [x] Le set Pauline conserve sa source, son créateur et son audience.

### 17.4 Personnages et progression

- [x] Marie reste visible et centrale sur J01–J04.
- [x] Sandra n’est pas définie par le flou.
- [x] Mathilde reste sensuelle de manière ordinaire, sans intention sexuelle attribuée.
- [x] Pauline et Bastien sont un couple réel.
- [x] Raphaëlle reste professionnelle.
- [x] Nico reste ami hétérosexuel sans route avec Player.
- [x] Player reste hors cadre et non identifiable pendant l’Acte I.

### 17.5 Choix, refus et agency

- [x] Le refus ne crée aucune récompense de substitution.
- [x] Le refus ne fait pas tomber la journée sous son budget visuel.
- [x] Marie, Mathilde, Raphaëlle, Pauline et Nico continuent d’agir sans Player.
- [x] Les promesses P01 et P02 sont créées seulement après acceptation.
- [x] Aucun silence ne devient automatiquement consentement.
- [x] La co-présence arrête le chat.

### 17.6 Audiences et connaissances

- [x] Marie ne connaît pas automatiquement T01.
- [x] Nico ne connaît pas automatiquement le séjour Mathilde.
- [x] Le set public Pauline n’ouvre aucune version privée.
- [x] La suppression d’un fichier ne supprime pas la connaissance.
- [x] Public ne signifie pas libre de recadrage sexuel.
- [x] Le déclenchement de T01 ne transfère pas la propriété.

### 17.7 Corrections ciblées closes avant Git

- [x] Casting T04 verrouillé : Pauline, Bastien, Marie.
- [x] Player verrouillé comme destinataire hors cadre et non identifiable.
- [x] Nico et Mathilde exclus des trois frames T04.
- [x] T04 défini comme un seul `PHOTO_SET` avec trois fichiers enfants obligatoires.
- [x] Zéro variante conditionnelle.
- [x] J02 impose la suppression future complète de `msg_wed_marie_arrival_002`.
- [x] J02 impose la suppression future du `content_id mathilde_arrival_room_01`.
- [x] Les trois images de scène J02 sont maintenues.
- [x] Le fragment J03 actif est cartographié ligne par ligne sans réécriture.
- [x] Les anciennes familles J03 déplacées ne sont pas réintroduites.
- [x] Le `content_id` legacy J04 n’est pas utilisé comme identité canonique.
- [x] La Galerie ne crée aucune catégorie visible « Souvenir ».

---

# Synthèse finale

## Nombre exact de contenus principaux

```text
13
```

Répartition :

```text
J01 : 3
J02 : 3
J03 : 3
J04 : 4
```

## Nombre exact de variantes

```text
0 variante conditionnelle
```

Les trois frames T04 sont des fichiers enfants obligatoires d’un même `PHOTO_SET`, pas des variantes.

## Nombre exact de fichiers visuels sources

```text
15
```

Répartition :

```text
12 contenus principaux à fichier unique
+ 3 frames enfants T04
= 15 fichiers visuels sources
```

## Répartition par propriétaire dramatique principal

| Propriétaire principal | Contenus |
|---|---:|
| Marie | 5 |
| Sandra | 1 |
| Mathilde | 1 |
| Raphaëlle | 2 |
| Pauline / Bastien public | 1 |
| Nico | 1 |
| Foyer Marie / Mathilde partagé | 2 |
| **Total** | **13** |

## Répartition par apparitions visibles dans les 13 contenus principaux

Les contenus multi-personnages comptent pour chaque personne visible.

| Personnage | Apparitions principales |
|---|---:|
| Marie | 8 |
| Sandra | 1 |
| Mathilde | 3 |
| Pauline | 2 |
| Raphaëlle | 2 |
| Nico | 1 |
| Bastien | 2 |
| Player identifiable | 0 |

Les trois frames T04 conservent exactement Pauline, Bastien et Marie. Elles n’ajoutent pas trois apparitions au comptage des contenus principaux.

## Répartition PHOTO_DIÉGÉTIQUE / SOUVENIR

```text
PHOTO_DIÉGÉTIQUE : 2
SOUVENIR_IMAGE_DE_SCÈNE : 11
```

Photos diégétiques :

1. Sandra — déjeuner sélectionné J01 ;
2. Pauline / Bastien / Marie — set public relayé J04.

## Décisions restant à Ludovic

```text
AUCUNE
```

## Verdict J01–J04

| Jour | Verdict | Motif |
|---|---|---|
| J01 | `READY` | trois briefs complets ; T01 exacte ; sources dialogue identifiées |
| J02 | `READY` | correction future exacte inscrite ; aucune photo diégétique ; trois images de scène maintenues |
| J03 | `READY` | fragment actif après `SPLIT` cartographié ligne par ligne ; aucune ligne réécrite ni fonction déplacée réintroduite |
| J04 | `READY` | casting, audience et anonymat Player verrouillés ; un `PHOTO_SET`, trois frames enfants, zéro variante |

```text
J01–J04 — NARRATION : READY
J01–J04 — BRIEFS VISUELS : READY
J01–J04 — SOURCE DIALOGUE : READY
J01–J04 — MISSING_SPEC : AUCUN
CONTENUS PRINCIPAUX : 13
VARIANTES CONDITIONNELLES : 0
FICHIERS VISUELS SOURCES : 15
RUNTIME / UI / ASSETS : INCHANGÉS ET HORS PÉRIMÈTRE
```

---

## Validation produit

```text
VALIDATION PRODUIT : PASS
J01–J04 : READY
CONTENUS PRINCIPAUX : 13
FICHIERS VISUELS SOURCES : 15
VARIANTES CONDITIONNELLES : 0
DÉCISION PRODUIT RESTANTE : AUCUNE
```
