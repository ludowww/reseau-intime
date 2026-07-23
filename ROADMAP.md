# Réseau Intime — Roadmap active

## Statut

**Catégorie : Portail projet actif**

Cette roadmap résume la priorité courante. Elle ne remplace pas les sources canoniques.

---

# 1. État acquis

## Narration canonique

```text
North Star : validée
Personnages et voix : validés
Architecture Saison 1 : validée
Scripts J01–J21 : consolidés
Contrats de traces / promesses / connaissances : validés
Reachability : validée
Sign-off final : signé
```

Le corpus signé reste autoritaire pour J01–J21. La Bible Narrative reste autoritaire pour toute nouvelle production, révision structurelle ou extension.

## UX/UI

```text
T‑UI‑01   Coque portrait                         TERMINÉ
T‑UI‑02   Famille Messages                       TERMINÉ
T‑UI‑03A  Gallery Core                           TERMINÉ
T‑UI‑03B  ImageMessage                           TERMINÉ
T‑UI‑03C  PhotoViewer                            TERMINÉ
T‑UI‑03D  Gallery States                         TERMINÉ
```

Acquis :

- coque portrait additive ;
- safe areas ;
- navigation Messages / Galerie ;
- conversations privées et de groupe ;
- choix, non-lus, notifications et typing ;
- transitions hors téléphone et de journée ;
- ImageMessage ;
- Galerie responsive par personnage ;
- PhotoViewer partagé ;
- états locaux `NEW / VIEWED / LOCKED` ;
- matrices `720 × 1280`, `1080 × 1920`, `1080 × 2340` ;
- reduced motion et navigation clavier.

Le cœur UI prototype est verrouillé. Son extension est gelée par défaut.

## Runtime

`main` contient :

- le runtime narratif historique V0.xx ;
- des réconciliations ciblées ;
- le cœur UI portrait additif validé ;
- les tests statiques et outils de validation.

La migration narrative complète, la persistance Galerie, la sauvegarde cible, les vrais assets et les écrans système ne sont pas encore intégrés comme flux final.

---

# 2. Priorité active

```text
BIBLE NARRATIVE / NORTH STAR
→ choisir le prochain lot narratif
→ routes macro
→ actes
→ séquences
→ scènes modulaires
→ dialogues et photos attendues
→ découpage des journées
```

La roadmap ne fixe pas encore si le prochain lot porte sur :

- une révision ou un approfondissement de la Saison 1 ;
- une préparation d’arc suivant ;
- une bibliothèque de séquences ;
- une spécification de photos ;
- une adaptation runtime d’un bloc déjà canonique.

Cette décision produit doit être prise depuis `docs/canon/bible/`, pas depuis un ancien plan V0.xx.

---

# 3. Gel UI

Un nouveau lot UI ne doit être ouvert que pour :

1. un besoin bloquant découvert pendant la production narrative ;
2. l’intégration future des vrais assets ;
3. la persistance ou la sauvegarde ;
4. les écrans système explicitement décidés ;
5. une régression avérée.

Les préférences esthétiques non bloquantes restent en backlog.

## T‑UI‑04 — Écrans système

```text
DIFFÉRÉ
```

Cible canonique conservée :

- titre ;
- pause ;
- sauvegarde / chargement ;
- paramètres ;
- première configuration ;
- avertissement adulte ;
- confirmations ;
- erreurs et chargements.

Ce lot sera rouvert seulement lorsqu’un vertical slice système, la sauvegarde, le flux de démarrage ou un besoin narratif bloquant le justifie.

---

# 4. Runtime narratif futur

Aucun ancien lot `T‑NAR‑01` n’est automatiquement réactivé.

Toute adaptation runtime doit :

- partir de `main` courant ;
- citer la Bible, les scripts consolidés et le contrat d’état ;
- définir un bloc narratif court ;
- conserver promesses, traces, connaissances et conséquences ;
- respecter text-only et co-présence ;
- utiliser les composants UI existants plutôt que les refondre ;
- passer les tests avant publication.

La granularité exacte du prochain bloc runtime reste à décider après le prochain cadrage narratif.

---

# 5. Production visuelle

Les vrais assets ne sont pas encore intégrables dans le lot courant.

Avant production ou intégration :

1. chaque image doit avoir une fonction relationnelle précise ;
2. son origine, son audience et son consentement doivent être définis ;
3. sa place dans une séquence doit être validée ;
4. ses variantes doivent être limitées au besoin narratif réel ;
5. l’UI doit pouvoir remplacer le placeholder sans refonte architecturale.

Ordre recommandé lorsque les assets deviennent possibles :

```text
spécifications narratives des photos
→ charte visuelle cohérente des personnages
→ production par séquence
→ intégration runtime
→ QA Galerie / Messages / PhotoViewer
```

---

# 6. Distribution et finition

Après une première saison entièrement jouable :

- QA complète ;
- sauvegarde et migrations ;
- accessibilité finale ;
- performances ;
- contrôles clavier / souris / tactile ;
- écrans système ;
- crédits et avertissements ;
- packaging ;
- tests de reprise ;
- préparation des extensions narratives.

---

# 7. Différé

- onglet Profil sans fonction ;
- éditeur d’avatar complet ;
- thèmes multiples ;
- personnalisation du téléphone ;
- statistiques ;
- scores et routes visibles ;
- succès ;
- réseau social générique ;
- animations coûteuses non nécessaires au récit ;
- fonctionnalités Android spécifiques ;
- `REMOVED` et permissions Galerie tant que le runtime ne les fournit pas.

---

# 8. Règle de lot

```text
1 objectif produit
+ périmètre court
+ source canonique citée
+ tests ciblés
+ portails synchronisés
```

Aucun lot ne mélange par défaut :

```text
refonte UI globale
+ migration narrative massive
+ nouveau système de sauvegarde
+ production d’assets
```
