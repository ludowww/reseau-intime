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
VISUELS FINAUX : 21 / 21 MISSING_SPEC avant extraction des paquets
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
26 nouveaux fichiers sources
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

# 8. Prochain lot recommandé

```text
NAR‑PROD‑05 — Finalisation du paquet Acte IV / J13–J16
```

Le paquet est désormais débloqué par NAR‑CANON‑01. La prochaine passe doit :

- aligner ses verdicts sur `FULL_COLLISION | NO_COLLISION` ;
- conserver les comptages validés ;
- corriger les métadonnées T17/T18 déjà arbitrées ;
- vérifier la reachability J14→J15 contre les sept promesses ;
- ne rouvrir aucun dialogue signé.

Comptages de travail à conserver :

```text
12 beats servis
10 nouveaux contenus principaux
12 réutilisations antérieures distinctes
11 nouveaux fichiers sources
1 fichier enfant
1 variante conditionnelle
```

Ordre de production :

```text
Acte I J01–J04          READY
→ Acte II J05–J08       READY
→ Acte III J09–J12      READY
→ NAR‑CANON‑01          READY
→ Acte IV J13–J16       NAR‑PROD‑05 finalisation
→ Acte V J17–J21
→ production des assets validés
→ adaptation runtime seulement lorsque nécessaire
```

---

# 9. Gel technique

Par défaut :

```text
UI       GELÉE
RUNTIME  GELÉ
ASSETS   NON PRODUITS
```

Une réouverture technique exige un besoin narratif bloquant, une donnée indispensable absente, une limite UI avérée, une régression ou une décision produit explicite.

---

# 10. Règle de lot

```text
1 objectif produit
+ périmètre court
+ source canonique citée
+ corrections dans la source autoritative
+ critères ciblés
+ aucun second document concurrent
```
