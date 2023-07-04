defmodule MemoryGame do
  def start(num_players) do
    vowels = ["A", "E", "I", "O", "U"]
    consonants = ["B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "X", "Y", "Z"]
    letters = vowels ++ consonants

    pairs = Enum.shuffle(letters) |> Enum.take(6)
    pairs = pairs ++ pairs |> Enum.shuffle()

    board = Enum.chunk(pairs, 4)

    play(board, 3, 6, num_players, 0)
  end


  def play(board, attempts, pairs_count, num_players, pairs_found) do
    IO.puts("Bienvenido al juego de memoria")
    IO.puts("Tienes #{attempts} oportunidades para encontrar los #{pairs_count} pares.")

    Enum.each(1..num_players, fn player ->
      loop(board, attempts, pairs_count, pairs_found, [], [], player)
    end)
  end

  def loop(board, attempts, pairs_count, pairs_found, found_pairs, revealed, player) do
    IO.puts("Turno del jugador #{player}")

    if attempts == 0 do
      IO.puts("Juego terminado. No has encontrado todos los pares.")
      IO.puts("Pares encontrados: #{pairs_found}")
    else
      print_board(board, revealed)

      IO.puts("Elige dos numeros del 1 al 12:")
      choice1 = get_input()
      choice2 = get_input()

      card1 = get_card(board, choice1)
      card2 = get_card(board, choice2)

      IO.puts("Carta 1: #{card1}")
      IO.puts("Carta 2: #{card2}")

      if card1 == card2 do
        IO.puts("Has encontrado un par")
        new_found_pairs = found_pairs ++ [card1]
        new_revealed = reveal_card(revealed, choice1, board) |> reveal_card(choice2, board)
        pairs_count = pairs_count - 1
        new_pairs_found = pairs_found + 1

        if pairs_count == 0 do
          IO.puts("Felicitaciones. Has encontrado todos los pares.")
          IO.puts("Pares encontrados: #{new_pairs_found}")
        else
          loop(board, attempts, pairs_count, new_pairs_found, new_found_pairs, new_revealed, player)
        end
      else
        IO.puts("No es un par. Intentalo nuevamente.")
        loop(board, attempts - 1, pairs_count, pairs_found, found_pairs, revealed, player)
      end
    end
  end

  def print_board(board, revealed) do
    IO.puts("Tablero:")
    Enum.each(board, fn row ->
      row_formatted = Enum.map(row, fn letter ->
        if is_revealed?(revealed, letter) do
          letter
        else
          "*"
        end
      end)
      IO.inspect(row_formatted, pretty: false)
    end)
  end

  def is_revealed?(revealed, letter) do
    Enum.member?(revealed, letter)
  end

  def reveal_card(revealed, number, board) do
    revealed ++ [get_card(board, number)]
  end

  def get_card(board, number) do
    {row_index, col_index} = number_to_indices(number)
    Enum.at(Enum.at(board, row_index - 1), col_index - 1)
  end

  def number_to_indices(number) do
    row_index = div(number - 1, 4) + 1
    col_index = rem(number - 1, 4) + 1
    {row_index, col_index}
  end

  def get_input do
    IO.gets("") |> String.trim() |> String.to_integer()
  end
end

MemoryGame.start(2)
