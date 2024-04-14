defmodule MessagePassingSystem.Client do
  def start_link(server_ip, port, name) do
    Task.start_link(fn -> loop(server_ip, port, name) end)
  end

  defp loop(server_ip, port, name) do
    {:ok, socket} = :gen_tcp.connect(server_ip, port, [:binary])
    IO.puts("Connected to server.")
    send_message(socket, name <> ": Connected.")
    receive_messages(socket)
  end

  defp receive_messages(socket) do
    receive do
      {:tcp, _socket, data} ->
        IO.puts("Received message: #{String.trim(data)}")
        receive_messages(socket)
      {:tcp_closed, _socket} ->
        IO.puts("Connection to server closed.")
    end
  end

  def send_message(socket, message) do
    :gen_tcp.send(socket, message)
  end
end
