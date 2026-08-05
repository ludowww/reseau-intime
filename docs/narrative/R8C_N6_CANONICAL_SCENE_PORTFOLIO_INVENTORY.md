# R8C-N6 — Inventaire canonique du portefeuille de scènes

> **Lot :** R8C-N6 — Audit global du portefeuille de scènes et de la couverture visuelle érotique
> **Baseline auditée :** `91af1f0795c9980d5220ae30fead67674da9cc37`
> **Tag :** `r8c-n5-sandra-blue-chairs-staged-season-projection` — tag annoté dont la cible déréférencée est la baseline ci-dessus
> **Statut :** audit documentaire, lecture seule sur le canon, le runtime et les assets
> **Architecture de lecture :** `arc → séquence → fonction → scène → dialogue → média`

## 1. Verdict exécutif

Le portefeuille de la première grande version jouable est narrativement complet, mais il ne faut pas confondre cette complétude avec la livraison visuelle ou l'activation de toutes les scènes canoniques.

| Mesure | Compte | Lecture correcte |
|---|---:|---|
| Arcs/mouvements de Saison 1 | 5 | Réouverture, attirances, explorations, limites/conséquences, clarification. |
| Séquences canoniques historiques `S01–S35` | 35 | Réservoir canonique à adapter par arc ; il ne fixe pas un moteur de 21 jours. |
| Positions de scène/fonction servies dans la projection J01–J21 | 66 | Unité d'audit de scène employée dans ce document. Certaines positions sont des alternatives ou des réutilisations. |
| Fichiers de conversation actifs | 46 | Unités techniques JSON ; un fichier peut porter plusieurs branches et plusieurs fonctions. |
| Points de choix authorés dans ces 46 fichiers | 172 | Catalogue de branches : 143 points décisionnels et 29 réponses guidées ; ce n'est pas un total par partie. |
| Contenus visuels principaux canoniques | 63 | Parents logiques ; un parent peut avoir variantes, frames ou enfants de séquence. |
| Fichiers visuels physiques spécifiés | 84 | 59 images de scène, 16 photos diégétiques, 9 frames de `PHOTO_SET`. |
| Scène canonique staged hors parcours | 1 | Sandra — **Les chaises bleues**. |
| Définitions A6/A11 de prototype ou test, hors canon de Saison 1 | 5 | Trois A6 synthétiques et deux exports A11. |
| Unités de scène inventoriées toutes couches | **72** | 66 canon projeté + 1 canon staged + 5 prototypes/candidates. |

La Saison 1 n'a besoin ni d'une nouvelle route, ni d'un nouvel acte, ni d'une nouvelle finale concurrente. Le besoin principal est de produire et livrer les 84 fichiers visuels déjà spécifiés, de réconcilier la finale avec le contrat R8C le plus récent, et de décider séparément si la scène staged doit être activée.

## 2. Méthode et unités de compte

### 2.1 Une scène n'est pas un fichier

L'audit retient comme **position de scène/fonction** le plus petit beat servi par les paquets `NAR-PROD-02` à `NAR-PROD-06`. Cette unité est plus stable qu'un fichier JSON :

- une conversation JSON peut contenir plusieurs branches mutuellement exclusives ;
- une scène physique hors téléphone peut n'avoir aucun fichier de conversation autonome ;
- un même média peut être réutilisé sans créer une nouvelle scène ;
- une séquence adulte peut regrouper trois images dans une seule scène vécue ;
- un `PHOTO_SET` compte comme un contenu principal même s'il exige plusieurs fichiers physiques.

Les 66 positions sont donc un inventaire de service éditorial, pas 66 scènes simultanément jouées. Les 46 JSON actifs et les 84 fichiers visuels sont reportés séparément.

### 2.2 Frontières documentaires

| Couche | Statut N6 | Règle d'utilisation |
|---|---|---|
| Canon signé J01–J21 et addenda adultes | `CANON` | Définit l'histoire, les dialogues, les limites et les payoffs. |
| Contrat narratif R8C réconcilié | `CANON` le plus récent pour structure/finale | Les actes sont souples ; les jours sont une projection ; J17/J21 demandent un raccord ciblé. |
| Paquets `NAR-PROD-02–06` et `ASSET-01` | `CANON DE PRODUCTION` | Autorité sur les 63 parents, 84 fichiers et budgets par acte. |
| Code, données et tests de la baseline | `ACTIVE_RUNTIME` | Autorité sur ce qui est réellement branché et jouable, jamais sur le sens canonique. |
| `r8c_n5_sandra_blue_chairs_staged.json` | `STAGED` | Canon narratif projeté techniquement, non indexé et hors joueur. |
| Bundles A6/A11 synthétiques | `CANDIDATE/PROTOTYPE` | Preuves d'outillage, pas des scènes de Saison 1. |
| `docs/V0_*`, anciens plans racine, `docs/story_state/` | `HISTORIQUE` | Provenance seulement, sauf renvoi actif explicite. |
| `docs/canon/bible/11_*` et plans `12*` | `CANON HISTORIQUE / PARTIELLEMENT CONTRADICTOIRE` | Utiles pour densité et fonctions ; les constats runtime obsolètes ne sont pas retenus. |

## 3. Sources importantes et statut

| Source | Statut retenu | Information utilisée |
|---|---|---|
| `docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md` | canon de gouvernance | Priorité canon/runtime/historique et frontières d'autorité. |
| `docs/canon/DOCUMENTATION_READING_ORDER.md` | portail actif | Ordre de reprise et primauté des scripts signés. |
| `docs/canon/bible/00_NORTH_STAR.md` | canon produit | Jeu adulte, relationnel, visual-first. |
| `docs/canon/bible/14_CONTRAT_NARRATIF_SAISON_1_RECONCILIE.md` | canon R8C le plus récent | Cinq mouvements souples ; Marie/Player au centre ; finale obligatoire ; jours non structurants. |
| `docs/canon/bible/07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md` | canon à adapter | Réservoir `S01–S35`, fonctions et différenciation des routes. |
| `docs/canon/bible/09_PROGRESSION_VISUELLE_ET_PHOTOGRAPHIQUE.md` | canon | Progression et garde-fous des images. |
| `docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md` | canon signé | Corpus complet, 24 promesses, 28 traces, 44 faits de branche. |
| `docs/canon/dialogues/J01_J06_SOURCE_CANON_CONSOLIDE.md` | canon signé | Fonction et source exacte de l'ouverture. |
| `docs/canon/dialogues/J07_SCRIPT_NARRATIF_COMPLET.md` à `J21_SCRIPT_NARRATIF_COMPLET.md` | canon signé/amendé | Dialogues, scènes physiques, choix, conséquences et payoffs. |
| `docs/canon/dialogues/NAR_ADULT_01_*`, `02_*`, `03_*` | addenda canoniques adultes | Payoffs Marie, Mathilde, Sandra, Pauline et Raphaëlle. |
| `docs/canon/dialogues/NAR_PROD_02_*` à `NAR_PROD_06_*` | canon de production | 66 beats servis, 63 parents, variantes et réutilisations. |
| `docs/canon/dialogues/ASSET_01_MANIFESTE_PRODUCTION_VISUELLE_SAISON_1_84_FICHIERS.md` | manifeste final | Une ligne par fichier physique ; 84 lignes. |
| `docs/canon/characters/*_CANON_FULL.md` | canon personnage | Fantasmes, limites, moteurs et conséquences. |
| `game/data/runtime/season_1/j01_runtime_map.json` à `j21_runtime_map.json` | runtime actif | Ordre, conversations, présentations Galerie et dettes visuelles. |
| `game/data/conversations/*.json` | runtime actif | 46 conversations, 1 425 messages authorés, 172 points de choix de catalogue. |
| `game/data/visual_content/*.json` | runtime/historique mixte | Placeholders, prototypes et preuves non finales. |
| `game/assets/visual_content/` | prototypes | 14 PNG de prototypes V0.95/V0.96, aucun asset final du manifeste. |
| `docs/narrative/R8C_N1_*` à `R8C_N5_*` | décisions bornées N1–N5 | Canon et projection staged de **Les chaises bleues**. |
| `game/data/narrative_scenes/*.json` | staged/prototypes | Six définitions hors chaîne Saison 1 active, dont une canonique staged. |

## 4. Architecture canonique par arc et séquence

Le tableau suivant inventorie les 35 séquences historiques comme matière de conception. Les affectations de mouvement sont éditoriales : le contrat R8C autorise leur recomposition et interdit d'en faire une grille de jours rigide.

| Arc/mouvement | Séquences | Fonction de portefeuille | Personnages dominants |
|---|---|---|---|
| I — Réouverture | S01 réseau, S02 La Verrière, S03 Sandra/photo, S04 Mathilde/foyer, S05 Pauline/social, S06 Raphaëlle/travail, S07 Nico/L'Annexe | Installer l'ordinaire, les personnes, les lieux et les premiers regards. | Marie, Sandra, Mathilde, Pauline, Raphaëlle, Nico. |
| II — Attirances | S08 avis Marie, S09 Sandra imprimée, S10 Mathilde/chargeur, S11 Pauline/cadrage privé, S12 Raphaëlle/compte, S13 confidence Nico, S14 superposition | Faire compter autrement une personne ou une limite sans sélectionner de route. | Marie + une ligne extérieure à la fois. |
| III — Explorations | S15 Marie visible, S16 café Sandra, S17 tenue Mathilde, S18 surface Pauline, S19 image Sandra, S20 retour Mathilde, S21 Raphaëlle/cadre, S22 regard Nico, S23 convergence | Transformer attirance en intention, cadre, retrait ou exploration consentie. | Toutes les routes, sous recentrage Marie/Player. |
| IV — Limites et conséquences | S24 versions Pauline, S25 masque Raphaëlle, S26 alibi/image Nico, S27 mauvais écran, S28 horaires incompatibles | Faire payer audiences, promesses, secrets et obligations avant toute nouvelle intensification. | Marie ou témoin légitime + route concernée. |
| V — Clarification | S29 conversation couple, S30 résolution Sandra, S31 départ Mathilde, S32 Pauline, S33 Raphaëlle, S34 Nico, S35 trace finale | Résoudre/transformer les routes, puis faire décider Marie et Player. | Marie/Player obligatoires ; autres personnages comme conséquences, jamais arbitres. |

Les graines `SX-MARIE`, `SX-SANDRA`, `SX-MATHILDE`, `SX-RAPHAËLLE`, `SX-PAULINE` et `SX-NICO` sont des hooks futurs, pas six scènes dues à la première version jouable.

## 5. Inventaire de service J01–J21

Les jours ci-dessous sont une projection de densité. La colonne « parents » compte le catalogue visuel, pas les médias simultanément affichés. J10, J11, J13 et J19 contiennent des alternatives mutuellement exclusives.

| Jour | Mouvement | Séquence/fonction projetée | Beats servis | JSON actifs | Parents visuels | Fichiers | Statut principal |
|---|---|---|---:|---:|---:|---:|---|
| J01 | I | S01/S03 — couple vivant, trace Sandra | 3 | 2 | 3 | 3 | canon + runtime ; couverture runtime incomplète |
| J02 | I | S04 — Mathilde modifie le foyer | 3 | 3 | 3 | 3 | canon + runtime ; Galerie placeholders |
| J03 | I | S06 + écho Sandra/Marie | 3 | 3 | 3 | 3 | canon + runtime ; Galerie placeholders |
| J04 | I | S05/S07 — réseau social, Nico, foyer | 4 | 4 | 4 | 6 | canon + runtime ; set de trois frames non livré |
| J05 | II | S08 + continuité Sandra/fallback | 3 | 2 | 2 | 2 | canon + runtime ; troisième beat par réutilisation |
| J06 | II | S10/fallback + retour Marie | 3 | 2 | 3 | 3 | canon + runtime ; placeholders |
| J07 | II | S13 — Nico pivot, Raphaëlle, foyer | 3 | 3 | 3 | 3 | canon + runtime ; placeholders |
| J08 | II | S14 — première superposition | 3 | 3 | 3 | 6 | canon + runtime ; trois variantes locales |
| J09 | III | S15 — Marie visible dans son monde | 4 | 1 | 4 | 4 | canon + runtime ; trois médias en conversation, non livrés |
| J10 | III | S16/S17/S21/S22 — une ligne réelle | 3 | 5 | 7 | 7 | canon + runtime ; alternatives, pas sept médias par partie |
| J11 | III | S19/S20/S21/S22 ou reconquête Marie | 3 | 6 | 6 | 12 | canon + runtime ; 2 parents Galerie, 6 enfants placeholders, dette explicite |
| J12 | III | S23 — convergence La Verrière/L'Annexe | 4 | 3 | 4 | 7 | canon + runtime ; quatre visuels fonctionnels en dette |
| J13 | IV | S24/S25/S26 — conséquence foreground | 3 | 1 | 2 | 3 | canon + runtime ; placeholders conventionnels |
| J14 | IV | S27 — découverte ou absence d'incident | 3 | 1 | 2 | 2 | canon + runtime texte ; aucune présentation Galerie |
| J15 | IV | S28 — obligations incompatibles | 3 | 1 | 4 | 4 | canon + runtime texte ; aucune présentation Galerie |
| J16 | IV | paiement, départ, handoff couple | 3 | 1 | 2 | 3 | canon + runtime texte ; aucune présentation Galerie |
| J17 | V | S31 puis S29 — départ et couple | 3 | 1 | 3 | 4 | canon + runtime texte ; raccord final R8C à prévoir |
| J18 | V | S30 — Sandra conserve, retire ou vit l'intimité | 3 | 1 | 2 | 5 | canon + runtime texte ; payoff visuel non livré |
| J19 | V | S32 ou S33 — Pauline/Raphaëlle | 3 | 1 | 2 | 3 | canon + runtime texte ; un foreground seulement |
| J20 | V | S34 — position Nico et réseau | 3 | 1 | 1 | 1 | canon + runtime texte ; deux beats par réutilisation |
| J21 | V | S35 — image antérieure recontextualisée | 3 | 1 | 0 nouveau | 0 nouveau | canon + runtime texte ; trois réutilisations à mettre en scène |
| **Total** |  |  | **66** | **46** | **63** | **84** |  |

## 6. Inventaire runtime des dialogues et choix

Le runtime contient 46 fichiers de conversation et 1 425 messages authorés. Le parcours n'affiche pas toutes les branches ; les comptes ci-dessous sont ceux du catalogue JSON.

| Mesure | Total | Interprétation |
|---|---:|---|
| Points de choix | 172 | Un tableau `choices` non vide compte pour un point. |
| Points décisionnels | 143 | Plusieurs options ou une réponse non marquée guidée. |
| Réponses guidées | 29 | Pacing/réception, sans prétendre à une décision stratégique. |
| Options écrites | 371 | Toutes alternatives cumulées. |
| Messages avec référence média | 24 | Occurrences, dont répétitions conditionnelles ; pas 24 assets livrés. |

### 6.1 Longues séquences passives à surveiller

| Fichier | Messages | Décisions | Guidées | Verdict |
|---|---:|---:|---:|---|
| `chapter_08_marie_household_and_j09_bridge.json` | 55 | 0 | 7 | Longue réception guidée ; tester le sentiment d'agence. |
| `chapter_08_nico_chair_resolution.json` | 31 | 0 | 2 | Résolution essentiellement passive, acceptable si le choix causal vient de J07. |
| `chapter_08_raphaelle_mobile_review_resolution.json` | 56 | 1 | 1 | Densité élevée pour un seul point propre. |
| `chapter_01_marie_opening.json` | 28 | 1 | 4 | Ouverture guidée ; surveiller la sensation de tutoriel prolongé. |
| `chapter_01_sandra_trace.json` | 23 | 1 | 4 | Le vrai choix est lisible, les autres réponses sont de réception. |
| `chapter_11_sandra_image.json` | 25 | 1 | 0 | Trois options dans un point unique ; réception présente, pas de second contrôle. |

Un choix est signalé comme **cosmétique potentiel** lorsqu'il ne porte dans son JSON ni mutation locale explicite ni conséquence différenciée vérifiable. Cette étiquette reste une alerte de QA : les providers peuvent interpréter l'identifiant ailleurs. Aucun quota de choix n'est recommandé.

## 7. Portefeuille par personnage

Les comptes de conversations et d'assets se chevauchent : une scène ou une image multi-personnages est attribuée à chaque personne concernée. Ils ne doivent donc pas être additionnés entre personnages.

| Personnage | Fichiers de conversation le mentionnant | Jours concernés | Fichiers visuels où le sujet est nommé | Rôle dramatique du portefeuille |
|---|---:|---|---:|---|
| Marie | 22 | J01–J17, puis J21 | 32 | Centre du couple, autonomie sociale, reconquête, limite et finale. |
| Sandra | 13 | J01, J03, J05, J10–J14, J18, J21 | 10 | Représentation choisie, confiance, désir retenu, intimité tardive ou retrait. |
| Mathilde | 13 | J02, J04, J06, J10–J17 | 16 | Proximité domestique, intention choisie, secret/limite, départ réel. |
| Pauline | 7 | J04, J12–J14, J19, J21 | 9 | Surface publique, compartiment, preuve et dette envers Bastien/Marie. |
| Raphaëlle | 11 | J03, J07–J14, J19, J21 | 11 | Travail, processus, version choisie, cadre et après-rôle. |
| Nico | 10 | J04, J07–J14, J20, J21 | 6 | Ami, garde-fou, rival, témoin, regard partagé ou complice ; aucun désir Player/Nico. |

## 8. Scènes staged, candidates et prototypes

| Définition | Couche | Fonction | Choix | Verdict N6 |
|---|---|---|---:|---|
| `sandra_blue_chairs_definition` | `STAGED`, canon N2/N3/N5 | Relation Sandra dans la séquence de réouverture | 1 point / 2 options | Canonique mais hors parcours. Asset causal absent et ponts d'activation non réalisés. |
| `r8c_a11_4_sandra_recontact_after_silence_definition` | prototype A11.4 | Écho Sandra | 2 | Test d'export, pas contenu Saison 1. |
| `r8c_a11_sandra_last_lunch_definition` | prototype A11 | Écho Sandra | 2 | Pilote d'atelier, pas contenu Saison 1. |
| `r8c_a6_distance_raphaelle_definition` | prototype A6 | Opportunité | 1 | Preuve synthétique uniquement. |
| `r8c_a6_distance_sandra_definition` | prototype A6 | Écho | 1 | Preuve synthétique uniquement. |
| `r8c_a6_signature_sandra_definition` | prototype A6 | Relation | 1 | Preuve synthétique uniquement. |

### 8.1 Les chaises bleues

- texte N2 : 96 éléments stockés, 89 ou 90 selon le parcours ;
- une décision à deux options, réceptions distinctes puis convergence ;
- média requis : `photo_sandra_cafe_blue_chairs` ;
- rôle média : `NARRATIVE_TRIGGER`, secondaire `RELATIONSHIP_PROOF` ;
- niveau visuel : V0 contexte ; Sandra ne doit pas être clairement visible ;
- Galerie : aucune entrée automatique ;
- projection runtime actuelle : J04 16:30–18:04, révisable et non identitaire ;
- état : `RUNTIME_PROJECTION_STAGED`, `ASSET_REQUIRED_NOT_READY` ;
- incompatibilité : la continuité Sandra J05 ne doit pas être proposée si N2 l'a été.

## 9. Inventaire média et assets

| Couche média | Existant | Manquant | Statut |
|---|---:|---:|---|
| Manifeste final Saison 1 | 84 spécifiés | 84 à produire/livrer | Aucun fichier final correspondant n'est livré. |
| Images de scène du manifeste | 59 spécifiées | 59 | Inclut les séquences adultes non diégétiques. |
| Photos diégétiques unitaires | 16 spécifiées | 16 | Audience, sauvegarde et retrait distincts. |
| Frames de `PHOTO_SET` | 9 spécifiées | 9 | Ne valent pas neuf contenus principaux. |
| Prototypes PNG V0.95/V0.96 | 14 physiques | — | 5 Marie, 4 Mathilde, 4 Sandra, 1 Pauline ; aucun Raphaëlle/Nico. Hors manifeste final et non référencés par les maps canoniques. |
| Placeholders/métadonnées legacy | 44 entrées hors fichier final, plus 19 placeholders système | fichiers physiques majoritairement absents | Historique ou fallback ; ne pas compter comme production livrée. |
| Asset **Les chaises bleues** | 0 | 1 | Hors des 84 ; requis seulement si l'activation staged est décidée. |

## 10. Contradictions conservées

| Contradiction | Décision conservatrice N6 |
|---|---|
| Les anciens documents annoncent parfois J05–J21 non jouables. | Le code, les 21 runtime maps et les tests de la baseline prouvent une chaîne J01–J21 active ; l'ancien constat reste historique. |
| Le plan historique impose « au moins trois contenus visuels par jour ». | La cible est auditée comme couverture, jamais comme quota de création. Les paquets récents servent 66 beats avec réutilisations et alternatives. |
| `J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md` annonce aucun bloqueur narratif, tandis que le contrat R8C demande un raccord J17/J21. | Le corpus reste signé ; deux adaptations ciblées de structure/finale sont à prévoir sans rouvrir toute la saison. |
| Les 14 PNG prototypes peuvent sembler être des assets existants. | Ils sont comptés comme prototypes physiques, jamais comme l'un des 84 livrables finaux. |
| J10 contient sept parents et J11 douze fichiers. | Ce sont des catalogues alternatifs ; la partie sert trois beats. Aucun diagnostic de surcharge joueur ne repose sur le catalogue brut. |
| J21 a zéro nouveau fichier. | Choix volontaire : la finale doit recontextualiser trois contenus existants. Le manque actuel porte sur la mise en scène runtime, pas sur un besoin automatique de nouvelles images. |

## 11. Conclusion d'inventaire

Le portefeuille contient **72 unités inventoriées** toutes couches : 66 positions canoniques projetées, une scène canonique staged et cinq prototypes/candidates. Le nombre de scènes canoniques nécessaires à la Saison 1 n'est pas un manque : le canon principal est complet. Les écarts restants sont la livraison de 84 fichiers visuels, la matérialisation des recontextualisations tardives, deux raccords ciblés de finale, la QA de l'agence sur les longues séquences et, séparément, la décision d'activer ou non **Les chaises bleues**.
