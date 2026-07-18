# Réseau Intime — Roadmap active

## Statut

**Catégorie : Portail projet actif**

Cette roadmap résume l’ordre des lots. Elle ne remplace pas les sources canoniques.

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

## UX/UI — cadré

```text
UI‑FOUNDATION : validé
UI‑SCREENS : validé
UI‑HANDOFF : validé
```

Acquis :

- portrait 720 × 1280 de référence ;
- ratio 9:16 ;
- style sombre anime-inspired ;
- couleurs par personnage ;
- navigation Messages / Galerie ;
- Galerie à onglets personnages ;
- écrans narratifs et système cadrés ;
- sauvegarde, paramètres et accessibilité cadrés ;
- composants et contrats de présentation définis ;
- critères de test portrait définis.

## Runtime — prototype historique disponible

Acquis potentiellement réutilisables :

- Godot 4.6.x ;
- fils persistants ;
- choix ;
- chronologie ;
- notifications ;
- non-lus ;
- archives ;
- tests statiques et outils de validation.

Limites :

- interface 1280 × 720 horizontale ;
- couches V0.xx partiellement incompatibles avec le corpus signé ;
- J07–J21 non intégrés conformément au canon ;
- sauvegarde et Galerie à reprendre pour la cible finale.

---

# 2. Décision active

```text
Reprise technique : prête mais non encore autorisée explicitement
```

Avant tout code :

1. Ludovic autorise explicitement le démarrage de `T‑UI‑01` ;
2. Hermes repart de `main` courant ;
3. Hermes rédige un plan court et borné ;
4. le plan est validé avant modification du runtime.

---

# 3. T‑UI‑01 — Coque portrait

## Objectif

Construire la fondation portrait sans migrer la narration.

## Périmètre recommandé

- `project.godot` portrait ;
- viewport de référence ;
- stretch et safe areas ;
- thème et tokens ;
- couches système / diégétique ;
- navigation Messages / Galerie ;
- composants démonstrateurs ;
- fausses données ou scène de test ;
- aucune migration massive de journées.

## Validation

```text
720 × 1280
1080 × 1920
1080 × 2340 environ
fenêtre PC portrait
texte agrandi
navigation clavier
animations réduites
```

Le layout horizontal historique reste temporairement testable jusqu’à retrait explicite.

---

# 4. T‑UI‑02 — Composants Messages

- liste des conversations ;
- cartes de fil ;
- bulles ;
- choix ;
- typing ;
- non-lus ;
- notifications ;
- transition hors téléphone ;
- transition de journée.

Une seule famille de composants ou un seul parcours peut être traité par PR.

---

# 5. T‑UI‑03 — Galerie et Photo

- onglets personnages ;
- grille ;
- tuiles ;
- photo plein écran ;
- provenance ;
- permissions sauvegarder / retirer / partager ;
- états verrouillé / nouveau / retiré.

Règle : retirer une image ne supprime jamais les messages ni la connaissance acquise.

---

# 6. T‑UI‑04 — Écrans système

- titre ;
- pause ;
- sauvegarde / chargement ;
- paramètres ;
- première configuration ;
- avertissement adulte ;
- confirmations ;
- erreurs et chargements.

La sauvegarde reste une branche explicitement testée, séparée des migrations narratives.

---

# 7. T‑NAR‑01 — Réconciliation J01–J06

Objectifs :

- comparer les données actives aux sources signées ;
- retirer les concepts legacy incompatibles ;
- adapter textes et choix ;
- intégrer les contrats d’état minimaux ;
- conserver conséquences, promesses, traces et connaissances ;
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
- vérifier promesses et connaissances ;
- respecter text-only et co-présence ;
- utiliser des placeholders visuels si nécessaire ;
- passer les tests avant le bloc suivant.

---

# 9. Production visuelle

Les images peuvent être produites parallèlement après validation de la charte des personnages visuels.

Ordre recommandé :

```text
avatars cohérents
→ placeholders de Galerie
→ images J01–J06
→ images par blocs narratifs
→ polish final
```

Les images ne modifient jamais l’origine, l’audience, la permanence, le consentement ou la fonction narrative.

---

# 10. Distribution et finition

Après J01–J21 jouables :

- QA complète ;
- migrations de sauvegarde ;
- accessibilité ;
- performances ;
- contrôles clavier / souris / tactile ;
- crédits ;
- avertissements ;
- packaging ;
- tests de reprise ;
- préparation des extensions narratives.

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
- animations coûteuses non nécessaires au récit ;
- fonctionnalités Android spécifiques.

---

# 12. Règle de lot

```text
1 objectif produit
+ périmètre court
+ source canonique citée
+ tests ciblés
+ index synchronisés
```

Aucun lot ne mélange par défaut :

```text
migration portrait
+ migration de nombreuses journées
+ nouveau système de sauvegarde
+ production d’assets
```
