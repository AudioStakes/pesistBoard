defmodule FlaskOnPhoenix.StickyView do
  use FlaskOnPhoenix.Web, :view
  def render("index.json", %{stickys: stickys}) do
    # stickysの各stickyを下記のsticky.jsonで表示する
    %{stickys: render_many(stickys, FlaskOnPhoenix.StickyView, "sticky.json")}
  end

  def render("sticky.json", %{sticky: sticky}) do
    # stickyのid, content, stickyのuserのemail をJSON形式で表示する
    # %{id: sticky.id, body: sticky.content, user: sticky.user.email}
    %{
      id: sticky.id, left: sticky.left, top: sticky.top, width: sticky.width, height: sticky.height,
      scaleX: sticky.scaleX, scaleY: sticky.scaleY, angle: sticky.angle, group_left: sticky.group_left, group_top: sticky.group_top,
      group_width: sticky.group_width, group_height: sticky.group_height, group_scaleX: sticky.group_scaleX, group_scaleY: sticky.group_scaleY, group_angle: sticky.group_angle,
      text: sticky.text
    }
  end
end