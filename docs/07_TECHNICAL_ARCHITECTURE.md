# 07 — Architecture technique

## Recommandation moteur

Moteur recommandé : **Godot 4.x**.

Raisons :

- très adapté à une interface smartphone custom ;
- bonne gestion 2D/UI ;
- contrôle total des notifications, transitions et applications fictives ;
- export PC puis mobile possible ;
- GDScript suffisant pour un prototype ;
- intégration facile de fichiers JSON.

Alternative : Ren’Py pour un visual novel plus classique. Moins recommandé ici car l’interface smartphone et les multiples applications demandent une UI plus libre.

## Plateforme de développement

Phase 1 : PC avec smartphone simulé dans une fenêtre.  
Phase 2 : adaptation Android éventuelle.  
Phase 3 : éventuel export desktop/mobile selon besoins.

## Architecture générale

```text
game/
  scenes/
    Main.tscn
    smartphone/
      PhoneHome.tscn
      NotificationLayer.tscn
      AppMessages.tscn
      AppSocial.tscn
      AppGallery.tscn
      AppContacts.tscn
      AppSettings.tscn
  scripts/
    core/
      GameState.gd
      RouteManager.gd
      VariableStore.gd
      SaveManager.gd
      NotificationManager.gd
    messaging/
      ConversationManager.gd
      MessageRenderer.gd
      ChoiceResolver.gd
    content/
      VisualContentManager.gd
      GalleryManager.gd
      ProofManager.gd
  data/
    characters/
    conversations/
    routes/
    endings/
    visual_content/
```

## Modules principaux

### GameState

Contient l’état courant de la partie : chapitre, route dominante, variables, contenus débloqués, secrets, conversations vues.

### VariableStore

Stocke les variables globales et par personnage.

Variables globales initiales :

```text
marie_trust
lie_score
social_pressure
ludo_jealousy
truth_tendency
```

Variables personnages :

```text
marie.trust
marie.lucidity
mathilde.desire
mathilde.loyalty
sandra.attachment
sandra.exposure
raphaelle.attachment
raphaelle.clarity
pauline.interest
pauline.control
nico.desire_for_marie
nico.place_near_marie
```

### RouteManager

Calcule :

- route dominante ;
- route secondaire ;
- menace principale ;
- mode relationnel.

Ce calcul intervient à la fin de certains chapitres ou après certains pivots.

### ConversationManager

Charge les conversations, vérifie les conditions et affiche les messages disponibles.

### ChoiceResolver

Applique les effets d’un choix : variables, contenus, flags, secrets, route, prochaine scène.

### NotificationManager

Gère les notifications entrantes et leur priorité.

### VisualContentManager

Gère les photos, vidéos, stories et contenus liés à un contexte narratif.

### GalleryManager

Gère ce que le joueur a ouvert, conservé, supprimé ou capturé.

### ProofManager

Gère les preuves et leur potentiel de découverte.

## Système de données

Format recommandé : JSON maison.

Pourquoi :

- conversations sous forme de messages ;
- choix multiples ;
- pièces jointes ;
- conditions ;
- effets ;
- preuves ;
- notification et applications.

Yarn Spinner peut être étudié plus tard, mais le format smartphone est spécifique. Un système JSON sera plus direct au début.

## Système de sauvegarde

Sauvegarde au minimum :

```text
chapitre courant
route dominante
route secondaire
menace
mode relationnel
variables globales
variables personnages
messages vus
choix effectués
contenus débloqués
contenus supprimés
preuves conservées
flags narratifs
```

## Temps du jeu

Recommandation : temps simulé par chapitres, pas temps réel.

Exemple :

```text
Jour 1 — matin
Jour 1 — soir
Jour 2 — travail
Jour 3 — soirée Pauline
```

Le temps réel rendrait le projet plus complexe sans bénéfice immédiat.

## Interface smartphone

Le smartphone est une métaphore jouable, pas nécessairement un vrai OS.

Priorité :

1. Accueil téléphone.
2. Messages.
3. Notifications.
4. Galerie.
5. Réseau social.
6. Archives / preuves.

## Vertical slice technique minimal

Le premier prototype doit prouver :

- ouvrir une conversation ;
- recevoir une notification ;
- choisir une réponse ;
- modifier une variable ;
- débloquer une image placeholder ;
- conserver ou supprimer cette image ;
- afficher une conséquence différée ;
- calculer une route dominante simple.

## Règles anti-complexité

- Pas plus de 5 variables globales au départ.
- 2 variables maximum par personnage.
- 1 route dominante, 1 route secondaire, 1 menace.
- Les contenus visuels doivent être liés à des scènes, jamais ajoutés seuls.
- Les scènes communes doivent être écrites avant les variations longues.
- Le jeu ne doit pas tenter de simuler librement tous les personnages tout le temps.