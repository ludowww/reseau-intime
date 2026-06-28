# 15 — Fluidité joueur et signaux passifs

## Objectif

Préserver la fluidité du jeu tout en exploitant certaines actions discrètes du joueur.

Le joueur doit sentir que le smartphone est vivant, mais il ne doit pas avoir l’impression qu’il doit optimiser chaque micro-action.

## Principe

Le jeu repose sur deux couches :

```text
1. Choix visibles
2. Signaux passifs
```

Les choix visibles servent à orienter clairement l’histoire.

Les signaux passifs servent à colorer les réactions, détecter les habitudes du joueur et renforcer certaines routes par accumulation.

## Règle centrale

> Le joueur ne doit pas se demander quoi faire à chaque message reçu. La plupart des interactions doivent rester naturelles, rapides et lisibles.

## Charge mentale maximale

### Scène calme

```text
0 à 2 choix visibles
1 notification principale
pas de conséquence forte immédiate
```

### Scène de tension

```text
2 à 3 choix visibles
1 interruption possible
1 risque clair
```

### Scène pivot

```text
3 à 5 choix visibles
plusieurs notifications possibles
conséquence importante possible
```

Règle : les scènes pivots doivent être rares.

## Quand ne pas proposer de choix

Certaines interactions doivent être automatiques ou implicites.

Exemples :

- lire un message ;
- recevoir une notification ;
- voir une story ;
- conserver par défaut une photo non risquée ;
- recevoir une réaction sociale ;
- afficher un statut « vu » ;
- faire avancer une conversation de routine.

Ces moments servent au rythme, pas à la décision.

## Signaux passifs exploitables

### Favoris

Le joueur peut mettre une image en favori.

Effet possible :

- augmente légèrement l’attention envers le personnage ;
- peut être remarqué si la galerie est montrée ;
- peut nourrir une route par accumulation.

Exemple :

```text
Marie : C’est drôle, Mathilde revient souvent dans tes favoris.
```

### Fond d’écran

Signal fort déjà validé.

Le fond d’écran reste privé tant qu’il n’est pas montré. Il devient preuve sociale lors d’une scène de révélation.

### Likes et réactions

Le joueur peut liker ou réagir à des posts/stories.

Effets possibles :

- renforcer une complicité ;
- rendre un personnage plus audacieux ;
- créer une jalousie si un pattern est visible ;
- donner à Pauline ou Nico une occasion de commenter.

Exemple :

```text
Pauline : Tu likes vite quand c’est elle.
```

### Commentaires

Un commentaire est plus visible qu’un like.

Effets possibles :

- pression sociale ;
- réaction publique ;
- message privé déclenché ;
- soupçon de Marie.

### Ordre d’ouverture des conversations

Le jeu peut suivre qui Player ouvre en premier lors de messages croisés.

Exemples :

```text
opened_sandra_first_at_party
opened_mathilde_before_marie
ignored_marie_during_group_scene
```

Effets :

- priorité émotionnelle ;
- jalousie différée ;
- route dominante renforcée.

### Consultations répétées

Le joueur peut revenir plusieurs fois sur une image ou une conversation.

Effets possibles :

- renforcer un score d’obsession ;
- déclencher un commentaire intérieur de Player ;
- influencer une route si combiné avec d’autres signaux.

Exemple :

```text
Player regarde à nouveau la photo de Sandra.
Pensée : Il aurait dû la supprimer.
```

### Ignorer ou laisser attendre

Ne pas ouvrir une notification peut compter.

Effets possibles :

- Marie se sent négligée ;
- Sandra se ferme ;
- Pauline perd ou gagne du contrôle ;
- Raphaëlle comprend que Player évite ;
- Nico prend de la place.

## Signaux passifs à éviter

Ne pas suivre trop d’actions inutiles.

À éviter :

- temps exact passé sur chaque image ;
- micro-optimisation de lecture ;
- trop de statistiques invisibles ;
- punition liée à une seule action anodine ;
- système qui donne l’impression d’espionner le joueur plutôt que Player.

## Scores d’attention possibles

Ces scores sont internes et secondaires.

```text
marie_attention_score
marie_neglect_score
mathilde_attention_score
sandra_priority_score
raphaelle_clarity_score
pauline_risk_score
nico_surveillance_score
```

Ils ne remplacent pas les variables principales. Ils aident à colorer les réactions et à départager certaines routes proches.

## Règles d’utilisation

### 1. Pas de catastrophe sur un seul signal passif

Une action passive isolée ne doit jamais provoquer une rupture, fermer une route ou déclencher une scène majeure.

### 2. Accumulation obligatoire

Un signal passif devient important seulement s’il se répète ou s’il se combine avec un choix visible.

### 3. Réactivation contextuelle

Un signal passif ne doit produire une conséquence que dans un contexte qui le rend lisible.

Exemple : favoris Mathilde → conséquence seulement si Marie voit la galerie ou si Pauline provoque sur ce sujet.

### 4. Debug obligatoire

Le mode debug doit pouvoir afficher :

- les signaux passifs ;
- les scores d’attention ;
- les flags ;
- les effets sur la route dominante.

### 5. Relecture compréhensible

Après une conséquence, le joueur doit pouvoir comprendre :

```text
Oui, j’ai souvent ouvert Sandra en premier.
Oui, j’ai liké plusieurs posts de Mathilde.
Oui, j’ai gardé Pauline en favori.
Oui, j’ai ignoré Marie pendant plusieurs scènes.
```

## Exemple d’utilisation complète

### Situation

Le joueur nourrit Mathilde sans faire de choix explicitement décisif.

Actions :

```text
Jour 2 : ouvre Mathilde avant Marie.
Jour 2 : met une photo de Mathilde en favori.
Jour 3 : like un post de Mathilde.
Jour 3 : ouvre Mathilde en privé pendant le groupe.
Jour 4 : conserve une photo ambiguë.
```

Résultat possible :

```text
mathilde_attention_score élevé
mathilde.desire légèrement renforcé
marie.lucidity +1 si contexte de découverte
route Mathilde favorisée si d’autres choix visibles vont dans le même sens
```

Mais la route Mathilde ne se verrouille pas automatiquement sans choix ou scène de bascule.

## Exemple de scène fluide

```text
Marie : On mange quoi ce soir ?
- Comme tu veux.
- Je peux cuisiner.
- On commande ?
```

Aucun choix critique.

Puis notification discrète :

```text
Mathilde a réagi à votre message.
```

Le joueur peut ignorer ou regarder, mais le jeu ne doit pas créer une surcharge. Cette scène sert au rythme.

## Règle finale

> Les choix visibles doivent guider. Les signaux passifs doivent nuancer. Aucun des deux ne doit noyer le joueur.