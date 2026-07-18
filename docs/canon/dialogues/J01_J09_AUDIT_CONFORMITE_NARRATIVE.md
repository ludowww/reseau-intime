# Réseau Intime — Audit de conformité narrative J01–J09

> **STATUT HISTORIQUE / SUPERSÉDÉ** — Les corrections J01–J06 sont consolidées dans `J01_J06_SOURCE_CANON_CONSOLIDE.md`; J07–J09 sont consolidés dans leurs scripts sources.


## Statut

**Catégorie : Canon**

**Autorité : audit transversal et corrections de conformité J01–J09**

**Périmètre : narration, voix, agency, conséquences, communication textuelle et fonctions visuelles**

Ce document vérifie J01 à J09 contre les autorités suivantes :

- `00_NORTH_STAR.md` ;
- `01_EXPERIENCE_JOUEUR.md` ;
- `03_GRAMMAIRE_NARRATIVE.md` ;
- `07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md` ;
- `08_REGLES_DES_SCENES_MODULAIRES.md` ;
- `09_PROGRESSION_VISUELLE_ET_PHOTOGRAPHIQUE.md` ;
- `10_CARTE_CONSEQUENCES_DETTES_SECRETS_OBLIGATIONS.md` ;
- `12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md` ;
- `12B_PLANS_SCENES_J09_J12.md` ;
- `13_BIBLE_VOIX_MESSAGERIE_ET_TESTS_DISTINCTION.md` ;
- les canons complets des personnages ;
- `TEXT_ONLY_MESSAGING_CANON.md`.

Il ne modifie :

- aucun JSON ;
- aucun script Godot ;
- aucun test ;
- aucun asset ;
- aucun état runtime.

En cas de contradiction avec une formulation antérieure des scripts J07–J09, les corrections précises du présent document prévalent jusqu’à consolidation future.

---

# 1. Question de l’audit

La question n’est pas seulement :

```text
Est-ce que la journée fonctionne ?
```

Elle est :

```text
Est-ce que la journée respecte réellement
la North Star,
l’autonomie des personnages,
la voix,
le consentement,
les conséquences attribuables,
le text-only,
la fonction des images,
et l’agence du joueur ?
```

---

# 2. Échelle de verdict

## `CONFORME`

La journée respecte le canon narratif et son contrat produit, hors production finale des assets.

## `CONFORME NARRATIVEMENT — VISUELS À PRODUIRE`

La causalité, les personnages, les choix et les conséquences sont conformes.

Le contrat visual-first n’est pas encore matérialisé par trois contenus finalisés.

## `CONFORME SOUS CORRECTIONS DOCUMENTAIRES`

Le noyau est conforme mais une formulation, une option forcée, une audience visuelle ou une règle de fallback doit être corrigée.

## `NON CONFORME RUNTIME`

La narration canonique est identifiable mais le runtime actif applique encore une logique contradictoire.

---

# 3. Verdict global

| Jour | Noyau narratif | Voix | Agency | Text-only | Conséquences | Contrat visuel | Verdict |
|---|---|---|---|---|---|---|---|
| J01 | solide | solide | solide | correction mineure hors téléphone | attribuables | 1/3 actif | conforme narrativement, visuels et beat à corriger |
| J02 | solide | solide | solide | transition ambiguë | attribuables | 1/3 actif | conforme narrativement, visuels et libellé à corriger |
| J03 | solide après restructuration | solide | solide | conforme | attribuables | 0/3 actif | conforme narrativement, visuels à produire |
| J04 | solide après nouvelle origine | solide | solide | conforme | attribuables | 1/3 actif | conforme narrativement, visuels à produire |
| J05 | solide | solide | solide | conforme | attribuables | 0/3 actif | conforme narrativement, visuels à produire |
| J06 | dialogue solide | solide | solide dans le texte | conforme | retour Marie solide | 0/3 actif | **runtime actif non conforme** |
| J07 | solide | solide | promesse Nico forcée | conforme | préparation J08 solide | contrat visuel mal centré | corrections obligatoires |
| J08 | solide | solide | suppose Nico obligatoire | conforme | très attribuables | contrat visuel mal centré | corrections obligatoires |
| J09 | solide | solide | dîner J10 parfois forcé | conforme | attribuables | métadonnées insuffisantes | corrections obligatoires |

Conclusion :

```text
architecture relationnelle J01–J09 : cohérente
voix : globalement distinctes
consentement et limites : cohérents
text-only : presque conforme
agency : deux promesses forcées à corriger
visual-first : incomplet sur toutes les journées
runtime J06 : contradictoire avec le canon
```

---

# 4. Conformité à la North Star

## 4.1 Routes invisibles

J01–J09 ne présentent aucun menu :

```text
Marie
Sandra
Mathilde
Pauline
Raphaëlle
Nico
```

comme destination abstraite.

Les choix portent sur :

- présence ;
- heure ;
- observation ;
- participation ;
- limite ;
- amendement ;
- priorité ;
- refus ;
- qualité d’attention.

**Verdict : conforme.**

## 4.2 Relations lentes et crédibles

- Sandra progresse par représentation choisie, pas par récompense ;
- Mathilde passe de l’accueil familial à un regard reconnu, sans intention sexuelle déclarée ;
- Pauline reste publique et liée à Bastien ;
- Raphaëlle reste professionnelle ;
- Nico devient confident intéressé mais non autorisé ;
- Marie reste centre de gravité et vie désirable.

**Verdict : conforme.**

## 4.3 Personnages autonomes

Les personnages continuent d’agir sans Player :

- Marie vit son marché et La Verrière ;
- Sandra ferme ses fenêtres ;
- Mathilde s’installe et gère son constat ;
- Pauline protège la vie officielle ;
- Raphaëlle termine le travail ;
- Nico ouvre son service et rend la chaise.

**Verdict : conforme.**

---

# 5. J01 — Les choses qu’on remarque

## Forces conformes

- Marie existe avant le conflit ;
- la demande porte sur pain, dîner et marche ;
- le temps hors téléphone paie le choix ;
- Sandra initie ;
- la photo a été revue, gardée, recadrée et choisie ;
- Sandra ferme elle-même ;
- aucune route active ;
- Mathilde reste indirecte ;
- le retour final appartient au couple.

## Voix

### Marie

- humour pratique ;
- vie commune ;
- acte concret ;
- chaleur puis sérieux.

### Sandra

- peu de rafales ;
- minimisation ;
- un seul `Haha.` ;
- contrôle de représentation ;
- fermeture douce.

**Verdict voix : conforme.**

## Écart text-only

Les beats hors téléphone contiennent encore des répliques orales directes :

```text
« Message à prouver. Coupe le fromage. »
« Ne promets pas mieux. Fais un petit truc vrai. »
```

Le canon text-only autorise une transition narrative brève, mais elle doit rester non conversationnelle.

### Correction canonique future

Remplacer par narration indirecte :

```text
Marie lui tend le couteau à fromage.
Le geste concret remplace la meilleure promesse.
```

Aucune parole orale complète n’est montrée.

## Contrat visuel J01

### Actif

1. Sandra — ancienne photographie choisie.

### Slots manquants

2. Marie — contexte La Verrière ou préparation du dîner, centrée personnage ;
3. Marie — image de scène du temps partagé ou du retour final, non diégétique si personne ne photographie.

### Règles

- la photo Sandra reste destinée à Player ;
- réception ne signifie pas transfert autorisé ;
- les images Marie ne doivent pas être de simples objets ou décors.

## Verdict J01

```text
CONFORME NARRATIVEMENT
+ correction text-only mineure
+ deux contenus visuels à produire
```

---

# 6. J02 — Faire de la place

## Forces conformes

- urgence réelle ;
- Marie agit avant Player ;
- aucune sexualisation de l’urgence ;
- Player choisit la qualité de sa participation ;
- Mathilde obtient un accès domestique ordinaire uniquement ;
- le chat s’arrête au retour de Player ;
- l’installation continue hors téléphone ;
- Marie reste structurelle.

## Appel hors champ

La ligne :

```text
Mathilde vient de m’appeler.
```

est autorisée.

L’appel est extérieur à l’expérience du joueur et n’est pas une scène jouée.

## Écart de transition

Le texte d’index :

```text
Marie appelle entre deux tâches
```

peut laisser croire que Marie appelle Player.

### Correction canonique future

```text
Marie écrit entre deux tâches après l’urgence de Mathilde.
```

## Contrat visuel J02

### Actif

1. trace d’arrivée de Mathilde.

### Slots manquants

2. Marie — préparation du bureau / faire de la place ;
3. Marie et Mathilde — image de scène ou trace de l’installation terminée.

## Verdict J02

```text
CONFORME NARRATIVEMENT
+ libellé de transition à corriger
+ deux contenus visuels à produire
```

---

# 7. J03 — Les vies ailleurs

## Forces conformes

- Raphaëlle est le pivot professionnel ;
- Sandra reste un écho optionnel ;
- Marie ramène la journée au foyer ;
- aucun vernissage ;
- aucune superposition ;
- aucune route R2 ;
- le foyer continue avec ou sans Player ;
- les beats hors téléphone ne reproduisent pas de conversation orale.

## Voix

- Raphaëlle précise, professionnelle, non thérapeutique ;
- Sandra courte et non foreground ;
- Marie pratique et liée à une heure.

**Verdict voix : conforme.**

## Contrat visuel J03

1. Raphaëlle — travail et accessibilité, centrée personnage ;
2. Sandra — trace ordinaire après poste ou absence visuelle signifiée par un contenu de respiration centré Sandra ;
3. Marie / Mathilde — foyer, soupe ou retour, centrées personnages.

Le placeholder La Verrière historique reste déplacé vers J09 et ne compte pas pour J03.

## Verdict J03

```text
CONFORME NARRATIVEMENT
+ trois contenus visuels à produire
```

---

# 8. J04 — Le réseau devient concret

## Forces conformes

- Pauline existe avec Bastien dans une vie sociale légitime ;
- l’origine du set est indépendante de J03 ;
- l’audience est connue ;
- aucune version privée ;
- Nico existe comme ami avant alibi ;
- Marie est la source de l’information Mathilde ;
- Nico ne sexualise pas le séjour ;
- les échos foyer ne font pas progresser Mathilde ;
- l’ouverture se ferme sans route R2.

## Contrat visuel J04

### Actif

1. Pauline / Bastien / groupe — set social autorisé.

### Slots manquants

2. Marie — rapport du foyer ou vie commune ;
3. Mathilde — friction domestique légère ou autonomie dans le nouvel espace.

Nico peut recevoir un contenu visuel supplémentaire, mais il ne remplace pas le minimum de trois contenus principalement centrés sur les femmes.

## Verdict J04

```text
CONFORME NARRATIVEMENT
+ deux contenus visuels à produire
```

---

# 9. J05 — Une heure

## Forces conformes

- Marie possède déjà son samedi ;
- Player peut rejoindre ;
- proposer une alternative précise ;
- ou laisser Marie vivre son heure ;
- les engagements sont payés hors téléphone ;
- aucune route extérieure n’est injectée après un refus ;
- zéro progression extérieure est un résultat canonique valide.

## Écart documentaire historique

Le plan J05 décrivait un slot extérieur possible.

La règle supérieure autorise :

```text
zéro ou une continuité extérieure
```

La version Marie-only est donc conforme.

## Contrat visuel J05

1. Marie — mouvement du marché / café ;
2. Marie — heure partagée, alternative ou autonomie ;
3. respiration centrée sur une femme principale : Mathilde au foyer, Sandra dans sa vie ou Marie après l’heure, sans progression forcée.

## Verdict J05

```text
CONFORME NARRATIVEMENT
+ trois contenus visuels à produire
```

---

# 10. J06 — Ce qu’on a vu

## Dialogue conforme

La scène Mathilde respecte :

- tenue domestique ordinaire ;
- regard remarqué ;
- possibilité de reconnaître ;
- plaisanter ;
- restaurer la distance ;
- aucune permission sexuelle ;
- agency Mathilde.

Le retour Marie respecte :

- retour obligatoire ;
- acte immédiat ;
- acte borné ;
- non-réparation honnête ;
- conséquences des faits précédents.

## Runtime actif non conforme

Le runtime principal contient encore :

```text
candidate_pool
external_ticket_limit
wave_id
unique owner R2
MATHILDE_R2_MAX
```

Il peut déclarer Mathilde propriétaire R2 automatiquement.

Cela contredit :

- routes invisibles ;
- aucune propriété automatique ;
- possibilité d’aucune progression extérieure ;
- scène qui ne crée pas une route ;
- refus respecté ;
- conséquence attribuable.

## Autorité narrative correcte

J06 doit être compris comme :

```text
Mathilde = continuité optionnelle directe
vue, expirée ou différée
aucun ticket
aucune propriétaire
aucun R2 automatique
retour Marie obligatoire
```

La PR technique #54 contient une proposition de correction, mais elle reste draft, non fusionnée et non autoritative pendant la phase narrative.

## Contrat visuel J06

1. Mathilde — version domestique ordinaire, centrée personnage ;
2. Mathilde — conséquence, distance ou autonomie ;
3. Marie — retour du soir et état du couple.

## Verdict J06

```text
NARRATION CANONIQUE IDENTIFIÉE
RUNTIME ACTIF NON CONFORME
+ trois contenus visuels à produire
```

---

# 11. J07 — Ce qu’on ne dit qu’à une personne

## Noyau conforme

- source principale : `S13` ;
- Nico pivot unique ;
- Raphaëlle et Marie créent des obligations préparant `S14` ;
- Nico sait uniquement ce qu’il observe ou ce que Player dit ;
- Nico nomme son intérêt ;
- aucune femme n’est autorisée ;
- aucune image privée n’est demandée ;
- le foyer reste distinct de la route Mathilde.

## Carte de conformité des scènes

### `j07_raphaelle_mobile_review_obligation`

```text
scene_class: ECHO_OBLIGATION
source_sequence_id: S14_PREPARATION
primary_function: créer une attente professionnelle réelle
primary_relationship: Player / Raphaëlle
```

### `j07_nico_quiet_confidence`

```text
scene_class: PILLAR
source_sequence_id: S13
primary_function: définir écoute, permission ou complice
primary_relationship: Player / Nico
```

### `j07_marie_household_request`

```text
scene_class: OBLIGATION
source_sequence_id: S14_PREPARATION
primary_function: créer, amender ou fermer une attente domestique
primary_relationship: Player / Marie
```

`S14_PREPARATION` est une désignation documentaire de beat supportant S14, pas une nouvelle séquence autonome.

## Écart d’agency

La version validée contient :

```text
Nico : Passe à 18 h 45 si tu veux.
Player : je passe. 18 h 45
```

La réponse Player est guidée alors que la formulation offre un choix.

Une promesse qui crée J08 ne doit pas être forcée.

## Correction canonique J07

Après la proposition de Nico, Player reçoit trois réponses :

### N1 — Accepter

```text
je passe. 18 h 45
```

Nico :

```text
Ça marche.
Si tu annules, annule.
Ne me fais pas garder une chaise pour une philosophie.
```

État :

```text
attente Nico mardi 18 h 45
```

### N2 — Différer précisément

```text
pas demain. jeudi avant ton service, je te confirme avant midi
```

Nico :

```text
Jeudi n’est pas réservé.
Tu confirmes avant midi ou ça n’existe pas.
```

État :

```text
aucune attente Nico mardi
option jeudi conditionnelle
```

### N3 — Fermer la continuation

```text
non. on laisse ça là pour l’instant
```

Nico :

```text
D’accord.
Je garde la confidence, pas la chaise.
```

État :

```text
aucune attente Nico
confidence conservée
```

## Contrat visuel corrigé J07

Le minimum produit doit rester principalement centré sur les femmes adultes principales.

### V1 — Raphaëlle

```text
type: image de scène ou photo diégétique de travail
function: responsabilité professionnelle ordinaire
audience: Player si diégétique
```

### V2 — Marie

```text
type: image de scène
function: foyer, pochette bleue, vie commune
non_circulable: true
```

### V3 — Mathilde

```text
type: image de scène ou trace diégétique
function: vie autonome liée au constat, sans progression de route
audience: familiale ou privée selon origine
```

Nico / L’Annexe peut recevoir un contenu supplémentaire.

Il ne compte pas à la place du minimum féminin.

## Verdict J07

```text
CONFORME APRÈS CORRECTION D’AGENCY ET VISUELLE
```

---

# 12. J08 — Ce qui ne tient pas ensemble

## Noyau conforme

- source principale : `S14` ;
- obligations créées auparavant ;
- priorité, anticipation et amendement ;
- choix vague sans réussite cachée ;
- Raphaëlle non romantisée ;
- Nico accepte l’annulation ;
- Marie et Mathilde agissent sans Player ;
- conséquences attribuables.

## Carte de conformité

```text
scene_class: PILLAR_OR_MUTATION
source_sequence_id: S14
primary_function: rendre le temps relationnel
primary_relationship: variable selon obligations actives
```

## Écart d’entrée

La version validée suppose que le rendez-vous Nico existe dans toutes les parties.

La correction J07 permet désormais :

- Nico accepté ;
- Nico différé ;
- Nico fermé.

J08 doit donc lire seulement les attentes réellement créées.

## Configurations canoniques J08

### A — Raphaëlle + Nico + foyer

Triple superposition.

### B — Raphaëlle + Nico

Le foyer a été refusé ou déjà payé.

### C — Raphaëlle + foyer

Nico a été différé ou fermé.

### D — Raphaëlle seule

Nico et le foyer ont été fermés clairement.

Le jeu ne doit pas inventer une deuxième attente.

La journée mute en :

```text
S14_MUTATION_CLEAR_BOUNDARIES
```

Fonction :

```text
montrer que des refus clairs ont empêché la collision
et permettre à Player de payer ou non Raphaëlle sans faux climax
```

Cette mutation ne constitue pas une nouvelle séquence de route.

Elle est le fallback de S14 lorsque les conditions de superposition ne sont plus vraies.

## Règle de choix

Les choix principaux ne montrent que les responsabilités actives.

Aucun message Nico si Nico n’attend pas.

Aucun message foyer si le constat a été refusé ou déjà payé.

## Contrat visuel corrigé J08

### V1 — Raphaëlle

```text
function: responsabilité de travail / conséquence professionnelle
center: Raphaëlle
```

### V2 — Mathilde

```text
function: constat, autonomie ou solution trouvée sans Player
center: Mathilde
```

### V3 — Marie

```text
function: conséquence du foyer ou préparation de La Verrière pour J09
center: Marie
```

Nico / chaise vide peut recevoir un quatrième contenu facultatif.

Il ne remplace pas les trois contenus principalement centrés sur les femmes.

## Verdict J08

```text
CONFORME APRÈS LECTURE CONDITIONNELLE DES ATTENTES
+ fallback sans superposition
+ correction visuelle
```

---

# 13. J09 — Dans son élément

## Noyau conforme

- source : `S15` ;
- Marie pivot unique ;
- raison professionnelle et sociale ;
- robe noire choisie avant le choix Player ;
- besoin logistique distinct de l’envie ;
- présence tôt, tardive ou absence honnête ;
- qualité de présence ;
- autonomie Marie ;
- messages logistiques uniquement en co-présence ;
- retour émotionnel après séparation ;
- aucune route extérieure sélectionnée.

## Carte de conformité des scènes

### `j09_marie_laverriere_offer`

```text
scene_class: PILLAR
source_sequence_id: S15
primary_function: choisir une qualité de présence dans la vie visible de Marie
primary_relationship: Player / Marie
```

### `j09_marie_same_venue_presence`

```text
scene_class: PILLAR_VARIANT
source_sequence_id: S15
primary_function: distinguer aide, regard, distraction et présence bornée
primary_relationship: Player / Marie
```

### `j09_marie_after_separation`

```text
scene_class: CONSEQUENCE
source_sequence_id: S15
primary_function: rendre lisible ce que la soirée a réellement changé
primary_relationship: Player / Marie
```

## Écart d’agency

Plusieurs branches font demander à Marie :

```text
Demain 20 h 30 ?
```

puis imposent une réponse guidée positive.

Une nouvelle obligation J10 ne doit pas être forcée.

## Correction canonique du retour J10

Dans les branches :

- présence active ;
- arrivée tardive active ;
- présence bornée ;
- absence honnête ;

Marie peut proposer :

```text
Demain, 20 h 30, on mange ensemble ?
```

Player choisit :

### M1 — Accepter

```text
oui. 20 h 30
```

État : dîner J10 confirmé.

### M2 — Proposer une vraie alternative

```text
demain non. vendredi 20 h 30 ?
```

Marie peut répondre :

```text
Vendredi, oui.
Je bloque quand même une vraie heure.
```

État : obligation J11 possible.

### M3 — Refuser sans laisser attendre

```text
je ne peux pas. ne bloque rien pour moi
```

Marie :

```text
D’accord.
Je n’attends pas.
```

État : aucune obligation couple créée.

Les branches présence distraite et présence de spectateur ne créent toujours aucun dîner automatique.

## Contrat visuel corrigé J09

### V1 — Préparation privée choisie par Marie

```text
type: PHOTO_DIÉGÉTIQUE
creator: Marie
origin: préparation avant l’événement
intended_audience: Player
function: représentation choisie / robe noire
saving: consultable dans le fil
transfer: non autorisé hors nouvel accord
```

Le cadrage et la pose restent différés.

### V2 — Marie visible à La Verrière

```text
type: PHOTO_DIÉGÉTIQUE
creator: Élodie ou tiers nommé autorisé
origin: événement La Verrière
intended_audience: groupe photographié / partage social autorisé
function: visibilité professionnelle et sociale
saving: autorisée dans l’audience nommée
transfer: seulement selon le cadre social établi
```

### V3 — Fin de soirée recontextualisée

```text
type: PHOTO_DIÉGÉTIQUE
creator: Élodie
subject: Marie principalement
origin: fermeture ou fin de soirée
initial_audience: Marie / groupe autorisé
private_relay: Marie choisit de l’envoyer à Player
function: mémoire partagée, autonomie ou conséquence
saving: consultable dans le fil
transfer: interdit hors audience sans nouvel accord
```

La fonction varie selon :

- présence active ;
- présence de spectateur ;
- absence ;
- distraction.

## Verdict J09

```text
CONFORME APRÈS MICRO-CHOIX J10
+ contrat visuel précisé
```

---

# 14. Conformité des voix J01–J09

## Marie

Distincte par :

- mouvement ;
- heures ;
- vie partagée ;
- humour pratique ;
- demande d’acte ;
- autonomie sans retrait passif.

## Sandra

Distincte par :

- représentation choisie ;
- minimisation ;
- silence ;
- fermeture douce ;
- faible volume.

## Mathilde

Distincte par :

- vitesse ;
- correction ;
- embarras ;
- mauvaise foi ;
- droit dosé.

## Pauline

Distincte par :

- contrôle d’audience ;
- timing sec ;
- public / privé ;
- Bastien visible.

## Raphaëlle

Distincte par :

- précision professionnelle ;
- question ou date ;
- refus du vague ;
- aucune captation émotionnelle du travail.

## Nico

Distinct par :

- salle ;
- chaise ;
- service ;
- désir social concret ;
- humour qui tombe ;
- intérêt personnel reconnu.

## Player

Distinct par :

- minuscules ;
- réponses courtes ;
- première réponse parfois insuffisante ;
- capacité de précision ou de vague ;
- absence de séduction parfaite.

## Verdict voix

```text
CONFORME
```

Vigilance :

- limiter les lignes parfaitement citables ;
- conserver des messages banals ;
- ne pas transformer Raphaëlle en formulation toujours supérieure ;
- ne pas transformer Nico en thérapeute ;
- ne pas transformer Marie en unique détentrice de l’intelligence émotionnelle.

---

# 15. Conformité text-only J01–J09

## Conforme

- tous les choix jouables sont textuels ;
- les rencontres s’arrêtent à la co-présence ;
- les événements physiques reviennent par messages ;
- aucun message vocal ;
- aucun appel joué ;
- aucun choix oral ;
- aucun audio adulte.

## Corrections restantes

1. J01 : supprimer les répliques orales directes des beats hors téléphone ;
2. J02 : remplacer `Marie appelle` par `Marie écrit` dans la transition ;
3. conserver les mentions d’appels extérieurs seulement lorsqu’ils ne deviennent pas une scène.

## Verdict

```text
CONFORME SOUS DEUX CORRECTIONS DE LIBELLÉ
```

---

# 16. Conformité visual-first J01–J09

## Règle

Chaque journée pleinement produite devra proposer :

```text
3 contenus visuels distincts minimum
principalement centrés sur les femmes adultes principales
sans image de remplissage
```

## État réel

| Jour | Contenus actifs / produits | Slots fonctionnels après audit |
|---|---:|---:|
| J01 | 1 | 3 définis |
| J02 | 1 | 3 définis |
| J03 | 0 | 3 définis |
| J04 | 1 | 3 définis |
| J05 | 0 | 3 définis |
| J06 | 0 | 3 définis |
| J07 | 0 | 3 corrigés |
| J08 | 0 | 3 corrigés |
| J09 | 0 | 3 précisés |

## Verdict

```text
CONTRAT NARRATIF DE SLOTS : désormais complet J01–J09
PRODUCTION D’IMAGES : non réalisée
CONFORMITÉ PRODUIT FINALE : non atteinte avant assets ComfyUI
```

---

# 17. Conformité des conséquences

Les conséquences restent attribuables :

- retard ;
- heure tenue ;
- refus annoncé ;
- image choisie ;
- confidence ;
- travail repris ;
- personne qui cesse d’attendre ;
- autonomie de Marie ;
- frontière professionnelle ;
- limite Mathilde.

Les scripts distinguent :

```text
vérité
connaissance
engagement
conséquence
```

Principale correction :

```text
une promesse future importante doit toujours être choisie,
jamais imposée par une réponse guidée unique
```

---

# 18. Gouvernance J01–J09

## Autorité narrative actuelle

```text
J01–J05 : noyaux runtime provisoires + présent audit
J06 : intention canonique du présent audit, runtime non conforme
J07 : script validé + corrections du présent audit
J08 : script validé + corrections du présent audit
J09 : script candidat + corrections du présent audit
```

## Avant intégration technique future

Il faudra produire des scripts canoniques consolidés J01–J06 ou une migration narrative équivalente.

Le runtime actuel ne doit pas être traité comme l’unique source de vérité pour ces journées.

---

# 19. Règles obligatoires pour J10–J21

À partir de J10 :

1. toute scène de premier plan indique sa séquence source ;
2. toute promesse importante possède un vrai choix ;
3. toute journée prévoit trois contenus féminins fonctionnels ;
4. un visuel précise type, origine, auteur, audience et permanence ;
5. une rencontre physique arrête le chat ;
6. les conséquences prioritaires passent avant une nouvelle occasion ;
7. une seule relation reçoit le pivot majeur ;
8. les autres personnages continuent leur vie ;
9. un refus ferme réellement l’attente correspondante ;
10. un fallback existe si les conditions de la scène principale disparaissent ;
11. aucune image ne vaut permission ;
12. aucune route n’est annoncée ;
13. aucun audio ;
14. aucune scène ne dépend d’un futur système technique pour être compréhensible.

---

# 20. Verdict final

À la question :

> Est-ce que J09 et les journées précédentes respectent tout ce qui a été documenté ?

La réponse honnête est :

```text
Pas encore entièrement.
```

Mais les écarts sont désormais identifiés et bornés.

## Conforme

- North Star ;
- progression lente ;
- routes invisibles ;
- autonomie des personnages ;
- voix distinctes ;
- consentement ;
- conséquences attribuables ;
- centralité Marie ;
- text-only dans la structure ;
- absence de progression adulte prématurée.

## À corriger ou compléter

- agency de deux promesses forcées ;
- fallback J08 ;
- visual slots J07–J08 ;
- métadonnées visuelles J09 ;
- deux libellés text-only J01–J02 ;
- production des images J01–J09 ;
- runtime J06.

Après application du présent document :

```text
J01–J09 sont cohérents comme architecture narrative canonique.
Ils ne sont pas encore finalisés comme produit visual-first jouable.
J06 reste techniquement non conforme jusqu’à migration future.
```

> **L’audit ne valide pas par politesse. Il transforme les écarts en règles explicites avant que J10 n’ajoute une nouvelle couche de complexité.**
