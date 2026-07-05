# V0.71 — Canonical Source Priority & J1/J2 Runtime Alignment Audit

## 1. Décision produit

Le brut narratif validé prime sur le JSON pour le texte, le ton, l’ordre émotionnel et les beats.
Le JSON runtime est une implémentation technique fidèle.

En cas de divergence, on liste d’abord l’écart dans un audit avant toute correction runtime.

## 2. Règles d’intégration futures

- Ne pas reformuler les dialogues validés.
- Ne pas condenser plusieurs messages en exposition.
- Ne pas ajouter de nouveau beat sans validation produit.
- Player doit rester manuel via `choices`.
- Les `choices` / `guided_reply` peuvent structurer le brut, mais pas en changer le sens.
- Toute divergence doit être listée avant correction.
- Le `runtime JSON verrouillé` signifie l’état jouable actuel, pas une canonisation automatique du texte.

## 3. J1 — source canonique disponible

Source :
`docs/V0_66_Narrative_Rewrite_Source_Pack_J1.md`

À auditer contre :
- `game/data/conversations/chapter_01_index.json`
- `game/data/conversations/chapter_01_marie.json`
- `game/data/conversations/chapter_01_sandra.json`
- `game/data/visual_content/chapter_01_proofs.json`

### Verdict J1 par fichier

| Fichier | Verdict | Notes |
| --- | --- | --- |
| `chapter_01_index.json` | OK | Hiérarchie jouable conforme : 2 conversations actives, 3 visuels soft, Mathilde indirecte seulement. |
| `chapter_01_marie.json` | divergence mineure | Le fond suit le brut J1, mais le runtime segmente fortement en `guided_reply` et en relances techniques. |
| `chapter_01_sandra.json` | divergence mineure | Même pattern : fidélité de ton et de beats, mais beaucoup de charpente technique autour des messages validés. |
| `chapter_01_proofs.json` | OK | Les 3 visuels soft correspondent à l’intention J1 ; les métadonnées d’asset sont une adaptation technique. |

### Lecture J1

- Fidèle au brut : Marie reste l’ancre, Sandra revient par un déclencheur concret, Mathilde reste une présence indirecte.
- Adaptation technique acceptable : IDs, `content_id`, `guided_reply`, découpage en segments, notification d’ouverture.
- Ajout runtime non présent dans le brut : charpente répétée de follow-ups techniques, nombreux segments intermédiaires obligatoires.
- Reformulation / condensation : faible à modérée ; le sens général tient, mais certains blocs runtime compressent ou réordonnent la respiration du brut.
- Divergence de ton : non bloquante sur les fichiers audités ; la voix reste dans l’axe doux / retenu.
- Divergence bloquante : aucune relevée sur J1 dans cette passe.

## 4. J2 — source canonique à formaliser

Constat :
Le brut J2 validé existe dans les échanges / prompts, mais il n’est pas encore formalisé comme doc source pack canonique.

Action recommandée :
Créer ensuite un vrai `docs/V0_68_Canonical_J2_Source_Pack.md` ou équivalent avant toute correction runtime.

À auditer contre :
- `game/data/conversations/chapter_02_index.json`
- `game/data/conversations/chapter_02_marie_morning.json`
- `game/data/conversations/chapter_02_raphaelle_midday.json`
- `game/data/conversations/chapter_02_marie_afternoon.json`
- `game/data/conversations/chapter_02_mathilde_evening.json`
- `game/data/conversations/chapter_02_sandra_evening.json`
- `game/data/conversations/chapter_02_marie_night.json`
- `game/data/conversations/chapter_02_mathilde_night.json`
- `game/data/visual_content/placeholders.json`

### Verdict J2 par fichier

| Fichier | Verdict | Notes |
| --- | --- | --- |
| `chapter_02_index.json` | OK | Le jour est découpé en moments lisibles, avec Player manuel et 4 pôles actifs/latents conformes au brief actuel. |
| `chapter_02_marie_morning.json` | divergence mineure | Le fond respecte Marie / Mathilde / couple, mais le runtime met en place une forte charpente `guided_reply`. |
| `chapter_02_raphaelle_midday.json` | divergence mineure | Raphaëlle reste extérieure et utile ; l’adaptation technique est propre, mais le format runtime est plus bavard que le brut source pack à formaliser. |
| `chapter_02_marie_afternoon.json` | OK | Marie reste l’axe domestique ; la progression reste lisible. |
| `chapter_02_mathilde_evening.json` | OK | Mathilde devient concrète sans casser le centre de Marie. |
| `chapter_02_sandra_evening.json` | OK | Sandra revient brièvement en écho, avec retenue et respiration. |
| `chapter_02_marie_night.json` | divergence mineure | Transition de fin de journée cohérente, mais plus technique que narrative dans sa structure. |
| `chapter_02_mathilde_night.json` | divergence mineure | Le selfie / canapé reste dans l’axe, mais le runtime ajoute une mécanique de suivi plus lourde que le brut canonique n’est pas encore formalisé à part. |
| `placeholders.json` | OK | Placeholder neutre conforme ; simple support technique. |

### Lecture J2

- Fidèle au runtime actuel : Marie reste le centre, Mathilde devient concrète, Raphaëlle reste extérieure, Sandra reste un écho.
- Adaptation technique acceptable : placeholders, `content_id`, structuration par moments, notifications et files de conversation.
- Ajout runtime non présent dans le brut formalisé : la couche technique `guided_reply` et les enchaînements de segments sont déjà très présents.
- Reformulation / condensation : à vérifier plus finement une fois le brut J2 formalisé ; pour l’instant, l’audit ne peut pas trancher sur le texte canonique faute de source pack doc.
- Divergence de ton : non bloquante sur la passe observée.
- Divergence bloquante : l’absence de source canonique J2 formalisée bloque toute correction produit définitive.

## 5. Verdict attendu

Ne pas modifier le runtime maintenant.

- Ce qui est fidèle : le centre émotionnel, l’ordre des pôles, les déclencheurs concrets, la retenue des voix.
- Ce qui est une structure technique acceptable : IDs, `content_id`, `guided_reply`, découpage en segments, notifications, placeholders.
- Ce qui devra être réaligné plus tard : tout passage runtime qui reformule ou condense le brut sans validation produit supplémentaire.
- Ce qui nécessite une décision produit : la formalisation du brut J2 en vrai source pack canonique.

## 6. Remarque de cadrage

Cet audit ne corrige aucun JSON runtime.
Il sert de base de décision pour une passe produit ultérieure.
