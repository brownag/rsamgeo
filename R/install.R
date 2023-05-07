#' Install Required Python Modules
#'
#' This function installs the latest `segment-geospatial` package with dependencies. The default uses `pip` for package installation.
#' 
#' You can configure custom environments with `pip=FALSE` and additional arguments passed to `reticulate::py_install()`.
#' 
#' @param pip Use `pip` package manager? Default: `TRUE`
#' @param system Use a `system()` call to `python -m pip install ...` instead of `reticulate::py_install()`. Default: `FALSE`.
#' @param force Force update (uninstall/reinstall) and ignore existing installed packages? Default: `TRUE`. Applies only to `pip=TRUE`.
#' @param ... Additional arguments passed to `reticulate::py_install()`
#' @return `NULL`, or `try-error` (invisibly) on R code execution error.
#' @export
#' @importFrom reticulate py_install
#' @examples
#' \dontrun{
#' 
#' # install with pip (with reticulate)
#' sg_install()
#' 
#' # install with pip (system() call)
#' sg_install(system = TRUE)
#' 
#' # use virtual environment with default name "r-reticulate"
#' sg_install(pip = FALSE, method = "virtualenv")
#' 
#' # use "conda" environment named "foo"
#' sg_install(pip = FALSE, method = "conda", envname = "foo")
#' 
#' }
sg_install <- function(pip = TRUE, system = FALSE, force = TRUE, ...) {
  
  # alternately, just use a system() call to python -m pip install ...
  if (system && pip) {
    fp <- .find_python()
    if (nchar(fp) > 0) {
      return(invisible(system(
        paste(
          shQuote(fp),
          "-m pip install -U",
          ifelse(force, "--force", ""),
          "segment-geospatial"
        )
      )))
    }
  }
  
  invisible(try(reticulate::py_install(
    c("segment-geospatial"),
    pip = pip,
    pip_ignore_installed = force,
    ...
  ),
  silent = FALSE)
  )
}