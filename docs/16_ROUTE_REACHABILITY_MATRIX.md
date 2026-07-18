# 16 — Matrice d’atteignabilité des routes

> **STATUT HISTORIQUE / SUPERSÉDÉ** — Archive de conception antérieure. Pour J01–J21, `J01_J21_REACHABILITY_MATRIX.md` et `SEASON_1_NARRATIVE_STATE_CONTRACT.md` sont autoritaires.


> V0.57 (`docs/V0_57_Route_Character_Rework_Blueprint.md`) est la référence de hiérarchie route/personnage.
> Ce tableau reste utile pour l’atteignabilité, mais ses routes doivent être lues dans un cadre Marie-centrique et non comme un panel égalitaire.

## Objectif

Définir comment chaque route majeure peut être atteinte, renforcée, fermée ou échouer.

Ce document sert à éviter :

- les routes impossibles ;
- les routes déclenchées par un seul choix isolé ;
- les incohérences entre personnages ;
- les fins qui semblent arbitraires ;
- les branches trop nombreuses à maintenir.

## Principe général

Chaque route majeure doit avoir :

```text
1 chemin principal
1 chemin alternatif
1 chemin d’échec / fermeture
```

Une route ne doit jamais être verrouillée par un seul choix. Elle doit naître par accumulation : variables, flags, signaux passifs et scènes préparatoires.

## Variables et notions utilisées

Variables principales :

```text
marie.trust
marie.lucidity
lie_score
truth_tendency
social_pressure
ludo_jealousy
mathilde.desire
mathilde.loyalty
sandra.attachment
sandra.exposure
raphaelle.attachment
raphaelle.clarity
pauline.interest
pauline.control
nico.desire_for_marie
nico.place_near_marie
```

Signaux passifs possibles :

```text
mathilde_attention_score
sandra_priority_score
marie_neglect_score
raphaelle_clarity_score
pauline_risk_score
nico_surveillance_score
```

## Routes du vertical slice

Le vertical slice ne doit pas prouver toutes les routes du jeu complet.

Routes à rendre atteignables dès le slice :

```text
Mathilde interdite
Sandra ambiguë
Pauline piège
Marie / Nico jalousie
Raphaëlle clarté
```

Routes seulement amorcées dans le slice :

```text
Libertinage
NTR consenti
NTR subi
Harem secret
Trio Marie / Mathilde
```

## Route Marie — Réparation / vérité

### Fonction

Tester si Player peut revenir vers Marie au lieu de nourrir les secrets.

### Chemin principal

Conditions :

```text
marie.trust moyen ou haut
truth_tendency moyen ou haut
lie_score bas ou modéré
marie.lucidity augmente sans humiliation
```

Choix typiques :

- répondre à Marie quand elle écrit ;
- ne pas ignorer ses messages dans les scènes croisées ;
- avouer un trouble avant preuve majeure ;
- ne pas conserver de contenu trop risqué ;
- poser une question sincère sur le couple.

Résultat attendu :

```text
dominante = Marie possible
mode = EXCLUSIF_REPARATION ou ouverture future
menace = secrets contenus
```

### Chemin alternatif

Player a déjà nourri une ambiguïté, mais choisit de dire une vérité partielle avant que Marie découvre seule.

Résultat : Marie est blessée mais la route reste sauvable.

### Échec / fermeture

- mensonge répété ;
- humiliation publique ;
- contenu compromettant découvert ;
- Marie ignorée plusieurs fois ;
- Nico prend une place trop forte.

Résultat : route réparation fermée ou très difficile.

## Route Mathilde — Interdit domestique

### Fonction

Tester le fantasme interdit, le secret domestique et la tension avec Marie.

### Chemin principal

Conditions :

```text
mathilde.desire élevé
mathilde.loyalty encore moyenne ou haute
lie_score moyen ou haut
mathilde_attention_score élevé
marie.lucidity basse ou moyenne
```

Flags préparatoires :

```text
ludo_replied_mathilde_private
mathilde_home_scene_seen
mathilde_ambiguous_joke_accepted
saved_or_favorited_mathilde_content
opened_mathilde_before_marie
```

Choix typiques :

- répondre à Mathilde en privé ;
- accepter les sous-entendus ;
- ne pas reculer quand elle teste ;
- conserver ou mettre en favori une image de Mathilde ;
- mentir à Marie sur la nature de l’échange.

Résultat attendu :

```text
dominante = Mathilde
mode = SECRET_AFFAIR probable
menace = Marie ou Mathilde culpabilise
```

### Chemin alternatif

Mathilde est nourrie par des signaux passifs : favoris, fond d’écran, ouverture en premier, likes. La route devient possible si le joueur ajoute ensuite un choix visible ambigu.

### Échec / fermeture

- Player est trop direct trop tôt ;
- Mathilde.loyalty reste très haute ;
- Marie est humiliée trop vite ;
- Player traite Mathilde comme une simple conquête ;
- Player avoue à Marie et choisit clairement une limite.

Résultat : Mathilde recule ou devient tension contenue.

## Route Sandra — Ambiguïté émotionnelle

### Fonction

Tester la liaison émotionnelle, l’attente, l’exposition et l’obsession.

### Chemin principal

Conditions :

```text
sandra.attachment élevé
sandra.exposure bas ou modéré
sandra_priority_score élevé
lie_score moyen
marie.trust commence à baisser
```

Flags préparatoires :

```text
opened_sandra_first_at_party
sandra_late_confession_answered
ludo_shared_couple_doubt_with_sandra
sandra_message_deleted_seen
```

Choix typiques :

- répondre avec douceur ;
- se confier à elle ;
- ne pas exiger trop vite une réponse claire ;
- ouvrir Sandra en priorité pendant une scène croisée ;
- protéger son ambiguïté.

Résultat attendu :

```text
dominante = Sandra
mode = SECRET_AFFAIR émotionnelle
menace = exposition ou Marie
```

### Chemin alternatif

Player se retire calmement. Si Sandra.attachment est assez haut, elle revient par peur de perdre le lien.

### Échec / fermeture

- Player demande trop vite : « tu veux quoi avec moi ? » ;
- Sandra.exposure trop haut ;
- Player compare Sandra à Marie ;
- Player traite une photo de Sandra comme une preuve de conquête ;
- Sandra découvre qu’elle est une femme parmi d’autres dans un harem secret.

Résultat : Sandra fuit ou devient froide.

## Route Raphaëlle — Clarté / alternative réelle

### Fonction

Tester la sortie saine, le refus du secret et la possibilité d’une relation claire.

### Chemin principal

Conditions :

```text
raphaelle.attachment moyen ou haut
raphaelle.clarity haut
truth_tendency moyen ou haut
lie_score bas ou reconnu
```

Flags préparatoires :

```text
accepted_raphaelle_coffee
ludo_admitted_fatigue_to_raphaelle
raphaelle_clarity_boundary_seen
```

Choix typiques :

- accepter son attention sans mentir ;
- admettre que ça ne va pas ;
- ne pas lui demander de rester un secret ;
- éviter de la comparer à Sandra ;
- poser une limite claire avec Marie ou les autres avant d’aller trop loin.

Résultat attendu :

```text
dominante = Raphaëlle possible
mode = POLY_HONEST ou rupture propre future
menace = flou de Player
```

### Chemin alternatif

Player a menti au début, mais reconnaît le problème et accepte la clarté. Raphaëlle reste prudente mais la route n’est pas fermée.

### Échec / fermeture

- Player veut la garder comme secret ;
- Player cherche seulement un pansement ;
- lie_score trop haut sans aveu ;
- harem secret actif ;
- Raphaëlle découvre qu’elle est une option parmi d’autres.

Résultat : Raphaëlle coupe ou devient distante.

## Route Pauline — Piège / renversement

### Fonction

Tester la manipulation sociale, les preuves et la dynamique de pouvoir.

### Chemin principal : Pauline piège

Conditions :

```text
pauline.interest moyen ou haut
pauline.control élevé
pauline_risk_score élevé
lie_score moyen ou haut
social_pressure moyen
```

Flags préparatoires :

```text
opened_pauline_photo_at_party
answered_pauline_provocation
wrote_compromising_message_to_pauline
pauline_has_capture
```

Choix typiques :

- ouvrir le message de Pauline pendant la soirée ;
- répondre à sa provocation ;
- écrire trop clairement ;
- conserver une photo compromettante ;
- mentir à Marie sur Pauline.

Résultat attendu :

```text
dominante = Pauline ou menace = Pauline
mode = SECRET_AFFAIR ou CHAOS future
menace = preuve
```

### Chemin alternatif : Pauline renversée

Player comprend qu’elle cherche une preuve et refuse d’écrire trop vite. Si Pauline.interest reste haut mais Pauline.control baisse, une route de renversement devient possible plus tard.

### Échec / fermeture

- Player ignore Pauline plusieurs fois ;
- Player montre tout à Marie trop tôt ;
- Pauline perd tout contrôle sans consentement narratif ;
- Player refuse le jeu et coupe proprement.

Résultat : Pauline reste menace secondaire ou se retire.

## Route Nico / Marie — Jalousie et NTR amorcé

### Fonction

Tester la jalousie de Player et la possibilité que Marie soit désirée ailleurs.

### Chemin principal : NTR subi amorcé

Conditions :

```text
nico.place_near_marie moyen ou haut
marie.trust baisse
marie_neglect_score élevé
ludo_jealousy moyen ou haut
lie_score moyen ou haut
```

Flags préparatoires :

```text
nico_reacted_to_marie_story
ludo_checked_nico_story
ignored_marie_during_sandra_or_mathilde
nico_complimented_marie_seen
```

Choix typiques :

- négliger Marie pendant des scènes croisées ;
- vérifier obsessivement Nico sans parler à Marie ;
- répondre ailleurs alors que Marie attend ;
- laisser Nico occuper la conversation de groupe ;
- mentir à Marie pendant qu’elle se rapproche de Nico.

Résultat attendu :

```text
dominante = Nico / Marie possible
mode = NTR_SUBI amorcé
menace = Nico
```

### Chemin alternatif : NTR consenti amorcé

Player exprime sa jalousie sans accuser, Marie avoue aimer être regardée, et le couple peut transformer cette tension en discussion d’ouverture future.

### Échec / fermeture

- Player revient sincèrement vers Marie ;
- Nico est confronté tôt ;
- Marie se sent de nouveau désirée par Player ;
- ludo_jealousy reste bas.

Résultat : Nico reste rival latent mais non central.

## Route Libertinage — Amorçage

### Fonction

Tester une future ouverture de couple, généralement via Pauline ou Marie.

### Chemin principal

Conditions :

```text
truth_tendency moyen ou haut
marie.trust encore récupérable
pauline.interest moyen
social_pressure moyen
```

Flags préparatoires :

```text
ludo_admitted_desire_to_marie
pauline_opened_desire_discussion
marie_did_not_reject_opening_topic
```

Résultat attendu :

```text
mode = LIBERTINE_NEGOTIATED possible plus tard
```

### Échec / fermeture

- mensonge trop haut ;
- Marie humiliée ;
- Mathilde secrète déjà trop avancée ;
- Sandra infidélité émotionnelle découverte.

## Route Harem secret — Amorçage

### Fonction

Tester si Player tente de tout garder.

### Chemin principal

Conditions :

```text
au moins 3 routes nourries
lie_score élevé
plusieurs contenus conservés
truth_tendency bas
```

Flags possibles :

```text
saved_mathilde_content
opened_sandra_first_at_party
answered_pauline_provocation
accepted_raphaelle_attention_without_clarity
ignored_marie_message
```

Résultat attendu :

```text
mode = HAREM_SECRET ou CHAOS_EXPLOSION futur
menace = Pauline / Marie / Sandra fuite / Raphaëlle coupe
```

### Échec / fermeture

- Player avoue ;
- Raphaëlle coupe ;
- Sandra fuit ;
- Pauline expose ;
- Marie découvre trop tôt.

## Route Fond d’écran compromettant — Transversale

### Fonction

Tester une interaction passive forte transformée en preuve sociale.

### Chemin principal

Conditions :

```text
current_wallpaper_content_id non neutre
wallpaper_risk_level moyen ou haut
scene_reveals_wallpaper = true
```

Effets selon tags :

```text
wallpaper_tag_marie_tender       → Marie rassurée
wallpaper_tag_mathilde_ambiguous → Marie soupçonneuse, Mathilde gênée
wallpaper_tag_sandra_intimate    → Marie blessée, Sandra exposée
wallpaper_tag_pauline_risky      → Pauline gagne contrôle
wallpaper_tag_marie_nico         → jalousie / NTR
```

### Échec / fermeture

Si fond neutre ou scène non prévue, aucun effet majeur.

## Tests de parcours à créer plus tard

Chaque route du vertical slice devra avoir un parcours de référence.

Format :

```text
Route : [nom]
Objectif : [dominante / mode / menace]
Choix clés :
- ...
Signaux passifs :
- ...
Résultat attendu :
- dominante = ...
- secondaire = ...
- menace = ...
- mode = ...
```

## Règle finale

> Une route est atteignable quand elle peut être déclenchée par plusieurs décisions cohérentes, fermée par des choix opposés, et expliquée en relisant l’histoire.
