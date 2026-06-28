# J5 — Fondation d’écriture : lendemain, redistribution des photos et premières preuves

## Statut

Document de cadrage pour écriture et intégration data-first du Jour 5.

Ce document prolonge :

- `docs/J3_WRITING_FOUNDATION.md`
- `docs/J4_WRITING_FOUNDATION.md`
- `docs/J3_J5_Desire_Tension_Visual_Routes_Spec.md`
- `docs/decisions/DECISION_007_J3_J5_DESIRE_TENSION_VISUAL_ROUTES.md`

## Fonction narrative de J5

J5 est le lendemain de la soirée.

J4 a produit des regards, rapprochements, notifications, photos, stories et captures possibles. J5 doit montrer que la soirée ne disparaît pas quand elle est terminée : les images circulent, les détails ressortent, certains souvenirs deviennent désirables, d’autres deviennent risqués.

Question centrale :

```text
Qu’est-ce qu’une photo change quand elle revient le lendemain, hors de son contexte festif ?
```

J5 ne doit pas encore tout révéler. Il doit créer la première sensation que des preuves existent ailleurs que dans le téléphone de Player.

## Rôle dans la progression

```text
J1 — Couple + Sandra réactivée
J2 — Réseau ouvert + Mathilde dans la maison + Player absent
J3 — Retour maison + premier désir domestique visible + premiers secrets conscients
J4 — Soirée sociale + regards croisés + convergence des notifications
J5 — Lendemain + redistribution des photos + première preuve faible
```

## Principe fort J5

J4 produit la matière visuelle.

J5 la redistribue.

Le joueur doit sentir :

```text
Je n’ai pas vu toutes les photos.
Tout le monde n’a pas reçu les mêmes.
Certaines images peuvent me rapprocher de quelqu’un.
Certaines images peuvent me faire tomber.
```

## Soirée arrosée — règle de traitement

La soirée J4 peut avoir été arrosée, avec une ambiance plus libre : rires, proximité, fatigue, flou social, poses plus assumées, photos envoyées trop vite, messages regrettés.

Garde-fou : l’alcool ne doit pas servir à justifier une perte d’agence ou une scène intime non consentie. Il sert à rendre les personnages plus spontanés, plus imprudents, plus photographiés, pas à effacer leurs limites.

## Conversations actives J5

Fils visibles recommandés :

```text
Marie
Pauline
Mathilde
Sandra
Raphaëlle
```

Traces possibles :

```text
Nico — via story, réaction, photo de soirée ou discussion autour de Marie
```

J5 peut être plus dense que J3, mais doit rester lisible. Le joueur doit comprendre que le téléphone trie le lendemain d’une soirée : messages, photos reçues, stories, réactions, regrets.

## Structure globale J5

```text
1. Marie — Matin / elle revient sur la soirée
2. Pauline — Envoi des photos de soirée / première preuve faible
3. Nico / Marie — Story, réaction ou image qui active la jalousie
4. Mathilde — Follow-up photo J3/J4, provocation ou recul
5. Sandra — Réaction au délai ou à la soirée
6. Raphaëlle — Limite claire après le chaos
7. Pauline — Seed de sa propre preuve / tromperie
8. Fin J5 — Le joueur comprend que d’autres images existent encore
```

## Cadence émotionnelle

```text
Début : malaise doux, relecture de la soirée.
Montée : Pauline envoie les images.
Désir : certaines photos sont sexy ou flatteuses.
Risque : un détail peut devenir preuve.
Jalousie : Marie apparaît désirée / regardée par Nico.
Trouble : Mathilde demande si une photo a été gardée.
Frustration : Sandra retient ou supprime une image.
Clarté : Raphaëlle refuse le flou.
Ouverture : Pauline laisse entendre qu’elle aussi cache des preuves.
```

## Formule d’écriture J5

Chaque scène J5 doit contenir au moins un de ces effets :

```text
une photo retrouvée
une image envoyée après coup
une story ou réaction qui change le sens de la soirée
un message regretté
une preuve faible
une question sur ce qui a été gardé ou supprimé
une personne qui sait peut-être plus qu’elle ne dit
```

---

# I. Cadence photo J5

## Pack visuel recommandé

J5 doit proposer :

```text
1 photo sociale ambiguë obligatoire
1 photo sexy conditionnelle
1 preuve faible conditionnelle
1 trace supprimée / regrettée
1 sentiment que d’autres images existent encore hors champ
```

Toutes les photos ne doivent pas tomber dans la même partie. Certaines dépendent des choix J3/J4.

## Photo obligatoire — Pauline envoie les photos de soirée

ID proposé :

```text
photo_party_after_j5
```

Type : photo ou mini-lot photo.

Palier : 1 — Ambigu.

Fonction : première preuve faible.

Placeholder :

```text
Photo envoyée : image de soirée prise par Pauline. L’ambiance paraît légère : verres, rires, canapé, lumière chaude. Mais un détail attire l’œil selon la route : Player regarde son téléphone, Nico est trop près de Marie, Mathilde regarde Player, Marie remarque l’absence de Player, ou Pauline cadre volontairement une gêne.
```

Règle : la photo doit d’abord sembler amusante, puis devenir inquiétante quand on la regarde mieux.

## Lot photo possible

Pauline peut envoyer un petit lot :

```text
photo_party_group_j5 — photo normale de groupe
photo_party_blur_j5 — photo floue mais plus suggestive
photo_party_player_phone_j5 — Player pris en train de regarder son téléphone
photo_party_marie_nico_j5 — Marie et Nico dans un cadrage ambigu
photo_party_mathilde_look_j5 — Mathilde qui regarde Player ou réagit à lui
```

Le lot peut être réduit si le prototype ne supporte pas encore plusieurs images : une seule image peut contenir plusieurs détails.

## Photo sexy conditionnelle — Mathilde, Marie ou Pauline

J5 doit pouvoir donner une photo plus désirable si une route a été nourrie.

### Option Mathilde

ID proposé :

```text
photo_mathilde_after_party_j5
```

Déblocage : Player a gardé la photo canapé J3, flirté avec Mathilde, ou ouvert Mathilde pendant la convergence J4.

Placeholder :

```text
Photo envoyée : Mathilde après la soirée, encore en tenue de la veille ou décoiffée, cadrage plus assumé mais toujours défendable. L’image donne l’impression qu’elle hésite entre provocation et regret.
```

Message possible :

```text
Mathilde : J’ai retrouvé ça.
Mathilde : Je devrais sans doute pas te l’envoyer.
```

Risque : elle peut demander ensuite si Player l’a supprimée.

### Option Marie

ID proposé :

```text
photo_marie_after_party_j5
```

Déblocage : Player a valorisé Marie J4 ou choisi Marie dans la convergence.

Placeholder :

```text
Photo envoyée : Marie le lendemain, lumière du matin, encore marquée par la soirée mais belle, plus douce que provocante. Elle ne cherche pas à piéger Player ; elle veut sentir qu’il la regarde encore.
```

Fonction : route Marie désir / reconquête.

### Option Pauline

ID proposé :

```text
photo_pauline_soft_provocation_j5
```

Déblocage : Player a répondu aux provocations de Pauline ou demandé ce qu’elle avait vu.

Placeholder :

```text
Photo envoyée : Pauline dans une pose de soirée flatteuse, cadrage volontairement maîtrisé, sourire qui laisse penser qu’elle sait exactement l’effet produit. L’image reste non explicite, mais elle est adressée comme un test.
```

Fonction : provocation, preuve potentielle, route Pauline.

## Trace Sandra — photo non envoyée / supprimée

ID proposé :

```text
sandra_almost_sent_photo_j5
```

Sandra ne doit pas forcément envoyer une vraie photo en J5.

Elle peut :

- mentionner une photo ;
- supprimer une image ;
- dire qu’elle a failli envoyer quelque chose ;
- envoyer un message qui donne plus envie que la photo elle-même.

Exemples :

```text
Sandra : J’avais une photo à t’envoyer.
Sandra : Mauvaise idée.
```

```text
Sandra a supprimé une image.
```

Fonction : rareté, frustration, tension émotionnelle.

## Seed Pauline — preuve de sa propre tromperie

ID proposé :

```text
pauline_cheating_proof_seed_j5
```

J5 peut commencer à montrer que Pauline a aussi des choses à cacher.

Formes possibles :

- photo ambiguë de Pauline avec quelqu’un d’autre ;
- capture de message ;
- allusion de Nico ;
- image que Pauline retire ;
- phrase où Pauline laisse entendre qu’elle sait où sont les preuves ;
- mention de son copain au mauvais moment.

Garde-fou : ne pas révéler trop fort trop tôt. J5 doit semer le levier, pas encore l’exploser.

---

# J5_01 — Marie / Matin après soirée

## Fonction

Faire revenir Marie sur la soirée sans confrontation totale.

Elle a senti que Player était ailleurs. Elle a peut-être vu Nico, Pauline, Mathilde, le téléphone, ou simplement l’absence de Player dans certains moments.

## Moment proposé

```text
Matin — maison / réveil / café
```

## Ton de surface

```text
fatigué
doux
lucide
un peu piqué
```

## Sous-texte

```text
Marie se demande si Player était avec elle ou avec son téléphone.
```

## Désir perceptible

Marie peut être dans une douceur post-soirée : fatiguée, décoiffée, plus intime. Le désir ne doit pas disparaître au profit du soupçon.

## Point de tension

Player peut être tenté de minimiser la soirée, alors que des photos vont bientôt revenir.

## Mensonge possible

```text
J’étais juste fatigué.
```

## Omission possible

Player ne dit pas :

- qu’il a ouvert Sandra ;
- qu’il a regardé Nico ;
- qu’il a répondu à Mathilde ;
- que Pauline a vu quelque chose ;
- qu’il attend presque les photos.

## Choix joueur recommandés

### A — Reconnaître qu’il était ailleurs

Effets possibles :

```text
marie_trust +1
lie_score -1
truth_seed_marie_j5 = true
```

### B — Minimiser

Effets possibles :

```text
lie_score +1
marie_suspicion +1
```

### C — Revenir vers elle

Effets possibles :

```text
marie_route_pressure +2
photo_marie_after_party_j5_available = true
```

### D — Être jaloux de Nico

Effets possibles :

```text
ludo_jealousy +2
nico_threat_seed +1
marie_suspicion +1
```

## Phrases exemples

```text
Marie : Hier, j’ai eu l’impression que tu attendais quelqu’un qui n’était pas dans la pièce.
```

```text
Marie : Tu étais là.
Marie : Mais pas toujours avec moi.
```

```text
Marie : Je ne sais pas si c’est la soirée ou toi qui m’a fatiguée.
```

```text
Marie : C’est bête, mais j’avais envie que tu me regardes un peu plus.
```

## Photo possible

`photo_marie_after_party_j5` si Player revient vers Marie.

---

# J5_02 — Pauline / Les photos de soirée

## Fonction

Faire de Pauline la redistributrice des images.

Elle n’est pas seulement celle qui a vu. Elle possède, trie, choisit, envoie, retient.

## Moment proposé

```text
Milieu de matinée — Pauline envoie une ou plusieurs photos
```

## Ton de surface

```text
piquant
joueur
fausse innocence
contrôle discret
```

## Sous-texte

```text
Pauline teste ce que Player reconnaît dans les images.
```

## Désir perceptible

Les photos de Pauline doivent être attirantes à ouvrir : ambiance, proximité, personnes jolies, soirée un peu floue, cadrages flatteurs. Le désir vient du fait qu’elles sont à la fois agréables et dangereuses.

## Photo obligatoire

`photo_party_after_j5`

Message possible :

```text
Pauline : J’ai fait le tri.
Pauline : Enfin, une partie du tri.
```

Puis :

```text
Pauline : Y’en a que je garde pour plus tard.
```

## Choix joueur recommandés

### A — Regarder vite

Effets possibles :

```text
party_after_photo_seen_j5 = true
pauline_interest +1
```

### B — Zoomer / chercher les détails

Effets possibles :

```text
proof_awareness_j5 +1
pauline_interest +1
ludo_jealousy +1 si détail Nico/Marie
```

### C — Demander si elle a d’autres photos

Effets possibles :

```text
pauline_interest +2
pauline_control +1
pauline_threat_seed +2
```

### D — Faire semblant de ne pas être intéressé

Effets possibles :

```text
lie_score +1
pauline_interest +1
```

## Phrases exemples

```text
Pauline : Très photogénique hier.
Pauline : Pas forcément sur les photos.
```

```text
Pauline : J’ai fait le tri.
Pauline : J’ai gardé les gentilles.
Pauline : Pour l’instant.
```

```text
Pauline : C’est fou ce qu’on apprend sur les gens en zoomant.
```

## Trace / preuve

- `photo_party_after_j5_received`
- `party_photo_detail_seen_j5`
- `pauline_kept_more_photos_j5`
- `proof_social_j5 = true`

---

# J5_03 — Nico / Marie visible autrement

## Fonction

Faire revenir Nico via l’image, pas forcément via une conversation directe.

J5 doit montrer que Marie peut être regardée et désirée ailleurs. Cela nourrit la jalousie, la route Marie, et la menace Nico.

## Moment proposé

```text
Après réception des photos Pauline ou story réseau social
```

## Ton de surface

```text
social
anodin
piquant seulement si Player réagit
```

## Sous-texte

```text
Player découvre ce qu’il n’a pas voulu voir hier : Marie était visible pour d’autres.
```

## Photo / story possible

`story_marie_nico_j5`

Placeholder :

```text
Story ou photo : Marie sourit pendant la soirée. Nico est proche d’elle ou réagit à la story. Rien n’est explicitement déplacé, mais le cadrage donne à Player l’impression qu’il n’était pas le seul à la regarder.
```

## Choix joueur recommandés

### A — Laisser passer

Effets possibles :

```text
nico_threat_seed +1
marie_trust +0
```

### B — Réagir jaloux

Effets possibles :

```text
ludo_jealousy +2
marie_suspicion +1
nico_threat_seed +2
```

### C — Revenir vers Marie au lieu d’accuser Nico

Effets possibles :

```text
marie_route_pressure +1
ludo_jealousy -1
```

### D — Fouiller les photos

Effets possibles :

```text
proof_awareness_j5 +1
nico_threat_seed +1
lie_score +1
```

## Phrases exemples

```text
Nico a réagi à la story de Marie.
```

```text
Pauline : Ah celle-là elle est belle.
Pauline : Marie, pas Nico.
Pauline : Quoique.
```

```text
Marie : Tu bloques sur quoi ?
```

---

# J5_04 — Mathilde / Follow-up photo ou recul

## Fonction

Faire revenir la photo J3/J4 comme secret actif.

Mathilde doit demander ou sentir si Player a gardé une image. Elle peut envoyer une nouvelle photo plus assumée si sa route est nourrie, ou reculer si elle sent que la limite avec Marie devient réelle.

## Moment proposé

```text
Après-midi — message Mathilde
```

## Ton de surface

```text
taquin
plus prudent que J4
provocant si route haute
coupable si route basse ou limite posée
```

## Sous-texte

```text
Mathilde veut savoir si Player garde des traces d’elle.
```

## Désir perceptible

La tension vient de la question : la photo existe-t-elle encore ? Player l’a-t-il gardée ? L’a-t-il regardée ?

## Branches de ton

### Route basse / limite

Mathilde recule :

```text
Mathilde : Tu l’as supprimée, au moins ?
Mathilde : Dis oui, même si c’est faux.
```

### Route moyenne

Mathilde plaisante :

```text
Mathilde : J’espère que tu n’as pas montré mon combat contre votre canapé.
```

### Route haute

Mathilde envoie une photo conditionnelle :

```text
Mathilde : J’ai retrouvé ça.
Mathilde : Je devrais sans doute pas te l’envoyer.
```

Puis `photo_mathilde_after_party_j5`.

## Choix joueur recommandés

### A — Dire qu’il a supprimé

Effets possibles :

```text
mathilde_loyalty +1
lie_score +1 si faux
mathilde_desire -1
```

### B — Avouer qu’il l’a gardée

Effets possibles :

```text
mathilde_desire +2
mathilde_loyalty -1
lie_score +1
```

### C — La rassurer / poser une limite

Effets possibles :

```text
mathilde_loyalty +1
marie_trust +1
mathilde_route_pressure -1
```

### D — Demander une autre photo

Effets possibles :

```text
mathilde_desire +2
mathilde_loyalty -2
lie_score +2
photo_mathilde_after_party_j5_available = true
```

## Phrase interdite

```text
Envoie-moi quelque chose de plus chaud.
```

Trop frontal pour la tonalité actuelle. Préférer une formulation ambiguë ou une relance qui laisse Mathilde hésiter.

---

# J5_05 — Sandra / Réaction au délai ou au mauvais moment

## Fonction

Faire sentir que Sandra comprend qu’elle écrit dans une vie où elle n’a pas de place officielle.

Elle peut être blessée par un délai, par une réponse cachée, ou par le fait que Player était en soirée.

## Moment proposé

```text
Fin d’après-midi ou soir
```

## Ton de surface

```text
doux
retenu
un peu blessé
fuyant
```

## Sous-texte

```text
Sandra veut compter, mais elle ne veut pas être une notification honteuse.
```

## Désir perceptible

Sandra donne envie par l’absence, le manque, la photo retenue ou supprimée.

## Trace possible

`sandra_almost_sent_photo_j5`

Exemple :

```text
Sandra : J’avais une photo à t’envoyer.
Sandra : Mauvaise idée.
```

ou :

```text
Sandra a supprimé une image.
```

## Choix joueur recommandés

### A — La rassurer sans forcer

Effets possibles :

```text
sandra_attachment +1
sandra_exposure -1
```

### B — Lui dire qu’elle compte

Effets possibles :

```text
sandra_attachment +2
sandra_route_pressure +2
lie_score +1
```

### C — Mentir sur la soirée

Effets possibles :

```text
lie_score +2
sandra_exposure +1
```

### D — La pousser à envoyer la photo

Effets possibles :

```text
sandra_attachment +1
sandra_exposure +2
sandra_withdrawal_risk +1
```

## Phrases exemples

```text
Sandra : Tu n’étais pas seul hier, hein ?
Sandra : Je ne dis pas ça pour te demander des comptes.
Sandra : C’est presque pire.
```

```text
Sandra : Je crois que je n’aime pas devenir un message que tu caches dans une soirée.
```

```text
Sandra : J’avais une photo à t’envoyer.
Sandra : Et puis je me suis demandé ce que j’aurais voulu que tu en fasses.
```

---

# J5_06 — Raphaëlle / Limite claire

## Fonction

Faire apparaître Raphaëlle comme contrepoint au chaos J4/J5.

Elle n’était pas forcément dans la soirée. Elle arrive comme quelqu’un qui voit la fatigue, le flou, ou le besoin de Player de parler sans assumer.

## Moment proposé

```text
Soir ou fin de journée — message calme
```

## Ton de surface

```text
sobre
calme
adulte
ferme
```

## Sous-texte

```text
Raphaëlle accepte d’écouter, mais refuse d’être une cachette.
```

## Désir perceptible

Le désir Raphaëlle est conditionné à la vérité. Elle peut devenir attirante parce qu’elle refuse d’entrer dans le chaos.

## Choix joueur recommandés

### A — Reconnaître le flou

Effets possibles :

```text
raphaelle_clarity +2
lie_score -1
```

### B — Chercher un refuge

Effets possibles :

```text
raphaelle_attachment +1
raphaelle_boundary_seed +2
lie_score +1
```

### C — Mentir encore

Effets possibles :

```text
raphaelle_clarity -1
lie_score +1
```

### D — Dire qu’il doit parler à Marie

Effets possibles :

```text
marie_route_pressure +1
raphaelle_clarity +1
truth_seed_marie +1
```

## Phrases exemples

```text
Raphaëlle : Je peux t’écouter.
Raphaëlle : Mais pas si tu viens chercher ici le courage que tu refuses d’avoir chez toi.
```

```text
Raphaëlle : Tu as le droit d’être perdu.
Raphaëlle : Pas de faire comme si personne ne suivait tes traces.
```

```text
Raphaëlle : J’aurais pu avoir envie de toi.
Raphaëlle : Mais pas cachée dans une histoire que tu refuses de regarder.
```

---

# J5_07 — Pauline / Son propre secret

## Fonction

Semer ou renforcer l’idée que Pauline a elle aussi des preuves contre elle.

Pauline a trompé son copain. J5 peut commencer à faire exister ce fait par image, allusion ou contradiction.

## Moment proposé

```text
Après les photos de soirée ou en fin de journée
```

## Ton de surface

```text
provocant
maîtrisé
faux aveu
contrôle
```

## Sous-texte

```text
Pauline menace les secrets de Player tout en révélant qu’elle sait très bien comment survivre aux siens.
```

## Preuve possible

`pauline_cheating_proof_seed_j5`

Formes :

- photo ambiguë de Pauline avec quelqu’un d’autre ;
- capture qu’elle ne montre qu’un instant ;
- message aperçu ;
- allusion de Nico ;
- image retirée ;
- son copain mentionné pendant qu’une photo contredit l’image publique du couple.

## Choix joueur recommandés

### A — Ne pas relever

Effets possibles :

```text
pauline_control +1
pauline_threat_seed +1
```

### B — Lui faire comprendre qu’il a vu

Effets possibles :

```text
pauline_interest +2
pauline_control -1
pauline_route_pressure +1
```

### C — La juger

Effets possibles :

```text
pauline_control +2
pauline_retaliation_seed +1
```

### D — Devenir complice

Effets possibles :

```text
pauline_interest +2
lie_score +1
pauline_route_pressure +2
```

## Phrases exemples

```text
Pauline : Tu croyais être le seul à avoir des choses à cacher ?
Pauline : C’est mignon.
```

```text
Pauline : La différence entre toi et moi, c’est que moi je sais où sont les preuves.
```

```text
Pauline : Ne me regarde pas comme ça.
Pauline : Tu n’as pas encore assez de morale pour me juger.
```

## Garde-fou

Ne pas révéler toute la tromperie de Pauline en J5. Il faut surtout créer un levier pour J6+.

---

# Fin J5 — Sensation d’images hors champ

## Fonction

Terminer J5 avec l’idée que les photos visibles ne sont qu’une partie de ce qui existe.

Le joueur doit comprendre que d’autres images peuvent ressortir plus tard.

## Clôture possible

```text
Pauline : Je t’ai envoyé les gentilles.
```

ou :

```text
Mathilde : Certaines photos devraient disparaître toutes seules.
```

ou :

```text
Marie : Je ne sais pas ce que je regarde sur cette photo.
Marie : Toi non plus, j’ai l’impression.
```

## Effets de fin possibles

```text
proof_awareness_j5 = true
photos_exist_offscreen_j5 = true
pauline_kept_more_photos_j5 = true
route_pressure_readable_after_j5 = true
```

---

# Flags J5 recommandés

```text
photo_party_after_j5_received
party_after_photo_seen_j5
party_photo_detail_seen_j5
pauline_kept_more_photos_j5
proof_social_j5
story_marie_nico_j5_seen
nico_reacted_to_marie_story_j5
ludo_jealousy_triggered_j5
photo_mathilde_after_party_j5_available
photo_mathilde_after_party_j5_received
mathilde_asked_if_photo_kept_j5
mathilde_photo_kept_admitted_j5
mathilde_photo_deleted_claim_j5
sandra_almost_sent_photo_j5
sandra_deleted_image_j5
raphaelle_boundary_j5
pauline_cheating_proof_seed_j5
pauline_own_secret_seen_j5
photos_exist_offscreen_j5
```

# Variables J5 recommandées

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
pauline_route_pressure
raphaelle_clarity
nico_place_near_marie
```

# Lecture des routes après J5

## Marie dominante

Signes :

- Player revient vers Marie après la soirée ;
- il valorise une photo de Marie ;
- il ne transforme pas Nico en prétexte agressif ;
- il reconnaît au moins une part de son absence.

Conséquence : réparation / reconquête possible.

## Mathilde dominante

Signes :

- Player admet avoir gardé la photo ;
- demande ou reçoit une nouvelle photo ;
- nourrit l’ambiguïté malgré Marie ;
- Mathilde oscille entre provocation et culpabilité.

Conséquence : secret domestique plus actif.

## Sandra dominante

Signes :

- Player répond à Sandra malgré la soirée ;
- la rassure sur sa place ;
- pousse la photo ou la confidence ;
- laisse Sandra croire qu’elle est unique.

Conséquence : infidélité émotionnelle plus forte, risque de retrait si exposition.

## Pauline dominante / menace

Signes :

- Player demande d’autres photos ;
- Pauline comprend qu’il panique ;
- Player touche au secret de Pauline ;
- une preuve de sa tromperie existe.

Conséquence : Pauline devient levier de preuve et provocation.

## Nico menace

Signes :

- Player zoom sur Marie/Nico ;
- jalousie visible ;
- Nico apparaît comme celui qui regarde Marie quand Player regardait ailleurs.

Conséquence : NTR seed / jalousie miroir.

## Raphaëlle contrepoint

Signes :

- Player cherche un refuge après la soirée ;
- Raphaëlle pose une limite ;
- Player commence à envisager la vérité.

Conséquence : route de clarté possible, incompatible avec mensonge prolongé.

---

# Garde-fous J5

## Ne pas faire

```text
Ne pas révéler toutes les preuves d’un coup.
Ne pas donner toutes les photos conditionnelles en une seule partie.
Ne pas utiliser la soirée arrosée pour justifier une absence d’agence.
Ne pas faire de Pauline une maîtresse du jeu omnisciente.
Ne pas rendre Sandra trop disponible.
Ne pas faire de Marie seulement une victime jalouse.
Ne pas transformer Nico en méchant.
Ne pas rendre Mathilde explicitement disponible sans culpabilité.
```

## À faire

```text
Assumer que les photos sont importantes.
Faire monter le niveau d’intimité visuelle.
Faire sentir que certaines photos sont sexy et désirables.
Faire sentir que ces mêmes photos peuvent devenir des preuves.
Redistribuer les images de J4 sous plusieurs angles.
Donner à Pauline un rôle de tri, capture et conservation.
Faire exister des images hors champ.
Préparer la suite par l’envie de voir ce qui n’a pas encore été montré.
```

## Résumé J5

```text
J5 est le lendemain de la soirée.
Marie sent que Player n’était pas complètement avec elle.
Pauline envoie des photos et laisse entendre qu’elle en garde d’autres.
Une image de Marie/Nico active la jalousie miroir.
Mathilde demande si Player a gardé une photo ou envoie une image plus risquée selon route.
Sandra réagit au mauvais timing et retient ou supprime une image.
Raphaëlle pose une limite claire.
Pauline laisse apparaître que sa propre tromperie peut aussi avoir des preuves.
La journée se termine sur l’idée que d’autres photos existent encore.
```

## Fonction finale

J5 doit faire comprendre :

```text
La soirée n’est pas finie tant que toutes les photos n’ont pas circulé.
```
