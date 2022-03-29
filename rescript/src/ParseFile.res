open ReadFile
open Parser

let callback = (string: string) => {
  switch string
  -> Parser.parseString {
  | Some(anagrams) => Js.log(anagrams)
  | None => ()
  }
}

ReadFile.readFileWithCallback(callback, "../dictionary")