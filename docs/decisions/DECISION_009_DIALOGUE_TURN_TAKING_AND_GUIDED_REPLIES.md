# DECISION 009 — Discussions, tours de parole et réponses guidées

## Statut

Validé.

## Problème constaté

Le prototype Godot charge correctement les données, mais l’expérience actuelle donne parfois l’impression de lire des monologues : un personnage envoie plusieurs messages, puis le joueur choisit une réponse parmi plusieurs options.

Ce rythme ne ressemble pas encore assez à une vraie conversation de messagerie.

## Décision

Les conversations doivent être structurées en vrais tours de parole.

Le joueur doit régulièrement répondre aux messages, même quand la réponse ne représente pas un choix de route.

Il faut donc distinguer :

```text
Réponses guidées de rythme
Choix narratifs de route
Choix passifs / traces
```

## Règle centrale

> Une conversation doit se lire comme un échange, pas comme un monologue interrompu par un choix.

## Réponses guidées de rythme

Une réponse guidée de rythme est une réponse unique proposée au joueur.

Elle sert à :

- faire sentir que Player répond ;
- relancer naturellement la conversation ;
- contrôler le pacing ;
- éviter un écran rempli uniquement de messages reçus ;
- donner au joueur un geste simple sans lui demander une décision importante.

Exemple :

```text
Sandra : Hey, tu survis à ta journée ?
Sandra : J’ai pensé à toi tout à l’heure.

[Réponse guidée unique]
À peine. Mais je fais semblant avec beaucoup de talent.

Sandra : Ça te va bien, faire semblant.
Sandra : Enfin... je crois.
```

## Choix narratifs de route

Les vrais choix multiples doivent rester plus rares.

Ils servent à orienter :

- ton ;
- mensonge / vérité ;
- priorité ;
- désir ;
- trace ;
- risque ;
- route probable.

Exemple :

```text
Tu réponds à qui en premier ?
- Sandra
- Pauline
- Mathilde
- Story Nico / Marie
- Poser le téléphone et revenir vers Marie
```

## Rythme recommandé

Une conversation normale doit alterner :

```text
2 à 4 messages reçus
1 réponse guidée unique
2 à 4 messages reçus
1 réponse guidée unique
éventuellement 1 vrai choix narratif
```

Une scène importante peut alterner :

```text
3 à 5 messages reçus
1 choix narratif
réponse de conséquence
1 réponse guidée unique pour reprendre le flux
```

## Effets des réponses guidées

Les réponses guidées peuvent avoir :

```text
effects faibles ou nuls
sets_flags de pacing
aucune conséquence majeure
```

Elles ne doivent pas à elles seules :

- verrouiller une route ;
- provoquer une catastrophe ;
- déclencher une preuve majeure ;
- fermer une relation.

Elles peuvent cependant :

- ajouter +1 à une affinité ;
- créer un flag de ton ;
- permettre au debug de savoir que le joueur a lu/répondu ;
- donner une impression de présence.

## Présentation UI

Les réponses guidées doivent être affichées comme un bouton unique de réponse, visuellement proche d’un message sortant.

Exemple de rendu :

```text
[message entrant]
Sandra : Je ne vais pas te faire le roman ce soir.
Sandra : Mais j’avais juste envie de parler à quelqu’un qui me connaît vraiment.

[réponse joueur — bouton unique]
Je suis là.
```

Après clic :

```text
Player : Je suis là.
Sandra : Je sais. C’est bien ça le problème.
```

## Données JSON recommandées

À terme, les données peuvent distinguer explicitement :

```json
{
  "id": "reply_c02_sandra_001",
  "type": "guided_reply",
  "text": "Je suis là.",
  "effects": {
    "sandra.attachment": 1
  },
  "sets_flags": ["guided_replied_sandra_day2"]
}
```

Mais pour une première passe, le système peut interpréter un choix unique comme une réponse guidée de rythme.

## Règle UI temporaire

Si un segment contient un seul choix :

```text
l’afficher comme Réponse
pas comme Choix disponibles
```

Si un segment contient plusieurs choix :

```text
l’afficher comme Choix
```

## Conséquence sur les données existantes

Les JSON des Jours 1 à 4 peuvent être progressivement enrichis.

Priorité : ne pas tout réécrire immédiatement.

Première passe recommandée :

```text
Jour 1 Sandra
Jour 1 Marie
Jour 2 Raphaëlle
Jour 2 Sandra
```

Objectif : prouver le rythme conversationnel avec réponses guidées avant de généraliser à toute la base.

## Règle finale

> Les choix construisent les routes. Les réponses guidées construisent la sensation de parler.