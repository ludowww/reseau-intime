# Réseau Intime

**Réseau Intime** est un jeu narratif adulte en interface smartphone, développé avec Godot 4.6.x.

Le joueur incarne **Player**, en couple avec **Marie**. Leur vie commune reste réelle et désirable, mais la routine, les images, les secrets, la jalousie et les désirs croisés obligent chacun à choisir ce qu’il veut préserver, cacher, partager ou quitter.

```text
Quand les personnages sont ensemble, ils parlent.
Quand la distance, la logistique, la confidentialité, une trace ou l'après-coup le justifie, le téléphone enregistre l'échange.
```

## Question centrale

```text
Le couple Player / Marie
peut-il redevenir un choix actif ?
```

## Architecture

```text
tronc dramatique fixe
+ choix topologiques
+ fenêtres narratives
+ scènes modulaires
+ obligations et traces persistantes
+ conséquences revenant vers le couple
```

Les routes utilisent R0–R5, mais le runtime actuel reste en R1 maximum.

## État jouable actuel — V0.82

### Mardi

```text
J1 — Les choses qu'on remarque
Marie + Sandra
couple = HABITUAL_WARMTH
```

### Mercredi

```text
Marie / faire de la place
Marie / trace d'arrivée
Mathilde / arrivée
installation hors ligne
```

Mathilde atteint R1 Ordinary Access.

### Jeudi

```text
09:10 Raphaëlle / travail
13:50 Sandra / écho optionnel
16:05 Marie / choix topologique M1
soir   une seule branche O5
22:10+ retour obligatoire O6 vers Marie
```

M1 propose :

```text
1. rejoindre Marie tôt
2. rester au foyer
3. finir le travail et promettre de venir ensuite
```

Le choix débloque exactement une scène :

```text
Marie / La Verrière
OU
Mathilde / foyer
OU
Raphaëlle / travail
```

Toute branche revient ensuite vers Marie.

## Navigation active

```text
chapter_01_modular_index.json
chapter_02_modular_index.json
chapter_03_modular_index.json
```

Les anciens Chapter 2–9 restent dans le dépôt pour historique et rollback, mais ne sont pas chargés comme continuation actuelle.

## Fondation runtime V0.82

Le prototype possède désormais :

- des jours et heures pilotés par les données ;
- un seul fil persistant par personnage ;
- des épisodes cumulés entre les jours ;
- des déblocages conditionnés par flags ;
- un déblocage après n’importe laquelle de plusieurs scènes ;
- des messages et choix conditionnels ;
- des `offline_beat` sans faux expéditeur ;
- une topologie exclusive ;
- une conséquence Marie obligatoire.

Aucun scheduler universel n’a été ajouté.

## État narratif après jeudi

```text
Mathilde = R1 domestique
Raphaëlle = R1 travail
Sandra = continuité douce
Marie/Player = HABITUAL_WARMTH
hard secrets = none
adult frames = none
Friday = not implemented
```

## Temps et communication

Modes actuels :

```text
REMOTE_ASYNC
TRACE_DELIVERY
SEPARATE_ROOMS_PING
SAME_VENUE_LOGISTICS
WORK_CHAT
OFFLINE_BEAT
AFTERGLOW_REMOTE
```

Les échanges dans une même pièce s’arrêtent lorsque les personnages peuvent parler face à face.

## Sources

Commencer par :

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
```

Rapport runtime V0.82 :

```text
docs/V0_82_Thursday_Topology_And_Marie_Return_Runtime_Report.md
```

## Workflow

```text
1. canon
2. source pack / cartes / temporalité
3. plan runtime
4. petite tranche verticale
5. validation
6. tranche suivante
```

## Règles adultes fondamentales

```text
Ignorer n'est pas consentir.
Une connaissance partielle n'est pas une permission.
La jalousie ou l'excitation n'est pas une permission.
Une image publique n'est pas une permission de transmettre.
Un vêtement ou costume n'est pas un consentement global.
Un secret clairement nommé reste une trahison.
```

## Prochaine étape

Après validation de V0.82 :

```text
V0.83 — Friday public traces and opening completion
```
