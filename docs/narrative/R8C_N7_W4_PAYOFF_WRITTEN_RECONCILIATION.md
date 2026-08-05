# R8C-N7 — Réconciliation écrite des payoffs W4

> **Baseline inspectée :** `5bb04c957030c00a0e8c6a9c39a103e8f697cd2e`
> **Tag stable :** `r8c-n6-global-scene-visual-erotic-coverage-audit`
> **Portée :** Marie J11 `#051`, Mathilde J11 `#045`, Sandra J18 `#079`
> **Nature :** audit et brief de révision ; aucun dialogue définitif
> **Taxonomie W :** éditoriale N7 uniquement, jamais destinée au runtime
> **Statut global :** `WRITTEN_RECONCILIATION_PLANNED`

## 1. Verdict

Les trois routes possèdent déjà un payoff adulte canonique, une entrée consentie,
un centre sexuel défini par fonction et un après-coup. Leur écriture canonique
atteint W3 : les actes sont nommés dans des contrats de scène, mais le centre reste
une ellipse ou un brief. Les trois médias centraux sont en revanche spécifiés comme
NV4/V5 et comme `PORNOGRAPHIC_PAYOFF`.

Le raccord écrit demandé n’ajoute donc aucune scène. Il remplace, dans chacune des
trois séquences existantes, le contrat abstrait du centre par une écriture W4
physique, détaillée et spécifique au personnage. Consentement, possibilité d’arrêt,
réaction immédiate, aftercare et conséquence restent dans le même contrat de
payoff ; le W4 ne les remplace pas.

| Travail | Position réelle | Écriture actuelle | Cible | Média central | Consentement | Décision N7 |
|---|---|---:|---:|---|---|---|
| `N7-PAY-MARIE-J11-051` | mouvement III ; pivot J11 Marie ; `C11-06` ; séquence `MARIE_J11_RECONQUEST` | canon W3 ; runtime W2 + scène placeholder | W4 | `#051` — `PORNOGRAPHIC_PAYOFF` | `CONSENTED_PRIVATE` | `READY_FOR_SCRIPTING` |
| `N7-PAY-MATHILDE-J11-045` | mouvement III ; pivot J11 Mathilde ; `C11-03` ; plafond M-B3 | canon W3 ; runtime W2 + scène placeholder | W4 | `#045` — `PORNOGRAPHIC_PAYOFF` | `CONSENTED_PRIVATE` | `READY_FOR_SCRIPTING` |
| `N7-PAY-SANDRA-J18-079` | mouvement V ; après `C18-01` ; branche adulte de `C18-02` | canon W3 ; branche absente du runtime | W4 | `#079` — `PORNOGRAPHIC_PAYOFF` | `CONSENTED_PRIVATE` | `READY_FOR_SCRIPTING` |

La décision Sandra est désormais verrouillée : `#079` représente, au milieu d’un
rapport vaginal pénétratif consensuel, Sandra au-dessus de Player, active, tournée
vers lui et contrôlant explicitement le rythme. Player reste partiellement cadré et
non identifiable. Le téléphone est hors d’usage, la capacité d’arrêt reste lisible
et l’image n’est jamais une pose pornographique détachée de la relation.

## 2. Autorité et état des sources

La hiérarchie appliquée est celle de
`docs/canon/bible/14_CONTRAT_NARRATIF_SAISON_1_RECONCILIE.md` : décisions et
scripts signés, contrats et registres, amendements validés, runtime, tests, puis
historique.

| Couche | Sources inspectées | Statut retenu | Usage N7 |
|---|---|---|---|
| Canon adulte | `NAR_ADULT_01_PAYOFFS_J11_MARIE_MATHILDE.md`, `NAR_ADULT_02_PAYOFF_SANDRA_J18.md` | `CANON` validé | Niveau, fonction sexuelle, consentement, limites, aftercare et nature non diégétique. |
| Canon de scène | `J11_SCRIPT_NARRATIF_COMPLET.md`, `J12_SCRIPT_NARRATIF_COMPLET.md`, `J18_SCRIPT_NARRATIF_COMPLET.md`, `J19_SCRIPT_NARRATIF_COMPLET.md` | `CANON` signé/amendé | Séquences, choix, réceptions, effets et positions relatives. |
| Canon personnage | `MARIE_CANON_FULL.md`, `MATHILDE_CANON_FULL.md`, `SANDRA_CANON_FULL.md`, `NSFW_CHARACTER_ROUTE_CANON.md`, bible de voix `13` | `CANON` | Voix, désir, crudité compatible et interdits. |
| Canon de production | `NAR_PROD_04_*`, `NAR_PROD_06_*`, `ASSET_01_MANIFESTE_*` | `CANON DE PRODUCTION` | Parents, enfants, IDs, nature des médias et comportement Galerie. |
| Audit N6 | les quatre documents `R8C_N6_*` | `AUDIT` | Diagnostic W3/NV4, trois révisions W4, gaps de livraison et contradictions. |
| Runtime actif | conversations J11/J12/J18/J19, maps J11/J12/J18/J19 et providers/état | `RUNTIME` | Contenu réellement présenté, choix branchés, placeholders et faits persistés. |
| Staged | `r8c_n5_sandra_blue_chairs_staged.json` et documents N1–N5 | `STAGED` | Hors des trois payoffs ; aucune activation ou déduction N7. |
| Historique | anciens plans et constats `V0_*`, `story_state`, états de production antérieurs | `HISTORIQUE` | Provenance seulement ; ne peut ni abaisser le W cible ni déclarer le runtime absent. |

Contradictions documentaires conservées et résolues pour cet audit :

- les blocs internes `status: DRAFT PRODUIT` des addenda adultes décrivent leur
  état avant validation ; leurs en-têtes de consolidation `Canon` et `PASS`
  prévalent ;
- les addenda disent ne pas avoir modifié physiquement les scripts de leur ancienne
  baseline, mais les scripts J11/J18 de la baseline N7 contiennent désormais leurs
  contrats ; ce qui manque reste la prose W4, pas l’autorisation adulte ;
- `WA` dans le manifeste est un code de fenêtre adulte, pas un niveau d’écriture W ;
- le debug runtime J18 borne encore Sandra aux résolutions standard alors que
  l’addendum adulte autorise la branche tardive : le canon prévaut sur ce constat
  d’implémentation ;
- les six enfants Galerie J11 sont des placeholders réellement configurés, pas six
  fichiers finaux livrés ; aucun des 84 fichiers du manifeste n’est produit ;
- une image de scène conservée par la Galerie est une mémoire joueur : elle ne
  devient ni photographie dans l’histoire, ni possession de Player, ni preuve.

## 3. Échelle écrite et contrat commun

| Niveau | Usage d’audit |
|---|---|
| W0 | quotidien |
| W1 | suggestif |
| W2 | érotique |
| W3 | sexuellement explicite : l’acte est nommé ou contracté |
| W4 | pornographique : le payoff est décrit physiquement et crûment |

Le passage W3 → W4 doit rendre explicites :

1. le changement physique qui fait quitter l’entrée érotique ;
2. l’action sexuelle centrale réellement accomplie, sans liste de possibilités ;
3. l’initiative et les réponses corporelles attribuables aux deux personnes ;
4. au moins un point de consentement continu lisible dans l’action ;
5. la manière dont l’arrêt reste praticable ;
6. la retombée physique immédiate qui ouvre l’aftercare.

Doivent rester implicites ou hors champ : anatomie de Player permettant son
identification, inventaire de positions, performance chiffrée, dialogue oral de
co-présence, caméra diégétique, promesse de répétition, consentement d’un partenaire
absent et connaissance que le canon n’a pas attribuée.

Le même contrat s’applique aux trois payoffs : préparation → consentement et agence
→ escalade → payoff → réaction immédiate → aftercare → mémoire et conséquence.

## 4. Marie — `N7-PAY-MARIE-J11-051`

### 4.1 Ancrage réel

| Champ | Constat |
|---|---|
| Scène/conversation | `game/data/conversations/chapter_11_marie_return.json` ; segment d’ouverture selon P10, choix de reconquête, puis `j11_marie_reconquest_adult`. |
| Séquence | `C11-06`, parent Galerie `S1_A3_J11_SCN_MARIE_COUPLE_STATE_01`, séquence `MARIE_J11_RECONQUEST`. |
| Position relative | Après règlement des obligations prioritaires et vérification du dîner/pivot ; remplace le climax J11 normal ; avant l’aftercare matinal J12 et la convergence. |
| Source autoritative | `NAR_ADULT_01_*` §§3.1, 5–11 ; `J11_SCRIPT_*` §§23–24 ; amendement J10–J12 pour le prédicat exact. |
| Runtime | Le choix de reconquête établit `MARIE_ADULT_RECONQUEST` seulement si éligible, sert la séquence de trois IDs sous placeholders, puis ferme J11. J12 paie `aftercare_marie_j11` à 08:24. |

### 4.2 Progression écrite et transition manquante

La préparation, l’initiative de Marie, le refus du sexe-pansement, le consentement
révocable et la transition hors téléphone sont déjà écrits. Le contrat central
nomme nudité, sexualité conjugale et rapport complet possible, mais saute de
l’accord au fait accompli. Le manque est donc le centre W4 entre `#049` et `#052`,
pas un nouveau sexting ni une nouvelle décision.

La révision doit :

- partir d’une familiarité corporelle de couple, mais montrer que Marie choisit
  activement de la réinvestir au présent ;
- fixer un acte sexuel central concret compatible avec un rapport complet, puis le
  décrire assez précisément pour que `#051` ne puisse pas illustrer un simple baiser
  ou une nudité statique ;
- rendre l’initiative de Marie visible dans le rythme, les gestes et les corrections
  de Player, sans faire de Player un corps anonyme totalement inerte ;
- conserver un signal de consentement continu sans transformer la scène en manuel ;
- faire retomber le centre vers un geste ou une action ordinaire qui prépare `#052`
  et le café J12 ;
- ne rien réparer par l’orgasme, la tendresse ou la familiarité : le couple garde
  ses dettes et devra encore être défini.

### 4.3 Crudité compatible

Crudité cible : **directe, physique et familière**, de degré moyen à fort. Les noms
du corps et de l’acte sont autorisés ; la prose doit privilégier sensations, gestes
connus et initiative concrète plutôt qu’une voix de performeuse générique. Marie
reste reconnaissable par l’action, le rythme domestique et la capacité à interrompre
une abstraction par un geste réel.

À rendre explicite : nudité, contact génital, progression vers l’acte central,
réponse corporelle, climax ou fin physique réellement située, reprise du souffle et
retombée. À garder implicite : toute métrique de performance, toute humiliation,
toute comparaison avec une autre femme, et le contenu exact des problèmes du couple
qui n’est pas connu ou résolu dans la chambre.

### 4.4 Choix, réception, conséquence et aftercare

- Choix existants : reconquête désirée ; désir sans sexe-pansement ; refus honnête.
- Réception : Marie confirme ou refuse la forme proposée ; aucune branche non
  sexuelle ne doit devenir une mauvaise récompense.
- Réaction immédiate manquante : une retombée non verbale brève doit joindre le
  centre W4 à l’aftercare, sans nouvelle réplique définitive.
- Aftercare écrit : échange matinal J12, présence ordinaire et rappel de
  responsabilité ; obligation runtime payée.
- Aftercare prévu : `#052`, `TRUST_OR_INTIMACY_REWARD`, troisième enfant de la tuile
  `Moment vécu`.
- Aftercare manquant : fichier final et prose de transition immédiate ; l’absence
  de longue discussion nocturne est volontaire, le saut sans retombée physique ne
  l’est pas.
- Fait durable autorisé : `MARIE_ADULT_RECONQUEST` a eu lieu avec consentement ; le
  désir est réel ; aucune route extérieure n’est ouverte en compensation ; aucune
  permission future n’est créée.

### 4.5 Média et consentement

`#051` est une `IMAGE_DE_SCÈNE` non diégétique, joueur uniquement, non partageable,
non découvrable et sans propriétaire dans l’histoire. Son rôle principal est
`PORNOGRAPHIC_PAYOFF`; sa classe relationnelle est `CONSENTED_PRIVATE`. Cette
classification qualifie la rencontre vécue, pas une autorisation de photographier.

## 5. Mathilde — `N7-PAY-MATHILDE-J11-045`

### 5.1 Ancrage réel

| Champ | Constat |
|---|---|
| Scène/conversation | `game/data/conversations/chapter_11_mathilde_return.json` ; ouverture, choix regard/proximité/distance, entrée physique, plafond M-B2/M-B3, après-coup. |
| Séquence | `C11-03`, parent Galerie `S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01`, séquence `MATHILDE_J11_SECRET_INTIMACY`. |
| Position relative | Après J06 regard et J10 effet choisi ; dans le pivot J11 exclusif ; avant départ vers un couchage indépendant, aftercare immédiat et conséquences J12/J16/J17. |
| Source autoritative | `NAR_ADULT_01_*` §§12–21 ; `J11_SCRIPT_*` §§13–15 ; `MATHILDE_CANON_FULL.md`. |
| Runtime | M-B3 établit un événement physique et une obligation d’aftercare, sert trois placeholders Galerie, exige le départ avant reprise du chat, puis offre trois réceptions dont une peut faire échouer l’aftercare. |

### 5.2 Progression écrite et transition manquante

Le runtime distingue déjà regard, proximité, M-B2, M-B3 et arrêt. M-B3 nomme
nudité et contact sexuel mutuel, interdit la pénétration et garantit une sortie
matérielle. Il manque le passage physique W4 qui rende cette transgression
inconfondable avec le baiser M-B2.

La révision doit :

- conserver l’initiative de Mathilde et sa validation étape par étape ;
- rendre explicite un contact sexuel mutuel non pénétratif, avec anatomie et gestes
  suffisamment précis pour établir ce qui a été accepté et vécu ;
- faire apparaître le moment où le contrôle préparé rencontre le trouble réel :
  accélération, correction, hésitation suivie d’une réaffirmation, ou arrêt ;
- préserver la possibilité d’une branche stoppée où `#045` n’est jamais servi ;
- terminer avant le retour de Marie et avant le départ effectif de Mathilde ;
- relier désir assumé, gêne, secret et responsabilité sans réduire Mathilde à
  l’interdit familial ni faire du logement une permission.

### 5.3 Crudité compatible

Crudité cible : **franche, corporelle, rapide**, avec des pointes fortes puis une
reprise de contrôle. Les euphémismes doivent diminuer ; le corps et l’intention
peuvent être nommés directement. La voix garde fragments, corrections et possible
panique courte. Le vocabulaire juridique diminue fortement pendant le centre.

À rendre explicite : déshabillage choisi, zones du corps effectivement touchées,
réciprocité, plaisir et limite non pénétrative. À garder implicite : toute pratique
non acceptée au fil de la scène, tout projet de relation, toute répétition, tout
détail concernant Marie que Mathilde n’a pas choisi de dire, et toute future
extension de la route.

### 5.4 Choix, réception, conséquence et aftercare

- Choix existants : regard seul ; proximité ; distance ; M-B3 accepté ; maintien
  M-B2 ; arrêt ; puis absence de définition, responsabilité envers Marie, ou demande
  immédiate de répétition.
- Réception : le choix M-B3 n’autorise que l’étape présente ; l’hésitation exige une
  réaffirmation, jamais une déduction.
- Réaction immédiate manquante : le centre W4 doit montrer la séparation physique et
  la récupération des vêtements/affaires avant le message d’arrivée.
- Aftercare écrit : messages après arrivée et choix MA1/MA2/MA3 ; J12 traite
  prioritairement l’échec, exclut Mathilde de la convergence et ferme la progression.
- Aftercare prévu : `#046`, `TRUST_OR_INTIMACY_REWARD`, troisième enfant Galerie ;
  comportements J12 ; départ différencié J16/J17.
- Aftercare manquant : fichier final et prose de liaison W4 ; l’absence de définition
  relationnelle est volontaire, l’absence de soin ne l’est pas.
- Fait durable autorisé : niveau M-B2 ou M-B3 exact, événement privé connu seulement
  de Mathilde/Player, aftercare `PAID` ou `FAILED`, aucune répétition ni permission.

### 5.5 Média et consentement

`#045` est une `IMAGE_DE_SCÈNE` non diégétique et non transférable. Rôle principal :
`PORNOGRAPHIC_PAYOFF`. Classe : `CONSENTED_PRIVATE`. Les vêtements, le séjour et la
familiarité familiale ne participent jamais à cette classification ; seuls
l’initiative actuelle, les validations successives et la capacité de partir la
fondent.

## 6. Sandra — `N7-PAY-SANDRA-J18-079`

### 6.1 Ancrage réel

| Champ | Constat |
|---|---|
| Scène/conversation canonique | `J18_SCRIPT_NARRATIF_COMPLET.md`, variante rare §§21–23 ; invitation, acceptation/retrait/refus, rencontre hors téléphone, après-coup. |
| Conversation runtime | `game/data/conversations/chapter_18_sandra_resolution.json` ne contient que le choix de conservation/avenir et quatre sorties standard. |
| Séquence | `C18-01` décide d’abord de l’impression/du fil ; la branche adulte remplace ensuite `C18-02` standard dans `SANDRA_J18_LATE_INTIMACY`. |
| Position relative | Après la définition provisoire du couple et la décision de représentation ; avant l’aftercare prioritaire Sandra qui doit ouvrir J19. |
| Source autoritative | `NAR_ADULT_02_*` §§3–14 ; `J18_SCRIPT_*` §§21–26 ; `SANDRA_CANON_FULL.md`; `NAR_PROD_06_*`. |
| Runtime | Aucune éligibilité adulte, aucun état `LATE_INTIMACY`, aucune transition hors téléphone, aucun parent Galerie C18-02 et aucun aftercare J19. |

### 6.2 Progression écrite et transition manquante

Le canon fixe une invitation tardive, une acceptation sans programme demandé, le
droit de retirer la proposition, la séparation et l’aftercare. La décision produit
complémentaire verrouille le centre : **rapport vaginal pénétratif consensuel,
Sandra au-dessus de Player**. Sandra reste active et tournée vers Player, contrôle
explicitement le rythme et conserve une capacité d’arrêt lisible ; Player reste
partiellement cadré et non identifiable.

La fonction principale de `#079` est `PORNOGRAPHIC_PAYOFF`. Sa fonction secondaire
est de matérialiser l’aboutissement du manque, de la confiance et de la tentation
lente. L’image saisit un moment au milieu de l’acte, jamais une pose détachée de la
relation. La révision doit :

- faire de la mise hors d’usage du téléphone une action de Sandra, pas un symbole
  décoratif ;
- montrer l’entrée interrompable de `#078`, puis le basculement physique exact qui
  autorise le rapport pénétratif et `#079` ;
- garder l’ancienne proximité, le contrôle de représentation et la précision de
  Sandra présents dans les gestes, le rythme et son orientation vers Player ;
- ne servir `#079` que si l’acte central a réellement été atteint ;
- joindre la séparation à `#080`, puis aux messages immédiats J18 et au module
  prioritaire J19 ;
- maintenir Jeff et, selon l’état du couple, Marie comme conséquences, jamais comme
  permissions indirectes.

### 6.3 Crudité compatible

Crudité cible : **progressive, précise et relationnelle**. Sandra peut devenir
explicitement sexuelle, mais sa voix et sa focalisation ne sautent pas sans
transition vers une brutalité générique. La prose doit être plus crue que ses
messages, tout en restant attentive à qui dirige, à ce qui est vu et à ce qui ne
devient pas une image.

À rendre explicite : nudité, rapport vaginal pénétratif, position de Sandra au-dessus,
contrôle du rythme, réponse de Player, plaisir et fin physique de la rencontre. À
garder implicite :
catalogue d’actes, spectacle pour une audience, détails de ce qu’elle dira à Jeff,
promesse de prochaine fois et tout consentement supposé de Jeff ou de Marie.

### 6.4 Choix, réception, conséquence et aftercare

- Choix canoniques : accepter le cadre ; demander un programme, ce qui retire la
  proposition ; refuser honnêtement. Le runtime ne les contient pas encore.
- Réception : Sandra confirme le cadre, retire sans négociation ou accepte le refus
  sans compensation ; un arrêt en rencontre limite les images à ce qui a eu lieu.
- Agence interne hors UI : ralentir, interrompre, retirer son accord, reformuler une
  limite, confirmer, continuer et réagir après l’acte restent possibles pendant la
  co-présence sans devenir de nouveaux boutons.
- Réaction immédiate : séparation, absence de regret simpliste, absence de droit
  futur et retour de la réalité Jeff/Marie.
- Aftercare écrit : après-coup immédiat J18 et module prioritaire J19 avec trois
  postures Player ; aucun projet secret commun.
- Aftercare prévu : `#080`, `TRUST_OR_INTIMACY_REWARD`, seule image adulte réutilisable
  en J19 ; une tuile `Moment vécu` C18-02 contenant uniquement les enfants servis.
- Chaîne verrouillée : `#079` seulement si l’acte central est atteint ; `#080` porte
  la sortie d’intensité et la distance ou proximité choisie ; J19 reste l’aftercare
  prioritaire.
- Aftercare manquant : toute la livraison runtime J18/J19, la Galerie et les fichiers
  finaux ; cette absence n’est pas volontaire et bloque la branche adulte propre.
- Fait durable autorisé : intimité atteinte ou arrêt exact, aucune photo sexuelle,
  aucun droit futur, décision de Sandra sur Jeff et dette éventuelle envers Marie.

### 6.5 Média et consentement

`#079` est une `IMAGE_DE_SCÈNE`, jamais une photographie diégétique. Rôle principal :
`PORNOGRAPHIC_PAYOFF`. Fonction secondaire : aboutissement du manque, de la confiance
et de la tentation lente. Classe : `CONSENTED_PRIVATE`. Le téléphone est hors d’usage.
Création d’une photo sexuelle, possession par Player, consultation par un tiers et
diffusion restent quatre actes distincts et tous absents. Toute future création non consentie relèverait de
`NON_CONSENTED_OR_DIFFUSED`, donc d’une route sombre à conséquences, jamais de ce
payoff propre.

## 7. Matrice d’aftercare consolidée

| Personnage | Écrit | Prévu | Placeholder Galerie | Manquant | Canal | Fonction | Conséquence | Absence volontaire ? |
|---|---|---|---|---|---|---|---|---|
| Marie | matin J12 ; présence ordinaire ; responsabilité maintenue | `#052` et retombée de séquence | oui, enfant 3/3 sous `MARIE_J11_RECONQUEST` | prose de liaison + fichier final | image de scène puis fil privé Marie | rendre le désir compatible avec la vie et les dettes | obligation payée ; couple non réparé | discussion nocturne longue : oui ; retombée/fichier : non |
| Mathilde | retour après départ ; MA1/MA2/MA3 ; conséquence J12 si échec | `#046`, comportements J12, départ J16/J17 | oui, enfant 3/3 sous `MATHILDE_J11_SECRET_INTIMACY` | prose de séparation + fichier final | image de scène, fil privé, puis conséquence foyer | restituer contrôle, reconnaître secret et responsabilité | `PAID` ou `FAILED`, progression ouverte/fermée, départ différencié | absence de définition : oui ; absence de soin : non |
| Sandra | canon J18 immédiat + priorité J19 | `#080`, réutilisable seule en J19 | non dans le runtime J18 | branche, messages, état, Galerie et fichier final | image de scène puis fil privé Sandra sur deux séquences | rendre l’intimité compatible avec contrôle, Jeff et aucune prochaine fois | recul, silence, dette sombre ou limite ; aucune progression J19 | non |

## 8. Garde des images et des audiences

| Situation | Classe | Traitement |
|---|---|---|
| Rencontre vécue Marie/Mathilde/Sandra, image de scène joueur uniquement | `CONSENTED_PRIVATE` | Galerie mémoire possible après service, jamais fichier diégétique. |
| Média explicitement destiné à un groupe ou canal légitime | `CONSENTED_SHARED` | Respect strict de l’audience et de la source. |
| Média dont la consultation n’est pas établie | `AMBIGUOUS_SEEN_NOT_SEEN` | Ne pas écrire la connaissance comme certaine ; conserver l’ambiguïté. |
| Capture, copie, possession ou diffusion non autorisée | `NON_CONSENTED_OR_DIFFUSED` | Route sombre, conséquences, retrait/inaccessibilité ; jamais récompense relationnelle propre. |

Les trois payoffs N7 appartiennent à la première ligne. Leur intensité W4 n’élargit
jamais audience, sauvegarde, consultation, transfert ou permission future.

## 9. Gates communs avant écriture définitive

- Les trois révisions restent dans `C11-06`, `C11-03` et `C18-02`.
- Une seule variante principale J11 est vécue ; C18-02 adulte remplace la standard.
- Le centre W4 contient une action sexuelle concrète, pas seulement nudité ou
  métaphore, et n’est pas un catalogue.
- Le personnage concerné initie ou co-initie et reste capable d’arrêter.
- Le texte n’invente aucun dialogue oral de co-présence.
- Le refus et l’arrêt ont une sortie complète sans image centrale ni punition.
- L’aftercare et la mémoire sont servis selon ce qui a réellement eu lieu.
- Aucun centre de scène ne devient photo, preuve ou permission.
- Les trois voix restent distinguables sans nom.
- Les trois payoffs sont `READY_FOR_SCRIPTING` ; aucun droit futur, aucune promesse
  de répétition et aucune route automatique ne découle de leur centre W4.
