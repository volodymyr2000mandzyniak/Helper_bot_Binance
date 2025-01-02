class BinanceService
  include HTTParty
  base_uri "https://api.binance.com"

  def fetch_tickers
    self.class.get("/api/v3/ticker/24hr")
  end
end
