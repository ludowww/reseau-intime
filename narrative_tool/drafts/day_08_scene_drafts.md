# Day 8 Scene Drafts

## Purpose
Créer un draft narrative_tool des deux scènes J8 prévues en V0.40, en restant strictement documentation-only : deux scènes SMS courtes, lisibles, respirables, sans runtime, sans JSON, sans index J8, sans preuve/photo/flag/content_id.

## Current baseline
- Branche de travail : `work/j8-scene-drafts-v0-41`
- Base vérifiée au départ : `main / origin/main @ 595afbc`
- Tag de départ : `v0.40-j8-narrative-beat-sheet`
- État du dépôt au départ : arbre propre
- Périmètre : documentation-only

## Sources inspected
### J8 direction / beat sheet
- `narrative_tool/docs/j8_narrative_direction.md`
- `narrative_tool/drafts/day_08_narrative_beat_sheet.md`

### Relectures précédentes
- `narrative_tool/docs/j5_j8_narrative_arc_character_rhythm_reassessment.md`
- `narrative_tool/docs/j5_sms_runtime_review_after_pauline_sandra_rewrite.md`
- `narrative_tool/docs/j6_j7_rhythm_review.md`

### Runtime J5-J7 read-only
- `game/data/conversations/chapter_05_index.json`
- `game/data/conversations/chapter_05_*.json`
- `game/data/conversations/chapter_06_index.json`
- `game/data/conversations/chapter_06_*.json`
- `game/data/conversations/chapter_07_index.json`
- `game/data/conversations/chapter_07_*.json`
- `game/data/visual_content/chapter_05_proofs.json`
- `game/data/visual_content/chapter_06_proofs.json`
- `game/data/visual_content/chapter_07_proofs.json`
- Hors-champ vérifié : `game/data/conversations/chapter_06_raphaelle_clarity.json` existe, mais n’est pas listé dans `chapter_06_index.json`.

### Docs d’écriture / voix / arcs
- `docs/writing/dialogue_authoring_tools.md`
- `docs/writing/characters/VOICE_PROFILES.md`
- `docs/narrative/DIALOGUE_CONTENT_TEXTURE_RULES.md`
- `docs/narrative/DAILY_RHYTHM_AND_CONTENT_DENSITY.md`
- `docs/narrative/ANTI_LOOP_RULES.md`
- `docs/narrative/PLAYER_RESPONSE_RULES.md`
- `docs/narrative/CONSENT_AND_RISK_RULES.md`
- `docs/narrative/MARIE_ARC_J1_J10.md`
- `docs/narrative/RAPHAELLE_ARC_J1_J10.md`
- `docs/story_state/GLOBAL_STORY_STATE.md`
- `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md`

### Story_state summaries
- `docs/story_state/J6_SUMMARY.md` — absent
- `docs/story_state/J7_SUMMARY.md` — absent
- `docs/story_state/J8_SUMMARY.md` — absent

### Sources absentes connues vérifiées
- `docs/dialogue_tool/` — absent
- `game/narrative_memory/day_08.json` — absent
- `game/narrative_routes/routes_schema.json` — absent

## Runtime absence check
- `game/data/conversations/chapter_08_index.json` — absent
- `game/data/conversations/chapter_08_*.json` — absent
- `game/data/visual_content/chapter_08_proofs.json` — absent

## J8 constraints
- Deux scènes fortes par défaut.
- Raphaëlle = clarté concrète, pas refuge.
- Marie = contrepoint émotionnel, pas confrontation.
- Sandra = silence actif seulement si une micro-trace devient vraiment indispensable.
- Pauline = trace indirecte seulement.
- Mathilde hors centre.
- Nico absent.
- Aucun runtime, aucun JSON, aucun index, aucune preuve, aucune photo, aucun flag, aucun route lock.
- Pas de panel, pas de tour de table, pas de mini-thèse, pas d’escalade finale.
- Choix Player courts et envoyables.

## Scene draft overview
| Ordre | Scène | Fonction | Longueur cible | Statut |
|---|---|---|---|---|
| 1 | Raphaëlle / clarté concrète | Ouvrir J8, poser une limite lisible, recentrer Player sur un geste concret | 12 à 20 bulles, choix inclus | obligatoire |
| 2 | Marie / contrepoint émotionnel | Faire sentir le coût affectif de la clarté sans fermer les routes | 12 à 20 bulles, choix inclus | obligatoire |
| 3 | Trace Sandra | Rappel très bref, sans vraie scène, seulement si la fin paraît trop sèche | 3 à 5 bulles max | non retenue par défaut |

## Scene 1 — Raphaëlle / clarté concrète
### Intent
Ouvrir J8 avec une clarté adulte et concrète. Raphaëlle ne console pas : elle nomme un décalage, pose une limite, et demande un geste lisible.

### Trigger
Un fait simple qui ne tient plus dans le flou : délai, dossier rouvert puis refermé, réponse différée, fatigue visible, ou décision laissée en suspens.

### Draft SMS
Raphaëlle: J’ai vu le dossier rester ouvert.
Raphaëlle: Puis se refermer sans finir.
Raphaëlle: Ce n’est pas la même chose que “je gère”.
Player choice A: Je le finis maintenant.
Player choice B: Je le laisse à plus tard.
Raphaëlle: Mieux.
Raphaëlle: Alors fais-le proprement.
Raphaëlle: Pas pour me plaire. Pour être net.
Player choice A: Je t’envoie le point clair.
Player choice B: Je te l’écris quand c’est prêt.
Raphaëlle: Oui.
Raphaëlle: Court, simple, sans brouillard.
Raphaëlle: Je préfère ça à une présence tiède.

### Choice shape
- Choix 1 : assumer ou esquiver un geste concret.
- Choix 2 : transparence simple ou délai propre.
- Choix Player courts, 3 à 6 mots, sans mini-thèse.

### Ending beat
Le jour reste ouvert, mais Player repart avec un cap. Raphaëlle n’offre pas de refuge : elle laisse une ligne claire.

### Why it works
- Elle clarifie sans consoler.
- Elle parle de faits, de délai et de geste.
- Elle reste calme, mais ferme.
- Elle évite la romance alternative.

### Risks
- Glisser vers une voix thérapeutique.
- Devenir une cachette confortable.
- Trop expliquer le triangle.
- Faire monter la scène en mini-discours.

### Runtime notes
Cette scène peut plus tard devenir un fichier runtime SMS court, mais sans IDs définitifs, sans content_id, sans flag, sans preuve, et sans index J8 dans cette branche.

## Scene 2 — Marie / contrepoint émotionnel
### Intent
Faire sentir le coût émotionnel de la clarté. Marie ramène le couple dans le champ, parle depuis le quotidien, et laisse paraître une distance réelle sans basculer en confrontation.

### Trigger
Un détail domestique simple qui révèle la tension : pain racheté, café refroidi, réponse plus rapide aux autres qu’à elle, ou silence plus présent que d’habitude.

### Draft SMS
Marie: J’ai racheté du pain.
Marie: L’autre était trop sec.
Marie: Comme si la matinée voulait déjà parler.
Player choice A: Je suis là maintenant.
Player choice B: J’ai été ailleurs.
Marie: Oui.
Marie: Et c’est ça qui me fatigue.
Marie: Pas le pain.
Player choice A: Je te l’accorde.
Player choice B: Je peux faire mieux.
Marie: Je ne te demande pas un grand discours.
Marie: Je te demande de ne pas m’effacer.
Marie: Et de me parler comme si on comptait encore.

### Choice shape
- Choix 1 : rassurer ou reconnaître.
- Choix 2 : assumer un peu plus ou promettre mieux.
- Choix courts, envoyables, sans justification longue.

### Ending beat
Le couple reste visible, la distance aussi. La scène ne ferme pas les routes ; elle laisse une fatigue lisible et un lien encore en place.

### Why it works
- Un détail concret porte la tension.
- Marie reste lucide sans être explosive.
- Le couple demeure au centre.
- La scène garde une porte ouverte au lieu d’un verdict.

### Risks
- Monter trop vite en jalousie lourde.
- Transformer Marie en tribunal.
- Faire du “maintenant” une clôture.
- Aller vers une rupture verbale prématurée.

### Runtime notes
En runtime futur, cette scène doit rester courte, textuelle et respirable. Elle ne doit pas ajouter de preuve, de photo, de flag, ni de lock de route.

## Optional trace decision
### Trace Sandra : utile ou non ?
Pas comme scène active. Oui seulement comme silence actif très court si la fin a besoin d’un dernier souffle.

### Trace Pauline : utile ou non ?
Oui seulement en bordure, comme trace indirecte déjà existante. Pas comme scène directe.

### Aucune trace : préférable ou non ?
Oui, préférable par défaut. C’est la meilleure façon d’éviter un mini-panel.

### Questions tranchées
- La scène Raphaëlle fonctionne-t-elle comme clarté concrète sans devenir refuge ? **Oui.**
- La scène Marie fonctionne-t-elle comme contrepoint émotionnel sans devenir confrontation ? **Oui.**
- Les deux scènes suffisent-elles sans trace Sandra ? **Oui, par défaut.**
- Faut-il garder Sandra seulement en silence actif ? **Oui, si trace minimale nécessaire.**
- Faut-il garder Pauline seulement en trace indirecte ? **Oui.**
- Le rythme SMS reste-t-il court ? **Oui.**
- Les choix Player sont-ils envoyables ? **Oui.**
- J8 reste-t-il sans panel ? **Oui.**

## Character presence check
| Personnage | Présence dans le draft | Conforme V0.39/V0.40 ? | Commentaire |
|---|---|---|---|
| Raphaëlle | active principale | oui | Clarté concrète, limite lisible, pas de refuge |
| Marie | active secondaire | oui | Contrepoint émotionnel, couple visible |
| Sandra | silence actif | oui | Absente en scène, possible micro-trace seulement |
| Pauline | trace indirecte | oui | Restée en bordure, aucun contrôle direct |
| Mathilde | hors centre | oui | Pas de retour au triangle domestique |
| Nico | absent | oui | Aucun moteur narratif utile pour J8 |

## SMS rhythm check
| Règle | Raphaëlle | Marie | Conforme |
|---|---|---|---|
| Max 3 messages personnage avant Player | 3 / 3 / 3 | 3 / 3 / 3 | oui |
| Choix courts | 3 à 6 mots | 3 à 6 mots | oui |
| Pas de mini-thèse | oui | oui | oui |
| Pas d’exposition | oui | oui | oui |
| Pas de panel | oui | oui | oui |

## Runtime integration notes
- J8 pourra plus tard devenir 2 fichiers runtime + index, mais pas dans cette branche.
- Les drafts doivent rester convertibles en JSON plus tard sans imposer d’IDs définitifs.
- Aucun `content_id`, `flag`, `photo` ou `proof` n’est proposé.
- Si runtime futur il y a, garder deux scènes par défaut.
- La trace Sandra doit rester hors runtime sauf validation explicite.

## Risks
- Raphaëlle peut basculer vers une cachette douce si la limite n’est pas assez nette.
- Marie peut basculer vers une confrontation trop tôt si le détail quotidien n’ancre pas la scène.
- Une micro-trace Sandra peut réouvrir la boucle “plus tard”.
- Pauline ne doit pas revenir sous forme de contrôle direct.
- Les choix doivent rester courts ; sinon la scène devient explicative.

## Recommendation
**Option A — Drafts J8 validables avec 2 scènes seulement : Raphaëlle + Marie.**

Pourquoi :
- J6 reste la référence d’un jour hiérarchisé.
- J7 montre le risque d’un équilibre trop stable entre plusieurs voix.
- J8 doit casser cet équilibre, pas le reproduire.
- Raphaëlle donne la clarté, Marie donne le coût émotionnel.
- Une troisième trace, même courte, risque vite de recréer un effet panel.

## Non-goals
- No runtime patch in V0.41.
- No game/data modification.
- No index modification.
- No chapter_08_index.json.
- No chapter_08 runtime file.
- No JSON conversation.
- No route lock.
- No new photo.
- No new content_id.
- No new flag.
- No new proof.
- No confrontation finale.
- No full 100-message dialogue.
- No tests/tool changes.
- No reports generated.

## Next recommended step
Garder ce draft comme base de cadrage seulement. Si une traduction runtime est demandée plus tard, la faire en conservant exactement la hiérarchie : Raphaëlle d’abord, Marie ensuite, Sandra uniquement en silence actif, Pauline seulement en bordure.
