defmodule GameParser do
  def parse(document) when is_binary(document) do
    document
    |> Floki.parse_document!
    |> parse_score
  end

  defp parse_score(document) do
    top = parse_inning(document, "top")
    bottom = parse_inning(document, "bottom")

    %{
      top: top,
      bottom: bottom
    }

  end

  defp parse_inning(document, attack) do
    inning = document
    |> Floki.find("tr.#{attack}")

    name = inning
    |> Floki.find("span.hide_sp")
    |> Floki.text()

    scores = inning
    |> Floki.find("td")
    |> Enum.filter(fn {_tag, attrs, _value} ->
      not Enum.any?(attrs, fn{attr, _attr_val} -> attr == "class" end)
    end )
    |> Enum.map(fn {_tag,_attr,value} -> value end)


    total = inning
    |> Floki.find("td.total-1")
    |> Floki.text()

    %{
      name: name,
      scores: List.flatten(scores),
      total: total
    }
  end

end
