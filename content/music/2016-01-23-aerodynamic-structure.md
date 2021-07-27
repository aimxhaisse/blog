---
categories:
- aero
- music
date: "2016-01-23T00:00:00Z"
icon: music
title: structure
---

*Cet article fait partie de la série [Aerodynamic]({% post_url music/2016-01-21-aerodynamic %}).*

Avant toute chose, essayez d'écouter 3/4 fois le [morceau original](https://www.youtube.com/watch?v=L93-7vRfxNs), d'en déduire
les différentes parties et d'imaginer comment elles sont construites.

C'est bon? Prêt à décoller? Allons-y!

Voici ce à quoi ressemble le morceau une fois importé dans *Sonic
Visualizer* :

<img src="/public/img/aerodynamic/structure.png" data-action="zoom" />

Il s'agit d'une manière classique de visualiser un son, en abcisse on
a le temps et en ordonnée le volume (plus la bande est épaisse, plus
le son est intense). On voit que le morceau dure 3 minutes 27, et
qu'il est composé de 5 parties que l'on va appeler ainsi :

1. `bells`
2. `funk`
3. `solo`
4. `funk/solo`
5. `outro`

C'est un découpage logique, et il pourrait être plus fin (par exemple
la seconde partie `funk` est composée en réalité de deux sous-parties,
qui ressortent également sur notre graphe). On va surtout s'intéresser
aux 4 premières parties dans cette série d'articles, et quelque peu
délaisser la 5ème partie.

## Le tempo

On va avoir besoin de connaître le tempo du morceau, que l'on
représente généralement en `BPM` (beats per minute), cela correspond
au nombre de temps par minute. On peut le récupérer différentes
manières, la plus simple étant probablement d'utiliser un logiciel qui
donne directement sa valeur, par exemple, en important le morceau
dans *Audacity* et en utilisant le plugin *Tempo and Beat Tracker* :

<img src="/public/img/aerodynamic/bpm.png" data-action="zoom" />

On peut aussi le calculer à partir de la partie `bells`, qui comprend
4 sons de cloche sur une durée de **15''6**, si on décide que chaque
coup de cloche correspond à 8 temps, on peut déduire ainsi les BPM:

- un son de cloche correspond à **15.6 / 4 = 3.9''**,
- un son de cloche étant sur 8 temps, un temps dure **3.9 / 8 = 0.4875''**,
- on a donc **60/0.4875 = 123** temps dans **60''**, le BPM est donc de **123**.

Pour s'assurer d'avoir la bonne valeur, on va jouer 4 notes espacées de 8
temps dans *Sonic Pi* avec un tempo de 123 BPM :

```ruby
use_bpm 123

4.times do
    play :C3
    sleep 8
end
```

C'est plutôt expressif et ça se lit ainsi:

* utilise un `BPM` de 123
* effectue 4 fois ce qui se trouve entre `do` et `end` (on apelle ça un bloc),
* dans le bloc, joue la note `C3`, puis attend 8 temps.

C'est assez proche de l'original d'un point de vue rythmique (mais pas
au niveau de la sonorité puisque l'on a choisi `C3` arbitrairement),
pour s'en assurer, on peut comparer dans *Audacity*:

<img src="/public/img/aerodynamic/bpm-match.png" data-action="zoom" />

En haut on a l'original (on est en stéréo, il y a une bande pour le
côté gauche, une pour le côté droit), en bas notre version : ça colle,
on peut continuer!

[La suite par ici...]({% post_url music/2016-01-24-aerodynamic-quelque-chose-qui-cloche %})

<hr />

*Cet article fait partie de la série [Aerodynamic]({% post_url music/2016-01-21-aerodynamic %}).*
