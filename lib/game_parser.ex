defmodule GameParser do
  def parse(document) when is_binary(document) do
    document
    |> Floki.parse_document!
    |> parse_score
  end

  defp parse_score(document) do
    document
    |> Floki.find("div#table_linescore")
  end

end
