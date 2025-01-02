# class CoinsController < ApplicationController
#   def index
#     service = BinanceService.new
#     @tickers = service.fetch_tickers.parsed_response

#     # Фільтрація ліквідних монет
#     @tickers = @tickers.select do |ticker|
#       ticker['quoteVolume'].to_f > 100_000 && ticker['priceChangePercent'].to_f.abs < 10
#     end
#     @tickers = @tickers.sort_by { |ticker| -ticker['quoteVolume'].to_f }

#     # Загальна кількість валютних пар
#     @total_pairs = @tickers.size
#   end
# end


class CoinsController < ApplicationController
  def index
    service = BinanceService.new
    @tickers = service.fetch_tickers.parsed_response

    # Фільтрація ліквідних монет
    @tickers = @tickers.select do |ticker|
      ticker['quoteVolume'].to_f > 100_000 && ticker['priceChangePercent'].to_f.abs < 10
    end
    @tickers = @tickers.sort_by { |ticker| -ticker['quoteVolume'].to_f }

    # Якщо є параметр пошуку, фільтруємо валютні пари за символом
    if params[:search].present?
      search_query = params[:search].to_s.upcase
      @tickers = @tickers.select do |ticker|
        ticker['symbol'].upcase.include?(search_query)
      end
    end

    # Загальна кількість валютних пар
    @total_pairs = @tickers.size
  end
end
