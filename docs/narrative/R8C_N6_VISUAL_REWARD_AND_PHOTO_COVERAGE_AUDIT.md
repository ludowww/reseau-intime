# R8C-N6 — Audit des récompenses visuelles et de la couverture photo

> **Baseline :** `91af1f0795c9980d5220ae30fead67674da9cc37`
> **Portée :** 63 contenus principaux, 84 fichiers physiques, projection runtime J01–J21
> **Principe :** la cible produit de trois contenus distincts est auditée sans devenir une topologie du moteur

## 1. Verdict

Le produit possède un manifeste visuel final cohérent et adulte : 63 contenus principaux, 84 fichiers physiques, trois payoffs NV4, deux payoffs NV3 et des fonctions d'image différenciées. Il ne possède cependant **aucun des 84 fichiers finaux livrés**.

La couverture actuelle est donc à trois niveaux :

1. **canon de production complet** : les 84 fichiers sont identifiés ;
2. **structure runtime partielle** : 34 parents Galerie J02–J11, six enfants J11 et des références média en conversation ;
3. **livraison finale nulle** : tous les contenus canoniques utilisent placeholders, fallbacks ou absence de présentation.

Les journées J14–J21 sont les plus sous-alimentées dans le runtime : aucune présentation Galerie et aucun média de conversation actif, alors que le canon leur attribue 24 beats visuels servis par réutilisation ou nouveaux parents. J10–J12 sont des hotspots de catalogue, pas nécessairement des journées surchargées pour le joueur : leurs alternatives doivent rester exclusives.

## 2. Comptage physique et échelle d'audit `NV0–NV4`

`NV` signifie **N6 Visual Audit**. La classification ci-dessous est une couche éditoriale N6 appliquée aux 84 lignes d'`ASSET-01`. Elle n'est inscrite dans aucun JSON et ne remplace pas l'échelle canonique `V0–V5`.

| Niveau | Fichiers | Part | Lecture |
|---|---:|---:|---|
| NV0 — contexte | 40 | 47,6 % | foyer, travail, monde, conséquence, respiration |
| NV1 — attirance | 25 | 29,8 % | tenue, regard, présence sociale ou image chargée |
| NV2 — intimité | 14 | 16,7 % | image privée, proximité, entrée ou aftercare adulte |
| NV3 — explicite | 2 | 2,4 % | photos adultes Pauline et Raphaëlle |
| NV4 — payoff pornographique | 3 | 3,6 % | centres sexuels Marie, Mathilde et Sandra |
| **Total** | **84** | **100 %** |  |

### 2.1 Correspondance avec le canon `V0–V5`

Les définitions canoniques ci-dessous viennent de `docs/canon/bible/09_PROGRESSION_VISUELLE_ET_PHOTOGRAPHIQUE.md`. Le canon reste normatif ; N6 agrège intensité, fonction média et place dans le payoff, sans conversion automatique 1:1.

| Niveau canonique et définition normative | Agrégation N6 observée | Lecture |
|---|---|---|
| **V0 — Trace ordinaire** : présence quotidienne, cadrage imparfait, situation concrète, corps non mis en avant comme récompense, fonction principale narrative ou contextuelle. | surtout NV0, parfois NV1 | Une trace peut devenir preuve relationnelle NV1 sans changer d'intensité canonique. |
| **V1 — Élégante** : personnage clairement attirant, tenue/silhouette lisible, cadrage contrôlé, présence valorisée, image ordinaire ou publique. | NV0 ou NV1 | La fonction contextuelle ou attractive décide de l'agrégation. |
| **V2 — Sexy** : corps/pose mis en valeur, image socialement défendable, intention érotique possible mais pas nécessairement destinée à Player. | NV1 ou NV2 | N6 distingue signal d'attirance et vraie intimité. |
| **V3 — Provocante** : destination excitante connue, pose/cadrage/vêtement choisis, version privée/détail intime, invitation ou reconnaissance du désir. | surtout NV2, parfois NV1 | Les versions privées basculent généralement en NV2. |
| **V4 — Érotique adulte** : lingerie, nudité, exposition directe, posture sexuelle ou contexte explicitement intime sans acte pornographique complet ; audience/conservation centrales. | NV2 ou NV3 | Les deux photos adultes sont NV3 ; entrées et aftercares adultes restent NV2. |
| **V5 — Pornographique** : activité sexuelle explicite comme sujet principal, soumise au canon, à la route, au consentement, au cadre, aux audiences, aux conséquences et à l'après-coup. | NV4 | Trois centres sexuels seulement ; le rapprochement reste propre à ce portefeuille. |

### 2.2 Fichiers NV4

| Route | Asset | Rôle principal | Nature |
|---|---|---|---|
| Marie | `S1_A3_J11_SCN_MARIE_RECONQUEST_ADULT_PAYOFF_01` | `PORNOGRAPHIC_PAYOFF` | image de scène, non diégétique |
| Mathilde | `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_CENTRAL_01` | `PORNOGRAPHIC_PAYOFF` | image de scène, non diégétique |
| Sandra | `S1_A5_J18_SCN_SANDRA_LATE_INTIMACY_CENTRAL_01` | `PORNOGRAPHIC_PAYOFF` | image de scène, non diégétique |

### 2.3 Fichiers NV3

| Route | Asset | Rôle principal | Nature |
|---|---|---|---|
| Raphaëlle | `S1_A4_J13_DPH_RAPHAELLE_MASKED_ADULT_SELECTED_01` | `EROTIC_VISUAL_REWARD` | photo diégétique, créée par Maud, choisie par Raphaëlle |
| Pauline | `S1_A5_J19_DPH_PAULINE_ADULT_COMPARTMENT_01` | `EROTIC_VISUAL_REWARD` | photo diégétique, contrôle Pauline, audience Player |

Le manifeste ne contient aucune photo sexuelle diégétique Sandra et aucune image pornographique Nico/Player. Ces absences sont des décisions de personnage, pas des trous de production.

## 3. Répartition NV par projection de journée

La cible de trois contenus visuels distincts par journée reste une règle produit pour la projection actuelle J01–J21 et pour la vérification de sa couverture. Elle n’est pas une topologie obligatoire du futur moteur narratif, qui reste conçu par arcs, séquences et scènes.

Conséquences d'audit : les 21 journées actuelles restent toutes vérifiées ; trois contenus artificiels ou purement décoratifs ne suffisent pas ; de futurs jours peuvent être déplacés, fusionnés ou redistribués ; aucune scène n'est inventée pour remplir une journée ; la projection de livraison n'est pas l'identité d'une scène.

| Jour | Fichiers | NV0 | NV1 | NV2 | NV3 | NV4 | Commentaire |
|---|---:|---:|---:|---:|---:|---:|---|
| J01 | 3 | 2 | 1 | 0 | 0 | 0 | quotidien + trace Sandra |
| J02 | 3 | 3 | 0 | 0 | 0 | 0 | installation et foyer |
| J03 | 3 | 2 | 1 | 0 | 0 | 0 | travail/processus naissant |
| J04 | 6 | 5 | 1 | 0 | 0 | 0 | set social + foyer |
| J05 | 2 | 1 | 1 | 0 | 0 | 0 | troisième beat par réutilisation |
| J06 | 3 | 2 | 1 | 0 | 0 | 0 | regard Mathilde + retour Marie |
| J07 | 3 | 2 | 1 | 0 | 0 | 0 | Nico, Raphaëlle, foyer |
| J08 | 6 | 6 | 0 | 0 | 0 | 0 | conséquences locales, trois variantes |
| J09 | 4 | 0 | 3 | 1 | 0 | 0 | visibilité Marie et robe privée |
| J10 | 7 | 0 | 6 | 1 | 0 | 0 | sept alternatives de route, trois beats servis |
| J11 | 12 | 3 | 1 | 6 | 0 | 2 | deux familles NV4 alternatives + conséquences |
| J12 | 7 | 5 | 2 | 0 | 0 | 0 | convergence sociale, sets à casting réel |
| J13 | 3 | 0 | 0 | 2 | 1 | 0 | Pauline/Raphaëlle mutuellement exclusives |
| J14 | 2 | 2 | 0 | 0 | 0 | 0 | découverte/absence, pas récompense |
| J15 | 4 | 1 | 3 | 0 | 0 | 0 | vies autonomes et obligations |
| J16 | 3 | 2 | 1 | 0 | 0 | 0 | départ et handoff |
| J17 | 4 | 3 | 1 | 0 | 0 | 0 | foyer transformé et couple |
| J18 | 5 | 0 | 2 | 2 | 0 | 1 | résolution Sandra, standard ou adulte |
| J19 | 3 | 0 | 0 | 2 | 1 | 0 | Pauline ou Raphaëlle foreground |
| J20 | 1 | 1 | 0 | 0 | 0 | 0 | Nico + deux réutilisations |
| J21 | 0 nouveau | 0 | 0 | 0 | 0 | 0 | trois contenus antérieurs recontextualisés |
| **Total** | **84** | **40** | **25** | **14** | **2** | **3** |  |

### 3.1 Matrice exhaustive des 84 fichiers physiques — lignes 001–084

`ASSET-01` désigne le chemin exact `docs/canon/dialogues/ASSET_01_MANIFESTE_PRODUCTION_VISUELLE_SAISON_1_84_FICHIERS.md`. Le niveau canonique est indiqué lorsqu'il est identifiable ; une plage signale qu'un cadrage de production non encore livré tranche entre deux niveaux canoniques.

| Alias source | Chemin exact |
|---|---|
| NP02 | `docs/canon/dialogues/NAR_PROD_02_PAQUET_PRODUCTION_ACTE_I_J01_J04.md` |
| NP03 | `docs/canon/dialogues/NAR_PROD_03_PAQUET_PRODUCTION_ACTE_II_J05_J08.md` |
| NP04 | `docs/canon/dialogues/NAR_PROD_04_PAQUET_PRODUCTION_ACTE_III_J09_J12.md` |
| NP05 | `docs/canon/dialogues/NAR_PROD_05_PAQUET_PRODUCTION_ACTE_IV_J13_J16.md` |
| NP06 | `docs/canon/dialogues/NAR_PROD_06_PAQUET_PRODUCTION_ACTE_V_J17_J21.md` |

| N° | Asset ID exact | NV | Canon V identifiable | Personnage/groupe principal | Rôle média principal | Conversation/Galerie/set | Statut asset | Source | Justification factuelle |
|---:|---|---:|---|---|---|---|---|---|---|
| 001 | `S1_A1_J01_SCN_MARIE_SHARED_KITCHEN_01` | NV0 | V0 | Marie | `ATMOSPHERE_OR_WORLD` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #001; NP02 §5.10 | ouverture Marie |
| 002 | `S1_A1_J01_DPH_SANDRA_LUNCH_SELECTED_01` | NV1 | V0 | Sandra | `NARRATIVE_TRIGGER` | Conversation + Galerie | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #002; NP02 §5.11 | envoi J01 |
| 003 | `S1_A1_J01_SCN_MARIE_EVENING_RETURN_01` | NV0 | V0 | Marie | `RELATIONSHIP_PROOF` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #003; NP02 §5.12 | retour du soir |
| 004 | `S1_A1_J02_SCN_MATHILDE_FIRST_INSTALLED_VIEW_01` | NV0 | V0 | Mathilde | `ATMOSPHERE_OR_WORLD` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #004; NP02 §6.11 | installation atteinte |
| 005 | `S1_A1_J02_SCN_MARIE_HOLDS_HOUSEHOLD_01` | NV0 | V0 | Marie | `RELATIONSHIP_PROOF` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #005; NP02 §6.12 | Marie tient le foyer |
| 006 | `S1_A1_J02_SCN_FIRST_SHARED_EVENING_01` | NV0 | V0 | Marie + Mathilde | `RELATIONSHIP_PROOF` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #006; NP02 §6.13 | première soirée partagée |
| 007 | `S1_A1_J03_SCN_RAPHAELLE_ACCESSIBILITY_REVIEW_01` | NV0 | V0 | Raphaëlle | `ATMOSPHERE_OR_WORLD` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #007; NP02 §7.11 | revue accessibilité |
| 008 | `S1_A1_J03_SCN_RAPHAELLE_GARMENT_BAG_01` | NV1 | V0–V1 | Raphaëlle | `NARRATIVE_TRIGGER` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #008; NP02 §7.12 | garment bag visible |
| 009 | `S1_A1_J03_SCN_MARIE_HOME_FROM_LAVERRIERE_01` | NV0 | V0 | Marie | `RELATIONSHIP_PROOF` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #009; NP02 §7.13 | retour La Verrière |
| 010 | `S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01_FRAME_01` | NV0 | V0 | Pauline + Bastien + Marie | `SOCIAL_TRACE` | Conversation + Galerie/set | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #010; NP02 §8.11 | frame obligatoire |
| 011 | `S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01_FRAME_02` | NV0 | V0 | Pauline + Bastien + Marie | `SOCIAL_TRACE` | Conversation + Galerie/set | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #011; NP02 §8.11 | frame obligatoire |
| 012 | `S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01_FRAME_03` | NV0 | V0 | Pauline + Bastien + Marie | `SOCIAL_TRACE` | Conversation + Galerie/set | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #012; NP02 §8.11 | frame obligatoire |
| 013 | `S1_A1_J04_SCN_MARIE_SOCIAL_MOTION_01` | NV1 | V1 | Marie + Pauline + Bastien | `SOCIAL_TRACE` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #013; NP02 §8.12 | mouvement social |
| 014 | `S1_A1_J04_SCN_NICO_SAVED_SEAT_01` | NV0 | V0 | Nico | `RELATIONSHIP_PROOF` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #014; NP02 §8.13 | place gardée |
| 015 | `S1_A1_J04_SCN_HOUSEHOLD_THREE_RHYTHM_01` | NV0 | V0 | Marie + Mathilde | `RELATIONSHIP_PROOF` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #015; NP02 §8.14 | rythme du foyer |
| 016 | `S1_A2_J05_SCN_MARIE_REAL_HOUR_01` | NV1 | V0–V1 | Marie | `RELATIONSHIP_PROOF` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #016; NP03 §12 | beat Marie servi |
| 017 | `S1_A2_J05_SCN_MARIE_SATURDAY_CONTINUES_01` | NV0 | V0 | Marie | `CONSEQUENCE_OR_ECHO` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #017; NP03 §12 | aucune continuité extérieure |
| 018 | `S1_A2_J06_SCN_MATHILDE_LOOK_ACKNOWLEDGED_01` | NV1 | V2 | Mathilde | `TRUST_OR_INTIMACY_REWARD` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #018; NP03 §12 | Mathilde éligible |
| 019 | `S1_A2_J06_SCN_SUNDAY_WITHOUT_EXTERNAL_PROGRESS_01` | NV0 | V0 | Marie / foyer | `ATMOSPHERE_OR_WORLD` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #019; NP03 §12 | aucune continuité extérieure |
| 020 | `S1_A2_J06_SCN_MARIE_CONCRETE_RETURN_01` | NV0 | V0 | Marie | `RELATIONSHIP_PROOF` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #020; NP03 §12 | retour concret |
| 021 | `S1_A2_J07_SCN_RAPHAELLE_MOBILE_REVIEW_DUE_01` | NV0 | V0 | Raphaëlle | `NARRATIVE_TRIGGER` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #021; NP03 §12 | obligation mobile |
| 022 | `S1_A2_J07_SCN_NICO_AFTER_SERVICE_CONFIDENCE_01` | NV0 | V0 | Nico | `RELATIONSHIP_PROOF` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #022; NP03 §12 | confidence après service |
| 023 | `S1_A2_J07_SCN_MARIE_HOUSEHOLD_REQUEST_01` | NV1 | V0–V1 | Marie | `NARRATIVE_TRIGGER` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #023; NP03 §12 | demande foyer |
| 024 | `S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01_PAID` | NV0 | V0 | Raphaëlle | `CONSEQUENCE_OR_ECHO` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #024; NP03 §12 | P05 payée |
| 025 | `S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01_TAKEN_OVER` | NV0 | V0 | Raphaëlle | `CONSEQUENCE_OR_ECHO` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #025; NP03 §12 | travail repris |
| 026 | `S1_A2_J08_SCN_NICO_CHAIR_STATE_01_PAID` | NV0 | V0 | Nico | `CONSEQUENCE_OR_ECHO` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #026; NP03 §12 | présence payée |
| 027 | `S1_A2_J08_SCN_NICO_CHAIR_STATE_01_NO_WAIT` | NV0 | V0 | Nico | `CONSEQUENCE_OR_ECHO` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #027; NP03 §12 | aucune attente |
| 028 | `S1_A2_J08_SCN_HOUSEHOLD_STATE_01_PAID` | NV0 | V0 | Marie / foyer | `CONSEQUENCE_OR_ECHO` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #028; NP03 §12 | aide accomplie |
| 029 | `S1_A2_J08_SCN_HOUSEHOLD_STATE_01_AUTONOMOUS` | NV0 | V0 | Marie / foyer | `CONSEQUENCE_OR_ECHO` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #029; NP03 §12 | foyer autonome |
| 030 | `S1_A3_J09_SCN_LAVERRIERE_INSTALLATION_01` | NV1 | V0 | Marie / La Verrière | `ATMOSPHERE_OR_WORLD` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #030; NP04 §13.1 | installation |
| 031 | `S1_A3_J09_DPH_MARIE_BLACK_DRESS_PRIVATE_01` | NV2 | V3 | Marie | `EROTIC_VISUAL_REWARD` | Conversation + Galerie | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #031; NP04 §13.1 | robe privée choisie |
| 032 | `S1_A3_J09_DPH_MARIE_LAVERRIERE_PUBLIC_01` | NV1 | V1 | Marie | `SOCIAL_TRACE` | Conversation + Galerie | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #032; NP04 §13.1 | source publique |
| 033 | `S1_A3_J09_DPH_MARIE_LAVERRIERE_AFTER_01` | NV1 | V1–V2 | Marie | `TRUST_OR_INTIMACY_REWARD` | Conversation + Galerie | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #033; NP04 §13.1 | créée et relayée |
| 034 | `S1_A3_J10_SCN_SANDRA_CAFE_HELD_01` | NV1 | V1 | Sandra | `TRUST_OR_INTIMACY_REWARD` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #034; NP04 §13.2 | pivot Sandra, café tenu |
| 035 | `S1_A3_J10_DPH_MATHILDE_OUTFIT_CHOICE_01` | NV2 | V2–V3 | Mathilde | `EROTIC_VISUAL_REWARD` | Conversation + Galerie | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #035; NP04 §13.2 | pivot Mathilde |
| 036 | `S1_A3_J10_SCN_MATHILDE_SOCIAL_RESULT_01` | NV1 | V1 | Mathilde | `CONSEQUENCE_OR_ECHO` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #036; NP04 §13.2 | pivot Mathilde |
| 037 | `S1_A3_J10_DPH_RAPHAELLE_PROCESS_DETAIL_01` | NV1 | V2 | Raphaëlle | `TRUST_OR_INTIMACY_REWARD` | Conversation + Galerie | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #037; NP04 §13.2 | pivot Raphaëlle R-A |
| 038 | `S1_A3_J10_DPH_RAPHAELLE_PROCESS_COMPARISON_02` | NV1 | V2 | Raphaëlle | `TRUST_OR_INTIMACY_REWARD` | Conversation + Galerie | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #038; NP04 §13.2 | branche R-A |
| 039 | `S1_A3_J10_DPH_ANNEXE_MARIE_PUBLIC_01` | NV1 | V1 | Marie | `SOCIAL_TRACE` | Conversation + Galerie | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #039; NP04 §13.2 | pivot Nico |
| 040 | `S1_A3_J10_DPH_ANNEXE_MATHILDE_PUBLIC_01` | NV1 | V1 | Mathilde | `SOCIAL_TRACE` | Conversation + Galerie | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #040; NP04 §13.2 | pivot Nico |
| 041 | `S1_A3_J11_DPH_SANDRA_CHOSEN_IMAGE_01` | NV2 | V3 | Sandra | `EROTIC_VISUAL_REWARD` | Conversation + Galerie | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #041; NP04 §13.3 | continuation Sandra |
| 042 | `S1_A3_J11_SCN_SANDRA_IMAGE_CONSEQUENCE_01` | NV1 | V0 | Sandra | `CONSEQUENCE_OR_ECHO` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #042; NP04 §13.3 | conséquence Sandra |
| 043 | `S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01_PROXIMITY` | NV2 | V3 | Mathilde | `TRUST_OR_INTIMACY_REWARD` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #043; NP04 §13.3 | proximité maintenue |
| 044 | `S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01_DISTANCE` | NV0 | V0 | Mathilde | `CONSEQUENCE_OR_ECHO` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #044; NP04 §13.3 | distance restaurée |
| 045 | `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_CENTRAL_01` | NV4 | V5 | Mathilde | `PORNOGRAPHIC_PAYOFF` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #045; NP04 §13.3 | M-B3 éligible et consentement actuel |
| 046 | `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_AFTERCARE_01` | NV2 | V4 | Mathilde | `TRUST_OR_INTIMACY_REWARD` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #046; NP04 §13.3 | payoff servi, aftercare dû |
| 047 | `S1_A3_J11_DPH_RAPHAELLE_CHOSEN_RESULT_01` | NV2 | V3 | Raphaëlle | `TRUST_OR_INTIMACY_REWARD` | Conversation + Galerie | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #047; NP04 §13.3 | résultat réellement envoyé |
| 048 | `S1_A3_J11_SCN_NICO_PREPARE_J12_01` | NV0 | V0 | Nico | `NARRATIVE_TRIGGER` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #048; NP04 §13.3 | continuation Nico |
| 049 | `S1_A3_J11_SCN_MARIE_COUPLE_STATE_01_RECONNECTION` | NV2 | V3–V4 | Marie | `TRUST_OR_INTIMACY_REWARD` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #049; NP04 §13.3 | reconquête crédible |
| 050 | `S1_A3_J11_SCN_MARIE_COUPLE_STATE_01_LIMIT` | NV0 | V0 | Marie | `CONSEQUENCE_OR_ECHO` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #050; NP04 §13.3 | limite ou distance |
| 051 | `S1_A3_J11_SCN_MARIE_RECONQUEST_ADULT_PAYOFF_01` | NV4 | V5 | Marie | `PORNOGRAPHIC_PAYOFF` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #051; NP04 §13.3 | reconquête et consentement actuels |
| 052 | `S1_A3_J11_SCN_MARIE_RECONQUEST_AFTERCARE_01` | NV2 | V4 | Marie | `TRUST_OR_INTIMACY_REWARD` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #052; NP04 §13.3 | payoff servi, aftercare dû |
| 053 | `S1_A3_J12_DPH_MARIE_LAVERRIERE_PRO_01` | NV1 | V1 | Marie | `SOCIAL_TRACE` | Conversation + Galerie | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #053; NP04 §13.4 | visibilité professionnelle |
| 054 | `S1_A3_J12_DPH_LAVERRIERE_PUBLIC_GROUP_SET_01_FRAME_01` | NV0 | V0 | Groupe La Verrière | `SOCIAL_TRACE` | Conversation + Galerie/set | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #054; NP04 §13.4 | casting réel |
| 055 | `S1_A3_J12_DPH_LAVERRIERE_PUBLIC_GROUP_SET_01_FRAME_02` | NV0 | V0 | Groupe La Verrière | `SOCIAL_TRACE` | Conversation + Galerie/set | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #055; NP04 §13.4 | casting réel |
| 056 | `S1_A3_J12_DPH_LAVERRIERE_PUBLIC_GROUP_SET_01_FRAME_03` | NV0 | V0 | Groupe La Verrière | `SOCIAL_TRACE` | Conversation + Galerie/set | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #056; NP04 §13.4 | casting réel |
| 057 | `S1_A3_J12_DPH_LAVERRIERE_PUBLIC_GROUP_SET_01_FRAME_04` | NV0 | V0 | Groupe La Verrière | `SOCIAL_TRACE` | Conversation + Galerie/set | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #057; NP04 §13.4 | casting réel |
| 058 | `S1_A3_J12_DPH_PAULINE_BASTIEN_ANNEXE_01` | NV1 | V1 | Pauline + Bastien | `SOCIAL_TRACE` | Conversation + Galerie | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #058; NP04 §13.4 | accès L’Annexe légitime |
| 059 | `S1_A3_J12_DPH_ANNEXE_SOCIAL_POSITIONS_SET_01_FRAME_01` | NV0 | V0 | Groupe L’Annexe | `SOCIAL_TRACE` | Conversation + Galerie/set | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #059; NP04 §13.4 | T15 créée et autorisée |
| 060 | `S1_A3_J12_DPH_PAULINE_BASTIEN_ANNEXE_01_FRAME_04_PRIVATE` | NV2 | V3 | Pauline | `EROTIC_VISUAL_REWARD` | Conversation + Galerie/set | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #060; NP05 §15 | version privée créée et envoyée |
| 061 | `S1_A4_J13_DPH_RAPHAELLE_MASKED_POSTURE_01` | NV2 | V3 | Raphaëlle | `EROTIC_VISUAL_REWARD` | Conversation + Galerie | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #061; NP05 §15 | prise sélectionnée |
| 062 | `S1_A4_J13_DPH_RAPHAELLE_MASKED_ADULT_SELECTED_01` | NV3 | V4 | Raphaëlle | `EROTIC_VISUAL_REWARD` | Conversation + Galerie | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #062; NP05 §15 | branche adulte et sélection explicite |
| 063 | `S1_A4_J14_SCN_MARIE_LIMITED_DISCOVERY_01` | NV0 | V0 | Marie | `CONSEQUENCE_OR_ECHO` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #063; NP05 §15 | Marie témoin légitime |
| 064 | `S1_A4_J14_SCN_MATHILDE_LIMITED_DISCOVERY_01` | NV0 | V0 | Mathilde | `CONSEQUENCE_OR_ECHO` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #064; NP05 §15 | Mathilde témoin légitime |
| 065 | `S1_A4_J15_SCN_MARIE_AUTONOMOUS_PRIORITY_01` | NV0 | V0 | Marie | `CONSEQUENCE_OR_ECHO` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #065; NP05 §15 | Marie non servie |
| 066 | `S1_A4_J15_SCN_SANDRA_AUTONOMOUS_WINDOW_01` | NV1 | V0 | Sandra | `CONSEQUENCE_OR_ECHO` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #066; NP05 §15 | Sandra non servie |
| 067 | `S1_A4_J15_SCN_MATHILDE_AUTONOMOUS_HOUSEHOLD_01` | NV1 | V0 | Mathilde | `CONSEQUENCE_OR_ECHO` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #067; NP05 §15 | Mathilde non servie |
| 068 | `S1_A4_J15_SCN_PAULINE_AUTONOMOUS_VERSION_01` | NV1 | V0 | Pauline | `CONSEQUENCE_OR_ECHO` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #068; NP05 §15 | Pauline non servie |
| 069 | `S1_A4_J16_SCN_MATHILDE_DEPARTURE_PREPARATION_01_ORDINARY` | NV0 | V0 | Mathilde | `CONSEQUENCE_OR_ECHO` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #069; NP05 §15 | préparation ordinaire |
| 070 | `S1_A4_J16_SCN_MATHILDE_DEPARTURE_PREPARATION_01_PROTECTIVE` | NV0 | V0 | Mathilde | `CONSEQUENCE_OR_ECHO` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #070; NP05 §15 | préparation protectrice |
| 071 | `S1_A4_J16_SCN_MARIE_J17_HANDOFF_01` | NV1 | V0 | Marie / foyer | `NARRATIVE_TRIGGER` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #071; NP05 §15 | handoff J17 |
| 072 | `S1_A5_J17_SCN_MATHILDE_REAL_DEPARTURE_01` | NV0 | V0 | Mathilde | `CONSEQUENCE_OR_ECHO` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #072; NP06 §11 | départ réel |
| 073 | `S1_A5_J17_SCN_HOUSEHOLD_TRANSFORMED_01` | NV0 | V0 | Foyer | `CONSEQUENCE_OR_ECHO` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #073; NP06 §11 | foyer transformé |
| 074 | `S1_A5_J17_SCN_MARIE_COUPLE_STATE_01_HELD_NEGOTIATING` | NV1 | V0–V1 | Marie / couple | `RELATIONSHIP_PROOF` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #074; NP06 §11 | maintien ou négociation |
| 075 | `S1_A5_J17_SCN_MARIE_COUPLE_STATE_01_FRACTURE_SEPARATION` | NV0 | V0 | Marie / couple | `RELATIONSHIP_PROOF` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #075; NP06 §11 | fracture ou séparation |
| 076 | `S1_A5_J18_SCN_SANDRA_KEEPS_REMOVES_PRINT_01` | NV1 | V0 | Sandra | `CONSEQUENCE_OR_ECHO` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #076; NP06 §11 | décision sur impression ou fil |
| 077 | `S1_A5_J18_SCN_SANDRA_FINAL_STATE_01_STANDARD` | NV1 | V0 | Sandra | `TRUST_OR_INTIMACY_REWARD` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #077; NP06 §11 | résolution standard |
| 078 | `S1_A5_J18_SCN_SANDRA_LATE_INTIMACY_ENTRY_01` | NV2 | V4 | Sandra | `TRUST_OR_INTIMACY_REWARD` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #078; NP06 §11 | rencontre commencée |
| 079 | `S1_A5_J18_SCN_SANDRA_LATE_INTIMACY_CENTRAL_01` | NV4 | V5 | Sandra | `PORNOGRAPHIC_PAYOFF` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #079; NP06 §11 | sexualité réellement atteinte |
| 080 | `S1_A5_J18_SCN_SANDRA_FINAL_STATE_01_LATE_INTIMACY_AFTERCARE` | NV2 | V4 | Sandra | `TRUST_OR_INTIMACY_REWARD` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #080; NP06 §11 | intimité atteinte, aftercare |
| 081 | `S1_A5_J19_SCN_PAULINE_SURFACE_COMPARTMENT_01` | NV2 | V3 | Pauline | `EROTIC_VISUAL_REWARD` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #081; NP06 §11 | foreground Pauline |
| 082 | `S1_A5_J19_DPH_PAULINE_ADULT_COMPARTMENT_01` | NV3 | V4 | Pauline | `EROTIC_VISUAL_REWARD` | Conversation + Galerie | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #082; NP06 §11 | P19-B et fenêtre privée |
| 083 | `S1_A5_J19_SCN_RAPHAELLE_AFTER_ROLE_PROCESS_01` | NV2 | V2–V3 | Raphaëlle | `TRUST_OR_INTIMACY_REWARD` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #083; NP06 §11 | foreground Raphaëlle |
| 084 | `S1_A5_J20_SCN_NICO_ACTIVE_POSITION_01` | NV0 | V0 | Nico | `RELATIONSHIP_PROOF` | Galerie/replay | `SPECIFIED_NOT_PRODUCED` | ASSET-01 #084; NP06 §11 | position active |

Contrôle de cardinalité : **84 lignes de données**, IDs `001–084` uniques et exhaustifs, aucun absent ni doublon ; totaux **NV0 40, NV1 25, NV2 14, NV3 2, NV4 3**. Les NV3 nommés sont Raphaëlle #062 et Pauline #082 ; les NV4 nommés sont Mathilde #045, Marie #051 et Sandra #079.

J21 ne constitue pas un trou de manifeste : sa fonction est de changer le sens d'une image déjà vécue. Son trou runtime est l'absence de présentation/recontextualisation réellement configurée.

## 4. Rôle principal des 63 contenus logiques

Les rôles secondaires sont conservés lorsque la branche change le sens. Les comptes ci-dessous sont exclusifs sur le rôle principal et totalisent 63 parents ; les frames et enfants physiques ne sont pas recomptés comme parents.

| Rôle principal | Parents | Content refs |
|---|---:|---|
| `NARRATIVE_TRIGGER` | 6 | J01-02, J03-02, J07-N01, J07-N03, C11-05, C16-02 |
| `RELATIONSHIP_PROOF` | 11 | J01-03, J02-02, J02-03, J03-03, J04-03, J04-04, J05-N01, J06-N03, J07-N02, C17-03, C20-01 |
| `TRUST_OR_INTIMACY_REWARD` | 7 | J06-N01, C09-04, C10-01, C10-04, C10-05, C11-04, C19-02 |
| `EROTIC_VISUAL_REWARD` | 6 | C09-02, C10-02, C11-01, C13-01, C13-02, C19-01 |
| `PORNOGRAPHIC_PAYOFF` | 3 | C11-03 maximal Mathilde, C11-06 maximal Marie, C18-02 maximal Sandra |
| `SOCIAL_TRACE` | 9 | J04-01, J04-02, C09-03, C10-06, C10-07, C12-01, C12-02, C12-03, C12-04 |
| `CONSEQUENCE_OR_ECHO` | 16 | J05-N02, J08-N01–03, C10-03, C11-02, C14-01–02, C15-01–04, C16-01, C17-01–02, C18-01 |
| `ATMOSPHERE_OR_WORLD` | 5 | J01-01, J02-01, J03-01, J06-N02, C09-01 |
| **Total** | **63** |  |

### 4.1 Rôles secondaires importants

| Contenu | Principal | Secondaire |
|---|---|---|
| J01-02 Sandra déjeuner | `NARRATIVE_TRIGGER` | `RELATIONSHIP_PROOF` |
| C09-02 Marie robe privée | `EROTIC_VISUAL_REWARD` | `TRUST_OR_INTIMACY_REWARD` |
| C11-01 Sandra choisie | `EROTIC_VISUAL_REWARD` | `RELATIONSHIP_PROOF` |
| C11-03/C11-06 branches standard | `PORNOGRAPHIC_PAYOFF` au maximum | `TRUST_OR_INTIMACY_REWARD` ou `CONSEQUENCE_OR_ECHO` si l'adulte n'est pas servi |
| C13-01 Pauline | `EROTIC_VISUAL_REWARD` | `SOCIAL_TRACE`, car dérivée d'un set légitime |
| C13-02 Raphaëlle | `EROTIC_VISUAL_REWARD` | `TRUST_OR_INTIMACY_REWARD` |
| C18-02 Sandra | `PORNOGRAPHIC_PAYOFF` au maximum | `CONSEQUENCE_OR_ECHO` dans la résolution standard |
| C19-01 Pauline | `EROTIC_VISUAL_REWARD` | `CONSEQUENCE_OR_ECHO` si l'image est retirée |

Cette classification évite de compter comme « récompense » toute image simplement regardable. Les 21 parents `CONSEQUENCE_OR_ECHO` ou `ATMOSPHERE_OR_WORLD` sont nécessaires à la respiration, mais ne compensent pas un payoff manquant.

## 5. Couverture runtime actuelle par journée

« Structure » signifie qu'un hook ou placeholder existe ; « livré » signifie un fichier final correspondant au manifeste. Le nombre livré est nul partout.

| Jour | Cible servie | Structure runtime observée | Galerie | Livré | Diagnostic |
|---|---:|---|---:|---:|---|
| J01 | 3 | 1 photo Sandra en conversation | 0 | 0 | sous-alimentée : deux moments canoniques non présentés |
| J02 | 3 | 3 parents placeholders | 3 | 0 | structure couverte, production absente |
| J03 | 3 | 3 parents placeholders | 3 | 0 | structure couverte, production absente |
| J04 | 4 | 4 parents, set social placeholder | 4 | 0 | structure couverte, six fichiers absents |
| J05 | 3 | 2 nouveaux parents + réutilisation | 2 | 0 | couverture canonique atteinte par réemploi ; pas de quota d'un troisième nouveau fichier |
| J06 | 3 | 3 parents + ancres antérieures | 3 | 0 | structure couverte, production absente |
| J07 | 3 | 3 parents | 3 | 0 | structure couverte, production absente |
| J08 | 3 | 3 parents, variantes locales | 3 | 0 | structure couverte ; six fichiers de catalogue |
| J09 | 4 | 4 parents, 3 médias conversation | 4 | 0 | structure couverte, production absente |
| J10 | 3 | 7 parents alternatifs | 7 catalogue | 0 | hotspot de branche ; ne jamais servir les sept ensemble |
| J11 | 3 | 2 parents + 6 enfants placeholders | 2 parents | 0 | dette adulte explicite ; une séquence seulement par configuration |
| J12 | 4 | 4 médias fonctionnels placeholders | 0 | 0 | fonction couverte en conversation, Galerie absente |
| J13 | 3 | 2 parents alternatifs + réutilisation | 0 | 0 | placeholders conventionnels, Galerie absente |
| J14 | 3 | texte seulement | 0 | 0 | sous-alimentée structurellement |
| J15 | 3 | texte seulement | 0 | 0 | sous-alimentée structurellement |
| J16 | 3 | texte seulement | 0 | 0 | sous-alimentée structurellement |
| J17 | 3 | texte seulement | 0 | 0 | sous-alimentée ; foyer/couple non matérialisés |
| J18 | 3 | texte seulement | 0 | 0 | sous-alimentée ; payoff Sandra absent |
| J19 | 3 | texte seulement | 0 | 0 | sous-alimentée ; payoffs/aftercare absents |
| J20 | 3 | texte seulement | 0 | 0 | sous-alimentée ; position Nico sans écho visuel |
| J21 | 3 réutilisés | texte seulement | 0 | 0 | sous-alimentée en mise en scène, pas en nouveaux assets |

### 5.1 Journées sous-alimentées

- **J01** : une photo de conversation au lieu de trois fonctions canoniques ;
- **J12–J13** : médias placeholders sans entrée Galerie ;
- **J14–J20** : aucune surface visuelle runtime active ;
- **J21** : aucune recontextualisation configurée alors que trois beats visuels existants doivent conclure la saison ;
- **toutes les journées** : zéro asset final, donc aucune n'est couverte au sens livraison.

### 5.2 Journées ou lots surchargés

- **J10** : sept parents alternatifs pour trois beats servis ; charge de production élevée, charge joueur bornée si l'exclusivité tient ;
- **J11** : douze fichiers, deux familles adultes complètes et plusieurs continuations ; plus gros hotspot d'intensité ;
- **J12** : sept fichiers et deux sets ; risque de composition universelle mensongère ;
- **J04** : six fichiers pour quatre moments, car un set contient trois frames ; pas une surcharge narrative ;
- **J18** : cinq fichiers pour deux parents alternatifs, dont une séquence adulte ; production conditionnelle à tester.

## 6. Galerie, conversation et permanence

| Surface | État observé | Règle |
|---|---|---|
| Médias en conversation | 24 occurrences authorées, environ 20 identifiants uniques, dont répétitions et au moins un ancien `FACT_RECORD` | Une référence n'est pas une livraison ; vérifier type et audience. |
| Parents Galerie J02–J11 | 34 | Tous utilisent un libellé de non-livraison ou un placeholder canonique. |
| Enfants Galerie J11 | 6 | Trois Marie, trois Mathilde ; aucun fichier final. |
| Galerie J12–J21 | 0 présentation | Trou d'intégration majeur pour les actes tardifs. |
| Images de scène | 59 fichiers prévus | Revisables après vécu ; non partageables, non découvrables comme fichiers. |
| Photos diégétiques/sets | 25 fichiers prévus | Créateur, audience, sauvegarde, transfert et retrait doivent rester actifs. |
| J21 | 0 nouveau fichier | Réutiliser sans restaurer une photo retirée ni révéler un contenu jamais vécu. |

La Galerie est un journal de contenus rencontrés, pas un distributeur. Une tuile adulte ne doit apparaître qu'après la scène ou l'image vécue ; sa miniature ne doit pas révéler le contenu avant déblocage.

## 7. Assets existants et manquants

### 7.1 Fichiers physiques

| Catégorie | Existant | Manquant |
|---|---:|---:|
| Assets finaux du manifeste | 0 | 84 |
| Prototypes PNG V0.95/V0.96 | 14 | — |
| Asset **Les chaises bleues** hors manifeste | 0 | 1 si activation |

Les 14 prototypes sont répartis ainsi : Marie 5, Mathilde 4, Sandra 4, Pauline 1, Raphaëlle 0, Nico 0. Ils ne portent pas les identifiants finaux d'`ASSET-01` et ne sont pas référencés par les maps canoniques J09/J10 ; ils restent des preuves historiques, pas des fichiers livrés.

### 7.2 Apparitions à produire par personnage

Les comptes se chevauchent pour les groupes.

| Personnage | Fichiers du manifeste où il/elle est sujet nommé | Prototypes physiques | Fichiers finaux livrés |
|---|---:|---:|---:|
| Marie | 32 | 5 | 0 |
| Sandra | 10 | 4 | 0 |
| Mathilde | 16 | 4 | 0 |
| Pauline | 9 | 1 | 0 |
| Raphaëlle | 11 | 0 | 0 |
| Nico | 6 | 0 | 0 |

## 8. Besoins de production visuelle

| Besoin | Quantité | Priorité |
|---|---:|---|
| Références personnages validées | 6 principaux + Player hors cadre | bloque toute cohérence d'asset |
| Références lieux | appartement, La Verrière, L'Annexe, travail Sandra, atelier Raphaëlle, extérieurs Sandra | bloque les vagues par acte |
| Fichiers NV0–NV1 | 65 | socle visual-first et continuité |
| Fichiers NV2 | 14 | récompenses intimes et aftercares |
| Fichiers NV3 | 2 | Pauline/Raphaëlle adultes |
| Fichiers NV4 | 3 | Marie/Mathilde/Sandra centraux |
| Frames de sets | 9 | continuité casting/audience |
| QA audience/retrait/Galerie | 25 fichiers diégétiques/sets | bloque l'intégration propre |
| Asset **Les chaises bleues** | 1 hors manifeste | seulement si activation N5 décidée |

Produire les 84 fichiers dans l'ordre numérique brut serait une erreur. Les références, lieux, sets et séquences adultes doivent être verrouillés avant les vagues ; les jours restent une projection de contrôle, pas l'architecture de production.

## 9. Hypothèses conservatrices

- NV4 est réservé aux trois images centrales de sexualité complète/bornée ; nudité frontale seule reste NV3.
- Une entrée ou un aftercare adulte reste NV2 même si la scène globale atteint NV4.
- Les variantes et frames comptent comme fichiers physiques mais pas comme moments principaux indépendants.
- Un média conversation référencé sans fichier final compte comme structure, jamais comme asset existant.
- Les 14 PNG prototypes ne réduisent pas le manque de 84 fichiers.
- J21 reste à zéro nouveau fichier ; son besoin est la réutilisation contrôlée.
- Une journée à trois contenus NV0 décoratifs n'est pas déclarée couverte sur l'axe récompense.
- Les catalogues alternatifs J10/J11/J19 ne sont pas additionnés dans une partie.

## 10. Conclusion

La couverture cible est éditorialement solide : 77,4 % de fichiers NV0–NV1 construisent le monde et l'attirance, 16,7 % portent l'intimité, et cinq fichiers NV3–NV4 délivrent les payoffs adultes les plus élevés. Le défaut n'est pas un manque de volume prévu ; c'est l'absence totale de livraison finale et la disparition progressive des hooks visuels du runtime après J13. La production doit donc matérialiser le manifeste existant, préserver les fonctions et reconnecter les actes tardifs à la Galerie, sans inventer des photos pour remplir un calendrier.
