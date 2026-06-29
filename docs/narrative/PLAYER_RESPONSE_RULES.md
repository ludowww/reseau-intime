# Règles de réponse Player

## Problème identifié

Depuis J5/J6, Player devient trop souvent une absence.

Structure actuelle trop fréquente :

```text
Personnage parle.
Choix abstrait du joueur.
Personnage réagit.
```

Il manque :

```text
Player dit quelque chose.
Player ment.
Player assume.
Player esquive.
Player formule une contradiction.
Player provoque une réaction par ses mots, pas seulement par l’étiquette du choix.
```

## Règle principale

```text
Chaque choix narratif important doit correspondre à une vraie réponse de Player.
```

L’UI peut garder un choix court, mais le JSON doit prévoir une réponse visible ou au moins une formulation claire dans les `next_messages`.

## Format recommandé

### Option 1 — Réponse Player visible après choix

```json
{
  "id": "choice_example_truth",
  "text": "Reconnaître que j’étais ailleurs.",
  "tone": "truth",
  "next_messages": [
    {
      "id": "msg_player_truth_001",
      "sender": "ludo",
      "text": "Oui. J’étais ailleurs, et je ne peux pas te demander de faire semblant de ne pas l’avoir vu."
    },
    {
      "id": "msg_marie_truth_001",
      "sender": "marie",
      "text": "Merci de ne pas me servir une excuse trop propre."
    }
  ]
}
```

### Option 2 — Choix court + réponse implicite documentée

À utiliser seulement si l’UI ou le rythme impose de ne pas afficher Player.

```json
{
  "id": "choice_example_refuge",
  "text": "Chercher un refuge.",
  "tone": "vulnerable",
  "player_subtext": "Je cherche un endroit où ne pas devoir répondre tout de suite.",
  "next_messages": [
    {
      "id": "msg_raphaelle_refuge_001",
      "sender": "raphaelle",
      "text": "Je comprends l’envie. Mais un refuge ne doit pas devenir une cachette."
    }
  ]
}
```

À terme, l’option 1 est préférable pour les scènes fortes.

## Ce qu’il faut éviter

Choix abstraits sans réponse incarnée :

```text
Reconnaître le flou.
Chercher un refuge.
Répondre avec humour.
Poser une limite.
Être honnête.
```

Ces choix peuvent rester comme labels UI, mais le script doit savoir ce que Player dit réellement.

## Exemples par type de réponse

### Vérité partielle

```text
Oui. J’étais ailleurs. Je ne sais pas encore comment te l’expliquer sans rendre ça plus laid.
```

Usage : Marie, Raphaëlle, Sandra.

Effet : baisse du mensonge, mais ne résout pas tout.

### Mensonge doux

```text
C’était juste la fatigue. Je crois que tu cherches quelque chose qui n’est pas là.
```

Usage : Marie, Raphaëlle.

Effet : protège à court terme, abîme la confiance.

### Esquive par humour

```text
Je plaide coupable de mauvaise gestion du timing, mais pas encore de crime international.
```

Usage : Sandra, Mathilde, Pauline.

Effet : peut préserver la complicité, mais doit parfois être lu comme fuite.

### Aveu de désir sans bascule

```text
Je ne vais pas faire semblant que ça ne m’a rien fait. Mais je ne sais pas quoi faire proprement de cette phrase.
```

Usage : Sandra, Mathilde, Pauline.

Effet : augmente le trouble sans consommer la route.

### Limite claire

```text
Non. Là, si je continue, je vais appeler ça un jeu juste parce que ça m’arrange.
```

Usage : Mathilde, Pauline.

Effet : peut réduire désir immédiat, mais augmente cohérence.

### Retour vers Marie

```text
Je dois arrêter de transformer tout ça en choses que je gère dans un coin. Je dois revenir vers Marie.
```

Usage : Raphaëlle, Sandra, Mathilde.

Effet : vérité / coût / fermeture partielle d’opportunité.

## Règles de style Player

Player n’est pas un héros parfaitement lucide.

Il doit pouvoir être :

```text
- maladroit ;
- sincère à moitié ;
- ironique quand il a honte ;
- tenté de minimiser ;
- capable d’un geste juste ;
- capable d’un mensonge confortable.
```

Mais il ne doit pas devenir :

```text
- analyste parfait de ses émotions ;
- pur manipulateur ;
- pur spectateur ;
- uniquement défini par les réactions des autres.
```

## Règles par personnage

### Avec Marie

Player doit répondre comme quelqu’un qui partage un quotidien.

À éviter : phrases trop théoriques.

Bon registre :

```text
café, écran, matin, fatigue, gestes, regard, maison.
```

### Avec Sandra

Player doit être prudent, touché, parfois maladroit.

À éviter : promesses trop grandes ou place officielle trop tôt.

Bon registre :

```text
moment, timing, manque, retenue, phrase qu’on n’ose pas trop tenir.
```

### Avec Mathilde

Player peut être ironique, mais Marie doit rester dans son angle mort ou son malaise.

À éviter : réponse trop frontale ou trop sexuelle.

Bon registre :

```text
mauvaise foi, limite, maison, photo, jeu qui change de nom.
```

### Avec Pauline

Player peut essayer de reprendre le contrôle, mais Pauline doit pouvoir lire ce geste.

À éviter : la rendre omnisciente ; Player ne doit pas non plus être idiot.

Bon registre :

```text
cadrage, détail, archive, ce qu’elle montre, ce qu’elle refuse.
```

### Avec Raphaëlle

Player doit être ramené au concret.

À éviter : confession romantique ou analyse thérapeutique.

Bon registre :

```text
dossier, agenda, notes, appel, temps, travail propre.
```

## Règle de densité

Toutes les réponses Player ne doivent pas être longues.

Alternance recommandée :

```text
- une réponse courte et humaine ;
- parfois une réponse plus précise ;
- rarement une grande phrase de vérité.
```

Exemples courts :

```text
Oui. Tu as raison.
Je n’ai pas envie de mentir, là.
Je fais une blague parce que je ne sais pas répondre.
Je n’ai pas supprimé. Pas encore.
Je crois que j’ai aimé être regardé. Et c’est le problème.
```

## Application à J5/J6

Réécriture obligatoire :

```text
- ajouter des réponses visibles de Player dans les choix forts ;
- réduire les labels abstraits ;
- faire porter certaines conséquences par ce que Player dit, pas seulement par la réaction du personnage ;
- éviter que chaque personnage analyse Player sans qu’il ne parle vraiment.
```
