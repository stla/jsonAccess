#' @useDynLib HSdll
.jsonAccess <- function(json, path){
  .C("jsonAccessR", json=json, path=path,
     lpath=length(path), result="")$result
}
.jsonElemsAt <- function(json, indices){
  .C("jsonElemsAtR", json=json, indices=indices,
     lindices=length(indices), result="")$result
}




#' Title
#'
#' @param json json string
#' @param path character vector
#'
#' @return json string
#' @export
#' @importFrom jsonlite validate
#' @importFrom magrittr "%>%"
#' @examples
#' json <- "{\"a\":{\"b\":8,\"c\":[1,2]},\"b\":null}"
#' jsonAccess(json, "a")
#' jsonAccess(json, "b")
#' jsonAccess(json, "X")
#' jsonAccess(json, c("a","c"))
jsonAccess <- function(json, path){
  # TODO: check valid json
  #class(json) <- "json" ...
  # if(!validate(json))
  .jsonAccess(json=as.character(json), path=as.character(path))
}

#' Title
#'
#' @param json json string
#' @param path character vector
#'
#' @return json stringjavascript:;
#' @export
#'
#' @examples
#' json <- "{\"a\":{\"b\":8,\"c\":[0,1,\"hello\"]},\"b\":null}"
#' ( arr <- jsonAccess(json, c("a","c")) )
#' jsonElemsAt(arr, c(0,2))
#' jsonElemsAt(arr, 2)
#' jsonElemsAt(arr, c(1,3))
jsonElemsAt <- function(json, indices){
  .jsonElemsAt(json=as.character(json), indices=as.integer(indices))
}
