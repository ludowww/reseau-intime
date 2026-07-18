# Réseau Intime — J09 Script narratif complet

## Statut

**Catégorie : Canon validé narrativement — source pré-runtime consolidée**

**Périmètre : J09 uniquement**

**Surface : messagerie texte uniquement**

Ce document définit la source narrative consolidée de J09 après les audits et les lots A–C.

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

J09 devient :

```text
Mercredi — Dans son élément
```

Sa fonction principale est :

```text
montrer Marie dans une vie visible,
professionnelle, sociale et désirable,
qui existe avec ou sans Player
```

La journée ne demande pas :

- si Player autorise Marie à sortir ;
- si Marie cherche à le rendre jaloux ;
- si une route extérieure doit gagner ;
- si la robe noire ouvre un accès adulte ;
- si l’absence de Player doit être punie.

Elle demande :

> Player rejoint-il réellement la vie visible de Marie, vient-il seulement la regarder, ou lui laisse-t-il une autonomie qu’il assume sans transformer ensuite l’absence en reproche ?

---

# 2. État d’entrée depuis J08

J08 a établi que :

- les autres continuent leur vie sans Player ;
- une alternative précise peut fonctionner ;
- un refus honnête ferme une attente ;
- une réponse vague fait agir les autres sans lui ;
- Raphaëlle distingue le travail d’une dette sentimentale ;
- Nico ne garde une chaise que si `nico_j07_tuesday_1845` a réellement été accepté ;
- Marie et Mathilde savent organiser le foyer autrement.

Marie a annoncé :

> Demain je finis tard à La Verrière.

> Élodie a prévu une rallonge noire et trois personnes qui ne savent pas lire un plan.

> Je te redis pour l’heure.

Aucune route extérieure n’est sélectionnée à l’entrée de J09.

---

# 3. Architecture de la journée

```text
15:48  écho bref de J08
15:49  Marie donne les heures et distingue besoin / envie
16:02  trace privée robe noire
18:00  montage hors téléphone pour la branche A
19:00  ouverture de l’événement
20:15  arrivée tardive éventuelle pour la branche B
22:35  fermeture
23:05  trace de fin de soirée
23:07  retour textuel après séparation réelle
```

J09 possède :

- un pivot unique : Marie ;
- un choix principal de présence ;
- une qualité de présence déterminée par les actes ;
- aucune superposition nouvelle ;
- aucune scène adulte ;
- aucune obligation extérieure créée en compensation.

---

# 4. Écho bref de J08

Une seule variante modifie le ton.

## 4.1 J08 payé ou amendé clairement

**15:48 — Marie**

> Hier, merci d’avoir donné des heures qui existaient vraiment.

**15:48 — Marie**

> Je vais tenter la même méthode aujourd’hui.

## 4.2 Refus domestique honnête

**15:48 — Marie**

> Hier, merci d’avoir dit non avant qu’on organise autour de toi.

**15:48 — Marie**

> Aujourd’hui, même principe.

## 4.3 Réponse vague ou attente ratée

**15:48 — Marie**

> Hier, on a fini par organiser sans savoir où tu étais.

**15:48 — Marie**

> Aujourd’hui je te donne les heures avant.

Ces variantes ne modifient pas le droit de Marie à vivre la soirée.

---

# 5. Fenêtre A — La Verrière avant l’ouverture

Marie est déjà à La Verrière.

Player se trouve ailleurs.

Mode :

```text
REMOTE_ASYNC
```

**15:49 — Marie**

> Portes à 19 h.

**15:49 — Marie**

> Trente-cinq personnes annoncées.

**15:50 — Marie**

> Donc probablement cinquante et une dame qui demandera pourquoi le logo est petit.

**15:50 — Marie**

> J’ai besoin de deux bras à 18 h.

**15:51 — Marie**

> Et j’ai envie que tu viennes.

**15:51 — Marie**

> Ce sont deux raisons différentes.

**Player guidé**

> et la rallonge noire

**15:52 — Marie**

> Arrivée.

**15:52 — Marie**

> La grise est toujours maudite.

**15:53 — Marie**

> Nous respectons les traditions.

Marie distingue :

```text
besoin logistique
!=
envie personnelle de voir Player
```

---

# 6. La robe noire

**16:02 — Marie**

> Et j’ai gardé la robe noire.

**16:02 — Marie**

> Je te préviens. Je ne relance pas le vote.

**Player guidé**

> bonne décision

**16:03 — Marie**

> Je sais 🙂

**16:03 — Marie**

> Elle a survécu au trajet dans mon tote bag. C’est déjà un signe.

```text
trace_id: j09_marie_black_dress_private_01
creator: Marie
owner: Marie
initial_audience: [Marie, Player]
saving_rule: IN_THREAD_ONLY
transfer_rule: FORBIDDEN
fact_id: fact_player_received_marie_black_dress_image
```

Cette trace ne crée :

- aucune permission sexuelle ;
- aucun droit de transfert ;
- aucune promesse de version plus privée ;
- aucune obligation de venir.

---

# 7. Choix principal de présence

## Choix A — Rejoindre tôt et participer

**Player**

> je viens à 18 h. envoie-moi la liste

**15:55 — Marie**

> Marché conclu.

**15:55 — Marie**

> Chaises, rallonges, deux tables et décisions de dernière minute.

**15:56 — Marie**

> Arrive vraiment à 18 h et je serai presque impressionnée.

```text
Player attendu au montage à 18 h
```

## Choix B — Venir plus tard avec une heure précise

**Player**

> je ne peux pas pour le montage. je viens à 20 h 15 et je reste jusqu’à 21 h 30

**15:55 — Marie**

> 20 h 15.

**15:55 — Marie**

> Je ne te garde pas la partie montage.

**15:56 — Marie**

> Je garde juste l’envie de te voir.

**15:56 — Marie**

> Et à 21 h 30, tu pars si tu as dit que tu partais.

```text
Marie organise le montage sans Player
Player attendu de 20 h 15 à 21 h 30
```

## Choix C — Ne pas venir et l’annoncer honnêtement

**Player**

> je ne viens pas ce soir. je te le dis maintenant pour que tu ne m’attendes pas

**15:55 — Marie**

> D’accord.

**15:56 — Marie**

> Je ne garde pas de place.

**15:56 — Marie**

> Et je mets quand même la robe noire.

**15:57 — Marie**

> La soirée aura lieu, donc autant qu’elle soit jolie.

```text
aucune présence Player attendue
Marie organise et vit la soirée sans lui
```

Le choix C n’est jamais formulé comme une permission donnée à Marie.

---

# 8. Branche A — Montage et événement hors téléphone

À l’arrivée de Player :

```text
17:57–séparation finale
co-présence physique
chat direct arrêté
aucun dialogue oral transcrit
```

## 8.1 Qualité A1 — Initiative réelle

```text
Player prend les tables du fond et la rallonge noire sans attendre une relance.
Marie n’a pas besoin de guider chaque geste.
presence_active
```

## 8.2 Qualité A2 — Humour mais action réelle

```text
Player plaisante brièvement mais accomplit les tâches annoncées.
presence_playful_useful
```

## 8.3 Qualité A3 — Présence distraite

```text
Player consulte plusieurs fois un autre fil.
Marie observe l’attention déplacée sans demander le destinataire.
presence_distracted
conséquence de couple active
```

## 8.4 Trace publique

À 19 h 08, Élodie publie :

```text
trace_id: j09_marie_laverriere_public_01
creator: Élodie
owner: La Verrière
initial_audience: groupe photographié / canal La Verrière nommé
fact_id: fact_marie_public_professional_version_visible
```

La publication est une trace sociale passive.

Aucun échange direct Marie / Player n’est affiché pendant la co-présence.

Les verres, cartons, rideaux et rallonges sont gérés physiquement.

---

# 9. Branche B — Arrivée à 20 h 15

Marie a réalisé le montage sans Player.

Elle ne lui fait pas payer une absence annoncée.

## 9.1 Orientation avant l’arrivée

Tant que Player est encore dehors :

**20:12 — Marie**

> Tu es où ?

**Player**

> côté cour

**20:13 — Marie**

> Passe par la porte scène.

**20:13 — Marie**

> Évite l’entrée principale. Il y a six manteaux et personne ne sait à qui ils appartiennent.

Le chat direct s’arrête dès que Player entre dans La Verrière.

## 9.2 Qualité B1 — Rejoindre le mouvement

```text
Player prend les cartons vides puis les verres propres.
presence_late_active
```

## 9.3 Qualité B2 — Venir surtout regarder

```text
Player prend un verre et regarde Marie terminer.
Marie apprécie le regard mais distingue cette présence de l’action.
presence_spectator
```

## 9.4 Qualité B3 — Présence bornée

```text
Player aide jusqu’à 21 h.
Il reste dans la salle jusqu’à 21 h 30.
Il part à l’heure annoncée.
presence_bounded_reliable
```

## 9.5 Trace publique

À 20 h 28, Élodie publie la même trace sociale autorisée :

```text
trace_id: j09_marie_laverriere_public_01
```

La lecture dépend des actes déjà observés.

Aucun message direct Marie / Player n’est affiché dans la salle.

---

# 10. Branche C — Marie vit la soirée sans Player

Marie ne relance pas Player pendant le montage.

Elle ne lui envoie :

- ni succession de preuves ;
- ni photographie destinée à provoquer ;
- ni message passif-agressif ;
- ni invitation tardive.

À 20:37, depuis des lieux distincts :

**20:37 — Marie**

> Élodie a envoyé ça au groupe.

```text
trace_id: j09_marie_laverriere_public_01
```

**20:38 — Marie**

> Je te l’envoie parce que je l’aime bien.

**20:38 — Marie**

> Pas pour te faire venir à 21 h.

**Player guidé**

> tu as l’air bien

**20:39 — Marie**

> Je le suis.

**20:39 — Marie**

> Et j’ai toujours deux cartons à descendre, donc l’émotion reste contenue.

Marie partage une trace qu’elle contrôle sans rouvrir l’invitation.

---

# 11. Fin de l’événement

La fermeture a lieu vers 22 h 35.

Le retour textuel commence seulement après une séparation réelle :

- Player est reparti ;
- Marie termine avec Élodie ;
- ou Marie est en trajet après avoir rendu les clés.

À 23:05 :

**23:05 — Marie**

> Élodie vient de me renvoyer la dernière.

```text
trace_id: j09_marie_laverriere_after_01
creator: Élodie
current_audience: ajoute Player seulement si Marie relaie
fact_id: fact_marie_recontextualized_evening_for_player
```

La trace signifie selon la branche :

- mémoire partagée ;
- Marie regardée dans son monde ;
- autonomie ;
- contraste entre visibilité et présence réelle.

---

# 12. Retour après présence active A1/A2

**23:07 — Marie**

> Merci pour ce soir.

**23:07 — Marie**

> C’était bien de te voir porter des chaises, parler à Élodie et ne pas me demander toutes les cinq minutes si ça allait.

**Player guidé**

> j’étais bien là

**23:08 — Marie**

> Oui.

**23:08 — Marie**

> Je l’ai vu.

**23:09 — Marie**

> Demain, 20 h 30, on mange ensemble ?

Player reçoit un vrai choix.

## M1 — Accepter jeudi

**Player**

> oui. 20 h 30

**Marie**

> Parfait.

```text
promise_id: marie_j09_dinner_j10_2030
status: ACTIVE
```

## M2 — Proposer vendredi

**Player**

> demain non. vendredi 20 h 30 si tu peux

**Marie**

> Vendredi, oui.

```text
promise_id: marie_j09_dinner_friday_2030
status: ACTIVE
```

## M3 — Refuser

**Player**

> non. ne bloque pas pour moi

**Marie**

> D’accord.

```text
promise_id: marie_j09_dinner_j10_2030
status: REFUSED
```

Aucune récompense sexuelle automatique.

---

# 13. Retour après présence distraite A3

**23:07 — Marie**

> Merci d’être venu.

**23:07 — Marie**

> Tu as passé une partie de la soirée dans ton téléphone.

**Player guidé**

> je sais

**23:08 — Marie**

> Je ne fais pas un procès.

**23:08 — Marie**

> Je note la différence.

**23:09 — Marie**

> Demain, ne bloque rien pour moi.

**23:09 — Marie**

> Dis-moi juste si tu rentres.

```text
presence_distracted
aucun rendez-vous couple verrouillé
retour domestique à confirmer
```

---

# 14. Retour après arrivée tardive active B1

**23:07 — Marie**

> Tu es arrivé à l’heure que tu avais donnée.

**23:07 — Marie**

> Et tu as pris un bout de la soirée en charge.

**Player guidé**

> j’aurais préféré être là plus tôt

**23:08 — Marie**

> Peut-être.

**23:08 — Marie**

> Mais tu n’as pas promis plus tôt.

**23:09 — Marie**

> Ce soir, ce que tu as dit et ce que tu as fait se ressemblent.

**23:10 — Marie**

> Demain 20 h 30 ?

Player accepte jeudi, propose vendredi ou refuse selon M1–M3.

```text
presence_late_active
retour couple conditionnel au choix réel
```

---

# 15. Retour après présence de spectateur B2

**23:07 — Marie**

> J’étais contente de te voir.

**23:07 — Marie**

> Mais tu es venu me regarder.

**23:08 — Marie**

> Pas vraiment être avec moi.

**Player guidé**

> c’est pas faux

**23:08 — Marie**

> Non.

**23:09 — Marie**

> Et ce n’est pas rien.

**23:09 — Marie**

> Mais ce n’est pas pareil.

```text
presence_spectator
Marie se sait désirée visuellement
aucun rendez-vous couple automatique
```

Le regard compte mais ne remplace pas l’action.

---

# 16. Retour après présence bornée B3

**23:07 — Marie**

> Tu es parti à 21 h 30.

**23:07 — Marie**

> Exactement comme annoncé.

**Player guidé**

> tu vérifies mes sorties maintenant

**23:08 — Marie**

> Non.

**23:08 — Marie**

> J’apprécie simplement les heures qui ne fondent pas.

**23:09 — Marie**

> Demain 20 h 30, tu peux ?

Player accepte jeudi, propose vendredi ou refuse selon M1–M3.

```text
presence_bounded_reliable
retour couple conditionnel au choix réel
```

---

# 17. Retour après absence honnête C

**23:07 — Marie**

> Je ferme.

**23:07 — Marie**

> La soirée était bien.

**23:08 — Marie**

> Vraiment.

**Player guidé**

> je suis content

**23:08 — Marie**

> Moi aussi.

**23:09 — Marie**

> Et merci d’avoir dit non avant.

**23:09 — Marie**

> Je n’ai attendu personne.

**23:10 — Marie**

> Demain 20 h 30, tu es là ?

Player accepte jeudi, propose vendredi ou refuse selon M1–M3.

```text
absence honnête absorbée
Marie autonome
retour couple conditionnel au choix réel
```

L’absence n’est pas transformée automatiquement en crise.

---

# 18. Personnages secondaires

## Élodie

Élodie existe comme :

- collègue ;
- témoin du travail ;
- créatrice exacte des traces La Verrière ;
- personne non omnisciente sur le couple.

## Pauline et Bastien

Ils peuvent être socialement présents ou hors champ.

Ils ne possèdent aucun fil J09.

Leur convergence reste réservée à J12.

## Nico

Il n’est pas utilisé comme observateur jaloux de la robe noire.

## Mathilde

Elle ne devient pas automatiquement responsable du foyer pendant l’absence de Marie.

## Sandra et Raphaëlle

Aucun message au premier plan.

J10 décidera si une continuité extérieure devient réellement foreground.

---

# 19. Handoff vers J10

J09 ne choisit pas le pivot J10.

États possibles :

```text
presence_active
presence_late_active
presence_bounded_reliable
absence_honest
presence_distracted
presence_spectator
```

Promesses possibles :

```text
marie_j09_dinner_j10_2030 = ACTIVE ou REFUSED
marie_j09_dinner_friday_2030 = ACTIVE
```

J10 lit le statut réel de la promesse avant toute opportunité extérieure.

Aucune route extérieure ne reçoit un avantage automatique.

---

# 20. Contrat visuel différé

## V1 — Préparation privée

```text
trace_id: j09_marie_black_dress_private_01
fonction: représentation choisie par Marie
audience: [Marie, Player]
```

## V2 — Vie professionnelle et sociale

```text
trace_id: j09_marie_laverriere_public_01
fonction: Marie visible dans son monde
creator: Élodie
audience: groupe / canal La Verrière nommé
```

## V3 — Fin de soirée

```text
trace_id: j09_marie_laverriere_after_01
fonction: mémoire, autonomie ou conséquence
creator: Élodie
audience: Player seulement après relais Marie
```

Aucune pose, aucun cadrage et aucun prompt ne sont fixés ici.

---

# 21. Audit text-only

J09 ne contient :

- aucun échange direct pendant le montage ;
- aucun choix interactif dans la salle ;
- aucun dialogue oral transcrit ;
- aucun message émotionnel pendant la co-présence ;
- aucun retour de couple avant une séparation réelle.

Le seul échange d’orientation de la branche B a lieu avant l’entrée physique de Player.

---

# 22. Audit de voix

Marie reste reconnaissable par :

- les heures ;
- le mouvement ;
- La Verrière ;
- l’humour pratique ;
- la différence entre envie et besoin ;
- le refus des promesses décoratives ;
- la capacité à vivre la soirée sans Player.

Player reste :

- en minuscules ;
- court ;
- capable de donner une heure ;
- capable d’être honnêtement absent ;
- capable de confondre regard et présence.

---

# 23. Critères de validation

- [ ] Marie est le pivot unique ;
- [ ] la robe noire est choisie par Marie ;
- [ ] les trois choix de présence sont réels ;
- [ ] aucune co-présence n’est jouée par messages ;
- [ ] Élodie crée les traces La Verrière ;
- [ ] le dîner J10 est accepté, amendé ou refusé ;
- [ ] aucun dîner n’est créé par une réponse guidée ;
- [ ] l’absence honnête ne punit pas Player ;
- [ ] le regard ne remplace pas l’action ;
- [ ] J10 reste libre de sélectionner son pivot selon l’histoire.

> **Marie n’a pas besoin que Player autorise sa vie. J09 mesure seulement s’il est capable de la rejoindre sans confondre sa présence, son regard et son désir.**
