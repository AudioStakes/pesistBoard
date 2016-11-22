defmodule FlaskOnPhoenix.StickyController do
  use FlaskOnPhoenix.Web, :controller
  alias FlaskOnPhoenix.Repo
  alias FlaskOnPhoenix.Sticky

  @doc """
  メッセージ一覧取得API
  """
  def index(conn, _params) do
    # すべてのメッセージを取得。userも一緒にロードしておく
    stickys = Repo.all(Sticky)
    render conn, :index, stickys: stickys
  end

  # TODO: authentication（ユーザー登録した場合）
end