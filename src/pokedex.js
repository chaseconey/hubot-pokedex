// Description
//   A hubot script that catches them all
//
// Configuration:
//
// Commands:
//   hubot pokedex 15 - <gives pokedex stats on Beedrill (pokemon with id of 15)>
//   a wild pokemon appears - randomly selects a pokemon from the pokedex
//
// Author:
//   Chase Coney[chase.coney@chaseconey.com]

const fetchPokemon = (msg, uri) =>
  msg.http(`${uri}`)
    .get()(function(err, res, body) {
      const results = JSON.parse(body);
      if (results.eror) {
        msg.send("error");
        return;
      }

      const abilities = gather(results.abilities, 'name');
      const moves = gather(results.moves, 'name');
      const types = gather(results.types, 'name');
      const evolutions = gather(results.evolutions, 'to');

      msg.send(`http://pokeapi.co/media/img/${results.pkdx_id}.png`);
      return msg.send(`Name: ${results.name} [${types}]\n \
Evolutions: ${evolutions}\n \
Attack: ${results.attack}\n \
Defense: ${results.defense}\n \
Catch rate: ${results.catch_rate}\n \
Abilities: ${abilities}\n \
# of Moves: ${moves.length}\n \
GOTTA CATCH'EM ALL!`
      );
  })
;

var gather = function(attr, prop) {
  let str = '';
  for (let key in attr) {
    const value = attr[key];
    str += value[prop] + ' ';
  }
  return str.trim();
};

const getPokemon = function(msg) {
  const poke_id = escape(msg.match[1]);

  return fetchPokemon(msg, `http://pokeapi.co/api/v1/pokemon/${poke_id}/`);
};



// retrieves a random pokemon by grabbing the current pokedex, then selecting
// a random entry from it and loading that
const getWild = msg =>
  msg.http("http://pokeapi.co/api/v1/pokedex/1/")
    .get()(function(err, res, body) {
      const pokedex = JSON.parse(body);
      if (pokedex.eror) {
        msg.send("no pokemon are in this location");
        return;
      }

      // got our pokedex, find a random entry, then invoke getPokemon
      const pokemon = pokedex.pokemon[Math.floor(Math.random() * pokedex.pokemon.length)];

      return fetchPokemon(msg, `http://pokeapi.co/${pokemon.resource_uri}`);
  })
;


module.exports = function(robot) {
  robot.respond(/pokedex me (.*)/i, msg => getPokemon(msg));

  return robot.hear(/a wild pokemon appears/i, msg => getWild(msg));
};
