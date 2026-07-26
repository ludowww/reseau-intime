# ASSET-03 — Location References & Pilot Batch

```text
Document :
ASSET-03 — Location References & Pilot Batch

Statut :
ACTIVE_PREPRODUCTION_REFERENCE

Baseline inspectée :
8850cca6ac90bd14a7e0d165c55266c96369687d

Périmètre :
lieux récurrents Saison 1
+ sélection documentaire de huit fichiers pilotes

Pipeline cible futur :
Anima via ComfyUI

Production :
non commencée
```

---

# 1. Mission et limites

ASSET-03 verrouille les principaux lieux récurrents de la Saison 1, leurs invariants de continuité à travers les 84 fichiers d’ASSET-01, la sélection du premier batch pilote et ses critères d’acceptation avant toute production en série.

Ce lot reste strictement documentaire. Il ne produit :

- aucune image ;
- aucun prompt définitif ;
- aucun workflow ComfyUI ;
- aucun fichier de référence visuelle ;
- aucun asset temporaire ou final ;
- aucune modification runtime.

## 1.1 Autorité

ASSET-03 fait autorité sur :

- l’identité visuelle minimale des lieux récurrents ;
- leur géographie interne utile ;
- leurs matériaux, palettes et familles de lumière ;
- leurs invariants de continuité ;
- la sélection du premier batch pilote ;
- les critères de validation de ce batch.

ASSET-03 ne fait pas autorité sur :

- les dialogues ;
- les personnages ;
- les routes ;
- les audiences narratives ;
- la composition détaillée de chaque asset ;
- le consentement ;
- les états de relation ;
- les prompts définitifs ;
- les réglages ComfyUI ;
- les fichiers produits ;
- l’intégration runtime.

## 1.2 Hiérarchie

```text
scripts et registres
→ vérité narrative

NAR-PROD-02 à NAR-PROD-06
→ brief exact de chaque fichier

ASSET-01
→ identité, ordre et comptage des 84 fichiers

ASSET-02
→ identité humaine récurrente

ASSET-03
→ identité des lieux et batch pilote
```

En cas de divergence, ASSET-03 doit être corrigé. Il ne doit jamais réinterpréter une scène signée.

## 1.3 Sources relues

```text
docs/canon/dialogues/ASSET_01_MANIFESTE_PRODUCTION_VISUELLE_SAISON_1_84_FICHIERS.md
docs/canon/dialogues/ASSET_02_CHARACTER_REFERENCES.md

docs/canon/dialogues/NAR_PROD_02_PAQUET_PRODUCTION_ACTE_I_J01_J04.md
docs/canon/dialogues/NAR_PROD_03_PAQUET_PRODUCTION_ACTE_II_J05_J08.md
docs/canon/dialogues/NAR_PROD_04_PAQUET_PRODUCTION_ACTE_III_J09_J12.md
docs/canon/dialogues/NAR_PROD_05_PAQUET_PRODUCTION_ACTE_IV_J13_J16.md
docs/canon/dialogues/NAR_PROD_06_PAQUET_PRODUCTION_ACTE_V_J17_J21.md

docs/canon/characters/*_CANON_FULL.md
docs/canon/bible/09_PROGRESSION_VISUELLE_ET_PHOTOGRAPHIQUE.md
```

Les anciens placeholders runtime ne sont pas une autorité de décor.

---

# 2. Principes généraux des lieux

## 2.1 Lieux vécus

Les lieux ne doivent pas ressembler à :

- des showrooms ;
- des appartements témoins ;
- des décors de publicité ;
- des fonds génériques interchangeables ;
- des espaces excessivement luxueux ;
- des environnements fantasy ou futuristes.

Chaque lieu doit montrer :

- une fonction réelle ;
- des traces d’usage ;
- une organisation plausible ;
- quelques imperfections contrôlées ;
- une histoire visible sans surcharge.

## 2.2 Continuité

La continuité repose sur :

- la géographie générale ;
- les ouvertures ;
- les matériaux dominants ;
- les meubles fixes ;
- deux à cinq repères permanents ;
- la famille de lumière ;
- les rapports d’échelle.

Elle ne repose pas sur :

- un cadrage identique ;
- un objet toujours placé exactement au même endroit ;
- une lumière figée ;
- une décoration copiée pixel par pixel.

## 2.3 Personnages prioritaires

Le décor soutient les personnages. Il ne doit jamais :

- prendre toute la lisibilité ;
- transformer l’image en visite immobilière ;
- imposer une émotion différente du brief ;
- révéler un personnage ou un objet absent ;
- sexualiser automatiquement une scène ordinaire.

## 2.4 Player

Player reste :

- hors cadre ;
- point de vue ;
- ou présence non identifiable lorsqu’un brief l’exige.

Aucun miroir, reflet, ombre ou photographie ne doit créer accidentellement son apparence canonique.

---

# 3. Registre des lieux

| Référence documentaire | Lieu | Statut | Fonctions principales | Assets liés |
|---|---|---|---|---|
| `LOC_APPARTEMENT` | Appartement Marie / Player | `LOCKED_RECURRENT` | couple, foyer, Mathilde, transformations domestiques | ASSET-01 |
| `LOC_LAVERRIERE` | La Verrière | `LOCKED_RECURRENT` | travail créatif, installation, visibilité publique | ASSET-01 |
| `LOC_ANNEXE` | L’Annexe | `LOCKED_RECURRENT` | service, amitié Nico, circulation sociale | ASSET-01 |
| `LOC_CAFE_SANDRA` | Café / déjeuner Sandra | `LOCKED_SUPPORT` | souvenir du déjeuner, rencontre tenue | ASSET-01 |
| `LOC_RAPHAELLE_ATELIER` | Atelier personnel de Raphaëlle | `LOCKED_CHARACTER_SPACE` | fabrication, sélection, transformation | ASSET-01 + canon Raphaëlle |
| `LOC_SOCIAL_SOURCE_ONLY` | Lieux sociaux ponctuels | `SOURCE_SPECIFIC` | sets et scènes ponctuelles | brief NAR-PROD exact |
| `LOC_PRIVATE_DEFERRED` | Intérieurs privés non encore localisés | `DEFERRED_TO_SIGNED_SCENE` | payoffs et scènes privées | brief exact uniquement |

Ces identifiants sont documentaires. Ils ne deviennent :

- ni clés JSON ;
- ni noms de scènes Godot ;
- ni dossiers runtime ;
- ni `asset_id`.

---

# 4. `LOC_APPARTEMENT`

## 4.1 Fonction

Centre émotionnel et géographique de la saison. Il doit rendre crédibles :

- la vie commune Marie / Player ;
- l’arrivée temporaire de Mathilde ;
- les routines à trois ;
- les tensions domestiques ;
- le retour au couple ;
- le foyer transformé après le départ.

## 4.2 Identité générale

Appartement urbain réellement habité :

- confortable mais non luxueux ;
- dimensions moyennes ;
- circulation compacte ;
- mobilier choisi progressivement ;
- mélange d’objets du couple ;
- chaleur quotidienne plutôt que perfection décorative.

## 4.3 Zones obligatoires

### Cuisine ouverte / coin repas

Repères :

- plan de travail réellement utilisé ;
- petite table ou prolongement de repas ;
- lumière chaude du soir ;
- quelques ustensiles visibles ;
- rangement imparfait mais maîtrisé ;
- espace suffisant pour deux ou trois adultes sans effet de grande villa.

Doit rester compatible avec :

```text
S1_A1_J01_SCN_MARIE_SHARED_KITCHEN_01
S1_A1_J02_SCN_FIRST_SHARED_EVENING_01
```

### Entrée / petit couloir

Repères :

- miroir d’entrée ;
- manteaux ou patères ;
- chaussures ou clés ;
- transition claire vers l’espace commun ;
- accès à la petite chambre.

Le miroir reste orienté et cadré de manière à ne jamais révéler Player.

### Séjour

Repères :

- canapé utilisé ;
- table basse ;
- éclairage secondaire ;
- objets ordinaires du couple ;
- aucune scénographie romantique permanente.

### Petite chambre

Repères :

- taille réellement réduite ;
- lit simple ou solution temporaire crédible ;
- rangement limité ;
- valise de Mathilde ;
- garment bag ;
- tote bag juridique ;
- sensation de séjour temporaire, pas de chambre adolescente.

Doit rester compatible avec :

```text
S1_A1_J02_SCN_MATHILDE_FIRST_INSTALLED_VIEW_01
```

## 4.4 Palette

- bois chaud moyen ;
- crème non uniforme ;
- olive discret ;
- terracotta ponctuel ;
- gris doux ;
- petites touches personnelles colorées.

## 4.5 Lumières

Prévoir au moins :

- fin d’après-midi naturelle ;
- soirée domestique chaude ;
- retour tardif plus contrasté ;
- matin ou dimanche plus diffus.

## 4.6 Interdits

- loft immense ;
- appartement blanc clinique ;
- décoration entièrement beige ;
- luxe parisien de magazine ;
- objets trop nombreux et illisibles ;
- chambre de Mathilde traitée comme espace érotique ;
- géographie différente entre deux images ;
- miroir révélant Player.

---

# 5. `LOC_LAVERRIERE`

## 5.1 Fonction

Lieu de travail créatif, d’installation et de visibilité publique associé au monde autonome de Marie. Il doit permettre :

- le travail réel avant l’ouverture ;
- l’installation ;
- la revue d’accessibilité avec Raphaëlle ;
- les mouvements de personnes ;
- les prises publiques ou professionnelles ;
- une transformation nette entre préparation et événement.

## 5.2 Identité générale

Espace culturel ou créatif réhabilité, identifiable sans devenir monumental :

- lumière naturelle importante ;
- structure vitrée ou grande présence du verre ;
- éléments métalliques sobres ;
- murs permettant installation et affichage ;
- mobilier mobile ;
- arrière-zones de préparation ;
- circulation visible.

La « verrière » doit être un repère de lumière et d’architecture, pas un palais de verre spectaculaire.

## 5.3 Sous-zones

- espace principal d’installation ;
- table ou surface de préparation ;
- passage latéral / zone technique ;
- entrée publique ;
- coin de revue ou de travail ;
- arrière-plan permettant un groupe réel.

## 5.4 Palette

- verre légèrement froid ;
- métal gris ou noir doux ;
- bois clair à moyen ;
- blanc cassé ;
- accents issus des installations présentes ;
- lumière de soirée plus chaude sans transformer le lieu en club.

## 5.5 Continuité

Les images J03, J09 et J12 doivent partager :

- la même logique d’ouvertures ;
- la même structure principale ;
- au moins deux repères architecturaux ;
- une échelle cohérente ;
- une évolution crédible de l’installation.

## 5.6 Interdits

- galerie blanche vide générique ;
- musée monumental ;
- coworking technologique ;
- lieu nocturne permanent ;
- installations inventées qui prennent le dessus sur les personnages ;
- confusion avec L’Annexe ;
- confusion avec l’atelier privé de Raphaëlle.

---

# 6. `LOC_ANNEXE`

## 6.1 Fonction

Lieu social récurrent associé à Nico, au service, aux places gardées, aux confidences après fermeture et à plusieurs photographies publiques.

## 6.2 Identité générale

Bar-café ou petite restauration de quartier :

- chaleureux ;
- fréquenté ;
- assez soigné pour accueillir plusieurs cercles ;
- pas branché au point de devenir exclusif ;
- pas délabré ;
- identifiable grâce au comptoir et à quelques repères fixes.

## 6.3 Repères permanents

- comptoir visible ;
- rangée limitée de bouteilles ou verrerie ;
- tabourets ou sièges dépareillés mais cohérents ;
- tables compactes ;
- une chaise ou place reconnaissable ;
- lumière suspendue ;
- passage vers l’espace de service ;
- extérieur ou vitrine seulement lorsque le brief le justifie.

## 6.4 États de lumière

- service actif ;
- fin de service ;
- après fermeture partielle ;
- moment social plus dense ;
- lumière publique photographiable.

## 6.5 Palette

- bois sombre mais pas noir ;
- ambre ;
- vert profond ;
- crème ou laiton discret ;
- touches rouges ou brique limitées.

## 6.6 Interdits

- boîte de nuit ;
- bar clandestin ultra-sombre ;
- pub folklorique ;
- restaurant de luxe ;
- néons omniprésents ;
- foule indistincte ;
- décor vide après service ;
- sexualisation automatique des échanges.

---

# 7. `LOC_CAFE_SANDRA`

## 7.1 Fonction

Support concret du déjeuner passé puis d’une éventuelle rencontre tenue. Le lieu doit soutenir :

- la mémoire ordinaire ;
- la conversation ;
- la proximité retenue ;
- le contrôle de Sandra sur sa représentation.

## 7.2 Identité

Café adulte et discret :

- lumière naturelle ;
- table de petite taille ;
- deux verres ou tasses ;
- fond vivant mais non envahissant ;
- teintes neutres ;
- aucun code de rendez-vous romantique spectaculaire.

## 7.3 Photographie diégétique

Pour :

```text
S1_A1_J01_DPH_SANDRA_LUNCH_SELECTED_01
```

la photographie doit pouvoir sembler réellement prise :

- cadrage légèrement imparfait ;
- Sandra reste lisible ;
- table et verres servent de contexte ;
- pas de bokeh artificiel excessif ;
- pas de composition de shooting professionnel ;
- pas de crop sexualisant.

## 7.4 Interdits

- terrasse parisienne cliché ;
- chandelles ;
- restaurant de luxe ;
- selfie glamour ;
- table entièrement vide ;
- halo flou présenté comme signature de Sandra.

---

# 8. `LOC_RAPHAELLE_ATELIER`

## 8.1 Fonction

Espace privé de création et de transformation de Raphaëlle. Il doit être distinct :

- de son activité professionnelle ;
- de La Verrière ;
- d’un magasin de costumes ;
- d’une chambre générique.

## 8.2 Identité

Atelier personnel organisé mais réellement utilisé :

- table de coupe ou grande surface de travail ;
- tissus en cours ;
- garment bags ;
- mannequin de couture éventuel ;
- boîtes de mercerie ;
- quelques outils visibles ;
- éléments de costume partiels ;
- éclairage précis ;
- livres ou références choisies.

Raphaëlle reste :

- créative ;
- compétente ;
- attentive ;
- humaine ;
- jamais réduite à une « femme de bureau devenue sexy ».

## 8.3 Palette

- bleu encre ;
- vert forêt ;
- prune ;
- ivoire ;
- rouille ;
- charbon ;
- détails dorés atténués.

## 8.4 Interdits

- boutique de cosplay ;
- amas chaotique incompréhensible ;
- décor fantasy réel ;
- accessoires sacrés utilisés comme décoration ;
- pièce entièrement sombre ;
- atelier assimilé automatiquement à une scène sexuelle.

---

# 9. Lieux différés

Ne pas verrouiller sans source suffisante :

- l’intérieur précis de l’intimité Sandra J18 ;
- l’espace exact du compartiment Pauline J19 ;
- toute chambre d’hôtel ;
- toute résidence privée secondaire ;
- tout lieu sportif comme scène narrative ;
- tout extérieur non décrit ;
- tout décor adulte générique.

La direction sportive de Mathilde appartient à ASSET-02. Elle ne crée pas automatiquement :

- un club de tennis récurrent ;
- un terrain de golf narratif ;
- un nouvel asset ;
- une nouvelle scène.

Pour ces espaces :

```text
DEFERRED_TO_SIGNED_SCENE
```

Le brief NAR-PROD exact de l’asset concerné doit être relu avant toute production. En particulier :

```text
Sandra J18
→ NAR-PROD-06, brief exact de C18-02 et de sa variante d’intimité tardive

Pauline J19
→ NAR-PROD-06, brief exact de C19-01
```

---

# 10. Batch pilote `PILOT-01`

## 10.1 Statut

```text
PILOT_CANDIDATE_NOT_GENERATED
```

Cette sélection :

- ne modifie pas `production_status` dans ASSET-01 ;
- ne signifie pas que les fichiers existent ;
- ne constitue pas une validation artistique ;
- ne lance pas W1 ;
- ne crée aucun fichier hors comptage.

## 10.2 Sélection verrouillée

| Pilote | asset_id | Test principal | Lieu |
|---|---|---|---|
| P01 | `S1_A1_J01_SCN_MARIE_SHARED_KITCHEN_01` | Marie + appartement + image de scène | `LOC_APPARTEMENT` |
| P02 | `S1_A1_J01_DPH_SANDRA_LUNCH_SELECTED_01` | Sandra + photo diégétique naturelle | `LOC_CAFE_SANDRA` |
| P03 | `S1_A1_J02_SCN_MATHILDE_FIRST_INSTALLED_VIEW_01` | Mathilde + petite chambre + corps entier | `LOC_APPARTEMENT` |
| P04 | `S1_A1_J03_SCN_RAPHAELLE_ACCESSIBILITY_REVIEW_01` | Raphaëlle + activité précise + lieu public créatif | `LOC_LAVERRIERE` |
| P05 | `S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01_FRAME_01` | Pauline, Bastien, Marie + photo de groupe | source NAR-PROD-02 |
| P06 | `S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01_FRAME_02` | continuité du même set et des mêmes personnes | source NAR-PROD-02 |
| P07 | `S1_A1_J04_SCN_NICO_SAVED_SEAT_01` | Nico + L’Annexe + lumière sociale | `LOC_ANNEXE` |
| P08 | `S1_A1_J04_SCN_HOUSEHOLD_THREE_RHYTHM_01` | Marie + Mathilde + continuité appartement | `LOC_APPARTEMENT` |

## 10.3 Couverture vérifiée contre ASSET-01

```text
8 fichiers
5 personnages féminins principaux couverts
Nico couvert
Bastien couvert
4 familles de lieux
5 SOUVENIR_IMAGE_DE_SCÈNE
3 fichiers PHOTO_SET / PHOTO_DIÉGÉTIQUE
2 frames du même set
0 adulte
0 variante
0 J21
```

Les cinq personnages féminins principaux couverts sont Marie, Sandra, Mathilde, Pauline et Raphaëlle. Les quatre familles de lieux verrouillées testées sont `LOC_APPARTEMENT`, `LOC_CAFE_SANDRA`, `LOC_LAVERRIERE` et `LOC_ANNEXE` ; le lieu social de P05 et P06 reste défini uniquement par le brief source NAR-PROD-02 et ne crée pas une cinquième référence verrouillée.

Le comptage des natures vient des colonnes autoritatives d’ASSET-01, pas des noms de fichiers :

- P01, P03, P04, P07 et P08 : `SOUVENIR_IMAGE_DE_SCÈNE` ;
- P02 : `PHOTO_DIÉGÉTIQUE` ;
- P05 et P06 : `PHOTO_SET_DIÉGÉTIQUE`, enfants obligatoires d’un même set ;
- les huit entrées sont `BASE` ou `SET_CHILD`, jamais `VARIANT`.

---

# 11. Objectifs du pilote

## 11.1 Identité des personnages

- reconnaissance immédiate ;
- fidélité à ASSET-02 ;
- absence de `same face syndrome` ;
- stabilité de l’âge apparent ;
- stabilité des lunettes ;
- stabilité des cheveux ;
- distinction Sandra / Pauline ;
- Raphaëlle structurée mais chaleureuse ;
- Mathilde adulte et sportive, jamais adolescente.

## 11.2 Continuité des lieux

- appartement géographiquement cohérent ;
- La Verrière reconnaissable ;
- L’Annexe reconnaissable ;
- café Sandra crédible ;
- aucun décor générique interchangeable.

## 11.3 Distinction des natures d’image

Une `PHOTO_DIÉGÉTIQUE` ou un enfant de `PHOTO_SET` doit sembler :

- réellement capturé ;
- légèrement imparfait ;
- soumis à une perspective plausible ;
- différent d’une illustration cinématographique.

Une `SOUVENIR_IMAGE_DE_SCÈNE` doit sembler :

- vécue ;
- composée pour le joueur ;
- sans appareil diégétique implicite ;
- sans selfie, flash ou interface inventée.

## 11.4 Groupe et set

P05 et P06 doivent vérifier :

- mêmes visages ;
- mêmes vêtements ;
- même lieu ;
- même lumière générale ;
- positions différentes mais plausibles ;
- aucune disparition ou substitution de personnage ;
- aucune dérive corporelle.

## 11.5 Présentation mobile

Chaque résultat doit rester lisible :

- en cadrage vertical ;
- sur écran de téléphone ;
- sans détail narratif indispensable dans un coin minuscule ;
- sans texte intégré à l’image ;
- sans visage excessivement éloigné.

---

# 12. Critères d’acceptation

Chaque axe reçoit exactement un verdict :

```text
PASS
REVISION
REJECT
```

| N° | Axe | `PASS` | `REVISION` | `REJECT` |
|---:|---|---|---|---|
| 1 | Identité personnage | identité immédiate et conforme | correction locale possible | identité erronée ou instable |
| 2 | Distinction entre personnages | silhouettes et visages distincts | proximité ponctuelle corrigeable | confusion ou substitution |
| 3 | Anatomie | crédible et stable | défaut local réparable | anomalie majeure ou dérive |
| 4 | Âge apparent | conforme à ASSET-02 | légère dérive corrigeable | infantilisation ou vieillissement majeur |
| 5 | Tenue | conforme au brief et continue | détail ou matière à corriger | tenue fausse, contradictoire ou sexualisée |
| 6 | Expression | sert précisément la scène | intensité à ajuster | émotion opposée ou séduction ajoutée |
| 7 | Lieu | référence reconnaissable | repères insuffisants mais récupérables | lieu générique ou erroné |
| 8 | Continuité géographique | géographie et échelle cohérentes | écart local corrigeable | contradiction structurelle |
| 9 | Lumière | famille juste et lisible | réglage limité requis | ambiance opposée au brief |
| 10 | Nature SCN / DPH | nature immédiatement distincte | ambiguïté corrigeable | mauvaise nature d’image |
| 11 | Cadrage vertical | lecture mobile immédiate | recadrage limité possible | sujet ou information essentielle perdue |
| 12 | Respect du brief | sujets, moment et interdits respectés | détail secondaire à reprendre | contradiction narrative ou sujet ajouté/absent |
| 13 | Absence de Player identifiable | aucune apparence créée | trace ambiguë supprimable | visage, reflet, ombre ou corps canonisant Player |
| 14 | Absence de sexualisation ajoutée | tonalité conforme | pose ou cadrage à neutraliser | sexualisation non demandée structurante |
| 15 | Cohérence avec les autres images du batch | identités, tenues, lieux et set stables | dérive locale réparable | rupture de continuité majeure |

Un résultat `REJECT` ne devient jamais une variante canonique.

## 12.1 Gate du batch

Le pilote n’est pas accepté en série tant que l’une des conditions suivantes persiste :

- au moins un axe narratif ou de consentement est `REJECT` ;
- au moins un personnage est confondu avec un autre ;
- Player est identifiable dans au moins un résultat ;
- P05 et P06 ne forment pas un set continu ;
- au moins une des quatre familles de lieux testées n’est pas reconnaissable ;
- les natures `SOUVENIR_IMAGE_DE_SCÈNE`, `PHOTO_DIÉGÉTIQUE` et `PHOTO_SET_DIÉGÉTIQUE` ne sont pas visuellement distinctes.

Un `REVISION` exige une nouvelle évaluation. Il ne vaut pas acceptation implicite.

---

# 13. Paquet d’entrée futur Anima / ComfyUI

ASSET-03 définit seulement le paquet d’entrée attendu pour ASSET-04.

Pour chaque fichier pilote, ASSET-04 devra réunir :

- `asset_id` exact ;
- brief NAR-PROD exact ;
- fiche personnage ASSET-02 ;
- fiche lieu ASSET-03 ;
- type `SCN`, `DPH` ou `PHOTO_SET` ;
- sujets présents et absents ;
- tenue ;
- moment ;
- expression ;
- cadrage ;
- interdits ;
- continuités ;
- références autorisées ;
- modèle Anima exact ;
- hash du checkpoint ;
- workflow ComfyUI ;
- seed ;
- sampler ;
- scheduler ;
- steps ;
- CFG ou équivalent ;
- dimensions ;
- éventuels LoRA / ControlNet ;
- règles d’upscale ;
- convention de nommage des essais ;
- résultat de QA.

ASSET-03 ne renseigne pas encore ces paramètres techniques.

## 13.1 Informations différées à ASSET-04

```text
nom exact du checkpoint Anima
version / hash
VAE
sampler
scheduler
steps
guidance
résolution source
upscaler
LoRA
ControlNet
IPAdapter ou équivalent
politique de seed
workflow JSON ComfyUI
```

Aucun réglage « recommandé » n’est inventé dans ASSET-03.

---

# 14. Fichiers de référence

Ce lot ne commit aucun fichier image.

Les planches de sélection produites pendant la conception :

- servent à expliquer les décisions ;
- ne sont pas des assets du jeu ;
- ne sont pas des références techniques obligatoires ;
- ne sont pas ajoutées automatiquement au dépôt ;
- ne définissent pas seules un visage final reproductible.

ASSET-02 reste l’autorité textuelle sur les personnages.

ASSET-03 reste l’autorité textuelle sur les lieux.

---

# 15. Verdict documentaire

```text
ASSET-01 : inchangé
ASSET-02 : inchangé
ASSET-03 : référence active de préproduction
PILOT-01 : huit fichiers sélectionnés, non générés
Production visuelle : non commencée
Anima / ComfyUI : non lancé en production
Runtime / JSON / tests / UI : inchangés
Prochaine étape : ASSET-04, à définir séparément
```
