# Réseau Intime — 14 Contrat narratif réconcilié — Saison 1

## Statut

> **Candidat de réconciliation produit — READY_FOR_PRODUCT_REVIEW.**
>
> Ce document fixe les décisions à valider avant R8B/R8C. Il ne verrouille pas
> encore une architecture définitive et ne révoque pas silencieusement les scripts
> ou canons personnages existants.

## Résumé exécutif

La saison 1 demeure l'histoire de **Marie / Player**. Sandra, Mathilde, Pauline,
Raphaëlle et Nico ne remplacent pas l'histoire principale : leurs relations rendent
visibles désirs, besoins, limites et contradictions, puis influencent la décision
finale du couple.

Le corpus actuel apporte personnages autonomes, conséquences, traces, obligations,
scènes modulaires et une structure en cinq actes. La réconciliation requiert une
relation centrale distincte des routes, une séparation stricte entre contrat du
couple et divulgation, et une conversation finale Marie/Player obligatoire. La
recommandation est de préserver l'ossature actuelle en cinq mouvements, reformulée
par questions, transformations et sorties plutôt que par quotas de scènes.

## 1. Autorité et portée

### Hiérarchie d'autorité

1. Décisions produit signées et scripts canoniques signés.
2. Contrats et registres canoniques applicables.
3. Amendements validés.
4. Runtime verrouillé, constat d'implémentation.
5. Tests, preuve de comportement.
6. Documentation historique.

Un comportement testé peut être un bug : le runtime n'est jamais le canon par
défaut. Une fois validé et verrouillé, ce document devient la source canonique la
plus récente pour la structure de saison et la finale. Les fiches personnages
restent autoritatives pour leur voix, autonomie, désirs, limites et monde propre
tant qu'une adaptation ciblée n'est pas signée.

### Limites de ce lot

Ce lot ne modifie ni scripts, ni runtime, ni données, ni tests. Il ne crée aucune
permission rétroactive ni promesse de configuration entre personnages. Les écarts
identifiés sont des travaux futurs, pas des changements déjà appliqués.

## 2. Décisions produit réconciliées

### Centre dramatique et promesse joueur

Marie est le centre de gravité permanent, sans être un obstacle ou un jugement.
Elle conserve autonomie, désirs, explorations possibles et monde propre. Le jeu ne
devient pas un puzzle de mensonges ou de mémoire : les complications sont limitées,
au service de l'attachement et de l'exploration. Le système porte la mémoire et
restitue les conséquences ; le joueur reconnaît ce qui l'attire et ce qu'il veut
construire.

Il n'existe aucune symétrie forcée : Marie ne révèle que ce que son parcours a
produit. Désirs, fautes et explorations ne sont pas nécessairement équivalents.

### Personnages comme miroirs et ponts futurs

Chaque personnage éveille une forme distincte d'attachement, désir, intimité ou
fantasme, sans devenir une étiquette. Attirance émotionnelle et physique peuvent
concerner deux femmes différentes. Jeu de rôle, inversion ponctuelle, compétition,
tutorat, trio, domination/soumission et autres ponts sont seulement des
possibilités conditionnelles : relation crédible, motivation propre et consentement
actuel de chaque personne. Aucune matrice combinatoire exhaustive n'est promise.

### Nico

Dans la relation Player/Nico, `desir = NONE` : il n'existe aucune attirance
Player/Nico. Nico peut être garde-fou, confident, complice, rival, provocateur,
tiers NTR/sharing ou manipulateur. Il explore la place masculine de Player, la
jalousie, le regard partagé, la rivalité et la manipulation, avec conséquences.

### Scènes modulaires

Une scène modulaire peut être légère, relationnelle ou structurante et incarner un
événement obligatoire du tronc commun. Elle produit événements et conséquences,
mais ne possède pas d'état relationnel persistant : celui-ci appartient à
`EtatNarratif`, `EtatRelation` ou `EtatRelationCentrale`. Le consentement est local
à la scène, actuel, révocable et non persistant.

## 3. Contrat de finale Marie / Player

### Obligation de clôture

Toute partie complète se conclut par une conversation explicite Marie/Player,
après les résolutions de routes pertinentes. Une posture face à une trace, un état
de route ou un épilogue visuel ne peut la remplacer. Cette conversation produit une
décision réelle, même lorsque celle-ci reste difficile ou provisoire.

| Décision | Valeurs nécessaires | Règle |
|---|---|---|
| Rester ensemble | `contrat_couple = exclusif | ouvert | libertin` | Contrat explicite et actuel ; pas de permission générale envers des tiers. |
| Rester ensemble | `etat_divulgation = honnete | partiel | asymetrique | mensonger_compromis | revele` | La divulgation est séparée du contrat. |
| Se séparer | départ et logistique concrets | La sortie traite logement, objets, rendez-vous ou limites. |
| Se séparer | `relation_apres_separation = bons_termes | blessee | hostile | sans_contact` | La relation résiduelle est distincte de la rupture. |

Une double vie mensongère n'est jamais un contrat sain : elle relève de
`mensonger_compromis`, reste instable et porte des conséquences réelles.

La conversation finale doit partir des événements, connaissances, promesses,
traces et conséquences établis ; respecter ce que Marie sait réellement ; rendre
sa réponse autonome ; et établir l'état central de sortie. Elle ne doit ni absoudre
un mensonge rétroactivement, ni convertir un consentement passé en permission, ni
promettre un tiers.

## 4. Actes : comparaison et recommandation

### Architecture actuelle

| Mouvement | Valeur conservée | Risque à corriger |
|---|---|---|
| I — Réouverture | Installe couple, ordinaire et possibilité de désir. | Marie ne devient pas l'état initial à dépasser. |
| II — Lignes privées | Rend limites et liens distinctifs visibles. | La discrétion ne devient pas un mini-jeu de dissimulation. |
| III — Vies parallèles | Met des mondes et désirs divergents en tension. | Le retour au couple reste rythmé. |
| IV — Convergence | Fait collisionner conséquences, connaissances et obligations. | Aucune convergence identique n'est imposée à toutes les routes. |
| V — Vérité supportable | Porte clarification, réparation, perte et clôture. | La finale Marie/Player devient obligatoire. |

Cette structure est compatible avec R8A : elle distingue mouvements fixes et
contenu variable, et accepte l'autonomie des personnages hors champ.

### Architectures candidates

| Candidat | Forme | Avantages | Risques |
|---|---|---|---|
| A — Cinq mouvements réconciliés | Réouverture / lignes privées / vies parallèles / convergence / clarification | Préserve corpus, séquences et progression de conséquences. | Lourdeur si chaque mouvement devient un quota. |
| B — Quatre mouvements simplifiés | Attirance / exploration / limite / construction ou séparation | Lecture produit compacte. | Fusionne des tensions distinctes et demande un audit des séquences. |
| C — Trois macro-questions | Désir nommé / vérité à l'épreuve / décision commune | Très lisible conceptuellement. | Trop abstrait pour guider seul la production. |

**Recommandation : candidat A.** Les cinq mouvements sont conservés comme
structure souple ; l'Acte V devient fonctionnellement « clarification et décision ».
Le candidat B peut être audité comme vue de planification, sans réécrire la saison.

| Acte recommandé | Question dramatique | Transformation | Sortie narrative |
|---|---|---|---|
| I — Réouverture | Qu'est-ce qui manque ou se réveille dans le couple ? | Une possibilité réelle de désir ou changement est établie. | Événement de réouverture et retour de couple lisible. |
| II — Lignes privées | Que chacun garde-t-il, partage-t-il ou refuse-t-il ? | Limites et liens distinctifs reconnus. | Une ligne privée a conséquence et un recentrage couple a eu lieu. |
| III — Vies parallèles | Que révèle la coexistence de désirs ou mondes divergents ? | Contradiction, désir ou dette devient impossible à ignorer. | Événement significatif modifie confiance, foyer, connaissance ou engagement. |
| IV — Convergence | Quelles conséquences doivent être affrontées ? | Les faits cessent de pouvoir être évités. | Obligations majeures résolues, transformées ou assumées ; finale due. |
| V — Clarification | Que choisissent Marie et Player de construire ou terminer ? | Contrat explicite ou séparation organisée. | Conversation accomplie, état central final et conséquences de sortie établis. |

Un acte peut contenir trois ou quinze discussions. Il n'est jamais franchi par un
score ni un compteur. Chaque acte doit fournir une progression significative,
éviter la répétition infinie, inclure au moins un recentrage Marie/Player et faire
remonter les conséquences dues avant une opportunité de même nature.

## 5. Fiches synthétiques des sept personnages

| Personnage | Éveille | Peut construire | Impact couple | Rôle finale | Décision |
|---|---|---|---|---|---|
| Marie | Attachement fondateur, autonomie, réparation ou séparation. | Reconquête, contrat explicite, vie commune ou rupture digne. | Centre de gravité et co-décisionnaire. | Interlocutrice obligatoire. | KEEP, ADAPT finale. |
| Sandra | Retrouvailles, confiance d'image, tendresse, désir retenu. | Amitié, confidence, relation parallèle ou retrait. | Rend visible le prix du respect. | Conséquence, jamais arbitre. | KEEP / ADAPT raccord. |
| Mathilde | Proximité quotidienne, désir domestique, loyauté. | Loyauté, distance, route conditionnelle ou après-clarification. | Éprouve foyer, sécurité et vérité. | Ses faits nourrissent la discussion. | ADAPT ciblé. |
| Pauline | Compartiment, preuve, culpabilité, contrôle. | Arrêt, confession, secret à conséquences ou intégration conditionnelle. | Révèle le coût du mensonge. | Conséquence, pas alternative au couple. | ADAPT important. |
| Raphaëlle | Version choisie, cadre, rôle, clarté. | Confiance, désir lent, accord informé ou fermeture. | Exige une clarté non simulable. | Limite ou possibilité future conditionnelle. | KEEP / ADAPT raccord. |
| Nico | Miroir masculin, rivalité, regard partagé. | Amitié, garde-fou, rival, pacte conditionnel ou retrait. | Éclaire posture, alibi et jalousie de Player. | Témoin ou conséquence de réseau. | ADAPT : `desir = NONE`. |
| Player | Désir reconnu, responsabilité, présence. | Engagement, réparation limitée ou séparation assumée. | Sujet des choix, non collectionneur de routes. | Décide avec Marie sans contrôler sa réponse. | ADAPT. |

## 6. Matrice documentaire KEEP / ADAPT / REWRITE / ARCHIVE

| Document | Décision | Raccord futur requis |
|---|---|---|
| `00_NORTH_STAR.md` | ADAPT | Marie/Player reste le centre jusqu'à la décision finale. |
| `01_EXPERIENCE_JOUEUR.md` | ADAPT | Anti-puzzle de mensonges ; mémoire portée par système. |
| `02_FANTASMES_CENTRAUX.md` | ADAPT | Contrat sain, divulgation instable, ponts conditionnels. |
| `03_GRAMMAIRE_NARRATIVE.md` | KEEP | Formes de séquence conservées. |
| `04_TRAME_PRINCIPALE_ET_ACTES_SAISON_1.md` | REWRITE | Questions, transformations, sorties, finale obligatoire. |
| `05_ROUTES_MACRO_SAISON_1.md` | ADAPT | Bascules rattachées à la relation centrale sans supprimer autonomie. |
| `06_EVOLUTION_EROTIQUE_DES_ROUTES.md` | ADAPT | Consentement local et promesses de combinaison à vérifier. |
| `07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md` | ADAPT | Identifier recentrages et événements structurants sans quotas. |
| `08_REGLES_DES_SCENES_MODULAIRES.md` | ADAPT | Aligner écritures R8A ; scène de tronc commun possible. |
| `09_PROGRESSION_VISUELLE_ET_PHOTOGRAPHIQUE.md` | KEEP | Traces/audiences cohérentes ; raccord final ultérieur. |
| `10_CARTE_CONSEQUENCES_DETTES_SECRETS_OBLIGATIONS.md` | ADAPT | Double vie = divulgation, pas contrat. |
| `CHARACTER_CANON_INDEX.md` | ADAPT | Ajouter ce contrat seulement après verrouillage. |
| `MARIE_CANON_FULL.md` | KEEP | Préserver autonomie et centralité. |
| `SANDRA_CANON_FULL.md` | KEEP | Préserver différenciation et limites d'image. |
| `MATHILDE_CANON_FULL.md` | ADAPT | Raccorder foyer et routes après clarification/séparation. |
| `PAULINE_CANON_FULL.md` | ADAPT | Requalifier double vie, preuve et intégration. |
| `RAPHAELLE_CANON_FULL.md` | KEEP | Préserver cadre, version choisie et refus. |
| `NICO_CANON_FULL.md` | ADAPT | Expliciter Player/Nico : `desir = NONE`. |
| `PLAYER_CANON_FULL.md` | ADAPT | Construction choisie plutôt qu'optimisation de routes. |
| `NSFW_CHARACTER_ROUTE_CANON.md` | ADAPT | Ponts conditionnels, consentement actuel, pas de matrice exhaustive. |
| `J17_SCRIPT_NARRATIF_COMPLET.md` | REWRITE ciblé | Conversation provisoire, non finale de saison. |
| `J21_SCRIPT_NARRATIF_COMPLET.md` | REWRITE ciblé | Finale trace/posture à conclure par Marie/Player. |
| `SEASON_1_NARRATIVE_STATE_CONTRACT.md` | ADAPT | Raccorder relation centrale, contrat, divulgation, séparation à R8A. |
| `DOCUMENTATION_READING_ORDER.md` | ADAPT | Ajouter ce document après verrouillage. |
| `NARRATIVE_CANON_STATUS.md` | ADAPT | Corriger « aucun bloqueur » lors de la validation comme préalable R8B/R8C. |

**ARCHIVE : aucun document inspecté n'est à archiver immédiatement.** Une archive ne
peut suivre qu'une réécriture explicitement signée avec renvoi historique stable.

## 7. Écart J17 / J21

J17 contient une conversation Marie/Player substantielle et des sorties de
reconquête, accord provisoire, reconfiguration, double vie fragile et
fracture/séparation. C'est une clarification provisoire de milieu de parcours :
elle ne satisfait pas l'obligation de fin de partie complète.

J21 est aujourd'hui centré sur trace principale et postures finales (agir,
reconnaître une perte, maintenir une contradiction). Il reflète des états de couple
mais ne rend pas obligatoire une conversation finale clarifiant contrat ou
séparation. L'écart est réel. Une réécriture ciblée ultérieure doit garder J17 comme
clarification provisoire et faire de J21 l'accomplissement de la conversation
Marie/Player, après les modules de conséquence.

## 8. Impacts R8A / R8B / R8C

R8A reste applicable : le futur moteur exprimera `relation_centrale`, routes
qualitatives, événements, traces narratives, connaissances, consentement local,
scènes modulaires et finale obligatoire. `contrat_couple` et `etat_divulgation`
sont distincts ; un mensonge est un état instable, non un contrat sain.

R8B et R8C restent **non autorisés** avant signature de ce contrat et arbitrage des
points ouverts. Aucun modèle, reducer, JSON narratif, test ou migration ne peut
anticiper ces décisions comme si elles étaient acquises.

## 9. Décisions encore à arbitrer

1. Valider le candidat A ou auditer la piste B avant toute réécriture de trame.
2. Définir si un contrat final peut être explicitement temporaire, avec date et
   obligations de suivi, ou doit être stable à la clôture.
3. Valider la taxonomie et le vocabulaire joueur de contrat, divulgation et
   relation après séparation.
4. Choisir la granularité de J21 : module final unique ou journée restructurée.
5. Auditer chaque promesse implicite de pont futur : motivation, crédibilité,
   consentement actuel.
6. Arbitrer les raccords Pauline et Nico, les plus sensibles pour double vie,
   alibi, tiers et regard partagé.

## 10. Prochains lots recommandés

1. **R8A-C3 — Validation et verrouillage** : arbitrer les points ouverts et signer
   la structure ; modifier seulement les index/statuts indispensables.
2. **R8A-C4 — Réécriture canonique ciblée J17/J21** : écrire la finale obligatoire
   et ajuster la trame, sans runtime.
3. **R8B — Lecture seule de l'état réconcilié** : seulement après C3/C4 signés.

## Verdict documentaire

```text
READY_FOR_PRODUCT_REVIEW
```

La direction conserve la valeur du corpus existant et rend R8A cohérent, sans
devenir canonique définitive avant validation explicite.
