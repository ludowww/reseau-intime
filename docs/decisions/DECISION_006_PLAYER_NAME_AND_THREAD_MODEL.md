# DECISION_006 — Nom Player et modèle de fils Messages

## Statut

Validé pour la documentation produit et le prototype data-first.

## Décision

`Player` est le nom générique temporaire du protagoniste. À terme, le joueur choisira son prénom en début de partie et ce prénom sera le nom affiché dans les textes visibles.

Les docs ne doivent donc pas traiter l’ancien prénom historique comme nom canonique visible définitif. Les formulations produit doivent préférer :

- `Player` quand on parle du placeholder actuel ;
- `le personnage joueur` quand le nom affiché n’a pas d’importance ;
- `le prénom choisi par le joueur` quand on décrit l’expérience finale.

## Règles nom / identifiants

- Ne pas réintroduire l’ancien prénom historique dans les textes visibles définitifs.
- Ne pas le documenter comme prénom canonique du héros.
- Des identifiants internes historiques peuvent rester temporairement si non visibles et si leur renommage n’est pas nécessaire au patch.
- Les exemples de données doivent utiliser `player` pour l’identifiant générique quand ils ne décrivent pas un legacy interne.

## Modèle Messages

Une ligne Messages = un fil visible par personnage ou groupe.

Plusieurs épisodes internes peuvent alimenter le même fil visible : par exemple plusieurs épisodes Marie sur J2 restent dans la ligne `Marie`, pas dans des lignes `Marie matin`, `Marie après-midi`, `Marie nuit`.

## Pending / unread

- `pending` / `unread` apparaît au démarrage initial d’un jour si le fil est réellement disponible avec messages non lus.
- `pending` / `unread` apparaît aussi lors d’un vrai unlock d’épisode.
- Ouvrir une discussion ne doit pas rendre les autres fils `unread`.
- Pas d’unread fantôme : un fil ne redevient unread que si un nouvel épisode ou message est effectivement débloqué.
