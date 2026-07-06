# Character Voice, Messenger & Intensity Bible

> Document de cadrage produit / écriture.  
> Référence de travail pour les voix Messenger, emojis, photos, progression d'intensité et signatures des personnages.  
> Aucun runtime, aucun JSON narratif, aucune conversation jouable, aucun test ne sont modifiés ici.

## 1. Statut et hiérarchie de lecture

Ce document complète la refonte narrative existante. Il ne remplace pas :

- `docs/story_state/GLOBAL_STORY_STATE.md` pour la vérité narrative courante ;
- `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md` pour la continuité active J1-J3 ;
- `docs/V0_57_Route_Character_Rework_Blueprint.md` pour la hiérarchie macro des routes ;
- `docs/V0_59_Reworked_J1_J9_Beat_Plan.md` pour les principes de refonte J1-J9 ;
- `docs/narrative/PROOF_AND_SECRET_MAP.md` pour la gestion des preuves / traces ;
- `docs/narrative/ANTI_LOOP_RULES.md` pour les règles anti-répétition ;
- `docs/narrative/DIALOGUE_CONTENT_TEXTURE_RULES.md` pour la texture vivante des dialogues ;
- `docs/narrative/PLAYER_RESPONSE_RULES.md` pour les réponses incarnées de Player.

Règle de lecture :

```text
brut narratif validé / source packs récents = vérité narrative prioritaire
runtime JSON verrouillé = vérité jouable / implémentation technique
story_state = résumé actif de la vérité courante
V0.57 / V0.59 = macro-direction
ce document = référence de voix, intensité, emojis, photos et signatures Messenger
anciens day plans = historiques ou obsolètes si contradiction
```

## 2. Intention globale

`Réseau Intime` est un jeu de messagerie intime adulte.

Les discussions, photos et routes peuvent devenir plus directes et plus spécialisées selon les personnages. Cette montée doit rester :

- personnalisée par personnage ;
- progressive ;
- lisible ;
- liée à l'état du couple Marie / Player ;
- liée aux conséquences ;
- différenciée entre cadre clair, flou risqué, mensonge, route sombre et coût relationnel.

Règle principale :

```text
Une scène plus intense ne doit jamais être seulement "le personnage devient plus intense".
Elle doit révéler quelque chose de lui, d'elle, de leur lien ou du couple.
```

## 3. Centre dramatique

Marie / Player reste le centre dramatique.

Toutes les routes secondaires doivent être lues à travers :

- l'état du couple ;
- la transparence ou le secret ;
- la réparation ou l'éloignement ;
- l'ouverture nommée ou la dérive ;
- l'intimité émotionnelle ou l'excitation / provocation ;
- les traces et photos qui modifient les comportements.

Nico, Sandra, Mathilde, Pauline et Raphaëlle ne sont pas des routes isolées. Ils changent de fonction selon le couple.

## 4. Casting concerné

Personnages couverts dans ce document :

- Player ;
- Marie ;
- Sandra ;
- Mathilde ;
- Pauline ;
- Raphaëlle ;
- Nico.

## 5. Décisions validées à intégrer

### Marie

- Compagne de Player.
- Centre dramatique du couple.
- Très sociable, pleine d'entrain, vivante.
- Cheveux détachés.
- Aimante mais capable de poser vite des limites.
- Peut reprendre du pouvoir si Player ment.
- Peut devenir provocante, rendre jaloux, utiliser le regard de Nico ou proposer une règle / ouverture.
- Ne doit pas être réduite à "pose ton téléphone".
- Peut accepter beaucoup de choses si elles sont nommées.
- N'accepte pas d'être mise hors du réel.

### Sandra

- Ancien lien doux, distant, intime.
- En couple stable en apparence.
- Ne glisse pas parce qu'elle est disponible.
- Glisse parce qu'elle se sent regardée avec précision par Player.
- Route de valorisation, manque, confidence, retenue qui se fissure.
- Pas de bascule trop rapide.
- Les photos Sandra sont offertes quand elle se sent assez vue pour oser jouer.

### Mathilde

- Cousine de Marie.
- Présence domestique forte.
- Sportive mais pas trop : active, tonique, à l'aise avec son corps, mais pas archétype "sportive".
- Aime sortir, faire la fête.
- Fait attention à son image.
- Toujours apprêtée, même dans le quotidien.
- Aime être regardée et plaire secrètement.
- À moitié consciente du trouble.
- Départ canonique à construire autour de la scène nocturne araignée / chambre / trace douce.
- Ne pas réactiver la photo canapé legacy comme base actuelle.
- Tension : loyauté envers Marie vs plaisir d'exister dans le regard de Player.

### Pauline

- Vraie amie de Marie.
- Arrive via Marie et le social.
- Jeu, photos, contrôle, cadrage, défi.
- Sent une attirance qui grandit en elle.
- Sa loyauté envers Marie doit rester réelle.
- Elle n'est pas seulement celle qui expose : elle peut aussi être exposée.
- Doit avoir une faille, ne pas rester omnisciente ou toute-puissante.

### Raphaëlle

- Collègue directe de Player, même équipe quotidienne.
- Élégante, attentionnée, soignée.
- Prend soin d'elle et de sa beauté sans en faire trop.
- Lunettes.
- Cheveux attachés.
- Voit Player au travail : fatigue, dossiers, cafés abandonnés, notes, silences, dispersion.
- Représente la clarté, le concret, la douceur adulte.
- Refuse d'être une cachette.
- Peut devenir intime seulement si le cadre devient propre.

### Nico

- Personnage masculin miroir de Player.
- Réellement attiré par Marie.
- Joueur, Don Juan, charmant, socialement plausible.
- Ami possible, rival possible, tentateur, complice, déclencheur d'interdits.
- Peut ouvrir des routes de jalousie, partage, regard, groupe, cadre ouvert ou dérive sombre.
- Ne doit pas être un prédateur, un méchant plat ou un simple outil de jalousie.
- Ne vole pas Marie à Player : il montre à Player ce qui arrive quand Marie découvre qu'elle aussi peut être désirée, choisir et cacher.

### Player

- Discret, observateur, ironique quand il est gêné.
- Désirable mais imparfait.
- Doit répondre, mentir, assumer, esquiver, désirer, poser des limites ou se trahir.
- Ne doit pas rester un avatar vide ou une absence commentée.
- Peut être jaloux.
- Peut être troublé par sa propre jalousie.
- Peut protéger Marie, la perdre, l'ouvrir, mentir, réparer, ou s'enfoncer dans le flou.

## 6. Règle Messenger principale

Les conversations doivent ressembler à de vrais échanges Messenger, pas à des monologues interrompus par des choix.

À viser :

```text
2 à 4 messages entrants
1 réponse Player courte
2 à 4 messages entrants
1 réponse Player ou choix narratif
conséquence / relance / silence / photo
```

Les réponses guidées de rythme doivent être utilisées pour donner l'impression que Player participe vraiment, même quand aucun choix de route majeur n'est nécessaire.

## 7. Règle de voix

Chaque personnage doit être reconnaissable même sans son prénom.

Pour chaque personnage, les futures fiches doivent définir :

- signature émotionnelle ;
- syntaxe Messenger ;
- tournures récurrentes ;
- emojis typiques ;
- private jokes ;
- phrases de fuite ;
- phrases de désir ;
- phrase interdite / motif à ne pas répéter ;
- manière unique de devenir plus direct ;
- manière unique de monter en intensité ;
- manière unique d'envoyer ou de retenir des photos.

Règle d'écriture :

```text
Une scène Messenger doit contenir au moins deux éléments de signature :
- tournure typique ;
- emoji cohérent ;
- private joke ;
- réaction Player ;
- phrase imparfaite ;
- micro-fuite ;
- relance ;
- photo / trace / détail.
```

## 8. Signatures rapides

### Player

Signature : homme qui observe trop, répond avec ironie quand il est gêné, puis se trahit en une phrase trop juste.

Phrase-type :

```text
Je fais une blague parce que je ne sais pas encore répondre honnêtement.
```

### Marie

Signature : femme solaire qui refuse d'animer seule un couple qui s'éteint.

Phrase-type :

```text
Je peux être drôle ET sérieuse.
```

### Sandra

Signature : femme raisonnable en apparence, troublée par le fait d'être regardée avec précision.

Phrase-type :

```text
Je suis très raisonnable, normalement.
```

### Mathilde

Signature : cousine de Marie, apprêtée, vive, à moitié consciente qu'elle aime être regardée.

Phrase-type :

```text
Je voulais faire simple, raté.
```

### Pauline

Signature : amie loyale de Marie qui joue avec le feu, puis réalise qu'elle attend la réponse.

Phrase-type :

```text
Je dis ça en amie parfaitement loyale.
```

### Raphaëlle

Signature : collègue élégante, attentionnée, qui voit le désordre mais refuse de devenir une cachette.

Phrase-type :

```text
Je peux comprendre le flou. Je ne veux pas l'habiter.
```

### Nico

Signature : miroir masculin, charmeur, qui nomme la jalousie et ouvre les fantasmes interdits.

Phrase-type :

```text
Tu veux la vérité ou une version confortable ?
```

## 9. Tournures personnalisées

### Player

- "Je vais répondre prudemment."
- "C'est le moment où je suis censé dire un truc intelligent."
- "Je fais une blague parce que je suis gêné."
- "Je suis en train de minimiser, là."
- "Je vais être honnête à moitié. C'est déjà un progrès."
- "J'ai vu. C'est peut-être ça le problème."
- "Je ne sais pas quoi faire proprement de cette phrase."
- "Je crois que j'ai aimé ça. Et ça ne m'arrange pas."
- "Je peux mentir, mais je vais mal le faire."
- "Je réponds trop vite, non ?"

### Marie

- "Allez, bouge."
- "Je refuse qu'on devienne tristes un mardi soir."
- "Tu viens avec moi ou tu fais ton ermite ?"
- "Ne me réponds pas une phrase molle."
- "Je peux être drôle ET sérieuse."
- "Là, tu m'éteins un peu."
- "Je ne vais pas courir derrière toi dans notre propre vie."
- "Je ne te demande pas d'être simple."
- "Je te demande de ne pas me perdre exprès."
- "Tu veux du flou ? Très bien. Mais ne sois pas surpris si j'apprends aussi."

### Sandra

- "Je suis très raisonnable, normalement."
- "Ne donne pas trop d'importance à cette phrase."
- "On va dire que c'est sans conséquence."
- "C'est plus simple si on fait semblant que c'est léger."
- "Tu as une façon pénible d'être juste."
- "Je devrais arrêter de sourire à mon téléphone."
- "Ne me dis pas ça trop bien."
- "Je vais faire semblant de ne pas avoir relu."
- "Tu me rends moins raisonnable que prévu."
- "Ce n'est pas une bonne idée. Ce qui ne veut pas dire que je n'y pense pas."

### Mathilde

- "Je voulais faire simple, raté."
- "C'est bizarre ou c'est moi ?"
- "Je suis en train de m'enfoncer, là ?"
- "J'étais pas spécialement habillée."
- "Enfin si, un peu, mais pas pour ça."
- "Tu vas pas analyser ma tenue non plus."
- "Ok, j'avoue, j'aime bien qu'on remarque."
- "Mais pas toi. Enfin... bref."
- "C'est censé être normal, vu que t'es le mec de Marie."
- "Ça compte si je l'ai pas fait exprès ?"

### Pauline

- "Je dis ça en amie parfaitement loyale."
- "Réponds intelligemment."
- "Je ne suis pas en train de te piéger. Enfin pas complètement."
- "Attention, terrain glissant."
- "On va prétendre que c'est innocent."
- "Marie m'adore, je te rappelle."
- "Tu réponds trop bien, c'est embêtant."
- "Je voulais juste te taquiner."
- "Et maintenant je suis curieuse. Donc bravo."
- "Je suis en train de perdre mon alibi, là."
- "C'est le moment où je devrais être sage."

### Raphaëlle

- "Je te pose la question simplement."
- "Tu n'as pas l'air très présent aujourd'hui."
- "Je ne vais pas insister."
- "Mais je l'ai vu."
- "Tu as relu trois fois la même phrase."
- "Je peux relire ton dossier."
- "Pas clarifier ta vie à ta place."
- "Je peux comprendre le flou."
- "Je ne veux pas l'habiter."
- "Je ne veux pas être choisie dans un moment de fuite."
- "Tu fais semblant proprement. C'est presque pire."

### Nico

- "Je dis ça pour toi."
- "Tu fais semblant de pas voir ?"
- "Mauvaise réponse."
- "T'es plus jaloux que tu veux l'admettre."
- "Elle a remarqué, hein."
- "Faut suivre, mon vieux."
- "Je te juge pas. Enfin pas encore."
- "Tu veux la vérité ou une version confortable ?"
- "Attention, là tu vas aimer une mauvaise idée."
- "C'est pas qu'elle plaise aux autres le problème."
- "C'est que tu fasses semblant de le découvrir."

## 10. Emojis : principe général

Les emojis sont très présents dans les discussions.

Ils ne sont pas décoratifs. Ils sont une grammaire émotionnelle de messagerie.

Ils servent à :

- fluidifier les échanges ;
- éviter le ton trop littéraire ;
- adoucir une phrase trop directe ;
- signaler une gêne ;
- intensifier une provocation ;
- créer une private joke ;
- contredire une phrase ;
- accompagner la montée d'intensité.

Règle :

```text
Les emojis doivent progresser avec la relation.
```

## 11. Progression emoji générale

### Palier 1 — Quotidien / familiarité

```text
🙂 😅 🙄 😂
```

### Palier 2 — Gêne / trouble

```text
😅 🙃 🫠 👀
```

### Palier 3 — Provocation / jeu

```text
😇 🙃 👀 😏
```

### Palier 4 — Désir assumé

```text
😈 🔥 🫦
```

### Palier 5 — Intensité adulte

```text
😈 🔥 🫦 💋
```

## 12. Emojis par personnage

### Player

- Base : 😅 🙄 🙂
- Trouble : 👀 🙃 🫠
- Intensité : 😈 🔥 rarement

### Marie

- Base : 🙂 😅 🙄 😂 ❤️
- Limite : 🙂 seul, très chargé
- Reconquête : 😏 🔥 💋
- Pouvoir : 😈

### Sandra

- Base : 🙂 😅
- Gêne : 🙃 🫠
- Désir rare : 🫦 très rare
- Intensité : 🔥 exceptionnel

### Mathilde

- Base : 😅 🙃 🙄 😂
- Gêne : 🫠
- Regard : 👀
- Fausse innocence : 😇
- Provocation : 😏 😈
- Intensité : 🫦 🔥

### Pauline

- Base : 😇 🙂 🙃 😅
- Observation : 👀
- Trouble : 🫠
- Défi : 😏 😈
- Intensité : 🔥 🫦

### Raphaëlle

- Base : 🙂 😅
- Fêlure rare : 🫠
- Désir rare : 🫦
- Intensité : 🔥 très rare

### Nico

- Base : 😏 😂 👀 🙃
- Rivalité : 😏 👀
- Interdit : 😈 🔥

## 13. Photos : principe général

Il y aura peu de photos réellement neutres.

Les photos doivent majoritairement mettre les femmes en valeur :

- visage ;
- tenue ;
- posture ;
- contexte de séduction ;
- regard ;
- beauté ;
- désirabilité ;
- pouvoir social ;
- confiance ;
- provocation ;
- défi.

Cela ne veut pas dire que chaque photo est explicite. Cela veut dire que même une photo défendable doit nourrir le désir, la projection ou la tension.

Règle :

```text
Une photo doit être un fait narratif, pas seulement une image.
```

Elle doit modifier au moins une chose : regard de Player, confiance, culpabilité, jalousie, secret, statut de preuve, disponibilité, envie de répondre, mensonge, cadre relationnel.

## 14. Hiérarchie photo

1. Photo valorisante.
2. Photo de regard.
3. Photo de provocation.
4. Photo de défi.
5. Photo explicite dans un cadre clair et accepté.
6. Photo dangereuse / route sombre à coût relationnel.

## 15. Photos par personnage

### Marie

Photos de reconquête, visibilité sociale, couple, jalousie, pouvoir, désir conjugal.

### Sandra

Photos de reprise douce, restaurant, souvenir, confiance, valorisation.

### Mathilde

Photos d'image, fête, tenue, regard interdit, proximité domestique.

### Pauline

Photos sociales, cadrées, provocantes, contrôlées, puis potentiellement vulnérables.

### Raphaëlle

Photos rares, élégantes, concrètes, jamais mécaniquement provocantes.

### Nico

Nico sert surtout à commenter, relayer, cadrer le regard de Player et ouvrir des dynamiques de jalousie / partage / regard / cadre de groupe.

## 16. Progression d'intensité générale

Chaque route doit pouvoir évoluer selon cette échelle :

```text
1. Suggestion
2. Trouble reconnu
3. Provocation assumée
4. Désir direct
5. Intensité contrôlée
6. Fantasme structuré / route spécialisée
```

## 17. Intensité par personnage

### Marie

Intensité : conjugale, reconquête, pouvoir, jalousie, ouverture possible.

### Sandra

Intensité : lente, émotionnelle, valorisée, retenue qui craque.

### Mathilde

Intensité : regard interdit, image, fête, gêne, provocation.

### Pauline

Intensité : sociale, défi, contrôle, jeu qui dérape.

### Raphaëlle

Intensité : adulte, précise, claire, élégante, cadrée.

### Nico

Intensité : jalousie, miroir, fantasme, regard, partage, groupe, dérive sombre.

### Player

Intensité : observation, honte, désir, jalousie, curiosité, contrôle du flou.

## 18. Anti-boucles principales

Motifs à ne pas répéter sans conséquence nouvelle :

### Marie

À éviter :

```text
pose ton téléphone
regarde-moi
tu es ailleurs
```

À remplacer par : action propre, reprise de pouvoir, sortie, provocation, cadre, vérité demandée, ouverture discutée.

### Sandra

À éviter :

```text
je ne veux pas être cachée
plus tard me blesse
j'attends
```

À remplacer par : changement de disponibilité, photo retirée, silence choisi, limite, vraie proposition, valorisation qui fissure la retenue.

### Mathilde

À éviter :

```text
tu as gardé la photo ?
tu l'as supprimée ?
c'est dangereux, non ?
```

À remplacer par : scène sans photo, gêne domestique, araignée / chambre / trace douce, choix de limite, jeu qui change de nom, loyauté envers Marie.

### Pauline

À éviter :

```text
j'ai une photo
je garde quelque chose
tu veux savoir ?
```

À remplacer par : elle refuse d'envoyer, elle apparaît trop, elle perd son alibi, elle comprend qu'elle attend la réponse, son secret la rend vulnérable.

### Raphaëlle

À éviter :

```text
je ne suis pas un refuge
je peux écouter mais pas cacher
tu dois être clair
```

À remplacer par : limite concrète, pause café, dossier, marche, photo rare, cadre horaire, choix relationnel propre.

### Nico

À éviter : rival méchant, provocation mécanique, jalousie gratuite, manipulateur plat.

À remplacer par : charme social, vérité inconfortable, complicité ambiguë, fausse aide, Marie qui choisit, fantasme nommé progressivement.

## 19. Réactions types de Player

Les scènes fortes doivent donner à Player des réponses visibles.

### Vérité partielle

```text
Oui. J'étais ailleurs. Je ne sais pas encore comment te l'expliquer sans rendre ça plus laid.
```

### Mensonge doux

```text
C'était juste la fatigue. Je crois que tu cherches quelque chose qui n'est pas là.
```

### Esquive par humour

```text
Je plaide coupable de mauvaise gestion du timing, mais pas encore de crime international.
```

### Aveu de désir sans bascule

```text
Je ne vais pas faire semblant que ça ne m'a rien fait. Mais je ne sais pas quoi faire proprement de cette phrase.
```

### Limite claire

```text
Non. Là, si je continue, je vais appeler ça un jeu juste parce que ça m'arrange.
```

### Retour vers Marie

```text
Je dois arrêter de transformer tout ça en choses que je gère dans un coin. Je dois revenir vers Marie.
```

### Provocation assumée

```text
Tu voulais savoir si j'avais remarqué ? Oui. Et j'ai probablement remarqué exactement ce que tu voulais que je remarque.
```

## 20. Scènes fondatrices recommandées

### Marie

Marie veut sortir, pleine d'entrain, cheveux détachés, mais sent que Player est ailleurs.

### Sandra

Reprise par photo / souvenir / restaurant.

### Mathilde

Nuit chez Marie et Player, araignée / chambre / gêne douce.

### Pauline

Photo sociale via Marie, puis premier message direct à Player.

### Raphaëlle

Même équipe, dossier / café / fatigue remarquée.

### Nico

Soirée sociale où il fait rire Marie et teste Player.

### Player

Il répond trop tard / trop vite / trop prudemment, et se rend compte que sa réponse est déjà un choix.

## 21. Format des futures fiches complètes

Chaque fiche personnage devra utiliser ce plan :

```text
1. Identité générale
2. Place narrative
3. Lien avec Player
4. Lien avec Marie / autres personnages
5. Désir profond
6. Contradiction interne
7. Voix Messenger
8. Tournures personnalisées
9. Emojis par paliers
10. Private jokes / codes relationnels
11. Rapport aux photos
12. Progression d'intensité
13. Limites / interdits
14. Réactions aux réponses Player
15. Scène fondatrice
16. Phrases interdites / anti-boucles
17. Exemples courts Messenger
```

## 22. Règle finale

```text
Le scénario donne la direction.
Les voix, emojis, photos, maladresses, private jokes et phrases imparfaites donnent envie de rester dans la conversation.
```

Une scène réussie doit permettre de reconnaître :

- qui parle ;
- ce qu'elle / il veut ;
- ce qu'elle / il cache ;
- ce qui devient plus intense ;
- ce qui change après.
