# DECISION 004 — Cadre créatif, contenu et diffusion

## Statut

Validé.

## Décision

Ce document verrouille les règles de base concernant le niveau adulte, Mathilde, la posture morale, Player, les assets, les plateformes, la progression et la lisibilité des choix.

## 1. Niveau explicite

Le jeu adopte un niveau **explicite progressif**, pouvant aller jusqu’à du contenu pornographique assumé dans les routes avancées.

Règle :

> Le jeu peut aller jusqu’au porno assumé, mais jamais sans progression, contexte narratif, trace, conséquence ou tension.

Conséquences :

- Les contenus explicites ne sont pas disponibles dès le début.
- Les paliers visuels restent progressifs : social, ambigu, suggestif, intime, explicite, preuve/conséquence.
- Les mini-vidéos explicites sont réservées aux routes avancées.
- Chaque contenu adulte doit avoir un contexte narratif et des conditions de déblocage.

## 2. Statut de Mathilde

Mathilde peut être définie par défaut comme **cousine par alliance** de Marie si cela facilite la diffusion ou le cadrage public du projet.

Le fantasme de l’interdit doit rester possible.

Une option cachée ou un réglage avancé pourra permettre au joueur de définir Mathilde comme une vraie cousine dans la fiction.

Règle :

> Mathilde est toujours une figure d’interdit familial, domestique et affectif. Le degré exact du lien familial peut être paramétrable, mais le poids émotionnel de la trahison doit rester central.

Conséquences :

- Les routes trio/quatuor avec Marie, Mathilde et éventuellement Nico restent possibles.
- Le jeu assume qu’il s’agit d’une fiction adulte.
- Marie / Mathilde doit rester une relation à très fort enjeu émotionnel.

## 3. Position morale du jeu

Le jeu ne moralise pas, mais il ne banalise jamais.

Règle :

> Tout choix intime crée une trace, une conséquence ou une tension.

Conséquences :

- La tromperie, le libertinage, le polyamour, le NTR, le harem et les routes interdites peuvent exister.
- Le jeu ne distribue pas des punitions morales automatiques.
- Les personnages réagissent selon leur psychologie, leurs limites et les secrets découverts.
- Les contenus visuels sont des récompenses mais aussi des objets narratifs.

## 4. Player

Player désigne un personnage écrit, mais orientable par les choix.

Il n’est pas un avatar neutre.

Failles de base :

- besoin d’être désiré ;
- tendance à éviter les confrontations ;
- difficulté à dire clairement ce qu’il veut ;
- tentation du secret ;
- peur de perdre sa place ;
- attirance pour les zones ambiguës.

Règle :

> Le joueur guide Player, mais Player garde une personnalité, des failles et une cohérence émotionnelle.

## 5. Assets visuels

Les images et vidéos définitives seront générées plus tard.

Pour longtemps, le projet utilise des placeholders.

Direction visuelle cible :

```text
Style anime adulte à définir
Images générées par IA plus tard
Vidéos générées par IA plus tard si pipeline viable
```

Règles :

- Aucun contenu visuel adulte définitif n’est nécessaire pour le prototype.
- Les placeholders doivent suffire à tester les routes, la galerie, les preuves et l’UX.
- Chaque futur asset doit être lié à un contexte narratif et un palier.
- Les assets adultes définitifs doivent être gérés avec prudence si le dépôt reste public.

## 6. Dépôt public / privé

Le dépôt est actuellement public.

Recommandation validée :

```text
Repo public : documentation, code, placeholders neutres.
Assets adultes définitifs : dépôt privé ou stockage séparé.
```

Si la production d’assets adultes commence, il est préférable de basculer le repo en privé ou de séparer les assets dans un dépôt/stockage privé.

## 7. Plateformes

Priorité :

```text
PC d’abord
Android ensuite
```

Conséquences :

- Le prototype doit d’abord fonctionner sur PC avec une interface smartphone simulée.
- Android viendra après validation de la boucle de jeu, de l’UX et du système de données.

## 8. Progression temporelle

Le jeu utilise des journées / chapitres simulés.

Pas de temps réel au départ.

Règle :

```text
Progression par chapitres ou moments de journée.
Notifications simulées par le scénario.
Pas de délais réels obligatoires.
```

Conséquence :

Le rythme reste maîtrisable pour l’écriture, les tests et la rejouabilité.

## 9. Lisibilité des choix

Les variables ne sont pas visibles en jeu normal.

Le joueur peut percevoir l’intention d’un choix par sa formulation, mais il ne voit pas les valeurs exactes.

Mode debug :

- afficher les effets de choix ;
- afficher les variables ;
- afficher les flags ;
- afficher route dominante, route secondaire, menace et mode relationnel ;
- aider au test et à l’équilibrage.

Règle :

> En jeu normal, le joueur ressent les conséquences. En debug, le développeur vérifie les effets.

## Synthèse validée

```text
Niveau : explicite progressif jusqu’au porno assumé.
Mathilde : cousine par alliance par défaut, vraie cousine possible via option cachée.
Posture morale : non moralisateur, conséquences fortes.
Player : personnage écrit mais orientable.
Assets : placeholders longtemps, IA anime adulte plus tard.
Plateforme : PC d’abord, Android ensuite.
Temps : journées / chapitres simulés.
Choix : variables cachées en jeu normal, debug pour développement.
```