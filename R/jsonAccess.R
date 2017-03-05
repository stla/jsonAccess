#' @useDynLib HSdll
.jsonAccess <- function(json, path){
  .C("jsonAccessR", json=json, path=path,
     lpath=length(path), result="")$result
}
.jsonElemsAt <- function(json, indices){
  .C("jsonElemsAtR", json=json, indices=indices,
     lindices=length(indices), result="")$result
}
.jsonElemAt <- function(json, index){
  .C("jsonElemAtR", json=json, index=index, result="")$result
}
.jsonElemAt_ifNumber <- function(json, index){
  .C("jsonElemAt_ifNumberR", json=json, index=index, result="")$result
}
.jsonElemAt_ifObject <- function(json, index){
  .C("jsonElemAt_ifObjectR", json=json, index=index, result="")$result
}
.jsonElemAt_ifArray <- function(json, index){
  .C("jsonElemAt_ifArrayR", json=json, index=index, result="")$result
}
.jsonElemAt_ifString <- function(json, index){
  .C("jsonElemAt_ifStringR", json=json, index=index, result="")$result
}
.jsonElemAt_ifBool <- function(json, index){
  .C("jsonElemAt_ifBoolR", json=json, index=index, result="")$result
}
.jsonMembers <- function(json){
  .C("jsonMembersR", json=json, result="")$result
}
.jsonPretty <- function(json, indent, numformat){
  .C("jsonPrettyR", json=json, indent=indent, format=numformat, result="")$result
}


#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`

#' @title Access to the value of a JSON string
#' @description Access to the value of a JSON string by giving a sequence
#' of keys.
#' @param json a JSON string
#' @param path character vector, sequence of keys
#' @param toJSON logical, whether to apply \code{\link[jsonlite]{toJSON}} to
#' the input
#' @param fromJSON logical, whether to apply \code{\link[jsonlite]{fromJSON}} to
#' the output
#'
#' @return A json string if \code{fromJSON=FALSE}, a R object if \code{fromJSON=TRUE}.
#' @seealso \code{\link{jsonElemsAt}}
#' @export
#' @importFrom jsonlite validate toJSON fromJSON
#' @examples
#' json <- "{\"a\":{\"b\":8,\"c\":[1,2]},\"b\":null}"
#' jsonAccess(json, "a")
#' jsonAccess(json, "b")
#' jsonAccess(json, "X")
#' jsonAccess(json, c("a","c"))
#' # get the result as a R object:
#' jsonAccess(json, c("a","c"), fromJSON=TRUE)
#' # same as:
#' jsonAccess(json, c("a","c")) %>% jsonlite::fromJSON(.)
#' @note Instaed of using the option \code{toJSON=TRUE}, you can apply
#' \code{\link[jsonlite]{toJSON}} before; this allows you to apply it
#' with its options. Same remark for the option \code{toJSON=FALSE}.
jsonAccess <- function(json, path, toJSON=FALSE, fromJSON=FALSE){
  # check valid json
  if(toJSON){
    json <- jsonlite::toJSON(json)
  }else if(!validate(json)){
    if(!validate(json <- as.character(json))){
      stop("Not a valid JSON string. Try option `toJSON=TRUE`.")
    }
  }
  out <- .jsonAccess(json=as.character(json), path=as.character(path))
  if(fromJSON){
    out <- jsonlite::fromJSON(out)
  }
  return(out)
}

#' Sub-array of a JSON array
#' @description Returns a sub-array of a JSON array by giving the desired
#' indices.
#' @param json json string
#' @param indices integer vector
#' @param toJSON logical, whether to apply \code{\link[jsonlite]{toJSON}} to
#' the input
#' @param fromJSON logical, whether to apply \code{\link[jsonlite]{fromJSON}} to
#' the output
#' @return A json string if \code{fromJSON=FALSE}, a R object if \code{fromJSON=TRUE}.
#' @export
#' @seealso \code{\link{jsonElemAt}}, \code{\link{jsonAccess}}
#' @examples
#' json <- "{\"a\":{\"b\":8,\"c\":[0,1,\"hello\"]},\"b\":null}"
#' ( arr <- jsonAccess(json, c("a","c")) )
#' jsonElemsAt(arr, c(0,2))
#' jsonElemsAt(arr, 2)
#' jsonElemsAt(arr, c(1,3))
#' # chain with the pipe operator:
#' jsonAccess(json, c("a","c")) %>% jsonElemsAt(2)
jsonElemsAt <- function(json, indices, toJSON=FALSE, fromJSON=FALSE){
  if(toJSON){
    json <- jsonlite::toJSON(json)
  }
  out <- .jsonElemsAt(json=as.character(json), indices=as.integer(indices))
  if(fromJSON){
    out <- jsonlite::fromJSON(out)
  }
  return(out)
}

#' Extract element of a JSON array
#' @description Returns the element of a JSON array by giving the desired
#' index.
#' @param json json string
#' @param index integer
#' @param toJSON logical, whether to apply \code{\link[jsonlite]{toJSON}} to
#' the input
#' @param fromJSON logical, whether to apply \code{\link[jsonlite]{fromJSON}} to
#' the output
#' @return A JSON string if \code{fromJSON=FALSE}, a R object if \code{fromJSON=TRUE}.
#' @export
#' @seealso \code{\link{jsonElemsAt}}, \code{\link{jsonElemAt_ifNumber}}, \code{\link{jsonAccess}}
#' @examples
#' json <- "[0,1,\"hello\",null,\"bird\"]"
#' jsonElemAt(json, 2)
#' jsonElemAt(json, 3)
#' jsonElemAt(json, 10) == "null"
#' jsonElemsAt(json, 1:4) %>% jsonElemAt(3)
#' jsonElemAt("{\"a\":{\"b\":8}}", 0) == "null"
jsonElemAt <- function(json, index, toJSON=FALSE, fromJSON=FALSE){
  if(toJSON){
    json <- jsonlite::toJSON(json)
  }
  out <- .jsonElemAt(json=as.character(json), index=as.integer(index))
  if(fromJSON){
    out <- jsonlite::fromJSON(out)
  }
  return(out)
}

#' Extract a number from a JSON array
#' @description Returns the number in a JSON array by giving its index;
#' returns \code{"null"} if there is no number at this index.
#' @param json JSON string
#' @param index integer
#' @param toJSON logical, whether to apply \code{\link[jsonlite]{toJSON}} to
#' the input
#' @param fromJSON logical, whether to apply \code{\link[jsonlite]{fromJSON}} to
#' the output
#' @return A JSON string if \code{fromJSON=FALSE}, a R object if \code{fromJSON=TRUE}.
#' @export
#' @seealso \code{\link{jsonElemAt}}, \code{\link{jsonAccess}}
#' @examples
#' json <- "[1,0,\"hello\",null,\"bird\"]"
#' jsonElemAt_ifNumber(json, 0)
#' jsonElemAt_ifNumber(json, 2) == "null"
#' jsonElemAt_ifNumber(json, 3)
jsonElemAt_ifNumber <- function(json, index, toJSON=FALSE, fromJSON=FALSE){
  if(toJSON){
    json <- jsonlite::toJSON(json)
  }
  out <- .jsonElemAt_ifNumber(json=as.character(json), index=as.integer(index))
  if(fromJSON){
    out <- jsonlite::fromJSON(out)
  }
  return(out)
}

#' Extract an object from a JSON array
#' @description Returns the object in a JSON array by giving its index;
#' returns \code{"null"} if there is no object at this index.
#' @param json JSON string
#' @param index integer
#' @param toJSON logical, whether to apply \code{\link[jsonlite]{toJSON}} to
#' the input
#' @param fromJSON logical, whether to apply \code{\link[jsonlite]{fromJSON}} to
#' the output
#' @return A JSON string if \code{fromJSON=FALSE}, a R object if \code{fromJSON=TRUE}.
#' @export
#' @seealso \code{\link{jsonElemAt}}, \code{\link{jsonAccess}}
#' @examples
#' json <- "[1,0,{},null,\"bird\"]"
#' jsonElemAt_ifObject(json, 2)
#' jsonElemAt_ifObject(json, 1) == "null"
#' jsonElemAt_ifObject(json, 3)
jsonElemAt_ifObject <- function(json, index, toJSON=FALSE, fromJSON=FALSE){
  if(toJSON){
    json <- jsonlite::toJSON(json)
  }
  out <- .jsonElemAt_ifObject(json=as.character(json), index=as.integer(index))
  if(fromJSON){
    out <- jsonlite::fromJSON(out)
  }
  return(out)
}

#' Extract an array from a JSON array
#' @description Returns the array in a JSON array by giving its index;
#' returns \code{"null"} if there is no array at this index.
#' @param json JSON string
#' @param index integer
#' @param toJSON logical, whether to apply \code{\link[jsonlite]{toJSON}} to
#' the input
#' @param fromJSON logical, whether to apply \code{\link[jsonlite]{fromJSON}} to
#' the output
#' @return A JSON string if \code{fromJSON=FALSE}, a R object if \code{fromJSON=TRUE}.
#' @export
#' @seealso \code{\link{jsonElemAt}}, \code{\link{jsonAccess}}
#' @examples
#' json <- "[1,[{},2],null,\"bird\"]"
#' jsonElemAt_ifArray(json, 2)
#' jsonElemAt_ifArray(json, 1) == "null"
#' jsonElemAt_ifArray(json, 3)
jsonElemAt_ifArray <- function(json, index, toJSON=FALSE, fromJSON=FALSE){
  if(toJSON){
    json <- jsonlite::toJSON(json)
  }
  out <- .jsonElemAt_ifArray(json=as.character(json), index=as.integer(index))
  if(fromJSON){
    out <- jsonlite::fromJSON(out)
  }
  return(out)
}

#' Extract a string from a JSON array
#' @description Returns the string in a JSON array by giving its index;
#' returns \code{"null"} if there is no string at this index.
#' @param json JSON string
#' @param index integer
#' @param toJSON logical, whether to apply \code{\link[jsonlite]{toJSON}} to
#' the input
#' @param fromJSON logical, whether to apply \code{\link[jsonlite]{fromJSON}} to
#' the output
#' @return A JSON string if \code{fromJSON=FALSE}, a R object if \code{fromJSON=TRUE}.
#' @export
#' @seealso \code{\link{jsonElemAt}}, \code{\link{jsonAccess}}
#' @examples
#' json <- "[1,\"hello\",null,\"bird\"]"
#' jsonElemAt_ifString(json, 1)
#' jsonElemAt_ifString(json, 0) == "null"
jsonElemAt_ifString <- function(json, index, toJSON=FALSE, fromJSON=FALSE){
  if(toJSON){
    json <- jsonlite::toJSON(json)
  }
  out <- .jsonElemAt_ifString(json=as.character(json), index=as.integer(index))
  if(fromJSON){
    out <- jsonlite::fromJSON(out)
  }
  return(out)
}

#' Extract a Boolean from a JSON array
#' @description Returns the Boolean in a JSON array by giving its index;
#' returns \code{"null"} if there is no Boolean at this index.
#' @param json JSON string
#' @param index integer
#' @param toJSON logical, whether to apply \code{\link[jsonlite]{toJSON}} to
#' the input
#' @param fromJSON logical, whether to apply \code{\link[jsonlite]{fromJSON}} to
#' the output
#' @return A JSON string if \code{fromJSON=FALSE}, a R object if \code{fromJSON=TRUE}.
#' @export
#' @seealso \code{\link{jsonElemAt}}, \code{\link{jsonAccess}}
#' @examples
#' json <- "[1,true,null,\"bird\"]"
#' jsonElemAt_ifBool(json, 1)
#' jsonElemAt_ifBool(json, 0) == "null"
jsonElemAt_ifBool <- function(json, index, toJSON=FALSE, fromJSON=FALSE){
  if(toJSON){
    json <- jsonlite::toJSON(json)
  }
  out <- .jsonElemAt_ifBool(json=as.character(json), index=as.integer(index))
  if(fromJSON){
    out <- jsonlite::fromJSON(out)
  }
  return(out)
}

#' Members of a JSON string
#' @description Returns the members of a JSON string as a JSON string array.
#' @param json JSON string
#' @param toJSON logical, whether to apply \code{\link[jsonlite]{toJSON}} to
#' the input
#' @param fromJSON logical, whether to apply \code{\link[jsonlite]{fromJSON}} to
#' the output
#' @return A JSON string if \code{fromJSON=FALSE}, a R object if \code{fromJSON=TRUE}.
#' @export
#' @seealso \code{\link{jsonElemAt}}, \code{\link{jsonAccess}}
#' @examples
#' json <- "{\"a\":{\"b\":8,\"c\":[1,2]},\"b\":[10,11]}"
#' jsonMembers(json)
jsonMembers <- function(json, toJSON=FALSE, fromJSON=FALSE){
  if(toJSON){
    json <- jsonlite::toJSON(json)
  }
  out <- .jsonMembers(json=as.character(json))
  if(fromJSON){
    out <- jsonlite::fromJSON(out)
  }
  return(out)
}

#' Pretty JSON string
#' @description Returns a JSON string in pretty format.
#'
#' @param json JSON string
#' @param indent indentation per level of nesting; choices are
#' \code{"indent0"} (remove \strong{all} white spaces), \code{"indent1"},
#' \code{"indent2"}, \code{"indent3"}, \code{"indent3"}, and
#' \code{"tab"} (tabulation)
#' @param numformat number format; choices are:
#' \itemize{
#'      \item \code{"generic"}: integer literals for integers (1, 2, ...),
#'      simple decimals for fractional values between 0.1 and 9999999,
#'      and scientific notation otherwise
#'      \item \code{"decimal"}: standard decimal notation
#'      \item \code{"scientific"}: scientific notation
#' }
#' @param toJSON logical, whether to apply \code{\link[jsonlite]{toJSON}} to
#' the input
#' @return A JSON string.
#' @export
#' @examples
#' json <- "{\"a\": {\"b\": 8, \"c\": [1,2]}, \"b\": [10.14, 11.618]}"
#' jsonPretty(json) %>% cat
#' jsonPretty(json, indent="indent0") %>% cat
#' jsonPretty(json, indent="tab", numformat="scientific") %>% cat
jsonPretty <- function(json, indent="indent2", numformat="generic", toJSON=FALSE){
  indent <- match.arg(indent, choices=c("indent0", "indent1", "indent2", "indent3", "indent4", "tab"))
  numformat <- match.arg(numformat, choices=c("generic", "scientific", "decimal"))
  if(toJSON){
    json <- jsonlite::toJSON(json)
  }
  out <- .jsonPretty(json=as.character(json), indent=indent, numformat=numformat)
  return(out)
}
