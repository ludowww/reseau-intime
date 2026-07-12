# État global de l’histoire — V0.87

> Résumé opérationnel après rédaction du premier cycle de répétition post-ouverture.  
> Le runtime reste jouable du mardi au vendredi sur la baseline V0.86.  
> V0.87 documente les fenêtres suivantes mais ne les active pas encore dans le jeu.

## 1. Hiérarchie actuelle

```text
canon personnages
+ V0.78 architecture
= identité et mouvement narratif

V0.79 ouverture
+ V0.83 réconciliation J1 et temps diégétique
= vérité narrative de l'ouverture

V0.84–V0.86a
= runtime actif mardi–vendredi
+ temps autoritaire
+ continuité smartphone

V0.87
= première vague de répétitions autorisée en documentation
= non implémentée

legacy Chapter 1–9
= historique technique sauf référence active explicite
```

## 2. Runtime actuellement jouable

Au lancement :

```text
Mardi = actif
Mercredi = verrouillé
Jeudi = verrouillé
Vendredi = verrouillé
```

Progression active :

```text
fin Mardi -> Mercredi
fin Mercredi -> Jeudi
fin Jeudi -> Vendredi
fin Vendredi -> aucune suite jouable
```

Le runtime s’arrête vendredi soir sur :

```text
household_rhythm_confirmed = true
opening_band_complete = true
```

Les fenêtres samedi–mardi de V0.87 ne sont pas encore chargées.

---

## 3. État narratif implémenté à la fin du vendredi

```text
Marie/Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE

Sandra = soft trace / continuité ordinaire
Mathilde = R1 domestique, stay active
Raphaëlle = R1 travail
Pauline = R1 social/public
Nico = R1 amitié/social

Pauline private compartment = false
Nico dangerous shared-gaze frame = false
hard secrets = none
adult frames = none
routes R2+ = none
```

### Marie

- vie commune réelle et désirable ;
- présence/absence de Player déjà mémorisée ;
- aucun basculement de mode de couple après une seule soirée ;
- prochaine scène doit lui appartenir aussi à elle.

### Sandra

- une seule trace douce mardi ;
- continuité jeudi vue ou expirée ;
- aucune seconde image ;
- aucun accès R2 actif.

### Mathilde

- séjour temporaire actif ;
- accès domestique R1 ;
- sensualité ordinaire visible ;
- intention sexuelle non établie.

### Raphaëlle

- accès professionnel R1 ;
- confiance de travail possible ;
- aucune couche privée ou créative révélée.

### Pauline

- accès R1 social/public ;
- Bastien visible ;
- photo publique avec origine et public connus ;
- aucun compartiment privé actif.

### Nico

- accès R1 amitié/social ;
- connaissance possible du séjour Mathilde ;
- aucun pacte d’image, alibi ou regard partagé actif.

---

## 4. Présentation temporelle active

Le runtime V0.86a utilise :

```text
dernier message
-> contact hors ligne
-> pause de 2 secondes
-> horloge accélérée pendant 4 secondes à Speed x1
-> notification compacte si le prochain message vient d'un autre fil
```

Si le nouvel épisode appartient au fil déjà ouvert :

```text
horloge
-> aucune notification pour le même contact
-> reprise directe à la suite de l'historique
```

Le runtime actif n’utilise plus :

- écran vide de moment de journée ;
- bandeau `Le temps passe` ;
- bouton de scheduler latéral ;
- texte explicatif des actions hors téléphone ;
- section visible `Moments hors ligne` dans les archives.

Les états internes nécessaires à la continuité peuvent rester enregistrés sans être montrés au joueur.

---

## 5. Traces actives

| Trace | Origine | Public / cadre | Statut |
|---|---|---|---|
| `j1_sandra_lunch_memory_soft` | Sandra | privé Player/Sandra | risque 0, une seule trace |
| `mathilde_arrival_room_01` | arrivée foyer | foyer privé autorisé | logistique, pas de fonction sexuelle |
| `marie_laverriere_setup_01` | La Verrière | événement autorisé | branche Marie seulement |
| `laverriere_public_group_photo_set_01` | Pauline / télécommande | groupe photographié + La Verrière | public/social, Bastien visible, Mathilde absente |

Règle :

```text
Une image publique n'autorise ni recadrage privé,
ni sexualisation partagée,
ni nouveau destinataire.
```

V0.87 n’ajoute aucune image obligatoire.

---

## 6. V0.87 — première vague de répétition documentée

Position :

```text
Acte I — S4 Private attention repeats
```

Question :

```text
Quelle attention répétée change de sens en premier ?
```

Structure :

```text
W9  Marie réclame une heure partagée
W10 opportunité de répétition week-end
W11 retour obligatoire vers Marie
W12 opportunité de répétition premier jour ouvré
W13 fermeture de vague / équilibre du couple
```

Budget :

```text
1 foreground Marie fixe
+ 2 foregrounds externes maximum
+ 0–2 échos par fenêtre
+ 1 seul propriétaire d'accès chargé maximum
```

Sélection déterministe :

```text
sécurité / aftermath
-> tronc fixe
-> obligation due
-> continuation compatible
-> contexte physique et temporel
-> scène éligible non vue
-> scène la plus différée
-> personnage le moins récemment foreground
-> ordre authored
```

Aucun personnage n’apparaît parce qu’un simple timestamp est atteint.

---

## 7. Fenêtres V0.87 autorisées

### Marie — `marie_saturday_shared_hour_01`

Samedi matin, Marie est déjà sortie pour une vraie course et propose une heure de café/marché.

Player peut :

- la rejoindre maintenant ;
- proposer un vrai horaire alternatif ;
- la laisser profiter seule.

Conséquence :

- preuve de reconnexion si l’acte est payé ;
- preuve de dérive si le `plus tard` reste vide ;
- Marie agit dans tous les cas.

### Mathilde — `mathilde_morning_kitchen_afterglow_01`

Un regard ordinaire dans la cuisine est rouvert après séparation physique.

Plafond possible :

```text
R2 Charged Access
```

Cela signifie seulement :

- Mathilde a remarqué le regard ;
- Player l’assume sans revendiquer sa tenue ;
- Mathilde ne rejette pas l’échange ;
- intention délibérée encore fausse ;
- aucune permission d’image ou sexuelle.

### Sandra — `sandra_ticket_ghost_hot_chocolate_01`

Sandra choisit Player pour un court après-poste autour d’un ticket récurrent et d’un chocolat chaud.

Plafond possible :

```text
R2 Charged Access
```

Seulement si :

- la continuité est encore active ;
- la précision antérieure était réelle ;
- les limites ont été respectées ;
- aucune autre route n’a déjà pris le ticket chargé.

Aucune nouvelle photo.

### Raphaëlle — `raphaelle_lunch_walk_outside_work_01`

Après résolution d’un vrai dossier, Raphaëlle propose dix minutes de marche.

Plafond possible :

```text
R2 Charged Access
```

Seulement comme première couche `outside-work person`.

Toujours verrouillés :

- compte créatif privé ;
- costume ;
- fitting ;
- image personnelle ;
- attraction nommée ;
- cadre adulte.

### Pauline — `pauline_bastien_sunday_table_01`

Pauline et Bastien organisent un repas ordinaire.

Objectif :

- deuxième cycle social légitime ;
- Bastien humain et visible ;
- Marie autonome ;
- Pauline toujours R1.

Aucun crop privé, test secret ou double adresse.

### Nico — `nico_pre_shift_lunch_friendship_01`

Nico propose un déjeuner avant son service.

Objectif :

- deuxième cycle d’amitié ;
- Nico calme et ordinaire ;
- vraie relation avant regard partagé ;
- Nico toujours R1.

Aucune demande de photo, aucun alibi, aucun commentaire-catalogue.

### Marie — `marie_concrete_return_due_01`

Après chaque foreground externe :

- acte concret immédiat ;
- acte futur borné ;
- ou reconnaissance honnête qu’aucune réparation n’est faite.

Cette conséquence passe avant toute nouvelle opportunité externe.

---

## 8. Plafond de route documenté

```text
charged_access_owner = none | mathilde | sandra | raphaelle
maximum one owner
```

| Personnage | État runtime actuel | Maximum V0.87 après future intégration |
|---|---|---|
| Marie | `HABITUAL_WARMTH` | même mode + preuves reconnexion/dérive |
| Sandra | R1/soft | R2 max |
| Mathilde | R1 | R2 max |
| Raphaëlle | R1 | R2 max |
| Pauline | R1 | R1 |
| Nico | R1 | R1 |

Toujours absents :

```text
hard secrets
adult frames
adult images
routes R3+
relationship-frame change
```

Le plafond documenté ne modifie pas la sauvegarde actuelle tant qu’il n’est pas intégré.

---

## 9. Cooldowns et mutations V0.87

- Marie : l’heure du samedi ne reste pas ouverte ; elle profite seule si besoin.
- Mathilde : le moment de cuisine ne se répète pas à l’identique ; deux fenêtres de cooldown.
- Sandra : l’intervalle tardif expire la même nuit ; un miss produit un écho plus froid ou un nouveau prétexte ultérieur.
- Raphaëlle : une seule déférence de marche ; ensuite nouvelle raison obligatoire.
- Pauline : le repas a lieu sans Player ; aucun privé automatique après absence.
- Nico : il mange et part travailler ; une dette de déjeuner doit avoir une date.
- Marie retour : reste priorité jusqu’à paiement ou échec explicitement mémorisé.

Aucune scène ne reste `OFFERED` indéfiniment.

---

## 10. État de sortie V0.87 documenté

Après une future intégration complète de cette vague :

```text
first_repetition_wave_complete = true

couple mode = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE
active-reconnection evidence = possible
parallel-drift evidence = possible

external foregrounds seen = 0–2
charged_access_owner = none | mathilde | sandra | raphaelle

Pauline = R1
Nico = R1
Mathilde = R1 or R2
Sandra = R1 or R2
Raphaëlle = R1 or R2

hard secrets = none
adult frames = none
adult images = none
routes R3+ = none
```

Un retour Marie doit être résolu après le dernier foreground externe.

---

## 11. Statut des fichiers

### Runtime actif V0.86

```text
game/data/conversations/chapter_01_modular_index.json
game/data/conversations/chapter_02_modular_index.json
game/data/conversations/chapter_03_modular_index.json
game/data/conversations/chapter_04_modular_index.json
```

### Documentation V0.87

```text
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SCENE_CARDS.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_TEMPORAL_DELIVERY_MAP.md
docs/V0_87_Next_Act_I_Windows_Source_Pack_Report.md
```

Aucun fichier `game/**` ne doit changer dans V0.87.

---

## 12. Prochaine version

```text
V0.88 — First Repetition Runtime Integration Plan
```

V0.88 devra choisir une petite tranche :

```text
W9 Marie
+ un candidat externe
+ retour Marie obligatoire
```

Puis seulement planifier l’intégration runtime.

---

## 13. Résumé opérationnel

```text
Runtime : mardi–vendredi, V0.86.
Ouverture : implémentée et terminée.
V0.87 : première répétition documentée, non jouable.
Foregrounds externes futurs : 2 maximum.
Accès chargé futur : 1 personnage maximum.
Pauline/Nico : R1 conservé.
Secrets/adulte/images nouvelles : absents.
Prochaine étape : plan d'intégration V0.88, documentation d'abord.
```
