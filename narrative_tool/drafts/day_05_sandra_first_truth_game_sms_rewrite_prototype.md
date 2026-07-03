# Day 5 Sandra First Truth Game — SMS Rewrite Prototype

## Purpose

Prototype a version of `chapter_05_sandra_first_truth_game` that reads like a real private SMS exchange instead of a long explanatory monologue.

Goals:

- shorter Sandra bursts,
- faster alternance,
- shorter Player choices,
- more silence and suspension,
- less emotional explanation,
- Sandra still prudent, hurt, and rare,
- no runtime change yet.

This is a `narrative_tool` draft only.

## Source runtime diagnosis

Target runtime file:

- `game/data/conversations/chapter_05_sandra_later.json`

Runtime conversation ID:

- `chapter_05_sandra_first_truth_game`

Current shape, observed from the runtime scene:

- 1 segment.
- 16 Sandra messages before the first Player reply window.
- Average Sandra bubble length: about 36 characters.
- Longest Sandra bubble: 97 characters.
- 3 Player choices.
- Average Player choice length: about 16.7 words.
- Longest Player choice: 21 words.
- One visual trace only: `j5_sandra_restaurant_soft_crop`.

Absent sources confirmed without failure:

- `docs/dialogue_tool/` not found.
- `game/narrative_memory/day_05.json` not found.
- `game/narrative_routes/routes_schema.json` not found.

### Diagnosis matrix

| Élément source | Diagnostic | Action prototype |
|---|---|---|
| Burst Sandra | Beaucoup trop long : 16 messages d’affilée avant réponse Player. Effet scène parlée, pas SMS vivant. | Réduire à 2–3 messages max avant une relance Player. |
| Choix Player | Trop longs, trop “mini-thèse”, pas assez envoyables. | Raccourcir fortement, viser 3 à 9 mots. |
| “Plus tard” / manque | Présent en creux, mais noyé dans l’explication et le commentaire. | Préserver, mais le rendre implicite et blessant. |
| Photo supprimée / retenue | Bonne matière de manque, mais encore traitée comme appât explicatif. | Garder comme absence, pas comme récompense. |
| Ton Sandra | Prudente et blessée, mais parfois trop disponible verbalement. | Garder la prudence, couper la disponibilité continue. |
| Rythme J5 | Narrativement valide, rythmiquement surchargé. | Alléger, respirer, re-donner la main au Player plus tôt. |

### Ce que le runtime fait déjà bien

- Sandra reste une ancienne amie, pas une romance générique.
- Le manque passe par la photo absente / presque envoyée.
- Il n’y a pas de preuve définitive.
- Le jeu confidence/photo est bien posé.
- Le lien est fragile sans être frontal.

### Ce qui gêne le plus

- trop de messages Sandra avant la première ouverture Player,
- trop d’explication dans les phrases de Sandra,
- plusieurs choix Player qui sonnent comme des postures développées,
- une sensation de “tout dire” alors que Sandra devrait garder de la retenue,
- un risque de disponibilité trop continue.

## What must be preserved

- Sandra comme ancienne amie / lien réactivé.
- Prudence émotionnelle.
- Retenue.
- Blessure légère autour du “plus tard”.
- Désir par absence, pas par disponibilité.
- Aucune nouvelle photo Sandra J5.
- Aucune déclaration frontale.
- Aucune attaque contre Marie.
- Aucune route lock.
- Aucune preuve définitive.
- Aucune disponibilité permanente.
- Le contenu visuel existant doit rester une trace faible, pas un trophée.

## What should change

- Alternance SMS plus nette.
- Réponses Player plus fréquentes.
- Bulles plus courtes.
- Moins d’explication émotionnelle.
- Moins de Sandra qui verbalise tout.
- Plus de sous-entendu.
- Plus de silence / suspension.
- Plus de gêne ou d’esquive.
- Choix Player envoyables comme textos.
- Un rythme qui donne l’impression d’un vrai échange privé.

## Rewrite principles

1. Never more than 3 Sandra messages in a row before a Player reply.
2. One Sandra message = one idea.
3. Player choices should ideally be 3–9 words.
4. No paragraph that explains the scene’s meaning.
5. Let silence carry part of the pressure.
6. Sandra can be sharp, but not exhaustive.
7. The Player should feel he is answering a person, not a briefing.
8. The “photo” should remain a trace, not a reveal machine.

## Prototype dialogue

### Segment 1 — Photo retrouvée

Sandra: J’ai retrouvé la photo du restaurant.

Sandra: Enfin, “retrouvé”, c’est un peu vite dit.

Player choice A: Tu la gardes ?

Sandra: J’hésite.

Player choice B: Elle t’embête ?

Sandra: Un peu. Justement.

Sandra: C’est comme ça que ça reste.

### Segment 2 — Pas “plus tard”

Sandra: Je n’aime pas trop les rendez-vous qui deviennent du flou.

Sandra: Ça fait joli, mais ça laisse vide.

Player choice A: Je peux répondre maintenant.

Sandra: Oui.

Player choice B: Je veux pas te faire attendre.

Sandra: Alors ne m’apprends pas à attendre.

Sandra: Ça, j’ai déjà assez donné.

### Segment 3 — Ce qu’elle n’envoie pas

Sandra: J’ai failli t’envoyer autre chose.

Sandra: Puis j’ai fermé l’écran.

Player choice A: Tu regrettes ?

Sandra: Non.

Player choice B: Tu veux que je voie ?

Sandra: Pas encore.

Sandra: Peut-être jamais comme ça.

Sandra: Ou peut-être autrement.

### Segment 4 — Crochet final

Sandra: Je suis prudente, tu sais.

Sandra: C’est juste que je ne fais pas semblant d’être disponible.

Player choice A: Je préfère ça.

Sandra: Menteur.

Player choice B: Reste là.

Sandra: Je suis là.

Sandra: Mais pas à tout prix.

## Choice mapping

| Runtime choice intent | Current issue | Prototype SMS option |
|---|---|---|
| `J’aime bien quand tu fais semblant d’être prudente alors que tu viens d’inventer un jeu dangereux.` | Trop long, trop commenté, trop “lecture de scène”. | `Tu la gardes ?` |
| `Si tu m’envoies une photo moins responsable, je risque de répondre moins raisonnablement.` | Phrase brillante mais trop développée, pas assez texto. | `Je peux répondre maintenant.` |
| `J’ai envie de jouer. Mais je ne veux pas te donner l’impression que je t’appelle seulement quand ma vie devient floue.` | Trop explicatif, trop auto-commentaire. | `Je veux pas te faire attendre.` |
| `Qu’est-ce que tu attends de moi, exactement ?` | Trop frontal / analytique pour un échange SMS intime. | `Tu veux que je voie ?` |
| `C’est peut-être mieux qu’on garde ça pour plus tard.` | Réactive le “plus tard” sans le charger émotionnellement. | `Reste là.` |

## Comparison with Pauline J5 prototype

### Ce qui doit rester commun

- alternance plus nette,
- choix courts,
- pas d’exposition longue,
- pas de paragraphes explicatifs,
- pas de nouvelle photo,
- pas de scène qui annonce sa propre idée au lieu de parler.

### Ce qui doit différer

- Pauline = contrôle, cadrage, maîtrise sociale.
- Sandra = manque, retenue, blessure douce, absence.
- Pauline pousse vers la lecture des traces.
- Sandra garde la trace à distance et laisse le vide faire pression.

### Ce que la méthode SMS confirme

- Le prototype SMS marche mieux quand une idée = une bulle.
- Le Player reprend de l’épaisseur quand il répond vite et court.
- Le silence est plus fort qu’une explication de sentiment.

### Ce que la méthode doit adapter à Sandra

- moins de démonstration que Pauline,
- moins de contrôle affiché,
- plus de fragilité retenue,
- plus de peur de déranger,
- plus de désir par retrait que par appât.

## Runtime integration notes

Ce qui pourrait être intégré plus tard si on voulait rapprocher le runtime du prototype :

- couper le burst initial à 2–3 messages Sandra,
- remplacer certaines phrases explicatives par des relances courtes,
- raccourcir les trois choix Player,
- préserver l’idée de photo faible / presque envoyée,
- conserver `chapter_05_sandra_first_truth_game` comme conversation ID,
- garder `j5_sandra_truth_game_seed` si la logique de seed est déjà attendue,
- garder `j5_sandra_restaurant_soft_crop` comme trace visuelle si l’intégration future le demande.

Ce qui doit rester hors runtime pour l’instant :

- toute nouvelle photo Sandra,
- toute route lock,
- toute preuve définitive,
- toute nouvelle branche narrative,
- toute reformulation qui transforme Sandra en personnage trop disponible.

En pratique, l’intégration future devrait préserver :

- `chapter_05_sandra_first_truth_game`,
- `thread_sandra_private`,
- `j5_sandra_truth_game_seed`,
- `j5_sandra_restaurant_soft_crop`,
- l’absence de nouveau content_id,
- l’absence de nouveau flag narratif.

## Risks

- Si Sandra devient trop courte, elle peut perdre sa retenue et son trouble.
- Si les choix Player deviennent trop “secs”, ils peuvent sembler artificiels.
- Si le manque est trop explicite, il devient mécanique.
- Si on ajoute une explication de plus, le texte retombe dans le monologue.
- Si Sandra devient trop présente, elle cesse d’être rare.

## Recommendation

Garder cette version comme référence SMS pour Sandra J5.

Ne pas intégrer au runtime maintenant.

La bonne suite est une comparaison avec le runtime actuel lors d’une future passe d’intégration minimale, sans toucher `game/data/` pour le moment.
