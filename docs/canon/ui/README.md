# Réseau Intime — Index UX/UI canonique

## Statut

**Catégorie : Index canonique actif**

```text
UI‑FOUNDATION : validé
UI‑SCREENS : validé
UI‑HANDOFF : validé
Reprise technique : prête mais en attente d’autorisation explicite
```

Ce dossier contient les décisions UX/UI actives du projet.

Les maquettes générées sont des références conceptuelles. Les décisions transférées dans les documents ci-dessous sont les seules autorités produit.

> Les préfixes `UI_01`, `UI_02` et `UI_03` indiquent l’ordre de lecture. Ils ne désignent pas des versions runtime.

---

# 1. Sources actives

```text
UI_01_VERTICAL_SMARTPHONE_SYSTEM.md
UI_02_SCREEN_ARCHITECTURE_AND_STATES.md
UI_03_INTEGRATION_HANDOFF_AND_MOCKUP_STATUS.md
```

Ordre d’autorité :

```text
UI_01 système visuel et responsive
→ UI_02 écrans et états finaux
→ UI_03 contrat d’intégration
```

---

# 2. Décisions verrouillées

```text
format cible : portrait smartphone
viewport de référence : 720 × 1280
ratio de conception : 9:16
support initial : PC en fenêtre portrait
Android : plus tard
style : sombre, anime-inspired, premium et lisible
identification : couleur + avatar + nom + position
navigation MVP : Messages / Galerie
Galerie : collection classique organisée par personnage
Profil : différé tant qu’aucune fonction produit n’est validée
interface système : distincte du téléphone diégétique
```

Le `game/project.godot` reste actuellement en `1280 × 720` horizontal. Le canon UI définit la cible future ; aucune migration technique n’est impliquée par ces documents seuls.

---

# 3. Écrans narratifs validés

```text
D01 liste des conversations
D02 conversation individuelle
D03 conversation de groupe
D04 transition hors téléphone
D05 photo ouverte
D06 Galerie par personnage
D07 transition de journée
```

Règles centrales :

- une ligne Messages par personnage ou groupe ;
- un choix égale un message Player ;
- aucun message direct pendant la co-présence ;
- la reprise exige une séparation réelle ;
- partager, sauvegarder ou retirer une image dépend des permissions narratives ;
- retirer une image n’efface jamais les messages ni la connaissance déjà acquise.

---

# 4. Écrans système validés

```text
S01 écran titre
S02 menu pause
S03 sauvegarde / chargement
S04 paramètres
S05 première configuration Player
S05B avertissement adulte
S06 confirmations et erreurs
S07 crédits / informations légales
```

MVP avant le premier playtest vertical fiable :

- D01 à D07 ;
- S01 à S06 ;
- sauvegarde automatique contrôlée + slots manuels ;
- paramètres et accessibilité ;
- états vide, chargement, erreur, verrouillé et retiré.

S07 peut suivre le premier build vertical mais doit exister avant distribution publique.

---

# 5. Palette d’identité

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

La couleur n’est jamais utilisée seule.

---

# 6. Règles narratives protégées

L’UI ne doit jamais afficher :

- nom de route ;
- score relationnel ;
- pourcentage de désir ;
- propriétaire de route ;
- contradiction interne ;
- `trace_id`, `promise_id` ou `fact_id` ;
- raison technique d’éligibilité ;
- contenu exact d’une image verrouillée.

L’UI rend les conséquences visibles par :

- messages ;
- horaires ;
- absence ;
- notifications ;
- accès, retrait ou verrouillage d’un contenu ;
- comportement autonome des personnages.

---

# 7. Frontière MVP et différé

## MVP

- shell portrait ;
- Messages ;
- Galerie ;
- photo plein écran ;
- transitions ;
- titre, pause, sauvegarde, paramètres ;
- première configuration et avertissement ;
- navigation clavier et texte agrandi.

## Différé

- éditeur d’avatar ;
- thèmes multiples ;
- personnalisation du téléphone ;
- statistiques ;
- pourcentages de Galerie ;
- routes visibles ;
- succès ;
- réseau social générique ;
- onglet Profil sans fonction ;
- fonctionnalités Android spécifiques.

---

# 8. Prochaine action

```text
décision explicite de reprise technique
→ plan court T‑UI‑01 depuis main courant
→ validation du plan
→ implémentation Hermes avec Godot
```

`UI_03_INTEGRATION_HANDOFF_AND_MOCKUP_STATUS.md` définit le périmètre exact de `T‑UI‑01` et les critères de test.
