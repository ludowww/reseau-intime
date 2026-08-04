# R8C-N2 — Révision narrative mineure — Sandra — Les chaises bleues

> **Candidate :** `R8C-N2_REVISION_CANDIDATE`
>
> **Statut :** `READY_FOR_FINAL_CANON_APPROVAL`
>
> **Parent de la correction finale :** `128d49ffa210b58f698188860b247b5df6856aca`
>
> **Baseline stable :** `25e8cafac7e14487a2cf57e41c1b1d151873cbbb`
>
> **Tag stable parent :** `r8c-n1-canon-review-sandra-blue-chairs`
>
> **Source historique préservée :** `R8C-A11.5`

## Résultat

La source N2 fournie par ChatGPT reste verrouillée comme deuxième candidate distincte.
La projection structurée applique ensuite l’unique correction canonique autorisée
à `m91`. Aucun token auteur canonique et validable du prénom choisi par le
joueur n’existe dans le dépôt : le repli exact `bonne soirée` est donc utilisé.
Les artefacts A11.5 restent la première candidate verrouillée et ne sont ni
modifiés ni remplacés. N2 ne produit aucune canonisation automatique : la
décision finale appartient à ChatGPT après revue.

La recommandation de ce lot est `READY_FOR_FINAL_CANON_APPROVAL`. Elle ne vaut
pas `CANON_APPROVED`.

## Artefacts N2

Tous les artefacts N2 sont isolés sous `narrative_tool/a11/revisions/` :

- `sandra_blue_chairs_r8c_n2.locked.md` : bloc ChatGPT verrouillé, incluant le manifeste ;
- `sandra_blue_chairs_r8c_n2.source.json` : projection JSON corrigée par le seul repli fermé de `m91` ;
- `sandra_blue_chairs_r8c_n2.provenance.json` : provenance et limites fermées ;
- `sandra_blue_chairs_r8c_n2.plan_projection.json` : projection du plan limitée aux identités, au décompte et à la structure N2 ;
- `sandra_blue_chairs_r8c_n2.draft.json` : brouillon N2 rattaché aux sept battements existants ;
- `sandra_blue_chairs_r8c_n2.validation_report.json` : validation déterministe ;
- `sandra_blue_chairs_r8c_n2.comparison_report.json` : comparaison narrative exhaustive A11.5 → N2 ;
- `sandra_blue_chairs_r8c_n2.traceability_report.json` : participants, battements, choix, média, faits et voix ;
- `sandra_blue_chairs_r8c_n2.blind_reading.md` : lecture anonymisée sans notation ;
- `sandra_blue_chairs_r8c_n2.human_review.md` : relecture éditoriale manuelle sans notation ;
- `sandra_blue_chairs_r8c_n2.canon_decision.json` : décision de soumission à la revue canonique finale.

## Empreintes

- document source verrouillé UTF-8 :
  `af0e48812a160b701b7e60638407513f86b892bbae2258eea1050d7a6a70b404` ;
- contenu narratif N2 projeté :
  `aac0ab82b735467e0d65df6d555f2ff62be2956e6acb5227e5b838112cfa5d77` ;
- contenu narratif historique A11.5 :
  `9167120abc55dbf4275ac67eb7b4f774a58322587d87c9310644e3bcf85982dd`.

La première empreinte couvre le bloc joint complet, manifeste inclus. La
deuxième couvre le contenu jouable structuré : média, messages, formulations,
branches et convergence.

## Convention de prénom et correction finale

La convention réelle est documentée dans
`docs/decisions/DECISION_006_PLAYER_NAME_AND_THREAD_MODEL.md` : `player` est
l’identifiant technique générique et le texte visible final doit employer le
prénom choisi par le joueur. Le dépôt ne définit toutefois aucun token auteur
interpolable pour ce prénom. `display_name` alimente les libellés d’auteur, pas
les occurrences incluses dans le corps des répliques.

Le correctif par rapport au commit revu
`128d49ffa210b58f698188860b247b5df6856aca` est donc exactement :

- `m91` — `bonne soirée, Ludo` → `bonne soirée`.

`m92` et `m93` restent inchangés. La validation reconstruit cette projection
depuis le Markdown verrouillé et refuse tout autre diff narratif.

## Comparaison exhaustive A11.5 → N2

La comparaison porte sur le locuteur, le type, le texte et la branche de
chaque bulle, ainsi que sur le média et les formulations du choix. Elle n'est
pas déduite du seul nombre d'enregistrements.

### Ajouts

- `m51A-2` — Player — « Pas tout » ;
- `m51A-3` — Sandra — « assez ».

### Remplacement de convergence

- l'ancien `m52` commun, « Pas complètement », devient `m52B` sous l'option B ;
- la convergence commune commence à `m53` ;
- le parcours A sort par `m51A → m51A-2 → m51A-3 → m53` ;
- le parcours B sort par `m51B → m52B → m53`.

### Remplacement de la limite reçue

Les anciens `m64–m69` sont remplacés par les nouveaux `m64–m67` :

- `m64` — « J’avais pas l’impression de pousser » ;
- `m65` — « je sais » ;
- `m66` — « c’est pour ça que je te le dis » ;
- `m67` — « D’accord ».

La raison issue de N1 est de simplifier un dialogue trop construit tout en
gardant une réception claire de la limite et un Player non insistant.

### Retraits

- ancien `m70` — « Je recycle » ;
- ancien `m71` — « je sais ».

Ils n'ont plus d'antécédent après le retrait de la plaisanterie sur la phrase
notée puis réutilisée.

### Remplacement de l'incertitude

Les anciens `m75–m78` sont remplacés par :

- `m75` — « Et le reste » ;
- `m76` — « je sais pas encore » ;
- `m77` — « et c’est très bien comme ça » ;
- `m78` — « D’accord ».

La raison issue de N1 est de retirer une formule trop composée et de laisser
Sandra exprimer une incertitude prudente qui lui convient.

### Éléments inchangés

Sont strictement inchangés : le titre, le média, les deux formulations du
choix, `m01–m51A` hors ajouts, `m47B–m51B`, `m53–m63`, `m72–m74` et
`m79–m90` et `m92–m93`. Le rapport JSON énumère individuellement les 84 bulles inchangées
avec leur contenu complet.

### Correction canonique supplémentaire

- `m91` — Sandra — « bonne soirée, Ludo » est remplacé par « bonne soirée » ;
- raison : retrait de l’ancien prénom historique, faute de token auteur canonique et validable ;
- aucune intention, ponctuation voisine, transition ou conséquence n’est modifiée.

Toute bulle étrangère, toute modification d'un élément déclaré inchangé,
toute ancienne convergence à `m52` ou toute réintroduction de `m68–m71` est
refusée par la validation du manifeste.

## Décomptes et transitions

- éléments stockés : **96** ;
- parcours `careful_warmth` : **90** éléments ;
- parcours `ironic_withdrawal` : **89** éléments ;
- battements : **7** ;
- convergence commune : `m53` ;
- après retrait de `m70–m71`, `m72` répond techniquement à `m67` ;
- `m79` suit `m78` sans créer de rendez-vous acquis.

## Relecture narrative

- `m51A-3 → m53` : « assez » puis « ok » est bref et naturel ;
- `m52B → m53` : « Pas complètement » puis « ok » conserve la continuité de B ;
- `m64–m67` : Sandra formule la limite, Player la reçoit sans se défendre longuement ;
- `m67 → m72` : « D’accord » ouvre naturellement la précision suivante de Sandra ;
- `m75–m78` : l'incertitude de Sandra est claire, prudente et non brillante ;
- `m78 → m79` : Player accepte avant d'énoncer une possibilité au conditionnel ;
- la photo garde sa fonction concrète de relance ;
- Sandra et Player restent les seuls participants ;
- Marie et Mathilde sont structurellement incompatibles avec le plan, les faits, les mouvements et la voix ;
- aucun désir mutuel, rendez-vous acquis, route, intimité future, fait durable ou conséquence supplémentaire n'est introduit.

### Répétitions restantes

- `je sais` : `m42`, `m65`, `m83` ;
- `D’accord` : `m60`, `m67`, `m78` ;
- `sans promesse` : `m87`, `m88` ;
- `pas complètement` : `m51B`, `m52B`.

Elles restent audibles mais remplissent des fonctions distinctes de rythme,
réception ou limite. Aucune nouvelle réécriture hors manifeste n'est engagée.

## Périmètre et gate

Le lot ne touche aucun fichier `game/`, ne crée aucun export A6, ne branche
rien en Saison 1, ne crée aucune trace A1 et ne modifie aucun artefact A1–A10
ou A11.5. Aucun asset, aucune scène et aucun mécanisme de score, hasard,
classement, priorité ou compatibilité historique ne sont ajoutés.

Les commandes spécifiques sont :

```text
python tools/a11_plan_draft_export.py validate-n2
python tools/a11_plan_draft_export.py n2-blind
python tools/a11_plan_draft_export.py n2-review
python tools/a11_plan_draft_export.py n2-smoke
python -m unittest tests.test_r8c_n2_sandra_blue_chairs_revision -v
```

Godot est hors gate : aucun fichier chargé par Godot n'est modifié.
