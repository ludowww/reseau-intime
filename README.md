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

## Runtime jouable actuel — V0.82

```text
Mardi
Mercredi
Jeudi
```

Contenu :

```text
Mardi      J1 Marie + Sandra
Mercredi   urgence et arrivée Mathilde
Jeudi      Raphaëlle, écho Sandra, choix topologique, une branche O5, retour Marie
```

État :

```text
Mathilde = R1 domestique
Raphaëlle = R1 travail
Sandra = continuité douce
Marie/Player = HABITUAL_WARMTH
hard secrets = none
adult frames = none
Friday = not implemented
```

## Correction documentaire actuelle — V0.83

V0.83 suspend le vendredi après audit de trois problèmes :

1. Mardi, Mercredi et Jeudi sont tous sélectionnables dès le lancement ;
2. le changement de jour ne possède aucun interstitiel ;
3. J1 et l’ordre horaire du jeudi contiennent des incohérences.

V0.83 ne modifie pas encore le runtime.

## Nouveau canon du temps

Source :

```text
docs/canon/TEMPORAL_FLOW_AND_DAY_TRANSITION_CANON.md
```

Cycle des jours :

```text
LOCKED
AVAILABLE
ACTIVE
COMPLETE
ARCHIVED
```

Cycle des phases :

```text
LOCKED
CURRENT
COMPLETE
SKIPPED
EXPIRED
```

Règle centrale :

```text
Les timestamps décrivent la chronologie.
L'état temporel contrôle l'accès.
```

Un joueur ne doit pas pouvoir ouvrir une conversation de 13:50 après avoir déjà agi à 16:05.

## Transitions visées

Fin/début de journée :

```text
MARDI — FIN DE JOURNÉE

MERCREDI — MIDI
Faire de la place
```

Transition intrajournalière :

```text
JEUDI — FIN D'APRÈS-MIDI
16:05
```

Les jours futurs seront verrouillés. Une journée terminée deviendra une archive en lecture seule.

## Correction J1

Source :

```text
docs/canon/J1_RUNTIME_RECONCILIATION_SOURCE_PACK.md
```

Le J1 actif actuel utilise encore de gros fichiers legacy filtrés et contient notamment :

- une contradiction Mardi/Mercredi ;
- des timestamps qui reculent ;
- une fin émotionnelle sur Sandra plutôt que Marie ;
- une progression Sandra trop avancée ;
- d’anciens scores numériques ;
- trop de clics à réponse unique.

Le futur J1 actif sera :

```text
18:12 Marie remote
19:15 dîner/marche hors ligne
22:57 Sandra / photo floue
23:25 retour final Marie hors ligne
fin Mardi -> Mercredi
```

Deux choix significatifs seulement :

```text
M1 — présent / joueur-présent / retardé-plat
S1 — chaleur sûre / observation précise / prudence
```

## Prochaines implémentations

```text
V0.84 — Day & Moment Flow Runtime Foundation
V0.85 — J1 Canon Runtime Reconciliation
V0.86 — Friday Public Traces & Opening Completion
```

### V0.84

- verrouillage/déverrouillage des jours ;
- interstitiels ;
- phases horaires ;
- scènes optionnelles vues ou expirées ;
- Sandra 13:50 avant Marie 16:05 ;
- aucun nouveau dialogue.

### V0.85

- nouveaux fichiers J1 actifs ;
- deux nœuds à trois choix ;
- deux beats hors ligne ;
- flags uniquement ;
- final obligatoire sur Marie ;
- mercredi/jeudi inchangés.

## Sources

Commencer par :

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
```

Rapport V0.83 :

```text
docs/V0_83_Temporal_Flow_And_J1_Reconciliation_Report.md
```

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
Ne pas ajouter vendredi à une chronologie que le joueur peut réarranger.
Rendre d'abord le temps autoritaire et le premier soir cohérent.
```
