defmodule NpbGamesCrawler do
  @moduledoc """
  Documentation for `NpbGamesCrawler`.
  """

  @base_url "https://npb.jp/scores/2024/0329/g-t-01/"

  def crawl() do
    HTTPoison.get!("#{@base_url}").body
    |> GameParser.parse()
  end
end
