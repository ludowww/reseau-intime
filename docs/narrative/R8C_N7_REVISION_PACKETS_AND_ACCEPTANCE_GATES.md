# R8C-N7 — Paquets de révision et portes d’acceptation

Baseline obligatoire : `5bb04c957030c00a0e8c6a9c39a103e8f697cd2e`
Tag de référence : `r8c-n6-global-scene-visual-erotic-coverage-audit`

## 1. Objet et limite du lot

Ce document transforme la réconciliation N7 en **exactement cinq paquets de travail** : trois révisions de payoffs adultes écrits et deux ponts de continuité. Il ne crée ni scène supplémentaire, ni asset, ni dialogue final. Les formulations ci-dessous sont des contraintes de révision et des critères d’acceptation, pas des répliques prêtes à intégrer.

| ID stable | Unité | Statut éditorial | Décision encore requise |
|---|---|---|---|
| `N7-RP-01-MARIE-J11-W4` | Marie — payoff J11 adossé à l’asset `#051` | `READY_FOR_SCRIPTING` | Aucune |
| `N7-RP-02-MATHILDE-J11-W4` | Mathilde — payoff J11 adossé à l’asset `#045` | `READY_FOR_SCRIPTING` | Aucune |
| `N7-RP-03-SANDRA-J18-W4` | Sandra — payoff J18 adossé à l’asset `#079` | `NEEDS_CANON_DECISION` | Verrouiller un acte sexuel central unique et sa représentation par `#079` |
| `N7-RP-04-J17-CLARIFICATION` | Pont de clarification J17 | `NEEDS_CANON_DECISION` | Valider le pont court et la projection canonique à six états |
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
- Statut : image de scène non diégétique ; elle n’est ni une photo prise par Jeff, ni un objet possédé ou diffusé dans le récit.
- Consentement : `CONSENTED_PRIVATE`, actuel, explicite et réversible. La permission sexuelle ne vaut jamais permission de photographier, conserver ou partager.

### Beats existants à préserver

- Marie revient vers Jeff par un geste choisi, non par effacement du conflit.
- Le désir est conjugal, concret et co-actif ; Marie n’est pas réduite à une récompense passive.
- Le choix du joueur règle la manière d’avancer et peut maintenir une prudence réelle.
- La scène ferme J11 et se prolonge par un matin ordinaire en J12.

### Beats manquants à écrire

- Un acte sexuel central unique ou une courte progression d’actes, explicitement nommés et spatialement compréhensibles.
- Une initiative lisible de Marie et une réponse lisible de Jeff, sans automatisme de consentement.
- Un point de contrôle verbal ou gestuel pendant la progression.
- Une retombée corporelle immédiate avant le retour au quotidien.

### Choix à conserver

- Avancer avec franchise et désir partagé.
- Ralentir ou vérifier sans punir la prudence.
- Refuser ou arrêter sans faire du refus un échec moral.

### Réactions obligatoires

- Marie réagit selon sa voix concrète, familière et domestique, jamais comme une séductrice générique.
- Jeff peut être désirant et actif, mais sa réaction doit rester conditionnée au choix actuel de Marie.
- Toute hésitation produit un ralentissement ou un arrêt observable, pas une relance implicite.

### Aftercare

- Immédiat : retour au souffle, vérification de l’état de Marie, proximité choisie et sortie de l’intensité.
- Différé : conserver le raccord J12 déjà associé au paiement `aftercare_marie_j11` et à l’asset d’aftercare `#052` dans la séquence prévue.
- Fonction : montrer une reprise possible du quotidien sans prétendre que le conflit conjugal est résolu par le sexe.

### Fait durable autorisé

Marie et Jeff ont pu reprendre une intimité sexuelle complète et consentie. Ce fait autorise une proximité retrouvée, mais n’autorise ni réconciliation totale, ni exclusivité garantie, ni effacement des décisions ultérieures.

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
- Des réactions corporelles et intentionnelles distinctes pour Mathilde et Jeff.
- Une sortie nette de l’acte avant la décision indépendante de rester dormir ou de partir.

### Choix à conserver

- Continuer au rythme formulé par Mathilde.
- Ralentir et vérifier.
- Arrêter le contact.
- Après l’acte, proposer de rester ou respecter un départ sans transformer ce choix logistique en mesure du désir.

### Réactions obligatoires

- Mathilde parle et agit par fragments, corrections et précision croissante ; sa franchise sexuelle ne devient pas du juridisme.
- Jeff répond à ce qui vient d’être demandé ou montré, jamais à une permission antérieure supposée permanente.
- Un ralentissement ou un arrêt modifie réellement l’action et la tonalité.

### Aftercare

- Immédiat : présence, espace ou geste pratique selon le choix de Mathilde ; maintenir les sorties `PAID` et `FAILED`.
- Différé : préserver la conséquence conditionnelle dans `chapter_12_obligations.json` et l’asset d’aftercare `#046` prévu par la séquence J11.
- Fonction : l’aftercare est une responsabilité distincte du fait d’avoir eu un contact sexuel et distincte du choix de dormir sur place.

### Fait durable autorisé

Mathilde et Jeff ont pu partager un contact sexuel mutuel explicite sans pénétration. La qualité de l’aftercare reste un fait séparé, susceptible d’améliorer ou de dégrader la confiance au matin.

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

Le canon écrit autorise une relation sexuelle complète et fournit un aftercare prioritaire J19, mais le runtime J18 ne sert actuellement aucun payoff adulte Sandra et J19 ne sert pas son aftercare. Le centre pornographique doit atteindre `W4` et s’adosser à `#079`, tandis que le canon laisse encore volontairement l’acte sexuel central exact non verrouillé.

### Périmètre de révision

Après arbitrage canonique, préparer la révision écrite de la branche adulte Sandra en J18 et son raccord d’aftercare prioritaire J19. Le paquet définit l’écriture nécessaire ; l’intégration runtime, les fichiers de conversation et les maps ne sont pas modifiés dans R8C-N7.

### Niveau d’écriture

- Niveau actuel : `W3` dans le canon écrit ; absent du runtime servi.
- Niveau cible : `W4`.
- Effet attendu : sélectionner puis décrire un acte sexuel central concret et complet, compatible avec la continuité corporelle, la voix de Sandra et une seule image centrale `#079`.

### Média et consentement

- Asset de payoff : `#079`, `S1_A5_J18_SCN_SANDRA_LATE_INTIMACY_CENTRAL_01`.
- Rôle : `PORNOGRAPHIC_PAYOFF`.
- Statut : image de scène non diégétique ; aucune caméra ni photo ne doit exister dans l’action.
- Consentement : `CONSENTED_PRIVATE`, présent, explicite et révocable. La scène doit séparer sans ambiguïté consentement sexuel et toute question de média.

### Beats existants à préserver

- Sandra avance graduellement, avec précision et intention, sans bascule soudaine dans une crudité étrangère à sa voix.
- Jeff reste un partenaire réel, visible dans les gestes et les réactions.
- Le consentement est contemporain de chaque étape.
- La scène possède une retombée immédiate et une priorité d’aftercare en J19.

### Beats manquants à écrire

- L’acte sexuel central exact : il doit être choisi par décision canonique avant scripting.
- La progression corporelle qui mène à cet acte et la réponse mutuelle.
- Les embranchements de ralentissement ou d’arrêt autour du point central.
- Le raccord servi vers l’aftercare Sandra de J19 et l’asset `#080`.

### Choix à conserver

- Continuer avec un accord explicite et situé.
- Ralentir ou changer de rythme.
- Arrêter sans dette affective ou sexuelle.
- Au lendemain, répondre à la demande d’aftercare, offrir de l’espace ou manquer cette responsabilité avec une conséquence lisible.

### Réactions obligatoires

- Sandra reste précise, progressive et consciente de ce qu’elle choisit ; l’explicite ne doit pas devenir abrupt.
- Jeff manifeste désir, attention et capacité d’arrêt.
- La branche d’arrêt protège l’autonomie de Sandra et ne détourne pas la scène en sanction.

### Aftercare

- Immédiat : sortie physique de l’intensité, vérification claire et retour à une proximité ou une distance choisie.
- Différé : J19 doit donner priorité au suivi Sandra prévu par `J19_SCRIPT_AFTERCARE_SANDRA.md`, avec la fonction visuelle d’aftercare `#080`.
- Fonction : confirmer ce que la rencontre change ou ne change pas, sans convertir le sexe en promesse automatique.

### Fait durable autorisé

Après validation du centre, Sandra et Jeff peuvent avoir partagé une relation sexuelle complète, explicite et consentie. Cela n’autorise ni possession, ni enregistrement, ni promesse de couple, ni résolution globale de la trajectoire Sandra.

### Interdits

- Choisir l’acte central pendant le scripting sans arbitrage canonique explicite.
- Camera, photographie, souvenir diégétique ou extension d’audience.
- Sandra brusquement grossière, passive ou utilisée comme spectacle.
- Jeff effacé de l’acte ou consentement déduit d’une proximité antérieure.
- Omission de l’aftercare J19 ou création d’un nouvel asset.

### Critères d’acceptation

1. Une décision canonique nomme un seul acte central compatible avec `#079` avant toute écriture finale.
2. Après cette décision, le centre atteint `W4` avec une progression claire et des réactions mutuelles.
3. Les options continuer, ralentir et arrêter sont effectives et non punitives.
4. Sandra conserve sa voix précise et graduelle ; Jeff reste un partenaire réel.
5. `#079` demeure non diégétique et aucune capture n’est produite dans la scène.
6. L’aftercare immédiat, le suivi prioritaire J19 et la fonction `#080` sont raccordés.

### Statut de décision

`NEEDS_CANON_DECISION`. Décision minimale attendue : sélectionner et décrire fonctionnellement un acte sexuel central unique, compatible avec `#079`, sans rédiger de dialogue final. Une fois cette décision consignée, le paquet devient `READY_FOR_SCRIPTING` sans autre extension de scope.

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

J17 est encore susceptible d’être lu comme une décision finale de couple, alors que le contrat réconcilié en fait une clarification provisoire avant les conséquences de J18–J20 et la décision finale de J21. Le runtime ne projette en outre que quatre états de couple là où le canon en distingue six. Le contrat laisse cependant ouverte la granularité exacte de la réécriture J17.

### Périmètre de révision

Ajouter un pont court au sein de la scène J17 existante : quelques messages fonctionnels, un signal de provisoire, une trace d’engagement ou de retrait, puis une conséquence immédiatement exploitable. Ne pas créer une nouvelle scène, ne pas résoudre le couple et ne pas refondre toute la conversation.

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
- Les quatre sorties runtime actuelles : reconquête, provisoire, séparation, fracture.
- La nécessité de laisser J18–J20 produire des conséquences réelles.

### Beats manquants à écrire

- Une phrase-fonction indiquant que J17 fixe une position provisoire, non la fin de saison.
- Une projection explicite vers les six états canoniques : reconquête, provisoire, séparation, fracture, reconfiguration et double vie fragile.
- Une trace ou un comportement immédiatement réutilisable par J18–J21.
- Un coût ou une conséquence qui empêche le choix de rester abstrait.

### Choix à conserver

- Tenter une reconquête.
- Maintenir un accord provisoire.
- Se séparer.
- Constater la fracture.
- Après décision canonique sur la projection : permettre à la reconfiguration et à la double vie fragile d’être représentées sans les écraser dans une conclusion faussement binaire.

### Réactions obligatoires

- Marie et Jeff traitent le choix comme une position à éprouver, pas comme une sentence finale.
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
- Élever artificiellement le niveau W.
- Réduire les six états canoniques à quatre sans règle de projection validée.
- Répéter les scènes d’aftercare ou inventer une autorisation média.

### Critères d’acceptation

1. Le canon valide le format de pont court plutôt qu’une réécriture longue.
2. Une table de projection à six états est approuvée avant scripting.
3. Le texte rend explicite le caractère provisoire de J17.
4. Chaque sortie produit une trace ou une conséquence exploitable en J18–J21.
5. Aucun nouvel asset, aucune nouvelle scène et aucune escalade vers `W3/W4` ne sont introduits.
6. J21 conserve seul la décision finale après les conséquences.

### Statut de décision

`NEEDS_CANON_DECISION`. Deux validations liées sont requises : approuver le pont court et approuver la projection des quatre états runtime vers les six états canoniques. Le contrat réconcilié exige la correction mais déclare sa granularité encore ouverte.

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

Le runtime J21 sert le matin, le fil du contrôleur de trace et une posture finale à l’intérieur de ce fil, mais pas la conversation autonome Marie/Jeff exigée après les conséquences et la trace. La finale doit donc réordonner et compléter l’écrit sans ajouter d’asset : conséquences, conversation finale autonome, décision/logistique, puis épilogues.

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
- Rôle commun : `CONSEQUENCE_OR_ECHO`, avec `RELATIONSHIP_PROOF` seulement si la source le justifie.
- Consentement par provenance : privé autorisé = `CONSENTED_PRIVATE` ; public ou groupe légitime = `CONSENTED_SHARED` ; consultation incertaine = `AMBIGUOUS_SEEN_NOT_SEEN` ; prise ou diffusion non autorisée = `NON_CONSENTED_OR_DIFFUSED`, utilisable uniquement comme conséquence sombre.
- Création, possession, consultation et diffusion restent quatre autorisations distinctes.

### Beats existants à préserver

- Le matin Marie/Jeff.
- La résolution du contrôleur de trace et ses conséquences.
- Les faits durables accumulés, y compris aftercares payés ou manqués.
- La disponibilité d’exactement trois réemplois fonctionnels, sans production visuelle nouvelle.

### Beats manquants à écrire

- Une conversation Marie/Jeff autonome, située après les conséquences et hors du fil du contrôleur.
- Une décision finale distincte sur le statut du couple.
- Un contrat relationnel formulable : limites, loyautés et conditions de continuité.
- Une décision de disclosure et une conséquence logistique.
- La transition explicite de ces sorties vers les épilogues appropriés.

### Choix à conserver

- Confirmer, reconfigurer ou terminer le couple selon les faits accumulés.
- Définir les limites du contrat plutôt que supposer qu’un label suffit.
- Choisir ce qui est révélé, à qui et avec quelles conséquences.
- Arrêter ou restreindre la consultation d’une trace dont l’autorisation est absente ou ambiguë.

### Réactions obligatoires

- Marie et Jeff parlent comme deux sujets autonomes après avoir vu les conséquences, pas comme des avatars du contrôleur.
- Les aftercares passés modulent confiance, prudence et crédibilité sans dicter mécaniquement une fin unique.
- La réponse relationnelle, la politique de disclosure et la logistique peuvent diverger ; elles ne doivent pas être comprimées dans un bouton global.

### Aftercare

- Marie : rappeler la qualité du raccord J11/J12 comme fait de confiance, sans répéter la scène.
- Mathilde : distinguer clairement aftercare `PAID` ou `FAILED` et leur effet sur la crédibilité de Jeff.
- Sandra : si sa branche adulte a eu lieu, exiger que l’aftercare prioritaire J19 ait été reconnu ; son absence devient une conséquence, pas un oubli.
- Fonction finale : réconcilier les soins donnés ou manqués avec le contrat choisi, sans transformer l’aftercare en monnaie donnant droit à une relation.

### Fait durable autorisé

J21 peut fixer le statut final du couple, son contrat, la politique de disclosure, les conséquences logistiques et la sélection d’épilogue. Il ne peut pas rétroactivement créer un consentement média, annuler un aftercare manqué ou inventer un payoff adulte absent.

### Interdits

- Laisser la décision finale dans le fil du contrôleur de trace.
- Placer le choix de couple avant les conséquences.
- Ajouter un quatrième réemploi, un nouvel asset ou une nouvelle scène.
- Utiliser une photo privée, ambiguë ou non consentie comme récompense romantique.
- Résoudre statut, contrat, disclosure et logistique par une seule variable sans effets distincts.
- Ajouter une scène sexuelle finale ou élever J21 à `W3/W4`.

### Critères d’acceptation

1. L’ordre est : conséquences, conversation Marie/Jeff autonome, décision et logistique, épilogues.
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
| `GATE-CHOICES` | Continuer, ralentir et arrêter produisent des réactions effectives dans les payoffs | Aucun refus puni ni permission permanente |
| `GATE-AFTERCARE` | Aftercare immédiat et différé réconcilié pour Marie, Mathilde et Sandra | Paiements, échecs et conséquences transportés jusqu’à J21 |
| `GATE-CONTINUITY` | J17 reste provisoire ; J21 décide après les conséquences dans une conversation autonome | Ordre final conforme au contrat réconcilié |
| `GATE-SCOPE` | Documentation seulement dans N7 | Aucun fichier de jeu, runtime, dialogue, asset ou test modifié |

## 8. Arbitrages à remettre à ChatGPT avant scripting

Deux décisions seulement restent ouvertes :

1. `N7-RP-03-SANDRA-J18-W4` — choisir un acte sexuel central unique, compatible avec l’image `#079`, la progression consentie et la voix de Sandra.
2. `N7-RP-04-J17-CLARIFICATION` — approuver le pont court et la règle de projection des quatre états runtime vers les six états canoniques.

Les paquets Marie, Mathilde et J21 sont `READY_FOR_SCRIPTING`. Aucun autre arbitrage, paquet, asset ou dialogue final n’est requis par R8C-N7.
