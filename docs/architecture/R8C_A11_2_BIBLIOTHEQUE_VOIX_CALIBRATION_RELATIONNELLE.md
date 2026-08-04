# R8C-A11.2 — Bibliothèque de voix et calibration relationnelle

> **Statut :** `IMPLEMENTED_PROTOTYPE_NON_CANONIQUE`
> **Parent obligatoire :** `952198ed4bcbce82f8693b88aaf15bd83f4465f1`
> **Dépendance :** A11.1, sans export A6 supplémentaire.

## Responsabilité

A11.2 protège trois voix dans trois relations actives : Sandra–Player,
Marie–Player et Mathilde–Player. Le lot reste un outil éditorial hors ligne. Il
ne produit aucune scène jouable, ne charge aucun état du jeu, ne persiste rien
et ne contacte aucun service de génération.

Le registre Sandra–Marie A11.1 reste contextuel. A11.2 ne crée ni registre
croisé supplémentaire, ni matrice générale des personnages.

## Réutilisation d'A11.1

Les trois contrats emploient sans modification le format fermé
`R8C_A11_CHARACTER_SHEET` et son validateur A11.1. Chaque fiche conserve la
structure `role`, `voice`, `known_facts`, `unknown_facts`.

Le brouillon `R8C_A11_DIALOGUE_DRAFT` n'est pas réutilisé : il décrit une scène
longue avec choix et projection, tandis que les preuves A11.2 sont des corpus
de 8 à 14 bulles sans scène, choix, média ni export.

## Extensions de format justifiées

Deux formats fermés, versionnés `1`, ajoutent uniquement les invariants absents
d'A11.1 :

| Format | Contenu | Invariant non représentable en A11.1 |
| --- | --- | --- |
| `R8C_A11_RELATIONSHIP_CALIBRATION_REGISTER` | une relation Player, faits partagés identifiés, limites identifiées, mouvements relationnels et au moins deux états locaux | A11.1 possède des limites textuelles mais aucun mouvement relationnel ni stratégie dépendante de l'état local |
| `R8C_A11_VOICE_CALIBRATION_CASE` | personnage et relation actifs, état local, sélections utiles, preuves de règles de voix et 8–14 bulles annotées | le brouillon A11.1 impose une scène de 45–70 bulles et ne peut pas exprimer une preuve courte croisée sans export |

Ces formats ne décrivent pas une personnalité générique. Ils sont bornés à
trois cas nommés et à trois relations Player actives.

## Contrats et différences encodées

### Sandra

- amitié et complicité antérieures à Marie ;
- distance actuelle et manque indirect ;
- humour ou détour comme première protection ;
- intérêt visible par mémoire, relance et prolongation ;
- progression lente, sans séduction instantanée.

### Marie

- ancre du couple et cœur dramatique du quotidien ;
- voix directe, mémoire d'habitudes et d'engagements ;
- intimité jamais présumée acquise ;
- réparation honnête laissée ouverte sans pardon automatique ;
- aucun sexe ou reconquête comme récompense, aucune jalousie générique.

### Mathilde

- regard situé dans l'espace domestique et ambiguïté révocable ;
- autonomie matérialisée par une sortie réelle ;
- aucune disponibilité érotique ou répétition supposée ;
- M-B1 sans sexualité, M-B2 distinct de M-B3 ;
- arrêt non punitif et départ indépendant conservé jusque dans M-B3.

## Corpus communs et réalisations distinctes

Les trois corpus comptent dix bulles. Player revient après un retard et tente
une ouverture légèrement personnelle.

- Sandra détourne par l'abribus, relance par un ticket ancien, puis prolonge par
  une question banale. Le manque n'est jamais déclaré.
- Marie nomme le retard, rappelle une promesse et des habitudes du foyer, puis
  demande dix minutes de présence sans conclure la réparation.
- Mathilde part de la tasse, de la porte et de sa clé, sépare explicitement le
  précédent du choix présent, puis reste dix minutes avec son départ intact.

## Validation croisée

Chaque corpus est validé contre son contrat et son registre. Il est ensuite
présenté aux deux contrats étrangers. Les incompatibilités sont localisées par
chemin JSON et portent sur plusieurs catégories :

- règle de voix non disponible ;
- fait relationnel non disponible ;
- limite incompatible ou requise mais absente ;
- mouvement étranger ou absent de l'état local ;
- personnage, paire ou locuteur incompatibles.

Le texte seul ne décide donc jamais de la non-interchangeabilité. Les
annotations structurées relient chaque bulle à des faits, mouvements et limites
revus humainement. Aucun résultat numérique n'est calculé ou agrégé.

## Contexte minimal compilé

`compile_minimal_context` émet exactement six sections :

1. personnage actif, limité à l'identité, au rôle et à la voix ;
2. registre Player actif, limité à l'identité, à la paire et à la nature ;
3. état local sélectionné ;
4. faits utiles sélectionnés ;
5. limites utiles sélectionnées ;
6. mouvements attendus sélectionnés.

Les autres personnages, relations, faits, secrets et corpus ne sont pas émis.
Un autre état local change la stratégie et les mouvements, sans modifier la
section de voix du personnage.

## Lecture humaine en aveugle

Le dossier `narrative_tool/a11/calibration/dossier_lecture_aveugle.md` expose
Voix A, Voix B et Voix C, puis une fiche vide d'attribution et de justification.
Le lecteur doit citer relation, mouvement, limite et fait ; aucun résultat
automatique n'est produit.

## Commandes ciblées

```powershell
python -m unittest tests.test_r8c_a11_2_voice_relationship_calibration -v
python -m unittest tests.test_r8c_a11_authoring_workshop -v
python tools/a11_voice_calibration.py validate-json
python tools/a11_voice_calibration.py smoke
git diff --check
```

La gate finale ajoute la suite Python globale, `validate_game_data.py` et
`simulate_route_paths.py`. Aucun fichier chargé par Godot n'étant modifié, un
smoke Godot n'est ni requis ni lancé pour ce lot.
