#' aec_extract_f - extract subsets geographically
#'
#' The dorling algorithm doesn't work on the entire country,
#' because it is very clustered at the cities. To get a reasonable
#' cartogram we need to extract out the cities, expand these
#' with dorling independently. This function does the extraction.
#' @export
#' @param aec_data data with centroids of electoral divisions
#' @param ctr centroids of subset
#' @param expand how large a chunk to cut out
#'
#' @examples
#' data(nat_map.rda)
#' data(nat_data)
#' aec_data_syd <- aec_extract(nat_data, expand=list(c(2,3)))
aec_extract_f <- function(aec_data, ctr=c(151.2, -33.8),
                          expand=c(3,4.5), ...) {
  aec_data_sub <- aec_data %>% filter(long_c > ctr[1]-expand[1]  &
                                        long_c < ctr[1]+expand[1] &
                                        lat_c > ctr[2]-expand[2] &
                                        lat_c < ctr[2]+expand[2])
  return(aec_data_sub)
}

#' aec_carto_f - run dorling ondata centers
#'
#' The dorling algorithm creates a non-contiguous cartogram by
#' shifting circles to alleviate overlap, while roughly maintaining
#' geographic proximity.
#' @export
#' @param aec_data_sub subset of data with centroids of electoral divisions
#' @param ... arguments to dorling function
#'
#' @examples
#' data(nat_map.rda)
#' data(nat_data)
#' aec_data_syd <- aec_extract(nat_data, expand=list(c(2,3)))
#' aec_data_dor <- aec_carto(aec_data_syd, expand=list(c(3,4.5)))
aec_carto_f <-function(aec_data_sub, polygon.vertex=6, name.text=TRUE,
                       dist.ratio=dist.ratio, iteration=100,
                       xlab="", ylab="", ...) {
  #aec_data_sub <- aec_extract(aec_data)
  aec_data_dor <- dorling(aec_data_sub$id, aec_data_sub$long_c,
                          aec_data_sub$lat_c, aec_data_sub$POPULATION,
                          polygon.vertex=polygon.vertex,
                          name.text=name.text,
                          dist.ratio=dist.ratio,
                          iteration=iteration,
                          xlab=xlab, ylab=ylab)
  return(aec_data_dor)
}

#' aec_carto_join_f - bind the cartogram corrdinates to original data
#'
#' Add the cartogram locations as new variables to original data
#' and make any of these that were not made equal to the original centroids
#' @export
#' @param aec_data_sub subset of data with centroids of electoral divisions
#' @param aec_cartocartogram centers
#'
#' @examples
#' data(nat_map.rda)
#' data(nat_data)
#' cities <- list(c(151.2, -33.8), # Sydney
#' c(153.0, -27.5), # Brisbane
#' c(145.0, -37.8), # Melbourne
#' c(138.6, -34.9), # Adelaide,
#' c(115.9, -32.0)) # Perth
#' expand <- list(c(2,3), c(2,3), c(2.5,4), c(3,5), c(5,8))
#' aec_carto <- purrr::map2(.x=cities, .y=expand,
#' .f=aec_extract_f, aec_data=nat_data) %>%
#'   purrr::map_df(aec_carto_f) %>%
#'     mutate(region=as.integer(as.character(region))) %>%
#'       rename(id=region)
#'       aec_cart_join <- aec_carto_join_f(nat_data, aec_carto)
#' ggplot(data=nat_map) +
#'   geom_polygon(aes(x=long, y=lat, group=group, order=order),
#'   fill="grey90", colour="white") +
#'     geom_point(data=aec_cart_join, aes(x=x, y=y), size=2, alpha=0.4,
#'                  colour="#572d2c") +
#'     geom_text(data=aec_cart_join, aes(x=x, y=y, label=id), size=0.5) +
#'       coord_equal()
aec_carto_join_f <- function(aec_data, aec_carto) {
  aec_carto_join <- merge(aec_data, aec_carto, by="id", all=TRUE)

  # Make corto centers of remote districts same as actual lat/long
  aec_carto_join$x[is.na(aec_carto_join$x)] <-
    aec_carto_join$long_c[is.na(aec_carto_join$x)]
  aec_carto_join$y[is.na(aec_carto_join$y)] <-
    aec_carto_join$lat_c[is.na(aec_carto_join$y)]

  return(aec_carto_join)
}

