proc decode(data: string, unique: int): int =
  for i in 0..data.len - unique:
    block inner:
      let chars = data[i..i + unique - 1]
      for j in 0..unique - 2:
        if chars[j] in chars[j+1..^1]:
          break inner
      return i + unique
  return -1

let data = stdin.readAll()
echo decode(data, 4)
echo decode(data, 14)
