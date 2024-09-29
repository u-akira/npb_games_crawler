defmodule NpbGamesCrawler do
  @moduledoc """
  Documentation for `NpbGamesCrawler`.
  """

  @base_url "https://npb.jp"
  @game_months ["03","04", "05","06","07","08","09","10","11"]

  def crawl() do
    IO.puts("取得する年月を指定してください.")
  end
  def crawl(year) do
    crawlExecute(year,  @game_months)
  end

  def crawl(year, months) when is_list(months) do
    crawlExecute(year, months)
  end

  def crawl(year, month) do
    crawlExecute(year, [month])
  end

  defp crawlExecute(year, months) do
    makeScoreLinks(year, months)
    |> Enum.map(&fetch_game/1)
    |> Enum.map(&JsonStorage.save/1)
  end

  def makeScoreLinks(year, months) do
    links = months
    |> Enum.map(&build_schedule_url(year, &1))
    |> Enum.map(&fetch_schedule/1)

    List.flatten(links)
    |> Enum.map(&build_game_url/1)
    |> Enum.map(fn url -> {url,build_game_filepath(url)} end)

  end

  defp build_schedule_url(year, month) do
    "#{@base_url}/games/#{year}/schedule_#{month}_detail.html"
  end

  defp fetch_schedule(url) do
    url
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> ScheduleParser.parse()
  end

  defp build_game_url(url) do
    "#{@base_url}#{url}"
  end

  defp build_game_filepath(url) do
    url
    |> String.replace("https://npb.jp/", "")
    |> String.trim_trailing("/")
    |> Kernel.<>(".json")

  end

  defp fetch_game({url,path}) do
    unless File.exists?(path) do
      score = url
      |> HTTPoison.get!()
      |> Map.get(:body)
      |> GameParser.parse()

      {score, path}
    end
  end
end
