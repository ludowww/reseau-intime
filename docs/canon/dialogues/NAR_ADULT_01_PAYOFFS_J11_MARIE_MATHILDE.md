# Réseau Intime — NAR-ADULT-01 — Payoffs J11 Marie & Mathilde

> **Statut canonique de consolidation**
>
> Catégorie : Canon — addendum de production adulte validé
>
> Périmètre : spécification pré-réécriture et pré-production
>
> Baseline : `47c37021d32a7f48128a8a187f1af13d337ca059`
>
> Validation produit : Ludovic — PASS

Le texte validé ci-dessous est repris intégralement. Son marqueur interne `DRAFT PRODUIT` décrit l’état du brouillon avant sa validation et ne prévaut plus sur le statut canonique de consolidation ci-dessus.

Autorité du présent addendum :

- il amende les plafonds adultes et les budgets visuels du corpus signé sur son périmètre précis ;
- il ne modifie pas encore physiquement les scripts sources ;
- les anciens comptages NAR-PROD restent temporairement présents jusqu’au lot d’amendement suivant ;
- en cas d’écart sur les payoffs adultes concernés, le présent addendum prévaut temporairement sur les anciens budgets de fichiers ;
- il ne prévaut pas sur les règles générales de consentement, d’agence, de connaissance, de retrait ou de `text-only`.

Amendement ultérieur applicable :

- `NAR_PROD_05_AMENDEMENT_COHERENCE_J10_J12.md` remplace les notions vagues
  d’éligibilité Marie par un prédicat exact, ordonne le premier baiser
  Raphaëlle, et fixe l’échec d’aftercare Mathilde avant J12 ;
- le présent document reste autoritatif pour le niveau adulte, la représentation
  et les séquences visuelles Marie/Mathilde.

## 1. Statut

```text
document_id: NAR-ADULT-01
document_path_candidate: docs/canon/dialogues/NAR_ADULT_01_PAYOFFS_J11_MARIE_MATHILDE.md
baseline_inspected: 47c37021d32a7f48128a8a187f1af13d337ca059
scope: amendements adultes ciblés de J11 et handoff J12
status: DRAFT PRODUIT
git_changes: none
runtime_changes: none
ui_changes: none
assets_produced: none
```

Le présent document spécifie les payoffs adultes maximaux de Marie et Mathilde en J11.

Il ne réécrit pas l’ensemble de J11.

Il fixe :

- l’éligibilité exacte des deux scènes ;
- leur niveau adulte ;
- leur déroulé visuel ;
- les images à produire ;
- leur présentation hors téléphone ;
- leur comportement dans la Galerie ;
- leur après-coup ;
- les conséquences obligatoires en J12 ;
- les futurs deltas documentaires.

---

## 2. Sources principales

- `docs/canon/bible/05_ROUTES_MACRO_SAISON_1.md`
- `docs/canon/bible/06_EVOLUTION_EROTIQUE_DES_ROUTES.md`
- `docs/canon/dialogues/J10_SCRIPT_NARRATIF_COMPLET.md`
- `docs/canon/dialogues/J11_SCRIPT_NARRATIF_COMPLET.md`
- `docs/canon/dialogues/J12_SCRIPT_NARRATIF_COMPLET.md`
- `docs/canon/dialogues/NAR_PROD_04_PAQUET_PRODUCTION_ACTE_III_J09_J12.md`
- `docs/canon/ui/UI_02_SCREEN_ARCHITECTURE_AND_STATES.md`

J11 impose déjà qu’une scène adulte remplace le pivot normal et ne puisse survenir qu’après paiement des conséquences prioritaires. Le consentement doit être écrit, le changement d’avis possible et l’après-coup J12 obligatoire.

---

## 3. Décisions produit

### 3.1 Marie

La route maximale Marie peut atteindre en J11 :

```text
sexualité conjugale explicite
rapport sexuel complet possible
reconquête choisie
aucun reset magique du couple
```

Le payoff utilise trois images :

1. entrée dans la reconquête ;
2. image sexuelle centrale explicite ;
3. après-coup ordinaire.

### 3.2 Mathilde

La route maximale Mathilde peut atteindre en J11 :

```text
nudité explicite
contact sexuel mutuel explicite
aucune pénétration pendant ce premier passage
secret et responsabilité envers Marie
```

Cette décision donne une vraie récompense adulte sans rendre le premier passage artificiellement identique à la route conjugale de Marie.

La différenciation est volontaire :

```text
Marie
= couple ancien qui choisit à nouveau une sexualité complète

Mathilde
= premier interdit physique consciemment franchi,
  explicite mais encore borné
```

La pénétration n’est pas interdite pour tout futur arc Mathilde. Elle n’appartient pas à ce premier basculement J11.

### 3.3 Nature des images

Toutes les images sexuelles de ce lot sont :

```text
IMAGE_DE_SCÈNE
non diégétiques
non transférables
non découvrables par un personnage
sans caméra dans l’histoire
```

Aucune photo nue ou sexuelle n’est envoyée dans les conversations Marie ou Mathilde pendant ces scènes.

---

## 4. Invariants communs

Une scène adulte J11 est bloquée si l’une des conditions suivantes existe :

- conséquence prioritaire impayée ;
- limite ignorée ;
- intoxication ;
- dépendance matérielle exploitée ;
- disponibilité créée artificiellement ;
- initiative incohérente du personnage ;
- consentement ambigu ;
- impossibilité de quitter le lieu ;
- absence d’après-coup possible.

Règles communes :

- une seule variante principale de J11 est vécue dans une partie ;
- la scène adulte remplace le climax normal ;
- elle ne s’ajoute pas après une autre progression majeure ;
- aucun choix oral n’est joué pendant la co-présence ;
- Player reste non identifiable ;
- aucune image ne crée de droit futur ;
- l’arrêt reste possible ;
- le refus ou l’arrêt ne produit aucune punition ;
- le lendemain conserve les conséquences ;
- aucune image nouvelle n’est créée en J21.

---

# Partie I — Marie

## 5. État actuel

Le script Marie contient déjà :

- une initiative explicite de Marie ;
- la distinction entre désir et sexe-pansement ;
- un consentement écrit ;
- une rencontre hors téléphone ;
- une sexualité conjugale possible ;
- un après-coup le lendemain.

Marie écrit déjà qu’elle veut retrouver Player sans utiliser le sexe pour effacer les jours précédents. La variante adulte prévoit une rencontre physique et sexuelle, puis un retour à la vie ordinaire.

Le manque actuel n’est donc pas narratif.

Il est représentatif : la scène est autorisée, mais son cœur demeure elliptique.

---

## 6. Éligibilité Marie

La variante adulte est éligible seulement si toutes les conditions suivantes
sont vraies :

```text
j11_pivot == MARIE
j10_pivot == NONE
j10_pivot_outcome in {DUE_DINNER_PAID, ORDINARY_MEAL_JOINED}
marie_j09_presence_outcome in {
  presence_active,
  presence_playful_useful,
  presence_late_active,
  presence_bounded_reliable
}
couple_state in {BASELINE_SHARED_LIFE, STRAIN_VISIBLE}
P09 terminale
P10 absente ou PAID
aucune obligation DUE ou FAILED non traitée
aucune progression extérieure J10 utilisée comme repli
choix J11 P-A réellement sélectionné
consentement Marie actuel, explicite et révocable
```

Pour ce prédicat, P09 terminale signifie : absente ou `PAID`, `CANCELLED`,
`REFUSED`, `FAILED` ou `CLOSED`. P09 `AMENDED` ne compte comme résolue que si
elle pointe vers P10 et que P10 est `PAID`.

Marie doit toujours initier ou co-initier, Player doit nommer son désir sans
promettre une réparation magique et le lendemain ordinaire doit rester possible.

La variante est bloquée en cas de :

- jalousie utilisée comme pression ;
- retour vers Marie uniquement après fermeture d’une autre route ;
- dette Marie encore active ;
- tentative de consolation ;
- refus antérieur non respecté ;
- `presence_distracted`, `presence_spectator` ou `absence_honest` ;
- P10 `ACTIVE`, `CANCELLED` ou `FAILED` ;
- obligation `DUE` ou `FAILED` non traitée ;
- fermeture d’une route extérieure utilisée comme repli.

`DUE_DINNER_PAID` ou `ORDINARY_MEAL_JOINED` ne suffit jamais seul. Le runtime ne
crée pas `RECONQUEST_ACTIVE` avant la scène pour justifier rétroactivement son
accès. Si une preuve manque, la branche non adulte est utilisée.

---

## 7. Dialogue Marie

Les messages existants sont conservés.

Aucun sexting supplémentaire n’est nécessaire.

Le nœud reste :

```text
Marie :
Quand je rentre, je veux qu’on se choisisse pour ce soir.

Marie :
Pas comme si ça réglait tout.

Player :
je te désire. je sais que ça ne règle rien.
tu peux arrêter ou changer d’avis à n’importe quel moment

Marie :
Oui.

Marie :
À tout à l’heure.
```

Après `À tout à l’heure`, la conversation passe immédiatement en transition hors téléphone.

---

## 8. Séquence visuelle Marie

### M-J11-01 — Entrée dans la reconquête

Fichier existant rebriefé :

`S1_A3_J11_SCN_MARIE_COUPLE_STATE_01_RECONNECTION`

Parent :

`C11-06`

Type :

`IMAGE_DE_SCÈNE`

Fonction :

- Marie rentre et choisit réellement la proximité ;
- l’initiative doit être visible ;
- la scène ne ressemble ni à une réconciliation automatique ni à un câlin générique ;
- le désir appartient à Marie autant qu’à Player ;
- la familiarité du couple reste perceptible.

Niveau :

```text
érotique fort
début de nudité possible
pas encore payoff central
```

Composition :

- Marie reste le sujet identifiable ;
- Player est hors champ, de dos ou limité à une présence non distinctive ;
- le lieu appartient au couple ;
- téléphone hors de la chambre ;
- aucun regard caméra ;
- aucun signe de photographie.

### M-J11-02 — Payoff central

Nouveau fichier :

`S1_A3_J11_SCN_MARIE_RECONQUEST_ADULT_PAYOFF_01`

Parent :

`C11-06`

Type :

`IMAGE_DE_SCÈNE`

Fonction :

- représenter la sexualité conjugale explicite ;
- montrer que Marie et Player se choisissent dans le présent ;
- payer visuellement la route maximale Marie ;
- différencier la reconquête d’une simple reprise d’habitude.

Niveau :

```text
nudité explicite
scène sexuelle explicite
rapport sexuel complet possible
```

Contraintes :

- Marie reste centrale et active ;
- Player reste non identifiable ;
- aucune posture d’humiliation ;
- aucune jalousie mise en scène comme moteur ;
- aucune caméra diégétique ;
- aucune pose destinée à une audience extérieure ;
- aucune impression de « récompense acquise » ;
- l’image doit rester spécifique à un couple qui se connaît déjà.

### M-J11-03 — Après-coup ordinaire

Nouveau fichier :

`S1_A3_J11_SCN_MARIE_RECONQUEST_AFTERCARE_01`

Parent :

`C11-06`

Type :

`IMAGE_DE_SCÈNE`

Fonction :

- montrer le lendemain ou le retour immédiat au quotidien ;
- rappeler que la relation ne se résume pas à la scène sexuelle ;
- préparer La Verrière J12 ;
- conserver le désir sans transformer la nuit en réparation totale.

Niveau :

```text
intimité post-sexuelle
nudité partielle possible
pas de nouvel acte sexuel
```

Composition recommandée :

- matin, vêtements repris ou drap non théâtral ;
- Marie déjà engagée dans une action quotidienne ;
- café, cuisine ou préparation de journée ;
- aucun bonheur définitif ;
- aucune tristesse punitive ;
- proximité réelle mais problème du couple encore existant.

---

## 9. Présentation Marie

```text
messages de consentement
→ OffPhoneTransition
→ M-J11-01
→ M-J11-02
→ fondu ou fin de la rencontre
→ M-J11-03
→ reprise des messages d’après-coup
```

Aucun choix n’est affiché entre les images.

La séquence est le résultat du choix déjà effectué et de l’éligibilité accumulée.

La transition hors téléphone doit suspendre le chat. Le contrat UI interdit les messages ou choix oraux pendant la co-présence et exige une séparation réelle avant la reprise textuelle.

---

## 10. Alternatives Marie inchangées

Restent inchangées :

### Reconquête non adulte

- repas tardif ;
- proximité ;
- aucune sexualité ;
- confiance renforcée.

### Refus du sexe comme pansement

- désir reconnu ;
- sexualité différée ;
- relation renforcée par la distinction.

### Refus honnête

- aucune sexualité ;
- aucune punition ;
- distance conjugale lisible.

Aucune image adulte n’est débloquée sur ces branches.

---

## 11. Handoff Marie vers J12

J12 doit conserver :

- la présence ordinaire ;
- le désir devenu réel ;
- l’absence de reset magique ;
- la capacité de Marie à vivre dans son monde professionnel ;
- la continuité du couple sans exposition publique de la scène privée.

Le module J12 existant prévoit déjà que, si J11 a produit une reconquête physique, Marie demande à Player de venir près d’elle pour une photo de groupe sans « raconter hier ».

Cette fonction est conservée.

Précision à ajouter :

> La proximité publique J12 ne doit pas ressembler à une possession après la scène sexuelle. Marie choisit elle-même la place de Player dans l’image.

---

# Partie II — Mathilde

## 12. État actuel

J10 peut établir que Mathilde a consciemment choisi une tenue pour produire un effet, tout en refusant une permission générale.

J11 contient ensuite :

- Mathilde qui revient volontairement ;
- une demande explicite d’être regardée ;
- une proximité négociée ;
- un premier baiser ;
- un toucher plus intime possible après demande ;
- aucune pénétration ;
- un départ vers une solution de couchage indépendante ;
- un après-coup écrit.

Le nouveau payoff maximal ne remplace pas ces branches.

Il ajoute une branche plus exigeante au-dessus du premier passage physique actuel.

---

## 13. Architecture Mathilde révisée

La route J11 Mathilde possède quatre plafonds.

### M-A — Regard seulement

```text
Mathilde veut être regardée
aucun toucher
proximité érotique non sexuelle
```

### M-B1 — Proximité conditionnelle

```text
contact volontaire
aucun baiser
aucun toucher intime
```

### M-B2 — Premier passage physique borné

```text
baiser
toucher plus intime possible après demande
aucune pénétration
nudité non obligatoire
```

Cette branche correspond au script actuel.

### M-B3 — Payoff adulte maximal

```text
nudité explicite
contact sexuel mutuel explicite
aucune pénétration
secret physique pleinement reconnu
après-coup et conséquence envers Marie obligatoires
```

M-B3 est la seule nouvelle branche canonique.

---

## 14. Éligibilité renforcée Mathilde

Toutes les conditions existantes restent obligatoires :

- regard reconnu depuis J06 ;
- effet choisi en J10 ;
- limite respectée ;
- Marie absente pour une raison indépendante ;
- Mathilde prend l’initiative ;
- aucune exploitation du logement ;
- solution indépendante pour dormir ;
- capacité de quitter le lieu ;
- absence de Marie non organisée ;
- aucune conséquence prioritaire impayée ;
- arrêt immédiat possible.

Conditions supplémentaires pour M-B3 :

- M-B2 aurait déjà été crédible dans le même état ;
- Mathilde a nommé que son retour est intentionnel ;
- Player n’a jamais utilisé Marie comme comparaison ou pression ;
- Player n’a pas demandé de récompense pour avoir respecté une limite ;
- Mathilde sait qu’elle quittera le logement après la scène ;
- le secret envers Marie est reconnu comme conséquence, pas comme excitation abstraite ;
- aucune demande de répétition n’est créée avant l’après-coup ;
- aucune photographie ou conservation visuelle n’est demandée ;
- Mathilde conserve vêtements, téléphone, transport et solution de repli accessibles.

La branche est bloquée si :

- Mathilde dépend encore du logement pour dormir ;
- Player a organisé l’absence de Marie ;
- une limite a été négociée à la baisse ;
- Mathilde hésite sans réaffirmer ;
- Player insiste après une réponse partielle ;
- une dette domestique ou matérielle existe ;
- la scène ne peut pas finir avant le retour de Marie.

---

## 15. Dialogue supplémentaire Mathilde

La négociation actuelle du baiser reste l’entrée commune.

Après :

```text
Mathilde :
Tu peux m’embrasser.

Mathilde :
Rien d’autre sans me demander.
```

M-B2 conserve le script actuel.

M-B3 ajoute uniquement ce bloc, avant la transition :

```text
Mathilde :
Je veux aller plus loin que ça.

Mathilde :
Je te dis ce que j’accepte au fur et à mesure.
Tu ne complètes pas le reste tout seul.

Player :
d’accord. tu décides chaque étape.
si tu hésites, si tu changes d’avis ou si tu dis stop, on arrête

Mathilde :
Oui.

Mathilde :
Et après je dors ailleurs comme prévu.

Player :
compris

Mathilde :
Viens.
```

Ce dialogue :

- ne décrit pas les actes à l’avance ;
- ne transforme pas la scène en contrat administratif ;
- fixe clairement l’initiative de Mathilde ;
- protège son départ ;
- empêche toute déduction automatique.

---

## 16. Séquence visuelle Mathilde

### MT-J11-01 — Entrée dans l’interdit choisi

Fichier existant rebriefé :

`S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01_PROXIMITY`

Parent :

`C11-03`

Type :

`IMAGE_DE_SCÈNE`

Fonction :

- Mathilde revient volontairement dans la pièce ;
- la tenue et le regard ont cessé d’être accidentels ;
- elle garde le contrôle de la distance ;
- le foyer et la présence morale de Marie restent perceptibles.

Niveau :

```text
érotique fort
proximité consentie
nudité non encore centrale
```

Composition :

- Mathilde est le sujet ;
- Player reste non identifiable ;
- aucun cadrage voyeur depuis une porte ;
- aucun dispositif de surveillance ;
- aucune caméra ;
- le décor reste un foyer réel, pas un studio pornographique abstrait.

### MT-J11-02 — Payoff central

Nouveau fichier :

`S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_CENTRAL_01`

Parent :

`C11-03`

Type :

`IMAGE_DE_SCÈNE`

Fonction :

- représenter explicitement le premier secret sexuel Mathilde/Player ;
- payer la route maximale sans effacer sa peur ni son contrôle ;
- distinguer ce payoff de la sexualité conjugale Marie.

Niveau :

```text
nudité explicite
contact sexuel mutuel explicite
aucune pénétration
```

Contraintes :

- Mathilde reste active et capable d’interrompre ;
- aucune posture de dépendance ;
- aucun sommeil ;
- aucune intoxication ;
- aucune violence ;
- aucune humiliation de Marie ;
- aucun symbole de victoire sur le foyer ;
- Player non identifiable ;
- aucun téléphone utilisé comme caméra ;
- aucune photographie ou vidéo dans l’histoire.

La scène doit être clairement adulte et ne pas pouvoir être confondue avec un simple baiser.

Elle ne doit toutefois pas donner l’impression que Mathilde a accepté :

- une relation durable ;
- une répétition ;
- une diffusion ;
- une nouvelle pratique ;
- une prochaine scène ;
- une rupture avec Marie.

### MT-J11-03 — Après-coup et départ réel

Nouveau fichier :

`S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_AFTERCARE_01`

Parent :

`C11-03`

Type :

`IMAGE_DE_SCÈNE`

Fonction :

- montrer Mathilde après la séparation réelle ;
- confirmer qu’elle possède toujours une solution indépendante ;
- matérialiser le secret, la gêne et la responsabilité ;
- préparer son comportement J12 et son départ futur.

Niveau :

```text
après-coup intime
nudité partielle possible
aucun nouvel acte sexuel
```

Composition recommandée :

- Mathilde arrivée dans son lieu de couchage indépendant ou dans un espace où Player est absent ;
- vêtements repris partiellement ou entièrement ;
- téléphone utilisé pour écrire, jamais pour photographier ;
- sac, clés ou affaires accessibles ;
- expression mêlant désir assumé, gêne et réflexion ;
- aucune image de victime ;
- aucune euphorie de conquête.

---

## 17. Présentation Mathilde

```text
messages de consentement
→ OffPhoneTransition
→ MT-J11-01
→ MT-J11-02
→ Mathilde quitte réellement le foyer
→ MT-J11-03
→ messages d’après-coup
```

La scène ne contient aucun choix oral joué.

Le départ réel avant la reprise textuelle est obligatoire.

---

## 18. Après-coup Mathilde

Les trois réponses Player existantes sont conservées :

### Ne pas réclamer de définition

Sortie :

```text
secret reconnu
clarification future
aucun droit de répétition
```

### Reconnaître la conséquence envers Marie

Sortie :

```text
responsabilité reconnue
secret actif
Mathilde ne porte pas seule la faute
```

### Demander immédiatement une répétition

Sortie :

```text
recul
répétition refusée
confiance fragilisée
aftercare_mathilde_j11 = FAILED
```

La demande de répétition ne retire pas rétroactivement le consentement de la scène vécue.

Elle dégrade l’après-coup et peut fermer la prochaine étape.

MA1 et MA2 produisent `aftercare_mathilde_j11 = PAID`. Un refus explicite de
l’aftercare produit également `FAILED`.

---

## 19. Handoff Mathilde vers J12

J12 sait déjà que Mathilde :

- connaît ce qui s’est produit ;
- sait que Marie reste une responsabilité ;
- doit continuer à vivre dans le foyer après J11.

Après M-B3, J12 doit obligatoirement montrer au moins un comportement parmi :

- Mathilde évite une place trop proche de Player ;
- elle parle normalement à Marie avec un effort visible ;
- elle quitte La Verrière ou L’Annexe plus tôt ;
- elle refuse un aparté ;
- elle choisit de ne pas venir ;
- elle corrige Player s’il vérifie constamment sa position.

Exception prioritaire : si `aftercare_mathilde_j11 == FAILED`, Mathilde ne
participe pas à la convergence normale. J12 traite d’abord la conséquence,
enregistre son absence, ferme toute progression physique et interdit toute
substitution relationnelle.

Le module existant interdit déjà une deuxième scène, l’usage de Nico pour provoquer Player et l’effacement moral de Marie.

Ajout recommandé si Player insiste du regard après M-B3 :

```text
Mathilde :
Ne me regarde pas comme si on avait décidé la suite.

Player :
d’accord

Mathilde :
On a décidé hier.
Pas aujourd’hui.
```

Aucune nouvelle scène sexuelle ne survient en J12.

---

## 20. Handoff futur vers J16 et J17

NAR-ADULT-01 ne réécrit pas encore J16 ou J17.

Il impose toutefois les règles suivantes :

- le passage M-B3 ne rend pas automatiquement le départ protecteur ;
- une scène respectée peut conduire à un départ ordinaire mais émotionnellement chargé ;
- une pression pendant l’après-coup peut conduire à la variante protectrice ;
- Mathilde ne reste pas dans le logement pour prolonger la route ;
- son départ matériel reste obligatoire ;
- Marie demeure affectée par le secret même sans connaissance immédiate ;
- J17 ne traite pas Mathilde comme une option entre elle et Marie ;
- aucune consolation sexuelle extérieure n’est ouverte par une fracture du couple.

---

## 21. Galerie

### Marie

Une seule tuile :

```text
personnage: Marie
origine: Moment vécu
séquence: 3 images
```

Images :

1. entrée ;
2. payoff central ;
3. après-coup.

### Mathilde

Une seule tuile :

```text
personnage: Mathilde
origine: Moment vécu
séquence: 3 images
```

Images :

1. entrée ;
2. payoff central ;
3. après-coup.

Règles :

- la tuile n’apparaît qu’après la scène vécue ;
- aucun contenu exact n’est révélé avant ;
- les branches non adultes ne déverrouillent pas la séquence ;
- aucune image n’est partageable ;
- aucune image n’est retirable comme fichier diégétique ;
- aucune image n’est une preuve accessible à Marie ;
- la Galerie archive l’expérience du joueur, pas le téléphone de Player.

Contrat runtime/UI restant : C11-03 et C11-06 restent chacun une seule tuile
parent avec trois images internes. Les enfants ne sont jamais exposés comme
trois entrées séparées. La navigation interne est une dépendance technique d’un
lot ultérieur, sans modification du contrat narratif.

Le contrat UI permet déjà qu’une image soit visible sans devenir un fichier diégétique et prévoit qu’un retrait de photo n’efface ni les faits vécus ni les connaissances.

---

## 22. Incidence sur le catalogue

### État avant NAR-ADULT-01

```text
contenus principaux Saison 1: 63
fichiers Saison 1: 76
variantes: 8
fichiers J21: 0
```

### Fichiers existants rebriefés

| Route | Fichier |
|---|---|
| Marie | `S1_A3_J11_SCN_MARIE_COUPLE_STATE_01_RECONNECTION` |
| Mathilde | `S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01_PROXIMITY` |

### Nouveaux fichiers

| Route | Fichier | Nature |
|---|---|---|
| Marie | `S1_A3_J11_SCN_MARIE_RECONQUEST_ADULT_PAYOFF_01` | enfant conditionnel de C11-06 |
| Marie | `S1_A3_J11_SCN_MARIE_RECONQUEST_AFTERCARE_01` | enfant conditionnel de C11-06 |
| Mathilde | `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_CENTRAL_01` | enfant conditionnel de C11-03 |
| Mathilde | `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_AFTERCARE_01` | enfant conditionnel de C11-03 |

### Comptage intermédiaire

```text
Acte III actuel: 26 fichiers
NAR-ADULT-01: +4
Acte III révisé: 30 fichiers

Saison actuelle: 76 fichiers
NAR-ADULT-01: +4
Total intermédiaire: 80 fichiers
```

Les quatre nouveaux fichiers :

- ne sont pas des variantes ;
- ne créent pas de nouveaux contenus principaux ;
- sont des enfants conditionnels de deux contenus J11 existants ;
- ne sont jamais tous servis dans une même partie, puisque Marie et Mathilde sont des pivots exclusifs.

Le total final prévu par NAR-PROD-07 reste **84 fichiers** après les lots Sandra, Pauline et Raphaëlle.

---

## 23. Deltas documentaires futurs

Après validation de NAR-ADULT-01, un lot d’intégration documentaire devra modifier uniquement :

1. `J11_SCRIPT_NARRATIF_COMPLET.md`
   - ajouter M-B3 ;
   - enrichir les événements hors téléphone Marie et Mathilde ;
   - intégrer les contrats des séquences ;
   - préserver toutes les branches non adultes.

2. `J12_SCRIPT_NARRATIF_COMPLET.md`
   - préciser les conséquences Marie ;
   - ajouter le comportement Mathilde après M-B3 ;
   - interdire toute seconde progression adulte.

3. `NAR_PROD_04_PAQUET_PRODUCTION_ACTE_III_J09_J12.md`
   - passer de 26 à 30 fichiers ;
   - ajouter quatre enfants conditionnels ;
   - conserver 21 contenus principaux ;
   - conserver deux variantes ;
   - mettre à jour le manifeste J11.

4. Futur `ASSET_01_PRODUCTION_LIST.md`
   - ajouter quatre lignes ;
   - passer provisoirement de 76 à 80 avant les autres payoffs.

Aucun document UI ou runtime n’est modifié dans ce premier lot.

---

## 24. Critères d’acceptation

### Marie

- [ ] la scène reste une reconquête, pas un retour automatique ;
- [ ] Marie initie ou co-initie ;
- [ ] la scène sexuelle complète est réellement représentée ;
- [ ] Player reste non identifiable ;
- [ ] le lendemain ordinaire existe ;
- [ ] aucune autre route n’est ouverte en compensation ;
- [ ] les branches non sexuelles restent satisfaisantes.

### Mathilde

- [ ] M-B1, M-B2 et M-B3 restent distinctes ;
- [ ] M-B3 exige davantage que le baiser actuel ;
- [ ] le payoff est sexuellement explicite ;
- [ ] aucune pénétration pendant ce premier passage ;
- [ ] Mathilde possède une solution indépendante ;
- [ ] elle quitte réellement le foyer avant la reprise du chat ;
- [ ] Marie reste une responsabilité ;
- [ ] aucune caméra diégétique ;
- [ ] aucune répétition automatique ;
- [ ] J12 porte la gêne, le secret ou la distance.

### Présentation

- [ ] les scènes apparaissent hors téléphone ;
- [ ] aucune image sexuelle n’est une bulle de message ;
- [ ] chaque séquence utilise une tuile de Galerie ;
- [ ] la provenance affichée est `Moment vécu` ;
- [ ] aucun contenu est révélé avant déblocage ;
- [ ] aucun nouveau fichier J21.

### Comptage

- [ ] deux fichiers existants rebriefés ;
- [ ] quatre nouveaux fichiers ;
- [ ] aucun nouveau contenu principal ;
- [ ] aucune nouvelle variante ;
- [ ] Acte III à 30 fichiers ;
- [ ] Saison intermédiaire à 80 fichiers.

---

## 25. Verdict

```text
MARIE J11:
payoff adulte complet validable
rapport sexuel complet possible
3 images de séquence
2 nouveaux fichiers

MATHILDE J11:
extension canonique ciblée nécessaire
payoff sexuel explicite sans pénétration
3 images de séquence
2 nouveaux fichiers

STRUCTURE J11:
préservée

BRANCHES NON ADULTES:
préservées

J12:
conséquences renforcées
aucune nouvelle scène sexuelle

TOTAL INTERMÉDIAIRE:
80 fichiers

GIT:
aucune modification
```
