# Réseau Intime — 08 Règles des scènes modulaires

## Statut du document

**Catégorie : Canon**

**Niveau : Contrat de conception, d’adaptation et de validation des scènes**

Ce document définit comment une séquence de la bibliothèque narrative devient une ou plusieurs scènes concrètes adaptées à l’état réel de la partie.

Il s’applique :

- aux scènes de premier plan ;
- aux scènes de conséquence ;
- aux scènes de respiration ;
- aux transitions ;
- aux interactions hors téléphone ;
- aux échos ;
- aux scènes érotiques, sexuelles ou pornographiques ;
- aux futures cartes de scènes ;
- aux adaptations d’anciennes scènes.

Ce document ne contient :

- aucun dialogue définitif ;
- aucun découpage en journées ;
- aucun schéma JSON définitif ;
- aucune variable runtime imposée ;
- aucune obligation de refonte technique ;
- aucune validation automatique des scènes existantes.

Pour la direction narrative, ce document devient l’autorité principale sur les scènes modulaires.

Le document historique :

`docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md`

reste une référence technique utile jusqu’à sa réconciliation documentaire. En cas de contradiction, la présente Bible, les canons complets des personnages et les règles de consentement prévalent.

---

# 1. Principe directeur

> **Une scène modulaire n’est pas un contenu libre que le système place lorsqu’un personnage est disponible.**

Elle est l’incarnation précise :

- d’une séquence validée ;
- dans un contexte crédible ;
- avec des personnages concrets ;
- selon un historique réel ;
- avec une fonction dramatique unique ;
- et avec une conséquence que l’histoire peut retenir.

Une scène doit répondre à cinq questions :

1. Quelle séquence incarne-t-elle ?
2. Pourquoi peut-elle avoir lieu maintenant ?
3. Pourquoi avec ces personnages précis ?
4. Qu’est-ce qui change parce qu’elle a eu lieu ?
5. Que devient-elle si le joueur ne la voit pas ou refuse son ouverture ?

Une scène n’est pas modulaire parce qu’elle est stockée dans un fichier séparé.

Elle est modulaire lorsqu’elle peut :

- apparaître dans plusieurs chronologies compatibles ;
- lire seulement les éléments d’historique qui changent son sens ;
- adapter son entrée, son ton et son résultat ;
- conserver un moteur dramatique stable ;
- muter ou expirer sans bloquer la saison ;
- produire une conséquence persistante ;
- préserver le canon du personnage.

---

# 2. Hiérarchie de conception

Toute scène doit respecter l’ordre suivant :

```text
North Star
→ Expérience joueur
→ Fantasmes centraux
→ Canon complet du personnage
→ Route macro
→ Évolution érotique
→ Acte
→ Séquence
→ Scène modulaire
→ Dialogues et photos
→ Distribution temporelle
→ Runtime
```

Une scène :

- ne crée pas une route absente de la Bible ;
- ne modifie pas l’identité d’un personnage ;
- ne remplace pas une progression par une récompense ;
- ne déduit pas une permission d’un score ;
- ne change pas seule l’architecture de la saison ;
- ne doit pas être écrite en fonction d’une limitation runtime non encore confirmée.

---

# 3. Différence entre séquence, fenêtre et scène

## Séquence

Une séquence est un événement dramatique de haut niveau défini dans :

`07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md`

Elle fixe notamment :

- la situation ;
- le personnage dominant ;
- la fonction ;
- les ancrages ;
- les éléments fixes ;
- la trace ;
- l’état de sortie attendu.

Exemple :

> **S21 — La fermeture cassée**

Une pièce de costume de Raphaëlle pose un problème concret et permet à Player d’entrer dans le processus créatif sans confondre aide, regard et permission.

## Fenêtre narrative

Une fenêtre est le contexte dans lequel une scène peut devenir possible.

Elle contient :

- lieu ;
- moment ;
- personnages disponibles ;
- degré de confidentialité ;
- témoins ;
- moyen de communication ;
- pression temporelle ;
- plafond d’intensité ;
- obligations dues ;
- scènes en cooldown.

## Scène modulaire

La scène est l’incarnation exacte d’une séquence dans une fenêtre donnée.

Exemples possibles pour S21 :

- Raphaëlle demande à Player un avis photographique à distance ;
- Player apporte un objet dans l’atelier pendant que Maud est présente ;
- une fermeture casse après un essayage, puis un échange a lieu après leur séparation ;
- Raphaëlle refuse finalement l’aide et envoie plus tard une photo du résultat ;
- Player a déjà mal interprété une image et n’est plus invité dans l’atelier.

Ces scènes partagent une fonction.

Elles ne partagent pas nécessairement :

- les mêmes dialogues ;
- le même canal ;
- le même degré de proximité ;
- le même résultat ;
- la même audience ;
- la même conséquence.

---

# 4. Contrat minimal d’une scène

Toute scène de premier plan doit définir les blocs suivants avant rédaction de ses dialogues.

## 4.1 Identité

```text
scene_id
working_title
source_sequence_id
scene_class
primary_function
principal_character
primary_relationship
affected_relationships
```

### `scene_id`

Identifiant stable, descriptif et indépendant d’un numéro de journée lorsque le jour n’est pas dramatiquement obligatoire.

Format recommandé :

```text
<character_or_hub>_<sequence_engine>_<variant>
```

Exemples :

```text
raphaelle_broken_fastener_workshop_01
sandra_printed_trace_after_shift_01
mathilde_chosen_outfit_return_01
pauline_restore_surface_after_crop_01
nico_inside_outside_gaze_offer_01
marie_laverriere_join_or_delay_01
```

### `source_sequence_id`

Toute scène importante doit pointer vers une séquence de `07`.

Exemple :

```text
source_sequence_id: S21
```

Une scène sans séquence source doit expliquer :

```text
new_sequence_candidate
reason_the_library_does_not_cover_it
```

Elle ne peut pas entrer directement en production sans validation de cette nouvelle fonction.

### `primary_function`

Une seule fonction dramatique principale.

Exemples :

- accès ordinaire ;
- invitation ;
- regard reconnu ;
- limite ;
- image destinée ;
- réparation ;
- dette d’alibi ;
- reconnaissance du désir ;
- collision ;
- après-coup.

Une scène peut affecter plusieurs dimensions, mais elle ne doit pas chercher simultanément à accomplir quatre transformations majeures.

### `primary_relationship`

Une relation principale seulement.

Exemples :

- Player / Marie ;
- Player / Sandra ;
- Player / Mathilde ;
- Player / Pauline ;
- Player / Raphaëlle ;
- Player / Nico ;
- Marie / Pauline ;
- Player / Marie / Mathilde dans une scène réellement triangulaire.

Les autres relations peuvent recevoir :

- une trace ;
- une obligation ;
- une suspicion ;
- un futur hook ;
- une conséquence due.

Elles ne doivent pas toutes progresser de niveau dans la même scène.

---

# 5. Dépendances canoniques obligatoires

Chaque carte de scène doit lister :

```text
required_bible_files
required_character_files
required_adult_canon
relevant_deprecation_maps
supporting_character_sources
```

Exemple :

```text
required_bible_files:
- 05_ROUTES_MACRO_SAISON_1.md
- 06_EVOLUTION_EROTIQUE_DES_ROUTES.md
- 07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md

required_character_files:
- RAPHAELLE_CANON_FULL.md
- PLAYER_CANON_FULL.md
- MARIE_CANON_FULL.md

required_adult_canon:
- NSFW_CHARACTER_ROUTE_CANON.md

relevant_deprecation_maps:
- RAPHAELLE_CANON_DEPRECATION_MAP.md
```

Une carte de scène isolée ne doit jamais pouvoir réintroduire :

- une identité dépréciée ;
- une orientation contradictoire ;
- un ancien ordre fixe des journées ;
- une permission adulte disparue ;
- un partenaire supprimé par commodité ;
- un objet ou comportement devenu non canonique.

---

# 6. Contrat d’ancrage du personnage

Toute scène doit utiliser au moins **deux ancrages concrets** du canon complet du personnage.

Ces ancrages peuvent être :

- métier ;
- lieu ;
- objet ;
- proche ;
- pratique ;
- habitude ;
- blessure ;
- contradiction ;
- moteur relationnel ;
- moteur érotique ;
- manière de parler ;
- manière de se retirer.

Une scène n’est pas spécifique parce qu’elle contient le prénom du personnage.

## Test d’interchangeabilité

Poser la question :

> **La scène fonctionnerait-elle presque à l’identique avec un autre personnage en remplaçant les noms ?**

Si oui, elle doit être réécrite.

### Exemple trop générique

```text
Le personnage envoie une photo de tenue.
Player complimente.
Le personnage hésite puis sourit.
```

### Mathilde

```text
Le vêtement est déjà ordinaire pour elle.
Elle découvre que Player connaît maintenant le modèle qu’il remarque.
Elle corrige sa propre demande d’avis.
La confiance de Marie rend l’effet plus lourd.
```

### Pauline

```text
La tenue est socialement légitime.
La différence vient d’un cadrage que Bastien et Marie ne reçoivent pas.
Pauline teste si Player sait préserver un compartiment.
```

### Raphaëlle

```text
L’image montre un processus de fabrication ou une version choisie.
Raphaëlle nomme l’audience.
Le rôle, le craft et ce qui restera après comptent davantage que l’exposition du corps.
```

---

# 7. Noyau stable et variables modulaires

Chaque scène doit distinguer :

```text
stable_kernel
variable_context
mutation_rules
```

## Noyau stable

Le noyau est la chaîne causale qui ne change pas entre les variantes.

Exemple S21 — Raphaëlle :

```text
problème réel de costume
→ Player obtient ou demande un accès au processus
→ Raphaëlle décide ce qu’il peut voir
→ l’aide, le regard et la permission sont distingués
→ l’accès créatif est ouvert, limité ou fermé
```

## Contexte variable

Peut modifier :

- lieu précis ;
- présence de Maud ;
- scène distante ou physique ;
- compte créatif déjà révélé ;
- Marie informée, non informée ou seulement évoquée ;
- confiance professionnelle ;
- incident précédent ;
- audience de la photo ;
- intensité disponible.

## Mutation

Une scène doit pouvoir devenir autre chose lorsque son contexte principal disparaît.

Exemples :

- l’essayage devient une photo du résultat après refus d’accès ;
- le café devient un message bref parce que Sandra est retenue à SentryCore ;
- la demande d’avis de Mathilde devient une scène de distance après une limite franchie ;
- le compartiment Pauline devient une réparation sociale après découverte ;
- l’alibi Nico devient un refus et une dette relationnelle ;
- la sortie Marie devient une action autonome si Player ne répond pas.

---

# 8. Éligibilité

L’éligibilité comporte quatre niveaux.

## 8.1 Conditions obligatoires

Toutes doivent être vraies.

Exemples :

- la séquence source est encore disponible ;
- le personnage dispose d’un accès ordinaire suffisant ;
- le lieu est accessible ;
- l’intensité de l’acte autorise la scène ;
- la trace nécessaire existe ;
- l’audience requise est encore possible ;
- aucune limite bloquante n’a été posée ;
- le personnage n’est pas déjà engagé ailleurs ;
- une scène sexuelle ne précède pas sa progression relationnelle.

## 8.2 Exclusions dures

Une seule exclusion bloque la scène.

Exemples :

- refus clair non réparé ;
- route fermée ;
- personnage indisponible ;
- conséquence de sécurité due ;
- scène de même moteur utilisée trop récemment ;
- image supprimée avant l’envoi ;
- partenaire physiquement présent lorsque la scène exige une intimité cachée ;
- niveau d’acte trop bas ;
- canal incompatible ;
- chronologie déjà dépassée ;
- consentement expiré ;
- confiance professionnelle rompue ;
- séjour de Mathilde terminé pour une scène exigeant la cohabitation.

## 8.3 Préférences souples

Améliorent la pertinence sans être obligatoires.

Exemples :

- Player a remarqué un objet plus tôt ;
- Sandra a déjà reçu une réponse précise ;
- Pauline a déjà testé une différence d’audience ;
- Raphaëlle a déjà révélé son compte ;
- Nico a déjà nommé son attirance ;
- Marie a déjà proposé une activité similaire ;
- Mathilde a déjà reconnu un regard sans encore choisir l’effet.

## 8.4 Raison de disponibilité

Toute scène doit préciser pourquoi le personnage est disponible maintenant.

Exemples :

- Marie prépare un événement à La Verrière ;
- Sandra termine un poste du soir ;
- Mathilde vit temporairement dans l’appartement ;
- Pauline sort de répétition de chorale ;
- Raphaëlle termine un atelier ou prépare une convention ;
- Nico vient de fermer L’Annexe.

> **La disponibilité est une réalité de la vie du personnage, pas une récompense produite par son intérêt pour Player.**

---

# 9. Lecture limitée de l’état

Une scène ne doit lire que les états qui modifient réellement son sens.

## Couple

- état actuel Marie–Player ;
- présence ou absence récente ;
- promesse due ;
- confiance ;
- vérité cachée ou reconnue ;
- cadre exclusif, négocié ou fracturé ;
- conséquence Marie due.

## Route principale

- état actuel ;
- accès ;
- désir reconnu ;
- limite ouverte ;
- route en pause ou fermée ;
- scène récente ;
- sentiment d’avoir été utilisé ;
- question en suspens.

## Monde

- lieu ;
- horaire ;
- travail ;
- transport ;
- logement ;
- événement ;
- présence de Jeff ou Bastien ;
- Maud disponible ;
- séjour Mathilde actif ;
- L’Annexe ouvert ou fermé.

## Traces

- image existante ;
- origine ;
- créateur ;
- audience prévue ;
- audience réelle ;
- sauvegarde ;
- suppression ;
- transfert ;
- objet déplacé ;
- alibi actif ;
- risque de découverte.

## Connaissance

Pour chaque personnage :

```text
CONNU
SOUPÇONNÉ
MAL_INTERPRÉTÉ
INCONNU
```

## Consentement

- participants ;
- activité autorisée ;
- audience ;
- sauvegarde ;
- transfert ;
- durée ;
- signaux de ralentissement ;
- cadre informé ou caché ;
- conséquence promise.

Une scène ne doit pas lire cinquante variables pour paraître réactive.

Elle doit lire les quelques faits qui changent :

- la signification ;
- la voix ;
- le consentement ;
- la conséquence ;
- la disponibilité.

---

# 10. Classes de scènes

## 10.1 Scène pilier

Accomplit une fonction obligatoire de la saison.

Règles :

- ne disparaît pas à cause d’un score faible ;
- peut avoir plusieurs incarnations ;
- possède un fallback ;
- peut être retardée seulement dans une plage définie ;
- ne force pas un résultat de route précis.

## 10.2 Opportunité de route

Ouvre une possibilité propre au personnage.

Règles :

- accès ordinaire déjà établi ;
- contexte crédible ;
- aucune conséquence prioritaire impayée ;
- peut être manquée ;
- expire ou mute ;
- ne reste pas disponible éternellement sans changement.

## 10.3 Continuation de route

Paie un état déjà construit.

Règles :

- historique compatible ;
- pas de contradiction avec une limite ;
- moteur différent de la scène immédiatement précédente ;
- nouvelle décision ou nouvelle conséquence ;
- pas de répétition avec seulement davantage de nudité ou de franchise.

## 10.4 Scène de conséquence

Paie :

- promesse ;
- mensonge ;
- alibi ;
- découverte ;
- image ;
- attente ;
- limite ;
- sexualité ;
- retour au travail ;
- retour au foyer.

Règles :

- priorité sur une nouvelle opportunité ;
- personnages affectés identifiés ;
- aucun reset propre ;
- état de sortie explicite.

## 10.5 Respiration

Renforce la réalité du personnage sans escalade déguisée.

Elle peut montrer :

- travail ;
- famille ;
- craft ;
- repas ;
- fatigue ;
- humour ;
- rangement ;
- routine ;
- loisir ;
- déplacement.

Une respiration n’est pas un remplissage.

Elle prépare les scènes intenses en donnant une existence au personnage en dehors du désir.

## 10.6 Écho

Petit beat contextuel.

Il peut être :

- message court ;
- notification ;
- objet déplacé ;
- image publique ;
- changement de ton ;
- souvenir ;
- réponse différée ;
- réaction sociale.

Un écho ne peut pas :

- créer une bascule ;
- établir un consentement adulte ;
- cacher une décision irréversible ;
- remplacer un après-coup ;
- faire avancer une route complète.

## 10.7 Interaction hors téléphone

Interaction jouée ou inférée hors du téléphone.

Règles :

- raison de sortie du chat claire ;
- durée approximative ;
- fonction définie ;
- résultat observable plus tard ;
- absence de faux transcript ;
- aucune carte explicative obligatoire à l’écran.

## 10.8 Clôture de route ou de saison

Établit un nouvel état durable.

Elle ne résume pas une route par un score.

Elle doit utiliser :

- action ;
- trace ;
- règle ;
- départ ;
- image recontextualisée ;
- changement d’habitude ;
- décision du personnage.

---

# 11. Budget de premier plan

Une fenêtre narrative contient par défaut :

```text
1 scène de premier plan
0 à 2 échos
```

## Règles

- une seule relation principale peut connaître une évolution majeure ;
- une scène de convergence peut affecter plusieurs relations, mais doit désigner son effet principal ;
- les relations secondaires peuvent recevoir une dette, un soupçon ou un hook ;
- une scène ne doit pas augmenter simultanément confiance, désir, secret, consentement, couple et route secondaire ;
- une scène de premier plan ne doit pas être cachée sous forme de notification ;
- après une scène explicite ou une découverte majeure, la prochaine scène compatible doit être un après-coup, une conséquence ou un retour ordinaire.

Le joueur ne doit pas avoir l’impression que six routes réclament simultanément son attention.

---

# 12. Ordre de priorité

Lorsque plusieurs scènes sont éligibles :

## A — Sécurité, consentement et après-coup

- limite franchie ;
- retrait ;
- image diffusée ;
- suppression demandée ;
- retour après une scène explicite ;
- sécurité émotionnelle ;
- retour professionnel difficile.

## B — Fonction pilier due

- acte obligatoire ;
- transformation du foyer ;
- mouvement de Marie ;
- convergence ;
- discussion du cadre du couple.

## C — Obligation due

- promesse ;
- invitation ;
- dette ;
- alibi ;
- objet à rendre ;
- question laissée ouverte ;
- image à supprimer ;
- retour attendu.

## D — Continuation active

- route dont la progression appelle une conséquence ou une nouvelle décision.

## E — Nouvelle opportunité

- accès ;
- invitation ;
- variation ;
- entrée d’un personnage.

## F — Respiration ou fallback

- vie ordinaire ;
- rythme ;
- aucun progrès de route nécessaire.

Départage :

```text
cohérence du contexte
→ conséquence la plus en retard
→ scène encore jamais vue
→ opportunité différée le plus longtemps
→ moteur le moins récemment utilisé
→ ordre déterministe écrit
```

Aucune sélection aléatoire ne précède ces critères.

---

# 13. Contrat temporel et spatial

Toute carte de scène doit définir :

```text
calendar_anchor
time_band
approximate_clock_range
elapsed_since_previous_window
temporal_cues
physical_context
communication_mode
why_message_is_used
when_messaging_stops
offline_continuation
```

## Temps

La scène doit être compatible avec :

- horaires de travail ;
- sommeil ;
- transports ;
- repas ;
- ouverture des lieux ;
- événements ;
- délai émotionnel ;
- date d’une promesse ;
- expiration d’une occasion.

## Présence physique

Deux personnages capables de parler normalement dans la même pièce ne mènent pas une longue conversation Messenger.

Le téléphone peut servir à :

- transmettre une photo ;
- envoyer une adresse ;
- localiser un objet ;
- faire un aparté discret ;
- conserver une trace ;
- lancer un rendez-vous.

Lorsque les personnages se rejoignent, le chat s’arrête.

## Modes de communication

### `REMOTE_ASYNC`

Lieux différents, échanges personnels normaux.

### `TRACE_DELIVERY`

La communication existe parce qu’une image, un document ou un lien est transmis.

### `SEPARATE_ROOMS_PING`

Même logement, pièces séparées, demande brève.

### `SAME_VENUE_LOGISTICS`

Même lieu, bruit, public ou tâches différentes.

### `WORK_CHAT`

Échange professionnel justifié.

### `AFTERGLOW_REMOTE`

Message après séparation physique.

### `OFFLINE_BEAT`

Interaction hors téléphone dont le résultat sera visible plus tard.

---

# 14. Contrat des choix

## Trois choix par défaut

```text
maximum recommandé : 3 choix par nœud
```

Chaque choix doit représenter une posture ou une action différente.

Exemples :

```text
s’engager
négocier ou reformuler
ralentir ou refuser
```

ou :

```text
rejoindre Marie
laisser Marie agir seule
honorer une responsabilité différente
```

## Un axe de décision par nœud

Un seul choix ne doit pas décider simultanément :

- du désir ;
- du mensonge ;
- de la sauvegarde d’une image ;
- de la relation avec Marie ;
- d’un trio ;
- d’une séparation.

Ces décisions doivent être réparties dans plusieurs beats.

## Messages réels

Les choix doivent produire :

- une phrase réelle de Player ;
- une action ;
- un silence assumé ;
- un refus ;
- un déplacement ;
- une demande précise.

Interdit :

```text
Choisir la sincérité
Séduire Mathilde
Activer la route Pauline
Être fidèle
```

## Quatre choix ou plus

Exception uniquement si trois choix fusionneraient :

- des consentements différents ;
- des participants différents ;
- des conséquences irréversibles distinctes ;
- des activités qui ne peuvent pas être regroupées sans ambiguïté.

L’intensité adulte n’est pas une justification suffisante.

## Scène sans choix

Valide lorsqu’elle est :

- conséquence obligatoire ;
- action initiée par un personnage ;
- transition ;
- après-coup ;
- résultat d’un choix topologique antérieur ;
- écho.

Ne pas ajouter de faux choix.

---

# 15. Agence du personnage

Chaque carte doit répondre :

- Que veut le personnage dans cette scène ?
- Que refuse-t-il ?
- Que peut-il initier ?
- Que sait-il ?
- Que comprend-il mal ?
- Que fait-il si Player reste passif ?
- Que fait-il si Player pousse ?
- Que fait-il si Player refuse ?
- Qu’est-ce qui lui ferait quitter la scène ?
- Que fait-il ensuite indépendamment de Player ?

Le choix de Player n’écrit pas directement les émotions de l’autre personnage.

Modèle correct :

```text
Player accomplit une action
→ le personnage l’interprète selon son histoire et son état
→ le personnage choisit sa réponse
→ la relation change ou non
```

---

# 16. Contrat des écritures d’état

Chaque scène de premier plan doit lister ce qui change.

## Couple

- présence améliorée ou dégradée ;
- désir exprimé ;
- confiance réparée ou tendue ;
- vérité cachée ou révélée ;
- question de cadre ouverte ;
- conséquence Marie due.

## Route principale

- accès ordinaire ;
- accès chargé ;
- désir reconnu ;
- limite respectée ou cassée ;
- route avancée ;
- route en pause ;
- route fermée ;
- après-coup dû ;
- personnage retiré.

## Obligation

- promesse ;
- dette ;
- alibi ;
- réponse attendue ;
- suppression ;
- retour d’objet ;
- présence à un événement ;
- conversation future.

## Trace

- image créée ;
- image envoyée ;
- version différente ;
- objet déplacé ;
- témoin ;
- notification vue ;
- phrase devenue code ;
- comportement modifié.

## Connaissance

- fait connu ;
- soupçon ;
- erreur corrigée ;
- croyance fausse renforcée.

## Consentement

- activité acceptée ;
- activité refusée ;
- audience nommée ;
- sauvegarde permise ou interdite ;
- transfert interdit ;
- cadre expiré ;
- confirmation directe nécessaire.

Une scène ne doit pas écrire positivement dans toutes ces catégories.

---

# 17. Contrat de sortie

Toute scène doit définir :

```text
exit_state
follow_up_functions
consequence_due
cooldown
expiry
mutation_if_deferred
fallback_if_unseen
```

## État de sortie

Résumé des faits désormais vrais.

Exemple :

```text
Raphaëlle sait que Player s’intéresse au processus.
Elle ne lui a pas donné accès au compte complet.
Maud connaît seulement l’aide technique.
Marie n’est pas informée de l’attirance.
Une invitation à voir le costume terminé reste possible.
```

## Follow-up

Lister des fonctions, pas une scène obligatoire unique.

Exemples :

- photo du résultat ;
- retour au travail ;
- invitation à l’atelier ;
- discussion de l’audience ;
- distance professionnelle ;
- conséquence Marie ;
- réparation après une mauvaise interprétation.

## Conséquence due

- immédiate ;
- prochaine fenêtre compatible ;
- liée à un acte futur ;
- facultative ;
- aucune.

## Cooldown

Empêche la répétition trop rapide du même moteur.

## Expiration

Une opportunité peut :

- expirer ;
- refroidir ;
- changer de canal ;
- perdre son image ;
- devenir une occasion manquée ;
- être accomplie sans Player.

## Mutation

Une scène différée ne doit pas toujours réapparaître identique.

---

# 18. Traces, images et objets

Toute trace importante doit définir :

```text
trace_id
origin
creator
initial_holder
intended_audience
actual_audience
consent_level
save_rule
forward_rule
knowledge_state
risk
expiry
possible_payoffs
```

## Regard partagé autorisé

La personne représentée sait :

- que l’image existe ;
- qui la voit ;
- pourquoi ;
- ce qui peut être sauvegardé ;
- ce qui peut être transféré.

## Recontextualisation non autorisée

Une image légitime change :

- d’audience ;
- de cadrage ;
- de fonction ;
- de sauvegarde ;
- de lecture sexuelle.

Cette voie est une trahison, même lorsque l’image n’est pas nue.

## Capture prohibée

- caméra cachée ;
- vol d’image intime ;
- personne endormie ou incapable de choisir ;
- enregistrement secret d’un acte sexuel ;
- menace.

Ce contenu ne constitue jamais une récompense normale.

## Suppression

La suppression retire ou réduit une preuve.

Elle n’efface pas :

- l’événement ;
- les personnes qui ont vu ;
- les souvenirs ;
- la confiance perdue ;
- les changements de comportement ;
- une copie déjà établie.

---

# 19. Contrat adulte

Toute scène qui modifie une permission sexuelle ou pornographique doit préciser :

```text
who_consents
activity
participants
watchers
image_recipients
save_rule
forward_rule
forbidden_elements
frame_duration
slow_or_stop_signals
aftermath_promised
informed_or_excluded_people
```

Un cadre peut être volontairement caché.

Il doit alors être nommé :

```text
frame: infidélité cachée
Marie n’est pas informée.
Les participants savent qu’elle n’est pas informée.
Leur consentement mutuel ne crée pas celui de Marie.
```

Les formulations suivantes sont insuffisantes :

```text
couple plutôt ouvert
elle doit être d’accord
on verra
cadre libre
```

---

# 20. Règle de centralité de Marie

Une scène extérieure ne doit pas transformer Marie en sanction automatique.

Elle doit toutefois rester dans la vie partagée tant que le couple n’a pas changé de cadre.

Une scène externe peut créer :

- conséquence Marie due ;
- action indépendante de Marie ;
- changement du retour au foyer ;
- promesse manquée ;
- nouvelle visibilité ;
- comparaison ;
- question de vérité ;
- possibilité de reconquête.

Toutes les scènes externes ne doivent pas produire une dispute.

Mais aucune route externe importante ne doit exister dans un univers où Marie disparaît.

---

# 21. Tests propres aux personnages

## Marie

- La scène montre-t-elle pourquoi sa vie est désirable ?
- Agit-elle pour elle-même ?
- La Verrière, le foyer ou son mouvement concret sont-ils utilisés ?
- Player doit-il accomplir quelque chose, pas seulement parler ?
- Marie existe-t-elle autrement que comme conséquence d’une autre route ?

## Sandra

- Existe-t-il une trace concrète ou une distance choisie ?
- Sandra contrôle-t-elle ce qu’elle montre ?
- SentryCore, ses refuges, Jeff ou les Tilleuls sont-ils pertinents ?
- La pression est-elle évitée ?
- Le silence ou le retrait ont-ils un sens ?

## Mathilde

- Le dégât des eaux et le séjour temporaire restent-ils cohérents ?
- La sensualité ordinaire est-elle distinguée de l’intention ?
- La confiance de Marie pèse-t-elle réellement ?
- Mathilde conserve-t-elle compétence, travail, humour et dignité ?
- Peut-elle arrêter, partir ou modifier le cadre ?

## Pauline

- Bastien et la vie officielle existent-ils ?
- L’ancienne infidélité éclaire-t-elle sans résumer la scène ?
- La différence d’audience est-elle concrète ?
- Le compartiment produit-il un risque réel ?
- Marie est-elle amie, conséquence et non autorisation ?

## Raphaëlle

- Le craft ou le processus existent-ils réellement ?
- Le cosplay est-il autre chose qu’une tenue sexy ?
- L’audience est-elle choisie ?
- Travail et accès privé sont-ils séparés ?
- Le rôle possède-t-il une fin ?
- L’après du rôle est-il prévu ?
- La clarté locale évite-t-elle de se présenter comme innocence globale ?

## Nico

- Nico est-il explicitement hétérosexuel dans la logique de la scène ?
- Son intérêt porte-t-il sur Marie, Mathilde ou une autre femme concrètement établie ?
- L’Annexe, le regard social ou sa vie ordinaire sont-ils utilisés ?
- L’origine d’une image est-elle crédible ?
- La femme concernée reste-t-elle sujet de son propre désir ?
- L’amitié avec Player est-elle réelle ?
- Rivalité ou regard partagé évitent-ils toute ambiguïté sexuelle cachée entre les hommes ?
- Nico peut-il refuser d’être utilisé ?

## Player

- Envoie-t-il un vrai message ou accomplit-il une vraie action ?
- Son observation peut-elle être fausse ?
- Choisit-il, diffère-t-il, refuse-t-il, cache-t-il ou revient-il ?
- Assume-t-il ce qu’il demande ?
- Est-il plus qu’une caméra ?

---

# 22. Exemple de carte — S21 La fermeture cassée

Cette carte illustre le niveau de conception attendu. Elle ne contient aucun dialogue définitif.

```yaml
scene_id: raphaelle_broken_fastener_workshop_01
working_title: La fermeture ne tient pas
source_sequence_id: S21
scene_class: route_opportunity
primary_function: creative_access
principal_character: Raphaëlle
primary_relationship: Player / Raphaëlle
affected_relationships:
  - Player / Marie
  - Raphaëlle / Maud

required_character_files:
  - RAPHAELLE_CANON_FULL.md
  - PLAYER_CANON_FULL.md
  - MARIE_CANON_FULL.md

required_adult_canon:
  - NSFW_CHARACTER_ROUTE_CANON.md

act_range:
  - Act II
  - Act III

route_stage_range:
  - ordinary_work_access
  - personal_curiosity
  - creative_access

intensity:
  minimum: ordinary
  maximum: acknowledged_attraction

canon_anchors:
  - garment_bag
  - red_seam_ripper
  - Maud
  - home_workshop
  - incomplete_fitting
  - chosen_audience

hard_requirements:
  - real_costume_problem_exists
  - professional_task_is_resolved
  - Raphaëlle_route_not_closed
  - no_workplace_pressure
  - no_overdue_adult_aftermath

hard_exclusions:
  - Player_previously_violated_image_rule_unrepaired
  - Raphaëlle_explicitly_refused_private_access
  - Marie_consequence_overdue_and_blocking
  - same_process_engine_recently_seen

soft_preferences:
  - Player_previously_noticed_craft_detail
  - creative_account_revealed_or_teased
  - Maud_unavailable_for_practical_help
  - Player_has_demonstrated_attention_to_process

availability_reason:
  - costume must be repaired before an event or photo session

physical_context:
  - Raphaëlle's apartment-workshop
  - or remote photo exchange before Player arrives

communication_mode:
  entry: TRACE_DELIVERY or REMOTE_ASYNC
  continuation: OFFLINE_BEAT
  aftermath: AFTERGLOW_REMOTE

stable_kernel:
  - real craft problem
  - Player is invited or asks to help
  - Raphaëlle chooses what process he may see
  - help, gaze, image, and permission are separated
  - creative access opens, remains limited, or closes

primary_decision_axis:
  - how Player receives access to the process

choices:
  1:
    posture: practical_and_attentive
    action: help without converting access into sexual claim
    possible_writes:
      - creative_trust_up
      - future_finished_version_possible
      - attraction_unconfirmed
  2:
    posture: acknowledge_intention
    action: name that seeing the preparation changes his gaze
    possible_writes:
      - attraction_acknowledged
      - audience_question_due
      - Marie_frame_question_seeded
  3:
    posture: consume_or_push
    action: focus only on body/result or request more access
    possible_writes:
      - Raphaëlle_boundary
      - creative_access_paused
      - work_distance_possible

character_agency:
  wants:
    - solve the costume problem
    - test whether Player sees the process
  can_refuse:
    - physical help
    - image
    - private access
  can_initiate:
    - reveal partial fitting
    - ask him to hold or photograph one detail
    - end the scene
  if_Player_passive:
    - Raphaëlle completes or delays the repair without him
  if_Player_pushes:
    - she closes the access and names the confusion
  independent_action:
    - attend the event or session with or without Player

trace:
  possible:
    - detail photo
    - partial silhouette
    - repaired fastener
    - garment bag seen at work
  image_rules:
    - origin and photographer named
    - no saving or forwarding inferred
    - partial fitting is not general costume access

exit_states:
  trust:
    - Player admitted into process
  attraction:
    - intention recognized but frame unresolved
  distance:
    - access refused or paused

follow_up_functions:
  - finished_version_image
  - mask_changes_posture
  - return_to_work
  - audience_rule
  - Marie_consequence
  - repair_after_misread

cooldown:
  - no second fitting/process scene in next two compatible windows

expiry:
  - the immediate repair opportunity ends with the event

mutation_if_deferred:
  - Raphaëlle sends the completed result
  - or Maud solves the problem and Player loses process access

fallback_if_unseen:
  - Raphaëlle's creative practice remains established
  - another sequence must provide future chosen-version access
```

---

# 23. Audit des scènes existantes

Ce document ne rend pas automatiquement conformes :

- les anciennes cartes de scènes ;
- les source packs ;
- les conversations JSON ;
- les scènes déjà jouables ;
- les anciens plans de journées.

Chaque scène existante doit être classée.

## Compatible

La scène :

- sert une séquence actuelle ;
- respecte le canon complet ;
- possède une fonction claire ;
- reste temporellement crédible ;
- n’introduit aucune permission invalide ;
- peut être conservée avec corrections mineures.

## Adaptable

La fonction est utile, mais il faut revoir :

- entrée ;
- objets ;
- lieu ;
- partenaire ;
- choix ;
- état de sortie ;
- conséquence ;
- canal de communication.

## À réécrire

La scène dépend :

- d’une ancienne identité ;
- d’un moteur générique ;
- d’une progression trop rapide ;
- d’une disponibilité artificielle ;
- d’une route créée par la scène elle-même ;
- d’un consentement implicite ;
- d’un personnage secondaire utilisé comme autorisation ;
- d’une temporalité devenue incompatible.

## À archiver

La fonction elle-même n’appartient plus à la saison ou duplique une meilleure séquence.

---

# 24. Fiche d’audit recommandée

Pour chaque ancienne scène :

```text
existing_scene_id
current_source
original_function
closest_S01_S35_sequence
character_canon_compatibility
route_compatibility
temporal_compatibility
communication_compatibility
choice_quality
trace_quality
consent_quality
consequence_quality
classification
required_action
```

Classification :

```text
COMPATIBLE
ADAPTABLE
REWRITE
ARCHIVE
```

L’audit doit examiner le contenu narratif avant l’implémentation.

Une scène déjà fonctionnelle techniquement peut être narrativement obsolète.

---

# 25. Checklist de validation narrative

Une scène peut être présentée pour validation seulement si :

- [ ] sa séquence source est identifiée ;
- [ ] sa fonction principale est unique ;
- [ ] sa relation principale est claire ;
- [ ] les canons complets requis sont listés ;
- [ ] au moins deux ancrages propres au personnage sont utilisés ;
- [ ] l’acte et le niveau de route sont compatibles ;
- [ ] la disponibilité est crédible ;
- [ ] le mode de communication est justifié ;
- [ ] le noyau stable est défini ;
- [ ] les variations changent réellement le sens ;
- [ ] les conditions et exclusions sont écrites ;
- [ ] l’agence du personnage est explicite ;
- [ ] Player accomplit une action ou envoie un vrai message ;
- [ ] le nombre de choix est conforme ;
- [ ] un seul axe est décidé par nœud ;
- [ ] chaque choix produit une conséquence distincte ;
- [ ] les connaissances avant et après sont cohérentes ;
- [ ] les règles d’images sont explicites ;
- [ ] le consentement est décrit lorsqu’il change ;
- [ ] Jeff, Bastien, Marie ou les autres personnes affectées restent réels ;
- [ ] l’état de sortie est défini ;
- [ ] le suivi, l’expiration et la mutation sont définis ;
- [ ] aucune conséquence majeure n’est cachée dans un écho ;
- [ ] aucun changement runtime global n’est implicitement exigé.

---

# 26. Anti-patterns

Rejeter une scène qui repose sur :

- un jour fixe sans nécessité dramatique ;
- un score d’affection unique ;
- une disponibilité aléatoire ;
- un menu de sélection de personnage ;
- toutes les routes actives simultanément ;
- une image sans origine ;
- un personnage omniscient ;
- une photo publique considérée comme transférable ;
- un costume considéré comme permission ;
- une tenue Mathilde considérée comme intention automatique ;
- l’absence de Jeff ou Bastien considérée comme autorisation ;
- une trahison cachée appelée relation ouverte ;
- trois réponses synonymes ;
- un choix décidant une relation entière ;
- une conséquence qui disparaît à la fin de la scène ;
- une scène explicite sans lendemain ;
- une limite que l’insistance peut contourner ;
- un rôle Raphaëlle sans fin définie ;
- un Nico secrètement attiré par Player ;
- un personnage secondaire promu en consentement par procuration ;
- un dialogue générique produit procéduralement ;
- une scène dont l’unique fonction est d’exposer une fiche de personnage ;
- une refonte runtime conçue avant validation de la fonction narrative.

---

# 27. Relation avec le runtime

Le runtime doit adapter la scène validée avec la représentation la plus petite et compatible.

Il ne doit pas :

- créer des systèmes généraux inutilisés ;
- transformer chaque élément du document en variable ;
- exposer les noms internes des routes ;
- ajouter des choix pour reproduire toutes les variantes de rédaction ;
- ignorer une conséquence parce qu’elle est difficile à implémenter ;
- faire de la scène existante la source de vérité narrative.

Avant intégration :

1. valider la carte ;
2. choisir une petite tranche ;
3. inspecter les systèmes existants ;
4. mapper uniquement les états nécessaires ;
5. intégrer les conséquences dues ;
6. adapter les tests ;
7. préserver le reste du runtime.

---

# 28. Résumé canonique

Une séquence définit l’événement.

Une fenêtre définit ce qui est possible maintenant.

Une scène définit comment cet événement arrive réellement à ces personnes-là.

La modularité ne consiste pas à rendre une scène vague.

Elle consiste à conserver :

- une fonction stable ;
- une personne spécifique ;
- un contexte variable ;
- une agence réelle ;
- des choix lisibles ;
- une mémoire persistante ;
- une mutation lorsque l’occasion est manquée.

Marie doit continuer à vivre et à agir.

Sandra doit choisir ses traces.

Mathilde doit distinguer sensualité ordinaire et intention.

Pauline doit maintenir ou perdre son compartiment.

Raphaëlle doit choisir la version, le cadre et la fin du rôle.

Nico doit rester un homme hétérosexuel dont l’amitié, la rivalité et le regard autour des femmes peuvent devenir complicité ou dette, sans route sexuelle cachée avec Player.

Player doit agir plutôt que sélectionner une route.

> **Une scène modulaire est une promesse précise : dans ces conditions, cette personne peut accomplir cette action, Player peut répondre de ces manières, et l’histoire se souviendra de ce qui s’est réellement passé.**