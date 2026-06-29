# J6 — Brief d’implémentation data-first : conséquences des preuves faibles

## Statut

Brief opérationnel pour préparer l’intégration runtime/data-first de J6 sur :

```text
work/j6-data-first-photo-consequences
```

Ce document est un contrat de cadrage. Il ne modifie pas le runtime.

Base attendue :

```text
main = état post-J5 + story_state J5 + outils dialogue authoring
```

Références à respecter :

```text
docs/PROJECT_STATE.md
docs/story_state/J5_SUMMARY.md
docs/story_state/GLOBAL_STORY_STATE.md
docs/story_state/CHARACTER_CONTINUITY_MATRIX.md
docs/writing/dialogue_authoring_tools.md
docs/writing/characters/VOICE_PROFILES.md
game/data/writing/character_voice_profiles.json
game/data/writing/knowledge_state.json
```

## Fonction narrative J6

J6 ne doit pas être une nouvelle journée de photos.

J6 doit traiter les conséquences concrètes des preuves faibles J5 :

```text
une image revue ;
un détail qui reste ;
un comportement qui change ;
un message qu’on n’ose plus envoyer pareil ;
un personnage qui teste si Player a compris ;
un personnage qui réagit au fait que Player continue de fuir ou de revenir.
```

Principe central :

```text
J5 a montré que les photos commencent à parler.
J6 doit montrer que Player commence à agir, esquiver ou corriger sous l’effet de ce qu’elles disent.
```

## Garde-fous J6

Ne pas faire :

```text
- nouvelle avalanche de photos ;
- preuve définitive ;
- confrontation totale Marie ;
- révélation complète Pauline ;
- bascule consommée avec Mathilde / Sandra / Pauline / Raphaëlle ;
- route verrouillée ;
- Nico antagoniste caricatural ;
- Raphaëlle refuge romantique ;
- Sandra trop disponible ;
- Mathilde trop frontale ;
- Pauline omnisciente.
```

Règle :

```text
routes ouvertes ≠ routes assumées
preuves faibles ≠ preuves définitives
désir visible ≠ bascule consommée
jalousie ≠ confrontation finale
```

## Usage obligatoire des outils d’écriture avant runtime

Avant toute intégration runtime J6, lancer ou consulter au minimum :

```bash
python3 tools/dialogue_context_pack.py --character marie --day 6
python3 tools/dialogue_context_pack.py --character pauline --day 6
python3 tools/dialogue_context_pack.py --character mathilde --day 6
python3 tools/dialogue_context_pack.py --character sandra --day 6
python3 tools/dialogue_context_pack.py --character raphaelle --day 6
python3 tools/dialogue_context_pack.py --character nico --day 6
```

Après rédaction runtime, lancer :

```bash
python3 tools/dialogue_rhythm_report.py game/data/conversations/chapter_06_*.json
python3 tools/dialogue_voice_check.py game/data/conversations/chapter_06_marie*.json --character marie
python3 tools/dialogue_voice_check.py game/data/conversations/chapter_06_pauline*.json --character pauline
python3 tools/dialogue_voice_check.py game/data/conversations/chapter_06_mathilde*.json --character mathilde
python3 tools/dialogue_voice_check.py game/data/conversations/chapter_06_sandra*.json --character sandra
python3 tools/dialogue_voice_check.py game/data/conversations/chapter_06_raphaelle*.json --character raphaelle
```

Les warnings des outils d’écriture sont des alertes d’auteur, pas automatiquement des blocages.

## Scope recommandé pour runtime J6

J6 doit rester court et testable.

Créer probablement :

```text
game/data/conversations/chapter_06_index.json
game/data/conversations/chapter_06_marie_morning.json
game/data/conversations/chapter_06_pauline_kept_photos.json
game/data/conversations/chapter_06_mathilde_trace.json
game/data/conversations/chapter_06_sandra_later_echo.json
game/data/conversations/chapter_06_raphaelle_clarity.json
```

Optionnel seulement si nécessaire :

```text
game/data/conversations/chapter_06_social_nico_pressure.json
game/data/visual_content/chapter_06_proofs.json
```

Modifier `DataLoader.gd` uniquement pour ajouter :

```text
res://data/conversations/chapter_06_index.json
```

et `chapter_06_proofs.json` seulement si J6 ajoute vraiment un nouveau bundle visuel.

## Recommandation importante sur les photos

J6 peut utiliser des photos déjà reçues en J4/J5 sans créer beaucoup de nouveaux visuels.

Photos / traces déjà disponibles :

```text
photo_party_after_j5_placeholder
story_marie_nico_j5_placeholder
photo_mathilde_after_party_j5_placeholder
photo_marie_after_party_j5_placeholder
photo_pauline_soft_provocation_j5_placeholder
pauline_cheating_proof_seed_j5_placeholder
capture_player_phone_party_j4_placeholder
photo_party_group_j4_placeholder
```

Créer un nouveau visuel seulement si la scène en a réellement besoin.

Idée : J6 peut être plus fort si une ancienne image change de sens plutôt que si une nouvelle image arrive.

## Structure J6 recommandée

### 1. Marie — Matin / comportement après avoir été vu absent

Conversation :

```text
chapter_06_marie_morning
```

Fonction : Marie vérifie si Player revient vraiment après J5.

Elle ne doit pas accuser frontalement. Elle observe son comportement : regarde-t-il encore le téléphone ? Cherche-t-il Marie ? Fait-il semblant que tout est normal ?

Tonalité :

```text
douce
lucide
un peu lasse
encore désirable
pas seulement jalouse
```

Questions de scène :

```text
Player revient-il vers Marie ou surveille-t-il encore les traces ?
Marie demande-t-elle une preuve d’attention plutôt qu’une explication ?
```

Choix recommandés :

```text
A — poser le téléphone / revenir vers elle
B — minimiser encore
C — parler de Nico au lieu de parler d’elle
D — reconnaître que les photos l’ont travaillé
```

### 2. Pauline — Ce qu’elle garde vraiment

Conversation :

```text
chapter_06_pauline_kept_photos
```

Fonction : Pauline teste si Player se souvient que les images continuent d’exister.

Elle ne doit pas tout révéler. Elle doit plutôt montrer que la possession d’une image change le rapport de force.

Tonalité :

```text
fausse innocence
contrôle
humour froid léger
provocation sociale
```

Questions de scène :

```text
Pauline veut-elle protéger, tester ou manipuler ?
Son propre secret apparaît-il comme faille ou comme menace ?
```

Garde-fou : elle sait parce qu’elle a vu / capturé / gardé. Pas parce qu’elle devine tout.

### 3. Mathilde — La trace devient dette, jeu ou danger

Conversation :

```text
chapter_06_mathilde_trace
```

Fonction : transformer la question J5 “tu l’as gardée ?” en conséquence.

Mathilde ne doit pas devenir plus frontale d’un coup. Elle peut tester le malaise, demander une limite ou forcer Player à nommer ce qu’il fait de la trace.

Tonalité :

```text
taquine
nerveuse
plus prudente si Marie est proche
culpabilité légère
```

Questions de scène :

```text
La photo est-elle une dette ?
Un jeu ?
Un danger ?
Une limite à poser ?
```

### 4. Sandra — Le “plus tard” résonne encore

Conversation :

```text
chapter_06_sandra_later_echo
```

Fonction : montrer si “plus tard” devient promesse ou blessure répétée.

Sandra ne doit pas devenir plus disponible parce qu’elle est touchée. Elle peut être plus personnelle, mais toujours retenue.

Tonalité :

```text
douce
blessée sans accuser
prudente
manque contenu
```

Questions de scène :

```text
Player donne-t-il une place réelle à Sandra ou seulement un créneau ?
Sandra avance-t-elle ou recule-t-elle pour se protéger ?
```

Garde-fou : pas de nouvelle grosse photo directe.

### 5. Raphaëlle — Clarté concrète ou refuge pratique

Conversation :

```text
chapter_06_raphaelle_clarity
```

Fonction : tester si Player cherche vraiment la clarté ou seulement un endroit pratique où déposer ce qu’il refuse d’affronter.

Raphaëlle doit rester ancrée dans le concret : travail, dossier, agenda, notes, fatigue, détails observés.

Tonalité :

```text
sobre
concrète
adulte
un peu plus présente qu’avant
limite nette
```

Questions de scène :

```text
Raphaëlle devient-elle plus chaude sans devenir cachette ?
Player accepte-t-il un regard clair ou cherche-t-il seulement à être soulagé ?
```

Garde-fou : elle ne connaît pas les photos de Pauline, ni le détail de Sandra ou Mathilde.

### 6. Nico / social — optionnel

Conversation optionnelle :

```text
chapter_06_social_nico_pressure
```

Fonction : montrer si Player agit par amour de Marie ou par surveillance de Nico.

Nico doit rester socialement défendable.

À utiliser seulement si J6 a besoin d’un rappel social. Ne pas forcer une scène Nico si Marie et Pauline suffisent.

## Ordre recommandé

Version courte recommandée :

```text
Marie matin
→ Pauline kept photos
→ Mathilde trace
→ Sandra later echo
→ Raphaëlle clarity
```

Version avec rappel social :

```text
Marie matin
→ Pauline kept photos
→ Social / Nico pressure
→ Mathilde trace
→ Sandra later echo
→ Raphaëlle clarity
```

## Variables / flags possibles

Réutiliser autant que possible les variables existantes.

Flags J6 possibles :

```text
j6_phone_put_down_for_marie
j6_marie_photo_consequence_acknowledged
j6_pauline_kept_photo_pressure
j6_pauline_secret_pressure
j6_mathilde_trace_named
j6_mathilde_boundary_set
j6_sandra_later_echo
j6_sandra_receded_softly
j6_raphaelle_clarity_chosen
j6_raphaelle_refuge_refused
j6_nico_pressure_seen
```

Ne pas créer de nouvelles variables chiffrées sans mise à jour explicite du validateur.

## Critère de réussite

J6 est réussi si le joueur sent que :

```text
les photos J5 ne sont pas seulement des objets vus,
mais des choses qui modifient le comportement de Player et des autres.
```

Le joueur doit se demander :

```text
Est-ce que je corrige quelque chose,
ou est-ce que je deviens seulement meilleur pour cacher ?
```

## Validations attendues après runtime

```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest tests.test_godot_prototype_static -v
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

Smoke manuel J6 :

```text
J6 apparaît après J5.
Ordre J6 cohérent.
Pas d’avalanche de nouveaux visuels.
Pas de preuve finale.
Pas de route verrouillée.
Raphaëlle reste concrète.
Sandra reste retenue.
Pauline ne devient pas omnisciente.
Marie reste centrale et désirable.
Mathilde garde Marie en sous-texte.
```
