open Promise

type path = string
type encoding = string

@module("fs/promises") external readFile: (path, encoding) => Promise.t<string> = "readFile"

module ReadFile = {
  let readFileWithCallback = (path: path) =>
    readFile(path, "utf-8")
    ->then((text) => {
      Some(text
      -> Js.String2.replaceByRe(_, %re("/'\r'?\n/g"), " ") // replace regexp in .bs.js file
      -> Js.String2.replaceByRe(_, %re("/ +/g"), " "))
    }->resolve)
    ->catch((er) => {
      Js.log2("Error", er)
      None
    }->resolve)
}