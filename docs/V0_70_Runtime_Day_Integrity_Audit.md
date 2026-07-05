# V0.70 — Runtime Day Integrity Audit & Guardrails

## Baseline
- Repo : `ludowww/reseau-intime`
- Branche : `work/runtime-day-integrity-audit-v0-70`
- SHA de départ : `594c72b740c717ab0ba1b6ca9e0b4f9edf3740e0`
- Périmètre : audit statique + tests + rapport, sans réécriture narrative.

## Résumé exécutif
- J1, J2, J3, J4, J5, J6, J7 et J9 sont cohérents avec les fichiers réellement chargés par `DataLoader.gd`.
- Aucun `content_id` actif ne manque dans les bundles visuels chargés.
- `placeholders.json` conserve bien les profils essentiels et les visuels J2/J3 attendus ; il n’a pas été réduit à un catalogue partiel.
- Le point faible majeur reste J8 : `chapter_08_index.json` existe sur disque, mais `DataLoader.gd` ne le charge pas.

## Tableau d’audit par jour

| Jour | Conversations actives attendues | Conversations réellement chargées | Visuels chargés | Fichiers dormants / legacy détectés | Risques narratifs | Risques runtime | Verdict |
|---|---|---|---|---|---|---|---|
| J1 | 2 threads : Marie, Sandra (Mathilde indirecte) | `chapter_01_marie`, `chapter_01_sandra` | `placeholders.json`, `chapter_01_proofs.json` | `chapter_01_group_friends.json`, `chapter_01_raphaelle.json` | faibles ; socle conforme | faibles ; aucun id manquant | OK |
| J2 | 7 threads : Marie / Raphaëlle / Mathilde / Sandra | `chapter_02_marie_morning`, `chapter_02_raphaelle_midday`, `chapter_02_marie_afternoon`, `chapter_02_mathilde_evening`, `chapter_02_sandra_evening`, `chapter_02_marie_night`, `chapter_02_mathilde_night` | `placeholders.json` | `chapter_02_group_pauline_night.json`, `chapter_02_mathilde_home.json`, `chapter_02_social_marie_nico.json` | faibles à moyens ; beaucoup de présence mais structure propre | faibles ; tous les ids actifs existent | OK |
| J3 | 4 threads : Marie / Sandra / Mathilde | `chapter_03_marie_morning`, `chapter_03_sandra_midday`, `chapter_03_marie_evening`, `chapter_03_mathilde_late_night` | `placeholders.json` | `chapter_03_crossed_notifications.json`, `chapter_03_party_aftershock.json`, `chapter_03_party_group_arrival.json`, `chapter_03_party_pressure.json`, `chapter_03_pre_party_threads.json`, `chapter_03_wallpaper_reveal.json` | faibles ; journée compacte | faibles ; aucun visuel actif absent | OK |
| J4 | 3 threads : Pauline / Marie / groupe | `chapter_04_pauline_invite`, `chapter_04_marie_pre_party`, `chapter_04_party_group_arrival` | `placeholders.json`, `chapter_04_proofs.json` | `chapter_04_conditional_proofs.json`, `chapter_04_marie_morning_reaction.json`, `chapter_04_mathilde_observes.json`, `chapter_04_pauline_late_control.json`, `chapter_04_raphaelle_lunch_contrast.json`, `chapter_04_route_pressure_and_debug.json`, `chapter_04_sandra_bad_timing.json`, `chapter_04_social_after_party.json` | moyens ; soirée plus dense, mais logique | faibles à moyens ; surcharge possible si dormant activé par erreur | OK |
| J5 | 7 threads : Marie, Nico social, Mathilde, Pauline, Raphaëlle, Sandra, Pauline final | `chapter_05_marie_couple_vacille`, `chapter_05_social_story`, `chapter_05_mathilde_kitchen_trial`, `chapter_05_pauline_understands`, `chapter_05_raphaelle_work_breath`, `chapter_05_sandra_first_truth_game`, `chapter_05_pauline_last_photo` | `placeholders.json`, `chapter_05_proofs.json` | aucun | moyens ; jour dense, mais cohérent | faibles ; ids et unlocks alignés | OK |
| J6 | 4 threads : Mathilde / Marie / Pauline / Sandra | `chapter_06_mathilde_trace_choice`, `chapter_06_marie_position`, `chapter_06_pauline_silence_price`, `chapter_06_sandra_one_truth` | `placeholders.json`, `chapter_06_proofs.json` | `chapter_06_raphaelle_clarity.json` | faibles à moyens ; tension bien cadrée | faibles ; aucune référence active manquante | OK |
| J7 | 4 threads : Mathilde / Marie / Sandra / Pauline | `chapter_07_mathilde_too_close`, `chapter_07_marie_senses_difference`, `chapter_07_sandra_lamp_soft`, `chapter_07_pauline_less_theoretical` | `placeholders.json`, `chapter_07_proofs.json` | aucun | faibles ; rythme lisible | faibles ; bundles et ids concordent | OK |
| J9 | 1 thread : Sandra seule, traces Marie / Pauline indirectes | `chapter_09_sandra_relance` | `placeholders.json`, `chapter_09_proofs.json` | aucun | faibles ; option A minimaliste respectée | faibles ; aucun active content_id manquant | OK |

## Section spéciale — J5 / J6 : mismatches d’IDs
### Conclusion
Il n’y a pas de mismatch runtime entre `moment_flow` et les conversations chargées.

### Ce qui pouvait sembler faux
- Les noms de fichiers ne correspondent pas aux `conversation_id` internes.
- Exemple J5 : `chapter_05_marie_morning.json` contient l’id `chapter_05_marie_couple_vacille`.
- Exemple J6 : `chapter_06_mathilde_trace.json` contient l’id `chapter_06_mathilde_trace_choice`.

### Pourquoi ce n’est pas un bug runtime
- `DataLoader.gd` charge les fichiers puis indexe les conversations par leur champ `id`, pas par leur nom de fichier.
- Les `moment_flow[].conversation_ids[]` pointent bien vers ces ids internes.
- Les tests ajoutés verrouillent explicitement cette correspondance pour J5 et J6.

### Verdict J5/J6
- **OK en l’état** : pas de correction technique nécessaire.
- Si un futur source pack renomme un fichier sans conserver l’id interne, le test doit échouer immédiatement.

## Section spéciale — J8 absent
### Constats
- `game/data/conversations/chapter_08_index.json` existe sur disque.
- `DataLoader.gd` ne le charge pas, car `CHAPTER_INDEX_PATHS` saute de `chapter_07_index.json` à `chapter_09_index.json`.
- Aucun bundle `chapter_08_*` n’est listé dans `VISUAL_CONTENT_PATHS`.
- Les fichiers J8 présents sur disque restent donc dormants / non runtime.

### Impact
- Le runtime ne peut pas afficher J8.
- Si J8 doit être livré comme jour actif, c’est un manque de loader, pas un problème narratif.

### Décision
- **À corriger avant livraison J8**, sinon **dormant/legacy documenté**.
- Dans le cadre de cette passe, aucun contenu narratif n’a été inventé ni réécrit.

## Section spéciale — Catalogues visuels
### Bundle partagé `placeholders.json`
- Le catalogue contient 19 items, donc il n’a pas été remplacé par une version partielle.
- Profils essentiels présents :
  - `profile_marie_placeholder`
  - `profile_sandra_placeholder`
  - `profile_mathilde_placeholder`
  - `profile_raphaelle_placeholder`
  - `profile_pauline_placeholder`
  - `profile_nico_placeholder`
- Visuels J2 / J3 essentiels présents :
  - `marie_j2_morning_soft_placeholder`
  - `raphaelle_j2_work_badge_placeholder`
  - `mathilde_j2_arrival_marie_placeholder`
  - `mathilde_j2_couch_innocent_selfie_placeholder`
  - `sandra_j2_lake_book_soft_placeholder`
  - `marie_j3_kitchen_soft_placeholder`
  - `sandra_j3_lake_page_placeholder`
  - `mathilde_j3_ceiling_spider_placeholder`
  - `mathilde_j3_room_recovered_placeholder`

### Couverture des `content_id`
- Tous les `content_id` actifs des jours chargés sont résolus par un bundle visuel chargé.
- Aucun contenu actif ne retombe sur un id orphelin.

### Lecture technique
- Les bundles J1, J4, J5, J6, J7, J9 sont chargés explicitement par `DataLoader.gd`.
- J2 et J3 utilisent bien le catalogue partagé `placeholders.json` pour leurs contenus actifs.

## Règles anti-régression à conserver pour les prochains source packs
1. Vérifier les ids, pas seulement les noms de fichiers : `moment_flow[].conversation_ids[]` doit correspondre aux `id` internes chargés.
2. Tout `initial_conversation_id`, `locked_conversation_id`, clé `unlocks` et `after_conversation_completed` doit exister dans les conversations chargées du jour.
3. Aucun `conversation_file` chargé ne doit rester orphelin de `moment_flow` / `conversation_availability`, sauf si le fichier est explicitement déclaré dormant.
4. Tout `content_id` actif doit exister dans un bundle visuel chargé.
5. `placeholders.json` doit rester un catalogue complet, pas une extraction J2/J3 partielle.
6. Les fichiers dormants doivent être documentés, pas activés par accident.
7. Si un jour intermédiaire comme J8 doit être livré, le loader et les tests doivent être mis à jour ensemble.

## Verdict final
- **OK** : J1, J2, J3, J4, J5, J6, J7, J9.
- **À corriger / bloquant si J8 doit être runtime** : `chapter_08_index.json` n’est pas chargé par `DataLoader.gd`.
