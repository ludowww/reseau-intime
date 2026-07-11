# Matrice de continuité personnages — V0.84

> Résumé opérationnel après intégration du contrôle des jours et phases.  
> Le contenu narratif reste celui de V0.82 jusqu’au jeudi ; J1 sera remplacé en V0.85.

## 1. Règle de lecture

```text
Mardi–jeudi = runtime V0.84 actif et chronologiquement verrouillé
Mardi dialogue = encore legacy temporaire
V0.85 = remplacement canonique de J1
Vendredi = reporté à V0.86
anciens Chapter 1–9 = legacy sauf référence active explicite
```

## 2. Matrice actuelle

| Personnage | Accès V0.84 | État après jeudi | Effet du flux temporel | Dette restante / prochaine étape |
|---|---|---|---|---|
| **Marie** | Mardi obligatoire, mercredi O1/O2, jeudi O4/O5A possible et O6 obligatoire. | Couple en `HABITUAL_WARMTH`, reconnexion/dérive candidates seulement. | Les jours futurs restent verrouillés ; O6 clôt réellement jeudi avant toute suite. | Mardi legacy ne revient pas correctement vers Marie ; V0.85 ajoute dîner/marche et final Marie. |
| **Sandra** | Mardi obligatoire dans le J1 temporaire ; jeudi optionnelle à 13:50. | Continuité douce ; aucun R2 ou second visuel. | Marie 16:05 reste cachée jusqu’à Sandra terminée ou expirée. Une Sandra ignorée devient inaccessible. | Mardi encore trop avancé et incohérent ; V0.85 remplace par une trace concise et une limite douce. |
| **Player** | Progresse uniquement dans le jour et la phase courants. | Historique de participation/topologie mémorisé par flags. | Ne peut plus ouvrir Mercredi/Jeudi en avance ni répondre à 13:50 après 16:05. | J1 contient encore trop de clics guidés et anciens scores jusqu’à V0.85. |
| **Mathilde** | Indirecte mardi, arrivée mercredi, O5B jeudi seulement si topologie foyer. | R1 domestique ; aucune intention sexuelle. | Mercredi reste verrouillé jusqu’à fin Mardi ; jeudi jusqu’à fin Mercredi. | Nouveau J1 V0.85 supprimera toute dépendance aux gros fichiers filtrés. |
| **Raphaëlle** | Jeudi 09:10 obligatoire ; O5C possible. | R1 travail. | Jeudi ne devient visible qu’après mercredi ; sa scène ouvre ensuite seulement la phase Sandra. | Aucun changement narratif prévu V0.85. |
| **Pauline** | Absente. | Inactive. | Vendredi n’existe pas dans le runtime actif. | Entrée R1 public/social reportée à V0.86. |
| **Nico** | Absent. | Inactif. | Vendredi n’existe pas dans le runtime actif. | Entrée R1 amitié/social reportée à V0.86. |

## 3. Chronologie active

### Mardi temporaire

```text
18:12 Marie obligatoire
-> 22:57 Sandra obligatoire
-> interstitiel fin Mardi / début Mercredi
```

### Mercredi

```text
12:10 Marie / faire de la place
-> 18:18 trace d'arrivée
-> 18:22 Mathilde / arrivée + offline beat
-> interstitiel fin Mercredi / début Jeudi
```

### Jeudi

```text
09:10 Raphaëlle obligatoire
-> 13:50 Sandra optionnelle
-> Sandra vue ou expirée
-> 16:05 Marie obligatoire
-> une branche O5
-> 22:10 O6 Marie obligatoire
-> fin Jeudi
```

## 4. Fils persistants et archives

```text
Marie      = thread_marie_private
Sandra     = thread_sandra_private
Mathilde   = thread_mathilde_private
Raphaëlle  = thread_raphaelle_private
```

Les fils continuent entre les jours actifs.

Lorsqu’un ancien jour est rouvert :

- l’historique est filtré par épisode source ;
- les épisodes ultérieurs du même fil ne sont pas révélés ;
- aucun choix, effet, badge, notification ou changement d’heure n’est produit.

## 5. Sandra jeudi

### Vue

- Player ouvre l’écho à 13:50 ;
- l’avancement vers 16:05 est bloqué jusqu’à sa fin ;
- une fois terminée, le bouton permet de continuer.

### Ignorée

```text
chapter_03_sandra_continuity = EXPIRED
thursday_sandra_echo_missed = true
```

Elle disparaît avant Marie et ne peut pas être rouverte à l’ancienne heure.

## 6. État et flags temporels

V0.84 mémorise de manière éphémère :

- jours déverrouillés/terminés ;
- jour courant ;
- phase courante ;
- phases terminées ou sautées ;
- épisodes sources terminés ;
- conversations optionnelles ouvertes ;
- conversations expirées.

Nouveau flag narratif possible :

```text
thursday_sandra_echo_missed
```

Aucun score de désir, affection, jalousie ou couple n’est ajouté.

## 7. J1 cible V0.85

```text
18:12 Marie remote + M1
19:15 dîner/marche offline
22:57 Sandra trace + S1
23:25 final Marie/shared-life offline
fin Mardi -> Mercredi
```

Deux nœuds significatifs, trois choix chacun.

Flags cibles :

```text
j1_marie_present
j1_marie_playful_present
j1_marie_delayed_flat
j1_shared_evening_completed
j1_sandra_safe_warmth
j1_sandra_precise_observation
j1_sandra_cautious
j1_sandra_trace_complete
j1_marie_final_return_present
j1_marie_final_return_delayed
j1_day_complete
```

Aucun ancien score numérique.

## 8. Traces

| Trace | Statut V0.84 |
|---|---|
| `j1_sandra_lunch_memory_soft` | active dans le J1 legacy, à conserver sous forme concise en V0.85 |
| `j1_marie_kitchen_soft` | legacy actif temporaire, décision finale V0.85 |
| `j1_mathilde_bag_domestic_trace` | filtré/inactif |
| `mathilde_arrival_room_01` | mercredi, inchangé |
| `marie_laverriere_setup_01` | jeudi, inchangé |

## 9. Communication

- transitions : interstitiels bloquants et courts ;
- archive : lecture seule ;
- co-présence : toujours hors ligne ;
- Sandra jeudi : `REMOTE_ASYNC` uniquement pendant 13:50 ;
- aucun message futur visible avant sa phase.

## 10. Prochaine matrice

Après V0.85, V0.86 pourra ajouter :

- Pauline R1 social/public ;
- Nico R1 amitié/social ;
- photo de groupe publique ;
- respiration du foyer ;
- clôture du pack V0.79.

## 11. Final

```text
V0.84 corrige l'accès au temps.
V0.85 doit maintenant corriger le contenu du premier soir sans modifier cette fondation.
```
