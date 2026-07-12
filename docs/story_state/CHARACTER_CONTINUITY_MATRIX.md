# Matrice de continuité personnages — V0.87

> Résumé opérationnel après rédaction de la première vague de répétition post-ouverture.  
> Le runtime reste jouable du mardi au vendredi sur V0.86.  
> Les fenêtres V0.87 sont canoniques en documentation mais pas encore intégrées.

## 1. Règle de lecture

```text
Mardi–vendredi = runtime actif
V0.87 samedi–mardi = contenu documenté futur
runtime actuel = tous R1 ou soft continuity
plafond V0.87 futur = un seul R2 parmi Mathilde / Sandra / Raphaëlle
Pauline / Nico = R1 conservé
anciens Chapter 1–9 = legacy sauf référence active explicite
```

## 2. Matrice actuelle et prochaine répétition

| Personnage | État runtime fin vendredi | Fenêtre V0.87 autorisée | Maximum documenté | Continuité obligatoire |
|---|---|---|---|---|
| **Marie** | Couple `HABITUAL_WARMTH`, cadre `ASSUMED_EXCLUSIVE`. | Heure partagée samedi + retour concret après chaque foreground externe. | Même mode + preuves reconnexion/dérive. | Marie agit pour elle-même, demande un acte vérifiable, ne devient pas une simple punition. |
| **Sandra** | Trace douce / continuité ordinaire ; jeudi vu ou expiré. | Après-poste ticket fantôme + chocolat chaud, sans nouvelle image. | R2 max si contact choisi + précision + limite respectée. | Pas de pression, Jeff reste humain, fenêtre tardive expire réellement. |
| **Player** | Historique de présence, promesses, topologie, social et amitié. | Choisit comment il crée du temps, assume un regard, respecte un cadre, montre ou non sa présence. | Pas de route propre ; preuves comportementales. | Aucun menu de femmes ; chaque attention externe revient vers une action Marie. |
| **Mathilde** | R1 domestique, stay active, intention sexuelle non établie. | Regard cuisine rouvert à distance après séparation physique. | R2 max si regard reconnu sans revendication. | Tenue normale ≠ consentement ; intention délibérée toujours fausse ; Marie/famille actives. |
| **Raphaëlle** | R1 travail, aucune couche privée. | Marche déjeuner après vrai dossier résolu. | R2 max comme `outside-work person`. | Pas de refuge, compte privé, costume, photo ou attraction nommée. |
| **Pauline** | R1 social/public, Bastien visible, aucun compartiment privé. | Repas légitime avec Bastien et Marie dans la réalité sociale. | R1. | Deuxième cycle public avant le privé ; Bastien non effacé ; aucun crop ou test secret. |
| **Nico** | R1 amitié/social, aucun regard partagé dangereux. | Déjeuner pré-service et Nico calme hors performance sociale. | R1. | Vraie amitié avant pacte ; aucune photo, alibi, jalousie-catalogue ou demande domestique. |

## 3. Chronologie runtime active

### Mardi

```text
18:12 Marie + M1
-> dîner/marche
-> 22:57 Sandra + S1
-> retour final Marie
-> Mercredi
```

### Mercredi

```text
12:10 urgence Mathilde
-> 18:18 trace arrivée
-> 18:22 Mathilde
-> installation foyer
-> Jeudi
```

### Jeudi

```text
09:10 Raphaëlle
-> 13:50 Sandra optionnelle
-> Sandra vue ou expirée
-> 16:05 Marie
-> une branche O5
-> 22:10 retour Marie
-> Vendredi
```

### Vendredi

```text
08:35 Pauline / P0
-> 14:05 Nico / N0
-> 18:05 Marie + Mathilde
-> 18:25 fermeture foyer
-> opening_band_complete
```

Aucune journée ultérieure n’est actuellement jouable.

---

## 4. Chronologie V0.87 documentée

```text
W9  samedi matin — Marie réclame une heure partagée
W10 week-end — un foreground externe éligible
W11 même soir / lendemain — retour Marie obligatoire
W12 premier jour ouvré — un second foreground externe maximum
W13 même soir — fermeture de vague / retour Marie
```

Budget :

```text
2 tickets foreground externes maximum
1 seul personnage chargé maximum
0–2 échos par fenêtre
même personnage deux fois = interdit
```

Ordre des personnages non prédéterminé.

---

## 5. Fils persistants

```text
Marie      = thread_marie_private
Sandra     = thread_sandra_private
Mathilde   = thread_mathilde_private
Raphaëlle  = thread_raphaelle_private
Pauline    = thread_pauline_private
Nico       = thread_nico_private
```

Règle de reprise :

```text
nouvel épisode dans le fil déjà ouvert
-> horloge avance
-> pas de notification même contact
-> reprise à la suite de l'historique
```

Autre contact :

```text
notification compacte
-> aperçu 10 caractères + ...
-> raccourci de changement de fil
```

Les archives :

- filtrent les épisodes par jour ;
- ne révèlent aucun futur ;
- ne proposent aucun choix ou effet ;
- ne déplacent pas l’heure ;
- n’affichent pas de section `Moments hors ligne`.

---

## 6. Marie — continuité V0.87

### Ce qu’elle fait

- rend les clés / fait une course / va au marché ;
- crée une heure agréable avant que Player réponde ;
- invite Player dans une vie déjà en mouvement ;
- accepte un vrai horaire alternatif ;
- profite seule si Player ne vient pas.

### Ce qu’elle lit

- présence immédiate ;
- promesse bornée puis payée ou manquée ;
- retour concret après attention externe ;
- répétition d’un `plus tard` vide.

### Ce qu’elle ne sait pas automatiquement

- contenu des fils Sandra/Mathilde/Raphaëlle ;
- pensée privée de Player ;
- futur moteur NSFW d’un personnage.

### Effets possibles

```text
marie_shared_hour_joined
marie_shared_hour_rescheduled
marie_moves_without_player
marie_return_paid
active_reconnection_evidence
parallel_drift_evidence
```

Ces labels restent conceptuels jusqu’au plan V0.88.

---

## 7. Sandra — continuité V0.87

### Entrée

- trace J1 encore active ou chaleureusement non résolue ;
- limite précédente respectée ;
- rythme de fin de poste crédible ;
- fenêtre jeudi prise en compte.

### Si jeudi a été vu

- priorité de continuation plus forte ;
- scène après-poste possible après cooldown.

### Si jeudi a été ignoré

- scène exacte différée par défaut ;
- possible variante plus froide après délai ;
- aucune punition automatique.

### Ce qui reste interdit

- nouvelle photo ;
- Jeff monstre ;
- Player thérapeute magique ;
- pression récompensée ;
- aveu/affaire en V0.87.

### Plafond

```text
R1 ou R2 Charged Access
```

R2 = Sandra a choisi Player pour cet intervalle et l’a reconnu sous limite douce.

---

## 8. Mathilde — continuité V0.87

### Entrée

- stay active ;
- moment cuisine ordinaire ;
- Marie absente pour une vraie raison ;
- messages seulement après séparation ;
- aucun overstep non résolu.

### Ce qui devient connaissable

- Mathilde a remarqué le regard ;
- Player peut l’assumer, plaisanter ou rétablir la distance ;
- Mathilde peut dire que cela ne l’a pas gênée sans transformer la tenue en invitation.

### Ce qui reste faux

```text
Mathilde deliberate intent = false
image permission = none
adult permission = none
Nico domestic access = none
```

### Plafond

```text
R1 ou R2 Charged Access
```

R2 = regard reconnu et non rejeté, rien de plus.

---

## 9. Raphaëlle — continuité V0.87

### Entrée

- vrai dossier résolu ;
- relation de pairs intacte ;
- positions de travail séparées ;
- pause déjeuner réelle ;
- aucune obligation Marie utilisée comme fuite.

### Accès possible

- marche courte ;
- un détail ordinaire : tissu sans projet, thé, marché, Maud, trajet ;
- retour au travail avec distinction préservée.

### Toujours verrouillé

- compte créatif ;
- costume / fitting ;
- photo ;
- attraction nommée ;
- cadre explicite.

### Plafond

```text
R1 ou R2 Charged Access
```

R2 = Raphaëlle a choisi une couche ordinaire hors bureau.

---

## 10. Pauline — continuité V0.87

### Ce qu’elle sait

- Marie a sa propre décision sociale ;
- Player participe, aide ou décline ;
- Bastien organise réellement le repas avec elle.

### Ce que Player sait

- Pauline et Bastien ont une vie partagée ;
- la compétence publique de Pauline n’était pas une façade vide ;
- aucun message privé supplémentaire n’est promis.

### Toujours verrouillé

```text
private alternate
one-view image
unnecessary alibi
old affair disclosure to Player
reciprocal proof
R2
```

### Résultat

```text
pauline_legitimate_social_repetition
bastien_visible_again
pauline remains R1
```

---

## 11. Nico — continuité V0.87

### Ce qu’il propose

- une heure avant service ;
- un déjeuner réel ;
- de la nourriture, du travail, du foot raté, du silence ;
- aucune monnaie sexuelle.

### Ce que Player peut apprendre

- Nico existe quand il n’anime pas un groupe ;
- l’amitié a une valeur avant le futur pacte ;
- une dette de déjeuner doit avoir une date.

### Toujours verrouillé

```text
photo request
inside/outside exchange
alibi
body catalogue
shared gaze
R2
```

### Résultat

```text
nico_friendship_repeated
nico_quiet_access_seen
nico remains R1
```

---

## 12. Traces

| Trace | Statut V0.87 |
|---|---|
| `j1_sandra_lunch_memory_soft` | historique privé, aucune nouvelle image |
| `mathilde_arrival_room_01` | histoire foyer, aucun recadrage sexuel |
| `marie_laverriere_setup_01` | contexte événement, aucun nouvel usage privé |
| `laverriere_public_group_photo_set_01` | public/social, aucun crop Pauline, aucun pacte Nico |

V0.87 exige :

```text
new_required_images = none
adult_images = none
trace_recontextualization = none
```

---

## 13. Plafond et verrou global

```text
charged_access_owner = none | mathilde | sandra | raphaelle
maximum one owner
```

Dès qu’un propriétaire chargé existe :

```text
retour Marie dû
-> aucune nouvelle opportunité externe
-> paiement / échec du retour
-> suite éventuelle
```

Pauline et Nico ne peuvent pas devenir propriétaire chargé dans V0.87.

---

## 14. Cooldowns et occasions manquées

| Personnage | Cooldown / mutation |
|---|---|
| Marie | l’heure expire ; `plus tard` devient obligation ou échec |
| Sandra | deux fenêtres privées ; la nuit exacte expire |
| Mathilde | deux foregrounds compatibles ; moment exact non rejoué |
| Raphaëlle | une journée de travail ; une seule déférence |
| Pauline | un cycle social ; repas continue sans Player |
| Nico | un cycle social ; déjeuner et service continuent |

Aucune scène ne reste figée dans l’attente du joueur.

---

## 15. État de sortie documenté

```text
first_repetition_wave_complete = true
couple mode = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE

external foregrounds seen = 0–2
charged_access_owner = none | mathilde | sandra | raphaelle

Sandra = R1 or R2
Mathilde = R1 or R2
Raphaëlle = R1 or R2
Pauline = R1
Nico = R1

hard secrets = none
adult frames = none
adult images = none
routes R3+ = none
```

Cet état n’existe pas encore dans le runtime.

---

## 16. Prochaine matrice

V0.88 devra mapper :

- tickets foreground ;
- propriétaire chargé ;
- obligations Marie ;
- cooldowns ;
- expiry/mutation ;
- reprise même fil ;
- sélection déterministe ;
- petite tranche d’intégration.

Aucune scène V0.87 ne doit être ajoutée directement au runtime avant validation de ce plan.

---

## 17. Final

```text
Le runtime prouve que chaque personnage existe.
V0.87 prouve que certaines présences peuvent revenir.
Une seule répétition peut devenir chargée.
Aucune ne devient encore permission.
```
