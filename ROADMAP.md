# Réseau Intime — roadmap active

> **Baseline de départ auditée pour R8C-A4 :** `4dda96f437d1e44658b7fc0748dca421ab98c0cc`

## Acquis

- contrat narratif R8A verrouillé;
- contrat produit et état qualitatif R8A-D1;
- vue lecture seule R8B;
- fondation transactionnelle R8C-A1;
- contrat de scène et micro-signaux R8C-A2;
- prototype synthétique minimal R8C-A3;
- consolidation canonique et suppression du legacy non chargé R8C-A4 validées
  sur la branche A4 dédiée.

## Ordre de travail

1. verrouiller R8C-A4 seulement après une gate globale verte;
2. concevoir R8C-A5 comme lot séparé de persistance;
3. au cutover, refuser/réinitialiser les snapshots de développement incompatibles
   au lieu de maintenir deux architectures;
4. remplacer progressivement l'oracle Season1 sans introduire un nouveau moteur
   de journée dans A4.

## Hors périmètre A4

- persistance R8C-A5;
- nouveau contenu narratif;
- nouveau constructeur ou planificateur de journée;
- migration longue des prototypes;
- refonte cosmétique générale;
- merge ou tag de verrouillage.
