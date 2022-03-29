import { readFile } from 'fs/promises'
import { findAnagrams } from './parser'

readFile('../dictionary', 'utf-8')
  .then((data) => data
    .replace(/\r?\n/g, " ")
    .replace(/ +/g, " "))
  .then(findAnagrams)
  .then((result) => {
    console.log(result);
  })
  .catch((err) => {
    console.error(err);
  })