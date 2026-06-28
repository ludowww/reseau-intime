# 14 — Choix, cohérence des routes et atteignabilité

## Objectif

Garantir que les choix du joueur :

- ne soient pas tous visiblement critiques ;
- produisent des conséquences cohérentes ;
- alimentent les routes sans les rendre mécaniques ;
- permettent d’atteindre chaque chemin important ;
- gardent une histoire crédible quelle que soit la dynamique empruntée.

## Problème à éviter

Dans beaucoup de jeux narratifs, le joueur comprend vite :

> Si le jeu me propose un choix, c’est que ce choix va provoquer une conséquence forte.

Réseau Intime doit éviter cet effet.

Tous les choix ne doivent pas être des bifurcations majeures. Certains choix doivent être :

- anodins ;
- relationnels ;
- atmosphériques ;
- purement expressifs ;
- légèrement colorants ;
- importants seulement par accumulation.

## Catégories de choix

### 1. Choix anodins

Choix sans conséquence forte.

Fonction : rendre le smartphone vivant et naturel.

Exemple :

```text
Marie : On mange quoi ce soir ?
- On commande.
- Je cuisine.
- Comme tu veux.
```

Effets possibles :

- aucun ;
- +1 relation douce ;
- variation de réplique ;
- couleur de scène.

Règle :

> Les choix anodins sont nécessaires pour que le joueur ne lise pas chaque choix comme une alarme narrative.

### 2. Choix de ton

Choix qui orientent la manière dont Player répond, sans changer immédiatement la route.

Exemples :

```text
éviter
rassurer
plaisanter
flirter légèrement
répondre froidement
```

Effets :

- faibles variations de variables ;
- réaction immédiate différente ;
- possible accumulation.

### 3. Choix de relation

Choix qui nourrissent une relation précise.

Exemples :

- répondre plus vite à Sandra ;
- relancer Mathilde ;
- accepter un café avec Raphaëlle ;
- demander à Marie ce qui ne va pas ;
- réagir à une story de Nico / Marie.

Effets :

- variables personnage ;
- flags relationnels ;
- route secondaire possible.

### 4. Choix de trace

Choix liés aux photos, vidéos, captures, messages supprimés ou preuves.

Exemples :

```text
conserver
supprimer
capturer
montrer
mentir
avouer
```

Effets :

- preuves ;
- risque différé ;
- contrôle de Pauline ;
- lucidité de Marie ;
- exposition de Sandra.

### 5. Choix de vérité

Choix majeurs où Player doit assumer, mentir, ouvrir ou contrôler.

Exemples :

```text
Tout dire à Marie.
Minimiser.
Accuser Pauline.
Proposer une ouverture.
Confronter Nico.
Demander à Sandra de choisir.
```

Effets :

- changement de mode relationnel ;
- fermeture de route ;
- bascule de menace ;
- confrontation.

## Répartition recommandée

Dans une séquence normale :

```text
40 % choix anodins ou de ton
35 % choix relationnels
15 % choix de trace
10 % choix de vérité / bascule
```

Cette répartition évite que chaque choix semble critique.

## Conséquences immédiates et différées

### Conséquence immédiate

La réaction arrive tout de suite.

Exemple :

```text
Player flirte avec Mathilde.
Mathilde répond avec une provocation.
mathilde.desire +2
```

### Conséquence différée

La réaction arrive plus tard.

Exemple :

```text
Player ment à Marie sur Pauline.
Plus tard, Pauline révèle qu’ils se sont parlé en privé.
Marie remarque l’incohérence.
```

Règle :

> Une conséquence différée doit toujours pouvoir être comprise en relisant les scènes précédentes.

## Flags discrets

Les choix importants ne doivent pas toujours modifier une grosse variable visible en debug. Ils peuvent aussi poser des flags.

Exemples :

```text
lied_about_pauline
opened_sandra_first_at_party
saved_mathilde_photo
ignored_marie_message
asked_raphaelle_for_coffee
checked_nico_story
showed_photo_to_marie
```

Ces flags peuvent être réactivés plus tard.

## Cohérence des branches

Chaque route doit respecter trois règles.

### 1. Préparation

Une route ne doit jamais apparaître sans signaux préalables.

Exemple : Mathilde ne bascule pas si aucune scène n’a montré son goût du jeu, son trouble et son conflit avec Marie.

### 2. Accumulation

Une route doit naître de plusieurs signaux, pas d’un seul choix isolé.

Mauvais :

```text
Choix unique : “flirter” → route Mathilde verrouillée.
```

Meilleur :

```text
Player répond vite à Mathilde.
Il accepte une blague ambiguë.
Il garde un message secret.
Il ne recule pas quand elle teste.
Mathilde devient route dominante possible.
```

### 3. Réconciliation narrative

Les scènes communes doivent permettre à l’histoire de se recentrer.

Même si le joueur nourrit Sandra, Mathilde ou Pauline, la scène suivante avec Marie doit refléter l’éloignement ou la dissimulation.

## Route dominante

Une route dominante ne doit pas être choisie par un seul flag.

Elle doit être calculée par :

```text
score relationnel
flags clés
niveau de mensonge
menace active
mode relationnel probable
```

Exemple :

```text
Route Mathilde probable si :
- mathilde.desire élevé ;
- au moins 2 flags de complicité privée ;
- lie_score moyen ou haut ;
- marie.lucidity pas encore trop élevée ;
- Mathilde n’a pas activé un flag de recul définitif.
```

## Route secondaire

La route secondaire doit compliquer la dominante, pas devenir une deuxième route complète ingérable.

Exemples :

```text
Dominante Sandra + secondaire Raphaëlle
=> clarté contre obsession.

Dominante Mathilde + secondaire Nico
=> interdit domestique + jalousie miroir.

Dominante Pauline + secondaire Marie
=> piège social + risque de découverte.
```

## Menace

La menace doit être lisible :

- Marie découvre ;
- Pauline garde une preuve ;
- Sandra fuit ;
- Raphaëlle coupe ;
- Nico prend la place ;
- Mathilde culpabilise.

La menace doit être préparée par des scènes antérieures.

## Atteignabilité des routes

Chaque route majeure doit avoir :

```text
1 chemin principal
1 chemin alternatif
1 chemin d’échec ou de fermeture
```

Exemple : route Sandra.

```text
Chemin principal : patience + attachement + exposition faible.
Chemin alternatif : Player se retire, Sandra revient par peur de le perdre.
Échec : Player exige trop vite, exposition haute, Sandra fuit.
```

Exemple : route Raphaëlle.

```text
Chemin principal : vérité + clarté + rupture propre ou poly honnête.
Chemin alternatif : Player avoue tard mais accepte de réparer.
Échec : Player veut la garder comme secret, Raphaëlle coupe.
```

## Tests d’atteignabilité

À terme, chaque route doit être testée avec un parcours de référence.

Format recommandé :

```text
Route : Mathilde secrète
Choix clés :
- répondre à Mathilde au Jour 2 ;
- ouvrir Mathilde avant Sandra pendant la soirée ;
- conserver la photo ;
- mentir à Marie ;
- ne pas reculer au lendemain.
Résultat attendu : dominante = Mathilde, mode = SECRET_AFFAIR, menace = Marie.
```

Chaque route importante doit avoir au moins un script de test narratif ou une checklist.

## Cohérence quelle que soit la route

Toutes les routes doivent préserver les vérités fixes :

1. Player et Marie sont en couple au départ.
2. Le couple n’est pas mort, mais le désir est fatigué.
3. Mathilde reste liée à Marie.
4. Sandra reste fragile face à l’exposition.
5. Raphaëlle refuse le mensonge prolongé.
6. Pauline comprend le pouvoir des preuves.
7. Nico renvoie Player à sa jalousie et son hypocrisie.
8. Un contenu intime crée toujours une trace ou une tension.
9. Une route adulte n’efface jamais la psychologie des personnages.
10. Une fin doit être un état de réseau, pas seulement une récompense.

## Incohérences à éviter

### Route sortie de nulle part

Un personnage bascule sans préparation.

### Choix unique trop puissant

Un choix isolé détermine une route entière.

### Route incompatible forcée

Raphaëlle accepte un harem mensonger sans réagir.

Sandra accepte d’être exposée publiquement sans peur.

Mathilde trahit Marie sans culpabilité.

Marie accepte Mathilde sans avoir repris du pouvoir.

### Conséquence punitive arbitraire

Le joueur fait un choix anodin et reçoit une conséquence majeure incompréhensible.

### Trop de choix critiques

Chaque choix devient anxiogène et visible comme mécanique.

## Règle finale

> Le joueur doit sentir que ses choix comptent, mais il ne doit pas toujours savoir quand ils comptent.

## Principe de relecture

Après une fin, le joueur doit pouvoir repenser à sa partie et se dire :

> Ce n’était pas un piège arbitraire. C’était là depuis le début.