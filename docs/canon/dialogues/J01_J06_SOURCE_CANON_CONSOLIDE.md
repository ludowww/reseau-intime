# Réseau Intime — Source canonique consolidée J01–J06

## Statut

**Catégorie : Source narrative canonique consolidée — pré-runtime**

**Périmètre : J01 à J06**

Ce document remplace l’usage de `J01_J09_AUDIT_CONFORMITE_NARRATIVE.md` comme patch mental permanent pour J01–J06.

Les dialogues runtime historiques restent à migrer plus tard. Les décisions narratives ci-dessous sont la source de vérité.

---

# 1. Règles communes

- messagerie texte uniquement ;
- toute co-présence arrête le chat direct ;
- aucune réplique orale n’est affichée comme message ;
- une proposition ne devient promesse qu’après choix Player ;
- aucune image de scène ne devient trace diégétique ;
- aucun ticket, propriétaire de vague, candidate pool ou R2 automatique ;
- Marie revient obligatoirement après toute continuité extérieure ;
- les routes restent invisibles.

---

# 2. J01 — Marie et Sandra

## Fonction

- établir la vie commune Marie / Player ;
- réactiver Sandra par une trace concrète ;
- ne pas créer de triangle explicite ;
- Mathilde apparaît indirectement dans le fil Marie.

## Corrections intégrées

- les deux anciennes répliques orales directes sont retirées ;
- les événements physiques restent décrits sans dialogue ;
- la photographie Sandra utilise `trace_id: j01_sandra_lunch_memory_soft` ;
- voir cette photographie crée `fact_player_saw_sandra_lunch_photo` ;
- aucun transfert ni sauvegarde hors fil n’est autorisé ;
- une présence Marie éventuelle utilise `promise_id: marie_j01_shared_evening` seulement si Player l’accepte.

---

# 3. J02 — Arrivée de Mathilde

## Fonction

- introduire Mathilde comme personne et besoin réel ;
- mettre le foyer en mouvement ;
- élargir le réseau sans panel de routes.

## Corrections intégrées

- tout libellé `Marie appelle` devient `Marie écrit` ;
- l’aide à l’arrivée utilise `promise_id: mathilde_j02_arrival_help` ;
- `j02_mathilde_arrival_room_01` est un `FACT_RECORD`, pas une photographie diégétique garantie ;
- aucun créateur d’image n’est inventé ;
- Mathilde arrive et s’organise même si Player refuse ou échoue.

---

# 4. J03–J04 — Travail, réseau et premières traces publiques

## Fonction

- rendre visibles La Verrière, Raphaëlle, Pauline et Bastien ;
- conserver Marie comme axe principal ;
- séparer clairement monde professionnel et monde social.

## Traces

- `j03_marie_laverriere_setup_01` : photographie seulement si Élodie la crée ; sinon `FACT_RECORD` ;
- `j04_pauline_bastien_public_set_01` : set public contrôlé par Pauline via retardateur, avec Bastien et le groupe réellement présents ;
- audience publique ou de groupe nommée ;
- aucune version privée dérivée automatiquement.

---

# 5. J05 — Une heure réelle

## Fonction

Marie demande une heure ou une présence concrète.

- `promise_id: marie_j05_shared_hour` ;
- Player accepte, amende précisément ou refuse ;
- un `plus tard` sans heure ne crée rien ;
- Marie agit seule si Player ne s’engage pas ;
- l’heure payée ne devient pas un score de confiance.

---

# 6. J06 — Continuité extérieure optionnelle

## Fonction

Une seule continuité extérieure peut devenir visible si elle a été réellement préparée.

## Contrat

- `promise_id: j06_external_continuity_window` seulement après acceptation réelle ;
- aucune candidate pool visible ou autoritaire ;
- aucun `external_ticket_limit` ;
- aucun `wave_id` propriétaire ;
- aucun `unique R2 owner` ;
- aucune constante `MATHILDE_R2_MAX` ;
- aucune route ou accès chargé automatique ;
- la continuité peut être refusée ou expirer ;
- le retour Marie est obligatoire et conserve l’état du couple.

## Sortie maximale

Une continuité directe peut produire une attention reconnue ou une possibilité future, jamais une propriété de route, une permission adulte ou une femme gagnée.

---

# 7. Handoff J07

À l’entrée de J07 :

- Marie possède un état issu d’actes réels ;
- Mathilde reste une invitée du foyer ;
- Sandra reste une continuité légère ;
- Raphaëlle reste une relation professionnelle ;
- Pauline et Bastien possèdent une surface publique réelle ;
- Nico reste un ami social ;
- aucun accès adulte n’est ouvert ;
- aucune route n’appartient à un personnage.

> **L’ouverture ne choisit pas une route. Elle construit les personnes, les lieux et les promesses dont la saison pourra ensuite demander le prix.**
