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
Scripts J01–J21 : consolidés et signés
Contrats de traces / promesses / connaissances : validés
Reachability : validée
NAR‑PROD‑01 : audit terminé et intégré
NAR‑PROD‑02 : paquet Acte I intégré
NAR‑PROD‑03 : paquet Acte II intégré
NAR‑PROD‑04 : paquet Acte III intégré
NAR‑CANON‑01 : correctif J14→J16 intégré
NAR‑PROD‑05 : paquet Acte IV intégré
NAR‑PROD‑06 : paquet Acte V intégré
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

Le cœur UI prototype est verrouillé. Son extension est gelée par défaut.

## Runtime

`main` contient le runtime narratif historique, des réconciliations ciblées, le cœur UI portrait additif validé et les outils de validation.

La migration narrative complète, la persistance Galerie, la sauvegarde cible, les vrais assets et les écrans système ne sont pas encore intégrés comme flux final.

---

# 2. Positionnement de production verrouillé

```text
J01–J21 restent la Saison 1 de référence.
```

Le corpus signé n’est pas rouvert comme chantier structurel général. Les corrections restent ciblées et doivent répondre à une contradiction canonique, une rupture de continuité, un problème de consentement ou d’audience, une incohérence entre sources ou un blocage de production démontré.

Hiérarchie relationnelle :

```text
Marie      centre dramatique obligatoire et transformation complète
Sandra     bascule complète possible
Mathilde   bascule complète possible
Pauline    promesse forte d’extension avec ligne autonome en Saison 1
Raphaëlle  graine structurante avec conséquence et futur concret
Nico       graine structurante avec décision engageante et conséquence
```

Toutes les relations doivent changer, sans atteindre nécessairement la même profondeur.

Carte autoritative :

```text
docs/canon/bible/11_DISTRIBUTION_SEQUENCES_SCENES_IMAGES_CONSEQUENCES_JOURNEES.md
```

Aucun second calendrier concurrent ne doit être créé.

---

# 3. NAR‑PROD‑01 — Audit terminé

Source :

```text
docs/canon/dialogues/NAR_PROD_01_AUDIT_PREPARATION_PRODUCTION_SAISON_1.md
```

Verdict :

```text
ACTES I–V : READY
J01–J21 NARRATIF : 21 / 21 READY
RÉÉCRITURE STRUCTURELLE : NON REQUISE
VISUELS FINAUX : remplacés par les paquets NAR‑PROD‑02 à NAR‑PROD‑06
RUNTIME : GELÉ / HORS PÉRIMÈTRE
```

NAR‑PROD‑01 confirme que les scripts, registres, conséquences et états permettent d’extraire des paquets de production sans rouvrir l’architecture.

---

# 4. NAR‑PROD‑02 — Acte I prêt

Source :

```text
docs/canon/dialogues/NAR_PROD_02_PAQUET_PRODUCTION_ACTE_I_J01_J04.md
```

```text
J01–J04 : READY
13 contenus principaux
15 fichiers visuels sources
2 PHOTO_DIÉGÉTIQUE
11 SOUVENIR_IMAGE_DE_SCÈNE
0 variante conditionnelle
```

Décisions centrales :

- Player reste non identifiable pendant l’Acte I ;
- T04 est un `PHOTO_SET` Pauline / Bastien / Marie composé de trois frames obligatoires ;
- J02 reste sans photo diégétique et conserve T02 comme `FACT_RECORD` ;
- les images de scène restent non transférables, non découvrables et sans catégorie visible « Souvenir » ;
- aucune décision produit ne reste ouverte pour J01–J04.

---

# 5. NAR‑PROD‑03 — Acte II prêt

Source :

```text
docs/canon/dialogues/NAR_PROD_03_PAQUET_PRODUCTION_ACTE_II_J05_J08.md
```

Verdict :

```text
J05–J08 : READY
12 beats servis par partie
11 nouveaux contenus principaux
6 contenus Acte I réutilisés
14 nouveaux fichiers sources
3 variantes conditionnelles J08
```

Décisions centrales :

- J05 conserve Marie comme pivot et Sandra comme seule continuité extérieure optionnelle ;
- J06 conserve Mathilde comme seule continuité extérieure optionnelle, avec un chemin sans continuité pleinement valide ;
- J07 donne le pivot à Nico, Raphaëlle en secondaire professionnel et le retour au foyer ;
- J08 représente la première superposition par trois états locaux, jamais par paires théoriques ;
- l’échange Sandra J05 est la seule nouvelle source dialoguée du paquet et réutilise T01 sans nouvel asset ;
- Player reste non identifiable ;
- aucun nouveau `PHOTO_DIÉGÉTIQUE` ;
- le comportement Galerie conditionnel reste différé sans rouvrir l’UI.

Ce paquet ne produit aucun asset et n’autorise aucune modification runtime par lui seul.

---

# 6. NAR‑PROD‑04 — Acte III prêt

Source :

```text
docs/canon/dialogues/NAR_PROD_04_PAQUET_PRODUCTION_ACTE_III_J09_J12.md
```

Verdict :

```text
J09–J12 : READY
14 beats servis par partie
21 nouveaux contenus principaux
8 réutilisations antérieures distinctes
30 nouveaux fichiers sources
2 variantes conditionnelles J11
```

Décisions centrales :

- J09 possède Marie comme pivot unique ; l’ancien prototype Sandra-only est non autoritatif ;
- J10 sélectionne invisiblement une seule continuité extérieure ou aucune ;
- J11 continue exclusivement le pivot réellement actif ou Marie ;
- J12 converge sans image de groupe all-cast universelle ;
- Player reste non identifiable ;
- `FACT_RECORD`, `PHOTO_DIÉGÉTIQUE` et `SOUVENIR_IMAGE_DE_SCÈNE` restent strictement séparés ;
- les deux seules variantes couvrent Mathilde proximité/distance et Marie reconquête/limite ;
- aucune décision produit ne reste ouverte pour J09–J12.

Ce paquet ne produit aucun asset et n’autorise aucune modification runtime par lui seul.

---

# 7. NAR‑CANON‑01 — J14→J16 réparé

Source :

```text
docs/canon/dialogues/NAR_CANON_01_REPARATION_PROMESSES_ATTEIGNABILITE_J14_J16.md
```

Sources autoritatives corrigées :

```text
docs/canon/dialogues/J01_J21_PROMISE_REGISTRY.md
docs/canon/dialogues/J01_J21_REACHABILITY_MATRIX.md
docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md
```

Verdict :

```text
7 nouvelles promesses conditionnelles J14→J15
P14 : D-C avec heure précise uniquement
P15 : PAID ou FAILED en J14
S28 FULL_COLLISION : deux fiches prouvées requises
S28 sans paire : S28_MUTATION_NO_COLLISION
Raphaëlle : mutation, seconde obligation professionnelle MISSING_SIGNED_SOURCE
Nico : mutation par défaut
P17 : créée seulement si conséquence réelle restante
J16 priorité 8 : atteignable après fermeture propre
VALIDATION PRODUIT : PASS
```

Le correctif ne modifie aucun dialogue signé, aucun runtime, aucun JSON, aucun test, aucun asset et aucun comptage visuel de NAR‑PROD‑05.

---

# 8. NAR‑PROD‑05 — Acte IV prêt

Source :

```text
docs/canon/dialogues/NAR_PROD_05_PAQUET_PRODUCTION_ACTE_IV_J13_J16.md
```

Verdict :

```text
J13–J16 : READY
12 beats servis par partie
10 nouveaux contenus principaux
12 réutilisations antérieures distinctes
12 nouveaux fichiers sources
2 fichiers enfants
1 variante conditionnelle
2 PHOTO_DIÉGÉTIQUE
8 SOUVENIR_IMAGE_DE_SCÈNE
0 FACT_RECORD visuel
```

Décisions centrales :

- J13 sert une seule conséquence et conserve un écho Marie ;
- C13-01 Pauline et C13-02 Raphaëlle sont mutuellement exclusifs dans une partie ;
- T17 est la quatrième frame privée Pauline issue de C12-03 à L’Annexe ;
- T18 est une photographie autonome créée par Maud et sélectionnée par Raphaëlle ;
- J14 ne découvre qu’une trace déjà accessible et utilise un fallback propre sinon ;
- J15 joue `FULL_COLLISION` uniquement avec deux promesses prouvées, puis `S28_MUTATION_NO_COLLISION` sinon ;
- Raphaëlle et Nico n’obtiennent aucune seconde obligation inventée ni fichier de substitution ;
- P17 n’existe que si une conséquence réelle reste due ;
- J16 peut atteindre la priorité 8 après fermeture propre ;
- aucune décision produit ne reste ouverte pour J13–J16.

Le paquet corrige uniquement T17 et T18 dans le Trace Registry. Il ne produit aucun asset et n’autorise aucune modification runtime par lui seul.

---

# 9. NAR‑PROD‑06 — Acte V prêt

Source :

```text
docs/canon/dialogues/NAR_PROD_06_PAQUET_PRODUCTION_ACTE_V_J17_J21.md
```

Verdict :

```text
J17–J21 : READY
15 beats servis par partie
8 nouveaux contenus principaux
14 réutilisations historiques distinctes disponibles
13 nouveaux fichiers sources
3 fichiers enfants
2 variantes conditionnelles
J21 : 0 nouveau contenu, 0 fichier, 0 trace, 0 photographie
```

Décisions centrales :

- J17 mutualise visuellement les états du couple en deux familles sans fusionner les états narratifs ;
- T23 reste un `FACT_RECORD` sans fichier ;
- T24 est une impression physique contrôlée par Sandra qui réutilise T01 sans nouveau fichier photographique ;
- C18-01 reste une image de scène distincte et ne devient jamais T24 ;
- l’intimité tardive Sandra remplace la résolution standard et son aftercare J19 réutilise la variante J18 ;
- J19 contient deux foregrounds de catalogue alternatifs, jamais deux foregrounds servis ensemble ;
- T25 et T26 restent respectivement message et état d’accès, sans image ;
- J20 donne une position active à Nico sans variante par état ;
- P23 existe à la proposition précise et ne devient `ACTIVE` qu’après acceptation ;
- T27 et T28 restent fait ou absence, jamais photographie ;
- J21 fonctionne exclusivement par réutilisation, contexte ou absence sous `NO_NEW_ASSET` ;
- aucun comportement Galerie ou onglet « Souvenir » n’est ajouté ;
- aucune décision produit ne reste ouverte pour J17–J21.

Le paquet ne modifie aucun registre, dialogue signé, runtime, JSON, test, UI ou asset.

---

# 10. Prochaine priorité recommandée

```text
Cycle adulte : intégré
Scripts et registres : amendés
NAR-PROD-04/05/06 : amendés
ASSET-01 : intégré
ASSET-02 : intégré
ASSET-03 : prochain lot
Production visuelle réelle : non commencée
ComfyUI : toujours non lancé en production
```

Prochaine priorité :

```text
ASSET-03
prochain lot de préproduction visuelle
```

---

# 11. Gel technique

Par défaut :

```text
UI       GELÉE
RUNTIME  GELÉ
ASSETS   SPÉCIFIÉS, NON PRODUITS
```

Une réouverture technique exige un besoin narratif bloquant, une donnée indispensable absente, une limite UI avérée, une régression ou une décision produit explicite.

---

# 12. Règle de lot

```text
1 objectif produit
+ périmètre court
+ source canonique citée
+ corrections dans la source autoritative
+ critères ciblés
+ aucun second document concurrent
```
