# Réseau Intime — NAR-PROD-04 — Paquet de production Acte III / J09–J12

## 1. Statut, périmètre et autorités

### 1.1 Statut

**Statut du paquet : `READY`**

**VALIDATION PRODUIT : PASS**

**Baseline documentaire de référence : `51ba41678a888f1d3c59ceda0e80e9b227046989`**

Le présent document constitue le paquet de production narratif et visuel complet de l’Acte III, J09 à J12.

Il fixe :

- les quatorze beats visuels servis par partie ;
- les vingt-et-un nouveaux contenus principaux du registre ;
- les huit contenus antérieurs réutilisables ;
- les trente nouveaux fichiers sources exactement justifiés ;
- les deux variantes conditionnelles maximales ;
- les conditions de service, d’audience, de permanence et de recontextualisation ;
- les fallbacks qui permettent de ne jamais inventer une image, une présence ou une connaissance.

Il ne modifie :

- aucun dialogue signé ;
- aucun fichier Git ;
- aucun runtime ;
- aucun JSON ;
- aucun test ;
- aucune UI ;
- aucun asset existant ;
- aucune règle de Galerie ;
- aucune architecture d’état.

Il ne contient aucun prompt ComfyUI définitif.

### 1.2 Autorités

L’ordre d’autorité appliqué est :

1. scripts narratifs signés J09, J10, J11 et J12 ;
2. `NAR_PROD_07_ADULT_PAYOFF_AUDIT_SPECIFICATION.md` et `NAR_ADULT_01_PAYOFFS_J11_MARIE_MATHILDE.md` pour les payoffs adultes J11 ;
3. `J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md` ;
4. registres canoniques des traces, promesses, connaissances et atteignabilités ;
5. `12B_PLANS_SCENES_J09_J12.md` ;
6. Bible Narrative et canons complets des personnages ;
7. NAR-PROD-02 et NAR-PROD-03 pour la méthode de production ;
8. anciens plans et ancien runtime, en `REFERENCE_ONLY`.

Décision d’autorité verrouillée :

- J09 possède Marie comme pivot unique ;
- l’ancien prototype Sandra-only J09 est non autoritatif ;
- Sandra ne peut devenir foreground qu’en J10 si ses conditions signées sont réunies ;
- aucune fonction de l’ancien runtime ne peut superséder les scripts signés J09–J12.

### 1.3 Statuts de source

| Statut | Usage dans ce paquet |
|---|---|
| `SIGNED_SOURCE` | fonction, condition, trace ou scène matérialisée dans un script signé ou un registre canonique signé |
| `CONSOLIDATED_CANON` | décision de production déduite sans ambiguïté de plusieurs sources canoniques convergentes |
| `REFERENCE_ONLY` | matériau historique, ancien plan ou possibilité non autoritative |
| `NO_NEW_ASSET` | fonction servie par texte, état, réutilisation exacte ou absence signifiante sans nouveau fichier |

---

## 2. Décisions héritées de NAR-PROD-02 et NAR-PROD-03

### 2.1 État acquis J01–J08

| Lot | Beats ou contenus | Fichiers sources | Variantes |
|---|---:|---:|---:|
| NAR-PROD-02 — Acte I | 13 contenus principaux | 15 | 0 |
| NAR-PROD-03 — Acte II | 12 beats servis, 11 nouveaux contenus, 6 réutilisations | 14 nouveaux fichiers | 3 variantes J08 |

J01 à J08 sont `READY`.

### 2.2 Invariants repris sans réouverture

- Player reste visuellement non identifiable.
- Un personnage absent n’est jamais ajouté à une image.
- Une qualité de présence Player ne justifie pas automatiquement une variante.
- Une image n’est mutualisée que si son contenu demeure vrai dans toutes les branches qui l’utilisent.
- Une recontextualisation ne change ni le créateur, ni l’audience, ni la propriété, ni la connaissance réelle.
- Une photo de scène ne devient pas automatiquement une trace.
- Un `FACT_RECORD` ne devient jamais une photo.
- `SOUVENIR_IMAGE_DE_SCÈNE` reste un type interne :
  - non transférable ;
  - non découvrable comme fichier diégétique ;
  - `can_share: false`.
- Aucun onglet visible « Souvenir » n’est créé.
- `gallery_eligibility: conditional`.
- `gallery_slot_behavior: deferred`.
- Une image de scène ne peut être ni la preuve J14, ni l’image finale J21.
- Une photo progresse par intention, contrôle et audience, pas par exposition seule.
- Aucune nudité ni scène sexuelle complète n’est imposée.
- Une scène adulte éventuelle ne remplace ni un consentement, ni un aftercare, ni le paiement d’une obligation.

### 2.3 Règle de comptage

Les cinq mesures restent distinctes :

1. **beat servi** : fonction visuelle effectivement reçue dans une partie ;
2. **contenu principal** : parent logique inscrit au registre de production ;
3. **réutilisation** : parent antérieur servi sans nouveau fichier ;
4. **fichier source** : composition visuelle réellement à produire ;
5. **variante** : fichier supplémentaire nécessaire parce que le même parent possède deux états visuellement incompatibles.

Un enfant de `PHOTO_SET` est un fichier, pas un contenu principal ni une variante.

---

## 3. Contrat narratif et visuel de l’Acte III

### 3.1 Fonction d’acte

L’Acte III réalise quatre mouvements :

1. J09 rend visible la vie autonome, professionnelle et sociale de Marie ;
2. J10 sélectionne invisiblement une seule continuité extérieure, ou aucune ;
3. J11 approfondit exclusivement cette ligne ou Marie, avec limite, retrait ou conséquence ;
4. J12 fait converger les positions sociales sans révéler toutes les routes ni les conclure.

### 3.2 Contrat de service

```text
J09 = 4 beats
J10 = 3 beats
J11 = 3 beats
J12 = 4 beats
TOTAL = 14 beats servis par partie
```

Le catalogue conditionnel n’est jamais affiché au joueur.

Le joueur ne voit :

- aucun nom de pivot ;
- aucune liste de routes ;
- aucun score ;
- aucun identifiant interne ;
- aucune option non sélectionnée ;
- aucune punition artificielle infligée à une relation hors foreground.

### 3.3 Contrat de représentation

- Marie reste la grille morale et relationnelle de l’acte.
- La robe noire appartient à Marie et ne crée aucune permission sexuelle.
- Les images privées restent contrôlées par leur créatrice.
- Les images publiques n’expliquent jamais à elles seules une qualité de présence ou une route privée.
- Les scènes hors téléphone ne reçoivent aucun dialogue oral inventé.
- Player peut être hors cadre, vu de dos sans trait identifiable, réduit à une main non distinctive si indispensable, ou entièrement absent.
- La solution par défaut reste l’absence de Player dans l’image.

### 3.4 Contrat de non-surproduction

Le plafond de trente fichiers n’est pas un quota.

Le manifeste atteint trente uniquement parce que :

- les vingt-et-un contenus parents exigent chacun un fichier de base ;
- les deux variantes J11 exigent deux fichiers supplémentaires ;
- le `PHOTO_SET` La Verrière J12 exige quatre fichiers enfants, soit trois fichiers au-delà de son parent logique ;
- les payoffs adultes J11 exigent quatre enfants conditionnels.

```text
21 fichiers parents de base
+ 2 variantes
+ 3 enfants supplémentaires du PHOTO_SET C12-02
+ 4 enfants adultes J11
= 30 fichiers
```

Aucun autre fichier n’est produit.

---

## 4. Tableau exécutif J09–J12

| Jour | Fonction | Beats servis par partie | Nouveaux contenus parents | Pool de réutilisations | Nouveaux fichiers | Variantes |
|---|---|---:|---:|---|---:|---:|
| J09 | Marie visible dans son monde | 4 | 4 | aucune réutilisation obligatoire Actes I–II | 4 | 0 |
| J10 | une continuité extérieure ou aucune | 3 | 7 mutuellement conditionnels | pool dédupliqué des 8 réutilisations | 7 | 0 |
| J11 | continuation exclusive ou Marie | 3 | 6 mutuellement conditionnels | contenus J10 atteints + pool historique autorisé | 12 | 2 |
| J12 | convergence sociale conditionnelle | 4 | 4 | T04 et états déjà atteints si un visuel J12 n’est pas créé | 7 | 0 |
| **Total** |  | **14** | **21** | **8 parents antérieurs distincts** | **30** | **2** |

Les réutilisations sont un pool dédupliqué sur l’ensemble de l’acte. Leur mention dans plusieurs journées ne les compte jamais plusieurs fois.

---

## 5. Continuité d’entrée depuis J01–J08

### 5.1 État relationnel minimal

À l’entrée de J09 :

- Marie et Player possèdent encore une vie commune réelle ;
- Marie a annoncé La Verrière et distingue besoin logistique et envie personnelle ;
- Sandra peut être `DISTANT_FRIEND` ou `RECONNECTION_OPEN`, sans droit automatique au café ;
- Mathilde reste une invitée familiale, avec regard éventuellement reconnu mais aucune intention automatique ;
- Raphaëlle reste une collègue réelle, avec accès créatif préparatoire au maximum ;
- Nico peut posséder une confidence active et une promesse exacte, jamais une permission sur Marie ou Mathilde ;
- Pauline et Bastien forment un couple public réel ;
- aucune route extérieure n’est sélectionnée à l’entrée de J09.

### 5.2 Obligations d’entrée

Les états J08 doivent rester lisibles :

- `raphaelle_j07_mobile_review` : payé, amendé, refusé ou repris ;
- `nico_j07_tuesday_1845` : payé, refusé, amendé ou fermé ;
- `nico_j07_thursday_conditional` : confirmé avant échéance ou expiré ;
- `marie_j07_household_request` : payé, amendé, refusé ou absorbé par l’autonomie du foyer.

Une obligation active domine toute opportunité plus séduisante.

### 5.3 Pool historique autorisé

Les huit parents réutilisables sont :

1. `S1_A1_J01_DPH_SANDRA_LUNCH_SELECTED_01` ;
2. `S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01` ;
3. `S1_A2_J06_SCN_MATHILDE_LOOK_ACKNOWLEDGED_01` ;
4. `S1_A2_J07_SCN_RAPHAELLE_MOBILE_REVIEW_DUE_01` ;
5. `S1_A2_J07_SCN_NICO_AFTER_SERVICE_CONFIDENCE_01` ;
6. `S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01` ;
7. `S1_A2_J08_SCN_NICO_CHAIR_STATE_01` ;
8. `S1_A2_J08_SCN_HOUSEHOLD_STATE_01`.

T02 et T03 restent des `FACT_RECORD`. Ils ne sont pas des réutilisations visuelles.

---

## 6. Paquet complet J09

### 6.1 Fonction canonique

J09 est **« Mercredi — Dans son élément »**.

Marie est le pivot unique. La journée montre :

- sa préparation professionnelle ;
- son choix de représentation privée ;
- sa visibilité sociale ;
- la différence entre présence, regard et action ;
- son autonomie lorsque Player ne vient pas ;
- le retour du couple après une séparation réelle.

Aucune continuité extérieure n’est sélectionnée.

### 6.2 Budget J09

| Mesure | Valeur |
|---|---:|
| Beats servis | 4 |
| Nouveaux contenus | 4 |
| Réutilisations Actes I–II | 0 obligatoire |
| Nouveaux fichiers | 4 |
| Variantes | 0 |

### 6.3 Les quatre beats

| Beat | Fonction | Contenu principal | Toujours servi ? | Mutation sans faux visuel |
|---|---|---|---|---|
| J09-B1 | préparation ou installation La Verrière | C09-01 | oui | Player absent du cadre quelle que soit sa venue future |
| J09-B2 | robe noire choisie par Marie | C09-02 | oui | aucune déclinaison sexuelle |
| J09-B3 | Marie visible professionnellement | C09-03 | oui | même source publique ; accès contextualisé selon présence ou absence |
| J09-B4 | retour du couple après séparation | C09-04 si créée et relayée | oui comme fonction | si T09 est `NOT_CREATED`, recontextualisation exacte de C09-03 avec retour textuel, `NO_NEW_ASSET` |

### 6.4 Contenus J09

#### C09-01 — Installation La Verrière

| Champ | Valeur |
|---|---|
| `asset_id` | `S1_A3_J09_SCN_LAVERRIERE_INSTALLATION_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Statut | `CONSOLIDATED_CANON` |
| Sujet | Marie et environnement professionnel ; Élodie possible |
| Fonction | matérialiser la préparation ou l’installation sans prétendre que Player est présent |
| Audience | joueur uniquement |
| Sauvegarde / transfert | non / non ; `can_share: false` |
| Galerie | `conditional` ; comportement de slot `deferred` |
| J14 / J21 | non / non |
| Interdits | Player identifiable ; regard jaloux ; robe noire sexualisée ; image utilisée comme trace |

#### C09-02 — Robe noire privée

| Champ | Valeur |
|---|---|
| `asset_id` | `S1_A3_J09_DPH_MARIE_BLACK_DRESS_PRIVATE_01` |
| Type | `PHOTO_DIÉGÉTIQUE` |
| `trace_id` | `j09_marie_black_dress_private_01` — T07 |
| Statut | `SIGNED_SOURCE` |
| Créatrice / propriétaire | Marie / Marie |
| Audience initiale | Marie, Player |
| Sauvegarde | `IN_THREAD_ONLY` |
| Transfert | `FORBIDDEN` |
| Permanence | `PRIVATE_ACTIVE`, `REMOVED` ou `INACCESSIBLE` |
| Galerie | conditionnelle à l’accessibilité |
| J14 / J21 | oui selon l’état de la trace |
| Interdits | nudité ; promesse de version plus privée ; permission sexuelle ; transfert |

#### C09-03 — Marie publique à La Verrière

| Champ | Valeur |
|---|---|
| `asset_id` | `S1_A3_J09_DPH_MARIE_LAVERRIERE_PUBLIC_01` |
| Type | `PHOTO_DIÉGÉTIQUE PUBLIQUE` |
| `trace_id` | `j09_marie_laverriere_public_01` — T08 |
| Statut | `SIGNED_SOURCE` |
| Créatrice / propriétaire | Élodie / Élodie ou La Verrière |
| Audience initiale | groupe photographié ou canal La Verrière nommé |
| Sauvegarde / transfert | `PUBLIC_SOURCE_RULES` |
| Permanence | `PUBLIC_ACTIVE` |
| Fonction | Marie visible dans son monde, sans information sur la qualité de présence de Player |
| J14 / J21 | J14 seulement en juxtaposition autorisée ; J21 oui |
| Interdits | Player visible ; preuve de présence ; publication provocatrice destinée à Player |

#### C09-04 — Fin de soirée relayée

| Champ | Valeur |
|---|---|
| `asset_id` | `S1_A3_J09_DPH_MARIE_LAVERRIERE_AFTER_01` |
| Type | `PHOTO_DIÉGÉTIQUE` |
| `trace_id` | `j09_marie_laverriere_after_01` — T09 |
| Statut | `SIGNED_SOURCE` |
| Créatrice | Élodie |
| Audience initiale | Marie et groupe autorisé |
| Audience Player | ajoutée seulement si Marie relaie |
| Sauvegarde | `IN_THREAD_ONLY` après relais |
| Transfert | interdit hors audience |
| Permanence | `PRIVATE_ACTIVE`, `PUBLIC_ACTIVE` ou `NOT_CREATED` |
| Fonction | mémoire partagée, autonomie ou conséquence après séparation |
| J14 / J21 | oui si la trace existe |

### 6.5 Contenus mutuellement exclusifs

Les qualités suivantes sont des états narratifs, pas des assets :

- `presence_active` ;
- `presence_playful_useful` ;
- `presence_late_active` ;
- `presence_bounded_reliable` ;
- `absence_honest` ;
- `presence_distracted` ;
- `presence_spectator`.

Elles ne produisent aucune variante.

### 6.6 Sortie J09 vers J10

J09 transmet :

- la qualité de présence réelle ;
- `marie_j09_dinner_j10_2030` : `ACTIVE`, `REFUSED` ou amendée ;
- `marie_j09_dinner_friday_2030` : `ACTIVE` si vendredi a été accepté ;
- aucune route extérieure avantagée.

J10 doit traiter l’obligation Marie avant toute sélection extérieure.

---

## 7. Paquet complet J10

### 7.1 Fonction canonique

J10 rend une seule ligne extérieure réellement foreground :

- Sandra ;
- Mathilde ;
- Raphaëlle ;
- Nico ;
- ou aucune.

La sélection reste invisible. En cas d’égalité artificielle, de dette Marie ou de fermeture des accès, le fallback sans continuité extérieure est préféré.

### 7.2 Budget J10

| Mesure | Valeur |
|---|---:|
| Beats servis par partie | 3 |
| Nouveaux contenus au registre | 7 |
| Nouveaux fichiers | 7 |
| Variantes | 0 |
| Contenus servis simultanément | uniquement ceux du pivot réel, complétés par réutilisation |

### 7.3 Composition des trois beats selon le pivot

| Pivot J10 | Beat 1 | Beat 2 | Beat 3 |
|---|---|---|---|
| Sandra | C10-01 café tenu | réutilisation T01 | conséquence Marie par J09/J08 |
| Mathilde | C10-02 tenue choisie | C10-03 résultat social | conséquence Marie par J09/J08 |
| Raphaëlle R-A | C10-04 détail de processus | C10-05 seconde série de comparaison | conséquence Marie par J09/J08 |
| Raphaëlle R-B | état de processus, `NO_NEW_ASSET` | réutilisation exacte autorisée | conséquence Marie par J09/J08 ; le résultat futur relève de C11-04 seulement s’il est réellement envoyé |
| Raphaëlle R-C | frontière, `NO_NEW_ASSET` | aucune image privée ou publique supplémentaire | conséquence Marie par J09/J08 |
| Nico | C10-06 Marie publique | C10-07 Mathilde publique | conséquence Marie ou foyer |
| Aucune | conséquence Marie | état foyer | respiration publique T04 ou état antérieur exact |

Le fallback n’invente aucun nouveau contenu et ne transforme aucune relation en compensation.

### 7.4 Registre J10

| Code | `asset_id` | Type | Statut | Fonction | Condition |
|---|---|---|---|---|---|
| C10-01 | `S1_A3_J10_SCN_SANDRA_CAFE_HELD_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | `SIGNED_SOURCE` | rencontre enfin réelle | Sandra éligible, café accepté et tenu |
| C10-02 | `S1_A3_J10_DPH_MATHILDE_OUTFIT_CHOICE_01` | `PHOTO_DIÉGÉTIQUE` | `SIGNED_SOURCE` | intention vestimentaire testée | Mathilde pivot |
| C10-03 | `S1_A3_J10_SCN_MATHILDE_SOCIAL_RESULT_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | `SIGNED_SOURCE` | choix maintenu hors du regard Player | Mathilde pivot ; aucun relais privé inventé |
| C10-04 | `S1_A3_J10_DPH_RAPHAELLE_PROCESS_DETAIL_01` | `PHOTO_DIÉGÉTIQUE` | `SIGNED_SOURCE` | accès au problème exact | Raphaëlle pivot, branche R-A |
| C10-05 | `S1_A3_J10_DPH_RAPHAELLE_PROCESS_COMPARISON_02` | `PHOTO_DIÉGÉTIQUE` | `SIGNED_SOURCE` | seconde série de comparaison du processus | branche R-A uniquement |
| C10-06 | `S1_A3_J10_DPH_ANNEXE_MARIE_PUBLIC_01` | `PHOTO_DIÉGÉTIQUE PUBLIQUE` | `SIGNED_SOURCE` | Marie dans une interaction sociale ordinaire | Nico pivot |
| C10-07 | `S1_A3_J10_DPH_ANNEXE_MATHILDE_PUBLIC_01` | `PHOTO_DIÉGÉTIQUE PUBLIQUE` | `SIGNED_SOURCE` | Mathilde sociale distincte du foyer | Nico pivot |

### 7.5 Règles par contenu

- C10-01 ne crée aucune caméra diégétique ; il reste interne, non partageable et non découvrable.
- C10-02 correspond à T10 `j10_mathilde_outfit_choice_01` :
  - créatrice et propriétaire : Mathilde ;
  - audience : Mathilde et Player ;
  - sauvegarde : `IN_THREAD_ONLY` ;
  - transfert : `FORBIDDEN` ;
  - J14 : oui ;
  - J21 : oui seulement si encore accessible et pertinente.
- C10-03 n’est pas un nouvel envoi privé. Si Inès produit une photographie sociale, elle n’est pas automatiquement transmise à Player. Le paquet retient une image de scène afin de ne pas créer une trace absente du registre.
- C10-04 reste le premier support diégétique local du processus en branche R-A.
- C10-05 est strictement la seconde série de comparaison du processus en branche R-A :
  - créatrice : Raphaëlle ;
  - propriétaire : Raphaëlle ;
  - audience initiale : Raphaëlle et Player ;
  - sauvegarde : `IN_THREAD_ONLY` ;
  - transfert : `FORBIDDEN` ;
  - J14 : non ;
  - J21 : non.
- En R-B, J10 est classé `NO_NEW_ASSET`. Un résultat futur relève uniquement de C11-04 et uniquement s’il est réellement envoyé.
- En R-C, J10 est classé `NO_NEW_ASSET`. Aucune image privée ou publique supplémentaire n’est créée.
- C10-06 et C10-07 sont deux images publiques distinctes :
  - créatrice : Sophie ;
  - propriétaire : Sophie ou canal officiel L’Annexe ;
  - audience : publication ou groupe autorisé nommé ;
  - aucune des deux images ne peut servir d’accès à une version privée ;
  - Nico ne reçoit aucune image privée et ne devient propriétaire d’aucune représentation.

### 7.6 Contenus mutuellement exclusifs et toujours servis

Mutuellement exclusifs :

- C10-01 ;
- C10-02 et C10-03 ;
- C10-04 et C10-05, ensemble uniquement en R-A ;
- Raphaëlle R-B ou R-C : `NO_NEW_ASSET` ;
- C10-06 et C10-07 ;
- fallback `NO_NEW_ASSET`.

Toujours servis comme fonctions :

1. un pivot ou fallback crédible ;
2. une conséquence Marie réelle ;
3. un écho de vie qui ne progresse pas une deuxième route.

### 7.7 Articulation Marie

Avant le pivot :

- le dîner jeudi est maintenu, précisément amendé ou annulé ;
- le dîner vendredi reste une obligation active si accepté ;
- un retard ou une absence concernant Marie reste connu de Marie ;
- aucun pivot extérieur ne transforme la conséquence couple en simple réaction secondaire.

---

## 8. Paquet complet J11

### 8.1 Fonction canonique

J11 continue exclusivement :

- le pivot J10 réellement actif ;
- sa conséquence de limite ou retrait ;
- ou Marie si aucune ligne extérieure ne domine.

Une seule version existe dans une partie.

### 8.2 Budget J11

| Mesure | Valeur |
|---|---:|
| Beats servis par partie | 3 |
| Nouveaux contenus parents | 6 |
| Nouveaux fichiers | 12 |
| Variantes | 2 |
| Variante principale simultanée | 1 maximum |

### 8.3 Composition des trois beats

| Continuation | Beat 1 | Beat 2 | Beat 3 |
|---|---|---|---|
| Sandra | C11-01 image choisie | C11-02 conséquence de contrôle | Marie ordinaire réutilisée |
| Mathilde | rappel C10-02 | C11-03 état de proximité ou distance | foyer J08 réutilisé |
| Raphaëlle | en R-A, rappel C10-04/C10-05 ; en R-B/R-C, aucun rappel J10 nouveau | C11-04 uniquement si un résultat futur est réellement envoyé ; sinon `NO_NEW_ASSET` | conséquence Marie réutilisée |
| Nico | rappel C10-06 | rappel C10-07 | C11-05 préparation J12 |
| Marie | C11-06 état du couple | C09-04 ou C09-03 recontextualisée | foyer J08 ou matin ordinaire sans nouveau fichier |

### 8.4 Registre J11

| Code | `asset_id` | Type | Statut | Fonction | Condition |
|---|---|---|---|---|---|
| C11-01 | `S1_A3_J11_DPH_SANDRA_CHOSEN_IMAGE_01` | `PHOTO_DIÉGÉTIQUE` | `SIGNED_SOURCE` | image réellement choisie par Sandra | Sandra J11 éligible |
| C11-02 | `S1_A3_J11_SCN_SANDRA_IMAGE_CONSEQUENCE_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | `SIGNED_SOURCE` | maintien, retrait ou inaccessibilité sans restaurer le fichier | Sandra J11 |
| C11-03 | `S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | `SIGNED_SOURCE` | proximité conditionnelle ou distance restaurée | Mathilde J11 |
| C11-04 | `S1_A3_J11_DPH_RAPHAELLE_CHOSEN_RESULT_01` | `PHOTO_DIÉGÉTIQUE` | `SIGNED_SOURCE` | résultat choisi pour Player | Raphaëlle J11, seulement si le résultat est réellement envoyé |
| C11-05 | `S1_A3_J11_SCN_NICO_PREPARE_J12_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | `SIGNED_SOURCE` | convergence à venir sans image privée | Nico J11 |
| C11-06 | `S1_A3_J11_SCN_MARIE_COUPLE_STATE_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | `SIGNED_SOURCE` | reconquête/proximité ou limite/distance | Marie J11 |

### 8.5 Traces et limites

#### C11-01 — Sandra

- `trace_id`: `j11_sandra_chosen_image_01` — T11 ;
- créatrice et propriétaire : Sandra ;
- audience : Sandra et Player ;
- sauvegarde : voir-seulement ou `IN_THREAD_ONLY` pour cette image précise ;
- transfert : interdit ;
- états : `PRIVATE_ACTIVE`, `REMOVED`, `INACCESSIBLE` ;
- aucune règle générale de conservation n’est créée.

#### C11-03 — Mathilde

- aucune image sexuelle diégétique ;
- le passage physique éventuel reste hors téléphone ;
- le retrait ou la distance utilise le fichier incompatible dédié ;
- `S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01_DISTANCE` reste la seule variante ;
- `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_CENTRAL_01` et `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_AFTERCARE_01` sont des enfants conditionnels ;
- M-B3 sert une séquence de trois images de scène dans une seule tuile Galerie `Moment vécu` ;
- T13 `j11_mathilde_physical_aftercare_01` reste une trace textuelle, jamais une photo.

#### C11-04 — Raphaëlle

- `trace_id`: `j11_raphaelle_chosen_result_01` — T12 ;
- créatrice : Maud ;
- sélection : Raphaëlle ;
- audience initiale : Raphaëlle et Maud ;
- Player n’est ajouté que si Raphaëlle envoie ;
- transfert interdit ;
- Maud ne devient pas omnisciente sur les messages privés.
- C11-04 est le seul contenu couvrant le résultat futur de R-B ; il n’existe pas si aucun envoi réel n’a lieu.
- C11-04 ne redéfinit pas rétroactivement C10-05, qui reste une seconde comparaison créée et possédée par Raphaëlle en R-A.

#### C11-06 — Marie

- aucune sexualité conjugale ne sert de pansement ;
- le refus ne produit aucune punition visuelle ;
- une scène physique éligible remplace le pivot, elle ne s’ajoute pas en bonus ;
- `S1_A3_J11_SCN_MARIE_COUPLE_STATE_01_LIMIT` reste la seule variante ;
- `S1_A3_J11_SCN_MARIE_RECONQUEST_ADULT_PAYOFF_01` et `S1_A3_J11_SCN_MARIE_RECONQUEST_AFTERCARE_01` sont des enfants conditionnels ;
- l’aftercare Marie est dû avant toute nouvelle progression.

### 8.6 Contenus mutuellement exclusifs et toujours servis

Mutuellement exclusifs :

- couple C11-01/C11-02 ;
- C11-03 ;
- C11-04 ;
- C11-05 ;
- C11-06.

Toujours servis comme fonctions :

1. la continuation ou fermeture exacte de J10 ;
2. sa conséquence, son silence ou son aftercare ;
3. Marie ou la préparation sociale J12.

---

## 9. Paquet complet J12

### 9.1 Fonction canonique

J12 est une convergence conditionnelle :

- Marie reste le pivot de La Verrière ;
- Pauline et Bastien demeurent un couple officiel authentique ;
- Nico demeure l’hôte de L’Annexe ;
- une seule conséquence J11 peut devenir foreground ;
- Mathilde, Sandra et Raphaëlle restent conditionnelles ;
- aucune image ne révèle toutes les routes ;
- aucune image ne conclut la route dominante.

### 9.2 Budget J12

| Mesure | Valeur |
|---|---:|
| Beats servis par partie | 4 |
| Nouveaux contenus parents | 4 |
| Nouveaux fichiers | 7 |
| Variantes | 0 |
| Fichiers enfants de set | 4 pour C12-02 |

### 9.3 Les quatre beats

| Beat | Fonction | Nouveau contenu prioritaire | Fallback exact |
|---|---|---|---|
| J12-B1 | Marie dans son monde professionnel | C12-01 | aucun fallback nécessaire |
| J12-B2 | version collective réelle de La Verrière | C12-02 | aucun personnage conditionnel ajouté au cadre |
| J12-B3 | Pauline/Bastien comme surface authentique | C12-03 | T04 si le nouveau contenu n’est pas accessible à Player |
| J12-B4 | positions sociales à L’Annexe ou absence signifiante | C12-04 si T15 est créée | réutilisation exacte J11/J09, `NO_NEW_ASSET`, si Player rentre ou si le set n’existe pas |

Le nombre de beats reste quatre même lorsqu’une trace finale n’est pas créée : la fonction est payée par une absence lisible ou une réutilisation dont l’audience autorise réellement l’accès.

### 9.4 Registre J12

| Code | `asset_id` | Type | Statut | Fonction | Condition |
|---|---|---|---|---|---|
| C12-01 | `S1_A3_J12_DPH_MARIE_LAVERRIERE_PRO_01` | `PHOTO_DIÉGÉTIQUE PUBLIQUE` | `SIGNED_SOURCE` | Marie dans son rôle professionnel | toujours |
| C12-02 | `S1_A3_J12_DPH_LAVERRIERE_PUBLIC_GROUP_SET_01` | `PHOTO_SET_DIÉGÉTIQUE` | `SIGNED_SOURCE` | version officielle du groupe réellement présent | toujours, casting réel seulement |
| C12-03 | `S1_A3_J12_DPH_PAULINE_BASTIEN_ANNEXE_01` | `PHOTO_DIÉGÉTIQUE SOCIALE` | `SIGNED_SOURCE` | surface officielle authentique Pauline/Bastien | L’Annexe ou accès légitime ultérieur |
| C12-04 | `S1_A3_J12_DPH_ANNEXE_SOCIAL_POSITIONS_SET_01` | `PHOTO_SET_DIÉGÉTIQUE` | `SIGNED_SOURCE` | positions et comportements à L’Annexe | T15 créée et audience autorisée |

### 9.5 Sets et compositions

#### C12-02 — La Verrière

- `trace_id`: `j12_laverriere_public_group_set_01` — T14 ;
- créatrice : Élodie ;
- quatre fichiers enfants ;
- même événement, même casting réel, même audience et même fonction ;
- les quatre enfants ne sont pas quatre beats ni quatre variantes ;
- aucun personnage conditionnel n’est ajouté pour compléter le cadre ;
- une frame où Player serait reconnaissable est rejetée.

Le set n’est pas une « photo universelle » de toutes les routes. Il montre uniquement le noyau réellement présent et peut laisser Mathilde ou Raphaëlle hors cadre même lorsqu’elles sont dans la salle.

#### C12-03 — Pauline et Bastien

- créatrice : Pauline ;
- propriétaire : Pauline ;
- sujets : Pauline et Bastien ;
- audience initiale : groupe photographié nommé ;
- sauvegarde : sélection collective ;
- transfert : selon accord du groupe.

#### C12-04 — L’Annexe

- `trace_id`: `j12_annexe_public_group_set_01` — T15 ;
- créatrice canonique du registre : Sophie ;
- un fichier source principal est obligatoire dans ce lot ;
- le registre conserve une identité de `PHOTO_SET`, mais aucun deuxième membre n’est produit sans fonction signée supplémentaire ;
- le contenu est `NOT_CREATED` si la branche ne produit pas la trace ;
- aucun casting alternatif n’est fabriqué sous forme de variante.

### 9.6 Toujours servi et mutuellement exclusif

Toujours servis comme fonctions :

1. visibilité professionnelle Marie ;
2. groupe réel La Verrière ;
3. couple social Pauline/Bastien ;
4. positions L’Annexe ou absence/retrait réellement signifiant.

Conditionnels :

- C12-03 selon accès de Player et continuité L’Annexe ;
- C12-04 selon création de T15 ;
- modules Sandra, Mathilde et Raphaëlle selon la route J11 ;
- présence Player à L’Annexe selon le choix de continuer.

---

## 10. Matrice des pivots conditionnels J10–J11

| Pivot | Conditions J10 | Production J10 | Condition de continuation J11 | Production J11 | Fermeture / `NO_NEW_ASSET` |
|---|---|---|---|---|---|
| Sandra | T01 accessible, continuité non violée, café encore crédible | C10-01 + T01 | manque partagé ou confiance avec intention ouverte | C11-01 + C11-02 | café fermé, amitié simple, reprogrammation seule, limite ignorée |
| Mathilde | séjour actif, regard J06 reconnu, motif social indépendant, Marie absente pour raison réelle | C10-02 + C10-03 | effet choisi ou désir potentiel avec limite | C11-03 | distance restaurée, ralentissement demandé, fenêtre incompatible |
| Raphaëlle | confiance professionnelle, J08 payé/amendé, projet Maud réel | R-A : C10-04 + C10-05 ; R-B/R-C : `NO_NEW_ASSET` | R-A : continuité du processus ; R-B : résultat futur réellement envoyé ; R-C : frontière maintenue | C11-04 seulement si l’envoi réel a lieu ; sinon `NO_NEW_ASSET` | confiance rompue, processus refusé, rôle/personne confondus ou absence d’envoi |
| Nico | T06 réelle, continuation promise ou confirmée, observation publique réelle | C10-06 + C10-07 | garde-fou ou rivalité bornée | C11-05 | comparaison fermée, continuation refusée, image privée nécessaire |
| Aucune | dette Marie, égalité artificielle, cooldown, refus ou expiration | réutilisations seulement | Marie ou respiration | C11-06 ou `NO_NEW_ASSET` | aucune route de compensation |
| Marie J11 | aucune route extérieure dominante, dîner/reconquête construits ou conséquence couple prioritaire | conséquence J10 | état couple réellement atteint | C11-06 | refus ou limite restent des sorties valides |

Règles communes :

- une seule ligne extérieure reçoit le pivot principal J10–J11 ;
- une route non sélectionnée n’est ni annoncée ni punie ;
- une scène adulte éventuelle remplace le pivot normal ;
- aucune route ne devient dominante par sa seule présence dans une image publique.

---

## 11. Matrice de casting J12

| Personnage | La Verrière | C12-02 | L’Annexe | C12-04 | Règle de production |
|---|---|---|---|---|---|
| Marie | obligatoire, pivot | lisible | présente selon continuité sociale signée | peut être lisible | ne jamais la réduire à une réaction secondaire |
| Player | présent selon L-A/L-B/L-C | hors cadre ou non identifiable | présent seulement si continuation A12/B12 | hors cadre ou non identifiable | aucune identité visuelle |
| Pauline | présente avec Bastien | noyau social possible | présente dans les branches L’Annexe | possible | surface officielle authentique |
| Bastien | présent avec Pauline | noyau social possible | présent dans les branches L’Annexe | possible | ne jamais l’effacer pour favoriser Pauline |
| Élodie | collègue et créatrice | possible | présente si elle continue | possible | témoin de travail, non omnisciente |
| Nico | ne quitte pas artificiellement L’Annexe | absent | hôte | lisible si T15 créée | rôle d’hôte, garde-fou, rival ou ami ordinaire |
| Mathilde | conditionnelle | hors cadre commun par défaut | conditionnelle | seulement si réellement présente | aucune inclusion pour compléter le casting |
| Raphaëlle | conditionnelle pour motif créatif/pro | hors cadre commun par défaut | conditionnelle | seulement si réellement présente | Marie ne connaît pas automatiquement sa ligne privée |
| Sandra | généralement absente ; message ou vue publique | absente du cadre commun | généralement absente | absente | aucune image privée comme prix d’entrée |

### 11.1 Règle de casting commune

Il n’existe aucune image de groupe universelle contenant tous les personnages principaux.

Une composition commune n’est autorisée que si :

- toutes les personnes visibles sont réellement présentes ;
- leur présence reste vraie dans les branches qui utilisent le fichier ;
- un personnage conditionnel peut rester hors cadre sans effacer sa fonction narrative ;
- l’image ne prétend pas que Player a rejoint L’Annexe s’il est rentré.

---

## 12. Registre des 21 nouveaux contenus principaux

| N° | Code | `asset_id` | Jour | Type | Statut |
|---:|---|---|---|---|---|
| 1 | C09-01 | `S1_A3_J09_SCN_LAVERRIERE_INSTALLATION_01` | J09 | `SOUVENIR_IMAGE_DE_SCÈNE` | `CONSOLIDATED_CANON` |
| 2 | C09-02 | `S1_A3_J09_DPH_MARIE_BLACK_DRESS_PRIVATE_01` | J09 | `PHOTO_DIÉGÉTIQUE` | `SIGNED_SOURCE` |
| 3 | C09-03 | `S1_A3_J09_DPH_MARIE_LAVERRIERE_PUBLIC_01` | J09 | `PHOTO_DIÉGÉTIQUE PUBLIQUE` | `SIGNED_SOURCE` |
| 4 | C09-04 | `S1_A3_J09_DPH_MARIE_LAVERRIERE_AFTER_01` | J09 | `PHOTO_DIÉGÉTIQUE` | `SIGNED_SOURCE` |
| 5 | C10-01 | `S1_A3_J10_SCN_SANDRA_CAFE_HELD_01` | J10 | `SOUVENIR_IMAGE_DE_SCÈNE` | `SIGNED_SOURCE` |
| 6 | C10-02 | `S1_A3_J10_DPH_MATHILDE_OUTFIT_CHOICE_01` | J10 | `PHOTO_DIÉGÉTIQUE` | `SIGNED_SOURCE` |
| 7 | C10-03 | `S1_A3_J10_SCN_MATHILDE_SOCIAL_RESULT_01` | J10 | `SOUVENIR_IMAGE_DE_SCÈNE` | `SIGNED_SOURCE` |
| 8 | C10-04 | `S1_A3_J10_DPH_RAPHAELLE_PROCESS_DETAIL_01` | J10 | `PHOTO_DIÉGÉTIQUE` | `SIGNED_SOURCE` |
| 9 | C10-05 | `S1_A3_J10_DPH_RAPHAELLE_PROCESS_COMPARISON_02` | J10 | `PHOTO_DIÉGÉTIQUE` | `SIGNED_SOURCE` |
| 10 | C10-06 | `S1_A3_J10_DPH_ANNEXE_MARIE_PUBLIC_01` | J10 | `PHOTO_DIÉGÉTIQUE PUBLIQUE` | `SIGNED_SOURCE` |
| 11 | C10-07 | `S1_A3_J10_DPH_ANNEXE_MATHILDE_PUBLIC_01` | J10 | `PHOTO_DIÉGÉTIQUE PUBLIQUE` | `SIGNED_SOURCE` |
| 12 | C11-01 | `S1_A3_J11_DPH_SANDRA_CHOSEN_IMAGE_01` | J11 | `PHOTO_DIÉGÉTIQUE` | `SIGNED_SOURCE` |
| 13 | C11-02 | `S1_A3_J11_SCN_SANDRA_IMAGE_CONSEQUENCE_01` | J11 | `SOUVENIR_IMAGE_DE_SCÈNE` | `SIGNED_SOURCE` |
| 14 | C11-03 | `S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01` | J11 | `SOUVENIR_IMAGE_DE_SCÈNE` | `SIGNED_SOURCE` |
| 15 | C11-04 | `S1_A3_J11_DPH_RAPHAELLE_CHOSEN_RESULT_01` | J11 | `PHOTO_DIÉGÉTIQUE` | `SIGNED_SOURCE` |
| 16 | C11-05 | `S1_A3_J11_SCN_NICO_PREPARE_J12_01` | J11 | `SOUVENIR_IMAGE_DE_SCÈNE` | `SIGNED_SOURCE` |
| 17 | C11-06 | `S1_A3_J11_SCN_MARIE_COUPLE_STATE_01` | J11 | `SOUVENIR_IMAGE_DE_SCÈNE` | `SIGNED_SOURCE` |
| 18 | C12-01 | `S1_A3_J12_DPH_MARIE_LAVERRIERE_PRO_01` | J12 | `PHOTO_DIÉGÉTIQUE PUBLIQUE` | `SIGNED_SOURCE` |
| 19 | C12-02 | `S1_A3_J12_DPH_LAVERRIERE_PUBLIC_GROUP_SET_01` | J12 | `PHOTO_SET_DIÉGÉTIQUE` | `SIGNED_SOURCE` |
| 20 | C12-03 | `S1_A3_J12_DPH_PAULINE_BASTIEN_ANNEXE_01` | J12 | `PHOTO_DIÉGÉTIQUE SOCIALE` | `SIGNED_SOURCE` |
| 21 | C12-04 | `S1_A3_J12_DPH_ANNEXE_SOCIAL_POSITIONS_SET_01` | J12 | `PHOTO_SET_DIÉGÉTIQUE` | `SIGNED_SOURCE` |

Contrôle :

```text
J09  4
J10  7
J11  6
J12  4
TOTAL 21
```

---

## 13. Manifeste exact des nouveaux fichiers sources

Les identifiants ci-dessous sont des stems de production. Le format final d’image reste hors périmètre.

### 13.1 J09 — 4 fichiers

| N° | Fichier source | Parent |
|---:|---|---|
| 1 | `S1_A3_J09_SCN_LAVERRIERE_INSTALLATION_01` | C09-01 |
| 2 | `S1_A3_J09_DPH_MARIE_BLACK_DRESS_PRIVATE_01` | C09-02 |
| 3 | `S1_A3_J09_DPH_MARIE_LAVERRIERE_PUBLIC_01` | C09-03 |
| 4 | `S1_A3_J09_DPH_MARIE_LAVERRIERE_AFTER_01` | C09-04 |

### 13.2 J10 — 7 fichiers

| N° | Fichier source | Parent |
|---:|---|---|
| 5 | `S1_A3_J10_SCN_SANDRA_CAFE_HELD_01` | C10-01 |
| 6 | `S1_A3_J10_DPH_MATHILDE_OUTFIT_CHOICE_01` | C10-02 |
| 7 | `S1_A3_J10_SCN_MATHILDE_SOCIAL_RESULT_01` | C10-03 |
| 8 | `S1_A3_J10_DPH_RAPHAELLE_PROCESS_DETAIL_01` | C10-04 |
| 9 | `S1_A3_J10_DPH_RAPHAELLE_PROCESS_COMPARISON_02` | C10-05 |
| 10 | `S1_A3_J10_DPH_ANNEXE_MARIE_PUBLIC_01` | C10-06 |
| 11 | `S1_A3_J10_DPH_ANNEXE_MATHILDE_PUBLIC_01` | C10-07 |

### 13.3 J11 — 12 fichiers

| N° | Fichier source | Parent | Nature |
|---:|---|---|---|
| 12 | `S1_A3_J11_DPH_SANDRA_CHOSEN_IMAGE_01` | C11-01 | base |
| 13 | `S1_A3_J11_SCN_SANDRA_IMAGE_CONSEQUENCE_01` | C11-02 | base |
| 14 | `S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01_PROXIMITY` | C11-03 | base |
| 15 | `S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01_DISTANCE` | C11-03 | variante V11-M |
| 16 | `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_CENTRAL_01` | C11-03 | enfant conditionnel adulte |
| 17 | `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_AFTERCARE_01` | C11-03 | enfant conditionnel adulte |
| 18 | `S1_A3_J11_DPH_RAPHAELLE_CHOSEN_RESULT_01` | C11-04 | base |
| 19 | `S1_A3_J11_SCN_NICO_PREPARE_J12_01` | C11-05 | base |
| 20 | `S1_A3_J11_SCN_MARIE_COUPLE_STATE_01_RECONNECTION` | C11-06 | base |
| 21 | `S1_A3_J11_SCN_MARIE_COUPLE_STATE_01_LIMIT` | C11-06 | variante V11-P |
| 22 | `S1_A3_J11_SCN_MARIE_RECONQUEST_ADULT_PAYOFF_01` | C11-06 | enfant conditionnel adulte |
| 23 | `S1_A3_J11_SCN_MARIE_RECONQUEST_AFTERCARE_01` | C11-06 | enfant conditionnel adulte |

### 13.4 J12 — 7 fichiers

| N° | Fichier source | Parent | Nature |
|---:|---|---|---|
| 24 | `S1_A3_J12_DPH_MARIE_LAVERRIERE_PRO_01` | C12-01 | base |
| 25 | `S1_A3_J12_DPH_LAVERRIERE_PUBLIC_GROUP_SET_01_FRAME_01` | C12-02 | enfant de set |
| 26 | `S1_A3_J12_DPH_LAVERRIERE_PUBLIC_GROUP_SET_01_FRAME_02` | C12-02 | enfant de set |
| 27 | `S1_A3_J12_DPH_LAVERRIERE_PUBLIC_GROUP_SET_01_FRAME_03` | C12-02 | enfant de set |
| 28 | `S1_A3_J12_DPH_LAVERRIERE_PUBLIC_GROUP_SET_01_FRAME_04` | C12-02 | enfant de set |
| 29 | `S1_A3_J12_DPH_PAULINE_BASTIEN_ANNEXE_01` | C12-03 | base |
| 30 | `S1_A3_J12_DPH_ANNEXE_SOCIAL_POSITIONS_SET_01_FRAME_01` | C12-04 | composition principale conditionnelle |

Contrôle :

```text
4 + 7 + 12 + 7 = 30 fichiers sources
```

Les quatre frames C12-02 et la composition C12-04 ne sont pas des variantes.

---

## 14. Manifeste des huit réutilisations

| N° | `asset_id` conservé | Source | Type | Audience et permanence d’origine | Réutilisation Acte III | Risque contrôlé |
|---:|---|---|---|---|---|---|
| R01 | `S1_A1_J01_DPH_SANDRA_LUNCH_SELECTED_01` | J01 / T01 | `PHOTO_DIÉGÉTIQUE` | Sandra, Player ; état réellement accessible | rappel du déjeuner dans la ligne Sandra | Marie ne connaît pas automatiquement l’image |
| R02 | `S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01` | J04 / T04 | `PHOTO_SET_DIÉGÉTIQUE` | groupe social nommé ; `PUBLIC_SOURCE_RULES` | respiration J10 ou surface Pauline/Bastien J12 | même parent et mêmes trois frames ; aucun crop privé |
| R03 | `S1_A2_J06_SCN_MATHILDE_LOOK_ACKNOWLEDGED_01` | J06 | `SOUVENIR_IMAGE_DE_SCÈNE` | joueur uniquement ; conditionnel | antécédent de la ligne Mathilde | ne devient ni intention ni trace |
| R04 | `S1_A2_J07_SCN_RAPHAELLE_MOBILE_REVIEW_DUE_01` | J07 | `SOUVENIR_IMAGE_DE_SCÈNE` | joueur uniquement ; scène vécue | rappel de l’obligation professionnelle | aucune dette sentimentale |
| R05 | `S1_A2_J07_SCN_NICO_AFTER_SERVICE_CONFIDENCE_01` | J07 / T06 textuelle associée | `SOUVENIR_IMAGE_DE_SCÈNE` | joueur uniquement ; scène vécue | antécédent Nico | Nico ne reçoit aucune image privée |
| R06 | `S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01` | J08 | `SOUVENIR_IMAGE_DE_SCÈNE` | joueur uniquement ; état atteint | fichier `PAID` ou `TAKEN_OVER` réellement atteint | ne pas changer la méthode ni la connaissance |
| R07 | `S1_A2_J08_SCN_NICO_CHAIR_STATE_01` | J08 | `SOUVENIR_IMAGE_DE_SCÈNE` | joueur uniquement ; état atteint | fichier `PAID` ou `NO_WAIT` réellement atteint | ne jamais prétendre que Nico a attendu |
| R08 | `S1_A2_J08_SCN_HOUSEHOLD_STATE_01` | J08 | `SOUVENIR_IMAGE_DE_SCÈNE` | joueur uniquement ; état atteint | foyer `PAID` ou `AUTONOMOUS` | ne pas inventer le constat ou la présence Player |

### 14.1 Règles de réutilisation

- L’`asset_id` parent n’est jamais renommé.
- Un enfant de T04 n’est pas recompté comme réutilisation distincte.
- Pour R06, R07 et R08, seul le fichier d’état réellement atteint est servi.
- Une réutilisation conserve son audience et sa permanence.
- Une scène interne ne devient pas un fichier envoyé par un personnage.
- Une réutilisation ne crée aucune connaissance nouvelle, sauf la relecture par Player de ce qu’il connaissait déjà.
- Toute apparition dans une autre audience exige une source canonique distincte ; elle ne peut pas être obtenue par simple recontextualisation.

---

## 15. Matrice PHOTO_DIÉGÉTIQUE / SOUVENIR / FACT_RECORD

| Type | Existe dans le monde | Créateur diégétique | Transférable | Découvrable comme fichier | Galerie | J14 / J21 |
|---|---|---|---|---|---|---|
| `PHOTO_DIÉGÉTIQUE` | oui | personnage ou tiers autorisé | selon règle explicite | oui selon audience | `conditional` | seulement si registre et état l’autorisent |
| `SOUVENIR_IMAGE_DE_SCÈNE` | non comme fichier détenu | aucun créateur diégétique | non | non | `conditional`, sans nouvel onglet | jamais |
| `FACT_RECORD` | fait ou notification, pas une image | source du fait | selon partage factuel, jamais comme photo | non comme image | non comme photo | selon règle du fait, jamais par conversion |

### 15.1 Répartition des 21 parents

| Type | J09 | J10 | J11 | J12 | Total |
|---|---:|---:|---:|---:|---:|
| `PHOTO_DIÉGÉTIQUE` ou `PHOTO_SET` | 3 | 5 | 2 | 4 | 14 |
| `SOUVENIR_IMAGE_DE_SCÈNE` | 1 | 2 | 4 | 0 | 7 |
| `FACT_RECORD` | 0 | 0 | 0 | 0 | 0 |
| **Total** | **4** | **7** | **6** | **4** | **21** |

### 15.2 Cas explicitement exclus

- T02 et T03 restent `FACT_RECORD`.
- T13 reste textuelle même si un passage physique Mathilde a eu lieu.
- T16 peut être une notification ou un `FACT_RECORD`, jamais une nouvelle photo Sandra.
- C09-01, C10-01, C10-03, C11-02, C11-03, C11-05 et C11-06 ne deviennent jamais des traces partageables.

---

## 16. Matrice audience, permanence, sauvegarde, transfert, Galerie, J14 et J21

| Groupe de contenus | Audience | Permanence | Sauvegarde | Transfert | Galerie | J14 | J21 |
|---|---|---|---|---|---|---|---|
| C09-01, C10-01, C10-03, C11-02, C11-03, C11-05, C11-06 | joueur uniquement | scène vécue ou état conditionnel | aucune sauvegarde diégétique | interdit ; `can_share: false` | `conditional` | non | non |
| C09-02 / T07 | Marie, Player | active, retirée ou inaccessible | `IN_THREAD_ONLY` | interdit | si accessible | oui si affichable | oui selon état |
| C09-03 / T08 | audience La Verrière nommée | publique active | règles source publique | règles source publique | conditionnelle | juxtaposition autorisée seulement | oui |
| C09-04 / T09 | Marie et groupe, puis Player si relais | active ou non créée | fil après relais | interdit hors audience | conditionnelle | oui si créée | oui si créée |
| C10-02 / T10 | Mathilde, Player | active, retirée ou inaccessible | `IN_THREAD_ONLY` | interdit | si accessible | oui | oui si pertinente |
| C10-04 | Raphaëlle et audience exacte du premier support R-A | local J10, non promu au registre saisonnier | fil seulement si envoyé | interdit | conditionnelle | non | non |
| C10-05 | Raphaëlle, Player | active locale en R-A ; absente en R-B/R-C | `IN_THREAD_ONLY` | `FORBIDDEN` | conditionnelle | non | non |
| C10-06, C10-07 | publication ou groupe autorisé nommé | publique locale | règles source publique | règles source publique ; aucun accès à une version privée | conditionnelle | non | non |
| C11-01 / T11 | Sandra, Player | active, retirée ou inaccessible | voir-seulement ou fil pour cette image | interdit | si accessible | oui | oui |
| C11-04 / T12 | Raphaëlle, Maud, puis Player si envoi | active, retirée ou inaccessible | `IN_THREAD_ONLY` | interdit | si accessible | oui | oui |
| C12-01 | participants / communication La Verrière | publique locale | règles source publique | publication officielle uniquement | conditionnelle | non seule | non seule |
| C12-02 / T14 | groupe photographié / canal La Verrière | publique active | `PUBLIC_SOURCE_RULES` | `PUBLIC_SOURCE_RULES` | conditionnelle | oui | oui |
| C12-03 | groupe photographié nommé | sociale active si créée | sélection collective | selon accord du groupe | conditionnelle | non seule | non seule |
| C12-04 / T15 | groupe réellement photographié | active ou `NOT_CREATED` | `PUBLIC_SOURCE_RULES` | même audience ou public selon canal | conditionnelle | oui | oui |

Les quatre enfants adultes C11-03/C11-06 sont des `SOUVENIR_IMAGE_DE_SCÈNE`, joueur uniquement, sans sauvegarde ni transfert diégétique. Les séquences M-B3 et Marie adulte utilisent chacune une seule tuile Galerie `Moment vécu` contenant uniquement les images réellement servies.

### 16.1 Création, propriété et sujets ciblés

| Contenu | Créatrice | Propriétaire | Sujets | Audience initiale |
|---|---|---|---|---|
| C10-05 | Raphaëlle | Raphaëlle | processus comparé | Raphaëlle, Player |
| C10-06 | Sophie | Sophie ou canal officiel L’Annexe | Marie | publication ou groupe autorisé nommé |
| C10-07 | Sophie | Sophie ou canal officiel L’Annexe | Mathilde | publication ou groupe autorisé nommé |
| C12-03 | Pauline | Pauline | Pauline, Bastien | groupe photographié nommé |

Règles globales :

- `gallery_slot_behavior: deferred` pour tous les contenus ;
- aucune règle UI nouvelle ;
- public ne signifie jamais libre de crop, de transfert ou de sexualisation ;
- l’éligibilité J14/J21 appartient à la trace, pas à la simple ressemblance visuelle ;
- une absence de trace peut rester un payoff, mais aucun fichier retiré n’est restauré.

---

## 17. Variantes conditionnelles et justification de leur coût

### 17.1 Variante V11-M — Mathilde

| Champ | Valeur |
|---|---|
| Parent | C11-03 |
| Base | `..._PROXIMITY` |
| Variante | `..._DISTANCE` |
| Coût | 1 fichier supplémentaire |
| Justification | la proximité maintenue et la distance restaurée produisent des positions, distances et fonctions incompatibles |
| Non-variantes | `...SECRET_INTIMACY_CENTRAL_01` et `...SECRET_INTIMACY_AFTERCARE_01` sont deux enfants conditionnels adultes, jamais des variantes |

### 17.2 Variante V11-P — Marie

| Champ | Valeur |
|---|---|
| Parent | C11-06 |
| Base | `..._RECONNECTION` |
| Variante | `..._LIMIT` |
| Coût | 1 fichier supplémentaire |
| Justification | reconquête/proximité et limite/distance ne peuvent partager honnêtement la même composition |
| Non-variantes | `...RECONQUEST_ADULT_PAYOFF_01` et `...RECONQUEST_AFTERCARE_01` sont deux enfants conditionnels adultes, jamais des variantes |

### 17.3 Éléments qui ne sont pas des variantes

- les qualités de présence J09 ;
- les sept contenus alternatifs J10 ;
- les pivots J11 ;
- les quatre enfants C12-02 ;
- les quatre enfants adultes J11 ;
- la présence ou l’absence d’un personnage conditionnel hors cadre ;
- la création ou non de T15 ;
- le choix de Player de continuer à L’Annexe ;
- un fichier antérieur revu dans une nouvelle séquence.

Total exact :

```text
2 variantes
```

---

## 18. Contrôle des traces, promesses et connaissances J01–J12

### 18.1 Traces

| Trace | Type | Contrôle NAR-PROD-04 |
|---|---|---|
| T01 — déjeuner Sandra | photo privée | réutilisée seulement si accessible ; aucune connaissance Marie automatique |
| T02–T03 | `FACT_RECORD` | aucune conversion en photo |
| T04 — set Pauline/Bastien/Marie | set public | réutilisation exacte ; trois enfants conservés ; aucun crop privé |
| T06 — confidence Nico | texte | l’image de scène R05 ne remplace pas la trace textuelle |
| T07 — robe noire Marie | photo privée | C09-02 ; aucune permission sexuelle |
| T08 — Marie publique La Verrière | photo publique | C09-03 ; ne prouve pas la présence Player |
| T09 — fin de soirée Marie | photo relayée | C09-04 ; peut être `NOT_CREATED` |
| T10 — tenue Mathilde | photo privée | C10-02 ; aucun droit Nico |
| T11 — image Sandra choisie | photo privée | C11-01 ; voir-seulement, fil ou retrait selon branche |
| T12 — résultat Raphaëlle | photo privée contrôlée | C11-04 ; Maud ne connaît pas les messages privés |
| T13 — aftercare Mathilde | texte | aucune photo créée |
| T14 — set public La Verrière | `PHOTO_SET` public | C12-02 ; casting réel seulement |
| T15 — set public L’Annexe | `PHOTO_SET` public | C12-04 ; active ou non créée |
| T16 — vue publique Sandra | notification / fait | aucune nouvelle image Sandra |

### 18.2 Promesses

| Promesse | Échéance | Contrôle |
|---|---|---|
| P05 `raphaelle_j07_mobile_review` | J08 | état réellement payé/amendé/refusé conservé |
| P06 `nico_j07_tuesday_1845` | J08 | aucune attente inventée après fermeture |
| P07 `nico_j07_thursday_conditional` | J10 midi | Nico J10 seulement si confirmée |
| P08 `marie_j07_household_request` | J08 | autonomie du foyer respectée |
| P09 `marie_j09_dinner_j10_2030` | J10 20 h 30 | payée, amendée ou refusée avant pivot extérieur |
| P10 `marie_j09_dinner_friday_2030` | J11 20 h 30 | priorité couple si active |
| P11 `sandra_cafe_saturday_1100` | préambule J12 | active seulement après double confirmation ; sinon refusée ou expirée |
| P12 `marie_j12_laverriere_presence` | heure L-A/L-B/L-C | la durée réelle produit la conséquence, pas une variante d’image |
| P13 `j12_annexe_continuation` | J12 22 h 50 | aucune attente créée pour L-C ; refus ou retour restent valides |

### 18.3 Connaissances

| Faits | Connaisseurs légitimes | Limite |
|---|---|---|
| F08 — photo déjeuner Sandra | Sandra, Player | Marie ne la connaît pas automatiquement |
| F09 — regard Mathilde reconnu | Mathilde, Player | ne signifie ni désir ni répétition autorisée |
| F10 — confidence Nico | Nico, Player | Nico ne parle pas au nom d’une femme |
| F11 — robe noire Marie | Marie, Player | privé, non transférable |
| F12 — Marie publique La Verrière | audience sociale | ne révèle pas la qualité de présence Player |
| F13 — Mathilde choisit Player comme audience | Mathilde, Player | aucun droit d’envoi à Nico |
| F14 — Sandra choisit une image | Sandra, Player | sous-états voir-seulement, fil, retrait |
| F15 — Raphaëlle choisit Player | Raphaëlle, Maud, Player selon transfert réel | Maud ne connaît pas le contenu des messages |
| F16 — passage physique Mathilde | Mathilde, Player | Marie non omnisciente ; aftercare dû |
| F17 — limite Mathilde | Mathilde, Player | toute suite doit la respecter |
| F18 — participants La Verrière | personnes présentes et audience T14 | identifiants réels seulement |
| F19 — participants L’Annexe | personnes présentes et audience T15 | aucun absent ajouté |
| F20 — comportement observé | témoin exact | geste observé distinct de sa signification |
| F21 — Sandra voit le contexte public | Sandra | aucune déduction automatique d’une autre route privée |

### 18.4 Recontextualisation

Une recontextualisation peut changer :

- la fonction ressentie par Player ;
- le moment où Player revoit un contenu ;
- le contraste avec un état actuel.

Elle ne peut pas changer :

- le créateur ;
- le propriétaire ;
- l’audience initiale ;
- le droit de sauvegarde ;
- le droit de transfert ;
- ce qu’un personnage a réellement vu ou appris.

---

## 19. Couverture des refus, retraits, silences, expirations et aftercare

| Jour | Cas | Mutation canonique | Réponse visuelle | Interdit |
|---|---|---|---|---|
| J09 | absence honnête | Marie vit la soirée sans attendre | C09-03 relayée selon source ; retour après séparation | crise ou compensation extérieure automatique |
| J09 | présence distraite | conséquence couple active | mêmes fichiers, sens modifié par les actes | variante « jalousie » |
| J09 | présence spectatrice | regard reconnu mais action absente | mêmes fichiers | récompense sexuelle |
| J09 | T09 non créée | retour textuel maintenu | C09-03 recontextualisée, `NO_NEW_ASSET` | inventer une dernière photo |
| J10 | aucun pivot éligible | respiration crédible | réutilisations R02/R08 ou conséquence Marie | route arbitraire |
| J10 | café Sandra fermé | Sandra continue sa vie | T01 seulement si encore accessible | S19 immédiat |
| J10 | Mathilde restaure le pratique | ambiguïté non récompensée | C10-03 ou rappel neutre | punition ou sexualisation |
| J10 | Raphaëlle R-A | comparaison du processus | C10-04 puis C10-05 | fusionner comparaison et résultat futur |
| J10 | Raphaëlle R-B | résultat futur non encore envoyé | `NO_NEW_ASSET` | anticiper C11-04 ou créer un résultat J10 |
| J10 | Raphaëlle R-C | frontière professionnelle | `NO_NEW_ASSET` | créer une image privée ou publique supplémentaire |
| J10 | Nico ferme la comparaison | ligne Nico close | images publiques restent publiques | image privée ou rivalité imposée |
| J11 | image Sandra retirée | distance ou absence J12 | C11-02 ; fichier privé non restauré | faux accès Galerie |
| J11 | Mathilde stoppe | distance restaurée | variante V11-M `DISTANCE` | passage adulte ou relance |
| J11 | Raphaëlle envoie réellement le résultat futur R-B | partage contrôlé | C11-04 | rétroattribuer le résultat à C10-05 |
| J11 | Raphaëlle protège la frontière ou n’envoie rien | relation professionnelle claire | `NO_NEW_ASSET` | baiser ou image inventée |
| J11 | Nico ferme | Nico ne commente plus | C11-05 seulement comme préparation sociale | punition d’une route |
| J11 | Marie refuse le sexe-pansement | limite valide | variante V11-P `LIMIT` | présenter le refus comme échec |
| J11 | passage physique Mathilde | aftercare dû | même image de scène non explicite + T13 textuelle | photo sexuelle diégétique |
| J11 | scène physique Marie | aftercare dû | même parent C11-06 | progression extérieure avant paiement |
| J12 | café Sandra non confirmé | P11 `EXPIRED` | absence ou contexte public seulement | relance tardive punitive |
| J12 | Sandra retire l’image | distance réelle | aucun nouveau fichier Sandra | restaurer le fichier via T14/T15 |
| J12 | Player rentre | L’Annexe continue sans lui | beat d’absence par réutilisation autorisée | photo prétendant sa présence |
| J12 | T15 non créée | aucune trace L’Annexe accessible | `NO_NEW_ASSET` et conséquence textuelle | set universel de remplacement |
| J12 | aftercare dû | foreground prioritaire | conséquence exacte de la route J11 | nouvelle séduction concurrente |

Principe :

> un refus ferme ou transforme une attente ; il ne déclenche jamais une route de compensation.

---

## 20. Contradictions résolues, décisions restantes et checklist finale

### 20.1 Contradictions résolues

| Sujet | Résolution |
|---|---|
| ancien J09 Sandra-only | `REFERENCE_ONLY`, supersédé par J09 Marie signé |
| trois visuels J09 dans le script | complétés par une image de scène d’installation ; quatre beats sans quatrième trace |
| qualités de présence J09 | états textuels, zéro variante |
| sept contenus J10 | catalogue conditionnel, jamais sept beats dans une partie |
| C10-05 mutualisé | limité à la seconde série de comparaison R-A, créée et possédée par Raphaëlle ; R-B/R-C restent `NO_NEW_ASSET` en J10 |
| C10-06/C10-07 | créées par Sophie, possédées par Sophie ou le canal officiel L’Annexe, publiques et distinctes, sans accès à une version privée |
| C12-03 | créé et possédé par Pauline ; Pauline et Bastien sont les sujets ; audience, sauvegarde et transfert relèvent du groupe photographié nommé |
| continuation J11 | une seule ligne ou Marie ; aucune permission adulte automatique |
| deux variantes J11 | uniquement Mathilde proximité/distance et Marie reconquête/limite |
| casting J12 variable | aucun all-cast universel ; personnages conditionnels hors cadre commun par défaut |
| quatre beats et sept fichiers J12 | quatre parents ; quatre enfants pour le set La Verrière ; un fichier pour chacun des trois autres parents |
| T15 non créée | beat payé par absence ou réutilisation exacte, jamais par faux groupe |
| quatre enfants adultes J11 | deux enfants Mathilde et deux enfants Marie, aucun nouveau parent ni variante |
| plafond de trente | total exact justifié, aucune production de remplissage |

### 20.2 Décisions restantes à Ludovic

**Aucune décision produit bloquante ne reste ouverte.**

Les choix de cadrage, format, résolution, technique de génération et sélection finale entre plusieurs propositions graphiques appartiennent à la production ultérieure. Ils ne modifient pas le produit défini ici.

### 20.3 Checklist

#### Autorité

- [x] J09 possède Marie comme pivot unique.
- [x] L’ancien runtime Sandra-only est non autoritatif.
- [x] Les scripts signés J09–J12 prévalent.
- [x] Aucun dialogue signé n’est réécrit ou ajouté.

#### Comptages

- [x] J09 sert quatre beats.
- [x] J10 sert trois beats.
- [x] J11 sert trois beats.
- [x] J12 sert quatre beats.
- [x] Le registre contient vingt-et-un nouveaux parents.
- [x] Le pool contient huit réutilisations dédupliquées.
- [x] Le manifeste contient trente fichiers exacts.
- [x] Deux variantes J11 seulement.
- [x] C10-05 couvre uniquement la seconde comparaison R-A.
- [x] Raphaëlle R-B et R-C restent `NO_NEW_ASSET` en J10.
- [x] C10-06 et C10-07 conservent Sophie comme créatrice.
- [x] C12-03 conserve Pauline comme créatrice et propriétaire.

#### Images et casting

- [x] Player reste non identifiable.
- [x] Aucun personnage absent n’est ajouté à un cadre.
- [x] Aucune photo de groupe all-cast universelle.
- [x] Les enfants de `PHOTO_SET` ne sont pas comptés comme variantes.
- [x] La robe noire ne crée aucune permission sexuelle.
- [x] Les payoffs adultes explicites restent conditionnels, consentis et limités aux branches validées.

#### Taxonomie et Galerie

- [x] `PHOTO_DIÉGÉTIQUE`, `SOUVENIR_IMAGE_DE_SCÈNE` et `FACT_RECORD` restent distincts.
- [x] Aucun `FACT_RECORD` ne devient photo.
- [x] Aucun souvenir interne ne devient trace J14 ou image J21.
- [x] `gallery_eligibility: conditional`.
- [x] `gallery_slot_behavior: deferred`.
- [x] Aucun onglet visible « Souvenir ».
- [x] Aucun changement UI ou runtime.

#### Conséquences

- [x] Toute promesse active est payée, amendée, refusée ou expirée.
- [x] Aucun refus ne produit de route de compensation.
- [x] Aucun aftercare n’est contourné.
- [x] Les connaissances restent locales à leurs sources.
- [x] Les fichiers retirés ne sont jamais restaurés.
- [x] J12 prépare la convergence sans conclure la route dominante.

### 20.4 Comptages finaux

| Mesure | Nombre exact |
|---|---:|
| Beats servis par partie | **14** |
| Nouveaux contenus principaux | **21** |
| Réutilisations antérieures distinctes | **8** |
| Nouveaux fichiers sources | **30** |
| Variantes conditionnelles | **2** |
| Plafond autorisé de fichiers | **30** |
| Écart avec le plafond | **0** |

### 20.5 Verdicts

| Journée | Verdict | Motif |
|---|---|---|
| J09 | `READY` | autorité Marie, quatre fonctions couvertes, zéro variante |
| J10 | `READY` | pivot unique invisible, sept contenus conditionnels, branches Raphaëlle R-A/R-B/R-C explicites, trois beats servis |
| J11 | `READY` | continuation exclusive, deux variantes justifiées, aftercare protégé |
| J12 | `READY` | quatre beats, casting conditionnel, aucun groupe all-cast universel |
| **NAR-PROD-04** | **`READY`** | **14 / 21 / 8 / 30 / 2, aucune décision produit restante** |

Comptage Saison 1 consolidé :

```text
Acte I: 15
Acte II: 14
Acte III: 30
Acte IV: 12
Acte V: 13
Total: 84

contenus principaux: 63
variantes: 8
nouveaux fichiers adultes: 8
images de scène adultes nouvelles: 6
photos diégétiques adultes nouvelles: 2
nouveau fichier J21: 0
```

---

## Conclusion de production

NAR-PROD-04 est prêt pour une intégration documentaire ultérieure séparée.

Ce paquet n’autorise pas encore :

- la production définitive des assets ;
- la rédaction de prompts ComfyUI ;
- l’intégration runtime ;
- une modification JSON ;
- une décision UI ou Galerie ;
- une nouvelle signature narrative.

Il autorise uniquement la préparation visuelle à partir des trente fichiers sources manifestés, dans le respect strict des conditions, audiences, castings et fallbacks définis ci-dessus.
