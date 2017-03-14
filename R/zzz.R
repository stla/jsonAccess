.onLoad <- function(libname, pkgname) {
  library.dynam("JsonAccessR", pkgname, libname)
  .C("HsStart")
  invisible()
}

.onUnLoad <- function(libpath) {
  library.dynam.unload("JsonAccessR", libpath)
  invisible()
}

