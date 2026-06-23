# 10 — Scope vertical slice

## Objectif

Créer une première portion jouable qui prouve :

- le ton ;
- l’interface smartphone ;
- les notifications ;
- les conversations multiples ;
- les variables ;
- les contenus visuels comme récompenses et preuves ;
- la détection d’une route dominante.

Le vertical slice ne doit pas contenir tout le jeu.

## Périmètre narratif

### Chapitre 1 — Routine

Scènes :

- conversation avec Marie ;
- mention de Mathilde qui passe bientôt ;
- message léger de Sandra ;
- Raphaëlle au travail ;
- Nico mentionné ;
- Pauline annonce une soirée.

Objectif : comprendre le couple et installer les personnages.

### Chapitre 2 — Premières tensions

Scènes :

- Mathilde à la maison ;
- Sandra se confie ;
- Raphaëlle remarque Ludo ;
- Nico complimente Marie ;
- Pauline semble sage mais prépare la soirée.

Objectif : ouvrir les routes.

### Chapitre 3 — Soirée chez Pauline

Scène pivot.

Événements :

- Pauline provoque Ludo par message ;
- Nico regarde Marie ;
- Mathilde remarque Ludo ;
- Sandra écrit à distance ;
- Marie sent que Ludo est ailleurs.

Objectif : créer une tension multi-notifications.

### Chapitre 4 — Lendemain / première preuve

Événements possibles :

- photo ambiguë de Mathilde ;
- message supprimé de Sandra ;
- capture ou provocation de Pauline ;
- story Marie / Nico ;
- Raphaëlle demande de la clarté.

Objectif : montrer que les contenus deviennent des risques.

## Routes à tester

### 1. Mathilde interdite

- Tension domestique.
- Premier contenu placeholder de Mathilde.
- Risque Marie.

### 2. Sandra ambiguë

- Confidence émotionnelle.
- Message supprimé ou contenu rare.
- Risque d’exposition.

### 3. Pauline piège

- Provocation à la soirée.
- Capture ou preuve.
- Risque de manipulation.

### 4. Nico / Marie jalousie

- Réaction à story.
- Compliment de Nico.
- Jalousie Ludo.

### 5. Raphaëlle contrepoint

- Attention au travail.
- Question de clarté.
- Refus du flou si Ludo est trop mensonger.

## Fonctionnalités techniques minimales

### Smartphone home

- Écran principal avec icônes.
- Accès Messages, Galerie, Réseau social, Paramètres.

### Messages

- Liste de conversations.
- Conversation privée.
- Conversation de groupe simplifiée.
- Choix de réponse.
- Pièce jointe placeholder.

### Notifications

- Notification entrante.
- Possibilité d’ouvrir ou ignorer.
- Priorité entre plusieurs notifications.

### Variables

Implémenter seulement les variables nécessaires au slice :

```text
marie_trust
lie_score
ludo_jealousy
mathilde.desire
mathilde.loyalty
sandra.attachment
sandra.exposure
pauline.control
raphaelle.clarity
nico.place_near_marie
```

### Galerie

- Afficher les contenus débloqués.
- Conserver ou supprimer un contenu.
- Marquer un contenu comme preuve.

### RouteManager simplifié

À la fin du vertical slice, afficher un état :

```text
Route dominante : Mathilde / Sandra / Pauline / Nico / Marie
Route secondaire : optionnelle
Menace : Marie / Pauline / Nico / Exposition
Mode probable : SECRET_AFFAIR / EXCLUSIF_REPARATION / NTR_SUBI / LIBERTINE_POSSIBLE
```

## Assets placeholders

Créer des fichiers neutres :

```text
photo_mathilde_tier1_placeholder.png
photo_sandra_tier1_placeholder.png
photo_pauline_tier1_placeholder.png
story_marie_nico_tier1_placeholder.png
photo_raphaelle_tier1_placeholder.png
```

## Critères de réussite

Le vertical slice est réussi si :

- le joueur comprend immédiatement qu’il utilise un smartphone ;
- les notifications créent une tension réelle ;
- choisir une conversation plutôt qu’une autre change l’ambiance ;
- au moins une photo placeholder est reçue ;
- la photo peut être conservée ou supprimée ;
- une route dominante est calculée ;
- Marie réagit différemment selon les choix ;
- le joueur a envie de recommencer pour tester une autre dynamique.

## Ce qui est hors scope

- Toutes les fins complètes.
- Tous les contenus explicites définitifs.
- Système de temps réel.
- Export Android.
- Harem complet.
- Quatuor complet.
- Production graphique finale.
- Système de succès / achievements.

## Premier objectif concret

Créer une démo narrative de 20 à 30 minutes maximum avec :

- 6 personnages introduits ;
- 1 soirée pivot ;
- 5 conversations actives ;
- 3 contenus visuels placeholders ;
- 3 routes dominantes possibles ;
- 1 écran de bilan temporaire.