# J4 — Fondation d’écriture : soirée sociale, regards croisés et convergence

## Statut

Document de cadrage pour écriture et intégration data-first du Jour 4.

Ce document prolonge :

- `docs/J3_WRITING_FOUNDATION.md`
- `docs/J3_J5_Desire_Tension_Visual_Routes_Spec.md`
- `docs/decisions/DECISION_007_J3_J5_DESIRE_TENSION_VISUAL_ROUTES.md`

## Fonction narrative de J4

J4 est le premier vrai croisement social.

Après J3, Player a commencé à cacher non seulement des messages, mais aussi ce que ces messages lui font. J4 fait entrer cette tension dans un espace plus exposé : une soirée, des regards, des photos, des réactions, des notifications, des témoins.

Question centrale :

```text
Que se passe-t-il quand les secrets du téléphone entrent dans la même pièce que les personnes concernées ?
```

J4 ne doit pas encore faire exploser le réseau. Il doit donner au joueur le vertige des possibilités : Marie, Sandra, Mathilde, Pauline, Nico, Raphaëlle existent presque en même temps, mais Player ne peut pas tout ouvrir sans coût.

## Rôle dans la progression

```text
J1 — Couple + Sandra réactivée
J2 — Réseau ouvert + Mathilde dans la maison + Player absent
J3 — Retour maison + premier désir domestique visible + premiers secrets conscients
J4 — Soirée sociale + regards croisés + convergence des notifications
J5 — Lendemain + première preuve faible
```

## Conversations actives J4

Fils visibles recommandés :

```text
Marie
Mathilde
Sandra
Pauline
```

Fils ou traces possibles :

```text
Nico — plutôt via groupe, story, réaction ou présence sociale
Raphaëlle — pas active pendant la soirée, mais peut exister comme contrepoint avant/après
```

Important : J4 peut introduire Pauline plus nettement, mais ne doit pas encore transformer Pauline et Nico en routes lourdes rétroactivement. Leur fonction principale est d’augmenter la pression sociale et la menace de preuve.

## Structure globale J4

```text
1. Pauline — Invitation / relance de soirée
2. Marie — Préparation / couple en public
3. Soirée — Photo sociale / première image de groupe
4. Nico — Regard sur Marie / jalousie miroir
5. Mathilde — Elle observe Player
6. Sandra — Notification au mauvais moment
7. Pauline — Elle a vu quelque chose
8. Convergence — Plusieurs fils s’ouvrent presque ensemble
```

## Cadence émotionnelle

```text
Début : soirée presque légère, promesse sociale.
Montée : Marie redevient visible et désirée.
Tension : Nico regarde Marie, Player réagit.
Trouble : Mathilde remarque le trouble de Player.
Rupture d’attention : Sandra écrit au mauvais moment.
Danger : Pauline voit ou capture un détail.
Vertige : plusieurs routes semblent ouvertes, mais pas sans coût.
```

## Formule d’écriture J4

Chaque scène J4 doit contenir :

```text
un regard
une photo, story ou capture possible
une personne qui observe plus qu’elle ne dit
un choix de priorité ou de mensonge
```

---

# J4_01 — Pauline / Invitation ou relance de soirée

## Fonction

Introduire Pauline comme pression sociale et observatrice.

Elle ne doit pas encore être la manipulatrice totale. Elle doit d’abord paraître légère, sociale, piquante, puis laisser entendre qu’elle voit les choses.

## Moment proposé

```text
Fin d’après-midi — message privé Pauline ou petit groupe léger
```

## Ton de surface

```text
social
piquant
fausse innocence
amusé
```

## Sous-texte

```text
Pauline teste qui vient, qui hésite, qui se cache déjà derrière son téléphone.
```

## Désir perceptible

Pauline n’est pas encore frontalement séduisante. Son désir passe par la provocation et le risque : elle rend l’idée de la soirée dangereuse parce qu’elle observe trop bien.

## Point de tension

Player peut prétendre que la soirée ne l’intéresse pas, alors qu’il veut savoir qui sera là : Marie, Mathilde, Nico, Pauline.

## Mensonge possible

À Marie :

```text
Ça me dit moyen, mais si tu veux y aller.
```

alors que Player est curieux ou inquiet.

## Photo / trace possible

- story d’invitation ;
- selfie léger de Pauline ;
- photo de préparation envoyée par Pauline ;
- mention qu’elle prendra des photos ;
- message à double sens : “je garde tout”.

## Choix joueur recommandés

### A — Accepter naturellement

Effets possibles :

```text
pauline_threat_seed +1
marie_trust +0
```

### B — Faire semblant d’être indifférent

Effets possibles :

```text
lie_score +1
pauline_interest +1
```

### C — Demander qui vient

Effets possibles :

```text
pauline_interest +1
nico_threat_seed +1
mathilde_route_pressure +1
```

### D — Rester près de Marie

Effets possibles :

```text
marie_route_pressure +1
marie_trust +1
```

## Phrases exemples

```text
Pauline : Petite soirée tranquille.
Pauline : Donc probablement pas tranquille, mais on fera semblant.
```

```text
Pauline : Viens, ça fera du bien à Marie de voir des gens qui ne sont pas ton écran.
```

```text
Pauline : Je préviens, je prends des photos.
Pauline : Les gens sont plus honnêtes quand ils oublient qu’on les regarde.
```

## Phrase interdite

```text
Je vais te piéger.
```

Trop explicite.

---

# J4_02 — Marie / Préparation ou arrivée

## Fonction

Montrer Marie comme femme désirée, pas seulement comme compagne.

J4 doit rappeler que Marie peut elle aussi être regardée, photographiée, désirée, complimentée. Cela prépare Nico, mais aussi la route Marie réparation / reconquête.

## Moment proposé

```text
Avant soirée — maison / miroir / arrivée
```

## Ton de surface

```text
tendre
concret
un peu joueur
couple en public
```

## Sous-texte

```text
Marie veut retrouver une normalité de couple avec Player devant les autres.
```

## Désir perceptible

Marie peut demander l’avis de Player sur sa tenue ou envoyer une photo. Le joueur doit sentir que la choisir est aussi une envie, pas seulement un devoir moral.

## Point de tension

Player peut être préoccupé par Mathilde, Sandra ou Pauline au moment où Marie attend un regard simple.

## Photo conditionnelle

`photo_marie_evening_j4`

Type : photo.

Palier : 1 — Ambigu / désir de couple.

Déblocage recommandé : Player valorise Marie, répond avec désir ou choisit de rester présent.

Placeholder :

```text
Photo envoyée : Marie avant la soirée, tenue simple mais plus apprêtée que d’habitude, lumière de salle de bain ou entrée. Elle ne pose pas de façon provocante, mais elle sait qu’elle est jolie et attend le regard de Player.
```

## Choix joueur recommandés

### A — La regarder vraiment

Effets possibles :

```text
marie_route_pressure +2
marie_trust +1
photo_marie_evening_j4_available = true
```

### B — Répondre distraitement

Effets possibles :

```text
marie_suspicion +1
nico_threat_seed +1
```

### C — Faire une blague pour esquiver

Effets possibles :

```text
lie_score +1
marie_suspicion +1
```

### D — Être jaloux avant même Nico

Effets possibles :

```text
ludo_jealousy +1
nico_threat_seed +1
marie_suspicion +1
```

## Phrases exemples

```text
Marie : Je mets ça ou c’est trop pour une soirée “tranquille” ?
```

```text
Marie : J’ai envie que tu me regardes avant que les autres donnent leur avis.
```

```text
Marie : Si tu réponds “comme tu veux”, je te bloque jusqu’à demain matin.
```

## Phrase interdite

```text
Tu crois que Nico va aimer ?
```

Trop direct avant que Nico soit installé.

---

# J4_03 — Soirée / Photo sociale initiale

## Fonction

Créer la première image sociale réutilisable.

La photo ou story ne doit pas être directement explosive. Elle doit sembler légère, mais contenir un détail qui pourra prendre du poids en J5.

## Moment proposé

```text
Début de soirée — arrivée / premier groupe / première story
```

## Ton de surface

```text
léger
social
vivant
fausse normalité
```

## Sous-texte

```text
Tout le monde n’a pas encore menti, mais tout le monde peut déjà être observé.
```

## Photo obligatoire J4

`photo_party_group_j4`

Type : photo ou story.

Palier : 0 à 1.

Fonction : première trace sociale.

Placeholder :

```text
Photo/story : petit groupe en soirée, Marie visible et lumineuse, Pauline au premier plan ou derrière l’objectif, Mathilde dans le cadre, Nico proche mais pas encore trop évident. Player peut être partiellement visible ou hors-champ, téléphone en main ou regard détourné selon route.
```

## Détails exploitables possibles

- Nico regarde Marie ;
- Marie sourit à quelqu’un hors champ ;
- Mathilde regarde Player ;
- Pauline cadre trop bien ;
- Player regarde son téléphone ;
- une notification apparaît en reflet ou dans une main ;
- personne ne remarque le détail avant J5.

## Choix joueur recommandés

### A — Regarder la photo normalement

Effets possibles :

```text
party_photo_seen_j4 = true
```

### B — Zoomer / s’attarder

Effets possibles :

```text
ludo_jealousy +1
pauline_threat_seed +1
```

### C — Ignorer la photo

Effets possibles :

```text
missed_party_detail_j4 = true
```

### D — La conserver

Effets possibles :

```text
party_photo_kept_j4 = true
proof_social_j4 = true
```

## Phrases exemples

```text
Pauline : Photo de famille.
Pauline : Famille au sens très large, hein.
```

```text
Mathilde : Je suis floue, donc légalement je n’étais pas là.
```

```text
Marie : T’es où sur la photo ?
Marie : Ah oui. Derrière ton téléphone.
```

---

# J4_04 — Nico / Premier regard sur Marie

## Fonction

Installer Nico comme miroir, pas comme méchant.

Nico doit révéler l’hypocrisie possible de Player : Player désire ailleurs, mais supporte mal que Marie soit regardée.

## Moment proposé

```text
Milieu de soirée — discussion légère / commentaire sur Marie
```

## Ton de surface

```text
amical
blagueur
un peu piquant
socialement défendable
```

## Sous-texte

```text
Nico occupe une place émotionnelle ou visuelle que Player laisse vide.
```

## Désir perceptible

Le désir ne passe pas par Nico comme récompense visuelle. Il passe par Marie qui est regardée, complimentée, photographiée ou valorisée.

## Point de tension

Player devient jaloux alors qu’il cache lui-même des désirs ailleurs.

## Mensonge possible

Player prétend :

```text
Je ne suis pas jaloux.
```

alors que son comportement dit le contraire.

## Photo / trace possible

- Nico réagit à la story de Marie ;
- Nico est proche d’elle sur la photo de groupe ;
- Pauline capte le regard de Player ;
- Marie rit avec Nico ;
- Player interprète trop ou pas assez.

## Choix joueur recommandés

### A — Laisser passer

Effets possibles :

```text
nico_threat_seed +1
marie_trust +0
```

### B — Répondre avec humour

Effets possibles :

```text
ludo_jealousy +1
nico_interest +1
```

### C — Se montrer jaloux

Effets possibles :

```text
ludo_jealousy +2
marie_suspicion +1
nico_threat_seed +2
```

### D — Revenir vers Marie

Effets possibles :

```text
marie_route_pressure +1
nico_threat_seed -1
```

## Phrases exemples

```text
Nico : Elle te va bien cette robe, Marie.
Nico : Enfin, j’imagine que monsieur l’avait remarqué.
```

```text
Nico : Relax, c’était un compliment.
Nico : Encore autorisé, non ?
```

```text
Nico : T’es jaloux ou juste surpris que quelqu’un la regarde encore ?
```

## Phrase interdite

```text
Je vais te prendre Marie.
```

Trop caricatural.

---

# J4_05 — Mathilde / Elle observe Player

## Fonction

Faire de Mathilde une témoin du trouble de Player.

Elle ne doit pas seulement être l’objet du désir. Elle voit que Player ment à plusieurs endroits, qu’il surveille Marie/Nico, qu’il réagit à Sandra, qu’il essaie de rester normal.

## Moment proposé

```text
Milieu / fin de soirée — message discret ou aparté
```

## Ton de surface

```text
taquin
lucide
effronté
un peu protecteur malgré elle
```

## Sous-texte

```text
Mathilde comprend que Player n’est pas seulement troublé par elle.
```

## Désir perceptible

Mathilde peut provoquer Player parce qu’elle a vu sa réaction, mais elle peut aussi reculer en nommant Marie.

## Point de tension

Mathilde devient complice possible, mais aussi miroir de la culpabilité.

## Mensonge possible

Player dit :

```text
J’ai rien.
```

alors qu’il vient de réagir à Nico, Sandra ou Pauline.

## Photo / trace possible

- selfie Mathilde soirée conditionnel ;
- Mathilde dans la photo de groupe ;
- Mathilde demande si Player a gardé la photo J3 ;
- Mathilde voit une notification sans la lire ;
- une photo peut être envoyée seulement si Player nourrit sa route.

## Choix joueur recommandés

### A — Rire avec elle

Effets possibles :

```text
mathilde_familiarity +1
mathilde_route_pressure +1
```

### B — Flirter plus directement

Effets possibles :

```text
mathilde_desire +2
mathilde_loyalty -1
lie_score +1
```

### C — Nommer Marie / poser une limite

Effets possibles :

```text
mathilde_loyalty +1
marie_trust +1
mathilde_desire -1
```

### D — Mentir sur son trouble

Effets possibles :

```text
lie_score +1
mathilde_suspicion +1
```

## Phrases exemples

```text
Mathilde : T’as une tête de mec qui essaie de regarder trois conversations en même temps.
```

```text
Mathilde : Tu devrais faire attention.
Mathilde : T’as pas une tête de mec qui sait mentir longtemps.
```

```text
Mathilde : Je me moque, mais doucement.
Mathilde : Parce que Marie est là.
```

```text
Mathilde : Ne réponds pas trop bien.
Mathilde : Sinon je vais devoir faire semblant de ne pas aimer.
```

## Phrase interdite

```text
J’ai envie de toi maintenant.
```

Trop frontal et trop tôt.

---

# J4_06 — Sandra / Notification au mauvais moment

## Fonction

Faire sentir que Sandra est absente physiquement, mais présente émotionnellement.

Son message doit arriver au pire moment : quand Player devrait être présent avec Marie, gérer Nico, répondre à Pauline ou rester dans la soirée.

## Moment proposé

```text
Fin de soirée — pendant une scène sociale ou juste avant de rentrer
```

## Ton de surface

```text
doux
hésitant
conscient du mauvais timing
```

## Sous-texte

```text
Sandra veut compter même quand Player est ailleurs.
```

## Désir perceptible

Le désir Sandra est dans l’interruption : elle ne montre rien, mais elle attire Player hors de la pièce.

## Point de tension

Le joueur doit choisir quelle présence il privilégie.

## Notification exemple

```text
Sandra : Mauvais moment ?
Sandra : Désolée. Je ne sais pas pourquoi j’ai pensé à toi maintenant.
```

## Choix joueur recommandés

### A — Ouvrir Sandra tout de suite

Effets possibles :

```text
sandra_attachment +2
sandra_route_pressure +2
marie_suspicion +1
pauline_threat_seed +1
lie_score +1
```

### B — Ignorer Sandra

Effets possibles :

```text
sandra_exposure -1
sandra_attachment -1
marie_trust +1
```

### C — Répondre vite en cachette

Effets possibles :

```text
sandra_attachment +1
lie_score +2
pauline_threat_seed +1
```

### D — Dire à Marie que c’est Sandra

Effets possibles :

```text
marie_trust +1
lie_score -1
sandra_exposure +1
```

### E — Mentir sur la notification

Effets possibles :

```text
lie_score +2
marie_suspicion +1
pauline_threat_seed +1
```

## Trace possible

- `sandra_bad_timing_j4`
- `sandra_message_opened_during_party_j4`
- `sandra_message_ignored_j4`
- `sandra_quick_hidden_reply_j4`
- `lie_about_sandra_notification_j4`

Si Player tarde, Sandra peut supprimer un message :

```text
Sandra a supprimé un message.
```

Puis :

```text
Sandra : Désolée.
Sandra : Mauvais réflexe.
```

## Phrase interdite

```text
Je t’aime.
```

Trop tôt.

---

# J4_07 — Pauline / Elle a vu quelque chose

## Fonction

Faire comprendre que Pauline peut devenir dangereuse parce qu’elle observe et garde les preuves.

Elle ne doit pas encore tout révéler. Elle doit tester la panique de Player.

## Moment proposé

```text
Fin de soirée ou message après-coup immédiat
```

## Ton de surface

```text
piquant
fausse innocence
amusé
contrôle discret
```

## Sous-texte

```text
Pauline a vu une notification, un regard, une gêne ou un mensonge.
```

## Désir perceptible

Chez Pauline, la tension vient du risque : elle rend la preuve excitante parce qu’elle sait la garder.

## Point de tension

Player ne sait pas combien elle a compris.

## Photo / preuve possible

- capture de la soirée ;
- photo où Player regarde son téléphone ;
- notification visible partiellement ;
- Pauline a une image mais ne la montre pas encore ;
- teasing d’une preuve liée à sa propre tromperie.

## Détail Pauline à préparer

Pauline a trompé son copain. J4 peut seulement semer ce fait.

Seeds possibles :

```text
pauline_own_secret_seed_j4
pauline_cheating_proof_exists_seed
pauline_knows_proofs_matter
```

Elle peut dire une phrase qui prend un double sens plus tard :

```text
Pauline : Les gens qui jugent les autres sont souvent ceux qui ont mal rangé leurs propres photos.
```

## Choix joueur recommandés

### A — Nier trop vite

Effets possibles :

```text
pauline_interest +2
pauline_threat_seed +2
lie_score +1
```

### B — Faire de l’humour

Effets possibles :

```text
pauline_interest +1
pauline_threat_seed +1
```

### C — Demander ce qu’elle a vu

Effets possibles :

```text
pauline_control +1
pauline_threat_seed +2
```

### D — Retourner la question

Effets possibles :

```text
pauline_interest +2
pauline_own_secret_seed_j4 +1
```

## Phrases exemples

```text
Pauline : Tu répondais à qui ?
Pauline : Pardon, question impolie.
Pauline : J’adore les questions impolies.
```

```text
Pauline : T’es très expressif quand tu essaies de ne pas l’être.
```

```text
Pauline : Tu devrais faire attention à ce que tu crois discret.
```

```text
Pauline : Tu croyais être le seul à avoir des choses à cacher ?
Pauline : C’est adorable.
```

## Phrase interdite

```text
Je vais montrer ça à Marie.
```

Trop tôt.

---

# J4_08 — Convergence / Vertige des possibilités

## Fonction

Créer un moment où plusieurs routes semblent s’ouvrir presque en même temps.

Ce moment ne doit pas tout débloquer définitivement. Il doit donner une sensation de vertige et préparer J5.

## Moment proposé

```text
Fin de soirée — retour maison, toilettes, couloir, voiture, lit, ou juste après la soirée
```

## Structure possible

```text
22:48 — Marie : Tu viens ?
22:49 — Sandra : Je sais que ce n’est pas le moment.
22:49 — Mathilde : J’ai vu ta tête quand Pauline a parlé de photos.
22:50 — Pauline vous a envoyé une image.
22:51 — Nico a réagi à la story de Marie.
```

Raphaëlle peut apparaître le lendemain en J5, pas forcément dans le pic lui-même.

## Choix joueur possibles

```text
ouvrir Marie
ouvrir Sandra
ouvrir Mathilde
ouvrir Pauline
regarder la story / réaction Nico
ignorer tout
```

## Effet recherché

Le joueur doit sentir :

```text
Je peux réparer avec Marie.
Je peux continuer avec Sandra.
Je peux basculer avec Mathilde.
Je peux entrer dans le jeu de Pauline.
Je peux jalouser Nico.
Je peux chercher la clarté de Raphaëlle demain.
Mais je ne peux pas tout faire sans coût.
```

## Règles d’effets

Ouvrir Marie :

```text
marie_trust +1
marie_route_pressure +1
sandra_attachment -1 si Sandra ignorée
mathilde_route_pressure -1 si Mathilde ignorée
```

Ouvrir Sandra :

```text
sandra_attachment +2
lie_score +1
marie_suspicion +1
pauline_threat_seed +1
```

Ouvrir Mathilde :

```text
mathilde_route_pressure +2
mathilde_desire +1
lie_score +1
marie_suspicion +1
```

Ouvrir Pauline :

```text
pauline_interest +2
pauline_threat_seed +2
proof_social_j4 = true
```

Regarder Nico / story :

```text
ludo_jealousy +2
nico_threat_seed +2
marie_route_pressure +0 ou +1 selon réaction
```

Ignorer tout :

```text
marie_trust +1 si Player revient réellement
missed_convergence_j4 = true
```

## Garde-fou

Le moment de convergence doit rester lisible.

Ne pas afficher trop de choix si l’interface ne le supporte pas encore. Il peut être simulé par une séquence de notifications et un choix prioritaire unique.

---

# Contenus visuels J4

## Obligatoire

```text
photo_party_group_j4
```

Fonction : première trace sociale.

## Conditionnels

```text
photo_marie_evening_j4
photo_mathilde_party_j4
photo_pauline_soft_provocation_j4
story_marie_nico_reaction_j4
```

## Traces / preuves

```text
sandra_bad_timing_j4
pauline_saw_notification_j4
pauline_possible_capture_j4
pauline_own_secret_seed_j4
nico_reacted_to_marie_story_j4
```

---

# Flags J4 recommandés

```text
party_invite_j4
party_started_j4
photo_party_group_j4_received
photo_party_group_j4_kept
photo_marie_evening_j4_available
photo_marie_evening_j4_received
nico_complimented_marie_j4
ludo_jealous_of_nico_j4
mathilde_noticed_player_j4
sandra_bad_timing_j4
sandra_message_opened_during_party_j4
sandra_message_ignored_j4
sandra_quick_hidden_reply_j4
lie_about_sandra_notification_j4
pauline_saw_notification_j4
pauline_possible_capture_j4
pauline_own_secret_seed_j4
pauline_cheating_proof_exists_seed
convergence_notifications_j4
missed_convergence_j4
```

# Variables J4 recommandées

```text
marie_trust
marie_suspicion
lie_score
ludo_jealousy
mathilde_desire
mathilde_loyalty
sandra_attachment
sandra_exposure
pauline_interest
pauline_control
raphaelle_clarity
nico_place_near_marie
```

Pressions de route :

```text
marie_route_pressure
mathilde_route_pressure
sandra_route_pressure
pauline_route_pressure
nico_threat_seed
raphaelle_route_pressure
```

Raphaëlle peut ne pas monter activement en J4, mais son futur rôle de clarté doit être préparé par le chaos que Player crée.

---

# Lecture des routes après J4

## Marie renforcée

Signes :

- Player valorise Marie avant la soirée ;
- Player choisit Marie dans la convergence ;
- Player ne cache pas Sandra ;
- Player ne se perd pas dans la jalousie Nico.

Conséquence :

```text
Réparation ou reconquête possible.
```

## Mathilde renforcée

Signes :

- Player garde le lien après la photo J3 ;
- Player répond à Mathilde pendant la soirée ;
- Mathilde remarque qu’il ment ou qu’il la regarde ;
- Player nourrit l’ambiguïté malgré Marie.

Conséquence :

```text
Interdit domestique plus actif.
Risque Marie augmente.
```

## Sandra renforcée

Signes :

- Player ouvre Sandra au mauvais moment ;
- Player répond en cachette ;
- Player lui donne une place prioritaire pendant la soirée.

Conséquence :

```text
Infidélité émotionnelle plus lisible.
Exposition augmente.
```

## Pauline renforcée

Signes :

- Pauline voit une notification ;
- Pauline envoie une photo ;
- Player panique ou nie ;
- Player retourne la question et touche au secret de Pauline.

Conséquence :

```text
Pauline devient menace de preuve.
Sa propre tromperie peut devenir levier J5+.
```

## Nico renforcé

Signes :

- Nico complimente Marie ;
- Marie réagit naturellement ;
- Player devient jaloux ;
- une story ou photo fixe ce regard.

Conséquence :

```text
Menace Nico / NTR seed.
Player voit sa propre hypocrisie.
```

## Raphaëlle préparée

Signes :

- Player crée du chaos ;
- Player ment à plusieurs endroits ;
- J5 pourra faire revenir Raphaëlle comme clarté.

Conséquence :

```text
Raphaëlle pourra poser une limite après coup.
```

---

# Garde-fous J4

## Ne pas faire

```text
Ne pas faire exploser Marie en confrontation totale.
Ne pas faire de Pauline une manipulatrice omnisciente trop tôt.
Ne pas rendre Nico brutal ou méchant.
Ne pas faire de Sandra une déclaration d’amour.
Ne pas transformer Mathilde en séductrice frontale.
Ne pas ouvrir un groupe lourd si l’interface ou le rythme ne le justifie pas.
Ne pas donner toutes les photos conditionnelles dans la même partie.
```

## À faire

```text
Faire sentir que Marie est désirable.
Faire sentir que Nico regarde Marie.
Faire sentir que Player est hypocritement jaloux.
Faire de Pauline une observatrice dangereuse.
Faire de Sandra une interruption émotionnelle.
Faire de Mathilde un témoin du trouble.
Créer une photo sociale réutilisable.
Préparer une preuve faible pour J5.
Créer un moment de convergence lisible.
```

## Résumé J4

```text
J4 commence par une invitation apparemment légère de Pauline.
Marie se prépare et redevient visible comme femme désirée.
La soirée produit une première photo sociale.
Nico regarde Marie et active la jalousie de Player.
Mathilde remarque que Player n’est pas clair.
Sandra écrit au mauvais moment.
Pauline voit ou capture quelque chose.
La fin de soirée ouvre plusieurs routes presque en même temps.
```

## Fonction finale

J4 doit faire comprendre :

```text
Le téléphone n’est plus seulement un refuge privé.
Il devient dangereux parce que les autres peuvent le voir, le deviner ou le photographier.
```
