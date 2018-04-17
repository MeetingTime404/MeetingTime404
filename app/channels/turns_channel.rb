# app/channels/games_channel.rb

class TurnsChannel < ApplicationCable::Channel  
  def subscribed
    stream_from 'turns'
  end
end