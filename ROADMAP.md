# Roadmap

## 1. État actuel

### Moteur et workflow

```text
Moteur : Godot 4.6.x
Méthode : documentation validée avant runtime
PR : courtes, ciblées, sans gros refactoring
Choix : 3 maximum par défaut
```

### Canon personnages

Les sept personnages principaux possèdent un canon concret complet :

```text
Marie
Sandra
Player
Mathilde
Pauline
Nico
Raphaëlle
```

Jeff et les autres ancrages restent des personnages secondaires documentés proportionnellement.

### J1

`J1 — Les choses qu'on remarque` est canon et runtime-aligné.

- Marie et Sandra actives ;
- Player actif par ses réponses ;
- Mathilde indirecte ;
- Pauline, Nico et Raphaëlle absents des fils actifs ;
- aucune route verrouillée ;
- aucun secret dur ;
- aucun contenu explicite ;
- fin centrée sur Marie et la vie commune.

### Architecture post-J1

V0.78 a remplacé l’ancien calendrier fixe J2–J10 par :

```text
tronc dramatique fixe
+ choix topologiques
+ fenêtres narratives
+ scènes modulaires
+ obligations et traces persistantes
+ conséquences revenant vers le couple
```

Le couple commence après J1 dans :

```text
HABITUAL_WARMTH
```

Les routes suivent :

```text
R0 Background
R1 Ordinary Access
R2 Charged Access
R3 Acknowledged Intent
R4 Consequential Frame
R5 Integration / Aftermath
```

### Ouverture Acte I

V0.79 écrit le premier source pack concret :

```text
docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_OPENING_SCENE_CARDS.md
```

L’ouverture couvre approximativement trois à cinq jours diégétiques sans imposer une étiquette fixe `J2`.

Elle établit :

- le dégât des eaux et l’hébergement temporaire de Mathilde ;
- l’entrée ordinaire de Mathilde dans le foyer ;
- l’entrée professionnelle de Raphaëlle ;
- une continuité Sandra légère ;
- le vernissage de La Verrière annoncé dans J1 ;
- le premier choix topologique de Player ;
- un retour obligatoire vers Marie ;
- un relais photo public Pauline ;
- un suivi d’amitié Nico autour d’une place gardée ;
- aucune route adulte, aucun secret dur et aucun changement de cadre relationnel.

V0.79 est documentaire. Le runtime n’est pas encore modifié.

## 2. Priorité immédiate

```text
V0.80 — First Modular Runtime Integration Plan
```

V0.80 doit inspecter le runtime existant et produire un plan, sans modifier Godot ou les JSON narratifs.

Le plan doit :

1. cartographier les conversations et indexes J2+ existants ;
2. déterminer comment O0–O8 s’insèrent dans l’interface smartphone ;
3. préserver un fil visible par personnage ;
4. mapper seulement les états nécessaires à la tranche V0.79 ;
5. identifier les anciens nœuds J2 à remplacer, contourner ou déprécier ;
6. préserver le budget `1 scène principale / 0–2 échos` ;
7. préserver les neuf nœuds à trois choix ;
8. garantir le retour obligatoire vers Marie ;
9. préserver l’origine et le public des images ;
10. définir validations, tests et rollback ;
11. éviter tout gros refactoring.

## 3. Étape runtime suivante

Après validation de V0.80 :

```text
V0.81 — First Modular Runtime Vertical Slice
```

La PR runtime devra rester courte.

Elle intégrera seulement :

- la tranche validée par le plan ;
- ou un sous-ensemble encore plus petit si l’architecture technique l’exige.

Elle ne devra pas :

- réécrire tout J2+ ;
- construire un moteur procédural universel ;
- introduire tous les futurs états de route ;
- modifier les personnages ou l’histoire sans correction documentaire préalable.

## 4. Structure narrative à long terme

```text
Acte 0 — Les choses qu'on remarque
Acte I — La place qu'on laisse
Acte II — Les regards circulent
Acte III — Les lignes choisies
Acte IV — Les versions se rencontrent
Acte V — Ce qu'on choisit de garder
```

Le tronc fixe :

```text
S0 Attention
S1 Changement du foyer
S2 Mouvement proposé
S3 Vies extérieures visibles
S4 Attention privée répétée
S5 Limite nommée
S6 Désir devenu conséquent
S7 Collision entre privé et quotidien
S8 Cadre du couple déclaré
S9 Ce qui reste
```

V0.79 concrétise l’ouverture de S1, S2 et S3.

## 5. Contenu futur après la première tranche runtime

Les futurs source packs devront avancer progressivement :

- premières scènes de matin / chambre d’appoint avec Mathilde ;
- répétition mesurée du lien Sandra ;
- seconde présence ordinaire de Raphaëlle ;
- passage Pauline du public à la sélection privée ;
- passage Nico de l’amitié au regard partagé ;
- nouvelles scènes Marie pour elle-même ;
- première limite respectée ;
- mutation des occasions manquées ;
- seulement ensuite premières routes R2 puis R3.

Le contenu adulte explicite appartient normalement aux actes ultérieurs et exige un cadre nommé.

## 6. Principes produit permanents

- Marie reste le centre vivant, pas l’obstacle aux routes.
- Les choix modifient ce que Player fait, pas la femme qu’il sélectionne dans un menu.
- Les personnages disposent d’une vie ordinaire avant leur fonction érotique.
- Une scène principale domine chaque fenêtre ; les autres présences restent des échos limités.
- Les conséquences dues passent avant les nouvelles tentations.
- Les promesses, alibis, images, suppressions et occasions manquées doivent muter ou être payés.
- Un seul score d’affection ne doit pas remplacer la psychologie.
- Une route peut se fermer avant le sexe et rester narrativement complète.
- Les scènes explicites doivent conserver la voix du personnage et produire un après-coup.
- Les personnages secondaires restent humains et proportionnels.

## 7. Règles adultes permanentes

```text
Ignorer n'est pas consentir.
Une connaissance partielle n'est pas une permission.
La jalousie et l'excitation ne sont pas une permission.
Une image publique n'est pas une permission de transmettre.
Un vêtement ou costume n'est pas un consentement global.
Une trahison clairement nommée reste une trahison.
Une négociation ultérieure n'efface pas le passé.
```

## 8. Documents historiques

Les anciens éléments suivants restent consultables, mais ne déterminent plus l’ordre narratif :

- ancien J2 intégré ;
- `docs/J2_WRITING_FOUNDATION.md` ;
- `docs/story_state/J2_SUMMARY.md` ;
- anciennes fondations J3–J5 ;
- ancien spine J1–J10 ;
- anciennes matrices de routes et preuves.

Ils peuvent fournir un support technique ou une idée isolée à revalider.

Sont particulièrement dépréciés comme contraintes :

- selfie canapé Mathilde ;
- quatre visuels J2 obligatoires ;
- Player absent du foyer jusqu’à J3 ;
- Pauline et Nico exclus uniquement par numéro de jour ;
- progression fixe J3 → J4 → J5 ;
- soirée pivot unique imposée à une date déterminée.

## 9. Séquence officielle

```text
V0.79 — Act I Opening Windows Source Pack
V0.80 — First Modular Runtime Integration Plan
V0.81 — First Modular Runtime Vertical Slice
V0.82+ — Extension incrémentale des fenêtres et pools validés
```

## 10. À éviter maintenant

- écrire tout l’Acte I avant validation du premier runtime vertical ;
- modifier J2+ directement depuis les anciens documents ;
- ajouter une route R2/R3 dans l’ouverture V0.79 ;
- réintroduire le selfie canapé ;
- créer le pacte voyeur Nico trop tôt ;
- ouvrir le compte cosplay de Raphaëlle trop tôt ;
- donner à Pauline un crop privé dès son premier accès ;
- ajouter une nouvelle photo Sandra immédiatement ;
- traiter Mathilde comme la récompense du choix de rester au foyer ;
- supprimer la conséquence de retour vers Marie ;
- développer un gros scheduler universel avant d’avoir validé une petite tranche ;
- fusionner documentation et runtime dans la même étape sans validation.
