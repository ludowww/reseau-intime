# Réseau Intime — Lot A Corrections bloquantes J01–J21

## Statut

**Catégorie : Autorité corrective canonique validable**

**Périmètre : J10, J12, J14, J17 et J21**

**Base : audit global validé `J01_J21_AUDIT_GLOBAL_DIALOGUES_CONTINUITE.md`**

Ce document applique les quatre corrections bloquantes du lot A :

```text
A1 calendrier J17 / J21
A2 promesse Sandra déplacée J10 → paiement J12
A3 suppression des conversations interactives en co-présence
A4 posture finale C disponible seulement pour une contradiction déjà active
```

Il prévaut immédiatement sur les passages contradictoires des scripts concernés.

Jusqu’au lot C de consolidation des sources, les scripts complets restent lisibles avec la règle suivante :

```text
script source
→ présent correctif obligatoire
→ audit global
```

Le lot A ne modifie :

- aucune route ;
- aucun état final de personnage ;
- aucun niveau d’intimité ;
- aucun JSON ;
- aucun script Godot ;
- aucun test ;
- aucun asset ;
- aucune galerie.

---

# 1. Décisions consolidées

## 1.1 Calendrier

Le calendrier reste :

```text
J17 jeudi
J18 vendredi
J19 samedi
J20 dimanche
J21 lundi
```

Toute promesse créée en J17 et encore active après J21 doit utiliser :

- une date explicitement postérieure à J21 ;
- une heure ;
- une personne responsable de la confirmation ;
- un statut clair.

Les mots `dimanche`, `jeudi` ou `la semaine prochaine` ne suffisent pas seuls lorsqu’ils déterminent une règle de couple.

## 1.2 Text-only

```text
co-présence physique
→ aucun dialogue interactif direct
```

Sont autorisés pendant la co-présence :

- une notification passive ;
- un message de groupe produit pour une audience sociale réelle ;
- un état narratif non dialogué ;
- une trace photographique créée par une source indépendante.

Ne sont pas autorisés :

- un choix Player envoyé à la personne assise à côté ;
- un échange émotionnel depuis deux pièces du même logement ;
- une conversation complète pendant un montage, un repas ou une rencontre ;
- une séparation artificielle de quelques mètres servant uniquement à rouvrir le chat.

## 1.3 Promesse

Toute promesse possède :

```text
created_at
accepted_at
due_at
status
paid_or_closed_by
```

Le lot A fixe narrativement ces informations sans encore définir le format runtime.

## 1.4 Contradiction finale

La posture sombre de J21 :

```text
maintenir consciemment une contradiction
```

ne peut jamais créer la première violation.

Elle prolonge seulement un état sombre déjà actif à la fin de J20.

---

# 2. A1 — Correction du calendrier J17 / J21

## 2.1 Décision canonique

Le point de contrôle du couple est déplacé après J21.

Valeur documentaire de référence :

```text
couple_review_due_at:
jeudi suivant J21, 20 h 30
```

Une journée complète éventuellement promise à Marie est fixée :

```text
couple_shared_day_due_at:
dimanche suivant le point de jeudi
```

Ces deux promesses sont distinctes.

La seconde n’existe que si Player l’a proposée et Marie l’a acceptée.

## 2.2 Correction J17 — Présence concrète

Dans `J17_SCRIPT_NARRATIF_COMPLET.md`, la branche C17-A2 ne crée plus une journée le dimanche J20.

### Ancienne intention à remplacer

```text
Player bloque dimanche avec Marie.
```

### Texte canonique corrigé

**Player**

> jeudi prochain 20 h 30 pour notre point. et si on décide encore d’essayer, je bloque le dimanche d’après avec toi

**Marie**

> Jeudi 20 h 30.

**Marie**

> Une heure réelle.

**Marie**

> Le dimanche d’après n’existe pas encore comme récompense.

**Marie**

> On le confirme jeudi si on est toujours capables de tenir la même règle.

### État

```text
couple_review_due_at = jeudi suivant J21, 20 h 30
couple_shared_day_due_at = conditionnel
aucune obligation couple supplémentaire avant J21
```

Cette correction maintient l’intention :

- acte concret ;
- pas de grande promesse vague ;
- présence future possible ;
- aucune concurrence avec J20.

## 2.3 Correction J17 — Accord provisoire

Le retour textuel de l’accord provisoire devient :

**Player**

> combien de temps

**Marie**

> Jusqu’à jeudi prochain.

**Marie**

> 20 h 30.

**Marie**

> Après, on ne pourra pas appeler `provisoire` quelque chose qui n’a aucune date.

### État

```text
couple_state = accord_provisoire
couple_review_due_at = jeudi suivant J21, 20 h 30
nouvelles progressions extérieures suspendues jusque-là
```

## 2.4 Correction J17 — Reconfiguration en négociation

Le retour textuel devient :

**Marie**

> On n’a pas décidé d’ouvrir quoi que ce soit.

**Marie**

> On a décidé d’arrêter de prétendre que la seule alternative était le silence ou la trahison.

**Marie**

> Jusqu’à jeudi prochain, 20 h 30 : aucune nouvelle étape avec personne.

**Marie**

> Après, on parle de ce que chacun peut réellement accepter.

### État

```text
couple_state = reconfiguration_en_negociation
couple_review_due_at = jeudi suivant J21, 20 h 30
aucune permission rétroactive
pause actuelle
```

## 2.5 Correction J21 — Accord provisoire

Le matin devient :

**07:42 — Marie**

> J’ai pris le café dans la grande tasse.

**07:43 — Marie**

> La petite était dans la chambre où tu dors.

**07:43 — Marie**

> Phrase toujours étrange.

**07:44 — Marie**

> Jeudi 20 h 30 tient toujours.

**07:44 — Marie**

> Jusqu’à jeudi, notre règle tient aussi.

Le soir ne répète plus `Dimanche tient`.

La branche se ferme sur une information déjà valide envoyée avant toute co-présence :

**18:52 — Marie**

> Je rentre vers 20 h 30.

**18:53 — Marie**

> Je prends la chambre ce soir.

**18:53 — Marie**

> Jeudi tient.

**Player**

> d’accord

**Marie**

> À tout à l’heure.

La messagerie s’arrête lorsque Marie rentre.

## 2.6 Correction J21 — Reconfiguration

Le matin devient :

**07:44 — Marie**

> Pour nous : aucune nouvelle étape avant jeudi 20 h 30.

**07:45 — Marie**

> Je préfère le réécrire un matin normal.

**07:45 — Marie**

> Pas uniquement quand quelqu’un nous oblige à en parler.

La branche du soir se place avant la rencontre physique éventuelle :

**18:52 — Marie**

> La règle a tenu aujourd’hui.

**18:52 — Marie**

> Une journée.

**18:53 — Marie**

> Je préfère compter les actes plutôt que déclarer une nouvelle vie après vingt-quatre heures.

**Player**

> oui

**18:54 — Marie**

> Jeudi 20 h 30.

La messagerie s’arrête à la co-présence.

## 2.7 Effet sur J20

J20 ne paie plus le point de couple.

Il peut seulement lire :

```text
couple_review_due_at > J21
```

Nico ne devient ni arbitre ni témoin automatique de cette promesse.

---

# 3. A2 — Paiement de la promesse Sandra en J12

## 3.1 Promesse créée en J10

La branche J10 S-B reste :

**Player**

> pas aujourd’hui. samedi 11 h au même endroit si tu peux

**Sandra**

> Samedi, peut-être.

**Sandra**

> Je te confirme vendredi avant 18 h.

**Sandra**

> Si je ne confirme pas, on ne garde pas le café vivant par principe.

L’état est précisé :

```text
promise_id = sandra_cafe_saturday_1100
created_at = J10 12:24
accepted_by_sandra = conditionnel
confirmation_deadline = J11 vendredi 18 h
possible_due_at = J12 samedi 11 h
```

## 3.2 Confirmation J11

Si Sandra confirme avant 18 h :

**17:41 — Sandra**

> Demain 11 h tient de mon côté.

**17:42 — Sandra**

> Confirme avant 9 h 30.

**17:42 — Sandra**

> Après je ne me déplace pas sur une supposition.

Player répond réellement :

### Maintenir

> oui. 11 h

État :

```text
status = active
accepted_by_player = true
due_at = J12 11 h
```

### Fermer

> non. ne te déplace pas

Sandra :

> D’accord.

> Je ne bloque rien.

État :

```text
status = refused
```

### Ne pas répondre avant 9 h 30 J12

La promesse expire avant déplacement.

## 3.3 Préambule conditionnel J12

Avant l’ouverture principale de J12, ajouter :

```text
J12_PRELUDE_SANDRA_CAFE_CONFIRMED
```

Conditions cumulatives :

```text
promise_id = sandra_cafe_saturday_1100
status = active
Player a confirmé avant 9 h 30
aucune limite Sandra ne l’a fermé
aucune question de sécurité ou d’audience ne bloque la rencontre
```

## 3.4 Script J12 — Maintien

**09:18 — Sandra**

> 11 h tient toujours.

**09:19 — Sandra**

> Je pars à 10 h 34.

**09:19 — Sandra**

> Information très utile pour éviter les réponses à 10 h 57.

Player peut seulement :

### Confirmer

> ça tient. 11 h

Sandra :

> D’accord.

### Fermer avant déplacement

> non. ne pars pas

Sandra :

> D’accord.

> Je garde ma matinée.

La fermeture possède un coût relationnel possible mais ne crée aucune attente.

## 3.5 Rencontre hors téléphone

Si maintenue :

```text
11:00–11:30
café Sandra / Player
aucun dialogue oral transcrit
aucune nouvelle image
aucune scène adulte
aucune décision générale sur la relation
```

La rencontre paie seulement la promesse déjà créée.

Elle ne devient pas le pivot majeur de J12.

## 3.6 Après séparation

**11:44 — Sandra**

> Train attrapé.

**11:45 — Sandra**

> Cette fois sans performance athlétique contestable.

Player guidé :

> progrès

**11:46 — Sandra**

> N’exagérons rien.

Puis :

**11:47 — Sandra**

> Merci d’être venu à l’heure.

Player peut répondre :

> merci d’avoir confirmé

Sandra :

> Voilà.

> On peut laisser la matinée à cette taille.

### Sortie

```text
promise sandra_cafe_saturday_1100 = paid
relation Sandra inchangée ou légèrement renforcée selon l’accumulation
aucune escalade automatique
J12 principal commence normalement à 14 h 42
```

## 3.7 Expiration

Si Player ne confirme pas avant 9 h 30 :

**09:31 — Sandra**

> Je ne pars pas.

**09:31 — Sandra**

> Ce n’est pas une relance.

**09:32 — Sandra**

> Bonne matinée.

État :

```text
promise = expired
Sandra n’attend plus
aucun préambule physique
```

## 3.8 Compatibilité avec J12

Le préambule :

- se termine avant midi ;
- ne modifie pas les heures de La Verrière ;
- ne donne aucun accès à l’image Sandra ;
- ne rend pas Sandra physiquement présente le soir ;
- ne remplace pas S23 ;
- ne crée aucune deuxième route foreground.

---

# 4. A3 — Suppression des conversations en co-présence

## 4.1 Règle absolue

À partir du moment où deux personnages se retrouvent physiquement :

```text
aucun nouveau choix interactif direct entre eux
```

Le prochain échange direct ne peut commencer qu’après une séparation réelle et durable pour la scène :

- départ du lieu ;
- trajet séparé ;
- retour au travail ;
- retour à un logement distinct ;
- fin de rencontre clairement établie.

Changer de pièce ne suffit pas.

## 4.2 Correction J12 — Montage La Verrière

Le chapitre `Fenêtre B — Montage La Verrière` ne contient plus de messages directs Marie / Player.

Il devient :

```text
17:45–19:00
Player rejoint Marie à La Verrière si L-A est actif.
Le chat direct s’arrête.
Player prend les tables du fond et la rallonge noire.
Marie et Élodie poursuivent le montage.
Aucun dialogue oral n’est transcrit.
Les décisions déjà écrites déterminent la qualité de la présence.
```

Les anciens messages :

```text
Tu es côté scène ?
tables du fond
Élodie cherche les pinces noires
dans la caisse sous le vestiaire
```

ne sont plus des messages interactifs.

Ils peuvent devenir :

- une description d’état ;
- une notification logistique passive de l’équipe ;
- ou être supprimés.

Aucun choix Player n’est demandé pendant le montage.

## 4.3 Messages de groupe J12

Les messages sociaux publics restent possibles lorsque leur fonction est :

- annoncer une arrivée ;
- produire une trace de groupe ;
- publier une photographie ;
- informer l’audience entière.

Player ne répond pas directement à la personne physiquement présente dans le groupe pour jouer une conversation privée.

## 4.4 Correction J14

La structure commune devient :

```text
situation ordinaire crédible
→ écran visible par accident
→ réaction immédiate non dialoguée
→ séparation physique réelle
→ échange textuel
→ personne représentée prévenue si nécessaire
→ état de connaissance précis
→ obligation J15
```

Supprimer comme option :

```text
depuis des pièces distinctes
```

Une personne peut :

- quitter l’appartement ;
- repartir au travail ;
- sortir marcher ;
- rentrer chez elle ;
- rejoindre un trajet séparé.

L’échange textuel commence ensuite.

## 4.5 Correction J17

L’ouverture Marie ne peut pas commencer depuis une autre pièce du même logement.

Conditions corrigées :

```text
Marie et Player sont réellement séparés
```

Marie peut être :

- encore à La Verrière ;
- en trajet ;
- dehors après le départ de Mathilde ;
- chez Élodie pour une raison déjà établie ;
- seule dans le foyer pendant que Player est ailleurs ;
- ailleurs pendant que Player est dans le foyer.

Si aucune séparation réelle n’existe le jeudi soir :

- la définition pratique du foyer est envoyée ;
- la grande conversation est déplacée vers l’heure postérieure explicitement choisie ;
- aucune conversation artificielle depuis deux chambres.

## 4.6 Rencontre J17

Si les personnages se rejoignent à 20 h 30 :

```text
20:30–21:30
conversation hors téléphone
```

Le résultat ne revient par texte que si :

- Marie repart réellement marcher et reste dehors ;
- Player quitte le logement pour la nuit ou pour un trajet distinct ;
- Marie retourne à La Verrière ;
- chacun rentre dans un logement différent.

La formule :

```text
chacun se place dans une pièce différente
```

est supprimée.

## 4.7 Correction J21 — Reconquête active

La finale ne reprend plus un dialogue après le dîner alors que le couple reste ensemble.

Le dernier échange direct a lieu avant la co-présence :

**18:52 — Marie**

> Je pars de La Verrière dans dix minutes.

**18:52 — Marie**

> Tu as pris du pain ?

**Player**

> oui

**18:53 — Marie**

> Bien.

**18:53 — Marie**

> Et demain, ne me demande pas si ce soir a tout réparé.

**18:54 — Marie**

> Recommence juste à être là.

**Player**

> d’accord

**18:54 — Marie**

> J’arrive.

La messagerie s’arrête.

La soirée existe hors téléphone sans nouveau dialogue affiché.

## 4.8 Correction J21 — Accord provisoire et reconfiguration

Les règles de chambre et de checkpoint sont envoyées avant le retour ou avant la rencontre.

Aucun `Bonne nuit` interactif n’est nécessaire lorsque les deux personnes sont dans le même logement.

Le silence après la co-présence fait partie de la résolution.

## 4.9 Correction J21 — Séparation

La branche séparation reste textuelle si les personnages vivent déjà dans des lieux distincts.

Si Player vient récupérer les cartons :

- les messages s’arrêtent à son arrivée ;
- aucun échange direct n’est transcrit pendant la récupération ;
- le dernier message éventuel intervient après son départ.

---

# 5. A4 — Gating de la posture finale C

## 5.1 Règle d’éligibilité

La posture finale C est disponible seulement si :

```text
existing_contradiction_id != null
```

L’identifiant doit avoir été créé avant J21 et rester actif à la fin de J20.

## 5.2 Contradictions éligibles

Liste documentaire bornée :

```text
couple_false_hour_active
couple_false_place_active
couple_double_life_active
sandra_copy_retained_secretly_active
pauline_compartment_active
pauline_reciprocal_trace_active
raphaelle_clear_secret_active
nico_shared_alibi_active
nico_complice_debt_active
```

Cette liste sera normalisée au lot B.

## 5.3 Contradictions non éligibles

La posture C est interdite si elle créerait en J21 :

- la première copie non autorisée ;
- le premier mensonge d’heure ;
- le premier alibi ;
- la première demande de dissimulation ;
- la première exclusion de Marie ;
- la première extension abusive d’une invitation ;
- une nouvelle audience compromise ;
- une nouvelle route sombre.

## 5.4 Visibilité du choix

### Si contradiction active

Player reçoit :

```text
A — agir selon la nouvelle règle
B — reconnaître une perte ou une dette
C — maintenir la contradiction déjà active
```

### Si aucune contradiction active

Player reçoit seulement :

```text
A — agir selon la nouvelle règle
B — reconnaître une perte ou une dette
```

Le jeu n’affiche pas une option C désactivée ou expliquée techniquement.

## 5.5 Exemples corrigés

### Double vie déjà active

Condition :

```text
couple_false_hour_active
```

Player répète l’heure déjà fausse :

**Player → Marie**

> 19 h 30

La conséquence ne crée pas le mensonge ; elle confirme qu’il continue.

### Compartiment Pauline déjà actif

Condition :

```text
pauline_compartment_active
```

**Player → Pauline**

> on garde la règle actuelle

Cette réponse maintient le compartiment existant.

Elle ne l’ouvre pas en J21.

### Complicité Nico déjà active

Condition :

```text
nico_shared_alibi_active
ou nico_complice_debt_active
```

**Player → Nico**

> on garde la version qu’on a déjà donnée

Nico peut accepter ou refuser selon son état J20.

Si J20 a fermé l’alibi, cette variante est inéligible.

### Copie Sandra déjà conservée secrètement

Condition :

```text
sandra_copy_retained_secretly_active
```

J21 peut montrer que Player ne la supprime toujours pas.

J21 ne décrit aucune nouvelle méthode de copie ou de dissimulation.

## 5.6 Effet sur la trace finale

Si C est disponible :

```text
final_trace_id
```

est prioritairement lié à la contradiction active.

Si plusieurs contradictions existent, ordre de priorité :

```text
1. sécurité ou audience
2. mensonge affectant le couple
3. dette ou alibi impliquant un tiers
4. compartiment volontaire
```

Un seul conflit reçoit le premier plan.

## 5.7 Sortie

```text
contradiction déjà active maintenue
aucune nouvelle victime
aucune nouvelle audience
future conséquence préparée
```

---

# 6. Matrice de validation du lot A

## Test A1 — Accord provisoire

Entrée :

```text
J17 accord provisoire
```

Attendu :

```text
checkpoint jeudi suivant J21 20 h 30
aucune référence au dimanche J20 comme futur
```

## Test A2 — Reconfiguration

Entrée :

```text
J17 reconfiguration en négociation
```

Attendu :

```text
pause jusqu’au checkpoint post-J21
aucune permission extérieure automatique
```

## Test A3 — Promesse Sandra payée

Entrée :

```text
J10 alternative samedi
Sandra confirme J11
Player confirme avant J12 9 h 30
```

Attendu :

```text
café J12 11 h
promesse payée
J12 principal intact
```

## Test A4 — Promesse Sandra expirée

Entrée :

```text
Player ne confirme pas
```

Attendu :

```text
Sandra ne se déplace pas
aucune attente
aucune relance
```

## Test A5 — Co-présence J12

Attendu :

```text
aucun choix Player envoyé à Marie pendant le montage
```

## Test A6 — Co-présence J17

Attendu :

```text
conversation textuelle seulement après séparation réelle
```

## Test A7 — Finale claire

Entrée :

```text
aucune contradiction active
```

Attendu :

```text
postures A et B seulement
```

## Test A8 — Finale sombre

Entrée :

```text
contradiction active avant J21
```

Attendu :

```text
posture C disponible
aucune nouvelle violation créée
```

---

# 7. Effets sur les états de sortie

Le lot A ne modifie pas les états canoniques possibles.

## Couple

```text
reconquête active
accord provisoire
reconfiguration en négociation
double vie fragile
fracture
séparation
```

## Sandra

```text
amitié retrouvée
confidence privilégiée
désir reconnu et contenu
relation parallèle tendre
intimité tardive
recul protecteur
rupture de confiance
```

## Pauline, Raphaëlle et Nico

Leurs états J19–J20 restent inchangés.

Le lot A corrige seulement :

- quand une promesse doit être payée ;
- quand un échange peut être affiché ;
- quand une contradiction finale est accessible.

---

# 8. Autorité et consolidation future

## Autorité immédiate

Toute lecture de :

- J10 ;
- J12 ;
- J14 ;
- J17 ;
- J21 ;

applique le présent document lorsque les formulations divergent.

## Lot B

Le lot B transformera les identifiants documentaires en contrats bornés :

- promesses ;
- traces ;
- connaissances ;
- états ;
- reachability.

## Lot C

Le lot C consolidera physiquement les corrections dans les scripts sources et retirera la nécessité de lire le lot A comme overlay.

Aucune adaptation runtime ne doit utiliser les anciens passages sans appliquer le présent correctif.

---

# 9. Verdict du lot A

```text
A1 CALENDRIER : CORRIGÉ
A2 PROMESSE SANDRA : PAYÉE OU FERMÉE
A3 CO-PRÉSENCE : CONFORME TEXT-ONLY
A4 POSTURE C : STRICTEMENT CONDITIONNELLE
```

Le lot A est complet comme correction documentaire.

Il ne rend pas encore le corpus prêt pour le runtime.

La prochaine étape est le lot B :

```text
registre des traces
registre des promesses
registre des connaissances
contrat d’état
matrice de reachability
```

> **Le lot A ne change pas l’histoire. Il retire les contradictions qui empêchaient encore cette histoire d’être exécutée exactement.**
