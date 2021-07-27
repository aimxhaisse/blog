---
categories:
- aero
- music
date: "2016-01-27T00:00:00Z"
icon: music
title: tout ensemble
disable_listing: true
---

*Cet article fait partie de la série <a href="/music/2016-01-21-aerodynamic">Aerodynamic</a>.*

Maintenant que nous avons toutes les parties du morceau, on va voir
comment mettre tout ça ensemble. On a déjà vu comment fonctionnait
les `live_loop`, pour rappel :

```ruby
live_loop :hej do
    play :C3
    sleep 4
end
```

Définie une boucle live nommée `hej`, qui tout les 4 temps va jouer la
note `C3`. Si l'ont édite en live la boucle et que l'on change par
exemple la note, pour ensuite ré-évaluer (via le bouton *Run*), au
prochain tour la note prendra la nouvelle valeur. On peut de cette
manière contrôler chaque boucle de manière indépendante, et petit à
petit faire évoluer un morceau.

## Synchronisation

On peut avoir autant de boucles lives que souhaitées, par exemple :

```ruby
live_loop :hej do
    play :C3
    sleep 4
end

live_loop :san do
    play :E5
    sleep 1
end
```

On a ici 2 boucles :

* une première qui tout les 4 temps joue la note *C3*
* une seconde qui tout les 1 temps joue la note *E5*

Si ces dernières sont créées en même temps, elles seront
automatiquement synchronisées, car elles vont démarrer en même temps.
Par contre, si on créé la seconde boucle un peu après la premère,
elles ne seront pas synchronisées et joueront en décalé :

```ruby
live_loop :hej do
    play :C3
    sleep 4
end

sleep 0.3

live_loop :san do
    play :E5
    sleep 1
end
```

Ce genre de décalage peut arriver aussi si l'on se trompe dans la
valeur de sleep en voulant faire évoluer une boucle (ce qui arrive
souvent) : par exemple, si au lieu d'attendre 1 temps, on attend 1/3
de temps, on va se retrouver également désynchronisé pour tout le
reste du morceau.

Pour éviter ce genre de décalages, on peut demander à *Sonic Pi* de
synchroniser des boucles, c'est à dire, de demander à une boucle de ne
commencer qu'au début d'un temps :

```ruby
live_loop :main do
    sleep 1
end

sleep 0.4

live_loop :hej do
    sync :main

    play :C3
    sleep 4
end

sleep 0.3

live_loop :san do
    sync :main

    play :E5
    sleep 1
end
```

On a introduit une 3ème boucle nommée `main` qui est déclenchée tous
les temps et ne fait rien.

Le mot clef `sync` permet de synchroniser une boucle sur une autre,
ici, on force les boucles *hej* et *san* à ne démarrer que lorsque la
boucle main commence : peu importe les décalages, elles ne démarreront
qu'exactement sur un temps.

Un autre mot clef utile est `stop`, il permet de stopper une boucle :
en ajoutant *stop* dans la boucle *hej* et en ré-évaluant, on arrête
de jouer la note *C3* tout les 4 temps ; en enlevant à nouveau le
stop et en ré-évaluant, on joue à nouveau la note tout en restant
synchronisé. C'est très utile : on peut activer / désactiver des
boucles de cette manière.

## Aerodynamic

On a enfin tout les éléments pour jouer *Aerodynamic*, voici le code
complet avec toutes les boucles nécessaires, en bonus, j'ai ajouté une
loop additionelle nommée `extra_beat` qui peut s'avérer utile. *Have
fun!*

```ruby
use_bpm 123

maquillage = "~/il-macquillage-lady.wav"
aerodynamic = "~/funk.wav"

load_sample maquillage
load_sample aerodynamic

define :sample_chunk do |what, beat, dur, delay|
    beat = beat / 16.0
    dur = dur / 16.0
    sample what, beat_stretch: 16, start: beat, finish: beat + dur
    sleep delay
end

define :funk do
    # sample_chunk(aerodynamic, 0.0, 4.0, 4.0)

    sample_chunk(maquillage, 0.0, 0.5, 0.5)
    sample_chunk(maquillage, 2.5, 1.0, 0.25)
    sample_chunk(maquillage, 3.5, 0.5, 0.75)
    sample_chunk(maquillage, 0.0, 0.5, 0.5)
    sample_chunk(maquillage, 8.5, 0.5, 0.5)
    sample_chunk(maquillage, 2.5, 1.0, 1.0)
    sample_chunk(maquillage, 7.5, 0.5, 0.5)

    # sample_chunk(aerodynamic, 4.0, 4.0, 4.0)

    sample_chunk(maquillage, 3.5, 0.5, 0.5)
    sample_chunk(maquillage, 2.5, 1.0, 1.0)
    sample_chunk(maquillage, 7.5, 0.5, 0.5)
    sample_chunk(maquillage, 8.5, 0.5, 0.5)
    sample_chunk(maquillage, 2.5, 1.0, 1.0)
    sample_chunk(maquillage, 7.5, 0.5, 0.5)

    # sample_chunk(aerodynamic, 8.0, 4.0, 4.0)

    sample_chunk(maquillage, 0.0, 0.5, 0.5)
    sample_chunk(maquillage, 2.5, 1.0, 0.25)
    sample_chunk(maquillage, 3.5, 0.5, 0.75)
    sample_chunk(maquillage, 0.0, 0.5, 0.5)
    sample_chunk(maquillage, 8.5, 0.5, 0.5)
    sample_chunk(maquillage, 2.5, 1.0, 1.0)
    sample_chunk(maquillage, 7.5, 0.5, 0.5)

    # sample_chunk(aerodynamic, 12.0, 4.0, 4.0)

    sample_chunk(maquillage, 3.5, 0.5, 0.5)
    sample_chunk(maquillage, 8.5, 0.25, 0.0)
    sample_chunk(maquillage, 2.5, 1.0, 0.25)
    sample_chunk(maquillage, 3.5, 0.5, 0.5)
    sample_chunk(maquillage, 8.5, 0.25, 0.25)
    sample_chunk(maquillage, 3.5, 0.5, 0.5)
    sample_chunk(maquillage, 8.5, 0.5, 0.5)
    sample_chunk(maquillage, 2.5, 1.0, 1.0)
    sample_chunk(maquillage, 7.5, 0.5, 0.5)
end

# Live loops

live_loop :main do
    sleep 4
end

live_loop :funk do
    sync :main

    with_fx :ixi_techno, mix: 0.1, phase: 8, cutoff_min: 90, cutoff_max: 120, res: 0.9, amp: 1 do
        with_fx :bpf, mix: 0, res: 0.00001, centre: :B8, amp: 2 do
            funk
        end
    end
end

live_loop :solo do
    sync :main

    use_synth :zawa
    use_synth_defaults attack: 0.05, sustain: 0.15, release: 0.125

    phases = [
        [:D4, :Fs3, :B3, :Fs3],
        [:D4, :Gs3, :B3, :Gs3],
        [:G4, :B3, :E4, :B3],
        [:E4, :A3, :Cs4, :A3],

        [:D4, :Fs4, :B3, :Fs4],
        [:D4, :Gs4, :B3, :Gs4],
        [:G4, :B3, :E4, :B3],
        [:E4, :A3, :Cs4, :A3],
    ]

    phases.each do |notes|
    	4.times do
            notes.each do |n|
                play n
                sleep 0.25
            end
        end
    end
end

live_loop :extra_beat do
    sync :main

    32.times do
        tick
        sample :bd_fat, amp: 2 if spread(1, 16).look
        sample :bd_fat, amp: 1.5 if spread(1, 32).rotate(4).look
        synth :cnoise, release: 0.6, cutoff: 130, env_curve: 7, amp: 1 if spread(1, 16).rotate(8).look
        synth :cnoise, release: 0.1, cutoff: 130, env_curve: 7, amp: 0.25 if spread(1, 2).look
        sleep 0.125
    end
end

live_loop :intro do
    stop # remove me if you want bells

    sync :main

    use_synth :pretty_bell
    use_synth_defaults release: 9

    with_fx :level, amp: 0.5 do
        4.times do
            with_fx :gverb, room: 20 do
                play :A1, amp: 0.25
                play :A2, amp: 0.5
                play :A3, amp: 1.5
                play :A4, amp: 0.75
                play :A5, amp: 0.5
                sleep 8
            end
        end
    end
end
```

<hr />

*Cet article fait partie de la série <a href="/music/2016-01-21-aerodynamic">Aerodynamic</a>.*
