# V0.58 — Documentation Reconciliation Report

## 1. Source de vérité actuelle

- Référence narrative principale : `docs/V0_57_Route_Character_Rework_Blueprint.md`
- Audit de contexte : `docs/V0_56_Narrative_Continuity_Audit_J1_J9.md`
- Principe retenu : V0.57 prime dès qu’un document ancien contredit la hiérarchie route/personnage.

## 2. Documents compatibles

Ces docs restent cohérents avec V0.57, ou n’exigent qu’une note légère de lecture.

- `docs/story_state/GLOBAL_STORY_STATE.md` — état global déjà centré sur le couple, les traces et les conséquences.
- `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md` — matrice exploitable pour la continuité jour par jour.
- `docs/narrative/DAILY_RHYTHM_AND_CONTENT_DENSITY.md` — utile comme cadrage de densité, sans contradiction de fond.
- `docs/narrative/PROOF_AND_SECRET_MAP.md` — compatible avec la lecture preuves/traces/conséquences de V0.57.
- `docs/decisions/DECISION_006_PLAYER_NAME_AND_THREAD_MODEL.md` — aligne Player, le modèle de fils et le pending/unread.
- `docs/decisions/DECISION_007_FIRST_DAY_PACING_AND_CHARACTER_ANCHORING.md` — compatible avec l’ancrage progressif du départ.
- `docs/decisions/DECISION_008_DAY_STRUCTURE_REVEALS_AND_TRANSITIONS.md` — compatible avec la structure de journée.
- `docs/decisions/DECISION_009_DIALOGUE_TURN_TAKING_AND_GUIDED_REPLIES.md` — compatible avec le modèle de réponses guidées.
- `docs/narrative/MARIE_ARC_J1_J10.md` — Marie reste bien le centre dramatique et le point de reprise de pouvoir.
- `docs/narrative/SANDRA_ARC_J1_J10.md` — trajectoire prudente et différée, cohérente avec V0.57.
- `docs/narrative/RAPHAELLE_ARC_J1_J10.md` — clarté / présence / pas de refuge, cohérent avec la priorité différée.
- `docs/narrative/PLAYER_ARC_J1_J10.md` — Player actif, doute, désir, responsabilité narrative : compatible.
- `docs/narrative/NICO_AND_EXTERNAL_PARTNERS.md` — Nico comme miroir social, compatible avec le cadrage V0.57.

## 3. Documents partiellement compatibles

Ces docs restent utiles, mais contiennent encore des hypothèses à relire ou des hiérarchies trop plates.

- `docs/03_ROUTE_ARCHITECTURE.md` — vocabulaire utile, mais lecture initiale trop symétrique.
- `docs/16_ROUTE_REACHABILITY_MATRIX.md` — matrice utile, mais le slice doit rester lu à travers le centre Marie.
- `docs/17_VERTICAL_SLICE_BEAT_SHEET.md` — bon support de slice, mais pas une hiérarchie finale des routes.
- `docs/19_DAY_2_REVEALS_AND_SCENE_FLOW.md` — bon plan J2, mais à relire si une ancienne formulation place une route secondaire au niveau de Marie.
- `docs/20_DAY_3_PARTY_PIVOT_PLAN.md` — bon pivot J3, mais à relire comme pivot Marie-centrique.
- `docs/21_DAY_4_FIRST_PROOF_PLAN.md` — utile pour la première preuve, mais à lire comme conséquence d’une hiérarchie déjà orientée.
- `docs/narrative/SCENARIO_SPINE_J1_J10.md` — utile, mais certains passages doivent être relus à l’aune de V0.57.
- `docs/narrative/CHARACTER_ARCS_J1_J10.md` — structure utile, mais la lecture doit être hiérarchisée plutôt que symétrique.
- `docs/narrative/J5_J6_REWRITE_PLAN.md` — pertinent, mais à recentrer explicitement sur Marie et les routes secondaires.

## 4. Documents obsolètes ou remplacés

Aucun document n’a été supprimé ou archivé dans cette passe.

- Pas de convention d’archive explicite détectée.
- Les anciens plans restent conservés, mais plusieurs d’entre eux sont désormais absorbés fonctionnellement par V0.57 + V0.56 + ce rapport.
- Recommandation : ne pas supprimer massivement avant validation produit de la future phase V0.59.

## 5. Documents contradictoires

Aucune contradiction dure n’a été supprimée ici. Le point le plus proche d’une contradiction structurante était :

- `docs/03_ROUTE_ARCHITECTURE.md` — présenté seul, il peut encore donner une lecture trop “panel” des routes ; il a été annoté pour rappeler la hiérarchie V0.57.

Si un document ancien dit explicitement que Marie n’est qu’une route parmi d’autres, ou qu’une route secondaire démarre au même niveau que le centre du couple, il doit être relu comme contradiction avec V0.57.

## 6. Actions réalisées en V0.58

### Docs modifiés
- `docs/story_state/GLOBAL_STORY_STATE.md`
- `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md`
- `docs/narrative/DAILY_RHYTHM_AND_CONTENT_DENSITY.md`
- `docs/narrative/PROOF_AND_SECRET_MAP.md`
- `docs/03_ROUTE_ARCHITECTURE.md`
- `docs/16_ROUTE_REACHABILITY_MATRIX.md`
- `docs/17_VERTICAL_SLICE_BEAT_SHEET.md`
- `docs/19_DAY_2_REVEALS_AND_SCENE_FLOW.md`
- `docs/20_DAY_3_PARTY_PIVOT_PLAN.md`
- `docs/21_DAY_4_FIRST_PROOF_PLAN.md`
- `docs/narrative/SCENARIO_SPINE_J1_J10.md`
- `docs/narrative/CHARACTER_ARCS_J1_J10.md`
- `docs/narrative/J5_J6_REWRITE_PLAN.md`

### Docs créés
- `docs/V0_58_Documentation_Reconciliation_Report.md`

### Docs déplacés / supprimés
- Aucun.

## 7. Actions recommandées après V0.58

- **V0.59 — Reworked J1→J9 Beat Plan**
  - réécrire les beats J1→J9 avec la hiérarchie V0.57 ;
  - garder Marie comme centre de gravité ;
  - éviter tout retour à un casting ou des routes à niveau égal.

- **V0.60+ — Réécriture progressive des jours**
  - réécrire les jours par blocs ;
  - conserver les comportements J1/J2 validés tant qu’ils ne sont pas explicitement rouvertes ;
  - contrôler les locks et les conséquences plus tardives.

- **Nettoyage ultérieur**
  - envisager archivage/suppression seulement après validation produit explicite ;
  - ne retirer les doublons qu’une fois leur remplacement confirmé.

## 8. Notes de validation de lecture

- V0.57 est bien la référence actuelle pour la hiérarchie routes/personnages.
- V0.56 reste l’audit J1→J9.
- Les anciens plans sont conservés, mais annotés ou à relire avec prudence.
- Aucun runtime, aucun JSON narratif, aucun test n’a été modifié dans cette passe.
