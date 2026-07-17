# Réseau Intime — Audit global des dialogues et de la continuité J01–J21

## Statut

**Catégorie : Audit canonique candidat à validation**

**Périmètre : J01 à J21**

**Branche de travail : `agent/audit-global-dialogues-j01-j21`**

**Base auditée : `main` au commit `07aa95651133224d36af0950ec7d757ad00df251`**

Ce document audite ensemble :

- les noyaux et corrections J01–J09 ;
- les scripts complets J10–J21 ;
- la chronologie ;
- les promesses ;
- les connaissances ;
- les images, audiences et suppressions ;
- les voix ;
- les conséquences et après-coups ;
- la conformité text-only ;
- la compatibilité de la finale ;
- la préparation à une future adaptation runtime.

Il ne modifie :

- aucun dialogue source ;
- aucun JSON ;
- aucun script Godot ;
- aucun test ;
- aucun asset ;
- aucune galerie ;
- aucun état runtime.

Les corrections proposées restent à valider avant intégration documentaire ou technique.

---

# 1. Verdict exécutif

## 1.1 Architecture générale

```text
ARCHITECTURE SAISON 1 : COHÉRENTE ET COMPLÈTE
RÉSOLUTIONS J17–J21 : COHÉRENTES DANS LEUR INTENTION
ROUTES INVISIBLES : CONFORMES
AGENCE DES PERSONNAGES : FORTE
CONSENTEMENT ET AUDIENCES : TRÈS SOLIDES DANS LE PRINCIPE
FINALE : PERTINENTE ET EXTENSIBLE
```

La saison possède une progression lisible :

```text
vie ordinaire
→ lignes privées
→ première superposition
→ incarnation d’une ligne
→ convergence sociale
→ conséquences
→ découverte
→ engagements incompatibles
→ paiement
→ résolutions
→ trace finale recontextualisée
```

Aucune refonte de la trame, des routes macro ou de l’ordre J01–J21 n’est recommandée.

## 1.2 État des dialogues

```text
DIALOGUES : NARRATIVEMENT VALIDÉS MAIS NON ENCORE PRÊTS POUR LE RUNTIME
```

Le corpus nécessite une passe ciblée avant adaptation technique.

Les écarts ne remettent pas en cause les décisions fondamentales.

Ils concernent principalement :

1. une incohérence calendaire certaine entre J17 et J21 ;
2. une promesse Sandra déplacée mais non payée ;
3. plusieurs échanges textuels pendant une co-présence physique ;
4. une posture finale sombre insuffisamment conditionnée ;
5. l’absence d’un registre unique des traces, promesses et connaissances ;
6. la multiplication de libellés d’état non normalisés ;
7. des corrections J01–J09 encore portées par un audit plutôt que consolidées dans les sources ;
8. une contamination progressive des voix par le langage du canon ;
9. quelques connaissances ou origines d’image encore trop implicites.

## 1.3 Décision de production

```text
REPRISE TECHNIQUE : BLOQUÉE
```

Avant runtime, il faut produire et valider quatre correctifs documentaires :

```text
A. calendrier, promesses et text-only
B. registre des traces / connaissances / engagements
C. matrice des états et de l’accessibilité des branches
D. passe de naturel et de distinction des voix
```

J06 reste en plus techniquement non conforme jusqu’à sa migration dédiée.

---

# 2. Échelle de sévérité

## `BLOQUANT`

L’écart peut produire :

- une scène impossible dans le calendrier ;
- une promesse oubliée ;
- une violation du canon text-only ;
- une image apparaissant sans source ;
- un état impossible à implémenter de manière fiable ;
- une finale incompatible avec une sortie antérieure.

## `CORRECTION CIBLÉE`

Le noyau est valide, mais une condition, une source ou un dialogue doit être précisé.

## `POLISH DIALOGUE`

La scène fonctionne mais doit gagner en naturel, respiration ou distinction vocale.

## `PRODUCTION`

Le contrat narratif existe mais l’asset, la métadonnée ou l’intégration reste à produire.

---

# 3. Matrice synthétique par journée

| Jour | Verdict audit global | Correction principale |
|---|---|---|
| J01 | conforme sous corrections connues | retirer les répliques orales directes hors téléphone |
| J02 | conforme sous correction connue | remplacer un libellé laissant croire à un appel joué |
| J03 | conforme narrativement | produire les visuels et conserver la restructuration |
| J04 | conforme narrativement | produire les visuels avec origine indépendante |
| J05 | conforme narrativement | produire les visuels |
| J06 | narration conforme, runtime non conforme | retirer candidate pool / propriétaire automatique |
| J07 | conforme après correction non consolidée | rendre le rendez-vous Nico réellement optionnel |
| J08 | conforme après correction non consolidée | lire seulement les attentes réellement créées |
| J09 | conforme après correction non consolidée | rendre le dîner J10 réellement choisi |
| J10 | correction bloquante | payer ou déplacer correctement l’alternative Sandra du samedi |
| J11 | conforme sous condition | renforcer l’éligibilité indépendante de Mathilde ; naturaliser certaines formulations |
| J12 | correction bloquante text-only | supprimer les échanges directs pendant co-présence |
| J13 | conforme sous métadonnées | fixer les créateurs exacts des traces réutilisables |
| J14 | excellente logique de connaissance ; correction text-only | interdire les échanges depuis deux pièces du même lieu |
| J15 | conforme | normaliser obligations, preuves et sorties |
| J16 | conforme | normaliser les états et garder les variantes strictement conditionnelles |
| J17 | correction bloquante | corriger le rendez-vous `dimanche` et les messages en co-présence |
| J18 | conforme | passe de naturel ; vérifier toutes les sources de traces |
| J19 | correction ciblée | établir la source de la connaissance Pauline / Marie |
| J20 | conforme sous matrice d’éligibilité | le regard autorisé doit être directement accordé par la femme concernée |
| J21 | plusieurs corrections bloquantes | calendrier, co-présence, registre des traces, posture C conditionnelle |

---

# 4. Blocage B1 — Incohérence calendaire J17 / J20 / J21

## Constat

Le calendrier canonique est :

```text
J17 jeudi
J18 vendredi
J19 samedi
J20 dimanche
J21 lundi
```

J17 fixe pourtant plusieurs états jusqu’à `dimanche` :

- accord provisoire jusqu’à dimanche ;
- reconfiguration sans nouvelle étape jusqu’à dimanche ;
- journée entière avec Marie proposée le dimanche.

J21, qui se déroule le lundi suivant, conserve ensuite les formulations :

```text
Dimanche tient toujours.
Jusqu’à dimanche, notre règle tient aussi.
Aucune nouvelle étape avant dimanche.
Dimanche.
```

Le point de contrôle est donc déjà passé lorsque J21 commence.

J20, pourtant situé le dimanche, ne paie pas ce rendez-vous de couple car son pivot est Nico et le réseau.

## Effet

- la chronologie devient impossible ;
- l’accord provisoire ne possède plus de date réelle ;
- la reconfiguration peut être prolongée rétroactivement ;
- J21 parle d’un futur déjà passé ;
- une journée entière Marie peut entrer en conflit avec la résolution Nico.

## Correction canonique recommandée

Ne plus écrire un jour relatif isolé.

Créer :

```text
couple_review_due_at
couple_shared_day_due_at
```

avec une date et une heure réellement choisies.

Pour les exemples de la première saison :

```text
couple_review_due_at = jeudi suivant 20 h 30
```

Le checkpoint se situe ainsi après J21 et reste une promesse d’extension préparée.

La journée de reconquête éventuelle peut être :

```text
dimanche suivant, explicitement daté
```

et non le dimanche J20.

## Corrections de texte attendues

### J17

Remplacer :

```text
Jusqu’à dimanche.
Jusqu’à dimanche : aucune nouvelle étape avec personne.
```

par une heure explicitement résolue, par exemple :

```text
Jeudi prochain, 20 h 30.
Jusque-là, aucune nouvelle étape avec personne.
```

### J21

Remplacer :

```text
Dimanche tient toujours.
Jusqu’à dimanche, notre règle tient aussi.
```

par :

```text
Jeudi 20 h 30 tient toujours.
Jusqu’à jeudi, notre règle tient aussi.
```

Le jour exact reste un exemple documentaire et doit être vérifié contre les autres promesses actives.

## Sévérité

```text
BLOQUANT
```

---

# 5. Blocage B2 — Promesse Sandra J10 déplacée mais non payée

## Constat

Dans J10, Player peut refuser le café immédiat et proposer :

```text
samedi 11 h au même endroit
```

Sandra doit confirmer le vendredi avant 18 h.

J11 exclut correctement la continuation Sandra lorsque le café est seulement reprogrammé.

Mais J12 commence officiellement à 14 h 42 et ne contient aucun module permettant de payer un café confirmé le samedi à 11 h.

La promesse peut donc :

- être créée en J10 ;
- être confirmée en J11 ;
- disparaître en J12.

## Effet

La règle centrale :

```text
une promesse choisie doit être payée, amendée ou fermée
```

est violée.

## Correction recommandée

Ajouter à J12 un préambule conditionnel strict :

```text
J12_PRELUDE_SANDRA_CAFE_CONFIRMED
10:58–11:35
```

Conditions :

- l’alternative a été proposée en J10 ;
- Sandra l’a confirmée avant vendredi 18 h ;
- aucune limite ou conséquence prioritaire ne l’a fermée ;
- Player accepte encore l’heure ou l’amende avant que Sandra se déplace.

Fonction :

```text
payer la promesse
sans devenir un deuxième pivot majeur de J12
```

Après le café :

- retour textuel minimal ;
- aucune image intime ;
- aucune progression qui remplace S23 ;
- La Verrière commence toujours à 14 h 42.

Alternative acceptable : déplacer dès J10 la proposition vers une date après J21.

La solution du préambule J12 est préférable car elle conserve la continuité émotionnelle.

## Sévérité

```text
BLOQUANT
```

---

# 6. Blocage B3 — Co-présence et canon text-only

## Règle supérieure

Le canon produit impose :

```text
lorsque les personnages se rejoignent physiquement,
le chat s’arrête
```

Les résultats peuvent revenir par messages après une véritable séparation.

## Écarts identifiés

### J12

Le module `SAME_VENUE_LOGISTICS` fait écrire Marie et Player pendant qu’ils montent La Verrière dans le même lieu.

Même si les messages sont logistiques, ils rejouent une scène physique par chat.

### J14

L’architecture autorise une reprise :

```text
après séparation ou depuis des pièces distinctes
```

Deux pièces du même appartement ne constituent pas une séparation suffisante dans le canon actuel.

### J17

L’ouverture de la conversation Marie peut avoir lieu :

```text
dans une autre pièce avec une demande d’espace
```

Cette solution contourne la règle au lieu de l’appliquer.

### J21

La finale affirme que la co-présence arrête le chat, puis reprend les messages après que Marie s’est seulement éloignée ou est repartie chercher quelque chose.

Les branches chambre séparée / bonne nuit peuvent également faire converser des personnes toujours présentes dans le même logement.

## Correction canonique

### Direct messages

Interdire toute conversation interactive directe lorsque les personnages sont au même endroit.

Remplacer par :

```text
état de scène non dialogué
notification passive
trace sociale produite indépendamment
ou message après séparation réelle
```

### J12

- convertir le montage en état narratif non dialogué ;
- conserver éventuellement les posts de groupe comme traces sociales non interactives ;
- retirer les réponses guidées Player pendant le montage ;
- rendre le résultat après que Player a quitté La Verrière ou L’Annexe.

### J14 / J17

Remplacer `pièces distinctes` par :

```text
après que l’un des personnages a réellement quitté le lieu
```

ou différer le message au prochain trajet, poste ou déplacement crédible.

### J21

La branche reconquête doit soit :

- se terminer sur le message précédant le dîner ;
- soit produire son dernier échange après une séparation réelle.

Le simple fait que Marie change de pièce ou reparte chercher un objet ne suffit pas.

## Sévérité

```text
BLOQUANT
```

---

# 7. Blocage B4 — La posture finale C peut créer une nouvelle violation

## Intention valide

J21 doit permettre de :

```text
maintenir consciemment une contradiction déjà active
```

Cette sortie sombre est cohérente avec la North Star.

## Problème actuel

Les exemples incluent :

- conserver une copie que l’autrice croit supprimée ;
- demander à Nico de ne pas corriger alors que l’alibi peut avoir été fermé ;
- traiter une invitation limitée comme un accès futur ;
- faire croire à Marie qu’une ligne est fermée.

Sans garde stricte, le choix final peut créer une nouvelle violation au lieu de maintenir une contradiction existante.

Cela contredit les conditions d’entrée de J21 :

```text
aucune urgence inconnue
aucune nouvelle route
aucune nouvelle révélation
```

## Correction canonique

La posture C exige :

```text
existing_contradiction_id != null
```

Éligibilités possibles :

```text
copy_retained_secretly déjà actif
false_hour_active déjà actif
pauline_compartment_active déjà actif
nico_complice déjà actif
raphaelle_secret_active déjà actif
couple_double_life déjà actif
```

Interdictions :

- créer une première copie non autorisée en J21 ;
- rouvrir un alibi fermé en J20 ;
- transformer une route saine en route sombre par un seul choix final ;
- produire une nouvelle victime ou une nouvelle audience compromise.

Si aucune contradiction n’est active, seules les postures A et B sont disponibles.

## Sévérité

```text
BLOQUANT
```

---

# 8. Blocage B5 — Absence de registre canonique des traces

## Constat

J14 et J21 dépendent d’images ou de traces déjà existantes.

Les documents utilisent parfois des formulations génériques :

```text
image du foyer déjà établie
photographie sociale existante
photo du premier soir
photo de la terrasse
image Marie / La Verrière
Pauline ou personne autorisée
```

Ces formulations sont suffisantes pour une intention narrative.

Elles ne suffisent pas pour garantir :

- que la trace existe réellement dans la partie ;
- que Player y a encore accès ;
- que le témoin peut la voir ;
- que l’image n’a pas été retirée ;
- que son créateur est connu ;
- que son audience est correcte ;
- que J21 ne fabrique pas une nouvelle photographie.

## Registre obligatoire

Créer avant runtime :

```text
docs/canon/dialogues/J01_J21_TRACE_REGISTRY.md
```

Champs minimum :

```text
trace_id
source_day
source_scene
creator
subject
owner
initial_audience
current_audience
storage_location
saving_rule
transfer_rule
current_state
removed_at
discoverable_by
knowledge_created
eligible_for_j14
eligible_for_j21
```

## Traces sûres déjà identifiables

- photographie du déjeuner Sandra J01 ;
- photographie publique Pauline / Bastien / groupe ;
- image choisie Sandra J11 si non retirée ;
- version privée Pauline J13 si non retirée ;
- image choisie Raphaëlle si réellement produite ;
- traces publiques La Verrière / L’Annexe lorsque leur créateur et leur audience sont fixés.

## Traces à préciser

- photographie Mathilde du premier soir ;
- photographie Nico / terrasse ;
- photographie Marie du montage ;
- image du foyer utilisée comme photographie diégétique ;
- toute trace dont le créateur reste `personne autorisée`.

À défaut de trace réelle, utiliser :

```text
une image de scène non diégétique
ou l’absence explicite du contenu
```

sans prétendre qu’une photographie existait dans le téléphone.

## Sévérité

```text
BLOQUANT AVANT RUNTIME
```

---

# 9. Blocage B6 — États, promesses et connaissances non normalisés

## Constat

Les scripts possèdent une excellente richesse de sorties.

Ils emploient cependant de nombreux libellés proches :

```text
reconquête active
accord provisoire
accord provisoire fragile
reconfiguration négociée précoce
reconfiguration en négociation
espace
fracture
fracture avancée
séparation
double vie fragile
```

Le même phénomène existe pour :

- les images ;
- les audiences ;
- les promesses ;
- les confidences ;
- les états Sandra, Pauline, Raphaëlle et Nico.

Sans normalisation, une adaptation directe conduirait à :

- des centaines de flags ;
- des états synonymes ;
- des branches impossibles ;
- des handoffs non déterministes ;
- une finale difficile à sélectionner.

## Documents obligatoires avant runtime

### A — Contrat d’état

```text
docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md
```

Il définit des enums bornés :

```text
couple_state
household_state
sandra_state
mathilde_state
pauline_state
raphaelle_state
nico_state
```

### B — Registre des promesses

```text
promise_id
created_at
created_by
accepted_by_player
due_at
status: active / amended / refused / paid / expired
paid_by_scene
```

### C — Registre des connaissances

```text
knower
fact_id
source
certainty
scope
can_share
```

### D — Matrice de reachability

```text
docs/canon/dialogues/J01_J21_REACHABILITY_MATRIX.md
```

Elle doit prouver que :

- chaque sortie J17 peut atteindre une variante J21 cohérente ;
- chaque trace J21 possède une source ;
- aucune branche fermée ne se rouvre sans événement ;
- les aftercares adultes sont toujours payés ;
- les promesses futures ne disparaissent pas.

## Sévérité

```text
BLOQUANT AVANT RUNTIME
```

---

# 10. Blocage B7 — Corrections J01–J09 non consolidées

## État actuel

L’audit J01–J09 possède autorité corrective et identifie :

- J01 : deux répliques orales directes à remplacer ;
- J02 : un libellé `Marie appelle` à remplacer par `Marie écrit` ;
- J07 : promesse Nico forcée ;
- J08 : rendez-vous Nico supposé obligatoire et fallback manquant ;
- J09 : dîner J10 parfois forcé ;
- J06 : runtime contradictoire ;
- J01–J09 : production visuelle incomplète.

Ces corrections existent dans l’audit, mais les fichiers sources et le runtime ne sont pas encore uniformément consolidés.

## Risque

Une future adaptation peut lire :

- le script historique ;
- l’audit correctif ;
- le plan ;
- ou le runtime ;

et obtenir quatre réponses différentes.

## Correction recommandée

Avant toute reprise technique :

1. produire des scripts canoniques consolidés J01–J06 ou une spécification de migration équivalente ;
2. intégrer les corrections J07–J09 dans leurs scripts sources ;
3. retirer toute réponse guidée qui crée une promesse ;
4. implémenter le fallback J08 ;
5. traiter J06 dans une branche technique séparée ;
6. conserver l’audit J01–J09 comme historique de décision, non comme patch permanent à appliquer mentalement.

## Sévérité

```text
BLOQUANT AVANT RUNTIME
```

---

# 11. Blocage B8 — Autorités documentaires contradictoires

## Constat

Le document :

```text
12E_AUDIT_GLOBAL_COHERENCE_J01_J21.md
```

est encore classé `Canon`.

Il affirme pourtant :

```text
DIALOGUES J07–J21 : NON PRODUITS
```

et recommande encore de commencer la production par J01–J04.

Ces affirmations sont désormais historiquement vraies mais actuellement fausses.

Par ailleurs, les scripts J10–J21 portent encore en en-tête :

```text
Canon candidat à validation narrative
```

alors que les index déclarent J07–J21 validés narrativement.

## Correction recommandée

### `12E`

Ajouter un bandeau :

```text
ARCHIVE CANONIQUE D’ARCHITECTURE
Supersédé pour l’état des dialogues par
J01_J21_AUDIT_GLOBAL_DIALOGUES_CONTINUITE.md
```

Le garder comme preuve de la validation de l’architecture.

Ne plus l’utiliser pour le statut de production.

### Scripts J10–J21

Après validation du présent audit et corrections :

```text
Catégorie : Canon validé narrativement — pré-runtime
```

### Index

Ajouter une hiérarchie explicite :

```text
scripts consolidés
→ audit global dialogue
→ corrections validées
→ contrat runtime
```

## Sévérité

```text
BLOQUANT DE GOUVERNANCE
```

---

# 12. Correction ciblée C1 — Dépendance de Mathilde et passage physique J11

## Constat

J11 peut autoriser un premier passage physique avec Mathilde alors qu’elle habite encore temporairement chez Marie et Player.

Le script impose déjà :

- initiative ou confirmation Mathilde ;
- consentement écrit ;
- stop immédiat ;
- aucune pénétration ;
- aucun usage explicite du logement comme accès ;
- après-coup obligatoire.

Ces protections sont fortes.

La dépendance matérielle reste toutefois réelle tant que Mathilde ne possède pas une solution de logement autonome.

## Condition supplémentaire recommandée

La branche adulte n’est éligible que si l’histoire établit avant la scène :

```text
Mathilde possède une solution alternative pour dormir
son hébergement ne dépend pas de son oui
elle peut quitter le lieu sans perdre ses affaires ou sa sécurité
Marie n’a pas été éloignée pour créer la fenêtre
le refus ne change aucune règle de logement
```

À défaut :

```text
variante non adulte uniquement
```

La proximité, le baiser éventuel ou la tension peuvent rester, mais toute progression plus explicite doit attendre la fin de la dépendance domestique.

## Sévérité

```text
CORRECTION CIBLÉE OBLIGATOIRE POUR LA BRANCHE
```

---

# 13. Correction ciblée C2 — Connaissance Pauline / Marie en J19

## Constat

Pauline affirme :

```text
Moi je sais ce qu’elle m’a déjà confié sur votre couple.
```

Leur amitié rend cette connaissance plausible.

Le corpus n’établit pas toujours quelle confidence précise a été donnée, quand, ni ce que Pauline sait réellement.

Cette phrase peut donc créer rétroactivement une connaissance importante.

## Correction recommandée

Option A — établir une source antérieure :

```text
knowledge_id: pauline_knows_marie_couple_fragility
source_day: J12 ou J14
source: message direct Marie / Pauline hors écran Player,
confirmé seulement par une phrase attribuable
scope: fatigue, absence ou mensonge précis
```

Option B — réduire la phrase :

```text
Je suis son amie.
Je sais que ce qu’on fait la concerne maintenant.
```

La seconde option est préférable si aucune scène source n’est ajoutée.

## Sévérité

```text
CORRECTION CIBLÉE
```

---

# 14. Correction ciblée C3 — Créateurs d’image exacts

## Constat

Certaines métadonnées emploient :

```text
Pauline ou personne autorisée
source crédible selon la branche
personnage, proche autorisé ou source de scène
```

Cette souplesse convient à un plan.

Elle devient insuffisante lorsqu’une image :

- est découverte en J14 ;
- devient une preuve ;
- est recontextualisée en J21 ;
- possède une audience sociale précise.

## Correction recommandée

Avant runtime, chaque trace diégétique doit avoir un créateur résolu :

```text
creator_character_id
creator_role
consent_of_subject
initial_recipient_ids
```

Si le créateur varie, créer des variantes de trace distinctes.

Ne pas conserver `personne autorisée` comme donnée finale.

## Sévérité

```text
CORRECTION CIBLÉE
```

---

# 15. Correction ciblée C4 — Omniscience implicite dans certaines formulations

## Risques repérés

### Mathilde

Une phrase comme :

```text
rien ne recommence tant que tu n’as pas une règle réelle avec Marie
```

exige que Mathilde connaisse réellement l’absence de règle ou que Marie lui ait parlé.

### Marie

En J21 double vie :

```text
Je remarque aussi que tu gardes encore des phrases en dehors de notre règle.
```

nécessite un comportement observable ou une trace.

### Nico

Il peut reconnaître son intérêt mais ne doit pas déduire les décisions privées des femmes à partir des descriptions de Player.

## Correction recommandée

Chaque phrase de connaissance importante doit être rattachée à :

```text
source directe
trace visible
comportement observable
ou déclaration Player
```

À défaut, remplacer l’affirmation par :

```text
soupçon
question
ou refus de conclure
```

Exemple Marie :

```text
Je ne crois toujours pas connaître toute ta version.
```

plutôt qu’une affirmation sur des phrases qu’elle ne peut pas prouver.

## Sévérité

```text
CORRECTION CIBLÉE
```

---

# 16. Audit des voix

## 16.1 Verdict général

```text
IDENTITÉS VOCALES : SOLIDES
NATUREL SUR LA DURÉE : À POLIR DANS LES ACTES IV–V
```

Les filtres d’attention restent distincts :

- Marie remarque l’acte et la vie commune ;
- Sandra remarque la représentation et ce qu’elle permet de croire ;
- Mathilde remarque l’effet et corrige ;
- Pauline remarque l’audience et la contradiction ;
- Raphaëlle remarque le processus et la décision cachée ;
- Nico remarque la pièce, le désir social et son propre intérêt.

## 16.2 Risque de contamination par le canon

À partir de J13, plusieurs personnages parlent parfois comme s’ils énonçaient la règle de design :

```text
audience
permission
version
cadre
règle générale
responsabilité
preuve
dette
```

Ces mots sont légitimes pour Pauline ou Raphaëlle.

Le problème apparaît lorsqu’ils produisent des structures identiques chez tous :

```text
Ce n’est pas X.
C’est Y.
```

ou :

```text
D’accord.
Puis formulation parfaitement définitive.
```

## 16.3 Risques par personnage

### Marie

Forces :

- pain, horaires, pièces, courses, mouvement ;
- émotion liée à une action.

Risque :

- devenir la porte-parole abstraite du contrat relationnel ;
- formuler trop parfaitement ce que Player fait.

Correction : ramener une partie des limites à des actes, heures et décisions pratiques.

### Sandra

Forces :

- faible volume ;
- silences ;
- contrôle de la représentation ;
- minimisation.

Risque :

- devenir trop précise et aphoristique ;
- multiplier les phrases telles que `une image précise, pas une règle générale`.

Correction : conserver une seule ligne forte par beat et davantage d’hésitation ou de banalité autour.

### Mathilde

Forces :

- vitesse ;
- correction ;
- gêne ;
- mauvaise foi légère.

Risque :

- devenir une experte parfaite de la limite lorsque le conflit augmente.

Correction : garder ses décisions nettes, mais laisser davantage de phrases incomplètes, de corrections et de détails pratiques.

### Pauline

Forces :

- audience ;
- surface ;
- compartiment ;
- Bastien réel.

Risque :

- trop d’énoncés conceptuels sur les versions ;
- trop de punchlines écrites.

Correction : réduire les démonstrations et faire apparaître davantage ses décisions par le timing, les suppressions et les changements de fil.

### Raphaëlle

Forces :

- processus ;
- travail ;
- observation ;
- espace.

Risque :

- toujours avoir la formulation moralement supérieure ;
- devenir la voix de l’audit.

Correction : plus de silences, de réponses partielles et de détails de fabrication ; moins de diagnostic sur Player.

### Nico

Forces :

- bar ;
- heure ;
- chaise ;
- provocation qui tombe ;
- intérêt personnel reconnu.

Risque :

- devenir professeur de consentement ou thérapeute ;
- parler trop souvent en règles générales.

Correction : conserver le fond, raccourcir la démonstration et ancrer les limites dans un fait concret.

## 16.4 Règle de polish recommandée

Pour chaque beat fort :

```text
1 ligne réellement mémorable maximum
30 à 50 % de messages ordinaires, partiels ou imparfaits
au moins une question non entièrement répondue lorsque la scène est émotionnelle
aucune symétrie de trois punchlines
```

La passe de naturel doit préserver les décisions et les métadonnées.

Elle ne doit pas rouvrir la structure.

## Sévérité

```text
POLISH OBLIGATOIRE AVANT DIALOGUES RUNTIME DÉFINITIFS
```

---

# 17. Audit des promesses

## Conforme

- les engagements importants J10–J21 possèdent généralement un vrai choix ;
- un refus ferme l’attente ;
- les alternatives sont précises ;
- Marie, Sandra, Raphaëlle et Nico peuvent agir sans Player ;
- J15 utilise des obligations antérieures plutôt que des rendez-vous inventés.

## Restant à corriger

- J07 Nico : intégrer la correction dans le script source ;
- J09 dîner : intégrer le micro-choix dans le script source ;
- J10 Sandra samedi : ajouter le paiement J12 ;
- J17 checkpoint de couple : dater après J21 ;
- J21 : ne confirmer que des promesses réellement actives.

## Règle runtime

Aucun dialogue ne doit tester une promesse par une simple variable booléenne vague.

Utiliser le registre :

```text
promise_id + due_at + status
```

---

# 18. Audit des connaissances

## Forces

J14 est la meilleure base de la saison sur ce point.

Il distingue explicitement :

```text
trace vue
réaction Player
explication Player
contexte réel
interprétation du témoin
```

J15–J20 préservent généralement :

- fait exact ;
- contexte inconnu ;
- soupçon ;
- preuve limitée ;
- absence d’omniscience.

## Risques

- connaissances sociales plausibles mais non sourcées ;
- personnages affirmant une règle de couple sur la base d’un soupçon ;
- finale utilisant une trace sans prouver son accessibilité ;
- tiers connaissant une heure sans source préalable.

## Correction

Créer des `fact_id` stables et interdire toute ligne nécessitant un fait absent du registre.

---

# 19. Audit des images et audiences

## Verdict

```text
CONTRAT D’IMAGE : EXCELLENT DANS LE PRINCIPE
TRAÇABILITÉ INTER-JOURNÉES : INCOMPLÈTE
ASSETS : NON PRODUITS
```

## Forces

- voir, conserver et transférer sont distincts ;
- suppression et connaissance sont distinctes ;
- les personnes représentées gardent le droit de retrait ;
- aucune image ne vaut permission adulte ;
- les contenus supprimés ne reviennent pas par principe ;
- les images finales ne sont pas des trophées de route.

## Corrections

- registre des traces obligatoire ;
- créateurs exacts ;
- accès final vérifié ;
- état de copie explicite ;
- une trace J21 sélectionnée de manière déterministe ;
- une image de scène non diégétique ne doit jamais devenir une preuve dans l’histoire.

---

# 20. Audit du contenu adulte

## Conforme

- aucun adulte obligatoire ;
- consentement écrit ;
- stop et retrait ;
- pas d’intoxication ;
- après-coup obligatoire ;
- pas de droit permanent ;
- pas de fichier sexuel automatique ;
- dark routes nommées comme instables.

## Corrections

1. renforcer l’indépendance matérielle Mathilde avant branche physique ;
2. vérifier qu’une scène adulte remplace le pivot normal au lieu de s’y ajouter ;
3. interdire toute nouvelle progression si un aftercare reste dû ;
4. J21 ne crée aucune nouvelle violation adulte ou d’image.

---

# 21. Audit de la finale

## Forces

J21 respecte l’intention de saison :

- vie ordinaire transformée ;
- trace déjà connue ;
- aucune révélation ;
- aucune sélection de femme ;
- choix de posture ;
- continuation possible sans annuler la résolution.

La possibilité de conclure par une image inaccessible est particulièrement forte.

## Corrections obligatoires

- calendrier du checkpoint ;
- messages après co-présence ;
- trace ID exacte ;
- posture C strictement conditionnée ;
- tie-breaker déterministe entre plusieurs dettes ;
- suppression des exemples de trace non établie.

## Sélection recommandée

À la fin de J20, écrire explicitement :

```text
final_trace_id
final_trace_state
final_trace_controller
final_trace_audience
final_posture_options
```

J21 ne recalcule pas tout le réseau en direct.

Il interprète cet état préparé.

---

# 22. Ordre recommandé des corrections

## Lot A — Continuité bloquante

```text
A1 calendrier J17 / J21
A2 préambule Sandra J12
A3 suppression des messages en co-présence
A4 gating de la posture finale C
```

Fichiers probables :

- J10 ;
- J12 ;
- J14 ;
- J17 ;
- J21.

## Lot B — Contrats de données narratifs

```text
B1 trace registry
B2 promise registry
B3 knowledge registry
B4 state contract
B5 reachability matrix
```

Documentation uniquement.

## Lot C — Corrections de sources

```text
C1 consolidation J01–J09
C2 source Pauline / Marie
C3 créateurs exacts des images
C4 gating Mathilde adulte
C5 mise à jour 12E et statuts
```

## Lot D — Polish des voix

Passe J10–J21 centrée sur :

- banalité ;
- réponses partielles ;
- silences ;
- réduction des aphorismes ;
- réduction du langage de design prononcé par les personnages.

## Lot E — Reprise technique

Seulement après validation A–D.

Commencer par :

```text
réconciliation J01–J06
puis adaptation courte J07–J09
```

Ne pas commencer par implémenter J21 ou une machine générique couvrant toute la saison.

---

# 23. État final par domaine

| Domaine | Verdict |
|---|---|
| North Star | conforme |
| Trame J01–J21 | conforme |
| Routes invisibles | conforme |
| Agence | conforme sous consolidations J07/J09 |
| Couple Marie | conforme |
| Sandra | conforme |
| Mathilde | conforme sous gating adulte |
| Pauline | conforme sous source de connaissance |
| Raphaëlle | conforme |
| Nico | conforme |
| Partenaires / tiers | conforme |
| Conséquences | conforme |
| Après-coup | conforme |
| Chronologie | non conforme sur checkpoint J17/J21 |
| Promesses | non conforme sur alternative Sandra J10 |
| Text-only | non conforme sur plusieurs co-présences |
| Connaissances | solide, registre requis |
| Images / audiences | solide, registre requis |
| Voix | distinctes, polish requis |
| Finale | solide, quatre corrections obligatoires |
| Runtime J06 | non conforme |
| Assets | à produire |
| Prêt pour adaptation technique | non |

---

# 24. Décision finale de l’audit

```text
SAISON 1 : VALIDÉE DANS SON ARCHITECTURE ET SES RÉSOLUTIONS
DIALOGUES : VALIDÉS SOUS CORRECTIONS CIBLÉES
RUNTIME : NE PAS REPRENDRE ENCORE
```

La saison ne nécessite pas :

- une nouvelle route ;
- un nouvel acte ;
- un autre final ;
- davantage de personnages ;
- une nouvelle mécanique narrative globale.

Elle nécessite :

- de payer toutes ses propres promesses ;
- de respecter strictement la séparation entre chat et co-présence ;
- de donner des identifiants aux états déjà conçus ;
- de vérifier que chaque image finale existait réellement ;
- de rendre les voix un peu moins parfaites ;
- de consolider l’ouverture avant d’écrire le runtime.

> **La saison fonctionne. Le travail restant n’est plus d’inventer davantage, mais de rendre chaque promesse, chaque trace et chaque phrase aussi exacte que l’architecture qui les porte.**
