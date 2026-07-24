# Réseau Intime — NAR-PROD-01 — Audit de préparation à la production de la Saison 1

## Statut

**Catégorie : Audit de production actif — non autoritatif**

**Périmètre : Saison 1 J01–J21, actes, séquences, scènes, dialogues, traces, promesses, connaissances, conséquences et besoins visuels**

**Base auditée : `main` au commit `87b00e4832597a66dacb538f17d8331eedcfd61f`**

**Autorités : Bible Narrative, scripts consolidés J01–J21, registres, matrice d’atteignabilité et sign-off final**

Cet audit ne crée aucune nouvelle vérité narrative. Il classe l’état de préparation des matériaux existants et identifie les paquets encore nécessaires avant production visuelle ou adaptation runtime.

Il ne modifie :

- aucun dialogue ;
- aucune route ;
- aucun état relationnel ;
- aucun JSON ;
- aucun runtime ;
- aucun test ;
- aucun asset ;
- aucune interface.

---

# 1. Échelle de classement

## `READY`

Les sources canoniques permettent de produire le paquet narratif de la journée sans réécriture structurelle : fonction, séquence, variations, états, traces, promesses, connaissances et conséquences sont définis ou fermables.

## `TARGETED_CORRECTION`

Le noyau est valide, mais une correction documentaire localisée est nécessaire avant utilisation directe : statut obsolète, ancienne correction encore présentée comme ouverte, acceptation non synchronisée ou priorité documentaire ambiguë.

## `MISSING_SPEC`

La production concernée ne peut pas commencer sans une spécification nouvelle et bornée. Dans cet audit, ce statut concerne principalement les briefs visuels finaux : composition, sujet, type d’image, variantes, identifiant d’asset et contraintes de production.

## Axes séparés

Chaque journée reçoit deux verdicts :

```text
Narratif / scènes
Visuel / assets
```

Le runtime reste hors périmètre et gelé. Une journée peut donc être `READY` narrativement tout en restant `MISSING_SPEC` visuellement.

---

# 2. Sources relues

## Architecture et production

- `00_NORTH_STAR.md` ;
- `04_TRAME_PRINCIPALE_ET_ACTES_SAISON_1.md` ;
- `05_ROUTES_MACRO_SAISON_1.md` ;
- `06_EVOLUTION_EROTIQUE_DES_ROUTES.md` ;
- `07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md` ;
- `08_REGLES_DES_SCENES_MODULAIRES.md` ;
- `09_PROGRESSION_VISUELLE_ET_PHOTOGRAPHIQUE.md` ;
- `10_CARTE_CONSEQUENCES_DETTES_SECRETS_OBLIGATIONS.md` ;
- `11_DISTRIBUTION_SEQUENCES_SCENES_IMAGES_CONSEQUENCES_JOURNEES.md` ;
- plans `12`, `12B`, `12C`, `12D` et archive `12E`.

## Corpus et contrats

- source consolidée J01–J06 ;
- scripts complets J07–J21 ;
- audit global des dialogues ;
- lot A de corrections bloquantes ;
- registres des traces, promesses et connaissances ;
- contrat d’état narratif borné ;
- matrice d’atteignabilité J01–J21 ;
- sign-off final du corpus.

---

# 3. Verdict exécutif

```text
ARCHITECTURE SAISON 1 : READY
ACTES I–V : READY
CORPUS J01–J21 : READY
TRACES / PROMESSES / CONNAISSANCES : READY
ATTEIGNABILITÉ ET FERMETURES : READY
RÉÉCRITURE STRUCTURELLE : NON REQUISE
PRODUCTION VISUELLE FINALE : MISSING_SPEC
ADAPTATION RUNTIME : HORS PÉRIMÈTRE / GELÉE
```

Le sign-off final a absorbé les corrections des lots A–D. Les anciens blocages de calendrier, promesse Sandra, co-présence, posture finale, registres et voix ne doivent pas être réouverts comme problèmes actifs.

La Saison 1 est prête pour l’extraction de paquets de production narratifs. Elle n’est pas prête pour produire les assets finaux, car les documents canoniques définissent volontairement des fonctions visuelles et non des briefs de composition ou des prompts.

---

# 4. Verdict par acte

| Acte | Journées | Narratif | Visuel | Verdict |
|---|---:|---|---|---|
| I — La réouverture | J01–J04 | `READY` | `MISSING_SPEC` | ouverture signée ; briefs visuels à produire |
| II — Les lignes privées | J05–J08 | `READY` | `MISSING_SPEC` | obligations et continuités bornées ; assets à spécifier |
| III — Les vies parallèles | J09–J12 | `READY` | `MISSING_SPEC` | pivot extérieur unique, convergence et corrections intégrées |
| IV — La convergence | J13–J16 | `READY` | `MISSING_SPEC` | conséquences, connaissance et paiements définis |
| V — La vérité supportable | J17–J21 | `READY` | `MISSING_SPEC` | résolutions et finale atteignables ; variantes visuelles à produire |

Aucun acte ne nécessite une nouvelle route, un nouvel acte ou une nouvelle finale.

---

# 5. Matrice par journée

| Jour | Fonction | Narratif | Visuel | Motif principal |
|---|---|---|---|---|
| J01 | couple vivant + retour Sandra | `READY` | `MISSING_SPEC` | source consolidée, trace Sandra et promesse Marie définies ; deux briefs visuels supplémentaires à produire |
| J02 | arrivée Mathilde | `READY` | `MISSING_SPEC` | séjour, aide et connaissance sourcés ; `FACT_RECORD` à ne pas convertir automatiquement en photo |
| J03 | Raphaëlle travail + monde Marie | `READY` | `MISSING_SPEC` | ancienne restructuration absorbée par la source consolidée ; trois visuels exacts non définis |
| J04 | réseau social Pauline/Bastien + Nico | `READY` | `MISSING_SPEC` | origine du set public corrigée ; composition et participants exacts à briefer |
| J05 | heure réelle Marie + continuité possible | `READY` | `MISSING_SPEC` | pivot Marie et sélection de continuité bornés ; trois assets fonctionnels non conçus |
| J06 | continuité extérieure optionnelle + retour Marie | `READY` | `MISSING_SPEC` | candidate pool et propriétaire automatique retirés ; variantes visuelles à définir |
| J07 | confidence Nico + accès secondaire | `READY` | `MISSING_SPEC` | promesses conditionnelles et connaissance Nico structurées ; visuels à briefer |
| J08 | première superposition | `READY` | `MISSING_SPEC` | seules les attentes réellement créées sont lues ; visuels de choix, attente et retour à définir |
| J09 | visibilité sociale Marie | `READY` | `MISSING_SPEC` | séquence S15 et traces Marie définies ; préparation, événement et retour à produire |
| J10 | une ligne extérieure devient réelle | `READY` | `MISSING_SPEC` | un seul pivot parmi Sandra/Mathilde/Raphaëlle/Nico ; paquets visuels par variante absents |
| J11 | intention, limite, retrait ou adulte éligible | `READY` | `MISSING_SPEC` | scène adulte optionnelle et aftercare bornés ; versions standard et adulte à spécifier séparément |
| J12 | La Verrière puis L’Annexe | `READY` | `MISSING_SPEC` | préambule Sandra et text-only corrigés ; matrice exacte des participants et set social à produire |
| J13 | conséquence prioritaire | `READY` | `MISSING_SPEC` | sélection par urgence définie ; mapping trace réutilisée / nouvelle image de scène absent |
| J14 | trace au mauvais écran | `READY` | `MISSING_SPEC` | trace préexistante et connaissance sourcée ; représentation de la découverte et du retrait à briefer |
| J15 | engagements incompatibles | `READY` | `MISSING_SPEC` | promesses antérieures uniquement ; variantes visuelles selon obligation choisie absentes |
| J16 | paiement avant résolution | `READY` | `MISSING_SPEC` | aucune nouvelle route ; assets d’après-coup et vie ordinaire non conçus |
| J17 | départ Mathilde + définition du couple | `READY` | `MISSING_SPEC` | calendrier et co-présence corrigés ; branches foyer/couple nécessitent un paquet visuel borné |
| J18 | résolution Sandra | `READY` | `MISSING_SPEC` | états et permissions atteignables ; variantes de conservation, retrait et intimité tardive à produire |
| J19 | résolution Pauline / Raphaëlle | `READY` | `MISSING_SPEC` | un seul pivot développé ; deux familles visuelles et leurs fermetures doivent être spécifiées |
| J20 | résolution Nico / réseau | `READY` | `MISSING_SPEC` | position Nico bornée et consentement direct requis ; visuels du regard autorisé ou refusé à définir |
| J21 | trace finale recontextualisée | `READY` | `MISSING_SPEC` | sélection limitée aux traces enregistrées ; variantes présence/absence/retrait et état du foyer à briefer |

## Total

```text
Narratif READY : 21 / 21
Narratif TARGETED_CORRECTION : 0 / 21
Narratif MISSING_SPEC : 0 / 21
Visuel MISSING_SPEC : 21 / 21
```

---

# 6. Contrats structurés

## Traces

Le registre distingue correctement image de scène, trace diégétique, `FACT_RECORD`, audience, sauvegarde, transfert, retrait et éligibilité J14/J21.

Aucune future fiche visuelle ne doit transformer un `FACT_RECORD` en photographie sans source nouvelle validée.

## Promesses

Les propositions, acceptations, amendements, refus, expirations et paiements sont séparés. Les corrections du café Sandra et du point de couple post-J21 sont intégrées. J15 ne peut utiliser que des engagements créés antérieurement.

## Connaissances

Les faits, connaisseurs, sources, certitudes et règles de partage sont structurés. Une suppression de fichier ne supprime jamais la connaissance. Les personnages secondaires ne deviennent pas omniscients pour servir la convergence.

## Atteignabilité

Les états J17 rejoignent des sorties J21 cohérentes. Une route fermée ne se rouvre pas sans événement. Les scènes adultes exigent aftercare, et une séparation ou reconfiguration du couple n’ouvre aucune personne extérieure automatiquement.

---

# 7. Corrections documentaires ciblées

Ces corrections ne concernent pas le corpus signé. Elles concernent la lisibilité du dépôt.

## D1 — Plan J01–J08 encore écrit comme audit pré-consolidation

`12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md` conserve des diagnostics anciens : réécriture Sandra, relocalisations J03 et correction J04. La source consolidée J01–J06 et le sign-off ont absorbé ces décisions.

**Classement : `TARGETED_CORRECTION`.**

Action recommandée : ajouter un bandeau indiquant que les verdicts runtime historiques sont supersédés par la source consolidée et le sign-off, sans supprimer leur intérêt historique.

## D2 — Audit global des dialogues encore présenté comme candidat

`J01_J21_AUDIT_GLOBAL_DIALOGUES_CONTINUITE.md` conserve un verdict de reprise bloquée antérieur aux lots A–D.

**Classement : `TARGETED_CORRECTION`.**

Action recommandée : le marquer explicitement `HISTORICAL / SUPERSEDED`, avec renvoi vers les registres, la matrice d’atteignabilité et le sign-off.

## D3 — Lots correctifs encore lisibles comme autorités actives

Les lots A–D ont été consolidés physiquement dans les scripts et validés par le sign-off.

**Classement : `TARGETED_CORRECTION`.**

Action recommandée : harmoniser leurs en-têtes comme archives correctives, sans supprimer leur contenu de décision.

## D4 — Cases d’acceptation non synchronisées dans les plans 12A–12D

Les checklists restent visuellement non cochées alors que le corpus a été signé ensuite.

**Classement : `TARGETED_CORRECTION`.**

Action recommandée : ajouter une note commune indiquant que le sign-off final prévaut sur l’état historique des cases, plutôt que cocher rétroactivement chaque ligne sans preuve locale.

---

# 8. Spécification manquante principale

## `NAR-VIS-01 — Briefs de production visuelle Saison 1`

Les documents actuels définissent fonction narrative, personnage ou relation, nombre minimal, audience et permanence lorsque nécessaire, statut diégétique ou image de scène, intensité et contraintes de consentement.

Ils ne définissent volontairement pas :

- `asset_id` final ;
- image de scène ou photo diégétique pour chaque slot ;
- composition ;
- personnages visibles ;
- pose ;
- tenue précise ;
- décor précis ;
- cadrage ;
- lumière ;
- variantes de branche ;
- réutilisation autorisée ;
- prompt ou workflow ComfyUI ;
- résolution source ;
- sélection finale.

La production visuelle ne doit pas commencer directement depuis les scripts. Elle nécessite un paquet de briefs lié aux `trace_id`, aux audiences et aux variantes de scène.

---

# 9. Décisions produit encore nécessaires

## P1 — Budget visuel réel

Le canon demande au minimum trois contenus visuels par journée, soit un plancher théorique de 63 emplacements, avant variantes de branche et scènes adultes.

Décision requise :

```text
63+ assets uniques
ou
réutilisation/recontextualisation contrôlée
ou
production par vagues avec placeholders
```

La réutilisation n’est valide que si audience, signification, accessibilité ou fonction changent réellement.

## P2 — Granularité des variantes

J10, J11, J12, J13, J18, J19 et J21 possèdent plusieurs familles de branche.

Décision requise : produire une image commune avec variantes textuelles, plusieurs images de branche, ou un set commun plus un asset payoff conditionnel.

## P3 — Place des images de scène dans la Galerie

Le canon permet qu’une image de scène devienne souvenir joueur sans devenir fichier diégétique.

Décision requise : déterminer quelles images de scène apparaissent dans la Galerie, restent seulement dans la narration, possèdent un emplacement verrouillé ou sont exclues de toute circulation diégétique.

## P4 — Set social J12

La présence de Sandra, Mathilde et Raphaëlle dépend de conditions crédibles. Une seule composition universelle risquerait de contredire certaines parties.

Décision requise : set de base commun, compositions conditionnelles, ou vues séparées ne prétendant pas réunir tout le monde.

## P5 — Finale J21 et contenu retiré

Une trace retirée peut conclure par son absence, mais le prototype UI ne possède pas encore `REMOVED`.

Décision requise au moment de l’intégration : représentation narrative seule, emplacement inaccessible, ou futur état UI/runtime dédié. Cette décision ne bloque pas la production narrative actuelle.

---

# 10. Ordre de production recommandé

Ne pas produire les 21 journées en une seule vague.

## Lot suivant recommandé

```text
NAR-PROD-02 — Paquet de production Acte I / J01–J04
```

Contenu :

1. références exactes des dialogues signés ;
2. cartes de scènes finales ;
3. `trace_id`, promesses et connaissances ;
4. 3 à 6 briefs visuels par journée ;
5. distinction image de scène / trace diégétique ;
6. audience, permanence et réutilisation ;
7. variantes réellement nécessaires ;
8. aucun code, aucun asset produit et aucun runtime.

Après validation de l’Acte I :

```text
Acte II J05–J08
→ Acte III J09–J12
→ Acte IV J13–J16
→ Acte V J17–J21
```

Les scènes adultes et les résolutions à variantes nombreuses ne doivent être briefées qu’après validation de la méthode sur l’ouverture.

---

# 11. Doutes explicites

1. Le budget de 63 contenus visuels minimum peut être trop élevé si chaque emplacement devient un asset unique. Le canon n’oblige pas cette interprétation, mais le budget doit être décidé avant production.
2. J12 ne doit pas être illustré par une image de groupe contenant automatiquement tous les personnages principaux.
3. J18 et J19 peuvent remplacer une résolution standard par un payoff tardif ; les deux paquets visuels ne doivent pas être produits comme s’ils apparaissaient ensemble.
4. Une image de scène et une trace diégétique peuvent représenter le même moment, mais elles ne peuvent pas partager automatiquement identité, audience ou règles de diffusion.
5. Le statut final des anciennes checklists et audits est documentairement ambigu tant que les bandeaux de supersession ne sont pas ajoutés.

---

# 12. Verdict final

```text
SAISON 1 — NARRATION : READY
SAISON 1 — STRUCTURE : READY
SAISON 1 — ÉTATS ET ATTEIGNABILITÉ : READY
SAISON 1 — VISUELS FINAUX : MISSING_SPEC
SAISON 1 — RUNTIME : GELÉ / HORS PÉRIMÈTRE
PROCHAINE ACTION : NAR-PROD-02 ACTE I J01–J04
```

Aucune correction globale des dialogues ou de l’architecture n’est recommandée. Le prochain travail consiste à transformer l’Acte I signé en paquet de production exploitable, sans créer une nouvelle vérité narrative.