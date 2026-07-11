# Matrice de continuité personnages — V0.85

> Résumé opérationnel après remplacement du J1 actif.  
> Le runtime reste jouable jusqu’au jeudi soir ; vendredi est reporté à V0.86.

## 1. Règle de lecture

```text
Mardi–jeudi = runtime actif, chronologiquement verrouillé
Mardi = contenu J1 réconcilié V0.85
Mercredi = tranche V0.81
Jeudi = topologie V0.82 sous flux V0.84
Vendredi = absent jusqu'à V0.86
anciens Chapter 1–9 = legacy sauf référence active explicite
```

## 2. Matrice actuelle

| Personnage | Accès actif | État après jeudi | Continuité garantie | Prochaine étape |
|---|---|---|---|---|
| **Marie** | Mardi ouverture + deux beats hors ligne ; mercredi O1/O2 ; jeudi O4/O5A possible et O6 obligatoire. | Couple en `HABITUAL_WARMTH`, reconnexion/dérive candidates seulement. | Mardi commence et finit sur la vie commune ; pain, dîner et marche ont réellement lieu ; O6 clôt jeudi. | Nouvelles scènes Marie-for-herself après l’ouverture. |
| **Sandra** | Mardi trace douce obligatoire ; jeudi écho optionnel à 13:50. | Soft trace seed ; aucun R2, aucune seconde image. | J1 reste avant minuit, sans lac/roman/confession profonde ; jeudi doit être terminé ou expiré avant Marie. | Continuité future mesurée, jamais pression. |
| **Player** | Deux vrais choix mardi, choix mercredi, topologie jeudi. | Historique de présence et promesse mémorisé par flags. | Le pain est un engagement puis une action ; aucun menu de personnages ; aucun ancien score J1. | Accumuler des comportements cohérents avant R2. |
| **Mathilde** | Indirecte mardi ; arrivée mercredi ; O5B jeudi selon topologie. | R1 domestique ; aucune intention sexuelle. | Aucun fil mardi, aucun sac/chargeur/installation anticipée ; urgence mercredi intacte. | Vendredi respiration du foyer, puis futurs accès ordinaires. |
| **Raphaëlle** | Jeudi 09:10 obligatoire ; O5C possible. | R1 travail. | Son entrée reste professionnelle ; elle ne devient pas l’excuse de Player. | Aucun changement avant la suite validée de l’Acte I. |
| **Pauline** | Absente. | Inactive. | Vendredi n’existe pas encore. | Entrée R1 social/public en V0.86. |
| **Nico** | Absent. | Inactif. | Vendredi n’existe pas encore. | Entrée R1 amitié/social en V0.86. |

## 3. Chronologie active

### Mardi — réconcilié

```text
18:12 Marie remote + M1
-> 19:15/19:35 dîner et marche offline
-> 22:57 Sandra trace + S1
-> 23:25/23:28 final Marie/shared-life offline
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
09:10 Raphaëlle obligatoire
-> 13:50 Sandra optionnelle
-> Sandra vue ou expirée
-> 16:05 Marie obligatoire
-> une branche O5
-> 22:10 O6 Marie obligatoire
-> fin Jeudi
```

## 4. Fils persistants

```text
Marie      = thread_marie_private
Sandra     = thread_sandra_private
Mathilde   = thread_mathilde_private
Raphaëlle  = thread_raphaelle_private
```

Marie et Sandra commencent désormais avec de nouveaux épisodes J1 concis. Les épisodes Mercredi/Jeudi continuent dans les mêmes fils.

Les anciens jours archivés :

- sont filtrés par épisode source ;
- ne révèlent aucun épisode futur ;
- ne proposent aucun choix ou effet ;
- affichent les beats hors ligne du jour sous `Moments hors ligne`.

## 5. Choix et flags mardi

### Marie M1

```text
j1_marie_present
j1_marie_playful_present
j1_marie_delayed_flat
j1_shared_evening_due
```

### Soirée partagée

```text
j1_shared_evening_completed
j1_marie_return_active
j1_marie_return_delayed
```

### Sandra S1

```text
j1_sandra_safe_warmth
j1_sandra_precise_observation
j1_sandra_cautious
j1_sandra_trace_complete
```

### Retour final Marie

```text
j1_marie_final_return_present
j1_marie_final_return_delayed
j1_day_complete
```

Aucun score numérique de confiance, désir, affection, vérité, attachement ou priorité.

## 6. Traces

| Trace | Statut V0.85 |
|---|---|
| `j1_sandra_lunch_memory_soft` | seule image active mardi ; deux verres, coin de table, Sandra floue ; risque 0 |
| `j1_marie_kitchen_soft` | métadonnée legacy non référencée |
| `j1_mathilde_bag_domestic_trace` | métadonnée legacy non référencée |
| `mathilde_arrival_room_01` | mercredi, inchangé |
| `marie_laverriere_setup_01` | jeudi, inchangé |

## 7. Connaissances après mardi

### Marie

Sait :

- que Player a accepté, plaisanté ou tardé ;
- qu’il a tout de même participé au dîner et à la marche ;
- la qualité réelle de sa présence.

Ne sait pas nécessairement :

- le détail du fil Sandra, qui reste une trace privée douce.

### Sandra

Sait :

- comment Player a lu la photographie ;
- qu’elle a choisi de mettre fin à l’échange ;
- que rien n’a été déclaré ou négocié.

### Mathilde

Reste indirecte mardi. Elle ne sait rien d’un séjour qui n’est pas encore déclenché.

## 8. Communication

- Marie 18:12 : `REMOTE_ASYNC` ;
- dîner/marche : `OFFLINE_BEAT` ;
- Sandra 22:57 : `REMOTE_ASYNC` ;
- retour final Marie : `OFFLINE_BEAT` ;
- aucune longue conversation Messenger pendant la co-présence ;
- tous les timestamps mardi restent monotones et avant minuit.

## 9. Sandra jeudi

### Vue

- Player ouvre l’écho à 13:50 ;
- l’avancement vers 16:05 est bloqué jusqu’à sa fin.

### Ignorée

```text
chapter_03_sandra_continuity = EXPIRED
thursday_sandra_echo_missed = true
```

Elle ne peut plus être répondue après le passage à Marie.

## 10. Prochaine matrice

V0.86 pourra ajouter :

- Pauline R1 social/public ;
- Nico R1 amitié/social ;
- photo de groupe publique ;
- respiration du foyer ;
- clôture de l’ouverture V0.79.

## 11. Final

```text
V0.84 a rendu le temps fiable.
V0.85 rend le premier soir humain et cohérent.
La prochaine extension peut désormais reprendre vendredi.
```
