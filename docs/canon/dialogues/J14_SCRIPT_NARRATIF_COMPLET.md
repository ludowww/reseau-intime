# Réseau Intime — J14 Script narratif complet

## Statut

**Catégorie : Canon validé narrativement — source pré-runtime consolidée**

**Périmètre : J14 uniquement**

**Surface : messagerie texte uniquement**

Ce document définit la version narrative complète de J14 avant toute adaptation technique.

Il s’appuie sur :

- `J13_SCRIPT_NARRATIF_COMPLET.md` ;
- `S27 — La photo au mauvais écran` ;
- les états de connaissance créés en J12 ;
- les règles d’audience, de conservation, de retrait et de consentement ;
- le canon text-only.

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

J14 devient :

```text
Lundi — La photo au mauvais écran
```

Sa fonction est :

```text
changer un état de connaissance
à partir d’une trace qui existait déjà
sans donner au témoin tout le contexte
```

J14 n’invente :

- aucune nouvelle photographie ;
- aucun transfert magique ;
- aucune capture secrète ;
- aucun témoin téléporté ;
- aucune preuve plus précise que ce qui est réellement affiché.

---

# 2. Question dramatique

> Que fait Player lorsqu’une personne voit une trace réelle dont elle ne possède pas le contexte ?

Player peut :

1. expliquer une vérité limitée ;
2. minimiser ou mentir ;
3. protéger la personne représentée et différer l’explication.

Le troisième choix n’est pas automatiquement noble.

Protéger une audience peut être juste.

Utiliser la protection comme prétexte pour maintenir un mensonge important crée une dette.

---

# 3. Conditions d’entrée

J14 existe uniquement si une trace réelle a survécu J13.

Traces possibles :

```text
j13_pauline_private_version_01
j13_raphaelle_masked_version_01
j13_nico_alibi_or_hour_message_01
j11_sandra_chosen_image_01
j10_mathilde_outfit_choice_01 ou j11_mathilde_physical_aftercare_01
j09_marie_black_dress_private_01 juxtaposée à j09_marie_laverriere_public_01
```

Si aucune trace privée ou ambiguë n’existe réellement, J14 mute vers une journée de respiration et de préparation J15.

Le jeu ne crée pas une erreur d’écran pour remplir le calendrier.

---

# 4. Règle de sélection du témoin

Le témoin doit :

- être physiquement présent ;
- posséder une raison ordinaire d’être près de l’écran ;
- voir seulement ce que l’interface affiche ;
- ne pas lire un fil complet sans action supplémentaire ;
- ne pas devenir omniscient ;
- avoir un intérêt relationnel réel dans la trace.

Ordre de sélection :

1. personne directement affectée et réellement présente ;
2. personne qui connaît déjà la version publique correspondante ;
3. personne qui partage le foyer ou le contexte professionnel ;
4. aucun témoin si la situation serait artificielle.

---

# 5. Ce que le témoin peut réellement voir

Selon le mode de découverte :

## Aperçu verrouillé

Le témoin peut voir :

- nom de l’expéditeur ;
- première ligne ;
- miniature si les réglages et le contenu le permettent ;
- heure de réception.

Il ne voit pas :

- historique complet ;
- règle d’audience antérieure ;
- consentement exact ;
- origine émotionnelle de la relation.

## Mauvaise conversation ouverte

Le témoin peut voir :

- le dernier contenu affiché ;
- quelques lignes immédiatement visibles ;
- le nom du fil.

Il ne peut pas parcourir le fil sans nouvelle action.

## Galerie ou sélection ouverte

Le témoin peut voir :

- une image réellement enregistrée ou consultable ;
- sa proximité avec d’autres contenus ;
- éventuellement le nom du fil d’origine si l’application l’affiche.

Il ne connaît pas automatiquement l’audience autorisée.

## Notification textuelle

Le témoin connaît exactement les mots affichés, pas leur contexte complet.

---

# 6. Réaction de fermeture de l’écran

Fermer brusquement l’écran est une action visible.

Elle peut signifier :

- protection légitime de la personne représentée ;
- panique ;
- mensonge ;
- habitude de secret ;
- simple respect de la vie privée.

Le témoin ne sait pas laquelle sans explication.

Le jeu mémorise donc séparément :

```text
trace_id
witness_id
visible_fields
player_reaction
player_explanation
knowledge_id: fact_witness_saw_limited_trace
```

---

# 7. Architecture de la journée

J14 ne possède pas une heure unique pour toutes les variantes.

Structure commune :

```text
situation ordinaire crédible
→ écran visible par accident
→ réaction immédiate Player
→ séparation physique réelle
→ échange textuel après que l’un des personnages a quitté le lieu
→ personne représentée prévenue si nécessaire
→ état de connaissance précis
→ obligation J15
```

La co-présence ne produit aucun long dialogue oral.

Lorsque le témoin et Player sont côte à côte, la scène s’arrête sur un geste ou une phrase narrative brève, puis reprend en messages après séparation.

---

# 8. Modèle de choix Player

Chaque variante adapte ces trois postures.

## D-A — Vérité limitée

Player explique :

- ce que la trace est ;
- ce qu’elle n’est pas ;
- ce qu’il est autorisé à dire ;
- ce qu’il doit encore assumer.

La vérité limitée ne signifie pas révélation totale.

## D-B — Minimiser ou mentir

Player peut :

- réduire la trace à un détail banal ;
- nier une intention évidente ;
- inventer une origine ;
- déplacer la faute sur le témoin ;
- supprimer visiblement sans expliquer.

Cela peut préserver quelques heures, mais crée :

- contradiction ;
- dette ;
- preuve ;
- pression J15.

## D-C — Protéger le sujet et différer

Player ferme l’écran, dit qu’il ne peut pas exposer la personne représentée et propose une heure de clarification.

Ce choix est valide seulement si :

- une audience privée réelle existe ;
- l’heure est précise ;
- Player prévient la personne représentée si son audience a été compromise ;
- la clarification ne devient pas un report indéfini.

---

# 9. Variante Pauline — Marie voit une autre version

## 9.1 Éligibilité

Cette variante existe si :

- Pauline a envoyé P1 en J13 ;
- l’image est encore consultable dans le fil ;
- Marie est réellement avec Player ;
- Marie connaît la version publique de J12 ;
- aucun incident plus grave ne passe avant.

## 9.2 Situation ordinaire

Lundi soir, Marie et Player sélectionnent ou recherchent une photographie publique de J12 pour La Verrière.

Player utilise son téléphone.

Marie est assise à côté de lui ou tient le téléphone parce qu’elle cherche la version officielle.

L’application revient sur la conversation Pauline ou affiche une miniature récente.

Marie voit :

- Pauline seule ou principalement centrée ;
- le même lieu que J12 ;
- un cadrage différent de la version de groupe ;
- le nom de Pauline ;
- aucune règle d’audience.

## 9.3 Réaction immédiate hors téléphone

Player reprend ou verrouille le téléphone.

La narration montre uniquement :

```text
Marie a reconnu Pauline.
Elle a reconnu la soirée.
Elle n’a pas reconnu la version.
```

Aucun dialogue oral complet n’est joué.

Marie quitte la pièce, prend son manteau ou termine la tâche sans poursuivre sur place.

À 20:14, elle écrit.

## 9.4 Ouverture Marie

**20:14 — Marie**

> C’était Pauline.

**20:14 — Marie**

> Même soirée.

**20:15 — Marie**

> Pas la photo du groupe.

**20:15 — Marie**

> Pourquoi elle t’a envoyé une autre version ?

Marie sait :

- qu’une image différente existe ;
- qu’elle est arrivée dans un fil privé Player/Pauline ;
- que Player a fermé l’écran.

Elle ne sait pas :

- si l’image était destinée érotiquement ;
- si Player peut la conserver ;
- si Bastien connaît son existence ;
- si Pauline a déjà ouvert un compartiment ;
- ce que Player a répondu.

---

# 10. Choix Pauline / témoin Marie

## P14-A — Vérité limitée

**Player**

> elle a écarté cette version du groupe et me l’a envoyée séparément. elle voulait que je voie la différence. je n’ai pas le droit de la montrer ni de la sortir du fil

Silence.

**20:17 — Marie**

> Donc tu sais que la différence était pour toi.

**Player**

> oui

**20:18 — Marie**

> Est-ce que Bastien le sait ?

Player reçoit un choix réel :

- `je ne sais pas` ;
- `non, d’après ce qu’elle m’a dit` ;
- `je n’ai pas demandé`.

### Réponse `je ne sais pas`

**Marie**

> D’accord.

**Marie**

> Alors ne me présente pas ça comme un cadre propre.

### Réponse `non`

**Marie**

> Donc ce n’est pas seulement une photo.

**Marie**

> C’est une place secrète que vous êtes en train de fabriquer.

### Réponse `je n’ai pas demandé`

**Marie**

> Tu as demandé la règle de l’image.

**Marie**

> Tu n’as pas demandé la règle de la relation.

### Sortie

```text
Marie connaît la double adresse partielle
Pauline doit être prévenue que Marie a vu l’image
conversation couple J15 due
```

## P14-B — Minimiser ou mentir

**Player**

> c’est juste une photo ratée du groupe. elle voulait mon avis avant de la supprimer

**20:17 — Marie**

> Elle n’avait pas l’air ratée.

**Player**

> tu l’as vue une seconde

**20:18 — Marie**

> Oui.

**20:18 — Marie**

> Et toi tu as fermé l’écran en moins d’une seconde.

**20:19 — Marie**

> Ce n’est pas une preuve de ce qu’elle voulait.

**20:19 — Marie**

> C’est une information sur ce que toi tu savais.

### Sortie

```text
mensonge ou minimisation active
Marie connaît la contradiction comportementale
image Pauline devient preuve potentielle J15
Pauline n’est pas encore prévenue
```

## P14-C — Protéger Pauline et différer

**Player**

> je ne peux pas te montrer ni raconter son image sans son accord. mais je ne vais pas faire comme si tu n’avais rien vu. je te réponds ce soir à 21 h 30 après l’avoir prévenue

**20:17 — Marie**

> 21 h 30.

**20:17 — Marie**

> Et je ne te demande pas la photo.

**20:18 — Marie**

> Je te demande ce que tu as accepté.

Player doit prévenir Pauline.

**Player → Pauline**

> Marie a vu la miniature quand on cherchait la photo du groupe. je ne lui ai pas montré davantage. je dois lui répondre sur ce que j’ai accepté avec toi

### Pauline

**Pauline**

> D’accord.

**Pauline**

> Ne lui envoie pas l’image.

**Pauline**

> Dis-lui que je l’ai choisie pour une autre audience.

**Pauline**

> Et que Bastien ne le sait pas si tu décides de lui dire la vérité complète.

Le choix de Player à 21 h 30 détermine s’il protège une audience ou maintient un secret trompeur.

### Sortie

```text
audience Pauline protégée
Marie attend une explication à heure précise
Pauline sait que la ligne privée a laissé une trace
J15 possède deux obligations incompatibles possibles
```

---

# 11. Variante Sandra — Mathilde voit l’image destinée

## 11.1 Éligibilité

Cette variante existe si :

- l’image Sandra est encore accessible ;
- sa règle autorise le visionnage dans le fil ou la conservation précise ;
- Mathilde partage encore le foyer ;
- Marie n’est pas la personne la plus plausible près de l’écran à cet instant ;
- Mathilde possède une raison ordinaire de voir le téléphone.

## 11.2 Situation ordinaire

Player montre à Mathilde une photographie publique de J12 ou cherche une information pratique dans son téléphone.

Il lui tend l’appareil quelques secondes.

Le téléphone revient sur le dernier média consulté ou un geste de navigation ouvre le fil Sandra.

Mathilde voit :

- Sandra ;
- une image manifestement choisie et privée ;
- le nom du fil ;
- aucune règle de conservation ;
- aucun historique complet.

## 11.3 Réaction immédiate

Player reprend le téléphone.

Mathilde ne tente pas de le récupérer.

Elle quitte la cuisine ou termine ce qu’elle faisait.

À 18:36, elle écrit depuis une autre pièce.

## 11.4 Ouverture Mathilde

**18:36 — Mathilde**

> C’était Sandra ?

**18:36 — Mathilde**

> Je demande parce que j’ai vu son nom.

**18:37 — Mathilde**

> Et parce que cette photo n’avait pas l’air d’être dans un groupe de déjeuner.

Mathilde sait :

- que Sandra a envoyé ou laissé accessible une image privée ;
- que Player l’a consultée ;
- que Player a repris le téléphone.

Elle ne sait pas :

- si Sandra autorise la conservation ;
- si Jeff sait ;
- si l’image était érotique pour Sandra ;
- si Player et Sandra se sont rencontrés ;
- ce que Marie sait.

---

# 12. Choix Sandra / témoin Mathilde

## S14-A — Vérité limitée

**Player**

> oui. elle l’a prise et choisie elle-même. elle me l’a envoyée pour moi. tu n’étais pas censée la voir

**18:38 — Mathilde**

> D’accord.

**18:38 — Mathilde**

> Donc je n’ai pas vu une photo volée.

**18:39 — Mathilde**

> J’ai vu une photo qui n’était pas pour moi.

**Player**

> oui

**18:39 — Mathilde**

> Tu dois lui dire.

**18:40 — Mathilde**

> Pas pour me dénoncer. Pour qu’elle sache que son audience a changé pendant trois secondes.

Player doit prévenir Sandra.

### Sortie

```text
Mathilde connaît une relation visuelle privée
Sandra doit être informée de l’audience accidentelle
Marie ne sait rien automatiquement
```

## S14-B — Minimiser ou mentir

**Player**

> vieille photo. rien de privé

**18:38 — Mathilde**

> Tu mens très vite.

**Player**

> tu as vu une image une seconde

**18:39 — Mathilde**

> Oui.

**18:39 — Mathilde**

> Et j’ai vu ton visage juste après.

**18:40 — Mathilde**

> Je ne sais pas ce que c’est.

**18:40 — Mathilde**

> Je sais seulement que tu ne veux pas que Marie le voie.

### Sortie

```text
Mathilde interprète un secret envers Marie
Sandra n’est pas prévenue
confiance Mathilde réduite
J15 peut utiliser le foyer comme pression
```

## S14-C — Protéger Sandra et différer

**Player**

> je ne peux pas te donner le contexte sans lui demander. je vais lui dire que tu as vu l’écran. après, je te réponds sur ce que ça change dans l’appartement et avec Marie

**18:38 — Mathilde**

> Bien.

**18:39 — Mathilde**

> Je ne te demande pas de me montrer la photo.

**18:39 — Mathilde**

> Je te demande de ne pas me transformer en personne qui couvre sans savoir.

Player prévient Sandra.

**Player → Sandra**

> Mathilde a vu l’image quelques secondes quand je lui ai tendu mon téléphone. elle n’a pas parcouru le fil. je suis désolé. je veux savoir ce que tu veux que je fasse maintenant

Sandra peut :

- retirer immédiatement ;
- demander confirmation de ce qui a été vu ;
- laisser l’image mais exiger que Mathilde ne reçoive aucun détail supplémentaire.

### Sortie

```text
audience compromise reconnue
Sandra contrôle retrait ou maintien
Mathilde refuse un secret sans règle
conversation Marie potentiellement due en J15
```

---

# 13. Variante Mathilde — Marie lit une notification domestique

## 13.1 Éligibilité

Cette variante existe si :

- Mathilde a écrit une règle, un secret ou une phrase sur la non-répétition ;
- le message existe encore ;
- Marie partage le foyer ;
- le téléphone est visible dans une situation ordinaire ;
- l’aperçu contient réellement une ligne significative.

## 13.2 Situation ordinaire

Le téléphone de Player charge sur le meuble de l’entrée ou le plan de travail.

Marie est à proximité pour une raison ordinaire.

Une notification Mathilde apparaît.

Exemples de lignes survivantes :

```text
Aujourd’hui, rien ne se répète.
On doit décider comment on vit ici maintenant.
Je veux de la distance dans l’appartement.
```

La variante choisit uniquement une ligne réellement envoyée dans la partie.

Marie ne touche pas nécessairement le téléphone.

Elle voit :

- le nom Mathilde ;
- la ligne affichée ;
- l’heure ;
- aucune conversation complète.

## 13.3 Ouverture Marie

Marie se sépare de Player avant d’écrire.

**19:02 — Marie**

> J’ai vu la notification de Mathilde.

Puis la ligne exacte :

### Exemple proximité

> `Aujourd’hui, rien ne se répète.`

### Exemple règle

> `On doit décider comment on vit ici maintenant.`

### Exemple sécurité

> `Je veux de la distance dans l’appartement.`

**19:03 — Marie**

> Je ne vais pas inventer le reste.

**19:03 — Marie**

> Mais je ne vais pas faire semblant que cette phrase est ordinaire.

Marie sait exactement :

- qu’un échange privé existe ;
- que Mathilde parle d’une répétition, d’une règle ou d’une distance ;
- que le contexte concerne potentiellement le foyer.

Elle ne sait pas :

- ce qui s’est passé ;
- si c’était physique ;
- qui a initié ;
- quelle limite a été posée ;
- si Mathilde se sent en sécurité.

---

# 14. Choix Mathilde / témoin Marie

## M14-A — Vérité limitée avec priorité sécurité

La formulation dépend de l’état réel.

### Si proximité consentie

**Player**

> on a reconnu une attirance et posé une règle pour qu’il n’y ait rien de nouveau dans l’appartement sans en reparler. tu viens de voir la conséquence, pas tout le contexte

Silence.

**19:05 — Marie**

> `On a reconnu` est une formulation très pratique.

**19:05 — Marie**

> Est-ce qu’elle se sent en sécurité ici ?

Player doit répondre directement.

### Si premier passage physique

**Player**

> il s’est passé quelque chose vendredi. c’était consenti et borné. elle a demandé qu’on définisse une règle pour vivre ici après

**19:05 — Marie**

> D’accord.

**19:06 — Marie**

> Je vais parler à Mathilde sans toi pour savoir ce qu’elle veut pour le logement.

**19:06 — Marie**

> Ensuite on parlera de nous.

### Si limite ignorée

**Player**

> elle m’a demandé de la distance parce que je n’ai pas respecté correctement une limite

**19:05 — Marie**

> Tu ne restes pas seul avec elle ce soir.

**19:05 — Marie**

> Je gère d’abord sa sécurité et son logement.

### Sortie

```text
Marie connaît le type de problème, pas chaque détail
Mathilde doit pouvoir parler sans Player
couple et foyer deviennent obligations distinctes
J15 reçoit au moins deux engagements incompatibles
```

## M14-B — Minimiser ou mentir

**Player**

> elle parle des règles de l’appartement. rien à voir avec nous

**19:05 — Marie**

> Elle t’écrit à toi.

**19:05 — Marie**

> `Rien à voir avec nous` n’est pas une explication.

**Player**

> tu lis une phrase hors contexte

**19:06 — Marie**

> Oui.

**19:06 — Marie**

> Et tu utilises le manque de contexte pour me demander de ne pas croire les mots exacts.

Marie peut écrire directement à Mathilde sans transmettre l’accusation de Player.

### Sortie

```text
mensonge actif
Marie cherche une source indépendante
Mathilde peut apprendre que son message a été vu
J15 devient plus conflictuel
```

## M14-C — Protéger Mathilde et différer

**Player**

> je ne vais pas raconter sa version à sa place. la phrase concerne une limite dans le foyer. je lui dis que tu l’as vue et je te réponds à 20 h 30 sur ce que moi j’ai fait

**19:05 — Marie**

> 20 h 30.

**19:05 — Marie**

> Et je parlerai aussi avec elle.

**19:06 — Marie**

> Pas pour comparer vos versions. Pour savoir si elle peut rester ici sereinement.

Player prévient Mathilde.

**Player → Mathilde**

> Marie a vu l’aperçu de ton message. seulement la première ligne. je lui ai dit que ça concernait une limite dans le foyer et que je ne parlerais pas à ta place

Mathilde peut répondre :

> D’accord. Je lui parlerai moi-même.

ou, si elle demande de la distance :

> Je veux lui parler sans toi dans la pièce.

### Sortie

```text
audience Mathilde compromise reconnue
sécurité prioritaire
explication Player due à heure précise
```

---

# 15. Variante Raphaëlle — Marie voit l’image masquée

## 15.1 Éligibilité

Cette variante existe si :

- l’image masquée R1 a survécu J13 ;
- Marie est réellement près de l’écran ;
- elle connaît Raphaëlle comme collègue ou relation professionnelle ;
- l’écran affiche l’image ou sa miniature ;
- aucune violation plus urgente ne passe avant.

## 15.2 Situation ordinaire

Player cherche un document, une photo publique de J12 ou montre un élément de travail à Marie.

Le téléphone ou l’ordinateur ouvre la dernière image consultée.

Marie voit :

- Raphaëlle avec un masque ou une posture de rôle ;
- un cadrage choisi ;
- le nom du fil ou du fichier ;
- aucune règle d’audience ;
- aucune preuve de rencontre physique.

## 15.3 Ouverture Marie

**21:08 — Marie**

> C’était Raphaëlle du travail ?

**21:08 — Marie**

> Avec le masque.

**21:09 — Marie**

> Je sais qu’une image de costume peut être du travail.

**21:09 — Marie**

> Je sais aussi reconnaître quand quelqu’un a choisi une image pour une personne précise.

Marie comprend correctement :

- que l’image a été sélectionnée ;
- que Player est une audience privée ou spécifique ;
- que le contexte dépasse probablement un simple fichier collectif.

Elle ne sait pas :

- si Player et Raphaëlle se sont embrassés ;
- si Maud est autrice ;
- si l’image peut être conservée ;
- si Raphaëlle a nommé son attirance ;
- si Player a respecté le rôle.

---

# 16. Choix Raphaëlle / témoin Marie

## R14-A — Vérité limitée

**Player**

> Maud a pris la photo. Raphaëlle l’a choisie et me l’a envoyée parce que j’ai suivi le processus. elle a précisé que le rôle était dans l’image, pas dans la conversation

**21:11 — Marie**

> Donc tu connais assez bien la différence pour me la réciter.

**Player**

> oui

**21:12 — Marie**

> Est-ce que tu es attiré par elle ?

Player doit choisir :

- `oui` ;
- `je ne veux pas ouvrir ça avec toi ce soir` ;
- `non` si c’est réellement vrai dans la branche.

Un mensonge incompatible avec J11 devient une dette.

### Sortie

```text
Marie connaît l’accès privé au processus
attirance éventuellement reconnue
Raphaëlle doit être informée que Marie a vu l’image
clarification couple et professionnelle due
```

## R14-B — Minimiser ou mentir

**Player**

> fichier de travail. rien de privé

**21:11 — Marie**

> Les fichiers de travail n’arrivent pas avec ton pouce sur l’écran comme s’il fallait les cacher.

**Player**

> tu interprètes

**21:12 — Marie**

> Oui.

**21:12 — Marie**

> Parce que tu refuses de me donner le contexte minimum.

### Sortie

```text
Marie interprète une exclusion
Raphaëlle non prévenue
confiance couple réduite
risque professionnel J15
```

## R14-C — Protéger Raphaëlle et différer

**Player**

> je ne peux pas te montrer davantage ni parler de son image sans la prévenir. je lui dis ce que tu as vu. à 22 h je te réponds sur ma place dans cette histoire

**21:11 — Marie**

> 22 h.

**21:11 — Marie**

> Je ne demande pas le fichier.

**21:12 — Marie**

> Je demande pourquoi tu es devenu une audience qu’elle a choisie.

Player prévient Raphaëlle.

**Player → Raphaëlle**

> Marie a vu l’image masquée quand mon écran s’est rouvert dessus. elle n’a rien parcouru. je lui ai dit que je te prévenais avant de parler de ma place dans le processus

Raphaëlle :

> D’accord.

> Ne lui envoie pas l’image.

> Tu peux lui dire que je l’ai choisie et que Maud l’a prise.

> Pour le reste, parle de tes actes. Pas à ma place.

### Sortie

```text
audience Raphaëlle protégée
Marie attend la vérité sur Player
obligation professionnelle et couple peuvent entrer en conflit J15
```

---

# 17. Variante Nico — Marie lit une phrase d’alibi

## 17.1 Éligibilité

Cette variante existe si :

- un message Nico sur l’heure réelle ou l’alibi existe ;
- Marie est directement concernée par l’heure ;
- l’aperçu est visible dans une situation ordinaire ;
- Nico n’a pas supprimé ou fermé le fil ;
- aucune trace d’image plus urgente ne passe avant.

## 17.2 Situation ordinaire

Player et Marie organisent une heure, regardent un calendrier ou utilisent le téléphone pour une tâche commune.

Une notification Nico apparaît.

Ligne possible réellement survivante :

```text
Je ne change pas une heure pour la protéger.
Mon nom ne sera pas dans ton mensonge.
La règle a tenu. Tu n’as pas parlé pour elles.
```

La variante choisit uniquement une ligne existante.

## 17.3 Ouverture Marie

**18:27 — Marie**

> J’ai vu le message de Nico.

Puis la ligne exacte.

**18:28 — Marie**

> Je ne sais pas ce qu’il protège.

**18:28 — Marie**

> Je sais qu’il refuse de changer une heure pour toi.

Marie sait :

- qu’une version d’horaire existe ;
- que Nico connaît la réalité ;
- que Player a peut-être demandé ou envisagé une couverture.

Elle ne sait pas :

- quelle relation extérieure est concernée ;
- si Player a effectivement menti ;
- ce que Nico sait des femmes ;
- si l’alibi a été demandé ou prévenu.

---

# 18. Choix Nico / témoin Marie

## N14-A — Vérité limitée

**Player**

> j’ai dépassé l’heure que je t’avais donnée. Nico a dit l’heure réelle et a refusé d’être un alibi. il a raison

**18:30 — Marie**

> Pourquoi tu ne m’as pas dit l’heure réelle toi-même ?

Player choisit :

- `j’ai eu peur de ta réaction` ;
- `je voulais éviter une discussion` ;
- `je pensais rentrer plus tôt et j’ai laissé dériver`.

Chacune est une vérité différente, sans réparation automatique.

### Sortie

```text
heure réelle reconnue
Nico retiré du mensonge
conversation couple due
```

## N14-B — Minimiser ou mentir

**Player**

> il parle d’un client et d’une fermeture. rien à voir avec toi

**18:30 — Marie**

> Il écrit `pour toi`.

**Player**

> façon de parler

**18:31 — Marie**

> Non.

**18:31 — Marie**

> C’est une façon d’éviter de parler.

Marie peut demander directement à Nico seulement ce qui la concerne :

> À quelle heure Player est-il parti samedi ?

Nico répond l’heure réelle.

### Sortie

```text
mensonge contredit par source indépendante
Nico devient témoin malgré lui
J15 reçoit une dette couple forte
```

## N14-C — Protéger la confidence mais répondre sur l’heure

**Player**

> je ne vais pas te raconter ce que j’ai confié à Nico. mais le message te concerne sur un point : je n’ai pas respecté l’heure donnée. je te réponds maintenant sur ça

**18:30 — Marie**

> D’accord.

**18:30 — Marie**

> Je ne te demande pas sa confidence.

**18:31 — Marie**

> Je te demande pourquoi ton ami a dû protéger la vérité de ton propre mensonge.

### Sortie

```text
confidence Nico protégée
fait affectant Marie reconnu
rivalité ou garde-fou préservé
```

---

# 19. Variante composite Marie — Une notification privée sur la photo du couple

## 19.1 Éligibilité

Cette variante existe si :

- aucune image privée complète n’est affichée ;
- la photo publique du couple J12 existe ;
- une notification privée réelle survit J13 ;
- Marie est près de l’écran ;
- le contraste lui donne une connaissance partielle nouvelle.

## 19.2 Situation

Player et Marie regardent la photographie publique où ils apparaissent comme couple.

Une notification réelle apparaît au-dessus de l’image.

Exemples :

- Sandra : `Je la laisse pour aujourd’hui.`
- Pauline : `La version publique reste vraie.`
- Raphaëlle : `Le rôle n’est pas dans cette conversation.`
- Mathilde : `Aujourd’hui, rien ne se répète.`
- Nico : `Mon nom ne sera pas dans ton mensonge.`

Marie voit :

- leur image publique ;
- le nom de l’expéditeur ;
- une phrase privée ;
- la réaction de Player.

Elle ne voit pas la trace complète.

## 19.3 Ouverture Marie

**21:36 — Marie**

> C’est presque trop propre.

**Player guidé**

> la photo ?

**21:37 — Marie**

> La photo.

**21:37 — Marie**

> Et la notification au-dessus.

**21:38 — Marie**

> Je ne sais pas ce que la phrase voulait dire.

**21:38 — Marie**

> Je sais qu’elle ne parlait pas de nous comme la photo le faisait.

Les trois choix suivent le modèle vérité limitée, minimisation ou protection/délai selon l’expéditeur réel.

### Sortie

```text
version officielle du couple devenue insuffisante
trace privée non révélée complètement
conversation J15 obligatoire
```

---

# 20. Fallback — Aucun mauvais écran crédible

## 20.1 Conditions

Le fallback s’active si :

- aucune trace privée n’a survécu ;
- toutes les images ont été retirées ;
- les notifications sont désactivées ou non visibles ;
- aucun témoin crédible n’est présent ;
- forcer l’accident exigerait une coïncidence artificielle.

## 20.2 Fonction

J14 ne joue pas S27.

Elle devient :

```text
S27_MUTATION_NO_DISCOVERY
```

Cette mutation ne crée pas une nouvelle séquence.

Elle montre qu’une bonne gestion de l’audience ou un retrait réel a empêché la découverte.

## 20.3 Script

**19:18 — Marie**

> Pauline a envoyé la sélection finale à La Verrière.

**19:18 — Marie**

> Tu peux vérifier que la légende ne transforme pas Bastien en sponsor officiel ?

**Player guidé**

> je regarde

Le téléphone reste ordinaire.

Aucune notification privée ne surgit.

Player peut :

- traiter la tâche ;
- proposer une heure de couple ;
- annoncer qu’il ne peut pas ce soir.

La journée prépare J15 par les engagements réellement existants, pas par une découverte inventée.

---

# 21. Obligation de prévenir la personne représentée

Lorsqu’une image privée a été vue hors audience, Player doit prévenir la personne concernée.

## Sandra

Doit savoir :

- qui a vu ;
- combien de temps ;
- si le fil a été parcouru ;
- si une copie existe ;
- ce que Player a dit.

## Pauline

Doit savoir :

- que Marie a vu une version différente ;
- si l’image a été montrée ou seulement aperçue ;
- si Bastien est désormais concerné indirectement.

## Raphaëlle

Doit savoir :

- que Marie a vu l’image masquée ;
- qu’aucun autre fichier n’a été montré ;
- ce que Player a déclaré sur le processus.

## Mathilde

Doit savoir :

- que Marie a vu l’aperçu ;
- les mots exacts visibles ;
- si Player a parlé à sa place.

Ne pas prévenir crée une seconde violation distincte de l’accident initial.

---

# 22. Droit du témoin à ne pas tout recevoir

Le témoin peut refuser :

- de voir l’image complète ;
- d’entendre des détails intimes ;
- de devenir gardien d’un secret ;
- de parler immédiatement ;
- de croire une explication contradictoire.

Marie peut dire :

> Je ne veux pas la photo. Je veux savoir ce que tu as accepté.

Mathilde peut dire :

> Je ne veux pas devenir la personne qui couvre sans savoir.

Bastien, s’il devient témoin dans une future mutation Pauline, peut refuser une version partielle et demander que Pauline lui parle directement.

---

# 23. État de connaissance formel par variante

## Pauline / Marie

```text
vu: image Pauline différente de la version publique
compris_correctement: audience privée Player
interprété_incorrectement_possible: niveau exact d’intimité
sait_que_player_sait: que la différence était destinée
```

## Sandra / Mathilde

```text
vu: image Sandra choisie dans un fil privé
compris_correctement: image non publique
interprété_incorrectement_possible: relation sexuelle ou accord de conservation
sait_que_player_sait: que l’image n’était pas pour Mathilde
```

## Mathilde / Marie

```text
vu: phrase exacte de règle, répétition ou distance
compris_correctement: problème privé lié au foyer
interprété_incorrectement_possible: nature physique exacte
sait_que_player_sait: contexte complet de la phrase
```

## Raphaëlle / Marie

```text
vu: image masquée sélectionnée
compris_correctement: audience spécifique Player
interprété_incorrectement_possible: rencontre physique ou rôle prolongé
sait_que_player_sait: contexte du processus et de l’image
```

## Nico / Marie

```text
vu: phrase exacte sur heure, mensonge ou couverture
compris_correctement: Nico détient une vérité différente
interprété_incorrectement_possible: nature de toute la confidence
sait_que_player_sait: quelle heure ou version est réelle
```

## Composite / Marie

```text
vu: photo publique du couple + notification privée
compris_correctement: coexistence de deux versions de la journée
interprété_incorrectement_possible: importance exacte de la ligne privée
sait_que_player_sait: contexte que Marie ne possède pas
```

---

# 24. Choix de suppression

Supprimer une trace après qu’elle a été vue ne supprime pas la connaissance.

Le jeu distingue :

```text
contenu_supprimé
connaissance_témoin_active
preuve_matérielle_disponible
confiance_affectée
```

Une suppression peut :

- respecter une demande d’audience ;
- protéger une personne ;
- détruire une preuve ;
- sembler confirmer un secret ;
- créer une dette si elle est faite sans prévenir l’autrice.

---

# 25. Retour de la personne représentée

Une seule réponse secondaire est foreground après l’échange avec le témoin.

Priorité :

1. personne dont l’image ou le message a été vu ;
2. témoin directement affecté ;
3. Marie si elle n’était pas témoin mais reste structurellement concernée.

Cette réponse ne résout pas tout J14.

Elle fixe seulement :

- retrait ;
- audience ;
- heure de discussion ;
- distance ;
- vérité à donner en J15.

---

# 26. Handoff vers J15

J14 rend les engagements plus difficiles à tenir simultanément.

Obligations possibles :

## Pauline

- parler à Marie ;
- protéger l’image ;
- ne pas exposer Bastien ;
- répondre à Pauline sur le compartiment.

## Sandra

- confirmer suppression ou audience ;
- répondre à Mathilde ;
- décider ce qui doit être dit à Marie ;
- respecter le poste ou l’horaire Sandra.

## Mathilde

- garantir la sécurité ou la distance ;
- parler avec Marie ;
- organiser le foyer ;
- maintenir une obligation professionnelle ou extérieure.

## Raphaëlle

- informer Raphaëlle ;
- clarifier avec Marie ;
- payer un engagement professionnel ;
- préserver ou fermer le cadre privé.

## Nico

- dire la vérité sur l’heure ;
- ne pas utiliser Nico comme alibi ;
- honorer une obligation couple ;
- répondre à une autre relation qui ignore la découverte.

## Composite

- expliquer la notification ;
- payer l’obligation publique ;
- ne pas exposer la personne privée ;
- tenir une heure annoncée.

J15 exige au moins deux de ces éléments.

---

# 27. Contrat visuel global

Minimum : 3.

## V1 — Trace existante

```text
type: contenu déjà créé
function: objet réellement vu
```

## V2 — Témoin / découverte

```text
type: IMAGE_DE_SCÈNE
center: femme témoin ou personnage affecté
function: écran, réaction, retrait ou distance
circulable: false
```

## V3 — Conséquence

```text
type: état du contenu, image de scène ou trace ordinaire
center: personne représentée ou Marie
function: suppression, audience, dette ou autonomie
```

Aucune image nouvelle ne remplace la trace découverte.

---

# 28. Conformité text-only

- aucun appel ;
- aucun message vocal ;
- aucune scène audio ;
- découverte visuelle ou textuelle ;
- réaction immédiate non dialoguée longuement ;
- discussion par messages après séparation ;
- éventuelle co-présence future hors téléphone ;
- aucune conversation orale transcrite.

---

# 29. Audit des voix

## Marie

- phrase exacte ;
- distinction entre preuve et impression ;
- refus de recevoir une image non destinée ;
- demande d’acte ou de vérité ;
- pas d’omniscience.

## Mathilde

- vitesse ;
- gêne ;
- phrase directe lorsqu’une limite d’audience existe ;
- refus de couvrir sans savoir ;
- humour réduit face à la gravité.

## Pauline

- version ;
- audience ;
- surface qui reste vraie ;
- Bastien réel ;
- contrôle sec.

## Sandra

- contrôle de représentation ;
- retrait ;
- faible volume ;
- besoin de savoir exactement qui a vu.

## Raphaëlle

- rôle ;
- processus ;
- responsabilité sur l’image ;
- refus que Player parle à sa place.

## Nico

- heure réelle ;
- refus de couverture ;
- langage direct ;
- confidence distincte du mensonge.

---

# 30. Test sans nom

```text
Je ne veux pas la photo. Je veux savoir ce que tu as accepté.
→ Marie

Je ne veux pas devenir la personne qui couvre sans savoir.
→ Mathilde

Dis-lui que je l’ai choisie pour une autre audience.
→ Pauline

Je veux savoir ce que tu veux que je fasse maintenant.
→ Player après violation Sandra

Parle de tes actes. Pas à ma place.
→ Raphaëlle

Je peux garder une confidence. Je ne change pas une heure pour la protéger.
→ Nico
```

---

# 31. Audit anti-générique

J14 évite :

- téléphone qui s’ouvre magiquement sur le secret parfait ;
- témoin qui lit tout le fil ;
- image inventée pour la scène ;
- notification affichant plus que son contenu réel ;
- Marie comprenant immédiatement toute la route ;
- Mathilde devenant complice par défaut ;
- Pauline ou Sandra privées de leur droit de retrait ;
- Raphaëlle réduite au costume ;
- Nico transformé en source omnisciente ;
- suppression qui efface la connaissance ;
- vérité limitée présentée comme réparation automatique ;
- protection d’audience utilisée comme excuse sans heure de retour ;
- nouvelle scène adulte après la découverte.

---

# 32. Critères de validation J14

- [ ] la trace existait avant J14 ;
- [ ] le témoin est réellement présent ;
- [ ] le témoin a une raison d’être près de l’écran ;
- [ ] il ne voit que ce que l’interface affiche ;
- [ ] ce qu’il comprend correctement est défini ;
- [ ] ce qu’il interprète mal est défini ;
- [ ] ce qu’il sait que Player sait est défini ;
- [ ] Player peut dire une vérité limitée ;
- [ ] Player peut mentir ou minimiser avec coût ;
- [ ] Player peut protéger le sujet avec une heure précise ;
- [ ] la personne représentée est prévenue si son audience change ;
- [ ] aucune image privée n’est montrée davantage pour expliquer ;
- [ ] suppression et connaissance restent distinctes ;
- [ ] aucune nouvelle route dominante ;
- [ ] aucune scène adulte ;
- [ ] Marie reste présente ou affectée ;
- [ ] trois fonctions visuelles minimum ;
- [ ] J15 reçoit au moins deux engagements incompatibles ;
- [ ] le fallback existe si aucun mauvais écran n’est crédible.

---

# 33. Résumé canonique candidat

J14 utilise une trace qui existe déjà.

Marie peut voir une version privée de Pauline, une image masquée de Raphaëlle, un message d’alibi de Nico ou une notification Mathilde.

Mathilde peut voir l’image choisie de Sandra et comprendre qu’elle n’était pas destinée à son regard.

Une photographie publique du couple peut rester ouverte au moment où une notification privée apparaît, rendant la version officielle insuffisante sans révéler le contexte complet.

Le témoin ne découvre jamais toute la relation.

Il découvre seulement :

- une image ;
- une phrase ;
- une audience ;
- une contradiction ;
- et la réaction de Player.

Player peut dire une vérité limitée, minimiser ou mentir, ou protéger la personne représentée en différant l’explication à une heure précise.

Toute image vue hors audience doit être signalée à son autrice ou à la personne représentée.

Supprimer le contenu ne supprime pas ce que le témoin sait.

Si aucune trace n’a réellement survécu, aucun accident n’est inventé.

J14 se ferme sur au moins deux obligations que J15 rendra incompatibles.

> **L’écran ne révèle pas la vérité entière. Il révèle qu’une vérité existe et que Player savait où elle était cachée.**

---

# Annexe canonique — Identifiants consolidés

```text
trace_id: j14_discovery_event_01
fact_id: fact_witness_saw_limited_trace
fact_id: fact_trace_controller_informed_of_audience_breach
fact_id: fact_player_explanation_to_witness
promise_id: j14_witness_clarification
promise_id: j14_inform_trace_controller
```

Aucune variante J14 n’existe sans `discovered_trace_id` déjà créé et encore affichable.
