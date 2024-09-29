defmodule NpbGamesCrawlerTest do
  use ExUnit.Case
  doctest NpbGamesCrawler

  test "scoresのリンクを取得できるか" do
    year = "2024"
    months = ["03"]

    expected = [
      {"https://npb.jp/scores/2024/0329/g-t-01/", "scores/2024/0329/g-t-01.json"},
      {"https://npb.jp/scores/2024/0329/s-d-01/", "scores/2024/0329/s-d-01.json"},
      {"https://npb.jp/scores/2024/0329/db-c-01/", "scores/2024/0329/db-c-01.json"},
      {"https://npb.jp/scores/2024/0329/e-l-01/", "scores/2024/0329/e-l-01.json"},
      {"https://npb.jp/scores/2024/0329/m-f-01/", "scores/2024/0329/m-f-01.json"},
      {"https://npb.jp/scores/2024/0329/b-h-01/", "scores/2024/0329/b-h-01.json"},
      {"https://npb.jp/scores/2024/0330/g-t-02/", "scores/2024/0330/g-t-02.json"},
      {"https://npb.jp/scores/2024/0330/s-d-02/", "scores/2024/0330/s-d-02.json"},
      {"https://npb.jp/scores/2024/0330/db-c-02/", "scores/2024/0330/db-c-02.json"},
      {"https://npb.jp/scores/2024/0330/e-l-02/", "scores/2024/0330/e-l-02.json"},
      {"https://npb.jp/scores/2024/0330/m-f-02/", "scores/2024/0330/m-f-02.json"},
      {"https://npb.jp/scores/2024/0330/b-h-02/", "scores/2024/0330/b-h-02.json"},
      {"https://npb.jp/scores/2024/0331/g-t-03/", "scores/2024/0331/g-t-03.json"},
      {"https://npb.jp/scores/2024/0331/s-d-03/", "scores/2024/0331/s-d-03.json"},
      {"https://npb.jp/scores/2024/0331/db-c-03/", "scores/2024/0331/db-c-03.json"},
      {"https://npb.jp/scores/2024/0331/e-l-03/", "scores/2024/0331/e-l-03.json"},
      {"https://npb.jp/scores/2024/0331/m-f-03/", "scores/2024/0331/m-f-03.json"},
      {"https://npb.jp/scores/2024/0331/b-h-03/", "scores/2024/0331/b-h-03.json"}
    ]

    result = NpbGamesCrawler.makeScoreLinks(year, months)
    #IO.inspect(result, label: "Test Output - makeScoreLinks Result")

    assert result == expected
  end
end
