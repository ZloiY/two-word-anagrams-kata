import { removeItem } from './utils';
import { dictArr } from './domain';

type word = string;
type anagrams = [ word, word ];
type charsArr = Array<string>

type anagramsStorage = {
  anagrams: anagrams;
  charsArr: charsArr;
  completed: boolean;
}

type maybeAnagramStorage = anagramsStorage | null;
type maybeAnagramStorageArr = Array<anagramsStorage> | null

const isWordAnagram = (oneWord: charsArr, dictionary: charsArr): charsArr | null => {
  if (oneWord.length > 0) {
    const [head, ...tail] = oneWord;
    if (dictionary.indexOf(head) == -1) {
      return null
    } else {
      return isWordAnagram(tail, removeItem<word>(dictionary, head));
    }
  } else {
    return dictionary
  }
};

const updateAnagramsStorage = (oneWord: word, anagramsStorage: maybeAnagramStorage): maybeAnagramStorage => {
  const wordChars = oneWord.split("");
  if (anagramsStorage == null) {
    const charsArr = isWordAnagram(wordChars, dictArr);
    return !!charsArr ? {
      anagrams: [oneWord, ""],
      charsArr: charsArr,
      completed: false,
    } : null;
  } else {
    const { anagrams: [anagram], charsArr } = anagramsStorage;
    const newCharsArr = isWordAnagram(wordChars, charsArr);
    if (newCharsArr && newCharsArr.length == 0 && oneWord.length > 0) {
      return {
        anagrams: [anagram, oneWord],
        charsArr: [],
        completed: true
      }
    } else {
      return anagramsStorage;
    }
  }
}

const goThroughWordList = (words: Array<word>): maybeAnagramStorageArr => {
  if (words.length > 0) {
    let anagramsStorageArr: maybeAnagramStorageArr = null;
    words.forEach((head) => {
      if (anagramsStorageArr == null) {
        const newStrg = updateAnagramsStorage(head, null);
        if (newStrg != null) anagramsStorageArr = [newStrg];
      } else {
        anagramsStorageArr = anagramsStorageArr.reduce((acc, strg) => {
          const updatedStrg = updateAnagramsStorage(head, strg);
          return [...acc, updatedStrg]
        }, [])
        const newStrg = updateAnagramsStorage(head, null);
        if (newStrg != null) anagramsStorageArr.push(newStrg)
      }
    });
    return anagramsStorageArr;
  } else {
    return null;
  }
}

export const findAnagrams = (words: string): Array<anagrams> | null => {
  const wordsArr = words.split(" ");
  const parsedArr = goThroughWordList(wordsArr);
  return !!parsedArr ? parsedArr
    .filter(x => x.completed)
    .map(x => x.anagrams)
    : null
}
