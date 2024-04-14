defmodule ValueStorageServer.Command do

 @doc """
Runs the given command.
"""
def run(command)

def run({:create, bucket}, pid) do
  ValueStorage.Registry.create(pid, bucket)
  {:ok, "OK\r\n"}
end


def run({:get, bucket, key}) do
    lookup(bucket, fn pid ->
        value = ValueStorage.Bucket.get(pid, key)
        {:ok, "#{value}\r\nOK\r\n"}
    end)
end

def run({:put, bucket, key, value}) do
    lookup(bucket, fn pid ->
        ValueStorage.Bucket.put(pid, key, value)
        {:ok, "OK\r\n"}
    end)
end

def run({:delete, bucket, key}) do
    lookup(bucket, fn pid ->
        ValueStorage.Bucket.delete(pid, key)
        {:ok, "OK\r\n"}
    end)
end

defp lookup(bucket, callback) do
    case ValueStorage.Registry.lookup(ValueStorage.Registry, bucket) do
        {:ok, pid} -> callback.(pid)
        :error -> {:error, :not_found}
    end
end


  def parse(line) do
    case String.split(line) do
        ["CREATE", bucket] -> {:ok, {:create, bucket}}
        ["GET", bucket, key] -> {:ok, {:get, bucket, key}}
        ["PUT", bucket, key, value] -> {:ok, {:put, bucket, key, value}}
        ["DELETE", bucket, key] -> {:ok, {:delete, bucket, key}}
        _ -> {:error, :unknown_command}
    end
end

end
