# 10 — Scope vertical slice

## Objectif

Créer une première portion jouable qui prouve :

- le ton ;
- l’interface smartphone ;
- les notifications ;
- les conversations multiples ;
- les variables ;
- les contenus visuels comme récompenses, traces et preuves ;
- la détection progressive d’une route dominante.

Le vertical slice ne doit pas contenir tout le jeu et ne doit pas exposer tout le casting au Jour 1.

## Périmètre narratif

### Jour 1 — Ancrage intime

Scènes :

- conversation avec Marie ;
- mention indirecte de Mathilde via Marie ;
- conversation pilier avec Sandra ;
- première photo de Sandra comme trace émotionnelle.

Objectif : comprendre le couple et installer Sandra comme faille émotionnelle ancienne, sans surcharger le joueur.

Ne pas inclure au Jour 1 :

- conversation de groupe ;
- Raphaëlle active ;
- Pauline active ;
- Nico actif ;
- photo de groupe ;
- déblocage visuel complet du casting.

### Jour 2 — Ouverture progressive

Scènes possibles :

- Marie court ou moyen ;
- Mathilde plus concrète dans l’espace domestique ;
- Raphaëlle au travail ;
- Sandra en écho court, pas en deuxième pilier ;
- mention légère de Pauline ;
- Nico évoqué indirectement.

Objectif : commencer à clarifier les liens essentiels sans transformer tous les personnages en routes actives.

### Jour 3 — Soirée chez Pauline

Scène pivot.

Événements :

- groupe actif ;
- Pauline contrôle le cadre social ;
- Nico regarde Marie ;
- Mathilde remarque Ludo ;
- Sandra écrit à distance ou reste présente par absence ;
- Marie sent que Ludo peut être ailleurs ;
- le joueur choisit ses priorités entre notifications et fils.

Objectif : créer une tension multi-notifications quand le joueur connaît déjà assez les personnages.

### Jour 4 — Lendemain / première preuve

Événements possibles :

- réaction de Marie ;
- trace liée à Sandra, Mathilde, Pauline ou Nico ;
- Raphaëlle demande de la clarté ;
- story Marie / Nico ;
- première preuve conservée, supprimée ou minimisée ;
- debug de route probable.

Objectif : montrer que les contenus et choix deviennent des risques.

## Routes à tester

### 1. Marie / réparation

- Attention ou négligence de Ludo.
- Capacité à clarifier tôt.
- Réaction de Marie aux distances du téléphone.

### 2. Sandra ambiguë

- Conversation pilier émotionnelle.
- Photo comme trace fragile.
- Priorité donnée ou non à Sandra quand d’autres fils existent.
- Risque d’exposition.

### 3. Mathilde interdite

- Présence domestique d’abord indirecte.
- Premier contenu placeholder plus tard, pas Jour 1.
- Risque Marie.

### 4. Pauline piège

- Provocation à la soirée.
- Capture ou preuve.
- Risque de manipulation.

### 5. Nico / Marie jalousie

- Réaction à story.
- Compliment de Nico.
- Jalousie Ludo.
- Négligence de Marie comme carburant.

### 6. Raphaëlle contrepoint

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
- Conversation de groupe simplifiée, mais pas forcément active au Jour 1.
- Choix de réponse.
- Pièce jointe placeholder.
- Présence indirecte possible par mention dans un fil existant.

### Notifications

- Notification entrante.
- Possibilité d’ouvrir ou ignorer.
- Priorité entre plusieurs notifications.
- Certains jours avec peu de notifications pour garder un rythme réaliste.

### Variables

Implémenter seulement les variables nécessaires au slice :

```text
marie_trust
lie_score
truth_tendency
ludo_jealousy
mathilde.desire
mathilde.loyalty
sandra.attachment
sandra.exposure
pauline.control
raphaelle.clarity
nico.place_near_marie
```

Signaux passifs recommandés :

```text
marie_attention_score
marie_neglect_score
mathilde_attention_score
sandra_priority_score
raphaelle_clarity_score
pauline_risk_score
nico_surveillance_score
```

### Galerie

- Afficher les contenus débloqués.
- Conserver ou supprimer un contenu.
- Marquer un contenu comme preuve.
- Supporter une première photo émotionnelle non explicite.

La photo Sandra Jour 1 peut être visible comme trace, mais ne doit pas donner l’impression que la route Sandra est déjà verrouillée.

### RouteManager simplifié

Avant le Jour 4, éviter d’afficher une route dominante trop forte. Le debug peut afficher des signaux, mais le jeu doit considérer la route comme indécise.

À la fin du vertical slice, afficher un état :

```text
Route probable : Marie / Mathilde / Sandra / Pauline / Nico-Marie / Raphaëlle / indécise
Route secondaire : optionnelle
Menace : Marie / Pauline / Nico / Exposition / indécise
Mode probable : SECRET_AFFAIR / EXCLUSIF_REPARATION / NTR_SUBI / LIBERTINE_POSSIBLE / indécis
```

## Assets placeholders

Créer ou utiliser des fichiers neutres :

```text
photo_sandra_day1_lunch_placeholder.png
photo_mathilde_tier1_placeholder.png
photo_pauline_tier1_placeholder.png
story_marie_nico_tier1_placeholder.png
photo_raphaelle_tier1_placeholder.png
```

La photo de groupe ne doit pas être obligatoire au Jour 1. Elle peut être déplacée vers le moment où le groupe devient actif.

## Critères de réussite

Le vertical slice est réussi si :

- le joueur comprend immédiatement qu’il utilise un smartphone ;
- le Jour 1 ne surcharge pas le casting ;
- Marie et Sandra sont clairement différenciées dès le départ ;
- Mathilde existe d’abord comme présence indirecte ;
- les notifications créent une tension réelle mais respirent ;
- choisir une conversation plutôt qu’une autre change l’ambiance ;
- au moins une photo placeholder est reçue ;
- la photo peut être conservée ou supprimée plus tard si le système le permet ;
- une route probable est calculée seulement après suffisamment de signaux ;
- Marie réagit différemment selon les choix ;
- le joueur a envie de continuer pour rencontrer progressivement le reste du réseau.

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

- Jour 1 centré sur Marie et Sandra ;
- Mathilde introduite indirectement ;
- réseau élargi progressivement aux Jours 2–3 ;
- 1 soirée pivot ;
- 3 contenus visuels placeholders maximum dans le slice initial ;
- 3 routes probables possibles en fin de slice ;
- 1 écran de bilan temporaire.
