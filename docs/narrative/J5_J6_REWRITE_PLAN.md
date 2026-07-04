# Plan de réécriture — J5 / J6

> V0.57 est la référence narrative principale pour cette réécriture.
> Ce plan reste pertinent, mais ses priorités doivent être lues dans une hiérarchie Marie-centrique plutôt qu’en panel égalitaire.

## Statut

Document opérationnel pour préparer une future branche de réécriture runtime J5/J6.

Ce document ne modifie pas le runtime.

## Problème à corriger

Les versions actuelles de J5/J6 sont techniquement valides mais narrativement provisoires.

Problèmes observés :

```text
- impression de tourner en rond ;
- répétition des mêmes motifs jour après jour ;
- téléphone / absence Player trop répété avec Marie ;
- “plus tard” Sandra répété ;
- Mathilde trop centrée sur trace/photo gardée ;
- Pauline trop centrée sur photos gardées ;
- Raphaëlle répète le refus d’être une cachette ;
- Player ne répond plus directement, il est surtout commenté par les autres.
```

Objectif de la réécriture :

```text
J5 doit rendre Marie active et Pauline dangereusement compréhensive.
J6 doit forcer Player à faire un acte concret.
```

## Décision de statut

```text
J1-J4 : base utilisable.
J5-J6 : à réécrire avant tout J7 runtime.
J7 : bloqué tant que J5/J6 ne sont pas recadrés.
```

## Nouvelle fonction J5

### Fonction dramatique

```text
Marie comprend que le couple vacille.
Pauline comprend que Player regarde ailleurs.
Player découvre que ses désirs ne sont plus seulement intérieurs.
```

### Ce qui doit changer

Avant J5 :

```text
Player peut encore croire qu’il gère des tensions séparées.
```

Après J5 :

```text
Marie sent que le couple est en danger.
Pauline a une porte d’entrée dangereuse.
Player doit choisir entre vérité, mensonge, ouverture ou jeu de contrôle.
```

## J5 — Structure recommandée

### Scène 1 — Marie : “le couple vacille”

Remplace la scène actuelle centrée sur téléphone / regard / écran.

Marie ne dit plus :

```text
Pose ton téléphone.
Regarde-moi.
Tu étais ailleurs.
```

Elle dit plutôt :

```text
Je crois que quelque chose bouge entre nous.
Et je n’ai pas envie d’être la dernière à le comprendre.
```

Fonction : Marie devient active.

Choix Player recommandés :

```text
A — vérité partielle : “Je crois que j’aime être désiré ailleurs.”
B — mensonge doux : “Tu interprètes trop.”
C — flou sincère : “Je ne sais pas encore ce que je veux.”
D — ouverture risquée : “Et si on devait parler de ce qu’on autorise ?”
```

Chaque choix doit contenir un message visible de Player dans `next_messages`.

Conséquences narratives :

```text
A → couple_state truth_discussion, Marie blessée mais incluse.
B → couple_state suspicious, marie_revenge seed.
C → couple_state suspicious/truth_discussion hybride.
D → open_discussion seed, Marie active, jalousie possible.
```

### Scène 2 — Pauline : “je comprends que tu regardes ailleurs”

Remplace Pauline comme simple distributrice de photos.

Fonction : Pauline devient complice dangereuse.

Elle n’arrive pas avec une menace brutale.

Elle dit :

```text
Je ne te juge pas.
Je crois même que je comprends très bien.
C’est peut-être ça le problème.
```

Puis elle peut envoyer un selfie provoque, contrôlé par elle.

Choix Player recommandés :

```text
A — nier.
B — demander ce qu’elle a vu.
C — entrer dans son jeu.
D — lui retourner son propre passé / sa réputation de fille pas si sage.
```

Conséquences :

```text
A → pauline_control +, lie_score +.
B → proof_state weak_proof actif.
C → pauline_control +, player_posture power_drunk.
D → pauline_fragility seed, pauline_control peut baisser ou se transformer.
```

### Scène 3 — Sandra ou silence Sandra

Ne pas répéter “plus tard”.

Deux options :

```text
Option A : Sandra absente de J5.
Option B : Sandra prépare la soirée confidences sans jouer le manque.
```

Si présente, sa fonction doit être :

```text
passer de l’attente à la valorisation / confidence.
```

Pas :

```text
je ne veux pas être cachée.
j’ai attendu plus tard.
```

### Scène 4 — Raphaëlle ou absence Raphaëlle

Raphaëlle peut être absente de J5 si elle n’apporte pas de pivot nouveau.

Si présente, elle doit être concrète : pause café, dossier, détail de travail.

Interdit : reformuler “je peux écouter mais pas cacher”.

## Nouvelle fonction J6

### Fonction dramatique

```text
Player agit.
```

J6 ne doit pas être une journée où les personnages lui expliquent ce qu’il devrait faire.

Il doit faire quelque chose qui modifie une compatibilité de route.

## J6 — Acte concret recommandé

La meilleure base :

```text
Player doit choisir quoi faire d’une trace Mathilde pendant que Marie demande une vérité.
```

Pourquoi :

```text
- relie Marie au conflit central ;
- relie Mathilde à la maison ;
- force Player à agir ;
- transforme photo/trace en décision ;
- crée conséquences sur mensonge, vérité ou ouverture.
```

## J6 — Structure recommandée

### Scène 1 — Mathilde : “supprime ou assume”

Mathilde ne demande plus seulement si la photo existe.

Elle force une décision.

Exemple :

```text
Je ne veux plus savoir si elle existe.
Je veux savoir ce que tu fais maintenant.
```

Choix Player :

```text
A — supprimer devant elle / lui dire qu’il supprime.
B — garder et assumer que ce n’est pas innocent.
C — mentir en disant qu’il l’a déjà supprimée.
D — dire qu’il ne veut pas transformer Marie en angle mort.
```

Messages Player visibles obligatoires.

Conséquences :

```text
A → mathilde_loyalty_conflict +, marie.trust narrative +, mathilde.desire peut baisser ou se complexifier.
B → mathilde_domestic_risk +, lie_score +, désir +.
C → broken_trust seed si découvert, pauline_control possible +.
D → restrained, raphaelle_clarity +, mathilde respect +.
```

### Scène 2 — Marie : réaction au choix ou conversation vérité

Marie n’a pas besoin de parler du téléphone.

Elle sent une position.

Si Player a choisi vérité :

```text
Elle peut ouvrir la discussion : “Donc on parle de ce qui peut arriver, pas seulement de ce qui est arrivé.”
```

Si Player a menti :

```text
Elle devient plus froide, plus active, seed Nico / vengeance.
```

Si Player reste flou :

```text
Elle décide qu’elle ne restera pas passive.
```

### Scène 3 — Pauline : défi ou silence selon choix

Si Player est entré dans le jeu Pauline en J5, J6 peut contenir un petit défi.

Sinon Pauline peut rester en attente.

Important : ne pas répéter qu’elle garde des photos.

Elle doit proposer une transaction ou une question :

```text
Je suis curieuse de savoir ce que tu crois que mon silence vaut.
```

Mais cela peut aussi être repoussé à J7/J8 si J6 est déjà chargé.

### Scène 4 — Sandra : amorce confidences uniquement si utile

Si J6 a assez de densité, Sandra peut être absente.

Si présente, elle doit lancer une autre dynamique :

```text
pas plus tard,
mais “dis-moi quelque chose de vrai”.
```

## Scènes à supprimer ou transformer dans J5/J6 actuels

### Marie téléphone

Supprimer comme pivot principal.

Peut rester comme détail une seule fois, mais ne doit plus être le sujet.

### Sandra plus tard

Transformer en arc confidence / valorisation.

Si “plus tard” a déjà été traité, Sandra doit agir : recul, vraie proposition, silence, ou jeu de confidence.

### Mathilde trace gardée

Transformer en décision : garder / supprimer / mentir / poser limite.

### Pauline photos gardées

Transformer en compréhension sulfureuse / selfie provoque / prix du silence.

### Raphaëlle cachette

Transformer en scènes concrètes : pause café, marche, dossier refusé, photo rare, pot de départ.

## Exigence Player

Chaque scène forte doit avoir des messages `sender: "ludo"` visibles après les choix.

Minimum recommandé :

```text
J5 Marie : chaque choix fort inclut un message Player.
J5 Pauline : chaque choix fort inclut un message Player.
J6 Mathilde : chaque choix fort inclut un message Player.
J6 Marie : au moins deux branches incluent un message Player.
```

Les labels UI peuvent rester courts, mais la scène doit contenir une phrase réelle de Player.

## États attendus fin J5

Au lieu d’un seul résultat, J5 doit laisser plusieurs états possibles :

```text
truth_discussion_seed
marie_revenge_seed
pauline_control_seed
open_discussion_seed
sandra_confidence_seed optional
```

Mais ne pas ouvrir toutes les routes à la fois.

## États attendus fin J6

J6 doit produire au moins une décision claire :

```text
mathilde_trace_deleted
mathilde_trace_kept
mathilde_trace_lied_about
marie_truth_discussion
marie_revenge_seed
pauline_challenge_seed
sandra_confidence_started
```

Un seul axe principal suffit.

## Critères de validation narrative

J5 valide si :

```text
- Marie ne répète pas le téléphone ;
- Marie devient active ;
- Pauline n’est pas seulement distributrice de photos ;
- Player répond directement ;
- au moins un état truth/revenge/open/control est seedé.
```

J6 valide si :

```text
- Player fait un acte concret ;
- une trace devient décision ;
- au moins une route monte et une route recule ;
- les motifs J5 ne sont pas répétés ;
- Player a des messages visibles.
```

## Outils à adapter après ce plan

Les outils actuels peuvent rester, mais il faudra ajouter ou renforcer :

```text
player_presence_check.py
motif_repetition_check.py
scenario_pivot_check.py
route_compatibility_check.py
```

Ces outils ne doivent pas décider à la place de l’auteur, mais signaler :

```text
- absence de Player ;
- motif répété ;
- pas de pivot ;
- aucune compatibilité de route modifiée.
```

## Règle finale

```text
J5 doit faire comprendre à Marie que le couple vacille.
J6 doit faire comprendre à Player qu’il n’est plus seulement en train de regarder.
```
