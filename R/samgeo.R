#' `sg_version()`: Gets the `segment-geospatial` version
#' @rdname samgeo
#' @return character. Version Number.
#' @export
#' @importFrom reticulate py_eval
sg_version <- function() {
  try(reticulate::py_eval("version('segment-geospatial')"), silent = TRUE)
}

#' `Module(samgeo)` - Create `samgeo` Model Instance
#'
#' Gets the `samgeo` module instance in use by the package in current **R**/`reticulate` session.
#' @export
#'
samgeo <- function() {
  sg
}

#' @param ... Arguments to create model instance
#' @return `sg_samgeo()`: return `SamGeo` model instance
#' @export
#' @rdname samgeo
sg_samgeo <- function(...) {
  sg$SamGeo(...)
}

#' Generate SamGeo Model Segmentation Output
#'
#' Create segmented image based on input GeoTIFF.
#'
#' @param x A `SamGeo` model instance
#' @param ... Arguments to `SamGeo.generate()`
#' @export
sg_generate <- function(x, ...) {
  stopifnot(inherits(x, 'samgeo.samgeo.SamGeo'))
  x$generate(...)
}

#' Get `Module(torch)` Instance Used By `Module(samgeo)`
#'
#' @return `Module(torch)` instance from `Module(`
#'
#' @export
sg_torch <- function() {
  sg$torch
}

#'
#' @return `sg_torch_cuda_is_available()`: `logical`. Is CUDA available?
#'
#' @rdname sg_torch
#' @export
sg_torch_cuda_is_available <- function() {
  sg_torch()$cuda$is_available()
}
