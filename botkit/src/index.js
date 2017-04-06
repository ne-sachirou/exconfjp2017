// @flow
import HttpBot from './botkit/HttpBot'

const controller = HttpBot({
  debug: false,
  stats_optout: true
})
controller.spawn()
controller.hears(['ping'], 'message_received', (bot, message) => bot.reply(message, 'pong'))
