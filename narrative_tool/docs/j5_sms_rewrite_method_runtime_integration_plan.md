# J5 SMS Rewrite Method & Runtime Integration Plan

## Purpose
Formaliser une méthode commune de réécriture SMS pour J5, comparer les prototypes Pauline et Sandra, puis décider comment les intégrer plus tard au runtime sans casser les invariants validés.

Ce document ne modifie pas le runtime. Il sert de pont entre prototype et future intégration.

## Current baseline
- Branch de départ validée : `main`
- SHA de départ validé : `7c54ac6`
- Travail mené sur la branche : `work/j5-sms-rewrite-method-runtime-plan-v0-34`
- Runtime J5 actuel : déjà indexé dans `game/data/conversations/chapter_05_index.json`
- Prototypes verrouillés :
  - `narrative_tool/drafts/day_05_pauline_understands_sms_rewrite_prototype.md`
  - `narrative_tool/drafts/day_05_sandra_first_truth_game_sms_rewrite_prototype.md`

## Sources inspected
### Prototypes SMS
- `narrative_tool/drafts/day_05_pauline_understands_sms_rewrite_prototype.md`
- `narrative_tool/drafts/day_05_sandra_first_truth_game_sms_rewrite_prototype.md`

### Diagnostic V0.31
- `narrative_tool/docs/j5_j8_narrative_arc_character_rhythm_reassessment.md`
- Sections lues en priorité : Writing Style Regression, Writing style decisions, Recommended decisions for J5, Recommended direction for J8

### Runtime J5
- `game/data/conversations/chapter_05_index.json`
- `game/data/conversations/chapter_05_pauline_photos.json`
- `game/data/conversations/chapter_05_sandra_later.json`
- `game/data/conversations/chapter_05_marie_morning.json`
- `game/data/conversations/chapter_05_mathilde_followup.json`
- `game/data/conversations/chapter_05_social_story.json`
- `game/data/conversations/chapter_05_raphaelle_boundary.json`
- `game/data/conversations/chapter_05_pauline_last_photo.json`
- `game/data/visual_content/chapter_05_proofs.json`
- `game/data/state/initial_state.json`

### Références style initial
- `game/data/conversations/chapter_01_marie.json`
- `game/data/conversations/chapter_01_sandra.json`
- `game/data/conversations/chapter_02_marie_morning.json`
- `game/data/conversations/chapter_02_sandra_evening.json`
- `game/data/conversations/chapter_03_marie_morning.json`
- `game/data/conversations/chapter_03_sandra_evening.json`

### Docs d’écriture / rythme
- `docs/writing/dialogue_authoring_tools.md`
- `docs/writing/characters/VOICE_PROFILES.md`
- `docs/narrative/DIALOGUE_CONTENT_TEXTURE_RULES.md`
- `docs/narrative/DAILY_RHYTHM_AND_CONTENT_DENSITY.md`
- `docs/narrative/ANTI_LOOP_RULES.md`
- `docs/narrative/PROOF_AND_SECRET_MAP.md`
- `docs/narrative/PLAYER_RESPONSE_RULES.md`
- `docs/narrative/CONSENT_AND_RISK_RULES.md`
- `docs/narrative/PAULINE_ARC_J1_J10.md`
- `docs/narrative/SANDRA_ARC_J1_J10.md`
- `docs/story_state/J5_SUMMARY.md`
- `docs/story_state/GLOBAL_STORY_STATE.md`
- `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md`

### Sources absentes vérifiées sans échec
- `docs/dialogue_tool/` — absent
- `game/narrative_memory/day_05.json` — absent
- `game/narrative_routes/routes_schema.json` — absent

## Why this plan exists
Les deux prototypes valident la même direction générale, mais pas avec la même pression narrative.

- Pauline montre surtout le risque de scène trop démonstrative, trop longue, trop “explicative”.
- Sandra montre surtout le risque inverse : garder la retenue et le manque, mais les noyer dans une disponibilité verbale continue.

Le besoin réel est donc de distinguer :
1. la méthode commune de réécriture SMS ;
2. ce qui doit rester propre à chaque voix ;
3. l’ordre d’intégration runtime le plus sûr ;
4. les critères à vérifier avant tout patch runtime.

## Common SMS rewrite method
Méthode commune validée par les deux prototypes :

1. Maximum 3 messages personnage d’affilée avant réponse Player.
2. Une bulle = une idée.
3. Choix Player courts, idéalement 3 à 9 mots.
4. Supprimer les mini-thèses Player.
5. Transformer les explications en sous-entendus.
6. Garder les photos comme traces faibles, pas comme révélations définitives.
7. Ne pas ajouter de flags, branches ou photos nouvelles dans la réécriture prototype.
8. Préserver la fonction route/personnage de la scène.
9. Vérifier que la tension reste lisible après réduction.
10. Ne pas uniformiser toutes les voix : le même rythme ne doit pas aplatir Pauline, Sandra, Marie, Mathilde ou Raphaëlle.

Lecture pratique :
- Pauline valide surtout la compression d’une scène trop “parlée”.
- Sandra valide surtout la compression d’une scène trop “retenue mais explicative”.
- Les deux confirment qu’un vrai SMS n’est ni un monologue ni un résumé de monologue.

## Pauline vs Sandra comparison

| Axe | Pauline J5 prototype | Sandra J5 prototype | Méthode commune | Différence à préserver |
|---|---|---|---|---|---|
| Fonction narrative | Gardienne des images, contrôle social, test de réaction | Retour du manque, prudence, photo retrouvée / presque envoyée | Réécrire une scène SMS qui fait avancer une route sans l’expliquer | Pauline = maîtrise / cadrage ; Sandra = retenue / absence |
| Type de tension | Pression, contrôle, sous-entendu, malaise observateur | Blessure légère, attente, manque, hésitation | Garder la tension dans les ellipses et le timing | Pauline est plus intrusive ; Sandra plus fragile |
| Rapport à la photo | Photo faible utilisée comme appât ou trace | Photo comme souvenir / absence / hésitation | La photo doit rester faible et fonctionnelle | Pauline manipule la photo ; Sandra la retient |
| Rapport au silence | Silence comme méthode de test | Silence comme protection ou blessure | Le silence porte une partie du sens | Chez Sandra, le silence doit rester blessure ; chez Pauline, levier |
| Type de danger | Danger de lecture trop explicite, trop de contrôle visible | Danger de sentimentalisation ou de “plus tard” permanent | Réduire sans perdre la charge relationnelle | Pauline = domination ; Sandra = dilution |
| Type de choix Player | Réactions rapides, presque défensives, parfois provocantes | Réponses plus affectives, plus prudentes | Les choix doivent être envoyables et courts | Pauline autorise plus de piquant ; Sandra demande plus de retenue |
| Risque si trop raccourci | Devenir sec, mécanique, froid | Perdre le manque et la nuance | Garder une tension après réduction | Pauline ne doit pas devenir sèche ; Sandra ne doit pas devenir plate |

## Runtime J5 risk review
### Ce que le runtime montre déjà
- J5 est déjà structuré et entièrement indexé dans `chapter_05_index.json`.
- La journée est organisée en 7 moments : Marie, Mathilde, Pauline, story sociale, Raphaëlle, Sandra, Pauline final.
- Les proofs J5 sont déjà présents dans `chapter_05_proofs.json`.
- Les deux scènes prototypes ciblées existent déjà dans le runtime : Pauline et Sandra.

### Ce que les stats confirment
- Pauline runtime : 21 messages avant la première fenêtre de réponse Player.
- Sandra runtime : 16 messages avant la première fenêtre de réponse Player.
- Les deux scènes restent trop longues pour un vrai rythme SMS.
- Pauline est la plus mécanique sur le plan structurel.
- Sandra est un peu moins longue, mais son risque est plus fin : garder le manque sans l’étirer en commentaire.

### Références style initial
Les scènes J1-J3 montrent qu’un rythme plus vivant reste possible :
- bursts plus courts ;
- choix plus courts ;
- alternance plus naturelle ;
- Player moins “thèse” et plus réponse réelle.

### Absences importantes
Les sources d’outillage ou schéma suivantes ne sont pas présentes :
- `docs/dialogue_tool/`
- `game/narrative_memory/day_05.json`
- `game/narrative_routes/routes_schema.json`

Cela signifie qu’il ne faut pas compter sur un système externe pour absorber la réécriture : la clarification doit rester documentaire et runtime-local plus tard.

## Recommended runtime integration sequence
### Option A — intégrer Pauline d’abord
Avantages :
- traite la scène la plus mécanique d’abord ;
- valide la méthode SMS sur un cas clairement trop long ;
- réduit le risque de conserver une scène “explicative” en croyant la corriger ;
- donne un test net sur photo faible / contrôle / sous-texte.

Limites :
- risque de sous-estimer ensuite la finesse de Sandra si la méthode est trop “coupante” ;
- Pauline peut être corrigée vers le court, mais sans solutionner à elle seule toute la densité J5.

### Option B — intégrer Sandra d’abord
Avantages :
- teste immédiatement la retenue et le manque ;
- peut préserver mieux la nuance émotionnelle si la méthode est déjà stable.

Limites :
- moins bon banc d’essai pour la méthode ;
- le risque principal est subtil, donc plus facile à rater ;
- on peut croire que “ça marche” alors que la structure SMS n’est pas encore bien verrouillée.

### Option C — intégrer les deux dans une seule branche
Avantages :
- un seul passage de validation ;
- cohérence globale immédiate.

Limites :
- mélange les diagnostics ;
- rend plus difficile l’attribution des régressions ;
- augmente le risque de casser la lisibilité de J5 ;
- complique les validations fines sur bursts, choix et photo faible.

### Recommendation
**Recommandation : Option A, puis Option B, en passes séparées.**

Pourquoi : Pauline est le meilleur test de méthode car c’est la scène la plus structurellement problématique. Une fois la compression SMS validée sur le cas le plus mécanique, Sandra peut être intégrée avec une attention spécifique à la retenue et au manque.

## Runtime integration checklist
- [ ] Diff limité à un seul fichier runtime si possible.
- [ ] Aucun index modifié.
- [ ] Aucun content_id ajouté.
- [ ] Aucun flag ajouté sauf nécessité déjà validée.
- [ ] Aucun route lock.
- [ ] Aucune preuve définitive.
- [ ] Aucun changement J1-J4.
- [ ] Maximum 3 messages personnage consécutifs avant réponse Player.
- [ ] Choix Player majoritairement courts et envoyables.
- [ ] Fonction narrative préservée.
- [ ] Voix personnage préservée.
- [ ] Validation data OK.
- [ ] Simulation routes OK.
- [ ] Tests OK.
- [ ] Godot headless OK.

## Non-goals
- No runtime patch in V0.34.
- No game/data modification.
- No index modification.
- No scene rewrite in runtime.
- No draft modification.
- No route lock.
- No new memory/state system.
- No tests/tool changes.
- No direct copy from prototype to runtime.

## Risks
- Patcher directement `game/data/` maintenant casserait la comparaison propre entre prototype et runtime.
- Modifier deux scènes d’un coup peut masquer quel changement a réellement amélioré ou dégradé le rythme.
- Une réécriture trop agressive peut aplatir la différence entre Pauline et Sandra.
- Un patch runtime précipité peut aussi affecter l’ordre J5 déjà verrouillé dans l’index.
- La tentation de “réparer le texte” peut conduire à toucher la structure, les preuves ou les IDs, ce qu’il faut éviter tant que la méthode n’est pas validée.

## Next recommended step
Préparer une intégration runtime séparée, d’abord Pauline puis Sandra, avec un diff minimal et une vérification stricte des critères ci-dessus avant toute modification de `game/data/`.
