# R8C-N14 — Contrat des registres durables et de la résolution atomique

> **Baseline obligatoire vérifiée :** `fa6adc55420df0fadc4ff2b14e17c795680951d5`
>
> **Tag stable vérifié :** `r8c-n13-minimal-sequence-executor-in-memory-snapshot`
>
> **Branche de livraison :** `work/r8c-n14-durable-registries-atomic-resolution-contract`
>
> **Nature :** contrat documentaire et architectural uniquement ; aucune implémentation
>
> **Statut du document :** `DURABLE_REGISTRIES_ATOMIC_RESOLUTION_CONTRACT_APPROVED`
>
> **Approbation produit :** commit revu `257dead5fab17795bcc457359206765ce1fa5cb0` ; approuvé sans réserve bloquante ; date de référence août 2026

## 1. Décision, portée et autorités

N14 ferme le contrat des cinq registres durables déjà présents dans A1, de leur
validation A5 et du commit commun qui doit rendre visibles ensemble les effets
d'une résolution unifiée et l'état A5 `RESOLVED`.

Le présent lot ne modifie aucun code, test, fixture, donnée, contenu canonique,
surface UI ou contrat antérieur. Il amende normativement, dans ce document
uniquement, les formulations de N11 et N12.1 relatives à l'autorité relue au
moment du commit. N13, son exécuteur et son snapshot restent verrouillés et
inchangés.

Les autorités appliquées sont, par ordre spécialisé :

1. les invariants A1–A10 existants, notamment la frontière transactionnelle A1,
   la séparation définition/instance A2–A3, le registre A5, la définition A6 et
   les sept opérations A10 ;
2. les contrats N12 verrouillés et la liaison explicite N12.1 entre
   `resolution_id`, `a10_choice_id` et `a10_resolution_id` ;
3. l'exécuteur minimal et le snapshot N13 verrouillés ;
4. N11, tel qu'amendé explicitement par la section 3 du présent contrat ;
5. N14 pour le manifeste A6, les registres durables, le codec narratif v2 et le
   protocole atomique A1 + A5.

En cas de conflit sur la source technique des mutations d'un commit unifié, la
décision N14 prévaut. Elle ne retire pas à la résolution authored son autorité
player-facing et ne change aucune autre frontière N11/N12/N13.

### 1.1 Corrections après première revue produit

La première revue produit demande et le présent correctif intègre cinq
fermetures supplémentaires : l'effet média `WITHDRAW`, la vérification d'un
replay avant toute exigence `PROPOSED`, l'union fermée des faits, l'ordre strict
des `event_keys` et une publication finale synchrone et non réentrante. Ces
décisions sont désormais approuvées sans réserve bloquante.

## 2. Diagnostic du runtime verrouillé

Le diagnostic de départ est fermé et vérifié sur la baseline :

1. `EtatNarratif` possède déjà les racines dictionnaires `promesses`,
   `obligations`, `traces_narratives`, `connaissances` et
   `livraison_medias`.
2. Aucun reducer métier effectif n'écrit actuellement ces cinq racines.
3. `EtatNarratif.traiter_evenement()` accepte seulement
   `R8C_A1_RELATION_CENTRALE_SYNTHETIQUE` et
   `R8C_A1_RELATION_SYNTHETIQUE`.
4. `ReducerRelation.gd` ne prépare que des mutations de `relation_centrale` ou
   de `relations`.
5. `A5NarrativeStateCodec.gd` refuse tout snapshot où l'une des cinq nouvelles
   racines est non vide.
6. `MinimalSceneEngine._finaliser()` appelle aujourd'hui
   `EtatNarratif.traiter_evenement()`, puis applique la transition A5 préparée ;
   les deux publications ne partagent pas encore un protocole de préparation.
7. A10 retrouve depuis l'instance la définition A6 et sa résolution, mais ne
   reçoit aucun catalogue `AuthoredSequenceV1`.
8. L'enveloppe N13 `sequence_resolution` contient volontairement des identités,
   un checkpoint et `event_keys`, sans payload mutable.
9. Un commit complet ne peut donc pas encore rendre atomiquement visibles un
   fait, une connaissance, une trace, une promesse, une obligation, un accès
   média et l'état A5 `RESOLVED`.

Ce diagnostic est une limite actuelle à lever dans N14.1, pas une autorisation
de modifier N13 dans N14.

## 3. Autorité des effets durables et amendement N11/N12.1

### 3.1 Source technique au moment du commit

Pour un commit A10/A3 du runtime unifié, la source d'autorité directement
disponible est exactement :

```text
orchestration.a6_entry.definition.resolutions[a10_resolution_id]
```

Cette résolution A3/A10 peut porter le manifeste optionnel et fermé
`durable_manifest`. Pour une résolution durable issue du runtime unifié, ce
manifeste est requis et constitue l'unique source technique des mutations
construites et appliquées par A1.

La résolution `AuthoredSequenceV1` demeure l'autorité player-facing pour :

- le chemin narratif et le choix consommé ;
- `choice_id` et `resolution_id` ;
- les checkpoints et le checkpoint terminal ;
- la convergence et la suite authored ;
- les effets attendus et leurs identifiants.

Le lien est toujours explicite et unidirectionnel :

```text
resolution_id authored
  → a10_choice_id
  → a10_resolution_id
  → durable_manifest de la résolution A6
```

Aucun lien n'est inféré par nom, préfixe, suffixe, position, ordre, index ou
égalité accidentelle.

### 3.2 Amendement normatif à N11 et N12.1

Les formulations N11 §7.1/§7.3 et N12.1 §2/§4 selon lesquelles A3 ou les
reducers relisent directement la définition authored sont remplacées, pour le
commit unifié, par les règles suivantes :

1. au chargement, les validateurs N12/N14 vérifient la cohérence exacte entre
   chaque résolution authored committable et le `durable_manifest` A6 auquel
   elle est explicitement liée ;
2. l'exécuteur construit `sequence_resolution` depuis la séquence authored déjà
   validée ;
3. A10/A3 relisent exclusivement la résolution A6 liée à l'instance et nommée
   par `a10_resolution_id` ;
4. A10/A3 comparent l'enveloppe au binding et aux clés du manifeste A6 ;
5. A3 construit l'événement A1 uniquement depuis le manifeste A6 ;
6. aucun effet n'est lu depuis un payload fourni par l'UI, le port de
   projection, l'exécuteur ou l'enveloppe ;
7. A10 ne reçoit aucun catalogue authored supplémentaire.

La signature `create(library, narrative_state)` reste inchangée. La façade A10
conserve exactement ses sept opérations publiques. N14 n'autorise ni huitième
opération, ni seconde écriture après `resolve_scene`.

### 3.3 Compatibilité des deux flux A3/A10

- Une résolution unifiée durable possède `context.sequence_resolution` et un
  `durable_manifest` A6 valide. L'absence de l'un des deux refuse ce flux.
- Les appels synthétiques historiques sans `sequence_resolution` conservent le
  chemin A3/A10 existant et ses résolutions actuelles.
- Un appel ne bascule jamais d'un flux à l'autre. Il n'existe ni fallback, ni
  reconstruction authored implicite, ni tolérance partielle.

## 4. Contrat fermé de `durable_manifest`

### 4.1 Présence et racine

`durable_manifest` est absent ou vaut le dictionnaire vide `{}` pour une
résolution locale. Il est obligatoire, non vide et fermé pour toute résolution
unifiée durable.

Sa structure conceptuelle exacte est :

```text
durable_manifest
├── binding
├── facts
├── knowledge
├── traces
├── promises
├── obligations
└── media_deliveries
```

Un manifeste durable contient exactement ces sept champs. Les six catégories
d'effets sont des tableaux ordonnés, éventuellement vides. Tout champ ou toute
catégorie supplémentaire est refusé.

### 4.2 Binding unique

`binding` contient exactement :

| Champ | Règle |
|---|---|
| `sequence_id` | identité authored exacte de la séquence |
| `authored_version` | version authored exacte, sans sélection automatique d'une autre version |
| `resolution_id` | identité exacte de la résolution authored liée |

Une résolution A10 ne possède qu'un seul binding authored dans cette première
version. Les trois valeurs doivent être strictement égales aux champs de même
nom dans `sequence_resolution`.

### 4.3 Clés d'effets

Chaque entrée d'effet possède un `event_key` stable. Dans chaque catégorie, les
identifiants métier et les `event_key` sont non vides, bornés, uniques et
conservés dans l'ordre authored. Une catégorie ne contient pas deux opérations
sur le même identifiant dans une résolution ; les transitions successives
réelles utilisent des résolutions/commits distincts.

La liste applicable des clés est la concaténation, dans cet ordre fixe, des
`event_key` de :

```text
facts → knowledge → traces → promises → obligations → media_deliveries
```

L'ordre interne de chaque tableau est préservé. `sequence_resolution.event_keys`
doit être strictement égal à cette liste : mêmes valeurs, même cardinal, même
ordre, aucune clé absente, supplémentaire ou dupliquée.

`event_keys` est un tableau ordonné, jamais un ensemble. Le validateur ne le
trie pas et ne normalise pas un ordre erroné. Il refuse avant toute mutation :

- une clé manquante, supplémentaire, dupliquée ou inconnue ;
- les mêmes clés présentées dans un ordre différent ;
- tout ordre divergent entre l'enveloppe et l'ordre canonique du manifeste A6.

Les effets authored `NONE` restent admis par le contrat authored existant, mais
ne produisent aucune entrée de manifeste, aucune `event_key` et aucune mutation.

### 4.4 Descripteurs fermés

Les formes ci-dessous sont normatives pour N14.1. `provenance`, statuts dérivés
et instants de résolution ne sont pas acceptés depuis le manifeste : A3 les
construit depuis l'instance, le binding et le contexte validés.

| Catégorie | Forme fermée |
|---|---|
| `facts` `RELATION` | `{event_key,scope,personnage_id,fact}` ; `scope = RELATION`, `personnage_id` est obligatoire et non nul |
| `facts` `RELATION_CENTRALE` | `{event_key,scope,fact}` ; `scope = RELATION_CENTRALE` et `personnage_id` est absent |
| `knowledge` | `{event_key,effect,knowledge_id,subject_id,holder_ids}` avec `effect = ACQUIRE` |
| `traces` `CREATE` | `{event_key,effect,trace_id,creator_id,audience_ids,controller_ids,accessible_to_ids}` |
| `traces` `WITHDRAW` | `{event_key,effect,trace_id}` |
| `traces` accès | `{event_key,effect,trace_id,accessible_to_ids}` avec `effect = GRANT_ACCESS|REVOKE_ACCESS` |
| `promises` `CREATE` | `{event_key,effect,promise_id,author_id,beneficiary_ids,content_ref}` |
| `promises` terminal | `{event_key,effect,promise_id}` avec `effect = PAY|FAIL` |
| `obligations` `CREATE_DUE` | `{event_key,effect,obligation_id,debtor_id,beneficiary_ids,kind}` |
| `obligations` terminal | `{event_key,effect,obligation_id}` avec `effect = PAY|FAIL` |
| `media_deliveries` `CREATE_DIEGETIC` | `{event_key,effect,media_id,fictional_audience_ids}` |
| `media_deliveries` `GRANT_ACCESS` | `{event_key,effect,media_id,diegetic_status,fictional_audience_ids,gallery_status}` |
| `media_deliveries` `REVOKE_ACCESS` | `{event_key,effect,media_id}` |
| `media_deliveries` `WITHDRAW` | `{event_key,effect,media_id}` |

Pour un `GRANT_ACCESS` qui matérialise un média non encore enregistré,
`diegetic_status`, `fictional_audience_ids` et `gallery_status` fournissent
l'état initial complet ; `diegetic_status` peut valoir `NOT_APPLICABLE` pour un
média non diégétique. Sur un record existant, ces valeurs doivent être égales à
l'état déjà sourcé, sauf la transition d'accès et l'admission Galerie
explicitement demandées. Une divergence est refusée.

Le manifeste ne contient aucune catégorie libre, aucun script, aucun nom de
reducer choisi dynamiquement et aucun payload UI.

## 5. Version du contenu de `narrative_state`

### 5.1 Version v2

Le snapshot narratif A1/A5 introduit à sa racine :

```text
format_version = 2
```

Cette version qualifie uniquement le contenu de `narrative_state`. Elle ne
change pas :

- le namespace `reseau_intime.unified_runtime` ;
- `UnifiedRuntimeSnapshotV1.schema_version = 1` ;
- l'enveloppe A5 extérieure `{version,narrative_state,scene_registry}` ;
- le champ extérieur `domain.version = 1`.

Le snapshot unifié N13 reste donc en version 1. Sa propriété
`domain.narrative_state` contient, après N14.1, un état narratif v2.

### 5.2 Lecture v1 et normalisation

Le codec A5 v2 accepte :

1. un état v2 possédant exactement `format_version = 2` et respectant tous les
   invariants v2 ;
2. un état v1 sans `format_version`, seulement si les cinq registres sont
   absents ou vides et si tous les autres invariants v1 sont valides.

Un état v1 admissible est copié puis normalisé en mémoire en v2, avec les cinq
racines présentes et vides. Toute production de snapshot après restauration
émet uniquement du v2.

Sont interdits :

- la migration silencieuse d'un registre v1 non vide ;
- le downgrade d'un état v2 vers v1 ;
- l'inférence d'une version depuis un champ inconnu ;
- la modification de l'objet snapshot fourni, qu'il soit accepté ou refusé ;
- toute migration de contenu legacy.

Cette compatibilité vise uniquement les snapshots techniques N13 ; aucune
sauvegarde de production n'existe à migrer.

## 6. Provenance commune des records durables

Chaque record durable créé ou déjà présent puis modifié doit posséder une
provenance fermée. Elle contient exactement :

```text
event_id
source_scene_id
source_scene_instance_id
source_a10_choice_id
source_a10_resolution_id
source_sequence_id
source_authored_version
source_resolution_id
moment_diegetique
```

Tous les champs sont construits par A3 depuis l'instance, la définition A6, le
binding et le contexte validés. Aucun de ces champs n'est accepté depuis l'UI ou
l'exécuteur.

La provenance ne contient aucun jour, score, texte UI, formulation de choix ou
droit implicite. Elle ne confère aucun droit futur. Pour un record déjà existant,
la provenance de création reste immuable ; la provenance de chaque mutation est
conservée par l'événement A1 correspondant, tandis que les champs terminaux du
record portent l'instant résultant.

## 7. Registre `connaissances`

`connaissances` est un dictionnaire indexé par `knowledge_id`. Chaque record est
fermé et contient exactement :

```text
knowledge_id
subject_id
holder_ids
status
provenance
```

La seule valeur initiale de `status` est `KNOWN`. Le seul effet initial est
`ACQUIRE`.

Règles :

- une connaissance est créée seulement si elle figure dans le manifeste ;
- `holder_ids` est non vide, borné, sans doublon et ordonné ;
- un rejeu strictement identique est idempotent ;
- le même `knowledge_id` avec un contenu différent est rejeté ;
- aucune suppression implicite n'existe ;
- aucune photo, aucun message présenté, aucun reçu `VIEWED` et aucune audience
  ne créent une connaissance par déduction.

## 8. Registre `traces_narratives`

`traces_narratives` est un dictionnaire indexé par `trace_id`. Chaque record est
fermé et contient exactement :

```text
trace_id
creator_id
audience_ids
controller_ids
accessible_to_ids
status
provenance
withdrawn_at
```

Statuts : `ACTIVE`, `WITHDRAWN`.

Effets : `CREATE`, `WITHDRAW`, `GRANT_ACCESS`, `REVOKE_ACCESS`.

Règles :

- `CREATE` exige un identifiant absent, initialise `status = ACTIVE` et
  `withdrawn_at = null` ;
- créateur, audience, contrôle et accès sont quatre notions distinctes ;
- le créateur n'est pas automatiquement contrôleur ;
- l'audience fictionnelle n'implique aucun accès durable ;
- `GRANT_ACCESS` et `REVOKE_ACCESS` modifient seulement
  `accessible_to_ids`, par ensembles explicites sans doublon ;
- `WITHDRAW` conserve le record et sa provenance, fixe
  `status = WITHDRAWN` et `withdrawn_at = moment_diegetique` ;
- aucun accès ne peut être accordé à une trace retirée ;
- aucune transition ne réactive implicitement une trace ;
- une transition impossible ou divergente est rejetée sans mutation ;
- le rejeu strictement identique d'une transition déjà réalisée est idempotent.

## 9. Registre `promesses`

`promesses` est un dictionnaire indexé par `promise_id`. Chaque record est fermé
et contient exactement :

```text
promise_id
author_id
beneficiary_ids
content_ref
status
provenance
resolved_at
```

Statuts : `ACTIVE`, `PAID`, `FAILED`.

Effets authored existants : `CREATE`, `PAY`, `FAIL`, `NONE`.

Transitions autorisées :

```text
absente → ACTIVE   par CREATE
ACTIVE  → PAID     par PAY
ACTIVE  → FAILED   par FAIL
```

`CREATE` exige des `beneficiary_ids` non vides et sans doublon, initialise
`resolved_at = null` et fixe la provenance de création. `PAY` ou `FAIL` fixe
`resolved_at` au `moment_diegetique` de l'événement. Un `PAY` ou `FAIL` rejoué
avec le même événement et le même contenu est idempotent. Toute autre
transition, tout conflit de contenu et toute tentative de changer un statut
terminal sont refusés sans mutation. `NONE` n'écrit rien.

## 10. Registre `obligations`

`obligations` est un dictionnaire indexé par `obligation_id`. Chaque record est
fermé et contient exactement :

```text
obligation_id
debtor_id
beneficiary_ids
kind
status
provenance
resolved_at
```

Statuts : `DUE`, `PAID`, `FAILED`.

Effets authored existants : `CREATE_DUE`, `PAY`, `FAIL`, `NONE`.

Transitions autorisées :

```text
absente → DUE      par CREATE_DUE
DUE     → PAID     par PAY
DUE     → FAILED   par FAIL
```

`CREATE_DUE` exige des `beneficiary_ids` non vides et sans doublon, initialise
`resolved_at = null` et fixe la provenance de création. `PAY` ou `FAIL` fixe
`resolved_at` au `moment_diegetique` de l'événement. Le rejeu strictement
identique est idempotent. Toute autre transition ou modification d'un statut
terminal est refusée sans mutation. `NONE` n'écrit rien.

### 10.1 Aftercare

L'aftercare est représenté exclusivement par une obligation :

- payoff et aftercare restent deux faits narratifs distincts ;
- l'obligation d'aftercare devient `DUE` au checkpoint authored approprié ;
- un choix final authored peut la faire passer à `PAID` ou `FAILED` ;
- une question demandant à l'autre personnage de rassurer Player peut être
  authored comme `FAILED`, mais le reducer ne fait aucune déduction libre ;
- l'absence d'un média d'aftercare ne change jamais le statut de l'obligation ;
- un retrait avant payoff peut laisser l'aftercare `DUE` si le contrat authored
  le déclare explicitement.

Le futur code N14.1 ne contient aucune règle propre à Sandra, Mathilde ou à un
autre personnage canonique.

## 11. Registre `livraison_medias`

`livraison_medias` est un dictionnaire indexé par `media_id`. Chaque record est
fermé et contient exactement :

```text
media_id
diegetic_status
fictional_audience_ids
access_status
gallery_status
withdrawal_status
provenance
```

Valeurs autorisées :

| Champ | Valeurs |
|---|---|
| `diegetic_status` | `NOT_APPLICABLE`, `CREATED` |
| `access_status` | `LOCKED`, `ACCESSIBLE`, `REVOKED` |
| `gallery_status` | `HIDDEN`, `AVAILABLE` |
| `withdrawal_status` | `ACTIVE`, `WITHDRAWN` |

Effets authored : `CREATE_DIEGETIC`, `GRANT_ACCESS`, `REVOKE_ACCESS`,
`WITHDRAW`, `NONE`.

Règles :

- présenter un beat `MEDIA_REVEAL` ne crée aucun record ni accès durable ;
- `CREATE_DIEGETIC` matérialise l'existence fictionnelle, initialise
  `access_status = LOCKED`, `gallery_status = HIDDEN` et
  `withdrawal_status = ACTIVE`, sans accorder d'accès ;
- `GRANT_ACCESS` fixe `access_status = ACCESSIBLE`, mais ne crée pas une audience
  fictionnelle non déclarée ;
- `gallery_status = AVAILABLE` est accepté seulement si le manifeste le
  demande explicitement et si l'accès résultant est `ACCESSIBLE` ;
- `REVOKE_ACCESS` conserve le record et sa provenance, fixe
  `access_status = REVOKED` et `gallery_status = HIDDEN` ;
- `WITHDRAW` exige un record existant avec `withdrawal_status = ACTIVE`, conserve
  `media_id` et la provenance d'origine, puis applique exactement
  `ACTIVE → WITHDRAWN` ;
- `WITHDRAW` fixe `withdrawal_status = WITHDRAWN`, fixe
  `gallery_status = HIDDEN` et fixe `access_status = REVOKED` si l'accès était
  encore `ACCESSIBLE` ;
- `WITHDRAW` ne modifie pas rétroactivement `fictional_audience_ids`, ne supprime
  ni l'existence diégétique ni le fichier technique, et ne crée aucune audience
  ou accès ;
- l'événement A1 source conserve l'historique durable de la transition, tandis
  que le record reste présent et conserve sa provenance d'origine ;
- un nouveau `WITHDRAW` strictement identique sur le même média déjà
  `WITHDRAWN` rend `IDEMPOTENT`, sans second record, seconde mutation, nouvelle
  provenance ou réouverture de transaction ;
- `WITHDRAW` sur un identifiant absent est refusé ; combiner création et retrait
  du même média dans un manifeste initial est également interdit ;
- `GRANT_ACCESS`, `CREATE_DIEGETIC` ou tout changement de `WITHDRAWN` vers
  `ACTIVE` sont refusés comme tentatives de réactivation ;
- un retrait rejoué sous le même identifiant d'événement avec contenu ou
  provenance divergente est rejeté avant mutation ;
- `VIEWED` reste un reçu de présentation N13/N16 et n'appartient pas à ce
  registre ;
- l'existence du fichier technique, son chargement ou un placeholder restent
  hors du registre et ne donnent aucun droit.

`REVOKE_ACCESS` et `WITHDRAW` sont distincts. `REVOKE_ACCESS` retire seulement
l'accès joueur et laisse `withdrawal_status = ACTIVE`. `WITHDRAW` ferme
durablement le média authored et interdit tout nouvel accès sans une nouvelle
décision de contrat/version. La version initiale ne possède aucun effet
`RESTORE`, `REACTIVATE` ou `UNWITHDRAW`.

N14 ne connecte ni Galerie, ni PhotoViewer.

## 12. Faits relationnels

Les faits relationnels restent exclusivement dans les structures actuelles :

- `relations` pour un personnage ;
- `relation_centrale` pour la relation centrale.

Le manifeste peut déclarer des faits, mais il ne crée aucune troisième racine
de faits. Le payload atomique `facts` utilise exclusivement l'union fermée :

```text
{scope: RELATION, personnage_id, fact}
{scope: RELATION_CENTRALE, fact}
```

Pour `RELATION`, `personnage_id` est obligatoire et non nul. Pour
`RELATION_CENTRALE`, le champ `personnage_id` doit être absent, jamais présent
avec la valeur `null`. Le reducer choisit la destination exclusivement via
`scope`. Il refuse un `scope` inconnu, toute forme incohérente et tout fait
dirigé vers une troisième racine.

Le `event_key` commun du descripteur de manifeste enveloppe cette mutation ; il
n'ajoute aucune variante à l'union du payload `facts`. Les records continuent
d'utiliser la structure A1/A5 existante ; la provenance commune est construite
et injectée par A3 selon les champs compatibles du record de fait.

Dans N14.1, `consequence_ids` reste limité aux conséquences qualitatives déjà
représentables par les relations ou les faits. Aucun reducer générique de
conséquence n'est créé.

## 13. Événement A1 atomique de résolution

N14 introduit conceptuellement le type d'événement :

```text
R8C_A1_SEQUENCE_RESOLUTION_V1
```

Un événement représente le commit durable complet d'une résolution. Son
identifiant déterministe recommandé est :

```text
r8c-a1:<scene_instance_id>:sequence-resolution:<a10_resolution_id>
```

L'événement possède l'enveloppe A1 fermée `{event_id,event_type,provenance,payload}`.
Sa provenance respecte la section 6. Son payload contient exactement :

```text
facts
knowledge
traces
promises
obligations
media_deliveries
```

Chaque valeur est la projection profonde, ordonnée et validée de la catégorie
correspondante du manifeste ; aucune catégorie libre n'est admise. Pour
`facts`, le `event_key` du descripteur est validé contre l'enveloppe, puis
l'objet placé dans le payload possède exactement l'une des deux formes fermées
de la section 12, sans champ supplémentaire. Le binding n'est pas recopié dans
le payload parce que ses identités sont déjà validées et portées par la
provenance.

L'événement est construit par A3 depuis `durable_manifest`. Il n'est jamais
fourni directement par l'UI, le port de projection, l'exécuteur ou
`sequence_resolution`.

Le conflit d'identifiant est vérifié avant tout reducer et avant toute mutation :

- même `event_id` et payload strictement identique : `IDEMPOTENT` ;
- même `event_id` et payload différent : `REJETE`.

La comparaison inclut l'enveloppe, la provenance et les six catégories
ordonnées. Le runtime ne trie ni ne normalise le payload reçu pour transformer
une divergence en rejeu valide.

## 14. Reducers ciblés et état candidat

N14.1 utilise des reducers spécialisés :

- le reducer relation/faits existant, étendu seulement selon son contrat ;
- un reducer de connaissances ;
- un reducer de traces ;
- un reducer de promesses ;
- un reducer d'obligations ;
- un reducer de livraisons médias.

Un orchestrateur mince de résolution peut appeler ces reducers, dans l'ordre
fixe du manifeste, sur une même copie candidate. Chaque reducer :

- connaît une seule racine, sauf le reducer relation/faits déjà responsable de
  `relations` et `relation_centrale` ;
- accepte seulement ses effets fermés ;
- vérifie les transitions, identités, doublons, bornes et idempotence ;
- travaille sur un candidat non publié ;
- ne modifie jamais l'état réel en cas d'échec ;
- rend un résultat déterministe.

L'orchestrateur n'est ni un reducer universel, ni un moteur de script, ni un
interpréteur de payload libre, ni un système de plugins.

## 15. Protocole atomique A1 + A5

### 15.1 Ordre normatif de `resolve_scene`

Le flux est strictement :

```text
valider les identités stables
→ rechercher et revalider une terminaison persistée
→ retourner IDEMPOTENT si elle est strictement identique
→ sinon exiger PROPOSED pour un nouveau commit
→ préparer A1 et A5
→ publier A1 et A5 sans observation intermédiaire
```

L'idempotence n'est pas une exception à la machine d'état. Elle constate qu'un
commit identique a déjà été entièrement publié.

### 15.2 Étape 1 — validation d'identité stable

Avant toute exigence sur le statut courant et sans mutation, A3/A5 vérifient :

1. l'instance présente et sa définition A6 liée ;
2. la version de définition ;
3. le choix A10 et la résolution A10 ;
4. la forme fermée de `context.sequence_resolution` ;
5. le binding de `durable_manifest` ;
6. l'identifiant déterministe de transaction ;
7. l'ordre strict et l'unicité des `event_keys`.

### 15.3 Étape 2 — terminaison persistée et replay

Avant de vérifier `instance.state == PROPOSED`, le runtime recherche une
terminaison persistée portant le même identifiant de transaction.

Si l'instance est déjà `RESOLVED`, le replay rend `IDEMPOTENT` seulement si les
éléments suivants correspondent exactement :

- même opération et même transaction ;
- même choix A10 et même résolution A10 ;
- même binding authored ;
- mêmes `event_keys`, dans le même ordre ;
- même événement A1, même provenance et même payload durable ;
- même état final A5.

Ce retour n'effectue aucune nouvelle préparation, publication ou mutation et ne
rouvre aucune transaction. Si l'identité terminale diffère, le résultat est
`RESOLUTION_TERMINALE_DIFFERENTE`. Si l'identité paraît identique mais que
l'événement A1, le payload ou l'état A5 retrouvé diverge, le résultat est
`TERMINAISON_PERSISTEE_INCOHERENTE`. Un événement A1 sans terminaison A5, ou une
terminaison A5 sans événement A1, est incohérent et ne peut jamais être réparé
par un replay.

### 15.4 Étape 3 — préparation d'un nouveau commit

L'exigence `instance.state == PROPOSED` s'applique uniquement lorsqu'aucune
terminaison persistée correspondante n'existe. Ensuite seulement :

1. construire `R8C_A1_SEQUENCE_RESOLUTION_V1` depuis le manifeste A6 ;
2. copier l'état narratif courant et préparer toutes les mutations A1 sur un
   candidat commun ;
3. valider entièrement le candidat avec le codec A5 v2 ;
4. préparer, sans l'appliquer, la transition A5 vers `RESOLVED`.

Aucune mutation réelle, aucun remplacement d'état, aucun ajout d'événement et
aucune transition d'instance ne se produit pendant cette phase.

### 15.5 Publication finale synchrone et non réentrante

Le commit commence seulement lorsque les deux préparations sont valides. Dans
le même appel `resolve_scene`, il effectue exactement :

1. publier l'état narratif candidat A1 déjà validé ;
2. appliquer immédiatement la transition A5 déjà préparée ;
3. seulement après les deux opérations, construire et retourner la quittance
   publique.

Cette phase est synchrone, non réentrante, sans `await`, callback externe,
émission de signal, notification, projection UI, hook plugin ou publication
intermédiaire observable. Aucun observateur externe ne peut lire l'état entre
les étapes 1 et 2. Les deux opérations sont déjà validées, sans branche de refus,
allocation métier ou dépendance externe encore susceptible d'échouer.

Si ces garanties ne peuvent pas être obtenues avec les primitives disponibles,
N14.1 doit être déclaré `N14_1_BLOCKED_ATOMIC_PUBLICATION`. Il est interdit de
compenser après qu'une mutation est devenue observable. D'éventuels signaux,
notifications ou projections ne peuvent survenir qu'après le succès complet ;
ils restent hors transaction durable. N14.1 n'ajoute toutefois aucun signal ni
event bus.

### 15.6 Rejet et invariants

Tout échec avant publication conserve bit pour bit ou structurellement à
l'identique :

- l'état narratif initial ;
- le registre A5 initial ;
- l'instance initiale ;
- son statut initial : `PROPOSED` pour un nouveau commit ou `RESOLVED` pour la
  revalidation d'un replay terminal.

Le même événement et la même terminaison rendent `IDEMPOTENT`. Le même
`event_id` avec un payload strictement identique rend `IDEMPOTENT` ; avec un
payload différent, il rend `REJETE` avant toute mutation. Une instance déjà
résolue avec une autre résolution rend `RESOLUTION_TERMINALE_DIFFERENTE`.

Il n'existe aucune deuxième écriture durable après `resolve_scene` et aucun
effet intermédiaire visible entre A1 et A5.

## 16. Validation de `context.sequence_resolution`

A3 accepte la clé `context.sequence_resolution` uniquement pour le runtime
unifié. Sa forme reste exactement celle de N12.1/N13 :

```text
instance_id
sequence_id
authored_version
choice_id
resolution_id
a10_choice_id
a10_resolution_id
terminal_checkpoint_id
event_keys
```

La validation d'identité vérifie :

- l'instance exacte ; son statut `PROPOSED` n'est exigé qu'après la recherche
  d'une terminaison persistée correspondante ;
- `scene_definition_id` et `definition_version` contre la définition A6 liée ;
- `sequence_id` et `authored_version` contre `durable_manifest.binding` ;
- `resolution_id` contre le binding unique ;
- `choice_id`, `a10_choice_id` et `a10_resolution_id` contre les liaisons déjà
  validées au chargement ;
- le checkpoint terminal ;
- l'égalité stricte de `event_keys` et des clés applicables du manifeste ;
- la portée `DURABLE` de la résolution A10 ;
- l'absence de toute clé supplémentaire.

Le validateur de chargement N12/N14 vérifie en outre, avant publication du
catalogue, que la résolution authored, la résolution A6, sa définition et leurs
versions se correspondent exactement. A10/A3 ne refont pas une lecture authored
au commit : ils vérifient l'enveloppe déjà construite contre la résolution A6
liée à l'instance.

Les appels historiques sans cette clé restent compatibles avec le chemin
synthétique existant. Une résolution unifiée ne peut jamais utiliser ce chemin
historique comme fallback, et un appel historique ne peut jamais injecter
partiellement une enveloppe unifiée.

## 17. Validation et restauration par le codec A5 v2

Le codec v2 doit :

- valider `format_version = 2` et la fermeture de toutes les racines ;
- valider les cinq registres même lorsqu'ils sont non vides ;
- imposer les champs exacts de chaque record ;
- vérifier les clés de dictionnaire contre les identifiants internes ;
- refuser les doublons dans toutes les listes qui les interdisent ;
- vérifier les statuts, les champs terminaux et la cohérence des transitions
  persistées avec le ledger d'événements A1 ;
- vérifier chaque provenance et sa cohérence avec l'événement source ;
- borner tailles de registres, tableaux, chaînes et identifiants ;
- refuser tout type ou champ inconnu ;
- refuser un float lorsqu'un entier est requis, même s'il représente une valeur
  mathématiquement entière ;
- refuser récursivement les objets Godot, `Resource`, `Node`, callable, signal ou
  toute autre valeur non structurelle ;
- accepter et normaliser seulement les snapshots v1 admissibles de la section
  5.2 ;
- produire uniquement un état v2 après restauration.

Le codec ne modifie jamais le snapshot reçu. Il valide et normalise une copie
candidate avant que le couple moteur/état restauré ne soit publié. Aucune
migration de contenu legacy n'est permise.

## 18. Allowlist prévisionnelle N14.1

N14.1 pourra modifier ou créer uniquement ce qui est nécessaire dans cette
allowlist technique prévisionnelle, à confirmer par son propre audit :

- `game/scripts/narrative_state/EtatNarratif.gd` ;
- les reducers ciblés sous `game/scripts/narrative_state/` ;
- `game/scripts/narrative_scene/SceneDefinition.gd` ;
- `game/scripts/narrative_scene/MinimalSceneEngine.gd` ;
- `game/scripts/narrative_scene/A5NarrativeStateCodec.gd` ;
- `game/scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd` ;
- les fixtures synthétiques N14 dédiées ;
- les tests statiques et smokes ciblés N14.1.

N14.1 doit préserver :

- la façade publique A10 et ses sept opérations ;
- `create(library, narrative_state)` ;
- `game/scripts/unified_runtime/execution/SequenceExecutor.gd` ;
- `game/scripts/unified_runtime/execution/UnifiedRuntimeSnapshotV1.gd`, sauf
  incompatibilité de version explicitement démontrée et revue séparément ;
- l'UI, le runtime legacy, Mathilde, Galerie et PhotoViewer.

Cette allowlist n'autorise aucune modification dans N14.

## 19. Fixture d'intégration future N14.1

N14.1 crée une fixture synthétique dédiée, distincte de N13 et sans personnage
canonique porteur de contenu réel. La gate complète doit démontrer :

- un fait relationnel ;
- une connaissance ;
- une trace ;
- une promesse créée puis terminalisée dans une résolution ou instance dédiée ;
- une obligation créée `DUE`, puis `PAID` ou `FAILED` ;
- un accès média durable ;
- l'instance A5 `RESOLVED` ;
- l'atomicité de chaque commit qui combine ses effets A1 et sa terminaison A5.

Il est interdit de forcer artificiellement création et toutes transitions
terminales dans une même résolution. Plusieurs instances synthétiques ciblées
sont admises si la gate couvre toutes les catégories et si chaque commit reste
atomique.

## 20. Cas négatifs obligatoires de N14.1

La future gate doit couvrir au minimum :

- manifeste absent pour une résolution unifiée durable ;
- binding authored différent ;
- `event_keys` incomplets ;
- `event_keys` supplémentaires ;
- `event_keys` dupliqués ;
- mêmes `event_keys` dans un ordre différent ;
- `event_key` inconnu ;
- ordre divergent entre enveloppe et manifeste ;
- effet inconnu ;
- registre inconnu ;
- même event_id, payload différent ;
- `personnage_id` absent pour un fait `RELATION` ;
- `personnage_id` présent pour un fait `RELATION_CENTRALE` ;
- `scope` de fait inconnu ;
- fait dirigé vers une troisième racine ;
- promesse payée avant création ;
- promesse terminale modifiée ;
- obligation payée avant `DUE` ;
- obligation terminale modifiée ;
- trace retirée puis accès accordé ;
- média accessible sans `GRANT_ACCESS` ;
- Galerie `AVAILABLE` sans accès `ACCESSIBLE` ;
- retrait d'un média inexistant ;
- double retrait strictement identique idempotent ;
- double retrait divergent rejeté ;
- accès accordé après retrait ;
- Galerie rendue disponible après retrait ;
- réactivation implicite d'un média retiré ;
- `REVOKE_ACCESS` confondu avec `WITHDRAW` ;
- audience fictionnelle créée par simple présentation ;
- snapshot v2 mal formé ;
- snapshot v1 non migrable ;
- échec du dernier reducer sans mutation partielle ;
- transition A5 non préparée sans mutation A1 ;
- instance `RESOLVED` avec même transaction et payload différent ;
- instance `RESOLVED` avec même transaction et `event_keys` différents ;
- événement A1 présent mais terminaison A5 absente ;
- terminaison A5 présente mais événement A1 absent ;
- instance `RESOLVED` avec un autre choix ou une autre résolution ;
- instance non `PROPOSED` sans terminaison correspondante ;
- rejeu strictement identique idempotent ;
- résolution divergente rejetée avec
  `RESOLUTION_TERMINALE_DIFFERENTE`.

Chaque refus doit prouver l'identité des snapshots A1/A5 avant et après l'appel.

## 21. Interdictions

N14 et N14.1 n'introduisent aucun :

- score, jauge relationnelle, consent score ou route points ;
- moteur de règles générique, moteur de script ou reducer universel ;
- transaction manager global, event bus, service locator ou plugin ;
- huitième opération A10 ou changement de signature `create` ;
- double écriture ou mutation après `resolve_scene` ;
- sauvegarde disque, migration legacy ou fallback legacy ;
- UI, branchement Galerie ou PhotoViewer ;
- contenu Sandra, Mathilde ou autre contenu canonique.

## 22. Découpage révisé

Le séquencement cible est désormais :

| Lot | Portée |
|---|---|
| N14 | présent contrat d'architecture durable et atomique |
| N14.1 | implémentation A1/A3/A5, reducers ciblés, manifeste A6 et codec narratif v2 |
| N15 | projections Messages et beat physique |
| N16 | projection média, Galerie et PhotoViewer |
| N17 | tranche Mathilde M-B3 |

N15 ne commence pas avant le verrouillage de N14.1. N14 ne commence ni N14.1,
ni N15.

## 23. Gate documentaire et verdict

### 23.1 Validation N14

- [x] Baseline et tag exacts vérifiés.
- [x] Diagnostic A1/A3/A5/A6/A10 et N13 constaté sans modification.
- [x] Autorité technique du `durable_manifest` A6 fermée.
- [x] Amendement N11/N12.1 explicite et catalogue authored absent d'A10.
- [x] Binding, catégories et `event_keys` fermés.
- [x] Ordre et unicité des `event_keys` stricts, sans tri ni normalisation.
- [x] Cinq registres, statuts, effets et transitions définis.
- [x] Retrait média `WITHDRAW` distinct de `REVOKE_ACCESS`, terminal et idempotent.
- [x] Aftercare exclusivement représenté par une obligation.
- [x] Union fermée des faits et conservation des deux racines relationnelles existantes.
- [x] `format_version = 2` et compatibilité v1 technique fermés.
- [x] Provenance commune sans jour, score ou texte UI.
- [x] Événement `R8C_A1_SEQUENCE_RESOLUTION_V1` fermé.
- [x] Replay terminal revalidé avant toute exigence `PROPOSED`.
- [x] Publication A1 + A5 synchrone, non réentrante et sans signal intermédiaire.
- [x] Compatibilité du flux synthétique historique sans fallback.
- [x] Allowlist, fixture et cas négatifs N14.1 définis.
- [x] Aucun code, test, fixture, donnée, A1–A10, N13, UI, legacy ou contenu
  Mathilde modifié.
- [x] N14.1 et N15 non commencés.

### 23.2 Verdict

Le contrat des registres durables, de leur version narrative et du commit
atomique A1 + A5 est approuvé sans réserve bloquante.

Le statut de livraison N14 est :

`N14_CONTRACT_APPROVED_READY_FOR_LOCK`
