import { findAnagrams } from './parser';
import { dictArr } from './domain';

const removeItemById = <T>(arr: Array<T>, id: number) => arr.filter((_, index) => index != id); 

const generateAnagram = (minWordLength: number, dictionary: Array<string>): string => {
  const maxWordLength = dictionary.length
  const firstWordLength = Math.floor(Math.random() * (maxWordLength - minWordLength)) + minWordLength
  const secondWordLength = maxWordLength - firstWordLength;
  const generateWord = (wordLength: number, dictionary: Array<string>, gennedWord: Array<string> | null): [Array<string> | null, Array<string>] => {
    if (wordLength > 0) {
      const randomDictCharIndex = Math.floor(Math.random() * (dictionary.length - 1));
      const char = dictionary[randomDictCharIndex];
      const newDictionary = removeItemById<string>(dictionary, randomDictCharIndex);
      return !!gennedWord ?
        generateWord(wordLength - 1, newDictionary, [...gennedWord, char]) :
        generateWord(wordLength - 1, newDictionary, [char])
    } else {
      return [gennedWord, dictionary]
    }
  }
  const [ firstWord, leftDict ] = generateWord(firstWordLength, dictionary, null)
  const [ secondWord ] = generateWord(secondWordLength, leftDict, null)
  return `${firstWord.join('')} ${secondWord.join('')}`;
}

const generateString = (pairQuantity: number): string => {
  let currentPairQuantity = pairQuantity;
  let currentString = '';
  while (currentPairQuantity > 0) {
    currentString = currentString.concat(" ", generateAnagram(2, dictArr))
    currentPairQuantity--;
  }
  return currentString
}
console.log(findAnagrams(generateString(10)))