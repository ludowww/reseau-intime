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

## Runtime jouable actuel — V0.85

Le contenu est jouable jusqu’au jeudi soir avec jours et phases déverrouillés chronologiquement.

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

## Mardi — J1 réconcilié

```text
18:12 Marie / dîner, pain et marche
-> M1 à trois choix

19:15 ou 19:35
-> dîner et marche hors ligne

22:57 Sandra / ancienne photo floue
-> S1 à trois choix

23:25 ou 23:28
-> retour final Marie / vie commune

fin Mardi -> Mercredi
```

Le J1 actif garantit désormais :

- le pain est encore à acheter quand Player répond ;
- M1 compare trois postures de présence cohérentes ;
- tous les timestamps restent mardi et progressent normalement ;
- Sandra partage une seule trace douce ;
- aucun lac, roman, aveu profond ou score d’attachement ;
- Mathilde reste indirecte ;
- la journée finit sur Marie et la vie commune.

Les anciens gros fichiers J1 restent dans le dépôt comme legacy, mais ne sont plus référencés par l’index actif.

## Mercredi

```text
12:10 Marie / faire de la place
-> 18:18 trace d'arrivée
-> 18:22 Mathilde / arrivée
-> installation hors ligne
```

Mathilde termine mercredi en :

```text
R1 Ordinary Access
stay active
aucune intention sexuelle
```

## Jeudi

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

## Interstitiels et moments hors ligne

Les changements de jour et grands sauts horaires utilisent des cartes bloquantes et brièvement skippables.

V0.85 ajoute deux phases mardi sans conversation :

- dîner et marche ;
- retour final vers Marie.

Elles sont sélectionnées par les flags de choix, affichées une fois, puis conservées dans l’archive sous :

```text
Moments hors ligne
```

Elles ne deviennent jamais de fausses bulles Messenger.

## Archives

Une journée terminée reste consultable en lecture seule.

Une archive :

- n’affiche aucun badge ou notification ;
- ne propose aucun nouveau choix ;
- ne réapplique aucun effet ;
- ne change pas l’heure courante ;
- ne réactive pas une scène expirée ;
- filtre les fils persistants par épisode source ;
- affiche ses moments hors ligne une seule fois.

## État narratif courant

```text
Marie/Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE
Sandra J1 = soft trace seed only
Mathilde = R1 domestique
Raphaëlle = R1 travail
Pauline = inactive
Nico = inactive
hard secrets = none
adult frames = none
Friday = not implemented
```

## Fondation runtime

```text
game/scripts/core/TimelineState.gd
game/scripts/ui/PhonePrototypeV084.gd
game/scripts/ui/PhonePrototypeV085.gd
game/scripts/ui/ConversationViewV084.gd
game/scripts/ui/TimelineTransitionView.gd
```

La couche V0.85 étend V0.84 uniquement pour les phases hors ligne sans conversation et leur journal d’archive.

## Sources

Commencer par :

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
```

Rapport V0.85 :

```text
docs/V0_85_J1_Canon_Runtime_Reconciliation_Report.md
```

## Prochaine version

```text
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
V0.85 rend le premier soir cohérent.
Vendredi peut reprendre seulement après validation de ce socle.
```
