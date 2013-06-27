defmodule History do

  def match?(module, fun, args) do
    fn_invocations = history(module)

    matching_fns = Enum.filter(fn_invocations, fn {_, {m, f, a}, _} ->
                     m == module && f == fun
                   end)

    matching_args_and_fns = Enum.filter(matching_fns, fn {_, {_,_,a}, _} -> args_match(args, a) end)

    !Enum.empty?(matching_args_and_fns)
  end

  defp history(module) do
    :meck.history(module)
  end

  defp args_match([expected_arg|t1], [actual_arg|t2]) when is_regex(expected_arg) and is_bitstring(actual_arg) do
    Regex.match?(expected_arg, actual_arg) && args_match(t1, t2)
  end

  defp args_match([expected_arg|t1], [actual_arg|t2]) do
    (expected_arg == actual_arg) && args_match(t1, t2)
  end

  defp args_match([], []) do
    true
  end

  defp args_match(_, _) do
    false
  end

end