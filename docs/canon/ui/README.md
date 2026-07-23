# Réseau Intime — Index UX/UI canonique

## Statut

**Catégorie : Index canonique actif**

```text
UI‑FOUNDATION : validé
UI‑SCREENS : validé
UI‑HANDOFF : validé
T‑UI‑01 à T‑UI‑03D : implémentés et validés
UI CORE PROTOTYPE : verrouillé
Extension UI par défaut : gelée
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
→ UI_02 écrans et états canoniques
→ UI_03 intégration, état implémenté et différé
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
navigation diégétique : Messages / Galerie
Galerie : collection organisée par personnage
Profil : différé tant qu’aucune fonction produit n’est validée
interface système : distincte du téléphone diégétique
```

Le cœur UI portrait est implémenté de manière additive. Le projet conserve encore un contrôle historique `1280 × 720` et n’a pas terminé la migration du runtime narratif, de la persistance ou des écrans système.

---

# 3. Surfaces implémentées et validées

## Coque

- safe areas ;
- navigation Messages / Galerie ;
- thème local ;
- responsive portrait ;
- reduced motion ;
- navigation clavier ;
- focus visible.

## Messages

- liste des conversations ;
- conversations privées et de groupe ;
- bulles Player et personnages ;
- choix ;
- non-lus ;
- notification ;
- typing ;
- DayDivider ;
- transition hors téléphone ;
- transition de journée ;
- ImageMessage ;
- ouverture PhotoViewer ;
- restauration du scroll, du focus et du typing.

## Galerie et photo

- onglets personnages ;
- grille responsive ;
- états locaux `NEW / VIEWED / LOCKED` ;
- verrouillage non révélateur ;
- PhotoViewer partagé ;
- provenance Messages / Galerie ;
- précédente / suivante depuis Galerie ;
- placeholders générés par l’UI.

---

# 4. Écrans canoniques différés

Les contrats restent actifs pour :

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

Ils ne sont pas encore implémentés comme flux final. Leur absence actuelle ne les rend pas abandonnés.

---

# 5. Frontière prototype / runtime final

Le prototype local utilise :

- données Galerie factices ;
- photos factices générées par l’UI ;
- `NEW / VIEWED` conservés seulement dans l’instance ;
- aucun lien automatique entre ImageMessage et Galerie ;
- aucune permission narrative réelle d’ajout, retrait ou partage.

Restent différés :

- vrais assets ;
- liaison au runtime narratif ;
- persistance Galerie ;
- `REMOVED` ;
- permissions ajouter / retirer / partager ;
- écrans système ;
- polish visuel global non bloquant.

---

# 6. Palette d’identité

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

L’UI rend les conséquences visibles par :

- messages ;
- horaires ;
- absence ;
- notifications ;
- accès, retrait ou verrouillage d’un contenu ;
- comportement autonome des personnages.

---

# 8. Réouverture du chantier UI

Un nouveau lot UI ne s’ouvre que pour :

1. un besoin bloquant découvert pendant la production narrative ;
2. l’intégration future des vrais assets ;
3. la persistance ou la sauvegarde ;
4. les écrans système explicitement décidés ;
5. une régression avérée.

Les préférences esthétiques non bloquantes restent en backlog.

```text
PROCHAINE PRIORITÉ : BIBLE NARRATIVE ET PRODUCTION DES ROUTES / SÉQUENCES
```

`UI_03_INTEGRATION_HANDOFF_AND_MOCKUP_STATUS.md` décrit le checkpoint implémenté, les limites locales et les fonctions différées.
