# R8C-A8 — Fenêtres d’opportunité et conflits exclusifs

> **Statut :** `IMPLEMENTED_PROTOTYPE_NON_CANONIQUE`
> **Base :** R8C-A7 verrouillé au SHA `da4b9c5ad74b86d846e37ef11a1d5c3ed5dd9f01`
> **Contenu :** bundle prototype A6 uniquement; aucun contenu Saison 1.

## Frontière A8

`R8COpportunityWindowExclusiveConflictCoordinator` regroupe un ou plusieurs
candidats A6 dans une fenêtre éphémère, puis délègue toute réservation ou
proposition au coordinateur A7. Il ne choisit aucune option : l’appelant fournit
explicitement `window_id`, `option_id` et l’intention `RESERVE` ou `PROPOSE`,
puis peut fermer le conflit avec un `option_id` retenu explicite.

Une fenêtre possède des bornes ISO date/heure, un contexte fermé
(`acte_courant`, disponibilités des participants, validité de l’opportunité) et
une ou plusieurs options. Une fenêtre à une option représente une opportunité
unique. Chaque option déclare séparément `option_id`,
`scene_definition_id`, `variant_id`, `instance_id` et sa politique de conflit.
Les identités sont authored, uniques dans la fenêtre et ne sont jamais dérivées
d’un ordre, d’un poids ou d’un total. Un même `instance_id` ne peut appartenir
qu’à une option d’une fenêtre A8 et ne peut pas reprendre une instance A5
préexistante. Le prototype borne une fenêtre à 32 options, le coordinateur à 64
fenêtres et le contexte à 32 participants aux identités et booléens validés.

## Cycle et états distincts

Les états A8 ne créent aucun nouvel état A5 :

| État A8 | Sens | A5 |
| --- | --- | --- |
| `CANDIDATE` | candidat A6 disponible, jamais retenu | aucune instance |
| `RESERVED` | réservation interne | instance `ELIGIBLE` |
| `PROPOSED` | opportunité réellement visible | instance `PROPOSED` |
| `NOT_SELECTED` | candidat non retenu silencieusement | aucune instance |
| `MISSED` | proposition visible perdue par conflit | instance `MISSED` |
| `CANCELLED` | réservation interne annulée | instance `CANCELLED` |
| `DEFERRED` | candidat éphémère conservé pour réévaluation | aucune instance |

Une simple ouverture ou réévaluation ne matérialise rien. Une réservation ne
devient jamais une absence. Seule une instance déjà `PROPOSED` peut devenir
`MISSED`; la terminaison et l’éventuelle mutation A1 restent celles d’A5.

## Politiques exclusives

- `CLOSE_SILENTLY` ferme une option jamais proposée en `NOT_SELECTED`; une
  réservation devient `CANCELLED`, sans conséquence relationnelle. Cette
  politique refuse une alternative déjà visible plutôt que de masquer son
  histoire.
- `MARK_MISSED_IF_PROPOSED` transforme uniquement une alternative `PROPOSED`
  en `MISSED`. Une réservation devient `CANCELLED`; un candidat non matérialisé
  devient `NOT_SELECTED`.
- `DEFER` conserve uniquement un candidat non matérialisé en `DEFERRED`. Une
  instance A5 ne peut pas être dépersistée et rend donc cette politique
  incompatible avec une option déjà réservée ou proposée. Sa réévaluation rend
  un verdict courant et un descripteur sans preuve ni `instance_id`; le futur
  orchestrateur peut ainsi authored une nouvelle option et une nouvelle
  identité sans transférer le cache interne A8.

Aucune autre politique n’est reconnue.

Ces politiques restent obligatoires dans une fenêtre mono-option, mais elles
n’ont aucun perdant auquel s’appliquer lorsque l’unique option est retenue.

## Revalidation, atomicité et idempotence

L’ouverture requête A6 et vérifie sa preuve fermée pour chaque identité
explicitement écrite. Chaque action reconstruit le contexte propre à
`instance_id`, requête A6 à nouveau, puis passe par A7. Avant une fermeture,
toutes les options sont rafraîchies via A6/A3 et toutes les instances
matérialisées sont rejouées idempotemment via A7. La liste complète des
transitions terminales A5 est réellement préparée via `SceneInstance` avant la
première mutation. Le commit n’applique ensuite que ces préparations déjà
validées et ne contient plus d’appel faillible.

Si la matérialisation de l’option retenue rend une alternative de la même scène
`UNIQUE` inéligible, A8 accepte uniquement cet échec précis : preuve A6 initiale
toujours valide, même définition, instance retenue propriétaire et seule raison
A3 `SCENE_DEJA_RESOLUE_OU_INSTANCIEE`. Toute autre inéligibilité annule la
fermeture avant commit.

Une fenêtre expirée, un contexte lié modifié, une provenance invalide, une
unicité devenue fausse, une horloge remontée ou une politique incompatible
refuse donc l’opération entière. Rejouer la même ouverture, action ou fermeture
rend le même résultat sans mutation; une fermeture rejouée avec une autre option
est refusée.

Le chemin `MISSED` de conflit prépare la terminaison A5 canonique après
revalidation A3/A7 et exige que la définition cible elle-même `MISSED`. Le
prototype refuse volontairement une conséquence relationnelle
`consequence_manquee` dans une fermeture A8 multi-options : A1 ne fournit pas
encore de transaction batch pour plusieurs événements. Le bundle A6 courant
n’en déclare aucune. Ce bornage préserve l’atomicité du lot au lieu de risquer
une mutation A1 partielle; un futur lot pourra lever cette limite avec une
primitive transactionnelle dédiée.

## Persistance et diagnostics

Le coordinateur conserve fenêtres, candidats et preuves uniquement en mémoire.
Il n’expose aucun snapshot A8 et ne modifie pas le schéma A5 : seules les
instances effectivement créées par A7 figurent dans `scene_registry`. Les
résumés runtime omettent candidats, preuves et diagnostics détaillés. Les
variantes `*_dev` sont limitées aux builds de développement, tests et éditeur.

## Hors périmètre et futur constructeur de journée

A8 n’ajoute ni sélection automatique, ni ranking, ni priorité numérique, ni
hasard, ni séquence, ni quota, ni topologie de journée, ni branchement Portrait
ou Saison 1. Il sait seulement représenter une fenêtre authored et appliquer un
choix explicite. Le futur constructeur de journée décidera quelles fenêtres
ouvrir et quand les présenter; il devra consommer cette API sans lui transférer
ses règles d’ordonnancement.

## Validation ciblée

```bash
python -m unittest tests.test_r8c_a1_narrative_state_static tests.test_r8c_a3_minimal_scene_prototype_static tests.test_r8c_a5_persistent_scene_registry_static tests.test_r8c_a6_minimal_narrative_library_static tests.test_r8c_a7_candidate_reservation_proposal_static tests.test_r8c_a8_opportunity_windows_exclusive_conflicts_static -v
godot --headless --path game res://tests/R8CAOpportunityWindowsExclusiveConflictsSmokeTest.tscn
```
