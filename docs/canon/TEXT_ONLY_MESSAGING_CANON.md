# Réseau Intime — Canon de communication uniquement textuelle

## Statut

**Catégorie : Canon**

**Autorité : surface de communication jouable**

Ce document précise et complète `DIEGETIC_TIME_AND_COMMUNICATION_CANON.md`.

En cas de contradiction sur la présence d’audio, d’appels ou de scènes vocalisées, le présent document prévaut.

---

# 1. Décision produit

> **Réseau Intime ne contient aucune scène audio. Toute communication jouable passe par la messagerie texte.**

Sont exclus :

- appels téléphoniques joués ;
- conversations audio ;
- messages vocaux ;
- notes vocales ;
- répondeur ;
- enregistrements sonores ;
- audio sexuel ;
- dialogues doublés servant de scène ;
- choix effectués pendant une conversation vocale ;
- scène d’appel simulée par une transcription présentée comme temps réel.

Le smartphone reste un appareil de messagerie, d’images, de notifications et de traces écrites.

---

# 2. Ce qui reste possible hors téléphone

Des événements physiques peuvent avoir lieu :

- repas ;
- promenade ;
- rencontre ;
- vernissage ;
- travail partagé ;
- installation de Mathilde ;
- café avec Sandra ;
- visite de L’Annexe ;
- préparation avec Raphaëlle ;
- intimité physique ou sexuelle ;
- dispute ;
- départ ;
- retour au foyer.

Ils ne sont pas joués sous forme audio.

Leur existence est rendue par :

```text
message qui organise
→ arrêt du chat à la co-présence
→ temps qui passe
→ image éventuelle
→ messages ultérieurs
→ changement d’état et conséquence
```

Le jeu peut utiliser une courte carte narrative écrite ou un beat textuel pour marquer le passage du temps, à condition qu’il ne reproduise pas une conversation complète hors messagerie.

---

# 3. Règle des dialogues

Tout dialogue interactif visible par le joueur doit être :

- un message texte ;
- un choix de réponse textuel ;
- un message de groupe ;
- une notification textuelle ;
- une légende ou un commentaire écrit lié à une image ;
- un texte bref de transition non conversationnel.

Le jeu ne montre pas :

- une conversation orale complète ;
- des sous-titres d’une scène doublée ;
- une transcription artificielle d’un appel ;
- des bulles de dialogue hors téléphone ;
- une scène où le joueur choisit des répliques parlées en direct.

---

# 4. Co-présence

Lorsque les personnages se rejoignent :

```text
la messagerie s’arrête
```

L’événement hors téléphone peut :

- payer une promesse ;
- modifier une obligation ;
- créer un souvenir ;
- déclencher une image ;
- changer le ton futur ;
- produire une dette ;
- fermer ou ouvrir une possibilité.

Le détail de leurs paroles n’est pas joué.

Le prochain échange écrit peut évoquer :

- ce qui a compté ;
- ce qui est resté gênant ;
- ce qui a été promis ;
- ce qui n’a pas été dit ;
- ce qui doit changer.

---

# 5. Scènes émotionnelles importantes

Une conversation émotionnelle majeure doit être conçue pour fonctionner dans la messagerie.

Pour rester crédible, elle peut avoir lieu lorsque les personnages sont :

- au travail dans des lieux différents ;
- en trajet ;
- temporairement séparés ;
- dans des pièces différentes avec une raison de ne pas se rejoindre immédiatement ;
- après un événement physique ;
- après un départ ;
- après qu’une personne a demandé de l’espace ;
- dans une situation où l’écrit permet une formulation plus maîtrisée.

Si le sujet ne peut être crédiblement traité par messages pendant la co-présence :

1. la messagerie prépare ou déclenche la discussion ;
2. les personnages se rejoignent hors téléphone ;
3. le résultat est visible plus tard par messages et états ;
4. aucune scène audio n’est créée.

---

# 6. Intimité et contenu adulte

Une progression adulte peut être portée par :

- messages de désir ;
- négociation écrite ;
- image destinée ;
- demande ou refus de sauvegarde ;
- messages avant une rencontre ;
- messages après séparation ;
- images de scène ;
- conséquences textuelles.

Un acte sexuel physique peut avoir lieu hors téléphone.

Il n’est jamais joué sous forme audio.

Il peut être représenté par :

```text
messages avant
→ image(s) éventuelle(s)
→ temps hors téléphone
→ messages d’après-coup
```

Le consentement et les limites doivent être lisibles dans les messages, les choix et les états.

---

# 7. Modes de communication autorisés

## `REMOTE_ASYNC`

Messagerie normale entre lieux différents.

## `TRACE_DELIVERY`

Image, document, capture ou lien envoyé avec texte.

## `SEPARATE_ROOMS_PING`

Bref message pratique ou privé entre pièces séparées.

Le chat s’arrête lors de la rencontre.

## `SAME_VENUE_LOGISTICS`

Messages courts de coordination dans un lieu bruyant ou public.

## `WORK_CHAT`

Échange professionnel écrit entre postes ou espaces distincts.

## `AFTERGLOW_REMOTE`

Messages après séparation physique.

## `TEXTUAL_OFFLINE_TRANSITION`

Courte transition écrite signalant qu’un événement s’est produit hors téléphone.

Ce mode :

- n’est pas un dialogue ;
- ne contient aucun choix de réplique orale ;
- ne retranscrit pas la conversation ;
- indique seulement temps, action générale ou résultat observable.

---

# 8. Modes interdits

```text
VOICE_CALL
VIDEO_CALL_DIALOGUE
VOICE_NOTE
AUDIO_MESSAGE
VOICED_CUTSCENE
LIVE_ORAL_CHOICE
AUDIO_SEX_SCENE
CALL_TRANSCRIPT_AS_GAMEPLAY
```

Ces modes ne doivent apparaître ni dans les documents de conception, ni dans les données runtime, ni dans les tests comme options jouables.

Une mention narrative telle que `Sandra a appelé sa mère` reste possible si l’appel est extérieur à l’expérience joueur et ne constitue pas une scène.

---

# 9. Champs requis des cartes de scènes

Toute scène de premier plan doit préciser :

```text
communication_mode
why_text_is_used
physical_context
when_messaging_stops
what_happens_off_phone
how_the_result_returns_to_text
```

Le champ `possible_offline_continuation` doit décrire une fonction ou un résultat, jamais une scène orale à produire plus tard.

---

# 10. Application aux journées J01–J21

## J01–J08

Les scènes existantes et planifiées restent compatibles lorsque :

- les choix passent par les messages ;
- les promenades, repas et installations se déroulent hors téléphone ;
- leur résultat revient ensuite par texte.

## J09–J12

Les événements sociaux et rencontres sont organisés et commentés par messages.

Les lieux physiques ne créent aucune scène audio.

## J13–J16

Les découvertes, alibis, suppressions et conflits sont portés par messages, notifications et images.

## J17–J21

Les résolutions restent jouables en messagerie.

Les décisions physiques ou conjugales peuvent être accomplies hors téléphone, puis confirmées ou recontextualisées par écrit.

---

# 11. Conséquences runtime

Le runtime futur ne nécessite :

- aucun lecteur audio ;
- aucune timeline vocale ;
- aucun fichier son narratif ;
- aucun système d’appel ;
- aucune transcription synchronisée ;
- aucun choix lié à une piste audio.

Les systèmes nécessaires restent :

- texte ;
- notifications ;
- images ;
- temps ;
- états ;
- galerie ;
- conséquences.

---

# 12. Anti-patterns

Rejeter :

- `elle t’appelle` comme méthode pour éviter d’écrire une scène de messages ;
- faux appel retranscrit en bulles ;
- note vocale utilisée comme récompense érotique ;
- scène sexuelle reposant sur des sons ;
- dialogue oral résumé par vingt lignes de narration ;
- conversation face à face artificiellement maintenue sur Messenger ;
- décision essentielle qui n’existe que dans un beat hors téléphone invisible ;
- message d’après-coup trop vague pour comprendre le choix effectué.

---

# 13. Règle finale

```text
Le joueur lit, répond, reçoit des images et observe les conséquences.

Il n’écoute aucune scène.

La vie peut se poursuivre hors du téléphone,
mais le jeu revient toujours au texte pour rendre le choix,
la mémoire et la transformation lisibles.
```