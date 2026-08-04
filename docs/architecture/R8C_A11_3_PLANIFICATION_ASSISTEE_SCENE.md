# R8C-A11.3 — Vertical slice de planification assistée d’une scène

> **Statut :** `IMPLEMENTED_PROTOTYPE_NON_CANONIQUE`
> **Parent obligatoire :** `960854de1f04661fb30aec2208799c630955b082`
> **Dépendances :** A11.1 et A11.2, sans brouillon, export A6 ni connexion runtime.

## Responsabilité

A11.3 transforme une intention narrative humaine en plan structuré par une
chaîne hors ligne explicite :

`intention humaine → diagnostic → options bornées → sélection humaine → plan → validation → relecture humaine`

Le slice ne produit aucun texte final de scène. Il ne crée ni décision majeure
autonome, ni état persistant, ni effet de jeu. Une approbation signifie
seulement que le plan exact peut alimenter ultérieurement une génération de
brouillon.

[`tools/a11_scene_planning.py`](../../tools/a11_scene_planning.py) contient le
validateur fermé, les projections de lecture de chaque étape et le smoke CLI.
Le cas unique est
[`sandra_recontact_after_silence.json`](../../narrative_tool/a11/planning/sandra_recontact_after_silence.json).

## Réutilisation d’A11.1 et A11.2

A11.3 réutilise sans modification :

- `Issue(code, path, message)` d’A11.1 pour tous les diagnostics localisés;
- `R8C_A11_CHARACTER_SHEET` pour la fiche Sandra;
- `R8C_A11_RELATIONSHIP_CALIBRATION_REGISTER` pour la mémoire relationnelle,
  les limites, les mouvements et les états locaux;
- les trois cas A11.2 afin de relire le plan Sandra sous les contrats Sandra,
  Marie et Mathilde.

`R8C_A11_SCENE_PLAN` A11.1 n’est pas réutilisé. Son contrat impose un choix avec
formulations de bulles, un média et une projection A6, puis alimente un
brouillon long. Il ne peut pas distinguer le diagnostic, les informations
sélectionnables et les décisions humaines qui précèdent le plan A11.3.

## Extension de format unique

Le seul nouveau format est `R8C_A11_ASSISTED_SCENE_PLANNING`, `version: 1`.
Il est fermé à chaque niveau et agrège le cas de travail complet pour que la
sélection humaine et la relecture portent sur le même plan.

| Section | Contenu | Invariant protégé |
| --- | --- | --- |
| `intention` | texte auteur, participants actifs, personnages contextuels, mouvement recherché et contrainte d’indirection | l’intention humaine reste la source |
| `diagnostic.present_information` | informations déjà disponibles et leurs sources | aucune invention silencieuse |
| `diagnostic.selectable_information_gaps` | une à trois options ordonnées par décision | assistance bornée sans choix automatique |
| `diagnostic.mandatory_human_decision_ids` | ordre exact des décisions requises | aucune sélection omise |
| `human_selection` | auteur humain et option retenue par décision | origine humaine explicite |
| `plan` | sept battements, faits, limites, mouvements, changement maximal, choix éventuel, réception et sortie | plan relisible sans bulles finales |
| `human_review` | statut, relecteur, empreinte et notes | approbation du plan exact |

L’empreinte SHA-256 couvre l’intention, le diagnostic, les sélections humaines,
le plan et `a11-planning-validator-1.0`. Toute modification révoque donc la
relecture précédente.

## Intention et diagnostic du prototype

Intention humaine :

> Player reprend contact avec Sandra après plusieurs jours de silence. Il veut
> vérifier que leur rapprochement récent n’était pas seulement un moment isolé,
> sans lui demander frontalement ce qu’elle ressent.

Le diagnostic enregistre comme présents les participants, le silence, le but
indirect et la stratégie prudente de Sandra. Trois informations restent
sélectionnables : l’accroche concrète, le changement maximal et la présence
d’un choix de positionnement.

Les options restent dans l’ordre auteur et aucune fonction ne choisit à la
place de l’auteur. La fixture enregistre ces sélections humaines :

1. ticket de cinéma plié;
2. rendez-vous ultérieur seulement possible;
3. un choix de positionnement de Player.

## Plan Sandra

Le plan comporte sept battements :

| Battement | Fonction | Moteur |
| --- | --- | --- |
| `concrete_hook` | accroche concrète par le ticket plié | Player revient avec précaution |
| `calibration` | Sandra mesure le retour après le silence | Sandra détourne avec humour |
| `indirect_reopening` | Player laisse visible l’importance du rapprochement sans demande | Player reste prudent |
| `sandra_test` | Sandra teste sa manière de revenir | Sandra détourne et relance la mémoire |
| `player_positioning` | choix éventuel du degré d’explicitation | Player se positionne sans revendication |
| `reception` | Sandra reçoit l’attitude choisie | Sandra garde sa réserve et décide de prolonger |
| `protective_exit` | sortie concrète laissant un rendez-vous seulement possible | Sandra clôt sans punition |

Les objectifs sont asymétriques. Player cherche un indice de continuité;
Sandra vérifie qu’il peut reprendre le lien sans convertir la proximité en
droit acquis. Le risque local est une indirection perçue comme commode ou
exigeante. Le changement maximal reste un rendez-vous possible sans date ni
promesse.

Les seuls faits utilisables sont `sandra_folded_ticket` et
`sandra_current_distance`. Les faits privés de Marie et Mathilde sont
explicitement interdits. Aucun média n’est requis.

## Validation

Les erreurs bloquantes couvrent : participant inattendu, registre absent,
objectif manquant, battement sans fonction ou mouvement, fait inconnu, limite
violée, changement maximal dépassé, conséquence interdite, choix sans
réception, média injustifié, fermeture punitive, bulle finale écrite dans le
plan et approbation humaine absente.

Les avertissements couvrent : accroche abstraite, objectifs symétriques,
battements redondants, risque absent, sortie trop parfaite, évolution trop
importante, plan interchangeable, Player moteur de tout et Sandra limitée à la
réaction. Aucun résultat agrégé n’est calculé.

## Spécificité structurelle

`validate_plan_against_relationship` relit le même plan sous chaque registre
A11.2 sans interpréter son vocabulaire. Le contrat Sandra l’accepte. Les
contrats Marie et Mathilde produisent chacun les cinq familles suivantes :

- mémoire relationnelle incompatible;
- stratégie d’esquive ou état local incompatible;
- nature de proximité incompatible;
- limites relationnelles incompatibles;
- mouvements relationnels incompatibles.

La preuve subsiste si les résumés de battements sont remplacés par du texte
éditorial neutre, car elle dépend des références structurées.

## Relecture humaine

La fiche
[`sandra_recontact_after_silence.human_review.md`](../../narrative_tool/a11/planning/sandra_recontact_after_silence.human_review.md)
expose quatre statuts :

- `DRAFT`;
- `NEEDS_REVISION`;
- `APPROVED_FOR_DRAFT_GENERATION`;
- `REJECTED`.

Le prototype porte `APPROVED_FOR_DRAFT_GENERATION` et l’empreinte exacte du
plan. Cette décision ne lance aucune commande et ne produit aucun fichier de
jeu.

## Commandes ciblées

```powershell
python -m unittest tests.test_r8c_a11_3_assisted_scene_planning -v
python -m unittest tests.test_r8c_a11_authoring_workshop tests.test_r8c_a11_2_voice_relationship_calibration -v
python tools/a11_scene_planning.py validate-json
python tools/a11_scene_planning.py smoke
git diff --check
```

La gate finale ajoute la suite Python globale, `validate_game_data.py`,
`simulate_route_paths.py` et les contrôles statiques du lot. Aucun fichier
chargé par Godot n’est modifié; les smokes portrait et résolution restent hors
périmètre.
