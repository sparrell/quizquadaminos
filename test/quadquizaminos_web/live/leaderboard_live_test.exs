defmodule QuadquizaminosWeb.LeaderboardLiveTest do
  use QuadquizaminosWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Quadquizaminos.Accounts
  alias Quadquizaminos.Accounts.User
  alias Quadquizaminos.GameBoard.Records

  test "users can access leaderboard", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/leaderboard")

    assert html =~ "<h1>Leaderboard</h1>"
  end

  test "top 10 games played are displayed", %{conn: conn} do
    Enum.each(1..15, fn num ->
      attrs = %{name: "Quiz Block ", uid: Integer.to_string(num), role: "player"}
      {:ok, user} = Accounts.create_user(%User{}, attrs)

      game_record = %{
        start_time: ~U[2021-04-20 06:00:53Z],
        end_time: DateTime.utc_now(),
        uid: user.uid,
        score: 10 * num,
        dropped_bricks: 10,
        correctly_answered_qna: 2
      }

      Records.record_player_game(true, game_record)
    end)

    {:ok, _view, html} = live(conn, "/leaderboard")
    assert row_count(html) == 10
    assert html =~ "<th>Player</th>"
    assert html =~ "<th>Start time</th>"
    assert html =~ "<th>End time</th>"
    assert html =~ "<th>Date</th>"
  end

  test "user can be redicted to view player bottom blocks ", %{conn: conn} do
    bottom = %{
      <<1, 20>> => <<1, 20, 112, 105, 110, 107>>,
      <<1, 19>> => <<1, 19, 112, 105, 110, 107>>,
      <<1, 18>> => <<1, 18, 112, 105, 110, 107>>,
      <<1, 17>> => <<1, 17, 112, 105, 110, 107>>
    }

    attrs = %{name: "Quiz Block ", uid: "100", role: "player"}
    {:ok, user} = Accounts.create_user(%User{}, attrs)

    game_record = %{
      start_time: ~U[2021-04-20 06:00:53Z],
      end_time: DateTime.utc_now(),
      uid: user.uid,
      score: 100,
      dropped_bricks: 10,
      correctly_answered_qna: 2,
      bottom_blocks: bottom
    }

    {:ok, record} = Records.record_player_game(true, game_record)
    {:ok, _view, html} = live(conn, "/leaderboard/#{record.id}")
    assert html =~ "<p><b>End game status for Quiz Block </b>"
  end

  defp row_count(html) do
    row =
      ~r/<tr>/
      |> Regex.scan(html)
      |> Enum.count()

    # row is deducted by 2 due to the <tr> for table head and also <tr> for footer
    row - 2
  end
end
