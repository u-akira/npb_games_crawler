defmodule NpbGamesCrawler do
  @moduledoc """
  Documentation for `NpbGamesCrawler`.
  """

  @base_url "https://npb.jp"
  #@game_months ["03","04", "05","06","07","08","09","10","11"]
  @game_months ["04"]

  def crawl(year \\ "2024" ) do
    makeScoreLinks(year)
    |> Enum.map(&fetch_game/1)
    |> Enum.map(&save_json_to_file/1)

  end

  @spec makeScoreLinks(any()) :: list()
  def makeScoreLinks(year \\ "2024") do
    links = @game_months
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

  def build_game_url(url) do
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

  def save_json_to_file(nil) do
    IO.puts("取得済み.")
  end
  def save_json_to_file({data, file_path}) do
    dir_path = Path.dirname(file_path)

    # フォルダが存在しなければ作成
    unless File.exists?(dir_path) do
      case File.mkdir_p(dir_path) do
        :ok -> :ok
        {:error, reason} -> {:error, "Failed to create directory: #{reason}"}
      end
    end

    # Elixirのデータ構造をJSON文字列に変換
    case Jason.encode(data) do
      {:ok, json_string} ->
        # JSON文字列を指定したファイルに書き込み
        case File.write(file_path, json_string) do
          :ok -> {:ok, "File saved successfully!"}
          {:error, reason} -> {:error, "Failed to save file: #{reason}"}
        end
      {:error, reason} ->
        {:error, "Failed to encode JSON: #{reason}"}
    end
  end
end
