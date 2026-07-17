# Réseau Intime — J07 Script narratif complet

## Statut

**Catégorie : Canon candidat à validation narrative**

**Périmètre : J07 uniquement**

**Surface : messagerie texte uniquement**

Ce document définit la version narrative complète de J07 avant toute adaptation technique.

Il ne contient :

- aucun JSON ;
- aucun flag runtime définitif ;
- aucun changement de script Godot ;
- aucune migration ;
- aucun asset ;
- aucun prompt ComfyUI ;
- aucune scène audio ;
- aucun appel joué ;
- aucun message vocal.

Les événements physiques restent hors téléphone et ne sont jamais dialogués comme des scènes audio.

---

# 1. Décision principale de la journée

J07 n’est plus une journée Sandra.

L’ancienne scène :

```text
Sandra — vingt minutes après le poste
```

est conservée comme matériau narratif futur pour J10, où une continuité extérieure peut réellement devenir une rencontre.

J07 devient :

```text
Lundi — Ce qu’on ne dit qu’à une personne
```

Son pivot est Nico.

La fonction principale est :

```text
Player ne choisit pas une route.
Il choisit ce qu’il est prêt à reconnaître devant un ami
qui n’est ni neutre ni omniscient.
```

---

# 2. Position dans la saison

## État d’entrée

À la fin de J06 :

- Marie a reçu un acte, une échéance ou une vérité ;
- une attention Mathilde a pu être reconnue, plaisantée, remise à distance ou ignorée ;
- Sandra reste une continuité légère issue de J01/J03 ;
- Pauline et Bastien existent dans une vie sociale réelle ;
- Raphaëlle possède un accès professionnel R1 ;
- Nico connaît le séjour temporaire de Mathilde par Marie ;
- aucune route extérieure n’est propriétaire de la partie ;
- aucun accès adulte n’est ouvert ;
- aucune femme n’a été autorisée par un échange entre les hommes.

## Fonction de sortie

À la fin de J07 :

- Nico connaît une contradiction limitée et précisément sourcée ;
- Nico a nommé son propre intérêt pour Marie et Mathilde ;
- il a explicitement refusé la position de conseiller neutre ;
- Player et Nico ont prévu une continuation mardi à 18 h 45 ;
- une obligation professionnelle Raphaëlle existe avant mardi 19 h ;
- une demande domestique Marie/Mathilde existe, est amendée ou refusée ;
- J08 dispose d’au moins deux attentes capables de se superposer ;
- aucune route n’est sélectionnée ;
- aucune femme ne devient disponible parce que Nico a parlé.

---

# 3. Question dramatique

> Player cherche-t-il auprès de Nico une écoute, une permission ou un complice ?

La bonne scène ne répond pas à la question par une morale.

Elle révèle plutôt :

- ce que Player accepte de dire ;
- ce que Nico a réellement observé ;
- ce que Nico veut lui-même ;
- la limite entre confidence et alibi ;
- la différence entre nommer un désir et assumer ses conséquences.

---

# 4. Architecture de la journée

```text
09:30  conséquence matinale Marie, hors téléphone si nécessaire
11:04  Raphaëlle — obligation professionnelle courte
22:46  Nico — confidence principale après fermeture de L’Annexe
23:16  Marie — demande domestique pour mardi
```

La journée possède :

- un seul pivot dramatique : Nico ;
- une ligne secondaire professionnelle ;
- un retour couple/foyer très court ;
- aucun groupe ;
- aucune progression Sandra, Mathilde ou Pauline ;
- aucune image obligatoire.

---

# 5. Fenêtre A — Lundi matin — Ce qui a été promis

## Cas 1 — Une obligation café existe depuis J06

Le café promis à Marie a lieu à 09:30.

```text
Player et Marie se retrouvent dehors.
Le téléphone reste dans la poche.
La promesse est payée par la présence réelle.
```

Aucun dialogue oral n’est montré.

Le résultat narratif est simplement :

- Player est venu à l’heure ;
- ou le résultat hérite de la conséquence déjà définie avant J07.

## Cas 2 — Aucune obligation café

La semaine recommence ordinairement.

```text
Marie part vers La Verrière.
Player part vers son travail.
Mathilde organise sa propre journée.
```

Aucun faux message n’est ajouté pour remplir le matin.

---

# 6. Fenêtre B — 11:04 — Raphaëlle, version mobile

## Fonction

Cette scène :

- rappelle que Raphaëlle existe hors de la route adulte ;
- crée une obligation professionnelle crédible pour mardi ;
- ne constitue pas une progression relationnelle ;
- prépare J08 sans fabriquer une urgence romantique.

## Contexte

Raphaëlle et Player sont au travail dans des espaces distincts.

Mode :

```text
WORK_CHAT
```

## Carte de voix

```text
principal_speaker: Raphaëlle
voice_state: ordinary_professional
public_or_private: work_private
message_burst_shape: 3 messages, réponse, 3 messages
humor_mode: exact dry return
punctuation_mode: complete
emoji_budget: 0
forbidden_leakage: pas de diagnostic du couple, pas de “cadre” répété
```

## Script complet

**11:04 — Raphaëlle**

> Le point client passe à mercredi, 9 h.

**11:04 — Raphaëlle**

> La version mobile doit être relue demain avant 19 h.

**11:05 — Raphaëlle**

> Je t’envoie le lien à 17 h. C’est toujours ta section.

**Réponse Player guidée**

> oui. si je bloque, je te le dis avant 17 h

**11:06 — Raphaëlle**

> Merci.

**11:06 — Raphaëlle**

> Avant 17 h, donc.

**Réponse Player guidée**

> j’avais compris le concept

**11:07 — Raphaëlle**

> Tu avais aussi compris « à vérifier ».

**11:07 — Raphaëlle**

> Je préfère vérifier.

## Variante si Player avait retardé sa correction J03

La troisième ligne devient :

> La version mobile est toujours à toi. Je précise parce que le passé récent est instructif.

La dernière ligne devient :

> Ce n’est pas un reproche. C’est une date.

## Conséquence

```text
Raphaëlle attend une relecture avant mardi 19 h.
```

Ce n’est pas :

- une invitation privée ;
- un prétexte de séduction ;
- une dette sentimentale ;
- une route choisie.

---

# 7. Fenêtre C — 22:46 — Nico après la salle

## Fonction

C’est le pivot principal de J07.

Nico :

- remarque une contradiction sans connaître les fils privés ;
- dit ce qu’il a vu socialement ;
- révèle son propre intérêt ;
- refuse d’être traité comme un conseiller neutre ou un futur alibi ;
- propose de continuer mardi avant son service.

## Contexte

L’Annexe vient de fermer.

Nico est encore sur place :

- salle vide ;
- tablier retiré ou desserré ;
- plannings à finir ;
- table essuyée deux fois ;
- aucune clientèle à divertir.

Player est ailleurs :

- encore au travail ;
- en trajet ;
- dehors ;
- ou dans un lieu où l’échange écrit reste crédible.

Mode :

```text
REMOTE_ASYNC
```

Aucune rencontre n’a lieu ce soir.

## Carte de voix

```text
principal_speaker: Nico
voice_state: quiet_after_service
public_or_private: private_friendship
message_burst_shape: courts messages, humour qui tombe
humor_mode: salle / table / service
punctuation_mode: oral direct
emoji_budget: 0
forbidden_leakage: pas de thérapeute, pas de “frérot”, pas de vulgarité continue
```

## 7.1 Ouverture commune

**22:46 — Nico**

> La salle est vide.

**22:46 — Nico**

> J’ai essuyé la même table deux fois.

**22:47 — Nico**

> Je commence à me méfier de moi.

**Réponse Player guidée**

> tu veux me parler de quoi

**22:48 — Nico**

> De toi, malheureusement.

### Variante si Player avait demandé à Nico si Marie allait bien

**22:48 — Nico**

> Vendredi, tu m’as demandé si Marie avait l’air bien.

### Variante sinon

**22:48 — Nico**

> Vendredi, on parlait d’une chaise et tu as quand même fini par revenir à Marie.

**22:49 — Nico**

> Pas si elle t’en voulait.

**22:49 — Nico**

> Si elle avait l’air bien.

**Réponse Player guidée**

> et ça t’a fait penser à quoi

**22:50 — Nico**

> Que tu regardes si elle sait passer une bonne soirée sans toi.

**22:50 — Nico**

> Et que ça te rassure autant que ça t’agace.

À cet instant, le choix principal apparaît.

---

# 8. Choix principal Nico

Les trois choix ne sélectionnent aucun personnage.

Ils définissent :

1. ce que Player reconnaît ;
2. ce qu’il demande à Nico ;
3. ou la distance qu’il conserve.

---

## Choix A — Reconnaître la contradiction

**Player**

> je suis bien avec elle. et j’aime quand quelqu’un d’autre me regarde autrement. les deux sont vrais

**22:52 — Nico**

> Oui.

**22:52 — Nico**

> Et tant que tu ne choisis rien, tu peux appeler le deuxième « rien ».

**Player**

> c’est un peu facile

**22:53 — Nico**

> Oui.

**22:53 — Nico**

> C’est pour ça que je le fais gratuitement.

Nico cesse ensuite de plaisanter.

**22:54 — Nico**

> Je vais être clair aussi.

**22:54 — Nico**

> Marie me plaît.

**22:55 — Nico**

> Mathilde aussi. Pas de la même façon.

**22:55 — Nico**

> Ça ne me donne rien.

**22:55 — Nico**

> Mais mon avis n’est pas neutre.

### Connaissance créée

Nico sait que :

- Player se dit bien avec Marie ;
- Player aime recevoir ailleurs une attention spéciale ;
- Player n’a nommé aucune relation précise ;
- Player n’a demandé aucune permission.

Il ne sait pas :

- ce que Sandra a envoyé ;
- ce que Mathilde a écrit ;
- ce que Pauline ou Raphaëlle ont montré ;
- ce qui s’est physiquement produit ;
- ce que Marie sait.

---

## Choix B — Demander ce que Nico a perçu

**Player**

> toi, tu as vu quoi exactement

**22:52 — Nico**

> Que tu regardes Marie quand elle parle aux autres.

**22:52 — Nico**

> Pas comme un mec qui s’ennuie.

**22:53 — Nico**

> Comme un mec qui vérifie si elle a encore besoin de lui.

**22:53 — Nico**

> Et tu réponds vite dès que Mathilde entre dans la conversation.

**Player**

> tu lis beaucoup dans trois phrases

**22:54 — Nico**

> Possible.

**22:54 — Nico**

> Je travaille avec des gens qui mentent sur leur dernière commande depuis six ans.

**22:55 — Nico**

> Ça déforme.

Nico nomme ensuite sa propre position.

**22:55 — Nico**

> Et je préfère te prévenir.

**22:56 — Nico**

> Marie me plaît.

**22:56 — Nico**

> Mathilde aussi.

**22:56 — Nico**

> Donc mon avis n’est pas neutre.

### Connaissance créée

Nico sait que :

- Player veut connaître son regard social ;
- Player n’a confirmé aucun fait privé ;
- Player a contesté l’ampleur de son interprétation ;
- Player accepte néanmoins de continuer la discussion.

Nico ne peut pas transformer son observation en preuve.

---

## Choix C — Rester vague

**Player**

> j’ai juste la tête pleine. pas envie d’en faire une théorie

**22:52 — Nico**

> D’accord.

**22:52 — Nico**

> Je vais pas te tirer les mots.

**22:53 — Nico**

> Mais ne me demande pas un alibi un jour en prétendant que je n’avais rien compris.

**Player**

> je t’ai rien demandé

**22:54 — Nico**

> Justement.

**22:54 — Nico**

> Je préfère être en avance.

Nico nomme ensuite sa propre position malgré le refus de confidence.

**22:55 — Nico**

> Et pour que ce soit clair : Marie me plaît.

**22:55 — Nico**

> Mathilde aussi.

**22:56 — Nico**

> Ça ne me donne rien.

**22:56 — Nico**

> Mais je ne suis pas neutre.

### Connaissance créée

Nico sait seulement que :

- Player refuse de parler ce soir ;
- Player n’a pas nié être traversé par quelque chose ;
- Player n’a demandé aucun alibi ;
- Player accepte ou non la continuation proposée ensuite.

Il ne sait aucun contenu privé.

---

# 9. Fermeture commune Nico

Après les trois branches :

**Réponse Player guidée**

> au moins c’est dit

**22:58 — Nico**

> Oui.

**22:58 — Nico**

> Dire ce qu’on veut, c’est la partie facile.

**22:59 — Nico**

> Le reste, c’est ce qu’on en fait et qui est au courant.

**23:00 — Nico**

> Je finis les plannings demain avant le service.

**23:00 — Nico**

> Passe à 18 h 45 si tu veux qu’on termine ça sans le faire tenir dans des bulles.

**Réponse Player guidée**

> je passe. 18 h 45

**23:01 — Nico**

> Ça marche.

**23:01 — Nico**

> Si tu annules, annule.

**23:02 — Nico**

> Ne me fais pas garder une chaise pour une philosophie.

## Conséquence

Une attente réelle existe :

```text
mardi 18 h 45
Player doit passer avant le service de Nico
ou prévenir clairement qu’il ne vient pas
```

Cette attente n’est pas :

- une route Nico–Player ;
- une permission concernant Marie ;
- une permission concernant Mathilde ;
- un alibi ;
- une promesse de partage d’images.

---

# 10. Fenêtre D — 23:16 — Marie et le constat

## Fonction

Cette courte scène :

- revient vers la vie commune ;
- implique Mathilde sans créer une tension de séduction ;
- ajoute une obligation domestique possible pour mardi ;
- permet une réponse active, amendée ou refusée ;
- prépare J08 sans punition arbitraire.

## Contexte

Marie est au foyer.

Player est encore :

- en trajet ;
- dehors ;
- au travail ;
- ou suffisamment séparé pour que l’échange écrit soit crédible.

Le propriétaire ne téléphone pas dans une scène jouée.

Il doit passer physiquement mardi pour le constat lié au dégât des eaux de Mathilde.

## Carte de voix

```text
principal_speaker: Marie
voice_state: practical_tired
public_or_private: private_couple
message_burst_shape: 4 messages puis choix
humor_mode: administration domestique
punctuation_mode: normal
emoji_budget: 0
forbidden_leakage: pas de diagnostic, pas de jalousie Nico
```

## Script commun

**23:16 — Marie**

> Demain, le propriétaire passe pour le constat de Mathilde.

**23:16 — Marie**

> 19 h 15.

**23:17 — Marie**

> Elle finit tard et moi je suis à La Verrière.

**23:17 — Marie**

> Tu peux être à l’appart ?

---

# 11. Choix Marie

## Choix A — Présence précise

**Player**

> oui. 19 h 15, je serai là

**23:18 — Marie**

> Merci.

**23:18 — Marie**

> Les papiers sont dans la pochette bleue.

**23:19 — Marie**

> Pas la verte. La verte contient des choses que même l’administration a abandonnées.

### Conséquence

```text
présence Player attendue mardi à 19 h 15
```

Cette obligation entre directement en tension avec Nico à 18 h 45 et la relecture Raphaëlle avant 19 h.

---

## Choix B — Alternative précise

**Player**

> je peux être là à 18 h 30, pas 19 h 15. demande-lui s’il peut avancer

**23:18 — Marie**

> Je lui écris.

**23:19 — Marie**

> Je te dis dès qu’il répond.

**23:19 — Marie**

> C’est une vraie alternative. Je prends.

### Conséquence

```text
créneau domestique en cours d’amendement
réponse du propriétaire attendue mardi
```

J08 peut alors montrer :

- l’alternative acceptée ;
- l’alternative refusée ;
- ou une réponse tardive qui crée une superposition réelle.

---

## Choix C — Refus honnête

**Player**

> je ne peux pas demain. dis-lui de voir avec moi mercredi

**23:18 — Marie**

> D’accord.

**23:19 — Marie**

> Je vais lui écrire.

**23:19 — Marie**

> Mais je ne garde pas le créneau en suspens.

### Conséquence

Marie et Mathilde cherchent une autre solution.

Player ne reçoit :

- ni punition artificielle ;
- ni nouvelle route de compensation ;
- ni obligation domestique mardi soir.

J08 conserve néanmoins :

- la relecture Raphaëlle ;
- la rencontre Nico ;
- les conséquences du refus domestique.

---

# 12. Fin de journée

Aucun nouveau message ne suit.

Player ne reçoit pas :

- un résumé ;
- un écran de score ;
- une notification de route ;
- une phrase annonçant qu’il a « choisi Nico » ;
- une morale.

La journée se termine sur la coexistence de choses concrètes :

```text
travail à relire
ami à retrouver
foyer à organiser ou à laisser s’organiser sans lui
```

---

# 13. États narratifs de sortie

## Raphaëlle

```text
version mobile attendue mardi avant 19 h
```

Elle ne possède aucune progression privée.

## Nico

Une seule connaissance principale est enregistrée selon le choix :

### Branche A

```text
Player reconnaît aimer une attention extérieure
sans renier sa relation avec Marie
```

### Branche B

```text
Player demande le regard social de Nico
sans confirmer de faits privés
```

### Branche C

```text
Player refuse de se confier ce soir
mais accepte une continuation mardi
```

Dans toutes les branches :

```text
Nico a dit que Marie et Mathilde lui plaisent.
Nico a dit que cela ne lui donne aucun droit.
Nico refuse d’être considéré comme neutre.
```

## Marie / foyer

Un des trois états :

```text
présence mardi 19 h 15 confirmée
créneau domestique amendé et réponse attendue
refus honnête, solution extérieure en cours
```

## J08

Attentes disponibles :

```text
Raphaëlle avant 19 h
Nico à 18 h 45
foyer à 19 h 15 ou conséquence d’amendement/refus
```

J08 pourra donc :

- récompenser une anticipation réelle ;
- montrer une superposition dure ;
- montrer une alternative qui tient ;
- ou montrer que le refus propre a déjà fermé une obligation.

---

# 14. Personnages absents

## Sandra

Aucun nouveau message.

Son absence :

- protège son rythme ;
- évite de transformer J07 en catalogue ;
- conserve la scène des vingt minutes pour J10.

## Mathilde

Elle existe dans le problème du constat mais ne demande rien directement à Player.

Cette absence rappelle :

- Marie peut organiser avec sa cousine ;
- Player n’est pas le centre de chaque problème ;
- une obligation domestique n’est pas une route Mathilde.

## Pauline et Bastien

Aucun message.

Leur vie officielle continue hors champ.

---

# 15. Traitement de l’ancien matériau J07

La scène runtime historique :

```text
chapter_07_sandra_end_of_shift
```

ne doit pas être supprimée pendant la phase narrative.

Elle est reclassée comme matériau possible pour :

```text
J10 — S16 Le café enfin tenu
```

Éléments réutilisables :

- sortie de poste ;
- café du déjeuner précédent ;
- train dans vingt minutes ;
- rencontre bornée ;
- déjeuner futur ;
- limite douce.

Éléments à corriger avant réutilisation :

- aucune « deuxième photo floue » ;
- aucune logique de ticket ;
- aucun statut de vague ;
- continuité avec Sandra J01 réécrite autour de la représentation choisie.

---

# 16. Audit des voix

## Raphaëlle

Reconnaissable par :

- trois informations précises ;
- responsabilité existante ;
- humour sec sur `à vérifier` ;
- aucune analyse relationnelle ;
- aucun emoji.

Risque évité :

```text
Raphaëlle comme oracle calme qui comprend toute la scène
```

## Nico

Reconnaissable par :

- salle vide ;
- table essuyée ;
- oralité courte ;
- humour qui tombe ;
- désir nommé ;
- intérêt personnel admis ;
- alibi refusé avant d’être demandé ;
- chaise comme objet concret.

Risque évité :

```text
Nico comme thérapeute ou tentateur omniscient
```

## Marie

Reconnaissable par :

- heure ;
- action ;
- problème du foyer ;
- alternative acceptée si elle est réelle ;
- humour pratique sur les pochettes ;
- refus traité sans monologue.

Risque évité :

```text
Marie comme police jalouse des fils privés
```

## Player

Reconnaissable par :

- minuscules ;
- réponses courtes ;
- première formulation imparfaite ;
- contradiction reconnue sans confession parfaite ;
- précision lorsqu’il s’engage ;
- possibilité de refuser proprement.

---

# 17. Test sans nom

Les lignes suivantes doivent rester attribuables :

```text
La version mobile doit être relue demain avant 19 h.
→ Raphaëlle

J’ai essuyé la même table deux fois.
→ Nico

Ne me fais pas garder une chaise pour une philosophie.
→ Nico

Les papiers sont dans la pochette bleue.
→ Marie

Pas la verte. La verte contient des choses que même l’administration a abandonnées.
→ Marie

j’ai juste la tête pleine. pas envie d’en faire une théorie
→ Player
```

La reconnaissance ne dépend d’aucun nom propre dans la phrase.

---

# 18. Test de substitution

## Nico → Raphaëlle

```text
Ne me fais pas garder une chaise pour une philosophie.
```

Échec de substitution : trop oral, concret et lié à une place sociale pour Raphaëlle.

## Raphaëlle → Marie

```text
La version mobile doit être relue demain avant 19 h.
```

Échec de substitution : responsabilité professionnelle précise, sans mouvement de vie commune.

## Marie → Pauline

```text
Pas la verte. La verte contient des choses que même l’administration a abandonnées.
```

Friction : Pauline pourrait produire une phrase sèche, mais elle contrôlerait plutôt l’audience ou la contradiction ; Marie parle ici du foyer et d’un objet partagé.

---

# 19. Audit anti-dialogue générique

La scène évite :

- le banter parfaitement symétrique ;
- quatre personnages qui utilisent la même précision ;
- une longue confession parfaitement structurée ;
- Nico qui sait ce qu’il n’a pas vu ;
- Player qui énumère les femmes ;
- une femme autorisée par les hommes ;
- une conclusion aphoristique trop propre ;
- une compensation après refus ;
- une scène audio future nécessaire pour comprendre J08.

Messages volontairement ordinaires :

- date du point client ;
- lien envoyé à 17 h ;
- table essuyée ;
- plannings ;
- créneau du propriétaire ;
- pochettes de papiers.

Ces éléments permettent aux lignes fortes de rester rares.

---

# 20. Contrat visuel différé

Aucune image n’est conçue.

Trois slots fonctionnels minimum :

1. Raphaëlle / travail ordinaire ;
2. Nico / L’Annexe après fermeture ;
3. Marie / foyer / documents Mathilde.

Les images seront fournies plus tard par Ludovic via ComfyUI.

Ce document ne fixe :

- ni pose ;
- ni tenue ;
- ni cadrage ;
- ni décor précis ;
- ni prompt ;
- ni workflow.

---

# 21. Critères de validation J07

- [ ] Nico est le pivot principal ;
- [ ] aucun menu Sandra/Mathilde/Pauline ;
- [ ] Nico ne sait que ce qu’il a vu ou ce que Player lui dit ;
- [ ] Nico nomme son propre intérêt ;
- [ ] Nico ne demande aucune image ;
- [ ] aucune femme n’est autorisée par la confidence ;
- [ ] l’alibi est refusé ou borné ;
- [ ] Raphaëlle reste professionnelle ;
- [ ] Marie revient par une action concrète ;
- [ ] le refus domestique ne déclenche aucune route de remplacement ;
- [ ] J08 possède au moins deux attentes réelles ;
- [ ] tout dialogue est textuel ;
- [ ] aucune scène audio n’est nécessaire ;
- [ ] aucune image n’est conçue ;
- [ ] aucune donnée technique n’est produite.

---

# 22. Résumé canonique candidat

J07 commence par une responsabilité professionnelle ordinaire avec Raphaëlle.

Après la fermeture de L’Annexe, Nico remarque que Player vérifie si Marie sait vivre sans lui. Player peut reconnaître sa contradiction, demander ce que Nico a vu ou refuser de parler davantage.

Nico révèle alors que Marie et Mathilde lui plaisent et précise que cela ne lui donne aucun droit. Il refuse d’être considéré comme un conseiller neutre ou un futur alibi.

Player promet de passer mardi à 18 h 45 avant son service.

Marie demande ensuite une présence au foyer mardi à 19 h 15 pour le constat lié à Mathilde. Player peut accepter, proposer une vraie alternative ou refuser honnêtement.

J07 ne choisit aucune route.

Elle transforme simplement :

```text
travail
+ amitié
+ foyer
```

en attentes capables d’entrer en conflit pendant J08.

> **La journée ne demande pas à Player quelle femme il veut. Elle lui demande quelle part de lui-même il accepte de montrer à un ami qui a lui aussi quelque chose à gagner.**