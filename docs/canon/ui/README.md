# Réseau Intime — Index UX/UI canonique

## Statut

**Catégorie : Index canonique actif**

**Phase active : UI‑SCREENS — spécifications et maquettes finales**

**UI‑FOUNDATION : validé**

Ce dossier contient les décisions UX/UI actives du projet.

Les maquettes générées pendant les échanges sont des références visuelles. Les décisions transférées ici sont les seules autorités produit.

> Les préfixes `UI_01`, `UI_02` et `UI_03` indiquent l’ordre de lecture des documents. Ils ne désignent pas les lots de travail.

---

# 1. Sources actives

```text
UI_01_VERTICAL_SMARTPHONE_SYSTEM.md
UI_02_SCREEN_ARCHITECTURE_AND_STATES.md
UI_03_INTEGRATION_HANDOFF_AND_MOCKUP_STATUS.md
```

Lecture obligatoire dans cet ordre.

---

# 2. Décisions verrouillées par UI‑FOUNDATION

```text
format cible : portrait smartphone
viewport de référence futur : 720 × 1280
ratio de conception : 9:16
support : téléphone + fenêtre PC portrait
style : sombre, anime-inspired, premium et lisible
identification : couleur + avatar + nom + position
navigation MVP : Messages / Galerie
Galerie : collection classique organisée par personnage
Profil : différé tant qu’aucune fonction produit n’est validée
interface système : distincte du téléphone diégétique
```

Le `game/project.godot` reste actuellement en `1280 × 720` horizontal.

UI‑FOUNDATION définit la cible ; il ne modifie pas encore le runtime.

---

# 3. Écrans narratifs prévus

```text
D01  liste des conversations
D02  conversation individuelle
D03  conversation de groupe
D04  transition hors téléphone
D05  photo ouverte
D06  galerie par personnage
D07  transition de journée
```

Les notifications, indicateurs de saisie, choix et modales d’image sont des composants, pas des écrans indépendants.

---

# 4. Écrans système prévus

```text
S01  écran titre
S02  menu pause
S03  sauvegarde / chargement
S04  paramètres
S05  première configuration Player
S06  modales de confirmation
S07  crédits / informations légales
```

Les écrans système partagent la direction visuelle mais ne sont pas présentés comme des applications du téléphone de Player.

---

# 5. Frontière MVP

## Obligatoire avant le premier playtest vertical fiable

- D01 à D07 ;
- S01 à S06 ;
- résolution portrait et safe areas ;
- composants responsive ;
- taille de texte réglable ;
- couleurs personnages accessibles ;
- sauvegarde automatique + slots manuels ;
- états verrouillé, retiré, vide, chargement et erreur.

## Différé

- personnalisation complète du téléphone ;
- éditeur d’avatar ;
- thèmes multiples ;
- statistiques ;
- pourcentages de galerie ;
- routes visibles ;
- réseau social complet ;
- succès ;
- onglet Profil sans fonction concrète.

---

# 6. Palette d’identité actuelle

```text
Marie      bleu
Sandra     turquoise
Mathilde   ambre
Pauline    rose
Raphaëlle  vert
Nico       ardoise
Groupes    violet
Player     violet désaturé constant
```

Les valeurs exactes et les règles d’accessibilité sont définies dans `UI_01_VERTICAL_SMARTPHONE_SYSTEM.md`.

---

# 7. Règles narratives protégées

L’UI ne doit jamais afficher :

- nom de route ;
- score relationnel ;
- pourcentage de désir ;
- propriétaire de route ;
- contradiction interne ;
- `trace_id`, `promise_id` ou `fact_id` ;
- raison technique d’éligibilité ;
- contenu exact d’une image verrouillée.

L’UI doit rendre visibles les conséquences par :

- messages ;
- horaires ;
- absence ;
- notifications ;
- contenu accessible ou retiré ;
- comportement autonome des personnages.

---

# 8. Travail actif

```text
UI‑SCREENS — spécifications détaillées et maquettes finales des écrans manquants
```

Puis :

```text
UI‑HANDOFF — contrat d’intégration final
→ décision explicite de reprise technique
→ migration verticale
```

Aucun changement technique n’est autorisé par UI‑FOUNDATION seul.
