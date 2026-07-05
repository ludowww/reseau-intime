# V0.75 — J3 Runtime vs Canonical Source Audit

## 1. Décision de lecture

Le brut validé prime sur le JSON pour le texte, le ton, les beats et l’ordre émotionnel.
Le JSON reste l’implémentation technique.

Baseline relue pour cet audit : `main` à `364a771aa05b60cf75f7802696abe2bfb52d7d90`.

## 2. Méthode

Catégories utilisées :
- conforme ;
- adaptation technique acceptable ;
- divergence mineure ;
- divergence importante ;
- bloquant.

Périmètre relu :
- `docs/V0_74_Canonical_J3_Source_Pack.md` ;
- `game/data/conversations/chapter_03_index.json` ;
- `game/data/conversations/chapter_03_marie_morning.json` ;
- `game/data/conversations/chapter_03_sandra_midday.json` ;
- `game/data/conversations/chapter_03_marie_evening.json` ;
- `game/data/conversations/chapter_03_mathilde_late_night.json` ;
- `game/data/visual_content/placeholders.json` ;
- `tests/test_godot_prototype_static.py` ;
- `tools/simulate_route_paths.py`.

## 3. J3 — Audit global

### 3.1 Verdict global

**OK avec vigilance.**

Le runtime J3 suit bien la source canonique : ordre, routes actives, tonalité domestique, absence de route lock, et pivot nocturne Mathilde sont cohérents. Les écarts visibles sont surtout des reformulations et de petites compressions de beat, sans retour au vieux J3 “soirée / panel / Pauline / Nico / photo canapé”.

### 3.2 Conformités

- Le titre d’index reflète bien la maison et l’appel tardif de Mathilde.
- L’ordre est correct : Marie matin → Sandra midi → Marie soir → Mathilde nuit.
- Aucune conversation Nico / Pauline / Raphaëlle n’est active.
- Aucun groupe actif n’apparaît dans l’index J3.
- Aucune route lock n’est présente.
- Les routes actives restent limitées à `marie`, `sandra`, `mathilde`.
- Les quatre visuels J3 référencés sont présents dans `placeholders.json`.
- Les quatre visuels J3 sont `is_proof: false` et `risk_level <= 1`.
- Aucun sender auto-rendu Player/Ludo n’apparaît dans les messages ou choices examinés.
- Aucun retour vers `party_day3`, `canapé`, `panel`, `Pauline`, `Nico` ou `Raphaëlle` n’a été trouvé dans le J3 actif.

### 3.3 Adaptations techniques acceptables

- Segmentation JSON en plusieurs segments par conversation.
- IDs techniques par conversation / segment / message / choice.
- `choices` séparés du texte narratif canonique.
- Garde des `guided_reply` implicites via choices courts et naturels.
- `content_id` attribué seulement quand utile pour l’ancrage visuel.
- Métadonnées `design_goal` / `debug_notes` présentes.
- Notifications / unlocks de l’index utilisées comme implémentation technique.
- Le runtime garde des titres de conversation plus courts que les titres canoniques, ce qui reste acceptable tant que le sens reste stable.

### 3.4 Divergences mineures

- **Marie matin** : la présence de Mathilde est plus indirecte que dans la source canonique. Le climat domestique est bon, mais la trace explicite de Mathilde est moins lisible.
- **Sandra midi** : le ton reste doux, mais certaines lignes sont un peu plus romanesques que le matériau canonique minimal.
- **Marie soir** : la scène prépare le calme et la nuit, mais le motif araignée n’est pas encore perceptible dans le texte ; la préparation reste très générique.
- **Mathilde nuit** : le pivot domestique est bien là, mais le texte insiste davantage sur l’aide immédiate et la transparence possible que sur le simple embarras du plafond.
- **Titres de conversation** : les titres runtime sont plus courts / plus typés que les formulations canoniques, sans casser le sens.

### 3.5 Divergences importantes

- Aucune divergence importante bloquante n’a été relevée dans le périmètre demandé.
- Aucune sexualisation frontale de Mathilde n’a été observée.
- Marie ne devient pas moralement absente ; elle reste une grille affective lisible.
- Aucune réactivation de l’ancien J3 “soirée / panel / Pauline / Nico / photo canapé” n’apparaît.
- Aucun Player automatique ni sender incorrect n’a été détecté.

### 3.6 Décision produit recommandée

**Conserver le runtime tel quel pour l’instant.**

Si une V0.76 est prévue, elle serait de réalignement fin, pas de réparation structurelle : surtout pour rendre la trace de Mathilde un peu plus lisible dans Marie matin et pour faire sentir un peu plus tôt la préparation du motif araignée dans Marie soir.

## 4. Audit par fichier runtime

### 4.1 `chapter_03_index.json`

**Statut : conforme, adaptation technique acceptable.**

Points conformes :
- titre correct pour la lecture canonique J3 ;
- ordre des moments exact ;
- 4 conversations privées seulement ;
- aucune route lock ;
- `routes_available` limitées à Marie / Mathilde / Sandra ;
- unlocks simples et lisibles ;
- notification Mathilde strictement domestique.

Points à noter :
- le `title` runtime est plus compact que le texte canonique, mais reste aligné.
- `conversation_files` ne reflètent pas toute la richesse du source pack, ce qui est normal techniquement.

### 4.2 `chapter_03_marie_morning.json`

**Statut : conforme avec vigilance.**

Fidèle au canon :
- cuisine / café / chaussettes au centre ;
- ton tendre, gourmand, vivant ;
- une seule interaction Player via choices ;
- pas de panel, pas de jalousie lourde, pas de route social.

Divergence mineure :
- Mathilde est surtout en sous-texte. Le canon attend des traces déjà présentes dans la maison ; le runtime reste dans ce sens, mais de manière plus diffuse.

### 4.3 `chapter_03_sandra_midday.json`

**Statut : conforme.**

Fidèle au canon :
- roman idiot, lac, respiration douce ;
- Sandra reste prudente, rare, sans concurrence directe avec Marie ;
- ton bref et pudique ;
- aucune intensification frontale.

Divergence mineure :
- certaines formulations sont un peu plus émotionnelles que la simple respiration attendue, mais sans franchir la ligne.

### 4.4 `chapter_03_marie_evening.json`

**Statut : conforme avec vigilance.**

Fidèle au canon :
- Marie ferme la journée tôt ;
- le couple reste la grille morale ;
- pas de crise ;
- pas de route lock ;
- pas de photo non consentie ;
- pas d’ancienne soirée pivot.

Divergence mineure :
- la préparation du motif araignée reste très indirecte.
- le runtime prépare le calme plus qu’il ne prépare explicitement le basculement domestique nocturne.

### 4.5 `chapter_03_mathilde_late_night.json`

**Statut : conforme.**

Fidèle au canon :
- pivot domestique nocturne bien présent ;
- araignée / plafond / chambre / aide au centre ;
- ton proche, pudique, humain ;
- pas de sexualisation frontale ;
- pas de preuve ;
- pas de route lock ;
- transparence possible envers Marie préservée ;
- aucune fermeture malsaine du lien.

Divergence mineure :
- le runtime rend la scène un peu plus explicite dans l’aide proposée, mais cela reste compatible avec la lecture canonique.

### 4.6 `placeholders.json`

**Statut : conforme pour le périmètre J3.**

Conformité vérifiée :
- `marie_j3_kitchen_soft_placeholder` : `is_proof: false`, `risk_level: 1` ;
- `sandra_j3_lake_page_placeholder` : `is_proof: false`, `risk_level: 1` ;
- `mathilde_j3_ceiling_spider_placeholder` : `is_proof: false`, `risk_level: 1` ;
- `mathilde_j3_room_recovered_placeholder` : `is_proof: false`, `risk_level: 1`.

Lecture produit :
- les quatre ids J3 sont soft, non suggestifs et compatibles avec la source canonique ;
- aucune preuve ambiguë n’est active dans le périmètre J3 audité.

## 5. Tableau de réalignement futur

| Fichier runtime | Source canonique | Type de divergence | Gravité | Recommandation | Correction runtime nécessaire oui/non |
|---|---|---:|---:|---|---|
| `chapter_03_index.json` | Ordre et verrouillage J3 | N/A | faible | conserver | non |
| `chapter_03_marie_morning.json` | Traces de Mathilde déjà présentes | omission / sous-texte plus faible | mineure | réalignement léger si on veut renforcer la lecture canonique | non |
| `chapter_03_sandra_midday.json` | Écho doux à midi | reformulation légère | mineure | conserver | non |
| `chapter_03_marie_evening.json` | Préparation naturelle du motif araignée | préparation trop indirecte | mineure | réalignement plus tard seulement si on veut une couture canonique plus visible | non |
| `chapter_03_mathilde_late_night.json` | Pivot domestique nocturne | légère condensation / aide un peu plus explicite | mineure | conserver | non |
| `placeholders.json` | 4 visuels J3 soft non-proof | conforme | faible | conserver | non |

## 6. Verdict final

J3 peut **rester tel quel**.

Une V0.76 de réalignement JSON n’est **pas nécessaire** pour la stabilité produit ; elle ne serait utile que pour de la micro-polish canonique, principalement sur :
- `game/data/conversations/chapter_03_marie_morning.json`
- `game/data/conversations/chapter_03_marie_evening.json`

On peut donc **passer à la définition du nouveau J4** sans correction J3 préalable.
