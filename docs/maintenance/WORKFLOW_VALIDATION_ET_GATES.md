# Workflow de validation et gates

> **Statut :** `ACTIVE_MAINTENANCE_POLICY`

Cette politique vise une validation proportionnée au risque. Pendant le
développement, on exécute seulement les contrôles touchés. Une unique revue
finale précède une unique gate complète avant merge ou tag.

| Type de lot | Pendant le développement | Gate finale unique |
| --- | --- | --- |
| Documentation uniquement | Liens, cohérence documentaire, `git diff --check` | Contrôles documentaires concernés; pas de smoke Godot |
| Code narratif isolé | Tests statiques et smokes R8C concernés | Gate Python globale, JSON, simulation et Godot headless standard |
| Données JSON | Validation des fichiers modifiés et tests consommateurs | Validation JSON globale, tests concernés, simulation et Godot headless standard |
| Runtime sans UI | Tests statiques/runtime ciblés et smoke du lot | Gate Python globale, JSON, simulation et Godot headless standard |
| UI/UX | Tests statiques ciblés et smokes des surfaces/résolutions touchées | Gate globale plus smokes UX réellement concernés, dont 1280×720 si cette surface est touchée |
| Lot à fort risque | Tests ciblés après chaque changement cohérent; revue renforcée si persistance, état narratif, suppression massive ou format de données | Gate globale complète une fois, avec validations supplémentaires strictement liées au risque |

## Règles durables

- Une branche cohérente par lot; éviter les micro-branches de contrôle.
- Tests ciblés pendant le développement, avec correction autonome des écarts
  mineurs.
- Une seule revue finale et une seule gate complète avant merge/tag.
- Ne pas relancer les smokes Portrait J01/J09/J12/J15/J21 ni la résolution
  1280×720 lorsqu'aucun fichier UX ou runtime joueur n'est touché.
- Toujours valider les JSON lorsqu'un fichier de données change.
- Toujours exécuter `git diff --check` avant verrouillage.
- Ajouter les contrôles anti-régression propres au domaine modifié, sans
  transformer chaque lot isolé en campagne UX exhaustive.

Un écart conceptuel majeur interrompt le lot. Un écart mineur de code, test,
formatage ou documentation est corrigé dans la branche avant l'unique gate.
