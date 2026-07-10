# Matrice de continuité personnages — V0.81

> Résumé opérationnel après la première tranche runtime modulaire.  
> Les fiches complètes, V0.78, V0.79 et le rapport V0.81 restent prioritaires.

## 1. Règle de lecture

```text
Mardi–mercredi = runtime V0.81 actif
Jeudi–vendredi = canon documentaire V0.79, runtime non intégré
Actes ultérieurs = architecture V0.78
anciens Chapter 2–9 = legacy inactif
```

## 2. État jouable actuel

| Personnage | Mardi | Mercredi V0.81 | État après mercredi | Prochaine étape permise | Interdit actuellement |
|---|---|---|---|---|---|
| **Marie** | Fil actif J1 ; couple en `HABITUAL_WARMTH`. | O1 urgence Mathilde puis O2 trace d’arrivée dans le même fil persistant. | Qualité de participation de Player mémorisée ; aucune crise ; reste le pont famille/couple. | O4 invitation et retour O6 dans V0.82. | Être remplacée par la route Mathilde ; saut direct vers crise ou pardon. |
| **Sandra** | Fil actif et trace douce J1. | Aucun nouvel épisode jouable. | Continuité inchangée. | Écho après poste du matin dans V0.82. | Nouvelle photo, pression, confession, route accélérée. |
| **Player** | Répond par choix dans les fils Marie/Sandra. | M0 puis MT0 ; fait de la place et accueille Mathilde. | Historique observable par flags ; aucun secret ni route choisie. | Choix topologique M1 dans V0.82. | Scores abstraits supplémentaires, menu de personnages, annulation rétroactive du choix. |
| **Mathilde** | Indirecte seulement ; faux bagage déjà installé filtré. | Fil ouvert à 18:22 ; accueil pratique, taquin ou distant ; passage hors ligne au retour de Player. | `mathilde_stay_active` ; R1 Ordinary Access ; aucune intention sexuelle. | Scène foyer O5B possible dans V0.82 selon topologie. | Selfie canapé, séduction, image adulte, consentement inféré du vêtement. |
| **Raphaëlle** | Absente du runtime actif. | Absente. | Aucun accès post-J1 jouable. | O3 travail puis O5C possible dans V0.82. | Compte créatif, refuge, photo personnelle, route active avant travail ordinaire. |
| **Pauline** | Absente du runtime actif. | Absente. | Aucun accès post-J1 jouable. | O7 photo publique dans V0.83. | Crop privé, preuve réciproque, secret, Bastien effacé. |
| **Nico** | Absent du runtime actif. | Absent. | Aucun accès post-J1 jouable. | O8 place gardée dans V0.83. | Voyeurisme, demande de photo, alibi, rivalité ou NTR trop tôt. |

## 3. Fils et épisodes

### Marie

```text
thread_marie_private
```

Contient actuellement :

- J1 Mardi ;
- mercredi O1 ;
- mercredi O2 trace.

Les épisodes verrouillés ne doivent pas exposer leur heure avant déblocage.

### Mathilde

```text
thread_mathilde_private
```

S’ouvre seulement après la trace d’arrivée de Marie.

### Sandra

Son fil J1 reste inchangé ; aucun mercredi artificiel n’est ajouté.

## 4. Connaissances après mercredi

### Marie

Sait :

- l’urgence de Mathilde ;
- le niveau de participation de Player ;
- que Mathilde est arrivée ;
- que la photo d’arrivée a été envoyée à Player.

### Mathilde

Sait :

- que Marie et Player l’hébergent ;
- que Marie a pris/envoyé la photo pratique ;
- la qualité de l’accueil de Player.

Ne sait pas, parce que cela n’existe pas encore :

- route externe ;
- photo transmise ;
- intention sexuelle ;
- attraction active de Nico.

### Player

Sait :

- la cause du séjour ;
- la durée approximative ;
- l’état pratique de la chambre ;
- ce qu’il a choisi de faire.

## 5. Traces actuelles

| Trace | Public | Fonction | Risque |
|---|---|---|---|
| `j1_marie_kitchen_soft` | Player | chaleur domestique J1 | faible |
| `j1_sandra_lunch_memory_soft` | Player | trace Sandra J1 | faible |
| `mathilde_arrival_room_01` | Player, avec connaissance Marie/Mathilde | documenter l’installation | 0 / non-preuve |

Le visuel legacy `j1_mathilde_bag_domestic_trace` reste dans les fichiers historiques mais est exclu du contenu actif Mardi.

## 6. Temps et communication

```text
Mardi : 18:12+
Mercredi : 12:10 -> 18:18 -> 18:22 -> retour hors ligne
```

- pas de conversation longue entre personnes co-présentes ;
- l’arrivée est messagée pendant l’absence de Player ;
- l’installation réelle passe en `offline_beat` ;
- l’heure narrative ne recule pas ;
- le beat hors ligne ne se duplique pas à la réouverture.

## 7. État et flags

```text
opening_make_room_proactive / playful / passive
mathilde_arrival_practical / playful / distant
mathilde_stay_active
opening_wednesday_complete
```

Aucun :

- score d’affection supplémentaire ;
- désir ;
- jalousie ;
- secret ;
- cadre adulte ;
- changement de couple.

## 8. Prochaine matrice

V0.82 devra ajouter :

- Raphaëlle R1 travail ;
- écho Sandra ;
- topologie M1 ;
- une seule branche O5 ;
- retour Marie O6 obligatoire ;
- état de promesse tenue, modifiée ou manquée.

## 9. Final

```text
Le runtime actuel s'arrête après l'installation de Mathilde mercredi soir.
Tout ce qui concerne jeudi et vendredi reste documenté mais non jouable.
```
