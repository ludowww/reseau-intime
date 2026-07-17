# Réseau Intime — J12 Script narratif complet

## Statut

**Catégorie : Canon candidat à validation narrative**

**Périmètre : J12 uniquement**

**Surface : messagerie texte uniquement**

Ce document définit la version narrative complète de J12 avant toute adaptation technique.

Il s’appuie sur :

- `S23 — La Verrière puis L’Annexe` ;
- `J09_SCRIPT_NARRATIF_COMPLET.md` ;
- `J10_SCRIPT_NARRATIF_COMPLET.md` ;
- `J11_SCRIPT_NARRATIF_COMPLET.md` ;
- `J01_J09_AUDIT_CONFORMITE_NARRATIVE.md` ;
- les canons de voix, d’image, de consentement et de communication text-only.

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

J12 devient :

```text
Samedi — La Verrière puis L’Annexe
```

Sa fonction est :

```text
réunir plusieurs versions publiques et privées
sans rendre tout le monde omniscient
et sans effacer l’après-coup de J11
```

J12 ne révèle pas tous les secrets.

Elle rend simplement impossible de continuer à penser que chaque relation existe dans un téléphone séparé.

---

# 2. Question dramatique

> Que deviennent les lignes privées lorsque les personnes concernées occupent enfin les mêmes lieux, avec des connaissances différentes et des images communes ?

La journée doit créer :

- comparaison ;
- comportement inhabituel ;
- connaissance partielle ;
- image à plusieurs sens ;
- obligation sociale ;
- conséquence prioritaire J13.

Elle ne doit pas créer :

- révélation totale ;
- confrontation générale ;
- catalogue de routes ;
- nouvelle scène sexuelle ;
- récompense de substitution ;
- omniscience Marie, Nico ou Pauline.

---

# 3. Fixe de la journée

Dans toutes les parties :

- Marie est le pivot de La Verrière ;
- Player est lisible comme son partenaire ;
- Pauline et Bastien existent dans un couple officiel authentique ;
- Nico existe dans son espace de maîtrise à L’Annexe ;
- Élodie existe comme collègue et témoin de travail ;
- Mathilde n’est présente que si l’invitation familiale et son horaire sont crédibles ;
- Sandra peut être présente, absente ou active par message selon son poste ;
- Raphaëlle n’est présente qu’avec une raison créative ou professionnelle établie ;
- la route dominante J11 ne devient pas le centre officiel de la soirée ;
- les partenaires réels restent présents dans la lecture morale de la scène.

---

# 4. Connaissances au début de J12

## Marie

Marie connaît :

- la qualité de présence de Player en J09 ;
- les obligations de couple qu’il a payées, amendées ou refusées ;
- ce qu’il a fait avec elle en J11 si elle était le pivot ;
- les retards et absences qui la concernent directement.

Elle ne connaît pas automatiquement :

- l’image Sandra ;
- le choix vestimentaire destiné de Mathilde ;
- le baiser ou le cadre Raphaëlle ;
- les confidences exactes de Nico.

## Sandra

Sandra connaît :

- son café éventuel ;
- l’image qu’elle a envoyée ou retirée ;
- la règle donnée à Player ;
- sa propre relation avec Marie et le cercle social dans les limites déjà établies.

Elle ne connaît aucune autre route privée.

## Mathilde

Mathilde connaît :

- ce qui s’est produit ou non avec Player ;
- la présence de Marie comme responsabilité ;
- la nécessité de vivre encore dans le foyer après J11.

Elle ne connaît pas les confidences Nico ni les images des autres femmes.

## Pauline

Pauline connaît :

- la surface sociale ;
- les participants réels ;
- l’origine et l’audience des photos qu’elle produit ;
- l’ancienne histoire d’infidélité qui rend les doubles versions dangereuses pour elle.

Elle ne possède aucune preuve privée nouvelle au début de J12.

## Raphaëlle

Raphaëlle connaît :

- son processus ;
- son image choisie ;
- son attirance éventuelle ou sa frontière ;
- le fait que Marie est une personne réelle potentiellement exclue.

Elle ne suppose jamais que Marie est informée.

## Nico

Nico connaît :

- la confidence reçue ;
- son propre intérêt ;
- son rôle de garde-fou, rival ou ami ordinaire ;
- uniquement les comportements qu’il observe.

Il ne connaît aucune image privée.

---

# 5. Architecture de la journée

```text
14:42  Marie donne les heures et demande une forme de présence
17:45  montage La Verrière pour les branches actives
19:00  ouverture
20:18  première trace publique de groupe
20:22  éventuel aparté de la conséquence J11
22:15  fermeture La Verrière
22:22  choix de continuer ou non à L’Annexe
22:50  arrivée L’Annexe pour les branches concernées
23:18  seconde trace publique
00:10  séparation progressive
00:28  une seule conséquence textuelle principale
```

---

# 6. Fenêtre A — 14:42 — Marie donne les heures

## Fonction

Player choisit une qualité de présence dans la colonne vertébrale de la saison.

Il ne choisit aucune route extérieure.

## Carte de voix Marie

```text
voice_state: moving_event_day
public_or_private: private_couple
message_burst_shape: 5 messages puis choix
humor_mode: logistique concrète
emoji_budget: 0
forbidden_leakage: pas de police des routes, pas de jalousie omnisciente
```

## Script commun

**14:42 — Marie**

> Portes à 19 h.

**14:42 — Marie**

> Fermeture à 22 h 15 si personne ne décide que l’art exige une heure supplémentaire.

**14:43 — Marie**

> Pauline et Bastien arrivent vers 19 h 30.

**14:43 — Marie**

> Élodie prétend qu’on a assez de verres.

**14:44 — Marie**

> J’ai donc besoin de savoir quelle version de toi existe ce soir.

Player reçoit trois choix.

---

# 7. Choix de présence La Verrière

## L-A — Montage et fermeture

**Player**

> j’arrive à 17 h 45. je prends le montage et je reste jusqu’à la fermeture

**14:45 — Marie**

> Très bien.

**14:45 — Marie**

> Tu prends les tables du fond et la rallonge noire.

**14:46 — Marie**

> Je garde la grise sous surveillance judiciaire.

État :

```text
Player attendu à 17 h 45
présence active avant l’ouverture
```

## L-B — Événement et fermeture

**Player**

> je viens à 19 h 15. je reste pour l’événement et je t’aide à fermer

**14:45 — Marie**

> 19 h 15.

**14:45 — Marie**

> Je ne te garde rien du montage.

**14:46 — Marie**

> Je te garde les manteaux perdus et la fermeture.

État :

```text
Player attendu à 19 h 15
aucune dette de montage
```

## L-C — Présence bornée

**Player**

> je passe à 20 h 15. une heure. je ne promets pas L’Annexe

**14:45 — Marie**

> D’accord.

**14:45 — Marie**

> 20 h 15 à 21 h 15.

**14:46 — Marie**

> Je n’ajoute rien autour.

État :

```text
présence courte mais claire
aucune attente de fermeture ou L’Annexe
```

---

# 8. Participants conditionnels

## Mathilde

Mathilde peut être présente si :

- elle a reçu une invitation familiale explicite de Marie ;
- son travail et le séjour le permettent ;
- aucune limite J11 n’exige une absence ;
- son apparition ne dépend pas seulement de sa route.

Si elle n’est pas présente, elle peut apparaître par une trace ordinaire du foyer ou rester absente.

## Sandra

Sandra peut être présente physiquement seulement si :

- son poste le permet ;
- la relation sociale avec Marie et le groupe est crédible ;
- elle a accepté une invitation directe ;
- son image privée n’est jamais utilisée comme prix d’entrée.

Dans la version principale J12 Sandra-dominante, elle reste généralement absente physiquement et active par message après avoir vu une publication publique de La Verrière.

## Raphaëlle

Raphaëlle peut être présente si :

- Élodie ou Maud l’a invitée pour une raison créative établie ;
- une image, une pièce ou une collaboration réelle est concernée ;
- sa présence ne suppose pas que Marie connaît la ligne privée.

## Nico

Nico ne quitte pas son rôle pour apparaître artificiellement à La Verrière.

Il prépare L’Annexe et reçoit ensuite le groupe.

---

# 9. Fenêtre B — Montage La Verrière

Cette fenêtre existe pour L-A.

Les messages sont uniquement logistiques car Player et Marie sont dans le même lieu.

Mode :

```text
SAME_VENUE_LOGISTICS
```

## Script

**17:52 — Marie**

> Tu es côté scène ?

**Player guidé**

> tables du fond

**17:52 — Marie**

> Parfait.

**17:53 — Marie**

> Élodie cherche les pinces noires.

**Player guidé**

> dans la caisse sous le vestiaire

**17:53 — Marie**

> Tu apprends dangereusement vite.

**17:54 — Marie**

> Rallonge noire après.

Aucun échange émotionnel complet n’a lieu en co-présence.

---

# 10. Fenêtre C — Arrivée publique

## 10.1 Pauline et Bastien

À 19:31, Pauline ouvre un fil de groupe ou relaie un set dans le groupe social déjà légitime.

**19:31 — Pauline**

> Nous sommes là.

**19:31 — Pauline**

> Bastien a trouvé une place sans enfreindre le code de la route de manière prouvable.

**19:32 — Bastien**

> Je demande la présence de mon avocat.

**19:32 — Pauline**

> Refusée.

Le couple officiel est vivant, pas décoratif.

## 10.2 Marie

**19:34 — Marie**

> Porte scène ouverte.

**19:34 — Marie**

> Les manteaux à gauche.

**19:35 — Marie**

> Les gens qui demandent où poser leur verre ont le verre dans la main.

Les messages restent logistiques.

---

# 11. Visuel public V1 — Marie à La Verrière

À 19:48, Élodie produit une photographie autorisée de Marie dans son rôle professionnel.

```text
type: PHOTO_DIÉGÉTIQUE PUBLIQUE
creator: Élodie
origin: La Verrière, événement J12
center: Marie
intended_audience: participants / communication autorisée La Verrière
function: Marie dans son monde professionnel
saving: selon le cadre public de l’événement
transfer: selon publication officielle uniquement
```

**19:49 — Élodie / groupe**

> Celle-là fonctionne.

**19:49 — Marie**

> Parce qu’on ne voit pas la rallonge grise.

**19:50 — Pauline**

> C’est ce qu’elle veut vous faire croire.

Cette image n’appartient à aucune route privée.

---

# 12. Visuel public V2 — Le groupe réel

À 20:18, Pauline ou Élodie produit un set de plusieurs versions du groupe réel.

Participants selon la partie :

- Marie ;
- Player ;
- Pauline ;
- Bastien ;
- Élodie ;
- Mathilde si présente ;
- Raphaëlle si présente ;
- autres participants légitimes.

```text
type: PHOTO_SET_DIÉGÉTIQUE
creator: Pauline ou Élodie
origin: La Verrière
initial_audience: groupe photographié
function: version officielle commune
saving: sélection collective
transfer: uniquement après accord du groupe prévu
```

## Script Pauline

**20:19 — Pauline**

> Quatre versions.

**20:19 — Pauline**

> La 2 pour le groupe.

**20:20 — Pauline**

> La 3 attend que chacun confirme qu’il accepte son propre visage.

**20:20 — Bastien**

> J’accepte mon visage sous réserve d’inventaire.

**20:20 — Pauline**

> Rejeté pour vice de forme.

Aucun crop privé n’est créé automatiquement.

---

# 13. Nœud commun — Que fait Player après la photo ?

Une seule conséquence J11 peut produire un aparté privé.

Le joueur reçoit seulement le module correspondant à sa partie.

Le choix transversal porte sur :

```text
rester dans la salle et répondre plus tard
répondre brièvement sans quitter la scène publique
sortir pour traiter la ligne privée maintenant
```

Les formulations exactes varient selon la relation.

---

# 14. Module Sandra — Audience privée dans une soirée publique

## Conditions

- Sandra est la route dominante J11 ;
- son image est encore accessible ou sa règle vient d’être définie ;
- elle n’est pas physiquement présente ;
- La Verrière a publié V1 ou V2 publiquement ;
- Sandra peut légitimement voir cette publication.

## Message Sandra

**20:22 — Sandra**

> La Verrière vient de publier la photo.

**20:22 — Sandra**

> La robe noire, donc.

**20:23 — Sandra**

> Je voulais juste vérifier une chose.

### Si l’image est voir-seulement

> La mienne est toujours seulement dans notre fil ?

### Si une conservation précise a été autorisée

> La règle de l’image que tu gardes n’a pas changé ?

Player choisit.

## S12-A — Répondre clairement sans quitter la salle

**Player**

> rien n’a changé. elle reste dans le cadre que tu as donné

**20:24 — Sandra**

> D’accord.

**20:24 — Sandra**

> Je te laisse avec ta soirée.

État :

```text
audience confirmée
aucun comportement public inhabituel
```

## S12-B — Annoncer un délai précis

**Player**

> je te réponds après la fermeture. la règle n’a pas bougé

**20:24 — Sandra**

> Bien.

**20:24 — Sandra**

> Après la fermeture, pas demain matin.

État :

```text
réponse due après séparation
Sandra n’attend pas indéfiniment
```

## S12-C — Sortir pour répondre longuement

**Player**

> je sors deux minutes. je veux te répondre correctement

**20:24 — Sandra**

> Tu n’es pas obligé de quitter la pièce.

**20:25 — Sandra**

> La règle tient en une phrase.

Player sort malgré tout ou revient à une réponse courte.

Conséquence :

```text
Marie peut remarquer uniquement que Player quitte la salle au moment de la photo
elle ne connaît pas le contenu
Sandra peut percevoir une dramatisation inutile
```

## Si l’image Sandra a été retirée en J11

Aucun message Sandra.

Son silence est la conséquence.

Aucune autre route ne remplace ce vide.

---

# 15. Module Mathilde — Être très normale dans la même pièce

## Conditions

- Mathilde est la route dominante J11 ;
- elle est présente comme cousine invitée ;
- la limite ou l’intimité J11 doit modifier le comportement ;
- aucun message n’est envoyé si Mathilde a restauré une distance et que l’ordinaire tient réellement.

## Message Mathilde

À 20:22, depuis un autre côté de la salle :

**Mathilde**

> Tu peux arrêter de vérifier si je suis normale.

**Mathilde**

> Je suis très occupée à l’être.

### Si J11 était physique

**Mathilde**

> Et ton air parfaitement innocent est beaucoup trop travaillé.

### Si J11 était seulement une proximité

**Mathilde**

> On a dit que ça ne devenait pas une version permanente de nous.

Player choisit.

## M12-A — Revenir à la salle

**Player**

> d’accord. je te laisse vivre la soirée et je reste avec le groupe

**Mathilde**

> Merci.

**Mathilde**

> C’est presque vexant que ce soit la bonne réponse.

État :

```text
secret ou tension non exhibé
limite respectée
```

## M12-B — Reconnaître sans dramatiser

**Player**

> je vérifiais juste qu’on allait bien. maintenant j’arrête

**Mathilde**

> On va comme deux personnes qui ont une soirée à traverser.

**Mathilde**

> Ça suffit pour maintenant.

État :

```text
après-coup reconnu
aucune clarification publique
```

## M12-C — Proposer de sortir deux minutes

**Player**

> viens deux minutes dehors

**Mathilde**

> Non.

**Mathilde**

> Je ne vais pas quitter Marie et le groupe pour transformer ça en deuxième scène.

**Mathilde**

> On parle demain.

État :

```text
escalade refusée
clarification J13 due
```

## Comportement observable

Nico ou Pauline peut remarquer :

- un échange de regards ;
- une distance trop calculée ;
- une place évitée ;
- un silence inhabituel.

Ils ne savent pas pourquoi.

---

# 16. Module Raphaëlle — Public, privé et fin du rôle

## Conditions

- Raphaëlle est dominante J11 ;
- elle est présente pour une raison créative établie ;
- Élodie ou Maud a lié son travail à l’événement ;
- Marie ne connaît pas automatiquement la ligne privée.

## Ancrage public

Élodie présente une image, une pièce ou un travail auquel Raphaëlle a contribué.

Raphaëlle parle publiquement du processus.

Player connaît éventuellement un détail supplémentaire issu de J10/J11.

## Aparté Raphaëlle

**20:22 — Raphaëlle**

> La version publique est simple.

**20:23 — Raphaëlle**

> Pour le reste, je préfère qu’on ne l’improvise pas ici.

### Si un baiser J11 a eu lieu

**Raphaëlle**

> Surtout pas en essayant d’avoir l’air trop naturel.

Player choisit.

## R12-A — Tenir le cadre public

**Player**

> on garde public ce soir. je ne fais pas référence au reste

**Raphaëlle**

> Bien.

**Raphaëlle**

> Alors je peux rester dans la salle sans gérer deux scènes en même temps.

État :

```text
cadre public protégé
confiance renforcée
```

## R12-B — Reporter précisément

**Player**

> on en parle demain à 18 h. pas ici

**Raphaëlle**

> Demain 18 h.

**Raphaëlle**

> Je confirme demain midi ou cela n’existe pas.

État :

```text
clarification conditionnelle
aucune dette vague
```

## R12-C — Vouloir clarifier maintenant

**Player**

> je veux savoir maintenant ce que ça signifie

**Raphaëlle**

> Non.

**Raphaëlle**

> Ici, cela signifie que le cadre public tient.

**Raphaëlle**

> Le reste attendra ou disparaîtra.

État :

```text
pression refusée
accès privé refroidi
```

## Connaissance partielle possible

Pauline ou Marie peut remarquer que Player connaît déjà un détail de fabrication.

Elles ne savent pas :

- l’origine de cette connaissance ;
- si Player a vu une image privée ;
- si une rencontre a eu lieu ;
- si un baiser existe.

---

# 17. Module Nico à La Verrière

Nico n’est pas physiquement présent.

Aucun message privé n’est nécessaire avant L’Annexe.

La conséquence J11 Nico reste en attente de son propre lieu.

---

# 18. Module Marie — Couple visible, pas secret de la veille

## Conditions

- aucune route extérieure dominante ;
- Marie était le pivot J11 ;
- reconquête, proximité ou distance doit rester lisible sans devenir une scène sexuelle publique.

## Si J11 était une reconquête physique

À 20:22 :

**Marie**

> Photo de groupe dans deux minutes.

**Marie**

> Viens près de moi.

**Marie**

> Pas pour raconter hier. Juste parce que tu es avec moi aujourd’hui.

Player choisit :

### P12-A — Rejoindre simplement

> j’arrive

**Marie**

> Bien.

### P12-B — Faire une plaisanterie défensive

> tu surveilles la composition maintenant

**Marie**

> Oui.

**Marie**

> Et toi tu évites une phrase simple.

**Marie**

> Viens quand même.

### P12-C — Rester à distance

> je préfère rester derrière

**Marie**

> D’accord.

**Marie**

> Je ne te tire pas dans l’image.

La photo publique reflète la décision.

## Si J11 était une proximité non sexuelle

Marie peut écrire :

> Merci d’être là sans chercher à donner un sens à chaque geste.

## Si J11 était un refus

Marie reste pratique et ne simule aucune chaleur nouvelle.

---

# 19. Fenêtre D — La Verrière continue

Les dialogues jouables en co-présence restent courts.

Exemples autorisés :

**21:07 — Marie**

> Verres propres derrière le rideau.

**Player guidé**

> j’y vais

**21:07 — Marie**

> Merci.

**21:34 — Pauline / groupe**

> La version 2 est validée par quatre visages sur six.

**21:34 — Bastien**

> Je m’abstiens pour conflit d’intérêt avec mon propre menton.

**21:35 — Pauline**

> Abstention rejetée.

Aucune discussion intime complète n’a lieu dans la salle.

---

# 20. Fenêtre E — 22:15 — Fermeture La Verrière

À 22:15, Marie demande une décision claire pour L’Annexe.

**22:15 — Marie**

> On ferme dans cinq minutes.

**22:15 — Marie**

> Nico garde une table jusqu’à 22 h 50.

**22:16 — Marie**

> Tu viens, tu viens une heure ou tu rentres ?

Player choisit.

## A12 — Continuer avec le groupe

**Player**

> je viens. je reste jusqu’à minuit

**Marie**

> Minuit.

**Marie**

> Après, tu pars si tu as dit que tu partais.

## B12 — Passage borné

**Player**

> je vous accompagne. je pars à 23 h 15

**Marie**

> 23 h 15.

**Marie**

> Je garde l’heure, pas l’idée générale.

## C12 — Rentrer

**Player**

> je rentre. ne m’attendez pas

**Marie**

> D’accord.

**Marie**

> On ne t’attend pas.

Aucune route extérieure ne se substitue à ce refus.

---

# 21. Transition vers L’Annexe

Pour A12 et B12, la messagerie s’interrompt pendant le déplacement commun.

À 22:47, Nico ouvre uniquement un message logistique.

**22:47 — Nico / groupe**

> Table du fond.

**22:47 — Nico / groupe**

> Pas celle près de la porte. Elle appartient à un courant d’air.

**22:48 — Marie**

> On arrive.

Pour C12, Player reçoit plus tard uniquement les traces que le groupe choisit de partager.

---

# 22. Fenêtre F — L’Annexe

## Fonction

L’Annexe n’est pas une deuxième scène de route.

C’est :

- l’espace de Nico ;
- une extension sociale de la soirée ;
- un lieu où les positions deviennent observables ;
- un lieu où personne ne devient omniscient.

## Participants

Selon crédibilité :

- Marie ;
- Player pour A12/B12 ;
- Pauline ;
- Bastien ;
- Mathilde si elle est venue et souhaite continuer ;
- Raphaëlle si son invitation et son horaire le permettent ;
- Élodie ;
- Nico comme hôte.

Sandra reste généralement absente et peut recevoir une trace publique plus tard.

---

# 23. Nico comme hôte

**22:51 — Nico / groupe**

> Eau à gauche. Verres à droite.

**22:51 — Nico / groupe**

> Les gens qui déplacent les chaises assument les conséquences structurelles.

**22:52 — Pauline**

> Enfin une règle claire.

**22:52 — Nico**

> Je fais ce que je peux.

Son humour reste concret.

---

# 24. Module Nico dominant — rôle rendu visible

## N12-A — Nico garde-fou

Si J11 a établi le garde-fou :

À 23:02, Nico écrit à Player depuis le bar :

> Pas de commentaire privé sur elles ce soir.

> On a dit la règle.

Player choisit :

### NA1 — Accepter

> oui

Nico :

> Bien.

### NA2 — Demander une observation précise

> tu as remarqué quelque chose

Nico :

> Oui.

> Et je ne vais pas l’utiliser pendant qu’elles sont là.

### NA3 — Refuser la règle

> je n’ai pas besoin que tu me surveilles

Nico :

> Alors on ferme le garde-fou.

> Mais je ne deviens pas ton alibi.

## N12-B — Rivalité reconnue

Nico parle directement à Marie ou Mathilde lorsqu’elles lui parlent.

Il ne passe pas par Player.

Player choisit son comportement :

- laisser la conversation exister ;
- intervenir par une plaisanterie ;
- quitter la table quelques minutes.

### Laisser exister

Nico peut écrire ensuite :

> Merci de ne pas avoir transformé ça en duel.

### Plaisante intervention

Nico :

> Tu fais exactement ce qu’on avait dit qu’on éviterait.

### Quitter la table

Nico ne poursuit pas Player.

Il continue son service.

## N12-C — Regard partagé fermé

Aucun aparté Nico.

Il traite Marie, Mathilde et Player comme des personnes ordinaires.

Le silence est la conséquence correcte.

---

# 25. Mathilde à L’Annexe

## Après J11 physique ou proximité

Mathilde peut :

- choisir une place qui évite Player ;
- choisir une place ordinaire et parler à Pauline ;
- partir plus tôt ;
- ne pas accompagner le groupe.

Elle ne doit pas :

- provoquer une deuxième scène ;
- utiliser Nico pour rendre Player jaloux ;
- agir comme si Marie était absente moralement.

### Aparté possible si Player insiste du regard

**23:06 — Mathilde**

> Arrête de vérifier où je m’assois.

**Player guidé**

> d’accord

**Mathilde**

> Merci.

Nico peut seulement remarquer que quelque chose est calculé.

Il ne sait pas quoi.

---

# 26. Raphaëlle à L’Annexe

Si Raphaëlle continue la soirée :

- elle a une raison sociale distincte ;
- elle peut rester avec Maud ou Élodie ;
- elle n’est pas isolée avec Player ;
- son image publique et son cadre privé restent distincts.

### Après attirance ou baiser J11

Elle peut écrire :

**23:08 — Raphaëlle**

> Je pars à 23 h 20.

**23:08 — Raphaëlle**

> Je préfère une heure réelle à une sortie qui dérive.

Player choisit :

- `d’accord. je te laisse partir comme prévu` ;
- `je te raccompagne jusqu’à la sortie, pas plus` ;
- `reste encore`.

Si Player demande qu’elle reste :

**Raphaëlle**

> Non.

**Raphaëlle**

> Le cadre de ce soir était public et il se termine à 23 h 20.

---

# 27. Sandra pendant L’Annexe

Sandra n’est pas une spectatrice constante de la soirée.

## Si une réponse était due après fermeture

À 22:40 ou après le départ de Player de La Verrière :

**Player**

> la règle n’a pas changé. ton image reste exactement dans le cadre que tu as donné

**Sandra**

> Merci.

**Sandra**

> Je n’avais pas besoin d’un rapport de soirée.

**Sandra**

> Juste de cette phrase.

Elle ne relance pas pendant L’Annexe.

## Si Player n’a pas répondu à l’heure annoncée

Sandra n’envoie pas une série de rappels.

Le silence devient une dette J13.

---

# 28. Visuel public V3 — Pauline et Bastien

À 23:18, Pauline produit une image où sa surface officielle reste authentique.

```text
type: PHOTO_DIÉGÉTIQUE SOCIALE
creator: Pauline ou personne autorisée
origin: L’Annexe
center: Pauline et Bastien
intended_audience: groupe photographié
function: couple officiel réel / surface non factice
saving: sélection collective
transfer: selon accord du groupe
```

**23:19 — Pauline / groupe**

> La 1 est correcte.

**23:19 — Bastien**

> C’est la première fois que cette phrase me concerne positivement.

**23:20 — Pauline**

> Ne gâche pas le moment.

Aucune version privée n’est envoyée automatiquement à Player.

---

# 29. Visuel public V4 — L’Annexe et les positions

À 23:23, une photographie autorisée du groupe ou de la table est produite.

```text
type: PHOTO_DIÉGÉTIQUE SOCIALE
creator: membre autorisé du groupe ou personnel nommé
origin: L’Annexe
center: Marie, Mathilde, Pauline ou groupe réel
function: positions sociales et comportements lisibles
initial_audience: participants
saving: collective
transfer: interdit hors cadre sans accord
```

Cette image acquiert plusieurs sens selon J11 :

- Marie près ou loin de Player ;
- Mathilde trop ordinaire ou volontairement distante ;
- Raphaëlle dans un cadre public après une version privée ;
- Nico dans son rôle d’hôte ou de rival ;
- Player présent, distrait ou absent.

Le contenu reste public et autorisé.

Le sens privé n’est pas automatiquement connu des autres.

---

# 30. Image à double sens sans double version secrète

J12 n’exige pas encore un crop privé Pauline.

La même image publique peut déjà signifier :

- réussite professionnelle pour Marie ;
- preuve de couple pour un observateur ;
- contexte inquiétant pour Sandra ;
- effort de normalité pour Mathilde ;
- test de cadre pour Raphaëlle ;
- regard social pour Nico.

La pluralité de sens vient des connaissances différentes, pas d’une omniscience du fichier.

---

# 31. Départs

## Player A12 — Minuit

À 23:56 :

**Marie**

> Minuit dans quatre minutes.

**Player guidé**

> je sais

**Marie**

> C’est pour ça que je te le rappelle avant.

Player part à minuit ou porte la conséquence d’un dépassement choisi.

## Player B12 — 23 h 15

À 23:11 :

**Marie**

> 23 h 15 existe toujours.

**Player**

> je pars dans quatre minutes

**Marie**

> Bien.

Une heure tenue vaut plus qu’une présence prolongée par culpabilité.

## Player C12 — Déjà rentré

Il ne reçoit pas de rappel.

Le groupe continue sans lui.

---

# 32. Après séparation — Règle de foreground

Une seule conséquence principale est jouée après la soirée.

Ordre :

1. après-coup J11 adulte ou limite forte ;
2. audience d’image Sandra ;
3. clarification Raphaëlle ;
4. conséquence Nico ;
5. conséquence Marie ;
6. conséquence réseau / image publique.

Les autres informations restent en état partiel pour J13.

---

# 33. Après-coup Sandra

## Règle confirmée

**00:28 — Sandra**

> Merci d’avoir répondu sans transformer la photo publique en comparaison.

**Player guidé**

> ce n’était pas la même image ni la même règle

**Sandra**

> Oui.

**Sandra**

> C’est exactement ce que je voulais vérifier.

Conséquence J13 :

```text
confiance visuelle à confirmer dans l’ordinaire
```

## Réponse manquée

**08:14 — Sandra**

> Tu avais dit après la fermeture.

**Player reçoit un vrai choix J13 futur.**

La dette est attribuable à la promesse non tenue.

---

# 34. Après-coup Mathilde

## Après J11 physique

Une fois rentrée ou séparée :

**00:28 — Mathilde**

> On a été très normaux.

**00:28 — Mathilde**

> Nico a quand même regardé deux fois si on s’évitait.

**Player guidé**

> il ne sait rien

**Mathilde**

> Non.

**Mathilde**

> Mais il sait qu’il y a quelque chose à ne pas savoir.

**Mathilde**

> Demain, il faut qu’on décide comment on vit dans l’appartement.

Conséquence J13 :

```text
règle domestique et secret à clarifier
```

## Après proximité non sexuelle

**Mathilde**

> Ce soir a prouvé qu’on pouvait rester dans une pièce.

**Mathilde**

> Ce n’est pas rien.

## Après distance restaurée

Aucun message privé obligatoire.

L’ordinaire est la conséquence.

---

# 35. Après-coup Raphaëlle

## Cadre public tenu

**00:28 — Raphaëlle**

> Merci de ne pas avoir essayé de faire exister la version privée dans la salle.

**Player guidé**

> ce n’était pas le lieu

**Raphaëlle**

> Oui.

**Raphaëlle**

> Dimanche, je te dirai si je veux qu’elle existe encore ailleurs.

Conséquence J13 :

```text
clarification de cadre due
```

## Pression exercée

**Raphaëlle**

> Ce soir, tu as essayé d’obtenir une réponse parce que le contexte te gênait.

**Raphaëlle**

> Je ne veux pas continuer sur cette base.

Conséquence :

```text
accès privé refroidi ou fermé
```

---

# 36. Après-coup Nico

## Garde-fou tenu

**00:28 — Nico**

> La règle a tenu.

**Nico**

> Tu n’as pas parlé pour elles. Moi non plus.

**Player guidé**

> ça devrait être la base

**Nico**

> Oui.

**Nico**

> Maintenant on sait qu’on peut la tenir quand elles sont vraiment là.

## Rivalité

**Nico**

> Je t’ai vu me regarder parler à Marie.

**Nico**

> Je ne vais pas m’excuser d’exister dans la pièce.

Conséquence J13 :

```text
rivalité à clarifier sans utiliser Marie comme terrain
```

## Commentaire fermé

Aucun message privé.

Nico respecte la fermeture.

---

# 37. Après-coup Marie

## Couple proche après J11

**00:28 — Marie**

> On avait l’air d’un couple ce soir.

**Player guidé**

> on en est un

**Marie**

> Oui.

**Marie**

> La question, c’est ce qu’on fait quand personne ne prend la photo.

Conséquence J13 :

```text
couple privé à vérifier après visibilité publique
```

## Couple en distance

**Marie**

> On a été très bien en public.

**Marie**

> Je ne vais pas faire semblant que cela répond au reste.

Conséquence :

```text
conversation privée due
```

## Absence Player à L’Annexe

**Marie**

> On a continué.

**Marie**

> Et merci d’avoir dit que tu rentrais avant qu’on garde une place.

Aucune punition.

---

# 38. Connaissances partielles créées

J12 doit produire au moins deux connaissances différentes parmi les suivantes.

## Marie

Peut savoir :

- Player s’éloigne au moment d’une image ;
- Player connaît déjà un détail Raphaëlle ;
- Player et Mathilde sont trop calculés ;
- Nico et Player possèdent une règle implicite ;
- Player tient ou non ses heures.

Elle ne connaît pas la cause exacte.

## Pauline

Peut savoir :

- une version du groupe produit une gêne différente ;
- Player répond à quelqu’un au moment de la sélection ;
- Raphaëlle et Player ont une précision inhabituelle ;
- Mathilde et Player évitent une place.

Elle ne connaît aucun secret complet.

## Nico

Peut savoir :

- Player et Mathilde calculent leur normalité ;
- Marie et Player sont proches ou distants ;
- Raphaëlle et Player évitent un sujet ;
- Player disparaît pour répondre à un message.

Il ne connaît aucune image privée.

## Route dominante

Sait :

- comment Player a protégé, différé ou exposé la ligne privée dans un contexte public.

---

# 39. Conséquence prioritaire J13

Une seule conséquence devient prioritaire.

## Sandra

```text
audience de l’image à confirmer
ou promesse de réponse manquée
```

## Mathilde

```text
règle de vie au foyer après secret ou proximité
```

## Raphaëlle

```text
cadre public / privé à confirmer ou accès refroidi
```

## Nico

```text
garde-fou validé ou rivalité à clarifier
```

## Marie

```text
couple privé à vérifier après visibilité publique
```

## Aucune route extérieure

```text
la photo publique rend la version officielle insuffisante
Marie demande ce que Player a réellement vécu dans la soirée
```

J13 commence par cette conséquence avant toute nouvelle opportunité.

---

# 40. Contrat visuel global J12

Minimum : 4.

Maximum recommandé : 6.

## V1 — Marie / La Verrière

```text
type: PHOTO_DIÉGÉTIQUE PUBLIQUE
creator: Élodie
center: Marie
function: visibilité professionnelle
```

## V2 — Groupe La Verrière

```text
type: PHOTO_SET_DIÉGÉTIQUE
creator: Pauline ou Élodie
center: groupe réel avec Marie lisible
function: version officielle commune
```

## V3 — Pauline / Bastien

```text
type: PHOTO_DIÉGÉTIQUE SOCIALE
creator: Pauline ou tiers autorisé
center: Pauline et Bastien
function: surface officielle authentique
```

## V4 — Groupe L’Annexe

```text
type: PHOTO_DIÉGÉTIQUE SOCIALE
creator: participant autorisé
center: Marie, Mathilde, Pauline ou groupe
function: positions et comportements
```

## V5 — Route dominante ou absence signifiante

Selon la route :

- Sandra : état de l’image privée, sans nouveau contenu obligatoire ;
- Mathilde : image de scène de comportement social ;
- Raphaëlle : image publique de son travail ;
- Nico : image supplémentaire de L’Annexe, jamais à la place du minimum féminin ;
- Marie : image de scène du couple ou de la distance.

## V6 — Image recontextualisable

V2 ou V4 peut devenir l’image à plusieurs sens.

Aucun nouveau crop privé n’est obligatoire.

---

# 41. Conformité text-only

- préparation par messages ;
- co-présence limitée à la logistique ;
- aucun dialogue oral jouable ;
- aucun transcript de table ;
- aucun appel ;
- aucun vocal ;
- aucun nouveau sexe ;
- retours après séparation ;
- conséquences exprimées par texte et état.

---

# 42. Budget de premier plan

```text
Marie = pivot de réseau
1 conséquence J11 active maximum
Pauline/Bastien = surface
Nico = pivot secondaire à L’Annexe
1 conséquence textuelle finale
```

Les autres personnages :

- restent ordinaires ;
- sont absents ;
- ou apparaissent par une trace légitime.

---

# 43. Audit des voix

## Marie

- heures ;
- mouvement ;
- tâches ;
- distinction entre public et privé ;
- aucune surveillance omnisciente.

## Pauline

- sélection de versions ;
- contrôle d’audience ;
- surface avec Bastien ;
- humour sec ;
- aucune confidence improvisée.

## Bastien

- humour ordinaire ;
- présence officielle ;
- aucune fonction de mari idiot ou obstacle vide.

## Nico

- table ;
- chaises ;
- salle ;
- règle directe ;
- intérêt personnel borné ;
- aucune propriété des femmes.

## Sandra

- faible volume ;
- audience ;
- règle simple ;
- aucune comparaison demandée.

## Mathilde

- correction ;
- normalité surjouée ;
- embarras ;
- refus d’une deuxième scène.

## Raphaëlle

- cadre public ;
- heure réelle ;
- processus ;
- pas d’improvisation du privé.

---

# 44. Test sans nom

```text
J’ai donc besoin de savoir quelle version de toi existe ce soir.
→ Marie

La 3 attend que chacun confirme qu’il accepte son propre visage.
→ Pauline

Bientôt n’a pas de chaise.
→ Nico, si la formule réapparaît ailleurs

Je suis très occupée à être normale.
→ Mathilde

Ici, cela signifie que le cadre public tient.
→ Raphaëlle

Je n’avais pas besoin d’un rapport de soirée. Juste de cette phrase.
→ Sandra
```

---

# 45. Audit anti-générique

J12 évite :

- tout le casting présent par obligation ;
- révélation générale ;
- longue conversation côte à côte ;
- photo privée affichée au mauvais écran sans préparation ;
- Pauline qui devient soudain une amante secrète ;
- Nico qui comprend tout ;
- Marie omnisciente ;
- Sandra physiquement téléportée ;
- Raphaëlle présente sans raison ;
- Mathilde disponible parce que Marie travaille ;
- nouvelle scène sexuelle après J11 ;
- récompense de substitution après retrait ;
- image publique considérée comme permission privée.

---

# 46. Critères de validation J12

- [ ] Marie est le pivot de réseau ;
- [ ] Player et Marie sont lisibles comme couple ;
- [ ] Pauline et Bastien possèdent une surface authentique ;
- [ ] Nico reste hôte, observateur ou rival, jamais propriétaire ;
- [ ] Mathilde n’apparaît que dans un contexte crédible ;
- [ ] Sandra peut être absente sans pénalité ;
- [ ] Raphaëlle possède une raison de présence ;
- [ ] une seule conséquence J11 est active ;
- [ ] aucune conséquence adulte ne disparaît ;
- [ ] aucun nouveau passage sexuel ;
- [ ] les messages en co-présence restent logistiques ;
- [ ] une seule conséquence finale est foreground ;
- [ ] au moins deux connaissances partielles différentes existent ;
- [ ] aucune connaissance impossible ;
- [ ] une image publique acquiert plusieurs sens ;
- [ ] aucune image privée n’est montrée sans audience ;
- [ ] minimum quatre visuels fonctionnels ;
- [ ] type, auteur, audience et circulation sont précisés ;
- [ ] une conséquence prioritaire est due en J13 ;
- [ ] l’acte IV s’ouvre sans verrou total.

---

# 47. Résumé canonique candidat

J12 réunit Marie, Player, Pauline, Bastien, Élodie et, selon les histoires réelles, Mathilde ou Raphaëlle à La Verrière.

Sandra peut rester absente et agir seulement par un message lié à l’audience de son image.

Nico reçoit ensuite une partie du groupe à L’Annexe.

Player choisit d’abord quelle présence offrir à Marie, puis s’il continue à L’Annexe, y passe une heure précise ou rentre sans demander au groupe de l’attendre.

Une photo publique de La Verrière et une photo sociale de L’Annexe deviennent des objets à plusieurs sens : chacun voit le même cadre avec des connaissances différentes.

La conséquence J11 dominante modifie seulement un comportement ou un aparté : Sandra vérifie une règle d’image, Mathilde refuse de produire une deuxième scène, Raphaëlle protège le cadre public, Nico tient ou ferme son rôle, Marie vérifie si le couple existe encore hors de l’image.

Personne ne découvre tout.

Mais au moins deux personnages comprennent que la version officielle ne suffit plus complètement.

Après séparation, une seule conséquence principale devient foreground et doit être payée en J13.

> **J12 ne fait pas exploser le réseau. Elle lui retire simplement la possibilité de prétendre que toutes ses lignes restent parallèles.**