# V0.78 — J4/J5 Runtime Source Audit

## 1. Décision de lecture

Le brut validé prime sur le JSON pour le texte, le ton, les beats et l’ordre émotionnel.
Le JSON reste l’implémentation technique.

## 2. Méthode

Catégories :
- conforme ;
- adaptation technique acceptable ;
- divergence mineure ;
- divergence importante ;
- bloquant.

Lecture appliquée ici :
- V0.76 / V0.77 sont la référence canonique narrative pour J4 / J5 ;
- le runtime JSON peut adapter la forme, pas réécrire le fond ;
- si un fichier runtime réactive l’ancien schéma social / panel / legacy, il doit être classé comme divergence importante ou bloquante ;
- les visual bundles sont audités avec le même principe : `is_proof`, `risk_level`, et compatibilité canonique priment sur la simple présence du fichier.

## 3. Audit J4

### 3.1 Source canonique V0.76

Source canonique J4, points verrouillés :
- J4 = lendemain domestique post-Mathilde ;
- Marie centre affectif ;
- Mathilde gênée / reconnaissante / non sexualisée ;
- Sandra écho doux ;
- Nico / Pauline / Raphaëlle absents du J4 actif ;
- ancien V0.64b “Marie & Pauline Outing” déplacé à J5 ;
- minimum 3 visuels ;
- emojis sobres ;
- pas de messages Marie/Player quand ils sont physiquement ensemble ;
- pas de panel ;
- pas de route lock ;
- pas de vocal ;
- pas d’explicite ;
- pas de proof fort.

### 3.2 Fichiers runtime J4 trouvés

Fichiers actifs repérés :
- `game/data/conversations/chapter_04_index.json`
- `game/data/conversations/chapter_04_pauline_invite.json`
- `game/data/conversations/chapter_04_marie_pre_party.json`
- `game/data/conversations/chapter_04_party_group_arrival.json`
- `game/data/conversations/chapter_04_route_pressure_and_debug.json`
- `game/data/conversations/chapter_04_conditional_proofs.json`
- `game/data/conversations/chapter_04_sandra_bad_timing.json`
- `game/data/conversations/chapter_04_pauline_late_control.json`
- `game/data/conversations/chapter_04_mathilde_observes.json`
- `game/data/conversations/chapter_04_social_after_party.json`
- `game/data/conversations/chapter_04_raphaelle_lunch_contrast.json`
- `game/data/conversations/chapter_04_marie_morning_reaction.json`
- bundles visuels liés : `game/data/visual_content/chapter_04_proofs.json`, `game/data/visual_content/chapter_04_proofs_legacy.json`

### 3.3 Conformités

Conformes ou globalement compatibles :
- présence d’au moins 3 visuels dans le pack J4 courant (`chapter_04_proofs.json` contient 4 items) ;
- plusieurs visuels J4 sont soft, non-proof, risk 1 ;
- `chapter_04_marie_pre_party.json` et `chapter_04_party_group_arrival.json` restent techniquement centrés sur Marie et utilisent des réponses Player via choices ;
- la notion de photo consentie / sociale existe dans le runtime récent.

### 3.4 Adaptations techniques acceptables

Acceptable techniquement, mais pas suffisant pour canoniser le jour :
- `chapter_04_index.json` garde une logique de progression en 3 moments avec pending/lock technique, ce qui peut être lisible comme implémentation ;
- le bundle `chapter_04_proofs.json` contient 4 contenus, dont 3 soft et 1 Pauline risk 2, ce qui reste compatible avec un pack social léger si le cadre narratif était bon ;
- les notifications restent courtes et lisibles.

### 3.5 Divergences mineures

- quelques emojis et formulations sont un peu plus démonstratifs que le ton sobre attendu pour V0.76 ;
- la présence de `Raphaëlle` dans `chapter_04_raphaelle_lunch_contrast.json` peut être relue comme trace périphérique, mais elle ne correspond pas au verrou “absente du J4 actif” ;
- la surface de design parle encore parfois de “sortie”, “soirée”, “cadre social” au lieu de “lendemain domestique”.

### 3.6 Divergences importantes

- le runtime J4 actuel est encore construit comme un ancien J4 social / Pauline : `chapter_04_index.json` s’intitule “Marie sort avec Pauline”, avec `routes_available` marie + pauline et un flow de sortie ;
- `chapter_04_party_group_arrival.json` affiche un thread de groupe `Marie / Pauline`, ce qui contredit le J4 domestique centré Marie ;
- `chapter_04_pauline_invite.json` et `chapter_04_pauline_late_control.json` gardent Pauline comme moteur actif de la journée ;
- `chapter_04_social_after_party.json` réactive explicitement Nico, Pauline et une mémoire sociale de soirée ;
- `chapter_04_mathilde_observes.json` ramène Nico et Pauline dans le champ de J4 ;
- `chapter_04_route_pressure_and_debug.json` et `chapter_04_conditional_proofs.json` structurent déjà des preuves / routes / flags de pression post-soirée ;
- `game/data/visual_content/chapter_04_proofs_legacy.json` contient des `is_proof: true` et des risk 3–4 hérités, dont `capture_pauline_ludo_party_placeholder`, `capture_player_phone_party_j4_placeholder`, `photo_mathilde_after_party_warning_placeholder` ;
- le mot-clé `party` et le schéma “after party” restent actifs dans le runtime J4, alors que V0.76 verrouille un lendemain domestique.

### 3.7 Bloquants éventuels

- le runtime J4 ne peut pas être considéré comme conforme à V0.76 sans nettoyage structurel ;
- la présence de legacy party / panel / proof routes empêche une lecture canonique stricte ;
- les fichiers de preuve legacy réactivent explicitement un ancien matériau non compatible avec le verrou J4 ;
- la contradiction n’est pas cosmétique : elle touche l’ordre des beats, le rôle des personnages et la logique de jour.

### 3.8 Verdict J4

**Verdict : à réaligner**

Lecture honnête : J4 peut conserver des éléments techniques utiles, mais il ne peut pas rester tel quel comme version canonique V0.76. Un nettoyage runtime dédié est nécessaire avant d’appeler ce jour “verrouillé”.

## 4. Audit J5

### 4.1 Source canonique V0.77

Source canonique J5, points verrouillés :
- J5 = Marie + Pauline outing ;
- récupération propre de V0.64b ;
- Marie sort et redevient visible hors maison ;
- Pauline sociale, vive, complice, non manipulatrice ;
- Player regarde Marie à distance ;
- photos consenties / sociales / défendables ;
- minimum 3 visuels ;
- pas Nico actif ;
- pas Mathilde active ;
- pas Sandra active ;
- pas Raphaëlle active ;
- pas panel ;
- pas NTR ;
- pas route lock ;
- pas vocal ;
- pas explicite ;
- pas proof fort.

### 4.2 Fichiers runtime J5 trouvés

Fichiers actifs repérés :
- `game/data/conversations/chapter_05_index.json`
- `game/data/conversations/chapter_05_marie_morning.json`
- `game/data/conversations/chapter_05_social_story.json`
- `game/data/conversations/chapter_05_mathilde_followup.json`
- `game/data/conversations/chapter_05_pauline_photos.json`
- `game/data/conversations/chapter_05_raphaelle_boundary.json`
- `game/data/conversations/chapter_05_sandra_later.json`
- `game/data/conversations/chapter_05_pauline_last_photo.json`
- bundle visuel : `game/data/visual_content/chapter_05_proofs.json`

### 4.3 Conformités

Conformes ou partiellement compatibles :
- Marie est bien visible hors maison via photo / sortie ;
- Pauline reste sociale, vive, complice au niveau de la voix ;
- plusieurs contenus sont consentis ou défendables ;
- il y a au moins 3 contenus visuels dans le bundle J5 ;
- certaines lignes évitent l’explicite direct.

### 4.4 Adaptations techniques acceptables

- `chapter_05_marie_morning.json` place bien Marie au centre de départ ;
- `chapter_05_social_story.json` garde Nico léger dans sa forme, avec un ton crédible de miroir social ;
- `chapter_05_raphaelle_boundary.json` reste une respiration bureau lisible ;
- `chapter_05_sandra_later.json` peut fonctionner comme trace lointaine si J5 n’était pas censé l’activer, mais ce n’est pas canonique pour V0.77.

### 4.5 Divergences mineures

- Pauline est parfois formulée de façon plus “design / mécanisme” que V0.77 ne le souhaite ;
- certaines lignes ont une coloration un peu trop contrôlante / appât / photo-trace ;
- les choix Player peuvent parfois sonner plus “stance” que simple SMS, surtout dans les scènes les plus chargées.

### 4.6 Divergences importantes

- `chapter_05_index.json` n’est pas un J5 Marie + Pauline outing : il fait de Nico le premier pivot et ouvre la journée à six personnages actifs, ce qui contredit le verrou canonique ;
- `chapter_05_index.json` active Mathilde, Sandra et Raphaëlle, alors que V0.77 les exclut du J5 actif ;
- `chapter_05_social_story.json` est un thread Nico privé actif : Nico n’est donc pas seulement “regard à distance”, il structure le jour ;
- `chapter_05_pauline_last_photo.json` introduit une logique de photo-seed / quasi-preuve qui tire vers un J6+ plus lourd ;
- `chapter_05_pauline_photos.json` qualifie Pauline comme “pivot secondaire plus dangereux par retenue”, alors que V0.77 demande une Pauline complice, pas encore manipulatrice ;
- `chapter_05_sandra_later.json` réactive Sandra de façon active ;
- `chapter_05_mathilde_followup.json` réactive Mathilde en plein J5 ;
- `chapter_05_raphaelle_boundary.json` réactive Raphaëlle en J5 ;
- `game/data/visual_content/chapter_05_proofs.json` contient encore des legacy items à proof/risk élevés : `photo_party_after_j5_placeholder` (is_proof true, risk 4), `photo_mathilde_after_party_j5_placeholder` (is_proof true, risk 3), `pauline_cheating_proof_seed_j5_placeholder` (is_proof true, risk 4) ;
- le bundle J5 contient aussi une logique “Nico / Marie / social capture” qui ne correspond pas au lock V0.77.

### 4.7 Bloquants éventuels

- la divergence J5 n’est pas seulement de ton : c’est une divergence de structure, de casting et de hiérarchie de jours ;
- la présence de proof seeds et de personnages interdits dans le jour actif empêche une lecture canonique V0.77 ;
- le runtime actuel ressemble davantage à un ancien J5/J6 hybride qu’à la récupération simple de V0.64b décrite par V0.77.

### 4.8 Verdict J5

**Verdict : bloquant**

Le runtime J5 ne peut pas être maintenu tel quel si l’objectif est de respecter V0.77. Il faut un patch de réalignement avant toute intégration runtime propre.

## 5. Audit des visuels J4/J5

| content_id | jour | source canonique attendue | statut runtime | is_proof | risk_level | compatible oui/non | recommandation |
|---|---:|---|---|---:|---:|---|---|
| `photo_marie_evening_j4_placeholder` | J4 | Marie avant départ, soft, consentie, non proof | présent dans le runtime J4 actuel | false | 1 | oui, partiellement | conserver comme base, mais dans un J4 réaligné |
| `photo_pauline_soft_provocation_j4_placeholder` | J4 | Pauline complice légère, sans contrôle | présent | false | 2 | oui, avec prudence | acceptable techniquement, tonalité à calmer |
| `photo_marie_pauline_selfie_j4_placeholder` | J4 | selfie social doux | présent | false | 1 | non pour V0.76 | compatible avec le vieux J4 social, pas avec le J4 canonique |
| `photo_j4_terrace_placeholder` | J4 | trace sociale de sortie | présent | false | 1 | non pour V0.76 | legacy social, à déplacer hors J4 |
| `capture_player_phone_party_j4_placeholder` | J4 | non attendu en canonique | présent | true | 3 | non | legacy / trop haut / à retirer du flux canonique |
| `capture_pauline_ludo_party_placeholder` | J4 | non attendu | legacy proof | true | 4 | non | bloquant pour V0.76 |
| `story_nico_marie_after_party_placeholder` | J4 | non attendu | legacy social | false | 3 | non | legacy, à recycler plus tard |
| `photo_mathilde_after_party_warning_placeholder` | J4 | Mathilde non sexualisée | legacy proof | true | 3 | non | incompatible avec le lock J4 |
| `photo_group_last_party_placeholder` | J4/J5 | non attendu ici | présent comme mémoire sociale | false | 1 | non | garder en historique, pas en actif |
| `j5_marie_party_nico_frame` | J5 | Marie visible hors maison, sans pivot Nico | présent | false | 2 | non | à retirer du jour actif J5 |
| `j5_pauline_street_selfie` | J5 | Pauline sociale, photo consentie | présent | false | 1 | oui, partiellement | garder seulement si le jour est réaligné autour de Marie + Pauline |
| `j5_sandra_restaurant_soft_crop` | J5 | non attendu | présent | false | 1 | non | hors canon V0.77 |
| `j5_nico_thread_capture` | J5 | non attendu | présent | false | 1 | non | trop Nico pour V0.77 |
| `j5_nico_bar_context` | J5 | non attendu | présent | false | 1 | non | trop Nico pour V0.77 |
| `pauline_cheating_proof_seed_j5_placeholder` | J5 | pas de proof fort | présent | true | 4 | non | bloquant tant que J5 reste canonique V0.77 |
| `photo_mathilde_home_tier1_placeholder` | placeholder global | Mathilde non sexualisée | présent dans le pool global | true | 3 | non pour J4/J5 canon | à traiter comme legacy à verrouiller ailleurs |

## 6. Anti-régression

Vérifié dans les runtime et bundles audités :
- ancien J3 soirée / panel : présent comme héritage lexical et structural dans plusieurs fichiers legacy ;
- ancien J4 panel social : présent ;
- Nico actif trop tôt : présent en J4 et central en J5 ;
- Pauline manipulatrice trop tôt : présent en J4 tardif et en J5 sur plusieurs fichiers ;
- Mathilde sexualisée : trace legacy dans les bundles de preuve et dans le J4 social ancien ;
- Sandra active en J5 : présent ;
- Raphaëlle active en J4/J5 : présente ;
- proof fort : présent ;
- vocal : non vu dans les fichiers audités, mais le verrou canonique reste nécessaire ;
- explicite : non dominant dans ces extraits, mais le schéma legacy pousse vers une escalade ;
- route lock : présent comme logique technique à éviter en J4/J5 canon ;
- messages Marie/Player en présence physique : le vieux J4 social les réactive encore indirectement via scènes de sortie / groupe.

## 7. Tableau de réalignement futur

| jour | fichier runtime | divergence | gravité | recommandation | correction runtime nécessaire oui/non | version recommandée |
|---|---|---|---|---|---|---|
| J4 | `game/data/conversations/chapter_04_index.json` | sortie Pauline / panel social au lieu de lendemain domestique | importante | réaligner le jour, déplacer le social en J5 | oui | V0.79 |
| J4 | `game/data/conversations/chapter_04_party_group_arrival.json` | groupe / soirée / selfie social | importante | reconstituer en Marie domestique hors maison | oui | V0.79 |
| J4 | `game/data/conversations/chapter_04_pauline_invite.json` | Pauline active moteur du jour | importante | réduire Pauline à trace hors actif | oui | V0.79 |
| J4 | `game/data/conversations/chapter_04_pauline_late_control.json` | capture / contrôle / fin de soirée | importante | supprimer du jour canonique | oui | V0.79 |
| J4 | `game/data/conversations/chapter_04_conditional_proofs.json` | proof routing legacy / party memory | bloquante | remplacer par un J4 soft non-proof | oui | V0.79 |
| J4 | `game/data/visual_content/chapter_04_proofs_legacy.json` | proof fort et risk élevé | bloquante | retirer du flux canonique J4 | oui | V0.79 |
| J5 | `game/data/conversations/chapter_05_index.json` | Nico premier pivot + six personnages actifs | bloquante | recentrer sur Marie + Pauline | oui | V0.79 |
| J5 | `game/data/conversations/chapter_05_social_story.json` | Nico actif, pas simple distance | bloquante | reclasser en trace future ou supprimer du jour | oui | V0.79 |
| J5 | `game/data/conversations/chapter_05_pauline_photos.json` | Pauline trop contrôlante / design | importante | adoucir Pauline en complice sociale | oui | V0.79 |
| J5 | `game/data/conversations/chapter_05_sandra_later.json` | Sandra active trop tôt | importante | déplacer plus tard | oui | V0.79 |
| J5 | `game/data/conversations/chapter_05_mathilde_followup.json` | Mathilde active trop tôt | importante | déplacer plus tard | oui | V0.79 |
| J5 | `game/data/conversations/chapter_05_raphaelle_boundary.json` | Raphaëlle active trop tôt | importante | déplacer plus tard | oui | V0.79 |
| J5 | `game/data/conversations/chapter_05_pauline_last_photo.json` | photo-seed / proof heavy | bloquante | remonter en doc legacy ou supprimer du canon J5 | oui | V0.79 / V0.80 |
| J5 | `game/data/visual_content/chapter_05_proofs.json` | proof fort, Nico, Mathilde, seed J6+ | bloquante | purge / remaquettage du bundle | oui | V0.79 |

## 8. Verdict final

- **J4 peut rester tel quel ?** Non.
- **J5 peut rester tel quel ?** Non.
- **Une V0.79 de réalignement runtime est nécessaire ?** Oui.
- **Fichiers concernés en priorité :** `chapter_04_index.json`, `chapter_04_pauline_invite.json`, `chapter_04_marie_pre_party.json`, `chapter_04_party_group_arrival.json`, `chapter_04_route_pressure_and_debug.json`, `chapter_04_conditional_proofs.json`, `chapter_04_pauline_late_control.json`, `chapter_04_social_after_party.json`, `chapter_04_mathilde_observes.json`, `chapter_04_raphaelle_lunch_contrast.json`, `chapter_05_index.json`, `chapter_05_marie_morning.json`, `chapter_05_social_story.json`, `chapter_05_mathilde_followup.json`, `chapter_05_pauline_photos.json`, `chapter_05_raphaelle_boundary.json`, `chapter_05_sandra_later.json`, `chapter_05_pauline_last_photo.json`, `chapter_04_proofs.json`, `chapter_04_proofs_legacy.json`, `chapter_05_proofs.json`, et les visuels partagés qui portent ces IDs.
- **Peut-on passer directement à l’intégration runtime J4/J5 ?** Non. Il faut d’abord un patch de nettoyage / réalignement, sinon on intègre une lecture legacy incompatible avec V0.76 / V0.77.

### Conclusion courte

J4 est déjà legacy par rapport à V0.76 ; J5 est encore plus éloigné de V0.77. La bonne suite est une V0.79 de nettoyage runtime, pas une simple intégration.
