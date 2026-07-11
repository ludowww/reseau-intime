# Matrice de continuité personnages — V0.82

> Résumé opérationnel après la tranche runtime du jeudi.  
> Les fiches complètes, V0.78, V0.79 et le rapport V0.82 restent prioritaires.

## 1. Règle de lecture

```text
Mardi–jeudi = runtime modulaire actif
Vendredi = canon documentaire V0.79, runtime non intégré
Actes ultérieurs = architecture V0.78
anciens Chapter 2–9 = legacy inactif
```

## 2. Matrice actuelle

| Personnage | État avant jeudi | Présence V0.82 | État après jeudi | Prochaine progression | Interdit actuellement |
|---|---|---|---|---|---|
| **Marie** | Couple en `HABITUAL_WARMTH`, historique M0/MT0 connu. | O4 proposition, O5A possible, O6 obligatoire dans toutes les branches. | Sait si Player a rejoint, aidé ailleurs, annoncé un retard ou manqué sa promesse. Reconnexion/dérive seulement candidates. | Vendredi et nouveau cycle Acte I après V0.83. | Être contournée par la branche ; crise automatique ; route externe remplaçant O6. |
| **Sandra** | Trace douce J1, aucun mercredi. | Écho optionnel après poste du matin. | Continuité vivante, sans nouvelle photo ni promesse. | Autre fenêtre future seulement après respiration. | Pression, confession, route R2 ou second visuel immédiat. |
| **Player** | A fait de la place et accueilli Mathilde. | R0 Raphaëlle, M1, un seul O5, conséquence O6. | Historique topologique et qualité de présence mémorisés par flags. | Vendredi O7/O8 puis nouveaux cycles. | Plusieurs O5 à la fois, nouveau choix annulant O6, scores abstraits supplémentaires. |
| **Mathilde** | Séjour actif, R1 domestique, aucune intention sexuelle. | O5B uniquement si Player reste au foyer. | Aide pratique / complicité ordinaire / distance. R1 maintenu. | Respiration foyer vendredi ; tension R2 seulement dans un pack ultérieur. | Récompense sexuelle du choix de rester, image corporelle, consentement inféré du vêtement. |
| **Raphaëlle** | Aucun accès post-J1 jouable. | O3 travail obligatoire ; O5C seulement si Player choisit le travail. | R1 travail. Peut avoir observé une décision professionnelle, jamais reçu l’intimité du couple. | Nouvelle présence ordinaire future après V0.83. | Refuge, compte créatif, photo privée, désir nommé, responsabilité de la promesse de Player. |
| **Pauline** | Absente du runtime post-J1. | Absente. | Aucun accès jouable. | O7 relais photo publique dans V0.83. | Crop privé, preuve réciproque, secret. |
| **Nico** | Absent du runtime post-J1. | Absent. | Aucun accès jouable. | O8 place gardée dans V0.83. | Voyeurisme, demande de photo, alibi, rivalité ou NTR. |

## 3. Fils persistants

```text
Marie      = thread_marie_private
Sandra     = thread_sandra_private
Mathilde   = thread_mathilde_private
Raphaëlle  = thread_raphaelle_private
```

V0.82 fusionne les nouveaux segments avec l’historique déjà rendu au lieu de remplacer le fil par le seul épisode du jeudi.

Les clés de fusion utilisent :

```text
source conversation ID + segment ID
```

Cela évite les doublons lors des réouvertures.

## 4. Topologie et connaissances

### Rejoindre Marie

Marie sait :

- que Player a choisi de venir ;
- s’il a pris l’initiative, aidé en plaisantant ou déplacé son absence dans la salle.

Mathilde sait seulement que Marie est à l’événement.

### Rester au foyer

Mathilde sait :

- que Player est resté ;
- s’il a aidé ou gardé ses distances.

Marie sait au retour ce que Player lui dit dans O6.

Aucun regard sexuel n’est reconnu.

### Finir le travail

Raphaëlle sait :

- que le dossier doit être décidé ;
- éventuellement que Player doit rejoindre Marie, parce qu’il le dit.

Elle ne sait pas les détails du couple.

Marie sait si la promesse a été tenue, modifiée honnêtement ou manquée.

## 5. Flags actuels

### Topologie

```text
opening_topology_join_marie
opening_topology_stay_home
opening_topology_work_then_join
```

Une seule valeur est possible par parcours normal.

### Qualité de branche

```text
marie_event_initiative
marie_event_playful_help
marie_event_distracted

mathilde_home_help
mathilde_home_playful_help
mathilde_home_distance

work_promise_kept
work_promise_amended
work_promise_missed
```

### Tendances couple

```text
couple_reconnection_candidate
couple_presence_strained
household_participation_positive
parallel_drift_candidate
```

Ce sont des indices historiques, pas un changement automatique de mode.

## 6. Traces

| Trace | Origine | Public | Fonction | Risque |
|---|---|---|---|---|
| `mathilde_arrival_room_01` | Marie mercredi | Player, connaissance Marie/Mathilde | arrivée au foyer | 0 |
| `marie_laverriere_setup_01` | Élodie / événement jeudi | Marie/Player, contexte événement | Marie active dans son monde | 0 |

Aucune image adulte ou transmission non autorisée.

## 7. Communication

- Raphaëlle : work chat à distance ;
- Sandra : message après poste ;
- Marie O4 : échange à distance ;
- Marie O5A : logistique courte dans une salle bruyante ;
- Mathilde O5B : ping entre pièces puis hors ligne ;
- Raphaëlle O5C : work chat ;
- Marie O6 : après-coup à distance.

## 8. État de couple

```text
mode = HABITUAL_WARMTH
frame = ASSUMED_EXCLUSIVE
truth = no consequential hidden secret
```

V0.82 peut renforcer :

```text
ACTIVE_RECONNECTION candidate
ou
PARALLEL_DRIFT candidate
```

mais ne modifie pas encore officiellement le mode.

## 9. Prochaine matrice

V0.83 devra ajouter :

- Pauline R1 public/social ;
- Nico R1 friendship/social ;
- public group-photo trace ;
- household breather ;
- état final complet de l’ouverture V0.79.

## 10. Final

```text
Le runtime actuel s'arrête jeudi nuit après la conséquence Marie.
Vendredi reste documenté mais non jouable.
```
