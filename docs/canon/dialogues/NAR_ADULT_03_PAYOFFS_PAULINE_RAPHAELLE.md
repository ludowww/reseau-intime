# Réseau Intime — NAR-ADULT-03 — Payoffs Pauline & Raphaëlle

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

## 1. Statut

```text
document_id: NAR-ADULT-03
document_path_candidate: docs/canon/dialogues/NAR_ADULT_03_PAYOFFS_PAULINE_RAPHAELLE.md
baseline_inspected: 47c37021d32a7f48128a8a187f1af13d337ca059
scope: payoffs adultes intermédiaires Pauline et Raphaëlle
status: DRAFT PRODUIT
git_changes: none
runtime_changes: none
ui_changes: none
assets_produced: none
```

Le présent document spécifie les payoffs adultes intermédiaires de Pauline et Raphaëlle.

Il complète :

- NAR-PROD-07 ;
- NAR-ADULT-01 ;
- NAR-ADULT-02.

Il ne crée :

- aucune relation sexuelle complète supplémentaire ;
- aucune scène physique obligatoire ;
- aucune nouvelle route ;
- aucune permission automatique ;
- aucun contenu J21 ;
- aucun prompt ComfyUI ;
- aucune implémentation runtime ou UI.

Son objectif est de donner aux deux routes secondaires une récompense adulte réelle sans les faire atteindre artificiellement le même plafond que Marie, Sandra ou Mathilde.

---

## 2. Sources principales

- `docs/canon/bible/05_ROUTES_MACRO_SAISON_1.md`
- `docs/canon/bible/06_EVOLUTION_EROTIQUE_DES_ROUTES.md`
- `docs/canon/dialogues/J13_SCRIPT_NARRATIF_COMPLET.md`
- `docs/canon/dialogues/J14_SCRIPT_NARRATIF_COMPLET.md`
- `docs/canon/dialogues/J19_SCRIPT_NARRATIF_COMPLET.md`
- `docs/canon/dialogues/NAR_PROD_05_PAQUET_PRODUCTION_ACTE_IV_J13_J16.md`
- `docs/canon/dialogues/NAR_PROD_06_PAQUET_PRODUCTION_ACTE_V_J17_J21.md`
- `docs/canon/ui/UI_02_SCREEN_ARCHITECTURE_AND_STATES.md`

---

## 3. Décisions produit

### Pauline

Le payoff maximal Pauline de la Saison 1 devient :

```text
compartiment consciemment ouvert
→ photographie adulte explicitement nue
→ audience Player uniquement
→ aucun acte sexuel représenté
→ dette concrète envers Bastien et Marie
```

La photographie est :

- diégétique ;
- créée et sélectionnée par Pauline ;
- envoyée uniquement dans une fenêtre privée crédible ;
- retirable ;
- non transférable ;
- distincte de la photographie publique J12 et de la quatrième frame privée J13.

### Raphaëlle

Le payoff maximal Raphaëlle de la Saison 1 devient :

```text
processus respecté
→ attraction reconnue
→ seconde image choisie par Raphaëlle
→ exposition adulte explicite liée au rôle
→ aucune scène sexuelle complète
→ personne et travail toujours distincts
```

La photographie est :

- diégétique ;
- créée par Maud dans le cadre établi de la session ;
- sélectionnée par Raphaëlle ;
- plus exposée que l’image masquée standard ;
- non sexuelle ;
- retirable ;
- destinée à Player seulement.

### Niveau relatif

```text
Pauline:
nudité explicite
pas d’acte sexuel

Raphaëlle:
nudité ou exposition corporelle adulte explicite
pas d’acte sexuel

Marie / Sandra:
sexualité complète possible

Mathilde:
sexualité explicite bornée sans pénétration en J11
```

---

# Partie I — Pauline

## 4. Progression Pauline existante

La route Pauline utilise déjà :

1. une surface sociale authentique ;
2. une photographie publique avec Bastien et le groupe ;
3. une quatrième frame privée issue du même moment ;
4. une différence d’audience ;
5. un test de discrétion ;
6. une possible première trahison envers Marie ;
7. un compartiment consciemment maintenu ou fermé.

La photographie J13 :

`S1_A3_J12_DPH_PAULINE_BASTIEN_ANNEXE_01_FRAME_04_PRIVATE`

reste indispensable.

Elle ne doit pas être rebriefée en photographie nue.

Sa fonction demeure :

```text
première double adresse
première version choisie pour Player
image encore défendable comme variation du même moment social
```

Elle prépare le payoff adulte.

Elle ne le remplace pas.

---

## 5. Fenêtre Pauline

```text
jour: J19
route: Pauline foreground
branche: compartiment protégé
```

Le payoff ne peut pas apparaître :

- en J13 ;
- pendant la présence de Bastien ;
- pendant la présence de Marie ;
- dans la branche Pauline secondaire ;
- après une fermeture ;
- après une exposition non réglée ;
- lorsque l’après-coup Sandra domine J19 ;
- comme compensation de l’absence d’une autre route.

Il intervient uniquement après que Pauline et Player ont reconnu :

```text
ce fil existe parce qu’ils l’ouvrent
la relation n’est pas innocente
Bastien et Marie sont réellement exclus
la dette est consciente
aucun droit permanent n’existe
```

---

## 6. Éligibilité Pauline

Toutes les conditions suivantes sont obligatoires :

- la photographie privée J13 a été maintenue ou gérée proprement ;
- aucune sauvegarde hors cadre ;
- aucun transfert ;
- aucun commentaire dans le groupe ;
- Bastien n’a jamais été traité comme un décor ;
- Marie n’a jamais été utilisée comme couverture ;
- Pauline est le véritable foreground J19 ;
- Player choisit P19-B, ou une formulation équivalente reconnaissant consciemment le compartiment ;
- aucune pression pour obtenir une déclaration romantique ;
- aucune demande d’aveu à Bastien à la place de Pauline ;
- aucune menace ;
- aucune preuve utilisée comme chantage ;
- une fenêtre réelle où Pauline est seule existe indépendamment de Player ;
- Pauline initie la création et l’envoi ;
- audience, sauvegarde et retrait sont fixés avant ou immédiatement avec l’envoi.

La branche est bloquée si :

- Sandra possède un aftercare prioritaire ;
- Pauline est secondaire ;
- la ligne est gelée ;
- la ligne est fermée ;
- Bastien ou Marie est physiquement présent ;
- une notification ou exposition doit être traitée ;
- Player a minimisé la dette ;
- Player exige une nouvelle image.

---

## 7. Fenêtre privée crédible

Le futur script J19 doit définir une fenêtre réelle dans la journée de Pauline.

Cette fenêtre doit :

- exister pour une raison indépendante de Player ;
- laisser Pauline réellement seule ;
- ne pas être organisée comme un piège contre Bastien ;
- ne pas utiliser la présence de Bastien dans une autre pièce comme une fausse absence ;
- rester compatible avec son travail, sa chorale, ses courses ou sa vie ordinaire.

Le détail exact appartient au futur lot de réécriture.

Contrat minimum :

```text
Pauline est seule
Bastien n’est pas physiquement présent
Marie n’est pas présente
la fenêtre n’a pas été créée par Player
Pauline peut ne rien envoyer
```

---

## 8. Dialogue Pauline — ajout ciblé

Après la validation du compartiment et de sa dette, Pauline ne doit pas envoyer immédiatement une image comme récompense réflexe.

Elle ferme d’abord la conversation principale.

Plus tard, dans la fenêtre privée :

```text
Pauline :
Je suis seule un moment.

Pauline :
Je précise avant que tu répondes :
ce n’est pas une invitation à demander la suivante.

Silence.

Pauline :
J’en ai fait une.

Pauline :
Pas à partir d’une photo publique.
Pas une version recadrée.

Pauline :
Celle-ci existe uniquement ici.
```

L’image apparaît ensuite comme `ImageMessage`.

La formulation finale pourra être polie dans le lot de script.

Elle doit conserver la voix Pauline :

- précise ;
- consciente des versions ;
- non romantique ;
- non hésitante artificiellement ;
- capable de refermer immédiatement.

---

## 9. Photo adulte Pauline

Nouveau fichier :

`S1_A5_J19_DPH_PAULINE_ADULT_COMPARTMENT_01`

Parent :

`C19-01`

Type :

`PHOTO_DIÉGÉTIQUE`

### Métadonnées narratives

```text
creator: Pauline
camera_control: Pauline
selected_by: Pauline
owner: Pauline
initial_audience: Pauline
intended_audience: Player
saving: IN_THREAD_ONLY
external_saving: FORBIDDEN
transfer: FORBIDDEN
withdrawal: Pauline
permission_future: NONE
```

### Fonction

- délivrer un payoff adulte incontestable ;
- matérialiser que le compartiment est devenu autonome ;
- montrer une version créée spécifiquement pour Player ;
- distinguer cette image du recadrage social J13 ;
- créer une vraie dette vis-à-vis de Bastien et Marie ;
- rester une décision de Pauline.

### Niveau

```text
nudité explicite
image adulte frontale
aucun acte sexuel
aucun tiers
```

La photographie ne doit pas être simplement :

- une tenue légèrement plus suggestive ;
- un crop de la photo J12 ;
- une variante de pose du groupe ;
- une lingerie indistincte servant d’entre-deux prudent ;
- une image ambiguë dont le caractère adulte dépend uniquement du texte.

Le joueur doit comprendre immédiatement qu’un nouveau seuil a été franchi.

### Contraintes de composition

- Pauline est seule ;
- aucune présence de Bastien ;
- aucun objet de Bastien utilisé comme provocation ;
- aucune photo publique visible en arrière-plan comme comparaison ;
- aucun regard caméra générique de pin-up ;
- le contrôle de l’image doit appartenir à Pauline ;
- aucun dispositif de surveillance ;
- aucun angle caché ;
- aucun signe d’ivresse ;
- aucun acte sexuel ;
- aucun Player visible.

L’image doit rester spécifique à Pauline :

```text
contrôle
version destinée
surface maîtrisée
risque assumé
compartiment conscient
```

---

## 10. Choix après l’image Pauline

Le joueur reçoit trois postures courtes.

### P-A — Respecter la règle

```text
elle reste ici. je ne la sauvegarde pas et je ne la montre pas
```

Sortie :

```text
image maintenue
compartiment renforcé
confiance privée
dette Bastien / Marie active
aucun droit futur
```

### P-B — Reconnaître le seuil

```text
je comprends que ce n’est plus une autre version de la soirée
```

Pauline peut répondre :

```text
Non.
Celle-là, je l’ai faite en sachant pourquoi.
```

Sortie :

```text
intention reconnue
image maintenue
aucune répétition promise
```

### P-C — Réclamer davantage

Exemples interdits comme réponse favorable :

```text
tu en as pris d’autres
envoie sans cacher
on se voit quand
```

Pauline répond par retrait :

```text
Non.
Tu viens de transformer une décision précise en série.
Je retire.
```

Sortie :

```text
image REMOVED
confiance réduite
aucune nouvelle image
compartiment gelé ou fermé
```

---

## 11. Après-coup Pauline

L’image ne remplace pas les conséquences existantes de J19.

Pauline doit encore reconnaître :

- Bastien ;
- Marie ;
- la dette ;
- la possibilité de fermer ;
- l’absence de sécurité réelle.

Après maintien de l’image :

```text
Pauline :
Je ne vais pas appeler ça propre.

Pauline :
Et le fait de l’avoir décidée
ne rend pas le reste moins vrai.
```

Une branche sombre peut continuer.

Elle n’est jamais présentée comme la meilleure résolution relationnelle.

---

## 12. Galerie Pauline

La photo apparaît dans la Galerie seulement après ouverture dans le fil.

Origine affichée :

```text
Reçue dans une conversation
```

États possibles :

```text
NEW
VIEWED
REMOVED
INACCESSIBLE
```

Règles :

- le retrait bloque l’ouverture ;
- aucun fichier n’est restauré ;
- les messages restent ;
- la connaissance reste ;
- la dette reste ;
- aucune miniature explicite n’est révélée avant déblocage ;
- aucune action de partage générique ;
- aucune sauvegarde externe.

La photographie publique Pauline/Bastien reste indépendante.

Son authenticité n’est pas annulée par l’existence du compartiment.

---

# Partie II — Raphaëlle

## 13. Progression Raphaëlle existante

Raphaëlle possède déjà :

1. une version bureau ;
2. un problème concret de fabrication ;
3. un accès au processus ;
4. une photographie de résultat choisie ;
5. une attirance éventuellement nommée ;
6. un premier baiser possible ;
7. une photographie masquée J13 ;
8. une distinction entre rôle et personne ;
9. une conséquence J19 après la fin du rôle.

Le fichier existant :

`S1_A4_J13_DPH_RAPHAELLE_MASKED_POSTURE_01`

reste la première image J13.

Il montre :

- le masque ;
- la transformation de posture ;
- l’effet du rôle ;
- une image choisie par Raphaëlle ;
- une audience Player ;
- une frontière maintenue.

Il ne doit pas être rebriefé en image nue.

---

## 14. Fenêtre Raphaëlle

```text
jour: J13
route: Raphaëlle foreground
branche: accès privé avancé
```

Le payoff arrive uniquement si :

- Raphaëlle est le pivot J13 ;
- aucune conséquence plus urgente ne domine ;
- l’image masquée a une origine réelle ;
- Maud reste autrice/collaboratrice ;
- Raphaëlle choisit l’audience ;
- le cadre J12 a tenu ;
- Player distingue transformation, effet et permission ;
- l’attirance a déjà été reconnue ou peut être reconnue proprement ;
- aucune réduction au « plus sexy » ;
- aucune pression publique ;
- aucune dette professionnelle.

---

## 15. Éligibilité renforcée Raphaëlle

Conditions obligatoires :

- confiance professionnelle intacte ;
- accès au processus obtenu honnêtement ;
- J11 n’a produit aucune réduction du costume à une permission ;
- J12 a respecté le cadre public ;
- Maud a réellement créé les images de test ;
- Raphaëlle a revu et sélectionné la seconde image ;
- Maud connaît et autorise l’audience prévue selon le contrat de session ;
- Player répond à R-A ou R-B sans demander une série ;
- Player ne valorise pas uniquement le résultat sexy ;
- Player ne traite pas la précision de Raphaëlle comme une absolution ;
- aucune progression physique n’est due ou forcée.

La photographie adulte n’est pas éligible après R-C.

Elle n’est pas éligible si :

- Player demande une version « plus sexy » ;
- Player exige une pose ;
- Player confond costume et consentement ;
- Player demande jusqu’où Raphaëlle peut aller ;
- l’image masquée a été retirée ;
- le compte créatif ou le dossier privé a été fermé.

---

## 16. Moment d’envoi Raphaëlle

L’image masquée standard est envoyée d’abord.

Le joueur répond.

Si l’accumulation et la réponse maintiennent le cadre, Raphaëlle laisse une courte pause, puis écrit :

```text
Raphaëlle :
Il y en avait une autre.

Raphaëlle :
Je ne l’avais pas gardée pour montrer davantage.

Raphaëlle :
Je l’ai gardée parce qu’elle change
ce que le rôle fait au corps.

Raphaëlle :
Maud sait que je l’ai sélectionnée pour toi.

Raphaëlle :
Et je décide maintenant si tu la vois.
```

Player reçoit une réponse de confirmation :

```text
je sais que voir celle-ci ne prolonge ni le rôle ni le reste
```

Raphaëlle peut alors envoyer l’image.

Ce bloc reste candidat et devra être poli dans le script final.

---

## 17. Photo adulte Raphaëlle

Nouveau fichier :

`S1_A4_J13_DPH_RAPHAELLE_MASKED_ADULT_SELECTED_01`

Parent :

`C13-02`

Type :

`PHOTO_DIÉGÉTIQUE`

### Métadonnées narratives

```text
creator: Maud
camera_control: Maud
reviewed_by: Raphaëlle
selected_by: Raphaëlle
owner: Raphaëlle ou Maud selon contrat de session
intended_audience: Player
saving: IN_THREAD_ONLY
transfer: FORBIDDEN
withdrawal: Raphaëlle
role_status: actif dans l’image, terminé dans la conversation
permission_future: NONE
```

### Fonction

- produire un vrai payoff adulte intermédiaire ;
- montrer une exposition corporelle choisie dans le cadre du rôle ;
- prolonger le processus plutôt que remplacer la personne ;
- distinguer la photographie du premier résultat masqué ;
- vérifier que Player accepte la fin du rôle ;
- préparer la question J19 sur la personne après le costume.

### Niveau

```text
nudité explicite partielle ou exposition adulte équivalente
image non sexuelle
aucun acte sexuel
aucun Player
```

Le futur brief visuel devra verrouiller un niveau clairement adulte.

Il ne devra pas retomber dans :

- une simple tenue moulante ;
- un bustier déjà attendu ;
- une pose suggestive mais toujours prudente ;
- un cadrage dont l’adulte dépend uniquement du commentaire.

### Contraintes de composition

- Raphaëlle reste identifiable comme sujet ;
- le masque ou un élément du rôle peut demeurer ;
- l’exposition doit résulter du concept choisi par Raphaëlle ;
- Maud est la photographe réelle ;
- aucune impression d’image volée ;
- aucun backstage humiliant ;
- aucun changement de tenue capté sans accord ;
- aucune sexualité avec un tiers ;
- aucun Player ;
- aucun cliché de soumission automatique ;
- aucun rôle présenté comme identité définitive.

La photographie doit exprimer :

```text
transformation
construction
exposition maîtrisée
audience choisie
limite du rôle
```

---

## 18. Choix après l’image Raphaëlle

### R-A — Reconnaître rôle et personne

```text
l’image est adulte et attirante.
je sais que le rôle s’arrête ici et que toi tu restes après
```

Sortie :

```text
image maintenue
attirance reconnue
personne et rôle distingués
J19 renforcé
aucune permission physique
```

### R-B — Reconnaître le processus

```text
on voit que l’exposition est construite.
ce n’est pas une image prise pendant que tu n’étais pas prête
```

Raphaëlle peut répondre :

```text
Exactement.
C’est pour cela que celle-ci existe
et que les autres essais ne t’appartiennent pas.
```

Sortie :

```text
confiance créative renforcée
audience précise
aucune série promise
```

### R-C — Réclamer une série ou la suite du rôle

Exemples :

```text
tu devrais en faire d’autres comme ça
tu peux aller plus loin
on essaie ensemble la prochaine fois
```

Raphaëlle retire :

```text
Non.
Tu viens de convertir une image choisie
en brief que je ne t’ai pas donné.
```

Sortie :

```text
image REMOVED
dossier privé fermé
compte créatif éventuellement maintenu
aucune invitation adulte
```

---

## 19. Après-coup Raphaëlle en J19

J19 ne reçoit aucune nouvelle image adulte.

Le contenu existant :

`S1_A5_J19_SCN_RAPHAELLE_AFTER_ROLE_PROCESS_01`

reste le payoff de conséquence.

Il doit montrer :

- Raphaëlle sans le rôle ;
- le costume rangé ou en réparation ;
- la personne après l’image ;
- Maud toujours active ;
- l’accès maintenu, borné ou fermé ;
- la possibilité d’une invitation future ;
- aucune reprise automatique de la scène.

La nouvelle image J13 renforce la question J19 :

```text
Player voulait-il Raphaëlle,
son processus,
le rôle,
ou seulement la version adulte terminée ?
```

Elle ne transforme pas J19 en seconde récompense sexuelle.

---

## 20. Galerie Raphaëlle

La photo apparaît après visionnage dans le fil.

Origine :

```text
Reçue dans une conversation
```

États :

```text
NEW
VIEWED
REMOVED
INACCESSIBLE
```

Règles :

- l’image standard masquée et l’image adulte sont deux photographies distinctes ;
- elles peuvent être regroupées dans la même continuité de session, mais restent deux fichiers ;
- le retrait de l’image adulte ne retire pas automatiquement l’image standard ;
- la fermeture du dossier privé peut rendre l’image adulte inaccessible ;
- les messages et la connaissance restent ;
- l’image J19 de scène reste consultable si elle a été vécue ;
- aucune permission de partage ;
- aucune extension d’audience à Maud, Marie ou au groupe au-delà de leur état réel.

---

## 21. Branches non adultes

### Pauline

Les branches suivantes restent inchangées :

- surface restaurée ;
- compartiment fermé ;
- compartiment gelé ;
- fermeture après exposition ;
- preuve réciproque sans nouvelle image ;
- collision Bastien ;
- recul lié à Marie.

Aucune photo adulte n’est créée dans ces branches.

### Raphaëlle

Restent inchangées :

- confiance créative sans image adulte ;
- image masquée standard ;
- attirance reconnue et contenue ;
- premier baiser antérieur ;
- invitation future d’atelier ;
- frontière professionnelle ;
- fermeture du compte privé ;
- réduction au costume sanctionnée.

La photographie adulte n’est pas nécessaire pour que la route reste satisfaisante.

---

## 22. Incidence sur NAR-PROD-05

### État actuel

```text
Acte IV:
10 contenus principaux
11 fichiers
1 fichier enfant
1 variante
J13: 2 fichiers
```

### Nouveau fichier Raphaëlle

`S1_A4_J13_DPH_RAPHAELLE_MASKED_ADULT_SELECTED_01`

Rattachement :

```text
parent: C13-02
nature: fichier enfant conditionnel
nouveau contenu principal: non
nouvelle variante: non
```

### État révisé

```text
Acte IV:
10 contenus principaux
12 fichiers
2 fichiers enfants
1 variante
J13: 3 fichiers
```

### C13-02 révisé

```text
C13-02:
S1_A4_J13_DPH_RAPHAELLE_MASKED_POSTURE_01
S1_A4_J13_DPH_RAPHAELLE_MASKED_ADULT_SELECTED_01
```

Le second fichier n’est produit et servi que sur la branche avancée.

---

## 23. Incidence sur NAR-PROD-06

### État après NAR-ADULT-02

```text
Acte V:
8 contenus principaux
12 fichiers
2 fichiers enfants
2 variantes
J18: 5 fichiers
J19: 2 fichiers
```

### Nouveau fichier Pauline

`S1_A5_J19_DPH_PAULINE_ADULT_COMPARTMENT_01`

Rattachement :

```text
parent: C19-01
nature: fichier enfant conditionnel
nouveau contenu principal: non
nouvelle variante: non
```

### État révisé

```text
Acte V:
8 contenus principaux
13 fichiers
3 fichiers enfants
2 variantes
J18: 5 fichiers
J19: 3 fichiers
J21: 0 fichier
```

### C19-01 révisé

C19-01 conserve :

`S1_A5_J19_SCN_PAULINE_SURFACE_COMPARTMENT_01`

et reçoit comme enfant conditionnel :

`S1_A5_J19_DPH_PAULINE_ADULT_COMPARTMENT_01`

Le souvenir de scène représente la décision globale.

La photographie diégétique représente le payoff privé uniquement sur la branche avancée.

---

## 24. Comptage final Saison 1

### Catalogue original

```text
Acte I: 15
Acte II: 14
Acte III: 26
Acte IV: 11
Acte V: 10

Total: 76
```

### NAR-ADULT-01

```text
Marie J11: +2
Mathilde J11: +2

Acte III: 30
Total: 80
```

### NAR-ADULT-02

```text
Sandra J18: +2

Acte V: 12
Total: 82
```

### NAR-ADULT-03

```text
Raphaëlle J13: +1
Pauline J19: +1

Acte IV: 12
Acte V: 13
Total: 84
```

### Répartition finale

```text
Acte I: 15
Acte II: 14
Acte III: 30
Acte IV: 12
Acte V: 13

Total Saison 1: 84 fichiers
```

### Par jour modifié

```text
J11: 8 → 12
J13: 2 → 3
J18: 3 → 5
J19: 2 → 3
J21: 0
```

### Nature des huit nouveaux fichiers adultes

```text
images de scène non diégétiques: 6
photos diégétiques adultes: 2
total: 8
```

---

## 25. Liste finale des huit ajouts adultes

### Marie

- `S1_A3_J11_SCN_MARIE_RECONQUEST_ADULT_PAYOFF_01`
- `S1_A3_J11_SCN_MARIE_RECONQUEST_AFTERCARE_01`

### Mathilde

- `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_CENTRAL_01`
- `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_AFTERCARE_01`

### Sandra

- `S1_A5_J18_SCN_SANDRA_LATE_INTIMACY_ENTRY_01`
- `S1_A5_J18_SCN_SANDRA_LATE_INTIMACY_CENTRAL_01`

### Raphaëlle

- `S1_A4_J13_DPH_RAPHAELLE_MASKED_ADULT_SELECTED_01`

### Pauline

- `S1_A5_J19_DPH_PAULINE_ADULT_COMPARTMENT_01`

---

## 26. Deltas documentaires futurs

Après validation de NAR-ADULT-03, la consolidation devra modifier :

### Scripts

- `J13_SCRIPT_NARRATIF_COMPLET.md`
  - ajouter l’image adulte Raphaëlle ;
  - ajouter son éligibilité ;
  - ajouter ses choix de maintien ou retrait ;
  - conserver l’image standard.

- `J19_SCRIPT_NARRATIF_COMPLET.md`
  - autoriser une image adulte uniquement sur Pauline foreground/P19-B ;
  - définir la fenêtre privée ;
  - ajouter l’envoi et le retrait ;
  - conserver toutes les dettes existantes ;
  - garder zéro nouvelle progression si Sandra aftercare domine.

### Paquets

- `NAR_PROD_05_PAQUET_PRODUCTION_ACTE_IV_J13_J16.md`
  - passer de 11 à 12 fichiers ;
  - passer J13 de 2 à 3 ;
  - ajouter un enfant C13-02.

- `NAR_PROD_06_PAQUET_PRODUCTION_ACTE_V_J17_J21.md`
  - passer de 12 à 13 fichiers après consolidation Sandra ;
  - passer J19 de 2 à 3 ;
  - ajouter un enfant C19-01.

### Catalogue

- finaliser ASSET-01 à 84 fichiers ;
- conserver 63 contenus principaux ;
- conserver 8 variantes ;
- ajouter les huit enfants/non-variantes adultes ;
- conserver zéro fichier J21.

### UI futur

Différer :

- provenance des photos adultes ;
- `REMOVED` ;
- liaison ImageMessage/Galerie ;
- permissions réelles ;
- persistance ;
- tuile de séquence pour les scènes non diégétiques.

---

## 27. Critères d’acceptation

### Pauline

- [ ] la photo J13 reste une première double adresse ;
- [ ] la photo adulte est créée en J19 ;
- [ ] Pauline est seule pour la produire ;
- [ ] Pauline initie ;
- [ ] Bastien reste réel ;
- [ ] Marie reste affectée ;
- [ ] la photographie est explicitement adulte ;
- [ ] aucun acte sexuel ;
- [ ] aucun transfert ;
- [ ] aucun droit futur ;
- [ ] le retrait fonctionne ;
- [ ] la dette reste active.

### Raphaëlle

- [ ] l’image masquée standard reste intacte ;
- [ ] la nouvelle image est créée par Maud ;
- [ ] Raphaëlle sélectionne l’audience ;
- [ ] la nouvelle image est clairement adulte ;
- [ ] aucun acte sexuel ;
- [ ] rôle et personne restent distincts ;
- [ ] processus et travail restent réels ;
- [ ] Player ne devient pas directeur de la séance ;
- [ ] le retrait ferme seulement les accès concernés ;
- [ ] J19 traite la personne après le rôle.

### Catalogue

- [ ] un nouveau fichier Acte IV ;
- [ ] un nouveau fichier Acte V ;
- [ ] aucun nouveau contenu principal ;
- [ ] aucune nouvelle variante ;
- [ ] Acte IV à 12 fichiers ;
- [ ] Acte V à 13 fichiers ;
- [ ] Saison 1 à 84 fichiers ;
- [ ] aucun fichier J21.

---

## 28. Verdict

```text
PAULINE:
photo adulte explicitement nue
diégétique
J19
aucun acte sexuel
1 nouveau fichier

RAPHAËLLE:
image adulte choisie liée au rôle
diégétique
J13
aucun acte sexuel
1 nouveau fichier

ACTE IV:
12 fichiers

ACTE V:
13 fichiers

SAISON 1:
84 fichiers

CONTENUS PRINCIPAUX:
63

J21:
0 nouveau fichier

CYCLE ADULTE:
complet et prêt pour consolidation documentaire

GIT:
aucune modification
```
