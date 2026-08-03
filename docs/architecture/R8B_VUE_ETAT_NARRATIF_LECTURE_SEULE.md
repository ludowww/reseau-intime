# R8B — Vue d'état narratif en lecture seule

`EtatNarratifLecture` reçoit un `Season1State` et construit trois dictionnaires
reconstructibles : `obtenir_resume_relation_centrale`, `obtenir_resume_relation`
et `obtenir_resume_etat_narratif`. La classe ne possède aucun état, n'appelle
aucune méthode de mutation et ne participe ni au snapshot ni à sa restauration.

## Valeurs lisibles et valeurs projetées

- Les états de route, `couple_state`, le jour, et les quatre registres sont lus
  directement du runtime.
- Les statuts de relation, l'acte et le dernier événement sont des projections
  stables. L'acte est explicitement une compatibilité avec l'ancien corpus,
  J01–J21 : I=J01–J04, II=J05–J08, III=J09–J12, IV=J13–J16, V=J17–J21.
- Les IDs publics sont préfixés (`FAIT_`, `TRACE_`, `ENGAGEMENT_`,
  `EVENEMENT_`) afin que le vocabulaire de façade n'expose pas les noms de
  champs historiques. Les identifiants et champs legacy restent limités au
  bloc `debug` de provenance.

## Limites explicites

Le runtime ne contient pas de contrat de couple, de divulgation, ni de modèle
générique pour confiance, désir, intimité ou secret. La vue retourne donc
`INDETERMINE`, jamais une règle de couple ou un consentement inventé. Pour une
séparation, `contrat_couple` est `ABSENT`; le statut post-séparation demeure
`INDETERMINE` tant qu'aucune catégorie canonique ne peut être déduite.

`household_rhythm_confirmed` produit uniquement l'état de foyer `ETABLI`; il
ne prouve aucune présence à une scène. Les traces retirées restent absentes de
la liste visible et les connaissances existantes ne sont ni supprimées ni
élargies par la vue.
