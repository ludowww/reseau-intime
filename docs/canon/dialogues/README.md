# Réseau Intime — Dialogues canoniques candidats

## Statut

Ce dossier contient les scripts narratifs complets à valider avant toute intégration runtime.

Ordre obligatoire :

```text
plan détaillé de journée
→ script narratif complet
→ audit de conformité
→ validation de Ludovic
→ audit voix et continuité
→ seulement ensuite adaptation JSON/runtime
```

## Autorité corrective

Le document :

```text
J01_J09_AUDIT_CONFORMITE_NARRATIVE.md
```

corrige les écarts identifiés dans J01–J09.

En cas de contradiction ciblée avec les scripts J07–J09, ses corrections prévalent jusqu’à consolidation future.

## Règles

- messagerie texte uniquement ;
- aucun appel joué ;
- aucun message vocal ;
- aucune scène audio ;
- aucun asset conçu ;
- aucune mécanique créée dans cette couche ;
- les événements physiques restent hors téléphone ;
- les voix suivent `13_BIBLE_VOIX_MESSAGERIE_ET_TESTS_DISTINCTION.md` ;
- toute promesse importante doit être un vrai choix ;
- toute journée prévoit trois contenus principalement centrés sur les femmes adultes principales ;
- toute scène principale précise sa séquence source ;
- une seule relation reçoit le pivot majeur ;
- un fallback existe si aucune continuité n’est légitime.

## Scripts

```text
J07_SCRIPT_NARRATIF_COMPLET.md
J08_SCRIPT_NARRATIF_COMPLET.md
J09_SCRIPT_NARRATIF_COMPLET.md
J10_SCRIPT_NARRATIF_COMPLET.md
J01_J09_AUDIT_CONFORMITE_NARRATIVE.md
```

Statut :

```text
J01–J05 — noyaux narratifs conformes, visuels à produire
J06 — intention narrative conforme, runtime actif non conforme
J07 — validé avec corrections d’agency et de visuels
J08 — validé avec fallback et corrections visuelles
J09 — candidat corrigé par l’audit
J10 — candidat à validation narrative
J11–J21 — à produire
```

## Continuité

```text
J07 crée ou ferme des attentes réelles.
J08 paie uniquement les attentes réellement actives.
J09 remet Marie au centre par sa visibilité sociale.
J10 donne une forme réelle à une seule continuité extérieure.
J11 continue uniquement la relation réellement vécue en J10 ou paie son refus.
```

## Règle de gel technique

Aucune nouvelle intégration J07–J21 ne doit commencer avant validation narrative complète de J07–J21.

La PR technique J05–J06 existante reste séparée et ne constitue pas une autorité sur les futurs scripts.