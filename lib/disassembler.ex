defmodule Disassembler do
  @opcodes_list %{
      "00" => "PUSH0", # An empty array of bytes is pushed onto the stack.
      "PUSH0" => "PUSHF",
      "01" => "PUSHBYTES1", # 0x01-0x4B The next opcode bytes is data to be pushed onto the stack
      "4b" => "PUSHBYTES75",
      "4c" => "PUSHDATA1", # The next byte contains the number of bytes to be pushed onto the stack.
      "4d" => "PUSHDATA2", # The next two bytes contain the number of bytes to be pushed onto the stack.
      "4e" => "PUSHDATA4", # The next four bytes contain the number of bytes to be pushed onto the stack.
      "4f" => "PUSHM1", # The number -1 is pushed onto the stack.
      "51" => "PUSH1", # The number 1 is pushed onto the stack.
      "PUSH1" => "PUSHT",
      "52" => "PUSH2", # The number 2 is pushed onto the stack.
      "53" => "PUSH3", # The number 3 is pushed onto the stack.
      "54" => "PUSH4", # The number 4 is pushed onto the stack.
      "55" => "PUSH5", # The number 5 is pushed onto the stack.
      "56" => "PUSH6", # The number 6 is pushed onto the stack.
      "57" => "PUSH7", # The number 7 is pushed onto the stack.
      "58" => "PUSH8", # The number 8 is pushed onto the stack.
      "59" => "PUSH9", # The number 9 is pushed onto the stack.
      "5a" => "PUSH10", # The number 10 is pushed onto the stack.
      "5b" => "PUSH11", # The number 11 is pushed onto the stack.
      "5c" => "PUSH12", # The number 12 is pushed onto the stack.
      "5d" => "PUSH13", # The number 13 is pushed onto the stack.
      "5e" => "PUSH14", # The number 14 is pushed onto the stack.
      "5f" => "PUSH15", # The number 15 is pushed onto the stack.
      "60" => "PUSH16", # The number 16 is pushed onto the stack.
      "61" => "NOP", # Does nothing.
      "62" => "JMP",
      "63" => "JMPIF",
      "64" => "JMPIFNOT",
      "65" => "CALL",
      "66" => "RET",
      "67" => "APPCALL",
      "68" => "SYSCALL",
      "69" => "TAILCALL",
      "6a" => "DUPFROMALTSTACK",
      "6b" => "TOALTSTACK", # Puts the input onto the top of the alt stack. Removes it from the main stack.
      "6c" => "FROMALTSTACK", # Puts the input onto the top of the main stack. Removes it from the alt stack.
      "6d" => "XDROP",
      "72" => "XSWAP",
      "73" => "XTUCK",
      "74" => "DEPTH", # Puts the number of stack items onto the stack.
      "75" => "DROP", # Removes the top stack item.
      "76" => "DUP", # Duplicates the top stack item.
      "77" => "NIP", # Removes the second-to-top stack item.
      "78" => "OVER", # Copies the second-to-top stack item to the top.
      "79" => "PICK", # The item n back in the stack is copied to the top.
      "7a" => "ROLL", # The item n back in the stack is moved to the top.
      "7b" => "ROT", # The top three items on the stack are rotated to the left.
      "7c" => "SWAP", # The top two items on the stack are swapped.
      "7d" => "TUCK", # The item at the top of the stack is copied and inserted before the second-to-top item.
      "7e" => "CAT", # Concatenates two strings.
      "7f" => "SUBSTR", # Returns a section of a string.
      "80" => "LEFT", # Keeps only characters left of the specified point in a string.
      "81" => "RIGHT", # Keeps only characters right of the specified point in a string.
      "82" => "SIZE", # Returns the length of the input string.
      "83" => "INVERT", # Flips all of the bits in the input.
      "84" => "AND", # Boolean and between each bit in the inputs.
      "85" => "OR", # Boolean or between each bit in the inputs.
      "86" => "XOR", # Boolean exclusive or between each bit in the inputs.
      "87" => "EQUAL", # Returns 1 if the inputs are exactly equal", 0 otherwise.
      "8b" => "INC", # 1 is added to the input.
      "8c" => "DEC", # 1 is subtracted from the input.
      "8d" => "SIGN",
      "8f" => "NEGATE", # The sign of the input is flipped.
      "90" => "ABS", # The input is made positive.
      "91" => "NOT", # If the input is 0 or 1", it is flipped. Otherwise the output will be 0.
      "92" => "NZ", # Returns 0 if the input is 0. 1 otherwise.
      "93" => "ADD", # a is added to b.
      "94" => "SUB", # b is subtracted from a.
      "95" => "MUL", # a is multiplied by b.
      "96" => "DIV", # a is divided by b.
      "97" => "MOD", # Returns the remainder after dividing a by b.
      "98" => "SHL", # Shifts a left b bits, preserving sign.
      "99" => "SHR", # Shifts a right b bits, preserving sign.
      "9a" => "BOOLAND", # If both a and b are not 0, the output is 1. Otherwise 0.
      "9b" => "BOOLOR", # If a or b is not 0, the output is 1. Otherwise 0.
      "9c" => "NUMEQUAL", # Returns 1 if the numbers are equal, 0 otherwise.
      "9e" => "NUMNOTEQUAL", # Returns 1 if the numbers are not equal, 0 otherwise.
      "9f" => "LT", # Returns 1 if a is less than b, 0 otherwise.
      "a0" => "GT", # Returns 1 if a is greater than b, 0 otherwise.
      "a1" => "LTE", # Returns 1 if a is less than or equal to b, 0 otherwise.
      "a2" => "GTE", # Returns 1 if a is greater than or equal to b, 0 otherwise.
      "a3" => "MIN", # Returns the smaller of a and b.
      "a4" => "MAX", # Returns the larger of a and b.
      "a5" => "WITHIN", # Returns 1 if x is within the specified range (left-inclusive), 0 otherwise.
      "a7" => "SHA1", # The input is hashed using SHA-1.
      "a8" => "SHA256", # The input is hashed using SHA-256.
      "a9" => "HASH160",
      "aa" => "HASH256",
      "ac" => "CHECKSIG",
      "ae" => "CHECKMULTISIG",
      "c0" => "ARRAYSIZE",
      "c1" => "PACK",
      "c2" => "UNPACK",
      "c3" => "PICKITEM",
      "c4" => "SETITEM",
      "c5" => "NEWARRAY", #用作引用類型
      "c6" => "NEWSTRUCT", #用作值類型
      "f0" => "THROW",
      "f1" => "THROWIFNOT"
    };
    # TODO add more extended opcodes
    @extended_opcodes %{
      "62" => 3,
      "63" => 3,
      "64" => 3
    }

  # see example https://neotracker.io/contract/ce3a97d7cfaa770a5e51c5b12cd1d015fbb5f87d
  def parse_script(hex_string) do
      hex_string
      |> String.codepoints
      |> Enum.chunk(2)
      |> Enum.map(&Enum.join/1)
      |> make_list
      |> Enum.with_index
      |> IO.inspect
      |> Enum.reduce("", fn({code, index}, acc) ->
        cond do
          Map.has_key?(@opcodes_list, code) and String.length(code) == 2 ->
            acc <> to_string(index) <> ": " <> @opcodes_list[code] <> "\n"
          String.length(code) == 2 ->
            {bytes, _} = Integer.parse(code, 16)
            acc <> to_string(index) <> ": PUSHBYTES" <> to_string(bytes) <> "\n"
          true ->
            # TODO parse instruction lengths on certain opcodes here
            opcode_key = String.slice(code, 0..1)
            args = String.slice(code, 2..-1)
            acc <> to_string(index) <> ": " <> @opcodes_list[opcode_key] <> " " <> args <>  "\n"
        end
      end)
  end

  defp make_list(initial_list) do
    Enum.reduce(@extended_opcodes, initial_list, fn({opcode, repeat_value}, acc_list) ->
      case Enum.split_while(acc_list, fn(list_item) -> list_item != opcode end) do
        {_, []} ->
          acc_list
        {pre_opcode_match, non_empty_list} ->
          {opcodes_to_be_joined, remaining_list} = Enum.split(non_empty_list, repeat_value)
          joined_item = Enum.join(opcodes_to_be_joined)
          pre_opcode_match ++ [joined_item | remaining_list]
      end
    end)
  end

  defp parse_instruction_lengths do
    # I think this is the last step to parse the instruction lengths for certain opcodes
  end


  # TODO remove this code when finished - its not going to be used but keeping it in case we need
  # to work with bitstrings for some reason
  # def verification(hex_string) do
  #   case Base.decode16(hex_string, case: :lower) do
  #     :error -> IO.puts("error")
  #     {:ok, result} ->
  #       IO.puts("success")
  #       IO.inspect(result)
  #       <<b :: size(8), bits :: bitstring>> = result
  #       first_args = String.slice(hex_string, 2..67)
  #       optext = "0: PUSHBYTES" <> to_string(b) <> " 0x" <> first_args
  #       IO.inspect(optext)
  #       remaining_string = String.slice(hex_string, 68..-1)
  #       if (remaining_string == "ac"), do: IO.puts("1: CHECKSIG")
  #   end
  # end

  # def invocation(hex_string) do
  #   case Base.decode16(hex_string, case: :lower) do # is there a need to handle different encodings?
  #     :error -> IO.puts("error") # Figure out how to handle error later
  #     {:ok, result} ->
  #       string_results_list = for <<byte::8 <- result>>, do: Integer.to_string(byte, 16)
  #       str = string_results_list
  #         |> Enum.map(fn(result_item) ->
  #           cond do
  #             result_item == "0" -> "00"
  #             true -> result_item
  #           end
  #         end)
  #         |> Enum.join()
  #       IO.inspect str
  #       parse_script(str)
  #   end
  # end
end
