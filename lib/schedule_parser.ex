defmodule ScheduleParser do
  def parse(document) when is_binary(document) do
    document
    |> Floki.parse_document!
    |> parse_score
  end

  defp parse_score(document) do
    document
    |> Floki.find("tbody a[href]")
    |> Enum.map(fn element -> Floki.attribute(element, "href") end)
  end

end
