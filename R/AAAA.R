#' @importFrom reticulate import
#' @importFrom reticulate py_run_string
.loadModules <-  function() {
  # TODO: store modules in package environment not global variables?

  if (is.null(sg)) {
    try({
      sg <<- reticulate::import("samgeo", delay_load = TRUE)
    }, silent = TRUE)
  }

  # note: requires Python >= 3.8; but is not essential for functioning of package
  try(reticulate::py_run_string("from importlib.metadata import version"), silent = TRUE)

  !is.null(sg)
}

#' @importFrom reticulate py_discover_config
.has_python3 <- function() {
  # get reticulate python information
  # NB: reticulate::py_config() calls configure_environment() etc.
  #     .:. use py_discover_config()
  x <- try(reticulate::py_discover_config(), silent = TRUE)

  # need python 3 for reticulate
  # need python 3.7+ for SAM
  if (length(x) > 0 && !inherits(x, 'try-error')) {
    if (numeric_version(x$version) >= "3.7") {
      return(TRUE)
    } else if (numeric_version(x$version) >= "3.0") {
      return(FALSE)
    }
  }
  FALSE
}

#' @importFrom reticulate configure_environment
.onLoad <- function(libname, pkgname) {
  sg <<- NULL
  if (.has_python3()) {
    if (!.loadModules()) {
      x <- try(reticulate::configure_environment(pkgname), silent = TRUE)
      if (!inherits(x, 'try-error')) {
        .loadModules()
      }
    }
  }
}

#' @importFrom utils packageVersion
.onAttach <- function(libname, pkgname) {
  sgv <- sg_version()
  if (inherits(sgv, 'try-error'))
    sgv <- "<Not Found>"
  packageStartupMessage(
    "rsamgeo v",
    utils::packageVersion("rsamgeo"),
    " -- using samgeo v", sgv,
    ifelse(sg_torch_cuda_is_available(), " w/ CUDA", "")
  )
}

.find_python <- function() {
  # find python
  py_path <- Sys.which("python")
  if (nchar(py_path) == 0) {
    py_path <- Sys.which("python3")
  }
  py_path
}
