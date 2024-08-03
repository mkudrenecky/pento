defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, session, socket) do
    {:ok,
     assign(socket,
       score: 0,
       message: "Make a guess homie:",
       time: time(),
       answer: :rand.uniform(10) |> to_string(),
       guess: nil,
       session_id: session["live_socket_id"]
     )}
  end

  def render(assigns) do
    ~H"""
    <h1 class="mb-4 text-4xl font-extrabold">Your score: <%= @score %></h1>
    <h2>
      <%= @message %> It's <%= @time %>
    </h2>
    <br />
    <h2>
      <%= for n <- 1..10 do %>
        <.link
          class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
          phx-click="guess"
          phx-value-number={n}
        >
          <%= n %>
        </.link>
      <% end %>
    </h2>
    <br />
    <pre>
    <%= @current_user.email %>
    <%= @current_user.username %>
    <%= @session_id %>
    </pre>
    <%= if @guess == @answer do %>
      <h2>hello winner</h2>
      <.link phx-click="reset"> You win! Click to play again!</.link>
    <% end %>
    """
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    time = time()
    answer = socket.assigns.answer
    assign(socket, guess: guess)

    cond do
      guess == answer ->
        score = socket.assigns.score + 1
        message = "Correct"
        {:noreply, assign(socket, message: message, score: score, time: time)}

      true ->
        score = socket.assigns.score - 1
        message = "#{guess}! Wrong guess! Guess again"
        {:noreply, assign(socket, message: message, score: score, time: time)}
    end
  end

  def handle_event("reset", _socket) do
  end

  def time() do
    DateTime.utc_now() |> to_string
  end
end

