# Réseau Intime — NAR-PROD-03 — Paquet de production Acte II / J05–J08

## 1. Statut, périmètre et autorités

### 1.1 Statut

**Catégorie : paquet de production narratif et visuel dérivé du canon signé**

**Périmètre : Acte II, J05 à J08**

**VALIDATION PRODUIT : PASS**

**Baseline documentaire de référence :**

`9e20b87b340c005c9ecc2d2ca6649f54f1ce8add`

Ce document :

- traduit le corpus narratif signé en unités de production visuelle ;
- fixe les beats visuels servis par partie ;
- distingue contenus nouveaux, réutilisations, fichiers sources et variantes ;
- ne réécrit aucun dialogue signé antérieur ;
- intègre l’unique échange modulaire Sandra J05 autorisé par la décision produit définitive ;
- ne crée aucune route, promesse, trace ou connaissance ;
- n’autorise aucune intégration technique.

Le paquet reste subordonné au corpus signé. Il ne devient jamais une seconde carte de saison.

### 1.2 Hors périmètre absolu

Aucune modification n’est autorisée dans le cadre de NAR-PROD-03 sur :

- Git, les branches, les commits, les tags ou les PR ;
- le runtime ;
- les JSON ;
- les dialogues signés ;
- les tests ;
- l’UI ;
- les assets existants ;
- les prompts ComfyUI définitifs.

Les `asset_id` proposés sont des identifiants de travail documentaires. Ils ne constituent ni une création de fichier ni une décision d’intégration.

### 1.3 Hiérarchie d’autorité

En cas de divergence, l’ordre de résolution est :

1. `docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md` ;
2. `docs/canon/dialogues/J07_SCRIPT_NARRATIF_COMPLET.md` et `J08_SCRIPT_NARRATIF_COMPLET.md` pour J07–J08 ;
3. `docs/canon/dialogues/J01_J06_SOURCE_CANON_CONSOLIDE.md` pour J05–J06 ;
4. registres `TRACE`, `PROMISE`, `KNOWLEDGE` et matrice d’atteignabilité ;
5. `docs/canon/dialogues/NAR_PROD_02_PAQUET_PRODUCTION_ACTE_I_J01_J04.md` pour la taxonomie et les assets Acte I ;
6. Bible Narrative et canons complets des personnages ;
7. `docs/canon/bible/12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md`, uniquement comme cartographie fonctionnelle ou réservoir historique ;
8. runtime et JSON historiques, uniquement pour localiser un matériau, jamais pour réintroduire une règle supersédée.

Un plan historique ne peut pas :

- créer une progression absente des dialogues signés ;
- transformer un `FACT_RECORD` en image ;
- réintroduire `candidate_pool`, ticket, `wave_id`, propriétaire R2 ou compensation automatique ;
- faire primer une fonction générique sur le script complet J07 ou J08.

### 1.4 Sources principales relues

- `docs/canon/bible/00_NORTH_STAR.md`
- `docs/canon/bible/04_TRAME_PRINCIPALE_ET_ACTES_SAISON_1.md`
- `docs/canon/bible/05_ROUTES_MACRO_SAISON_1.md`
- `docs/canon/bible/06_EVOLUTION_EROTIQUE_DES_ROUTES.md`
- `docs/canon/bible/07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md`
- `docs/canon/bible/08_REGLES_DES_SCENES_MODULAIRES.md`
- `docs/canon/bible/09_PROGRESSION_VISUELLE_ET_PHOTOGRAPHIQUE.md`
- `docs/canon/bible/10_CARTE_CONSEQUENCES_DETTES_SECRETS_OBLIGATIONS.md`
- `docs/canon/bible/11_DISTRIBUTION_SEQUENCES_SCENES_IMAGES_CONSEQUENCES_JOURNEES.md`
- `docs/canon/bible/12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md`
- `docs/canon/dialogues/J01_J06_SOURCE_CANON_CONSOLIDE.md`
- `docs/canon/dialogues/J07_SCRIPT_NARRATIF_COMPLET.md`
- `docs/canon/dialogues/J08_SCRIPT_NARRATIF_COMPLET.md`
- `docs/canon/dialogues/J01_J21_TRACE_REGISTRY.md`
- `docs/canon/dialogues/J01_J21_PROMISE_REGISTRY.md`
- `docs/canon/dialogues/J01_J21_KNOWLEDGE_REGISTRY.md`
- `docs/canon/dialogues/J01_J21_REACHABILITY_MATRIX.md`
- `docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md`
- `docs/canon/dialogues/NAR_PROD_01_AUDIT_PREPARATION_PRODUCTION_SAISON_1.md`
- `docs/canon/dialogues/NAR_PROD_02_PAQUET_PRODUCTION_ACTE_I_J01_J04.md`
- canons complets de Marie, Sandra, Mathilde, Pauline, Raphaëlle, Nico et Player.

### 1.5 Vocabulaire opératoire

| Terme | Définition |
|---|---|
| beat visuel servi | Une apparition visuelle distincte vécue dans une partie. Un beat peut utiliser un nouveau contenu ou recontextualiser un contenu antérieur. |
| contenu principal nouveau | Une nouvelle unité narrative/Galerie avec un `asset_id` propre. |
| contenu réutilisé | Un contenu Acte I réaffiché avec exactement le même `asset_id`, sans être recompté comme nouveau. |
| fichier visuel source | Un fichier image distinct à produire. |
| variante conditionnelle | Un fichier alternatif rattaché au même contenu principal parce que l’état ou la fonction change réellement. |
| `PHOTO_DIÉGÉTIQUE` | Fichier existant dans l’univers, avec créateur, sujets, audience, permanence et règles de transfert. |
| `SOUVENIR_IMAGE_DE_SCÈNE` | Type interne d’une représentation destinée au joueur. Il n’existe pas comme fichier dans l’univers. |
| `FACT_RECORD` | Fait narratif sans fichier image. |
| `SIGNED_SOURCE` | Dialogue complet signé, directement exploitable sans invention. |
| `CONSOLIDATED_CANON` | Fonction et états canoniques consolidés ; un visuel neutre peut être produit s’il ne fabrique aucune progression supplémentaire. |
| `REFERENCE_ONLY` | Fonction ou matériau connu, mais dialogue complet non signé à l’emplacement concerné ; aucune nouvelle progression visuelle. |
| `NO_NEW_ASSET` | Aucun nouveau fichier autorisé ; seule une réutilisation exacte ou une absence visuelle est recevable. |

`REFERENCE_ONLY` décrit la source. `NO_NEW_ASSET` décrit l’action de production. Une branche peut donc être `REFERENCE_ONLY` avec une action `NO_NEW_ASSET`.

---

## 2. Décisions héritées de NAR-PROD-02 et décisions verrouillées

1. Player reste non identifiable visuellement.
2. Aucun nouveau `PHOTO_DIÉGÉTIQUE` n’est créé dans J05–J08.
3. Tous les nouveaux contenus sont des `SOUVENIR_IMAGE_DE_SCÈNE`.
4. Un `SOUVENIR_IMAGE_DE_SCÈNE` :
   - est non transférable ;
   - est non découvrable ;
   - conserve `can_share: false` ;
   - n’est ni une preuve, ni une trace J14, ni une image finale J21.
5. Aucun onglet ou intitulé visible « Souvenir » n’est créé.
6. Un contenu multi-personnages peut être référencé dans plusieurs onglets avec le même `asset_id`, sans duplication.
7. Un `FACT_RECORD` ne devient jamais automatiquement une photo ou un visuel diégétique.
8. Acte II sert exactement douze beats visuels par partie :
   - J05 : 3 ;
   - J06 : 3 ;
   - J07 : 3 ;
   - J08 : 3.
9. Ces douze beats ne sont pas présentés comme douze nouveaux contenus.
10. Dix-neuf nouveaux fichiers sources reste un plafond estimatif, pas un objectif.
11. Aucune production artificielle n’est autorisée pour atteindre ce plafond.
12. J05 :
    - Marie reste le pivot obligatoire ;
    - Sandra est la seule continuité extérieure optionnelle ;
    - Mathilde, Raphaëlle et Pauline sont fermées comme progressions ;
    - Sandra réutilise T01 et ne crée aucun nouvel asset ;
    - l’échange modulaire Sandra crée un état relationnel local réel, sans aveu, invitation datée, promesse de route ni route acquise.
13. J06 :
    - Mathilde est la seule continuité extérieure optionnelle ;
    - aucune continuité extérieure est un chemin pleinement valide ;
    - Sandra, Pauline et Raphaëlle sont fermées comme progressions ;
    - Marie reçoit obligatoirement le retour de journée ;
    - il n’existe jamais deux progressions garanties.
14. J07 :
    - Nico possède le pivot ;
    - Raphaëlle porte l’accès secondaire professionnel du script signé ;
    - Pauline ne progresse pas ;
    - Marie porte le retour foyer, avec Mathilde comme obligation concernée ;
    - Sandra et Mathilde ne reçoivent aucun catalogue d’assets.
15. J08 produit par états locaux Raphaëlle, Nico et foyer, jamais par paire théorique.
16. J08 ne superpose que P05, P06 et P08 réellement actives.
17. La Galerie conserve :

```text
gallery_eligibility: conditional
gallery_slot_behavior: deferred
```

18. NAR-PROD-03 ne décide ni absence de slot ni slot `LOCKED`.
19. Aucun intitulé Galerie ne révèle une route, une promesse ou une branche absente.
20. Aucun visuel ne matérialise une progression fermée pour Mathilde, Pauline ou Raphaëlle en J05, ni pour Sandra, Pauline ou Raphaëlle en J06.

---

## 3. Contrat narratif et visuel de l’Acte II

### 3.1 Fonction dramatique

L’Acte II transforme des présences établies en premières lignes privées et en attentes concrètes, sans sélectionner de route dominante.

La progression est :

```text
J05 : Marie demande une heure réelle ; Sandra seule peut maintenir un fil extérieur par T01
J06 : Mathilde seule peut devenir continuité extérieure ; aucune continuité reste pleinement valide
J07 : Nico reçoit une confidence limitée ; Raphaëlle crée une obligation professionnelle
J08 : le temps révèle ce que Player paie, amende ou laisse dériver
```

### 3.2 Contrat des douze beats

Chaque journée sert trois fonctions visuelles distinctes.

Une réutilisation est recevable seulement si :

- le contenu existait déjà ;
- l’`asset_id` ne change pas ;
- l’audience et la permanence ne sont pas altérées ;
- la recontextualisation ne fabrique ni nouvel envoi, ni nouveau cadrage, ni nouvelle promesse ;
- le contenu n’est pas recompensé comme nouveau.

### 3.3 Règle anti-remplissage

Un fichier n’est produit que si :

- une scène ou un état signé le matérialise ;
- le fichier ajoute une fonction visuelle distincte ;
- la composition reste vraie sur toutes les branches qui l’utilisent ;
- le même résultat ne peut pas être obtenu par une réutilisation exacte.

### 3.4 Contrat personnage

Tous les briefs appliquent les canons complets. Ils ne fixent aucun nouveau détail de visage, corps, coiffure, âge apparent, tatouage, tenue signature ou palette.

Ancrages obligatoires :

- Marie : mouvement propre, action concrète, absence d’attente passive ;
- Sandra : contrôle de sa représentation et de l’audience ;
- Mathilde : compétence, autonomie, sensualité ordinaire non assimilée à une permission ;
- Pauline : surface publique réelle, Bastien et Marie non effacés ;
- Raphaëlle : travail exact, séparation du professionnel et du créatif ;
- Nico : L’Annexe, vie de service, amitié réelle, absence d’ambiguïté sexuelle avec Player ;
- Player : hors cadre, dos non identifiable ou présence suggérée seulement si indispensable.

---

## 4. Tableau exécutif J05–J08

### 4.1 Comptage par journée

| Jour | Beats servis par partie | Nouveaux contenus principaux au manifeste | Réutilisations Acte I rattachées au paquet journalier | Nouveaux fichiers sources | Variantes conditionnelles |
|---|---:|---:|---:|---:|---:|
| J05 | 3 | 2 | 2 | 2 | 0 |
| J06 | 3 | 3 | 2 | 3 | 0 |
| J07 | 3 | 3 | 1 | 3 | 0 |
| J08 | 3 | 3 | 1 | 6 | 3 |
| **Total** | **12** | **11** | **6 contenus uniques** | **14** | **3** |

Le comptage des réutilisations est un comptage documentaire dédupliqué à l’échelle du paquet. Une réutilisation de continuité n’ajoute pas automatiquement un beat autonome : elle peut rester l’ancre déjà accessible, la référence de composition d’un nouveau beat ou la persistance d’un contenu antérieur. Aucune branche fermée ne progresse par ce mécanisme.

### 4.2 Budget servi dans une partie

| Jour | Beat 1 | Beat 2 | Beat 3 |
|---|---|---|---|
| J05 | nouveau Marie | réutilisation Marie Acte I | T01 si Sandra éligible, sinon nouveau fallback sans continuité |
| J06 | nouveau Mathilde si éligible, sinon nouveau fallback | réutilisation foyer Acte I | nouveau retour Marie |
| J07 | nouveau Raphaëlle | nouveau Nico | nouveau retour foyer |
| J08 | nouveau Raphaëlle selon état local | nouveau Nico selon état local | nouveau foyer selon état local |

### 4.3 Pourquoi le total n’est pas 19

Le total de 14 fichiers résulte de cinq suppressions par rapport à l’estimation initiale :

1. Sandra J05 progresse par un échange signé et la réutilisation exacte de T01, sans nouveau fichier ;
2. Mathilde, Raphaëlle et Pauline sont fermées comme progressions J05 ;
3. Sandra, Pauline et Raphaëlle sont fermées comme progressions J06 ;
4. Mathilde J06 et le chemin sans continuité partagent le même budget journalier sans production compensatoire ;
5. mutualisation de J08 par trois états locaux à deux fichiers, sans matrice par paire.

---

## 5. Continuité d’entrée depuis J01–J04

### 5.1 État relationnel

- Marie reste le centre du couple et possède une vie propre.
- Sandra peut être `DISTANT_FRIEND` ou `RECONNECTION_OPEN`.
- Mathilde est une invitée autonome du foyer.
- Pauline reste `PUBLIC_ONLY`.
- Raphaëlle reste `PROFESSIONAL_ONLY`, avec un détail créatif semé au maximum.
- Nico reste un ami ordinaire réinstallé socialement.
- aucune route extérieure n’est dominante ;
- aucun accès adulte n’est ouvert.

### 5.2 Traces Acte I

| Trace | État d’entrée utile |
|---|---|
| T01 `j01_sandra_lunch_memory_soft` | affichable seulement selon contrôle Sandra ; aucune sauvegarde ou transmission nouvelle |
| T02 `j02_mathilde_arrival_room_01` | `FACT_RECORD` ; le séjour existe, mais aucun fichier T02 |
| T03 `j03_marie_laverriere_setup_01` | `FACT_RECORD` ; le monde La Verrière existe, mais aucun fichier T03 |
| T04 `j04_pauline_bastien_public_set_01` | `PHOTO_SET` public actif ; même parent et mêmes trois frames |

### 5.3 Promesses et connaissances

- P01 et P02 sont closes dans l’Acte I.
- T01 ne devient pas connue de Marie.
- T02 n’autorise aucune intention Mathilde.
- T03 n’autorise aucun accès privé Raphaëlle.
- T04 ne crée aucune version privée Pauline.
- Nico ne reçoit aucune image ou connaissance privée par défaut.

---

## 6. Paquet complet J05 — Une heure réelle

### 6.1 Identité

| Champ | Valeur |
|---|---|
| Fonction dramatique | Marie demande une heure ou une présence concrète ; Player agit, amende précisément ou refuse. |
| Question joueur | Player sait-il faire une place réelle à Marie sans supposer qu’elle l’attendra ? |
| Pivot | Marie |
| Séquence | adaptation S08, limitée à la fonction signée de l’heure réelle |
| État d’entrée | aucune route dominante ; Marie en mouvement ; zéro continuité extérieure garantie |
| État de sortie | heure payée, amendée ou refusée ; zéro ou une continuité extérieure visible ; aucune compensation automatique |

### 6.2 Sources et statut

| Branche | Source | Statut source | Action visuelle |
|---|---|---|---|
| Marie — heure acceptée/amendée/refusée | `J01_J06_SOURCE_CANON_CONSOLIDE.md`, §5 ; `chapter_05_marie_shared_hour` comme fondation | `CONSOLIDATED_CANON` | nouveau contenu neutre, sans inventer de dialogue |
| Aucune continuité extérieure | consolidation J05 + plan `12`, §13 | `CONSOLIDATED_CANON` | fallback nouveau autorisé |
| Sandra | échange modulaire exact intégré en §6.5 et décision produit définitive | `SIGNED_SOURCE` | `NO_NEW_ASSET` ; réutilisation T01 seulement |
| Mathilde | ancienne possibilité fonctionnelle supersédée | `REFERENCE_ONLY` | `NO_NEW_ASSET` ; progression J05 fermée |
| Raphaëlle | ancienne possibilité fonctionnelle supersédée | `REFERENCE_ONLY` | `NO_NEW_ASSET` ; progression J05 fermée |
| Pauline | aucune progression J05 | `NO_NEW_ASSET` | progression J05 fermée |

### 6.3 Fenêtres et choix

#### Fenêtre A — Marie

Trois postures seulement :

1. accepter une heure réelle ;
2. proposer une alternative précise ;
3. refuser sans créer un « plus tard » fictif.

Règles :

- un « plus tard » sans heure ne crée pas P03 ;
- Marie agit seule si Player ne s’engage pas ;
- l’heure payée ne devient pas un score ;
- aucun compliment ne remplace l’acte.

#### Fenêtre B — Sandra optionnelle

Sandra est la seule continuité extérieure optionnelle. Elle apparaît seulement si :

- T01 est encore accessible ;
- Sandra n’a pas retiré l’image ou fermé l’audience ;
- aucune pression ou appropriation antérieure n’a fermé la continuité ;
- la fenêtre n’est pas utilisée comme compensation après un refus Marie.

Si Sandra n’est pas éligible, aucune autre continuité extérieure ne la remplace. L’absence produit une respiration et J05-N02.

### 6.4 Personnages

| Présence | Personnages |
|---|---|
| direct principal | Marie |
| direct conditionnel | Sandra uniquement |
| indirect | Player hors cadre |
| absent de la progression | Mathilde, Raphaëlle, Pauline, Nico |

### 6.5 Échange modulaire exact Sandra J05

#### 6.5.1 Ouverture commune

```text
Sandra — Je cherchais la facture du resto.
Sandra — Je suis retombée sur la photo que je t’avais envoyée.
Sandra — J’ai failli la supprimer.
Sandra — Et puis non.
Sandra — Je l’ai laissée. Voilà.
```

T01 reste accessible dans son emplacement existant. Aucun fichier n’est joint, renvoyé, dupliqué ou remplacé.

#### 6.5.2 Choix 1 — reconnaître son choix

```text
Player — Tu as bien fait de la garder.
Sandra — Je savais que tu répondrais ça.
Player — Tu préférais quoi ?
Sandra — Rien de particulier.
Sandra — C’est bien aussi quand tu n’essaies pas d’arranger la situation.
Player — Je peux faire ça.
Sandra — On verra.
```

État produit :

```text
sandra_j05_thread_maintained
expectation: messages_occasionnels_acceptés
limit: aucune_escalade_implicite
```

#### 6.5.3 Choix 2 — reconnaître le manque

```text
Player — Elle m’a surtout rappelé qu’on ne s’était pas vus depuis longtemps.
Sandra — Depuis le déjeuner.
Sandra — J’avais fait le calcul.
Player — Évidemment.
Sandra — Pas besoin d’avoir l’air si content.
Player — Je le cache mal.
Sandra — Oui.
Sandra — On pourrait éviter d’attendre autant la prochaine fois.
Player — Ça me va.
Sandra — J’ai dit « pourrait ».
Player — J’ai entendu.
```

État produit :

```text
sandra_j05_gap_acknowledged
expectation: ne_pas_laisser_disparaître_le_fil
limit: aucun_engagement_supplémentaire
```

#### 6.5.4 Choix 3 — protéger son autonomie

```text
Player — Tu peux la supprimer si elle finit par te gêner. Je ne vais pas te demander de la garder.
Sandra — Elle ne me gêne pas.
Player — D’accord.
Sandra — Tu essaies déjà de m’aider à la supprimer.
Player — Je voulais juste te laisser le choix.
Sandra — Je l’ai.
Sandra — Laisse-le-moi, c’est tout.
Player — Reçu.
Sandra — Bien.
```

État produit :

```text
sandra_j05_boundary_respected
expectation: le_fil_peut_continuer
limit: Sandra_reste_seule_décisionnaire_de_T01
```

#### 6.5.5 Pression ou demande supplémentaire

```text
Player — Garde-la alors. Et si tu en as une autre du même genre, je prends.
Sandra — Non.
Player — Je plaisantais.
Sandra — Pas vraiment.
Sandra — Je t’ai parlé d’une photo. Je n’ai pas ouvert un catalogue.
Player — D’accord.
Sandra — On va en rester là.
```

État produit :

```text
sandra_j05_continuity_cooled
expectation: aucune_relance
limit: aucune_demande_d_image
```

En cas d’insistance :

```text
Player — Tu le prends mal pour rien.
Sandra — Non.
Sandra — Tu viens juste de me rappeler pourquoi j’avais hésité.
Sandra — Bonne nuit.
```

État produit :

```text
sandra_j05_continuity_closed
```

#### 6.5.6 Verrous de l’échange

- Sandra initie toujours.
- Aucun nouvel asset n’est envoyé.
- T01 reste accessible uniquement selon son état antérieur réel.
- Aucun choix ne crée une invitation datée.
- Aucun choix ne constitue un aveu.
- Aucun choix ne crée une promesse enregistrée ou une route acquise.
- Les trois réponses recevables créent une attente ou une limite locale réelle.
- Toute pression, appropriation de T01 ou demande de davantage refroidit la continuité ; toute insistance après la limite la ferme.
- Le texte respecte la retenue, la complicité légère, le contrôle de l’image par Sandra et le « doucement » établi en J01.

### 6.6 Faits, traces, promesses et connaissances

- P03 `marie_j05_shared_hour` n’existe qu’après acceptation réelle.
- Aucun nouveau `trace_id` visuel n’est créé.
- T01 peut être revue, jamais restaurée après retrait.
- T02 et T03 restent des `FACT_RECORD`.
- L’échange Sandra ne crée aucune nouvelle photo, aucun transfert et aucune nouvelle audience.
- Les états `sandra_j05_*` sont locaux à la relation ; ils ne sont ni des routes, ni des promesses globales.
- Mathilde, Raphaëlle et Pauline ne reçoivent aucune nouvelle connaissance ou progression J05.

### 6.7 Matrice refus, silence, absence

| Condition | Mutation | Beat visuel | État de sortie |
|---|---|---|---|
| Player accepte l’heure | présence payée hors téléphone | J05-N01 | P03 `PAID` |
| Player amende précisément | Marie accepte ou non l’alternative réelle | J05-N01 | P03 `AMENDED` ou non créée |
| Player refuse proprement | Marie vit son heure | J05-N01 | aucun rattrapage automatique |
| aucune continuité extérieure | respiration J05-N02 | nouveau fallback | aucune route compensée |
| Sandra, choix 1 | T01 reste sous contrôle Sandra ; fil maintenu | réutilisation R-A1-02 | `sandra_j05_thread_maintained` |
| Sandra, choix 2 | manque suggéré, non avoué | réutilisation R-A1-02 | `sandra_j05_gap_acknowledged` |
| Sandra, choix 3 | autonomie Sandra explicitement protégée | réutilisation R-A1-02 | `sandra_j05_boundary_respected` |
| Sandra, pression/demande | continuité refroidie | réutilisation R-A1-02 | `sandra_j05_continuity_cooled` |
| Sandra, insistance | limite répétée puis fermeture | aucun beat supplémentaire | `sandra_j05_continuity_closed` |
| Mathilde, Raphaëlle ou Pauline | progression fermée | aucun | aucun état J05 créé |

### 6.8 Tableau de production J05

| Beats servis | Nouveaux contenus | Réutilisations éligibles | Nouveaux fichiers sources |
|---:|---:|---:|---:|
| 3 | 2 | 2 | 2 |

Dans toute partie :

- J05-N01 est servi ;
- R-A1-11 est servi comme continuité de Marie ;
- le troisième beat est soit J05-N02, soit T01 si Sandra est réellement éligible ;
- Mathilde, Raphaëlle et Pauline ne remplacent jamais Sandra ou le fallback.

### 6.9 Brief J05-N01 — L’heure de Marie

| Champ | Valeur |
|---|---|
| `asset_id` | `S1_A2_J05_SCN_MARIE_REAL_HOUR_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Statut source | `CONSOLIDATED_CANON` |
| Sujet visible | Marie |
| Fonction | matérialiser qu’elle possède déjà un mouvement et qu’une heure donnée doit devenir un acte |
| Moment | samedi, autour de la fenêtre réelle définie par le dialogue source |
| Décor | espace ordinaire cohérent avec l’heure signée ; aucun événement La Verrière ajouté |
| Composition | Marie au centre, engagée dans une action réelle ; Player absent ou hors champ non identifiable |
| Posture/expression | disponible mais non immobile ; aucune attente mélodramatique |
| Tenue/lumière | continuité stricte du canon complet ; lumière quotidienne, non érotisée artificiellement |
| Audience | joueur uniquement |
| Permanence | interne Galerie si scène vécue |
| Sauvegarde/transfert | aucun fichier diégétique ; `can_share: false` |
| Galerie | `gallery_eligibility: conditional` ; `gallery_slot_behavior: deferred` |
| J14 / J21 | non / non |
| Variante | aucune ; la composition reste vraie si Player est présent hors champ, amende ou refuse |
| Interdits | robe noire J09, photo miroir, regard caméra d’envoi, Player identifiable, score de couple |

### 6.10 Brief J05-N02 — Marie continue sans compensation

| Champ | Valeur |
|---|---|
| `asset_id` | `S1_A2_J05_SCN_MARIE_SATURDAY_CONTINUES_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Statut source | `CONSOLIDATED_CANON` |
| Condition | aucune continuité extérieure admissible |
| Sujet visible | Marie |
| Fonction | servir le troisième beat sans injecter une route de remplacement |
| Moment | après l’heure ou pendant la respiration de la journée |
| Composition | Marie poursuit une action ordinaire, sans pose d’abandon ni sollicitation |
| Audience | joueur uniquement |
| Permanence | conditionnelle |
| Sauvegarde/transfert | non / non ; `can_share: false` |
| Galerie | `gallery_eligibility: conditional` ; `gallery_slot_behavior: deferred` |
| J14 / J21 | non / non |
| Variante | aucune |
| Interdits | montrer Sandra, Mathilde, Pauline, Raphaëlle ou Nico pour « remplir » ; faire du refus une punition |

### 6.11 Réutilisations J05

`S1_A1_J04_SCN_MARIE_SOCIAL_MOTION_01` est réaffiché avec le même `asset_id`.

Nouvelle fonction de lecture :

> le mouvement de Marie existait avant sa demande d’une heure ; l’heure ne crée pas sa vie propre.

La réutilisation :

- ne crée aucune nouvelle photo ;
- ne change aucune audience ;
- ne compte pas comme nouveau contenu ;
- ne signifie pas que la scène J04 se reproduit.

T01 `S1_A1_J01_DPH_SANDRA_LUNCH_SELECTED_01` est l’unique réutilisation extérieure J05. Elle :

- reste dans son emplacement existant ;
- n’est jamais jointe de nouveau ;
- ne change ni de créateur, ni d’audience, ni de permanence ;
- n’est pas appropriée par Player ;
- porte un nouvel état relationnel textuel, jamais une fausse nouveauté visuelle.

### 6.12 Verdict J05

`READY`

Le pivot Marie est obligatoire, Sandra est la seule continuité extérieure optionnelle, l’échange exact est signé dans le présent paquet, T01 est réutilisée sans nouveau fichier, les autres progressions sont fermées et le fallback reste pleinement valide.

---

## 7. Paquet complet J06 — Zéro ou une continuité extérieure

### 7.1 Identité

| Champ | Valeur |
|---|---|
| Fonction dramatique | une attention extérieure peut devenir continuité, limite ou expiration ; le retour Marie reste obligatoire |
| Question joueur | Player reconnaît-il une attention sans la convertir en propriété ou permission ? |
| Pivot | zéro ou une continuité extérieure éligible |
| Retour requis | Marie |
| État de sortie | continuité progressée/refroidie/expirée ou aucune progression ; Marie reçoit un acte, une échéance ou une vérité |

### 7.2 Règles verrouillées

- zéro ou une continuité extérieure ;
- jamais deux progressions garanties ;
- aucun `candidate_pool` ;
- aucun ticket ;
- aucun `wave_id` ;
- aucun propriétaire R2 ;
- aucune compensation automatique ;
- aucun asset générique interchangeable entre personnages.

### 7.3 Sources et statut par branche

| Branche | Source | Statut source | Action visuelle |
|---|---|---|---|
| aucune continuité | `J01_J06_SOURCE_CANON_CONSOLIDE.md`, §6 | `CONSOLIDATED_CANON` | nouveau fallback autorisé |
| Mathilde | `chapter_06_mathilde_morning_afterglow` + T05/F09 | `CONSOLIDATED_CANON` | un nouveau contenu autorisé, borné au regard remarqué |
| Sandra | ancienne fonction candidate supersédée | `REFERENCE_ONLY` | `NO_NEW_ASSET` ; progression J06 fermée |
| Pauline | ancienne préparation fonctionnelle supersédée | `REFERENCE_ONLY` | `NO_NEW_ASSET` ; progression J06 fermée |
| Raphaëlle | ancienne fonction candidate supersédée | `REFERENCE_ONLY` | `NO_NEW_ASSET` ; progression J06 fermée |
| retour Marie | consolidation J06 ; `chapter_06_marie_concrete_return` | `CONSOLIDATED_CANON` | nouveau contenu autorisé |

### 7.4 Pourquoi Mathilde seule peut recevoir un nouveau contenu extérieur

La branche Mathilde possède :

- un matériau de dialogue complet identifiable ;
- T05 `j06_mathilde_look_acknowledged_01` ;
- F09 `fact_mathilde_knows_player_noticed_her` ;
- une fonction bornée : regard remarqué, tenue ordinaire, agence maintenue.

Le nouveau visuel ne signifie pas :

- tenue choisie pour Player ;
- désir admis ;
- permission ;
- R2 ;
- route dominante.

Sandra, Pauline et Raphaëlle sont fermées comme progressions J06. Leurs anciennes fonctions candidates ne servent plus qu’à documenter le matériau supersédé ; elles ne déclenchent ni dialogue, ni réutilisation de progression, ni fallback personnalisé.

### 7.5 Personnages

| Présence | Personnages |
|---|---|
| direct conditionnel | Mathilde uniquement |
| direct obligatoire au retour | Marie |
| indirect | Player hors cadre |
| absent de la progression | Sandra, Pauline, Raphaëlle, Nico |

### 7.6 Promesse P04

P04 `j06_external_continuity_window` :

- n’existe qu’après acceptation réelle de la continuité Mathilde ;
- reste bornée à la forme exacte admise par la source Mathilde ;
- peut expirer ou être refusée ;
- ne sélectionne pas une route ;
- ne rend pas Mathilde propriétaire du bloc ;
- n’est jamais attribuée à Sandra, Pauline ou Raphaëlle en J06.

### 7.7 Matrice refus, silence, absence

| Condition | Mutation | Beat 1 | Beat 2 | Beat 3 |
|---|---|---|---|---|
| aucune continuité | vie ordinaire | J06-N02 | R-A1-13 | J06-N03 |
| Mathilde admissible | regard reconnu ou distance restaurée | J06-N01 | R-A1-13 | J06-N03 |
| branche refusée/expirée | aucune remplaçante | J06-N02 | R-A1-13 | J06-N03 |
| Sandra, Pauline ou Raphaëlle | progression fermée | J06-N02 | R-A1-13 | J06-N03 |

### 7.8 Tableau de production J06

| Beats servis | Nouveaux contenus | Réutilisations éligibles | Nouveaux fichiers sources |
|---:|---:|---:|---:|
| 3 | 3 | 2 | 3 |

### 7.9 Brief J06-N01 — Le regard Mathilde reconnu

| Champ | Valeur |
|---|---|
| `asset_id` | `S1_A2_J06_SCN_MATHILDE_LOOK_ACKNOWLEDGED_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Statut source | `CONSOLIDATED_CANON` |
| Condition | branche Mathilde réellement éligible |
| Sujet visible | Mathilde |
| Fonction | matérialiser la conscience du regard, sans intention choisie |
| Moment | matin domestique, événement physique déjà terminé avant les messages |
| Décor | cuisine ou séjour du foyer ; ancrage chargeur/document/café selon source retenue |
| Composition | Mathilde active et compétente, non posée pour Player ; Player absent |
| Posture/expression | conscience légère ou humour défensif ; pas d’offrande |
| Tenue | ordinaire selon le canon et le dialogue ; ne pas accentuer artificiellement l’exposition |
| Audience | joueur uniquement |
| Permanence | conditionnelle |
| Sauvegarde/transfert | aucun fichier diégétique ; `can_share: false` |
| Galerie | `gallery_eligibility: conditional` ; `gallery_slot_behavior: deferred` ; onglet Mathilde |
| J14 / J21 | non / non |
| Variante | aucune ; reconnaissance, plaisanterie ou distance restent textuelles |
| Interdits | pose destinée, lingerie, nudité, Marie effacée comme responsabilité, Player identifiable |

### 7.10 Brief J06-N02 — Dimanche sans progression extérieure

| Champ | Valeur |
|---|---|
| `asset_id` | `S1_A2_J06_SCN_SUNDAY_WITHOUT_EXTERNAL_PROGRESS_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Statut source | `CONSOLIDATED_CANON` |
| Condition | aucune continuité ou continuité refusée/expirée |
| Sujet visible | Marie, ou foyer sans nouveau foreground extérieur |
| Fonction | rendre crédible une journée où aucune route ne progresse |
| Composition | action ordinaire autonome ; aucune personne présentée comme compensation |
| Audience | joueur uniquement |
| Permanence | conditionnelle |
| Sauvegarde/transfert | non / non ; `can_share: false` |
| Galerie | `gallery_eligibility: conditional` ; `gallery_slot_behavior: deferred` |
| J14 / J21 | non / non |
| Variante | aucune |
| Interdits | silhouette générique remplaçable par n’importe quelle route ; solitude punitive ; promesse implicite |

### 7.11 Brief J06-N03 — Retour concret Marie

| Champ | Valeur |
|---|---|
| `asset_id` | `S1_A2_J06_SCN_MARIE_CONCRETE_RETURN_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Statut source | `CONSOLIDATED_CANON` |
| Sujet visible | Marie |
| Fonction | payer J05 et réancrer le couple après la continuité ou l’absence de continuité |
| Moment | soir J06 |
| Composition | Marie dans une action concrète ; Player absent ou non identifiable |
| Expression | lit l’acte réel, pas une route extérieure abstraite |
| Audience | joueur uniquement |
| Permanence | si retour vécu |
| Sauvegarde/transfert | non / non ; `can_share: false` |
| Galerie | `gallery_eligibility: conditional` ; `gallery_slot_behavior: deferred` ; onglet Marie |
| J14 / J21 | non / non |
| Variante | aucune ; les différences restent dans le dialogue et l’état |
| Interdits | jalousie automatique, résumé des femmes, score, compensation sexuelle |

### 7.12 Réutilisations J06

`S1_A1_J04_SCN_HOUSEHOLD_THREE_RHYTHM_01` est réaffiché avec le même `asset_id`.

Fonction J06 :

> rappeler que le foyer et Mathilde continuent d’exister même lorsqu’aucune progression extérieure n’est servie.

Cette réutilisation ne crée ni dette Mathilde, ni photo du foyer, ni permission.

`S1_A1_J02_SCN_MATHILDE_FIRST_INSTALLED_VIEW_01` reste l’ancre visuelle de continuité de la branche Mathilde :

- elle ne devient pas T02 ;
- elle n’est jamais présentée comme une photo d’arrivée ;
- elle ne prouve aucune intention ;
- elle peut être rappelée dans la mise en scène du beat J06-N01 sans ajouter un quatrième beat ni un nouveau fichier.

T01, T04 et le support Raphaëlle associé à T03 ne servent aucune progression J06.

### 7.13 Verdict J06

`READY`

Mathilde est l’unique continuité extérieure optionnelle, le chemin sans continuité est complet, Sandra/Pauline/Raphaëlle sont fermées comme progressions et Marie reçoit toujours le retour de journée.

---

## 8. Paquet complet J07 — Nico pivot, Raphaëlle secondaire, retour foyer

### 8.1 Identité

| Champ | Valeur |
|---|---|
| Titre | Lundi — Ce qu’on ne dit qu’à une personne |
| Fonction | Player révèle ce qu’il cherche auprès de Nico sans sélectionner une route |
| Pivot | Nico |
| Secondaire | Raphaëlle, obligation professionnelle |
| Retour | Marie ; Mathilde reste l’objet de l’obligation domestique, pas une progression |
| État de sortie | P05 active ; P06 active/amendée/refusée ; P08 active/amendée/refusée |

### 8.2 Autorité

`docs/canon/dialogues/J07_SCRIPT_NARRATIF_COMPLET.md` est la source directe.

| Branche | Statut |
|---|---|
| Raphaëlle, revue mobile | `SIGNED_SOURCE` |
| Nico, confidence principale | `SIGNED_SOURCE` |
| Marie, demande foyer | `SIGNED_SOURCE` |
| Mathilde, conséquence domestique indirecte | `SIGNED_SOURCE` |
| Pauline | `NO_NEW_ASSET` |
| Sandra | `NO_NEW_ASSET` |

### 8.3 Architecture

```text
11:04  Raphaëlle — obligation professionnelle
22:46  Nico — confidence principale après fermeture
23:16  Marie — demande domestique pour mardi
```

Le café matinal éventuel Marie issu de J06 ne crée aucun quatrième beat ni asset.

### 8.4 Contrôle des choix

#### Nico

Les trois postures :

1. reconnaître une contradiction ;
2. demander ce que Nico a réellement perçu ;
3. rester vague.

Les différences restent textuelles. Aucune variante visuelle.

#### Promesse Nico

- N1 : P06 active ;
- N2 : jeudi conditionnel, P06 mardi inactive ;
- N3 : P06 refusée.

Le visuel J07 ne montre aucune rencontre future comme acquise.

#### Marie

- présence mardi acceptée ;
- alternative précise ;
- refus propre.

P08 n’est active que selon le choix réel.

### 8.5 Tableau de production J07

| Beats servis | Nouveaux contenus | Réutilisations | Nouveaux fichiers sources |
|---:|---:|---:|---:|
| 3 | 3 | 1 | 3 |

Le support Acte I associé à T03 sert uniquement de référence de continuité pour la composition Raphaëlle. Il n’est ni un quatrième beat, ni une nouvelle progression.

### 8.6 Brief J07-N01 — Raphaëlle, obligation mobile

| Champ | Valeur |
|---|---|
| `asset_id` | `S1_A2_J07_SCN_RAPHAELLE_MOBILE_REVIEW_DUE_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Statut | `SIGNED_SOURCE` |
| Sujet visible | Raphaëlle |
| Fonction | créer P05 comme responsabilité professionnelle, jamais comme accès privé |
| Moment | 11:04, espaces de travail séparés |
| Décor | poste de travail crédible ; interface mobile/projet sans données sensibles lisibles |
| Composition | Raphaëlle concentrée sur un problème exact ; aucun geste de séduction |
| Audience | joueur uniquement |
| Permanence | scène vécue |
| Sauvegarde/transfert | non / non ; `can_share: false` |
| Galerie | `gallery_eligibility: conditional` ; `gallery_slot_behavior: deferred` ; onglet Raphaëlle |
| J14 / J21 | non / non |
| Variante | aucune ; le retard J03 modifie le texte, pas la composition |
| Interdits | compte créatif, costume intime, invitation privée, dette sentimentale |

### 8.7 Brief J07-N02 — Nico après la salle

| Champ | Valeur |
|---|---|
| `asset_id` | `S1_A2_J07_SCN_NICO_AFTER_SERVICE_CONFIDENCE_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Statut | `SIGNED_SOURCE` |
| Sujet visible | Nico |
| Fonction | matérialiser le pivot et le passage de l’humour à une confidence bornée |
| Moment | 22:46, L’Annexe fermée |
| Décor | salle vide, table essuyée, plannings ; tablier retiré ou desserré |
| Composition | Nico seul dans la salle ; Player ailleurs et invisible |
| Expression | humour retombé, attention directe, sans posture de thérapeute |
| Audience | joueur uniquement |
| Permanence | scène vécue |
| Sauvegarde/transfert | non / non ; `can_share: false` |
| Galerie | `gallery_eligibility: conditional` ; `gallery_slot_behavior: deferred` ; onglet Nico |
| J14 / J21 | non / non ; T06 textuelle conserve ses propres règles |
| Variante | aucune ; les trois confidences ne changent pas le moment visible |
| Interdits | alibi, image de Marie/Mathilde, permission, ambiguïté sexuelle Nico/Player |

### 8.8 Brief J07-N03 — Marie et le constat

| Champ | Valeur |
|---|---|
| `asset_id` | `S1_A2_J07_SCN_MARIE_HOUSEHOLD_REQUEST_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Statut | `SIGNED_SOURCE` |
| Sujet visible | Marie ; Mathilde peut rester indirecte |
| Fonction | ramener la journée au foyer et créer P08 seulement selon le choix |
| Moment | 23:16, Marie au foyer, Player séparé |
| Décor | appartement ; élément administratif lié au constat, sans inventer de photo |
| Composition | Marie pratique et fatiguée ; aucune tension de séduction Mathilde |
| Audience | joueur uniquement |
| Permanence | scène vécue |
| Sauvegarde/transfert | non / non ; `can_share: false` |
| Galerie | `gallery_eligibility: conditional` ; `gallery_slot_behavior: deferred` ; onglet Marie |
| J14 / J21 | non / non |
| Variante | aucune ; acceptation, amendement et refus restent textuels |
| Interdits | propriétaire en appel joué, « photos du mur », dette Mathilde, jalousie Nico |

### 8.9 Contrôle des conséquences courtes

- Sandra : aucune progression, aucun asset.
- Mathilde : concernée par le constat, sans ligne de progression.
- Pauline : absente de J07.
- Le café Marie éventuel : conséquence hors téléphone, aucun asset supplémentaire.

### 8.10 Verdict J07

`READY`

Les trois beats reposent sur un script complet signé. Aucun brief n’ajoute une progression.

---

## 9. Paquet complet J08 — Première superposition par états locaux

### 9.1 Identité

| Champ | Valeur |
|---|---|
| Titre | Mardi — Ce qui ne tient pas ensemble |
| Fonction | montrer que des attentes réelles ne se paient pas toutes de la même manière |
| États lus | P05, P06 et P08, uniquement si réellement actives |
| Familles visuelles | Raphaëlle, Nico, foyer |
| Interdit | aucune paire théorique, aucune route gagnante, aucune scène adulte |

### 9.2 Autorité

`docs/canon/dialogues/J08_SCRIPT_NARRATIF_COMPLET.md` est la source directe.

| Branche locale | Statut |
|---|---|
| Raphaëlle — travail payé | `SIGNED_SOURCE` |
| Raphaëlle — travail repris/transféré | `SIGNED_SOURCE` |
| Nico — présence courte payée | `SIGNED_SOURCE` |
| Nico — chaise rendue/non gardée | `SIGNED_SOURCE` |
| foyer — présence payée | `SIGNED_SOURCE` |
| foyer — autonomie/report/refus absorbé | `SIGNED_SOURCE` |
| Sandra | `NO_NEW_ASSET` |
| Pauline | `NO_NEW_ASSET` |
| Mathilde comme route | `NO_NEW_ASSET` ; elle reste autonomie/conséquence du foyer |

### 9.3 Règle de superposition

Une attente inactive :

- ne participe pas au conflit ;
- n’est pas transformée en attente par le visuel ;
- ne reçoit aucun message d’attente ;
- peut être représentée seulement par l’état local « aucune attente entretenue ».

Le choix vague ne crée aucune réussite cachée.

### 9.4 Tableau de production J08

| Beats servis | Nouveaux contenus principaux | Réutilisations | Nouveaux fichiers sources | Variantes conditionnelles |
|---:|---:|---:|---:|---:|
| 3 | 3 | 1 | 6 | 3 |

Chaque contenu principal possède deux fichiers locaux. Un seul fichier par famille est servi dans une partie.

T04 demeure accessible selon son état public antérieur. Cette persistance documente la vie de Pauline sans créer un beat J08, une promesse active ou une progression Pauline.

### 9.5 Contenu J08-N01 — État local Raphaëlle

| Champ commun | Valeur |
|---|---|
| `asset_id` parent | `S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Sujet | Raphaëlle |
| Fonction | matérialiser la responsabilité professionnelle, pas une route sentimentale |
| Audience | joueur uniquement |
| Sauvegarde/transfert | non / non ; `can_share: false` |
| Galerie | `gallery_eligibility: conditional` ; `gallery_slot_behavior: deferred` |
| J14 / J21 | non / non |

#### Fichier source A — Travail payé

`S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01_PAID`

- Raphaëlle ferme ou envoie la version après une relecture réellement payée.
- Le poste reste professionnel et ordonné.
- L’expression indique une tâche terminée, pas une intimité gagnée.

#### Variante V08-R — Travail repris

`S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01_TAKEN_OVER`

- Raphaëlle reprend elle-même la navigation ou la partie inachevée.
- La charge supplémentaire est visible par l’action, pas par une colère spectaculaire.
- Cette variante couvre transfert honnête et reprise après vague ; la nuance de méthode reste textuelle.

Interdits communs :

- costume, compte privé, atelier, séduction ;
- Marie ou Nico dans le cadre ;
- écran contenant une route ou un score ;
- variante séparée par paire de personnages.

### 9.6 Contenu J08-N02 — État local Nico

| Champ commun | Valeur |
|---|---|
| `asset_id` parent | `S1_A2_J08_SCN_NICO_CHAIR_STATE_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Sujet | Nico |
| Fonction | montrer si une parole simple est payée ou si Nico reprend son temps |
| Audience | joueur uniquement |
| Sauvegarde/transfert | non / non ; `can_share: false` |
| Galerie | `gallery_eligibility: conditional` ; `gallery_slot_behavior: deferred` |
| J14 / J21 | non / non |

#### Fichier source A — Présence courte payée

`S1_A2_J08_SCN_NICO_CHAIR_STATE_01_PAID`

- Nico à L’Annexe avant service.
- Player reste hors cadre et non identifiable.
- La brièveté réelle est lisible ; aucune autorisation concernant Marie ou Mathilde.

#### Variante V08-N — Chaise rendue ou non gardée

`S1_A2_J08_SCN_NICO_CHAIR_STATE_01_NO_WAIT`

- Nico remet la chaise en place ou commence son service.
- La composition reste vraie après annulation honnête, refus J07 ou attente vague terminée.
- Elle ne suggère pas qu’il a attendu si P06 n’était pas active.

Interdits communs :

- image de Marie ou Mathilde ;
- alibi ;
- punition romantique ;
- rencontre Nico/Player sexualisée ;
- variante par obligation concurrente.

### 9.7 Contenu J08-N03 — État local foyer

| Champ commun | Valeur |
|---|---|
| `asset_id` parent | `S1_A2_J08_SCN_HOUSEHOLD_STATE_01` |
| Type | `SOUVENIR_IMAGE_DE_SCÈNE` |
| Sujet | Marie ; Mathilde indirecte ou présente seulement si le moment signé le permet |
| Fonction | montrer que le foyer est payé ou agit sans Player |
| Audience | joueur uniquement |
| Sauvegarde/transfert | non / non ; `can_share: false` |
| Galerie | `gallery_eligibility: conditional` ; `gallery_slot_behavior: deferred` ; onglet Marie, et Mathilde seulement si visible |
| J14 / J21 | non / non |

#### Fichier source A — Foyer payé

`S1_A2_J08_SCN_HOUSEHOLD_STATE_01_PAID`

- Le constat est accompli avec l’aide promise.
- Player reste absent du cadre.
- Le document administratif peut être visible sans contenu lisible.
- Le remerciement Mathilde ne devient aucune dette.

#### Variante V08-F — Foyer autonome

`S1_A2_J08_SCN_HOUSEHOLD_STATE_01_AUTONOMOUS`

- Marie et/ou Mathilde ont organisé la suite sans Player.
- La composition couvre :
  - constat géré avec la voisine ;
  - attente fermée ;
  - report au mercredi après refus propre.
- Elle ne montre pas le propriétaire ou le constat mardi lorsque P08 avait été refusée.

Interdits communs :

- transformer les « photos du mur » en photo Galerie ;
- montrer Mathilde redevable ;
- dispute inventée ;
- Player identifiable ;
- variante par combinaison Raphaëlle/Nico.

### 9.8 Matrice des états locaux

| P05 | P06 | P08 | Raphaëlle | Nico | Foyer |
|---|---|---|---|---|---|
| active et payée | active et payée | active et payée | `PAID` | `PAID` | `PAID` |
| active, reprise | active, annulée | active, payée | `TAKEN_OVER` | `NO_WAIT` | `PAID` |
| active, payée | inactive/refusée | active, ratée | `PAID` | `NO_WAIT` | `AUTONOMOUS` |
| active, reprise | active, payée | inactive/refusée | `TAKEN_OVER` | `PAID` | `AUTONOMOUS` |
| active, reprise | active, vague | active, vague | `TAKEN_OVER` | `NO_WAIT` | `AUTONOMOUS` |

Cette table ne crée pas cinq paires visuelles. Elle sélectionne indépendamment un fichier dans chacune des trois familles.

### 9.9 Verdict J08

`READY`

Le script complet matérialise les états. Les six fichiers couvrent les trois fonctions locales sans explosion combinatoire.

---

## 10. Matrice d’éligibilité des continuités extérieures

### 10.1 J05–J06

| Jour | Personnage | Précondition minimale | Statut | Nouveau contenu ? | Réutilisation |
|---|---|---|---|---:|---|
| J05 | Sandra | T01 encore accessible, aucune violation, continuité non fermée | `SIGNED_SOURCE` + `NO_NEW_ASSET` | non | T01 |
| J05 | Mathilde | sans objet : progression fermée | `REFERENCE_ONLY` + `NO_NEW_ASSET` | non | aucune progression |
| J05 | Raphaëlle | sans objet : progression fermée | `REFERENCE_ONLY` + `NO_NEW_ASSET` | non | aucune progression |
| J05 | Pauline | sans objet : progression fermée | `NO_NEW_ASSET` | non | aucune |
| J05 | aucune | aucune candidate | `CONSOLIDATED_CANON` | oui, fallback | Marie Acte I fixe |
| J06 | Mathilde | scène J06 réellement admissible | `CONSOLIDATED_CANON` | oui | aucune nécessaire pour le beat extérieur |
| J06 | Sandra | sans objet : progression fermée | `REFERENCE_ONLY` + `NO_NEW_ASSET` | non | aucune progression |
| J06 | Pauline | sans objet : progression fermée | `REFERENCE_ONLY` + `NO_NEW_ASSET` | non | aucune progression |
| J06 | Raphaëlle | sans objet : progression fermée | `REFERENCE_ONLY` + `NO_NEW_ASSET` | non | aucune progression |
| J06 | aucune | branche refusée, expirée ou absente | `CONSOLIDATED_CANON` | oui, fallback | foyer Acte I fixe |

Règles :

- une ligne `REFERENCE_ONLY` documente uniquement un matériau supersédé ;
- une branche `NO_NEW_ASSET` ne déclenche jamais la création d’un dialogue, d’un fichier ou d’un état relationnel ;
- T01 avance textuellement la relation Sandra J05 parce que l’échange est `SIGNED_SOURCE`, jamais parce que l’image serait nouvelle ;
- les autres réutilisations ne font pas avancer une relation fermée ;
- une absence d’éligibilité ne fait pas passer automatiquement au personnage suivant.

### 10.2 Manifeste des branches fermées J05–J08

| Jour | Branche fermée comme progression | Statut | Conséquence autorisée |
|---|---|---|---|
| J05 | Mathilde | `REFERENCE_ONLY` + `NO_NEW_ASSET` | aucune ; le séjour continue sans mutation de route |
| J05 | Raphaëlle | `REFERENCE_ONLY` + `NO_NEW_ASSET` | aucune ; le lien reste professionnel |
| J05 | Pauline | `NO_NEW_ASSET` | aucune ; la surface publique antérieure reste vraie |
| J06 | Sandra | `REFERENCE_ONLY` + `NO_NEW_ASSET` | aucune ; l’état local obtenu en J05 peut persister sans nouvelle scène |
| J06 | Pauline | `REFERENCE_ONLY` + `NO_NEW_ASSET` | aucune ; T04 ne devient pas un accès privé |
| J06 | Raphaëlle | `REFERENCE_ONLY` + `NO_NEW_ASSET` | aucune ; aucun compte ou accès nouveau |
| J07 | Pauline | `NO_NEW_ASSET` | aucune progression |
| J07 | Sandra | `NO_NEW_ASSET` | conséquence courte ou absence seulement |
| J07 | Mathilde comme route | `NO_NEW_ASSET` | conséquence domestique indirecte dans le retour foyer |
| J08 | Sandra | `NO_NEW_ASSET` | aucun état local J08 |
| J08 | Pauline | `NO_NEW_ASSET` | aucun état local J08 |
| J08 | Mathilde comme route autonome | `NO_NEW_ASSET` | présence ou autonomie uniquement dans la famille foyer |

La fermeture d’une progression ne supprime pas le personnage du monde. Elle interdit seulement qu’un beat, une réutilisation ou un visuel fabrique une avancée non signée.

---

## 11. Registre des contenus principaux nouveaux

| # | Jour | `asset_id` | Sujet | Sources | Fichiers | Niveau |
|---:|---|---|---|---|---:|---|
| 1 | J05 | `S1_A2_J05_SCN_MARIE_REAL_HOUR_01` | Marie | 1 | 1 | M1 |
| 2 | J05 | `S1_A2_J05_SCN_MARIE_SATURDAY_CONTINUES_01` | Marie | 1 | 1 | M1 |
| 3 | J06 | `S1_A2_J06_SCN_MATHILDE_LOOK_ACKNOWLEDGED_01` | Mathilde | 1 | 1 | MT1 |
| 4 | J06 | `S1_A2_J06_SCN_SUNDAY_WITHOUT_EXTERNAL_PROGRESS_01` | Marie/foyer | 1 | 1 | M1 |
| 5 | J06 | `S1_A2_J06_SCN_MARIE_CONCRETE_RETURN_01` | Marie | 1 | 1 | M1 |
| 6 | J07 | `S1_A2_J07_SCN_RAPHAELLE_MOBILE_REVIEW_DUE_01` | Raphaëlle | 1 | 1 | R1 professionnel |
| 7 | J07 | `S1_A2_J07_SCN_NICO_AFTER_SERVICE_CONFIDENCE_01` | Nico | 1 | 1 | N1 |
| 8 | J07 | `S1_A2_J07_SCN_MARIE_HOUSEHOLD_REQUEST_01` | Marie | 1 | 1 | M1 |
| 9 | J08 | `S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01` | Raphaëlle | 2 | 2 | conséquence |
| 10 | J08 | `S1_A2_J08_SCN_NICO_CHAIR_STATE_01` | Nico | 2 | 2 | conséquence |
| 11 | J08 | `S1_A2_J08_SCN_HOUSEHOLD_STATE_01` | Marie/foyer | 2 | 2 | conséquence |
| **Total** |  | **11 contenus principaux nouveaux** |  |  | **14 fichiers sources** |  |

Tous sont :

```text
type: SOUVENIR_IMAGE_DE_SCÈNE
can_share: false
discoverable: false
transferable: false
eligible_for_j14: false
eligible_for_j21: false
gallery_eligibility: conditional
gallery_slot_behavior: deferred
```

---

## 12. Manifeste des fichiers sources et variantes

| Fichier source | Parent | Jour | Statut | Variante ? |
|---|---|---|---|---:|
| `S1_A2_J05_SCN_MARIE_REAL_HOUR_01` | même ID | J05 | requis | non |
| `S1_A2_J05_SCN_MARIE_SATURDAY_CONTINUES_01` | même ID | J05 | conditionnel sans continuité | non |
| `S1_A2_J06_SCN_MATHILDE_LOOK_ACKNOWLEDGED_01` | même ID | J06 | conditionnel Mathilde | non |
| `S1_A2_J06_SCN_SUNDAY_WITHOUT_EXTERNAL_PROGRESS_01` | même ID | J06 | conditionnel sans continuité | non |
| `S1_A2_J06_SCN_MARIE_CONCRETE_RETURN_01` | même ID | J06 | requis | non |
| `S1_A2_J07_SCN_RAPHAELLE_MOBILE_REVIEW_DUE_01` | même ID | J07 | requis | non |
| `S1_A2_J07_SCN_NICO_AFTER_SERVICE_CONFIDENCE_01` | même ID | J07 | requis | non |
| `S1_A2_J07_SCN_MARIE_HOUSEHOLD_REQUEST_01` | même ID | J07 | requis | non |
| `S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01_PAID` | `...RAPHAELLE_WORK_STATE_01` | J08 | état local | non, base |
| `S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01_TAKEN_OVER` | `...RAPHAELLE_WORK_STATE_01` | J08 | état local | oui, V08-R |
| `S1_A2_J08_SCN_NICO_CHAIR_STATE_01_PAID` | `...NICO_CHAIR_STATE_01` | J08 | état local | non, base |
| `S1_A2_J08_SCN_NICO_CHAIR_STATE_01_NO_WAIT` | `...NICO_CHAIR_STATE_01` | J08 | état local | oui, V08-N |
| `S1_A2_J08_SCN_HOUSEHOLD_STATE_01_PAID` | `...HOUSEHOLD_STATE_01` | J08 | état local | non, base |
| `S1_A2_J08_SCN_HOUSEHOLD_STATE_01_AUTONOMOUS` | `...HOUSEHOLD_STATE_01` | J08 | état local | oui, V08-F |
| **Total** |  |  | **14 fichiers** | **3 variantes** |

Il n’existe :

- aucun fichier enfant ;
- aucun nouveau `PHOTO_SET` ;
- aucune variante par couple de personnages ;
- aucune variante de simple humeur.

---

## 13. Matrice type, audience, permanence, Galerie, J14 et J21

| Groupe | Type | Audience | Permanence | Galerie | J14 | J21 |
|---|---|---|---|---|---|---|
| 11 nouveaux contenus | `SOUVENIR_IMAGE_DE_SCÈNE` | joueur | si scène/état vécu | conditionnelle, comportement différé | non | non |
| T01 réutilisée en J05 | `PHOTO_DIÉGÉTIQUE` | Sandra + Player selon état | règle T01 | selon accès original | oui si affichable | oui |
| support T02 réutilisé comme continuité Mathilde J06 | `SOUVENIR_IMAGE_DE_SCÈNE` | joueur | Acte I | onglet Mathilde | non | non |
| support T03 réutilisé comme référence de composition Raphaëlle J07 | `SOUVENIR_IMAGE_DE_SCÈNE` | joueur | Acte I | onglet Raphaëlle | non | non |
| T04 maintenue comme continuité publique antérieure | `PHOTO_SET` | audience publique/sociale originale | `PUBLIC_ACTIVE` | même parent, frame principale originale | non seule | oui |
| Marie social J04 réutilisé | `SOUVENIR_IMAGE_DE_SCÈNE` | joueur | Acte I | onglets Marie/Pauline selon origine | non | non |
| foyer J04 réutilisé | `SOUVENIR_IMAGE_DE_SCÈNE` | joueur | Acte I | onglets Marie/Mathilde | non | non |

La réutilisation ne change jamais l’éligibilité J14/J21.

---

## 14. Réutilisations et recontextualisations de l’Acte I

### 14.1 Manifeste exact T01 à T04

| Trace | Fichier/asset Acte I réutilisable | Usage Acte II | Comptage | Interdits |
|---|---|---|---:|---|
| T01 `j01_sandra_lunch_memory_soft` | `S1_A1_J01_DPH_SANDRA_LUNCH_SELECTED_01` | échange Sandra J05 uniquement, si encore accessible | 1 contenu réutilisé / 1 fichier existant | aucun renvoi, impression, sauvegarde, restauration ou changement d’audience |
| T02 `j02_mathilde_arrival_room_01` | **aucun fichier T02**, car `FACT_RECORD` ; support autorisé : `S1_A1_J02_SCN_MATHILDE_FIRST_INSTALLED_VIEW_01` | ancre de continuité de la seule branche extérieure Mathilde J06 | 1 contenu de scène réutilisé / 1 fichier existant ; T02 elle-même compte 0 | ne pas appeler le support « T02 », ne pas créer de photo d’arrivée ou de progression J05 |
| T03 `j03_marie_laverriere_setup_01` | **aucun fichier T03**, car `FACT_RECORD` ; support autorisé : `S1_A1_J03_SCN_RAPHAELLE_GARMENT_BAG_01` | référence de continuité de composition pour l’accès secondaire Raphaëlle J07 | 1 contenu de scène réutilisé / 1 fichier existant ; T03 elle-même compte 0 | ne pas créer de photo La Verrière, de progression J05/J06, de compte privé ou de nouvel accès |
| T04 `j04_pauline_bastien_public_set_01` | `S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01` + ses trois frames existantes | continuité publique antérieure maintenue accessible selon son état ; aucune progression Pauline J05–J08 | 1 contenu réutilisé / 3 fichiers existants | aucun nouveau beat de progression, crop privé, changement d’audience ou nouveau choix de frame |

### 14.2 Autres réutilisations Acte I

| Asset | Jour Acte II | Nouvelle fonction de lecture | Fichiers existants |
|---|---|---|---:|
| `S1_A1_J04_SCN_MARIE_SOCIAL_MOTION_01` | J05 | Marie possédait déjà un mouvement avant de demander une heure | 1 |
| `S1_A1_J04_SCN_HOUSEHOLD_THREE_RHYTHM_01` | J06 | le foyer continue sans progression compensatoire | 1 |

### 14.3 Comptage dédupliqué

```text
contenus Acte I réutilisés : 6
fichiers Acte I référencés : 8
```

Les six contenus sont :

1. T01 ;
2. support visuel associé à T02 ;
3. support visuel associé à T03 ;
4. T04 ;
5. Marie social J04 ;
6. foyer J04.

Les huit fichiers résultent des cinq contenus à fichier unique et des trois frames de T04.

Ce comptage documentaire ne signifie pas que les six contenus sont tous affichés dans une même partie. T01 et le support T02 peuvent participer à un beat servi ; T03 guide la continuité du beat Raphaëlle J07 ; T04 demeure le même contenu public antérieur ; les deux contenus J04 ancrent Marie et le foyer. Aucun de ces usages ne rouvre une branche fermée.

### 14.4 Réutilisations interdites

- dupliquer un ancien fichier sous un nouvel `asset_id` ;
- compter T04 comme trois contenus ;
- afficher T01 après retrait ;
- faire croire que Sandra a imprimé ou renvoyé T01 en J05 ;
- faire de T02 ou T03 une photo ;
- dériver une version privée Pauline de T04 ;
- transformer le garment bag Raphaëlle en accès au compte ;
- utiliser une image de scène comme preuve, message ou pièce jointe.

---

## 15. Contrôle des traces, promesses et connaissances J01–J08

### 15.1 Traces

| ID | Jour | Contrôle NAR-PROD-03 |
|---|---|---|
| T01 | J01 | réutilisation J05 seulement si encore accessible ; aucun renvoi, changement d’audience ou nouveau fichier |
| T02 | J02 | reste `FACT_RECORD` |
| T03 | J03 | reste `FACT_RECORD` |
| T04 | J04 | reste le même `PHOTO_SET` public |
| T05 `j06_mathilde_look_acknowledged_01` | J06 | `TEXT_MESSAGE`, jamais photo ; le nouveau contenu Mathilde est une image de scène distincte |
| T06 `j07_nico_confidence_01` | J07 | `TEXT_MESSAGE`, jamais photo ; J07-N02 n’est pas T06 |

Les « photos du mur » J08 :

- appartiennent au constat comme fait ;
- ne reçoivent aucun `trace_id` dans ce paquet ;
- ne sont ni Galerie, ni J14, ni J21.

### 15.2 Promesses

| ID | Création | Lecture |
|---|---|---|
| P03 `marie_j05_shared_hour` | seulement si Player accepte une heure | payée/amendée/refusée sans score |
| P04 `j06_external_continuity_window` | seulement après acceptation réelle de Mathilde | zéro ou une continuité ; jamais Sandra, Pauline ou Raphaëlle |
| P05 `raphaelle_j07_mobile_review` | J07 script signé | J08 uniquement si active |
| P06 `nico_j07_tuesday_1845` | J07 N1 | J08 uniquement si active |
| P07 `nico_j07_thursday_conditional` | J07 N2 | hors superposition J08 mardi |
| P08 `marie_j07_household_request` | J07 selon choix | J08 active/amendée/refusée |

### 15.3 Connaissances

| Fait | Connaisseurs | Limite |
|---|---|---|
| F08 photo Sandra vue | Sandra, Player | Marie/Nico ne savent pas |
| état local Sandra J05 | Sandra, Player selon le choix servi | attente ou limite locale ; aucune promesse et aucune route |
| F09 regard Mathilde remarqué | Mathilde, Player selon choix | ne prouve aucune intention choisie |
| F10 confidence Nico | Nico, Player | Nico ne connaît aucun fil privé non raconté |
| obligation Raphaëlle | Raphaëlle, Player | aucune dette sentimentale |
| obligation foyer | Marie, Player ; Mathilde selon organisation | aucune dette de route Mathilde |

### 15.4 Absence d’omniscience

- Nico ne voit aucune image privée.
- Raphaëlle ne diagnostique pas le couple.
- Marie ne sait rien de T01 par le seul comportement de Player.
- Pauline n’obtient aucune connaissance J07.
- Sandra n’obtient aucune connaissance par son absence J07–J08.
- Mathilde ne connaît pas la confidence Nico.

---

## 16. Couverture des refus, absences, expirations et fallbacks

| Situation | Couverture narrative | Couverture visuelle | Compensation interdite |
|---|---|---|---|
| refus Marie J05 | Marie agit seule | J05-N01 + R-A1-11 + J05-N02 si aucun extérieur | aucune route injectée |
| aucune continuité J05 | respiration | J05-N02 | aucun ticket perdu |
| Sandra J05, réponse recevable | fil maintenu avec attente ou limite locale | T01 existante seulement | aucun nouvel envoi, aveu, rendez-vous ou route |
| Sandra J05, pression/appropriation | refroidissement ; fermeture si Player insiste | T01 n’est ni renvoyée ni remplacée | aucune récompense de pression |
| aucune continuité J06 | vie ordinaire + retour Marie | J06-N02 + R-A1-13 + J06-N03 | aucune seconde candidate |
| Mathilde J06 non éligible/refusée | aucun extérieur + retour Marie | J06-N02 + R-A1-13 + J06-N03 | aucune remplaçante |
| Sandra non accessible en J05 | silence/absence | aucun beat Sandra | pas de T01 restaurée |
| Mathilde/Raphaëlle/Pauline J05 | progressions fermées | aucun beat de progression | aucune substitution |
| Sandra/Pauline/Raphaëlle J06 | progressions fermées | aucun beat de progression | aucun crop, compte, message ou rappel compensatoire |
| P06 refusée | Nico ne garde pas de chaise | J08-N02 `NO_WAIT` | aucune relance |
| P08 refusée | mercredi organisé | J08-N03 `AUTONOMOUS` | aucune punition mardi |
| choix vague J08 | autres personnages agissent | variantes `TAKEN_OVER`, `NO_WAIT`, `AUTONOMOUS` | aucune réussite cachée |

---

## 17. Galerie des contenus conditionnels absents

NAR-PROD-03 enregistre seulement :

```text
gallery_eligibility: conditional
gallery_slot_behavior: deferred
```

Le paquet ne décide pas :

- qu’un slot absent doit être supprimé ;
- qu’un slot doit apparaître `LOCKED` ;
- qu’un slot doit annoncer une route ;
- qu’une variante non vécue doit être visible.

Règles déjà applicables :

- aucun nouveau comportement UI ;
- aucun intitulé révélateur ;
- aucun onglet « Souvenir » ;
- une variante non servie n’est pas une image possédée ;
- deux onglets peuvent référencer le même `asset_id` multi-personnages ;
- cette référence ne duplique ni le contenu ni le fichier.

---

## 18. Contradictions, décisions de Ludovic et checklist finale

### 18.1 Contradictions résolues

| Contradiction | Résolution |
|---|---|
| J05 : plusieurs continuités extérieures candidates | Marie reste pivot ; Sandra seule peut maintenir le fil ; Mathilde/Raphaëlle/Pauline sont fermées |
| J06 : Sandra, Mathilde, Pauline ou Raphaëlle possibles | Mathilde seule peut progresser ; aucune continuité reste pleinement valide |
| plan J07 : Pauline ou Raphaëlle | script signé : Raphaëlle uniquement |
| plan J06 : plusieurs progressions ou propriétaire R2 | consolidation : zéro ou une continuité, aucune propriété |
| J08 théorique : toutes les paires | script signé : P05/P06/P08 et trois états locaux |
| S08 robe noire possible en Acte II | matériau robe noire déplacé vers J09 ; aucun visuel robe noire J05 |
| T05/T06 interprétables comme photos | restent `TEXT_MESSAGE` |
| « photos du mur » comme contenu | restent un fait administratif |
| T02/T03 comme assets réutilisables | impossibles : ce sont des `FACT_RECORD`; seuls leurs supports de scène distincts peuvent être réutilisés |

### 18.2 Références historiques sans effet de branche

- Sandra J05 possède désormais un échange modulaire exact `SIGNED_SOURCE`.
- Mathilde, Raphaëlle et Pauline J05 sont fermées : leurs anciens matériaux restent `REFERENCE_ONLY / NO_NEW_ASSET`.
- Sandra, Pauline et Raphaëlle J06 sont fermées : leurs anciens matériaux restent `REFERENCE_ONLY / NO_NEW_ASSET`.
- Mathilde J06 et le chemin sans continuité sont entièrement couverts par `CONSOLIDATED_CANON`.
- Aucune information manquante ne bloque J05–J08.

### 18.3 Décisions restantes à Ludovic

Aucune décision produit supplémentaire n’est requise pour rendre NAR-PROD-03 prêt.

Le comportement Galerie des contenus conditionnels absents reste volontairement différé, avec :

```text
gallery_eligibility: conditional
gallery_slot_behavior: deferred
```

Ce report appartient à un lot UI ultérieur et ne constitue pas un blocage narratif ou visuel de NAR-PROD-03.

### 18.4 Checklist avant intégration Git

#### Autorité

- [x] Le corpus signé reste prioritaire.
- [x] Le dialogue Sandra J05 est classé `SIGNED_SOURCE`.
- [x] Le seul texte dialogué ajouté est l’échange modulaire Sandra J05 validé dans le présent paquet.
- [x] Aucun dialogue signé antérieur n’a été réécrit.
- [x] Les plans historiques ne créent aucune nouvelle progression.

#### Comptage

- [x] Douze beats sont servis par partie.
- [x] Trois beats sont servis par journée.
- [x] Onze contenus principaux nouveaux sont enregistrés.
- [x] Six contenus Acte I sont réutilisés, dédupliqués.
- [x] Quatorze nouveaux fichiers sources sont requis.
- [x] Trois variantes seulement sont requises.
- [x] Le plafond de dix-neuf n’est pas traité comme cible.

#### J05–J06

- [x] J05 conserve Marie comme pivot obligatoire.
- [x] Sandra est la seule continuité extérieure optionnelle J05.
- [x] L’échange Sandra J05 réutilise T01 sans nouvel asset et crée une attente ou une limite locale.
- [x] Mathilde, Raphaëlle et Pauline sont fermées comme progressions J05.
- [x] Un refus Marie ne déclenche aucune compensation.
- [x] J06 sert zéro ou une continuité extérieure.
- [x] Mathilde est la seule continuité extérieure optionnelle J06.
- [x] Sandra, Pauline et Raphaëlle sont fermées comme progressions J06.
- [x] Marie reçoit toujours le retour J06.
- [x] Aucun `candidate_pool`, ticket, `wave_id`, propriétaire R2 ou compensation n’est introduit.
- [x] Mathilde J06 reste en dessous de l’intention choisie.

#### J07

- [x] Nico possède le pivot.
- [x] Raphaëlle porte l’obligation secondaire.
- [x] Pauline ne progresse pas.
- [x] Marie/Mathilde portent le retour foyer.
- [x] Sandra et Mathilde ne créent aucun catalogue d’assets.

#### J08

- [x] Seules P05, P06 et P08 actives sont lues.
- [x] Les variantes sont locales à Raphaëlle, Nico et foyer.
- [x] Aucune paire théorique ne possède un fichier.
- [x] Le choix vague n’est pas récompensé.
- [x] Aucune route n’est verrouillée.

#### Taxonomie

- [x] Aucun nouveau `PHOTO_DIÉGÉTIQUE`.
- [x] T02 et T03 restent des `FACT_RECORD`.
- [x] T05 et T06 restent des `TEXT_MESSAGE`.
- [x] Tous les nouveaux contenus sont `SOUVENIR_IMAGE_DE_SCÈNE`.
- [x] Tous conservent `can_share: false`.
- [x] Aucun n’est découvrable, transférable, éligible J14 ou J21.

#### Galerie et Player

- [x] Player reste non identifiable.
- [x] Aucun onglet visible « Souvenir ».
- [x] `gallery_eligibility: conditional`.
- [x] `gallery_slot_behavior: deferred`.
- [x] Aucun nouveau comportement UI.

#### Gel technique

- [x] Aucun fichier Git modifié par ce travail documentaire préparatoire.
- [x] Aucun runtime, JSON, dialogue signé antérieur, test, UI ou asset modifié.
- [x] Aucun prompt ComfyUI définitif ajouté.

---

# Synthèse finale

## Nombre de beats servis

```text
12 beats par partie
J05 : 3
J06 : 3
J07 : 3
J08 : 3
```

## Nombre de nouveaux contenus principaux

```text
11
```

Répartition :

```text
J05 : 2
J06 : 3
J07 : 3
J08 : 3
```

## Nombre de contenus réutilisés

```text
6 contenus Acte I uniques
8 fichiers Acte I existants référencés
```

Les six contenus sont T01, le support visuel distinct de T02, le support visuel distinct de T03, T04, Marie social J04 et foyer J04.

## Nombre de nouveaux fichiers sources

```text
14
```

Répartition :

```text
J05 : 2
J06 : 3
J07 : 3
J08 : 6
```

## Nombre de variantes

```text
3 variantes conditionnelles
```

- Raphaëlle J08 : travail repris ;
- Nico J08 : chaise non gardée/rendue ;
- foyer J08 : autonomie/report.

## Écart avec le plafond initial de 19 fichiers

```text
plafond initial : 19
recalcul final : 14
écart : -5
```

Cet écart est volontaire et conforme aux décisions produit :

- Sandra J05 progresse par T01 et un échange signé, sans nouveau fichier ;
- les branches fermées J05–J06 ne reçoivent aucun asset de progression ;
- aucune production pour atteindre un quota ;
- réutilisation exacte de l’Acte I ;
- aucune variante par paire.

## Décisions restantes à Ludovic

Aucune décision supplémentaire n’est requise pour NAR-PROD-03.

Le comportement Galerie conditionnel reste volontairement différé hors de ce lot et n’empêche pas le verdict `READY`.

## Verdict J05–J08

| Jour | Verdict | Motif |
|---|---|---|
| J05 | `READY` | Marie pivot obligatoire ; Sandra seule optionnelle avec échange signé et T01 ; autres progressions fermées |
| J06 | `READY` | Mathilde seule optionnelle ; chemin sans continuité valide ; retour Marie obligatoire ; autres progressions fermées |
| J07 | `READY` | trois beats directement adossés au script signé |
| J08 | `READY` | trois familles locales et six fichiers directement adossés au script signé |

**Verdict global Acte II J05–J08 : `READY`.**

**Verdict NAR-PROD-03 : `READY`.**

Le resserrement ferme toutes les branches insuffisamment matérialisées, signe l’unique échange Sandra J05 autorisé et conserve les comptages validés sans invention visuelle, adaptation runtime ou production d’asset.
