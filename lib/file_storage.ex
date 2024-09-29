defmodule JsonStorage do
  @moduledoc """
  JSONデータをファイルに保存および読み込むためのモジュール。
  """

  def save(nil) do
    IO.puts("取得済み.")
  end
  def save({data, file_path}) do
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
