.onLoad <- function(libname, pkgname) {
  library.dynam("HSdll", pkgname, libname)
  .C("HsStart")
  invisible()
}

.onUnLoad <- function(libpath) {
  library.dynam.unload("HSdll", libpath)
  invisible()
}

