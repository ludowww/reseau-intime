# Réseau Intime — 12C Plans détaillés des scènes J13–J16

## Statut

**Catégorie : Canon**

**Périmètre : acte IV — convergence, découvertes et conséquences**

Ce document complète les plans J01–J12.

Il définit les journées J13 à J16, lorsque les versions privées commencent à produire :

- dette ;
- découverte ;
- contradiction ;
- retrait ;
- obligation ;
- risque de réseau.

Tout dialogue jouable reste en messagerie texte.

Aucune scène audio, aucun appel joué et aucun message vocal ne sont autorisés.

Les images restent des slots fonctionnels, fournis plus tard par Ludovic via ComfyUI.

---

# 1. État d’entrée J13

À la fin de J12 :

- Marie a été visible dans son monde ;
- le réseau s’est retrouvé dans un événement crédible ;
- plusieurs personnages possèdent des connaissances partielles ;
- une route extérieure peut être dominante ;
- une image ou un comportement peut être recontextualisé ;
- au moins une conséquence est due ;
- aucune personne ne sait automatiquement tout ;
- aucun audio n’a porté une décision.

## Question d’acte

> Que deviennent les lignes privées lorsqu’elles laissent des traces que le réseau peut interpréter ?

---

# 2. Budget J13–J16

```text
J13 : conséquence la plus urgente
J14 : une trace change de destinataire ou de contexte
J15 : les horaires et promesses deviennent incompatibles
J16 : journée de paiement avant résolution
```

Règles :

- aucune nouvelle route dominante ;
- aucune escalade adulte avant l’après-coup ;
- une seule conséquence principale par jour ;
- Marie reste directement présente ou activement affectée ;
- une violation d’image ou de consentement passe avant toute opportunité ;
- les personnages absents agissent hors champ et reviennent par messages.

---

# 3. J13 — Dimanche — Le lendemain de l’événement

## Identité

```text
day_id: J13
day_type: CONSEQUENCE
act: IV
main_function: highest_priority_aftermath
principal_relationship: variable
runtime_status: NOT_IMPLEMENTED
```

## Question dramatique

> Quelle relation réclame en premier que le joueur assume ce qui a été visible la veille ?

## Sélection du pivot

Priorité :

1. sécurité ou consentement ;
2. image compromise ;
3. après-coup adulte ;
4. promesse ou présence ;
5. ligne privée devenue visible ;
6. respiration si rien n’est dû.

Candidates :

- S24 Pauline — deux versions ;
- S25 Raphaëlle — masque et posture ;
- S26 Nico — image, alibi ou demande ;
- Sandra — retrait ou clarification ;
- Mathilde — conséquence domestique ;
- Marie — retour de couple.

## Variante Pauline — S24 Les deux versions

### Fonction

Une image publique et une version privée ne signifient plus la même chose.

### Communication

`TRACE_DELIVERY` et messages texte.

### Nœud

1. reconnaître la différence sans demander davantage ;
2. entrer consciemment dans la double adresse ;
3. refuser le compartiment.

### Conséquences

- compartiment ouvert ;
- surface restaurée ;
- preuve réciproque potentielle ;
- Bastien reste réel ;
- Marie peut être affectée sans tout savoir.

## Variante Raphaëlle — S25 Le masque et la posture

### Fonction

Player reçoit une version choisie ou comprend qu’une préparation n’est pas une permission.

### Communication

- messages texte ;
- image éventuelle ;
- aucun rôle joué par audio ;
- rencontre hors téléphone possible, résultat textuel ensuite.

### Nœud

1. s’intéresser au processus ;
2. reconnaître l’effet sans dépasser le cadre ;
3. traiter la version comme un produit fini et perdre de la confiance.

## Variante Nico — S26 L’image ou l’alibi

### Fonction

Nico demande quelque chose de précis ou Player lui propose une complicité.

### Nœud

1. dire la vérité limitée ;
2. demander un alibi clair ;
3. refuser la circulation d’image ou la couverture.

### Règle

Nico peut refuser.

Il ne reçoit aucun droit sur Marie, Mathilde ou une image privée par l’intermédiaire de Player.

## Variante Sandra

### Fonction

Payer une image destinée, un comportement public ou une intimité J11.

### Axes possibles

- qui a vu ;
- ce qui a été sauvegardé ;
- besoin de silence ;
- image retirée ;
- confiance renforcée par le respect.

## Variante Mathilde

### Fonction

Le foyer redevient réel après une soirée sociale.

Elle peut :

- plaisanter ;
- poser une limite ;
- éviter Player ;
- demander ce qui a été compris ;
- agir normalement devant Marie.

## Retour Marie

Même si Marie n’est pas le pivot, un écho ou une conséquence du couple doit exister.

## Slots visuels

```text
minimum: 3
asset_design: deferred_to_user_comfyui
```

Fonctions :

1. trace publique ou privée recontextualisée ;
2. conséquence de la relation principale ;
3. vie ordinaire / couple / autonomie.

## Sortie J13

- une audience, une limite ou une dette devient précise ;
- une autre conséquence peut être mise en attente ;
- aucune nouvelle opportunité forte n’écrase l’après-coup.

---

# 4. J14 — Lundi — La photo au mauvais écran

## Identité

```text
day_id: J14
day_type: DISCOVERY
act: IV
main_sequence: S27
principal_function: knowledge_state_change
runtime_status: NOT_IMPLEMENTED
```

## Question dramatique

> Que se passe-t-il lorsqu’une trace réelle est vue par une personne qui n’en possède pas le contexte ?

## Règle de source

La trace doit déjà exister.

Elle peut être :

- image Sandra ;
- version Pauline ;
- image Mathilde ;
- image Raphaëlle ;
- image Marie ;
- message ou notification ;
- capture sociale ;
- demande Nico.

Aucune preuve n’est créée uniquement pour cette scène.

## Modes de découverte possibles

- notification sur écran visible ;
- mauvaise conversation ouverte ;
- image affichée pendant une sélection ;
- transfert au mauvais contact ;
- galerie ouverte ;
- capture recontextualisée ;
- message lu par une personne présente.

Aucun appel entendu ou audio intercepté.

## Témoins possibles

- Marie ;
- Mathilde ;
- Pauline ;
- Nico ;
- Jeff ;
- Bastien ;
- Raphaëlle dans un contexte professionnel ;
- personnage secondaire crédible.

Le témoin est choisi selon :

- présence réelle ;
- accès à l’écran ;
- importance de la trace ;
- conséquence due.

## Nœud de réaction Player

1. expliquer la vérité limitée ;
2. minimiser ou mentir ;
3. protéger la personne représentée et différer l’explication.

Le troisième choix ne doit pas devenir automatiquement noble s’il maintient un mensonge important.

## Connaissance

La scène doit définir :

```text
ce que le témoin a vu
ce qu’il comprend correctement
ce qu’il interprète mal
ce qu’il sait que Player sait
```

## Sandra

Une image Sandra vue hors audience constitue une conséquence forte.

Player doit :

- la prévenir si nécessaire ;
- ne pas prétendre contrôler sa réaction ;
- distinguer accident, sauvegarde et transfert ;
- accepter une demande de suppression ou de retrait.

## Pauline

Une version privée peut faire apparaître le compartiment sans prouver toute la relation.

## Mathilde

Une image domestique ne prouve ni intention ni acte sexuel.

## Raphaëlle

Une image de rôle ne prouve pas permission ou relation.

## Slots visuels

```text
minimum: 3
asset_design: deferred_to_user_comfyui
```

Fonctions :

1. trace déjà existante ;
2. témoin / découverte ;
3. conséquence ou retrait.

## Sortie J14

- un état de connaissance change ;
- une obligation de clarification, suppression ou protection existe ;
- une relation peut refroidir ;
- les horaires de J15 deviennent plus difficiles à maintenir.

---

# 5. J15 — Mardi — Les horaires ne tiennent plus

## Identité

```text
day_id: J15
day_type: RICH_CONFLICT
act: IV
main_sequence: S28
principal_function: incompatible_commitments
runtime_status: NOT_IMPLEMENTED
```

## Question dramatique

> Quelle vérité apparaît lorsque Player ne peut plus tenir simultanément les versions de sa journée ?

## Conditions d’entrée

Au moins deux éléments :

- promesse Marie ;
- rendez-vous Sandra ;
- obligation domestique Mathilde ;
- engagement Pauline ;
- tâche Raphaëlle ;
- rencontre Nico ;
- demande de suppression ;
- clarification J14.

## Différence avec J08

J08 était la première superposition encore amendable.

J15 montre :

- accumulation ;
- mensonge éventuel ;
- dette ;
- priorité devenue visible ;
- conséquences plus fortes.

## Structure textuelle

La journée peut utiliser plusieurs threads, mais un seul choix principal décide :

1. quelle obligation est payée ;
2. quelle personne est honnêtement prévenue ;
3. quelle version est maintenue ou abandonnée.

Aucune scène audio pour résoudre les conflits.

## Choix

### Choix A — Dire la vérité à la personne la plus affectée

- coût immédiat ;
- meilleure lisibilité ;
- pas de réparation automatique.

### Choix B — Maintenir un engagement et amender les autres

- possible si les modifications sont précises ;
- certaines personnes peuvent refuser.

### Choix C — Construire ou maintenir un mensonge

- permet parfois de conserver une occasion ;
- crée dette, preuve et pression de collision.

## Mutations

- Marie agit seule ;
- Sandra annule ;
- Mathilde demande à Marie ou un tiers ;
- Pauline restaure sa surface ;
- Raphaëlle termine avec Maud ;
- Nico cesse de couvrir ;
- une image est retirée ;
- une tâche professionnelle reste due.

## Retour couple

Une conséquence Marie est obligatoire si :

- le foyer est utilisé ;
- une promesse est manquée ;
- une soirée est cachée ;
- une autre personne reçoit le temps prévu pour le couple.

## Slots visuels

```text
minimum: 3
asset_design: deferred_to_user_comfyui
```

Fonctions :

1. engagement choisi ;
2. personne laissée ou action autonome ;
3. preuve, horaire ou retour au foyer.

## Sortie J15

- dette majeure ou réparation partielle ;
- vérité du couple devenue difficile à repousser ;
- une route peut fermer ;
- J16 doit payer avant toute résolution finale.

---

# 6. J16 — Mercredi — Ce qui doit revenir avant la vérité

## Identité

```text
day_id: J16
day_type: CONSEQUENCE_ONLY
act: IV_END
principal_function: pay_due_states
runtime_status: NOT_IMPLEMENTED
```

## Question dramatique

> Que doit-on traiter avant que les personnages puissent décider ce qu’ils veulent conserver ?

## Interdits

- nouvelle route ;
- nouvelle personne séduite ;
- scène sexuelle de substitution ;
- grande image récompense sans conséquence ;
- révélation aléatoire ;
- appel de clarification.

## Priorités

1. sécurité ;
2. consentement ;
3. suppression ou audience ;
4. après-coup adulte ;
5. travail ;
6. foyer ;
7. promesse ;
8. clarification ;
9. préparation de la fin du séjour Mathilde.

## Fenêtres possibles

### Sandra

- confirmer suppression ;
- demander qui a vu ;
- retirer un accès ;
- accepter un silence ;
- reconnaître un respect.

### Mathilde

- remettre une distance ;
- préparer son départ ;
- parler à Marie ;
- rendre un objet ;
- ne pas être disponible comme consolation.

### Pauline

- fermer un compartiment ;
- protéger Bastien ou Marie ;
- demander une preuve ;
- maintenir un secret avec dette.

### Raphaëlle

- retour professionnel ;
- terminer la tâche ;
- clarifier le cadre ;
- remettre le rôle à plus tard.

### Nico

- confirmer ou retirer un alibi ;
- nommer son propre intérêt ;
- rappeler une limite ;
- prendre ses distances.

### Marie

- demander un acte ;
- annoncer une discussion ;
- ne plus attendre ;
- préparer une séparation ou une négociation.

## Communication

Messagerie texte uniquement.

Les rencontres ou actions physiques sont :

- organisées par messages ;
- accomplies hors téléphone ;
- confirmées ensuite par texte.

## Slots visuels

```text
minimum: 3
asset_design: deferred_to_user_comfyui
```

Fonctions :

1. après-coup principal ;
2. foyer / Marie ;
3. route dominante dans un état ordinaire, retiré ou autonome.

## Sortie J16

- les urgences sont payées ou explicitement échouées ;
- la fin du séjour Mathilde est prête ;
- la conversation du couple est inévitable ;
- les routes entrent en résolution, pas en nouvelle ouverture.

---

# 7. Matrice J13–J16

| Personnage | J13 | J14 | J15 | J16 |
|---|---|---|---|---|
| Marie | retour/conséquence | témoin possible | engagement majeur | préparation résolution |
| Sandra | aftermath possible | image hors audience possible | rendez-vous/limite | suppression/retrait |
| Mathilde | foyer/limite | témoin ou image | obligation domestique | préparation départ |
| Pauline | S24 possible | version découverte | compartiment sous pression | fermeture/protection |
| Raphaëlle | S25 possible | découverte pro possible | obligation travail | retour professionnel |
| Nico | S26 possible | témoin possible | alibi/rencontre | position d’amitié |

---

# 8. États minimaux

## Connaissance

- qui a vu quoi ;
- qui sait que l’autre sait ;
- ce qui est mal interprété ;
- ce qui est confirmé.

## Obligations

- suppression ;
- retour ;
- rendez-vous ;
- vérité ;
- tâche ;
- départ ;
- alibi.

## Routes

- active ;
- dominante ;
- refroidie ;
- fermée ;
- en conséquence ;
- sans nouvelle progression.

---

# 9. Anti-patterns

Rejeter :

- plusieurs découvertes majeures le même jour ;
- tout le réseau omniscient ;
- image qui prouve une intention absente ;
- partenaire découvrant par magie ;
- J15 comme simple répétition de J08 ;
- J16 ouvrant une nouvelle séduction ;
- audio ou appel pour exposer la vérité ;
- vocal accidentel comme preuve ;
- scène hors téléphone contenant le choix essentiel sans retour textuel ;
- suppression qui efface le souvenir ;
- confession qui répare automatiquement.

---

# 10. Critères d’acceptation

- [ ] J13 choisit la conséquence la plus urgente ;
- [ ] J14 utilise une trace existante ;
- [ ] le témoin ne comprend pas plus qu’il n’a vu ;
- [ ] J15 rend les priorités visibles ;
- [ ] J16 n’ouvre aucune nouvelle route ;
- [ ] Marie reste centrale ;
- [ ] les partenaires restent réels ;
- [ ] les violations d’audience ont un coût ;
- [ ] aucune scène audio ;
- [ ] les choix restent textuels ;
- [ ] les slots visuels restent à produire ;
- [ ] J17 peut résoudre le foyer sans dette urgente oubliée.

---

# 11. Résumé

J13 paie l’événement social.

J14 transforme une trace en connaissance partielle.

J15 révèle les priorités par les horaires et les engagements incompatibles.

J16 interdit toute fuite en avant et prépare les résolutions.

L’acte IV ne sert pas à multiplier les twists.

Il sert à faire comprendre que les relations privées ont désormais une existence dans le même monde.