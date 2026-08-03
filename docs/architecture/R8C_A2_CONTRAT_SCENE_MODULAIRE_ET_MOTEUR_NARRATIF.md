# R8C-A2 — Contrat de scène modulaire et moteur narratif

> **Statut : `PRODUCT_CONTRACT_READY_FOR_REVIEW`**
> **Portée : documentation produit uniquement**
> **Dépendance verrouillée :** R8C-A1, commit `6a1f08834a832dd406cd8adb96e3ad034eb5018e`, tag `r8c-a1-narrative-state-foundation`.

## 1. Objet et autorité

Ce document formalise le contrat produit des scènes que le futur moteur narratif pourra évaluer, situer, proposer et résoudre. Il précise le contrat R8A-D1 sans définir encore de classe Godot, de format JSON, de sérialisation, d'API définitive ni de migration du runtime historique.

Il respecte les invariants déjà verrouillés : `EtatNarratif` est la source de vérité persistante, les vues de sélection sont calculées, et une scène ne modifie jamais directement un état relationnel ou un registre. R8C-A1 fournit la frontière transactionnelle et l'encapsulation nécessaires ; ses deux types d'événements synthétiques restent provisoires et ne constituent pas la taxonomie décrite ici.

En cas de conflit, l'ordre d'autorité demeure : canon narratif verrouillé, contrat produit R8A-D1, fondation R8C-A1, puis présent contrat spécialisé. Les exemples de champs sont normatifs sur leur sens, pas sur leur représentation technique.

## 2. Définition canonique d'une scène

Une **scène** est une unité narrative écrite, bornée et résoluble qui réunit :

- une promesse dramatique précise ;
- des participants et un point de vue pertinents ;
- un contexte d'entrée explicite ;
- une évolution jouable ou observable ;
- zéro, un ou plusieurs choix cohérents autour d'un axe lisible ;
- un ensemble fini de résolutions ;
- des conséquences exprimables par événements ;
- une condition de sortie.

Une scène n'est ni une conversation générique, ni un créneau libre, ni un paquet de contenu à injecter dès qu'un personnage est disponible. Elle ne devient pas modulaire parce qu'elle réside dans un fichier séparé. Son identité vient de ce qu'une personne déterminée peut accomplir une action déterminée, dans des conditions déterminées, avec une mémoire narrative déterminée.

Une scène peut ne proposer aucun choix lorsque sa fonction est d'exposer une conséquence, d'accuser réception d'un fait, de laisser agir un personnage ou d'assurer une respiration. L'absence de choix n'abolit ni son contrat d'entrée, ni sa résolution, ni son inspectabilité.

## 3. Définition et instance

La **définition de scène** est le contenu écrit stable. Elle porte l'identité, la fonction, les conditions, les variantes permises, les résolutions possibles et les politiques temporelles. Elle ne porte pas le fait que la scène a eu lieu.

L'**instance de scène** est une occurrence située de cette définition dans une partie. Elle possède au minimum un identifiant unique, une référence vers la définition et sa version, une date diégétique effective, un créneau, une durée prévue, les participants disponibles, un état de cycle de vie et les raisons de ses transitions. Elle capture les références de contexte utiles, mais ne transforme jamais un snapshot d'éligibilité en permission durable.

Conséquences de cette distinction :

- une définition peut être évaluée plusieurs fois sans créer plusieurs occasions persistantes ;
- une instance n'est créée que lorsqu'une intention de planification ou de proposition existe réellement ;
- deux instances de la même définition sont distinctes et ne partagent ni résolution, ni provenance, ni idempotence ;
- une reprise technique peut restaurer une instance en cours sans réécrire la vérité narrative ;
- modifier une définition après une sauvegarde exige une politique explicite de version, jamais une réinterprétation silencieuse d'une instance résolue.

## 4. Scènes signatures et scènes modulaires

### 4.1 Scène signature

Une **scène signature** porte un pivot, une image, une confrontation, une révélation ou une décision dont la mise en scène fait partie de l'identité du récit. Elle possède une place écrite dans une séquence ou une fenêtre bornée. Elle peut offrir des variantes de contexte, mais l'orchestrateur ne la traite pas comme un contenu interchangeable dans un vivier général.

Une scène signature peut être retardée dans sa fenêtre, transformée par une résolution antérieure ou remplacée par une variante explicitement écrite. Elle ne disparaît pas parce qu'une préférence souple est faible et n'est jamais remplacée par une scène modulaire qui remplit une fonction vaguement similaire.

### 4.2 Scène modulaire

Une **scène modulaire** possède un noyau dramatique stable et un contexte d'entrée adaptable dans des bornes écrites. Elle peut être sélectionnée parmi plusieurs candidates lorsque ses conditions dures sont satisfaites. Son ancrage personnage, sa fonction et ses conséquences restent spécifiques ; « modulaire » ne signifie ni générique, ni procédural, ni interchangeable entre personnages.

### 4.3 Non-interchangeabilité

Le type `SIGNATURE` ou `MODULAIRE` appartient à la définition et ne change pas à l'exécution. Une scène modulaire ne compense pas automatiquement l'absence d'une signature. Une signature n'entre pas dans le classement ordinaire des modules. Une transformation entre les deux exige une nouvelle définition écrite, une provenance et une revue produit ; ce n'est jamais une mutation opportuniste du moteur.

## 5. Fonctions narratives

Chaque définition déclare une fonction principale et peut déclarer un petit nombre de fonctions secondaires. La taxonomie minimale est :

| Fonction | Rôle |
| --- | --- |
| `PIVOT` | Faire évoluer une question structurante ou un acte. |
| `RELATION` | Approfondir une relation par interaction réciproque. |
| `CONSEQUENCE` | Porter le résultat dû d'un événement, d'une promesse, d'une limite ou d'un conflit. |
| `REVELATION` | Produire une connaissance sourcée ou modifier sa certitude. |
| `CLARIFICATION_REPARATION` | Clarifier, réparer, renégocier ou constater une rupture. |
| `OPPORTUNITE` | Ouvrir une possibilité relationnelle ou narrative réellement refusible. |
| `ECHO` | Rappeler un fait antérieur sans le rejouer. |
| `RESPIRATION` | Donner du rythme, de la présence et du quotidien sans imposer un pivot. |
| `RECENTRAGE` | Ramener une question structurante, notamment Marie/Player, au premier plan. |
| `TRANSITION` | Relier deux moments, lieux ou régimes de communication. |

La fonction n'est pas un score de priorité. Elle sert à appliquer des politiques explicites : une conséquence due peut précéder une nouvelle opportunité ; une respiration peut être préférée après une scène intense ; un recentrage peut devenir nécessaire si une question structurante stagne.

## 6. Contrat minimal d'une définition

### 6.1 Métadonnées obligatoires

| Champ conceptuel | Exigence |
| --- | --- |
| `scene_id` | Identifiant stable, unique et indépendant d'un ancien numéro `jNN`. |
| `version_contrat` | Version de la définition utilisée pour créer une instance. |
| `titre_interne` | Libellé éditorial inspectable, non nécessairement exposé au joueur. |
| `nature` | `SIGNATURE` ou `MODULAIRE`. |
| `fonction_principale` | Une valeur de la taxonomie des fonctions narratives. |
| `participants_requis` | Personnes indispensables et rôle de chacune. |
| `relation_ou_question_focale` | Relation, promesse ou question dramatique servie. |
| `noyau_stable` | Promesse dramatique et action caractéristique qui ne peuvent être diluées. |
| `conditions_dures` | Prédicats nommés qui doivent tous être vrais. |
| `exclusions_dures` | Prédicats nommés dont un seul suffit à interdire la scène. |
| `lectures_etat` | Données persistantes et contextuelles que l'évaluation est autorisée à lire. |
| `contrat_temporel` | Fenêtre de dates, horaires permis, durée et politique de revalidation. |
| `resolutions` | Ensemble fini de sorties possibles, chacune liée à des événements candidats. |
| `politique_non_resolution` | Retard, expiration, annulation ou transformation autorisés. |
| `sortie` | Etat final attendu de l'instance et candidats de suivi. |
| `observabilite` | Codes de raisons minimaux pour éligibilité, exclusion et résolution. |

Les conditions et exclusions nomment des faits ou règles métier. Le futur moteur ne doit pas introduire un langage d'expression général uniquement pour éviter d'écrire des prédicats lisibles et testables.

### 6.2 Métadonnées optionnelles

Peuvent être ajoutés lorsqu'ils ont un usage éditorial réel : fonctions secondaires, participants optionnels, lieu ou mode de communication, préférences narratives, variantes de contexte, intensité, coût de premier plan, séquence source, ordre relatif, dépendances de médias, délai de refroidissement, candidats de transformation, rappels possibles, exigences d'accessibilité, notes de continuité et critères de QA propres au personnage.

Une métadonnée optionnelle absente ne reçoit pas une valeur inventée. Aucun champ n'est ajouté « au cas où ». Une option utilisée par une seule scène doit d'abord être justifiée comme donnée éditoriale plutôt que comme nouveau sous-système.

## 7. Conditions dures et préférences narratives

Les **conditions dures** établissent la possibilité et la cohérence. Elles couvrent notamment : présence ou disponibilité indispensable, fait accompli, connaissance sourcée, contrat actif, promesse en cours, absence d'exclusion, consentement actuel lorsque pertinent, compatibilité temporelle et prérequis de séquence. Si l'une échoue, la scène est inéligible.

Les **exclusions dures** protègent le canon, la sécurité, le consentement, la chronologie et les contradictions de relation. Elles gagnent toujours contre une préférence ou une priorité de rythme.

Les **préférences narratives** départagent des scènes déjà éligibles. Elles peuvent favoriser une conséquence en retard, une variation de rythme, un personnage moins présent récemment, un écho pertinent ou une continuité active. Elles ne créent aucun droit, ne rendent aucune scène vraie et ne ferment pas une route par elles-mêmes.

Le résultat d'évaluation doit distinguer au moins :

```text
eligible: true | false
raisons_conditions_satisfaites: [...]
raisons_exclusion: [...]
preferences_applicables: [...]
conflits: [...]
revalidation_requise_a: ...
```

Un rang de sélection peut exister en mémoire comme mécanisme déterministe, mais il ne devient ni un fait narratif, ni un score relationnel, ni une donnée de sauvegarde interprétée comme psychologie du joueur.

## 8. Temps, date réelle et disponibilité

Le futur moteur raisonne sur une **date réelle dans le calendrier diégétique**, pas sur une clé historique `jNN_*` ni sur un simple rang de journée. Cette date effective est accompagnée d'un fuseau ou référentiel de calendrier explicite, d'une heure de début possible, d'une heure limite, d'une durée prévue et, si nécessaire, d'une marge de déplacement ou de préparation.

Le contrat temporel distingue :

- la fenêtre de validité de la définition ;
- les créneaux où chaque participant est disponible ;
- le créneau réservé par une instance planifiée ;
- la durée prévue et, après résolution, la durée effectivement consommée ;
- les engagements, absences, repos et déplacements incompatibles ;
- l'instant auquel une revalidation est obligatoire.

La disponibilité est contextuelle et sourcée. Une disponibilité calculée hier n'est pas une garantie aujourd'hui. L'éligibilité et les conflits sont revalidés au minimum : avant planification, avant proposition au joueur, avant démarrage, après tout événement susceptible de modifier une condition dure, et à la reprise d'une sauvegarde.

Une revalidation ne réécrit jamais le passé. Si une instance planifiée devient impossible, elle est annulée, retardée ou transformée selon sa politique, avec une raison inspectable et, seulement si la fiction le justifie, un événement narratif.

## 9. Cycle de vie d'une instance

Les états canoniques sont :

| Etat | Sens |
| --- | --- |
| `INELIGIBLE` | Au moins une condition dure échoue ou une exclusion s'applique. Aucune occasion n'est offerte. |
| `ELIGIBLE` | La définition peut être considérée maintenant ; rien n'est encore promis au joueur. |
| `PLANIFIEE` | Une instance possède un créneau réservé ou une intention concrète de présentation. |
| `PROPOSEE` | L'occasion est perceptible et actionnable par le joueur ou explicitement engagée dans la fiction. |
| `RESOLUE` | Une résolution a été validée transactionnellement et l'instance est close. |
| `MANQUEE` | Une occasion réellement proposée ou un engagement explicite a expiré sans résolution, selon une règle écrite. |
| `ANNULEE` | L'instance cesse sans être imputée au joueur ; sa raison est sourcée. |

Transitions ordinaires :

```text
INELIGIBLE <-> ELIGIBLE -> PLANIFIEE -> PROPOSEE -> RESOLUE
PLANIFIEE -> ANNULEE
PROPOSEE  -> ANNULEE
PROPOSEE  -> MANQUEE
```

Les deux branches terminales depuis `PROPOSEE` sont distinctes : `ANNULEE` ou `MANQUEE`. La branche depuis `PLANIFIEE` mène seulement à `ANNULEE`.

`ELIGIBLE` peut redevenir `INELIGIBLE` après revalidation sans créer de perte. `PLANIFIEE` peut revenir à une nouvelle planification bornée ou être annulée. Une instance `RESOLUE`, `MANQUEE` ou `ANNULEE` est terminale ; une transformation crée une nouvelle instance reliée à l'ancienne au lieu de recycler son identité.

Chaque transition porte : instant diégétique, instant technique si utile, état précédent, état suivant, code de raison et source de décision. Les transitions techniques qui ne changent pas la fiction restent inspectables mais ne deviennent pas automatiquement des événements narratifs.

## 10. Non-sélection et occasion manquée

Une scène **non sélectionnée** est une définition éligible que l'orchestrateur n'a pas retenue. Elle n'a pas été montrée, promise ou réservée. Elle ne produit aucune faute, aucune frustration attribuée au joueur, aucune conséquence de refus et aucune inscription `MANQUEE`.

Une occasion est **réellement manquée** seulement si les quatre conditions suivantes sont réunies :

1. une instance identifiable a atteint `PROPOSEE`, ou un engagement diégétique explicite équivalent a été accepté ;
2. le joueur pouvait raisonnablement percevoir l'occasion et agir ;
3. une échéance ou condition de clôture écrite et inspectable a été franchie ;
4. la politique de la scène déclare que cette absence de résolution a une signification narrative.

Une indisponibilité système, un conflit créé par l'orchestrateur, un chargement impossible ou une condition devenue invalide entraîne `ANNULEE`, un retard ou une transformation, jamais `MANQUEE` par défaut.

Une définition arrivée au terme de sa fenêtre sans avoir dépassé `ELIGIBLE` expire silencieusement ou se transforme selon son contrat. Le moteur ne fabrique pas une histoire de négligence à partir de contenus que le joueur n'a jamais pu voir.

## 11. Choix exclusifs et conflits temporels

Un choix exclusif doit nommer son groupe d'exclusivité, les options concernées et le moment où l'exclusivité devient effective. La simple présence simultanée de plusieurs candidates ne les rend pas mutuellement exclusives.

Lorsqu'une option est confirmée :

- son instance réserve le temps et les ressources nécessaires ;
- les instances incompatibles sont revalidées ;
- elles peuvent être retardées, transformées ou annulées selon leur propre contrat ;
- elles ne deviennent `MANQUEE` que si elles avaient elles-mêmes constitué une occasion réellement proposée et si leur règle écrite le prévoit ;
- les conséquences fictionnelles d'un engagement rompu sont émises comme événements, pas déduites d'un conflit de calendrier technique.

Le moteur interdit le chevauchement de scènes nécessitant la présence physique du même participant. Il peut autoriser des interactions asynchrones si leur durée, leur attention requise et le mode de communication sont compatibles. Ces règles sont explicites et testables ; elles ne reposent pas sur une pénalité numérique cachée.

## 12. Résolution transactionnelle et conséquences

Une résolution décrit ce qui s'est effectivement passé, pas une récompense chiffrée. Elle produit un événement candidat ou un lot cohérent d'événements candidats comprenant conceptuellement :

```text
event_id
event_type
source_scene_id
source_scene_instance_id
source_resolution_id
actors
subjects
moment_diegetique
payload_minimal
idempotency_key
```

Ces événements passent par l'unique frontière transactionnelle de `EtatNarratif`. Le traitement valide toutes les transitions relationnelles et mutations de registres, prépare le nouvel état, applique l'ensemble, enregistre la provenance puis invalide les vues calculées. Si une partie échoue, aucune mutation partielle n'est conservée et l'instance ne peut pas être déclarée `RESOLUE`.

Les conséquences admissibles sont des faits et transitions qualitatives : changement borné d'état relationnel, connaissance sourcée, trace narrative, promesse, obligation, contrat, refus, retrait, réparation, conséquence due, progression d'acte ou candidat de suivi. Sont interdits : `route_points`, score d'affection, score d'attirance, compteur de consentement, compteur de limites, bonus d'emoji et tout scalaire psychologique équivalent.

La scène, l'UI, le provider, le planificateur et la séquence ne mutent jamais directement `EtatRelation`, `EtatRelationCentrale` ou un registre.

## 13. Scènes et séquences

Une **séquence** est une orchestration authored de plusieurs scènes ou battements qui partagent une question dramatique, des dépendances ou une continuité de présentation. Elle définit un contrat d'entrée, un ordre total ou partiel, des embranchements bornés, des conditions de sortie et une politique d'interruption/reprise.

Une séquence n'est pas une scène géante et ne contourne pas le contrat de résolution. Chaque scène conserve son identité, son instance, sa provenance et ses événements. Une séquence peut décider quelle définition devient candidate ensuite, mais elle ne fabrique pas de vérité persistante hors des événements validés.

Une scène signature appartient généralement à une séquence ou à une fenêtre structurante. Une scène modulaire peut être autonome ou servir une séquence lorsque son point d'insertion, sa fonction et ses variantes sont explicitement prévus. Le moteur ne concatène pas librement des modules pour simuler une séquence écrite.

## 14. Construction immersive future des journées

A terme, le moteur pourra construire une journée immersive en combinant :

1. les ancrages signatures et engagements à échéance dure ;
2. les conséquences, promesses et obligations dues ;
3. les disponibilités réelles, déplacements, repos et absences ;
4. un petit nombre de scènes modulaires éligibles ;
5. des messages, échos, transitions et respirations compatibles ;
6. la densité et le rythme déjà vécus.

La journée est un contenant diégétique, pas un quota. Elle peut être dense, calme, fragmentée ou ne comporter aucun pivot. Le système ne garantit ni une scène par personnage, ni un nombre fixe de choix, ni une route proposée comme menu. Il préserve les rendez-vous et conséquences explicites, puis compose le reste dans des bornes authored.

Cette capacité est une direction produit, pas une autorisation d'implémenter dès R8C-A2 un agenda généraliste, un solveur universel ou une génération procédurale de dialogues.

## 15. Retard, expiration, annulation et transformation

Chaque définition précise les politiques qu'elle autorise :

- **retard** : déplacer l'instance dans une fenêtre bornée sans changer son noyau ;
- **expiration** : cesser de considérer la définition ou l'instance lorsque sa fenêtre ferme ;
- **annulation** : clore une instance pour une cause qui n'est pas imputée comme occasion manquée ;
- **transformation** : clore l'instance source et créer une instance d'une autre définition authored, avec lien de provenance ;
- **occasion manquée** : résoudre l'absence d'action comme fait narratif seulement selon les critères de la section 10.

Le retard n'est pas infini. Une signature en retard doit porter une dernière borne, une variante ou une transformation. Une opportunité modulaire peut expirer silencieusement. Une conséquence due ne peut pas être supprimée par commodité : elle est portée, transformée ou explicitement annulée par un événement compatible avec le canon.

La transformation conserve ce qui est réellement connu ou accompli, mais ne copie ni consentement, ni décision, ni résolution de la scène source. Elle crée un nouvel identifiant d'instance et une nouvelle revalidation complète.

## 16. Micro-signaux relationnels

### 16.1 Principe

Les petits choix d'expression — emoji, compliment, ton, formulation, délai, relance, silence, degré de précision ou retenue — servent d'abord la présence et la nuance. Ils ne sont pas des boutons de score miniatures.

Le modèle sépare toujours :

1. le **signal émis** par Player dans un contexte précis ;
2. sa **réception** par un personnage qui a effectivement accès au signal ;
3. son **interprétation** située, dépendante de la relation, des connaissances, du moment et de la voix propre du personnage ;
4. son éventuel **effet narratif** authored.

Un emoji envoyé n'est pas automatiquement « flirt ». Un silence n'est pas automatiquement « rejet ». Le personnage peut ne pas voir le signal, le comprendre autrement, hésiter ou le recontextualiser plus tard. Cette interprétation doit rester explicable par la fiction.

### 16.2 Trois portées d'effet

Un micro-signal peut avoir l'une des portées suivantes :

- **locale** : variation de ligne, de ton, de rythme ou de réaction dans la scène, sans persistance ;
- **trace temporaire** : fait contextuel borné avec source et expiration, utile pour une relance ou un rappel proche ;
- **événement relationnel durable** : seulement lorsqu'un fait qualitativement significatif et explicitement écrit s'est réellement produit, avec réception identifiable et provenance complète.

Le passage à une portée durable n'est jamais une accumulation automatique. Il dépend d'un événement nommé et lisible — par exemple une clarification reçue, une limite respectée ou une attention explicitement reconnue — et non d'un seuil caché de petits gestes.

### 16.3 Interdictions

Le moteur ne maintient :

- aucune jauge cachée d'attirance, de consentement ou de limites ;
- aucun compteur d'emojis, de compliments, de silences, de temps de réponse ou de consultations ;
- aucun profil psychologique définitif déduit du style d'expression ;
- aucun score de compatibilité sexuelle ou relationnelle ;
- aucune permission persistante inférée d'une réaction favorable antérieure.

Le consentement reste local, actuel et retirable. Les limites restent explicites et sourcées. Une préférence calculée peut résumer des événements qualitatifs pour proposer des variations, mais elle demeure reconstructible, révisable et incapable d'autoriser seule une escalade.

### 16.4 Convergence et mémoire

Les micro-branches convergent rapidement vers le noyau de la scène. Leur priorité de production est : variations de ton immédiates, rappels ultérieurs, variantes de scènes écrites et compatibilités futures explicables. Elles ne multiplient pas les routes permanentes ni les combinaisons de sauvegarde.

Un registre plus osé ou une scène future ne dépend jamais d'un seul micro-choix. Son éligibilité exige une histoire relationnelle cohérente et réciproque faite d'événements qualitatifs, de connaissances partagées, de limites respectées, d'initiatives des personnages et d'un consentement actuel. Cette cohérence peut être vérifiée par des faits nommés ou des motifs d'événements, jamais par un total caché.

## 17. Inspectabilité

Pour une partie donnée, les outils de debug doivent pouvoir expliquer sans recalcul opaque :

- pourquoi une définition est inéligible ou éligible ;
- quelles conditions dures et exclusions ont été évaluées ;
- quelles préférences ont départagé les candidates ;
- pourquoi une instance a été créée, planifiée ou proposée ;
- quel conflit temporel a retardé, transformé ou annulé une instance ;
- quand et sur quelles données la dernière revalidation a eu lieu ;
- pourquoi une instance est résolue, manquée ou annulée ;
- quels événements ont été proposés à `EtatNarratif` et quel a été le résultat transactionnel ;
- comment un micro-signal a été reçu, interprété et limité dans le temps, s'il a persisté.

Ces explications utilisent des identifiants et codes de raisons stables. Elles sont destinées à l'écriture, aux tests et au support ; elles ne contraignent pas l'interface joueur à exposer la mécanique.

## 18. Garde-fous contre l'usine à gaz

- Un contrat commun court avant toute spécialisation.
- Une taxonomie bornée ; aucun nouveau statut pour une nuance éditoriale isolée.
- Des prédicats métier nommés et testables plutôt qu'un langage de règles universel.
- Aucune instance persistante créée pour chaque définition simplement éligible.
- Aucun solveur d'agenda généraliste : seules les contraintes narratives nécessaires sont modélisées.
- Aucun score caché utilisé comme raccourci de continuité, de consentement ou de psychologie.
- Aucun graphe exhaustif entre tous les personnages ; seulement les relations et conflits réellement authored.
- Un budget borné de variantes ; les micro-branches convergent.
- Une nouvelle métadonnée doit avoir un lecteur, un effet observable et un test.
- Une transformation référence une définition écrite ; le moteur n'invente pas de scène.
- Les vues de candidats, classements et disponibilités sont reconstructibles et invalidables.
- Les décisions importantes restent des événements sourcés, pas des états implicites dans l'orchestrateur.

## 19. Dette documentaire explicitement non canonique

Le modèle d'accumulation et de scores cachés présenté dans `docs/15_PLAYER_FLOW_AND_PASSIVE_SIGNALS.md`, notamment ses scores d'attention et sa règle d'accumulation de signaux passifs, est **non canonique sur ce point**.

Le présent contrat le remplace pour les micro-signaux relationnels : expression située, réception et interprétation par le personnage, effets bornés et événements qualitatifs sourcés, sans compteur ni jauge cachée. Les autres recommandations de fluidité ou de charge mentale de l'ancien document ne sont pas arbitrées ici.

`docs/15_PLAYER_FLOW_AND_PASSIVE_SIGNALS.md` doit être réconcilié dans un lot documentaire séparé afin de préserver un historique de décision clair. R8C-A2 ne modifie pas ce fichier.

## 20. Critères de validation produit

Le contrat est validé lorsque les cas suivants peuvent être expliqués sans ambiguïté :

- une définition éligible mais non sélectionnée ne crée aucune occasion manquée ;
- une proposition visible qui expire selon une règle écrite peut devenir `MANQUEE` ;
- un conflit système annule ou transforme une instance sans blâmer le joueur ;
- une scène signature ne peut pas être remplacée automatiquement par un module ;
- une scène modulaire conserve son ancrage personnage et son noyau stable ;
- date réelle diégétique, horaire, durée, disponibilités et revalidations sont inspectables ;
- deux engagements incompatibles produisent une résolution déterministe et sourcée ;
- une résolution multi-personnages est atomique et ne laisse aucune mutation partielle ;
- aucune scène, séquence ou UI ne modifie directement l'état persistant ;
- expiration, retard, annulation et transformation restent distincts ;
- une conséquence due ne disparaît pas par simple non-sélection ;
- un micro-signal peut ne produire qu'une variation locale ;
- une trace temporaire possède une source et une expiration ;
- aucun micro-choix unique n'autorise une escalade relationnelle ou adulte ;
- aucune jauge, aucun compteur d'emojis et aucun profil psychologique caché n'est requis ;
- les micro-branches convergent et la mémoire durable passe par des événements qualitatifs ;
- toute décision de sélection et toute transition d'instance possède une raison de debug ;
- la construction future d'une journée accepte le calme et ne dépend d'aucun quota fixe.

## 21. Limites de R8C-A2

R8C-A2 ne livre aucun runtime, schéma de données, scène jouable, UI, sauvegarde, migration, sélecteur, planificateur, taxonomie finale d'événements ou réconciliation du corpus historique. Il n'étend pas les types synthétiques de R8C-A1 et ne modifie aucune source existante.

Les lots techniques futurs devront d'abord choisir la représentation minimale de la définition et de l'instance, formaliser les prédicats nommés, définir la taxonomie canonique des événements de résolution, puis prouver sur un petit ensemble de scènes signatures et modulaires que le contrat reste inspectable et sans score caché.

## Verdict

`PRODUCT_CONTRACT_READY_FOR_REVIEW`
