open Domain
open Utils

type charsArr = array<string>
type anagrams = (string, string)

type anagramsStorage = {
  anagrams: anagrams,
  charsArr: charsArr,
  completed: bool
}

let rec isAnagram = (word: list<string>, dictionary: charsArr): option<charsArr> => {
  switch word {
  | list{} => Some(dictionary)
  | list{head, ...tail} => {
    if Js.Array2.indexOf(dictionary, head) != -1 {
      Utils.removeItem(head, dictionary)
      -> isAnagram(tail, _)
    } else {
      None
    }
  }
  }
}

let updateAnagramsStorage = (angrmsStrg: option<anagramsStorage>, word: string): option<anagramsStorage> => {
  let charsList = word -> Utils.toList
  switch angrmsStrg {
  | Some({
    anagrams: (anagram, ""),
    charsArr,
    completed: false
  }) => {
    switch isAnagram(charsList, charsArr) {
    | Some(dictionary) => {
      if (dictionary -> Js.Array2.length > 0) {
        Some({
          anagrams: (anagram, ""),
          charsArr,
          completed: false
        })
      } else {
        Some({
          anagrams: (anagram, word),
          charsArr: [],
          completed: true
        })
      }
    }
    | None => 
      Some({
        anagrams: (anagram, ""),
        charsArr,
        completed: false
      })
    }
  }
  | None =>
    charsList
    -> isAnagram(_, Domain.dictionaryArr)
    -> Belt.Option.map((charsArr) => {
      anagrams: (word, ""),
      charsArr,
      completed: false
    })
  | strg => strg
  }
}

module Parser = {
  let parseString = (str: string): option<array<anagrams>> => {
    let wordList = str
      -> Js.String2.split(_, " ")
      -> Belt.List.fromArray
    let rec goThroughList = (wordList: list<string>, anagramsStorages: option<array<anagramsStorage>>) => {
      switch wordList {
      | list{} => anagramsStorages
      | list{head, ...tail} => {
        switch anagramsStorages {
        | Some(strgs) => {
          let updatedStrgs = strgs
            -> Js.Array2.reduce(_, (acc, strg) => {
              switch updateAnagramsStorage(Some(strg), head) {
              | Some(updStrg) => Js.Array2.concat(acc, [updStrg])
              | None          => Js.Array2.concat(acc, [strg])
              }
            }, [])
          let goThroughAnagrams = tail -> goThroughList
          switch updateAnagramsStorage(None, head) {
          | Some(strg) => Some([strg]
            -> Js.Array2.concat(updatedStrgs, _))
            -> goThroughAnagrams
          | None => Some(updatedStrgs) -> goThroughAnagrams
          }
          
        }
        | None => tail
          -> goThroughList(
            _,
            updateAnagramsStorage(None, head)
            -> Belt.Option.map(_, (strg) => [strg])
          )
        }
      }
      }
    }
    wordList
    -> goThroughList(_, None)
    -> Belt.Option.map(_, (anagramsStrgs) => {
      anagramsStrgs
      -> Js.Array2.filter(_, (strg) => strg.completed == true)
      -> Js.Array2.map(_, (strg) => strg.anagrams)
    }) 
  }
}
