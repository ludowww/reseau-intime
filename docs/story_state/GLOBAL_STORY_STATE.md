# État global de l’histoire — V0.78

> Résumé opérationnel après validation de l’architecture narrative modulaire.  
> Ce fichier ne remplace pas le canon détaillé.  
> Il sert à vérifier rapidement l’état de l’histoire avant un source pack ou une intégration runtime.

## 1. Hiérarchie de vérité actuelle

```text
canon personnages complet
+ canon NSFW
+ canon des choix
+ Modular Narrative Arc Blueprint
+ Modular Scene Authoring Contract
= vérité narrative actuelle

source pack / fenêtre validée
= vérité de contenu pour la tranche concernée

runtime JSON
= implémentation technique, jamais vérité narrative automatique

anciens day plans / spine / arcs / proof maps
= historiques si contradiction
```

## 2. Sources actives

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/NARRATIVE_CANON_STATUS.md
docs/canon/CHOICE_DESIGN_CANON.md
docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md
docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md
docs/canon/characters/CHARACTER_CANON_INDEX.md
docs/canon/characters/*_CANON_FULL.md
docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md
docs/canon/SUPPORTING_CHARACTER_CANON_POLICY.md
```

Pour J1 :

```text
docs/canon/J1_CANON_SOURCE_PACK.md
docs/V0_69_J1_Canon_Text_Review_And_Final_Line_Source.md
```

## 3. Question centrale

```text
Le couple Player / Marie peut-il redevenir un choix actif ?
```

Les autres personnages ne remplacent pas cette histoire.

Ils proposent des réponses, tentations, regards ou conséquences différents.

```text
Marie      = le couple et la reconquête active
Sandra     = la confidence et la vérité privée choisie
Mathilde   = la proximité domestique et le changement d’intention
Pauline    = l’image, la compartimentation et la double vie
Nico       = le regard social, l’envie domestique, le voyeurisme et la rivalité
Raphaëlle  = la version choisie, le cadre explicite et l’après-rôle
Player     = le regard qui devient acte, choix ou mauvaise foi
```

## 4. État actuel après J1

Mode couple :

```text
HABITUAL_WARMTH
```

Cela signifie :

- amour réel ;
- confiance globalement intacte ;
- exclusivité supposée, pas récemment rediscutée ;
- désir sous-exprimé ;
- vie commune fonctionnelle ;
- présence active de Player inégale ;
- Marie demande encore de petites actions plutôt qu’une réparation totale.

État des routes :

- Marie / Player : couple actif, pas de crise déclarée ;
- Sandra : trace douce, aucune route verrouillée ;
- Mathilde : indirecte uniquement dans J1 ;
- Pauline : absente du runtime J1 ;
- Nico : absent du runtime J1 ;
- Raphaëlle : absente du runtime J1 ;
- aucun secret dur ;
- aucun contenu explicite ;
- aucun changement de cadre relationnel.

Les choix J1 créent seulement des signaux de présence, de retard ou d’attention.

## 5. Architecture post-J1

La narration n’utilise plus un ordre fixe J2–J10.

Un cycle narratif suit désormais :

```text
ancrage fixe
-> choix de Player
-> changement de contexte / topologie
-> une scène modulaire principale
-> zéro à deux échos
-> retour à la vie commune ou conséquence
-> mise à jour des obligations et traces
```

Budget par fenêtre :

```text
1 scène principale
0–2 échos
```

Les conséquences dues passent avant une nouvelle tentation.

## 6. Tronc narratif fixe

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

Le contenu exact de chaque ancrage peut varier selon l’état.

La fonction dramatique ne disparaît pas.

## 7. Actes actuels

```text
Acte 0 — Les choses qu'on remarque
Acte I — La place qu'on laisse
Acte II — Les regards circulent
Acte III — Les lignes choisies
Acte IV — Les versions se rencontrent
Acte V — Ce qu'on choisit de garder
```

Les actes ne correspondent pas à un nombre fixe de jours.

## 8. Fenêtres narratives principales

- foyer Player / Marie ;
- foyer sans Marie ;
- sortie sociale de Marie ;
- Player avec Marie en public ;
- sortie ou obligation séparée de Player ;
- travail Player / Raphaëlle ;
- canal privé de messages ;
- événement de groupe ;
- image / trace ;
- après-scène ;
- vérité du couple.

Une fenêtre définit :

- lieu ;
- moment ;
- personnages disponibles ;
- intimité ;
- témoins ;
- canal ;
- plafond d’intensité ;
- obligations dues.

## 9. Cycle de vie universel des routes

```text
R0 Background
R1 Ordinary Access
R2 Charged Access
R3 Acknowledged Intent
R4 Consequential Frame
R5 Integration / Aftermath
```

R4 doit être identifié comme :

```text
trahison cachée
cadre adulte informé
cadre post-séparation
cadre négatif / limite brisée
```

Plusieurs routes R1/R2 peuvent coexister.

Trois secrets conséquents ne peuvent pas s’accumuler silencieusement : collision, exposition, confession ou choix structurel deviennent obligatoires.

## 10. Modèle du couple

Dimensions conceptuelles :

```text
présence
désir
confiance
vérité
cadre relationnel
```

Modes dérivés :

- `HABITUAL_WARMTH` ;
- `ACTIVE_RECONNECTION` ;
- `PARALLEL_DRIFT` ;
- `CONCEALED_FRACTURE` ;
- `OPEN_CRISIS` ;
- `NEGOTIATED_REDESIGN` ;
- `SEPARATED_TRANSITION` ;
- `RECONSTRUCTED_COUPLE`.

Un seul choix ou score ne suffit pas à changer le mode du couple.

## 11. Obligations et mémoire

La narration doit mémoriser :

- promesse ;
- invitation ;
- question sans réponse ;
- dette ;
- alibi ;
- mensonge ;
- règle d’image ;
- suppression promise ;
- limite ;
- confession due ;
- après-scène ;
- occasion manquée.

Une obligation importante ne reste pas inchangée indéfiniment.

Elle est payée, expire, mute, abîme la confiance ou crée une conséquence.

## 12. Traces, connaissance et consentement

Une trace importante doit conserver :

- origine ;
- détenteur ;
- public prévu et réel ;
- droit de conserver ou transmettre ;
- personnes qui savent ou soupçonnent ;
- risque et fenêtres de conséquence.

États de connaissance :

```text
KNOWN
SUSPECTED
MISREAD
UNKNOWN
```

Le consentement est spécifique à :

- personnes ;
- activité ;
- regard ;
- image ;
- conservation ;
- transmission ;
- durée ;
- limites ;
- après-scène.

## 13. Règles NSFW

Le jeu peut devenir pornographique lorsque le cadre est mérité.

```text
Ignorer n'est pas consentir.
Une connaissance partielle n'est pas une permission.
La jalousie n'est pas une permission.
L'excitation n'est pas une permission.
Une image publique n'est pas une permission de transmettre.
Un costume n'est pas un consentement global.
Un secret clairement nommé reste une trahison.
Une négociation tardive ne réécrit pas une trahison antérieure.
```

Toute scène explicite majeure crée une obligation d’après-scène.

## 14. Personnages secondaires

Politique active :

```text
docs/canon/SUPPORTING_CHARACTER_CANON_POLICY.md
```

Jeff reste rattaché à Sandra.

Bastien reste rattaché à Pauline.

Les personnages secondaires restent humains lorsque la connaissance, le consentement, la vie commune ou la trahison les affecte.

Ils ne reçoivent pas automatiquement une route ou un système autonome.

## 15. Vérité actuelle J2+

- aucun ancien J2+ n’est automatiquement canon ;
- aucun dialogue J2 n’est validé par V0.78 ;
- les anciens J3–J10 restent historiques / suspendus ;
- les scènes futures doivent avoir une carte modulaire validée ;
- les choix doivent rester à trois par défaut ;
- aucune grosse refonte runtime ne précède la validation d’une tranche verticale.

## 16. Prochaine étape

```text
V0.79 — Act I Opening Windows Source Pack
```

Ce pack doit définir la première tranche concrète après J1 :

- entrée de Mathilde dans le foyer ;
- première décision topologique autour d’un mouvement proposé par Marie ;
- fenêtres ordinaires de Raphaëlle, Nico et Pauline ;
- continuité Sandra ;
- retours vers Marie ;
- cartes de scènes ;
- choix exacts ;
- conditions, conséquences et fallbacks.

Aucun runtime avant validation de ce pack.

## 17. Résumé opérationnel

```text
J1 : canon actuel.
J2+ : architecture modulaire validée, contenu concret encore à écrire.
Ancien J2–J10 : historique / suspendu.
Prochaine documentation : Act I Opening Windows Source Pack.
Runtime : seulement après source pack + cartes de scènes + plan d'intégration.
```
