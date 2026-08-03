# Réseau Intime — 14 Contrat narratif réconcilié — Saison 1

## Statut

> **PRODUCT_APPROVED_READY_FOR_LOCK.**
>
> Les arbitrages narratifs de saison sont approuvés. Ce document ne constitue pas
> à lui seul le verrouillage cumulé R8A-C1 + C2 + C3 et n'autorise donc ni R8B ni
> R8C avant ce verrouillage et la signature du contrat produit du moteur.

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
à la scène, actuel, révocable et non persistant. Elle ne crée aucune variable `jNN_*`.

## 3. Contrat de finale Marie / Player

### Obligation de clôture

Toute saison complète se conclut dans cet ordre : conséquences pertinentes des
routes, promesses, traces et obligations ; conversation finale Marie/Player
explicite et autonome ; décision du couple et organisation concrète ; puis courts
épilogues relationnels ou visuels compatibles. Ni posture face à une trace, ni état
de route, ni épilogue ne peut remplacer cette conversation ou contredire le contrat
final. Cette conversation produit une décision réelle, même difficile ou provisoire.

| Décision | Valeurs nécessaires | Règle |
|---|---|---|
| Statut | `statut_couple = ENSEMBLE | SEPARES | INDETERMINE/EN_CLARIFICATION` | Les états d'indétermination ne sont admis avant finale que si nécessaire. |
| Rester ensemble | `contrat_couple = EXCLUSIF | OUVERT | LIBERTIN | PROVISOIRE` | Contrat explicite et actuel ; pas de permission générale envers des tiers. |
| Rester ensemble | `etat_divulgation = HONNETE | PARTIEL | ASYMETRIQUE | MENSONGER_COMPROMIS | REVELE` | La divulgation est séparée du contrat. |
| Se séparer | départ et logistique concrets | La sortie traite logement, objets, rendez-vous ou limites. |
| Se séparer | `relation_apres_separation = BONS_TERMES | BLESSEE | HOSTILE | SANS_CONTACT` | La relation résiduelle est distincte de la rupture. |

Ces termes sont internes : l'interface et le dialogue emploient un vocabulaire
naturel. Une double vie mensongère n'est jamais un contrat sain : elle relève de
`MENSONGER_COMPROMIS`, reste instable et porte des conséquences réelles.

La conversation finale doit partir des événements, connaissances, promesses,
traces et conséquences établis ; respecter ce que Marie sait réellement ; rendre
sa réponse autonome ; et établir l'état central de sortie. Elle ne doit ni absoudre
un mensonge rétroactivement, ni convertir un consentement passé en permission, ni
promettre un tiers.

Un contrat final `PROVISOIRE` est une résolution de saison seulement s'il comporte
simultanément la règle actuelle, ses limites explicites, une date ou condition de
réévaluation, des obligations concrètes de suivi et aucune permission extérieure
implicite. Il ne vaut ni absence de décision ni report indéfini.

## 4. Actes approuvés : cinq mouvements souples

Les séquences et le corpus existants sont matière à adapter, jamais un ordre rigide.
Un acte ne se franchit ni par score, ni compteur, ni nombre fixe de scènes ou jours.

| Acte | Question dramatique | Transformation attendue | Événements structurants possibles | Sortie narrative | Garde-fous de rythme |
|---|---|---|---|---|---|
| I — Réouverture | Qu'est-ce qui se réveille dans la vie de Marie et Player ? | Désir, changement ou rapprochement devient reconnaissable dans le quotidien. | Retour de lien, promesse, invitation, friction intime, premier refus ou curiosité. | L'ouverture a un effet lisible et un recentrage Marie/Player a eu lieu. | Installer l'ordinaire avant l'intensité ; pas d'opportunités semblables immédiates. |
| II — Attirances | Pourquoi certaines personnes commencent-elles à compter autrement ? | Une attirance, un attachement ou une limite ne peut plus être réduit à une occasion. | Confidence, rendez-vous, proximité, limite, jalousie ou soutien révélateur. | L'attirance ou limite a une conséquence, située par un retour à Marie/Player. | Différencier personnages et émotions ; alterner découverte, respiration et recentrage. |
| III — Explorations | Qu'est-ce que Player et les autres souhaitent réellement vivre ? | Désirs, limites, accords ou incompatibilités deviennent précis et engageants. | Exploration consentie, retrait, accord local, contradiction, promesse ou dette. | Une exploration modifie ce qui est possible, dû ou difficile à dire. | Consentement actuel ; pas d'empilement ; conséquence avant intensification ; journées calmes. |
| IV — Limites et conséquences | Qu'est-ce qui ne peut plus être vécu sans être assumé ? | Les faits, limites, connaissances ou obligations exigent une réponse. | Limite non négociable, révélation située, conflit, réparation, retrait, promesse à honorer. | Les conséquences pertinentes sont résolues, transformées ou portées vers la finale. | Pas de collision identique imposée ; pas d'escalade mécanique ; temps d'intégration. |
| V — Clarification | Que choisissent Marie et Player de construire ou de terminer ? | Contrat, séparation organisée ou contrat provisoire complet. | Conséquences finales, conversation finale, organisation concrète, départ, réparation, épilogues compatibles. | L'ordre de fin est accompli et l'état final établi. | Pas de trace ou épilogue à la place de la conversation ; ni ambiguïté-report, ni contenu infini. |

## 5. Modèle temporel approuvé

J01–J21 sont des références du corpus et runtime historiques. Le futur moteur ne garantit ni vingt-et-un jours, ni une correspondance fixe jour/fonction dramatique. Les jours restent des contenants diégétiques pour horaires, rendez-vous, promesses, repos, absences et crédibilité ; une journée n'a pas nécessairement provider, outcome ni variables `jNN_*`.

Les actes ont une durée variable et peuvent contenir un nombre très différent de discussions selon le parcours. Le rythme doit éviter stagnation, répétition, progression trop rapide et contenu infini : chaque variation sert transformation, conséquence, respiration ou préparation de choix. Tout exemple numérique est non canonique.

## 6. Fiches synthétiques des sept personnages

| Personnage | Éveille | Peut construire | Impact couple | Rôle finale | Décision |
|---|---|---|---|---|---|
| Marie | Attachement fondateur, autonomie, réparation ou séparation. | Reconquête, contrat explicite, vie commune ou rupture digne. | Centre de gravité et co-décisionnaire. | Interlocutrice obligatoire. | KEEP, ADAPT finale. |
| Sandra | Retrouvailles, confiance d'image, tendresse, désir retenu. | Amitié, confidence, relation parallèle ou retrait. | Rend visible le prix du respect. | Conséquence, jamais arbitre. | KEEP / ADAPT raccord. |
| Mathilde | Proximité quotidienne, désir domestique, loyauté. | Loyauté, distance, route conditionnelle ou après-clarification. | Éprouve foyer, sécurité et vérité. | Ses faits nourrissent la discussion. | ADAPT ciblé. |
| Pauline | Compartiment, preuve, culpabilité, contrôle. | Arrêt, confession, secret à conséquences ou intégration conditionnelle. | Révèle le coût du mensonge. | Conséquence, pas alternative au couple. | ADAPT important. |
| Raphaëlle | Version choisie, cadre, rôle, clarté. | Confiance, désir lent, accord informé ou fermeture. | Exige une clarté non simulable. | Limite ou possibilité future conditionnelle. | KEEP / ADAPT raccord. |
| Nico | Miroir masculin, rivalité, regard partagé. | Amitié, garde-fou, rival, pacte conditionnel ou retrait. | Éclaire posture, alibi et jalousie de Player. | Témoin ou conséquence de réseau. | ADAPT : `desir = NONE`. |
| Player | Désir reconnu, responsabilité, présence. | Engagement, réparation limitée ou séparation assumée. | Sujet des choix, non collectionneur de routes. | Décide avec Marie sans contrôler sa réponse. | ADAPT. |

## 7. Matrice documentaire KEEP / ADAPT / REWRITE / ARCHIVE

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

## 8. Statut des séquences historiques J17 / J21

J17 contient une conversation Marie/Player substantielle et des sorties de
reconquête, accord provisoire, reconfiguration, double vie fragile et
fracture/séparation. C'est une source historique à réécrire comme séquence de
clarification intermédiaire tardive et provisoire : ni « milieu de parcours », ni
jour fixe, ni résolution de saison.

J21 est aujourd'hui centré sur trace principale et postures finales. Il devient une
source historique à réécrire ou adopter comme matière de la **séquence finale de
saison**, jamais une date obligatoire. Cette séquence accomplit la conversation
finale Marie/Player après les conséquences pertinentes, puis conduit à la décision
et aux épilogues compatibles.

## 9. Impacts R8A / R8B / R8C

R8A est applicable dans son principe : le futur moteur exprimera `relation_centrale`,
routes qualitatives, événements, traces, connaissances, consentement local, scènes
modulaires sans `jNN_*` et séquence finale de saison. `contrat_couple` et
`etat_divulgation` sont distincts ; un mensonge est un état instable, non un contrat.

R8B et R8C restent **non autorisés** avant verrouillage cumulé R8A-C1 + C2 + C3 et
signature du contrat produit moteur. Aucun modèle, reducer, JSON narratif, test,
migration, dialogue, asset ou code ne peut anticiper ces décisions comme acquises.

## 10. Décisions encore ouvertes

1. Granularité exacte des réécritures de la trame et des séquences historiques J17/J21.
2. Sélection des premiers ponts conditionnels à produire et de leurs raccords.
3. Détail de la taxonomie technique dans le futur contrat moteur.

## 11. Prochains lots recommandés

1. **Verrouillage cumulé R8A-C1 + C2 + C3** : enregistrer et signer la décision approuvée.
2. **Réécriture canonique ciblée** : adapter trame et séquences historiques J17/J21 en séquences non liées à des jours fixes, sans runtime.
3. **Contrat produit du nouveau moteur / R8B en lecture seule** : seulement après verrouillage et dans cet ordre recommandé.

## Verdict documentaire

```text
PRODUCT_APPROVED_READY_FOR_LOCK
```

L'architecture narrative est applicable dans son principe. R8B et R8C restent non
autorisés jusqu'au verrouillage cumulé et à la signature du contrat produit moteur.
