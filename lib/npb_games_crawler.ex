defmodule NpbGamesCrawler do
  @moduledoc """
  Documentation for `NpbGamesCrawler`.
  """

  @game_url "https://npb.jp/scores/2024/0329/g-t-01/"

  @base_url "https://npb.jp/games/"
  #@game_months ["03","04", "05","06","07","08","09","10","11"]
  @game_months ["03"]



  def crawl(_year \\ "2024" ) do
    #schedules_links = NpbGamesCrawler.makeScoreLinks(year)


    HTTPoison.get!("#{@game_url}").body
    |> GameParser.parse()
  end

  def makeScoreLinks(year \\ "2024") do
    links = @game_months
    |> Enum.map(&build_url(year, &1))
    |> Enum.map(&fetch_schedule/1)

    List.flatten(links)

  end

  defp build_url(year, month) do
    "#{@base_url}#{year}/schedule_#{month}_detail.html"
  end

  defp fetch_schedule(url) do
    url
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> ScheduleParser.parse()
  end
end
