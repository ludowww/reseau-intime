# Matrice de continuité personnages — V0.86

> Résumé opérationnel après intégration du vendredi et clôture de l’ouverture V0.79.  
> Le runtime est jouable du mardi au vendredi. Tous les personnages principaux ont désormais un premier accès ordinaire défendable.

## 1. Règle de lecture

```text
Mardi–vendredi = runtime actif et chronologiquement verrouillé
Mardi = J1 réconcilié V0.85
Mercredi = changement du foyer V0.81
Jeudi = topologie V0.82 sous flux V0.84
Vendredi = traces publiques et résidu V0.86
anciens Chapter 1–9 = legacy sauf référence active explicite
```

## 2. Matrice actuelle

| Personnage | Accès actif | État à la fin du vendredi | Continuité garantie | Prochaine étape documentaire |
|---|---|---|---|---|
| **Marie** | Mardi ouverture + beats hors ligne ; mercredi O1/O2 ; jeudi O4, O5A possible et O6 obligatoire ; vendredi rapport du foyer. | Couple en `HABITUAL_WARMTH`, reconnexion/dérive candidates seulement. | L’ouverture commence et revient constamment vers la vie commune ; Marie reste propriétaire de son événement et du choix public final. | Nouvelles scènes Marie-for-herself et répétitions de présence, sans crise prématurée. |
| **Sandra** | Mardi trace douce ; jeudi écho optionnel à 13:50. | Soft trace / continuité ordinaire ; aucun R2, aucune seconde image. | J1 reste avant minuit et limité à une image ; jeudi doit être vu ou expiré avant Marie. | Répétition mesurée ou refroidissement explicite, jamais pression. |
| **Player** | Deux choix mardi, choix de participation mercredi, topologie jeudi, P0/N0 vendredi. | Historique de présence, promesse, image publique et amitié mémorisé par flags. | Les choix portent sur ce qu’il fait ; les conséquences sont payées avant la nouvelle fenêtre. | Accumuler un motif de comportement avant toute intention reconnue. |
| **Mathilde** | Indirecte mardi ; arrivée mercredi ; O5B jeudi selon topologie ; correction domestique vendredi. | R1 domestique ; stay active ; aucune intention sexuelle. | L’accès vient du foyer et de la famille, pas d’une récompense sexuelle ; Friday close confirme un rythme ordinaire. | Premières répétitions cuisine/chambre d’appoint selon conditions, toujours pré-R2. |
| **Raphaëlle** | Jeudi 09:10 obligatoire ; O5C possible. | R1 travail ; aucun accès personnel. | Elle reste une pair professionnelle et ne devient pas l’excuse de Player. | Une nouvelle présence ordinaire peut précéder tout cadre créatif privé. |
| **Pauline** | Vendredi 08:35 : relais de trois versions publiques autorisées + P0. | R1 social/public ; Bastien visible ; aucun compartiment privé. | Sa compétence d’image apparaît avant sa double adresse ; Marie reste propriétaire de l’événement. | Répéter le public/social avant toute sélection privée volontaire. |
| **Nico** | Vendredi 14:05 : suivi de la place gardée + N0 ; connaissance possible du séjour Mathilde. | R1 amitié/social ; miroir social possible ; aucun regard dangereux actif. | Il entre comme vrai ami, sans commentaire de corps, demande d’image, rivalité ou arrangement de couverture. | Une nouvelle scène d’amitié doit précéder toute circulation du regard. |

## 3. Chronologie active

### Mardi

```text
18:12 Marie + M1
-> 19:15/19:35 dîner et marche offline
-> 22:57 Sandra + S1
-> 23:25/23:28 final Marie offline
-> fin Mardi / début Mercredi
```

### Mercredi

```text
12:10 Marie / faire de la place
-> 18:18 trace d'arrivée
-> 18:22 Mathilde / arrivée + offline beat
-> fin Mercredi / début Jeudi
```

### Jeudi

```text
09:10 Raphaëlle
-> 13:50 Sandra optionnelle
-> Sandra vue ou expirée
-> 16:05 Marie
-> une branche O5
-> 22:10 O6 Marie
-> fin Jeudi / début Vendredi
```

### Vendredi

```text
08:35 Pauline / photos publiques + P0
-> 14:05 Nico / place gardée + N0
-> 18:05 Marie et Mathilde / échos du foyer
-> 18:25 fermeture hors ligne
-> opening_band_complete
```

## 4. Fils persistants

```text
Marie      = thread_marie_private
Sandra     = thread_sandra_private
Mathilde   = thread_mathilde_private
Raphaëlle  = thread_raphaelle_private
Pauline    = thread_pauline_private
Nico       = thread_nico_private
```

Les archives :

- sont filtrées par épisode source ;
- ne révèlent aucun futur ;
- ne proposent aucun choix ou effet ;
- affichent les beats hors ligne du jour sous `Moments hors ligne`.

## 5. Pauline vendredi

### Ce qu’elle sait

- Marie lui a demandé de relayer les trois versions ;
- le set est destiné au groupe et à La Verrière ;
- Player peut donner un avis public ou renvoyer vers Marie.

### Ce que Player sait

- Pauline a créé le set avec sa télécommande ;
- Bastien est présent dans sa réalité sociale ;
- aucune version privée n’existe dans cette scène.

### Flags possibles

```text
pauline_public_selection_practical
pauline_public_selection_dry
pauline_public_selection_deferred_to_marie
pauline_r1_established
laverriere_public_group_photo_trace_exists
laverriere_public_photo_2_selected
marie_remains_event_decision_owner
```

## 6. Nico vendredi

### Ce qu’il sait

- la présence ou absence de Player à la soirée selon le contexte social ;
- que Mathilde séjourne temporairement chez Player et Marie, si l’écho est payé.

### Ce qu’il ne possède pas

- accès domestique visuel ;
- permission d’image ;
- cadre de rivalité ;
- permission de couvrir un mensonge ;
- cadre adulte partagé.

### Flags possibles

```text
nico_friendship_honest
nico_friendship_playful
nico_social_mirror_seed
nico_r1_established
nico_saved_seat_resolved
nico_missed_opportunity_acknowledged
player_attention_returns_to_marie
nico_knows_mathilde_stay
```

## 7. Traces

| Trace | Statut V0.86 |
|---|---|
| `j1_sandra_lunch_memory_soft` | mardi ; privée, ordinaire, risque 0 |
| `mathilde_arrival_room_01` | mercredi ; foyer privé autorisé |
| `marie_laverriere_setup_01` | jeudi ; image événementielle autorisée si branche Marie |
| `laverriere_public_group_photo_set_01` | vendredi ; set social/public autorisé, Bastien visible, Mathilde absente, risque 0 |

Règle :

```text
Une image publique n'autorise pas un nouveau public privé.
```

## 8. Communication

- Pauline : `TRACE_DELIVERY + REMOTE_ASYNC` ;
- Nico : `REMOTE_ASYNC` ;
- Marie / Mathilde à 18:05 : deux fils privés séparés ;
- fermeture 18:25 : `OFFLINE_BEAT` ;
- aucun faux groupe de foyer ;
- aucune longue conversation Messenger lorsque les trois adultes se retrouvent.

## 9. État final de l’ouverture

```text
Marie/Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE
Sandra = soft trace / continuité ordinaire
Mathilde = R1 domestique
Raphaëlle = R1 travail
Pauline = R1 social/public
Nico = R1 amitié/social

Pauline private compartment = false
Nico dangerous shared-gaze frame = false
hard secrets = none
adult frames = none
routes R2+ = none
household_rhythm_confirmed = true
opening_band_complete = true
```

## 10. Prochaine matrice

V0.87 devra documenter les fenêtres suivant l’accès ordinaire :

- répétition de présence Marie ;
- nouveau contact Sandra ou refroidissement ;
- accès domestique Mathilde conditionnel ;
- seconde présence travail/extérieur Raphaëlle ;
- répétition publique Pauline avant le privé ;
- seconde scène d’amitié Nico avant le regard partagé.

## 11. Final

```text
Tous les personnages existent maintenant dans le runtime comme personnes ordinaires.
La prochaine progression doit naître de la répétition et du contexte,
pas d'un saut automatique vers la tentation.
```
