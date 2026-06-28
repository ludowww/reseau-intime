# DECISION 008 — Structure de journée, révélations et transitions

## Statut

Validé.

## Décision

Une journée ne doit pas être une suite plate de conversations indépendantes. Elle doit être découpée en moments lisibles, avec des conversations qui peuvent commencer, s’interrompre, reprendre plus tard, et être croisées par d’autres événements.

Le joueur doit pouvoir se repérer dans la journée tout en sentant que les personnages ont leur propre vie sociale, leurs indisponibilités, leurs rythmes et leurs habitudes.

## Règle centrale

> Les dialogues portent l’histoire, mais la journée donne le rythme.

## Découpage d’une journée

Chaque journée importante doit être divisée en moments.

Moments recommandés :

```text
matin
midi
après-midi
début de soirée
soirée
nuit
```

Tous les moments ne sont pas obligatoires dans chaque journée. Un moment peut être court ou simplement transitionnel.

## Transitions

Les transitions servent à situer le joueur sans casser l’immersion smartphone.

Elles peuvent prendre plusieurs formes :

```text
changement d’heure visible
notification système
court texte de transition
écran d’accueil du téléphone
changement de fond d’ambiance
message automatique non interactif
résumé discret de contexte
titre de moment : Matin, Pause déjeuner, Soirée
```

Exemples :

```text
08:32 — Le lendemain matin
12:18 — Pause déjeuner
18:47 — Retour à l’appartement
23:06 — Trop tard pour répondre normalement
```

## Conversations découpées

Une même conversation peut être découpée en plusieurs moments de la journée.

Exemple : Sandra.

```text
Matin : Sandra écrit une blague légère.
Midi : elle répond tard et minimise.
Soir : elle revient avec une vraie confidence.
Nuit : elle écrit puis supprime.
```

Ce découpage permet de créer :

- attente ;
- familiarité ;
- frustration ;
- rythme émotionnel ;
- impression que le personnage existe hors écran.

## Interruptions

Les conversations peuvent être interrompues par :

- autre notification ;
- groupe actif ;
- story publiée ;
- absence du personnage ;
- message lu sans réponse ;
- changement de moment ;
- événement social hors écran ;
- indisponibilité liée au travail, couple, famille ou soirée.

## Vie sociale des personnages

Les personnages ne doivent pas sembler attendre Player en permanence.

Chaque personnage doit pouvoir :

```text
être occupé
répondre plus tard
avoir déjà parlé à quelqu’un d’autre
être avec son partenaire
être au travail
être chez Marie / Pauline / ailleurs
publier une story sans écrire directement à Player
être dans un groupe mais pas en privé
voir un message et ne pas répondre
```

## Révélations d’identité

À la fin du Jour 2, le joueur doit savoir clairement qui est chaque personnage important.

En particulier :

```text
Marie = copine de Player
Mathilde = cousine par alliance de Marie par défaut, presque sœur, familière du foyer
Sandra = meilleure amie ambiguë de Player, en couple fragile
Raphaëlle = collègue attentive de Player
Pauline = meilleure amie de Marie, hôte de la soirée, image sage mais jeu trouble
Nico = ami de Player, intéressé par Marie
```

Certaines nuances peuvent rester mystérieuses, mais les relations de base ne doivent plus être floues après le Jour 2.

## Jour 2 — objectif narratif

Le Jour 2 doit servir à compléter les présentations et à ouvrir les premiers désirs sans verrouiller de route.

À la fin du Jour 2, le joueur doit comprendre :

```text
qui est Mathilde précisément ;
pourquoi Sandra est dangereuse émotionnellement ;
ce que Raphaëlle représente ;
ce que Pauline prépare ;
que Nico regarde Marie ;
que Marie sent déjà quelque chose sans forcément savoir quoi.
```

## Matière dialoguée

Le contenu de l’histoire se joue essentiellement dans les dialogues. Il faut donc beaucoup de matière, pas seulement des choix.

Une séquence importante peut contenir :

```text
10 à 25 messages
1 à 3 choix visibles
plusieurs interruptions
1 transition temporelle
1 indice ou rappel contextuel
1 signal passif possible
```

Le volume vient du dialogue, des silences, des reprises et des interruptions, pas de la multiplication des décisions.

## Règle de progression

Les révélations doivent être progressives :

```text
Jour 1 : on voit les visages et les premières dynamiques.
Jour 2 : on comprend les liens exacts et les habitudes.
Jour 3 : les tensions se croisent réellement à la soirée.
Jour 4 : les premières traces deviennent des conséquences.
```

## Règle anti-confusion

Le joueur doit toujours pouvoir répondre à ces questions :

```text
Quel moment de la journée sommes-nous ?
Qui parle ?
Dans quelle conversation ?
Pourquoi cette personne m’écrit maintenant ?
Qu’est-ce qui s’est passé depuis la dernière réponse ?
Cette scène est-elle calme, intime, sociale ou dangereuse ?
```

## Conséquence data

Les fichiers de conversation doivent pouvoir inclure :

```text
moment_label
time_label
transition_text
availability_state
interruption_rules
resume_context
conversation_segment_id
```

Ces champs ne sont pas tous obligatoires immédiatement, mais le format doit être prévu.