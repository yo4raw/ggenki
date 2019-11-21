defmodule GgenkiWeb.BotController do
  use GgenkiWeb, :controller
  alias Ggenki.Message
  alias Ggenki.Alert

  def line_callback(conn, %{"events" => events}) do
    %{"message" => message } = List.first(events)
    %{"source" => source } = List.first(events)
    events = List.first(events)

    IO.inspect events
    endpoint_uri = "https://api.line.me/v2/bot/message/reply"

    # LINEメッセージの保存
    message = Message.insert(%Message{user: source["userId"],body: Poison.encode(events)})


    json_data = %{
                  replyToken: events["replyToken"],
                  messages: [
                    %{
                      type: "text",
                      text: message["text"] # 受信したメッセージをそのまま返す
                    }
                  ]
                } |> Poison.encode!

    headers = %{
      "Content-Type" => "application/json",
      "Authorization" => "Bearer " <> System.get_env("LINE_ACCESS_TOKEN") #メッセージ送受信設定|>アクセストークンからアクセストークンを取得
    }

    case HTTPoison.post(endpoint_uri, json_data, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end

    send_resp(conn, :no_content, "")
  end
  def check(conn, %{"events" => events}) do
    %{"message" => message } = List.first(events)
    %{"source" => source } = List.first(events)
    events = List.first(events)

    IO.inspect events
    endpoint_uri = "https://api.line.me/v2/bot/message/reply"

    json_data = %{
                  replyToken: events["replyToken"],
                  messages: [
                    %{
                      type: "text",
                      text: message["text"] # 受信したメッセージをそのまま返す
                    }
                  ]
                } |> Poison.encode!

    headers = %{
      "Content-Type" => "application/json",
      "Authorization" => "Bearer " <> System.get_env("LINE_ACCESS_TOKEN") #メッセージ送受信設定|>アクセストークンからアクセストークンを取得
    }

    case HTTPoison.post(endpoint_uri, json_data, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end

    send_resp(conn, :no_content, "")
  end


end