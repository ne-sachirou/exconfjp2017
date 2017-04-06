// @flow
import Botkit from 'botkit'
import http from 'http'

export default function HttpBot (config: Object = {}) {
  const botkit = Botkit.core(config)
  botkit.middleware.spawn.use((bot, next) => {
    listen(botkit, bot)
    next()
  })
  botkit.defineBot((botkit, config) => new Bot(botkit, config))
  return botkit
}

class Bot {
  botkit: Botkit
  config: Object
  utterances: {[string]: RegExp}
  say: (string|Object, any => void) => void

  constructor (botkit, config) {
    this.botkit = botkit
    this.config = config || {}
    this.utterances = botkit.utterances
  }

  startConversation (message, callback) {
    this.botkit.startConversation(this, message, callback)
  }

  send (message, callback) {
    message.response.writeHead(
      200,
      {
        'Content-Type': 'text/plain',
        'Content-Length': encodeURIComponent(message.text).replace(/%../g, 'x').length
      }
    )
    message.response.write(message.text)
    message.response.end()
  }

  reply (src, resp, callback) {
    var msg = {}
    if (typeof resp === 'string') {
      msg.text = resp
    } else {
      msg = resp
    }
    msg.channel = src.channel
    msg.response = src.response
    this.say(msg, callback)
  }

  findConversation (message, callback) {
    this.botkit.debug('CUSTOM FIND CONVO', message.user, message.channel)
    for (let t = 0; t < this.botkit.tasks.length; ++t) {
      for (let c = 0; c < this.botkit.tasks[t].convos.length; ++c) {
        if (this.botkit.tasks[t].convos[c].isActive() && this.botkit.tasks[t].convos[c].source_message.user === message.user) {
          this.botkit.debug('FOUND EXISTING CONVO!')
          callback(this.botkit.tasks[t].convos[c])
          return
        }
      }
    }
    callback()
  }
}

function listen (botkit, bot) {
  botkit.startTicking()
  const server = http.createServer((req, res) => {
    req.setEncoding('utf8')
    var data = ''
    req.on('data', chunk => { data += chunk })
    req.on('end', () => {
      const message = {
        text: data,
        user: 'user',
        channel: 'http',
        timestamp: Date.now(),
        response: res
      }
      botkit.receiveMessage(bot, message)
    })
  })
  server.on('clientError', (err, socket) => {
    console.error(err)
    socket.end('HTTP/1.1 400 Bad Request\r\n\r\n')
  })
  server.listen(3000)
}
