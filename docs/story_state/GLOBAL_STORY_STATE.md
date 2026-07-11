# État global de l’histoire — V0.82

> Résumé opérationnel après intégration de la topologie du jeudi.  
> Le runtime jouable actuel est canonique jusqu’au jeudi soir inclus.

## 1. Hiérarchie actuelle

```text
canon personnages
+ V0.78 architecture
+ V0.79 source pack / cartes / temps
= vérité narrative

V0.80 plan technique
= stratégie d'intégration

V0.81 mardi–mercredi
+ V0.82 jeudi conditionnel
= vérité jouable actuelle

anciens Chapter 2–9
= fichiers legacy inactifs
```

## 2. Navigation active

```text
Mardi — Les choses qu'on remarque
Mercredi — Faire de la place
Jeudi — Être là
```

Indexes actifs :

```text
chapter_01_modular_index.json
chapter_02_modular_index.json
chapter_03_modular_index.json
```

Vendredi n’est pas encore jouable.

## 3. État avant jeudi

Après mercredi :

```text
Mathilde stay = active
Mathilde = R1 Ordinary Access
couple = HABITUAL_WARMTH
hard secrets = none
adult frames = none
```

## 4. Jeudi matin — Raphaëlle

```text
09:10
WORK_CHAT
```

Player répond à une correction UX/accessibilité par :

- responsabilité ;
- humour suivi d’une correction ;
- report.

Raphaëlle atteint :

```text
R1 Ordinary Work Access
```

Aucun accès privé ou sexuel.

## 5. Jeudi début d’après-midi — Sandra

```text
13:50
REMOTE_ASYNC
```

Écho optionnel après un poste du matin :

- aucun nouveau visuel ;
- aucune promesse ;
- aucun changement de route.

Sandra ne bloque pas la suite Marie.

## 6. Jeudi fin d’après-midi — choix topologique

```text
16:05
Marie / vernissage La Verrière
```

M1 :

```text
1. rejoindre Marie tôt
2. rester au foyer
3. finir le travail et promettre de venir ensuite
```

Le runtime pose exactement un flag topologique et débloque une seule soirée.

## 7. Jeudi soir — une seule branche

### O5A — Marie / La Verrière

```text
17:55
SAME_VENUE_LOGISTICS
```

Player peut :

- prendre l’initiative ;
- aider en plaisantant ;
- être présent mais distrait.

Visuel possible :

```text
marie_laverriere_setup_01
```

### O5B — Mathilde / foyer

```text
18:20
SEPARATE_ROOMS_PING
```

Player peut :

- aider directement ;
- aider en plaisantant ;
- garder ses distances.

Les branches aidantes cessent le chat lorsque Player entre dans la chambre et passent en `offline_beat`.

### O5C — Raphaëlle / travail

```text
17:45
WORK_CHAT
```

Player peut :

- tenir sa promesse ;
- annoncer honnêtement un retard ;
- laisser le travail absorber la soirée.

Raphaëlle ne porte ni son indécision ni la conséquence de couple.

## 8. Jeudi nuit — retour obligatoire vers Marie

```text
22:10+
AFTERGLOW_REMOTE
```

Toute branche O5 terminée débloque O6.

La variante visible dépend du choix réel :

- présence active ;
- présence joueuse ;
- distraction ;
- aide au foyer ;
- distance ;
- promesse tenue ;
- retard annoncé ;
- promesse manquée.

O6 ne propose aucune nouvelle topologie et ne permet pas d’annuler le comportement précédent.

## 9. État après jeudi

```text
Raphaëlle = R1 travail
Mathilde = R1 domestique
Sandra = continuité douce
Marie/Player = HABITUAL_WARMTH
reconnection candidate = possible
parallel drift candidate = possible
hard secrets = none
adult frames = none
Friday = not implemented
```

Un seul jeudi ne change pas automatiquement le mode du couple.

## 10. Fondation technique V0.82

- unlocks conditionnés par flags ;
- `after_any_conversation_completed` ;
- notification silencieuse possible ;
- messages et choix conditionnels ;
- fil persistant cumulé entre les jours ;
- historique conservé ;
- aucun scheduler universel.

## 11. Validation

Tests statiques :

```text
tests/test_v081_wednesday_static.py
tests/test_v082_thursday_static.py
```

L’exécution Python/Godot doit être confirmée en CI ou localement avant merge.

## 12. Prochaine étape

```text
V0.83 — Friday public traces and opening completion
```

## 13. Résumé

```text
Mardi : jouable.
Mercredi : jouable.
Jeudi : une topologie exclusive + retour Marie jouables.
Vendredi : écrit mais non intégré.
Routes : R1 seulement.
Couple : HABITUAL_WARMTH.
```
