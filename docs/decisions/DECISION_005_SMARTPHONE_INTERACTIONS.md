# DECISION 005 — Scope des interactions smartphone

## Statut

Validé.

## Décision

Le jeu se concentre sur les interactions smartphone visuelles et textuelles. Il n’inclut pas de vocaux ou d’appels simulés avec voix dans le prototype ni dans le scope initial.

## Interactions incluses

Interactions prioritaires :

```text
Messages privés
Conversations de groupe
Notifications simultanées
Photos reçues
Mini-vidéos reçues
Posts et stories
Réactions aux publications
Commentaires publics
Messages supprimés
Captures d’écran
Galerie / archives / suppression
Statuts vu / en ligne / en train d’écrire
Fond d’écran du téléphone
Révélation publique du fond d’écran
Paramètres de confidentialité visuelle
```

## Interactions exclues du scope initial

```text
Messages vocaux avec audio
Appels vocaux simulés
Doublage des personnages
Système de son narratif lié aux voix
```

Les appels manqués peuvent éventuellement exister sous forme de notification textuelle, mais aucune voix ne doit être produite ou gérée.

## Raison

Les voix ajoutent une complexité importante :

- production audio ;
- casting ou génération vocale ;
- cohérence des voix ;
- localisation ;
- poids des fichiers ;
- gestion technique du son ;
- risque de casser l’immersion si la qualité n’est pas suffisante.

Le projet privilégie donc une écriture smartphone textuelle, visuelle et interactive.

## Interaction spéciale validée : fond d’écran compromettant

Le joueur peut choisir une image reçue comme fond d’écran du téléphone.

Cette image peut être :

- neutre ;
- romantique ;
- ambiguë ;
- intime ;
- compromettante ;
- liée à Marie ;
- liée à une autre femme ;
- liée à une route secrète.

Lors de certaines scènes, notamment dans une conversation de groupe ou une situation sociale, le joueur peut être amené à dévoiler son fond d’écran.

Si le fond d’écran est compromettant, les personnages présents peuvent réagir.

## Fonction narrative du fond d’écran

Le fond d’écran est une interaction forte car il transforme une récompense privée en preuve publique.

Il sert à créer :

- jalousie ;
- humiliation ;
- soupçon ;
- rire gêné ;
- révélation accidentelle ;
- tension de groupe ;
- conséquence différée ;
- choix entre assumer, mentir ou minimiser.

## Exemple

Player reçoit une photo ambiguë de Mathilde et la met en fond d’écran.

Plus tard, pendant une conversation de groupe :

```text
Pauline : Montre ton fond d’écran, on va voir qui est le plus cringe 😇
Nico : Ah oui, vas-y Player.
Marie : Pourquoi pas.
```

Si le fond d’écran est Mathilde :

```text
Marie : C’est Mathilde ?
Mathilde : Attends, quoi ?
Pauline : Ah.
Nico : Joli choix.
```

## Types de conséquences

Selon le fond d’écran :

```text
Marie photo tendre       → renforce le couple ou rassure Marie
Marie photo provocante   → peut gêner ou réveiller le désir
Mathilde ambiguë         → soupçon familial / domestique
Sandra intime            → infidélité émotionnelle visible
Raphaëlle douce          → soupçon de relation de travail
Pauline provocante       → Pauline peut s’en servir comme preuve
Marie + Nico             → jalousie de Player ou dynamique NTR
Fond neutre              → aucune conséquence forte
```

## Règle de design

> Un fond d’écran est un choix expressif tant qu’il reste privé. Il devient une preuve quand le téléphone est montré.

## Conséquence technique

Le système de galerie doit permettre :

- définir une image comme fond d’écran ;
- lire le fond d’écran actif depuis l’état de partie ;
- associer des tags au fond d’écran ;
- déclencher des réactions si le fond d’écran est révélé.

Données recommandées :

```text
current_wallpaper_content_id
wallpaper_tags
wallpaper_risk_level
wallpaper_known_by[]
```

## Règle anti-complexité

Le fond d’écran ne doit pas déclencher une conséquence majeure à chaque scène. Il doit être vérifié seulement lors de scènes prévues :

- jeu social ;
- discussion de groupe ;
- Marie prend le téléphone ;
- Pauline demande à voir ;
- Nico provoque ;
- mode debug / test.

## Priorité prototype

Pour le vertical slice, le système peut être testé avec :

- 1 image neutre ;
- 1 image Marie ;
- 1 image Mathilde ;
- 1 scène de groupe où le fond est révélé ;
- 3 réactions possibles : neutre, Marie rassurée, Marie soupçonneuse.