defmodule MathProblems do

  @default_count 10
  @default_limit 100
  @min_limit 10
  @operators {:+, :-}
  @blank_operand "___"

  @doc """
  generate random integer between 1 and limit
  """
  def gen_random_int(limit) when is_integer(limit) do
    :random.uniform(limit)
  end

  def gen_operator(), do: elem(@operators, :random.uniform(2) - 1)

  def gen_math_problem(limit) when is_integer(limit) do
    {n1, n3} = {gen_random_int(limit), gen_random_int(limit)}
    if n1 > n3, do: {n1, n3} = {n3, n1}
    n2 = n3 - n1
    blank_postion = gen_random_int(3) - 1
    operator = gen_operator()

    numbers = case operator do
      :+ -> [n1, n2, n3]
      :- -> [n3, n1, n2]
      _  -> raise "invalid operator #{operator}"
    end
    [op1, op2, result] = List.replace_at(numbers, blank_postion, @blank_operand)
    [op1, operator, op2, :=, result]
  end

  def get_problems(1, problems, limit)
      when is_list(problems) and is_integer(limit) do
    [gen_math_problem(limit) | problems]
  end

  def get_problems(count, problems, limit)
      when is_integer(count) and is_list(problems) and is_integer(limit) do
    [gen_math_problem(limit) | get_problems(count-1, problems, limit)]
  end

  def printable(elem) when is_atom(elem), do: to_string(elem)
  def printable(elem), do: :io_lib.format("~3s", [to_string(elem)])

  def format(problem) when is_list(problem) do
    Enum.map_join(problem, " ", &printable/1)
  end

  def process(:help) do
    IO.puts """
    usage: issue [--count count] [--limit limit]
    """
    System.halt(0)
  end

  def process({count, limit}) do
    :random.seed(:os.timestamp)
    get_problems(count, [], limit)
    |> Enum.map(&format/1)
    |> Enum.each(&IO.puts/1)
  end

  @doc """
  `argv` can be -h or --help, which returns :help

  Otherwise it is a github user name, project name, and (optionally)
  the number of entries to format.

  Return a tuple of `{user, project, count}`, or `:help` if help was given
  """
  def parse_args(argv) do
    {options, _, _} = OptionParser.parse(argv,
            switches: [help: :boolean, count: :integer, limit: :integer],
            aliases: [h: :help, c: :count, l: :limit])

    count = options[:count]
    limit = options[:limit]
    cond do
      options[:help] -> :help

      is_integer(count) and count > 0 and is_integer(limit) and limit >= @min_limit
        -> {count, limit}

      is_integer(count) and count > 0
        -> {count, @default_limit}

      is_integer(limit) and limit >= @min_limit
        -> {@default_count, limit}

      true ->{@default_count, @default_limit}
    end
  end

  @doc """
  generate random simple math problems for kids
  """
  def main(argv) do
    parse_args(argv)
     |> process
  end
end
