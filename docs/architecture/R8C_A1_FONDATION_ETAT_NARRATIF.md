# R8C-A1 — Fondation commune de l'état narratif

## Objectif et architecture

Ce lot crée un noyau autonome pour le futur moteur narratif. `EtatNarratif` possède l'état, orchestre les transactions et expose seulement la construction synthétique, le traitement d'un événement et la lecture d'un snapshot. `EtatRelationCentrale` et `EtatRelation` construisent et valident leurs structures. `ReducerRelation` est l'unique composant qui écrit les champs relationnels dans un état candidat.

Les quatre composants étendent `RefCounted`. Ce choix fournit des objets légers à durée de vie bornée sans introduire la sérialisation, l'inspection éditoriale ou l'identité d'asset d'un `Resource`, qui ne sont pas nécessaires à cette fondation.

## État initial synthétique

La construction exige une relation centrale explicite et valide : aucun statut de couple n'est inventé. La progression est une structure synthétique sans calendrier historique. Les registres sont vides. Six relations existent exactement (`marie`, `sandra`, `mathilde`, `pauline`, `raphaelle`, `nico`) ; aucune relation individuelle n'est créée pour Player. Leurs axes ordinaires commencent à `null`, sauf `nico.desir`, fixé à `NONE`.

## Transaction, idempotence et encapsulation

Un événement entrant est copié profondément, puis son enveloppe, sa provenance et son type provisoire sont validés. Le rejeu compare récursivement dictionnaires et tableaux, sans dépendre de l'ordre d'insertion des clés. Un identifiant déjà associé au même contenu retourne `IDEMPOTENT`; un contenu différent est rejeté.

Pour un nouvel identifiant, l'état est copié profondément. Le reducer prépare les mutations relationnelles sur cette copie, puis l'état candidat complet est validé. L'événement copié n'est ajouté au registre et l'état interne n'est remplacé qu'après succès. Tout rejet conserve donc un snapshot strictement identique. Les snapshots et événements enregistrés sont également protégés par copie profonde, de sorte qu'aucun dictionnaire ou tableau interne mutable ne quitte l'API.

## Invariants couverts

La relation centrale borne séparément statut du couple, contrat, divulgation et relation après séparation. `ENSEMBLE` exige un contrat et interdit une relation post-séparation. `SEPARES` interdit un contrat actif et exige une relation post-séparation. `EN_CLARIFICATION` accepte l'absence ou la présence d'un contrat. La divulgation n'entraîne aucune mutation automatique du contrat. Un contrat `PROVISOIRE` exige règle, limites, réévaluation et identifiants d'obligations structurels.

Les deux types d'événements A1 sont explicitement synthétiques et provisoires. Leur payload de test contient soit des changements de relation centrale, soit un `personnage_id` et des changements de relation individuelle. Ils prouvent uniquement transaction, validation, atomicité, idempotence et encapsulation ; ils ne préfigurent pas la future taxonomie canonique.

## Exclusions et limites

Cette fondation n'est connectée à aucun runtime historique et ne modifie aucun fichier existant de celui-ci. Elle n'intègre ni scènes jouables, UI, données narratives, sauvegarde de production, migration, double écriture, moteur de règles, moteur d'obligations, livraison réelle de médias ou reducer narratif complet. Les cycles de vie et contrôles référentiels des registres, la sérialisation, les événements canoniques, les sélecteurs et l'intégration jouable sont reportés aux lots futurs.
