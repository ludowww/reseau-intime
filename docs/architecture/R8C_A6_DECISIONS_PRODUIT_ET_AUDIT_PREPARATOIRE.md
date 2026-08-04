# R8C-A6 — Décisions produit et audit préparatoire

> **Statut :** `DOCUMENTATION_ONLY_AWAITING_PRODUCT_APPROVAL`
> **Base :** R8C-A5 verrouillé au SHA `bf443e35edd563d87270ba8980736642794b9985`
> **Interdiction :** aucune implémentation runtime A6, aucun branchement joueur et aucun démarrage A7.

## Verdict recommandé

| Décision | Recommandation | Effet de borne |
| --- | --- | --- |
| Source initiale | Bundle JSON data-first, versionné et strictement validé sous `res://data/narrative_scenes/`. | Une seule source de définitions; aucun `Resource` custom ni dictionnaire runtime dupliqué. |
| Diagnostics refusés | Complets uniquement en développement, tests et outils d'auteur. | Aucune mécanique interne, raison de refus ou volume de candidats exposé au joueur. |
| Identité des variantes | `variant_id` stable et explicite, distinct de `scene_definition_id`. | Identité structurée, sans concaténation fragile et sans modifier l'unicité A5 par accident. |
| Passage candidat → instance | À la réservation/proposition réelle, après revalidation; jamais pendant la requête. | Une compatibilité non retenue ne crée ni identité persistée, ni absence narrative, ni consommation `UNIQUE`. |

Ces quatre recommandations forment un ensemble cohérent. Elles gardent A6 comme
frontière de lecture et laissent à un futur consommateur la responsabilité de
réserver ou proposer une scène. Elles attendent encore une validation produit
explicite avant toute implémentation.

## 1. Source initiale des définitions

### Recommandation

Créer lors du futur lot un petit bundle, par exemple
`res://data/narrative_scenes/r8c_a6_synthetic_library.json`, avec une racine
fermée et versionnée contenant trois à cinq définitions synthétiques. Le chemin
est explicite; la bibliothèque ne scanne pas un dossier et ne découvre pas de
contenu par convention implicite.

La racine proposée contient exactement `format`, `version` et `definitions`,
avec `format == "R8C_A6_SCENE_LIBRARY"`, `version == 1` et un tableau borné de
définitions. Ce format de catalogue reste distinct du snapshot A5.

Le chargement suit une seule chaîne :

1. `DataLoader.load_json` lit l'objet JSON à un chemin explicite sous
   `res://data/` ;
2. A6 valide la version et les champs exacts de la racine ;
3. `SceneDefinition.valider` valide chaque définition A3 ;
4. l'index candidat n'est publié qu'après validation complète du bundle.

Il ne faut ni `Resource` custom, ni copie des mêmes définitions dans un script,
ni tolérance partielle. Un échec invalide toute la bibliothèque.

### Justification

- A3 consomme déjà des dictionnaires issus de JSON et possède le validateur de
  définition; A6 n'a pas à créer un second schéma métier.
- A5 ferme son snapshot et construit ses candidats avant publication; la même
  atomicité doit s'appliquer au catalogue.
- `DataLoader` protège aujourd'hui la frontière `res://data/`, mais ne valide
  pas la sémantique narrative. Lui ajouter cette sémantique créerait un loader
  universel et couplerait le runtime Portrait à A6.
- Le futur constructeur de journée disposera d'une source inspectable et
  déterministe, sans dépendre de l'ordre des scripts ou de ressources Godot.

## 2. Visibilité des diagnostics refusés

### Recommandation

La requête de production renvoie seulement les candidats compatibles et leur
diagnostic A3 utile au moteur. Une variante de diagnostic réservée aux builds de
développement, aux tests et aux outils d'auteur peut rendre les refus complets.
Ces refus ne sont ni journalisés systématiquement en production, ni copiés dans
un état joueur, une sauvegarde, une télémétrie ou une surface UI.

### Justification

- A2 exige l'inspectabilité pour les outils de debug, pas l'exposition des
  mécaniques internes au joueur.
- A3 produit déjà des codes de raisons structurés; les recalculer ou les
  reformuler dans A6 créerait une seconde vérité.
- A5 ne persiste que les instances et opportunités réelles. Persister les refus
  de recherche transformerait des calculs éphémères en histoire narrative.
- Le futur constructeur de journée pourra expliquer ses entrées en debug sans
  faire des diagnostics une préférence, une priorité ou un score caché.

## 3. Identité des variantes

### Recommandation

Une variante possède un `variant_id` authored, stable et explicite. Il reste
distinct de `scene_definition_id` et de `definition_version`. Les résultats de
requête et les tris manipulent une structure avec ces champs séparés; ils ne
fabriquent pas une clé par concaténation de chaînes.

`scene_definition_id` reprend la valeur A3 `scene_id`; le nom correspond à sa
projection persistée A5 et ne renomme pas le champ du contrat A3. En l'absence
de variante, le résultat porte `variant_id: null`. Si une variante est ajoutée
plus tard, son identifiant est une chaîne authored et non une clé dérivée.

Le lot A6 minimal n'a pas besoin d'inventer plusieurs variantes. Il doit
seulement verrouiller la forme de l'identité afin qu'une extension ultérieure ne
réinterprète pas `scene_id`. L'unicité A5 continue de porter sur la définition de
scène; un `variant_id` ne permet jamais de contourner une politique `UNIQUE`.

### Justification

- A3 distingue déjà définition et instance. Une variante est une troisième
  identité et ne doit usurper aucune des deux.
- A5 persiste `scene_definition_id` et reconstruit l'unicité à partir de cette
  identité. Une variante ne doit pas créer implicitement une nouvelle scène
  durable ni exiger maintenant une version 2 du snapshot.
- Une clé structurée évite les collisions de séparateurs, les renommages
  difficiles et les dépendances aux conventions de chaînes.
- Le futur constructeur de journée pourra comparer ou présenter des variantes
  authored sans les confondre avec des scènes concurrentes.

## 4. Moment où un candidat devient une instance A5

### Recommandation

`query_candidates` est strictement en lecture seule : il ne crée pas
`instance_id`, n'appelle pas `creer_instance` et ne réserve rien. Un candidat
compatible reste une valeur éphémère tant qu'un consommateur futur ne prend pas
un engagement réel de réservation/proposition.

La création d'instance intervient après la sélection externe au catalogue et
une dernière revalidation, au moment où la scène est effectivement réservée
pour être proposée ou proposée immédiatement. Une simple compatibilité, un tri,
un aperçu d'auteur ou une scène non retenue ne crée aucune instance. Tant que le
moteur ne possède pas un état de réservation explicite, une réservation douce
ne doit pas anticiper la création A5.

### Justification

- A2 interdit de transformer une scène non sélectionnée en occasion manquée.
- A3 ne permet `MISSED` qu'après `PROPOSED`; A6 doit préserver cette preuve de
  visibilité au lieu de matérialiser tous les candidats.
- A5 rend toute occurrence `UNIQUE` durable dans son registre. Instancier lors
  d'une recherche consommerait donc l'unicité sans engagement narratif réel.
- Le futur constructeur de journée pourra comparer plusieurs candidats sans
  polluer le snapshot. Seule sa décision explicite franchira la frontière A5.

## Inventaire non destructif des 88 JSON

| Famille actuelle | Nombre | Utilité future possible | Décision A6 |
| --- | ---: | --- | --- |
| `conversations/` | 46 | Dialogues, segments, fils et contenu authored à référencer plus tard. | Pas des définitions A3; aucune ingestion ou migration automatique. |
| `runtime/season_1/` | 21 | Oracle historique de fenêtres, transitions, présentations et chemins explicites. | Source d'audit seulement; jamais une bibliothèque A6 ni un constructeur futur. |
| `visual_content/` | 12 | Catalogue média et preuves visuelles pouvant valider de futures références de contenu. | Hors requête de compatibilité; reste derrière `DataLoader.get_visual_content`. |
| `characters/` | 7 | Identités, voix et métadonnées utiles à de futurs contrôles d'auteur. | Pas une source de scènes; aucun couplage au catalogue minimal. |
| `writing/` | 2 | Profils de voix et état de connaissance pour l'aide à l'écriture. | Documentation/outillage, pas vérité runtime A6. |

Total : **88 fichiers**, tous conservés sans modification. Aucun n'expose la
forme fermée d'une définition A3 (`scene_id`, `version_contrat`, participants,
conditions, exclusions, contrat temporel, unicité et résolutions). Les quelques
champs historiques nommés `scene_id` dans des conversations ne suffisent pas à
en faire des définitions et ne doivent pas être promus implicitement.

## Frontière actuelle de `DataLoader`

`DataLoader` est un autoload du runtime Portrait. `load_json` :

- normalise le chemin et refuse ce qui sort de `res://data/` ;
- exige un fichier existant ;
- exige une racine JSON de type objet `Dictionary` ;
- retourne un objet ou `{}` et accumule une erreur technique ;
- ne valide ni version, ni champs exacts, ni définitions A3 ;
- ne scanne aucun dossier narratif.

A6 doit donc appeler ce lecteur sans modifier `load_all`, qui reste réservé au
catalogue visuel historique. Le bundle A6 doit avoir une racine objet, même si
ses définitions sont stockées dans un tableau. La bibliothèque traite `{}`, une
version inconnue, un champ supplémentaire, une définition invalide, un doublon
ou une identité ambiguë comme un échec atomique.

## API minimale proposée, non implémentée

```gdscript
R8CSceneDefinitionLibrary.charger_depuis_json(path: String) -> Dictionary
# {ok, erreur, bibliotheque}

bibliotheque.obtenir_definition(scene_definition_id: String) -> Dictionary
bibliotheque.obtenir_ids_tries() -> Array[String]

bibliotheque.query_candidates(
    moteur,
    etat_narratif,
    contexte: Dictionary
) -> Dictionary
# {ok, erreur, candidats: [{scene_definition_id, definition_version,
#  variant_id, diagnostic}]}

bibliotheque.query_candidates_dev(
    moteur,
    etat_narratif,
    contexte: Dictionary
) -> Dictionary
# Même résultat, plus diagnostics_refuses; dev/tests seulement.
```

La construction valide le bundle entier avant de rendre la bibliothèque. La
requête parcourt l'index stable, délègue chaque évaluation à
`MinimalSceneEngine.evaluer_definition`, conserve uniquement les diagnostics
retournés et trie par tuple structuré. Elle n'effectue aucune sélection,
priorité, pondération, randomisation, instanciation ou mutation.

## Gate produit restante

Avant toute implémentation A6, la validation produit doit confirmer ensemble :

- le bundle JSON data-first et son emplacement dédié ;
- la séparation stricte entre diagnostics moteur et visibilité joueur ;
- l'identité de variante structurée sans changement du snapshot A5 ;
- la frontière candidat/instance au seul engagement réel de proposition.

A6 restera non mergé et non tagué jusque-là. R8C-A7, le constructeur de journée,
la sélection et toute évolution UX restent hors périmètre.
