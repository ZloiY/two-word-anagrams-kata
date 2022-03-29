open Promise

type path = string
type encoding = string

@module("fs/promises") external readFile: (path, encoding) => Promise.t<string> = "readFile"

module ReadFile = {
  let readFileWithCallback = (callback: (string) => (), path: path) =>
    readFile(path, "utf-8")
    ->then((text) => {
      text
      -> Js.String2.replaceByRe(_, %re("/'\r'?\n/g"), " ") // replace regexp in .bs.js file
      -> Js.String2.replaceByRe(_, %re("/ +/g"), " ")
      -> callback
    }->resolve)
    ->catch((er) => {
      Js.log2("Error", er)
    }->resolve)->ignore
}