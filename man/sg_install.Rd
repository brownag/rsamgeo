% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/install.R
\name{sg_install}
\alias{sg_install}
\title{Install Required Python Modules}
\usage{
sg_install(pip = TRUE, system = FALSE, force = TRUE, ...)
}
\arguments{
\item{pip}{Use \code{pip} package manager? Default: \code{TRUE}}

\item{system}{Use a \code{system()} call to \verb{python -m pip install ...} instead of \code{reticulate::py_install()}. Default: \code{FALSE}.}

\item{force}{Force update (uninstall/reinstall) and ignore existing installed packages? Default: \code{TRUE}. Applies only to \code{pip=TRUE}.}

\item{...}{Additional arguments passed to \code{reticulate::py_install()}}
}
\value{
\code{NULL}, or \code{try-error} (invisibly) on R code execution error.
}
\description{
This function installs the latest \code{segment-geospatial} package with dependencies. The default uses \code{pip} for package installation.
}
\details{
You can configure custom environments with \code{pip=FALSE} and additional arguments passed to \code{reticulate::py_install()}.
}
\examples{
\dontrun{

# install with pip (with reticulate)
sg_install()

# install with pip (system() call)
sg_install(system = TRUE)

# use virtual environment with default name "r-reticulate"
sg_install(pip = FALSE, method = "virtualenv")

# use "conda" environment named "foo"
sg_install(pip = FALSE, method = "conda", envname = "foo")

}
}
