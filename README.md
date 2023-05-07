
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {rsamgeo}

<!-- badges: start -->

[![Open in Google
Colab](https://camo.githubusercontent.com/84f0493939e0c4de4e6dbe113251b4bfb5353e57134ffd9fcab6b8714514d4d1/68747470733a2f2f636f6c61622e72657365617263682e676f6f676c652e636f6d2f6173736574732f636f6c61622d62616467652e737667)](https://colab.research.google.com/drive/1DwHUc1Vpgg1dRTSKB7AY5puDM_2uB8MY?usp=sharing)
<!-- badges: end -->

The goal of {rsamgeo} is to provide a basic R wrapper around the
[`segment-geospatial`](https://github.com/opengeos/segment-geospatial)
‘Python’ package by [Dr. Qiusheng Wu](https://github.com/giswqs). Uses R
{reticulate} package to call tools for segmenting geospatial data with
the [Meta ‘Segment Anything Model’
(SAM)](https://github.com/facebookresearch/segment-anything). The
‘segment-geospatial’ package draws its inspiration from
‘segment-anything-eo’ repository authored by [Aliaksandr
Hancharenka](https://github.com/aliaksandr960).

## Installation

You can install the development version of {rsamgeo} like so:

``` r
remotes::install_github("brownag/rsamgeo")
rsamgeo::sg_install()
```

## Example

After installing the package and the ‘Python’ dependencies, we can
download some sample data using `tms_to_geotiff()`

``` r
library(rsamgeo)

samgeo()$tms_to_geotiff(
  output = "satellite.tif",
  bbox = c(-120.3704, 37.6762, -120.368, 37.6775),
  zoom = 20L,
  source = 'Satellite',
  overwrite = TRUE
)
```

The SAM `model_type` specifies the SAM model you wish to use. Trained
model data used for segmentation are downloaded if the file `checkpoint`
is not found. Downloading this for the first time may take a while.
Create an instance of your desired model with `sg_samgeo()`

``` r
out_dir <- path.expand(file.path('~', 'Downloads'))
checkpoint <- file.path(out_dir, 'sam_vit_h_4b8939.pth')

sam <- sg_samgeo(
  model_type = 'vit_h',
  checkpoint = checkpoint,
  erosion_kernel = c(3L, 3L),
  mask_multiplier = 255L,
  sam_kwargs = NULL
)
```

Finally, generate a segmented image from the input, processing the input
in chunks as needed with `batch=TRUE`. Note that you want this
processing to run on the GPU with CUDA enabled. For the [Google Colab
Notebook]((https://colab.research.google.com/drive/1DwHUc1Vpgg1dRTSKB7AY5puDM_2uB8MY?usp=sharing))
example remember to set the notebook runtime to ‘GPU’.

``` r
sg_generate(sam, 
            "satellite.tif", 
            "segment.tif", 
            batch = TRUE)
```

Now that we have processed the input data, we can convert the segmented
image to vectors and write them out as a layer in a GeoPackage for
subsequent use.

``` r
sam$tiff_to_gpkg("segment.tif",
                 "segment.gpkg",
                 simplify_tolerance=NULL)
```

It is then fairly easy to overlay our segment polygons on the original
satellite image with {terra}:

``` r
library(terra)
r <- rast("satellite.tif")
v <- vect("segment.gpkg")
v$ID <- seq_len(nrow(v))
plotRGB(r)
plot(v, col = v$ID, alpha = 0.25, add = TRUE)
```
