defmodule GgenkiWeb.BotController do
  use GgenkiWeb, :controller
  use Timex
  alias Ggenki.Message
  alias Ggenki.Alert

  def line_callback(conn, %{"events" => events}) do
    %{"message" => message } = List.first(events)
    %{"source" => source } = List.first(events)
    events = List.first(events)

    IO.inspect events
    endpoint_uri = "https://api.line.me/v2/bot/message/reply"

    # LINEメッセージの保存

    Ggenki.Repo.insert(%Message{user: source["userId"],body: Poison.encode!(events)})


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


  def check(conn, _params) do

    #最後の発言を確認する時間間隔
    interval_hour = 1
    #確認をする対象LINEID
    line_id = System.get_env("TARGET_LINE_USER")
    #監視対象のグループID
    line_group_id = System.get_env("TARGET_LINE_GROUP")

    message = Message
      |> Ggenki.Repo.get_by(user: line_id)
      |> Ecto.Query.last
      |> Ggenki.Repo.one

    IO.inspect message

    #最後の発言から特定の時間が経過していたら
    if message.inserted_at < Timex.shift(message.inserted_at, hour: interval_hour) do
      endpoint_uri = "https://api.line.me/v2/bot/message/reply"
      json_data = %{
                    groupId: line_group_id,
                    messages: [
                      %{
                        type: "text",
                        text: "最後の発言から" <> Integer.to_string(interval_hour) <> "以上経過したよ"# 受信したメッセージをそのまま返す
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
    end
    send_resp(conn, :no_content, "")
  end


end