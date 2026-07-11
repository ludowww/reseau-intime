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

## Runtime jouable actuel — V0.84

Le contenu est jouable jusqu’au jeudi soir, mais les jours sont désormais déverrouillés chronologiquement.

Au lancement :

```text
Mardi = actif
Mercredi = verrouillé
Jeudi = verrouillé
Vendredi = absent
```

Progression :

```text
Mardi terminé
-> interstitiel
-> Mercredi déverrouillé et sélectionné

Mercredi terminé
-> interstitiel
-> Jeudi déverrouillé et sélectionné

Jeudi terminé
-> fin de journée
-> aucune suite encore disponible
```

Contenu :

```text
Mardi      J1 Marie + Sandra (legacy temporaire)
Mercredi   urgence et arrivée Mathilde
Jeudi      Raphaëlle, Sandra optionnelle, choix topologique, une branche O5, retour Marie
```

État :

```text
Mathilde = R1 domestique
Raphaëlle = R1 travail
Sandra = continuité douce ou écho jeudi expiré
Marie/Player = HABITUAL_WARMTH
hard secrets = none
adult frames = none
Friday = not implemented
```

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

Le joueur ne peut plus ouvrir une conversation de 13:50 après avoir fait avancer l’histoire à 16:05.

## Interstitiels

Changement de jour :

```text
MARDI — FIN DE JOURNÉE

MERCREDI — MIDI
Faire de la place · 12:10
```

Saut intrajournalier :

```text
JEUDI — FIN D'APRÈS-MIDI
16:05
```

Les cartes :

- bloquent le téléphone pendant la transition ;
- restent lisibles pendant un délai minimal ;
- deviennent skippables ensuite ;
- laissent une page neutre correspondant au nouveau moment.

## Jeudi — Sandra avant Marie

```text
09:10 Raphaëlle obligatoire
-> 13:50 Sandra optionnelle
-> Sandra vue ou expirée
-> 16:05 Marie obligatoire
-> une seule branche O5
-> 22:10 retour Marie obligatoire
```

Si Sandra est ignorée :

```text
chapter_03_sandra_continuity = EXPIRED
thursday_sandra_echo_missed = true
```

Elle ne reste pas accessible après 16:05.

## Archives

Une journée terminée reste consultable en lecture seule.

Une archive :

- n’affiche aucun badge ou notification ;
- ne propose aucun nouveau choix ;
- ne réapplique aucun effet ;
- ne change pas l’heure courante ;
- ne réactive pas une scène expirée ;
- filtre les fils persistants par épisode source pour éviter de montrer le futur dans un jour passé.

## J1 — dette restante

V0.84 ne réécrit aucun dialogue.

Le mardi actif utilise encore les gros fichiers legacy filtrés et conserve notamment :

- une contradiction Mardi/Mercredi ;
- des timestamps qui reculent ;
- une fin sur Sandra plutôt que Marie ;
- une progression Sandra trop avancée ;
- d’anciens scores numériques ;
- trop de clics à réponse unique.

Le remplacement V0.85 est déjà documenté :

```text
18:12 Marie remote + M1
19:15 dîner/marche hors ligne
22:57 Sandra / trace douce + S1
23:25 retour final Marie hors ligne
fin Mardi -> Mercredi
```

## Fondation runtime V0.84

```text
game/scripts/core/TimelineState.gd
game/scripts/ui/PhonePrototypeV084.gd
game/scripts/ui/ConversationViewV084.gd
game/scripts/ui/TimelineTransitionView.gd
```

La couche V0.84 étend les moteurs V0.81/V0.82 sans les refactorer et ajoute uniquement l’état temporel, les interstitiels, l’expiration optionnelle et les archives.

## Sources

Commencer par :

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
```

Rapport runtime :

```text
docs/V0_84_Day_And_Moment_Flow_Runtime_Report.md
```

## Prochaines versions

```text
V0.85 — J1 Canon Runtime Reconciliation
V0.86 — Friday Public Traces & Opening Completion
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
V0.84 rend le temps autoritaire.
V0.85 doit maintenant rendre le premier soir cohérent.
Vendredi attend les deux.
```
