# DECISION 002 — Structure narrative centrale

## Statut

Validé.

## Décision

Construire le jeu avec une structure :

```text
Tronc commun + route dominante + route secondaire + menace + mode relationnel
```

## Pourquoi

Les personnages sont liés et les possibilités sont nombreuses. Un arbre narratif totalement libre deviendrait vite impossible à écrire, tester et maintenir.

Cette structure permet :

- une histoire cohérente quelle que soit la route ;
- une forte rejouabilité ;
- des personnages qui changent de rôle selon les choix ;
- une production maîtrisable ;
- des scènes communes qui changent de sens au lieu de créer six jeux séparés.

## Tronc commun

Toutes les parties doivent contenir :

1. Routine Ludo / Marie.
2. Mathilde présente dans la maison.
3. Sandra comme confidente ambiguë.
4. Raphaëlle comme attention claire.
5. Pauline comme déclencheur social.
6. Nico comme désir extérieur envers Marie.
7. Soirée pivot chez Pauline.
8. Première preuve.
9. Choix de vérité.
10. Épilogue réseau.

## Route dominante

Personnage ou axe qui prend le centre de la partie :

- Marie ;
- Mathilde ;
- Sandra ;
- Raphaëlle ;
- Pauline ;
- Nico ;
- mode transversal comme harem ou libertinage.

## Route secondaire

Relation qui complique la dominante.

Exemple : dominante Sandra, secondaire Raphaëlle.

## Menace

Élément qui peut faire exploser la partie.

Exemples :

- Marie découvre ;
- Pauline garde une preuve ;
- Sandra fuit ;
- Nico prend la place ;
- Mathilde culpabilise ;
- Raphaëlle coupe.

## Mode relationnel

Règle générale de la dynamique :

- EXCLUSIF_REPARATION ;
- SECRET_AFFAIR ;
- LIBERTINE_NEGOTIATED ;
- POLY_HONEST ;
- NTR_SUBI ;
- NTR_CONSENTED ;
- HAREM_SECRET ;
- HAREM_ASSUMED ;
- CHAOS_EXPLOSION.

## Règle de design

> Les personnages décident du désir. Le mode relationnel décide des règles.

## Conséquence

Toute écriture ou implémentation doit préserver ce modèle. Une nouvelle scène doit indiquer :

- à quel point elle appartient au tronc commun ;
- quelle route elle nourrit ;
- quelle menace elle active ou apaise ;
- quel mode relationnel elle favorise.