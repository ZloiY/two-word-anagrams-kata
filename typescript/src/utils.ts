
export function removeItem<T>(arr: Array<T>, item: T): Array<T> {
  const itemIndex = arr.indexOf(item);
  return arr.reduce((acc, item, index) => (
    index == itemIndex ? acc : [...acc ,item]
  ), [])
}
