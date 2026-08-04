# R8C-N4 — Audit du placement exact Saison 1 — Sandra — Les chaises bleues

> **Catégorie :** audit documentaire de placement absolu
>
> **Périmètre :** Saison 1 réellement présente sur la baseline, scène N2
> `CANON_APPROVED`, contraintes relatives N3
>
> **Baseline obligatoire :** `6511e79254bd5c886a608452915df60f602420cb`
>
> **Parent exact :** `608dd7a37274e1c8a0670608ba55984dead8b8ce`
>
> **Tag stable :** `r8c-n3-sandra-blue-chairs-canonical-placement`
>
> **Nature du lot :** documentation uniquement ; aucune intégration

## Décision

`EXACT_PLACEMENT_RECOMMENDED`

Dans la Saison 1 actuellement signée et exécutée, **Sandra — Les chaises
bleues** possède un emplacement exact narrativement sain :

```text
J04 — vendredi — fin d’après-midi
après chapter_04_nico_saved_seat_followup, terminé à 14:09
avant chapter_04_marie_household_report, ouvert à 18:05
fenêtre de présentation recommandée : 16:30–18:04
```

Ce placement est une décision de séquence, pas une donnée exécutable. L’heure
de début `16:30` est une borne conceptuelle `not_before`; N2 ne possède pas de
timestamps ni de durée de lecture validée. Une future intégration devra mesurer
et authorer sa durée avant de produire un plan A9.

La recommandation est conditionnelle à l’éligibilité N3 et à une incompatibilité
de répétition : si **Les chaises bleues** est proposée en J04, la continuité
Sandra J05 `chapter_05_sandra_photo_continuity` ne doit pas être proposée. Elle
se ferme silencieusement, sans absence narrative, sans `MISSED` et sans effet
relationnel. Cette règle évite deux relances Sandra fondées sur une photographie
à moins d’une journée d’intervalle. Elle ne supprime ni ne réécrit la scène J05
existante dans le présent lot.

## Méthode d’autorité

L’audit sépare la cible canonique R8C, le corpus signé, l’exécution actuelle et
les matériaux historiques. Le contrat réconcilié R8C précise que les jours
J01–J21 sont des références du corpus et du runtime existants, non une promesse
que le futur moteur conservera vingt-et-un jours fixes. Le présent lot peut donc
fixer l’emplacement exact dans la **Saison 1 actuelle** sans transformer ce
calendrier en règle générale du futur moteur.

### Sources d’autorité et informations retenues

| Chemin vérifié | Statut utilisé dans cet audit | Information retenue |
| --- | --- | --- |
| `docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md` | `ACTIVE_CANON`, gouvernance | Le canon narratif prime ; le code, les données et les tests de la baseline font autorité sur l’exécution ; les anciens documents racine et `docs/narrative/` sont historiques par défaut sauf décision bornée explicite. |
| `docs/canon/DOCUMENTATION_READING_ORDER.md` | portail canonique actif | Ordre de lecture ; scripts signés comme oracle de comportement ; runtime comme oracle exécutable temporaire ; V0.xx sans autorité. |
| `docs/canon/bible/14_CONTRAT_NARRATIF_SAISON_1_RECONCILIE.md` | `ACTIVE_CANON`, contrat R8C le plus récent | Actes souples, scènes modulaires, rythme sans quota ; J01–J21 restent des références actuelles, pas la topologie obligatoire du futur moteur ; `04`, `07` et `08` demandent adaptation ou réécriture pour R8C. |
| `docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md` | canon signé du corpus existant | J01–J21, registres, voix, continuité et limites sont signés ; Marie reste l’axe ; Sandra est une relation ancienne, prudente, contrôlant ses images. |
| `docs/canon/characters/SANDRA_CANON_FULL.md` | canon personnage actif | Sandra relance par une trace concrète, vérifie si elle est lue correctement, garde le contrôle de l’image et ferme elle-même l’accès ; ses émojis restent rares. |
| `docs/canon/dialogues/J01_J06_SOURCE_CANON_CONSOLIDE.md` | canon signé J01–J06 | J01 réactive Sandra par la photo du dernier déjeuner ; J03 maintient un écho ; J05 est la première continuité extérieure optionnelle ; Sandra reste légère à l’entrée de J07. |
| `docs/canon/dialogues/J01_J21_TRACE_REGISTRY.md` | registre canon actif | `j01_sandra_lunch_memory_soft` existe dès J01, appartient à Sandra, est visible par Player et ne peut être transférée ; aucune trace « chaises bleues » n’existe. |
| `docs/canon/dialogues/J01_J21_KNOWLEDGE_REGISTRY.md` | registre canon actif | `fact_sandra_preexisting_friendship` et `fact_player_saw_sandra_lunch_photo` rendent disponibles l’ancienneté du lien et le souvenir partagé. |
| `docs/canon/dialogues/J01_J21_PROMISE_REGISTRY.md` et `docs/canon/dialogues/J01_J21_REACHABILITY_MATRIX.md` | registres canoniques actifs | Le prochain café daté n’apparaît qu’en J10, avec une branche samedi ensuite confirmée ou expirée ; avant J10, aucun nouveau déjeuner n’est acquis. |
| `game/data/conversations/chapter_01_sandra_trace.json` | `ACTIVE_RUNTIME`, contenu réellement joué | J01 22:57–23:12 : Sandra réouvre le fil par la photo du dernier déjeuner, Player reçoit son geste, Sandra pose une limite et ferme elle-même. |
| `game/data/conversations/chapter_03_sandra_continuity.json` | `ACTIVE_RUNTIME` | J03 13:50–13:53 : bref échange complice sur le bouton SentryCore, sans photo, promesse ni progression. Il est le dernier contact Sandra avant la fenêtre recommandée. |
| `game/data/runtime/season_1/j04_runtime_map.json` et les quatre conversations `chapter_04_*` | `ACTIVE_RUNTIME`, ordre et heures exacts | J04 : Pauline 08:35–08:40, Nico 14:05–14:09, Marie 18:05–18:06, Mathilde 18:07–18:08, retour foyer à 18:25. Le seul intervalle sain est après Nico et avant Marie. |
| `game/data/conversations/chapter_05_sandra_photo_continuity.json`, `game/data/runtime/season_1/j05_runtime_map.json`, `game/scripts/runtime/season_1/J05RuntimeProvider.gd` et `game/scripts/runtime/season_1/Season1State.gd` | `ACTIVE_RUNTIME` | J05 20:40–20:47 réutilise obligatoirement la photo J01 quand Marie a été payée, Sandra est `RECONNECTION_OPEN` et la trace est active ; ses branches peuvent maintenir, borner, refroidir ou fermer la continuité. |
| `game/data/conversations/chapter_10_sandra_cafe.json` et `chapter_11_sandra_image.json` | `ACTIVE_RUNTIME` | J10 réalise, reprogramme ou ferme le café ; J11 est déjà une progression d’image choisie plus avancée. Tout placement à partir de ces scènes est rétrograde ou contradictoire. |
| `game/data/runtime/season_1/j01_runtime_map.json` à `j11_runtime_map.json` | `ACTIVE_RUNTIME` | Chronologie, moments, ordre auteur, densité et médias proches réellement présents sur la baseline. |
| `docs/canon/bible/11_DISTRIBUTION_SEQUENCES_SCENES_IMAGES_CONSEQUENCES_JOURNEES.md` | plan canonique ancien, **contradictoire sur l’état runtime** | Retenue seulement après vérification runtime : J04 est une journée riche sans bascule, J05 normale, J08/J09 riches ; son affirmation que J05–J21 ne sont pas automatiquement jouables est obsolète. |
| `docs/canon/bible/12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md` | historique/contradictoire | Utilisé uniquement comme provenance de densité et de fonction ; ses affirmations « J07–J08 non jouables » et « J05 sans Sandra » ne décrivent plus la baseline. |
| `docs/architecture/R8C_A8_FENETRES_OPPORTUNITE_ET_CONFLITS_EXCLUSIFS.md` | `IMPLEMENTED_PROTOTYPE_NON_CANONIQUE` | Sémantique conceptuelle des fenêtres, revalidation et `CLOSE_SILENTLY`; un candidat jamais proposé ne devient pas une absence. Aucun contenu Saison 1 n’y existe. |
| `docs/architecture/R8C_A9_COMPOSITION_CONTROLEE_CRENEAU_NARRATIF.md` | `IMPLEMENTED_PROTOTYPE_NON_CANONIQUE` | Sémantique conceptuelle du créneau, moment diégétique, durée, bornes et ordre auteur ; A9 ne choisit ni fenêtre ni ordre. Aucun slot Saison 1 n’y existe. |
| `docs/narrative/R8C_N1_CANON_REVIEW_SANDRA_BLUE_CHAIRS.md` | décision bornée N1, historique après N2 | Conditions d’entrée, changement maximal et révisions obligatoires alors demandées. N2 a satisfait la gate ; N1 ne fournit aucun jour. |
| `docs/narrative/R8C_N2_SANDRA_BLUE_CHAIRS_MINOR_NARRATIVE_REVISION.md` et `narrative_tool/a11/revisions/sandra_blue_chairs_r8c_n2.*` | contenu narratif `CANON_APPROVED`, verrouillé | Source exacte : 96 éléments stockés, 89 ou 90 par parcours, sept battements, un choix à deux options, `😅`, `🙂`, photo requise, déjeuner seulement possible après le week-end, aucun effet durable actif. |
| `docs/narrative/R8C_N3_SANDRA_BLUE_CHAIRS_CANONICAL_PLACEMENT.md` | décision canonique bornée active pour cette scène | Placement relatif, unicité, conditions négatives, fonctions des émojis, média conceptuel et trace potentielle ; aucun jour n’y était fixé. |
| `docs/CURRENT_NARRATIVE_SOURCE_OF_TRUTH.md` | `HISTORICAL`, explicitement déclaré | Non utilisé pour décider le placement. Son ancien avertissement J4+ est incompatible avec la chaîne runtime actuelle J01–J21. |
| `game/assets/visual_content/` et `game/data/visual_content/` | état média réellement présent | Aucun asset de terrasse, café ou chaises bleues n’existe ; seuls des visuels Sandra V0.96 sans rapport ont été trouvés. |

## État Sandra avant J04 16:30

| Condition | Preuve actuelle | Verdict |
| --- | --- | --- |
| Reprise de contact Sandra | J01 : Sandra initie avec la photo du dernier déjeuner. | Satisfaite. |
| Complicité retrouvée | J01 réinstalle l’humour et J03 produit un écho bref, partagé et non progressif. | Satisfaite sur tous les parcours atteignant J04. |
| Souvenir ou déjeuner récent | La trace J01 et `fact_player_saw_sandra_lunch_photo` rendent le dernier déjeuner disponible aux deux participants. | Satisfaite comme souvenir partagé ; aucun nouveau déjeuner n’est inventé. |
| Ambiguïté légère reçue | J01 fait recevoir à Player une photo choisie et bornée ; les réponses chaude, précise ou prudente sont toutes reconnues par Sandra, puis le geste est refermé « sans conséquence ». | Satisfaite sans réciprocité acquise. |
| Petit silence | Dernier message Sandra J03 à 13:53 ; fenêtre N4 à partir de J04 16:30. | Satisfaite : plus d’une journée, sans rupture. |
| Aucun refus ou conflit actif | J01 ferme doucement ; J03 ne crée ni refus, ni promesse, ni conflit. J04 n’ajoute aucun conflit Sandra. | Satisfaite. |
| Aucun déjeuner déjà convenu | J01 ne contient qu’un ancien déjeuner ; la première proposition datable arrive en J10. | Satisfaite. |
| Aucune progression Sandra plus avancée | J05, J10 et J11 ne se sont pas encore produits. | Satisfaite. |

Le texte N2 renforce aussi l’ancrage calendaire : « pas cette semaine » puis
« je regarde après le week-end » est naturel le vendredi J04, acceptable le
samedi J05, et de plus en plus contradictoire à partir du lundi J07.

## Placements candidats

Les catégories sont qualitatives ; aucun score ou ranking numérique n’est
utilisé.

### J02 — après l’arrivée de Mathilde, avant J03 Raphaëlle

**Classement : `INCOMPATIBLE`**

- **Scène précédente :** fin de `chapter_02_mathilde_arrival` et retour foyer.
- **Scène suivante :** `chapter_03_raphaelle_blue_folder`.
- **Faits disponibles :** reprise J01, photo du déjeuner, ambiguïté bornée.
- **Conditions manquantes :** la complicité n’a pas encore reçu l’écho J03 et le
  silence reste trop court pour justifier « ça faisait un moment ».
- **Conflits :** « après le week-end » ne correspond pas à un mercredi ; Sandra
  reviendrait dès le lendemain de sa longue scène J01.
- **Coût narratif :** répétition immédiate de la réouverture et concurrence avec
  l’installation de Mathilde.
- **Effets d’arcs :** Sandra accélère ; Marie et Mathilde perdent la respiration
  nécessaire à la transformation du foyer.

### J03 — après l’écho Sandra, avant le retour Marie

**Classement : `INCOMPATIBLE`**

- **Scène précédente :** `chapter_03_sandra_continuity`, fin à 13:53.
- **Scène suivante :** `chapter_03_marie_evening_return`, à partir de 18:20.
- **Faits disponibles :** reprise, souvenir et complicité sont lisibles.
- **Condition manquante :** aucun petit silence ne suit la reprise : les deux
  scènes Sandra auraient lieu le même jour.
- **Conflits :** une relance de 89/90 éléments transformerait l’écho bref J03 en
  double foreground Sandra et comprimerait Raphaëlle puis le recentrage Marie.
- **Coût narratif :** élevé ; l’écho n’aurait plus sa fonction de respiration.
- **Effets d’arcs :** Sandra prend le pivot à Raphaëlle et réduit la présence
  active de Marie en fin de journée.

### J04 — après Nico, avant Marie

**Classement : `RECOMMENDED`**

- **Scène précédente :** `chapter_04_nico_saved_seat_followup`, dernier message
  à 14:09.
- **Scène suivante :** `chapter_04_marie_household_report`, premier message à
  18:05, puis correction Mathilde à 18:07 et retour physique au foyer à 18:25.
- **Faits disponibles :** toutes les conditions N3 sont établies par J01 et J03.
- **Conditions manquantes :** aucune condition narrative ; seules la durée A9
  et la production du média restent à authorer avant intégration.
- **Conflits :** collision lexicale avec la chaise de Nico ; photographie
  publique Pauline le matin ; répétition photographique Sandra avec J05 si les
  deux scènes sont proposées.
- **Traitement des conflits :** séparation horaire et fonctionnelle pour Nico et
  Pauline ; incompatibilité silencieuse avec la scène Sandra J05.
- **Coût narratif :** une longue scène supplémentaire dans une journée déjà
  riche. Ce coût reste acceptable uniquement comme fenêtre conditionnelle,
  jamais comme cinquième pivot obligatoire de tous les parcours.
- **Effets d’arcs :** Sandra obtient une réouverture intermédiaire ; Marie
  reprend immédiatement le centre par le rapport du foyer et le retour hors
  téléphone ; Mathilde reste une présence domestique ordinaire ; Pauline et
  Nico gardent leurs fonctions d’introduction sociale.

### J05 — après l’heure Marie, avant la continuité Sandra existante

**Classement : `POSSIBLE_WITH_REWORK`**

- **Scène précédente :** `chapter_05_marie_shared_hour` et sa résolution.
- **Scène suivante :** `chapter_05_sandra_photo_continuity`, 20:40–20:47, si
  elle est éligible.
- **Faits disponibles :** les prérequis Sandra sont présents et le vocabulaire
  du week-end reste possible.
- **Conditions manquantes :** aucune sur le lien, mais aucune respiration ne
  sépare deux scènes Sandra photographiques le même soir.
- **Conflits :** deux photos, deux discussions sur le dernier déjeuner, deux
  limites et deux choix Sandra dans une même séquence ; la scène existante J05
  peut ensuite refroidir ou fermer ce que N2 vient de rouvrir.
- **Coût narratif :** réécriture de la composition J05 ou exclusion de la scène
  existante ; densité et agence surchargées.
- **Effets d’arcs :** Marie vient d’obtenir l’heure réelle, mais deux scènes
  Sandra successives déplaceraient immédiatement le centre ; Mathilde et les
  autres lignes perdraient leur respiration.

### J06 — dimanche, seulement si Sandra J05 n’a pas été proposée

**Classement : `INSUFFICIENT_EVIDENCE`**

- **Scène précédente plausible :** `chapter_06_mathilde_morning_afterglow`.
- **Scène suivante plausible :** `chapter_06_marie_concrete_return` en soirée.
- **Faits disponibles :** souvenir J01, écho J03 et silence suffisant si J05
  Sandra n’a pas eu lieu ; le texte « après le week-end » reste temporellement
  possible.
- **Conditions manquantes :** aucun déclencheur actuel ne rend N2 disponible
  sans que son apparition compense précisément une inéligibilité J05.
- **Conflits :** dans le runtime, l’absence de Sandra J05 peut découler du refus
  de l’heure Marie. Proposer alors N2 risquerait de devenir une récompense de
  substitution et ferait deux progressions extérieures avec Mathilde.
- **Coût narratif :** nouvelles règles d’éligibilité et de non-compensation.
- **Effets d’arcs :** risque de minorer Marie et de transformer Sandra en contenu
  de remplacement ; aucun bénéfice supérieur à J04 n’est démontré.

### J07 à J09 — après le week-end, avant le café J10

**Classement : `INCOMPATIBLE`**

- **Scènes précédentes/suivantes :** J07 Raphaëlle/Nico/Marie ; J08 collision
  d’obligations ; J09 journée Marie à La Verrière ; puis J10 Sandra.
- **Faits disponibles :** la continuité Sandra peut rester ouverte selon J05.
- **Conditions manquantes :** sur plusieurs branches J05 a déjà produit une
  limite, un refroidissement ou une fermeture ; le petit silence n’est plus
  garanti uniformément.
- **Conflits :** « je regarde après le week-end » est déjà dépassé ; J07–J09
  possèdent leurs propres pivots et conséquences ; J09 doit rester centrée sur
  l’autonomie de Marie.
- **Coût narratif :** raccords conditionnels multiples et calendrier réécrit.
- **Effets d’arcs :** Sandra concurrence Nico, les obligations ou Marie ; le
  pont vers J10 devient trop tardif et artificiel.

### J10 avant le café, puis J10 et au-delà

**Classement : `INCOMPATIBLE`**

- **Scène précédente avant J10 Sandra :** obligations Marie/Nico du matin ;
  **scène suivante :** `chapter_10_sandra_cafe` à 12:21.
- **Faits disponibles :** une ligne Sandra existe, mais elle dépend déjà des
  branches J05.
- **Conditions manquantes avant 12:21 :** le calendrier interne N2 est dépassé
  et aucune respiration saine ne sépare N2 du café proposé le même jour.
- **Conflits à partir de 12:21 :** le café est tenu, reprogrammé ou fermé ; J11
  envoie ensuite une image choisie plus avancée. Un placement ultérieur viole
  explicitement N3 : déjeuner acquis/tenu, refus possible ou progression plus
  avancée.
- **Coût narratif :** rétrogradation de Sandra et contradiction des promesses,
  traces et résolutions jusqu’à J21.
- **Effets d’arcs :** déstabilisation de la convergence, des conséquences Marie
  et des autres routes ; aucun placement tardif n’est défendable.

## `PLAYER_AGENCY_REVIEW`

### Choix disponibles dans la séquence J04 recommandée

Avant la fenêtre N4, J04 propose déjà un positionnement sur la sélection
publique Pauline puis un positionnement d’amitié avec Nico. Après N4, Marie et
Mathilde envoient des échos automatiques et le retour au foyer se déroule hors
téléphone.

N2 conserve un seul vrai choix :

- `careful_warmth` — reconnaître prudemment que l’échange a manqué ;
- `ironic_withdrawal` — déplacer l’aveu vers les agendas sans l’effacer.

Les deux options ont des réceptions distinctes, convergent à `m53`, respectent
la limite et n’établissent ni option optimale ni rendez-vous. Le choix sert à
définir **comment** Player rend l’importance du contact lisible, pas à choisir
Sandra, un niveau d’intimité ou une route.

### Risques

Le risque de passivité est réel : 46 messages précèdent le choix, puis une
longue convergence suit sa réception. Il est atténué par les répliques Player
présentes dans le texte et par la différence claire des deux postures, mais il
devra être vérifié en lecture mobile lors d’un futur lot d’intégration.

Ajouter un second choix surchargerait la scène, brouillerait la fermeture
protectrice de Sandra et modifierait le contenu N2 verrouillé. Aucun ajout n’est
recommandé. Aucun quota de choix n’est appliqué. La présentation conditionnelle
A8 ne doit pas être confondue avec un choix de route offert au joueur.

## `EMOJI_FUNCTION_REVIEW`

- `m04` — `😅` transforme « je deviens vieille » en autodérision et protège une
  gêne légère dès l’ouverture. Il ne marque ni consentement ni disponibilité.
- `m93` — `🙂` ferme chaleureusement après la limite et le « sans promesse » ;
  il confirme la retenue, pas une progression supplémentaire.

Dans les scènes proches réellement jouées, J01 contient un seul `🙂` dans sa
fermeture, J03 n’utilise aucun émoji et J05 n’en utilise aucun. Au placement J04,
la séquence Sandra devient donc : fermeture J01 avec `🙂`, écho J03 sans émoji,
N2 avec `😅` puis `🙂`, et éventuelle J05 fermée silencieusement si N2 a été
proposée. Les deux émojis N2 ont des fonctions différentes et encadrent la scène ;
ils ne forment pas une répétition décorative. Aucun ajout ou retrait n’est
recommandé.

## Média

Le média `photo_sandra_cafe_blue_chairs` est temporellement compatible avec J04 :
Sandra peut être passée près du café plus tôt le vendredi et envoyer ensuite la
photo en fin d’après-midi. Le sujet reste la terrasse et les chaises, sans Sandra
clairement visible, sans érotisation et sans nouvelle audience.

Les collisions proches sont :

- le set public Pauline à 08:36, séparé par plusieurs heures, autre source,
  autre audience et autre fonction ;
- la « chaise qui ne penche pas » de Nico à 14:05, répétition lexicale visible
  mais non confusion de média ;
- la photo J01 réutilisée par J05, collision fonctionnelle qui impose la
  fermeture silencieuse de cette scène lorsque N2 est proposée.

Aucun fichier correspondant n’existe dans `game/assets/visual_content/` ni dans
les manifestes `game/data/visual_content/`. L’image est causale dès `m01` et ne
peut pas être remplacée par du texte. Un asset final — ou une décision explicite
de placeholder de production — est requis avant toute intégration jouable.

La recommandation est **conversation seulement**. Aucun déblocage Galerie ne
doit accompagner la réception. Une future présence Galerie exigerait une
décision distincte sur propriétaire, audience, conservation et retrait ; le
concept actuel d’une terrasse sans portrait ne la justifie pas.

## Fenêtre A8 conceptuelle

Cette description n’est ni un identifiant exécutable ni une donnée Saison 1.

- **Fonction :** rendre N2 éligible une fois, après l’écho J03 et avant toute
  continuité Sandra J05.
- **Ouverture :** J04 après la fin effective de la scène Nico à 14:09, avec
  `not_before` recommandé à 16:30 pour préserver une vraie respiration.
- **Expiration :** au plus tard à 18:04, avant le premier message Marie à 18:05.
- **Préconditions :** reprise J01, trace/souvenir J01 disponibles, écho J03
  achevé, Sandra encore ouverte, aucun conflit/refus/demande de distance, aucun
  nouveau déjeuner convenu, scène unique jamais instanciée.
- **Incompatibilités :** Sandra fermée ou refroidie, trace/souvenir indisponible
  comme fait, autre scène Sandra proposée dans le même voisinage, durée ne
  tenant pas avant Marie, média indisponible selon la politique de production.
- **Politique de fermeture :** `CLOSE_SILENTLY` pour un candidat jamais proposé
  ou seulement réservé. Aucun `MISSED`, aucune absence, aucune mutation A1 et
  aucun message compensatoire. Une fois réellement proposée, la scène doit
  rester jouable dans la séquence authorée ; aucune conséquence de rendez-vous
  manqué n’est définie par N1–N3.
- **Exclusivité aval :** si N2 a été proposée/résolue, la continuité photo Sandra
  J05 devient inéligible avant proposition et se ferme silencieusement. Si N2
  n’a jamais été proposée, J05 conserve son comportement actuel.

## Créneau A9 conceptuel

- **Jour :** J04, vendredi.
- **Moment diégétique :** `LATE_AFTERNOON`.
- **Bornes du créneau :** 16:30–18:04, à l’intérieur du vide runtime
  14:10–18:04.
- **Ordre auteur complet préservé :** Pauline → Nico → **Les chaises bleues** →
  Marie → Mathilde → retour hors téléphone au foyer.
- **Scène précédente :** `chapter_04_nico_saved_seat_followup`.
- **Scène suivante :** `chapter_04_marie_household_report`.
- **Conflits de créneau :** durée N2 non encore authorée ; fin dure avant 18:05 ;
  aucun chevauchement avec Marie/Mathilde ; aucune permutation automatique ;
  aucune seconde fenêtre Sandra ou média relationnel similaire dans ce créneau.
- **Règle de composition :** A9 reçoit la fenêtre déjà choisie et l’ordre
  explicite ; il ne sélectionne pas N2 et ne la déplace pas. Si la durée mesurée
  ne tient pas, le plan entier est refusé plutôt que de repousser Marie.

## Placement fixé et conséquences

| Élément | Décision N4 |
| --- | --- |
| Jour/séquence | J04 vendredi, fin d’après-midi, après Nico et avant Marie. |
| Prérequis | J01 réouvert et reçu ; J03 achevé ; petit silence ; souvenir du déjeuner disponible ; aucun refus, conflit, déjeuner acquis ou progression avancée. |
| Incompatibilités | Toute fermeture Sandra ; scène J05 Sandra si N2 a été proposée ; durée empiétant sur 18:05 ; média causal indisponible sans politique explicite. |
| Fenêtre A8 | Ouverture après 14:09, `not_before` 16:30, expiration 18:04, fermeture silencieuse avant proposition. |
| Créneau A9 | J04 `LATE_AFTERNOON`, 16:30–18:04, ordre Nico → N2 → Marie. |
| Agence | Un choix de positionnement suffit ; risque de passivité à tester ; aucun choix ajouté. |
| Média | Photo requise, asset absent, conversation seulement, aucune Galerie automatique. |
| Trace potentielle | `Sandra a reçu et compris que la reprise du contact compte pour Player.` Elle reste non créée et exige un lot distinct. |
| Effet Marie | Recentrage immédiat à 18:05 puis retour physique au foyer ; Marie reste hors du dialogue N2 mais non hors de la séquence. |

## Futurs fichiers probablement touchés — sans autorisation d’intégration

Un futur lot distinct devrait probablement toucher :

- une définition A6 canonique nouvelle pour la scène N2, son unicité et ses
  incompatibilités ;
- le futur constructeur de journée ou l’orchestration J04 qui ouvrira la
  fenêtre A8 et fournira le slot A9 ;
- l’éligibilité/orchestration J05 afin de fermer silencieusement
  `chapter_05_sandra_photo_continuity` lorsque N2 a été proposée ;
- la donnée de conversation/runtime J04 et ses tests ciblés ;
- un manifeste média et l’asset final `photo_sandra_cafe_blue_chairs` ;
- éventuellement A1/registre de trace, seulement après une décision séparée
  autorisant la trace potentielle.

Cette liste décrit un impact probable. Elle n’autorise aucune modification de
ces fichiers, aucun export A6, aucun branchement runtime, aucun asset et aucun
lot d’intégration.

## Périmètre confirmé

Le présent lot ne modifie aucun dialogue, artefact A11.5/N1/N2/N3, fichier
`game/`, donnée Saison 1, A1–A10, A6, runtime ou média. Il ne crée aucun test,
outil, fait, événement, trace active, fenêtre A8, créneau A9 ou asset.

`EXACT_PLACEMENT_RECOMMENDED`
