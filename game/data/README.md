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

visual_content/
  placeholders.json
```

## Règles

- Les personnages définissent l’identité narrative et la voix.
- `initial_state.json` définit les variables de départ.
- Les conversations sont organisées par chapitre, journée, moment et thread.
- Les effets de choix utilisent les noms de variables définis dans la documentation.
- Les placeholders visuels restent neutres tant que le pipeline d’assets adultes n’est pas défini.
- Les conversations peuvent être longues si elles installent la familiarité, mais elles ne doivent pas multiplier les choix visibles.
- Les premières images de profil doivent ancrer rapidement le casting.
- À partir du Jour 2, les conversations peuvent être segmentées par moment de journée avec `moment_label`, `transition_text`, `availability_state`, `interruption_rules` et `conversation_segment_id`.

## Scope actuel

Le contenu couvre les Jours 1 et 2 du vertical slice.

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

Aucune route dominante ne doit être verrouillée aux Jours 1 ou 2. Ces chapitres servent à installer les voix, le téléphone, les images mentales du casting, les liens exacts entre personnages, les habitudes de conversation, les interruptions et les premiers signaux faibles.
