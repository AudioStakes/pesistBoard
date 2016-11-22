defmodule FlaskOnPhoenix.RoomChannel do
  use Phoenix.Channel
  alias FlaskOnPhoenix.Repo
  alias FlaskOnPhoenix.Sticky

  def join("rooms:lobby", auth_msg, socket) do
    {:ok, socket}
  end
  def join("rooms:" <> _private_room_id, _auth_msg, socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("sticky:create", %{"left" => x, "top" => y, "backgroundColor" => f}, socket) do
    # Stickyモデル内のレコード数をカウント
    length = Sticky
    |> Sticky.record_length
    |> Repo.all

    # 付与するＩＤを計算
    next_id = Enum.at(length, 0) + 1

    # 新規作成する付箋をStickyモデルへ追加　
    # params = %{id: next_id, left: x, top: y, backgroundColor: f, width: 200, height: 200,
    # scaleX: 1, scaleY: 1, angle: 1, group_left: 1, group_top: 1,
    # group_width: 1, group_height: 1, group_scaleX: 1, group_scaleY: 1, group_angle: 1,
    # text: "テキスト"
    # }
    params = %{
      text: "テキスト",
      id: next_id,
      left: x,
      top: y,
      backgroundColor: f, 
      width: 200,
      height: 200,
      scaleX: 1,
      scaleY: 1,
      angle: 1,
      group_left: 1,
      group_top: 1,
      group_width: 1,
      group_height: 1,
      group_scaleX: 1,
      group_scaleY: 1,
      group_angle: 1
    }
    changeset = Sticky.changeset(%Sticky{}, params)
    Repo.insert!(changeset)

    # 新規作成する付箋をクライアントへ送信
    broadcast! socket, "sticky:create", params
    {:noreply, socket}
  end

  def handle_in("frame:create", %{"left" => x, "top" => y}, socket) do
    broadcast! socket, "frame:create", %{left: x, top: y}
    {:noreply, socket}
  end

  def handle_in("sticky:modified", %{
      "id" => a, "left" => b, "top" => c, "width" => d, "height" => e,
      "scaleX" => f, "scaleY" => g, "angle" => h, "group_left" => i, "group_top" => j,
      "group_width" => k, "group_height" => l, "group_scaleX" => m, "group_scaleY" => n, "group_angle" => o,
      "text" => p
    }, socket) do

    # 該当するIDのstickyデータを取得、updateデータ作成、update
    sticky = Repo.get!(Sticky, a)
    # sticky_params = %{
    #   left: 1, top: 1, width: 1, height: 1,
    #   scaleX: 1, scaleY: 1, angle: 1, group_left: 1, group_top: 1,
    #   group_width: 1, group_height: 1, group_scaleX: 1, group_scaleY: 1, group_angle: 1,
    #   text: "test"
    # }
    sticky_params = %{
      left: b, top: c, width: d, height: e,
      scaleX: f, scaleY: g, angle: h, group_left: i, group_top: j,
      group_width: k, group_height: l, group_scaleX: m, group_scaleY: n, group_angle: o,
      text: p
    }
    sticky_params = %{
      text: "テキスト",
      id: a,
      left: b,
      top: c,
      backgroundColor: "#f7e6ce"
    }
    changeset = Sticky.changeset(sticky, sticky_params)
    # changeset = Sticky.changeset(sticky, Map.put(sticky_params, :id, a))
    Repo.update(changeset)

    # updateしたstickyデータをクライアントへ送信
    broadcast! socket, "sticky:modified", sticky_params
    {:noreply, socket}
  end
end