# Données de jeu

Ce dossier contient les premiers fichiers JSON exploitables par le futur prototype Godot.

## Structure

```text
characters/
  ludo.json
  marie.json
  mathilde.json
  sandra.json
  raphaelle.json
  pauline.json
  nico.json

state/
  initial_state.json

conversations/
  chapter_01_index.json
  chapter_01_marie.json
  chapter_01_sandra.json
  chapter_01_raphaelle.json
  chapter_01_group_friends.json
  chapter_02_index.json
  chapter_02_marie_morning.json
  chapter_02_raphaelle_midday.json
  chapter_02_social_marie_nico.json
  chapter_02_mathilde_home.json
  chapter_02_sandra_evening.json
  chapter_02_group_pauline_night.json
  chapter_03_index.json
  chapter_03_pre_party_threads.json
  chapter_03_party_group_arrival.json
  chapter_03_crossed_notifications.json
  chapter_03_party_pressure.json
  chapter_03_wallpaper_reveal.json
  chapter_03_party_aftershock.json
  chapter_04_index.json
  chapter_04_marie_morning_reaction.json
  chapter_04_conditional_proofs.json
  chapter_04_raphaelle_lunch_contrast.json
  chapter_04_social_after_party.json
  chapter_04_route_pressure_and_debug.json

visual_content/
  placeholders.json
  chapter_04_proofs.json
```

## Validation

Depuis la racine du dépôt :

```bash
python tools/validate_game_data.py
```

Le validateur vérifie notamment :

- JSON valide ;
- IDs dupliqués ;
- références `res://data/...` ;
- références `content_id` ;
- variables inconnues dans les `effects` ;
- flags utilisés en condition mais jamais créés.

## Règles

- Les personnages définissent l’identité narrative et la voix.
- `initial_state.json` définit les variables de départ.
- Les conversations sont organisées par chapitre, journée, moment et thread.
- Les effets de choix utilisent les noms de variables définis dans la documentation.
- Les placeholders visuels restent neutres tant que le pipeline d’assets adultes n’est pas défini.
- Les conversations peuvent être longues si elles installent la familiarité, mais elles ne doivent pas multiplier les choix visibles.
- Les premières images de profil doivent ancrer rapidement le casting.
- À partir du Jour 2, les conversations peuvent être segmentées par moment de journée avec `moment_label`, `transition_text`, `availability_state`, `interruption_rules` et `conversation_segment_id`.
- À partir du Jour 3, les données peuvent inclure des choix de priorité, des branches conditionnelles et des aftershocks selon les flags.
- À partir du Jour 4, les données peuvent inclure des preuves conditionnelles et un calcul debug de route probable.

## Scope actuel

Le contenu couvre les Jours 1, 2, 3 et 4 du vertical slice.

### Jour 1

- routine avec Marie ;
- premier message de Sandra, plus long pour installer leur familiarité ;
- premier échange avec Raphaëlle au travail ;
- annonce de la soirée chez Pauline dans le groupe amis ;
- première image de groupe ;
- photos de profil initiales des personnages principaux.

### Jour 2

- matin avec Marie : routine, Mathilde identifiée comme cousine par alliance de Marie et présence familière du foyer ;
- midi avec Raphaëlle : collègue attentive, claire, avec sa propre journée ;
- après-midi social : story de Marie, réactions de Nico, jalousie légère ;
- début de soirée avec Mathilde : présence à la maison, interruption par Marie, première photo domestique non explicite ;
- soir avec Sandra : message interrompu par son partenaire, reprise intime, message supprimé ;
- nuit dans le groupe : Pauline prépare la soirée, Nico vise Marie publiquement, Pauline peut envoyer un privé conditionnel.

### Jour 3

- avant soirée : Marie prépare le départ, Raphaëlle existe comme contraste hors soirée ;
- arrivée chez Pauline : groupe actif, Pauline hôte, Nico vise Marie, Mathilde observe ;
- notifications croisées : le joueur choisit quoi ouvrir en premier ;
- milieu de soirée : pression sociale, Pauline observe, Mathilde prévient, Nico reste près de Marie ;
- fond d’écran : révélation conditionnelle pouvant transformer un choix privé en preuve sociale ;
- fin de soirée : aftershock conditionnel selon la route probable ou la menace active.

### Jour 4

- matin : Marie réagit à la distance ou au téléphone après la soirée ;
- fin de matinée : première preuve conditionnelle selon les flags du Jour 3 ;
- midi : Raphaëlle agit comme contraste lucide extérieur ;
- après-midi : le réseau social garde une mémoire publique de la soirée ;
- soir : dernier crochet conditionnel et calcul debug de route probable.

Aucune route finale ne doit être verrouillée aux Jours 1, 2, 3 ou 4. Au Jour 4, une route dominante probable et une menace active doivent pouvoir émerger dans le debug, mais le récit reste encore récupérable.