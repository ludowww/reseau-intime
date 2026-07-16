# Réseau Intime — 12D Plans détaillés des scènes J17–J21

## Statut

**Catégorie : Canon**

**Périmètre : acte V — résolution provisoire de la première saison**

Ce document complète les plans J01–J16.

Il définit :

- la fin du séjour de Mathilde ;
- la nouvelle définition du couple ;
- l’état final de Sandra ;
- la direction de Pauline et Raphaëlle ;
- la position future de Nico ;
- la dernière image recontextualisée.

Tout dialogue jouable reste en messagerie texte.

Aucune scène audio, aucun appel joué, aucun message vocal et aucune séquence doublée ne sont autorisés.

Les images sont des slots narratifs à remplir plus tard par Ludovic via ComfyUI.

---

# 1. État d’entrée J17

À la fin de J16 :

- les urgences de sécurité et d’audience sont traitées ou explicitement échouées ;
- le couple ne peut plus rester défini par l’habitude seule ;
- le séjour de Mathilde approche de sa fin canonique ;
- une route extérieure peut être dominante, refroidie ou fermée ;
- Pauline possède ou refuse une ligne privée ;
- Raphaëlle possède ou refuse un accès créatif ;
- Nico connaît une partie limitée des contradictions ;
- Jeff et Bastien restent des personnes réelles ;
- les conséquences principales sont identifiées ;
- aucune nouvelle route ne doit s’ouvrir.

## Question d’acte

> Quelle vie ordinaire reste possible lorsque les personnages savent désormais ce qu’ils ont choisi, évité ou trahi ?

---

# 2. Budget J17–J21

```text
J17 : foyer + définition du couple
J18 : Sandra décide ce qu’elle garde
J19 : Pauline et Raphaëlle obtiennent une direction
J20 : Nico et le réseau obtiennent une position
J21 : une image ancienne clôt la saison
```

Règles :

- aucun nouveau personnage principal ;
- aucune nouvelle route ;
- aucun choix final qui remplace l’accumulation ;
- une résolution peut rester instable ;
- une scène sexuelle tardive remplace une résolution standard, elle ne s’ajoute pas ;
- tout dialogue reste textuel ;
- les événements physiques sont inférés et payés par messages.

---

# 3. J17 — Jeudi — Le foyer ne peut plus rester le même

## Identité

```text
day_id: J17
day_type: RICH_RESOLUTION
act: V
main_sequences: S31 + S29
principal_relationships: Mathilde / foyer, Marie / Player
runtime_status: NOT_IMPLEMENTED
```

## Question dramatique

> Que devient le foyer lorsque Mathilde doit partir et que Marie refuse de laisser le couple revenir à l’ancien silence ?

## Fonction

J17 associe deux transformations :

1. la fin concrète du séjour de Mathilde ;
2. la définition provisoire du couple.

Ces deux fonctions appartiennent à la même journée parce que le départ modifie physiquement et émotionnellement le foyer.

## Fenêtre A — Matin ou midi — Mathilde prépare son départ

### Communication

`REMOTE_ASYNC` ou `SEPARATE_ROOMS_PING` bref.

### Pourquoi le texte

- Player est au travail ou en trajet ;
- Mathilde trie ses affaires ;
- Marie peut être ailleurs ;
- les questions logistiques sont écrites.

### Objets possibles

- clé ;
- chargeur ;
- vêtement ;
- tote bag ;
- objet laissé ;
- étagère libérée ;
- date de retour éventuelle.

Le document ne choisit pas l’image ou la composition.

## Nœud Mathilde

Les choix portent sur l’action de Player :

1. aider concrètement et reconnaître ce que le séjour a changé ;
2. maintenir une distance respectueuse ;
3. tenter de préserver un secret ou une proximité sans régler Marie.

Mathilde peut :

- remercier ;
- plaisanter ;
- demander une clarification ;
- poser une limite ;
- décider de parler à Marie ;
- partir plus tôt ;
- laisser un objet sans que cela garantisse une route.

## Fenêtre B — Départ ou transition hors téléphone

La messagerie s’arrête lorsque les personnages se rejoignent.

Le départ n’est pas joué en audio.

Il peut être indiqué par :

- temps écoulé ;
- message de Mathilde après son départ ;
- photo ou trace ;
- silence ;
- changement du foyer.

## Fenêtre C — Marie / Player

### Communication

La discussion jouable commence lorsque les personnages sont séparés :

- Marie au travail ;
- Player en trajet ;
- l’un a quitté temporairement le foyer ;
- une demande d’espace a été formulée.

Si les personnages se rejoignent, le chat s’arrête.

Le résultat revient ensuite par texte.

### Question

Marie ne demande pas un résumé de toutes les routes.

Elle demande une vérité praticable :

- qu’est-ce que Player choisit maintenant ?
- quelle règle peut encore être tenue ?
- qu’est-ce qu’il refuse d’admettre ?
- qu’est-ce que Marie ne veut plus porter seule ?

## États de couple possibles

### Reconquête active

- actes précédents cohérents ;
- vérité suffisante ;
- retour ordinaire concret ;
- nouvelle règle.

### Accord provisoire

- problème reconnu ;
- cadre encore incomplet ;
- prochaine discussion ou limite précise.

### Reconfiguration négociée

- désirs et limites nommés ;
- aucune permission rétroactive ;
- règles concrètes.

### Double vie fragile

- une partie de la vérité reste cachée ;
- Marie soupçonne ou accepte une version incomplète ;
- dette active.

### Fracture ou séparation

- Marie cesse de maintenir l’ancien contrat ;
- la vie commune change ;
- affection possible sans couple intact.

## Interdit

- choix `rester avec Marie / choisir une autre femme` comme menu ;
- confession exhaustive artificielle ;
- sexe comme réparation automatique ;
- Mathilde utilisée comme arbitre du couple ;
- appel téléphonique de résolution.

## Slots visuels

```text
minimum: 3
maximum_recommended: 5
asset_design: deferred_to_user_comfyui
```

Fonctions :

1. Mathilde et la fin du séjour ;
2. foyer transformé ;
3. Marie / couple ou distance ;
4. objet laissé ou repris ;
5. état ordinaire après décision.

## Sortie J17

- Mathilde possède un état lisible ;
- le foyer a changé ;
- le couple possède une définition provisoire ;
- les résolutions personnelles J18–J20 peuvent s’accomplir sans remplacer la décision de couple.

---

# 4. J18 — Vendredi — Sandra choisit ce qu’elle garde

## Identité

```text
day_id: J18
day_type: CHARACTER_RESOLUTION
act: V
main_sequence: S30
principal_relationship: Sandra / Player
runtime_status: NOT_IMPLEMENTED
```

## Question dramatique

> Quelle place Sandra donne-t-elle à Player lorsqu’elle décide ce qu’elle conserve de leur relation et de son image ?

## Fonction

J18 paie :

- la photographie J01 ;
- les continuités ;
- la rencontre ;
- l’image choisie ;
- les permissions ;
- les éventuelles violations ;
- le manque ;
- Jeff et la vie réelle.

## Communication

Messagerie texte uniquement.

Les formes possibles :

- messages après un poste ;
- photo imprimée ou retirée ;
- selfie envoyé ou gardé ;
- message depuis la Maison des Tilleuls ;
- demande de suppression ;
- proposition de rencontre future ;
- séparation douce.

Aucun appel, vocal ou audio intime.

## Branches

### Amitié retrouvée

Sandra conserve la relation sans ouvrir une ligne sexuelle.

Elle peut :

- renvoyer une trace ;
- proposer un café futur ;
- rappeler une limite ;
- utiliser une formule affectueuse rare.

### Confidence privilégiée

Player devient l’audience de certaines représentations, sous règles précises.

### Désir reconnu et contenu

Les deux savent, mais choisissent une limite.

Le désir ne disparaît pas ; la relation obtient une forme.

### Relation parallèle tendre

Une continuité émotionnelle ou physique existe à côté des couples officiels.

Le secret et Jeff restent des conséquences.

### Intimité tardive

Possible seulement si :

- elle n’a pas eu lieu avant ;
- la route est dominante et avancée ;
- les permissions sont établies ;
- elle remplace la résolution standard ;
- J19 ou J20 paie l’après-coup ;
- le dialogue reste textuel avant et après ;
- aucun fichier sexuel n’est supposé.

### Recul protecteur

Sandra retire une image ou une proximité tout en reconnaissant ce qui a existé.

### Rupture de confiance

Après violation d’audience :

- suppression ;
- vérification des copies ;
- fermeture ;
- Jeff ou le réseau peut être concerné ;
- l’ancienne amitié peut être perdue.

## Nœud Player

1. reconnaître le choix et la règle ;
2. demander une place future sans exiger ;
3. défendre son propre besoin ou minimiser le risque.

La réponse de Sandra dépend des actes antérieurs, pas du seul choix final.

## Slots visuels

```text
minimum: 3
maximum_recommended: 5
asset_design: deferred_to_user_comfyui
```

Fonctions :

1. représentation choisie ou retirée ;
2. trace matérielle / souvenir / accès perdu ;
3. vie réelle Sandra ;
4. éventuel payoff ;
5. après-coup ou règle.

## Sortie J18

- place de Sandra claire ;
- statut des images clair ;
- future rencontre, limite ou fermeture ;
- aucune route ne reste suspendue sans état.

---

# 5. J19 — Samedi — Ce que les versions privées deviennent

## Identité

```text
day_id: J19
day_type: DUAL_RESOLUTION
act: V
main_sequences: S32 + S33
principal_relationship: Pauline or Raphaëlle
runtime_status: NOT_IMPLEMENTED
```

## Question dramatique

> Que devient une version privée lorsqu’elle doit coexister avec une vie officielle et avec le lendemain ?

## Règle de pivot

Une seule des deux relations possède le premier plan développé.

L’autre reçoit :

- fermeture ;
- hook futur ;
- accès limité ;
- conséquence courte ;
- état autonome.

## Pauline — S32 Surface ou compartiment

### Fonctions à payer

- Bastien ;
- Marie ;
- version publique ;
- version privée ;
- preuve réciproque ;
- secret ;
- contrôle de l’audience.

### Branches

#### Surface restaurée

Pauline ferme ou réduit la ligne privée.

Sa vie officielle reste vraie.

#### Compartiment protégé

La ligne continue avec règle, dette et risque.

#### Preuve réciproque

Les deux personnes détiennent une trace, sans sécurité réelle.

#### Première trahison envers Marie

La relation privée devient autonome et coûteuse.

#### Collision Bastien

Soupçon ou découverte crédible, jamais omnisciente.

### Nœud

1. respecter une fermeture ;
2. accepter le compartiment consciemment ;
3. réclamer une vérité ou une version que Pauline refuse.

## Raphaëlle — S33 Après avoir retiré le costume

### Fonctions à payer

- travail ;
- processus ;
- Maud ;
- image ;
- cadre ;
- rôle ;
- fin du rôle ;
- Marie informée ou exclue.

### Branches

#### Confiance créative

Player garde un accès au processus.

#### Invitation future

Convention, atelier ou essayage futur clairement borné.

#### Attirance reconnue et contenue

La relation garde une frontière.

#### Secret clair mais infidèle

Raphaëlle nomme l’exclusion de Marie sans l’absoudre.

#### Frontière renforcée

Player désirait la version mais n’a pas assumé la personne ou le lendemain.

### Communication

Messagerie texte uniquement.

Aucun roleplay audio, aucune instruction vocale.

Une scène physique éventuelle est accomplie hors téléphone, puis payée par messages.

## Après-coup J18

Si J18 contenait une intimité Sandra :

- le premier plan peut devenir l’après-coup ;
- Pauline et Raphaëlle reçoivent des résolutions plus courtes ;
- aucune nouvelle scène adulte ne s’ajoute.

## Slots visuels

```text
minimum: 3
maximum_recommended: 5
asset_design: deferred_to_user_comfyui
```

Fonctions :

1. surface ou version Pauline ;
2. statut du compartiment ;
3. Raphaëlle après le rôle ou dans l’ordinaire ;
4. accès futur ;
5. conséquence sociale ou professionnelle.

## Sortie J19

- Pauline possède une direction précise ;
- Raphaëlle possède un accès ou une frontière précise ;
- aucune des deux n’est réduite à un hook vide ;
- les conséquences restantes appartiennent à Nico et au réseau.

---

# 6. J20 — Dimanche — Ce que l’amitié peut porter

## Identité

```text
day_id: J20
day_type: NETWORK_RESOLUTION
act: V
main_sequence: S34
principal_relationship: Nico / Player
runtime_status: NOT_IMPLEMENTED
```

## Question dramatique

> Quelle forme l’amitié prend-elle après les confidences, les rivalités, les images et les alibis ?

## Fonction Nico

Nico doit obtenir une position active :

- garde-fou ;
- confident ;
- rival ;
- complice ;
- partenaire d’un regard autorisé ;
- témoin compromis ;
- ami prenant ses distances.

Il ne reste pas un commentaire comique permanent.

## Communication

Messagerie texte avant ou après service.

L’Annexe peut être un lieu hors téléphone, mais aucun dialogue audio n’est joué.

## Nœud

1. dire à Nico ce qu’il a réellement besoin de savoir ;
2. lui demander ce qu’il accepte encore de porter ;
3. maintenir une version ou utiliser l’amitié comme couverture.

## Agence Nico

Nico peut :

- refuser un alibi ;
- reconnaître son attirance pour Marie ou Mathilde ;
- poser une limite sur les images ;
- dire qu’il ne couvrira plus ;
- accepter une vérité limitée ;
- devenir rival sans trahir automatiquement ;
- se retirer.

## Règle hétérosexuelle

Aucune branche ne crée :

- attirance pour Player ;
- contact sexuel entre les hommes ;
- révélation bisexuelle ;
- tension romantique masculine.

Une configuration future à plusieurs adultes reste centrée sur les femmes qui choisissent le cadre.

## Personnages secondaires et partenaires

J20 peut aussi payer :

- Jeff ;
- Bastien ;
- Maud ;
- Élodie ;
- témoin social ;
- suppression ;
- alibi fermé ;
- preuve de copie ou d’absence de copie.

Un seul de ces éléments devient secondaire fort.

## Slots visuels

```text
minimum: 3
maximum_recommended: 4
asset_design: deferred_to_user_comfyui
```

Fonctions :

1. Nico dans son monde ;
2. personne ou image concernée avec audience correcte ;
3. conséquence de réseau ;
4. retour ordinaire ou couple.

## Sortie J20

- place future de Nico claire ;
- principaux partenaires et témoins ont un état crédible ;
- aucune obligation urgente non identifiée ;
- la finale peut recontextualiser sans exposer un nouveau twist.

---

# 7. J21 — Lundi — La dernière photo change de sens

## Identité

```text
day_id: J21
day_type: SEASON_FINAL
act: V_END
main_sequence: S35
principal_relationship: Marie / Player + dominant route trace
runtime_status: NOT_IMPLEMENTED
```

## Question dramatique

> Quelle image du réseau reste lorsque les relations ne peuvent plus être regardées comme au début ?

## Fonction

J21 ne résume pas la saison.

Il montre :

- une vie ordinaire transformée ;
- une image ancienne qui possède un nouveau sens ;
- un comportement ;
- une règle ;
- une absence ;
- une continuité future.

## Image source

L’image doit déjà exister.

Candidates :

- photo du déjeuner Sandra ;
- photo de groupe ;
- image Marie / La Verrière ;
- image Mathilde / foyer ;
- version Pauline ;
- image Raphaëlle ;
- autre trace principale établie.

Elle peut être :

- conservée ;
- retirée ;
- supprimée ;
- imprimée ;
- recadrée légitimement ;
- inaccessible ;
- devenue souvenir ;
- devenue preuve ;
- devenue symbole d’une nouvelle règle.

Elle ne devient pas un nouvel asset du seul fait de son retour.

## Fenêtre A — Matin ordinaire

Marie ou le nouvel état du foyer est directement visible par messages.

Exemples de fonction :

- courses ;
- horaires ;
- clé ;
- café ;
- message pratique ;
- séparation organisée ;
- nouvelle habitude.

## Fenêtre B — Trace principale

L’image revient par :

- message ;
- galerie ;
- souvenir ;
- demande de suppression ;
- commentaire ;
- comparaison ;
- absence de l’image attendue.

## Fenêtre C — Dernier choix

Le dernier choix ne sélectionne pas une route.

Il exprime une posture cohérente avec la saison :

1. agir selon la nouvelle règle ;
2. reconnaître une perte ou une dette ;
3. maintenir une contradiction qui prépare la suite.

Le résultat dépend de l’accumulation.

## Promesses d’extension

Peuvent rester ouvertes :

- Pauline et son compartiment ;
- Raphaëlle et une invitation future ;
- Nico comme rival ou tiers possible ;
- Maison des Tilleuls ;
- nouvelle saison du couple ;
- conséquence sociale non résolue.

Elles ne doivent pas annuler la résolution provisoire.

## Communication

Messagerie texte uniquement.

Aucun monologue audio final, aucun appel, aucune narration vocale.

## Slots visuels

```text
minimum: 3
maximum_recommended: 5
asset_design: deferred_to_user_comfyui
```

Fonctions :

1. image recontextualisée ;
2. vie ordinaire du couple ou de la séparation ;
3. trace de la route dominante ;
4. état du réseau ;
5. promesse future éventuelle.

## Interdits

- écran de scores ;
- récapitulatif technique ;
- classement des femmes ;
- choix final `qui choisis-tu ?` ;
- révélation surprise non préparée ;
- dernière scène seulement sexuelle ;
- audio final ;
- galerie transformée en palmarès.

## Sortie J21

- couple défini ;
- Mathilde et Sandra possèdent un état ;
- Pauline possède une ligne ou une fermeture ;
- Raphaëlle possède un accès ou une frontière ;
- Nico possède un rôle ;
- partenaires et témoins restent crédibles ;
- les dettes majeures sont payées, assumées ou consciemment laissées instables ;
- la saison est complète et extensible.

---

# 8. Matrice J17–J21

| Personnage | J17 | J18 | J19 | J20 | J21 |
|---|---|---|---|---|---|
| Marie | couple pivot | conséquence | écho/état | retour possible | pivot ordinaire |
| Sandra | absence/trace | résolution pivot | aftermath possible | état secondaire | trace possible |
| Mathilde | départ pivot | écho | absence/conséquence | état secondaire | foyer trace |
| Pauline | conséquence | absence/écho | résolution | réseau | hook possible |
| Raphaëlle | travail/absence | absence/écho | résolution | réseau | hook possible |
| Nico | conséquence | absence/écho | témoin possible | résolution pivot | état réseau |

---

# 9. Couverture des résolutions

## Obligatoire

- S29 couple ;
- S30 Sandra ;
- S31 Mathilde ;
- S32 Pauline ;
- S33 Raphaëlle ;
- S34 Nico ;
- S35 finale.

Chaque séquence possède une variante de :

- progression ;
- refus ;
- retrait ;
- fermeture ;
- conséquence.

Aucune ne disparaît parce qu’une route n’a pas été poursuivie.

---

# 10. Anti-patterns

Rejeter :

- résolution de toutes les relations le même soir ;
- Mathilde quittant sans effet sur le foyer ;
- conversation Marie réduite à choisir une femme ;
- Sandra ouvrant automatiquement une relation sexuelle ;
- Pauline sans Bastien ;
- Raphaëlle sans après-rôle ;
- Nico sans décision propre ;
- audio pour rendre une fin plus émotionnelle ;
- message vocal comme preuve ou récompense ;
- dernière image nouvelle et sans histoire ;
- choix final annulant les vingt jours précédents ;
- conséquence majeure laissée sans état.

---

# 11. Critères d’acceptation

- [ ] J17 ferme réellement le séjour ;
- [ ] le couple reçoit une définition provisoire ;
- [ ] J18 donne à Sandra une décision active ;
- [ ] les permissions d’image sont claires ;
- [ ] J19 donne un état à Pauline et Raphaëlle ;
- [ ] J20 donne une position à Nico ;
- [ ] J21 réutilise une image existante ;
- [ ] aucune route nouvelle ;
- [ ] aucun écran de résultat ;
- [ ] aucun audio ;
- [ ] tout dialogue jouable est textuel ;
- [ ] les événements hors téléphone reviennent par messages ;
- [ ] les slots visuels restent à fournir ;
- [ ] la saison est complète mais extensible.

---

# 12. Résumé

J17 transforme le foyer et le couple.

J18 donne à Sandra le contrôle final sur ce qu’elle conserve et partage.

J19 distingue les versions privées de Pauline et Raphaëlle de leur vie officielle et de leur lendemain.

J20 oblige Nico à choisir ce que l’amitié peut réellement porter.

J21 reprend une image ancienne et montre que la vie ordinaire a changé.

La saison ne se termine pas par une révélation sonore ou un choix de route.

Elle se termine par des messages, une trace et une règle devenue impossible à ignorer.