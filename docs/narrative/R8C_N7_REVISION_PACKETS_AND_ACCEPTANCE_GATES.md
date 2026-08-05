# R8C-N7 — Paquets de révision et portes d’acceptation

Baseline obligatoire : `5bb04c957030c00a0e8c6a9c39a103e8f697cd2e`
Tag de référence : `r8c-n6-global-scene-visual-erotic-coverage-audit`
Statut global : `WRITTEN_RECONCILIATION_PLANNED`

## 1. Objet et limite du lot

Ce document transforme la réconciliation N7 en **exactement cinq paquets de travail** : trois révisions de payoffs adultes écrits et deux ponts de continuité. Il ne crée ni scène supplémentaire, ni asset, ni dialogue final. Les formulations ci-dessous sont des contraintes de révision et des critères d’acceptation, pas des répliques prêtes à intégrer.

| ID stable | Unité | Statut éditorial | Décision encore requise |
|---|---|---|---|
| `N7-RP-01-MARIE-J11-W4` | Marie — payoff J11 adossé à l’asset `#051` | `READY_FOR_SCRIPTING` | Aucune |
| `N7-RP-02-MATHILDE-J11-W4` | Mathilde — payoff J11 adossé à l’asset `#045` | `READY_FOR_SCRIPTING` | Aucune |
| `N7-RP-03-SANDRA-J18-W4` | Sandra — payoff J18 adossé à l’asset `#079` | `READY_FOR_SCRIPTING` | Aucune |
| `N7-RP-04-J17-CLARIFICATION` | Pont de clarification J17 | `READY_FOR_SCRIPTING` | Aucune |
| `N7-RP-05-J21-FINALE` | Pont final J21 et aftercares | `READY_FOR_SCRIPTING` | Aucune |

Il n’existe pas de sixième paquet dans R8C-N7. Les raccords, états et aftercares décrits dans un paquet font partie de son acceptation ; ils ne constituent pas des unités de production autonomes.

## 2. Paquet 1 — `N7-RP-01-MARIE-J11-W4`

### Sources

- `docs/canon/dialogues/NAR_ADULT_01_PAYOFFS_J11_MARIE_MATHILDE.md`
- `docs/canon/characters/MARIE_CANON_FULL.md`
- `docs/narrative/R8C_N6_EROTIC_AND_PORNOGRAPHIC_PROGRESSION_MAP.md`
- `docs/narrative/R8C_N6_VISUAL_REWARD_AND_PHOTO_COVERAGE_AUDIT.md`
- `docs/canon/dialogues/ASSET_01_MANIFESTE_PRODUCTION_VISUELLE_SAISON_1_84_FICHIERS.md`
- `game/data/conversations/chapter_11_marie_return.json`
- `game/data/conversations/chapter_12_obligations.json`
- `game/data/runtime/season_1/j11_runtime_map.json`

### Problème à résoudre

Le canon autorise un payoff conjugal complet, mais l’écriture actuellement servie reste à `W3` : elle établit la reprise sexuelle sans donner au centre de la scène un acte assez concret pour correspondre à la fonction pornographique de l’image `#051`. La continuité J12 et l’aftercare existent déjà ; la révision doit densifier le centre sans transformer le sexe en réparation magique du couple.

### Périmètre de révision

Réviser uniquement le segment adulte central et sa retombée immédiate dans `chapter_11_marie_return.json`, en conservant l’entrée, les choix structurants, la fermeture de J11 et le raccord à `chapter_12_obligations.json`. Aucun nouveau nœud canonique, aucune nouvelle image et aucun changement de runtime ne sont inclus dans ce paquet documentaire.

### Niveau d’écriture

- Niveau actuel : `W3`.
- Niveau cible : `W4`.
- Effet attendu : nommer et suivre au moins un acte sexuel central concret, avec positions corporelles lisibles, progression et réponse mutuelle ; ne pas se contenter d’ellipse, de métaphore ou d’une image finale.

### Média et consentement

- Asset de payoff : `#051`, `S1_A3_J11_SCN_MARIE_RECONQUEST_ADULT_PAYOFF_01`.
- Rôle : `PORNOGRAPHIC_PAYOFF`.
- Statut : image de scène non diégétique ; elle n’est ni une photo prise par Player, ni un objet possédé ou diffusé dans le récit.
- Consentement : `CONSENTED_PRIVATE`, actuel, explicite et réversible. La permission sexuelle ne vaut jamais permission de photographier, conserver ou partager.

### Beats existants à préserver

- Marie revient vers Player par un geste choisi, non par effacement du conflit.
- Le désir est conjugal, concret et co-actif ; Marie n’est pas réduite à une récompense passive.
- Le choix du joueur règle la manière d’avancer et peut maintenir une prudence réelle.
- La scène ferme J11 et se prolonge par un matin ordinaire en J12.

### Beats manquants à écrire

- Un acte sexuel central unique ou une courte progression d’actes, explicitement nommés et spatialement compréhensibles.
- Une initiative lisible de Marie et une réponse lisible de Player, sans automatisme de consentement.
- Un point de contrôle verbal ou gestuel pendant la progression.
- Une retombée corporelle immédiate avant le retour au quotidien.

### Choix à conserver

- Reconquête : choisir une reprise sexuelle sans en faire une solution au conflit.
- Sexe différé : reconnaître le désir mais refuser le sexe-pansement ce soir-là.
- Refus : ne pas consentir à la reprise sexuelle et ne pas compenser par une fausse tendresse.

### Points de choix UI existants

Nombre exact : **1 point logique présenté au joueur**, dans l’un des deux segments
mutuellement exclusifs `j11_marie_return_opening` ou
`j11_marie_post_dinner_opening`. Chaque variante expose **3 options**.

| Option et identifiants | Fonction | Réception existante | Nouveau point requis |
|---|---|---|---|
| Reconquête — `choice_j11_marie_post_reconquest` ou `choice_j11_marie_reconquest` | orienter vers le payoff adulte si l’éligibilité est satisfaite | Marie confirme le cadre, le téléphone hors de la chambre et la révocabilité | non |
| Sexe différé — `choice_j11_marie_post_no_pansement` ou `choice_j11_marie_no_pansement` | maintenir le désir sans utiliser le sexe comme réparation | Marie reçoit la distinction, puis revient au repas et au sommeil | non |
| Refus — `choice_j11_marie_post_refuse` ou `choice_j11_marie_refuse` | fermer la reprise sexuelle pour ce soir | Marie accepte le refus et interdit la tendresse compensatoire | non |

### Agence interne hors UI

Ralentir, interrompre, retirer son accord, reformuler une limite, confirmer,
continuer et réagir après l’acte appartiennent à la mise en scène et au consentement.
Ils ne deviennent pas trois nouveaux boutons « avancer / ralentir / arrêter ». Le
point en amont porte l’orientation ; la scène la réalise avec confirmations,
réactions et possibilité permanente de retrait.

### Réactions obligatoires

- Marie réagit selon sa voix concrète, familière et domestique, jamais comme une séductrice générique.
- Player peut être désirant et actif, mais sa réaction doit rester conditionnée au choix actuel de Marie.
- Toute hésitation produit un ralentissement ou un arrêt observable, pas une relance implicite.

### Aftercare

- Immédiat : retour au souffle, vérification de l’état de Marie, proximité choisie et sortie de l’intensité.
- Différé : conserver le raccord J12 déjà associé au paiement `aftercare_marie_j11` et à l’asset d’aftercare `#052` dans la séquence prévue.
- Fonction : montrer une reprise possible du quotidien sans prétendre que le conflit conjugal est résolu par le sexe.

### Fait durable autorisé

Marie et Player ont pu reprendre une intimité sexuelle complète et consentie. Ce fait autorise une proximité retrouvée, mais n’autorise ni réconciliation totale, ni exclusivité garantie, ni effacement des décisions ultérieures.

### Interdits

- Ellipse qui maintiendrait le texte à `W3`.
- Sexe utilisé comme pansement ou preuve de pardon définitif.
- Marie passive, soudainement fatale ou étrangère à sa voix canonique.
- Extension de consentement vers la photographie, l’archive ou la diffusion.
- Ajout d’un asset ou modification de l’ordre structurel J11/J12.

### Critères d’acceptation

1. Le segment central atteint `W4` par un acte explicite et compréhensible, pas par accumulation de vocabulaire cru.
2. L’initiative et le consentement restent bilatéraux, actuels et réversibles.
3. L’image `#051` correspond au point culminant sans devenir diégétique.
4. Les trois sorties — avancer, ralentir, arrêter — ont des réactions cohérentes et non punitives.
5. L’aftercare immédiat puis le raccord J12/`#052` sont lisibles.
6. Le seul fait durable ajouté est la possibilité d’une intimité reprise, sans résolution automatique du couple.

### Statut de décision

`READY_FOR_SCRIPTING`. Le canon fixe déjà le type de payoff, la limite conjugale, le consentement, l’aftercare et la fonction de l’asset.

## 3. Paquet 2 — `N7-RP-02-MATHILDE-J11-W4`

### Sources

- `docs/canon/dialogues/NAR_ADULT_01_PAYOFFS_J11_MARIE_MATHILDE.md`
- `docs/canon/characters/MATHILDE_CANON_FULL.md`
- `docs/narrative/R8C_N6_EROTIC_AND_PORNOGRAPHIC_PROGRESSION_MAP.md`
- `docs/narrative/R8C_N6_VISUAL_REWARD_AND_PHOTO_COVERAGE_AUDIT.md`
- `docs/canon/dialogues/ASSET_01_MANIFESTE_PRODUCTION_VISUELLE_SAISON_1_84_FICHIERS.md`
- `game/data/conversations/chapter_11_mathilde_return.json`
- `game/data/conversations/chapter_12_obligations.json`
- `game/data/runtime/season_1/j11_runtime_map.json`

### Problème à résoudre

La branche physique M-B3 existe et distingue déjà aftercare réussi ou manqué, mais son centre reste à `W3`. Le canon demande un contact sexuel mutuel explicite sans pénétration, avec consentement vérifié étape par étape et indépendance du choix de dormir ou de partir.

### Périmètre de révision

Réviser le centre adulte de M-B3 et ses transitions immédiates dans `chapter_11_mathilde_return.json`. Préserver les sorties, le paiement ou l’échec d’aftercare et la convergence conditionnelle de J12. Aucun changement d’architecture ou d’asset n’appartient à ce paquet documentaire.

### Niveau d’écriture

- Niveau actuel : `W3`.
- Niveau cible : `W4`.
- Effet attendu : décrire un contact sexuel mutuel précis, ses gestes successifs et les réponses des deux corps, tout en maintenant la limite canonique de non-pénétration.

### Média et consentement

- Asset de payoff : `#045`, `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_CENTRAL_01`.
- Rôle : `PORNOGRAPHIC_PAYOFF`.
- Statut : image de scène non diégétique.
- Consentement : `CONSENTED_PRIVATE`, renouvelé à chaque changement d’intensité. Aucun glissement vers prise, conservation ou diffusion d’image.

### Beats existants à préserver

- M-B3 est une bifurcation choisie et non la récompense obligatoire de la route Mathilde.
- Mathilde peut désirer, corriger, ralentir ou arrêter avec sa voix fragmentée et précise.
- Le contact reste mutuel et sans pénétration.
- L’aftercare immédiat possède déjà une issue `PAID` et une issue `FAILED` qui ont une conséquence J12.

### Beats manquants à écrire

- La nature exacte du contact sexuel mutuel, décrite au-delà de l’allusion.
- Les transitions étape par étape, chacune rendue conditionnelle au consentement présent.
- Des réactions corporelles et intentionnelles distinctes pour Mathilde et Player.
- Une sortie nette de l’acte avant la décision indépendante de rester dormir ou de partir.

### Choix à conserver

- Orientation initiale : regard, proximité ou distance.
- Plafond physique : accepter M-B3, maintenir M-B2 ou arrêter.
- Réception après départ : ne pas définir, reconnaître l’effet envers Marie ou réclamer une répétition.

### Points de choix UI existants

Nombre exact sur la branche M-B3 complète : **3 points UI**, chacun à **3 options**.

| Point et emplacement | Options et fonction | Réception existante | Nouveau point requis |
|---|---|---|---|
| 1 — `j11_mathilde_opening` | `choice_j11_mathilde_look`, `choice_j11_mathilde_proximity`, `choice_j11_mathilde_distance` : fixer regard, proximité ou distance | Mathilde confirme le plafond choisi ; seule la proximité éligible poursuit vers l’entrée physique | non |
| 2 — `j11_mathilde_physical_entry` | `choice_j11_mathilde_m_b3_accept`, `choice_j11_mathilde_m_b2_hold`, `choice_j11_mathilde_physical_stop` : accepter M-B3, rester à M-B2 ou fermer | M-B3 ouvre la séquence ; M-B2 borne le contact ; l’arrêt mène au départ | non |
| 3 — `j11_mathilde_physical_after` | `choice_j11_mathilde_after_no_definition`, `choice_j11_mathilde_after_marie`, `choice_j11_mathilde_after_repeat` : recevoir l’après-coup | les deux premières réponses paient l’aftercare ; la demande de répétition le fait échouer | non |

### Agence interne hors UI

Ralentir, interrompre, retirer son accord, reformuler une limite, confirmer,
continuer et réagir après l’acte restent des actes internes de co-présence. Ils ne
créent aucun bouton supplémentaire. Les trois points existants orientent la branche ;
la scène applique les confirmations successives et l’arrêt toujours possible.

### Réactions obligatoires

- Mathilde parle et agit par fragments, corrections et précision croissante ; sa franchise sexuelle ne devient pas du juridisme.
- Player répond à ce qui vient d’être demandé ou montré, jamais à une permission antérieure supposée permanente.
- Un ralentissement ou un arrêt modifie réellement l’action et la tonalité.

### Aftercare

- Immédiat : présence, espace ou geste pratique selon le choix de Mathilde ; maintenir les sorties `PAID` et `FAILED`.
- Différé : préserver la conséquence conditionnelle dans `chapter_12_obligations.json` et l’asset d’aftercare `#046` prévu par la séquence J11.
- Fonction : l’aftercare est une responsabilité distincte du fait d’avoir eu un contact sexuel et distincte du choix de dormir sur place.

### Fait durable autorisé

Mathilde et Player ont pu partager un contact sexuel mutuel explicite sans pénétration. La qualité de l’aftercare reste un fait séparé, susceptible d’améliorer ou de dégrader la confiance au matin.

### Interdits

- Pénétration ou ambiguïté laissant croire qu’elle a eu lieu.
- Consentement global déduit du choix initial de M-B3.
- Confusion entre rester dormir, pardonner et consentir à davantage.
- Voix uniformément juridique ou crudité brutale étrangère à Mathilde.
- Image diégétique, nouvel asset ou suppression de l’échec d’aftercare.

### Critères d’acceptation

1. Le centre atteint `W4` par un contact mutuel explicite sans pénétration.
2. Chaque hausse d’intensité a un signal de consentement présent et réversible.
3. L’image `#045` correspond au payoff sans devenir une photo narrative.
4. Les choix continuer, ralentir et arrêter entraînent des réactions distinctes.
5. La décision de rester ou partir demeure indépendante du consentement sexuel.
6. Les états d’aftercare `PAID` et `FAILED`, leur raccord J12 et `#046` restent opérants.

### Statut de décision

`READY_FOR_SCRIPTING`. Les actes autorisés, la limite de non-pénétration, les sorties et l’aftercare sont déjà verrouillés par le canon.

## 4. Paquet 3 — `N7-RP-03-SANDRA-J18-W4`

### Sources

- `docs/canon/dialogues/NAR_ADULT_02_PAYOFF_SANDRA_J18.md`
- `docs/canon/dialogues/J18_SCRIPT_NARRATIF_COMPLET.md`
- `docs/canon/dialogues/J19_SCRIPT_NARRATIF_COMPLET.md`
- `docs/canon/characters/SANDRA_CANON_FULL.md`
- `docs/narrative/R8C_N6_EROTIC_AND_PORNOGRAPHIC_PROGRESSION_MAP.md`
- `docs/narrative/R8C_N6_VISUAL_REWARD_AND_PHOTO_COVERAGE_AUDIT.md`
- `docs/canon/dialogues/ASSET_01_MANIFESTE_PRODUCTION_VISUELLE_SAISON_1_84_FICHIERS.md`
- `game/data/conversations/chapter_18_sandra_resolution.json`
- `game/data/conversations/chapter_19_private_versions.json`
- `game/data/runtime/season_1/j18_runtime_map.json`
- `game/data/runtime/season_1/j19_runtime_map.json`

### Problème à résoudre

Le canon écrit autorise une relation sexuelle complète et fournit un aftercare prioritaire J19, mais le runtime J18 ne sert actuellement aucun payoff adulte Sandra et J19 ne sert pas son aftercare. Le centre pornographique doit atteindre `W4` et représenter la décision désormais verrouillée : rapport vaginal pénétratif consensuel, Sandra au-dessus de Player et contrôlant le rythme.

### Périmètre de révision

Préparer la révision écrite de la branche adulte Sandra en J18 selon l’arbitrage canonique validé et son raccord d’aftercare prioritaire J19. Le paquet définit l’écriture nécessaire ; l’intégration runtime, les fichiers de conversation et les maps ne sont pas modifiés dans R8C-N7.

### Niveau d’écriture

- Niveau actuel : `W3` dans le canon écrit ; absent du runtime servi.
- Niveau cible : `W4`.
- Effet attendu : décrire le rapport vaginal pénétratif au milieu de l’acte, Sandra au-dessus de Player, active, tournée vers lui et contrôlant explicitement le rythme.

### Média et consentement

- Asset de payoff : `#079`, `S1_A5_J18_SCN_SANDRA_LATE_INTIMACY_CENTRAL_01`.
- Fonction principale : `PORNOGRAPHIC_PAYOFF`.
- Fonction secondaire : matérialiser l’aboutissement du manque, de la confiance et de la tentation lente.
- Statut : image de scène non diégétique prise au milieu de l’acte, pas pose pornographique détachée de la relation ; Player est partiellement cadré et non identifiable ; téléphone hors d’usage.
- Consentement : `CONSENTED_PRIVATE`, présent, explicite et révocable, avec capacité d’arrêt encore lisible. Aucune permission de photographier, conserver ou diffuser n’en découle.

### Beats existants à préserver

- Sandra avance graduellement, avec précision et intention, sans bascule soudaine dans une crudité étrangère à sa voix.
- Player reste le partenaire présent dans l’acte et répond aux gestes de Sandra.
- Jeff reste le partenaire absent et une conséquence réelle, jamais un participant à l’acte ni une permission indirecte.
- Le consentement est contemporain de chaque étape.
- La scène possède une retombée immédiate et une priorité d’aftercare en J19.

### Beats manquants à écrire

- La progression corporelle qui mène au rapport vaginal pénétratif et la réponse mutuelle.
- Le contrôle explicite du rythme par Sandra, sa position au-dessus et son orientation vers Player.
- Les embranchements de ralentissement ou d’arrêt autour du point central.
- Le raccord servi vers l’aftercare Sandra de J19 et l’asset `#080`.

### Choix à conserver

- Résolution générale J18 : reconnaître le choix de Sandra, proposer un avenir sans réclamer l’image, ou minimiser avec coût.
- Invitation adulte conditionnelle : accepter le cadre, demander davantage — ce qui retire la proposition — ou refuser honnêtement.
- Aftercare J19 : reconnaître sans réclamer, demander si elle regrette, ou chercher à cogérer le secret, avec les réceptions déjà définies par le canon.

### Points de choix UI existants

Nombre exact sur la chaîne adulte J18–J19 complète : **3 points UI**, chacun à
**3 options**. Le premier est déjà servi par le runtime ; le deuxième et le point
d’aftercare existent dans le canon mais restent des gaps de livraison, pas de
nouveaux choix de conception.

| Point et emplacement | Options et fonction | Réception existante | Nouveau point requis |
|---|---|---|---|
| 1 — une des variantes exclusives `j18_resolution_intact`, `j18_resolution_removed`, `j18_resolution_compromised` ou `j18_resolution_simple` | famille `choice_j18_recognize*`, `choice_j18_future*`, `choice_j18_minimize*` : reconnaître, ouvrir un avenir ou minimiser | quatre réceptions standard déterminent confiance, protection, amitié ou rupture | non |
| 2 — invitation adulte conditionnelle de `J18_SCRIPT_NARRATIF_COMPLET.md` §§21–22 | accepter le cadre ; demander un programme précis, ce qui retire l’invitation ; refuser honnêtement | Sandra confirme l’heure, retire la proposition sans négociation, ou reçoit le refus sans compensation | non |
| 3 — module prioritaire `J19_SCRIPT_NARRATIF_COMPLET.md` §6 | reconnaître sans réclamer ; demander si Sandra regrette ; chercher à cogérer le secret | Sandra distingue non-regret et permission future, peut demander du silence, et conserve seule la décision de ce qu’elle dit à Jeff | non |

Aucun choix oral n’est affiché pendant la séquence physique. Le point canonique
conditionnel devra être servi lors d’une livraison ultérieure, sans quatrième option.

### Agence interne hors UI

Ralentir, interrompre, retirer son accord, reformuler une limite, confirmer,
continuer et réagir après l’acte appartiennent à Sandra et Player pendant la
co-présence. Ils ne deviennent pas des boutons. L’arrêt reste toujours possible ;
`#079` n’est servi que si le centre pénétratif est réellement atteint.

### Réactions obligatoires

- Sandra reste précise, progressive et consciente de ce qu’elle choisit ; l’explicite ne doit pas devenir abrupt.
- Player manifeste désir, attention et capacité d’arrêt tout en restant partiellement cadré et non identifiable.
- La branche d’arrêt protège l’autonomie de Sandra et ne détourne pas la scène en sanction.

### Aftercare

- Immédiat : sortie physique de l’intensité, vérification claire et retour à une proximité ou une distance choisie.
- Chaîne d’images : `#079` seulement si l’acte central est atteint ; `#080` porte la sortie d’intensité et la distance ou proximité choisie.
- Différé : J19 doit donner priorité au suivi Sandra prévu par `J19_SCRIPT_NARRATIF_COMPLET.md`, avec la fonction visuelle d’aftercare `#080`.
- Fonction : confirmer ce que la rencontre change ou ne change pas, sans convertir le sexe en promesse automatique.

### Fait durable autorisé

Sandra et Player peuvent avoir partagé un rapport vaginal pénétratif complet, explicite et consenti, Sandra au-dessus et contrôlant le rythme. Cela n’autorise aucune possession, aucun enregistrement, aucun droit futur, aucune promesse de répétition et aucune route automatique. Jeff demeure le partenaire absent et une conséquence réelle.

### Interdits

- Caméra, photographie, souvenir diégétique ou extension d’audience.
- Sandra brusquement grossière, passive ou utilisée comme spectacle.
- Player identifiable, cadrage triomphal ou pose détachée de la relation.
- Jeff transformé en participant, en permission indirecte ou en consentement supposé.
- Omission de l’aftercare J19 ou création d’un nouvel asset.
- Droit futur, promesse de répétition ou ouverture automatique de route.

### Critères d’acceptation

1. Le centre atteint `W4` par le rapport vaginal pénétratif verrouillé, Sandra au-dessus de Player et contrôlant le rythme.
2. Sandra reste active et tournée vers Player ; Player reste partiellement cadré et non identifiable.
3. Le téléphone est hors d’usage et l’arrêt demeure lisible avant et pendant l’acte.
4. `#079` n’est servi qu’au milieu de l’acte atteint, demeure non diégétique et ne crée aucune permission média.
5. `#080` porte la sortie d’intensité et la distance ou proximité choisie ; J19 reste prioritaire.
6. Aucun droit futur, aucune répétition promise et aucune route automatique ne sont créés ; Jeff reste absent de l’acte et réel dans ses conséquences.

### Statut de décision

`READY_FOR_SCRIPTING`. L’acte central, le contrôle de Sandra, le cadrage de Player, la fonction de `#079`, les interdits média et la chaîne d’aftercare sont désormais verrouillés.

## 5. Paquet 4 — `N7-RP-04-J17-CLARIFICATION`

### Sources

- `docs/canon/bible/14_CONTRAT_NARRATIF_SAISON_1_RECONCILIE.md`
- `docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md`
- `docs/narrative/R8C_N6_CANONICAL_SCENE_PORTFOLIO_INVENTORY.md`
- `docs/narrative/R8C_N6_CONTENT_PRODUCTION_FORECAST_AND_ROADMAP.md`
- `game/data/conversations/chapter_17_departure_and_couple.json`
- `game/data/runtime/season_1/j17_runtime_map.json`
- `game/scripts/runtime/season_1/J17RuntimeProvider.gd`
- `game/scripts/runtime/season_1/Season1State.gd`

### Problème à résoudre

J17 est encore susceptible d’être lu comme une décision finale de couple, alors que le contrat réconcilié en fait une clarification provisoire avant les conséquences de J18–J20 et la décision finale de J21. Les quatre choix de couple runtime doivent produire six sorties canoniques selon les faits accumulés, sans que la formulation locale efface l’historique.

### Périmètre de révision

Ajouter exactement deux micro-retours dans les fils existants : Mathilde après le départ, puis Marie après le choix de couple. Le premier confirme seulement départ, aide, distance ou état pratique. Le second ferme selon l’état réellement résolu et indique statut actif/provisoire, règle courante et checkpoint ou logistique suivante. Ne créer ni scène, ni choix, ni asset.

### Niveau d’écriture

- Niveau actuel : `W1` pour le départ et la logistique ; `W2` pour la clarification relationnelle.
- Niveau cible : `W1–W2`, inchangé.
- Effet attendu : accroître la précision structurelle, pas l’intensité sexuelle. Aucun passage `W3` ou `W4` n’est requis.

### Média et consentement

- Média principal : réutilisation d’éléments ordinaires existants, avec rôle `CONSEQUENCE_OR_ECHO` pour le départ/foyer et `RELATIONSHIP_PROOF` seulement lorsqu’une relation est effectivement attestée.
- Consentement : ce paquet n’est pas un payoff sexuel. Toute trace photographique éventuelle conserve son audience canonique ; aucune autorisation de consultation ou diffusion supplémentaire n’est créée.

### Beats existants à préserver

- Le départ et ses contraintes concrètes.
- Le choix de couple tel qu’il existe dans `chapter_17_departure_and_couple.json`.
- Les quatre choix de couple runtime existants : reconquête, provisoire, séparation et reconnaissance après refus.
- Les six sorties canoniques : `RECONQUEST_ACTIVE`, `PROVISIONAL_AGREEMENT`, `RECONFIGURATION_NEGOTIATION`, `DOUBLE_LIFE_FRAGILE`, `FRACTURE`, `SEPARATION`.
- La nécessité de laisser J18–J20 produire des conséquences réelles.

### Beats manquants à écrire

- Un micro-retour Mathilde qui confirme seulement le départ et son état pratique, sans réinterpréter la relation.
- Un micro-retour Marie spécifique à l’état résolu, sans nommer automatiquement « reconquête » ou « provisoire » avant évaluation des faits.
- Un record distinguant `couple_state`, règle courante, divulgation incomplète et prochaine conséquence.
- Une fermeture qui rend J17 provisoire et immédiatement exploitable par J18–J21.

### Choix à conserver

- `choice_j17_reconquest`.
- `choice_j17_provisional`.
- `choice_j17_separation`.
- `choice_j17_refused_acknowledge`.

Ces quatre choix seulement alimentent les six sorties canoniques ; aucune sortie
supplémentaire ne devient un cinquième ou sixième bouton.

### Points de choix UI existants

Nombre exact : **2 points UI séquentiels**.

| Point et emplacement | Nombre d’options et Fonction | Réception existante | Nouveau point requis |
|---|---|---|---|
| 1 — départ, `j17_departure_ordinary` ou `j17_departure_distance` | **2 options** dans la variante ordinaire (`choice_j17_help`, `choice_j17_distance`) ou **1 option imposée** dans la variante distance (`choice_j17_distance_required`) ; fixer aide ou distance pratique | Mathilde reçoit l’aide sans y lire une décision relationnelle, ou confirme la distance non négociable | non |
| 2 — couple, `j17_couple_due` ou `j17_couple_refused` | **3 options** si la discussion est due (`choice_j17_reconquest`, `choice_j17_provisional`, `choice_j17_separation`) ou **1 option** si elle est refusée/non due (`choice_j17_refused_acknowledge`) ; exprimer la posture locale | Marie reçoit la formulation ; la table déterministe, et non cette seule formulation, fixe l’état | non |

Les deux micro-retours surviennent après ces points et n’ajoutent aucun bouton.

### Agence interne hors UI

Ralentir, interrompre, retirer son accord, reformuler une limite, confirmer,
continuer et réagir après le départ ou le choix restent des actes de réception et de
mise en scène. Ils ne deviennent pas de nouveaux choix UI. L’arrêt ou le retrait
d’une règle reste possible sans modifier les quatre identifiants de couple.

### Table décisionnelle exacte J17

L’ordre est normatif et exhaustif.

| Choix runtime | Faits accumulés | Sortie canonique |
|---|---|---|
| `choice_j17_separation` | tous | `SEPARATION` |
| `choice_j17_refused_acknowledge` | discussion J16 refusée ou non due | `FRACTURE` |
| `choice_j17_reconquest` ou `choice_j17_provisional` | violation grave connue de Marie et non réparée | `FRACTURE` |
| `choice_j17_reconquest` ou `choice_j17_provisional` | fait matériel caché ou version incompatible encore active | `DOUBLE_LIFE_FRAGILE` |
| `choice_j17_reconquest` | actes Marie répétés + vérité suffisante + aucune violation active + règle concrète | `RECONQUEST_ACTIVE` |
| `choice_j17_reconquest` | sinon | `PROVISIONAL_AGREEMENT` |
| `choice_j17_provisional` | désir extérieur reconnu + audiences sûres ou réparées + pause acceptée + droit complet de refus de Marie | `RECONFIGURATION_NEGOTIATION` |
| `choice_j17_provisional` | sinon | `PROVISIONAL_AGREEMENT` |

Les seuls faits admis sont : niveau physique J11, aftercare Mathilde, mensonge ou
minimisation J14, notification d’audience, résolution J15, paiement ou contestation
J16, actes et promesses envers Marie. L’évaluation suit l’ordre des lignes, sans
priorité numérique, sans hasard et sans score. Chaque entrée valide produit exactement un
état. Une formulation favorable ne peut effacer l’historique ; contradiction ou
violation active interdit toute sortie plus favorable.

### Réactions obligatoires

- Marie et Player traitent le choix comme une position à éprouver, pas comme une sentence finale.
- Les implications logistiques et affectives sont visibles dès J17.
- Les états supplémentaires ne sont pas de simples labels : ils doivent modifier au moins une trace ou une conséquence ultérieure.

### Aftercare

- Il n’y a pas d’aftercare sexuel propre à J17.
- Le pont doit néanmoins transporter les aftercares déjà payés ou manqués en amont comme faits de confiance, sans les rejouer.
- Il prépare J21 à les reconnaître dans la conversation finale autonome.

### Fait durable autorisé

J17 peut fixer une position relationnelle provisoire et ses premières conséquences logistiques. Il ne peut pas fixer à lui seul le statut final du couple, le contrat durable, la politique de disclosure ou l’épilogue.

### Interdits

- Transformer J17 en finale de saison.
- Ajouter une scène autonome ou un nouvel asset.
- Ajouter un bouton ou un cinquième/sixième choix de couple.
- Élever artificiellement le niveau W.
- Évaluer les sorties par score, hasard, priorité numérique ou formulation locale seule.
- Répéter les scènes d’aftercare ou inventer une autorisation média.

### Critères d’acceptation

1. Les deux micro-retours restent dans les fils Mathilde et Marie existants et n’ajoutent aucun choix.
2. Les quatre choix de couple runtime sont conservés et couvrent exactement les six sorties canoniques selon la table ordonnée.
3. `RECONFIGURATION_NEGOTIATION` est l’unique identifiant de reconfiguration.
4. Le record sépare `couple_state`, règle courante, divulgation incomplète et prochaine conséquence.
5. Chaque sortie produit une trace ou une conséquence exploitable en J18–J21, sans score ni effacement de l’historique.
6. Aucun nouvel asset, aucune nouvelle scène et aucune escalade vers `W3/W4` ne sont introduits ; J21 conserve la décision finale.

### Statut de décision

`READY_FOR_SCRIPTING`. Le pont à deux micro-retours, les quatre choix conservés, la table déterministe à six sorties et le record de continuité sont validés.

## 6. Paquet 5 — `N7-RP-05-J21-FINALE`

### Sources

- `docs/canon/bible/14_CONTRAT_NARRATIF_SAISON_1_RECONCILIE.md`
- `docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md`
- `docs/canon/dialogues/NAR_PROD_06_PAQUET_PRODUCTION_ACTE_V_J17_J21.md`
- `docs/narrative/R8C_N6_CANONICAL_SCENE_PORTFOLIO_INVENTORY.md`
- `docs/narrative/R8C_N6_CONTENT_PRODUCTION_FORECAST_AND_ROADMAP.md`
- `docs/narrative/R8C_N6_VISUAL_REWARD_AND_PHOTO_COVERAGE_AUDIT.md`
- `game/data/conversations/chapter_21_final_trace.json`
- `game/data/runtime/season_1/j21_runtime_map.json`
- `game/scripts/runtime/season_1/J21RuntimeProvider.gd`

### Problème à résoudre

Le runtime J21 sert le matin, le fil du contrôleur de trace et une posture finale à l’intérieur de ce fil, mais pas la conversation autonome Marie/Player exigée après cette posture. La finale doit donc respecter l’ordre complet sans ajouter d’asset : `conséquences → trace/posture → conversation Marie/Player → décision/logistique → épilogues`.

### Périmètre de révision

Réviser la structure écrite de `chapter_21_final_trace.json` en réemployant la matière canonique disponible et les trois fonctions visuelles existantes. Le paquet spécifie la conversation finale et ses sorties ; il n’ajoute ni scène supplémentaire, ni image, ni dialogue final dans N7.

### Niveau d’écriture

- Niveau actuel : `W1` pour la trace et les opérations ; la matière relationnelle existe mais n’est pas servie à la bonne place.
- Niveau cible : `W1` pour la trace et les échos visuels, `W2` pour la conversation finale autonome.
- Effet attendu : précision affective, contractuelle et logistique. Aucun payoff `W3/W4` n’appartient à J21.

### Média et consentement

- Réemploi B1 : une image de scène existante J17–J20 comme écho d’une vie ordinaire transformée.
- Réemploi B2 : une photo admissible existante, ou un état de trace/absence si aucune photo ne peut être consultée légitimement.
- Réemploi B3 : une conséquence ou un comportement final existant.
- Les trois réemplois sont des rappels existants mis en scène, jamais trois nouveaux assets.
- Rôle commun : `CONSEQUENCE_OR_ECHO`, avec `RELATIONSHIP_PROOF` seulement si la source le justifie.
- Consentement par provenance : privé autorisé = `CONSENTED_PRIVATE` ; public ou groupe légitime = `CONSENTED_SHARED` ; consultation incertaine = `AMBIGUOUS_SEEN_NOT_SEEN` ; prise ou diffusion non autorisée = `NON_CONSENTED_OR_DIFFUSED`, utilisable uniquement comme conséquence sombre.
- Création, possession, consultation et diffusion restent quatre autorisations distinctes.

### Beats existants à préserver

- Le matin Marie/Player.
- La résolution du contrôleur de trace et ses conséquences.
- Les faits durables accumulés, y compris aftercares payés ou manqués.
- La disponibilité d’exactement trois réemplois fonctionnels, sans production visuelle nouvelle.

### Beats manquants à écrire

- Une conversation Marie/Player autonome, située après la trace/posture et hors du fil du contrôleur.
- Une décision finale distincte sur le statut du couple.
- Un contrat relationnel formulable : limites, loyautés et conditions de continuité.
- Une décision de disclosure et une conséquence logistique.
- La transition explicite de ces sorties vers les épilogues appropriés.

### Choix à conserver

- Le point du matin propre à l’état de couple, qui reçoit une conséquence pratique de J17.
- Le point `j21_final_choices`, qui exprime une posture envers la trace sans décider le couple.
- La conversation Marie/Player reçoit ensuite les faits et la posture ; elle mène à la décision/logistique sans créer automatiquement un nouveau bouton.

### Points de choix UI existants

Nombre exact : **2 points UI séquentiels**.

| Point et emplacement | Nombre d’options et fonction | Réception existante | Nouveau point requis |
|---|---|---|---|
| 1 — matin selon `couple_state` | reconquête : **2** (`choice_j21_morning_1930`, `choice_j21_morning_absent`) ; provisoire : **1** (`choice_j21_morning_agree`) ; reconfiguration : **1** (`choice_j21_morning_understood`) ; double vie : **3** (`choice_j21_morning_real_hour`, `choice_j21_morning_vague`, `choice_j21_morning_false_hour`) ; fracture : **1** (`choice_j21_morning_received`) ; séparation : **2** (`choice_j21_boxes_accept`, `choice_j21_boxes_refuse`) | Marie reçoit présence, absence, règle, heure ou logistique selon l’état déjà résolu | non |
| 2 — `j21_final_choices` après la trace | **2 options de base** (`choice_j21_rule`, `choice_j21_loss`) et **1 troisième option conditionnelle** (`choice_j21_contradiction`) uniquement si une contradiction existe ; qualifier règle, perte ou contradiction | le contrôleur légitime de la trace répond à la posture ; ce point ne fixe pas le couple | non |

La décision/logistique finale vient après la conversation Marie/Player et réconcilie
les faits déjà choisis ; elle n’est pas confondue avec la posture de trace.

### Agence interne hors UI

Ralentir, interrompre, retirer son accord, reformuler une limite, confirmer,
continuer et réagir après la trace ou la décision restent des actes internes à la
conversation et à sa réception. Ils ne deviennent pas automatiquement des boutons.
Les choix en amont portent l’orientation ; l’échange final réalise cette orientation
avec possibilité de retrait ou de refus.

### Réactions obligatoires

- Marie et Player parlent comme deux sujets autonomes après avoir vu la trace/posture, pas comme des avatars du contrôleur.
- Les aftercares passés modulent confiance, prudence et crédibilité sans dicter mécaniquement une fin unique.
- La réponse relationnelle, la politique de disclosure et la logistique peuvent diverger ; elles ne doivent pas être comprimées dans un bouton global.

### Aftercare

- Marie : rappeler la qualité du raccord J11/J12 comme fait de confiance, sans répéter la scène.
- Mathilde : distinguer clairement aftercare `PAID` ou `FAILED` et leur effet sur la crédibilité de Player.
- Sandra : si sa branche adulte a eu lieu, exiger que l’aftercare prioritaire J19 ait été reconnu ; son absence devient une conséquence, pas un oubli.
- Fonction finale : réconcilier les soins donnés ou manqués avec le contrat choisi, sans transformer l’aftercare en monnaie donnant droit à une relation.

### Fait durable autorisé

J21 peut fixer le statut final du couple, son contrat, la politique de disclosure, les conséquences logistiques et la sélection d’épilogue. Il ne peut pas rétroactivement créer un consentement média, annuler un aftercare manqué ou inventer un payoff adulte absent.

### Interdits

- Laisser la décision finale dans le fil du contrôleur de trace.
- Placer la conversation Marie/Player avant la trace/posture.
- Placer la décision/logistique avant cette conversation.
- Placer les épilogues avant la décision finale.
- Ajouter un quatrième réemploi, un nouvel asset ou une nouvelle scène.
- Utiliser une photo privée, ambiguë ou non consentie comme récompense romantique.
- Résoudre statut, contrat, disclosure et logistique par une seule variable sans effets distincts.
- Ajouter une scène sexuelle finale ou élever J21 à `W3/W4`.

### Critères d’acceptation

1. L’ordre est exactement : `conséquences → trace/posture → conversation Marie/Player → décision/logistique → épilogues`.
2. La conversation produit quatre sorties distinguables : statut, contrat, disclosure et logistique.
3. Exactement trois réemplois B1/B2/B3 sont utilisés et aucun asset n’est créé.
4. Chaque média est filtré selon sa provenance et son audience ; aucune permission n’est extrapolée.
5. Les aftercares Marie, Mathilde et Sandra sont reconnus comme faits, paiements ou manquements pertinents.
6. La finale reste à `W1–W2` et n’invente aucun payoff adulte.

### Statut de décision

`READY_FOR_SCRIPTING`. L’autorité canonique fixe déjà l’ordre, la fonction de la conversation autonome, les sorties attendues et le budget de trois réemplois sans nouvel asset.

## 7. Portes transversales d’acceptation

Le lot R8C-N7 est acceptable uniquement si toutes les portes suivantes sont franchies :

| Porte | Exigence | Preuve attendue |
|---|---|---|
| `GATE-CARDINALITY` | Exactement cinq paquets, portant les cinq IDs de ce document | Aucun sixième paquet, aucun sous-paquet autonome |
| `GATE-W` | Marie, Mathilde et Sandra visent `W4`; J17 reste `W1–W2`; J21 reste `W1–W2` | Niveau déclaré et vérifié pour chaque paquet |
| `GATE-ASSETS` | `#051`, `#045`, `#079` sont les trois payoffs existants ; `#052`, `#046`, `#080` portent l’aftercare ; J21 réemploie exactement trois éléments | Aucun nouvel asset et aucune image rendue diégétique sans autorité |
| `GATE-CONSENT` | Consentement sexuel actuel et réversible ; consentement média séparé par création, possession, consultation et diffusion | Classification explicite de chaque usage visuel |
| `GATE-CHOICES` | Les points UI sont quantifiés dans les cinq paquets et l’agence interne reste distincte | Aucun nouveau bouton en co-présence ; arrêt et retrait toujours possibles |
| `GATE-AFTERCARE` | Aftercare immédiat et différé réconcilié pour Marie, Mathilde et Sandra | Paiements, échecs et conséquences transportés jusqu’à J21 |
| `GATE-CONTINUITY` | J17 reste provisoire ; J21 suit `conséquences → trace/posture → conversation Marie/Player → décision/logistique → épilogues` | Refus de tout ordre qui avance conversation, décision ou épilogues |
| `GATE-SCOPE` | Documentation seulement dans N7 | Aucun fichier de jeu, runtime, dialogue, asset ou test modifié |

## 8. Décisions canoniques closes

Les deux arbitrages précédemment ouverts sont validés :

1. `N7-RP-03-SANDRA-J18-W4` — rapport vaginal pénétratif consensuel, Sandra au-dessus de Player et contrôlant le rythme, avec `#079` au milieu de l’acte.
2. `N7-RP-04-J17-CLARIFICATION` — deux micro-retours et table déterministe ordonnée des quatre choix vers les six sorties.

Les cinq paquets sont `READY_FOR_SCRIPTING` sous le statut global `WRITTEN_RECONCILIATION_PLANNED`. Aucun autre arbitrage, paquet, asset ou dialogue final n’est requis par R8C-N7.
