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
NAR‑PROD‑03 : paquet Acte II validé sur sa branche
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

# 6. Prochain lot recommandé

```text
NAR‑PROD‑04 — Paquet de production Acte III / J09–J12
```

Objectif : appliquer la méthode validée aux vies parallèles, avec une vigilance particulière sur :

- l’entrée J09 et la robe noire déplacée ;
- les premières dominantes relationnelles sans verrou prématuré ;
- les différences d’audience et de permanence ;
- les variantes réellement nécessaires J10–J12 ;
- le casting conditionnel de J12 ;
- la séparation stricte image de scène / photo diégétique / trace.

Ordre de production :

```text
Acte I J01–J04          READY
→ Acte II J05–J08       READY
→ Acte III J09–J12      NAR‑PROD‑04
→ Acte IV J13–J16
→ Acte V J17–J21
→ production des assets validés
→ adaptation runtime seulement lorsque nécessaire
```

---

# 7. Gel technique

Par défaut :

```text
UI       GELÉE
RUNTIME  GELÉ
ASSETS   NON PRODUITS
```

Une réouverture technique exige un besoin narratif bloquant, une donnée indispensable absente, une limite UI avérée, une régression ou une décision produit explicite.

---

# 8. Règle de lot

```text
1 objectif produit
+ périmètre court
+ source canonique citée
+ corrections dans la source autoritative
+ critères ciblés
+ aucun second document concurrent
```
