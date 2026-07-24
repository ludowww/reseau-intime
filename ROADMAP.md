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
NAR‑PROD‑02 : paquet Acte I validé sur sa branche
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

Périmètre :

```text
Acte I — J01 à J04
```

Verdict :

```text
J01–J04 NARRATION : READY
J01–J04 BRIEFS VISUELS : READY
SOURCE DIALOGUE : READY
MISSING_SPEC : AUCUN
```

Budget verrouillé :

```text
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

Ce paquet ne produit aucun asset et n’autorise aucune modification runtime par lui seul.

---

# 5. Prochain lot recommandé

```text
NAR‑PROD‑03 — Paquet de production Acte II / J05–J08
```

Objectif : appliquer la même méthode validée à l’Acte II :

- références exactes des dialogues ;
- cartes de scènes finales ;
- traces, promesses et connaissances ;
- briefs visuels bornés ;
- distinction image de scène / photo diégétique ;
- audiences, permanence et réutilisations ;
- variantes strictement nécessaires ;
- aucune seconde carte de saison.

Ordre de production :

```text
Acte I J01–J04          READY
→ Acte II J05–J08       NAR‑PROD‑03
→ Acte III J09–J12
→ Acte IV J13–J16
→ Acte V J17–J21
→ production des assets validés
→ adaptation runtime seulement lorsque nécessaire
```

---

# 6. Gel technique

Par défaut :

```text
UI       GELÉE
RUNTIME  GELÉ
ASSETS   NON PRODUITS
```

Une réouverture technique exige un besoin narratif bloquant, une donnée indispensable absente, une limite UI avérée, une régression ou une décision produit explicite.

---

# 7. Règle de lot

```text
1 objectif produit
+ périmètre court
+ source canonique citée
+ corrections dans la source autoritative
+ critères ciblés
+ aucun second document concurrent
```
