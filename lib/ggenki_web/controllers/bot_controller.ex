defmodule GgenkiWeb.BotController do
  use GgenkiWeb, :controller
  use Timex
  alias Ggenki.Message
  alias Ggenki.Alert

  import Ecto.Query, only: [from: 2]

  def line_callback(conn, %{"events" => events}) do
    %{"message" => message } = List.first(events)
    %{"source" => source } = List.first(events)
    events = List.first(events)

    IO.inspect events
    endpoint_uri = "https://api.line.me/v2/bot/message/reply"

    # LINEメッセージの保存
    Ggenki.Repo.insert(%Message{user: source["userId"],body: Poison.encode!(events)})

    send_resp(conn, :no_content, "")
  end


  def check(conn, _) do

    #最後の発言を確認する時間間隔
    interval_hour = 23
    #確認をする対象LINEID
    line_id = System.get_env("TARGET_LINE_USER")
    #監視対象のグループID
    line_group_id = System.get_env("TARGET_LINE_GROUP")

    message = Message
                |> Message.latest_comment_by_user(line_id)
                |> Ggenki.Repo.one

    IO.inspect message


    {_, target_message_datetime} = DateTime.from_naive(message.inserted_at,"Etc/UTC")
    add_interval_target_message_datetime =  Timex.shift(target_message_datetime, hours: interval_hour,  minutes: 0)

    IO.puts "Timex.now===="
    IO.inspect Timex.now
    IO.puts "add_interval_target_message_datetime===="
    IO.inspect add_interval_target_message_datetime

    IO.inspect DateTime.compare(add_interval_target_message_datetime,Timex.now)

    #最後の発言から特定の時間が経過していたら
    if DateTime.compare(add_interval_target_message_datetime,Timex.now) == :lt do
      IO.puts "時間経過"
      alert_count= Alert
              |> Alert.get_by_message(message.id)
              |> Ggenki.Repo.aggregate(:count, :id)
      IO.inspect alert_count
      if alert_count == 0 do
        IO.puts "Alertにもない"
        endpoint_uri = "https://api.line.me/v2/bot/message/push"
        json_data = %{
                      to: line_group_id,
                      messages: [
                        %{
                          type: "text",
                          text: "最後の発言から" <> Integer.to_string(interval_hour) <> "時間以上経過したよ"# 受信したメッセージをそのまま返す
                        }
                      ]
                    } |> Poison.encode!

        headers = %{
          "Content-Type" => "application/json",
          "Authorization" => "Bearer " <> System.get_env("LINE_ACCESS_TOKEN") #メッセージ送受信設定|>アクセストークンからアクセストークンを取得
        }
#        case HTTPoison.post(endpoint_uri, json_data, headers) do
#          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
#            IO.puts body
#          {:ok, %HTTPoison.Response{status_code: 404}} ->
#            IO.puts "Not found :("
#          {:error, %HTTPoison.Error{reason: reason}} ->
#            IO.inspect reason
#        end

        #alertsに該当のメッセージを格納
        Ggenki.Repo.insert(%Alert{message_id: message.id})

      end
    end
    send_resp(conn, :no_content, "")
  end


end