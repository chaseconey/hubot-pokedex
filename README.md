# hubot-pokedex

A hubot script that catches them all

See [`src/pokedex.coffee`](src/pokedex.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-pokedex --save`

Then add **hubot-pokedex** to your `external-scripts.json`:

```json
["hubot-pokedex"]
```

## Sample Interaction

```
user1> hubot pokedex me 1
Hubot> http://pokeapi.co/media/img/15.png
Hubot> Pokemon name: Beedrill [poison bug]
        Attack: 90
        Defense: 40
        Catch rate: 0
        Abilities: swarm sniper
        # of Moves: 681
```
