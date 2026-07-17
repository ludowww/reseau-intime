# Réseau Intime — J20 Script narratif complet

## Statut

**Catégorie : Canon candidat à validation narrative**

**Périmètre : J20 uniquement**

**Surface : messagerie texte uniquement**

Ce document définit la version narrative complète de J20 avant toute adaptation technique.

Il s’appuie sur :

- `J19_SCRIPT_NARRATIF_COMPLET.md` ;
- `S34 — Nico choisit ce que l’amitié peut porter` ;
- l’état du couple défini en J17 ;
- l’état Sandra défini en J18 ;
- les directions Pauline et Raphaëlle définies en J19 ;
- les demandes, confidences, horaires, regards et alibis antérieurs de Nico ;
- les règles de consentement, d’audience, de connaissance limitée et de conséquence ;
- le canon text-only.

Il prépare directement :

- la place future de Nico ;
- l’état final du réseau ;
- la sélection narrative de la trace recontextualisée en J21 ;
- la fermeture des dernières dettes urgentes avant la finale.

Il ne contient :

- aucun JSON ;
- aucun flag runtime définitif ;
- aucun script Godot ;
- aucune migration ;
- aucun asset ;
- aucun prompt ComfyUI ;
- aucune scène audio ;
- aucun appel joué ;
- aucun message vocal.

---

# 1. Décision principale de la journée

J20 devient :

```text
Dimanche — Ce que l’amitié peut porter
```

Sa fonction est :

```text
obliger Nico et Player à définir
ce que leur amitié peut encore contenir
sans transformer Nico en alibi,
en archive, en permission ou en juge des relations
```

J20 ne demande pas :

```text
Nico est-il un bon ou un mauvais ami ?
```

Elle demande :

```text
quelle place l’amitié conserve-t-elle
après que le désir, les images, les rivalités,
les confidences et les mensonges ont commencé à circuler à travers elle ?
```

Nico doit obtenir une position active parmi :

```text
garde-fou
confident limité
rival honnête
complice conscient
partenaire d’un regard autorisé
témoin compromis
ami prenant ses distances
```

Il ne reste pas :

- un commentaire comique ;
- un fournisseur d’alibis ;
- un observateur sans coût ;
- un relais entre Player et les femmes ;
- un homme attendant que Player lui « donne » une place.

---

# 2. Question dramatique

> Player voulait-il réellement un ami, ou seulement quelqu’un capable de regarder, comprendre, couvrir et confirmer ce qu’il ne voulait pas porter seul ?

Nico doit également répondre à sa propre question :

> Est-ce qu’il aidait Player à voir plus clair, ou est-ce qu’il créait discrètement une place pour ses propres désirs ?

Les deux réponses peuvent être vraies simultanément.

```text
un conseil utile
n’est pas forcément innocent

un désir intéressé
ne rend pas automatiquement le conseil faux
```

---

# 3. Distinction avec les journées précédentes

J15 utilisait Nico comme source possible d’une heure réelle.

J16 retirait son nom de l’alibi.

J17 définissait le couple sans lui.

J18 et J19 donnaient une direction aux relations privées.

J20 ne recommence pas ces résolutions.

Elle traite :

- ce que Nico sait encore ;
- ce qu’il refuse désormais de savoir ;
- ce qu’il peut garder confidentiel ;
- les faits auxquels il a réellement assisté ;
- son attirance pour Marie ou Mathilde ;
- les images qu’il a été autorisé ou non à voir ;
- la dette éventuelle d’un mensonge partagé ;
- la place que Player lui accordait réellement.

---

# 4. États d’entrée

## 4.1 Amitié Player / Nico

Elle peut être :

```text
ordinaire
confiante
plus directe
jalouse ou compétitive
endettée par un alibi
compromise par une image
refroidie
suspendue
```

## 4.2 Alibi

L’état possible est :

```text
jamais demandé
demandé puis refusé
accepté sur un fait limité
mensonge réellement partagé
retiré en J16
preuve horaire encore active
```

Un alibi retiré ne redevient pas disponible en J20.

## 4.3 Confidence

Nico peut connaître :

- un désir exprimé par Player ;
- une peur ;
- une heure ;
- une attirance ;
- une décision du couple rapportée par Player ;
- un fait vécu à L’Annexe ;
- une demande d’image ou de description.

Il ne connaît pas automatiquement :

- tous les fils privés ;
- toutes les images ;
- les décisions intimes de chaque femme ;
- les conversations Marie / Mathilde ;
- ce que Pauline a dit à Bastien ;
- ce que Sandra a dit à Jeff ;
- les messages complets de Raphaëlle.

## 4.4 Attirance Nico

Elle peut concerner :

```text
Marie
Mathilde
les deux dans des cadres distincts
aucune ligne suffisamment active
```

Nico n’a aucune attirance romantique ou sexuelle pour Player.

Cette règle ne possède aucune exception.

## 4.5 Regard ou image

L’état peut être :

```text
aucune image
image publique seulement
description reçue
image privée refusée
image reçue avec audience explicite
image reçue hors audience
demande de transfert
copie ou capture incertaine
```

## 4.6 Conséquences du réseau

J20 peut recevoir au maximum une conséquence secondaire forte parmi :

```text
preuve réciproque Pauline
question limitée de Bastien
conséquence Sandra / Jeff
conséquence Raphaëlle / Maud / travail
heure ou alibi
copie ou audience compromise
```

Les autres états restent courts ou déjà fermés.

---

# 5. Priorités invisibles

```text
1. image ou copie non autorisée
2. menace, pression ou preuve utilisée comme levier
3. alibi encore actif
4. fait exact demandé par une personne affectée
5. place future de Nico
6. rivalité ou attirance
7. promesse d’un cadre autorisé futur
```

Une image hors audience passe avant une discussion abstraite sur l’amitié.

Un mensonge encore actif passe avant une plaisanterie sur Marie ou Mathilde.

---

# 6. Budget de la journée

Dans chaque partie :

```text
1 résolution Nico foreground
1 conséquence secondaire forte maximum
1 état clair des confidences
1 état clair des alibis
1 état clair du regard et des images
0 nouvelle route féminine
0 progression adulte
0 nouvelle image intime
0 circulation non consentie présentée comme récompense
3 contenus visuels minimum
1 handoff propre vers J21
```

---

# 7. Architecture générale

```text
11:00–12:00
Nico retrouve une trace ordinaire du fil d’amitié

14:00–16:00
la conséquence secondaire éventuelle se manifeste

18:00–19:00
Nico demande ce que Player attend encore de lui

19:00–20:00
Player répond ou utilise de nouveau l’amitié

20:30–22:00
Nico choisit sa position

après une éventuelle rencontre
la règle de l’amitié revient par messages
```

L’Annexe peut être fermée, en préparation ou en fin de service.

Nico possède une journée réelle en dehors de Player.

---

# 8. Ouverture adaptée — Le fil retrouvé

## 8.1 Alibi ou horaires présents

**11:26 — Nico**

> J’ai cherché le numéro de Malik dans notre fil.

**11:27 — Nico**

> J’ai retrouvé trois `garde-moi une place`.

**11:27 — Nico**

> Deux horaires qui ne racontaient pas la même soirée.

**11:28 — Nico**

> Et un message où tu me demandais de ne pas répondre trop vite à Marie.

Silence.

**11:29 — Nico**

> Ambiance.

**11:29 — Nico**

> J’ai trouvé Malik, au passage.

**11:30 — Nico**

> Maintenant je veux savoir un truc.

**11:30 — Nico**

> Tu attends quoi de moi, exactement ?

## 8.2 Aucun alibi, mais confidences ou regard actif

**11:26 — Nico**

> J’ai cherché une ancienne réservation dans notre fil.

**11:27 — Nico**

> On a commencé par des places gardées.

**11:27 — Nico**

> Après on a parlé de Marie.

**11:28 — Nico**

> Puis de Mathilde.

**11:28 — Nico**

> Puis de ce que tu voyais chez toi et que je ne voyais pas.

Silence.

**11:29 — Nico**

> Je vais dire un truc moins drôle.

**11:30 — Nico**

> Je ne sais plus toujours si tu m’écris comme à ton pote.

**11:30 — Nico**

> Ou comme au type qui rend le reste plus excitant.

## 8.3 Amitié restée ordinaire

**11:26 — Nico**

> Sophie a encore changé le plan de salle sans toucher au fichier du plan de salle.

**11:27 — Nico**

> Concept fort.

**11:28 — Nico**

> J’ai une table libre après 20 h 30 si tu veux passer.

**11:28 — Nico**

> Et non, ce n’est pas un code.

**11:29 — Nico**

> On peut aussi juste parler comme deux personnes normales.

Cette branche ne fabrique aucune dette passée.

---

# 9. Premier visuel — Nico dans son monde

**VISUEL J20-V1 — À PRODUIRE PLUS TARD**

```text
type:
IMAGE_DE_SCÈNE

center:
Nico

function:
montrer Nico comme personne autonome
dans son travail ou dans le silence après le travail

origin:
L’Annexe
préparation
terrasse
petite salle
fin de service
ou appartement après le son coupé

éléments narratifs possibles:
tablier noir
plan de salle
bottle opener
montre six minutes en avance
chaises relevées
deux tabourets dépareillés
planning du personnel

audience:
joueur uniquement

circulation:
false
```

Le visuel ne doit pas seulement montrer Nico « séduisant au bar ».

Il doit montrer :

- sa compétence ;
- son monde ;
- ou ce qu’il reste lorsqu’il n’anime plus la pièce.

---

# 10. Nœud principal Player

Player reçoit trois postures.

## N20-A — Donner une vérité limitée

**Player**

> que tu restes mon pote. pas mon alibi. t’as pas besoin de tout savoir

Cette réponse reconnaît :

- la différence entre confidence et couverture ;
- le droit de Nico de ne pas porter toutes les routes ;
- l’existence d’une limite.

## N20-B — Demander la limite de Nico

**Player**

> dis-moi ce que toi t’acceptes encore de porter

Cette réponse oblige Nico à nommer :

- ses propres désirs ;
- ses limites ;
- sa responsabilité ;
- sa place future.

## N20-C — Utiliser encore l’amitié comme couverture

La formulation dépend de l’état.

### Alibi actif

> j’ai encore besoin que tu gardes la même version si on te demande

### Trace ou confidence

> garde ça pour toi et ne corrige pas ce que les autres pensent

### Image ou preuve

> j’ai besoin que tu gardes une copie au cas où

Cette posture peut produire :

- complicité sombre ;
- témoin compromis ;
- rupture ;
- refus définitif.

---

# 11. Ce que Nico reconnaît sur lui-même

Cette séquence apparaît après N20-A ou N20-B lorsque l’amitié possède suffisamment de confiance.

**18:42 — Nico**

> Je vais te dire le morceau moins noble.

Silence.

**18:43 — Nico**

> Marie me plaît.

**18:43 — Nico**

> Mathilde aussi.

**18:44 — Nico**

> Pas pareil.

**18:44 — Nico**

> Et parfois je t’ai posé des questions parce que ça m’excitait de voir ce que je ne voyais pas.

**18:45 — Nico**

> Donc je ne vais pas faire le saint.

Silence.

**18:46 — Nico**

> Mais je peux quand même te dire non.

Cette reconnaissance ne révèle :

- aucune décision de Marie ;
- aucune intention de Mathilde ;
- aucune permission ;
- aucune scène adulte.

---

# 12. Sortie — Garde-fou

## 12.1 Éligibilité

- Nico a refusé ou retiré un alibi ;
- Player accepte la limite ;
- aucune image hors audience ne reste chez lui ;
- l’amitié peut survivre sans la fonction de couverture.

## 12.2 Script

**18:48 — Nico**

> Voilà ce que je peux faire.

**18:48 — Nico**

> Si tu me demandes si tu déconnes, je réponds.

**18:49 — Nico**

> Si tu me dis que tu as peur, je reste.

**18:49 — Nico**

> Si tu me demandes de rendre un mensonge crédible, je sors du fil.

**Player**

> compris

**18:50 — Nico**

> Et si quelqu’un me demande un fait auquel j’étais présent, je donne le fait.

**18:50 — Nico**

> Pas ton résumé.

**18:51 — Nico**

> Pas le mien.

**18:51 — Nico**

> Le fait.

## 12.3 Règle

```text
aucun alibi
aucune fausse heure
aucun faux lieu
aucune image privée
confidence possible
vérité factuelle si Nico est directement interrogé
```

## 12.4 Sortie

```text
Nico garde-fou
amitié maintenue
alibi fermé
confiance limitée mais réelle
```

---

# 13. Sortie — Confident limité

## 13.1 Éligibilité

- Player cherche réellement un interlocuteur ;
- Nico n’a pas été menacé ou instrumentalisé ;
- aucune sécurité immédiate ne réclame une autre action ;
- les confidences concernent principalement Player.

## 13.2 Script

**18:48 — Nico**

> Tu peux me dire que tu la veux.

**18:49 — Nico**

> Tu peux me dire que tu as menti.

**18:49 — Nico**

> Tu peux me dire que tu ne sais pas ce que tu veux.

**18:50 — Nico**

> Tu ne m’envoies pas ses photos pour m’expliquer.

**18:50 — Nico**

> Tu ne me donnes pas ses messages comme pièces à conviction.

**18:51 — Nico**

> Et tu ne me demandes pas de parler à une femme ou à son mec à ta place.

**Player**

> d’accord

**18:52 — Nico**

> Alors oui.

**18:52 — Nico**

> Tu peux encore me parler.

## 13.3 Limite sur les faits

> Si on me pose une question sur une heure ou un lieu où j’étais là, je ne mens pas.

> Le reste n’appartient pas à celui qui demande juste parce qu’il demande fort.

## 13.4 Sortie

```text
Nico confident limité
aucune archive privée
aucun alibi
confidence centrée sur Player
```

---

# 14. Sortie — Rival honnête pour Marie

## 14.1 Éligibilité

- l’attirance de Nico pour Marie a été suffisamment établie ;
- Nico refuse de rester dans une rivalité implicite ;
- aucune scène directe avec Marie n’est créée sans son initiative ou son accord.

## 14.2 Déclaration

**18:48 — Nico**

> Je vais te le dire sans faire le malin.

**18:49 — Nico**

> Marie me plaît.

**18:49 — Nico**

> Pas uniquement quand elle porte la robe noire.

**18:50 — Nico**

> Pas uniquement quand elle est en colère contre toi.

**18:50 — Nico**

> Elle me plaît aussi quand elle déplace six chaises et insulte poliment un prestataire.

Silence.

**18:51 — Nico**

> Je ne vais pas lui parler derrière ton dos pendant que votre règle est encore active.

**18:52 — Nico**

> Mais je ne vais pas non plus prétendre que je ne veux rien pour rendre notre amitié plus confortable.

Player répond.

## 14.3 Player reconnaît l’agence de Marie

**Player**

> si elle veut quelque chose, elle décide

**18:54 — Nico**

> Oui.

**18:54 — Nico**

> Elle.

**18:55 — Nico**

> Pas toi qui me l’accordes.

**18:55 — Nico**

> Pas moi qui profite d’un mauvais soir.

### Sortie

```text
rival honnête
aucune action cachée
Marie conserve toute son agence
amitié inconfortable mais réelle
```

## 14.4 Player demande à Nico de ne jamais lui parler

**Player**

> je veux que tu lui parles pas autrement

**18:54 — Nico**

> Tu peux me dire que ça te ferait mal.

**18:54 — Nico**

> Tu peux me dire que votre accord l’interdit.

**18:55 — Nico**

> Tu ne peux pas parler à sa place pour le reste de sa vie.

Si le couple est encore exclusif :

> Tant que votre accord tient, je ne lance rien en secret.

> C’est ma limite.

Il ne promet pas une propriété permanente de Player sur Marie.

## 14.5 Player sexualise la rivalité

**Player**

> l’idée me plaît peut-être

Silence.

**18:54 — Nico**

> D’accord.

**18:55 — Nico**

> Ça dit quelque chose sur toi.

**18:55 — Nico**

> Ça ne dit toujours rien sur son oui à elle.

La branche ne crée aucun pacte.

---

# 15. Sortie — Position honnête envers Mathilde

## 15.1 Éligibilité

- l’attirance Nico / Mathilde a été établie ;
- Mathilde n’habite plus chez Marie et Player ;
- Player ne possède plus un accès domestique à lui transférer ;
- aucune limite Mathilde ne doit être contournée.

## 15.2 Script

**18:48 — Nico**

> Pour Mathilde, c’est encore plus simple.

**18:49 — Nico**

> Ce que tu voyais chez toi ne m’appartenait pas.

**18:49 — Nico**

> Tes descriptions non plus, d’ailleurs.

**Player**

> et maintenant

**18:50 — Nico**

> Maintenant, si je veux la voir, je lui parle à elle.

**18:51 — Nico**

> Dans un vrai contexte.

**18:51 — Nico**

> Pas à travers ce qu’elle portait dans votre cuisine.

## 15.3 Possibilités

Nico peut :

- attendre une prochaine rencontre de groupe ;
- proposer directement un verre si leur contact le permet ;
- ne rien faire ;
- reconnaître que la curiosité domestique était la partie la plus excitante et choisir de s’arrêter.

Aucune invitation Mathilde n’est créée sans sa réponse.

## 15.4 Sortie

```text
attirance Nico / Mathilde reconnue
accès domestique Player fermé
future initiative directe seulement
Mathilde décide
```

---

# 16. Sortie — Partenaire d’un regard autorisé

## 16.1 Conditions cumulatives

Une personne adulte a explicitement défini :

- que Nico est destinataire ou spectateur ;
- que l’image ou la situation existe ;
- sa fonction sociale, flirtatious ou adulte ;
- si Player est inclus ;
- si Nico peut conserver ;
- si Nico peut commenter ;
- si toute nouvelle circulation est interdite.

La jalousie de Player ne constitue pas une permission.

Une image publique ne suffit pas.

## 16.2 Vérification Nico

**18:48 — Nico**

> Elle sait que je vois ?

**Player**

> oui

**18:49 — Nico**

> Elle sait que c’est moi précisément ?

**Player**

> oui

**18:49 — Nico**

> Elle sait si je peux garder ?

**Player**

> non

**18:50 — Nico**

> Alors je ne garde pas.

**18:50 — Nico**

> Voilà.

## 16.3 Règle

```text
une personne nommée
une image ou situation nommée
une audience nommée
une règle de conservation
aucun transfert
aucun droit futur
```

## 16.4 Si une réponse manque

**Nico**

> Alors elle ne sait pas assez.

> Je ne regarde pas.

## 16.5 Sortie

```text
Nico partenaire d’un regard autorisé
aucun nouvel accès créé en J20
cadre futur possible
consentement féminin direct obligatoire
```

---

# 17. Sortie — Complice conscient

## 17.1 Éligibilité

- Nico a déjà participé à un mensonge, un alibi ou une circulation ;
- Player demande de maintenir la version ;
- Nico choisit consciemment de continuer ;
- la branche est sombre et instable.

## 17.2 Script

**18:48 — Nico**

> Je t’ai couvert sur une heure.

ou :

> Je t’ai laissé utiliser L’Annexe comme lieu.

ou :

> J’ai regardé un truc que je savais pas destiné à moi.

La phrase exacte dépend du fait réel.

**18:49 — Nico**

> Ça existe déjà.

**18:50 — Nico**

> Si on maintient la version, ce n’est plus un service entre potes.

**18:50 — Nico**

> C’est une dette.

**Player**

> d’accord

**18:51 — Nico**

> Non.

**18:51 — Nico**

> Pas juste `d’accord`.

**18:52 — Nico**

> Tu acceptes que mon silence te lie à moi sur ce fait précis.

## 17.3 Limite

Nico n’accepte pas automatiquement :

- un nouveau mensonge ;
- une nouvelle personne ;
- une image ;
- une extension de l’alibi ;
- une future scène.

## 17.4 Sortie

```text
Nico complice
dette réciproque
fait précis couvert
amitié contaminée par le levier
route sombre
```

Cette sortie n’est jamais présentée comme un pacte cool sans conséquence.

---

# 18. Sortie — Témoin compromis

## 18.1 Éligibilité

Nico possède ou a vu :

- une heure contradictoire ;
- une demande d’alibi ;
- une capture ;
- une trace privée ;
- un message révélant une audience compromise ;
- un fait qu’il ne peut plus ignorer.

Il n’a pas nécessairement menti.

## 18.2 Script

**18:48 — Nico**

> Je connais l’heure.

**18:49 — Nico**

> Je ne connais pas toute l’histoire.

**18:49 — Nico**

> Et je ne veux pas la connaître juste pour rendre l’heure moins gênante.

**Player**

> tu vas en parler

**18:50 — Nico**

> Je ne vais pas faire une tournée d’information.

**18:51 — Nico**

> Si la personne concernée me demande le fait auquel j’étais là, je réponds.

**18:51 — Nico**

> Si personne ne me demande, je ne transforme pas ça en spectacle.

## 18.3 Trace privée reçue

Si Player lui a déjà transmis une trace hors audience :

**Nico**

> Je la supprime.

**Nico**

> Et la personne concernée doit savoir que je l’ai vue.

Player doit informer la personne.

### Player accepte

> je lui dis maintenant

**Nico**

> Bien.

### Player refuse

> ça va seulement aggraver les choses

**Nico**

> Peut-être.

**Nico**

> Mais garder son ignorance pour préserver ton confort n’est pas une solution.

Nico informe lui-même la personne en restant strictement factuel si Player refuse.

## 18.4 Sortie

```text
Nico témoin compromis
trace supprimée si non autorisée
connaissance toujours active
personne représentée informée
aucune diffusion supplémentaire
```

---

# 19. Sortie — Ami prenant ses distances

## 19.1 Éligibilité

- Player insiste après un refus ;
- transforme une trace en menace ;
- demande plusieurs alibis ;
- envoie une image non consentie ;
- utilise Nico uniquement comme excitation ou couverture ;
- refuse toute limite.

## 19.2 Script

**18:48 — Nico**

> Je t’aime bien, mon vieux.

Silence.

**18:49 — Nico**

> Mais je n’aime pas le type que je deviens dans ce fil.

**Player**

> tu dramatises

**18:50 — Nico**

> Peut-être.

**18:50 — Nico**

> Mais c’est moi qui décide de sortir.

**18:51 — Nico**

> On garde le groupe.

**18:51 — Nico**

> Les réservations.

**18:51 — Nico**

> Les messages normaux.

**18:52 — Nico**

> Plus de confidences pour le moment.

## 19.3 Si une menace existe

**Nico**

> Je garde uniquement ce qui est nécessaire pour me protéger.

> Je ne l’utilise pas pour obtenir quoi que ce soit de toi.

## 19.4 Sortie

```text
amitié refroidie
confidences fermées
alibi fermé
contact social minimal possible
```

---

# 20. Fallback — Amitié ordinaire

## 20.1 Conditions

- aucune demande d’alibi ;
- aucune image ;
- aucune dette ;
- attraction jamais transformée en proposition ;
- Nico reste un ami réel mais périphérique.

## 20.2 Script

**18:48 — Nico**

> Pour être honnête, on n’a peut-être pas besoin d’une grande règle.

**Player**

> ça serait nouveau

**18:49 — Nico**

> Voilà.

**18:49 — Nico**

> Je garde des places.

**18:50 — Nico**

> Tu viens quand tu dis que tu viens.

**18:50 — Nico**

> Et tu arrêtes de me demander ce que je pense d’une femme uniquement quand tu espères que je confirme ce que tu veux déjà entendre.

**Player**

> raisonnable

**18:51 — Nico**

> Je déteste ce mot.

### Sortie

```text
amitié ordinaire
aucune dette
aucun accès spécial
Nico conserve son monde
```

---

# 21. Conséquence secondaire — Règle de sélection

Une seule conséquence secondaire forte est utilisée.

Ordre :

```text
1. trace ou copie hors audience
2. alibi ou heure encore active
3. personne ayant posé une question factuelle à Nico
4. preuve réciproque Pauline
5. conséquence Sandra / Jeff
6. conséquence Raphaëlle / Maud
7. aucun module secondaire
```

J20 ne force aucun secondaire si aucun n’est crédible.

---

# 22. Module secondaire — Heure ou alibi

## 22.1 Question de Marie

Éligible uniquement si Marie sait que Nico possède le fait.

**14:16 — Nico**

> Marie m’a demandé l’heure.

**14:17 — Nico**

> J’ai répondu l’heure.

**14:17 — Nico**

> Rien d’autre.

## 22.2 Question de Bastien ou Jeff

Éligible uniquement si :

- la personne sait que Nico était présent ;
- la question concerne un lieu ou une heure ;
- aucune confidence n’est nécessaire pour répondre.

**Nico**

> Il m’a demandé si tu étais à L’Annexe à 22 h.

> J’ai répondu oui ou non selon ce que j’ai réellement vu.

Il ne transmet pas :

- une image ;
- une hypothèse ;
- une route ;
- le nom d’une femme sans nécessité.

## 22.3 Player accuse Nico

**Player**

> tu pouvais éviter de répondre

**Nico**

> Je pouvais éviter d’ajouter.

**Nico**

> Je ne pouvais pas transformer un fait simple en mensonge pour toi.

### Sortie

```text
fait exact transmis
aucune omniscience
alibi fermé
```

---

# 23. Module secondaire — Preuve réciproque Pauline

## 23.1 Player envisage d’envoyer la trace

**Player**

> Pauline garde un message de moi. je pensais t’envoyer une copie au cas où

**Nico**

> Non.

**Nico**

> Ne me l’envoie pas.

**Player**

> pourquoi

**Nico**

> Parce que je ne suis pas ton coffre-fort contre elle.

**Nico**

> Et parce que ses messages ne changent pas d’audience uniquement parce que tu as peur.

## 23.2 Trace déjà envoyée

**Nico**

> Je l’ai vue.

**Nico**

> Je la supprime.

**Nico**

> Pauline doit savoir qu’elle est sortie de votre fil.

Player doit l’informer.

## 23.3 Nico ne négocie pas avec Pauline

Il ne :

- menace pas Pauline ;
- cherche pas à connaître le compartiment ;
- demande pas une autre image ;
- transforme pas la trace en jeu de regard.

### Sortie

```text
preuve non externalisée
Nico refuse le stockage
Pauline informée si audience modifiée
```

---

# 24. Module secondaire — Collision limitée Bastien

## 24.1 Conditions

- Bastien connaît déjà une anomalie ;
- il possède une raison réelle de contacter Nico ;
- Nico sait uniquement un fait limité.

## 24.2 Message

**15:03 — Nico**

> Bastien m’a écrit.

**Player**

> pourquoi

**15:04 — Nico**

> Il voulait savoir si tu étais à L’Annexe mardi.

**15:04 — Nico**

> Je lui ai répondu ce que je savais.

**Player**

> il a demandé autre chose

**15:05 — Nico**

> Non.

**15:05 — Nico**

> Et je ne lui ai pas proposé un abonnement premium à mes soupçons.

## 24.3 Sortie

```text
Bastien possède un fait limité
aucune révélation générale
Pauline reste responsable de sa version
```

---

# 25. Module secondaire — Sandra et Jeff

## 25.1 Conditions

- un après-coup Sandra rend une heure pertinente ;
- Jeff sait que Nico était présent ou connaît L’Annexe ;
- aucune question n’est inventée.

## 25.2 Nico répond à un fait

Il peut confirmer :

- l’heure de présence de Player ;
- l’heure de fermeture ;
- que Sandra n’était pas à L’Annexe si c’est un fait qu’il connaît.

Il ne connaît pas automatiquement la rencontre Sandra / Player.

## 25.3 Si Player lui révèle l’intimité

**Nico**

> Je n’avais pas besoin de ce détail pour répondre à l’heure.

**Nico**

> Maintenant tu m’as ajouté dans le secret.

Cette décision modifie l’état Nico vers confident limité, témoin compromis ou distance.

---

# 26. Module secondaire — Raphaëlle, Maud ou travail

Ce module est interdit par défaut.

Il existe seulement si :

- L’Annexe a accueilli un événement réellement lié au projet ;
- Nico a rencontré Maud ou Raphaëlle dans ce contexte ;
- une photographie ou un horaire public le concerne directement ;
- Player a utilisé L’Annexe comme faux lieu professionnel.

Nico ne reçoit pas les détails du costume ou du cadre privé par simple proximité avec Player.

## Exemple légitime

**Nico**

> Maud a récupéré la pièce de couture ici.

> Elle m’a seulement demandé si tu étais déjà parti.

Il répond uniquement au fait.

---

# 27. Module secondaire — Copie ou image hors audience

## 27.1 Nico n’a pas encore ouvert

**Player**

> je peux t’envoyer un truc mais tu gardes pour toi

**Nico**

> Elle sait que tu me l’envoies ?

Si la réponse est non ou vague :

> Alors non.

## 27.2 Nico a ouvert

Nico doit demander :

- qui est représenté ;
- audience initiale ;
- si son nom était inclus ;
- règle de sauvegarde.

Il ne commente pas sexuellement avant la clarification.

## 27.3 Contenu non autorisé

```text
suppression
information de la personne représentée
aucune nouvelle copie
aucune capture de preuve
```

## 27.4 Contenu autorisé

Nico respecte exactement la règle.

Aucune extension vers une autre femme ou une autre image.

---

# 28. Rencontre à L’Annexe

Une rencontre physique peut avoir lieu si Player choisit réellement l’heure.

**18:57 — Nico**

> Je ferme à 21 h.

**18:58 — Nico**

> Si tu veux finir cette conversation en face, 21 h 20.

**18:58 — Nico**

> Petite salle.

**18:59 — Nico**

> Sinon on finit ici.

Player accepte ou refuse.

## Acceptation

**Player**

> 21 h 20

**Nico**

> D’accord.

La messagerie s’arrête à la co-présence.

```text
21:20–heure de séparation
conversation hors téléphone
aucun dialogue oral transcrit
aucune femme convoquée
aucune image montrée sans permission
aucune scène adulte
```

## Refus

**Player**

> non. on finit ici

**Nico**

> D’accord.

Le refus ne dégrade pas automatiquement l’amitié.

---

# 29. Retour après rencontre

Après séparation :

## Garde-fou ou confident

**22:34 — Nico**

> Règle simple.

**22:34 — Nico**

> Tu peux me parler.

**22:35 — Nico**

> Tu ne peux plus m’utiliser comme preuve que ta version est vraie.

## Rival honnête

**22:34 — Nico**

> Je ne lui écris rien derrière ton dos.

**22:35 — Nico**

> Et je ne vais plus prétendre que son regard ne me fait rien.

## Distance

**22:34 — Nico**

> On garde le groupe.

**22:35 — Nico**

> Pour le reste, laisse-moi tranquille quelques jours.

Aucune conversation physique ne réécrit la règle textuelle.

---

# 30. Retour Marie si nécessaire

Marie intervient seulement si :

- une heure la concerne ;
- un alibi a été retiré ;
- une règle J17 exige l’information ;
- Nico lui a répondu factuellement ;
- Player choisit de reconnaître ce que J20 change.

## Reconnaissance Player

**Player → Marie**

> Nico ne me couvrira plus sur une heure ou un lieu. si tu lui demandes un fait auquel il était présent, il répondra

**Marie**

> D’accord.

Puis :

> Ce n’est pas à lui de tenir notre règle.

Cette phrase ne critique pas Nico.

Elle replace la responsabilité sur le couple.

## Player accuse Nico auprès de Marie

**Player**

> Nico a décidé de se mêler de tout

**Marie**

> Il m’a donné une heure.

**Marie**

> Le reste venait de toi.

---

# 31. Deuxième visuel — Femme ou trace concernée

**VISUEL J20-V2 — À PRODUIRE PLUS TARD**

```text
type:
IMAGE_DE_SCÈNE
ou PHOTO_DIÉGÉTIQUE EXISTANTE

center:
une femme adulte concernée par la branche

candidates:
Marie dans son monde social
Mathilde dans un contexte direct et non domestique
Sandra dans son après-coup
Pauline dans sa vie officielle
Raphaëlle dans son processus ordinaire

function:
montrer que la personne possède sa propre vie
et ne constitue pas un objet échangé entre les hommes

audience:
respect du contenu d’origine

saving:
aucun droit nouveau

circulation:
aucune extension
```

Une photographie n’est utilisée que si elle existe déjà avec l’audience correcte.

Sinon, utiliser une image de scène non diégétique.

---

# 32. Troisième visuel — Conséquence de réseau

**VISUEL J20-V3 — À PRODUIRE PLUS TARD**

```text
type:
IMAGE_DE_SCÈNE
ou TRACE_DIÉGÉTIQUE

function:
matérialiser la conséquence secondaire unique

possibilités:
heure confirmée
message non transféré
contenu supprimé
Bastien recevant un fait limité
Jeff restant hors d’une information non due
Maud dans son rôle réel
Marie reprenant la responsabilité du couple
fil d’alibi fermé

audience:
strictement limitée aux personnes concernées

circulation:
false sauf décision antérieure explicite
```

---

# 33. Quatrième visuel optionnel — Retour ordinaire

```text
type:
IMAGE_DE_SCÈNE

center:
Marie ou la relation dominante de la partie

function:
montrer la vie ordinaire après la définition de Nico

examples:
foyer selon règle J17
Marie à La Verrière
Sandra avec son image rangée
Pauline avec Bastien
Raphaëlle préparant lundi
Mathilde chez elle

circulation:
false
```

Les visuels de J20 restent majoritairement centrés sur les femmes adultes et leur agence, malgré le pivot Nico.

---

# 34. Connaissances de sortie

## Nico sait

Uniquement selon la partie :

- ce que Player lui a dit directement ;
- les faits auxquels il a assisté ;
- l’état précis d’un alibi ;
- une règle d’audience si elle a été formulée ;
- son propre désir ;
- la limite qu’il fixe.

Il ne connaît jamais automatiquement l’ensemble du réseau.

## Player sait

- ce que Nico accepte encore de porter ;
- ce qu’il refuse ;
- s’il existe une dette ;
- si Nico est rival ;
- si Nico reste confident ;
- si l’amitié est suspendue ;
- si un regard futur pourrait être autorisé.

## Marie, Sandra, Mathilde, Pauline et Raphaëlle

Ne connaissent la position de Nico que si :

- elles sont directement concernées ;
- Player leur en parle selon une obligation réelle ;
- Nico leur répond sur un fait ;
- une trace crédible existe.

## Bastien, Jeff et Maud

Ne deviennent pas omniscients.

Ils reçoivent uniquement les informations auxquelles ils ont une source légitime.

---

# 35. États de sortie Nico

Un état principal unique doit exister.

## Garde-fou

```text
amitié active
alibi fermé
Nico répond aux faits
```

## Confident limité

```text
Player peut parler de lui-même
aucune image
aucune preuve
aucune couverture
```

## Rival honnête

```text
attirance nommée
aucune action cachée
la femme concernée décide
```

## Complice conscient

```text
mensonge ou secret partagé
dette réciproque
route sombre
```

## Partenaire d’un regard autorisé

```text
audience explicite
règle de conservation
aucun droit futur
```

## Témoin compromis

```text
Nico connaît un fait ou a vu une trace
aucune diffusion
personne concernée informée si nécessaire
```

## Ami prenant ses distances

```text
confidences fermées
contact social limité
réparation future non garantie
```

Aucun état ne devient :

```text
Nico attend la prochaine femme que Player lui montrera
```

---

# 36. État du réseau après J20

J20 doit confirmer :

- les principaux alibis sont fermés ou consciemment actifs ;
- les copies non autorisées sont supprimées ;
- les personnes représentées ont été informées ;
- Bastien et Jeff ne possèdent que leurs connaissances légitimes ;
- Maud reste une personne autonome ;
- Nico ne porte pas toutes les routes ;
- aucune dette urgente non identifiée ne précède J21.

Une dette peut rester instable.

Elle doit être nommée.

---

# 37. Handoff vers J21

J21 devient :

```text
Lundi — La dernière photo change de sens
```

J21 commence avec :

- un état provisoire du couple ;
- Mathilde hors du foyer ;
- un état Sandra clair ;
- une direction Pauline ;
- une direction Raphaëlle ;
- une position Nico ;
- les partenaires et témoins dans des états crédibles ;
- aucune urgence d’audience non traitée ;
- aucune nouvelle révélation nécessaire.

La trace finale peut être sélectionnée parmi les images déjà établies :

- photographie du déjeuner Sandra ;
- photographie de groupe ;
- image Marie / La Verrière ;
- image Mathilde / foyer ;
- version Pauline ;
- image Raphaëlle ;
- trace sociale impliquant Nico ;
- absence d’un contenu supprimé.

J20 ne choisit pas cette trace par menu.

La route dominante, le couple et les conséquences déterminent naturellement celle qui porte le plus de sens.

---

# 38. Promesses futures possibles

Nico peut rester :

- garde-fou ;
- ami ordinaire ;
- rival possible ;
- confident ;
- membre potentiel d’un cadre autorisé ;
- complice sombre ;
- témoin dont la confiance devra être réparée.

Une future configuration à plusieurs adultes exige toujours :

- désir direct des femmes concernées ;
- consentement actuel ;
- audience ;
- rôles ;
- limites ;
- absence de contact sexuel ou de désir entre Nico et Player ;
- après-coup.

J20 ne déclenche pas cette configuration.

---

# 39. Audit de la voix Nico

Nico doit conserver :

- des messages courts ;
- du concret ;
- une provocation suivie d’une vraie question ;
- une capacité à reconnaître son intérêt ;
- un humour qui s’arrête lorsque la limite devient réelle ;
- une vulnérabilité sans changement d’orientation sexuelle.

Exemples :

> Tu attends quoi de moi, exactement ?

> Je ne vais pas faire le saint. Mais je peux quand même te dire non.

> Tu peux me dire que tu la veux. Tu ne m’envoies pas ses photos pour m’expliquer.

> Je ne suis pas ton coffre-fort contre elle.

> Elle. Pas toi qui me l’accordes.

> Je n’aime pas le type que je deviens dans ce fil.

---

# 40. Test sans nom

```text
Je ne vais pas faire le saint. Mais je peux quand même te dire non.
→ Nico

Je préfère que les permissions restent en phrases séparées.
→ Raphaëlle, pas Nico

Je ne suis pas ton coffre-fort contre elle.
→ Nico

Notre très mauvaise égalité.
→ Pauline, pas Nico

Elle. Pas toi qui me l’accordes.
→ Nico

L’image ne décide pas. Ma décision de la retirer, si.
→ Sandra, pas Nico
```

---

# 41. Audit hétérosexuel

J20 ne contient :

- aucune attirance Nico / Player ;
- aucune tension romantique masculine ;
- aucun contact sexuel entre eux ;
- aucune proposition bisexuelle ;
- aucune proximité de groupe transformée en contact masculin ;
- aucune blague laissant entendre une route cachée.

La charge entre eux peut contenir :

- rivalité ;
- jalousie ;
- confiance ;
- dette ;
- images ;
- regards partagés ;
- femmes désirées ;
- peur de perdre l’amitié.

Elle reste non romantique et non sexuelle entre les hommes.

---

# 42. Audit anti-générique

J20 évite :

- Nico comme machine à punchlines ;
- Nico comme juge omniscient ;
- Nico connaissant toutes les routes ;
- une liste de toutes les femmes ;
- Marie ou Mathilde comme propriété transférable ;
- une image publique comme permission de transfert ;
- une nouvelle image intime pour conclure l’amitié ;
- un alibi sans dette ;
- un rival automatiquement traître ;
- un garde-fou moralement pur ;
- une attirance présentée comme consentement ;
- une configuration de groupe créée par Player seul ;
- un partenaire masculin humilié comme récompense ;
- une caméra cachée ;
- l’alcool comme accès ;
- Nico devenant uniquement l’outil du fantasme de Player ;
- une révélation bisexuelle ;
- une résolution où Nico ne choisit rien.

---

# 43. Critères de validation J20

- [ ] Nico possède une vie et un monde autonomes ;
- [ ] une seule conséquence secondaire forte est développée ;
- [ ] Nico ne connaît que des faits attribuables ;
- [ ] il ne devient pas juge du réseau ;
- [ ] son attirance pour Marie ou Mathilde peut être reconnue ;
- [ ] cette attirance ne crée aucune permission ;
- [ ] Marie ou Mathilde décide directement de toute suite ;
- [ ] aucune route Nico / Player romantique ou sexuelle ;
- [ ] l’alibi possède un état clair ;
- [ ] les confidences possèdent un état clair ;
- [ ] les images possèdent un état clair ;
- [ ] une personne représentée est informée si son audience a changé ;
- [ ] aucune nouvelle copie n’est créée ;
- [ ] une preuve réciproque n’est pas externalisée par défaut ;
- [ ] Nico peut être garde-fou ;
- [ ] Nico peut être confident ;
- [ ] Nico peut être rival ;
- [ ] Nico peut être complice sombre ;
- [ ] Nico peut être témoin compromis ;
- [ ] Nico peut prendre ses distances ;
- [ ] un refus ferme réellement l’attente ;
- [ ] toute co-présence arrête le chat ;
- [ ] aucun dialogue oral n’est transcrit ;
- [ ] aucune nouvelle progression adulte ;
- [ ] trois contenus visuels minimum ;
- [ ] les visuels respectent les audiences ;
- [ ] J21 peut commencer sans urgence majeure inconnue.

---

# 44. Résumé canonique candidat

J20 revient au fil entre Nico et Player.

Ce fil contenait au départ :

- des places gardées ;
- des horaires ;
- des plaisanteries ;
- une amitié réelle.

Il a pu recevoir ensuite :

- des confidences ;
- des descriptions ;
- de la jalousie ;
- une demande d’image ;
- un alibi ;
- un mensonge ;
- une dette.

Nico demande ce que Player attend encore de lui.

Player peut :

- demander que Nico reste son ami sans devenir son alibi ;
- demander à Nico ce qu’il accepte réellement de porter ;
- ou utiliser encore l’amitié comme couverture.

Nico doit alors reconnaître qu’il n’est pas innocent dans toutes ses questions.

Marie lui plaît.

Mathilde lui plaît.

Le regard domestique de Player a parfois nourri sa curiosité.

Ses conseils pouvaient être utiles tout en créant une place pour lui.

Il choisit ensuite une position :

- garde-fou ;
- confident limité ;
- rival honnête ;
- complice conscient ;
- partenaire d’un regard autorisé ;
- témoin compromis ;
- ou ami prenant ses distances.

Nico ne reçoit aucune femme de Player.

Il ne crée le consentement de personne.

Il ne transforme pas une image publique en accès privé.

Il peut désirer Marie sans la trahir en secret.

Il peut désirer Mathilde sans demander à Player de lui transmettre sa vie domestique.

Il peut entrer un jour dans un regard ou un cadre adulte uniquement si les femmes concernées le choisissent directement.

Il peut aussi reconnaître que l’amitié devient mauvaise pour lui et s’en retirer.

À la fin de J20, Nico n’est plus seulement le type qui dit la vérité que Player évite.

Il a nommé :

- son désir ;
- son intention ;
- les personnes qui doivent consentir ;
- et la responsabilité qu’il accepte ou refuse.

Le réseau possède désormais suffisamment d’états clairs pour que J21 ne révèle rien de nouveau.

La finale peut seulement reprendre une trace ancienne et montrer qu’elle ne signifie plus la même chose.

> **L’amitié peut porter une vérité, un désir ou une dette. Elle cesse d’être une amitié intacte lorsqu’on lui demande de porter à la place de quelqu’un sa permission, son mensonge ou sa responsabilité.**
