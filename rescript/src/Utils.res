module Utils = {
  let id = (a) => a

  let toArr = (str: string): array<string> =>
    str
    -> Js.String2.castToArrayLike
    -> Js.Array2.fromMap(_, id)
  
  let toList = (str: string): list<string> =>
    str
    -> toArr
    -> Belt.List.fromArray

  let removeItem = (item, arr) => {
    let itemIndex = arr -> Js.Array2.indexOf(_, item)
    arr
    -> Js.Array2.reducei(_, (acc, curItem, index) => {
      if (index == itemIndex) {
        acc
      } else {
        Js.Array2.concat(acc, [curItem])
      }
    }, [])
  }
}