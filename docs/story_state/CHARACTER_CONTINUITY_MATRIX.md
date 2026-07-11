# Matrice de continuité personnages — V0.83

> Résumé opérationnel après audit du temps et de J1.  
> V0.82 reste le runtime actif ; V0.83 définit les corrections avant toute intégration du vendredi.

## 1. Règle de lecture

```text
Mardi–jeudi = runtime V0.82 actif
V0.83 = correction documentaire du temps et de J1
V0.84 = fondation temporelle à venir
V0.85 = remplacement runtime J1 à venir
Vendredi = reporté à V0.86
```

## 2. Matrice actuelle et cible

| Personnage | Runtime V0.82 actuel | Dette confirmée | Cible V0.84/V0.85 | État après correction |
|---|---|---|---|---|
| **Marie** | Mardi très long, puis mercredi/jeudi cohérents ; O6 jeudi obligatoire. | Mardi ne revient pas réellement vers elle après Sandra ; dîner/marche absents comme action vécue ; vieux scores. | Nouveau fil mardi concis, beat dîner/marche, beat final Marie ; aucun score numérique. | Centre vivant de mardi, mercredi et jeudi ; couple toujours `HABITUAL_WARMTH`. |
| **Sandra** | Gros fil mardi legacy + écho jeudi disponible en même temps que Marie. | Mardi trop avancé émotionnellement ; mauvaise journée dite ; heures inversées ; lac/roman/manque ; vieux attachement. Jeudi reste répondable après 16:05. | Mardi : une photo floue et une limite douce. Jeudi : fenêtre optionnelle 13:50 qui expire avant Marie. | Trace douce, pas de R2, pas de seconde image. |
| **Player** | Peut sélectionner les jours librement et répondre aux heures dans le désordre. | Le temps n’est pas un état ; dizaines de clics guidés J1 ; anciens scores. | Jours/phase verrouillés ; M1 et S1 seulement comme vrais choix mardi ; flags observables. | Historique temporel lisible, aucun réarrangement du temps. |
| **Mathilde** | Indirecte mardi par filtre, arrivée mercredi, O5B jeudi possible. | Mardi repose encore sur fichiers legacy contenant l’ancien matériel même s’il est filtré. | Nouveau J1 sans bagages/chargeur/racket ; mercredi/jeudi inchangés. | Indirecte mardi, R1 domestique mercredi/jeudi. |
| **Raphaëlle** | Jeudi travail à 09:10, O5C possible. | Aucun problème de contenu majeur ; accès au jour trop tôt car Jeudi est visible dès le lancement. | Jeudi verrouillé jusqu’à fin Mercredi ; phase 09:10 obligatoire. | R1 travail, chronologie correcte. |
| **Pauline** | Absente. | Son vendredi était prévu avant correction de la fondation temporelle. | Reportée à V0.86. | Toujours inactive jusqu’après V0.85. |
| **Nico** | Absent. | Même risque que Pauline. | Reporté à V0.86. | Toujours inactif jusqu’après V0.85. |

## 3. Fils futurs actifs pour J1

V0.85 doit utiliser :

```text
thread_marie_private
thread_sandra_private
```

avec de nouveaux fichiers actifs concis.

Les gros fichiers legacy restent sur disque mais ne sont plus référencés par l’index Mardi.

## 4. Chronologie cible Mardi

```text
18:12 Marie remote
19:15 Marie/Player offline dinner + walk
22:57 Sandra remote trace
23:25 Marie/Player offline final return
fin de journée
```

Aucune heure ne recule.

## 5. Chronologie cible Jeudi

```text
09:10 Raphaëlle obligatoire
13:50 Sandra optionnelle
16:05 Marie obligatoire
soir une seule branche O5
22:10 O6 Marie obligatoire
```

La phase Sandra doit être vue ou expirée avant Marie.

## 6. Choix J1 cible

### Marie M1

```text
présent
joueur-présent
retardé/plat
```

### Sandra S1

```text
chaleur sûre
observation précise
prudence
```

Deux nœuds significatifs, trois choix chacun.

## 7. Connaissances et états J1 cible

### Marie

Sait :

- comment Player a répondu à sa demande ;
- s’il a réellement rejoint la soirée commune.

### Sandra

Sait :

- comment Player a lu la photo ;
- rien d’autre sur les routes ou le foyer.

### Player

Sait :

- que Marie veut une présence concrète ;
- que Sandra a gardé une photo floue ;
- que Mathilde pourrait passer voir l’installation mercredi.

### Mathilde

Ne possède aucun fil actif Mardi.

## 8. Flags J1 cible

```text
j1_marie_present
j1_marie_playful_present
j1_marie_delayed_flat
j1_shared_evening_completed
j1_marie_return_active
j1_marie_return_delayed
j1_sandra_safe_warmth
j1_sandra_precise_observation
j1_sandra_cautious
j1_sandra_trace_complete
j1_marie_final_return_present
j1_marie_final_return_delayed
j1_day_complete
```

Aucun :

```text
marie_attention_score
marie_neglect_score
sandra.attachment
sandra_priority_score
truth_tendency
```

## 9. Traces

| Trace | Statut après V0.85 |
|---|---|
| `j1_sandra_lunch_memory_soft` | conservée, unique trace Sandra |
| `j1_marie_kitchen_soft` | à retirer sauf validation explicite d’une ligne photo concise |
| `j1_mathilde_bag_domestic_trace` | legacy uniquement, jamais actif |
| `mathilde_arrival_room_01` | inchangée mercredi |
| `marie_laverriere_setup_01` | inchangée jeudi |

## 10. Communication

- Marie mardi 18:12 : `REMOTE_ASYNC` ;
- dîner/marche : `OFFLINE_BEAT` ;
- Sandra mardi 22:57 : `REMOTE_ASYNC` ;
- final Marie mardi : `OFFLINE_BEAT` ;
- Jeudi Sandra : `REMOTE_ASYNC` mais seulement pendant sa phase ;
- co-présence : aucun chat artificiel.

## 11. Prochaine matrice

Après V0.85 seulement, V0.86 pourra ajouter :

- Pauline R1 social/public ;
- Nico R1 amitié/social ;
- photo de groupe publique ;
- respiration du foyer ;
- clôture du pack V0.79.

## 12. Final

```text
V0.83 ne change aucun état jouable.
Il définit la chronologie et les contenus qui doivent remplacer les dettes actuelles avant Vendredi.
```
