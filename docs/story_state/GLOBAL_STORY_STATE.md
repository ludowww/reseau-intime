# État global de l’histoire — V0.84

> Résumé opérationnel après intégration du flux temporel autoritaire.  
> Le runtime reste narrativement identique à V0.82 jusqu’au jeudi soir, mais les jours et moments ne sont plus réarrangeables.  
> J1 reste temporairement legacy jusqu’à V0.85.

## 1. Hiérarchie actuelle

```text
canon personnages
+ V0.78 architecture
+ V0.79 ouverture
= vérité narrative large

V0.83 flux temporel
+ V0.83 source J1 réconciliée
= vérité corrective

V0.84
= runtime temporel actif

V0.85
= prochaine correction du contenu mardi

legacy Chapter 1–9
= historique technique sauf référence active explicite
```

## 2. Visibilité initiale

Au lancement :

```text
Mardi = actif
Mercredi = verrouillé
Jeudi = verrouillé
Vendredi = absent
```

Les indexes Mercredi et Jeudi sont chargés techniquement, mais invisibles et inaccessibles tant que la journée précédente n’est pas terminée.

## 3. Progression des journées

```text
fin Mardi
-> MARDI — FIN DE JOURNÉE
-> MERCREDI — MIDI
-> Mercredi déverrouillé et sélectionné

fin Mercredi
-> MERCREDI — FIN DE JOURNÉE
-> JEUDI — MATIN
-> Jeudi déverrouillé et sélectionné

fin Jeudi
-> JEUDI — FIN DE JOURNÉE
-> la suite n'est pas encore disponible
```

Les anciennes journées deviennent des archives en lecture seule.

## 4. Phases temporelles

Jour :

```text
LOCKED -> AVAILABLE -> ACTIVE -> COMPLETE -> ARCHIVED
```

Phase :

```text
LOCKED -> CURRENT -> COMPLETE / SKIPPED / EXPIRED
```

Règle :

```text
les timestamps décrivent le temps
les phases autorisent l'accès
```

## 5. Mardi actuel

Structure temporelle V0.84 :

```text
18:12 Marie obligatoire
-> 22:57 Sandra obligatoire
-> Mardi terminé
-> Mercredi
```

Le contenu reste le J1 legacy filtré.

Les incohérences de texte, timestamps, rythme et fin sur Sandra restent une dette explicitement prévue pour V0.85.

## 6. Mercredi actuel

```text
12:10 Marie / faire de la place
-> 18:18 Marie / trace d'arrivée
-> 18:22 Mathilde / arrivée
-> installation hors ligne
-> Mercredi terminé
-> Jeudi
```

Mathilde termine mercredi en :

```text
R1 Ordinary Access
stay active
aucune intention sexuelle
```

## 7. Jeudi actuel

```text
09:10 Raphaëlle obligatoire
-> 13:50 Sandra optionnelle
-> avancer explicitement
-> Sandra vue ou expirée
-> 16:05 Marie obligatoire
-> une branche O5
-> 22:10 retour Marie obligatoire
-> Jeudi terminé
```

Marie n’est plus accessible en même temps que Sandra immédiatement après Raphaëlle.

### Sandra ignorée

```text
chapter_03_sandra_continuity = EXPIRED
thursday_sandra_echo_missed = true
```

Sandra disparaît de la phase et ne peut plus être répondue après 16:05.

### Sandra ouverte

L’avancement est bloqué tant que son échange n’est pas terminé.

## 8. Interstitiels

Le runtime possède désormais :

- une page bloquante de changement de jour ;
- une carte courte pour les grands sauts intrajournaliers ;
- un délai minimal de lecture ;
- un skip souris/clavier après ce délai ;
- une page neutre correspondant au nouveau moment une fois la transition fermée.

## 9. Archives

Une journée terminée :

- reste consultable ;
- n’affiche aucun badge pending ;
- ne produit aucune notification ;
- n’offre aucun nouveau choix ;
- ne réapplique aucun effet ;
- ne change pas l’heure actuelle ;
- ne réactive pas une scène expirée ;
- filtre les fils persistants par épisode source pour éviter de montrer du futur dans le passé.

## 10. État narratif après jeudi

```text
Marie/Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE
Mathilde = R1 domestique
Raphaëlle = R1 travail
Sandra = continuité douce ou écho jeudi expiré
Pauline = inactive
Nico = inactive
hard secrets = none
adult frames = none
Friday = not implemented
```

V0.84 n’ajoute aucun score relationnel ou route.

## 11. J1 cible V0.85

```text
18:12 Marie à distance + M1
19:15 dîner / marche hors ligne
22:57 Sandra / trace douce + S1
23:25 retour final Marie / vie commune
fin Mardi -> Mercredi
```

V0.85 remplacera les deux gros fichiers actifs par de nouveaux fichiers concis, avec flags uniquement.

## 12. Runtime ajouté

```text
game/scripts/core/TimelineState.gd
game/scripts/ui/PhonePrototypeV084.gd
game/scripts/ui/ConversationViewV084.gd
game/scripts/ui/TimelineTransitionView.gd
game/scenes/smartphone/TimelineTransitionView.tscn
```

Les scripts V0.84 étendent les fondations V0.81/V0.82 plutôt que de les refactorer.

## 13. Validation

Nouveau test :

```text
tests/test_v084_temporal_flow_static.py
```

Les commandes Python et Godot doivent être exécutées par Hermes/local/CI avant merge, le connecteur GitHub ne disposant pas d’un environnement d’exécution.

## 14. Prochaines versions

```text
V0.85 — J1 Canon Runtime Reconciliation
V0.86 — Friday Public Traces & Opening Completion
```

## 15. Résumé opérationnel

```text
Runtime : jouable jusqu'à jeudi, ordre désormais imposé.
J1 : encore legacy, remplacement prévu V0.85.
Vendredi : toujours absent.
Prochaine étape : rendre mardi narrativement vrai sans toucher à la fondation temporelle.
```
