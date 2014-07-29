# Description
#   A hubot script that catches them all
#
# Configuration:
#
# Commands:
#   hubot pokedex 15 - <gives pokedex stats on Beedrill (pokemon with id of 15)>
#
# Author:
#   Chase Coney[chase.coney@chaseconey.com]

getPokemon = (msg) ->
  poke_id = escape(msg.match[1])
  msg.http("http://pokeapi.co/api/v1/pokemon/#{poke_id}/")
    .get() (err, res, body) ->
      results = JSON.parse(body)
      if results.eror
        msg.send "error"
        return

      abilities = gather(results.abilities, 'name')
      moves = gather(results.moves, 'name')
      types = gather(results.types, 'name')
      evolutions = gather(results.evolutions, 'to')

      msg.send "http://pokeapi.co/media/img/#{poke_id}.png"
      msg.send "Name: #{results.name} [#{types}]\n
        Evolutions: #{evolutions}\n
        Attack: #{results.attack}\n
        Defense: #{results.defense}\n
        Catch rate: #{results.catch_rate}\n
        Abilities: #{abilities}\n
        # of Moves: #{moves.length}\n
        GOTTA CATCH'EM ALL!"

gather = (attr, prop) ->
  str = ''
  for key,value of attr
    str += value[prop] + ' '
  str.trim()

module.exports = (robot) ->
  robot.respond /pokedex me (.*)/i, (msg) ->
    getPokemon(msg)
