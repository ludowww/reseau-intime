# DECISION 006 — Fluidité joueur et signaux passifs

## Statut

Validé.

## Décision

Le jeu doit rester fluide. Le joueur ne doit pas devoir se demander quoi faire à chaque notification ou message reçu.

Les choix visibles doivent rester limités, lisibles et rythmés. Certaines actions discrètes ou invisibles peuvent influencer l’histoire par accumulation, mais elles ne doivent pas devenir un système opaque, punitif ou trop complexe.

## Règle centrale

> Le joueur doit avoir l’impression d’utiliser naturellement un téléphone, pas de résoudre une interface narrative à chaque message.

## Complexité visible limitée

Dans une scène normale :

- 0 à 2 choix visibles forts ;
- parfois 3 choix si la scène est importante ;
- 4 à 5 choix uniquement pour une confrontation ou une bascule ;
- certaines scènes peuvent ne proposer aucun choix et servir seulement au rythme ou à l’information.

## Actions passives possibles

Certaines actions du joueur peuvent être suivies sans être présentées comme des choix dramatiques.

Exemples :

```text
mettre une image en favori
mettre une image en fond d’écran
ouvrir souvent une conversation précise en premier
ignorer souvent Marie
liker plus souvent une femme qu’une autre
commenter davantage les posts d’un personnage
conserver les images d’un personnage
supprimer les images d’un autre
consulter plusieurs fois une même photo
vérifier souvent les stories de Marie / Nico
ouvrir les contenus de Pauline sans répondre
laisser Sandra en vu
```

## Fonction narrative des signaux passifs

Les signaux passifs servent à détecter :

- les préférences du joueur ;
- les obsessions de Ludo ;
- les personnages que Ludo privilégie ;
- les contradictions entre ce que Ludo dit et ce qu’il fait ;
- les tensions qui peuvent ressortir plus tard.

## Règle anti-punition cachée

Un signal passif ne doit jamais déclencher seul une conséquence majeure.

Il peut :

- colorer une réaction ;
- ajouter une réplique ;
- augmenter légèrement une variable ;
- poser un flag faible ;
- contribuer à une route dominante ;
- renforcer une menace déjà préparée.

Mais il ne doit pas à lui seul verrouiller une fin, fermer une route ou provoquer une catastrophe.

## Exemple correct

Le joueur met plusieurs photos de Mathilde en favori.

Plus tard, si Marie voit la galerie ou si le fond d’écran est révélé, une réplique peut changer :

```text
Marie : C’est drôle, elle revient souvent dans tes favoris.
```

La conséquence est cohérente, car elle dépend d’un contexte de révélation.

## Exemple à éviter

Le joueur met une photo de Mathilde en favori une fois.

Plus tard, Marie rompt sans scène de découverte ni préparation.

Ce serait arbitraire.

## Signaux faibles et signaux forts

### Signaux faibles

Actions fréquentes, peu risquées individuellement :

```text
ouvrir une conversation en premier
liker un post
mettre en favori
relire une photo
ignorer une notification
```

### Signaux forts

Actions plus conscientes ou plus risquées :

```text
définir comme fond d’écran
capturer une photo
conserver un contenu supprimé
mentir sur un contenu
montrer une image
répondre publiquement à un flirt
```

## Agrégation

Les signaux passifs doivent fonctionner par accumulation.

Exemple :

```text
mathilde_attention_score
sandra_priority_score
marie_neglect_score
nico_surveillance_score
pauline_risk_score
raphaelle_clarity_score
```

Ces scores doivent rester secondaires par rapport aux choix narratifs majeurs.

## Debug

Le mode debug doit permettre de voir :

- les signaux passifs enregistrés ;
- les scores d’attention ;
- les flags discrets ;
- les raisons qui ont favorisé une route dominante.

En jeu normal, ces données restent cachées.

## Règle de rythme

Toutes les interactions ne doivent pas proposer un choix. Le téléphone doit parfois simplement vivre : notification, lecture, réaction automatique, silence, image conservée, story vue.

## Conséquence technique

Prévoir une couche de données pour les interactions passives.

Données possibles :

```text
opened_first_count_by_character
liked_posts_by_character
commented_posts_by_character
favorited_content_by_character
viewed_content_count_by_character
ignored_notifications_by_character
current_wallpaper_content_id
passive_attention_scores
```

## Conclusion

Le jeu peut utiliser les comportements invisibles du joueur pour enrichir les routes, mais seulement si ces comportements restent :

- légers ;
- compréhensibles en relecture ;
- non punitifs seuls ;
- visibles en debug ;
- cohérents avec les scènes et les personnages.

> Les choix visibles orientent l’histoire. Les signaux passifs révèlent les habitudes de Ludo.