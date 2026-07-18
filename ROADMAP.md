# Réseau Intime — Roadmap active

## Statut

**Catégorie : Portail projet actif**

Cette roadmap résume l’ordre des lots.

Elle ne remplace pas les sources canoniques.

---

# 1. État acquis

## Narration — terminé

```text
North Star : validée
Personnages et voix : validés
Architecture Saison 1 : validée
Scripts J01–J21 : consolidés
Contrats de traces / promesses / connaissances : validés
Reachability : validée
Polish des voix : validé
Sign-off final : signé
```

Aucun nouveau travail narratif structurel n’est requis avant adaptation.

## Runtime — prototype historique disponible

Acquis utiles :

- Godot 4.6.x ;
- fils persistants ;
- choix ;
- chronologie ;
- notifications ;
- non-lus ;
- archives ;
- quelques journées et répétitions jouables ;
- tests statiques et outils de validation.

Limites :

- interface 1280 × 720 horizontale ;
- couches V0.xx partiellement incompatibles avec le corpus signé ;
- J07–J21 non intégrés conformément au canon ;
- sauvegarde et galerie à reprendre pour la cible finale.

---

# 2. Phase active — UI‑01

## Objectif

Créer une source UI canonique stable avant toute migration technique.

## Livrables

```text
docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md
docs/canon/ui/README.md
docs/canon/ui/UI_01_VERTICAL_SMARTPHONE_SYSTEM.md
docs/canon/ui/UI_02_SCREEN_ARCHITECTURE_AND_STATES.md
docs/canon/ui/UI_03_INTEGRATION_HANDOFF_AND_MOCKUP_STATUS.md
```

## Décisions

- portrait 720 × 1280 de référence ;
- 9:16 ;
- anime-inspired sombre ;
- couleurs par personnage ;
- Messages / Galerie au MVP ;
- galerie en grille avec onglets personnages ;
- écrans système séparés ;
- maquettes conceptuelles non considérées comme assets.

---

# 3. UI‑02 — Spécifications et maquettes finales

## Écrans déjà suffisamment orientés

- liste des conversations ;
- conversation individuelle ;
- conversation de groupe ;
- galerie par personnage.

## Écrans à finaliser

1. photo plein écran ;
2. transition hors téléphone ;
3. transition de journée ;
4. écran titre ;
5. menu pause ;
6. sauvegarde / chargement ;
7. paramètres ;
8. première configuration Player ;
9. modales de confirmation ;
10. états vides, erreur, verrouillé et texte agrandi.

## Critère de sortie

Chaque écran possède :

```text
fonction
données nécessaires
états
navigation
actions
priorité MVP
éléments différés
```

---

# 4. UI‑03 — Contrat d’intégration final

Objectifs :

- composants réutilisables ;
- mapping données → présentation ;
- persistance UI ;
- règles responsive ;
- plan de migration ;
- critères d’acceptation ;
- limites de branche.

Sortie :

```text
décision explicite de reprise technique
```

---

# 5. T‑UI‑01 — Migration portrait

## Périmètre recommandé

- `project.godot` portrait ;
- viewport de référence ;
- stretch et safe areas ;
- thème et tokens ;
- navigation Messages / Galerie ;
- composants démonstrateurs ;
- fausses données ou scène de test ;
- aucune migration massive de narration.

## Validation

```text
720 × 1280
1080 × 1920
1080 × 2340
fenêtre PC portrait
```

Le layout horizontal historique reste temporairement testable jusqu’à retrait explicite.

---

# 6. T‑UI‑02 — Écrans système et Galerie

- titre ;
- pause ;
- sauvegarde / chargement ;
- paramètres ;
- premières modales ;
- galerie à onglets personnages ;
- photo plein écran ;
- états verrouillé / nouveau / retiré.

Cette étape peut être divisée en plusieurs PR courtes.

---

# 7. T‑NAR‑01 — Réconciliation J01–J06

Objectifs :

- comparer données actives et sources signées ;
- retirer les concepts legacy incompatibles ;
- adapter les textes et choix ;
- intégrer les nouveaux contrats d’état minimaux ;
- conserver les conséquences et promesses ;
- tester l’ouverture en portrait.

La PR technique historique #54 reste non autoritative et doit être réauditée depuis `main` au moment de la reprise.

---

# 8. Intégration narrative progressive

```text
T‑NAR‑02  J07–J09
T‑NAR‑03  J10–J12
T‑NAR‑04  J13–J16
T‑NAR‑05  J17–J21
```

Chaque bloc doit :

- être jouable ;
- respecter les registres ;
- vérifier les promesses ;
- vérifier les connaissances ;
- vérifier text-only ;
- utiliser des placeholders visuels si nécessaire ;
- passer les tests avant le bloc suivant.

---

# 9. Production visuelle

Les images peuvent être produites parallèlement après validation de la charte et des personnages visuels.

Ordre recommandé :

```text
avatars cohérents
→ placeholders de galerie
→ images J01–J06
→ images par blocs narratifs
→ polish final
```

Les images ne doivent pas modifier :

- l’origine ;
- l’audience ;
- la permanence ;
- le consentement ;
- la fonction narrative.

---

# 10. Distribution et finition

Après J01–J21 jouables :

- QA complète ;
- sauvegardes et migrations ;
- accessibilité ;
- performances ;
- contrôles clavier / souris / tactile ;
- crédits ;
- avertissements ;
- packaging ;
- tests de reprise ;
- préparation des mises à jour narratives.

---

# 11. Différé

- onglet Profil sans fonction ;
- éditeur d’avatar complet ;
- thèmes multiples ;
- personnalisation du téléphone ;
- statistiques ;
- scores et routes visibles ;
- succès ;
- réseau social générique ;
- animations coûteuses non nécessaires au récit.

---

# 12. Règle de lot

```text
1 objectif produit
+ périmètre court
+ source canonique citée
+ tests ciblés
+ index synchronisés
```

Aucun lot ne doit mélanger par défaut :

```text
refonte UI globale
+ migration de quinze jours
+ nouveau système de sauvegarde
+ production d’assets
```
