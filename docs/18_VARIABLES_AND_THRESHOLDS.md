# 18 — Variables et seuils

## Objectif

Définir les variables, valeurs de départ, bornes, effets moyens et seuils permettant de calculer :

- route dominante ;
- route secondaire ;
- menace active ;
- mode relationnel probable.

Ce document sert d’outil de design et d’équilibrage. Les valeurs sont initiales et pourront être ajustées après prototype.

## Principes

1. Les variables ne sont pas visibles en jeu normal.
2. Le mode debug doit afficher les variables et les raisons des calculs.
3. Une route ne doit pas être déclenchée par une seule variable.
4. Les signaux passifs restent secondaires.
5. Les seuils doivent être lisibles et testables.

## Échelle recommandée

Toutes les variables principales utilisent une échelle :

```text
0 à 100
```

Interprétation :

```text
0–24   très faible
25–44  faible
45–59  moyen
60–74  élevé
75–100 très élevé
```

## Valeurs de départ — globales

```text
marie_trust       = 60
lie_score         = 0
truth_tendency    = 30
ludo_jealousy     = 10
social_pressure   = 10
```

### marie_trust

Mesure la confiance relationnelle globale de Marie.

Augmente si : Ludo est présent, sincère, tendre.

Baisse si : Ludo ment, ignore Marie, est surpris dans une ambiguïté.

### lie_score

Mesure l’accumulation de secrets et de mensonges.

Augmente si : Ludo cache, conserve une preuve risquée, ment sur une interaction.

Baisse rarement. Peut baisser par aveu, suppression sincère ou choix de vérité.

### truth_tendency

Mesure la tendance de Ludo à assumer.

Augmente si : Ludo avoue, clarifie, pose une limite honnête.

Baisse si : Ludo esquive ou multiplie les demi-vérités.

### ludo_jealousy

Mesure la jalousie active de Ludo, surtout envers Nico / Marie.

Augmente si : Ludo vérifie Nico, voit Marie désirée, surveille une story.

### social_pressure

Mesure la pression du groupe et les risques publics.

Augmente si : commentaires publics, sous-entendus de groupe, Pauline expose, fond d’écran révélé.

## Valeurs de départ — personnages

```text
marie.lucidity              = 15
mathilde.desire             = 20
mathilde.loyalty            = 75
sandra.attachment           = 25
sandra.exposure             = 5
raphaelle.attachment        = 15
raphaelle.clarity           = 50
pauline.interest            = 25
pauline.control             = 30
nico.desire_for_marie       = 60
nico.place_near_marie       = 20
```

### marie.lucidity

Ce que Marie comprend des décalages de Ludo.

Attention : lucidité haute ne signifie pas forcément confiance basse. Marie peut comprendre et choisir de parler, ou comprendre et se fermer.

### mathilde.desire

Tension et attirance de Mathilde envers Ludo.

### mathilde.loyalty

Loyauté de Mathilde envers Marie.

Si `desire` et `loyalty` sont hauts ensemble, Mathilde devient instable : attirée mais culpabilisée.

### sandra.attachment

Attachement émotionnel de Sandra envers Ludo.

### sandra.exposure

Degré auquel Sandra se sent exposée, forcée ou en danger.

Si `attachment` haut et `exposure` bas : Sandra avance.

Si `attachment` haut et `exposure` haut : Sandra panique.

### raphaelle.attachment

Attachement de Raphaëlle envers Ludo.

### raphaelle.clarity

Exigence de clarté de Raphaëlle.

Ce score commence haut : Raphaëlle n’est pas naturellement compatible avec le mensonge.

### pauline.interest

Intérêt de Pauline pour le jeu avec Ludo.

### pauline.control

Pouvoir de Pauline sur la situation : preuves, captures, avance psychologique.

### nico.desire_for_marie

Désir de Nico pour Marie. Déjà haut au début.

### nico.place_near_marie

Place réelle que Nico prend auprès de Marie.

## Signaux passifs

Échelle secondaire :

```text
0 à 20
```

Signaux initiaux :

```text
marie_attention_score       = 0
marie_neglect_score         = 0
mathilde_attention_score    = 0
sandra_priority_score       = 0
raphaelle_clarity_score     = 0
pauline_risk_score          = 0
nico_surveillance_score     = 0
```

Les signaux passifs servent à colorer ou départager. Ils ne doivent pas déclencher seuls une route majeure.

## Effets moyens des choix

### Choix anodin

```text
0 à ±1 variable ou aucun effet
```

### Choix de ton

```text
±1 à ±2 sur une variable
éventuel signal passif +1
```

### Choix relationnel

```text
+2 à +4 sur une variable personnage
+1 lie_score si secret
+1 signal passif
```

### Choix de trace

```text
+2 à +5 lie_score ou contrôle/preuve
+1 à +3 lucidité/exposure/social_pressure selon contexte
```

### Choix de vérité / bascule

```text
+3 à +8 truth_tendency
-2 à -8 lie_score possible
+3 à +10 lucidity ou trust selon réponse
peut ouvrir/fermer un mode relationnel
```

## Seuils de route dominante — vertical slice

### Mathilde dominante probable

Conditions minimales recommandées :

```text
mathilde.desire >= 45
mathilde_attention_score >= 3
lie_score >= 10
mathilde.loyalty >= 40
au moins 2 flags Mathilde
```

Menaces possibles :

```text
Marie
Mathilde culpabilise
Pauline remarque
```

Mode probable :

```text
SECRET_AFFAIR
```

### Sandra dominante probable

```text
sandra.attachment >= 45
sandra.exposure <= 35
sandra_priority_score >= 3
au moins 2 flags Sandra
```

Menaces possibles :

```text
Exposition
Marie
Raphaëlle clarté
```

Mode probable :

```text
SECRET_AFFAIR émotionnelle
```

### Raphaëlle dominante probable

```text
raphaelle.attachment >= 35
truth_tendency >= 40
lie_score <= 25 ou aveu récent
raphaelle.clarity >= 50
```

Menaces possibles :

```text
Flou de Ludo
Sandra obsession
Marie blessée
```

Mode probable :

```text
POLY_HONEST amorcé ou rupture propre future
```

### Pauline dominante / menace probable

```text
pauline.interest >= 40
pauline.control >= 45 ou pauline_risk_score >= 3
au moins 1 flag preuve ou provocation
```

Menaces possibles :

```text
Preuve
Marie
Social pressure
```

Mode probable :

```text
SECRET_AFFAIR ou CHAOS futur
```

### Nico / Marie dominante probable

```text
nico.place_near_marie >= 40
ludo_jealousy >= 30
marie_neglect_score >= 2 ou marie_trust <= 50
```

Menaces possibles :

```text
Nico
Jalousie
Marie se détache
```

Mode probable :

```text
NTR_SUBI amorcé
```

### Marie réparation dominante probable

```text
marie_trust >= 60
truth_tendency >= 40
lie_score <= 20
marie_attention_score >= 2 ou choix vérité récent
```

Menaces possibles :

```text
Secrets passés
Nico latent
Sandra revient
```

Mode probable :

```text
EXCLUSIF_REPARATION
```

## Modes relationnels — seuils d’amorçage

### EXCLUSIF_REPARATION

```text
marie_trust >= 60
truth_tendency >= 40
lie_score <= 20
```

### SECRET_AFFAIR

```text
lie_score >= 20
au moins 1 route intime nourrie
truth_tendency < 50
```

### LIBERTINE_NEGOTIATED

```text
truth_tendency >= 50
marie_trust >= 45
social_pressure >= 20 ou pauline.interest >= 35
ludo a évoqué désir / règles avec Marie
```

### POLY_HONEST

```text
truth_tendency >= 60
raphaelle.attachment ou sandra.attachment élevé
lie_score bas ou aveu récent
Marie informée ou discussion amorcée
```

### NTR_SUBI

```text
nico.place_near_marie >= 50
marie_trust <= 45
marie_neglect_score >= 3
ludo_jealousy >= 30
```

### NTR_CONSENTED

```text
ludo_jealousy >= 30
truth_tendency >= 50
marie_trust >= 45
Marie exprime qu’elle aime être désirée
Ludo ne répond pas par contrôle pur
```

### HAREM_SECRET

```text
lie_score >= 45
au moins 3 routes nourries
truth_tendency <= 35
plusieurs contenus conservés
```

### HAREM_ASSUMED

Non atteignable dans le vertical slice. Seulement amorçable.

Conditions futures probables :

```text
truth_tendency très haut
Marie informée
plusieurs personnages compatibles
peu de preuves cachées
acceptation de pertes / refus
```

### CHAOS_EXPLOSION

Non atteignable complètement dans le vertical slice.

Amorçage :

```text
lie_score élevé
social_pressure élevé
Pauline.control élevé
Marie.lucidity élevée
plusieurs preuves actives
```

## Menaces — seuils

### Marie découvre / soupçonne

```text
marie.lucidity >= 45
ou contenu risqué révélé
ou contradiction visible
```

### Pauline garde une preuve

```text
pauline.control >= 45
ou flag pauline_has_capture
ou contenu Pauline conservé / capturé
```

### Sandra fuit

```text
sandra.exposure >= 45
ou Ludo demande une clarification trop tôt
ou Sandra découvre harem secret
```

### Raphaëlle coupe

```text
raphaelle.clarity >= 60
et lie_score >= 35
et Ludo refuse d’avouer
```

### Nico prend la place

```text
nico.place_near_marie >= 50
marie_trust <= 45
marie_neglect_score >= 3
```

### Mathilde culpabilise

```text
mathilde.desire >= 45
mathilde.loyalty >= 70
et marie.lucidity >= 35
```

## Priorité de calcul en cas d’égalité

Si plusieurs routes sont proches :

1. Route correspondant au dernier choix de vérité.
2. Route avec le plus de flags clés.
3. Route avec le plus haut score relationnel.
4. Route avec le signal passif le plus élevé.
5. En cas d’égalité persistante : garder une route secondaire plutôt que forcer une dominante.

## Debug recommandé

Afficher :

```text
Variables globales
Variables personnages
Signaux passifs
Flags actifs
Route dominante probable
Route secondaire probable
Menace probable
Mode relationnel probable
Raisons du calcul
```

Exemple :

```text
Dominante : Mathilde
Raisons : mathilde.desire 48, attention_score 4, 3 flags Mathilde, lie_score 18
Menace : Marie
Raisons : marie.lucidity 42, fond d’écran Mathilde révélé
Mode : SECRET_AFFAIR
```

## Règle finale

> Les seuils servent à guider l’histoire, pas à remplacer l’écriture. Une route ne doit être validée que si les scènes la rendent crédible.