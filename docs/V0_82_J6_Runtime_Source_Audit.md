# V0.82 — J6 Runtime Source Audit

## 1. Décision de lecture

Le brut validé prime sur le JSON pour le texte, le ton, les beats et l’ordre émotionnel.
Le JSON reste l’implémentation technique.

Base auditée : `main` / `origin/main` à `19f338b774281b41affc26753d4ab92f5ba2a17e`.

## 2. Méthode

Catégories :
- conforme
- adaptation technique acceptable
- divergence mineure
- divergence importante
- bloquant

Lecture utilisée : source pack canonique V0.81, J5 canonique V0.77, source of truth actuelle, story_state, runtime J6 index + conversations + visuels + mappings, puis greps demandés.

## 3. Source canonique J6 V0.81

Résumé canonique attendu :
- J6 = retombée sociale des photos J5.
- Nico remarque Marie et reste un ami crédible, miroir masculin, tentateur léger.
- Nico ne doit pas être manipulateur, vulgaire, rival frontal ou dangereux.
- Marie reste centrale et respectée.
- Player choisit une posture : protection, humour, fierté, jalousie, partage social défendable.
- Pauline, Mathilde, Sandra, Raphaëlle ne sont pas actives.
- Pas de vocal, pas d’explicite, pas de photo non consentie, pas de photo intime, pas de proof fort, pas de route lock.
- Minimum 3 contenus visuels, emojis sobres.

Conversations canoniques attendues :
1. `chapter_06_marie_morning_after_outing`
2. `chapter_06_nico_midday_notices_marie`
3. `chapter_06_nico_late_afternoon_limit`
4. `chapter_06_marie_evening_recenter`

Visuels canoniques attendus :
- `marie_j6_after_outing_soft_trace_placeholder`
- `j6_marie_social_photo_reframed_placeholder`
- `nico_j6_glass_social_context_placeholder`
- `j6_nico_chat_trace_placeholder`

## 4. Fichiers runtime J6 trouvés

### Conversations / index
- `game/data/conversations/chapter_06_index.json`
- `game/data/conversations/chapter_06_mathilde_trace.json`
- `game/data/conversations/chapter_06_marie_morning.json`
- `game/data/conversations/chapter_06_pauline_kept_photos.json`
- `game/data/conversations/chapter_06_sandra_later_echo.json`
- `game/data/conversations/chapter_06_raphaelle_clarity.json` (présent, mais non indexé ; référence legacy / inactive)

### Visuels
- `game/data/visual_content/chapter_06_proofs.json`
- `game/data/visual_content/placeholders.json` (mapping partagé qui contient aussi des entrées J6)

## 5. Audit J6

### 5.1 Index et conversations actives

Constat principal : le runtime J6 actuel ne correspond pas à la source canonique V0.81.

L’index actif porte encore une structure legacy centrée sur :
- Mathilde qui force une décision sur la trace ;
- Marie qui sent une position prise ;
- Pauline qui teste le prix du silence ;
- Sandra qui réclame une chose honnête.

Le runtime actif n’implémente donc pas le J6 canonique “Nico remarque Marie”.

Points structurels relevés :
- `routes_available` = `marie`, `mathilde`, `pauline`, `sandra`.
- `routes_locked_to_seed_only` contient `nico_marie`.
- Nico n’a pas de scène active J6 dans l’index.
- Raphaëlle n’est pas active dans l’index, mais un fichier J6 Raphaëlle existe encore dans le dossier.
- Les conversations actives sont les 4 fichiers legacy de trace / silence / honnêteté, pas les 4 beats canoniques attendus.

### 5.2 Conformités

Conformités partielles seulement :
- J6 reste bien une journée de retombée sociale autour d’un regard et de choix de posture.
- Le runtime conserve 4 conversations principales.
- Les messages Player passent bien par des choix dans la structure technique.
- Les visuels de J6 sont tous marqués `is_proof: false` dans `chapter_06_proofs.json`.
- Les visuels sont globalement sociaux / défendables et non explicites.

### 5.3 Adaptations techniques acceptables

Adaptations que le runtime pourrait garder si le fond canonique était déjà aligné :
- usage d’une indexation technique par fichiers séparés plutôt qu’un seul bloc de dialogue.
- séparation entre index, conversations, et bundle visuel.
- présence d’un fichier Raphaëlle J6 non indexé comme référence inactive.

### 5.4 Divergences mineures

- Le fichier `chapter_06_raphaelle_clarity.json` existe encore alors que Raphaëlle ne doit pas être active en J6 canonique.
- Le mapping partagé `placeholders.json` contient des entrées J6 mêlées à d’autres jours, ce qui complique la lecture mais n’est pas bloquant en soi.
- Certains textes restent très orientés “trace / silence / honnêteté” alors que le canon V0.81 attend “Nico remarque Marie”.

### 5.5 Divergences importantes

- Le cœur narratif n’est pas le bon : J6 canonique est Nico + Marie, runtime est Mathilde + Pauline + Sandra.
- L’activation de Pauline et Sandra en J6 contredit la source canonique.
- Le runtime conserve une logique de route/choix héritée (`routes_locked_to_seed_only`), alors que V0.81 impose explicitement “pas de route lock”.
- Le slot Nico est présent comme verrou technique, mais absent comme scène jouée.
- Les visuels runtime ne correspondent pas aux 4 contenus canoniques attendus.
- Les ids de visuels ne sont pas ceux du pack canonique V0.81.

### 5.6 Bloquants éventuels

- Présence de `sender: "ludo"` dans les conversations J6 : le greps demandés le montrent dans les quatre conversations actives, et aussi dans le fichier Raphaëlle non indexé.
- Le canon audit demandé interdit un sender direct Player/Ludo/ludo ; le runtime ne respecte pas cette contrainte.
- `chapter_06_proofs.json` contient un item Mathilde avec `risk_level: 2`.
- Le canon J6 exige `risk_level: 1` pour les visuels J6 attendus.
- Le runtime actuel n’est donc pas seulement “différent” : il est incompatible avec la source canonique V0.81.

### 5.7 Verdict J6

Verdict : **bloquant**.

Le J6 runtime ne peut pas rester tel quel pour V0.82. Il doit être réaligné en V0.83 avant d’être considéré comme compatible avec la source canonique V0.81.

## 6. Audit des visuels J6

Runtime trouvé : `chapter_06_proofs.json` avec 4 items.

| content_id attendu | source canonique attendue | statut runtime | is_proof | risk_level | compatible oui/non | recommandation |
|---|---|---|---|---|---|---|
| `marie_j6_after_outing_soft_trace_placeholder` | Marie, retombée sociale douce après J5 | absent / remplacé par un visuel legacy Marie | false | 1 attendu | non | reconstruire en V0.83 |
| `j6_marie_social_photo_reframed_placeholder` | photo sociale Marie, cadrage défendable | absent / remplacé par `j6_marie_window_soft` | false | 1 attendu | non | reconstruire en V0.83 |
| `nico_j6_glass_social_context_placeholder` | Nico observant Marie dans un contexte social léger | absent | n/a | 1 attendu | non | reconstruire en V0.83 |
| `j6_nico_chat_trace_placeholder` | échange social Nico / trace légère | absent | n/a | 1 attendu | non | reconstruire en V0.83 |

Note visuels runtime réels :
- `j6_mathilde_sink_mirror_tease` : `is_proof: false`, `risk_level: 2`, donc hors cible canonique.
- `j6_marie_window_soft` : `is_proof: false`, `risk_level: 1`, mais l’id ne correspond pas au pack V0.81.
- `j6_pauline_bus_stop_followup` : `is_proof: false`, `risk_level: 1`, mais Pauline ne doit pas être active.
- `j6_sandra_evening_soft` : `is_proof: false`, `risk_level: 1`, mais Sandra ne doit pas être active.

## 7. Anti-régression

### Présence problématique / legacy
- Nico manipulateur / vulgaire / rival frontal : non trouvé comme tel dans le runtime, mais Nico est absent de l’axe joué alors qu’il devrait être central.
- Pauline active : **présente**.
- Mathilde active : **présente**.
- Sandra active : **présente**.
- Raphaëlle active : fichier présent mais **non indexé** ; legacy / inactive.
- NTR : non trouvé dans le runtime grepé.
- harem : non trouvé dans le runtime grepé.
- route lock : **présent** via `routes_locked_to_seed_only`.
- proof fort : non trouvé comme preuve forte active, mais la structure visual_content garde un item Mathilde `risk_level: 2`.
- photo intime : non trouvé explicitement comme telle.
- photo non consentie : non trouvé explicitement comme telle.
- vocal : non trouvé.
- explicite : non trouvé.
- sender direct Player/Ludo/ludo : **présent** (`sender: "ludo"`).

### Lecture
Le runtime évite plusieurs excès lourds, mais il reste incompatible sur les points structurants : mauvais axe narratif, route lock, sender direct `ludo`, et visuels non conformes.

## 8. Tableau de réalignement futur

| fichier runtime | divergence | gravité | recommandation | correction runtime nécessaire | version recommandée |
|---|---|---|---|---|---|
| `game/data/conversations/chapter_06_index.json` | index J6 legacy centré trace / silence / Sandra / Pauline au lieu de Nico / Marie | importante | reconstruire l’index | oui | V0.83 |
| `game/data/conversations/chapter_06_mathilde_trace.json` | conversation active hors canon J6 | importante | remplacer par scène Nico | oui | V0.83 |
| `game/data/conversations/chapter_06_marie_morning.json` | Marie existe, mais dans une scène legacy avec sender ludo | importante | réécrire vers “Marie after outing” | oui | V0.83 |
| `game/data/conversations/chapter_06_pauline_kept_photos.json` | Pauline active alors qu’elle doit être inactive | importante | supprimer du J6 actif | oui | V0.83 |
| `game/data/conversations/chapter_06_sandra_later_echo.json` | Sandra active alors qu’elle doit être inactive | importante | supprimer du J6 actif | oui | V0.83 |
| `game/data/conversations/chapter_06_raphaelle_clarity.json` | fichier legacy non indexé | mineure | garder seulement comme historique / QA | non, si hors index | plus tard |
| `game/data/visual_content/chapter_06_proofs.json` | visuels legacy, ids non canons, un item risk 2 | importante | reconstruire les 4 visuels canoniques | oui | V0.83 |
| `game/data/visual_content/placeholders.json` | mapping partagé qui garde des références J6 legacy | mineure | nettoyer ou documenter les entrées J6 | oui, si on veut aligner le runtime | V0.83 / plus tard |

## 9. Verdict final

- J6 ne peut pas rester tel quel.
- J6 doit être réaligné.
- Une reconstruction runtime en V0.83 est nécessaire.
- Fichiers concernés : l’index J6, les 4 conversations actives, le fichier visuel J6, et au minimum le mapping partagé qui référence encore les placeholders J6.
- On ne peut pas intégrer ce J6 runtime directement sans nettoyage.
- Le runtime actuel doit être traité comme legacy / incompatible avec V0.81.
