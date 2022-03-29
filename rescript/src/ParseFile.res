open ReadFile
open Parser
open Promise

ReadFile.readFileWithCallback("../dictionary")
-> then((text) => text 
  -> Belt.Option.map(_, (str) => switch str -> Parser.parseString {
  | Some(anagrams) => Js.log(anagrams)
  | None => ()
  })->resolve)->ignore