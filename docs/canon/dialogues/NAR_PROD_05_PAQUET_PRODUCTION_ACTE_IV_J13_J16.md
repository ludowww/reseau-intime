# Réseau Intime — NAR-PROD-05 — Paquet de production Acte IV / J13–J16

## 1. Statut, périmètre et autorités

### 1.1 Statut final

```text
document_id: NAR-PROD-05
document_name: NAR_PROD_05_PAQUET_PRODUCTION_ACTE_IV_J13_J16.md
baseline_stable: 547d7af3207a7dfb5c9c68f8f01c984de3e21c6f
scope: Acte IV — J13 à J16
status: READY
VALIDATION PRODUIT: PASS
decisions_remaining_for_ludovic: AUCUNE
```

Ce document :

- consolide les fonctions narratives et visuelles de J13 à J16 ;
- met NAR-PROD-05 en conformité avec NAR-CANON-01 ;
- applique dans ce même lot les corrections documentaires de T17 et T18 au Trace Registry ;
- fixe les beats, contenus, fichiers, réutilisations, états, fallbacks et handoffs ;
- ne réécrit aucun dialogue signé ;
- ne crée aucun dialogue ;
- ne crée aucun prompt ComfyUI définitif ;
- ne modifie aucun runtime, JSON, test, UI ou asset.

### 1.2 Autorités

En cas d’écart, l’ordre suivant s’applique :

1. décisions explicites de Ludovic verrouillées pour la finalisation de NAR-PROD-05 ;
2. `NAR_PROD_07_ADULT_PAYOFF_AUDIT_SPECIFICATION.md` et `NAR_ADULT_03_PAYOFFS_PAULINE_RAPHAELLE.md` pour la photographie adulte Raphaëlle ;
3. scripts narratifs signés J13–J16 ;
4. NAR-CANON-01 et les registres canoniques corrigés à la baseline stable ;
5. Trace Registry avec T17, T18 et T18B ;
6. contrat d’état narratif et matrice d’atteignabilité ;
7. bible narrative et canons complets des personnages ;
8. NAR-PROD-02, NAR-PROD-03 et NAR-PROD-04 pour les contenus antérieurs.

### 1.3 Sources autoritatives relues

Sources supplémentaires désormais autoritatives :

- `docs/canon/dialogues/NAR_CANON_01_REPARATION_PROMESSES_ATTEIGNABILITE_J14_J16.md` ;
- `docs/canon/dialogues/J01_J21_PROMISE_REGISTRY.md` ;
- `docs/canon/dialogues/J01_J21_REACHABILITY_MATRIX.md` ;
- `docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md`.

Autres sources de production :

- `docs/canon/dialogues/NAR_PROD_02_PAQUET_PRODUCTION_ACTE_I_J01_J04.md` ;
- `docs/canon/dialogues/NAR_PROD_03_PAQUET_PRODUCTION_ACTE_II_J05_J08.md` ;
- `docs/canon/dialogues/NAR_PROD_04_PAQUET_PRODUCTION_ACTE_III_J09_J12.md` ;
- `docs/canon/bible/00_NORTH_STAR.md` ;
- `docs/canon/bible/04_TRAME_PRINCIPALE_ET_ACTES_SAISON_1.md` ;
- `docs/canon/bible/05_ROUTES_MACRO_SAISON_1.md` ;
- `docs/canon/bible/06_EVOLUTION_EROTIQUE_DES_ROUTES.md` ;
- `docs/canon/bible/07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md` ;
- `docs/canon/bible/08_REGLES_DES_SCENES_MODULAIRES.md` ;
- `docs/canon/bible/09_PROGRESSION_VISUELLE_ET_PHOTOGRAPHIQUE.md` ;
- `docs/canon/bible/10_CARTE_CONSEQUENCES_DETTES_SECRETS_OBLIGATIONS.md` ;
- `docs/canon/bible/11_DISTRIBUTION_SEQUENCES_SCENES_IMAGES_CONSEQUENCES_JOURNEES.md` ;
- `docs/canon/bible/12C_PLANS_SCENES_J13_J16.md` ;
- `docs/canon/dialogues/J13_SCRIPT_NARRATIF_COMPLET.md` ;
- `docs/canon/dialogues/J14_SCRIPT_NARRATIF_COMPLET.md` ;
- `docs/canon/dialogues/J15_SCRIPT_NARRATIF_COMPLET.md` ;
- `docs/canon/dialogues/J16_SCRIPT_NARRATIF_COMPLET.md` ;
- `docs/canon/dialogues/J01_J21_TRACE_REGISTRY.md` ;
- `docs/canon/dialogues/J01_J21_KNOWLEDGE_REGISTRY.md` ;
- `docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md` ;
- canons complets de Marie, Sandra, Mathilde, Pauline, Raphaëlle, Nico et Player.

### 1.4 Statuts de source et de production

| Statut | Usage |
|---|---|
| `SIGNED_SOURCE` | fonction, choix ou conséquence explicitement porté par un script signé |
| `CONSOLIDATED_CANON` | consolidation documentaire compatible avec toutes les autorités |
| `REFERENCE_ONLY` | formulation historique conservée seulement pour traçabilité |
| `NO_NEW_ASSET` | fonction servie sans nouveau fichier : texte, fait, retrait, absence ou réutilisation |

---

## 2. Décisions héritées et invariants

### 2.1 État acquis

| Paquet | Périmètre | État |
|---|---|---|
| NAR-PROD-02 | J01–J04 | `READY` |
| NAR-PROD-03 | J05–J08 | `READY` |
| NAR-PROD-04 | J09–J12 | `READY` |

J01–J12 restent l’histoire antérieure. Aucun `asset_id`, créateur, propriétaire ou état historique n’est renommé par NAR-PROD-05.

### 2.2 Invariants

- Player reste non identifiable visuellement.
- Une `PHOTO_DIÉGÉTIQUE` existe dans l’univers et possède créateur, propriétaire, audience et règles de circulation.
- Un `SOUVENIR_IMAGE_DE_SCÈNE` sert le joueur et n’existe pas comme fichier détenu par un personnage.
- Un `FACT_RECORD` reste un fait structuré et ne devient jamais une image.
- Un souvenir de scène utilise `saving_rule: NONE`, `transfer_rule: FORBIDDEN` et `can_share: false`.
- Une image de scène ne devient ni trace J14, ni preuve, ni payoff J21.
- Une suppression ou un retrait ne restaure jamais un fichier.
- Une connaissance acquise demeure même si la trace devient `REMOVED` ou `INACCESSIBLE`.
- Une image ne donne aucune permission corporelle future.
- Une bonne gestion ne crée ni dette compensatoire ni punition.
- `gallery_eligibility: conditional`.
- `gallery_slot_behavior: deferred`.

### 2.3 Règle de comptage

Le paquet distingue :

1. **beat servi** : fonction narrative effectivement payée dans une partie ;
2. **contenu principal** : unité documentaire possédant son propre `asset_id` ;
3. **réutilisation** : contenu antérieur conservant exactement son `asset_id` ;
4. **fichier source nouveau** : fichier image à produire ;
5. **fichier enfant** : nouveau fichier rattaché à un parent antérieur ;
6. **variante conditionnelle** : second fichier du même contenu pour un état visuel incompatible ;
7. **absence ou retrait** : événement servi par `NO_NEW_ASSET`.

Un contenu réutilisé plusieurs fois n’est compté qu’une fois dans le pool des douze réutilisations.

---

## 3. Contrat narratif et budget de l’Acte IV

### 3.1 Fonction d’acte

```text
J13 : une conséquence réclame une réponse
J14 : une trace réelle change une connaissance, ou l’absence d’incident maintient un chemin propre
J15 : deux obligations réelles peuvent entrer en collision ; sinon la mutation paie l’unique dû
J16 : une conséquence réelle est payée, échoue ou ne subsiste plus, puis Mathilde, Marie et J17 sont préparés
```

### 3.2 Contrat commun

- Une seule conséquence ou priorité devient foreground.
- Les urgences de sécurité, de consentement et d’audience passent avant l’attirance.
- Marie reste directement présente ou structurellement affectée.
- Aucun personnage non sélectionné ne reçoit une image de compensation.
- Aucun visuel séduisant ne récompense une limite poussée ou une dette impayée.
- Aucune scène sexuelle ni route nouvelle n’est créée ; seule la photographie adulte Raphaëlle validée peut être servie sous C13-02.
- Les personnages continuent leur vie sans attente artificielle.
- Une absence, un retrait, un silence ou un accès révoqué peut payer un beat avec zéro nouveau fichier.

### 3.3 Budget verrouillé

```text
12 beats servis par partie
10 nouveaux contenus principaux
12 réutilisations antérieures distinctes
12 nouveaux fichiers sources
2 fichiers enfants
1 variante conditionnelle
```

Répartition des fichiers :

```text
J13 : 3
J14 : 2
J15 : 4
J16 : 3
total : 12
```

Répartition par nature :

```text
fichiers de base autonomes : 9
fichiers enfants : 2
fichier de variante : 1
total : 12
```

---

## 4. Tableau exécutif J13–J16

| Jour | Type | Beats servis | Contenus principaux | Nouveaux fichiers | Enfant | Variante | Verdict |
|---|---|---:|---:|---:|---:|---:|---|
| J13 | `CONSEQUENCE` | 3 | 2 photographies principales mutuellement exclusives | 3 | 2 | 0 | `READY` |
| J14 | `DISCOVERY` ou fallback | 3 | 2 souvenirs mutuellement exclusifs | 2 | 0 | 0 | `READY` |
| J15 | `FULL_COLLISION` ou `S28_MUTATION_NO_COLLISION` | 3 | 4 souvenirs conditionnels | 4 | 0 | 0 | `READY` |
| J16 | `CONSEQUENCE_ONLY` ou fermeture propre | 3 | 2 souvenirs | 3 | 0 | 1 | `READY` |
| **Total** |  | **12** | **10** | **12** | **2** | **1** | **READY** |

### 4.1 Douze fonctions toujours servies

| Jour | Beat 1 | Beat 2 | Beat 3 |
|---|---|---|---|
| J13 | conséquence foreground | audience, limite ou dette précisée | écho Marie obligatoire |
| J14 | trace vue ou absence d’incident | témoin et connaissance, ou responsabilité réellement ouverte | conséquence d’audience ou préparation propre de J15 |
| J15 | obligation réelle payée, amendée, refusée ou fermée | autres personnes continuant leur vie | conséquence Marie, foyer, heure réelle ou passage vers J16 |
| J16 | état urgent payé, échoué ou déclaré absent | préparation concrète du départ Mathilde | retour Marie et handoff J17 |

Les contenus mutuellement exclusifs existent dans le paquet de production ; une partie n’en foreground qu’un selon son état.

---

## 5. Continuité d’entrée depuis J01–J12

### 5.1 Traces et contenus utiles

Les contenus antérieurs ne sont disponibles que si leur état l’autorise :

- T01 Sandra ;
- T04 Pauline/Bastien public ;
- T07 Marie robe noire ;
- T10 Mathilde tenue choisie ;
- T11 Sandra image choisie ;
- T12 Raphaëlle résultat choisi ;
- T14 La Verrière public ;
- T15 L’Annexe public ;
- C12-03 Pauline/Bastien à L’Annexe.

### 5.2 États à lire avant J13

```text
consent_or_safety_due
audience_or_image_due
adult_aftercare_due
active_promises
active_obligations
active_contradictions
trace_states
knowledge_entries
household_state
couple_state
foreground_history
```

Une route éligible, une attirance, une image reçue, un silence ou une disponibilité ne constitue jamais une promesse.

### 5.3 Priorité

```text
sécurité ou consentement
→ audience compromise ou image incertaine
→ aftercare
→ promesse ou présence réellement impayée
→ ligne privée devenue visible
→ respiration
```

---

## 6. Paquet complet J13 — Ce qui réclame une réponse

### 6.1 Fonction

J13 paie la conséquence la plus urgente née de J11–J12.

Contraintes :

- une seule conséquence foreground ;
- trois beats servis ;
- zéro nouvelle route ;
- aucune image de compensation ;
- aucun fichier pour une branche non sélectionnée dans la partie ;
- un écho Marie même lorsqu’elle n’est pas le pivot.

### 6.2 Composition

| Beat | Fonction | Support |
|---|---|---|
| J13-B1 | conséquence principale | C13-01 si Pauline, C13-02 si Raphaëlle, sinon trace, message, retrait ou silence existant |
| J13-B2 | audience, limite ou dette précise | état de trace ou message signé |
| J13-B3 | écho Marie / foyer | réutilisation compatible ou absence signifiante |

### 6.3 C13-01 — Version privée Pauline

| Champ | Valeur |
|---|---|
| Code | C13-01 |
| `asset_id` | `S1_A4_J13_DPH_PAULINE_PRIVATE_VERSION_01` |
| `trace_id` | `j13_pauline_private_version_01` |
| Type | `PHOTO_DIÉGÉTIQUE` |
| Source | `CONSOLIDATED_CANON` |
| `source_day` | J13 |
| Parent | C12-03 — `S1_A3_J12_DPH_PAULINE_BASTIEN_ANNEXE_01` |
| Origine | L’Annexe J12 |
| Créatrice / propriétaire / sélection | Pauline |
| Sujets | Pauline principalement |
| Audience | Pauline, puis Pauline et Player si envoi |
| Sauvegarde | `IN_THREAD_ONLY` |
| Transfert | `FORBIDDEN` |
| Fonction | quatrième frame privée non publiée du même moment photographique |
| Fichier | 1 nouveau fichier enfant |
| Galerie | `conditional` / slot `deferred` |
| J14 | oui seulement si encore accessible |
| J21 | selon état, sans restauration |

Fichier enfant :

```text
S1_A3_J12_DPH_PAULINE_BASTIEN_ANNEXE_01_FRAME_04_PRIVATE
```

### 6.4 C13-02 — Masque et posture Raphaëlle

| Champ | Valeur |
|---|---|
| Code | C13-02 |
| `asset_ids` | `S1_A4_J13_DPH_RAPHAELLE_MASKED_POSTURE_01` ; `S1_A4_J13_DPH_RAPHAELLE_MASKED_ADULT_SELECTED_01` |
| `trace_id` | `j13_raphaelle_masked_version_01` ; T18B `j13_raphaelle_masked_adult_selected_01` conditionnel |
| Type | `PHOTO_DIÉGÉTIQUE` |
| Source | `SIGNED_SOURCE` |
| `source_day` | J13 |
| `source_scene` | S25 — Le masque change la posture |
| Créatrice | Maud |
| Propriétaire | Raphaëlle |
| Sélection | Raphaëlle |
| Sujets | Raphaëlle |
| Audience initiale | Raphaëlle, Maud |
| Audience après envoi | Raphaëlle, Maud, Player |
| Sauvegarde | `IN_THREAD_ONLY` |
| Transfert | `FORBIDDEN` |
| Fonction | version choisie où le masque transforme visiblement la posture, sans permission corporelle future |
| Fichiers | 1 base autonome + 1 enfant conditionnel adulte |
| Galerie | `conditional` / slot `deferred` |
| J14 | oui seulement si encore accessible |
| J21 | selon état canonique, jamais restaurée |

Maud a terminé le tri des tests ; une prise montre que le masque change toute la posture ; Raphaëlle choisit cette prise et peut l’envoyer à Player. Le rôle reste dans l’image et non dans la conversation.

Cette photographie :

- est une prise distincte ;
- peut venir de la même session de tests que le résultat antérieur ;
- ne dérive d’aucun fichier antérieur ;
- n’est ni un crop, ni un fichier enfant ;
- n’est jamais créée dans la branche où Raphaëlle refuse l’envoi.

Le fichier adulte conditionnel :

```text
S1_A4_J13_DPH_RAPHAELLE_MASKED_ADULT_SELECTED_01
```

- reste un enfant de C13-02, pas un nouveau contenu principal ni une variante ;
- est créé par Maud, sélectionné et possédé par Raphaëlle ;
- ajoute Player à l’audience seulement si Raphaëlle l’envoie après R-A ou R-B ;
- peut montrer une nudité explicite partielle ou une exposition adulte équivalente ;
- ne montre aucun acte sexuel ni Player ;
- devient T18B et peut être retiré indépendamment de T18.

Si le cadre J12 a été pressé ou si Raphaëlle refuse l’image :

```text
current_state: NOT_CREATED
production: NO_NEW_ASSET
```

### 6.5 Exclusivité locale J13

C13-01 et C13-02 sont mutuellement exclusifs dans une partie :

```text
Pauline foreground → C13-01 possible ; C13-02 NOT_CREATED
Raphaëlle foreground → C13-02 possible ; C13-01 NOT_CREATED
autre foreground → C13-01 et C13-02 NOT_CREATED
```

Une seule conséquence J13 reste foreground.

### 6.6 Branches J13

| Pivot | Support | Nouveau fichier dans la branche | Branche non choisie | Écho Marie |
|---|---|---:|---|---|
| Pauline | C13-01 / T17 | 1 enfant | `NOT_CREATED` / `NO_NEW_ASSET` | T14, C12-03 public ou foyer |
| Raphaëlle | C13-02 / T18, avec T18B conditionnel | 1 base autonome + 1 enfant adulte si toutes les conditions sont réunies | `NOT_CREATED` / `NO_NEW_ASSET` | T14 ou foyer |
| Nico | T19 message d’heure ou d’alibi | 0 | `NO_NEW_ASSET` | T14, T15 ou retour couple |
| Sandra | T11, T01, retrait, silence ou inaccessibilité | 0 | `NO_NEW_ASSET` | T14 ou foyer |
| Mathilde | T10, T13 textuelle, règle du foyer ou distance | 0 | `NO_NEW_ASSET` | foyer et Marie |
| Marie | T07, T14 ou vérité de couple | 0 | `NO_NEW_ASSET` | Marie est le pivot |
| Respiration | contenus publics réellement accessibles | 0 | `NO_NEW_ASSET` | obligatoire |

### 6.7 Sortie J13

J13 produit une audience, une limite ou une dette précise, un seul foreground et un état Marie ou foyer lisible. Toute trace J14 doit exister réellement et demeurer accessible.

```text
J13: READY
```

---

## 7. Paquet complet J14 — La photo au mauvais écran

### 7.1 Fonction

J14 modifie une connaissance à partir d’une seule trace antérieure accessible, ou constate proprement qu’aucun incident n’a lieu.

Interdits :

- créer une photographie pour provoquer la découverte ;
- produire un asset par combinaison trace×témoin ;
- lire un fil complet sans action supplémentaire ;
- reproduire le fichier privé dans le souvenir témoin ;
- identifier physiquement Player ;
- créer un mockup UI définitif.

### 7.2 Trois beats

| Beat | Discovery | Fallback |
|---|---|---|
| J14-B1 | une trace réelle est vue | aucun faux écran ; absence d’incident |
| J14-B2 | un témoin acquiert une connaissance bornée | une responsabilité J14 réellement signée peut rester conditionnelle |
| J14-B3 | réaction Player et information du contrôleur | préparation de J15 sans dette inventée |

### 7.3 C14-01 — Marie, découverte limitée

| Champ | Valeur |
|---|---|
| `asset_id` | `S1_A4_J14_SCN_MARIE_LIMITED_DISCOVERY_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Source | `SIGNED_SOURCE` |
| Sujet | Marie après le bref affichage, jamais le contenu privé reproduit |
| Audience | joueur uniquement |
| Sauvegarde / transfert | `NONE` / `FORBIDDEN` |
| Fonction | réaction, séparation physique ou distance après connaissance partielle |
| `can_share` | false |
| J14 comme trace / J21 | non / non |

### 7.4 C14-02 — Mathilde, découverte limitée

| Champ | Valeur |
|---|---|
| `asset_id` | `S1_A4_J14_SCN_MATHILDE_LIMITED_DISCOVERY_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Source | `SIGNED_SOURCE` |
| Sujet | Mathilde après le bref affichage, jamais l’image privée reproduite |
| Audience | joueur uniquement |
| Sauvegarde / transfert | `NONE` / `FORBIDDEN` |
| Fonction | retrait, déplacement ou autonomie après connaissance partielle |
| `can_share` | false |
| J14 comme trace / J21 | non / non |

C14-01 et C14-02 sont mutuellement exclusifs dans une partie. Ils ne sont pas les variantes d’un même fichier.

### 7.5 Fallback canonique

Si aucune trace privée ou ambiguë n’est éligible :

1. ne pas inventer d’incident ;
2. conserver uniquement les responsabilités réellement créées par J14 ;
3. ne pas créer de promesse générique ;
4. ne réactiver aucune promesse terminale ;
5. ne créer aucun fichier diégétique ;
6. utiliser des réutilisations compatibles ou `NO_NEW_ASSET` ;
7. préparer `S28_MUTATION_NO_COLLISION` si moins de deux promesses admissibles existent.

L’absence d’une seconde obligation ne bloque pas J14.

### 7.6 Sortie J14

T20 enregistre un seul événement de découverte s’il existe. Une vérité immédiatement donnée ne crée pas P14. P15 devient `PAID` si la personne représentée est informée en J14.

```text
J14: READY
```

---

## 8. Paquet complet J15 — Les horaires ne tiennent plus

### 8.1 Deux modes canoniques

```text
FULL_COLLISION
S28_MUTATION_NO_COLLISION
```

`FULL_COLLISION` exige exactement deux promesses admissibles, `ACTIVE`, antérieures à la collision, portant deux actions distinctes et des fenêtres objectivement incompatibles.

La mutation s’applique lorsque cette paire n’existe pas. Elle ne constitue ni un échec de spécification ni une punition.

### 8.2 Trois beats dans les deux modes

| Beat | `FULL_COLLISION` | `S28_MUTATION_NO_COLLISION` |
|---|---|---|
| J15-B1 | payer, amender, refuser ou échouer une priorité | payer, amender, refuser ou fermer l’unique obligation réelle |
| J15-B2 | personne non servie agissant sans Player | autres personnes continuant leur vie sans attente artificielle |
| J15-B3 | conséquence Marie, foyer, heure ou preuve | conséquence Marie, foyer, heure réelle ou passage vers J16 |

Supports autorisés en mutation :

- réutilisation ;
- message signé ;
- absence ;
- retrait ;
- état du foyer ;
- `NO_NEW_ASSET`.

Aucun fichier n’est créé spécialement pour la mutation.

### 8.3 Quatre contenus J15

| Code | `asset_id` | Sujet | Fonction | Condition |
|---|---|---|---|---|
| C15-01 | `S1_A4_J15_SCN_MARIE_AUTONOMOUS_PRIORITY_01` | Marie | cesse d’attendre, repart ou organise sans Player | Marie non servie |
| C15-02 | `S1_A4_J15_SCN_SANDRA_AUTONOMOUS_WINDOW_01` | Sandra | commence son poste, retire l’image ou ferme l’attente | Sandra non servie |
| C15-03 | `S1_A4_J15_SCN_MATHILDE_AUTONOMOUS_HOUSEHOLD_01` | Mathilde | parle à Marie, change de nuit ou organise son départ | Mathilde non servie |
| C15-04 | `S1_A4_J15_SCN_PAULINE_AUTONOMOUS_VERSION_01` | Pauline | décide avec Bastien, retire la version ou ferme le compartiment | Pauline non servie |

Règles communes :

```text
type: SOUVENIR_IMAGE_DE_SCÈNE
creator: non applicable
owner: non applicable
audience: joueur uniquement
saving_rule: NONE
transfer_rule: FORBIDDEN
can_share: false
eligible_for_j14: false
eligible_for_j21: false
```

### 8.4 Raphaëlle et Nico en J15

Raphaëlle utilise seulement :

- R04, état de travail J08, si réellement pertinent ;
- T18 dans son état canonique ;
- une trace ou un message existant ;
- `NO_NEW_ASSET`.

L’autonomie professionnelle est décrite par texte ou état. Aucun rendu professionnel prétendument promis n’est représenté.

Nico utilise T19, une heure réelle, un message signé, T15 si l’audience l’autorise, ou `NO_NEW_ASSET`. Aucune seconde obligation et aucun fichier Nico ne sont inventés.

### 8.5 Matrice finale des branches

| Branche | Promise A | Promise B | `FULL_COLLISION` | Mutation sinon | Production |
|---|---|---|---|---|---|
| Pauline | `marie_j14_pauline_player_account_j15` | `pauline_j14_post_breach_return_j15` | si deux fiches `ACTIVE` et incompatibles | oui | C15-01 ou C15-04 selon priorité |
| Sandra | `household_j14_sandra_rule_j15` | `sandra_j14_breach_account_j15` | si deux fiches `ACTIVE` et incompatibles | oui | C15-02 ou C15-03 selon priorité |
| Mathilde | `mathilde_j14_household_safety_rule_j15` | seconde obligation extérieure antérieure réellement signée | seulement si O2 existe et est `ACTIVE` | oui | C15-03 ou autre contenu local autorisé |
| Raphaëlle | `marie_j14_raphaelle_position_j15` | aucune seconde fiche signée | `MISSING_SIGNED_SOURCE` | chemin canonique par défaut | `NO_NEW_ASSET`, R04 ou trace existante |
| Nico | `marie_j14_nico_hour_account_j15` | aucune seconde fiche par défaut | seulement sur preuve signée contraire | chemin canonique par défaut | `NO_NEW_ASSET` |
| Composite | paire exacte réellement prouvée | seconde fiche de cette paire | seulement si paire attribuable | oui | contenu du personnage réellement concerné |

La présence de `MISSING_SIGNED_SOURCE` pour la collision complète Raphaëlle ne rend ni J15 ni NAR-PROD-05 bloqué : son chemin jouable est la mutation.

### 8.6 T21

Si un record est utile :

```text
trace_id: j15_obligation_collision_record_01
record_type: FACT_RECORD
collision_mode: FULL_COLLISION | NO_COLLISION
eligible_active_promise_ids: []
selected_promise_id: promise_id réel ou null
chosen_priority: valeur attribuable ou null
amended_promise_ids: []
failed_promise_ids: []
closed_promise_ids: []
promise_outcome: PAID | AMENDED | REFUSED | FAILED | CANCELLED | CLOSED | NONE
incompatible_windows_proven: true | false
second_signed_obligation_present: true | false
urgent_consequence_remaining: true | false
current_state: ACTIVE
visual_asset: none
```

Si aucun record n’est nécessaire :

```text
trace_id: j15_obligation_collision_record_01
current_state: NOT_CREATED
```

T21 ne devient jamais une image.

### 8.7 Sortie J15

J15 produit soit une collision prouvée, soit le paiement ou la fermeture honnête de l’unique obligation réelle. Il prépare J16 sans fabriquer de dette.

```text
J15: READY
```

---

## 9. Paquet complet J16 — Ce qui doit revenir avant la vérité

### 9.1 Fonction

J16 paie, retire ou constate explicitement l’échec de la conséquence la plus urgente. Lorsqu’aucune urgence ne subsiste, J16 utilise la fermeture propre et prépare Mathilde, Marie et J17.

### 9.2 Trois beats

| Beat | Fonction | Production |
|---|---|---|
| J16-B1 | conséquence payée, échouée ou absente | réutilisation, retrait, texte ou `NO_NEW_ASSET` |
| J16-B2 | préparation concrète du départ Mathilde | C16-01 |
| J16-B3 | retour Marie et handoff J17 | C16-02 |

### 9.3 C16-01 — Préparation du départ Mathilde

| Champ | Valeur |
|---|---|
| `asset_id` | `S1_A4_J16_SCN_MATHILDE_DEPARTURE_PREPARATION_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Source | `SIGNED_SOURCE` |
| Sujet | Mathilde principalement |
| Audience | joueur uniquement |
| Sauvegarde / transfert | `NONE` / `FORBIDDEN` |
| Fonction | tri, objets, clés, autonomie ou départ avancé |
| Fichiers | base ordinaire + variante protectrice |
| `can_share` | false |

Fichiers :

```text
S1_A4_J16_SCN_MATHILDE_DEPARTURE_PREPARATION_01_ORDINARY
S1_A4_J16_SCN_MATHILDE_DEPARTURE_PREPARATION_01_PROTECTIVE
```

La variante protectrice n’est éligible que si sécurité, distance ou départ avancé modifie réellement la présence de Player, l’intermédiaire, le lieu ou la séparation physique.

### 9.4 C16-02 — Marie et le handoff J17

| Champ | Valeur |
|---|---|
| `asset_id` | `S1_A4_J16_SCN_MARIE_J17_HANDOFF_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Source | `SIGNED_SOURCE` |
| Sujet | Marie et foyer transformé |
| Audience | joueur uniquement |
| Sauvegarde / transfert | `NONE` / `FORBIDDEN` |
| Fonction | retour Marie, espace provisoire et préparation de J17 |
| Fichiers | 1 |
| `can_share` | false |

Ce contenu ne joue pas la conversation J17.

### 9.5 P17 et T22

P17 `j16_priority_consequence_payment` est créée seulement si une conséquence réelle reste due.

P17 est absente si :

- l’obligation a été payée ;
- l’attente a été proprement fermée ;
- aucune urgence ne subsiste ;
- la bonne gestion n’a laissé aucune dette.

T22, s’il est créé :

```text
trace_id: j16_consequence_payment_record_01
current_state: ACTIVE
record_type: FACT_RECORD
source_t21_id: j15_obligation_collision_record_01 | null
source_collision_mode: FULL_COLLISION | NO_COLLISION
source_promise_ids: []
p17_created: true | false
consequence_outcome:
  CONSEQUENCE_PAID
  | CONSEQUENCE_FAILED
  | NO_URGENT_CONSEQUENCE
  | DIRECT_TO_MATHILDE_MARIE_J17_PREPARATION
urgent_consequence_remaining: true | false
next_priority: 1..8
visual_asset: none
```

Si aucun T22 n’est instancié :

```text
trace_id: j16_consequence_payment_record_01
current_state: NOT_CREATED
```

Lorsque `urgent_consequence_remaining: false` :

```text
next_priority: 8
```

### 9.6 Sortie J16

J16 conserve un état concret du foyer, prépare le départ Mathilde et crée, amende ou refuse P18 uniquement par choix réel.

```text
J16: READY
```

---

## 10. Matrice de priorité J13

| Rang | Condition | Pivot | Support | Nouveau contenu |
|---:|---|---|---|---|
| 1 | sécurité ou consentement | Mathilde ou personne concernée | règle, distance, aftercare, foyer | aucun par compensation |
| 2 | audience compromise ou image incertaine | Sandra, Pauline, Raphaëlle, Marie | T11, T17, T18 ou T07 selon état | C13-01 ou C13-02 seulement si branche signée |
| 3 | aftercare adulte | Marie ou Mathilde | état de scène, conséquence et règle | `NO_NEW_ASSET` |
| 4 | promesse ou présence impayée | personne lésée | `promise_id` ou T19 | `NO_NEW_ASSET` |
| 5 | ligne privée devenue visible | pivot attribuable | trace existante | aucun |
| 6 | rien de dû | Marie / foyer / réseau | T14, T15, C12-03 ou R05 | réutilisation |

Règles :

- le premier rang réellement actif gagne ;
- une seule ligne devient foreground ;
- l’écho Marie reste J13-B3 ;
- C13-01 et C13-02 ne coexistent jamais dans une même partie.

---

## 11. Matrice locale trace/témoin J14

### 11.1 Cardinalité

```text
1 discovered_trace_id
+ 1 witness_id
+ 1 display_mode crédible
+ 1 liste visible_fields
+ 1 player_reaction
+ 1 player_explanation
```

### 11.2 Couples autorisés

| Trace accessible | Témoin | Mode | Champs visibles | Contenu témoin |
|---|---|---|---|---|
| T17 / C13-01 | Marie | miniature ou dernier média déjà affiché | expéditeur, miniature si activée, heure | C14-01 |
| T18 / C13-02 | Marie | image reçue ou miniature réellement accessible | fil, miniature si activée, heure ; aucune permission future | C14-01 |
| T18B / C13-02 | Marie | image adulte reçue ou miniature réellement accessible | Raphaëlle, exposition corporelle adulte, fil ou fichier, réaction Player ; aucune règle d’audience déduite | C14-01 |
| T19 Nico | Marie | notification textuelle | expéditeur, aperçu exact, heure | C14-01 |
| T11 Sandra | Mathilde | mauvaise conversation déjà ouverte | fil, dernier média, lignes immédiatement visibles | C14-02 |
| T13 Mathilde textuelle | Marie | aperçu verrouillé | expéditeur, aperçu exact, heure | C14-01 |

### 11.3 Cas bornés

| Cas | Résultat |
|---|---|
| T17 `REMOVED` ou `INACCESSIBLE` | aucun affichage ; connaissance antérieure conservée |
| T18 `NOT_CREATED` | aucun substitut et aucun fichier créé |
| T18 `REMOVED` ou `INACCESSIBLE` | aucune restauration |
| T18B `NOT_CREATED` | aucun substitut et aucun fichier créé |
| T18B `REMOVED` ou `INACCESSIBLE` | aucune restauration ; T18 standard n’est pas retirée automatiquement |
| T11 retirée | aucune restauration |
| aucune trace éligible | fallback sans incident, puis mutation si nécessaire |
| écran complet dans C14-01/C14-02 | interdit |

### 11.4 Connaissance

Le témoin connaît seulement les champs visibles, le geste de Player et les mots reçus ensuite. Il ne connaît pas automatiquement l’intention, la règle de sauvegarde, l’historique, le consentement exact ou ce que pense le contrôleur.

---

## 12. Matrice des obligations J15

### 12.1 Validateur `FULL_COLLISION`

Deux fiches distinctes doivent chacune satisfaire :

```text
promise_id != null
status == ACTIVE
created_at < collision_start
activated_at <= collision_start
source_signed_ref != null
concerned_person != null
action_due != null
due_at != null
accepted_by_player attribuable
paid_or_closed_at == null
```

La paire est refusée si :

- les identifiants sont identiques ;
- les actions dues sont identiques ou reformulent le même dû ;
- les fenêtres sont compatibles ;
- une promesse est terminale ;
- une action aurait déjà dû être payée en J14 ;
- la seconde obligation est créée en J15 pour provoquer la collision.

### 12.2 Contrat `S28_MUTATION_NO_COLLISION`

Éligibilité :

- moins de deux promesses admissibles ;
- fenêtres compatibles ;
- seconde obligation non signée ;
- bonne gestion ayant fermé les autres attentes.

Fonction :

- payer, amender, refuser ou fermer l’unique obligation réelle ;
- montrer les autres personnes continuant leur vie ;
- conserver une conséquence Marie ou foyer seulement si nécessaire ;
- préparer J16 sans prétendre qu’une collision complète a eu lieu.

Interdits :

- inventer une seconde obligation ;
- rouvrir une promesse terminale ;
- punir la bonne gestion ;
- créer une route, une progression adulte ou un fichier visuel.

### 12.3 Branches

| Branche J14 | Obligation A | Obligation B | Deux fiches admissibles ? | Mode J15 |
|---|---|---|---|---|
| Pauline | conversation Marie | retour Pauline après information | oui sous conditions | collision ou mutation |
| Sandra | règle du foyer | compte rendu Sandra | oui sous conditions | collision ou mutation |
| Mathilde | sécurité / foyer | obligation extérieure antérieure réelle | conditionnel | collision si O2 prouvée, mutation sinon |
| Raphaëlle | position de Player envers Marie | aucune tâche professionnelle signée | non par défaut | mutation |
| Nico | heure ou vérité couple | aucune seconde obligation signée par défaut | non par défaut | mutation |
| Composite | première fiche exacte | seconde fiche exacte de la paire | selon preuve | collision si paire prouvée, mutation sinon |

### 12.4 Terminalité

P01–P13 ne peuvent jamais être réactivées. Une promesse `PAID`, `REFUSED`, `FAILED`, `EXPIRED`, `CANCELLED` ou `CLOSED` ne redevient pas `ACTIVE` avec le même `promise_id`.

---

## 13. Matrice conséquence / Mathilde / Marie J16

| Sortie J15 | P17 créée ? | T21 | Entrée J16 |
|---|---:|---|---|
| collision avec conséquence réelle due | oui | `ACTIVE`, `FULL_COLLISION` | priorité urgente puis Mathilde/Marie |
| mutation, obligation échouée ou refusée avec conséquence | oui | `ACTIVE`, `NO_COLLISION` | priorité urgente puis Mathilde/Marie |
| mutation, obligation payée ou fermée | non | `ACTIVE`, `NO_COLLISION` | priorité 8 |
| aucun record utile, aucune urgence | non | `NOT_CREATED` | priorité 8 |

### 13.1 Support par pivot

| Conséquence | Support admissible | Nouveau fichier urgent | Interdit |
|---|---|---:|---|
| Sandra | T11 retirée/inaccessible, déclaration ou silence | 0 | nouvelle image Sandra |
| Pauline | T17 retirée, C12-03/T04 publics inchangés | 0 | compensation plus intime |
| Raphaëlle | T18 selon état, R04, message existant | 0 | rendu professionnel inventé |
| Nico | T19, heure factuelle ou alibi fermé | 0 | portrait-récompense |
| Mathilde | distance, objets, clés, foyer R05 | 0 | négociation de sécurité |
| Marie | heure, contradiction ou foyer | 0 | conversation J17 jouée en avance |

### 13.2 T22

T22 enregistre seulement un résultat factuel. Il n’a aucune audience photographique, n’est pas sauvegardé ou transféré comme image et ne produit aucun fichier.

---

## 14. Registre des dix nouveaux contenus principaux

| # | Code | Jour | `asset_id` | Type | Fonction | Fichiers |
|---:|---|---|---|---|---|---:|
| 1 | C13-01 | J13 | `S1_A4_J13_DPH_PAULINE_PRIVATE_VERSION_01` | `PHOTO_DIÉGÉTIQUE` | quatrième frame privée L’Annexe | 1 enfant |
| 2 | C13-02 | J13 | `S1_A4_J13_DPH_RAPHAELLE_MASKED_POSTURE_01` | `PHOTO_DIÉGÉTIQUE` | masque transformant la posture, puis seconde image adulte conditionnelle | 1 base + 1 enfant |
| 3 | C14-01 | J14 | `S1_A4_J14_SCN_MARIE_LIMITED_DISCOVERY_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | connaissance limitée Marie | 1 |
| 4 | C14-02 | J14 | `S1_A4_J14_SCN_MATHILDE_LIMITED_DISCOVERY_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | connaissance limitée Mathilde | 1 |
| 5 | C15-01 | J15 | `S1_A4_J15_SCN_MARIE_AUTONOMOUS_PRIORITY_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | Marie agit sans Player | 1 |
| 6 | C15-02 | J15 | `S1_A4_J15_SCN_SANDRA_AUTONOMOUS_WINDOW_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | Sandra ferme ou poursuit | 1 |
| 7 | C15-03 | J15 | `S1_A4_J15_SCN_MATHILDE_AUTONOMOUS_HOUSEHOLD_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | Mathilde réorganise le foyer | 1 |
| 8 | C15-04 | J15 | `S1_A4_J15_SCN_PAULINE_AUTONOMOUS_VERSION_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | Pauline reprend sa version | 1 |
| 9 | C16-01 | J16 | `S1_A4_J16_SCN_MATHILDE_DEPARTURE_PREPARATION_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | préparation du départ | 2 |
| 10 | C16-02 | J16 | `S1_A4_J16_SCN_MARIE_J17_HANDOFF_01` | `SOUVENIR_IMAGE_DE_SCÈNE` | foyer transformé, handoff J17 | 1 |
| **Total** |  |  |  |  | **10 contenus** | **12 fichiers** |

### 14.1 Répartition par type

| Type | Nombre |
|---|---:|
| `PHOTO_DIÉGÉTIQUE` | **2** |
| `SOUVENIR_IMAGE_DE_SCÈNE` | **8** |
| `FACT_RECORD` visuel | **0** |
| **Total** | **10** |

T19, T20, T21 et T22 conservent leur fonction narrative sans entrer dans le registre visuel.

---

## 15. Manifeste final des douze fichiers

| # | Jour | Fichier source | Contenu | Nature |
|---:|---|---|---|---|
| 1 | J13 | `S1_A3_J12_DPH_PAULINE_BASTIEN_ANNEXE_01_FRAME_04_PRIVATE` | C13-01 | enfant de C12-03 |
| 2 | J13 | `S1_A4_J13_DPH_RAPHAELLE_MASKED_POSTURE_01` | C13-02 | base autonome |
| 3 | J13 | `S1_A4_J13_DPH_RAPHAELLE_MASKED_ADULT_SELECTED_01` | C13-02 | enfant conditionnel adulte |
| 4 | J14 | `S1_A4_J14_SCN_MARIE_LIMITED_DISCOVERY_01` | C14-01 | base |
| 5 | J14 | `S1_A4_J14_SCN_MATHILDE_LIMITED_DISCOVERY_01` | C14-02 | base |
| 6 | J15 | `S1_A4_J15_SCN_MARIE_AUTONOMOUS_PRIORITY_01` | C15-01 | base |
| 7 | J15 | `S1_A4_J15_SCN_SANDRA_AUTONOMOUS_WINDOW_01` | C15-02 | base |
| 8 | J15 | `S1_A4_J15_SCN_MATHILDE_AUTONOMOUS_HOUSEHOLD_01` | C15-03 | base |
| 9 | J15 | `S1_A4_J15_SCN_PAULINE_AUTONOMOUS_VERSION_01` | C15-04 | base |
| 10 | J16 | `S1_A4_J16_SCN_MATHILDE_DEPARTURE_PREPARATION_01_ORDINARY` | C16-01 | base |
| 11 | J16 | `S1_A4_J16_SCN_MATHILDE_DEPARTURE_PREPARATION_01_PROTECTIVE` | C16-01 | variante conditionnelle |
| 12 | J16 | `S1_A4_J16_SCN_MARIE_J17_HANDOFF_01` | C16-02 | base |

Contrôle :

```text
J13 3 + J14 2 + J15 4 + J16 3 = 12
9 bases + 2 enfants + 1 variante = 12
```

### 15.1 Éléments sans nouveau fichier

- T19, T20, T21 et T22 ;
- toute branche J13 non sélectionnée ;
- le refus d’envoi Raphaëlle ;
- tout retrait, silence, blocage ou inaccessibilité ;
- toute preuve textuelle ou horaire existante ;
- toute paire J15 non jouée ;
- Raphaëlle et Nico en mutation ;
- la conséquence urgente J16 ;
- P18 et la conversation J17 non jouée.

---

## 16. Manifeste des douze réutilisations J01–J12

### 16.1 Règle commune

Chaque réutilisation conserve son `asset_id`, son créateur, son propriétaire, son audience, sa permanence, sa sauvegarde et son transfert. Elle ne crée aucune audience, aucun fichier et aucune restauration.

### 16.2 Manifeste

| # | Code | `asset_id` | Source | Créateur / propriétaire | Audience | Sauvegarde / transfert | État admis | Fonction Acte IV | Nouveau fichier |
|---:|---|---|---|---|---|---|---|---|---:|
| 1 | R01 | `S1_A1_J01_DPH_SANDRA_LUNCH_SELECTED_01` | J01 / T01 | Sandra / Sandra | Sandra, Player selon contrôle Sandra | `IN_THREAD_ONLY` / `FORBIDDEN` | état canonique | continuité Sandra, retrait ou absence | 0 |
| 2 | R02 | `S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01` | J04 / T04 | Pauline via retardateur / Pauline | groupe social nommé | `PUBLIC_SOURCE_RULES` / `PUBLIC_SOURCE_RULES` | `ACTIVE` ou `INACCESSIBLE` | surface publique Pauline/Bastien | 0 |
| 3 | R03 | `S1_A2_J06_SCN_MATHILDE_LOOK_ACKNOWLEDGED_01` | J06 | non applicable | joueur uniquement | `NONE` / `FORBIDDEN` | `ACTIVE` ou `INACCESSIBLE` | antécédent Mathilde, jamais trace | 0 |
| 4 | R04 | `S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01` | J08 | non applicable | joueur uniquement | `NONE` / `FORBIDDEN` | `ACTIVE` ou `INACCESSIBLE` | état de travail antérieur si réellement pertinent | 0 |
| 5 | R05 | `S1_A2_J08_SCN_HOUSEHOLD_STATE_01` | J08 | non applicable | joueur uniquement | `NONE` / `FORBIDDEN` | `ACTIVE` ou `INACCESSIBLE` | foyer et préparation du départ | 0 |
| 6 | R06 | `S1_A3_J09_DPH_MARIE_BLACK_DRESS_PRIVATE_01` | J09 / T07 | Marie / Marie | Marie, Player | `IN_THREAD_ONLY` / `FORBIDDEN` | `ACTIVE`, `REMOVED`, `INACCESSIBLE` | conséquence Marie sans permission future | 0 |
| 7 | R07 | `S1_A3_J10_DPH_MATHILDE_OUTFIT_CHOICE_01` | J10 / T10 | Mathilde / Mathilde | Mathilde, Player | `IN_THREAD_ONLY` / `FORBIDDEN` | `ACTIVE`, `REMOVED`, `INACCESSIBLE` | conséquence domestique, maintien ou retrait | 0 |
| 8 | R08 | `S1_A3_J11_DPH_SANDRA_CHOSEN_IMAGE_01` | J11 / T11 | Sandra / Sandra | Sandra, Player si maintenue | `IN_THREAD_ONLY` / `FORBIDDEN` | `ACTIVE`, `RESTRICTED`, `REMOVED`, `INACCESSIBLE` | trace réelle, retrait ou dette | 0 |
| 9 | R09 | `S1_A3_J11_DPH_RAPHAELLE_CHOSEN_RESULT_01` | J11 / T12 | Maud / Raphaëlle ou Maud selon accord canonique | Raphaëlle, Maud ; Player seulement si réception antérieure | `IN_THREAD_ONLY` / `FORBIDDEN` | `ACTIVE`, `RESTRICTED`, `REMOVED`, `INACCESSIBLE` | résultat antérieur distinct, réutilisable uniquement comme continuité de processus si encore accessible | 0 |
| 10 | R10 | `S1_A3_J12_DPH_LAVERRIERE_PUBLIC_GROUP_SET_01` | J12 / T14 | Élodie / source publique | groupe photographié / canal nommé | `PUBLIC_SOURCE_RULES` / `PUBLIC_SOURCE_RULES` | `ACTIVE` ou `INACCESSIBLE` | ancre publique, Marie ou retour | 0 |
| 11 | R11 | `S1_A3_J12_DPH_ANNEXE_SOCIAL_POSITIONS_SET_01` | J12 / T15 | Sophie / Sophie | groupe photographié nommé | `PUBLIC_SOURCE_RULES` / règles du canal | `ACTIVE` ou `INACCESSIBLE` | heure, présence publique ou Nico | 0 |
| 12 | R12 | `S1_A3_J12_DPH_PAULINE_BASTIEN_ANNEXE_01` | J12 / C12-03 | Pauline / Pauline | groupe photographié nommé | sélection collective / selon accord du groupe | `ACTIVE` ou `INACCESSIBLE` | parent C13-01 et surface officielle | 0 |

### 16.3 R09

R09 :

- est le résultat choisi J11 antérieur ;
- peut servir de comparaison historique dans le fil s’il est encore accessible ;
- prouve que Player avait déjà reçu un accès distinct ;
- ne possède aucune parenté de fichier avec T18 ;
- ne dérive pas vers T18 ;
- ne se transforme pas en T18 ;
- ne produit aucun nouveau fichier.

---

## 17. Taxonomie PHOTO / SOUVENIR / FACT_RECORD

| Type | Existe dans l’univers | Créateur diégétique | Découvrable | Sauvegarde / transfert | Usage |
|---|---|---|---|---|---|
| `PHOTO_DIÉGÉTIQUE` | oui | personne ou tiers autorisé | selon trace et état | règle explicite | C13-01, C13-02 et photos réutilisées |
| `SOUVENIR_IMAGE_DE_SCÈNE` | non comme fichier détenu | non applicable | jamais | `NONE` / `FORBIDDEN` | C14-01/02, C15-01 à C15-04, C16-01/02 et R03–R05 |
| `FACT_RECORD` | fait structuré | source du fait | jamais comme image | aucune sauvegarde photographique | T20, T21, T22 |

### 17.1 Traces et messages

| Élément | Type | Fichier image | Fonction |
|---|---|---:|---|
| T17 | `PHOTO` | 1 enfant | version privée Pauline |
| T18 | `PHOTO` | 1 autonome ou 0 si `NOT_CREATED` | posture Raphaëlle choisie |
| T18B | `PHOTO` | 1 enfant de C13-02 ou 0 si `NOT_CREATED` | seconde image adulte choisie Raphaëlle |
| T19 | `TEXT_MESSAGE` | 0 | heure ou alibi |
| T20 | `FACT_RECORD` | 0 | découverte limitée |
| T21 | `FACT_RECORD` | 0 | collision ou mutation |
| T22 | `FACT_RECORD` | 0 | résultat de conséquence |

### 17.2 Interdictions

- C14-01 et C14-02 ne reproduisent pas la trace privée.
- T20 ne contient aucun fichier découvert.
- T21 et T22 ne deviennent jamais des images.
- Une miniature n’autorise aucun dérivé.
- Un retrait ne reçoit aucun `asset_id` de substitution.

---

## 18. Audience, permanence, sauvegarde, transfert et Galerie

### 18.1 Nouveaux contenus

| Contenu | Audience | États | Sauvegarde | Transfert | Galerie | J14 | J21 |
|---|---|---|---|---|---|---|---|
| C13-01 / T17 | Pauline puis Player si envoi | `PRIVATE_ACTIVE`, `REMOVED`, `INACCESSIBLE`, `NOT_CREATED` | `IN_THREAD_ONLY` | `FORBIDDEN` | `conditional` | si accessible | selon état, jamais restaurée |
| C13-02 / T18 | Raphaëlle, Maud puis Player si envoi | `PRIVATE_ACTIVE`, `REMOVED`, `INACCESSIBLE`, `NOT_CREATED` | `IN_THREAD_ONLY` | `FORBIDDEN` | `conditional` | si accessible | selon état, jamais restaurée |
| C13-02 / T18B | Raphaëlle, Maud puis Player si envoi adulte | `PRIVATE_ACTIVE`, `REMOVED`, `INACCESSIBLE`, `NOT_CREATED` | `IN_THREAD_ONLY` | `FORBIDDEN` | `conditional` | si accessible | selon état, jamais restaurée |
| C14-01 / C14-02 | joueur uniquement | scène vécue ou inaccessible | `NONE` | `FORBIDDEN` | `conditional` | non comme trace | non |
| C15-01 à C15-04 | joueur uniquement | scène vécue ou inaccessible | `NONE` | `FORBIDDEN` | `conditional` | non | non |
| C16-01 / C16-02 | joueur uniquement | scène vécue ou inaccessible | `NONE` | `FORBIDDEN` | `conditional` | non | non |

### 18.2 États

| État | Accessible ? | Connaissance conservée ? | Nouveau fichier autorisé ? |
|---|---:|---:|---:|
| `PRIVATE_ACTIVE` | oui selon audience | oui | non par simple maintien |
| `REMOVED` | non | oui | non |
| `INACCESSIBLE` | non pour Player | oui si déjà acquise | non |
| `NOT_CREATED` | non | non pour ce fichier | non |

### 18.3 Galerie

Pour tous les nouveaux contenus :

```text
gallery_eligibility: conditional
gallery_slot_behavior: deferred
```

Une trace retirée n’est jamais restaurée pour remplir un slot.

---

## 19. Matrices T17–T22, T18B et P14–P18

### 19.1 T17–T22 et T18B

| ID | `trace_id` | Type | État | Nouveau fichier |
|---|---|---|---|---:|
| T17 | `j13_pauline_private_version_01` | `PHOTO` | `PRIVATE_ACTIVE`, `REMOVED`, `INACCESSIBLE`, `NOT_CREATED` | 1 enfant |
| T18 | `j13_raphaelle_masked_version_01` | `PHOTO` | `PRIVATE_ACTIVE`, `REMOVED`, `INACCESSIBLE`, `NOT_CREATED` | 1 autonome ou 0 |
| T18B | `j13_raphaelle_masked_adult_selected_01` | `PHOTO` | `PRIVATE_ACTIVE`, `REMOVED`, `INACCESSIBLE`, `NOT_CREATED` | 1 enfant ou 0 |
| T19 | `j13_nico_alibi_or_hour_message_01` | `TEXT_MESSAGE` | état du fil | 0 |
| T20 | `j14_discovery_event_01` | `FACT_RECORD` | `ACTIVE` ou `NOT_CREATED` | 0 |
| T21 | `j15_obligation_collision_record_01` | `FACT_RECORD` | `ACTIVE` ou `NOT_CREATED` | 0 |
| T22 | `j16_consequence_payment_record_01` | `FACT_RECORD` | `ACTIVE` ou `NOT_CREATED` | 0 |

### 19.2 P14–P18 et sept promesses conditionnelles

| Entrée | `promise_id` | Création | Statut / activation | Fonction | Contrôle |
|---|---|---|---|---|---|
| P14 | `j14_witness_clarification` | D-C avec heure précise | `ACTIVE` tant que due | clarification témoin | ne pas dupliquer |
| P15 | `j14_inform_trace_controller` | audience privée compromise | immédiate ; `PAID` ou `FAILED` en J14 | informer la personne représentée | terminale avant J15 |
| N1 | `marie_j14_pauline_player_account_j15` | sortie Pauline J14 | `CONDITIONAL` → `ACTIVE` uniquement à `activated_at` J15 | répondre à Marie | collision Pauline |
| N2 | `pauline_j14_post_breach_return_j15` | responsabilité distincte J14 | `CONDITIONAL` → `ACTIVE` uniquement à `activated_at` J15 | retour précis à Pauline | collision Pauline |
| N3 | `household_j14_sandra_rule_j15` | règle foyer J14 | `CONDITIONAL` → `ACTIVE` uniquement à `activated_at` J15 | fixer la règle du foyer | collision Sandra |
| N4 | `sandra_j14_breach_account_j15` | responsabilité d’audience J14 | `CONDITIONAL` → `ACTIVE` uniquement à `activated_at` J15 | rendre les faits à Sandra | collision Sandra |
| N5 | `mathilde_j14_household_safety_rule_j15` | sécurité / foyer J14 | `CONDITIONAL` → `ACTIVE` uniquement à `activated_at` J15 | garantir sécurité ou distance | O2 externe requise |
| N6 | `marie_j14_raphaelle_position_j15` | place Player laissée ouverte J14 | `CONDITIONAL` → `ACTIVE` uniquement à `activated_at` J15 | répondre à Marie | obligation unique par défaut |
| N7 | `marie_j14_nico_hour_account_j15` | heure ou vérité due J14 | `CONDITIONAL` → `ACTIVE` uniquement à `activated_at` J15 | heure réelle à Marie | obligation unique par défaut |
| P16 | validation J15 | référence des fiches réelles | aucun identifiant générique | validation des engagements | aucune dette créée |
| P17 | `j16_priority_consequence_payment` | sortie J15 seulement si dette réelle | conditionnelle | paiement prioritaire J16 | absente après fermeture propre |
| P18 | `marie_j16_couple_conversation_j17` | choix réel J16 | `ACTIVE`, `AMENDED` ou `REFUSED` | conversation couple J17 | non jouée J16 |

Règles :

- aucune des sept entrées ne duplique P14 ;
- si P14 `ACTIVE` couvre la même `action_due`, P14 est utilisée ;
- si P14 est terminale pour cette action, la même action n’est pas recréée ;
- P15 n’est jamais maintenue artificiellement jusqu’à J15 ;
- P01–P13 ne sont jamais réactivées ;
- J15 confirme ou active une responsabilité créée en J14 ; il ne la crée pas rétroactivement.

### 19.3 Matrice des branches promise

| Branche | Promise A | Promise B | Collision possible | Mutation |
|---|---|---|---|---|
| Pauline | N1 | N2 | si deux `ACTIVE`, actions distinctes, fenêtres incompatibles | sinon |
| Sandra | N3 | N4 | si deux `ACTIVE`, actions distinctes, fenêtres incompatibles | sinon |
| Mathilde | N5 | fiche extérieure antérieure signée | seulement avec O2 réelle | sans O2 |
| Raphaëlle | N6 | aucune seconde source signée | `MISSING_SIGNED_SOURCE` | chemin canonique |
| Nico | N7 | seconde fiche à prouver | non par défaut | chemin canonique |
| Composite | paire exacte | seconde fiche exacte | seulement sur preuve | sinon |

### 19.4 Corrections appliquées au Trace Registry

Le présent lot remplace uniquement T17 et T18 dans :

`docs/canon/dialogues/J01_J21_TRACE_REGISTRY.md`

#### T17 — Version privée Pauline J13

```text
trace_id: j13_pauline_private_version_01
trace_type: PHOTO
source_day: J13
source_scene: S24 — Les deux versions
parent_content_id: C12-03
parent_asset_id: S1_A3_J12_DPH_PAULINE_BASTIEN_ANNEXE_01
origin: L’Annexe J12
creator: Pauline
selected_by: Pauline
subjects: [Pauline]
owner: Pauline
initial_audience: [Pauline]
current_audience: [Pauline, Player] uniquement si Pauline envoie l’image
storage_location: fil Player / Pauline si envoyée
saving_rule: IN_THREAD_ONLY
transfer_rule: FORBIDDEN
current_state: PRIVATE_ACTIVE | REMOVED | INACCESSIBLE | NOT_CREATED
replaces_or_derives_from: C12-03, comme quatrième frame privée et nouveau fichier enfant
knowledge_created: fact_pauline_created_private_double_address
eligible_for_j14: true uniquement si encore accessible
eligible_for_j21: true selon état canonique, jamais après restauration d’un fichier retiré
production: 1 nouveau fichier enfant
legacy_runtime_alias: null
```

T17 ne possède aucune source Élodie ou La Verrière.

#### T18 — Masque et posture Raphaëlle J13

```text
trace_id: j13_raphaelle_masked_version_01
trace_type: PHOTO
source_day: J13
source_scene: S25 — Le masque change la posture
asset_id: S1_A4_J13_DPH_RAPHAELLE_MASKED_POSTURE_01
creator: Maud
selected_by: Raphaëlle
subjects: [Raphaëlle]
owner: Raphaëlle
initial_audience: [Raphaëlle, Maud]
current_audience: [Raphaëlle, Maud, Player] uniquement si Raphaëlle envoie l’image
storage_location: fil Player / Raphaëlle si envoyée
saving_rule: IN_THREAD_ONLY
transfer_rule: FORBIDDEN
current_state: PRIVATE_ACTIVE | REMOVED | INACCESSIBLE | NOT_CREATED
replaces_or_derives_from: null
knowledge_created: fact_raphaelle_chose_player_for_masked_posture_image
eligible_for_j14: true uniquement si encore accessible
eligible_for_j21: true selon état canonique, jamais après restauration d’un fichier retiré
production: 1 nouveau fichier source autonome
legacy_runtime_alias: null
```

Si Raphaëlle refuse l’envoi ou si la prise distincte n’existe pas :

```text
trace_id: j13_raphaelle_masked_version_01
current_state: NOT_CREATED
production: NO_NEW_ASSET
```

T18B complète C13-02 sans remplacer T18 :

```text
trace_id: j13_raphaelle_masked_adult_selected_01
asset_id: S1_A4_J13_DPH_RAPHAELLE_MASKED_ADULT_SELECTED_01
creator: Maud
selected_by: Raphaëlle
owner: Raphaëlle
production: 1 fichier enfant C13-02
eligible_for_j14: true uniquement si encore accessible
eligible_for_j21: true selon état
```

Le retrait de T18B ne retire pas automatiquement T18.

---

## 20. Refus, suppressions, absences, échecs et fallbacks

| Jour | Cas | Fonction servie | Production | Interdit |
|---|---|---|---|---|
| J13 | branche non foreground | silence ou fermeture | `NO_NEW_ASSET` | image de compensation |
| J13 | Pauline refuse ou retire | T17 `NOT_CREATED`, `REMOVED` ou `INACCESSIBLE` | aucun substitut | restaurer la frame |
| J13 | Raphaëlle refuse ou cadre pressé | T18 `NOT_CREATED` | `NO_NEW_ASSET` | créer une prise de substitution |
| J13 | Sandra retire | contrôle exercé | absence ou souvenir interne | réafficher T11 |
| J14 | trace inaccessible | aucun incident | fallback propre | inventer une notification |
| J14 | personne représentée informée | P15 `PAID` | T20 factuel | garder P15 `ACTIVE` |
| J14 | moins de deux promesses | préparation de la mutation | `NO_NEW_ASSET` | dette générique |
| J15 | moins de deux promesses | `S28_MUTATION_NO_COLLISION` | supports existants | créer une obligation mardi |
| J15 | fenêtres compatibles | mutation | supports existants | forcer la collision |
| J15 | Raphaëlle | obligation Marie unique traitée | R04, T18 ou texte | rendu professionnel inventé |
| J15 | Nico | heure réelle traitée | T19 ou texte | seconde obligation inventée |
| J16 | obligation payée/fermée | aucune urgence | priorité 8 | créer P17 |
| J16 | conséquence réelle échouée | P17 créée, T22 factuel | `NO_NEW_ASSET` | réparation magique |
| J16 | sécurité Mathilde | variante protectrice | 1 variante | récompense ou rapprochement |
| J16 | P18 refusée | Marie continue sans attendre | C16-02 si scène réelle | conversation forcée |

### 20.1 Fallback J14→J15

```text
moins de deux promesses admissibles
→ sequence_id: S28_MUTATION_NO_COLLISION
→ une seule obligation réelle payée, amendée, refusée ou fermée
→ autres personnages sans attente artificielle
→ aucune dette compensatoire
→ aucun fichier spécifique
```

### 20.2 Fallback J15→J16

```text
obligation échouée ou conséquence réelle restante
→ P17 créée
→ T22 enregistre la conséquence

obligation payée ou fermée, aucune urgence
→ P17 absente
→ consequence_outcome: NO_URGENT_CONSEQUENCE
→ next_priority: 8
```

---

## 21. Contradictions, remplacements, checklist, comptages et verdicts

### 21.1 Remplacements exacts

| Ancien état | État final |
|---|---|
| T17 attribuée à une source extérieure au moment L’Annexe | Pauline, parent C12-03, quatrième frame privée, fichier enfant |
| T18 traité comme simple modification d’accès | photographie autonome, nouvelle prise distincte, Maud créatrice, Raphaëlle sélectionneuse et propriétaire |
| T18 sans fichier nouveau | C13-02 produit un fichier autonome si la prise est créée et envoyée |
| R09 lié techniquement à T18 | résultat antérieur distinct, continuité de processus seulement |
| cinquième contenu visuel J15 | supprimé sans substitution visuelle |
| autonomie Raphaëlle montrée par un rendu professionnel | R04, T18, message, trace existante ou `NO_NEW_ASSET` |
| moins de deux promesses bloquant J15 | `S28_MUTATION_NO_COLLISION` |
| collision obligatoire dans toutes les parties | collision seulement avec deux fiches admissibles |
| P17 créée après toute sortie J15 | P17 créée seulement si une conséquence réelle reste due |
| T21/T22 décrits sans état canonique | `trace_id` stable et état canonique `ACTIVE` ou `NOT_CREATED` |
| J14 ou J16 encore conditionnés par une correction produit | J14 et J16 `READY` |
| NAR-PROD-05 bloqué | NAR-PROD-05 `READY` |

### 21.2 Contradictions résolues

- T17 possède une origine, une parentalité et une créatrice exactes.
- T18 est une prise autonome sans dérivation.
- C13-01 et C13-02 sont mutuellement exclusifs dans une partie.
- Le remplacement visuel J13/J15 et l’enfant T18B portent le total à douze fichiers.
- Raphaëlle ne possède aucune seconde tâche professionnelle inventée.
- Mathilde exige une O2 extérieure réellement signée pour une collision complète.
- Nico utilise la mutation par défaut.
- Une branche interne sans seconde source n’invalide pas la journée.
- P15 est terminale avant J15 lorsqu’elle a été payée.
- P01–P13 ne sont jamais ressuscitées.
- T21 et T22 restent des `FACT_RECORD` sans asset.
- P17 est conditionnelle à une conséquence réelle.

### 21.3 Décisions restantes

```text
Décisions restant à Ludovic : AUCUNE
```

La collision complète Raphaëlle reste `MISSING_SIGNED_SOURCE`. Son chemin jouable est `S28_MUTATION_NO_COLLISION` ; elle ne bloque donc pas NAR-PROD-05.

### 21.4 Checklist

#### Autorité et périmètre

- [x] Baseline `547d7af3207a7dfb5c9c68f8f01c984de3e21c6f`.
- [x] NAR-CANON-01 cité comme source autoritative.
- [x] Aucun dialogue réécrit.
- [x] Aucun dialogue créé.
- [x] Aucun changement runtime, JSON, test, UI ou asset.

#### Production

- [x] Exactement 12 beats.
- [x] Exactement 10 contenus principaux.
- [x] Exactement 12 réutilisations.
- [x] Exactement 12 fichiers.
- [x] Exactement 2 fichiers enfants.
- [x] Exactement 1 variante.
- [x] Exactement 2 `PHOTO_DIÉGÉTIQUE`.
- [x] Exactement 8 `SOUVENIR_IMAGE_DE_SCÈNE`.
- [x] Aucun `FACT_RECORD` visuel.
- [x] C13-02 Raphaëlle présent.
- [x] Aucun fichier Raphaëlle de substitution en J15.

#### Traces

- [x] T17 : Pauline, L’Annexe, C12-03, quatrième frame privée.
- [x] T18 : `PHOTO`, Maud créatrice, Raphaëlle propriétaire et sélectionneuse.
- [x] T18 distincte de T12 et sans dérivation.
- [x] T18B est un enfant conditionnel de C13-02, distinct de T18 et révocable indépendamment.
- [x] R09 est une continuité antérieure distincte.
- [x] T21 utilise `trace_id` et `current_state`.
- [x] T22 utilise `trace_id` et `current_state`.
- [x] Aucun fichier retiré n’est restauré.

#### Promesses et atteignabilité

- [x] Sept promesses conditionnelles référencées.
- [x] Aucun doublon avec P14.
- [x] P15 terminale selon l’issue J14.
- [x] Aucune réactivation P01–P13.
- [x] `FULL_COLLISION` exige deux fiches admissibles.
- [x] La mutation couvre les chemins avec zéro ou une obligation réelle.
- [x] Aucune dette n’est inventée pour bonne gestion.
- [x] P17 est conditionnelle.
- [x] Raphaëlle collision complète : `MISSING_SIGNED_SOURCE`.
- [x] Raphaëlle jouable : `S28_MUTATION_NO_COLLISION`.

### 21.5 Comptages finaux

| Mesure | Nombre exact |
|---|---:|
| Beats servis | **12** |
| J13 | **3** |
| J14 | **3** |
| J15 | **3** |
| J16 | **3** |
| Nouveaux contenus principaux | **10** |
| Réutilisations antérieures distinctes | **12** |
| Nouveaux fichiers sources | **12** |
| Fichiers enfants | **2** |
| Variantes conditionnelles | **1** |
| `PHOTO_DIÉGÉTIQUE` | **2** |
| `SOUVENIR_IMAGE_DE_SCÈNE` | **8** |
| `FACT_RECORD` visuel | **0** |

Comptage Saison 1 consolidé :

```text
Acte I: 15
Acte II: 14
Acte III: 30
Acte IV: 12
Acte V: 13
Total: 84

contenus principaux: 63
variantes: 8
nouveaux fichiers adultes: 8
images de scène adultes nouvelles: 6
photos diégétiques adultes nouvelles: 2
nouveau fichier J21: 0
```

### 21.6 Verdicts finaux

| Périmètre | Verdict | Motif |
|---|---|---|
| J13 | `READY` | deux photographies exclusives, T17/T18 et budget définis |
| J14 | `READY` | discovery et fallback canonique alignés sur NAR-CANON-01 |
| J15 | `READY` | collision prouvée ou mutation canonique sans dette inventée |
| J16 | `READY` | P17 conditionnelle, T22 canonique et priorité 8 disponible |
| NAR-PROD-05 | `READY` | narration, production et fallbacks entièrement fermés |

```text
J13: READY
J14: READY
J15: READY
J16: READY
NAR-PROD-05: READY
VALIDATION PRODUIT: PASS
Décisions restant à Ludovic: AUCUNE
```

La validation est acquise parce qu’aucun chemin ne fabrique ou ne ressuscite une obligation, qu’aucune image retirée n’est restaurée et que le budget final reste strictement borné à douze fichiers.
