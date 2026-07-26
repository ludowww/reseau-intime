# ASSET-01 — Manifeste de production visuelle Saison 1 — 84 fichiers

```text
Catégorie :
manifeste actif de production visuelle dérivé du canon signé

Statut :
ACTIVE_CANON pour l’identité, le comptage, l’ordre et le statut
des fichiers physiques à produire

Périmètre :
Saison 1, J01–J21, 84 fichiers

Autorité :
liste globale des fichiers et métadonnées de production

Ne fait pas autorité sur :
dialogues
apparence des personnages
composition détaillée
consentement
audience narrative
états de relation
runtime
workflow de génération

Base validée :
0820d87dc86b94a6a9fd133823fcd4258eab39ae
```

ASSET-01 ne supersède aucun paquet NAR-PROD.

```text
scripts et registres
→ vérité narrative

NAR-PROD-02 à NAR-PROD-06
→ brief et classification détaillés

ASSET-01
→ ordre global, inventaire physique et statut de production
```

## Extraction et règles de registre

Les identifiants et leur ordre proviennent exclusivement des manifestes finaux de `NAR-PROD-02` à `NAR-PROD-06`. Les répétitions dans les briefs, matrices, exemples, addenda, scripts et registres ne sont pas recomptées. Chaque ligne représente un fichier physique : aucun parent logique supplémentaire, aucune réutilisation, aucune trace non visuelle et aucun fichier J21.

Valeurs de `file_role` : `BASE`, `SET_CHILD`, `SEQUENCE_CHILD`, `VARIANT`.

Valeurs de `content_type` : `PHOTO_DIÉGÉTIQUE`, `PHOTO_SET_DIÉGÉTIQUE`, `SOUVENIR_IMAGE_DE_SCÈNE`.

Valeurs de `branch_gate` : `ALWAYS_IF_DAY_REACHED`, `CONDITIONAL`, `MUTUALLY_EXCLUSIVE`, `ADULT_CONDITIONAL`.

Le champ `continuity_group` ne crée aucune apparence, tenue ou géographie nouvelle. Le détail complet reste dans la source indiquée.

## Comptage autoritatif par acte de production

```text
001–015 → Acte I
016–029 → Acte II
030–059 → Acte III
060–071 → Acte IV
072–084 → Acte V
```

Le marqueur `_A1_` à `_A5_` inclus dans un `asset_id` décrit sa filiation documentaire historique.

Il ne constitue pas une source fiable pour déterminer l’acte dans lequel le fichier physique est produit.

L’acte de production est déterminé exclusivement par :

1. le manifeste NAR-PROD dont la ligne est extraite ;
2. la table d’acte dans ASSET-01 ;
3. la plage du numéro global.

Cas canonique volontaire :

```text
S1_A3_J12_DPH_PAULINE_BASTIEN_ANNEXE_01_FRAME_04_PRIVATE
```

- conserve son identifiant `_A3_J12_` ;
- dérive du parent C12-03 créé en Acte III ;
- est un nouveau fichier enfant produit et compté en Acte IV ;
- occupe la première ligne de l’Acte IV dans ASSET-01 ;
- ne doit jamais être renommé en `_A4_`.

Les totaux par acte sont validés par les plages globales, jamais par une expression régulière appliquée aux `asset_id`.

## Statut initial commun

```text
production_status: SPECIFIED_NOT_PRODUCED
```

Aucune ligne n’est `GENERATED`, `SELECTED`, `QA_APPROVED` ou `INTEGRATED`. Aucun fichier physique correspondant n’est produit dans ce lot.

## Acte I — J01–J04

| # global | asset_id | jour | content_ref | file_role | content_type | sujet principal | branch_gate | trace_id | gallery_group | continuity_group | production_wave | source exacte |
|---:|---|---|---|---|---|---|---|---|---|---|---|---|
| 001 | `S1_A1_J01_SCN_MARIE_SHARED_KITCHEN_01` | J01 | `J01-01` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie | `ALWAYS_IF_DAY_REACHED` — ouverture Marie | `none` | `J01-01` | character:Marie; location:appartement | `W1` | NAR-PROD-02 §5.10 |
| 002 | `S1_A1_J01_DPH_SANDRA_LUNCH_SELECTED_01` | J01 | `J01-02` | `BASE` | `PHOTO_DIÉGÉTIQUE` | Sandra | `ALWAYS_IF_DAY_REACHED` — envoi J01 | `j01_sandra_lunch_memory_soft` | `J01-02` | character:Sandra | `W1` | NAR-PROD-02 §5.11 |
| 003 | `S1_A1_J01_SCN_MARIE_EVENING_RETURN_01` | J01 | `J01-03` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie | `ALWAYS_IF_DAY_REACHED` — retour du soir | `none` | `J01-03` | character:Marie; location:appartement | `W1` | NAR-PROD-02 §5.12 |
| 004 | `S1_A1_J02_SCN_MATHILDE_FIRST_INSTALLED_VIEW_01` | J02 | `J02-01` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Mathilde | `ALWAYS_IF_DAY_REACHED` — installation atteinte | `none` | `J02-01` | character:Mathilde; location:appartement | `W1` | NAR-PROD-02 §6.11 |
| 005 | `S1_A1_J02_SCN_MARIE_HOLDS_HOUSEHOLD_01` | J02 | `J02-02` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie | `ALWAYS_IF_DAY_REACHED` — Marie tient le foyer | `none` | `J02-02` | character:Marie; location:appartement | `W1` | NAR-PROD-02 §6.12 |
| 006 | `S1_A1_J02_SCN_FIRST_SHARED_EVENING_01` | J02 | `J02-03` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie + Mathilde | `ALWAYS_IF_DAY_REACHED` — première soirée partagée | `none` | `J02-03` | character:Marie; character:Mathilde; location:appartement | `W1` | NAR-PROD-02 §6.13 |
| 007 | `S1_A1_J03_SCN_RAPHAELLE_ACCESSIBILITY_REVIEW_01` | J03 | `J03-01` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Raphaëlle | `ALWAYS_IF_DAY_REACHED` — revue accessibilité | `none` | `J03-01` | character:Raphaëlle; location:La Verrière | `W1` | NAR-PROD-02 §7.11 |
| 008 | `S1_A1_J03_SCN_RAPHAELLE_GARMENT_BAG_01` | J03 | `J03-02` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Raphaëlle | `ALWAYS_IF_DAY_REACHED` — garment bag visible | `none` | `J03-02` | character:Raphaëlle; location:La Verrière | `W1` | NAR-PROD-02 §7.12 |
| 009 | `S1_A1_J03_SCN_MARIE_HOME_FROM_LAVERRIERE_01` | J03 | `J03-03` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie | `ALWAYS_IF_DAY_REACHED` — retour La Verrière | `none` | `J03-03` | character:Marie; location:appartement; location:La Verrière | `W1` | NAR-PROD-02 §7.13 |
| 010 | `S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01_FRAME_01` | J04 | `J04-01` | `SET_CHILD` | `PHOTO_SET_DIÉGÉTIQUE` | Pauline + Bastien + Marie | `ALWAYS_IF_DAY_REACHED` — frame obligatoire | `j04_pauline_bastien_public_set_01` | `J04-01` | character:Pauline; character:Bastien; character:Marie; set:J04-01 | `W1` | NAR-PROD-02 §8.11 manifeste du set |
| 011 | `S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01_FRAME_02` | J04 | `J04-01` | `SET_CHILD` | `PHOTO_SET_DIÉGÉTIQUE` | Pauline + Bastien + Marie | `ALWAYS_IF_DAY_REACHED` — frame obligatoire | `j04_pauline_bastien_public_set_01` | `J04-01` | character:Pauline; character:Bastien; character:Marie; set:J04-01 | `W1` | NAR-PROD-02 §8.11 manifeste du set |
| 012 | `S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01_FRAME_03` | J04 | `J04-01` | `SET_CHILD` | `PHOTO_SET_DIÉGÉTIQUE` | Pauline + Bastien + Marie | `ALWAYS_IF_DAY_REACHED` — frame obligatoire | `j04_pauline_bastien_public_set_01` | `J04-01` | character:Pauline; character:Bastien; character:Marie; set:J04-01 | `W1` | NAR-PROD-02 §8.11 manifeste du set |
| 013 | `S1_A1_J04_SCN_MARIE_SOCIAL_MOTION_01` | J04 | `J04-02` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie + Pauline + Bastien | `ALWAYS_IF_DAY_REACHED` — mouvement social | `none` | `J04-02` | character:Marie; character:Pauline; character:Bastien | `W1` | NAR-PROD-02 §8.12 |
| 014 | `S1_A1_J04_SCN_NICO_SAVED_SEAT_01` | J04 | `J04-03` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Nico | `ALWAYS_IF_DAY_REACHED` — place gardée | `none` | `J04-03` | character:Nico; location:L’Annexe | `W1` | NAR-PROD-02 §8.13 |
| 015 | `S1_A1_J04_SCN_HOUSEHOLD_THREE_RHYTHM_01` | J04 | `J04-04` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie + Mathilde | `ALWAYS_IF_DAY_REACHED` — rythme du foyer | `none` | `J04-04` | character:Marie; character:Mathilde; location:appartement | `W1` | NAR-PROD-02 §8.14 |

## Acte II — J05–J08

| # global | asset_id | jour | content_ref | file_role | content_type | sujet principal | branch_gate | trace_id | gallery_group | continuity_group | production_wave | source exacte |
|---:|---|---|---|---|---|---|---|---|---|---|---|---|
| 016 | `S1_A2_J05_SCN_MARIE_REAL_HOUR_01` | J05 | `J05-N01` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie | `ALWAYS_IF_DAY_REACHED` — beat Marie servi | `none` | `J05-N01` | character:Marie | `W1` | NAR-PROD-03 §12 manifeste |
| 017 | `S1_A2_J05_SCN_MARIE_SATURDAY_CONTINUES_01` | J05 | `J05-N02` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie | `CONDITIONAL` — aucune continuité extérieure | `none` | `J05-N02` | character:Marie | `W1` | NAR-PROD-03 §12 manifeste |
| 018 | `S1_A2_J06_SCN_MATHILDE_LOOK_ACKNOWLEDGED_01` | J06 | `J06-N01` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Mathilde | `CONDITIONAL` — Mathilde éligible | `none` | `J06-N01` | character:Mathilde; location:appartement | `W1` | NAR-PROD-03 §12 manifeste |
| 019 | `S1_A2_J06_SCN_SUNDAY_WITHOUT_EXTERNAL_PROGRESS_01` | J06 | `J06-N02` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie / foyer | `CONDITIONAL` — aucune continuité extérieure | `none` | `J06-N02` | character:Marie; location:appartement | `W1` | NAR-PROD-03 §12 manifeste |
| 020 | `S1_A2_J06_SCN_MARIE_CONCRETE_RETURN_01` | J06 | `J06-N03` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie | `ALWAYS_IF_DAY_REACHED` — retour concret | `none` | `J06-N03` | character:Marie; location:appartement | `W1` | NAR-PROD-03 §12 manifeste |
| 021 | `S1_A2_J07_SCN_RAPHAELLE_MOBILE_REVIEW_DUE_01` | J07 | `J07-N01` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Raphaëlle | `ALWAYS_IF_DAY_REACHED` — obligation mobile | `none` | `J07-N01` | character:Raphaëlle | `W1` | NAR-PROD-03 §12 manifeste |
| 022 | `S1_A2_J07_SCN_NICO_AFTER_SERVICE_CONFIDENCE_01` | J07 | `J07-N02` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Nico | `ALWAYS_IF_DAY_REACHED` — confidence après service | `none` | `J07-N02` | character:Nico; location:L’Annexe | `W1` | NAR-PROD-03 §12 manifeste |
| 023 | `S1_A2_J07_SCN_MARIE_HOUSEHOLD_REQUEST_01` | J07 | `J07-N03` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie | `ALWAYS_IF_DAY_REACHED` — demande foyer | `none` | `J07-N03` | character:Marie; location:appartement | `W1` | NAR-PROD-03 §12 manifeste |
| 024 | `S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01_PAID` | J08 | `J08-N01` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Raphaëlle | `MUTUALLY_EXCLUSIVE` — P05 payée | `none` | `J08-N01` | character:Raphaëlle | `W1` | NAR-PROD-03 §12 manifeste |
| 025 | `S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01_TAKEN_OVER` | J08 | `J08-N01` | `VARIANT` | `SOUVENIR_IMAGE_DE_SCÈNE` | Raphaëlle | `MUTUALLY_EXCLUSIVE` — travail repris | `none` | `J08-N01` | character:Raphaëlle | `W1` | NAR-PROD-03 §12 manifeste |
| 026 | `S1_A2_J08_SCN_NICO_CHAIR_STATE_01_PAID` | J08 | `J08-N02` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Nico | `MUTUALLY_EXCLUSIVE` — présence payée | `none` | `J08-N02` | character:Nico; location:L’Annexe | `W1` | NAR-PROD-03 §12 manifeste |
| 027 | `S1_A2_J08_SCN_NICO_CHAIR_STATE_01_NO_WAIT` | J08 | `J08-N02` | `VARIANT` | `SOUVENIR_IMAGE_DE_SCÈNE` | Nico | `MUTUALLY_EXCLUSIVE` — aucune attente | `none` | `J08-N02` | character:Nico; location:L’Annexe | `W1` | NAR-PROD-03 §12 manifeste |
| 028 | `S1_A2_J08_SCN_HOUSEHOLD_STATE_01_PAID` | J08 | `J08-N03` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie / foyer | `MUTUALLY_EXCLUSIVE` — aide accomplie | `none` | `J08-N03` | character:Marie; character:Mathilde; location:appartement | `W1` | NAR-PROD-03 §12 manifeste |
| 029 | `S1_A2_J08_SCN_HOUSEHOLD_STATE_01_AUTONOMOUS` | J08 | `J08-N03` | `VARIANT` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie / foyer | `MUTUALLY_EXCLUSIVE` — foyer autonome | `none` | `J08-N03` | character:Marie; character:Mathilde; location:appartement | `W1` | NAR-PROD-03 §12 manifeste |

## Acte III — J09–J12

| # global | asset_id | jour | content_ref | file_role | content_type | sujet principal | branch_gate | trace_id | gallery_group | continuity_group | production_wave | source exacte |
|---:|---|---|---|---|---|---|---|---|---|---|---|---|
| 030 | `S1_A3_J09_SCN_LAVERRIERE_INSTALLATION_01` | J09 | `C09-01` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie / La Verrière | `ALWAYS_IF_DAY_REACHED` — installation | `none` | `C09-01` | character:Marie; location:La Verrière | `W2` | NAR-PROD-04 §13.1 manifeste |
| 031 | `S1_A3_J09_DPH_MARIE_BLACK_DRESS_PRIVATE_01` | J09 | `C09-02` | `BASE` | `PHOTO_DIÉGÉTIQUE` | Marie | `ALWAYS_IF_DAY_REACHED` — robe privée choisie | `j09_marie_black_dress_private_01` | `C09-02` | character:Marie; location:La Verrière | `W2` | NAR-PROD-04 §13.1 manifeste |
| 032 | `S1_A3_J09_DPH_MARIE_LAVERRIERE_PUBLIC_01` | J09 | `C09-03` | `BASE` | `PHOTO_DIÉGÉTIQUE` | Marie | `ALWAYS_IF_DAY_REACHED` — source publique | `j09_marie_laverriere_public_01` | `C09-03` | character:Marie; location:La Verrière | `W2` | NAR-PROD-04 §13.1 manifeste |
| 033 | `S1_A3_J09_DPH_MARIE_LAVERRIERE_AFTER_01` | J09 | `C09-04` | `BASE` | `PHOTO_DIÉGÉTIQUE` | Marie | `CONDITIONAL` — créée et relayée | `j09_marie_laverriere_after_01` | `C09-04` | character:Marie; location:La Verrière | `W2` | NAR-PROD-04 §13.1 manifeste |
| 034 | `S1_A3_J10_SCN_SANDRA_CAFE_HELD_01` | J10 | `C10-01` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Sandra | `MUTUALLY_EXCLUSIVE` — pivot Sandra, café tenu | `none` | `C10-01` | character:Sandra; location:café | `W2` | NAR-PROD-04 §13.2 manifeste |
| 035 | `S1_A3_J10_DPH_MATHILDE_OUTFIT_CHOICE_01` | J10 | `C10-02` | `BASE` | `PHOTO_DIÉGÉTIQUE` | Mathilde | `MUTUALLY_EXCLUSIVE` — pivot Mathilde | `j10_mathilde_outfit_choice_01` | `C10-02` | character:Mathilde | `W2` | NAR-PROD-04 §13.2 manifeste |
| 036 | `S1_A3_J10_SCN_MATHILDE_SOCIAL_RESULT_01` | J10 | `C10-03` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Mathilde | `MUTUALLY_EXCLUSIVE` — pivot Mathilde | `none` | `C10-03` | character:Mathilde | `W2` | NAR-PROD-04 §13.2 manifeste |
| 037 | `S1_A3_J10_DPH_RAPHAELLE_PROCESS_DETAIL_01` | J10 | `C10-04` | `BASE` | `PHOTO_DIÉGÉTIQUE` | Raphaëlle | `MUTUALLY_EXCLUSIVE` — pivot Raphaëlle R-A | `none` | `C10-04` | character:Raphaëlle | `W2` | NAR-PROD-04 §13.2 manifeste |
| 038 | `S1_A3_J10_DPH_RAPHAELLE_PROCESS_COMPARISON_02` | J10 | `C10-05` | `BASE` | `PHOTO_DIÉGÉTIQUE` | Raphaëlle | `MUTUALLY_EXCLUSIVE` — branche R-A | `none` | `C10-05` | character:Raphaëlle | `W2` | NAR-PROD-04 §13.2 manifeste |
| 039 | `S1_A3_J10_DPH_ANNEXE_MARIE_PUBLIC_01` | J10 | `C10-06` | `BASE` | `PHOTO_DIÉGÉTIQUE` | Marie | `MUTUALLY_EXCLUSIVE` — pivot Nico | `none` | `C10-06` | character:Marie; location:L’Annexe | `W2` | NAR-PROD-04 §13.2 manifeste |
| 040 | `S1_A3_J10_DPH_ANNEXE_MATHILDE_PUBLIC_01` | J10 | `C10-07` | `BASE` | `PHOTO_DIÉGÉTIQUE` | Mathilde | `MUTUALLY_EXCLUSIVE` — pivot Nico | `none` | `C10-07` | character:Mathilde; location:L’Annexe | `W2` | NAR-PROD-04 §13.2 manifeste |
| 041 | `S1_A3_J11_DPH_SANDRA_CHOSEN_IMAGE_01` | J11 | `C11-01` | `BASE` | `PHOTO_DIÉGÉTIQUE` | Sandra | `MUTUALLY_EXCLUSIVE` — continuation Sandra | `j11_sandra_chosen_image_01` | `C11-01` | character:Sandra | `W2` | NAR-PROD-04 §13.3 manifeste |
| 042 | `S1_A3_J11_SCN_SANDRA_IMAGE_CONSEQUENCE_01` | J11 | `C11-02` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Sandra | `MUTUALLY_EXCLUSIVE` — conséquence Sandra | `none` | `C11-02` | character:Sandra | `W2` | NAR-PROD-04 §13.3 manifeste |
| 043 | `S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01_PROXIMITY` | J11 | `C11-03` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Mathilde | `MUTUALLY_EXCLUSIVE` — proximité maintenue | `none` | `MATHILDE_J11_SECRET_INTIMACY` | character:Mathilde; sequence:MATHILDE_J11_SECRET_INTIMACY | `W2` | NAR-PROD-04 §13.3 manifeste |
| 044 | `S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01_DISTANCE` | J11 | `C11-03` | `VARIANT` | `SOUVENIR_IMAGE_DE_SCÈNE` | Mathilde | `MUTUALLY_EXCLUSIVE` — distance restaurée | `none` | `C11-03` | character:Mathilde | `W2` | NAR-PROD-04 §13.3 manifeste |
| 045 | `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_CENTRAL_01` | J11 | `C11-03` | `SEQUENCE_CHILD` | `SOUVENIR_IMAGE_DE_SCÈNE` | Mathilde | `ADULT_CONDITIONAL` — M-B3 éligible et consentement actuel | `none` | `MATHILDE_J11_SECRET_INTIMACY` | character:Mathilde; sequence:MATHILDE_J11_SECRET_INTIMACY | `WA` | NAR-PROD-04 §13.3 manifeste |
| 046 | `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_AFTERCARE_01` | J11 | `C11-03` | `SEQUENCE_CHILD` | `SOUVENIR_IMAGE_DE_SCÈNE` | Mathilde | `ADULT_CONDITIONAL` — payoff servi, aftercare dû | `none` | `MATHILDE_J11_SECRET_INTIMACY` | character:Mathilde; sequence:MATHILDE_J11_SECRET_INTIMACY | `WA` | NAR-PROD-04 §13.3 manifeste |
| 047 | `S1_A3_J11_DPH_RAPHAELLE_CHOSEN_RESULT_01` | J11 | `C11-04` | `BASE` | `PHOTO_DIÉGÉTIQUE` | Raphaëlle | `MUTUALLY_EXCLUSIVE` — résultat réellement envoyé | `j11_raphaelle_chosen_result_01` | `C11-04` | character:Raphaëlle | `W2` | NAR-PROD-04 §13.3 manifeste |
| 048 | `S1_A3_J11_SCN_NICO_PREPARE_J12_01` | J11 | `C11-05` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Nico | `MUTUALLY_EXCLUSIVE` — continuation Nico | `none` | `C11-05` | character:Nico; location:L’Annexe | `W2` | NAR-PROD-04 §13.3 manifeste |
| 049 | `S1_A3_J11_SCN_MARIE_COUPLE_STATE_01_RECONNECTION` | J11 | `C11-06` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie | `MUTUALLY_EXCLUSIVE` — reconquête crédible | `none` | `MARIE_J11_RECONQUEST` | character:Marie; sequence:MARIE_J11_RECONQUEST | `W2` | NAR-PROD-04 §13.3 manifeste |
| 050 | `S1_A3_J11_SCN_MARIE_COUPLE_STATE_01_LIMIT` | J11 | `C11-06` | `VARIANT` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie | `MUTUALLY_EXCLUSIVE` — limite ou distance | `none` | `C11-06` | character:Marie | `W2` | NAR-PROD-04 §13.3 manifeste |
| 051 | `S1_A3_J11_SCN_MARIE_RECONQUEST_ADULT_PAYOFF_01` | J11 | `C11-06` | `SEQUENCE_CHILD` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie | `ADULT_CONDITIONAL` — reconquête et consentement actuels | `none` | `MARIE_J11_RECONQUEST` | character:Marie; sequence:MARIE_J11_RECONQUEST | `WA` | NAR-PROD-04 §13.3 manifeste |
| 052 | `S1_A3_J11_SCN_MARIE_RECONQUEST_AFTERCARE_01` | J11 | `C11-06` | `SEQUENCE_CHILD` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie | `ADULT_CONDITIONAL` — payoff servi, aftercare dû | `none` | `MARIE_J11_RECONQUEST` | character:Marie; sequence:MARIE_J11_RECONQUEST | `WA` | NAR-PROD-04 §13.3 manifeste |
| 053 | `S1_A3_J12_DPH_MARIE_LAVERRIERE_PRO_01` | J12 | `C12-01` | `BASE` | `PHOTO_DIÉGÉTIQUE` | Marie | `ALWAYS_IF_DAY_REACHED` — visibilité professionnelle | `none` | `C12-01` | character:Marie; location:La Verrière | `W2` | NAR-PROD-04 §13.4 manifeste |
| 054 | `S1_A3_J12_DPH_LAVERRIERE_PUBLIC_GROUP_SET_01_FRAME_01` | J12 | `C12-02` | `SET_CHILD` | `PHOTO_SET_DIÉGÉTIQUE` | Groupe La Verrière | `ALWAYS_IF_DAY_REACHED` — casting réel | `j12_laverriere_public_group_set_01` | `C12-02` | location:La Verrière; set:C12-02 | `W2` | NAR-PROD-04 §13.4 manifeste |
| 055 | `S1_A3_J12_DPH_LAVERRIERE_PUBLIC_GROUP_SET_01_FRAME_02` | J12 | `C12-02` | `SET_CHILD` | `PHOTO_SET_DIÉGÉTIQUE` | Groupe La Verrière | `ALWAYS_IF_DAY_REACHED` — casting réel | `j12_laverriere_public_group_set_01` | `C12-02` | location:La Verrière; set:C12-02 | `W2` | NAR-PROD-04 §13.4 manifeste |
| 056 | `S1_A3_J12_DPH_LAVERRIERE_PUBLIC_GROUP_SET_01_FRAME_03` | J12 | `C12-02` | `SET_CHILD` | `PHOTO_SET_DIÉGÉTIQUE` | Groupe La Verrière | `ALWAYS_IF_DAY_REACHED` — casting réel | `j12_laverriere_public_group_set_01` | `C12-02` | location:La Verrière; set:C12-02 | `W2` | NAR-PROD-04 §13.4 manifeste |
| 057 | `S1_A3_J12_DPH_LAVERRIERE_PUBLIC_GROUP_SET_01_FRAME_04` | J12 | `C12-02` | `SET_CHILD` | `PHOTO_SET_DIÉGÉTIQUE` | Groupe La Verrière | `ALWAYS_IF_DAY_REACHED` — casting réel | `j12_laverriere_public_group_set_01` | `C12-02` | location:La Verrière; set:C12-02 | `W2` | NAR-PROD-04 §13.4 manifeste |
| 058 | `S1_A3_J12_DPH_PAULINE_BASTIEN_ANNEXE_01` | J12 | `C12-03` | `BASE` | `PHOTO_DIÉGÉTIQUE` | Pauline + Bastien | `CONDITIONAL` — accès L’Annexe légitime | `none` | `C12-03` | character:Pauline; character:Bastien; location:L’Annexe | `W2` | NAR-PROD-04 §13.4 manifeste |
| 059 | `S1_A3_J12_DPH_ANNEXE_SOCIAL_POSITIONS_SET_01_FRAME_01` | J12 | `C12-04` | `SET_CHILD` | `PHOTO_SET_DIÉGÉTIQUE` | Groupe L’Annexe | `CONDITIONAL` — T15 créée et autorisée | `j12_annexe_public_group_set_01` | `C12-04` | location:L’Annexe; set:C12-04 | `W2` | NAR-PROD-04 §13.4 manifeste |

## Acte IV — J13–J16

| # global | asset_id | jour | content_ref | file_role | content_type | sujet principal | branch_gate | trace_id | gallery_group | continuity_group | production_wave | source exacte |
|---:|---|---|---|---|---|---|---|---|---|---|---|---|
| 060 | `S1_A3_J12_DPH_PAULINE_BASTIEN_ANNEXE_01_FRAME_04_PRIVATE` | J13 | `C13-01` | `SET_CHILD` | `PHOTO_SET_DIÉGÉTIQUE` | Pauline | `MUTUALLY_EXCLUSIVE` — version privée créée et envoyée | `j13_pauline_private_version_01` | `C13-01` | character:Pauline; location:L’Annexe; set:C12-03 | `W3` | NAR-PROD-05 §15 manifeste |
| 061 | `S1_A4_J13_DPH_RAPHAELLE_MASKED_POSTURE_01` | J13 | `C13-02` | `BASE` | `PHOTO_DIÉGÉTIQUE` | Raphaëlle | `MUTUALLY_EXCLUSIVE` — prise sélectionnée | `j13_raphaelle_masked_version_01` | `C13-02` | character:Raphaëlle; set:C13-02 | `W3` | NAR-PROD-05 §15 manifeste |
| 062 | `S1_A4_J13_DPH_RAPHAELLE_MASKED_ADULT_SELECTED_01` | J13 | `C13-02` | `SEQUENCE_CHILD` | `PHOTO_DIÉGÉTIQUE` | Raphaëlle | `ADULT_CONDITIONAL` — branche adulte et sélection explicite | `j13_raphaelle_masked_adult_selected_01` | `C13-02` | character:Raphaëlle; sequence:RAPHAELLE_J13_MASKED | `WA` | NAR-PROD-05 §15 manifeste |
| 063 | `S1_A4_J14_SCN_MARIE_LIMITED_DISCOVERY_01` | J14 | `C14-01` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie | `MUTUALLY_EXCLUSIVE` — Marie témoin légitime | `none` | `C14-01` | character:Marie | `W3` | NAR-PROD-05 §15 manifeste |
| 064 | `S1_A4_J14_SCN_MATHILDE_LIMITED_DISCOVERY_01` | J14 | `C14-02` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Mathilde | `MUTUALLY_EXCLUSIVE` — Mathilde témoin légitime | `none` | `C14-02` | character:Mathilde | `W3` | NAR-PROD-05 §15 manifeste |
| 065 | `S1_A4_J15_SCN_MARIE_AUTONOMOUS_PRIORITY_01` | J15 | `C15-01` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie | `CONDITIONAL` — Marie non servie | `none` | `C15-01` | character:Marie | `W3` | NAR-PROD-05 §15 manifeste |
| 066 | `S1_A4_J15_SCN_SANDRA_AUTONOMOUS_WINDOW_01` | J15 | `C15-02` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Sandra | `CONDITIONAL` — Sandra non servie | `none` | `C15-02` | character:Sandra | `W3` | NAR-PROD-05 §15 manifeste |
| 067 | `S1_A4_J15_SCN_MATHILDE_AUTONOMOUS_HOUSEHOLD_01` | J15 | `C15-03` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Mathilde | `CONDITIONAL` — Mathilde non servie | `none` | `C15-03` | character:Mathilde; location:appartement | `W3` | NAR-PROD-05 §15 manifeste |
| 068 | `S1_A4_J15_SCN_PAULINE_AUTONOMOUS_VERSION_01` | J15 | `C15-04` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Pauline | `CONDITIONAL` — Pauline non servie | `none` | `C15-04` | character:Pauline | `W3` | NAR-PROD-05 §15 manifeste |
| 069 | `S1_A4_J16_SCN_MATHILDE_DEPARTURE_PREPARATION_01_ORDINARY` | J16 | `C16-01` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Mathilde | `MUTUALLY_EXCLUSIVE` — préparation ordinaire | `none` | `C16-01` | character:Mathilde; location:appartement | `W3` | NAR-PROD-05 §15 manifeste |
| 070 | `S1_A4_J16_SCN_MATHILDE_DEPARTURE_PREPARATION_01_PROTECTIVE` | J16 | `C16-01` | `VARIANT` | `SOUVENIR_IMAGE_DE_SCÈNE` | Mathilde | `MUTUALLY_EXCLUSIVE` — préparation protectrice | `none` | `C16-01` | character:Mathilde; location:appartement | `W3` | NAR-PROD-05 §15 manifeste |
| 071 | `S1_A4_J16_SCN_MARIE_J17_HANDOFF_01` | J16 | `C16-02` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie / foyer | `ALWAYS_IF_DAY_REACHED` — handoff J17 | `none` | `C16-02` | character:Marie; location:appartement | `W3` | NAR-PROD-05 §15 manifeste |

## Acte V — J17–J21

| # global | asset_id | jour | content_ref | file_role | content_type | sujet principal | branch_gate | trace_id | gallery_group | continuity_group | production_wave | source exacte |
|---:|---|---|---|---|---|---|---|---|---|---|---|---|
| 072 | `S1_A5_J17_SCN_MATHILDE_REAL_DEPARTURE_01` | J17 | `C17-01` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Mathilde | `ALWAYS_IF_DAY_REACHED` — départ réel | `none` | `C17-01` | character:Mathilde; location:appartement | `W4` | NAR-PROD-06 §11 manifeste |
| 073 | `S1_A5_J17_SCN_HOUSEHOLD_TRANSFORMED_01` | J17 | `C17-02` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Foyer | `ALWAYS_IF_DAY_REACHED` — foyer transformé | `none` | `C17-02` | location:appartement | `W4` | NAR-PROD-06 §11 manifeste |
| 074 | `S1_A5_J17_SCN_MARIE_COUPLE_STATE_01_HELD_NEGOTIATING` | J17 | `C17-03` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie / couple | `MUTUALLY_EXCLUSIVE` — maintien ou négociation | `none` | `C17-03` | character:Marie; location:appartement | `W4` | NAR-PROD-06 §11 manifeste |
| 075 | `S1_A5_J17_SCN_MARIE_COUPLE_STATE_01_FRACTURE_SEPARATION` | J17 | `C17-03` | `VARIANT` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie / couple | `MUTUALLY_EXCLUSIVE` — fracture ou séparation | `none` | `C17-03` | character:Marie; location:appartement | `W4` | NAR-PROD-06 §11 manifeste |
| 076 | `S1_A5_J18_SCN_SANDRA_KEEPS_REMOVES_PRINT_01` | J18 | `C18-01` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Sandra | `ALWAYS_IF_DAY_REACHED` — décision sur impression ou fil | `none` | `C18-01` | character:Sandra | `W4` | NAR-PROD-06 §11 manifeste |
| 077 | `S1_A5_J18_SCN_SANDRA_FINAL_STATE_01_STANDARD` | J18 | `C18-02` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Sandra | `MUTUALLY_EXCLUSIVE` — résolution standard | `none` | `C18-02` | character:Sandra | `W4` | NAR-PROD-06 §11 manifeste |
| 078 | `S1_A5_J18_SCN_SANDRA_LATE_INTIMACY_ENTRY_01` | J18 | `C18-02` | `SEQUENCE_CHILD` | `SOUVENIR_IMAGE_DE_SCÈNE` | Sandra | `ADULT_CONDITIONAL` — rencontre commencée | `none` | `SANDRA_J18_LATE_INTIMACY` | character:Sandra; sequence:SANDRA_J18_LATE_INTIMACY | `WA` | NAR-PROD-06 §11 manifeste |
| 079 | `S1_A5_J18_SCN_SANDRA_LATE_INTIMACY_CENTRAL_01` | J18 | `C18-02` | `SEQUENCE_CHILD` | `SOUVENIR_IMAGE_DE_SCÈNE` | Sandra | `ADULT_CONDITIONAL` — sexualité réellement atteinte | `none` | `SANDRA_J18_LATE_INTIMACY` | character:Sandra; sequence:SANDRA_J18_LATE_INTIMACY | `WA` | NAR-PROD-06 §11 manifeste |
| 080 | `S1_A5_J18_SCN_SANDRA_FINAL_STATE_01_LATE_INTIMACY_AFTERCARE` | J18 | `C18-02` | `VARIANT` | `SOUVENIR_IMAGE_DE_SCÈNE` | Sandra | `MUTUALLY_EXCLUSIVE` — intimité atteinte, aftercare | `none` | `SANDRA_J18_LATE_INTIMACY` | character:Sandra; sequence:SANDRA_J18_LATE_INTIMACY | `W4` | NAR-PROD-06 §11 manifeste |
| 081 | `S1_A5_J19_SCN_PAULINE_SURFACE_COMPARTMENT_01` | J19 | `C19-01` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Pauline | `MUTUALLY_EXCLUSIVE` — foreground Pauline | `none` | `C19-01` | character:Pauline | `W4` | NAR-PROD-06 §11 manifeste |
| 082 | `S1_A5_J19_DPH_PAULINE_ADULT_COMPARTMENT_01` | J19 | `C19-01` | `SEQUENCE_CHILD` | `PHOTO_DIÉGÉTIQUE` | Pauline | `ADULT_CONDITIONAL` — P19-B et fenêtre privée | `j19_pauline_adult_compartment_01` | `C19-01` | character:Pauline; sequence:PAULINE_J19_ADULT_COMPARTMENT | `WA` | NAR-PROD-06 §11 manifeste |
| 083 | `S1_A5_J19_SCN_RAPHAELLE_AFTER_ROLE_PROCESS_01` | J19 | `C19-02` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Raphaëlle | `MUTUALLY_EXCLUSIVE` — foreground Raphaëlle | `none` | `C19-02` | character:Raphaëlle | `W4` | NAR-PROD-06 §11 manifeste |
| 084 | `S1_A5_J20_SCN_NICO_ACTIVE_POSITION_01` | J20 | `C20-01` | `BASE` | `SOUVENIR_IMAGE_DE_SCÈNE` | Nico | `ALWAYS_IF_DAY_REACHED` — position active | `none` | `C20-01` | character:Nico; location:L’Annexe | `W4` | NAR-PROD-06 §11 manifeste |

# Comptages verrouillés

| Acte | Jours | Contenus principaux | Fichiers | Variantes |
|---|---|---:|---:|---:|
| I | J01–J04 | 13 | 15 | 0 |
| II | J05–J08 | 11 | 14 | 3 |
| III | J09–J12 | 21 | 30 | 2 |
| IV | J13–J16 | 10 | 12 | 1 |
| V | J17–J21 | 8 | 13 | 2 |
| **Total** | J01–J21 | **63** | **84** | **8** |

```text
63 contenus principaux
84 fichiers physiques
8 variantes
8 fichiers adultes ajoutés
6 images de scène adultes ajoutées
2 photos diégétiques adultes ajoutées
J21 = 0 nouveau fichier
```

Les réutilisations ne sont pas comptées. Un même fichier réutilisé plusieurs jours conserve une seule ligne.

# Huit fichiers adultes ajoutés

| Ordre WA | asset_id | nature |
|---:|---|---|
| 1 | `S1_A3_J11_SCN_MARIE_RECONQUEST_ADULT_PAYOFF_01` | SCN |
| 2 | `S1_A3_J11_SCN_MARIE_RECONQUEST_AFTERCARE_01` | SCN |
| 3 | `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_CENTRAL_01` | SCN |
| 4 | `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_AFTERCARE_01` | SCN |
| 5 | `S1_A4_J13_DPH_RAPHAELLE_MASKED_ADULT_SELECTED_01` | DPH |
| 6 | `S1_A5_J18_SCN_SANDRA_LATE_INTIMACY_ENTRY_01` | SCN |
| 7 | `S1_A5_J18_SCN_SANDRA_LATE_INTIMACY_CENTRAL_01` | SCN |
| 8 | `S1_A5_J19_DPH_PAULINE_ADULT_COMPARTMENT_01` | DPH |

Contrôle : **6 SCN + 2 DPH = 8**.

Les photos adultes diégétiques Raphaëlle et Pauline restent indépendantes de leurs photos antérieures. Le retrait de l’une ne retire pas automatiquement une autre trace.

# Séquences adultes complètes

## Marie J11

```text
sequence: MARIE_J11_RECONQUEST
S1_A3_J11_SCN_MARIE_COUPLE_STATE_01_RECONNECTION
S1_A3_J11_SCN_MARIE_RECONQUEST_ADULT_PAYOFF_01
S1_A3_J11_SCN_MARIE_RECONQUEST_AFTERCARE_01
```

Une seule tuile Galerie `Moment vécu`.

## Mathilde J11

```text
sequence: MATHILDE_J11_SECRET_INTIMACY
S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01_PROXIMITY
S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_CENTRAL_01
S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_AFTERCARE_01
```

Une seule tuile Galerie `Moment vécu`.

## Sandra J18

```text
sequence: SANDRA_J18_LATE_INTIMACY
S1_A5_J18_SCN_SANDRA_LATE_INTIMACY_ENTRY_01
S1_A5_J18_SCN_SANDRA_LATE_INTIMACY_CENTRAL_01
S1_A5_J18_SCN_SANDRA_FINAL_STATE_01_LATE_INTIMACY_AFTERCARE
```

Une seule tuile Galerie `Moment vécu`. `...LATE_INTIMACY_AFTERCARE` reste une variante de C18-02, appartient à W4 et n’est pas recomptée parmi les huit fichiers adultes ajoutés.

# Ordre de production

| Vague | Périmètre | Fichiers | Objectif |
|---|---|---:|---|
| W1 | Actes I et II | 29 | identités, appartement, La Verrière, L’Annexe, premières continuités et sets |
| W2 | Acte III hors quatre ajouts adultes J11 | 26 | escalade principale et bases Marie/Mathilde |
| W3 | Acte IV hors ajout adulte Raphaëlle | 11 | conséquences |
| W4 | Acte V hors ajouts adultes Sandra et Pauline | 10 | résolution ; aftercare Sandra variante inclus |
| WA | huit ajouts adultes | 8 | payoffs après validation des fondations correspondantes |
| **Total** |  | **84** | `29 + 26 + 11 + 10 + 8` |

Ordre interne WA : Marie central, Marie aftercare, Mathilde central, Mathilde aftercare, Raphaëlle adulte, Sandra entry, Sandra central, Pauline adulte.

Les identités, lieux, tenues et images de base correspondantes doivent être visuellement validés avant WA.

## Dépendances

- Une variante est produite après sa base.
- Un enfant de set reprend casting, lieu et continuité des autres frames.
- Une séquence adulte utilise la base déjà validée.
- Une photo diégétique conserve les imperfections crédibles d’une photographie réellement prise.
- Une image de scène ne reçoit aucun faux créateur diégétique.
- Player reste non identifiable.
- Aucun asset n’invente une personne absente.
- Une image retirée n’est pas recréée sous un autre identifiant.
- Une absence narrative ne produit aucun fichier de substitution.

# Hors comptage

Ne sont jamais comptés dans les 84 : planches de références personnages, références de lieux, ControlNet ou poses, masques, crops UI, miniatures, upscales, versions de travail, comparaisons, rejets, exports intermédiaires, fonds techniques, captures runtime, placeholders, traces textuelles, `FACT_RECORD`, `ACCESS_GRANT`, `ACCESS_REVOCATION`, `ABSENCE_MARKER`, impression T24 réutilisant T01 et tout nouveau fichier J21.

Ces éléments peuvent exister techniquement sans devenir des entrées du manifeste canonique.

# Formats différés

ASSET-01 ne décide ni extension, dimensions physiques, modèle, sampler, LoRA, workflow ComfyUI, convention de dossiers runtime, compression ou métadonnées embarquées. L’`asset_id` est indépendant de l’extension.
