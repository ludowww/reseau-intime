# R8A-D1 — Contrat produit du nouveau moteur narratif

> **Statut : `PRODUCT_APPROVED_READY_FOR_LOCK`**
> Corrections D1-C1 intégrées. Le contrat n'est canonique qu'après verrouillage explicite ; R8B et R8C restent non autorisés jusque-là.

## 1. Autorité, portée et vocabulaire

Ce document traduit le canon R8A verrouillé en capacités de produit. Il ne définit ni classes Godot, ni `Resource`, ni `Dictionary`, ni JSON, ni migration exécutable. La hiérarchie d'autorité est :

1. `14_CONTRAT_NARRATIF_SAISON_1_RECONCILIE.md` — contrat narratif R8A verrouillé ;
2. `R8A_ROUTE_STATE_SIMPLIFICATION_BLUEPRINT.md` — blueprint d'état et invariants R8A ;
3. les bibles, registres et canons personnages cités dans la documentation reading order ;
4. le présent contrat, qui ne peut contredire les niveaux précédents.

Le runtime actuel est un **oracle fonctionnel temporaire** : il renseigne les comportements et corpus existants, mais n'est pas la source du modèle futur et ne crée aucune contrainte de compatibilité. R8B et R8C restent non autorisés jusqu'à validation puis verrouillage de D1.

Les identifiants conceptuels sont français, sans accents, avec `snake_case` recommandé. Les noms de réalisation pourront varier si leur sémantique reste identique. Les termes de référence sont `EtatNarratif`, `EtatRelationCentrale`, `EtatRelation`, `RegistreEvenements`, `RegistrePromesses`, `RegistreObligations`, `RegistreTracesNarratives`, `RegistreConnaissances`, `MoteurReglesScene`, `ReducerRelation`, `ContexteScene`, `ProgressionSaison` et `LivraisonMedias`.

## 2. Etat narratif persistant

`EtatNarratif` est la source de vérité persistante de la saison. Sa structure minimale de produit est :

| Bloc | Responsabilité et frontière |
| --- | --- |
| `progression_saison` | Acte, pivots accomplis et sortie ; jamais une horloge de 21 jours. |
| `relation_centrale` | Vérité courante Marie/Player et son contrat explicite. |
| `relations[personnage_id]` | Vérité relationnelle qualitative avec chaque personnage ; pas de matrice universelle. |
| `evenements` | Historique immuable des faits narratifs produits. |
| `promesses` | Engagements acceptés et leur cycle de vie. |
| `obligations` | Conséquences dues, y compris hors promesse. |
| `traces_narratives` | Objets, contenus ou enregistrements dont circulation et accès comptent. |
| `connaissances` | Ce que chaque personne sait, et par quelle source. |
| `livraison_medias` | Etat technique et opérationnel de disponibilité et de remise des médias ; il n'établit ni contrôle narratif, ni droit d'accès, ni connaissance. |

Les registres et états courants ci-dessus sont persistants. Les vues suivantes sont calculées ou reconstructibles : `scenes_candidates`, `medias_disponibles`, `promesses_actives_ids`, `obligations_actives_ids`, `traces_visibles_ids`, `resume_relation`, `preference_joueur_calculee`, `peut_progresser`, `acte_pret_a_sortir` et `finale_eligible`. Elles ne sont pas des sources de vérité ; un cache est admissible seulement s'il est explicitement invalidable et reconstructible.

## 3. Etats relationnels

### 3.1 `EtatRelationCentrale` — Marie/Player

Champs minimaux : `statut_couple`, `contrat_couple`, `etat_divulgation`, `etat_foyer`, `relation_apres_separation`, `dernier_evenement_majeur_id` et `faits`. `contrat_couple` et `relation_apres_separation` sont conditionnels : ils sont optionnels ou `null` quand ils ne s'appliquent pas. La nullabilité porte le non-applicable ; aucune valeur de taxonomie `AUCUN` ou `NON_APPLICABLE` n'est ajoutée.

Taxonomies bornées :

- `statut_couple` : `ENSEMBLE`, `SEPARES`, `EN_CLARIFICATION` ;
- `contrat_couple` : `EXCLUSIF`, `OUVERT`, `LIBERTIN`, `PROVISOIRE` ;
- `etat_divulgation` : `HONNETE`, `PARTIEL`, `ASYMETRIQUE`, `MENSONGER_COMPROMIS`, `REVELE` ;
- `relation_apres_separation` : `BONS_TERMES`, `BLESSEE`, `HOSTILE`, `SANS_CONTACT`.

Invariants :

- `statut_couple = ENSEMBLE` impose un `contrat_couple` obligatoire et une `relation_apres_separation` absente ; aucune valeur de séparation n'est portée par un couple encore ensemble.
- `statut_couple = SEPARES` impose un `contrat_couple` absent et une `relation_apres_separation` obligatoire ; aucun fallback artificiel `EXCLUSIF` ne peut représenter un couple séparé.
- `statut_couple = EN_CLARIFICATION` peut conserver le dernier `contrat_couple` encore actif, ou ne porter aucun contrat lorsque l'ancien a explicitement cessé ; chaque cas est sourcé par un événement.
- Un mensonge n'est jamais un contrat ; `contrat_couple` ne devient effectif que par événement de contrat accepté et sourcé. `PROVISOIRE` exige une règle, des limites, une échéance ou condition de réévaluation, et des obligations concrètes.
- La divulgation décrit ce qui a été partagé, non l'accord ; aucune combinaison ne peut transformer automatiquement une divulgation partielle ou mensongère en accord.

### 3.2 `EtatRelation` — personnage

Chaque relation comporte au moins `personnage_id`, `etat_arc`, `statut_relation`, `confiance`, `desir`, `intimite`, `secret`, `dernier_evenement_majeur_id` et `faits`. Les valeurs sont des taxonomies qualitatives déjà validées par R8A, avec transitions bornées par personnage ; elles ne sont ni des scores ni des compteurs. Pour Nico/Player, `desir = NONE`. Il n'existe aucun `route_points`, score relationnel numérique ou `consent_score`.

Les liens entre personnes ne forment pas une matrice complète. Un état interpersonnel, fait ou événement n'est créé que pour une continuité durable utile. Une scène multi-personnages et ses conséquences croisées sont supportées, mais tout pont futur exige relation crédible, motivations propres et consentement actuel.

### 3.3 Nico

Nico est une route d'influence masculine sans désir romantique ou sexuel Player/Nico. Selon les événements, il peut devenir garde-fou, confident, complice, rival, provocateur, tiers NTR/sharing ou manipulateur ; aucun de ces rôles n'est imposé par défaut, et chacun entraîne des conséquences réelles.

## 4. Evénements, traces et connaissances

### 4.1 `RegistreEvenements`

Un événement est immuable, typé, sourcé et daté diégétiquement lorsque cela est utile. Il contient conceptuellement : identifiant, type, acteurs, sujets, `source_scene_id`, `choix_source_id`, données minimales et repère diégétique. Il couvre notamment choix, conversation, rapprochement, refus, retrait, découverte, réparation, contrat et séparation.

L'événement historique n'est pas une conclusion dérivée : celle-ci est une vue ou une transition explicitement produite à partir de l'historique. Un pivot ne doit jamais être recalculé depuis un état ultérieur. Les identifiants, l'unicité de provenance et une stratégie future d'idempotence empêchent duplication et replay ; aucun replay ne peut redoubler ses conséquences.

### 4.2 `RegistreTracesNarratives`

Une trace narrative est un contenu, objet ou enregistrement persistant dont l'existence, le contrôle, l'audience, la conservation, la circulation, l'accessibilité ou la suppression peuvent avoir des conséquences. Son contrat minimal est : `trace_id`, `type_trace`, `origine`, `createur`, `controleur`, `sujets`, `audience_actuelle`, `regle_sauvegarde`, `regle_transfert`, `etat_acces`, `permanence`, `source_evenement_id`, `derives_de` et `faits_associes`.

Un événement enregistre qu'un fait a eu lieu ; une trace est le support persistant qui peut circuler ; une connaissance est l'état sourcé d'une personne qui sait un fait. Toutes les actions ne créent pas une trace. La suppression d'une trace ne restaure jamais son contenu : elle peut laisser une connaissance, une copie, une absence significative ou une obligation, sans réapparition magique.

`RegistreTracesNarratives` est l'autorité narrative exclusive pour l'existence d'une trace, son contrôleur, son audience, son accessibilité, sa sauvegarde, son transfert, sa permanence et sa suppression ou son retrait. Ces droits et états sont établis par trace, contexte et règles narratives, puis persistent dans ce registre.

### 4.3 `RegistreConnaissances`

Une connaissance est sourcée par personne et comprend au minimum `fait_id`, `connaisseurs_actuels`, `source_type`, `source_ref`, `certitude`, `contexte_certitude`, `partageabilite` et date ou `source_scene`. Il n'y a aucune omniscience automatique : l'audience d'une trace ne vaut ni connaissance certaine de son contenu, ni autorisation de partage. Une connaissance partielle, erronée ou contextuelle reste distinguée du fait établi.

## 5. Promesses, obligations et médias

Une promesse est un engagement accepté avec échéance ou condition. Une obligation est une conséquence due ou action nécessaire, qui peut venir d'une promesse, d'un contrat, d'une règle de sécurité ou d'un événement. Elles ont des cycles de vie bornés (créée/active, remplie, transformée, expirée, annulée de façon sourcée lorsque compatible), une échéance diégétique concrète ou une condition explicite.

Elles ne dupliquent pas de scalaire dans `EtatRelation`. Les collisions se résolvent par priorité narrative : sécurité et consentement, conséquence à échéance dure, contrat explicite, réparation/clarification, puis logistique et respiration. Elles ne deviennent jamais un mini-jeu de gestion de dettes.

`LivraisonMedias` est exclusivement technique et opérationnel : média prêt ou non prêt, média servi ou non servi, moment de présentation, surface ou canal de livraison, variante technique livrée, erreur, attente ou retry de livraison. Une livraison réussie exécute un droit déjà établi par la trace, les contextes et les règles ; elle ne crée jamais de droit d'accès, d'audience, de connaissance, de sauvegarde ou de transfert, et ne contrôle pas narrativement le média.

## 6. `ContexteScene`, consentement et scènes modulaires

`ContexteScene` est temporaire : `scene_id`, `sequence_id`, `acte`, `moment_diegetique`, `lieu`, `participants`, `personnes_physiquement_presentes`, `faits_temporaires`, `consentement_actuel`, `limites_actives` et médias disponibles pour la scène. Il n'entre pas intégralement dans l'état persistant ; seuls les événements et conséquences effectivement produits y entrent.

Le consentement est exclusivement local : `NON_DEMANDE`, `INCERTAIN`, `CONFIRME`, `REFUSE`, `RETIRE`. Il n'est jamais une permission persistante : désir, confiance ou intimité antérieure ne valent jamais consentement actuel. Refus et retrait déclenchent des sorties respectueuses et ne sont pas artificiellement punis.

Le contrat d'une scène modulaire contient : identifiant et séquence source ; rôle `TRONC_COMMUN`, `VARIANTE_TRONC_COMMUN`, `RELATION`, `CONSEQUENCE` ou `AMBIANCE` ; éligibilité ; exclusions ; participants ; contexte temporel ; événements potentiels ; traces, connaissances, promesses et obligations possibles ; sorties et conséquences ; règle d'expiration ou mutation. Une scène peut être structurante. Elle ne modifie jamais directement `EtatRelation` ni `EtatRelationCentrale`, et aucune clé `jNN_*` ne peut appartenir au futur moteur. La reprise technique d'une scène est distincte de la vérité narrative.

## 7. Services conceptuels

`MoteurReglesScene` lit état, historique et registres pour calculer les scènes éligibles. Il applique priorités narratives, conséquences dues, respirations et recentrages Marie/Player. Il évite répétition, stagnation, escalade trop rapide et contenu infini. Il ne crée pas de vérité persistante et ne propose pas une route comme un menu. Chaque proposition peut porter des raisons de debug, non exposées techniquement au joueur.

`ReducerRelation` est le seul composant autorisé à modifier les états relationnels et central. Il valide les transitions contre les combinaisons autorisées, rejette explicitement une incohérence et peut préparer plusieurs relations pour un événement multi-personnages. Provider, scène et UI ne mutent rien directement. L'idempotence et la protection de replay sont requises au futur design technique.

Le traitement d'un événement candidat est une transaction narrative atomique, exposée publiquement par `traiter_evenement(evenement)`. Elle doit, dans une même opération logique :

1. recevoir l'événement candidat ;
2. vérifier sa provenance, son unicité et son idempotence ;
3. valider toutes les transitions et les mutations de registres ;
4. préparer les mutations de `EtatRelationCentrale`, d'une ou plusieurs `EtatRelation`, des promesses, obligations, traces narratives, connaissances et de `progression_saison` ;
5. appliquer l'ensemble ;
6. enregistrer l'événement comme accompli uniquement si toutes les mutations sont valides ;
7. invalider ou recalculer les vues calculées après succès.

En cas d'échec, aucune mutation partielle n'est conservée, aucun événement n'est partiellement enregistré et aucune vue n'est considérée valide. `enregistrer_evenement(evenement)` et `appliquer_evenement(evenement)` peuvent exister comme opérations internes conceptuelles, mais ne sont pas des points d'entrée publics indépendants : une scène, un provider ou l'UI ne peuvent jamais les appeler séparément.

API produit indicative, non définitive et sans engagement sur les signatures Godot :

```text
obtenir_resume_relation(personnage_id)
obtenir_resume_relation_centrale()
traiter_evenement(evenement)
obtenir_scenes_eligibles(contexte)
creer_contexte_scene(scene_id)
obtenir_connaissances(personnage_id)
obtenir_traces_visibles(personnage_id)
verifier_sortie_acte()
construire_sequence_finale()
```

## 8. Saison, journées et préférences

`ProgressionSaison` contient `acte_courant`, événements structurants accomplis, conditions de sortie, obligations de recentrage et historique des transitions. Les cinq mouvements verrouillés sont : `REOUVERTURE`, `ATTIRANCES`, `EXPLORATIONS`, `LIMITES_ET_CONSEQUENCES`, `CLARIFICATION`.

Les jours restent des contenants diégétiques pour horaires, rendez-vous, absences et repos, sans nombre fixe de jours ni de scènes. Une journée peut accueillir scènes structurantes, relationnelles, conséquences, respirations, messages courts ou aucun contenu important. Aucun provider obligatoire par journée : l'orchestration gère disponibilité, horaires, promesses, repos, absences et densité. J01–J21 est un corpus historique seulement.

La sortie d'un acte est narrative : pivots pertinents traités, conséquences suffisamment portées et prochaine question dramatiquement préparée. Des garde-fous de rythme peuvent imposer recentrage ou conséquence si un acte stagne, sans inventer de conclusion, score ni quota fixe.

`preference_joueur_calculee` se déduit des événements et choix : ce que le joueur encourage, recherche, refuse, contient ou explore. L'attirance émotionnelle et physique peuvent diverger. Cette vue ouvre des scènes sans fermer automatiquement les autres, sans profil psychologique définitif, ni score persistant de domination, NTR, trio ou analogue. Le joueur peut changer d'avis.

## 9. Finale de saison

La séquence finale obligatoire est : conséquences pertinentes, conversation finale Marie/Player, décision de couple ou séparation, organisation concrète, puis épilogues compatibles. Elle n'est liée à aucun numéro de jour.

Elle est éligible seulement si les conséquences majeures pertinentes sont résolues, transformées ou consciemment portées ; Marie ne sait que ce qui est sourcé ; aucune symétrie n'est forcée ; le dernier choix ne réécrit pas toute la saison ; un contrat final ou une séparation est réellement établi ; et les épilogues ne contredisent pas cette décision.

## 10. Sauvegarde, reprise et reconstruction

Le nouveau format peut être incompatible avec v1–v25. Il n'y a ni double architecture permanente ni double écriture longue. La sauvegarde sépare l'état narratif persistant de la reprise technique de scènes, providers et UI. Les garanties produit portent sur la conservation de la vérité persistante, l'impossibilité de rétablir un contenu supprimé et la reconstruction des vues ; le format de sérialisation est ouvert.

La reconstruction est découpée par fondation commune, Actes I–II / ancien J01–J09, pivot / ancien J10–J13, découverte et conséquences / ancien J14–J16, puis résolutions / ancien J17–J21. Pauline est pilote conceptuel, Mathilde validation critique ; la migration n'est pas strictement personnage par personnage. La comparaison à l'ancien runtime se fait comme oracle de comportement, jamais comme compatibilité de snapshot.

## 11. Observabilité produit

Le debug doit exposer, sans obligation d'écran joueur : résumé de relation centrale et des six relations ; derniers événements majeurs ; promesses et obligations actives ; traces et audiences ; connaissances par personnage ; acte courant et raisons de sortie/non-sortie ; scènes candidates et raisons d'éligibilité/exclusion.

## 12. Invariants transversaux

- Aucun score relationnel numérique, `route_points` ou `consent_score`.
- Aucun consentement persistant.
- Aucun mensonge comme contrat.
- Aucune mutation directe des états par scène, provider ou UI.
- Aucune omniscience, ni audience déduite d'une relation.
- Aucun contenu supprimé restauré.
- Aucun événement historique recalculé depuis le présent.
- Aucune route adulte débloquée par score seul.
- Refus et retrait respectueux non punis artificiellement.
- Aucun `jNN_*` dans le futur moteur et aucune dépendance à 21 jours fixes.
- Finale Marie/Player obligatoire.

## 13. Critères d'acceptation du futur moteur

- Une scène modulaire multi-personnages produit des événements atomiques et conséquences croisées valides.
- Un consentement retiré arrête la voie concernée sans permission persistante.
- Une trace à audience limitée ne devient pas publique par défaut.
- Une connaissance partielle existe sans accès au contenu de la trace.
- Contrat de couple et état de divulgation demeurent distincts.
- Un acte a une durée variable et peut être recentré sans quota.
- Une journée calme est possible sans contenu important.
- La préférence joueur est recalculée et permet un changement d'avis.
- Le traitement idempotent d'un événement rejoué est spécifié et vérifiable.
- Un événement rejeté par le reducer ne laisse aucune mutation partielle ni enregistrement accompli.
- Un couple séparé possède `relation_apres_separation` mais aucun `contrat_couple` actif.
- Une livraison média réussie n'étend ni audience ni connaissance.
- La séquence finale obligatoire est construite et respecte ses invariants.
- Une sauvegarde du nouveau format incompatible est reprise avec état narratif et reprise technique séparés.

## 14. Points ouverts de produit

1. Format et espace de nom des identifiants d'événements.
2. Réalisation Godot : `Resource`, `Dictionary`, classes ou combinaison.
3. Stratégie d'idempotence et de détection de replay.
4. Politique de cache et invalidation des vues calculées.
5. Détail de sérialisation et de reprise UI/provider.

Ces points ne rouvrent aucune décision narrative verrouillée.

## 15. Roadmap après D1

1. Verrouillage explicite de D1-C1, sans rouvrir de point narratif verrouillé.
2. `R8B` — lecture seule et résumé de l'état réconcilié, seulement après ce verrouillage.
3. `R8C` — fondation du nouveau moteur, seulement après R8B validé ou décision explicite contraire.

## Verdict

`PRODUCT_APPROVED_READY_FOR_LOCK`
