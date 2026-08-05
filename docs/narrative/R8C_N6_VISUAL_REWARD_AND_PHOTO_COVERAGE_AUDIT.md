# R8C-N6 — Audit des récompenses visuelles et de la couverture photo

> **Baseline :** `91af1f0795c9980d5220ae30fead67674da9cc37`
> **Portée :** 63 contenus principaux, 84 fichiers physiques, projection runtime J01–J21
> **Principe :** trois moments photo restent une cible de couverture historique, jamais un quota aveugle

## 1. Verdict

Le produit possède un manifeste visuel final cohérent et adulte : 63 contenus principaux, 84 fichiers physiques, trois payoffs V4, deux payoffs V3 et des fonctions d'image différenciées. Il ne possède cependant **aucun des 84 fichiers finaux livrés**.

La couverture actuelle est donc à trois niveaux :

1. **canon de production complet** : les 84 fichiers sont identifiés ;
2. **structure runtime partielle** : 34 parents Galerie J02–J11, six enfants J11 et des références média en conversation ;
3. **livraison finale nulle** : tous les contenus canoniques utilisent placeholders, fallbacks ou absence de présentation.

Les journées J14–J21 sont les plus sous-alimentées dans le runtime : aucune présentation Galerie et aucun média de conversation actif, alors que le canon leur attribue 24 beats visuels servis par réutilisation ou nouveaux parents. J10–J12 sont des hotspots de catalogue, pas nécessairement des journées surchargées pour le joueur : leurs alternatives doivent rester exclusives.

## 2. Comptage physique et intensité V0–V4

La classification V ci-dessous est une couche éditoriale N6 appliquée aux 84 lignes d'`ASSET-01`. Elle n'est inscrite dans aucun JSON.

| Niveau | Fichiers | Part | Lecture |
|---|---:|---:|---|
| V0 — contexte | 40 | 47,6 % | foyer, travail, monde, conséquence, respiration |
| V1 — attirance | 25 | 29,8 % | tenue, regard, présence sociale ou image chargée |
| V2 — intimité | 14 | 16,7 % | image privée, proximité, entrée ou aftercare adulte |
| V3 — explicite | 2 | 2,4 % | photos adultes Pauline et Raphaëlle |
| V4 — payoff pornographique | 3 | 3,6 % | centres sexuels Marie, Mathilde et Sandra |
| **Total** | **84** | **100 %** |  |

### 2.1 Fichiers V4

| Route | Asset | Rôle principal | Nature |
|---|---|---|---|
| Marie | `S1_A3_J11_SCN_MARIE_RECONQUEST_ADULT_PAYOFF_01` | `PORNOGRAPHIC_PAYOFF` | image de scène, non diégétique |
| Mathilde | `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_CENTRAL_01` | `PORNOGRAPHIC_PAYOFF` | image de scène, non diégétique |
| Sandra | `S1_A5_J18_SCN_SANDRA_LATE_INTIMACY_CENTRAL_01` | `PORNOGRAPHIC_PAYOFF` | image de scène, non diégétique |

### 2.2 Fichiers V3

| Route | Asset | Rôle principal | Nature |
|---|---|---|---|
| Raphaëlle | `S1_A4_J13_DPH_RAPHAELLE_MASKED_ADULT_SELECTED_01` | `EROTIC_VISUAL_REWARD` | photo diégétique, créée par Maud, choisie par Raphaëlle |
| Pauline | `S1_A5_J19_DPH_PAULINE_ADULT_COMPARTMENT_01` | `EROTIC_VISUAL_REWARD` | photo diégétique, contrôle Pauline, audience Player |

Le manifeste ne contient aucune photo sexuelle diégétique Sandra et aucune image pornographique Nico/Player. Ces absences sont des décisions de personnage, pas des trous de production.

## 3. Répartition V par projection de journée

| Jour | Fichiers | V0 | V1 | V2 | V3 | V4 | Commentaire |
|---|---:|---:|---:|---:|---:|---:|---|
| J01 | 3 | 2 | 1 | 0 | 0 | 0 | quotidien + trace Sandra |
| J02 | 3 | 3 | 0 | 0 | 0 | 0 | installation et foyer |
| J03 | 3 | 2 | 1 | 0 | 0 | 0 | travail/processus naissant |
| J04 | 6 | 5 | 1 | 0 | 0 | 0 | set social + foyer |
| J05 | 2 | 1 | 1 | 0 | 0 | 0 | troisième beat par réutilisation |
| J06 | 3 | 2 | 1 | 0 | 0 | 0 | regard Mathilde + retour Marie |
| J07 | 3 | 2 | 1 | 0 | 0 | 0 | Nico, Raphaëlle, foyer |
| J08 | 6 | 6 | 0 | 0 | 0 | 0 | conséquences locales, trois variantes |
| J09 | 4 | 0 | 3 | 1 | 0 | 0 | visibilité Marie et robe privée |
| J10 | 7 | 0 | 6 | 1 | 0 | 0 | sept alternatives de route, trois beats servis |
| J11 | 12 | 3 | 1 | 6 | 0 | 2 | deux familles V4 alternatives + conséquences |
| J12 | 7 | 5 | 2 | 0 | 0 | 0 | convergence sociale, sets à casting réel |
| J13 | 3 | 0 | 0 | 2 | 1 | 0 | Pauline/Raphaëlle mutuellement exclusives |
| J14 | 2 | 2 | 0 | 0 | 0 | 0 | découverte/absence, pas récompense |
| J15 | 4 | 1 | 3 | 0 | 0 | 0 | vies autonomes et obligations |
| J16 | 3 | 2 | 1 | 0 | 0 | 0 | départ et handoff |
| J17 | 4 | 3 | 1 | 0 | 0 | 0 | foyer transformé et couple |
| J18 | 5 | 0 | 2 | 2 | 0 | 1 | résolution Sandra, standard ou adulte |
| J19 | 3 | 0 | 0 | 2 | 1 | 0 | Pauline ou Raphaëlle foreground |
| J20 | 1 | 1 | 0 | 0 | 0 | 0 | Nico + deux réutilisations |
| J21 | 0 nouveau | 0 | 0 | 0 | 0 | 0 | trois contenus antérieurs recontextualisés |
| **Total** | **84** | **40** | **25** | **14** | **2** | **3** |  |

J21 ne constitue pas un trou de manifeste : sa fonction est de changer le sens d'une image déjà vécue. Son trou runtime est l'absence de présentation/recontextualisation réellement configurée.

## 4. Rôle principal des 63 contenus logiques

Les rôles secondaires sont conservés lorsque la branche change le sens. Les comptes ci-dessous sont exclusifs sur le rôle principal et totalisent 63 parents ; les frames et enfants physiques ne sont pas recomptés comme parents.

| Rôle principal | Parents | Content refs |
|---|---:|---|
| `NARRATIVE_TRIGGER` | 6 | J01-02, J03-02, J07-N01, J07-N03, C11-05, C16-02 |
| `RELATIONSHIP_PROOF` | 11 | J01-03, J02-02, J02-03, J03-03, J04-03, J04-04, J05-N01, J06-N03, J07-N02, C17-03, C20-01 |
| `TRUST_OR_INTIMACY_REWARD` | 7 | J06-N01, C09-04, C10-01, C10-04, C10-05, C11-04, C19-02 |
| `EROTIC_VISUAL_REWARD` | 6 | C09-02, C10-02, C11-01, C13-01, C13-02, C19-01 |
| `PORNOGRAPHIC_PAYOFF` | 3 | C11-03 maximal Mathilde, C11-06 maximal Marie, C18-02 maximal Sandra |
| `SOCIAL_TRACE` | 9 | J04-01, J04-02, C09-03, C10-06, C10-07, C12-01, C12-02, C12-03, C12-04 |
| `CONSEQUENCE_OR_ECHO` | 16 | J05-N02, J08-N01–03, C10-03, C11-02, C14-01–02, C15-01–04, C16-01, C17-01–02, C18-01 |
| `ATMOSPHERE_OR_WORLD` | 5 | J01-01, J02-01, J03-01, J06-N02, C09-01 |
| **Total** | **63** |  |

### 4.1 Rôles secondaires importants

| Contenu | Principal | Secondaire |
|---|---|---|
| J01-02 Sandra déjeuner | `NARRATIVE_TRIGGER` | `RELATIONSHIP_PROOF` |
| C09-02 Marie robe privée | `EROTIC_VISUAL_REWARD` | `TRUST_OR_INTIMACY_REWARD` |
| C11-01 Sandra choisie | `EROTIC_VISUAL_REWARD` | `RELATIONSHIP_PROOF` |
| C11-03/C11-06 branches standard | `PORNOGRAPHIC_PAYOFF` au maximum | `TRUST_OR_INTIMACY_REWARD` ou `CONSEQUENCE_OR_ECHO` si l'adulte n'est pas servi |
| C13-01 Pauline | `EROTIC_VISUAL_REWARD` | `SOCIAL_TRACE`, car dérivée d'un set légitime |
| C13-02 Raphaëlle | `EROTIC_VISUAL_REWARD` | `TRUST_OR_INTIMACY_REWARD` |
| C18-02 Sandra | `PORNOGRAPHIC_PAYOFF` au maximum | `CONSEQUENCE_OR_ECHO` dans la résolution standard |
| C19-01 Pauline | `EROTIC_VISUAL_REWARD` | `CONSEQUENCE_OR_ECHO` si l'image est retirée |

Cette classification évite de compter comme « récompense » toute image simplement regardable. Les 21 parents `CONSEQUENCE_OR_ECHO` ou `ATMOSPHERE_OR_WORLD` sont nécessaires à la respiration, mais ne compensent pas un payoff manquant.

## 5. Couverture runtime actuelle par journée

« Structure » signifie qu'un hook ou placeholder existe ; « livré » signifie un fichier final correspondant au manifeste. Le nombre livré est nul partout.

| Jour | Cible servie | Structure runtime observée | Galerie | Livré | Diagnostic |
|---|---:|---|---:|---:|---|
| J01 | 3 | 1 photo Sandra en conversation | 0 | 0 | sous-alimentée : deux moments canoniques non présentés |
| J02 | 3 | 3 parents placeholders | 3 | 0 | structure couverte, production absente |
| J03 | 3 | 3 parents placeholders | 3 | 0 | structure couverte, production absente |
| J04 | 4 | 4 parents, set social placeholder | 4 | 0 | structure couverte, six fichiers absents |
| J05 | 3 | 2 nouveaux parents + réutilisation | 2 | 0 | couverture canonique atteinte par réemploi ; pas de quota d'un troisième nouveau fichier |
| J06 | 3 | 3 parents + ancres antérieures | 3 | 0 | structure couverte, production absente |
| J07 | 3 | 3 parents | 3 | 0 | structure couverte, production absente |
| J08 | 3 | 3 parents, variantes locales | 3 | 0 | structure couverte ; six fichiers de catalogue |
| J09 | 4 | 4 parents, 3 médias conversation | 4 | 0 | structure couverte, production absente |
| J10 | 3 | 7 parents alternatifs | 7 catalogue | 0 | hotspot de branche ; ne jamais servir les sept ensemble |
| J11 | 3 | 2 parents + 6 enfants placeholders | 2 parents | 0 | dette adulte explicite ; une séquence seulement par configuration |
| J12 | 4 | 4 médias fonctionnels placeholders | 0 | 0 | fonction couverte en conversation, Galerie absente |
| J13 | 3 | 2 parents alternatifs + réutilisation | 0 | 0 | placeholders conventionnels, Galerie absente |
| J14 | 3 | texte seulement | 0 | 0 | sous-alimentée structurellement |
| J15 | 3 | texte seulement | 0 | 0 | sous-alimentée structurellement |
| J16 | 3 | texte seulement | 0 | 0 | sous-alimentée structurellement |
| J17 | 3 | texte seulement | 0 | 0 | sous-alimentée ; foyer/couple non matérialisés |
| J18 | 3 | texte seulement | 0 | 0 | sous-alimentée ; payoff Sandra absent |
| J19 | 3 | texte seulement | 0 | 0 | sous-alimentée ; payoffs/aftercare absents |
| J20 | 3 | texte seulement | 0 | 0 | sous-alimentée ; position Nico sans écho visuel |
| J21 | 3 réutilisés | texte seulement | 0 | 0 | sous-alimentée en mise en scène, pas en nouveaux assets |

### 5.1 Journées sous-alimentées

- **J01** : une photo de conversation au lieu de trois fonctions canoniques ;
- **J12–J13** : médias placeholders sans entrée Galerie ;
- **J14–J20** : aucune surface visuelle runtime active ;
- **J21** : aucune recontextualisation configurée alors que trois beats visuels existants doivent conclure la saison ;
- **toutes les journées** : zéro asset final, donc aucune n'est couverte au sens livraison.

### 5.2 Journées ou lots surchargés

- **J10** : sept parents alternatifs pour trois beats servis ; charge de production élevée, charge joueur bornée si l'exclusivité tient ;
- **J11** : douze fichiers, deux familles adultes complètes et plusieurs continuations ; plus gros hotspot d'intensité ;
- **J12** : sept fichiers et deux sets ; risque de composition universelle mensongère ;
- **J04** : six fichiers pour quatre moments, car un set contient trois frames ; pas une surcharge narrative ;
- **J18** : cinq fichiers pour deux parents alternatifs, dont une séquence adulte ; production conditionnelle à tester.

## 6. Galerie, conversation et permanence

| Surface | État observé | Règle |
|---|---|---|
| Médias en conversation | 24 occurrences authorées, environ 20 identifiants uniques, dont répétitions et au moins un ancien `FACT_RECORD` | Une référence n'est pas une livraison ; vérifier type et audience. |
| Parents Galerie J02–J11 | 34 | Tous utilisent un libellé de non-livraison ou un placeholder canonique. |
| Enfants Galerie J11 | 6 | Trois Marie, trois Mathilde ; aucun fichier final. |
| Galerie J12–J21 | 0 présentation | Trou d'intégration majeur pour les actes tardifs. |
| Images de scène | 59 fichiers prévus | Revisables après vécu ; non partageables, non découvrables comme fichiers. |
| Photos diégétiques/sets | 25 fichiers prévus | Créateur, audience, sauvegarde, transfert et retrait doivent rester actifs. |
| J21 | 0 nouveau fichier | Réutiliser sans restaurer une photo retirée ni révéler un contenu jamais vécu. |

La Galerie est un journal de contenus rencontrés, pas un distributeur. Une tuile adulte ne doit apparaître qu'après la scène ou l'image vécue ; sa miniature ne doit pas révéler le contenu avant déblocage.

## 7. Assets existants et manquants

### 7.1 Fichiers physiques

| Catégorie | Existant | Manquant |
|---|---:|---:|
| Assets finaux du manifeste | 0 | 84 |
| Prototypes PNG V0.95/V0.96 | 14 | — |
| Asset **Les chaises bleues** hors manifeste | 0 | 1 si activation |

Les 14 prototypes sont répartis ainsi : Marie 5, Mathilde 4, Sandra 4, Pauline 1, Raphaëlle 0, Nico 0. Ils ne portent pas les identifiants finaux d'`ASSET-01` et ne sont pas référencés par les maps canoniques J09/J10 ; ils restent des preuves historiques, pas des fichiers livrés.

### 7.2 Apparitions à produire par personnage

Les comptes se chevauchent pour les groupes.

| Personnage | Fichiers du manifeste où il/elle est sujet nommé | Prototypes physiques | Fichiers finaux livrés |
|---|---:|---:|---:|
| Marie | 32 | 5 | 0 |
| Sandra | 10 | 4 | 0 |
| Mathilde | 16 | 4 | 0 |
| Pauline | 9 | 1 | 0 |
| Raphaëlle | 11 | 0 | 0 |
| Nico | 6 | 0 | 0 |

## 8. Besoins de production visuelle

| Besoin | Quantité | Priorité |
|---|---:|---|
| Références personnages validées | 6 principaux + Player hors cadre | bloque toute cohérence d'asset |
| Références lieux | appartement, La Verrière, L'Annexe, travail Sandra, atelier Raphaëlle, extérieurs Sandra | bloque les vagues par acte |
| Fichiers V0–V1 | 65 | socle visual-first et continuité |
| Fichiers V2 | 14 | récompenses intimes et aftercares |
| Fichiers V3 | 2 | Pauline/Raphaëlle adultes |
| Fichiers V4 | 3 | Marie/Mathilde/Sandra centraux |
| Frames de sets | 9 | continuité casting/audience |
| QA audience/retrait/Galerie | 25 fichiers diégétiques/sets | bloque l'intégration propre |
| Asset **Les chaises bleues** | 1 hors manifeste | seulement si activation N5 décidée |

Produire les 84 fichiers dans l'ordre numérique brut serait une erreur. Les références, lieux, sets et séquences adultes doivent être verrouillés avant les vagues ; les jours restent une projection de contrôle, pas l'architecture de production.

## 9. Hypothèses conservatrices

- V4 est réservé aux trois images centrales de sexualité complète/bornée ; nudité frontale seule reste V3.
- Une entrée ou un aftercare adulte reste V2 même si la scène globale atteint V4.
- Les variantes et frames comptent comme fichiers physiques mais pas comme moments principaux indépendants.
- Un média conversation référencé sans fichier final compte comme structure, jamais comme asset existant.
- Les 14 PNG prototypes ne réduisent pas le manque de 84 fichiers.
- J21 reste à zéro nouveau fichier ; son besoin est la réutilisation contrôlée.
- Une journée à trois contenus V0 décoratifs n'est pas déclarée couverte sur l'axe récompense.
- Les catalogues alternatifs J10/J11/J19 ne sont pas additionnés dans une partie.

## 10. Conclusion

La couverture cible est éditorialement solide : 77,4 % de fichiers V0–V1 construisent le monde et l'attirance, 16,7 % portent l'intimité, et cinq fichiers V3–V4 délivrent les payoffs adultes les plus élevés. Le défaut n'est pas un manque de volume prévu ; c'est l'absence totale de livraison finale et la disparition progressive des hooks visuels du runtime après J13. La production doit donc matérialiser le manifeste existant, préserver les fonctions et reconnecter les actes tardifs à la Galerie, sans inventer des photos pour remplir un calendrier.
