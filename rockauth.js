riot.tag2('rockauth-login', '<h3>{message}</h3> <ul> <li each="{techs}">{name}</li> </ul>', 'rockauth-login,[riot-tag="rockauth-login"] { font-size: 2rem } rockauth-login h3,[riot-tag="rockauth-login"] h3 { color: #444 } rockauth-login ul,[riot-tag="rockauth-login"] ul { color: #999 }', '', function(opts) {
    this.message = 'Hello, Riot!'
    this.techs = [
      { name: 'HTML' },
      { name: 'JavaScript' },
      { name: 'CSS' }
    ]
}, '{ }');
