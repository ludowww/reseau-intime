# J3 — Fondation d’écriture : retour maison et premiers secrets

## Statut

Document de cadrage pour écriture et intégration data-first du Jour 3.

Ce document applique la direction validée dans :

- `docs/J3_J5_Desire_Tension_Visual_Routes_Spec.md`
- `docs/decisions/DECISION_007_J3_J5_DESIRE_TENSION_VISUAL_ROUTES.md`

## Fonction narrative de J3

J3 est le jour du retour physique.

Après J2, Player revient dans l’espace de Marie avec un téléphone déjà chargé de traces : Sandra, Mathilde, Raphaëlle, photos, promesses, messages courts, ambiguïtés.

Question centrale :

```text
Est-ce que Player revient vraiment auprès de Marie, ou seulement dans la maison ?
```

J3 ne doit pas encore faire exploser les routes.

Il doit faire sentir que Player commence à cacher non pas seulement des messages, mais ce que ces messages lui font.

## Rôle dans la progression

```text
J1 — Couple + Sandra réactivée
J2 — Réseau ouvert + Mathilde dans la maison + Player absent
J3 — Retour maison + premier désir domestique visible + premiers secrets conscients
J4 — Soirée sociale / regards croisés
J5 — Première preuve faible
```

## Conversations actives J3

Fils visibles recommandés :

```text
Marie
Mathilde
Raphaëlle
Sandra
```

Pauline et Nico ne doivent pas encore devenir des conversations lourdes en J3.

Ils peuvent être préparés indirectement seulement :

- mention d’une future soirée ;
- nom évoqué par Marie ou Mathilde ;
- aucune ligne Messages active longue obligatoire ;
- aucune activation rétroactive J1/J2.

## Structure globale J3

```text
1. Marie — Matin / retour physique
2. Mathilde — Réveil canapé / conséquence de la nuit
3. Raphaëlle — Midi / clarté calme
4. Sandra — Après-midi ou soir / jeudi maintenu
5. Marie — Fin de journée / légère inquiétude
```

## Cadence émotionnelle

```text
Début : maison, fatigue, tendresse.
Milieu : Mathilde rend la trace concrète et désirable.
Contrepoint : Raphaëlle voit que Player esquive.
Soir : Sandra devient émotionnellement dangereuse.
Fin : Marie sent que quelque chose se déplace.
```

## Formule d’écriture J3

Chaque scène J3 doit contenir :

```text
un désir perceptible
un mensonge ou une omission possible
une trace potentielle
un risque différé
```

---

# J3_01 — Marie / Matin retour maison

## Fonction

Réinstaller Marie comme ancrage et comme désir.

Player est physiquement là, mais pas complètement disponible. Marie ne sait pas ce qui s’est passé dans son téléphone, mais elle perçoit un décalage.

## Moment proposé

```text
08:12 — cuisine / salon / maison
```

Marie écrit ou répond alors qu’ils sont proches physiquement. Ce paradoxe est volontaire : le smartphone reste l’espace où les personnages peuvent dire, éviter ou tester des choses qu’ils ne formulent pas frontalement.

## Ton de surface

```text
domestique
tendre
concret
familier
```

## Sous-texte

```text
Marie teste si Player est vraiment revenu.
```

Elle ne pense pas encore forcément qu’il la trompe. Elle sent plutôt qu’il est ailleurs par fragments.

## Désir perceptible

Marie doit pouvoir être regardée comme une femme, pas seulement comme la compagne stable.

La scène peut contenir :

- un détail de tenue ;
- une proximité de cuisine ou de café ;
- une photo tendre optionnelle plus tard ;
- une phrase qui rappelle qu’elle veut encore être désirée.

## Point de tension

Player a déjà des traces dans son téléphone, mais Marie parle comme si le couple était encore simple.

## Mensonge possible

Player dit :

```text
Je suis juste fatigué.
```

alors qu’il est surtout troublé par Sandra, Mathilde ou sa culpabilité.

## Omission possible

Il ne mentionne pas :

- la photo ou trace Mathilde ;
- la conversation Sandra ;
- l’effet de Raphaëlle ;
- son trouble général.

## Choix joueur recommandés

### A — Rassurer tendrement

Intention : Player revient vers Marie.

Effets possibles :

```text
marie_trust +1
lie_score -1
marie_route_pressure +1
```

### B — Minimiser / esquiver

Intention : Player évite une discussion.

Effets possibles :

```text
lie_score +1
marie_suspicion +1
```

### C — Être sincère mais incomplet

Intention : Player dit qu’il est fatigué ou perdu, sans nommer les autres fils.

Effets possibles :

```text
marie_trust +1
lie_score +1
truth_seed_marie_j3 = true
```

### D — Réactiver le couple

Intention : Player montre qu’il désire encore Marie.

Effets possibles :

```text
marie_route_pressure +2
marie_trust +1
photo_marie_home_j3_available = true
```

## Photo / trace possible

Photo conditionnelle : `photo_marie_home_j3`.

Déblocage recommandé : choix tendre ou désirant envers Marie.

Placeholder :

```text
Photo envoyée : Marie dans la cuisine ou le salon, lumière douce du matin, tenue simple mais flatteuse, un détail de maison visible. L’image est tendre, intime, et rappelle que le couple possède encore une sensualité réelle.
```

## Phrases exemples

```text
Marie : T’es rentré.
Marie : Mais j’ai l’impression qu’il y a encore une partie de toi qui cherche le réseau.
```

```text
Marie : Tu veux un café ou tu vas encore faire semblant d’être déjà réveillé ?
```

```text
Marie : J’aime bien quand tu reviens. J’aime moins quand j’ai l’impression que tu repars dans ta tête.
```

## Phrase interdite

```text
Tu me trompes ?
```

Trop frontal pour J3.

---

# J3_02 — Mathilde / Réveil canapé

## Fonction

Donner une conséquence directe à la nuit de Mathilde chez Marie et Player.

Ce n’est pas la situation qui est nouvelle : Mathilde a déjà l’habitude de dormir chez eux. Ce qui change, c’est le regard de Player.

## Moment proposé

```text
09:34 — Mathilde écrit depuis le salon ou juste après être partie
```

## Ton de surface

```text
taquin
familier
effronté
vivant
```

## Sous-texte

```text
Mathilde veut savoir si Player l’a vue autrement.
```

Elle aime sentir l’effet qu’elle produit, mais elle n’est pas prête à devenir celle qui détruit Marie.

## Désir perceptible

Le désir Mathilde passe par le décor de Marie : canapé, plaid, tasse, chargeur, salon.

Plus la photo est domestique, plus elle est risquée.

## Point de tension

Marie trouve la présence de Mathilde normale. Player commence à ne plus la vivre normalement.

## Mensonge possible

À Marie plus tard :

```text
Mathilde m’a juste envoyé une connerie sur le canapé.
```

alors que Player a gardé, regardé ou désiré la photo.

## Photo obligatoire

`photo_mathilde_canape_morning_j3`

Type : photo.

Palier : 1 — Ambigu.

Fonction : première preuve domestique faible.

Placeholder :

```text
Photo envoyée : Mathilde au réveil sur le canapé de Marie et Player, plaid autour d’elle, cheveux un peu défaits, tasse à moitié pleine près d’elle. Elle sourit comme si la situation était normale, mais le cadrage rend la scène plus intime qu’elle ne devrait l’être.
```

Risque : Marie peut reconnaître le canapé, le plaid ou le contexte.

## Choix joueur recommandés

### A — Rester léger

Intention : Player répond sur le ton de la blague.

Effets possibles :

```text
mathilde_familiarity +1
mathilde_route_pressure +1
```

### B — Flirter doucement

Intention : Player montre qu’il l’a regardée autrement.

Effets possibles :

```text
mathilde_desire +2
mathilde_loyalty -1
lie_score +1
mathilde_route_pressure +2
```

Risque : Mathilde peut reculer si la phrase est trop claire.

### C — Poser une limite

Intention : Player protège Marie ou se protège lui-même.

Effets possibles :

```text
mathilde_loyalty +1
mathilde_desire -1
marie_trust +1
```

### D — Conserver la photo

Effets possibles :

```text
photo_mathilde_canape_morning_j3_kept = true
lie_score +1
mathilde_route_pressure +1
proof_mathilde_canape_j3 = true
```

### E — Supprimer la photo

Effets possibles :

```text
photo_mathilde_canape_morning_j3_deleted = true
lie_score -1
mathilde_exposure -1
possible_regret_j3 = true
```

## Phrases exemples

```text
Mathilde : Votre canapé m’a cassée.
Mathilde : Je joins une preuve pour l’assurance.
```

```text
Mathilde : Tu réponds comme ça à tout le monde ou je dois m’inquiéter ?
```

```text
Mathilde : Ne réponds pas un truc bizarre, je suis pas prête.
```

```text
Mathilde : Je disais ça pour rire.
Mathilde : Enfin.
Mathilde : On va dire ça.
```

## Phrase interdite

```text
Tu aurais dû dormir avec moi.
```

Trop direct pour J3.

---

# J3_03 — Raphaëlle / Midi clarté calme

## Fonction

Installer Raphaëlle comme contraste.

Elle n’est pas là pour séduire vite. Elle remarque que Player n’est pas clair, ou qu’il a l’air fatigué. Elle parle peu, mais juste.

## Moment proposé

```text
12:41 — pause travail
```

## Ton de surface

```text
calme
professionnel
attentif
sobre
```

## Sous-texte

```text
Raphaëlle voit que Player évite quelque chose.
```

## Désir perceptible

Raphaëlle peut devenir désirable par sa clarté, pas par provocation.

Le désir est ici lié à l’impression que quelqu’un voit Player sans chercher à le posséder.

## Point de tension

Player peut chercher du réconfort auprès d’elle sans clarifier sa vie.

## Mensonge possible

Player dit :

```text
Tout va bien.
```

alors que ses autres fils montrent le contraire.

## Choix joueur recommandés

### A — Dire que ça va

Effets possibles :

```text
lie_score +1
raphaelle_clarity -1
```

### B — Reconnaître la fatigue

Effets possibles :

```text
raphaelle_clarity +1
lie_score +0
```

### C — Chercher un appui

Effets possibles :

```text
raphaelle_attachment +1
raphaelle_boundary_seed +1
lie_score +1
```

Risque : Raphaëlle acceptera d’écouter, mais pas de devenir un secret.

## Photo / trace possible

Pas de photo obligatoire.

Trace possible : rappel de la photo badge J2, promesse d’une pause ou photo sobre plus tard si Player est clair.

## Phrases exemples

```text
Raphaëlle : Tu avais l’air fatigué ce matin.
Raphaëlle : Pas juste sommeil.
```

```text
Raphaëlle : Je ne sais pas ce que tu évites.
Raphaëlle : Mais tu l’évites assez fort pour que ça se voie.
```

```text
Raphaëlle : Je peux écouter.
Raphaëlle : Pas devenir l’endroit où tu caches le reste.
```

## Phrase interdite

```text
Je serai toujours là pour toi.
```

Trop pansement.

---

# J3_04 — Sandra / Jeudi maintenu

## Fonction

Faire de Sandra une route émotionnelle dangereuse sans nouvelle escalade visuelle trop rapide.

Sandra doit rester rare, douce, hésitante, capable d’esquive. Elle n’est pas une conquête facile.

## Moment proposé

```text
18:27 ou 22:14
```

## Ton de surface

```text
doux
prudent
complice
un peu fuyant
```

## Sous-texte

```text
Sandra veut compter sans devoir assumer ce que cela signifie.
```

## Désir perceptible

Chez Sandra, le désir passe par le manque, l’attente et les phrases retenues.

Une photo non envoyée ou un message supprimé peut être plus fort qu’une photo immédiate.

## Point de tension

Elle écrit dans un espace que Marie ne voit pas, mais qui peut devenir plus intime qu’une photo.

## Mensonge possible

Player laisse Sandra croire qu’elle est la seule à qui il parle vraiment.

## Omission possible

Il ne dit pas qu’il est aussi troublé par Mathilde ou qu’il cherche l’attention de Raphaëlle.

## Trace recommandée

Pas de nouvelle vraie photo obligatoire.

Trace recommandée :

```text
sandra_deleted_message_j3
```

ou :

```text
sandra_almost_sent_photo_j3
```

## Choix joueur recommandés

### A — La rassurer doucement

Effets possibles :

```text
sandra_attachment +1
sandra_exposure -1
sandra_route_pressure +1
```

### B — La pousser à dire ce qu’elle pense

Effets possibles :

```text
sandra_attachment +2
sandra_exposure +2
sandra_route_pressure +2
```

Risque : Sandra peut fuir si Player force.

### C — Faire de l’humour

Effets possibles :

```text
sandra_comfort +1
sandra_depth -1
```

### D — Parler de jeudi concrètement

Effets possibles :

```text
sandra_thursday_confirmed_j3 = true
sandra_attachment +1
lie_score +1
```

## Phrases exemples

```text
Sandra : Je fais semblant de ne pas penser à jeudi.
Sandra : C’est très convaincant, dans ma tête.
```

```text
Sandra : J’aime bien t’écrire.
Sandra : C’est justement ça le problème.
```

```text
Sandra : J’ai failli t’écrire un truc trop honnête.
Sandra : Heureusement j’ai encore un peu de lâcheté.
```

```text
Sandra : Je ne sais pas pourquoi je t’ai envoyé cette photo.
Sandra : Enfin si.
Sandra : Non, oublie.
```

## Phrase interdite

```text
Je veux être avec toi.
```

Trop frontal pour J3.

---

# J3_05 — Marie / Fin de journée

## Fonction

Refermer J3 sur Marie, pas sur la route secondaire.

Le joueur doit sentir que toutes les routes tournent autour du couple, même quand Marie ne sait pas tout.

## Moment proposé

```text
23:02 — maison / lit / salon
```

## Ton de surface

```text
doux
fatigué
intime
plus lucide que le matin
```

## Sous-texte

```text
Marie sent que la journée a éloigné Player, même s’il est physiquement là.
```

## Désir perceptible

Marie peut demander une présence qui est à la fois affective et corporelle : rester près d’elle, revenir dans le lit, poser le téléphone, être là.

## Point de tension

Le joueur peut avoir augmenté plusieurs routes dans la journée, mais Marie ferme la journée.

## Mensonge possible

Player dit :

```text
Je suis là.
```

alors qu’il a passé la journée à nourrir d’autres fils.

## Choix joueur recommandés

### A — Revenir vers elle

Effets possibles :

```text
marie_trust +2
lie_score -1
marie_route_pressure +1
```

### B — Mentir doucement

Effets possibles :

```text
lie_score +2
marie_suspicion +1
```

### C — Avouer une partie

Effets possibles :

```text
marie_trust +1
truth_seed_marie_j3 = true
```

Exemple d’intention :

```text
Je crois que je suis un peu perdu en ce moment.
Mais je ne veux pas te perdre toi.
```

### D — Esquiver par tendresse

Effets possibles :

```text
lie_score +1
marie_suspicion +1
```

## Phrases exemples

```text
Marie : T’as été gentil aujourd’hui.
Marie : Mais pas complètement là.
```

```text
Marie : Je ne sais pas si tu es fatigué ou si tu me caches ta fatigue.
```

```text
Marie : Alors reste un peu avec moi.
Marie : Même si c’est juste ce soir.
```

## Phrase interdite

```text
Je sais tout.
```

Trop tôt.

---

# Contenus visuels J3

## Obligatoire

```text
photo_mathilde_canape_morning_j3
```

Fonction : preuve domestique faible.

## Conditionnel

```text
photo_marie_home_j3
```

Fonction : rappeler Marie comme désir et ancrage.

## Promesse / trace

```text
sandra_almost_sent_photo_j3
sandra_deleted_message_j3
```

Fonction : rareté émotionnelle.

## Trace de clarté

```text
raphaelle_boundary_seed_j3
```

Fonction : préparer son refus du flou.

---

# Flags J3 recommandés

```text
player_returned_home_j3
marie_noticed_distance_j3
mathilde_morning_after_home_j3
photo_mathilde_canape_morning_j3_received
photo_mathilde_canape_morning_j3_kept
photo_mathilde_canape_morning_j3_deleted
photo_marie_home_j3_available
photo_marie_home_j3_received
raphaelle_noticed_fatigue_j3
raphaelle_boundary_seed_j3
sandra_deleted_message_j3
sandra_almost_sent_photo_j3
sandra_thursday_confirmed_j3
truth_seed_marie_j3
lie_to_marie_j3
```

# Variables J3 recommandées

Limiter les effets et rester data-first.

```text
marie_trust
marie_suspicion
lie_score
mathilde_desire
mathilde_loyalty
sandra_attachment
sandra_exposure
raphaelle_clarity
```

Pressions de route possibles :

```text
marie_route_pressure
mathilde_route_pressure
sandra_route_pressure
raphaelle_route_pressure
pauline_threat_seed
nico_threat_seed
```

Nico et Pauline peuvent avoir des seeds faibles, mais pas encore de route active lourde en J3.

---

# Lecture des routes après J3

## Si Player revient vers Marie

Conséquence :

```text
Marie reste forte.
Mensonge bas.
Réparation possible.
Routes secondaires progressent plus lentement.
```

## Si Player garde la photo Mathilde et flirte

Conséquence :

```text
Mathilde monte.
Loyauté Mathilde baisse.
Risque Marie augmente.
La photo canapé devient une preuve sensible.
```

## Si Player pousse Sandra

Conséquence :

```text
Sandra s’attache mais exposition augmente.
Elle peut ensuite fuir si Player force trop.
```

## Si Player cherche Raphaëlle

Conséquence :

```text
Raphaëlle devient contrepoint.
Elle demandera de la clarté plus tard.
Elle refusera le rôle de secret.
```

## Si Player ment à Marie tout en gardant les photos

Conséquence :

```text
SECRET_AFFAIR commence à devenir le mode probable.
Pauline et Nico deviendront plus dangereux en J4/J5.
```

---

# Garde-fous J3

## Ne pas faire

```text
Ne pas déclencher une crise conjugale frontale.
Ne pas faire de Mathilde une séductrice explicite.
Ne pas donner une nouvelle grosse photo Sandra.
Ne pas faire de Raphaëlle une romance immédiate.
Ne pas introduire Pauline/Nico comme conversations lourdes.
Ne pas créer de groupe actif obligatoire.
Ne pas oublier que Marie doit fermer la journée.
```

## À faire

```text
Rendre le retour physique concret.
Faire peser la nuit de Mathilde.
Faire sentir que Sandra devient émotionnellement importante.
Faire de Raphaëlle un repère de clarté.
Donner au joueur au moins un choix de mensonge / omission / vérité partielle.
Créer une première preuve domestique faible.
Faire sentir un désir perceptible sans passer trop vite à l’explicite.
```

## Résumé J3

```text
J3 commence avec Player revenu dans la maison.
Marie sent une distance.
Mathilde rend la nuit chez eux visible par une photo ambiguë.
Raphaëlle remarque que Player esquive.
Sandra confirme que jeudi compte.
Marie clôt la journée en demandant à Player d’être vraiment là.
```

## Fonction finale

J3 doit faire comprendre :

```text
Le danger ne vient pas encore de ce que Player a fait.
Il vient de ce qu’il commence à cacher.
```
