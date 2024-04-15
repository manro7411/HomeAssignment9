defmodule MessagePassingSystem.Server do
  def start_link(port) do
    {:ok, listen_socket} = :gen_tcp.listen(port, [:binary, {:active, true}])
    IO.puts("Server started and listening on port #{port}.")
    loop(listen_socket, %{})
  end

  defp loop(socket, clients) do
    case :gen_tcp.accept(socket) do
      {:ok, client_socket} ->
        IO.puts("New client connected.")
        spawn_link(fn -> handle_client(client_socket, clients) end)
        loop(socket, Map.put(clients, client_socket, nil))
      {:error, reason} ->
        IO.puts("Error accepting connection: #{reason}")
        loop(socket, clients)
    end
  end

  defp handle_client(socket, clients) do
    receive do
      {:tcp, _socket, data} ->
        IO.puts("Received message from client: #{data}")
        broadcast(data, clients, socket)
        handle_client(socket, clients)
      {:tcp_closed, _socket} ->
        IO.puts("Client disconnected.")
    end
  end

  defp broadcast(data, clients, sender_socket) do
    for client_socket <- Map.keys(clients) do
      unless client_socket == sender_socket do
        :gen_tcp.send(client_socket, data)
      end
    end
  end
end
