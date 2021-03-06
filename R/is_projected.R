#' Is the shape projected?
#'
#' Checks whether the shape is projected. Applicable to \code{Spatial}, \code{Raster} and \code{\link[sf:sf]{sf}} objects. In case the projection is missing, it checks whether the coordinates are within -180/180 and -90/90 (if so, it returns \code{FALSE}).
#'
#' @param x shape (from class \code{\link[sp:Spatial]{Spatial}}, \code{\link[raster:Raster-class]{Raster}}, or \code{\link[sf:sf]{sf}}), or projection (see \code{\link{get_proj4}} for options)
#' @return logical: \code{TRUE} if the shape is projected and \code{FALSE} otherwise.
#' @export
is_projected <- function(x) {
    isP <- if (inherits(x, "Raster")) {
        !couldBeLonLat(x, warnings=FALSE)
    } else {
        if (inherits(x, c("Spatial", "sf", "sfc")))
            prj <- get_projection(x)
        else prj <- get_proj4(x)

        proj4_is_projected(prj)
    }
    if (is.na(isP) && !is.character(x)) isP <- !maybe_longlat(get_bb(x)$b)
    isP
}

proj4_is_projected <- function(p) {
    if (is.na(p))
        as.logical(NA)
    else
        (length(grep("longlat", p, fixed = TRUE))==0)
}


maybe_longlat <- function(bb) {
    (bb[1] >= -180.1 && bb[3] <= 180.1 && bb[2] >= -90.1 && bb[4] <= 90.1)
}
