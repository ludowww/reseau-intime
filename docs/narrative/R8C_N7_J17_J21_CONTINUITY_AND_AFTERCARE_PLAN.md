# R8C-N7 — Plan de continuité J17/J21 et d’aftercare

> **Baseline inspectée :** `5bb04c957030c00a0e8c6a9c39a103e8f697cd2e`
> **Tag stable :** `r8c-n6-global-scene-visual-erotic-coverage-audit`
> **Portée :** raccords J17/J21 et aftercares Marie, Mathilde, Sandra
> **Nature :** plan de révision ; aucun dialogue définitif
> **Repérage :** les jours localisent le runtime actuel ; les positions de séquence restent autoritatives

## 1. Verdict

J17 et J21 ne demandent ni une nouvelle scène sexuelle, ni une seconde finale, ni
de nouveaux assets.

- **J17** possède déjà les deux événements nécessaires — départ réel de Mathilde,
  puis clarification du couple — mais le runtime en réduit les états et la portée.
  Le raccord recommandé est court : quelques messages de confirmation après la
  co-présence, un record de règle provisoire et une conséquence praticable. Une
  nouvelle scène complète ferait doublon avec le script canonique détaillé.
- **J21** possède déjà le matin Marie, la trace et la posture Player, mais le runtime
  termine dans le fil du contrôleur de la trace. Il manque la conversation autonome
  Marie/Player, la décision du couple et son organisation concrète avant les courts
  épilogues. Cette conversation est la finale ; la trace n’en est que la matière.
- **Aftercare** : Marie et Mathilde disposent d’un contrat canonique et d’un chemin
  runtime J11/J12 ; Sandra dispose d’un contrat canonique J18/J19, mais aucun chemin
  runtime correspondant. J17 et J21 doivent conserver ces faits et conséquences,
  pas les résumer en résultats de route.

| Raccord | Forme recommandée | Média | Statut N7 |
|---|---|---|---|
| `N7-CONT-J17-PROVISIONAL` | quelques messages + trace + conséquence ; aucune nouvelle scène complète | `RELATIONSHIP_PROOF` et `CONSEQUENCE_OR_ECHO` | `NEEDS_CANON_DECISION` |
| `N7-CONT-J21-FINAL` | conversation Marie/Player dans la séquence finale existante, après conséquences/trace ; trois réutilisations | `CONSEQUENCE_OR_ECHO` principal | `READY_FOR_SCRIPTING` |

J17 reste `NEEDS_CANON_DECISION` parce que le contrat narratif le plus récent note
explicitement la granularité de sa réécriture comme ouverte. N7 recommande le
raccord court ; une approbation canonique doit confirmer ce format et la table de
six états avant écriture définitive.

## 2. Sources et frontières d’autorité

| Source | Statut | Fait utilisé |
|---|---|---|
| `docs/canon/bible/14_CONTRAT_NARRATIF_SAISON_1_RECONCILIE.md` | canon structure/finale le plus récent | J17 = clarification intermédiaire ; J21 = conséquences, conversation Marie/Player, décision/logistique, épilogues. |
| `docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md` | canon pré-runtime à réécrire ciblé | Départ, foyer, six états provisoires, choix et retours de séparation. |
| `docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md` | canon pré-runtime à réécrire ciblé | Matin, trace, posture, branches du soir et trois fonctions visuelles. |
| `docs/canon/dialogues/NAR_PROD_06_PAQUET_PRODUCTION_ACTE_V_J17_J21.md` | canon de production | Trois beats J17, trois réutilisations J21, zéro nouvel asset J21. |
| scripts J11/J12/J18/J19 et addenda adultes | canon adulte | Aftercare, ordre des conséquences et limites des médias. |
| conversations/maps/providers J17/J18/J19/J21 et `Season1State.gd` | runtime actif | Ce qui est réellement servi, persisté ou absent. |
| quatre documents N6 | audit | Exactement deux raccords et trois payoffs, sans nouvelle scène. |
| `12D_PLANS_SCENES_J17_J21.md` | canon ancien à réécrire ciblé | Matière des résolutions ; pas autorité pour faire de la trace une finale suffisante. |
| anciens constats de jouabilité ou budgets | historique | Provenance seulement. |

## 3. J17 — discontinuité réelle

### 3.1 Position de séquence

Dans la structure relative de saison, J17 se place après :

1. les conséquences et priorités des mouvements précédents ;
2. la préparation du départ en J16 ;
3. l’acceptation, le déplacement ou le refus d’une heure de couple ;

et avant :

4. la résolution Sandra ;
5. les résolutions Pauline/Raphaëlle/Nico ;
6. la conversation finale Marie/Player.

Il combine `S31 — La fin du séjour de Mathilde` puis `S29 — La conversation qui ne
peut plus être repoussée`, mais S29 devient ici une clarification tardive et non la
clôture de saison.

### 3.2 Canon, runtime et écart

| Axe | Canon actuel | Runtime baseline | Discontinuité |
|---|---|---|---|
| Départ Mathilde | ordinaire, distance, accéléré, sans Player ou aide ; effet du secret/aftercare conservé | `ORDINARY` ou `DISTANCE`, puis `HELP` ou `DISTANCE` | Les nuances loyauté, secret suspendu et confiance rompue sont aplaties. |
| Co-présence | chat suspendu pendant récupération/départ | un `OFF_PHONE` global avant les messages Mathilde | Fonction présente, mais le résultat du départ n’est pas rejoué comme retour séparé. |
| Foyer | petite chambre et organisation matérielle changent de sens | transition textuelle, aucun beat/présentation Galerie | Conséquence nommée, non matérialisée. |
| Couple | six états : reconquête, provisoire, reconfiguration, double vie fragile, fracture, séparation | quatre sorties : reconquête, provisoire, séparation, fracture par refus | Reconfiguration et double vie manquent ; l’accumulation pèse moins que le choix local. |
| Règle de suivi | checkpoint/délai/limites si provisoire ; logistique si séparation | record `j17_couple_definition_record_01`, sans promesse de revue créée | Le record dit un état, mais pas ce qu’il oblige ensuite. |
| Fonction de saison | clarification provisoire | titre et fermeture peuvent se lire comme définition suffisante | J21 hérite d’un état sans contrat/divulgation/logistique complets. |

### 3.3 Forme minimale suffisante

Le raccord recommandé ne remplace pas le départ ni la conversation existante. Il
ajoute une **fermeture courte de séquence** après la co-présence et le choix :

1. un retour de Mathilde confirmant seulement l’état matériel et relationnel qu’elle
   peut légitimement connaître ;
2. un constat Marie sur le foyer transformé ;
3. une confirmation Marie/Player de la règle **actuelle**, de sa limite et, lorsque
   nécessaire, de son prochain point de revue ;
4. un record de couple séparant statut, règle provisoire et divulgation encore
   incomplète ;
5. une conséquence future lisible : comportement attendu, espace, heure, promesse
   de revue ou logistique de séparation.

Ces fonctions peuvent tenir dans quelques messages et un record. Une nouvelle scène
complète n’est justifiée que si l’approbation canonique refuse de réutiliser la
conversation J17 signée ; N7 ne la recommande pas.

### 3.4 Table des sorties à préserver

| Sortie canonique | Preuve écrite minimale | Conséquence autorisée | Interdit |
|---|---|---|---|
| `RECONQUEST_ACTIVE` | comportement concret à tenir maintenant | présence et actes vérifiables ; aucune absolution | retour automatique à l’ancien couple |
| `PROVISIONAL_AGREEMENT` | règle actuelle + limite + date/condition de revue | `couple_review_due_at` active | report indéfini ou permission extérieure |
| `RECONFIGURATION_NEGOTIATING` | suspension explicite des nouvelles étapes + sujets à décider | espace et checkpoint | traiter la négociation comme contrat ouvert |
| `DOUBLE_LIFE_FRAGILE` | contradiction reconnue comme instable | dette et risque de découverte | résultat optimal ou contrat sain |
| `FRACTURE` | distance/foyer/finances concrètes | organisation temporaire | disponibilité automatique des routes extérieures |
| `SEPARATION` | départ, objets, horaires et limites | relation résiduelle à définir plus tard | scène de consolation immédiate |

### 3.5 Choix, réception et consentement média

Les choix existants restent le socle : aide/distance pour le départ ; reconquête,
provisoire ou séparation si l’heure est due ; reconnaissance de la fracture si elle
ne l’est pas. Leur réception doit être recalibrée par l’accumulation, jamais par une
bonne phrase unique.

J17 n’est pas un payoff sexuel. Ses images de scène du départ, du foyer et du couple
n’appellent pas une classification sexuelle. Toute photo ordinaire éventuelle de
Mathilde reste toutefois une création contrôlée : audience familiale/privée
explicitement définie, donc `CONSENTED_PRIVATE` ou `CONSENTED_SHARED` selon le fil,
jamais preuve de disponibilité. Les rôles principaux restent :

- départ réel : `CONSEQUENCE_OR_ECHO` ;
- foyer transformé : `CONSEQUENCE_OR_ECHO` ;
- état du couple : `RELATIONSHIP_PROOF`.

## 4. J21 — discontinuité réelle

### 4.1 Position de séquence

J21 est la séquence finale après les résolutions personnelles et la sélection
invisible d’une trace. Son ordre canonique obligatoire est :

```text
conséquences pertinentes
→ trace et posture
→ conversation autonome Marie/Player
→ décision du couple et organisation concrète
→ courts épilogues compatibles
```

Les numéros de jour peuvent disparaître dans un futur moteur ; cet ordre ne le peut
pas.

### 4.2 Canon, runtime et écart

Le runtime sert :

1. un matin Marie variant selon `couple_state` ;
2. une trace unique sélectionnée en J20 ;
3. un dernier choix de posture dans le fil du contrôleur de cette trace ;
4. une réponse courte de ce même contrôleur ;
5. la fin de saison.

La discontinuité n’est donc pas l’absence totale de Marie. Elle est l’absence de la
conversation **après** les conséquences et la posture. Le matin réemploie la règle
J17 mais ne peut pas connaître l’acte ou la contradiction de la journée ; la réponse
du contrôleur de trace ne peut pas décider le couple. Le runtime termine également
sans champs complets de contrat, divulgation ou relation après séparation.

### 4.3 Raccord requis

Le raccord J21 réutilise les branches du soir déjà présentes dans le script
pré-runtime comme matière, mais les réordonne sous le contrat `14` :

1. lire le statut provisoire J17, les faits de routes et la posture finale ;
2. limiter Marie à ce qu’elle sait réellement ;
3. ouvrir un échange privé Marie/Player distinct du fil de la trace ;
4. produire une décision actuelle : ensemble, séparés ou clarification strictement
   bornée ;
5. si ensemble, établir un contrat explicite et séparer son état de divulgation ;
6. si séparés, établir la logistique et la relation résiduelle ;
7. si provisoire, fixer règle, limites, date/condition et obligations de suivi ;
8. seulement ensuite servir la conséquence visuelle finale et les épilogues courts.

Aucun nombre de messages n’est imposé. La conversation doit être assez longue pour
porter une décision réelle et assez courte pour ne pas résumer vingt jours.

### 4.4 Trois réutilisations visuelles, pas trois assets

| Beat | Source admissible | Fonction narrative | Rôle média principal | Garde |
|---|---|---|---|---|
| `J21-B1` | image de scène J17–J20 déjà vécue | montrer la vie ordinaire transformée avant/au contact de la décision finale | `RELATIONSHIP_PROOF` ou `CONSEQUENCE_OR_ECHO` | joueur seulement si scène ; aucun nouveau fichier |
| `J21-B2` | photo/photo-set accessible, ou état/absence d’une trace | porter la règle, la perte ou la dette sans révélation nouvelle | selon source : `RELATIONSHIP_PROOF`, `TRUST_OR_INTIMACY_REWARD` ou `CONSEQUENCE_OR_ECHO` | même audience, aucun retrait annulé, garde de type |
| `J21-B3` | contenu existant de vie après décision | montrer le comportement ou la conséquence finale, puis laisser les arcs continuer | `CONSEQUENCE_OR_ECHO` | pas de pose-récompense, pas de nouvelle route |

Les anciennes mentions J21 « À PRODUIRE PLUS TARD » sont `REFERENCE_ONLY` et
`NO_NEW_ASSET`. Un `TEXT_MESSAGE`, `FACT_RECORD`, `ACCESS_GRANT`,
`ACCESS_REVOCATION` ou `ABSENCE_MARKER` peut déterminer le sens ou la sélection,
mais ne devient jamais « la dernière photo ».

### 4.5 Consentement, possession et diffusion à J21

| État de la source | Classe d’audit | Service autorisé |
|---|---|---|
| photo privée encore accessible à Player selon sa règle | `CONSENTED_PRIVATE` | affichage direct dans la même audience |
| photo/set public ou groupe légitime | `CONSENTED_SHARED` | affichage selon la source et le groupe, sans recadrage érotique automatique |
| connaissance de consultation non établie | `AMBIGUOUS_SEEN_NOT_SEEN` | état, message ou absence ; ne pas attribuer une connaissance certaine |
| copie non autorisée, diffusion, exposition ou possession interdite | `NON_CONSENTED_OR_DIFFUSED` | conséquence sombre, suppression/inaccessibilité ou dette ; jamais récompense propre |
| image retirée/inaccessible | classe originale conservée, accès retiré | absence ou état seulement ; aucun aperçu restauré |

Création, possession, consultation et diffusion sont quatre faits séparés. La finale
ne les fusionne pas sous un booléen « image vue » et ne transforme jamais une
violation en preuve relationnelle positive.

### 4.6 Choix et réception

Les choix du matin restent des conséquences concrètes de J17. Les postures
`RULE_ACTED`, `LOSS_ACKNOWLEDGED` et, seulement si préexistante,
`EXISTING_CONTRADICTION_MAINTAINED` restent des lectures de l’état réel ; elles ne
doivent plus servir de décision du couple.

La conversation Marie/Player doit offrir ou confirmer un choix réel de sortie. Son
résultat ne peut être déduit uniquement du contrôleur de la trace, ni modifier
rétroactivement une route, une audience ou un consentement. La réception finale de
Marie doit être autonome et compatible avec ses connaissances.

## 5. Audit transversal des aftercares

### 5.1 Marie

| Champ | Audit |
|---|---|
| Aftercare écrit | Matin J12 : présence, café, responsabilité et absence de reset. |
| Aftercare prévu | `S1_A3_J11_SCN_MARIE_RECONQUEST_AFTERCARE_01` ; continuité du couple jusqu’à J17/J21. |
| Placeholder Galerie | Oui, enfant 3/3 de `MARIE_J11_RECONQUEST` dans la map J11. |
| Aftercare manquant | Prose de retombée W4 et fichier final ; J17/J21 doivent rappeler la dette sans rejouer le sexe. |
| Canal | Image de scène joueur, fil privé Marie J12, puis actions de foyer/couple. |
| Fonction | Faire coexister désir, vie quotidienne et problème non résolu. |
| Conséquence | `aftercare_marie_j11` payé ; aucune permission extérieure ; état du couple encore à décider. |
| Absence volontaire/problématique | Pas de longue conversation nocturne : volontaire. Pas de retombée écrite/fichier : problématique. |

### 5.2 Mathilde

| Champ | Audit |
|---|---|
| Aftercare écrit | Retour après départ, trois réceptions ; J12 traite l’échec avant convergence. |
| Aftercare prévu | `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_AFTERCARE_01`, comportements J12, départ différencié J16/J17. |
| Placeholder Galerie | Oui, enfant 3/3 de `MATHILDE_J11_SECRET_INTIMACY` dans la map J11. |
| Aftercare manquant | Prose W4 de séparation et fichier final ; J17 runtime aplatit secret suspendu, loyauté et confiance rompue. |
| Canal | Image de scène, fil privé Mathilde, conséquence foyer, logistique de départ. |
| Fonction | Rendre son contrôle matériel et émotionnel après le passage ; empêcher répétition/droit. |
| Conséquence | `PAID` maintient une clarification possible ; `FAILED` ferme progression, retire Mathilde de J12 et pousse vers distance. |
| Absence volontaire/problématique | Absence de définition amoureuse : volontaire. Perte des nuances au départ : problématique. |

### 5.3 Sandra

| Champ | Audit |
|---|---|
| Aftercare écrit | Canon J18 immédiat puis module prioritaire J19 avant Pauline/Raphaëlle. |
| Aftercare prévu | `S1_A5_J18_SCN_SANDRA_FINAL_STATE_01_LATE_INTIMACY_AFTERCARE`, seule réutilisation adulte admise J19. |
| Placeholder Galerie | Aucun dans les maps J18/J19. |
| Aftercare manquant | Toute la branche runtime, l’état `LATE_INTIMACY`, le module prioritaire J19, la tuile et le fichier final. |
| Canal | Image de scène puis fil privé Sandra J18/J19 ; aucune photographie sexuelle. |
| Fonction | Réintroduire Jeff, séparer non-regret et permission, rendre le retrait ou le silence possibles. |
| Conséquence | Aucune prochaine fois, récit de Sandra non cogéré, dette éventuelle envers Marie, priorité sur les autres payoffs J19. |
| Absence volontaire/problématique | Aucun flashback sexuel J19 : volontaire. Absence du module entier : problématique. |

## 6. Fermeture des arcs à J21

| Arc | Fait qui doit entrer dans la finale | Fermeture minimale | Interdit |
|---|---|---|---|
| Marie/couple | état J17, faits connus, promesses, divulgation et posture du jour | statut + contrat ou séparation + organisation | remplacer Marie par la personne de la trace |
| Mathilde | départ réel, aftercare payé/échoué, état de contact | vie autonome et accès domestique fermé ; conséquence conservée | disponibilité future implicite |
| Sandra | état de la photo, intimité/arrêt, aftercare et Jeff | contrôle de trace et limite/avenir sans droit | restaurer une photo ou rejouer `#079` |
| Pauline | état public/privé et Bastien | surface/compartiment clairement borné | photo adulte de compensation |
| Raphaëlle | accès/processus, image et Maud | personne/processus/frontière | transformer accès en photo |
| Nico | amitié, alibi, copie autorisée ou supprimée | position sans droit sur une femme | transformer fait/absence en image |

## 7. Contradictions documentaires à conserver visibles

| Contradiction | Lecture N7 |
|---|---|
| Le signoff J01–J21 annonce le corpus complet ; le contrat `14` exige J17/J21 ciblés. | Le corpus historique reste signé ; la structure/finale plus récente exige deux raccords, pas une réouverture globale. |
| `NAR_PROD_06` déclare J21 `READY`. | Son verdict est valide pour le budget visuel `NO_NEW_ASSET`; il ne prouve pas la présence de la conversation finale R8C. |
| Le script J21 contient des branches du soir ; le runtime finit après la réponse du contrôleur de trace. | La matière existe en canon, son ordre et son service runtime ne satisfont pas le contrat final. |
| Le script J17 prévoit six états ; le runtime en produit quatre. | Les deux états manquants et les obligations de suivi doivent être représentés ou explicitement repliés par décision canonique. |
| Les plans anciens traitent J17/J21 comme jours fixes. | Les jours ne sont que localisateurs du runtime ; l’ordre relatif de séquence est le contrat durable. |
| J21 possède zéro nouveau fichier alors que trois beats sont requis. | Les trois beats sont trois réutilisations fonctionnelles, pas trois productions. |
| Sandra possède un aftercare canonique ; J19 runtime foreground Pauline/Raphaëlle seulement. | Gap runtime réel, sans annulation du canon adulte. |

## 8. Gates d’acceptation continuité/aftercare

- J17 est présenté comme clarification provisoire, jamais finale.
- Le départ de Mathilde précède la clarification du couple et reflète l’aftercare.
- Une sortie J17 produit une règle actuelle, une limite et une conséquence concrète.
- Un état provisoire possède une revue bornée ; une séparation possède une logistique.
- J21 place conséquences/trace avant la conversation Marie/Player.
- La conversation finale est autonome et décide le couple ; la posture de trace ne
  la remplace pas.
- Les trois beats J21 réutilisent des contenus réellement vécus et admissibles.
- Aucun nouveau fichier, trace, photographie ou audience J21 n’est créé.
- Une absence reste une absence ; un type non photographique ne devient pas image.
- Les aftercares Marie, Mathilde et Sandra restent attribuables, conditionnels et
  porteurs de conséquence.
- Aucun sixième travail narratif n’est créé : les gaps runtime sont des dépendances
  futures des cinq paquets N7, pas de nouveaux paquets.
