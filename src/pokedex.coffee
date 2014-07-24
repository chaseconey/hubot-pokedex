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

      abilities = gatherNames(results.abilities)
      moves = gatherNames(results.moves)
      types = gatherNames(results.types)

      msg.send "http://pokeapi.co/media/img/#{results.pkdx_id}.png"
      msg.send "Name: #{results.name} [#{types}]\n
        Attack: #{results.attack}\n
        Defense: #{results.defense}\n
        Catch rate: #{results.catch_rate}\n
        Abilities: #{abilities}\n
        # of Moves: #{moves.length}\n
        GOTTA CATCH'EM ALL!"

gatherNames = (attr) ->
  str = ''
  for key,value of attr
    str += value.name + ' '
  str.trim()

module.exports = (robot) ->
  robot.respond /pokedex me (.*)/i, (msg) ->
    getPokemon(msg)
