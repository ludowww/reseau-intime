# V0.56 — Audit narratif global J1 → J9

## Baseline et périmètre
- Repo : `ludowww/reseau-intime`
- Branche : `work/narrative-continuity-audit-v0-56`
- SHA de base : `1fe89ee`
- Objet : audit uniquement, sans correction runtime ni modification des JSON narratifs.

## Sources inspectées
### Runtime
- `game/data/conversations/chapter_01_index.json` → `chapter_09_index.json`
- Toutes les conversations actives J1 → J9 listées dans ces index
- `game/data/visual_content/placeholders.json`
- `game/data/visual_content/chapter_04_proofs.json`
- `game/data/visual_content/chapter_05_proofs.json`
- `game/data/visual_content/chapter_06_proofs.json`
- `game/data/visual_content/chapter_07_proofs.json`
- `game/data/visual_content/chapter_09_proofs.json`

### Story state / continuité
- `docs/story_state/GLOBAL_STORY_STATE.md`
- `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md`
- `docs/story_state/J1_SUMMARY.md`
- `docs/story_state/J2_SUMMARY.md`
- `docs/story_state/J3_SUMMARY.md`
- `docs/story_state/J5_SUMMARY.md`

### Arc et cadrage narratifs
- `docs/narrative/SCENARIO_SPINE_J1_J10.md`
- `docs/narrative/CHARACTER_ARCS_J1_J10.md`
- `docs/narrative/J1_J10_REVISED_SCENARIO_PLAN.md`
- `docs/narrative/J5_J6_REWRITE_PLAN.md`
- `docs/narrative/MARIE_ARC_J1_J10.md`
- `docs/narrative/SANDRA_ARC_J1_J10.md`
- `docs/narrative/PAULINE_ARC_J1_J10.md`
- `docs/narrative/RAPHAELLE_ARC_J1_J10.md`
- `docs/narrative/DAILY_RHYTHM_AND_CONTENT_DENSITY.md`
- `docs/J4_DIALOGUE_POLISH_NOTES.md`

### Remarque de cadrage
- Il n’existe pas de `J6_SUMMARY`, `J7_SUMMARY`, `J8_SUMMARY` ou `J9_SUMMARY` dans `docs/story_state/` au moment de l’audit.
- L’évaluation des jours J6 → J9 repose donc surtout sur le runtime + les docs d’arc.

## Inventaire runtime actuel
| Jour | Conversations actives | Personnages / threads | Visuels |
|---|---:|---|---|
| J1 | 2 | Marie, Sandra ; Mathilde indirecte | 1 photo Sandra, pas de bundle dédié |
| J2 | 7 | Marie, Raphaëlle, Mathilde, Sandra | 4 contenus référencés via placeholders, pas de bundle J2 dédié dans `visual_content/` |
| J3 | 5 | Marie, Mathilde, Raphaëlle, Sandra | 2 contenus référencés via placeholders |
| J4 | 6 | Pauline, Marie, Mathilde, Sandra, Nico, thread groupe | 1 bundle dédié, 9 placeholders |
| J5 | 7 | Marie, Mathilde, Pauline, Raphaëlle, Sandra, Nico social | 1 bundle dédié, 9 placeholders |
| J6 | 4 | Marie, Mathilde, Pauline, Sandra | 1 bundle dédié, 4 placeholders |
| J7 | 4 | Marie, Mathilde, Pauline, Sandra | 1 bundle dédié, 3 placeholders |
| J8 | 2 | Raphaëlle, Marie | 0 bundle dédié |
| J9 | 1 | Sandra seule ; Marie/Pauline en traces indirectes | 1 bundle dédié, 3 placeholders |

## Audit jour par jour

### Jour 1 — Synthèse
- Conversations disponibles : `Jour 1 — Pain, retour et téléphone posé` ; `Jour 1 — Photo de Sandra`.
- Actifs : Marie, Sandra.
- Indirects : Mathilde seulement en arrière-plan.
- Événements clés : routine de couple, téléphone comme distance, photo-souvenir Sandra.
- Révélations : le lien Sandra se réactive sans rupture ; le couple reste le socle.
- Tensions : faibles, prudentes, surtout de disponibilité.
- Rapprochements : Marie par la logistique domestique ; Sandra par le souvenir.
- Refroidissement / distance : le téléphone et la disponibilité de Player restent le vrai sujet latent.
- Visuels / traces : photo Sandra J1 ; pas de bundle dédié.
- État émotionnel du joueur en fin de journée : curiosité contenue, nostalgie, trouble léger.
- Rôle du jour : poser le socle affectif et la route Sandra.
- Ce qui fonctionne : ancrage domestique clair, entrée douce de Sandra.
- Ce qui semble incohérent : rien de majeur.
- Ce qui est redondant : quelques ressorts de téléphone/logistique déjà très visibles.
- Ce qui manque : une conséquence plus nette de la photo Sandra.
- Ce qui arrive trop tôt : rien.
- Ce qui arrive trop tard : rien.
- Ce qui sonne trop écrit : peu ; la scène reste encore souple.

### Jour 2 — Synthèse
- Conversations disponibles : Marie matin / après-midi / nuit, Raphaëlle midi, Mathilde soir / nuit, Sandra soir.
- Actifs : Marie, Raphaëlle, Mathilde, Sandra.
- Indirects : aucun vraiment ; le réseau s’élargit.
- Événements clés : Player hors maison, badge Raphaëlle, arrivée de Mathilde, Mathilde reste dormir, Sandra rappelle la photo J1.
- Révélations : la maison devient un espace partagé ; Raphaëlle s’installe comme clarté concrète ; Sandra reste retenue.
- Tensions : domestiques, basses mais multiples.
- Rapprochements : Marie normalise, Mathilde s’ancre, Raphaëlle gagne en lisibilité, Sandra maintient le fil.
- Refroidissement / distance : Player est physiquement absent de la maison.
- Visuels / traces : 4 contenus référencés dans les messages, mais pas de bundle J2 dédié dans `game/data/visual_content/`; les ids vivent dans `placeholders.json`.
- État émotionnel du joueur en fin de journée : surcharge douce, impression d’un réseau plus large.
- Rôle du jour : ouvrir le monde sans chaos.
- Ce qui fonctionne : extension lisible du casting, bonne montée du quotidien.
- Ce qui semble incohérent : absence de bundle J2 dédié alors que la journée a bien des visuels.
- Ce qui est redondant : plusieurs micro-rappels de domesticité / canapé / équilibre.
- Ce qui manque : une conséquence plus forte de la nuit de Mathilde chez eux.
- Ce qui arrive trop tôt : rien de grave, la journée reste encore d’ouverture.
- Ce qui arrive trop tard : le retour physique de Player est réservé à J3, cohérent.
- Ce qui sonne trop écrit : certains dialogues alignent un peu trop proprement les fonctions.

### Jour 3 — Synthèse
- Conversations disponibles : Marie matin / nuit, Mathilde matin, Raphaëlle midi, Sandra soir.
- Actifs : Marie, Mathilde, Raphaëlle, Sandra.
- Indirects : Pauline et Nico encore hors champ.
- Événements clés : retour physique de Player, photo canapé de Mathilde, clarté calme de Raphaëlle, jeudi maintenu avec Sandra, demande de présence réelle de Marie.
- Révélations : Player n’est pas simplement absent ; il est déjà un peu dédoublé dans sa tête.
- Tensions : la maison devient le lieu où la trace survit à la scène.
- Rapprochements : Marie garde l’ancrage, Raphaëlle pose une limite calme, Sandra maintient le lien par retenue.
- Refroidissement / distance : Marie sent que Player n’est pas tout à fait revenu intérieurement.
- Visuels / traces : `mathilde_j3_morning_couch_placeholder`, `marie_j3_home_tender_placeholder`.
- État émotionnel du joueur en fin de journée : présence domestique, désir discret, malaise plus net.
- Rôle du jour : faire entrer le trouble dans la maison.
- Ce qui fonctionne : progression nette depuis J2, bonne articulation maison / trace / clarté.
- Ce qui semble incohérent : peu de choses, mais la scène peut paraître très fonctionnelle.
- Ce qui est redondant : le motif téléphone / retenue / trace revient encore beaucoup.
- Ce qui manque : un effet plus immédiat sur Marie après la photo de Mathilde.
- Ce qui arrive trop tôt : rien.
- Ce qui arrive trop tard : la visibilité sociale de Marie est réservée à J4, cohérent.
- Ce qui sonne trop écrit : Raphaëlle est parfois presque trop exemplaire dans sa clarté.

### Jour 4 — Synthèse
- Conversations disponibles : Pauline invite, Marie avant la soirée, groupe soirée, Mathilde observe, Sandra au mauvais moment, Pauline voit quelque chose.
- Actifs : Pauline, Marie, Mathilde, Sandra, Nico, thread groupe.
- Indirects : aucun ; tout le monde est en exposition sociale.
- Événements clés : soirée chez Pauline, photo de groupe, Nico commente Marie, capture du téléphone Player, Sandra écrit pendant la soirée.
- Révélations : le contrôle de Player sur la visibilité commence à se perdre.
- Tensions : jalousie miroir, observation, contrôle, timing raté.
- Rapprochements : Marie reste désirable et visible, Mathilde observe sans rompre, Pauline cadre le chaos.
- Refroidissement / distance : Sandra reste extérieure à la soirée et sa place devient plus délicate.
- Visuels / traces : bundle J4 de 9 placeholders, dont photo de groupe, photo Marie, photo Pauline, capture Player, story Nico/Marie.
- État émotionnel du joueur en fin de journée : surexposition, jalousie, sensation d’être observé.
- Rôle du jour : sortir le trouble du privé et le rendre visible.
- Ce qui fonctionne : vraie sensation de soirée sociale, circulation des regards, photo comme matière narrative.
- Ce qui semble incohérent : peu, mais le volume de micro-répliques peut donner un effet de scène écrite “au cordeau”.
- Ce qui est redondant : Pauline insiste beaucoup sur la photo et la capture.
- Ce qui manque : un peu plus de respiration entre les pics d’observation.
- Ce qui arrive trop tôt : Sandra au mauvais moment fonctionne, mais réduit déjà sa place au bruit social.
- Ce qui arrive trop tard : rien de majeur.
- Ce qui sonne trop écrit : plusieurs répliques de Pauline sont très explicites sur son rôle d’orchestratrice.

### Jour 5 — Synthèse
- Conversations disponibles : Marie, Mathilde, Pauline, story sociale Nico/Marie, Raphaëlle, Sandra, dernière photo Pauline.
- Actifs : Marie, Mathilde, Pauline, Raphaëlle, Sandra, Nico via réseau social.
- Indirects : Nico surtout comme miroir social ; Pauline et Marie alimentent la mémoire des images.
- Événements clés : Marie nomme le vacillement du couple, Pauline comprend trop bien, story Nico/Marie, Mathilde demande la photo gardée, Sandra ouvre le jeu de vérité, Raphaëlle reste concrète, Pauline laisse encore une photo.
- Révélations : l’image devient dette, pas simple souvenir ; Pauline a peut-être son propre secret ; Marie devient réellement active.
- Tensions : fortes, mais très éclatées entre 6 axes.
- Rapprochements : Marie revient au centre, Sandra gagne en densité retenue, Pauline passe du cadrage à la complicité dangereuse.
- Refroidissement / distance : Sandra reste retenue ; Raphaëlle refuse la cachette ; Nico reste un miroir.
- Visuels / traces : bundle J5 de 9 placeholders.
- État émotionnel du joueur en fin de journée : surcharge, culpabilité, tentation de fragmenter les routes.
- Rôle du jour : faire passer les images de traces à dettes sociales.
- Ce qui fonctionne : le principe de dette visuelle, la lucidité de Marie, le danger de Pauline.
- Ce qui semble incohérent : la journée est trop dense et frôle le panel ; elle multiplie les micro-présences au lieu de laisser un pivot respirer.
- Ce qui est redondant : photo / garde / supprime / plus tard / cachette.
- Ce qui manque : une concentration plus nette sur un conflit principal.
- Ce qui arrive trop tôt : le seed du secret Pauline est peut-être un peu rapide si on veut la préserver encore opaque.
- Ce qui arrive trop tard : la vraie décision Player sur une trace est repoussée à J6, ce qui est acceptable mais crée une attente forte.
- Ce qui sonne trop écrit : certaines formulations sont très “fonction de scène” et moins SMS spontanées.

### Jour 6 — Synthèse
- Conversations disponibles : Mathilde trace, Marie sent une position, Pauline prix du silence, Sandra une chose honnête.
- Actifs : Marie, Mathilde, Pauline, Sandra.
- Indirects : aucun ; les routes s’affrontent sur la décision.
- Événements clés : choix de la trace, Marie repère les micro-choix, Pauline teste le prix du silence, Sandra réclame une réponse honnête.
- Révélations : Player doit faire quelque chose de concret ; le flou devient coûteux.
- Tensions : décision, vérité, silence, possession des traces.
- Rapprochements : Marie reçoit une vérité, Sandra gagne en intensité retenue, Mathilde force l’assomption.
- Refroidissement / distance : Pauline met du prix sur son silence.
- Visuels / traces : bundle J6 de 4 placeholders.
- État émotionnel du joueur en fin de journée : pression décisionnelle, impression de ne plus pouvoir rester passif.
- Rôle du jour : forcer un acte réel.
- Ce qui fonctionne : pivot clair, bonne charnière entre photos et conséquences.
- Ce qui semble incohérent : peu ; c’est un des jours les plus nets.
- Ce qui est redondant : la métaphore de la trace revient encore, mais ici elle devient utile.
- Ce qui manque : une respiration visuelle un peu plus marquée pourrait alléger la densité.
- Ce qui arrive trop tôt : rien.
- Ce qui arrive trop tard : rien de majeur.
- Ce qui sonne trop écrit : quelques choix sont très explicites, mais le jour assume sa fonction de nœud.

### Jour 7 — Synthèse
- Conversations disponibles : Mathilde trop proche, Marie sent une différence, Sandra sous lampe basse, Pauline moins théorique.
- Actifs : Marie, Mathilde, Sandra, Pauline.
- Indirects : aucun.
- Événements clés : la proximité domestique devient trop nette, Marie sent le changement, Sandra reste douce, Pauline observe moins abstraitement.
- Révélations : le geste de J6 a laissé une trace visible dans la posture de Player.
- Tensions : proximité, recul, calme troublé.
- Rapprochements : Sandra gagne en chaleur retenue ; Marie reçoit une parole plus claire ; Mathilde teste le seuil.
- Refroidissement / distance : Pauline cesse d’être purement théorique, ce qui la rend plus inquiétante.
- Visuels / traces : bundle J7 de 3 placeholders.
- État émotionnel du joueur en fin de journée : inconfort concret, sensation de pièce trop petite.
- Rôle du jour : faire sentir la conséquence du choix de J6.
- Ce qui fonctionne : très bonne lisibilité du lendemain de décision.
- Ce qui semble incohérent : peu ; c’est un jour solide.
- Ce qui est redondant : encore la proximité / recul / trace, mais la variation de fonction est suffisamment claire.
- Ce qui manque : un peu plus de différence de rythme entre Mathilde, Sandra et Pauline.
- Ce qui arrive trop tôt : rien.
- Ce qui arrive trop tard : rien.
- Ce qui sonne trop écrit : la mécanique reste très visible, mais le jour est maîtrisé.

### Jour 8 — Synthèse
- Conversations disponibles : Raphaëlle garde la ligne, Marie sent le coût.
- Actifs : Raphaëlle, Marie.
- Indirects : les autres routes restent hors champ.
- Événements clés : limite concrète, recentrage sur une action claire, coût émotionnel du recentrage.
- Révélations : Player ne peut pas seulement dire “je gère” ; il doit finir quelque chose.
- Tensions : basse mais nette, centrée sur la clarté.
- Rapprochements : Raphaëlle gagne un rôle de cadre concret ; Marie redevient le point émotionnel.
- Refroidissement / distance : Sandra est volontairement absente ; Pauline, Mathilde et Nico s’effacent.
- Visuels / traces : aucun nouveau proof dédié.
- État émotionnel du joueur en fin de journée : respiration, lucidité, légère culpabilité.
- Rôle du jour : poser une pause lisible après la densité J5-J7.
- Ce qui fonctionne : lisibilité maximale, très bon contrepoint.
- Ce qui semble incohérent : par rapport aux docs plus anciens, J8 devait être la première contradiction ou une polarisation plus nette ; runtime choisit plutôt le recentrage et la sobriété.
- Ce qui est redondant : peu ; la simplicité est précisément la qualité du jour.
- Ce qui manque : un petit peu de surprise, peut-être une tension plus organique dans la transition.
- Ce qui arrive trop tôt : rien.
- Ce qui arrive trop tard : la mise en pause de Sandra est volontaire ; elle n’est pas un manque, mais une respiration.
- Ce qui sonne trop écrit : les phrases sont très propres, presque trop parfaites dans leur fonction.

### Jour 9 — Synthèse
- Conversations disponibles : Sandra seule, avec traces indirectes Marie et Pauline dans le même thread.
- Actifs : Sandra.
- Indirects : Marie et Pauline via contenu visuel / story ; Raphaëlle et Mathilde sont volontairement absentes.
- Événements clés : photo du déjeuner, photo calme de Marie, story trop propre de Pauline, demande / réclamation de la photo.
- Révélations : Sandra ne veut pas devenir attente vide ; elle retient les détails et valorise le fait d’être lue maintenant.
- Tensions : retenue, manque, désir de précision.
- Rapprochements : Sandra redevient centre de lien, sans disponibilité acquise.
- Refroidissement / distance : absence active de Marie et des autres threads ; c’est une journée resserrée.
- Visuels / traces : bundle J9 de 3 placeholders, soft et relationnels.
- État émotionnel du joueur en fin de journée : désir retenu, manque plus net, impression d’un lien ré-ouvert sans fermeture.
- Rôle du jour : relancer Sandra avec une photo douce, sans panel.
- Ce qui fonctionne : cohérence de l’Option A, bons marqueurs de retenue et de souvenir.
- Ce qui semble incohérent : le runtime a choisi un jour Sandra-only alors que les docs de plan général présentent J9 comme un jour de coût / choix plus ouvert ; ce n’est pas faux, mais c’est un rétrécissement net.
- Ce qui est redondant : la photo / le détail / le “plus tard” restent proches du vocabulaire déjà vu, mais la finesse de Sandra limite la sensation de répétition.
- Ce qui manque : une confrontation plus explicite avec le coût du choix, si l’on suit strictement l’arc de J9 dans les docs généraux.
- Ce qui arrive trop tôt : rien.
- Ce qui arrive trop tard : Marie et Pauline sont reléguées au statut de traces ; c’est probablement voulu, mais cela ferme un peu l’horizon.
- Ce qui sonne trop écrit : quelques répliques restent très construites, mais l’ensemble est plus respirable que J5.

## Audit par discussion / personnage

### Marie
- Évolution : elle passe de la routine à la lucidité, puis à la demande de présence, puis à la prise de coût.
- Cohérence présence / absence : globalement bonne ; Marie reste le socle et revient souvent au bon endroit.
- Tension de couple : crédible, progressive, jamais coupée trop tôt.
- Rôle dans l’intrigue : ancre du réel, miroir moral et affectif de Player.
- Continuité de l’information : bonne sur J1 → J8 ; J9 la réduit à une trace indirecte, ce qui est cohérent pour l’option choisie.
- Trop présente / pas assez présente / incohérente : trop présente surtout en J5 si l’on voulait un pivot plus resserré ; pas assez présente en J9 si l’on attendait un coût direct.

### Sandra
- Évolution : réactivation photo → prudence → mauvaise place → blessure douce → honnêteté retenue → relance fine J9.
- Complicité / tension : très bonne ; la route avance par manque, précision et retenue.
- Désir retenu : cohérent et bien tenu.
- Continuité J1 → J9 : forte, avec une vraie mémoire des photos et du “plus tard”.
- Moments forts : J1 photo, J4 mauvais moment, J5 photo supprimée / photo gardée, J6 vérité, J9 retour doux.
- Moments faibles : J2 peut sembler surtout de rappel ; J8 l’efface volontairement.
- Répétitions : le motif photo / retenue / plus tard revient souvent, mais la fonction change assez souvent pour rester lisible.
- Trop écrit : quelques formulations très propres, mais la voix reste la plus stable du runtime.
- Niveau de trouble actuel : élevé mais retenu, ce qui fonctionne bien.

### Pauline
- Évolution : hôte sociale → cadreuse → gardienne de photos → complice dangereuse → prix du silence.
- Complicité / contrôle : bonne, mais la route est très codée par les photos et le cadrage.
- Continuité : solide de J4 à J7 ; J5 et J6 l’installent comme enjeu de contrôle et de fragilité.
- Moments forts : J4 capture du téléphone, J5 dernière photo, J6 silence, J7 observation moins théorique.
- Moments faibles : le risque d’omniscience reste réel ; certaines lignes disent trop bien sa fonction.
- Répétitions : photo / preuve / appât / silence.
- Trop écrit : oui, davantage que Marie ou Sandra ; Pauline porte souvent les phrases les plus “scénarisées”.
- Niveau de trouble : fort, mais encore très contrôlé.

### Raphaëlle
- Évolution : clarté douce → observatrice concrète → limite → respiration → recentrage.
- Cohérence de présence / absence : très bonne ; elle sait aussi disparaître quand elle n’est pas utile.
- Tension : plus basse que Sandra ou Pauline, mais crédible et utile.
- Rôle : contrepoint adulte, pas cachette.
- Continuité : bonne, même si les docs plus anciens lui donnaient parfois un rôle de refuge plus actif que le runtime ne le fait.
- Moments forts : J2 badge, J3 fatigue, J5 bureau, J8 ligne claire.
- Moments faibles : elle peut paraître trop “propre” et un peu moins vulnérable que les autres.
- Répétitions : le refus de cachette, la clarté, l’adulte-concret.
- Trop écrit : modérément ; c’est surtout sa fonction qui est très nette.
- Niveau de trouble : moyen, volontairement contenu.

### Mathilde
- Évolution : présence domestique → couch / photo → témoin du trouble → proximité trop nette → trace / décision.
- Cohérence : bonne, surtout quand le texte garde la loyauté envers Marie en sous-texte.
- Rôle : faire entrer la tension dans la maison sans passer immédiatement au sexualisé frontal.
- Continuité : forte entre J2, J3, J4, J6, J7.
- Moments forts : J2 nuit sur place, J3 photo canapé, J4 observation sociale, J6 décision de trace, J7 proximité.
- Moments faibles : J5 est davantage utilitaire, presque tribunal domestique.
- Répétitions : photo / canapé / garder-supprimer / proximité.
- Trop écrit : parfois, surtout quand la scène annonce trop explicitement sa fonction.
- Niveau de trouble : moyen à fort, mais encore très lié au domestique.

### Nico et groupes éventuels
- Présence réelle / indirecte : Nico fonctionne mieux en miroir social qu’en personnage autonome.
- Fonction actuelle : visibilité de Marie, jauge de jalousie, comparaison sociale.
- Clarté pour le joueur : claire en J4-J5 ; plus diffuse ensuite, ce qui est acceptable.
- Surcharge : il ne doit pas devenir une menace constante.
- Manque : un peu plus de réapparitions non caricaturales si le projet veut le garder vivant au-delà du miroir.
- Groupes : le thread groupe J4 est le meilleur usage du collectif ; la story J5 reste plus faible mais utile comme trace.

## Carte de continuité narrative J1 → J9
| Jour | Événements réellement joués | Infos révélées | Infos seulement suggérées | Rapprochements | Tensions | Promesses ouvertes | Promesses non suivies / fils faibles | Contradictions possibles |
|---|---|---|---|---|---|---|---|---|
| J1 | Marie + Sandra | couple stable, photo Sandra | Mathilde en arrière-plan | intime domestique, ancienne amitié | absence / téléphone | jeudi avec Sandra | aucune vraie dette encore | rien de majeur |
| J2 | Marie / Raphaëlle / Mathilde / Sandra | maison partagée, Sandra rappelée | retour physique de Player à venir | normalisation de Mathilde, clarté Raphaëlle | absence de Player | J3 retour maison | bundle visuel J2 pas séparé | faible |
| J3 | retour maison | Player revient mais pas tout à fait | jeudi maintenu, fatigue, fenêtre ouverte ailleurs | Marie / Raphaëlle / Sandra | maison + trace | J4 exposition sociale | la photo Mathilde demande une suite plus visible | faible |
| J4 | soirée Pauline + groupe | visibilité sociale, capture du téléphone | contrôle de Pauline, jalousie miroir | Marie visible en public | regard social, mauvais timing Sandra | J5 mémoire des images | Sandra reste en périphérie | peu |
| J5 | lendemain / photos / story / limites | images = dette, Marie vacille, Pauline comprend | secret Pauline, rôle de Nico, retenue Sandra | Marie active, Pauline complice | surcharge, fragmentation | J6 acte concret | trop de micro-présences pour un seul pivot | journée plus panel que le plan révisé |
| J6 | décision de trace | Player agit réellement | coût du silence, honnêteté avec Sandra | Marie reçoit une vraie réponse | silence / vérité / garder-supprimer | changement de posture durable | peu ; c’est un nœud utile | faible |
| J7 | conséquence du choix | Player a changé de posture | nouveau seuil domestique | Sandra douce, Marie perçoit | proximité trop nette | J8 recentrage | aucune grande promesse oubliée | faible |
| J8 | recentrage lisible | clarté concrète, coût émotionnel | retour au couple comme point fixe | Raphaëlle + Marie | respiration, lucidité | J9 relance relationnelle | contrairement à certains docs, la contradiction n’est pas le pivot | oui, avec les docs plus anciens |
| J9 | Sandra seule + traces indirectes | manque retenu, photo douce, story Pauline | Marie / Pauline hors champ mais présentes en trace | Sandra redevient centre | absence des autres threads | suite Sandra / coût | J9 est plus étroit que le plan général | oui, selon le cadrage retenu |

## Évolution globale
- L’intimité monte globalement de façon naturelle jusqu’à J6.
- Le désir et la frustration progressent bien, surtout via Sandra, Mathilde et Pauline.
- L’histoire avance réellement de J1 à J7 : ce n’est pas un simple empilement de scènes.
- Le joueur comprend les enjeux principaux : couple, traces, regard social, clarté, silence.
- Les personnages arrivent dans un rythme globalement correct, avec Marie comme base, Sandra comme tension lente, Mathilde comme trouble domestique, Pauline comme contrôle social, Raphaëlle comme clarté.
- J5 est le jour qui ressemble le plus à un remplissage dense ou un quasi-panel.
- J8 est le meilleur contrepoids respiratoire.
- J9 fonctionne comme respiration ciblée et retour à un axe unique.
- Le jeu respecte assez bien l’intention “livre intime dont vous êtes le héros” : le téléphone est le support du réel, pas un simple menu.
- La principale fragilité globale n’est pas le contenu, mais la lisibilité des fonctions de J5/J7/J9 par rapport aux plans documentaires qui les entourent.

## Comparaison avec l’arc narratif prévu
### Élément conforme
- J1-J4 suivent très bien la colonne vertébrale de base : réactivation douce, ouverture du réseau, retour domestique, exposition sociale.
- Marie reste l’ancre du couple.
- Sandra reste un lien ancien, retenu, non gratuit.
- Raphaëlle reste claire et concrète.
- Mathilde reste liée à la maison et à la trace.
- Pauline devient un nœud de contrôle et d’images.
- Le système photo / trace / preuve faible est bien installé.

### Élément partiellement conforme
- J5 : l’idée “Marie active + Pauline dangereusement compréhensive” est bien présente, mais le runtime ajoute trop de micro-routes et garde une impression de panel.
- J6 : le jour de l’acte concret est très cohérent, mais reste très codé autour de la trace.
- J8 : la lisibilité et la clarté sont excellentes, mais le runtime remplace la “première vraie contradiction” décrite dans certains docs plus anciens par un recentrage plus sobre.
- J9 : le runtime choisit clairement l’Option A Sandra-only, cohérente avec le bundle et le texte, mais plus étroite que les plans généraux qui imaginent J9 comme un jour de coût plus ouvert.

### Élément absent
- Aucun J10 runtime.
- Aucun lock narratif léger réellement porté à l’écran.
- Aucune montée explicite vers une règle de couple formalisée.
- Pas de dialogue direct Marie/Nico au centre de J8-J9.
- Pas de J9 multi-voix.

### Élément trop tôt
- Le seed du secret Pauline est posé assez tôt pour être déjà lisible comme ligne de fond.
- Certains jours J5/J7 donnent parfois l’impression d’avoir déjà avancé très loin sur la grammaire des preuves.

### Élément trop tard
- Si l’on suit strictement les docs de plan révisé, le vrai coût de J9 arrive plus tôt dans l’arc théorique que dans le runtime réel.
- La clarification d’un verrou relationnel léger n’apparaît pas encore.

### Écart de ton
- Le runtime est un peu plus propre et plus respirable que certaines formulations de plan.
- Les docs attendent parfois un conflit plus polarisé ; le runtime préfère souvent une tenue plus douce.

### Écart de structure
- Contradiction majeure : `SCENARIO_SPINE_J1_J10.md` et `J5_J6_REWRITE_PLAN.md` disent encore que J5/J6 sont provisoires et que J7 ne doit pas être produit tant que J5/J6 ne sont pas refondus, alors que le runtime contient déjà J7, J8 et J9.
- Le runtime a donc dépassé un cadrage documentaire plus ancien.
- Autre écart : l’arc général J9 décrit un choix de coût plus ouvert ; le runtime a volontairement compacté J9 en Sandra-only.

### Écart de rythme
- J5 est trop dense et trop proche d’un panel.
- J8 est très lisible mais peut sembler presque trop sage.
- J9 respire bien mais ferme partiellement la pluralité des routes.

### Risques pour les jours suivants
- Si J10 arrive sans clarification documentaire, le jeu risque de ré-ouvrir des motifs déjà traités sans conséquence nouvelle.
- Si J5 reste la référence implicite, l’équipe peut vouloir “réparer” de mauvaises raisons.
- Si J9 est lu comme un modèle général, on risque de sous-estimer le besoin de coût et de choix relationnel dans les jours suivants.

## Recommandations

### Priorité 1 — blocants narratifs
1. **Aligner la base documentaire sur le runtime réel J7 → J9**
   - Problème constaté : les docs d’arc et le plan révisé ont encore une logique “J5/J6 provisoires, J7 à ne pas produire”, alors que le runtime est déjà au-delà.
   - Fichiers concernés : `docs/narrative/SCENARIO_SPINE_J1_J10.md`, `docs/narrative/J1_J10_REVISED_SCENARIO_PLAN.md`, `docs/narrative/J5_J6_REWRITE_PLAN.md`, `docs/story_state/J5_SUMMARY.md`, runtime J7-J9.
   - Impact joueur : risque de mauvaise lecture des intentions réelles.
   - Direction : faire un document de vérité unique sur l’état runtime J1-J9.
   - Risque si non corrigé : les futures corrections viseront une cible documentaire obsolète.
   - Priorité : 1.

2. **Décider si J9 est officiellement Sandra-only ou doit redevenir un jour de coût plus ouvert**
   - Problème constaté : le runtime J9 est cohérent en Option A, mais le plan général reste plus large.
   - Fichiers concernés : `game/data/conversations/chapter_09_index.json`, `chapter_09_sandra_relance.json`, `chapter_09_proofs.json`, `docs/narrative/J1_J10_REVISED_SCENARIO_PLAN.md`, `docs/narrative/CHARACTER_ARCS_J1_J10.md`.
   - Impact joueur : horizon narratif soit resserré proprement, soit perçu comme amputé.
   - Direction : trancher explicitement la cible J9 avant toute correction.
   - Risque si non corrigé : le jour 9 sera interprété différemment selon les lecteurs.
   - Priorité : 1.

### Priorité 2 — problèmes de rythme / tension
3. **Réduire l’effet panel de J5**
   - Problème constaté : trop de threads importants dans le même jour, au détriment d’un pivot principal.
   - Fichiers concernés : `game/data/conversations/chapter_05_*.json`, `chapter_05_index.json`, `docs/narrative/J5_J6_REWRITE_PLAN.md`.
   - Impact joueur : surcharge et difficulté à identifier l’axe émotionnel principal.
   - Direction : laisser 1 pivot + 1 contrepoint, pas 4 sous-axes équivalents.
   - Risque si non corrigé : fatigue narrative et impression de “scène construite”.
   - Priorité : 2.

4. **Clarifier le rôle de J8 comme respiration versus contradiction**
   - Problème constaté : les docs plus anciens attendaient une contradiction forte, le runtime donne un recentrage propre.
   - Fichiers concernés : `game/data/conversations/chapter_08_*.json`, `chapter_08_index.json`, `docs/narrative/J1_J10_REVISED_SCENARIO_PLAN.md`.
   - Impact joueur : si l’intention n’est pas clarifiée, J8 peut sembler trop sage ou, au contraire, parfaitement apaisant.
   - Direction : documenter si J8 est une pause ou une vraie cassure douce.
   - Risque si non corrigé : mauvaises attentes pour J9/J10.
   - Priorité : 2.

5. **Mieux varier la charge des motifs photo / trace / garder / supprimer**
   - Problème constaté : ces motifs sont très utiles mais omniprésents de J3 à J7.
   - Fichiers concernés : surtout J3-J7, plus `docs/narrative/DAILY_RHYTHM_AND_CONTENT_DENSITY.md`.
   - Impact joueur : risque de sensation de répétition.
   - Direction : alterner avec des actions, horaires, interruptions ou silences plus distincts.
   - Risque si non corrigé : lassitude et prévisibilité.
   - Priorité : 2.

### Priorité 3 — polish de voix / naturel
6. **Désépaissir certaines lignes trop “fonctionnelles” de Pauline**
   - Problème constaté : Pauline dit souvent exactement ce que la scène représente.
   - Fichiers concernés : `chapter_04_pauline_invite.json`, `chapter_04_pauline_late_control.json`, `chapter_05_pauline_photos.json`, `chapter_06_pauline_kept_photos.json`, `chapter_07_pauline_less_theoretical.json`.
   - Impact joueur : sentiment d’un texte très scénarisé.
   - Direction : garder l’intelligence de Pauline, mais réduire le sur-commentaire.
   - Risque si non corrigé : perte de naturel.
   - Priorité : 3.

7. **Alléger quelques transitions trop parfaites chez Raphaëlle**
   - Problème constaté : Raphaëlle est souvent lisible, mais parfois un peu trop propre.
   - Fichiers concernés : `chapter_02_raphaelle_midday.json`, `chapter_03_raphaelle_midday.json`, `chapter_05_raphaelle_boundary.json`, `chapter_08_raphaelle_clarity.json`.
   - Impact joueur : clarté très bonne, mais moindre surprise vocale.
   - Direction : ajouter de petites aspérités ou respirations concrètes.
   - Risque si non corrigé : personnage trop exemplaire.
   - Priorité : 3.

8. **Rendre J9 un peu moins “propre” dans la mise en forme des traces indirectes**
   - Problème constaté : J9 est lisible mais très net, presque trop composé.
   - Fichiers concernés : `chapter_09_sandra_relance.json`, `chapter_09_proofs.json`.
   - Impact joueur : belle cohérence, mais légère baisse de spontanéité.
   - Direction : conserver l’Option A tout en laissant respirer davantage le sous-texte.
   - Risque si non corrigé : sensation de collage thématique.
   - Priorité : 3.

### Priorité 4 — opportunités futures
9. **Préparer un vrai document de vérité J1 → J9 pour la V0.57**
   - Problème constaté : les docs existants ne portent pas tous la même version de la vérité.
   - Fichiers concernés : principalement les docs narratifs cités plus haut.
   - Impact joueur : indirect, mais utile pour la production.
   - Direction : synthèse de référence unique avant toute correction.
   - Risque si non corrigé : corrections dispersées.
   - Priorité : 4.

10. **Exploiter la respiration J8 comme modèle de rythme pour les jours suivants**
    - Problème constaté : la densité précédente peut écraser les jours suivants.
    - Fichiers concernés : J8 runtime, `docs/narrative/DAILY_RHYTHM_AND_CONTENT_DENSITY.md`.
    - Impact joueur : meilleure lisibilité de l’arc.
    - Direction : alterner nœud dense / respiration claire.
    - Risque si non corrigé : fatigue narrative.
    - Priorité : 4.

## Conclusion courte
- Le runtime J1 → J9 est globalement cohérent et lisible.
- Les plus gros sujets ne sont pas des erreurs de contenu brut, mais des contradictions de cadrage documentaire et un J5 trop dense.
- Sandra, Marie, Mathilde, Pauline et Raphaëlle ont tous une trajectoire identifiable.
- J8 est un bon temps de respiration ; J9 est cohérent en Option A, mais plus étroit que les plans généraux.
- Le point bloquant principal pour la suite est d’aligner les docs sur la réalité runtime avant toute correction narrative.
