# Season 1 Dramatic Scene Idea Bank

> **Catégorie :** `CREATIVE_IDEA_BANK`
>
> **Statut documentaire :** `NON_CANONICAL`
>
> **Périmètre :** réservoir créatif de payoffs futurs, scènes modulaires et
> hypothèses de montée dramatique pour la Saison 1
>
> **Autorité :** aucune. Ce document ne modifie ni le canon, ni la chronologie,
> ni les routes, ni les contrats verrouillés, ni le runtime.
>
> **Baseline de création :**
> `24e59389d163fdcc13a0d8f2a25d6b5259c634c7`
> (`OPENING_ARC_SANDRA_PHOTO_RECONNECTION_LOCKED`)

## 1. Usage et frontière d'autorité

Cette banque conserve des concepts de scènes validés comme **candidats à
explorer**, sans promettre leur présence dans le jeu. Elle sert à :

- garder à portée les payoffs futurs envisagés ;
- vérifier que les scènes d'ouverture sèment des préconditions naturelles ;
- comparer des variantes avant toute décision canonique ;
- calibrer la montée dramatique et l'intensité sans accélération artificielle.

Elle ne doit jamais être utilisée comme source directe pour écrire ou modifier
un JSON narratif, une route, un calendrier, un état runtime ou un test. En cas
de contradiction, les blueprints, le canon, les scripts signés, les contrats
verrouillés et la baseline exécutable concernée prévalent toujours.

Une idée de cette banque ne devient plan de production qu'après une décision
éditoriale séparée, une vérification de compatibilité avec toutes les autorités
actives et une promotion explicite dans la documentation canonique appropriée.

## 2. Statuts

- `VALIDATED_CONCEPT` : concept retenu comme piste créative valable ; placement,
  résultat, participants et forme finale restent ouverts.
- `OPTIONAL_VARIANT` : permutation ou modalité possible, à utiliser seulement si
  elle respecte le personnage, l'état relationnel et les conséquences établies.
- `PROMOTED_TO_CANON_PLAN` : réservé à une décision future formelle. **Aucune idée
  de ce document ne possède actuellement ce statut.**

## 3. Doctrine d'identité et de modularité

Certaines scènes sont **identitaires** : leur sens dépend d'un personnage précis,
de sa voix, de son histoire et d'une relation déterminée. D'autres sont des
**templates relationnels modulaires** : leur mécanique peut être réemployée dans
plusieurs relations, mais jamais par simple remplacement de nom.

L'interchangeabilité ne doit jamais ignorer :

- la voix et les limites propres au personnage ;
- l'état exact de la relation au moment de la scène ;
- les informations que chaque personne possède réellement ;
- le consentement local, explicite, retirable et non déduit d'une scène passée ;
- la responsabilité, l'après-scène et les conséquences durables possibles.

Une variante n'est éligible que si elle paraît naturelle pour les participants
et si les semis nécessaires existent déjà. Une scène identitaire ne doit pas
être aplatie en template ; un template ne doit pas créer rétroactivement un trait
de personnage ou une permission permanente.

## 4. Échelle d'intensité 1–6

| Niveau | Fonction dramatique | Limite indicative |
|---|---|---|
| 1 | Curiosité | détail remarqué, confort légèrement déplacé, aucune pression |
| 2 | Jeu ou sous-entendu | attention choisie, flirt léger, possibilité claire de retrait |
| 3 | Ambiguïté personnelle | gêne ou attirance reconnue, intimité encore réversible |
| 4 | Opportunité engagée | choix actif, risque de trace ou de secret, limites verbalisées |
| 5 | Secret ou incompatibilité | loyautés en tension, information cachée, après-scène nécessaire |
| 6 | Conséquence relationnelle forte | confiance, couple ou réseau durablement reconfiguré |

Le niveau décrit le **poids dramatique maximal possible**, pas une obligation de
contenu explicite. Toute escalade reste conditionnée par l'éligibilité narrative
et le consentement de la scène.

## 5. Courbe cible

```text
confort → curiosité → friction → attention → ambiguïté → opportunité
→ incompatibilité → secret → conséquence
```

Cette courbe guide la préparation, pas un ordre mécanique imposé à chaque route.
Une scène d'ouverture doit surtout installer du confort, de la curiosité, une
friction lisible ou une attention nouvelle. Les payoffs avancés ne sont naturels
que si les étapes relationnelles utiles ont été vécues et interprétées.

## 6. Scénarios candidats

### 6.1 Photo compromettante ou ambiguë envoyée volontairement ou « par erreur »

**Statut :** `VALIDATED_CONCEPT`

**Nature :** template relationnel modulaire

**Intensité possible :** 2–4

- **Concept :** une image plus personnelle que prévu crée gêne, attention et
  intimité ; l'incertitude porte sur l'intention réelle et sur la réponse.
- **Personnages compatibles / variantes interchangeables :** tout duo adulte dont
  la relation autorise déjà un échange personnel. `OPTIONAL_VARIANT` : envoi
  volontaire camouflé, véritable erreur, ou ambiguïté laissée sans explication.
- **Préconditions relationnelles :** canal privé établi, confiance minimale,
  raisons crédibles d'échanger des images et limites déjà observables.
- **Potentiel média :** image, miniature, suppression, accusé de lecture, capture
  ou souvenir durable selon les permissions canoniques.
- **Conséquences possibles :** complicité, malaise, recul, clarification, secret
  partagé ou future réinterprétation.
- **Garde-fous / consentement :** ne pas traiter l'absence de refus comme accord ;
  permettre une sortie sans humiliation ; ne pas redistribuer l'image sans
  permission distincte.
- **Semis en amont :** habitudes d'envoi, tonalité de flirt, rapport du personnage
  à l'image, règle de confidentialité et premier signe d'attention réciproque.

### 6.2 Complicité voyeuriste et demandes progressives de photos

**Statut :** `VALIDATED_CONCEPT`

**Nature :** template à forte dépendance de voix

**Intensité possible :** 2–5

- **Concept :** Nico ou Pauline demande progressivement au Player des photos de
  Marie ou Mathilde ; le jeu évolue vers une négociation de photos en retour.
- **Personnages compatibles / variantes interchangeables :** Nico ou Pauline comme
  complice principal ; Marie ou Mathilde comme sujet seulement si leurs limites
  et les droits sur les médias le permettent. `OPTIONAL_VARIANT` : curiosité,
  défi, échange réciproque ou retrait avant escalade.
- **Préconditions relationnelles :** confiance avec le complice, langage commun
  sur les limites, médias légitimement détenus et intérêt jamais présumé du sujet.
- **Potentiel média :** sélection progressive public → personnel → privé, aperçu,
  retour négocié et trace de la demande.
- **Conséquences possibles :** complicité, dette, jalousie, exposition du secret,
  arrêt du jeu ou redéfinition des limites du couple.
- **Garde-fous / consentement :** propriété d'un fichier ne vaut pas permission de
  partage ; consentement distinct du sujet et des destinataires ; aucune pression
  par dette, défi ou excitation collective.
- **Semis en amont :** goût du complice pour les confidences, échange d'images
  bénignes, règle explicite de non-diffusion et capacité démontrée à accepter non.

### 6.3 Nico confident et facilitateur de fantasmes consentis

**Statut :** `VALIDATED_CONCEPT`

**Nature :** branche identitaire Nico

**Intensité possible :** 3–6

- **Concept :** Nico devient un confident ou facilitateur possible pour des
  fantasmes de trio, quatuor ou NTR consenti, selon l'évolution réellement vécue.
- **Personnages compatibles / variantes interchangeables :** Nico reste le pivot
  identitaire. `OPTIONAL_VARIANT` : écoute sans participation, mise en relation,
  médiation des limites, participation envisagée puis refusée.
- **Préconditions relationnelles :** confiance éprouvée, confidentialité tenue,
  vocabulaire partagé sur le fantasme et distinction claire entre parler, vouloir
  et consentir à une situation concrète.
- **Potentiel média :** messages de confidence, listes de limites ou traces à
  double lecture ; aucun média intime requis par défaut.
- **Conséquences possibles :** soulagement, proximité, attente mal comprise,
  conflit de loyauté, dette ou reconfiguration relationnelle forte.
- **Garde-fous / consentement :** accord séparé de chaque adulte, possibilité de
  retrait à chaque étape, aucune facilitation secrète au nom d'un fantasme supposé,
  après-scène obligatoire aux niveaux élevés.
- **Semis en amont :** Nico sait écouter, respecte un premier secret, pose une
  limite utile et démontre qu'il ne transforme pas toute confidence en invitation.

### 6.4 Pauline, « cap ou pas cap » et négociation réciproque

**Statut :** `VALIDATED_CONCEPT`

**Nature :** branche identitaire Pauline avec mécanique modulaire

**Intensité possible :** 2–5

- **Concept :** Pauline utilise « cap ou pas cap » pour tester la complicité ; les
  défis deviennent une négociation réciproque, puis peuvent ouvrir la discussion
  de son fantasme de trio avec deux hommes ou deux femmes.
- **Personnages compatibles / variantes interchangeables :** Pauline est le moteur
  identitaire. `OPTIONAL_VARIANT` : défi verbal, photo bénigne, échange symétrique,
  fantasme seulement raconté, composition du trio laissée ouverte.
- **Préconditions relationnelles :** repartie ludique installée, réciprocité réelle,
  limites connues et possibilité de refuser sans perdre la relation.
- **Potentiel média :** défis par message, photos graduelles, preuve volontaire ou
  réponse équivalente négociée.
- **Conséquences possibles :** complicité, révélation d'un désir, asymétrie mise au
  jour, jalousie ou passage futur à une conversation de limites.
- **Garde-fous / consentement :** un défi n'oblige jamais ; symétrie proposée ne
  signifie pas équivalence des limites ; fantasme exprimé ne vaut ni promesse ni
  consentement à une personne précise.
- **Semis en amont :** petits défis sans enjeu, réaction positive à un refus,
  curiosité assumée et distinction entre jeu verbal et action réelle.

### 6.5 Sandra et le voyage hypothétique

**Statut :** `VALIDATED_CONCEPT`

**Nature :** scène identitaire Sandra–Player

**Intensité possible :** 2–4

- **Concept :** dans l'hypothèse où Marie ne pourrait pas partir, Player propose à
  Sandra de la remplacer ; le flirt reste masqué avant une question du type « si
  tu n'étais pas en couple ? ».
- **Personnages compatibles / variantes interchangeables :** Sandra et Player ne
  sont pas interchangeables dans le noyau. `OPTIONAL_VARIANT` : proposition
  sérieuse, plaisanterie protectrice, ou question laissée sans réponse.
- **Préconditions relationnelles :** reconnexion crédible, confiance privée,
  connaissance de la situation du couple et habitude de sous-entendus limitée.
- **Potentiel média :** destination partagée, captures de voyage, ancien souvenir
  ou échange privé préparant la projection.
- **Conséquences possibles :** gêne tendre, clarification, recul, désir reconnu ou
  secret émotionnel sans passage à l'acte.
- **Garde-fous / consentement :** ne pas faire de la proposition une dette ; laisser
  Sandra reformuler, refuser ou interrompre ; ne pas présumer la disponibilité de
  Marie ni instrumentaliser son absence.
- **Semis en amont :** intérêt commun pour un lieu, confiance restaurée, premier
  sous-entendu maîtrisé et preuve que Player respecte une limite posée.

### 6.6 Deux versions d'une sortie, enquête et rapprochement des « espions »

**Statut :** `VALIDATED_CONCEPT`

**Nature :** architecture dramatique semi-modulaire centrée sur Marie

**Intensité possible :** 3–6

- **Concept :** Marie donne deux versions d'une sortie. Player et une autre femme
  choisissent d'enquêter ou de suivre Marie, obtiennent des photos ambiguës ou
  compromettantes, puis se rapprochent entre eux par choix.
- **Personnages compatibles / variantes interchangeables :** Marie et Player
  structurent le conflit ; la seconde enquêtrice peut varier si sa motivation, sa
  voix et sa relation le justifient. `OPTIONAL_VARIANT` : erreur d'interprétation,
  vérité partielle, enquête abandonnée ou proximité qui reste émotionnelle.
- **Préconditions relationnelles :** contradiction vérifiable, motif crédible pour
  chacun, confiance déjà fissurée, limites de vie privée identifiées et choix
  indépendant des deux enquêteurs.
- **Potentiel média :** captures, photo distante, horaire, message tronqué, album
  commun ou preuve qui change de sens avec le contexte.
- **Conséquences possibles :** vérité découverte, culpabilité d'avoir suivi Marie,
  alliance, rapprochement, secret commun, rupture de confiance ou conséquence de
  couple majeure.
- **Garde-fous / consentement :** ne pas romantiser automatiquement la surveillance ;
  traiter l'atteinte à la vie privée comme un acte à conséquences. Si alcool il y
  a, il ne fonde jamais le consentement : tout rapprochement doit rester explicite,
  lucide et, si nécessaire, reconfirmé hors intoxication.
- **Semis en amont :** versions antérieures cohérentes, détail qui ne concorde pas,
  raison personnelle de la seconde femme, limites autour de la jalousie et moment
  préalable où les futurs alliés choisissent de se faire confiance.

### 6.7 Plage, piscine ou sport et progression des photos

**Statut :** `VALIDATED_CONCEPT`

**Nature :** template relationnel modulaire

**Intensité possible :** 1–4

- **Concept :** plage, piscine ou sport rendent l'image naturelle et permettent une
  progression public → personnel → privé sans saut d'intensité automatique.
- **Personnages compatibles / variantes interchangeables :** tout personnage pour
  qui l'activité et le partage d'images sont crédibles. `OPTIONAL_VARIANT` : photo
  de groupe, conseil de tenue, performance, image adressée à une seule personne.
- **Préconditions relationnelles :** contexte social établi, rapport à l'image
  cohérent, destinataires légitimes et premiers échanges non intimes.
- **Potentiel média :** publication publique, sélection non publiée, recadrage,
  coulisses ou version privée explicitement adressée.
- **Conséquences possibles :** attention nouvelle, compliment, comparaison,
  jalousie légère, demande de confidentialité ou opportunité future.
- **Garde-fous / consentement :** aucune sexualisation imposée ; consentement de
  toutes les personnes visibles ; chaque changement de cercle de diffusion est un
  nouveau choix.
- **Semis en amont :** activité annoncée, confort corporel propre au personnage,
  habitudes de publication et réaction respectueuse à une première image.

### 6.8 Raphaëlle et les essayages cosplay

**Statut :** `VALIDATED_CONCEPT`

**Nature :** scène identitaire Raphaëlle

**Intensité possible :** 1–4

- **Concept :** des essayages cosplay font croître graduellement la proximité par
  l'aide pratique, le regard demandé et la confiance créative.
- **Personnages compatibles / variantes interchangeables :** Raphaëlle reste le
  centre identitaire ; partenaire d'aide variable seulement si la relation et la
  compétence sont crédibles. `OPTIONAL_VARIANT` : choix d'accessoire, ajustement,
  séance photo ou préparation à distance.
- **Préconditions relationnelles :** intérêt sincère pour son projet, règles sur le
  toucher et les photos, sécurité suffisante pour demander puis corriger une aide.
- **Potentiel média :** croquis, photos d'étape, sélection privée, résultat public
  et versions refusées ou supprimées.
- **Conséquences possibles :** complicité créative, attention personnelle, malaise
  réparé, souvenir commun ou nouvelle limite explicite.
- **Garde-fous / consentement :** demander avant toucher, ajuster ou photographier ;
  ne pas présenter le costume comme consentement à l'intimité ; respecter le droit
  de retrait d'une image.
- **Semis en amont :** conversation sur le cosplay, premier conseil utile, espace
  de travail sûr, échange sur la diffusion et capacité à entendre une correction.

### 6.9 Mathilde surprend un moment sexuel privé du Player

**Statut :** `VALIDATED_CONCEPT`

**Nature :** scène avancée identitaire Mathilde–Player

**Intensité possible :** 4–5

- **Concept :** Mathilde surprend Player en train de se masturber et le confronte
  sur la personne à laquelle il pensait ; aucune réponse positive de Mathilde n'est
  présumée.
- **Personnages compatibles / variantes interchangeables :** Mathilde et Player
  sont le noyau. `OPTIONAL_VARIANT` : elle se retire, demande une explication plus
  tard, pose une limite, désamorce ou laisse la question sans réponse.
- **Préconditions relationnelles :** proximité domestique avancée, règles d'espace
  privé connues, tension déjà lisible et capacité des deux à parler sans coercition.
- **Potentiel média :** aucun média requis ; éventuellement un message ultérieur de
  clarification, jamais une capture de l'acte.
- **Conséquences possibles :** honte, humour défensif, limite renforcée, attirance
  révélée, distance ou secret émotionnel.
- **Garde-fous / consentement :** préserver le droit de Mathilde à une réaction
  négative, neutre ou différée ; ne pas transformer la surprise en permission ;
  éviter exposition prolongée, chantage ou réponse imposée.
- **Semis en amont :** habitudes de cohabitation, portes et intimité, premier
  incident mineur réparé, confiance suffisante pour une conversation difficile.

### 6.10 Sandra rencontre Marie et elles s'entendent bien

**Statut :** `VALIDATED_CONCEPT`

**Nature :** scène identitaire Sandra–Marie–Player

**Intensité possible :** 1–4

- **Concept :** Sandra rencontre Marie et une vraie affinité naît, ce qui rend
  l'ambiguïté avec Player plus inconfortable et moralement plus concrète.
- **Personnages compatibles / variantes interchangeables :** trio identitaire ; le
  contexte peut varier. `OPTIONAL_VARIANT` : rencontre brève, activité commune,
  échange privé ultérieur ou affinité qui surprend Player.
- **Préconditions relationnelles :** raison naturelle de la rencontre, image
  cohérente que chacune a de l'autre et ambiguïté Sandra–Player encore contenue.
- **Potentiel média :** photo de groupe, ajout de contact, souvenir commun ou message
  chaleureux dont Player connaît le sous-texte.
- **Conséquences possibles :** culpabilité, affection croisée, prudence accrue,
  nouvelle loyauté ou futur conflit plus difficile.
- **Garde-fous / consentement :** ne pas réduire Marie ou Sandra à un obstacle ;
  préserver leur relation propre ; ne pas utiliser l'amitié comme consentement à
  une configuration intime.
- **Semis en amont :** mentions mutuelles positives, intérêt partagé, occasion
  sociale crédible et distinction claire entre chaleur sociale et flirt.

### 6.11 Marie raconte avoir été draguée

**Statut :** `VALIDATED_CONCEPT`

**Nature :** scène identitaire Marie–Player, usages modulaires

**Intensité possible :** 1–5

- **Concept :** Marie raconte spontanément avoir été draguée ; la conversation peut
  préparer jalousie, curiosité, voyeurisme ou NTR consenti bien plus tard.
- **Personnages compatibles / variantes interchangeables :** Marie et Player au
  centre. `OPTIONAL_VARIANT` : anecdote amusée, trouble reconnu, limite posée,
  curiosité du Player ou conversation qui s'arrête sans résolution.
- **Préconditions relationnelles :** sécurité de parole dans le couple, raison de
  raconter et aucune doctrine déjà présumée sur la jalousie ou le fantasme.
- **Potentiel média :** message reçu montré volontairement, description sans preuve,
  photo sociale non ambiguë ou absence totale de média.
- **Conséquences possibles :** confiance accrue, jalousie, excitation verbalisée,
  frontière clarifiée ou graine d'une négociation future.
- **Garde-fous / consentement :** curiosité ou excitation ne vaut pas permission ;
  ne pas piéger Marie dans une révélation ; respecter qu'elle puisse seulement
  partager une anecdote.
- **Semis en amont :** couple capable de parler d'attention extérieure, petite
  discussion sur les limites et réaction du Player sans punition ni revendication.

### 6.12 Photo vue sans contexte

**Statut :** `VALIDATED_CONCEPT`

**Nature :** template relationnel modulaire

**Intensité possible :** 2–5

- **Concept :** Marie ou un autre personnage voit une photo sans son contexte et
  construit une interprétation plausible mais incomplète.
- **Personnages compatibles / variantes interchangeables :** observateur, sujet et
  détenteur variables si chacun possède une motivation crédible. `OPTIONAL_VARIANT` :
  aperçu accidentel, miniature, recadrage, ancien fichier ou légende manquante.
- **Préconditions relationnelles :** accès crédible au média, tension interprétative
  préexistante et information réellement absente de l'observateur.
- **Potentiel média :** miniature, photo recadrée, métadonnée, album ou version
  complète révélée plus tard.
- **Conséquences possibles :** question directe, silence, jalousie, mauvaise décision,
  enquête ou réparation après contextualisation.
- **Garde-fous / consentement :** ne pas rendre l'intrusion gratuite ; distinguer
  erreur d'accès et fouille volontaire ; laisser une voie crédible de clarification.
- **Semis en amont :** provenance du fichier, règle d'accès au téléphone, détail
  visuel à double lecture et raison émotionnelle de l'interprétation.

### 6.13 Première occasion réellement incompatible

**Statut :** `VALIDATED_CONCEPT`

**Nature :** pivot structurel de route

**Intensité possible :** 4–6

- **Concept :** une occasion oblige enfin Player à reconnaître qu'un choix envers
  Marie rend une autre relation ou promesse impossible au même moment.
- **Personnages compatibles / variantes interchangeables :** Marie reste l'ancrage ;
  l'autre relation dépend du chemin réellement construit. `OPTIONAL_VARIANT` :
  conflit d'horaire, promesse, présence attendue, secret ou limite incompatible.
- **Préconditions relationnelles :** deux engagements lisibles, coût compréhensible
  de chaque choix et impossibilité non artificielle de tout satisfaire.
- **Potentiel média :** invitations, horaires, messages simultanés, preuve d'absence
  ou souvenir d'une promesse.
- **Conséquences possibles :** déception, dette, route temporairement fermée, secret,
  honnêteté coûteuse ou première conséquence relationnelle forte.
- **Garde-fous / consentement :** ne pas fabriquer une fausse urgence sans semis ;
  ne pas punir un refus légitime ; rendre les conséquences cohérentes et non
  arbitraires.
- **Semis en amont :** attentes dites, disponibilité limitée, importance des deux
  liens et occasions antérieures où l'évitement restait encore possible.

### 6.14 Secret partagé avec Nico ou un autre confident

**Statut :** `VALIDATED_CONCEPT`

**Nature :** template modulaire, branche Nico privilégiée mais non obligatoire

**Intensité possible :** 3–6

- **Concept :** un secret confié crée une dette, un risque ou une responsabilité
  entre Player et Nico, ou un autre confident réellement éligible.
- **Personnages compatibles / variantes interchangeables :** Nico si la fonction de
  confident a été construite ; autre adulte seulement si sa voix et ses loyautés
  produisent une conséquence différente. `OPTIONAL_VARIANT` : secret reçu, découvert,
  gardé à contrecœur ou refusé.
- **Préconditions relationnelles :** confiance prouvée, contenu digne d'être protégé,
  risque identifiable et choix réel du confident.
- **Potentiel média :** message archivé, photo confiée, preuve chiffrée ou absence de
  trace comme choix dramatique.
- **Conséquences possibles :** dette, alliance, pression, révélation accidentelle,
  conflit de loyauté ou rupture de confiance.
- **Garde-fous / consentement :** ne pas confondre confidence et autorisation d'agir ;
  un confident peut poser une limite ou refuser de couvrir un préjudice ; aucune
  menace coercitive présentée comme complicité.
- **Semis en amont :** petit secret tenu, philosophie du confident, limite morale
  visible et coût potentiel de la confidentialité.

### 6.15 Canapé et proximité domestique avec Mathilde

**Statut :** `VALIDATED_CONCEPT`

**Nature :** scène identitaire Mathilde, modulable dans ses circonstances

**Intensité possible :** 1–4

- **Concept :** le canapé et les habitudes du foyer installent une proximité
  domestique banale avant qu'elle puisse devenir attention ou ambiguïté.
- **Personnages compatibles / variantes interchangeables :** Mathilde et Player au
  centre ; Marie peut être présente, absente pour une raison établie ou revenir.
  `OPTIONAL_VARIANT` : film, travail, fatigue, objet partagé ou place habituelle.
- **Préconditions relationnelles :** présence régulière de Mathilde, confort dans le
  foyer, règles implicites visibles et aucune intimité soudaine non préparée.
- **Potentiel média :** photo quotidienne, contenu regardé ensemble, message de Marie
  ou souvenir banal qui gagnera du sens plus tard.
- **Conséquences possibles :** nouvelle habitude, gêne légère, attention corporelle,
  recul choisi ou premier sentiment d'incompatibilité domestique.
- **Garde-fous / consentement :** proximité physique n'est pas permission ; laisser
  chacun changer de place, interrompre ou nommer son inconfort sans sanction.
- **Semis en amont :** arrivée naturelle de Mathilde dans le quotidien, objets et
  routines partagés, petites décisions de place et confiance sans sous-texte forcé.

### 6.16 Raphaëlle, déplacement et hôtel

**Statut :** `VALIDATED_CONCEPT`

**Nature :** scène identitaire Raphaëlle avec template logistique

**Intensité possible :** 2–5

- **Concept :** un déplacement, un hôtel ou une contrainte logistique réduit la
  distance et crée une proximité qui doit rester choisie, jamais automatique.
- **Personnages compatibles / variantes interchangeables :** Raphaëlle au centre ;
  Player ou un partenaire de projet selon le canon futur. `OPTIONAL_VARIANT` :
  réservation erronée, dernier transport manqué, travail tardif ou chambres séparées.
- **Préconditions relationnelles :** projet commun crédible, règles de voyage,
  confiance et possibilités de couchage ou de retrait explicitement disponibles.
- **Potentiel média :** billets, réservation, photos de lieu, préparation cosplay
  ou messages logistiques qui deviennent personnels.
- **Conséquences possibles :** complicité, tension, limite respectée, rumeur, secret
  ou occasion refusée qui compte autant qu'une occasion saisie.
- **Garde-fous / consentement :** contrainte matérielle ne vaut jamais consentement ;
  préserver une option sûre et digne ; alcool ou fatigue ne doivent pas affaiblir
  la nécessité d'un accord clair.
- **Semis en amont :** déplacement annoncé, répartition des responsabilités, premier
  travail en tête-à-tête et comportement fiable face à une limite.

### 6.17 Anciennes photos et souvenirs qui changent de sens

**Statut :** `VALIDATED_CONCEPT`

**Nature :** template mémoriel à forte dépendance de continuité

**Intensité possible :** 2–5

- **Concept :** une ancienne photo ou un souvenir déjà connu reçoit un sens nouveau
  après une révélation ou l'évolution d'une relation.
- **Personnages compatibles / variantes interchangeables :** toute relation disposant
  d'une provenance et d'une mémoire établies. `OPTIONAL_VARIANT` : détail remarqué,
  personne hors cadre, date, légende, geste ou intention réinterprétée.
- **Préconditions relationnelles :** média antérieur réellement semé, provenance
  durable, nouvelle information crédible et mémoire accessible au personnage.
- **Potentiel média :** avant/après contextuel, album, métadonnées, recadrage ou
  dialogue associé au média existant.
- **Conséquences possibles :** nostalgie, suspicion, tendresse, regret, enquête ou
  contradiction d'un alibi.
- **Garde-fous / consentement :** ne pas réécrire rétroactivement les faits sans base ;
  distinguer interprétation nouvelle et vérité objective ; respecter les droits de
  consultation et de partage.
- **Semis en amont :** photo mémorable, détail discret mais honnête, date et détenteur
  stables, première interprétation non surlignée.

### 6.18 Faux alibi qui devient un vrai secret

**Statut :** `VALIDATED_CONCEPT`

**Nature :** template de secret et de conséquence

**Intensité possible :** 3–6

- **Concept :** un mensonge initialement improvisé pour protéger ou éviter une gêne
  oblige ensuite deux personnages à conserver ensemble un vrai secret.
- **Personnages compatibles / variantes interchangeables :** Player et tout adulte
  dont la motivation, le coût et la loyauté sont établis. `OPTIONAL_VARIANT` : alibi
  demandé, offert, mal compris ou maintenu contre l'avis de l'autre.
- **Préconditions relationnelles :** incident concret, raison crédible d'éviter la
  vérité immédiate, possibilité initiale de refuser et risque croissant vérifiable.
- **Potentiel média :** horaires, message fabriqué, photo de couverture, historique
  incohérent ou preuve ultérieure.
- **Conséquences possibles :** dette, alliance, culpabilité, seconde faute pour
  protéger la première, aveu ou rupture de confiance.
- **Garde-fous / consentement :** ne pas forcer un personnage à couvrir un autre ;
  traiter le mensonge comme choix à conséquences ; offrir des issues d'aveu et de
  réparation.
- **Semis en amont :** fiabilité habituelle, détail vérifiable, petit écart de version,
  loyauté concernée et raison pour laquelle la vérité semble coûteuse.

### 6.19 Soirée de couples et réponses inattendues sur les fantasmes

**Statut :** `VALIDATED_CONCEPT`

**Nature :** scène collective semi-modulaire

**Intensité possible :** 2–5

- **Concept :** pendant une soirée, plusieurs couples parlent de fantasmes et
  découvrent des réponses inattendues qui déplacent les alliances ou les regards.
- **Personnages compatibles / variantes interchangeables :** couples et adultes dont
  la confiance collective est suffisante ; chaque composition doit produire des
  voix distinctes. `OPTIONAL_VARIANT` : jeu de cartes, conversation spontanée,
  réponse privée après la soirée ou droit de passer.
- **Préconditions relationnelles :** groupe déjà crédible, sécurité sociale, règles
  implicites de confidentialité et premiers sujets personnels moins risqués.
- **Potentiel média :** aucun requis ; éventuellement messages post-soirée, jeu
  support ou photo de groupe sans preuve intime.
- **Conséquences possibles :** curiosité, gêne, affinité nouvelle, jalousie, mauvaise
  interprétation ou conversation de couple nécessaire.
- **Garde-fous / consentement :** droit explicite de ne pas répondre ; une confidence
  collective n'est pas une invitation ; ne pas utiliser l'alcool pour obtenir une
  révélation ou un accord.
- **Semis en amont :** dynamique de groupe, capacité à respecter une confidence,
  humour sans humiliation et différences de limites déjà perceptibles.

### 6.20 Mauvaise photo ou mauvais message à la mauvaise personne

**Statut :** `VALIDATED_CONCEPT`

**Nature :** template relationnel générique, distinct du canon OA02 Sandra

**Intensité possible :** 2–5

- **Concept :** une photo ou un message destiné à une relation atteint une autre
  personne et révèle une attention, une version ou un secret inattendu.
- **Personnages compatibles / variantes interchangeables :** expéditeur, destinataire
  prévu et destinataire réel variables si leurs voix, états et conséquences sont
  écrits séparément. `OPTIONAL_VARIANT` : erreur authentique, mauvaise conversation,
  pièce jointe erronée, transfert incomplet ou envoi volontaire déguisé.
- **Préconditions relationnelles :** plusieurs fils actifs, habitudes de messagerie,
  contenu cohérent avec le destinataire prévu et risque déjà compréhensible.
- **Potentiel média :** message, photo, miniature, notification, suppression ou
  capture selon les permissions établies.
- **Conséquences possibles :** gêne, clarification, découverte d'un lien, jalousie,
  secret partagé, mensonge de couverture ou conséquence relationnelle forte.
- **Garde-fous / consentement :** ne pas copier la scène canonique OA02 Sandra ni ses
  identités runtime ; ne pas faire de l'erreur un consentement au partage ; traiter
  toute diffusion secondaire comme un choix séparé.
- **Semis en amont :** fils distincts, style reconnaissable des échanges, contenu
  préparé pour une raison crédible, possibilité d'erreur lisible et coût spécifique
  pour chaque destinataire.

## 7. Gate de consultation et de promotion

Avant d'utiliser une idée pour préparer une scène, vérifier :

- [ ] le statut reste `VALIDATED_CONCEPT` ou `OPTIONAL_VARIANT`, jamais canon par
  simple présence ici ;
- [ ] la scène sert la courbe relationnelle réellement atteinte ;
- [ ] la voix, l'état, les connaissances et les limites de chaque personnage sont
  vérifiés dans les sources autoritatives courantes ;
- [ ] les semis existent déjà ou sont ajoutés sans promettre artificiellement le
  payoff ;
- [ ] chaque média possède provenance, contrôleur, destinataires et permission de
  partage cohérents ;
- [ ] refus, retrait, malentendu, responsabilité et après-scène sont prévus ;
- [ ] les conséquences sont supportées par le moteur et la continuité avant toute
  promotion.

`PROMOTED_TO_CANON_PLAN` ne peut être attribué que dans un lot éditorial futur qui
nomme la source canonique modifiée, le placement, les préconditions, les variantes
retenues, les conséquences et les tests ou contrôles de continuité associés.
