# Réseau Intime — NAR-PROD-06 — Paquet de production Acte V / J17–J21

## 1. Statut, périmètre et autorités

### 1.1 Statut final

```text
document_id: NAR-PROD-06
document_path: docs/canon/dialogues/NAR_PROD_06_PAQUET_PRODUCTION_ACTE_V_J17_J21.md
baseline_git: f6c4cec28b5574937715b090666a6e9014e0327a
scope: production narrative et visuelle J17–J21
status: READY
validation_produit: PASS
decisions_remaining_ludovic: NONE
```

Le présent document transforme les scripts signés J17–J21 en paquet de production borné. Il ne réécrit aucun dialogue et ne modifie aucun événement signé.

Il fixe :

- quinze beats servis par partie ;
- huit nouveaux contenus visuels principaux ;
- quatorze réutilisations antérieures distinctes disponibles à l’entrée de l’Acte V ;
- dix nouveaux fichiers sources ;
- zéro fichier enfant ;
- deux variantes conditionnelles ;
- zéro nouveau fichier, contenu, trace ou photographie en J21.

### 1.2 Hors périmètre absolu

Ce lot n’autorise aucune modification de :

- runtime ;
- JSON ;
- test ;
- UI ;
- asset existant ;
- dialogue signé ;
- comportement Galerie ;
- onglet visible « Souvenir ».

Il ne fournit aucun prompt ComfyUI définitif.

### 1.3 Hiérarchie d’autorité

Ordre de lecture :

1. scripts narratifs complets signés J17–J21 ;
2. `J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md` ;
3. registres canoniques des traces, promesses, connaissances et atteignabilité ;
4. contrat narratif de saison ;
5. bibles canoniques et plan `12D_PLANS_SCENES_J17_J21.md` ;
6. NAR-CANON-01 ;
7. NAR-PROD-02 à NAR-PROD-05 comme méthode et continuité de production ;
8. le présent paquet pour les identifiants, budgets, mutualisations et interdictions de production de l’Acte V.

Les sources relues à la baseline sont :

- `docs/canon/dialogues/NAR_PROD_02_PAQUET_PRODUCTION_ACTE_I_J01_J04.md` ;
- `docs/canon/dialogues/NAR_PROD_03_PAQUET_PRODUCTION_ACTE_II_J05_J08.md` ;
- `docs/canon/dialogues/NAR_PROD_04_PAQUET_PRODUCTION_ACTE_III_J09_J12.md` ;
- `docs/canon/dialogues/NAR_PROD_05_PAQUET_PRODUCTION_ACTE_IV_J13_J16.md` ;
- `docs/canon/dialogues/NAR_CANON_01_REPARATION_PROMESSES_ATTEIGNABILITE_J14_J16.md` ;
- les bibles `00`, `04`, `05`, `06`, `07`, `08`, `09`, `10`, `11` et `12D` ;
- les scripts signés J17, J18, J19, J20 et J21 ;
- les registres J01–J21 ;
- le contrat d’état narratif ;
- le signoff final du corpus ;
- les canons complets des personnages.

### 1.4 Statuts de source

| Statut | Usage dans NAR-PROD-06 |
|---|---|
| `SIGNED_SOURCE` | Événement, branche, trace, promesse ou interdiction provenant directement d’une source signée. |
| `CONSOLIDATED_CANON` | Identifiant et règle de production consolidés par le présent paquet sans modifier la narration. |
| `REFERENCE_ONLY` | Fonction narrative ou indication de composition qui ne crée ni droit de production ni comportement UI. |
| `NO_NEW_ASSET` | Production nouvelle explicitement interdite. |

`REFERENCE_ONLY` et `NO_NEW_ASSET` peuvent s’appliquer simultanément : le premier décrit la valeur documentaire, le second ferme la production.

---

## 2. Décisions produit verrouillées

### 2.1 Budget de catalogue

```text
beats_served_per_playthrough: 15
new_principal_contents: 8
historical_reuse_pool: 14
new_source_files: 10
child_files: 0
conditional_variants: 2
new_j21_files: 0
```

### 2.2 Budget fichiers par journée

| Jour | Nouveaux fichiers |
|---|---:|
| J17 | 4 |
| J18 | 3 |
| J19 | 2 |
| J20 | 1 |
| J21 | 0 |
| **Total** | **10** |

### 2.3 Variantes autorisées

Deux variantes seulement :

1. J17, famille visuelle du couple :
   - maintien / négociation ;
   - contre fracture / séparation.
2. J18, état final Sandra :
   - résolution standard ;
   - contre intimité tardive / après-coup.

Toute autre déclinaison relève du texte, des données ou du choix d’un contenu existant.

### 2.4 Catalogue et service par partie

Les huit contenus principaux forment le catalogue nouveau de l’Acte V. Ils ne sont pas tous servis dans chaque partie.

Configuration standard :

- 7 nouveaux contenus servis ;
- 8 réutilisations servies ;
- 15 beats.

Configuration J19 avec aftercare Sandra :

- 6 nouveaux contenus servis ;
- 9 réutilisations servies ;
- 15 beats.

Comptages fixes du catalogue :

- 8 nouveaux contenus principaux ;
- 14 réutilisations distinctes disponibles ;
- 10 nouveaux fichiers ;
- 2 variantes.

Le nombre de beats reste constant. La proportion nouveaux/réutilisés peut changer selon la configuration J19.

| Configuration | Nouveaux servis | Réutilisations servies | Total beats |
|---|---:|---:|---:|
| Standard — Pauline foreground | 7 | 8 | 15 |
| Standard — Raphaëlle foreground | 7 | 8 | 15 |
| J19 avec aftercare Sandra | 6 | 9 | 15 |

La reprise de C18-02 variante en J19 est une réutilisation intra-acte d’un contenu déjà compté parmi les huit nouveaux contenus. Elle ne crée ni neuvième contenu principal, ni onzième fichier, ni quinzième entrée dans le pool historique J01–J16.

---

## 3. Contrat des quinze beats

| Jour | Beat | Service |
|---|---|---|
| J17 | J17-B1 | C17-01 — Mathilde et le départ réel |
| J17 | J17-B2 | C17-02 — foyer transformé |
| J17 | J17-B3 | C17-03 — Marie / état provisoire du couple |
| J18 | J18-B1 | réutilisation T01 / ancienne photo du déjeuner |
| J18 | J18-B2 | C18-01 — Sandra décide ce qu’elle conserve ou retire |
| J18 | J18-B3 | C18-02 standard ou variante intimité tardive / après-coup |
| J19 standard | J19-B1 | C19-01 ou C19-02, un seul foreground |
| J19 standard | J19-B2 | état court de l’autre relation par réutilisation |
| J19 standard | J19-B3 | surface, processus ou vie ordinaire par réutilisation |
| J19 aftercare | J19-B1 | réutilisation de C18-02 variante |
| J19 aftercare | J19-B2 | Pauline courte par réutilisation |
| J19 aftercare | J19-B3 | Raphaëlle courte par réutilisation |
| J20 | J20-B1 | C20-01 — Nico dans son monde et position active |
| J20 | J20-B2 | personne ou trace concernée par réutilisation admissible |
| J20 | J20-B3 | conséquence du réseau ou retour ordinaire par réutilisation |
| J21 | J21-B1 | vie ordinaire avec une image de scène J17–J20 existante |
| J21 | J21-B2 | photographie admissible existante, ou état/absence d’une trace |
| J21 | J21-B3 | conséquence ou comportement final avec un contenu existant |

Les trois lignes alternatives J19 occupent les mêmes trois positions de service. Une partie ne sert donc jamais dix-huit beats.

---

## 4. Tableau exécutif J17–J21

| Jour | Contenus catalogue | Fichiers | Variantes | Traces `NO_NEW_ASSET` |
|---|---:|---:|---:|---|
| J17 | 3 | 4 | 1 | T23 |
| J18 | 2 | 3 | 1 | T24 pour le fichier photographique ; représentation physique comprise dans C18-01 |
| J19 | 2 foregrounds alternatifs | 2 | 0 | T25, T26 |
| J20 | 1 | 1 | 0 | T27, T28 |
| J21 | 0 | 0 | 0 | aucune nouvelle trace |
| **Total** | **8** | **10** | **2** | **T23–T28 : aucun fichier autonome supplémentaire** |

Les deux contenus J19 existent au catalogue, mais un seul est foreground et servi comme nouveau contenu dans une partie standard.

---

## 5. Paquet J17 — Le foyer ne peut plus rester le même

### 5.1 Fonction et service

La chaîne unique est :

```text
Mathilde quitte réellement l’espace temporaire
→ le foyer change matériellement
→ Marie et Player définissent provisoirement le couple
```

Le premier mouvement appartient à Mathilde. Sa sécurité ou sa distance passe avant le confort du couple. Elle ne devient jamais arbitre du couple.

J17 sert :

1. C17-01 — Mathilde et le départ réel ;
2. C17-02 — foyer transformé ;
3. C17-03 — Marie / état provisoire du couple.

### 5.2 Budget

```text
principal_contents: 3
source_files: 4
variants: 1
child_files: 0
```

### 5.3 Mutualisation de C17-03

| État couple | Famille visuelle J17 | Différence portée par le texte |
|---|---|---|
| `RECONQUEST_ACTIVE` | A — maintien / négociation | reconquête explicitement active ; règles et gestes cohérents avec ce choix |
| `PROVISIONAL_AGREEMENT` | A — maintien / négociation | accord borné, non-réparation du passé et point de contrôle futur |
| `RECONFIGURATION_NEGOTIATING` | A — maintien / négociation | autonomie, limites et capacités de refus restent en négociation |
| continuité encore tenue | A — maintien / négociation | présence commune lisible sans retour à la normale automatique |
| `DOUBLE_LIFE_FRAGILE` | B — fracture / séparation | portes maintenues, participation de Marie retirée ou secret encore actif |
| `FRACTURE` | B — fracture / séparation | distance affective forte et couple non fonctionnel |
| `SEPARATION` | B — fracture / séparation | séparation dite et conséquences matérielles propres |

Les six états de couple canoniques restent distincts dans le texte et les données. « Continuité encore tenue » n’ajoute pas un septième `couple_state` : elle décrit la lecture visuelle commune aux sorties encore tenues.

Interdictions :

- aucune image par état Mathilde ;
- aucune image par `household_state` ;
- aucune matrice Mathilde × foyer × couple ;
- aucune nouvelle image intime ;
- aucune progression adulte ;
- aucune victoire esthétique de Marie sur Mathilde ;
- aucun retour visuel au couple d’avant.

### 5.4 T23

```text
trace_id: j17_couple_definition_record_01
trace_type: FACT_RECORD
source_day: J17
source_status: SIGNED_SOURCE
production_status: NO_NEW_ASSET
new_file: 0
eligible_for_j21: context_only
```

T23 informe le sens, la sélection et la posture de J21. Il ne devient jamais une photo, une capture, une miniature ou un fichier autonome.

### 5.5 P18

P18 est traitée selon son statut réel :

- `ACTIVE` : elle doit être payée, amendée, refusée ou échouée par la chaîne signée ;
- `AMENDED` : un seul déplacement admissible est respecté ;
- `REFUSED` : aucune conversation Marie fictive n’est créée ;
- `PAID` ou `FAILED` : la sortie réelle est enregistrée sans rejouer une scène inexistante.

J17 définit néanmoins le couple par les actes, la présence, la distance ou la définition unilatérale autorisée par le script.

### 5.6 Verdict

```text
J17: READY
```

---

## 6. Paquet J18 — Sandra choisit ce qu’elle garde

### 6.1 Trois beats

1. réutilisation photographique T01 / ancienne photo ;
2. C18-01 — Sandra décidant ce qu’elle conserve, range ou retire ;
3. C18-02 — état final Sandra, standard ou variante.

Les distinctions suivantes ne sont jamais fusionnées :

- garder une photographie ;
- garder le souvenir ;
- garder la relation ;
- garder le désir ;
- garder Player comme audience.

### 6.2 Budget

```text
principal_contents: 2
source_files: 3
variants: 1
historical_photo_reused: T01
new_diegetic_photo_source: 0
child_files: 0
```

### 6.3 T24

```text
trace_id: j18_sandra_lunch_print_01
trace_type: PHYSICAL_PRINT
source_day: J18
creator: Sandra
owner: Sandra
initial_audience: [Sandra]
current_audience: [Sandra] sauf choix explicite différent
saving_rule: OWNER_ONLY
transfer_rule: OWNER_CONFIRMATION_REQUIRED
current_state: ACTIVE | NOT_CREATED
replaces_or_derives_from: j01_sandra_lunch_memory_soft
source_status: SIGNED_SOURCE
production_status: NO_NEW_ASSET pour le fichier photographique
```

Règles de comptage :

- nouveau `trace_id` ;
- réutilisation du fichier photographique T01 ;
- zéro nouveau fichier photographique source ;
- zéro fichier enfant ;
- zéro contenu principal supplémentaire ;
- représentation physique de l’impression comprise dans C18-01 ;
- aucun accès Player automatique ;
- aucune seconde copie de T01 comptée ;
- aucune extension d’audience par simple message.

Contrat de séparation définitif :

- C18-01 est un `SOUVENIR_IMAGE_DE_SCÈNE`, joueur uniquement et non diégétique ;
- C18-01 ne dépend pas de l’audience diégétique Player ;
- C18-01 peut servir en J21 comme vie ordinaire ou contexte d’absence ;
- C18-01 ne devient jamais T24 ni la trace principale ;
- T24 est un `PHYSICAL_PRINT` appartenant à Sandra ;
- T24 réutilise le fichier photographique T01 ;
- T24 intervient en J21 par message, état ou signification ;
- T24 n’accorde pas d’accès direct Player par défaut ;
- T24 ne reçoit aucun `content_id` et ne possède aucun fichier autonome ;
- le paquet ne crée aucune photographie du tirage.

Le fichier de C18-01 représente Sandra agissant avec l’objet. Il n’est ni le fichier photographique T24, ni une copie de T01, ni une photographie autonome du tirage.

### 6.4 Variante adulte

La variante intimité tardive / après-coup :

- remplace C18-02 standard ;
- ne s’y ajoute pas ;
- reste `IMAGE_DE_SCÈNE NON DIÉGÉTIQUE` ;
- ne crée aucune photographie sexuelle ;
- ne crée aucun droit futur ;
- ne promet aucune répétition ;
- devient le support réutilisable de l’aftercare J19 ;
- ne produit aucun fichier supplémentaire en J19.

### 6.5 États textuels

Les états :

- amitié retrouvée ;
- confidence privilégiée ;
- désir reconnu et contenu ;
- relation parallèle tendre ;
- intimité tardive ;
- recul protecteur ;
- rupture de confiance ;

restent distincts dans le texte et les données. La variante de fichier ne remplace pas cette granularité narrative.

### 6.6 Verdict

```text
J18: READY
```

---

## 7. Paquet J19 — Ce que les versions privées deviennent

### 7.1 Catalogue et budget

Le catalogue contient :

- C19-01 — Pauline foreground : surface / compartiment ;
- C19-02 — Raphaëlle foreground : personne / processus après le rôle.

```text
catalogue_contents: 2
source_files: 2
variants: 0
new_foregrounds_served_per_standard_playthrough: 1
```

C19-01 et C19-02 ne sont jamais servis ensemble comme deux foregrounds.

### 7.2 Configurations

| Configuration J19 | Foreground | Relation courte 1 | Relation courte 2 | Nouveau fichier servi |
|---|---|---|---|---:|
| Pauline foreground | C19-01 nouveau | Raphaëlle par réutilisation | surface publique, Bastien, processus ou vie ordinaire par réutilisation | 1 |
| Raphaëlle foreground | C19-02 nouveau | Pauline par réutilisation | processus, Maud, version publique ou vie ordinaire par réutilisation | 1 |
| Aftercare Sandra | C18-02 variante réutilisée | Pauline par réutilisation | Raphaëlle par réutilisation | 0 |

### 7.3 Configuration Pauline

Pauline doit rester liée à :

- Bastien ;
- Marie ;
- sa version publique ;
- sa version privée ;
- son audience ;
- son compartiment ;
- une preuve réciproque éventuelle.

Le second et le troisième beat sont choisis dans le pool existant. Aucun menu Pauline/Raphaëlle n’est exposé.

### 7.4 Configuration Raphaëlle

Raphaëlle doit rester une personne entière, liée à :

- son travail ;
- son processus ;
- Maud ;
- l’image ;
- le rôle ;
- la fin du rôle ;
- l’accès futur borné ;
- Marie informée ou exclue selon les faits.

Elle n’est jamais réduite au costume. Une invitation future n’équivaut ni à une scène gagnée ni à un accès adulte.

### 7.5 Configuration aftercare Sandra

Si l’intimité tardive J18 a réellement eu lieu :

- l’aftercare Sandra devient foreground ;
- C18-02 variante est réutilisée ;
- Pauline reçoit une direction courte par réutilisation ;
- Raphaëlle reçoit une direction courte par réutilisation ;
- zéro nouveau fichier J19 spécifique Sandra ;
- zéro nouvelle scène adulte ;
- zéro image intime de consolation ;
- aucun aftercare n’est omis.

### 7.6 T25 et T26

| Trace | Type | Règle |
|---|---|---|
| T25 `j19_pauline_reciprocal_message_01` | `TEXT_MESSAGE` | preuve ou contradiction textuelle ; zéro fichier visuel |
| T26 `j19_raphaelle_creative_access_01` | `ACCESS_GRANT` ou `ACCESS_REVOCATION` | état d’accès ; zéro fichier visuel |

T25 et T26 ne deviennent ni photographie, ni capture, ni miniature, ni asset de Galerie.

### 7.7 Verdict

```text
J19: READY
```

---

## 8. Paquet J20 — Ce que l’amitié peut porter

### 8.1 Service et budget

J20 sert :

1. C20-01 — Nico dans son monde et position active ;
2. une personne ou une trace avec l’audience correcte, par réutilisation ;
3. une conséquence du réseau ou un retour ordinaire, par réutilisation.

```text
principal_contents: 1
source_files: 1
variants: 0
reuses_served: 2
```

Le même fichier C20-01 porte les positions :

- garde-fou ;
- confident limité ;
- rival honnête ;
- complice conscient ;
- partenaire d’un regard autorisé ;
- témoin compromis ;
- ami prenant ses distances.

La différence reste textuelle, comportementale et liée aux conséquences. Aucune variante d’image par état Nico n’est créée.

### 8.2 Interdictions

- aucune route romantique ou sexuelle Nico / Player ;
- aucune révélation bisexuelle ;
- aucune image de femme donnée par Player ;
- aucun alibi rouvert ;
- Nico ne juge pas les femmes ;
- une conséquence secondaire forte maximum ;
- aucune nouvelle route féminine ;
- aucune progression adulte ;
- aucune nouvelle image intime.

### 8.3 T27 et T28

```text
T27:
  trace_id: j20_nico_exact_hour_record_01
  trace_type: FACT_RECORD
  production_status: NO_NEW_ASSET

T28:
  trace_id: j20_nico_unauthorized_copy_deleted_01
  trace_type: ABSENCE_MARKER
  production_status: NO_NEW_ASSET
```

T28 représente l’absence ou la suppression. Il ne montre jamais le contenu supprimé et ne restaure aucun fichier.

### 8.4 P23

```text
promise_id: nico_j20_lannexe_2120
created_at: J20 18 h 57, proposition précise de Nico
created_by: Nico
proposed_to: Player
accepted_at: choix Player
```

Transitions :

```text
acceptation
→ ACTIVE

refus
→ REFUSED
→ aucune attente
→ aucune dégradation automatique de l’amitié

rencontre tenue
→ PAID

annulation explicite
→ CANCELLED
```

La fiche P23 existe dès la proposition précise de Nico. Elle ne devient `ACTIVE` que si Player accepte et peut rester enregistrée en `REFUSED` après un refus. Elle ne crée aucune image intime ni aucun accès à une femme.

### 8.5 Verdict

```text
J20: READY
```

---

## 9. J21 — `NO_NEW_ASSET` absolu

### 9.1 Budget

```text
beats_served: 3
new_principal_contents: 0
new_source_files: 0
child_files: 0
variants: 0
new_traces: 0
new_photographs: 0
production_status: NO_NEW_ASSET
```

Les trois beats utilisent exclusivement :

1. une image de scène existante J17–J20 pour la vie ordinaire ;
2. une photographie admissible existante, ou l’état/absence d’une trace ;
3. un contenu existant représentant la conséquence ou le comportement final.

### 9.2 Reclassification des propositions

Toutes les propositions J21 marquées « À PRODUIRE PLUS TARD », notamment J21-V1, J21-V3 et J21-V4, sont reclassées dans ce paquet ainsi :

```text
source_status: REFERENCE_ONLY
production_status: NO_NEW_ASSET
```

La possibilité ancienne d’une illustration nouvelle autour de J21-V2 est également fermée :

```text
source_status: REFERENCE_ONLY
production_status: NO_NEW_ASSET
```

Ces blocs définissent une fonction narrative. Ils n’autorisent aucune production.

### 9.3 Garde de type obligatoire

Peut servir directement comme image principale :

- `PHOTO` ;
- `PHOTO_SET` ;
- contenu visuel de scène déjà produit et utilisé uniquement comme vie ordinaire, jamais comme trace diégétique.

Dans ce paquet, un `PHYSICAL_PRINT` ne sert pas directement comme image principale : T24 intervient uniquement par message, état ou signification, tandis que le fichier photographique T01 peut être réutilisé selon ses propres règles d’audience.

Ne peut jamais devenir « la dernière photo » :

- `TEXT_MESSAGE` ;
- `ACCESS_GRANT` ;
- `ACCESS_REVOCATION` ;
- `FACT_RECORD` ;
- `ABSENCE_MARKER` ;
- `NOTIFICATION`.

Ces types peuvent :

- guider la sélection ;
- expliquer une absence ;
- définir une conséquence ;
- déterminer une posture.

Ils ne deviennent jamais un fichier photographique.

### 9.4 Traces absentes ou inaccessibles

Une trace `REMOVED`, `DELETED` ou `INACCESSIBLE` n’est représentée que par :

- son absence ;
- un emplacement vide ;
- un message existant ;
- un contenu de scène déjà produit ;
- une autre trace admissible contrôlée.

Aucun fichier n’est restauré.

L’absence est un état narratif. Elle ne reçoit ni `content_id`, ni `asset_id`, ni fichier de substitution.

### 9.5 Sélection invisible

Une seule trace reçoit le premier plan. La sélection dépend des états de saison, notamment :

1. dette de sécurité ou d’audience active ;
2. contradiction active ;
3. relation dominante ;
4. couple ;
5. trace sociale publique.

Player ne choisit ni femme ni trace dans la Galerie. La posture finale :

- `RULE_ACTED` ;
- `LOSS_ACKNOWLEDGED` ;
- `EXISTING_CONTRADICTION_MAINTAINED` seulement si une contradiction existait déjà ;

ne modifie pas rétroactivement les états relationnels.

### 9.6 Anti-explosion combinatoire

Il n’existe aucun fichier pour :

```text
couple_state
× route_dominante
× final_trace_id
× posture_finale
```

La finale sépare :

- le fichier source existant ;
- l’état du fichier ;
- son audience ;
- le contexte textuel ;
- la vie ordinaire réutilisée ;
- l’absence éventuelle ;
- le dernier comportement.

La même trace peut changer de sens sans produire une nouvelle image.

### 9.7 Verdict

```text
J21: READY
```

---

## 10. Registre exact des huit nouveaux contenus principaux

Tous les fichiers de ce registre sont des `SOUVENIR_IMAGE_DE_SCÈNE` non diégétiques. Aucun n’est une trace possédée par un personnage.

### C17-01 — Mathilde et le départ réel

| Champ | Valeur |
|---|---|
| `content_id` | `C17-01` |
| `asset_id` | `S1_A5_J17_SCN_MATHILDE_REAL_DEPARTURE_01` |
| `day_id` | `J17` |
| `beat_served` | `J17-B1` |
| `source_status` | `CONSOLIDATED_CANON` |
| `content_type` | `SOUVENIR_IMAGE_DE_SCÈNE` |
| `center` | Mathilde |
| `function` | montrer la fin réelle de l’occupation temporaire et l’autonomie du départ |
| `creator` | non applicable — mise en scène non diégétique |
| `subjects` | Mathilde ; objets strictement utiles au départ |
| `owner` | aucun propriétaire diégétique |
| `audience` | joueur uniquement |
| `saving_rule` | `NONE` |
| `transfer_rule` | `FORBIDDEN` |
| `permanence` | contenu de scène si le départ est vécu |
| `trace_id` | aucun |
| `files` | 1 |
| `variant_rule` | aucune variante par état Mathilde |
| `gallery_eligibility` | `conditional` |
| `gallery_slot_behavior` | `deferred`; aucun nouveau comportement |
| `reuse_in_later_day` | vie ordinaire J21 ou conséquence J20 seulement |
| `forbidden_uses` | photo diégétique ; preuve ; matrice d’états ; départ symbolique ; Player identifiable |

### C17-02 — Foyer transformé

| Champ | Valeur |
|---|---|
| `content_id` | `C17-02` |
| `asset_id` | `S1_A5_J17_SCN_HOUSEHOLD_TRANSFORMED_01` |
| `day_id` | `J17` |
| `beat_served` | `J17-B2` |
| `source_status` | `CONSOLIDATED_CANON` |
| `content_type` | `SOUVENIR_IMAGE_DE_SCÈNE` |
| `center` | foyer transformé ; Marie possible sans domination |
| `function` | rendre matériellement lisible que le foyer ne revient pas à son état antérieur |
| `creator` | non applicable — mise en scène non diégétique |
| `subjects` | espace partagé, petite chambre, entrée, cuisine ou couloir |
| `owner` | aucun propriétaire diégétique |
| `audience` | joueur uniquement |
| `saving_rule` | `NONE` |
| `transfer_rule` | `FORBIDDEN` |
| `permanence` | contenu de scène si l’état est atteint |
| `trace_id` | aucun |
| `files` | 1 |
| `variant_rule` | aucune variante par `household_state` |
| `gallery_eligibility` | `conditional` |
| `gallery_slot_behavior` | `deferred`; aucun nouvel onglet |
| `reuse_in_later_day` | J20 retour ordinaire ; J21 vie ordinaire |
| `forbidden_uses` | retour rassurant automatique ; victoire de Marie ; invitation sexuelle ; trace J21 |

### C17-03 — Marie / état provisoire du couple

| Champ | Valeur |
|---|---|
| `content_id` | `C17-03` |
| `asset_ids` | `S1_A5_J17_SCN_MARIE_COUPLE_STATE_01_HELD_NEGOTIATING`; `S1_A5_J17_SCN_MARIE_COUPLE_STATE_01_FRACTURE_SEPARATION` |
| `day_id` | `J17` |
| `beat_served` | `J17-B3` |
| `source_status` | `CONSOLIDATED_CANON` |
| `content_type` | `SOUVENIR_IMAGE_DE_SCÈNE` |
| `center` | Marie ; relation rendue par l’espace et la posture, Player non identifiable |
| `function` | porter la famille visuelle du nouvel état du couple |
| `creator` | non applicable — mise en scène non diégétique |
| `subjects` | Marie ; présence indirecte ou hors champ de Player |
| `owner` | aucun propriétaire diégétique |
| `audience` | joueur uniquement |
| `saving_rule` | `NONE` |
| `transfer_rule` | `FORBIDDEN` |
| `permanence` | une seule famille servie selon le `couple_state` |
| `trace_id` | aucun ; T23 reste distinct |
| `files` | 2 |
| `variant_rule` | famille A maintien/négociation contre famille B fracture/séparation |
| `gallery_eligibility` | `conditional` |
| `gallery_slot_behavior` | `deferred`; aucun nouvel onglet |
| `reuse_in_later_day` | J21 vie ordinaire ou conséquence finale, jamais comme trace |
| `forbidden_uses` | un fichier par état ; T23 visuel ; permission adulte ; réparation automatique |

### C18-01 — Sandra décide avec l’impression, le livre, l’enveloppe ou le fil

| Champ | Valeur |
|---|---|
| `content_id` | `C18-01` |
| `asset_id` | `S1_A5_J18_SCN_SANDRA_KEEPS_REMOVES_PRINT_01` |
| `day_id` | `J18` |
| `beat_served` | `J18-B2` |
| `source_status` | `CONSOLIDATED_CANON` |
| `content_type` | `SOUVENIR_IMAGE_DE_SCÈNE` |
| `center` | Sandra active |
| `function` | montrer Sandra décidant ce qu’elle conserve, range ou retire |
| `creator` | non applicable — mise en scène non diégétique |
| `subjects` | Sandra ; impression, livre, enveloppe ou fil selon la branche |
| `owner` | aucun propriétaire diégétique |
| `audience` | joueur uniquement ; ne dépend pas de l’audience diégétique Player |
| `saving_rule` | `NONE` |
| `transfer_rule` | `FORBIDDEN` |
| `permanence` | scène vécue |
| `trace_id` | aucun ; T24 reste un objet narratif distinct |
| `files` | 1 |
| `variant_rule` | aucune variante d’objet ou d’état Sandra |
| `gallery_eligibility` | `conditional` |
| `gallery_slot_behavior` | `deferred`; aucun nouvel onglet |
| `reuse_in_later_day` | J21 comme vie ordinaire ou contexte d’absence |
| `forbidden_uses` | affichage direct de T24 ; trace principale ; copie T01 ; extension d’audience |

### C18-02 — État final Sandra

| Champ | Valeur |
|---|---|
| `content_id` | `C18-02` |
| `asset_ids` | `S1_A5_J18_SCN_SANDRA_FINAL_STATE_01_STANDARD`; `S1_A5_J18_SCN_SANDRA_FINAL_STATE_01_LATE_INTIMACY_AFTERCARE` |
| `day_id` | `J18` |
| `beat_served` | `J18-B3`; variante réutilisée en `J19-B1` si aftercare |
| `source_status` | `CONSOLIDATED_CANON` |
| `content_type` | `SOUVENIR_IMAGE_DE_SCÈNE` |
| `center` | Sandra |
| `function` | montrer sa vie après la décision ; fournir l’après-coup si intimité tardive |
| `creator` | non applicable — mise en scène non diégétique |
| `subjects` | Sandra ; environnement ordinaire ou après-coup non photographié |
| `owner` | aucun propriétaire diégétique |
| `audience` | joueur uniquement |
| `saving_rule` | `NONE` |
| `transfer_rule` | `FORBIDDEN` |
| `permanence` | une seule version selon la branche |
| `trace_id` | aucun |
| `files` | 2 |
| `variant_rule` | standard remplacée par intimité tardive / après-coup ; jamais cumulées |
| `gallery_eligibility` | `conditional` |
| `gallery_slot_behavior` | `deferred`; aucun nouvel onglet |
| `reuse_in_later_day` | variante aftercare en J19 ; version servie possible en J21 comme conséquence |
| `forbidden_uses` | photographie sexuelle ; permission future ; récompense ; répétition promise |

### C19-01 — Pauline foreground : surface / compartiment

| Champ | Valeur |
|---|---|
| `content_id` | `C19-01` |
| `asset_id` | `S1_A5_J19_SCN_PAULINE_SURFACE_COMPARTMENT_01` |
| `day_id` | `J19` |
| `beat_served` | `J19-B1`, configuration Pauline uniquement |
| `source_status` | `CONSOLIDATED_CANON` |
| `content_type` | `SOUVENIR_IMAGE_DE_SCÈNE` |
| `center` | Pauline |
| `function` | rendre lisible sa décision entre surface, compartiment, fermeture et responsabilité |
| `creator` | non applicable — mise en scène non diégétique |
| `subjects` | Pauline ; Bastien ou surface publique seulement si la branche l’exige |
| `owner` | aucun propriétaire diégétique |
| `audience` | joueur uniquement |
| `saving_rule` | `NONE` |
| `transfer_rule` | `FORBIDDEN` |
| `permanence` | servi uniquement si Pauline est foreground |
| `trace_id` | aucun ; T25 reste textuelle |
| `files` | 1 |
| `variant_rule` | aucune variante par sortie Pauline |
| `gallery_eligibility` | `conditional` |
| `gallery_slot_behavior` | `deferred`; aucun nouvel onglet |
| `reuse_in_later_day` | J20 conséquence ; J21 comportement final |
| `forbidden_uses` | Pauline sans Bastien ; nouvelle image intime ; T25 transformée en photo ; foreground conjoint C19-02 |

### C19-02 — Raphaëlle foreground : personne / processus après le rôle

| Champ | Valeur |
|---|---|
| `content_id` | `C19-02` |
| `asset_id` | `S1_A5_J19_SCN_RAPHAELLE_AFTER_ROLE_PROCESS_01` |
| `day_id` | `J19` |
| `beat_served` | `J19-B1`, configuration Raphaëlle uniquement |
| `source_status` | `CONSOLIDATED_CANON` |
| `content_type` | `SOUVENIR_IMAGE_DE_SCÈNE` |
| `center` | Raphaëlle comme personne et travailleuse |
| `function` | montrer le processus, la fin du rôle et la frontière future |
| `creator` | non applicable — mise en scène non diégétique |
| `subjects` | Raphaëlle ; Maud ou environnement de travail si la branche le justifie |
| `owner` | aucun propriétaire diégétique |
| `audience` | joueur uniquement |
| `saving_rule` | `NONE` |
| `transfer_rule` | `FORBIDDEN` |
| `permanence` | servi uniquement si Raphaëlle est foreground |
| `trace_id` | aucun ; T26 reste un état d’accès |
| `files` | 1 |
| `variant_rule` | aucune variante par sortie Raphaëlle |
| `gallery_eligibility` | `conditional` |
| `gallery_slot_behavior` | `deferred`; aucun nouvel onglet |
| `reuse_in_later_day` | J20 conséquence professionnelle ; J21 comportement final |
| `forbidden_uses` | réduction au costume ; T26 photographique ; accès adulte ; foreground conjoint C19-01 |

### C20-01 — Nico dans son monde et position active

| Champ | Valeur |
|---|---|
| `content_id` | `C20-01` |
| `asset_id` | `S1_A5_J20_SCN_NICO_ACTIVE_POSITION_01` |
| `day_id` | `J20` |
| `beat_served` | `J20-B1` |
| `source_status` | `CONSOLIDATED_CANON` |
| `content_type` | `SOUVENIR_IMAGE_DE_SCÈNE` |
| `center` | Nico dans son monde |
| `function` | donner une présence active à son état d’amitié sans juger les femmes |
| `creator` | non applicable — mise en scène non diégétique |
| `subjects` | Nico ; environnement ordinaire ou L’Annexe seulement si réellement atteint |
| `owner` | aucun propriétaire diégétique |
| `audience` | joueur uniquement |
| `saving_rule` | `NONE` |
| `transfer_rule` | `FORBIDDEN` |
| `permanence` | scène vécue ; un seul fichier pour tous les états Nico |
| `trace_id` | aucun ; T27 et T28 restent non visuelles |
| `files` | 1 |
| `variant_rule` | aucune variante par état Nico ou acceptation de P23 |
| `gallery_eligibility` | `conditional` |
| `gallery_slot_behavior` | `deferred`; aucun nouvel onglet |
| `reuse_in_later_day` | J21 comportement ou état de réseau |
| `forbidden_uses` | romance Nico/Player ; image de femme échangée ; alibi rouvert ; T27/T28 visuels |

### 10.1 Contrôle du registre

```text
J17: C17-01 + C17-02 + C17-03 = 3
J18: C18-01 + C18-02 = 2
J19: C19-01 + C19-02 = 2
J20: C20-01 = 1
J21: 0
total: 8
```

T24 ne reçoit pas un neuvième `content_id`.

---

## 11. Manifeste exact des dix fichiers

| # | `asset_id` | `content_id` | `day_id` | `variant_of` | `source_status` | `file_count` | Sujet principal | Fonction narrative | Statut diégétique | `trace_id` éventuel | Audience | Permanence | Réutilisation possible | Réutilisation interdite |
|---:|---|---|---|---|---|---:|---|---|---|---|---|---|---|---|
| 1 | `S1_A5_J17_SCN_MATHILDE_REAL_DEPARTURE_01` | C17-01 | J17 | `null` | `CONSOLIDATED_CANON` | 1 | Mathilde | départ réel | non diégétique | aucun | joueur | scène vécue | J20/J21, vie ordinaire | photo, preuve, état par état |
| 2 | `S1_A5_J17_SCN_HOUSEHOLD_TRANSFORMED_01` | C17-02 | J17 | `null` | `CONSOLIDATED_CANON` | 1 | foyer | foyer matériellement changé | non diégétique | aucun | joueur | scène vécue | J20/J21, vie ordinaire | trace, victoire ou réparation automatique |
| 3 | `S1_A5_J17_SCN_MARIE_COUPLE_STATE_01_HELD_NEGOTIATING` | C17-03 | J17 | `null` | `CONSOLIDATED_CANON` | 1 | Marie / couple | maintien ou négociation | non diégétique | aucun | joueur | branche servie | J21, état ordinaire | T23, permission adulte, états B |
| 4 | `S1_A5_J17_SCN_MARIE_COUPLE_STATE_01_FRACTURE_SEPARATION` | C17-03 | J17 | `S1_A5_J17_SCN_MARIE_COUPLE_STATE_01_HELD_NEGOTIATING` | `CONSOLIDATED_CANON` | 1 | Marie / couple | fracture ou séparation | non diégétique | aucun | joueur | variante servie | J21, conséquence | T23, états A, fausse réconciliation |
| 5 | `S1_A5_J18_SCN_SANDRA_KEEPS_REMOVES_PRINT_01` | C18-01 | J18 | `null` | `CONSOLIDATED_CANON` | 1 | Sandra | décider avec l’impression ou le fil | non diégétique | aucun ; T24 reste distincte | joueur uniquement | scène vécue | J21 comme vie ordinaire ou contexte d’absence | affichage direct de T24 ; trace principale ; copie T01 ; extension d’audience |
| 6 | `S1_A5_J18_SCN_SANDRA_FINAL_STATE_01_STANDARD` | C18-02 | J18 | `null` | `CONSOLIDATED_CANON` | 1 | Sandra | résolution standard | non diégétique | aucun | joueur | branche servie | J21 conséquence | cumul avec variante adulte |
| 7 | `S1_A5_J18_SCN_SANDRA_FINAL_STATE_01_LATE_INTIMACY_AFTERCARE` | C18-02 | J18 | `S1_A5_J18_SCN_SANDRA_FINAL_STATE_01_STANDARD` | `CONSOLIDATED_CANON` | 1 | Sandra | intimité tardive / après-coup | non diégétique | aucun | joueur | branche servie | aftercare J19 ; J21 conséquence | photographie sexuelle, droit futur, consolation J19 nouvelle |
| 8 | `S1_A5_J19_SCN_PAULINE_SURFACE_COMPARTMENT_01` | C19-01 | J19 | `null` | `CONSOLIDATED_CANON` | 1 | Pauline | surface / compartiment | non diégétique | aucun | joueur | foreground Pauline | J20/J21 | T25 photographique, foreground C19-02 conjoint |
| 9 | `S1_A5_J19_SCN_RAPHAELLE_AFTER_ROLE_PROCESS_01` | C19-02 | J19 | `null` | `CONSOLIDATED_CANON` | 1 | Raphaëlle | personne / processus | non diégétique | aucun | joueur | foreground Raphaëlle | J20/J21 | T26 photographique, foreground C19-01 conjoint |
| 10 | `S1_A5_J20_SCN_NICO_ACTIVE_POSITION_01` | C20-01 | J20 | `null` | `CONSOLIDATED_CANON` | 1 | Nico | position active | non diégétique | aucun | joueur | scène vécue | J21 réseau/comportement | variante Nico, T27/T28 visuels |

Contrat explicite du fichier 5 :

```text
reuse_in_later_day:
J21 comme vie ordinaire ou contexte d’absence

forbidden_uses:
affichage direct de T24
trace principale
copie T01
extension d’audience
```

Contrôle :

```text
J17 4 + J18 3 + J19 2 + J20 1 + J21 0 = 10
child_files = 0
variants = fichiers 4 et 7 = 2
```

---

## 12. Pool exact des quatorze réutilisations antérieures

### 12.1 Règle de pool

Le pool d’entrée contient exactement quatorze contenus distincts issus de J01–J16. Chaque entrée conserve son identifiant, son créateur, son propriétaire, son audience, sa sauvegarde, son transfert et son état.

Ce pool signifie « disponible sous conditions ». Il ne signifie pas « servi intégralement dans une partie ».

Les réutilisations servies sont choisies selon la configuration, les audiences, les états et les besoins des beats. La trace finale J21 est ensuite une sélection unique, distincte du pool.

### 12.2 Manifeste

| # | Code | `content_id` ou `asset_id` exact | `trace_id` | Jour source | Créateur | Propriétaire | Audience | `saving_rule` | `transfer_rule` | État admissible | Fonction Acte V | Jours possibles | Nouveau fichier |
|---:|---|---|---|---|---|---|---|---|---|---|---|---|---:|
| 1 | R01 | `S1_A1_J01_DPH_SANDRA_LUNCH_SELECTED_01` | `j01_sandra_lunch_memory_soft` | J01 | Sandra | Sandra | Sandra, Player selon contrôle Sandra | `IN_THREAD_ONLY` | `FORBIDDEN` | `ACTIVE`, `RESTRICTED`, `REMOVED`, `INACCESSIBLE` | ancienne photo J18 ; trace ou absence J21 | J18, J21 | 0 |
| 2 | R02 | `S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01` | `j04_pauline_bastien_public_set_01` | J04 | Pauline via retardateur | Pauline | groupe social nommé | `PUBLIC_SOURCE_RULES` | `PUBLIC_SOURCE_RULES` | `PUBLIC_ACTIVE` | surface Pauline/Bastien ; conséquence sociale ; trace publique | J19, J20, J21 | 0 |
| 3 | R03 | `C09-03` / `S1_A3_J09_DPH_MARIE_LAVERRIERE_PUBLIC_01` | `j09_marie_laverriere_public_01` | J09 | Élodie | créateur ou La Verrière selon registre | groupe photographié / canal social nommé | `PUBLIC_SOURCE_RULES` | `PUBLIC_SOURCE_RULES` | `PUBLIC_ACTIVE` | visibilité professionnelle Marie ; trace principale J21 ; conséquence publique ou couple | J19, J20, J21 | 0 |
| 4 | R04 | `S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01` | aucun | J08 | non applicable | aucun propriétaire diégétique | joueur uniquement | `NONE` | `FORBIDDEN` | version réellement vécue, `ACTIVE` ou `INACCESSIBLE` | processus Raphaëlle court ou conséquence professionnelle | J19, J20, J21 vie ordinaire | 0 |
| 5 | R05 | `C09-04` / `S1_A3_J09_DPH_MARIE_LAVERRIERE_AFTER_01` | `j09_marie_laverriere_after_01` | J09 | Élodie | Marie ou Élodie selon accord canonique | Player uniquement si Marie a relayé, ou audience publique si la source exacte l’autorise | `IN_THREAD_ONLY` lorsque relayée | `FORBIDDEN` hors audience | `PRIVATE_ACTIVE`, `PUBLIC_ACTIVE`, `NOT_CREATED` | recontextualisation Marie ; conséquence couple ; trace principale J21 si réellement accessible | J19, J20, J21 | 0 |
| 6 | R06 | `S1_A3_J09_DPH_MARIE_BLACK_DRESS_PRIVATE_01` | `j09_marie_black_dress_private_01` | J09 | Marie | Marie | Marie, Player sauf retrait | `IN_THREAD_ONLY` | `FORBIDDEN` | `PRIVATE_ACTIVE`, `REMOVED`, `INACCESSIBLE` | couple, audience ou trace finale Marie | J19, J20, J21 | 0 |
| 7 | R07 | `S1_A3_J10_DPH_MATHILDE_OUTFIT_CHOICE_01` | `j10_mathilde_outfit_choice_01` | J10 | Mathilde | Mathilde | Mathilde, Player sauf retrait | `IN_THREAD_ONLY` | `FORBIDDEN` | `PRIVATE_ACTIVE`, `REMOVED`, `INACCESSIBLE` | agence Mathilde, personne concernée ou trace finale | J20, J21 | 0 |
| 8 | R08 | `S1_A3_J11_DPH_SANDRA_CHOSEN_IMAGE_01` | `j11_sandra_chosen_image_01` | J11 | Sandra | Sandra | Sandra, Player si maintenue | `IN_THREAD_ONLY` | `FORBIDDEN` | `PRIVATE_ACTIVE`, `REMOVED`, `INACCESSIBLE` | comparaison au choix J18 ; trace finale Sandra | J18, J21 | 0 |
| 9 | R09 | `S1_A3_J11_DPH_RAPHAELLE_CHOSEN_RESULT_01` | `j11_raphaelle_chosen_result_01` | J11 | Maud | Raphaëlle ou Maud selon accord | Raphaëlle, Maud ; Player seulement si envoi antérieur | `IN_THREAD_ONLY` | `FORBIDDEN` | `PRIVATE_ACTIVE`, `REMOVED`, `INACCESSIBLE` | continuité distincte du processus Raphaëlle | J19, J20, J21 | 0 |
| 10 | R10 | `S1_A3_J12_DPH_LAVERRIERE_PUBLIC_GROUP_SET_01` | `j12_laverriere_public_group_set_01` | J12 | Élodie | La Verrière ou créateur final | groupe photographié / canal nommé | `PUBLIC_SOURCE_RULES` | `PUBLIC_SOURCE_RULES` | `PUBLIC_ACTIVE` | vie ordinaire Marie, surface publique ou trace finale | J19, J20, J21 | 0 |
| 11 | R11 | `S1_A3_J12_DPH_ANNEXE_SOCIAL_POSITIONS_SET_01` | `j12_annexe_public_group_set_01` | J12 | Sophie | Sophie | groupe photographié nommé | `PUBLIC_SOURCE_RULES` | `PUBLIC_SOURCE_RULES` | `PUBLIC_ACTIVE`, `NOT_CREATED` | monde Nico, réseau, L’Annexe ou trace finale | J20, J21 | 0 |
| 12 | R12 | `S1_A3_J12_DPH_PAULINE_BASTIEN_ANNEXE_01` | aucun ; parent de T17 | J12 | Pauline | Pauline | groupe photographié nommé | sélection collective | selon accord du groupe | `ACTIVE`, `INACCESSIBLE` | Pauline/Bastien, version publique et surface officielle | J19, J20, J21 vie ordinaire | 0 |
| 13 | R13 | `C13-01` ; voir identification détaillée ci-dessous | `j13_pauline_private_version_01` | J13 | Pauline | Pauline | Pauline ; Player seulement si envoi | `IN_THREAD_ONLY` | `FORBIDDEN` | `PRIVATE_ACTIVE`, `REMOVED`, `INACCESSIBLE`, `NOT_CREATED` | état privé Pauline, audience ou trace finale | J19, J20, J21 | 0 |
| 14 | R14 | `C13-02` / `S1_A4_J13_DPH_RAPHAELLE_MASKED_POSTURE_01` | `j13_raphaelle_masked_version_01` | J13 | Maud | Raphaëlle | Raphaëlle, Maud ; Player seulement si envoi | `IN_THREAD_ONLY` | `FORBIDDEN` | `PRIVATE_ACTIVE`, `REMOVED`, `INACCESSIBLE`, `NOT_CREATED` | posture antérieure, frontière ou trace finale Raphaëlle | J19, J20, J21 | 0 |

### 12.3 Identification exacte de R13

```text
code: R13
content_id: C13-01
catalogue_asset_id: S1_A4_J13_DPH_PAULINE_PRIVATE_VERSION_01
source_file_id: S1_A3_J12_DPH_PAULINE_BASTIEN_ANNEXE_01_FRAME_04_PRIVATE
trace_id: j13_pauline_private_version_01
parent_content_id: C12-03
parent_asset_id: S1_A3_J12_DPH_PAULINE_BASTIEN_ANNEXE_01
new_file_count: 0
new_child_count: 0
new_derivation_count: 0
```

R13 distingue le contenu de catalogue, son identifiant de catalogue et le fichier source déjà produit. Cette précision ne crée aucun nouveau fichier, aucun nouvel enfant et aucune nouvelle dérivation.

### 12.4 Distinctions obligatoires

```text
pool disponible
!= contenus servis par configuration
!= trace finale sélectionnée
```

Les quatorze ne sont jamais affirmés comme tous servis dans une partie.

La variante C18-02 réutilisée en J19 est une reprise intra-acte d’un des huit contenus nouveaux. Elle ne modifie pas la cardinalité du pool historique.

Les réutilisations intra-acte de C17-01 à C20-01 restent distinctes du pool historique R01–R14. Elles ne reçoivent aucun code R et ne remplacent aucune des quatorze entrées J01–J16.

### 12.5 Réutilisations interdites

- réutiliser une photo dans une audience incompatible ;
- afficher un fichier retiré comme actif ;
- employer R04 comme trace J21 ; R03 et R05 sont des photographies historiques admissibles selon leur audience et leur état ;
- transformer un `FACT_RECORD` en image ;
- faire de T24 une copie Player par défaut ;
- faire de T26 une photographie ;
- restaurer R06, R07, R08, R09, R13 ou R14 après retrait ;
- dériver un nouveau crop, enfant ou fichier d’une entrée du pool ;
- compter les frames d’un `PHOTO_SET` comme plusieurs contenus ;
- modifier le sens de `saving_rule` ou `transfer_rule`.

---

## 13. Matrice T23–T28

| T23–T28 | Type | Fichier nouveau ? | Peut devenir image J21 ? | Fonction |
|---|---|---:|---|---|
| T23 `j17_couple_definition_record_01` | `FACT_RECORD` | non | non | état du couple, sélection et posture |
| T24 `j18_sandra_lunch_print_01` | `PHYSICAL_PRINT` | non ; C18-01 reste un fichier de scène distinct | non | propriété Sandra ; sens par message, état ou signification et réutilisation T01 |
| T25 `j19_pauline_reciprocal_message_01` | `TEXT_MESSAGE` | non | non | preuve ou contradiction textuelle |
| T26 `j19_raphaelle_creative_access_01` | `ACCESS_GRANT` ou `ACCESS_REVOCATION` | non | non | état d’accès créatif |
| T27 `j20_nico_exact_hour_record_01` | `FACT_RECORD` | non | non | fait d’heure, dette ou fermeture d’alibi |
| T28 `j20_nico_unauthorized_copy_deleted_01` | `ABSENCE_MARKER` | non | non | suppression ou non-création d’un fichier hors audience |

T23, T25, T26, T27 et T28 créent exactement zéro fichier. T24 crée un nouvel objet narratif et un nouveau `trace_id`, mais réutilise le fichier photographique de T01.

---

## 14. Matrice P18–P23

| P18–P23 | Création | Statut | Paiement ou fermeture | Hook futur |
|---|---|---|---|---|
| P18 `marie_j16_couple_conversation_j17` | J16 par choix réel Marie/Player | `ACTIVE`, `AMENDED`, `REFUSED`, `PAID`, `FAILED` | J17 : conversation hors téléphone, définition unilatérale autorisée ou déplacement unique ; aucune scène fictive si non active | aucun après paiement ; T23 porte l’état |
| P19 `couple_review_due_at` | J17 pour accord provisoire ou reconfiguration | `ACTIVE`, `AMENDED`, `PAID`, `REFUSED`, `FAILED` | hors Saison 1 ; J20/J21 peuvent rappeler, jamais payer | point couple jeudi suivant J21, 20 h 30 |
| P20 `couple_shared_day_due_at` | proposition J17 C17-A2 | `CONDITIONAL` | ne devient pas active en J18–J21 ; confirmation seulement pendant P19 | journée partagée future Marie |
| P21 `sandra_future_cafe_after_j18` | J18 seulement avec date et heure précises proposées ou acceptées | `ACTIVE`, `CONDITIONAL`, `REFUSED`, `CLOSED` | extension future ; « on se revoit » ne crée rien | café Sandra borné |
| P22 `raphaelle_future_atelier_saturday_1500` | J19 par Raphaëlle, après choix réel Player | `ACTIVE`, `REFUSED`, `AMENDED`, `CLOSED` | extension future ; Maud présente la première heure ; aucun accès adulte automatique | atelier samedi suivant, 15 h–17 h |
| P23 `nico_j20_lannexe_2120` | J20 18 h 57, proposition précise créée par Nico et proposée à Player ; acceptation au choix Player | `ACTIVE` après acceptation ; `REFUSED` après refus ; `PAID` après rencontre ; `CANCELLED` après annulation explicite | refus : aucune attente et aucune dégradation automatique ; rencontre tenue : paiement ; annulation explicite : fermeture | aucun droit nouveau ; retour textuel après séparation |

Une promesse future n’est jamais une scène déjà gagnée.

---

## 15. Matrice des traces candidates J21

| Trace J21 | Type | État admissible | Player audience ? | Affichage direct ou sens seulement |
|---|---|---|---|---|
| `j09_marie_black_dress_private_01` | `PHOTO` | `PRIVATE_ACTIVE`, `REMOVED`, `INACCESSIBLE` | oui seulement si encore accessible | direct si accessible ; sinon absence/sens |
| `j09_marie_laverriere_public_01` | `PHOTO` | `PUBLIC_ACTIVE` | selon groupe ou canal nommé | direct selon règles de source |
| `j09_marie_laverriere_after_01` | `PHOTO` | `PRIVATE_ACTIVE`, `PUBLIC_ACTIVE`, `NOT_CREATED` | oui seulement si Marie a relayé ou si la source l’autorise | direct si audience ; sinon sens/non-création |
| `j12_laverriere_public_group_set_01` | `PHOTO_SET` | `PUBLIC_ACTIVE` | selon groupe photographié ou canal nommé | direct selon règles de source |
| `j01_sandra_lunch_memory_soft` | `PHOTO` | `ACTIVE`, `RESTRICTED`, `REMOVED`, `INACCESSIBLE` | selon contrôle Sandra | direct si accessible ; sinon absence/sens |
| `j11_sandra_chosen_image_01` | `PHOTO` | `PRIVATE_ACTIVE`, `REMOVED`, `INACCESSIBLE` | oui si maintenue | direct si accessible ; sinon absence/sens |
| `j18_sandra_lunch_print_01` | `PHYSICAL_PRINT` | `ACTIVE`, `NOT_CREATED` | pas d’accès direct Player par défaut | sens par message Sandra et réutilisation T01 ; jamais fichier T24 autonome |
| `j10_mathilde_outfit_choice_01` | `PHOTO` | `PRIVATE_ACTIVE`, `REMOVED`, `INACCESSIBLE` | oui si encore accessible | direct si accessible et pertinente ; sinon absence/sens |
| `j04_pauline_bastien_public_set_01` | `PHOTO_SET` | `PUBLIC_ACTIVE` | selon groupe social nommé | direct selon règles publiques de source |
| `j13_pauline_private_version_01` | `PHOTO` | `PRIVATE_ACTIVE`, `REMOVED`, `INACCESSIBLE`, `NOT_CREATED` | oui seulement si Pauline l’a envoyée | direct si accessible ; sinon absence/sens |
| `j19_pauline_reciprocal_message_01` | `TEXT_MESSAGE` | `ACTIVE`, `RESTRICTED`, `NOT_CREATED` | oui selon le fil | sens seulement ; jamais image principale |
| `j11_raphaelle_chosen_result_01` | `PHOTO` | `PRIVATE_ACTIVE`, `REMOVED`, `INACCESSIBLE` | oui seulement si envoi antérieur | direct si accessible ; sinon absence/sens |
| `j13_raphaelle_masked_version_01` | `PHOTO` | `PRIVATE_ACTIVE`, `REMOVED`, `INACCESSIBLE`, `NOT_CREATED` | oui seulement si Raphaëlle l’a envoyée | direct si accessible ; sinon absence/sens |
| `j19_raphaelle_creative_access_01` | `ACCESS_GRANT` ou `ACCESS_REVOCATION` | `ACTIVE`, `RESTRICTED`, `REMOVED`, `NOT_CREATED` | oui pour l’état d’accès, pas pour une photo | sens seulement |
| `j12_annexe_public_group_set_01` | `PHOTO_SET` | `PUBLIC_ACTIVE`, `NOT_CREATED` | selon groupe photographié nommé | direct selon règles de source ; sinon non-création |
| `j13_nico_alibi_or_hour_message_01` | `TEXT_MESSAGE` | `ACTIVE`, `RESTRICTED`, `INACCESSIBLE`, `NOT_CREATED` | oui dans le fil Player/Nico | sens seulement |
| `j20_nico_exact_hour_record_01` | `FACT_RECORD` | `ACTIVE`, `NOT_CREATED` | connaissance, pas audience photographique | sens seulement |
| `j20_nico_unauthorized_copy_deleted_01` | `ABSENCE_MARKER` | `DELETED`, `NOT_CREATED` | aucune image accessible | absence/sens seulement |

Un type non photographique peut être `eligible_for_j21` dans le registre tout en restant interdit comme image. L’éligibilité permet d’informer la finale ; elle ne change pas le type.

---

## 16. Matrices de configuration complémentaires

### 16.1 Couple J17

| État couple | Famille visuelle J17 | Différence portée par le texte |
|---|---|---|
| `RECONQUEST_ACTIVE` | maintien / négociation | reconquête active et actes cohérents |
| `PROVISIONAL_AGREEMENT` | maintien / négociation | règle provisoire et checkpoint |
| `RECONFIGURATION_NEGOTIATING` | maintien / négociation | autonomie et limites négociées |
| `DOUBLE_LIFE_FRAGILE` | fracture / séparation | portes ouvertes, secret ou participation retirée |
| `FRACTURE` | fracture / séparation | rupture fonctionnelle et distance forte |
| `SEPARATION` | fracture / séparation | séparation dite et organisation matérielle |

### 16.2 J19

| Configuration J19 | Foreground | Relation courte 1 | Relation courte 2 | Nouveau fichier servi |
|---|---|---|---|---:|
| Pauline | C19-01 | Raphaëlle par R04, R09 ou R14 selon état | R02, R10 ou R12 selon la surface réelle | 1 |
| Raphaëlle | C19-02 | Pauline par R02, R12 ou R13 selon état | R04, R09, R10 ou R14 selon le processus réel | 1 |
| Aftercare Sandra | C18-02 variante réutilisée | Pauline par R02, R12 ou R13 | Raphaëlle par R04, R09 ou R14 | 0 |

Les options d’une cellule ne sont pas cumulatives. Une seule réutilisation sert chaque beat.

### 16.3 Service global

| Configuration | J17 | J18 | J19 | J20 | J21 | Nouveaux | Réutilisations | Beats |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| Pauline foreground | 3 N | 2 N + 1 R | 1 N + 2 R | 1 N + 2 R | 3 R | 7 | 8 | 15 |
| Raphaëlle foreground | 3 N | 2 N + 1 R | 1 N + 2 R | 1 N + 2 R | 3 R | 7 | 8 | 15 |
| Aftercare Sandra | 3 N | 2 N + 1 R | 0 N + 3 R | 1 N + 2 R | 3 R | 6 | 9 | 15 |

`N` signifie nouveau contenu servi. `R` signifie contenu déjà produit réutilisé.

---

## 17. Galerie, souvenir, permanence et UI

Pour les huit nouveaux contenus :

```text
gallery_eligibility: conditional
gallery_slot_behavior: deferred
new_visible_tab: false
new_ui_behavior: false
visible_souvenir_tab: false
```

Règles :

- aucune image de scène ne devient une trace ;
- aucune trace ne gagne une audience par présence en Galerie ;
- une trace retirée n’est jamais restaurée pour remplir un slot ;
- aucun onglet visible « Souvenir » ;
- aucune sélection visible de femme, de route ou de trace en J21 ;
- les mêmes `asset_id` restent dédupliqués lorsqu’un contenu est réutilisé ;
- vu, revu, possédé, sauvegardé et transférable restent cinq états distincts.

---

## 18. Contradictions résolues

### 18.1 J21 « À PRODUIRE PLUS TARD »

```text
ancienne_formulation: À PRODUIRE PLUS TARD
nouveau_source_status: REFERENCE_ONLY
production_status: NO_NEW_ASSET
```

Les blocs J21 conservent leur fonction narrative et perdent toute autorisation de production.

### 18.2 T24

```text
nouveau_trace_id: j18_sandra_lunch_print_01
fichier_photographique: réutilisation T01
représentation_physique: comprise dans C18-01
nouveau_fichier_photographique: 0
fichier_enfant: 0
content_id_supplémentaire: 0
fichier_T24_autonome: 0
```

Il n’existe aucun double comptage et aucune copie Player par défaut. C18-01 ne devient jamais T24 ni la trace principale. T24 intervient en J21 uniquement par message, état ou signification et par la réutilisation contrôlée de T01.

### 18.3 T25–T28 comme contexte J21

Leur éligibilité de contexte est subordonnée à la garde de type :

- T25 : message, jamais photo ;
- T26 : accès ou révocation, jamais photo ;
- T27 : fait, jamais photo ;
- T28 : absence, jamais photo.

Ils peuvent guider une autre image admissible ou expliquer son absence.

### 18.4 Absence de trace

```text
absence = état narratif ou représentation existante
absence != asset autonome
```

Une absence peut être portée par un emplacement vide, un message existant, une scène déjà produite ou une autre trace contrôlée. Aucun fichier absent n’est recréé.

### 18.5 Galerie / souvenir

Les propositions de Galerie ou de souvenir restent :

```text
source_status: REFERENCE_ONLY
new_ui_behavior: false
visible_souvenir_tab: false
```

### 18.6 J19 catalogue contre service

C19-01 et C19-02 sont deux contenus de catalogue alternatifs. Une partie standard n’en sert qu’un comme nouveau foreground. La configuration aftercare n’en sert aucun comme nouveau foreground.

### 18.7 Comptage aftercare

La variante C18-02 :

- est produite et comptée en J18 ;
- remplace la version standard dans la partie concernée ;
- est réutilisée en J19 ;
- ne produit aucun nouveau fichier J19.

La configuration passe ainsi de `7 N + 8 R` à `6 N + 9 R` sans modifier les quinze beats.

---

## 19. Fallbacks et fermetures

### 19.1 J17

Si P18 n’est pas `ACTIVE`, le paquet n’invente aucune conversation Marie. Le couple reçoit son état par la présence, la distance, la définition unilatérale permise ou les conséquences signées.

### 19.2 J18

Si T24 est `NOT_CREATED`, Sandra peut garder le souvenir, la relation, le désir ou une limite sans impression. C18-01 représente alors son choix avec le livre, l’enveloppe ou le fil, sans inventer de photographie.

Si l’intimité tardive n’est pas éligible, C18-02 standard est utilisée. Aucun contenu adulte compensatoire n’est ajouté.

### 19.3 J19

Si une relation ne peut pas être foreground, l’autre configuration signée ou une direction courte existante est utilisée. Aucune comparaison visible et aucun menu de sélection.

L’aftercare Sandra domine seulement si l’intimité J18 a réellement eu lieu.

### 19.4 J20

P23 est créée à la proposition précise de Nico, le J20 à 18 h 57. Si Player refuse, la fiche passe à `REFUSED`, aucune attente ne subsiste et Nico conserve un état d’amitié cohérent sans pénalité automatique. P23 ne devient `ACTIVE` qu’après acceptation. Si aucune conséquence forte n’est admissible, le troisième beat utilise un retour ordinaire existant.

T28 `NOT_CREATED` signifie qu’aucune copie non autorisée n’a existé ; aucune suppression dramatique n’est inventée.

### 19.5 J21

Si la trace prioritaire est absente, retirée ou inaccessible :

1. son absence garde le sens ;
2. une scène existante peut montrer la vie autour de cette absence ;
3. une autre trace photographique admissible peut être sélectionnée ;
4. aucun nouveau fichier ne comble le manque.

---

## 20. Checklist finale

### 20.1 Baseline et périmètre

- [x] baseline exacte `f6c4cec28b5574937715b090666a6e9014e0327a` ;
- [x] sources canoniques relues à cette référence ;
- [x] aucun dialogue réécrit ;
- [x] aucun runtime, JSON, test, UI ou asset modifié.

### 20.2 Service et catalogue

- [x] quinze beats par partie ;
- [x] huit nouveaux contenus principaux ;
- [x] quatorze réutilisations historiques distinctes dans le pool ;
- [x] C09-03 et C09-04 appartiennent au pool sous R03 et R05 ;
- [x] l’ancienne R03 Mathilde J06 est retirée ;
- [x] l’ancienne R05 foyer J08 est retirée ;
- [x] les réutilisations intra-acte C17–C20 restent distinctes du pool historique ;
- [x] le pool n’est pas présenté comme intégralement servi ;
- [x] configuration standard : sept nouveaux, huit réutilisations, quinze beats ;
- [x] configuration aftercare : six nouveaux, neuf réutilisations, quinze beats.

### 20.3 Fichiers

- [x] dix nouveaux fichiers ;
- [x] J17 : quatre ;
- [x] J18 : trois ;
- [x] J19 : deux ;
- [x] J20 : un ;
- [x] J21 : zéro ;
- [x] zéro fichier enfant ;
- [x] deux variantes ;
- [x] aucune autre variante de fichier.

### 20.4 Traces

- [x] T24 n’est pas un neuvième contenu ;
- [x] T24 réutilise T01 ;
- [x] C18-01 ne devient jamais T24 ni la trace principale ;
- [x] T24 intervient par sens ou message et par réutilisation T01 ;
- [x] aucun fichier T24 autonome ;
- [x] T24 n’élargit pas automatiquement l’audience ;
- [x] T23, T25, T26, T27 et T28 créent zéro fichier ;
- [x] aucun `FACT_RECORD` ou `ACCESS_GRANT` transformé en image ;
- [x] T28 montre seulement l’absence ;
- [x] aucune restauration de fichier.

### 20.5 Personnages et configurations

- [x] aucune photographie sexuelle Sandra ;
- [x] aftercare Sandra servi sans nouveau fichier J19 ;
- [x] aucune image intime de consolation ;
- [x] C19-01 et C19-02 jamais servis ensemble comme deux foregrounds ;
- [x] aucune matrice Mathilde × foyer × couple ;
- [x] aucune variante par état Nico ;
- [x] P23 créée à la proposition précise de Nico, le J20 à 18 h 57 ;
- [x] P23 activée seulement par l’acceptation de Player ;
- [x] P23 peut exister en `REFUSED` après un refus ;
- [x] refus P23 sans attente et sans dégradation automatique ;
- [x] rencontre tenue vers `PAID` ;
- [x] annulation explicite vers `CANCELLED`.

### 20.6 J21 et Galerie

- [x] zéro nouveau contenu J21 ;
- [x] zéro nouvelle trace J21 ;
- [x] zéro nouvelle photographie J21 ;
- [x] anciennes propositions J21 reclassées `REFERENCE_ONLY` / `NO_NEW_ASSET` ;
- [x] garde de type appliquée ;
- [x] aucune sélection visible ;
- [x] aucune restauration ;
- [x] aucun nouvel onglet Galerie ;
- [x] aucun onglet visible « Souvenir » ;
- [x] `gallery_eligibility` vaut `conditional` pour C17-01 à C20-01 ;
- [x] aucune éligibilité Galerie n’emploie le statut documentaire `REFERENCE_ONLY`.

### 20.7 R13

- [x] R13 distingue `content_id`, `catalogue_asset_id` et `source_file_id` ;
- [x] R13 conserve son `parent_content_id` et son `parent_asset_id` ;
- [x] R13 produit zéro nouveau fichier, zéro nouvel enfant et zéro nouvelle dérivation.

---

## 21. Comptages finaux

| Mesure | Valeur attendue | Valeur NAR-PROD-06 | Contrôle |
|---|---:|---:|---|
| Beats servis par partie | 15 | 15 | PASS |
| Nouveaux contenus principaux | 8 | 8 | PASS |
| Réutilisations historiques distinctes disponibles | 14 | 14 | PASS |
| Nouveaux fichiers sources | 10 | 10 | PASS |
| Fichiers enfants | 0 | 0 | PASS |
| Variantes conditionnelles | 2 | 2 | PASS |
| Nouveaux fichiers J21 | 0 | 0 | PASS |
| Nouveau `content_id` pour T24 | 0 | 0 | PASS |
| Fichiers T23, T25, T26, T27, T28 | 0 | 0 | PASS |

### 21.1 Résumé exact des décisions

```text
CATALOGUE
8 nouveaux contenus principaux
14 réutilisations historiques distinctes disponibles
10 nouveaux fichiers
0 fichier enfant
2 variantes

SERVICE STANDARD
7 nouveaux contenus servis
8 réutilisations servies
15 beats

SERVICE AFTERCARE SANDRA
6 nouveaux contenus servis
9 réutilisations servies
15 beats

J17
3 contenus
4 fichiers
1 variante locale du couple

J18
2 contenus
3 fichiers
1 variante locale Sandra
T24 réutilise T01

J19
2 contenus de catalogue
2 fichiers
1 seul foreground nouveau servi en standard
0 nouveau foreground en aftercare

J20
1 contenu
1 fichier
2 réutilisations servies

J21
3 beats
0 contenu
0 fichier
0 variante
0 trace
0 photographie
```

---

## 22. Verdict final

```text
J17: READY
J18: READY
J19: READY
J20: READY
J21: READY

NAR-PROD-06: READY
VALIDATION PRODUIT: PASS
DECISIONS RESTANT A LUDOVIC: AUCUNE
```

Le paquet est prêt pour la production documentaire et visuelle de l’Acte V dans les limites fixées ci-dessus.