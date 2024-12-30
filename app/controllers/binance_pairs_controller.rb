class BinancePairsController < ApplicationController
  require 'httparty'

  def index
    @pairs = fetch_binance_pairs
    @pairs_count = @pairs.count
  end

  def add_to_favorites
    symbol = params[:symbol]
    Favorite.create(symbol: symbol)
    redirect_to binance_pairs_index_path, notice: 'Pair added to favorites'
  end

  private

  def fetch_binance_pairs
    response = HTTParty.get('https://api.binance.com/api/v3/ticker/price')
    pairs = response.parsed_response.select { |pair| pair['symbol'].end_with?('BTC') }
    pairs.map { |pair| { symbol: pair['symbol'] } }
  end
end
