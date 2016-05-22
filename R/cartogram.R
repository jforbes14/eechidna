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
#' @param ... other arguments
#'
#' @examples 
#' library(dplyr)
#' library(ggplot2)
#' data(nat_map)
#' data(nat_data)
#' adelaide <- aec_extract_f(nat_data, ctr=c(138.6, -34.9), expand=c(2,3))
#' ggplot(data=nat_map) + 
#'   geom_polygon(aes(x=long, y=lat, group=group, order=order),
#'     fill="grey90", colour="white") +
#'   geom_point(data=adelaide, aes(x=long_c, y=lat_c), size=2, alpha=0.4,
#'     colour="#f0027f") + 
#'   xlim(c(136, 142)) + ylim(-36, -33) +
#'   coord_equal()


aec_extract_f <- function(aec_data, ctr=c(151.2, -33.8),
                          expand=c(3,4.5), ...) {
  long_c <- NULL # to appease the package check
  lat_c <- NULL  # http://stackoverflow.com/questions/9439256/how-can-i-handle-r-cmd-check-no-visible-binding-for-global-variable-notes-when
  aec_data_sub <- aec_data %>% filter(long_c > ctr[1]-expand[1]  &
                                        long_c < ctr[1]+expand[1] &
                                        lat_c > ctr[2]-expand[2] &
                                        lat_c < ctr[2]+expand[2])
  return(aec_data_sub)
}


##' Auto complete (or cut) a vector to a fixed length
##' 
##' From https://github.com/chxy/cartogram/blob/master/R/dorling.R
##' Not exported here, but needed for aec_carto_f
##' 
##' @param cl a vector
##' @param targetlen the target length
##' @return a vector of completed cl with length n
##' @examples
##' \dontrun{
##' complete_color('red',5)
##' complete_color(c('red','blue'),5)
##' complete_color(c('red','blue','green','yellow','pink','grey'),5)
##' }
complete_color = function(cl,targetlen){
  l = length(cl)
  if (l==0) return()
  if (l < targetlen){
    cl = rep(cl,ceiling(targetlen/l))
  }
  cl=cl[1:targetlen]
  return(cl)
}

##' Draw a circle
##' 
##' ##' From https://github.com/chxy/cartogram/blob/master/R/dorling.R
##' Not exported here, but needed for aec_carto_f
##' 
##' 
##' This function is used to compute the locations of the circle 
##' border and draw multiple circles. 
##' It borrows the code from plotrix::draw.circle
##' 
##' @param xvec X-coordinates
##' @param yvec Y-coordinates
##' @param rvec Radii
##' @param vertex The number of vertices of the circle
##' @param border Color of border
##' @param col Color to render in circle
##' @param add Whether the circles are added to another plot.
##' @param square A logical value to determine whether to draw squares.
##' @param ... other things
##' @examples
##' \dontrun{
##' x=y=1:5
##' r=5:1/5
##' circle(x,y,r,add=FALSE,asp=1)
##' circle(x,y,r,vertex=6,add=TRUE)  # hexagon
##' circle(x,y,r,vertex=4,add=TRUE)  # diamond
##' circle(x,y,r,square=TRUE,add=TRUE)  # square
##' }
##'
circle = function(xvec,yvec,rvec,vertex=100,border=1,col=NULL,add=TRUE, square=FALSE,...){
  n=length(xvec)
  stopifnot(length(yvec)==n && n==length(rvec))
  if (length(border) < n)  border = rep(border, length.out = n)
  if (!is.null(col) && length(col) < n) col = rep(col, length.out = n)
  # xylim = par("usr")
  # plotdim = par("pin")
  # ymult = (xylim[4] - xylim[3])/(xylim[2] - xylim[1]) * plotdim[1]/plotdim[2]
  if (square) {
    angles = seq(pi / 4, 7 * pi / 4, by = pi / 2)
  } else {
    angle.inc = 2 * pi / vertex
    angles = seq(0, 2 * pi - angle.inc, by = angle.inc)
  }
  if (!add) plot(c(min(xvec-rvec),max(xvec+rvec)),c(min(yvec-rvec),max(yvec+rvec)),type='n', ...)
  for (i in 1:n){
    xv <- cos(angles) * rvec[i] + xvec[i]
    yv <- sin(angles) * rvec[i] + yvec[i]
    graphics::polygon(xv, yv, border = border[i], col = col[i])
  }
}



##' Produce a Pseudo-Dorling Cartogram.
##' 
##' From https://github.com/chxy/cartogram/blob/master/R/dorling.R
##' Not exported here, but needed for aec_carto_f
##' 
##' @param name A vector of region names.
##' @param centroidx A vector of x-coordinates of the regions.
##' @param centroidy A vector of y-coordinates of the regions.
##' @param density A vector of the variable of interest. It will be used as the radii of the circles.
##' @param nbr A list of the neighbors of every region. Each element is a vector of all the neighbor names of a region. If nbr=NULL, then it is assumed that no region has any neighbors. If nbr is not NULL, then names should be given to all the elements of the list, for matching the neighbors with the host region name, otherwise the parameter "name" (a character vector) will be used as the element names of nbr. Besides, any values in nbr that are not in "name" will be removed. The length of nbr could be different from the length of "name", but any element in nbr whose name is not in "name" will be removed too.
##' @param shared.border A matrix of the counts of shared borders, typically generated from the function \code{border_summary_length()}. It is used to scale the attract force.
##' @param color a vector of color to fill in the circles or polygons. Auto-completed if the length does not match with name.
##' @param tolerance Tolerant value for the sum of overlapped radii.
##' @param dist.ratio The threshold to determine whether an attract force is added. It is applied to the ratio of the distance between two centroids and the sum of the two radii.
##' @param iteration The limit of the number of iterations. Default to be 9999.
##' @param polygon.vertex The number of vertice of the circle. Default to be 100. If polygon.vertex=4 then diamonds applies. If polygon.vertex=6, then hexagon applies.
##' @param animation Whether to show the movements of centroids.
##' @param sleep.time Only works when animation=TRUE.
##' @param nbredge whether to draw the lines between neighbor regions.
##' @param name.text whether to print the region names on the circles or polygons.
##' @param ggplot2 whether to use ggplot2 to draw the cartogram.
##' @param ... other things

##' 
dorling <- function(name, centroidx, centroidy, density, nbr=NULL, shared.border=NULL, color=NULL, tolerance=0.1, dist.ratio=1.2, iteration=9999, polygon.vertex=100, animation=FALSE, sleep.time=0.3, nbredge=ifelse(is.null(nbr),FALSE,TRUE), name.text=TRUE, ggplot2=FALSE, ...){
  n=length(name)
  stopifnot(n==length(centroidx), n==length(centroidy), n==length(density), is.numeric(iteration))
  
  # color vector
  if (!is.null(color)) color=complete_color(color, n)
  
  # identify all the names
  name=as.character(name)
  if (is.null(names(nbr)) && sum(duplindex <- duplicated(name))) {
    name[duplindex]=paste(name[duplindex],name[duplindex],1:sum(duplindex),sep="_")
  }
  
  # clean "nbr"
  if (!is.null(nbr)) {        
    if (is.null(names(nbr))) {
      stopifnot(n==length(nbr))
      names(nbr)=name
    } else {
      nbr=nbr[names(nbr) %in% name]
    }
    if (any(!unlist(nbr) %in% name)) {
      nbr = lapply(nbr, function(s){s[s %in% name]})
    }
    edge = data.frame(A=rep(names(nbr),times=sapply(nbr,length)),B=unname(unlist(nbr)))
    edge = t(apply(edge,1,sort))
    edge = edge[!duplicated(edge),]
  }
  
  # Set up the data
  dat=data.frame(name=name,x=centroidx,y=centroidy,density=density,stringsAsFactors=FALSE)
  rownames(dat)=dat$name
  
  # original distance
  origindist=as.matrix(dist(dat[,2:3]))
  
  # rescale the density (the radius) # 3/5/parameter here?
  dat$density=dat$density/max(dat$density)*mean(origindist)/5
  
  # the closest distance for paired centroids
  circleDist=outer(dat$density,dat$density,"+")
  diag(circleDist)=0
  colnames(circleDist)=rownames(circleDist)=name
  
  # set up initial values
  # crtloc is the current centroid locations
  # frc is the force, including repel force and attract force
  crtloc=frc=dat[,2:3]
  crtDist=origindist
  s=0
  err=circleDist-crtDist
  
  while (sum(sapply(err,max,0))>tolerance) {
    s = s + 1
    if (!is.null(iteration) && s>iteration) {
      warning("Reach the largest iteration limit.")
      break
    }
    if (s%%10==0) cat("Iteration: ",s,"\n")
    if (animation) {
      circle(crtloc$x,crtloc$y,dat$density,vertex=polygon.vertex,
             border=if(is.null(color) | all(color==color[1])){1}else{color},
             col=color,add=FALSE,xaxt='n',yaxt='n', ...)
      points(crtloc$x,crtloc$y,col=if(is.null(color)){2}else{color},pch=20)
      if (nbredge) segments(crtloc[edge[,1],1],crtloc[edge[,1],2],
                            crtloc[edge[,2],1],crtloc[edge[,2],2],col='grey70')
      if (name.text) text(crtloc$x,crtloc$y,dat$name,cex=0.8)
      Sys.sleep(sleep.time)
    }
    
    frc$xforce=frc$yforce=frc$xattract=frc$yattract=frc$xrepel=frc$yrepel=0.00000
    
    # Calculate the repel force
    idx = circleDist > crtDist
    #idx = idx & lower.tri(idx)
    for (i in which(rowSums(idx)>0)){
      #if (length(nbr[[name[i]]])==0) next
      for (j in which(idx[i,])){
        #for (j in na.omit(which(idx[i,])[nbr[[name[i]]]])){
        ratio=err[i,j]/crtDist[i,j]/4
        frc$xrepel[i]=frc$xrepel[i]+ratio*(crtloc$x[i]-crtloc$x[j])
        frc$xrepel[j]=frc$xrepel[j]+ratio*(crtloc$x[j]-crtloc$x[i])
        frc$yrepel[i]=frc$yrepel[i]+ratio*(crtloc$y[i]-crtloc$y[j])
        frc$yrepel[j]=frc$yrepel[j]+ratio*(crtloc$y[j]-crtloc$y[i])
      }
    }
    
    # Calculate the attract force
    for (i in 1:length(name)){
      if (length(nbr[[name[i]]])==0) next
      for (j in which(name %in% nbr[[name[i]]])){
        distratio=crtDist[i,j]/circleDist[i,j]
        if (distratio > dist.ratio & crtDist[i,j]>origindist[i,j]){
          border_ratio=ifelse(is.null(shared.border),1/(round(s/10)+15),shared.border[name[i],name[j]]/shared.border[name[i],name[i]]/2)
          ratio=err[i,j]/crtDist[i,j]*border_ratio
          frc$xattract[i]=frc$xattract[i]+ratio*(crtloc$x[i]-crtloc$x[j])
          frc$xattract[j]=frc$xattract[j]+ratio*(crtloc$x[j]-crtloc$x[i])
          frc$yattract[i]=frc$yattract[i]+ratio*(crtloc$y[i]-crtloc$y[j])
          frc$yattract[j]=frc$yattract[j]+ratio*(crtloc$y[j]-crtloc$y[i])
        }
      }
    }
    
    # Find the final force
    frc$xforce=frc$xrepel+frc$xattract
    frc$yforce=frc$yrepel+frc$yattract
    
    # Reduce the force if it changes the relative direction of the neighbors
    for (i in order(sapply(nbr,length),decreasing=TRUE)){
      closest = frc[c(name[i],nbr[[name[i]]]),]
      closest$newx = closest$x + closest$xforce
      closest$newy = closest$y + closest$yforce
      oldrloc = dat[nbr[[name[i]]], c('x','y')]
      oldrloc$x = sign(oldrloc$x - closest$x[1])
      oldrloc$y = sign(oldrloc$y - closest$y[1])
      newrloc = oldrloc
      newrloc$x = sign(closest$newx[-1] - closest$newx[1])
      newrloc$y = sign(closest$newy[-1] - closest$newy[1])
      dif = oldrloc != newrloc
      if (any(dif)) {
        problemx = rownames(dif)[dif[,1]]
        if (length(problemx)) {
          problemx = problemx[which.min(abs(closest[problemx,'newx']-closest$newx[1]))]
          frc[i,'xforce'] = (closest[problemx,'newx'] - frc[i,'x']) * 0.999999
          #cat(i,'\tx\t',name[i],'\t',problemx,'\n')
        }
        problemy = rownames(dif)[dif[,2]]
        if (length(problemy)) {
          problemy = problemy[which.min(abs(closest[problemy,'y']-closest$y[1]))]
          frc[i,'yforce'] = (closest[problemy,'newy'] - frc[i,'y']) * 0.999999
          #cat(i,'\ty\t',name[i],'\t',problemy,'\n')
        }
      }
    }

    crtloc=crtloc+frc[,8:7]
    crtDist=as.matrix(dist(crtloc))
    err = circleDist-crtDist
  }
  
  circle(crtloc$x,crtloc$y,dat$density,vertex=polygon.vertex,
         border=if(is.null(color) | all(color==color[1])){1}else{color},
         col=color,add=FALSE,xaxt='n',yaxt='n', ...)
  points(crtloc$x,crtloc$y,col=if(is.null(color)){2}else{color},pch=20)
  if (nbredge) segments(crtloc[edge[,1],1],crtloc[edge[,1],2],
                        crtloc[edge[,2],1],crtloc[edge[,2],2],col='grey70')
  if (name.text) text(crtloc$x,crtloc$y,dat$name,cex=0.8)
  return(data.frame(region=name,crtloc,radius=dat$density))
}


#' aec_carto_f - run dorling ondata centers
#'
#' The dorling algorithm creates a non-contiguous cartogram by
#' shifting circles to alleviate overlap, while roughly maintaining
#' geographic proximity.
#' @export
#' @param aec_data_sub subset of data with centroids of electoral divisions
#' @param ... arguments to dorling function
#' @param polygon.vertex The number of vertice of the circle. Default to be 100. If polygon.vertex=4 then diamonds applies. If polygon.vertex=6, then hexagon applies.
#' @param name.text whether to print the region names on the circles or polygons.
#' @param dist.ratio The threshold to determine whether an attract force is added. It is applied to the ratio of the distance between two centroids and the sum of the two radii.
#' @param iteration The limit of the number of iterations. Default to be 9999.
#' @param xlab Label for dorling x axis, intermediate drawing
#' @param ylab Label for dorling y axis, intermediate drawing
#' @examples 
#' library(dplyr)
#' library(ggplot2)
#' data(nat_map)
#' data(nat_data)
#' adelaide <- aec_extract_f(nat_data, ctr=c(138.6, -34.9), expand=c(2,3))
#' adelaide_carto <- aec_carto_f(adelaide) %>% rename(id=region)
#' ggplot(data=nat_map) + 
#'   geom_path(aes(x=long, y=lat, group=group, order=order),
#'                  colour="grey50") +
#'   geom_point(data=adelaide_carto, aes(x=x, y=y), size=4, alpha=0.4,
#'         colour="#f0027f") + 
#'         xlim(c(136, 140)) + ylim(-36, -33) +
#'         coord_equal()
#' adelaide_all <- merge(adelaide, adelaide_carto, by="id")
#' ggplot(data=nat_map) + 
#'   geom_path(aes(x=long, y=lat, group=group, order=order),
#'                  colour="grey50") +
#'   geom_point(data=adelaide_all, aes(x=long_c, y=lat_c), size=2, alpha=0.4,
#'               colour="#f0027f") + 
#'   geom_point(data=adelaide_all, aes(x=x, y=y), size=2, alpha=0.4,
#'                              colour="#f0027f") + 
#'   geom_segment(data=adelaide_all,
#'        aes(x=long_c, xend=x, y=lat_c, yend=y), colour="#f0027f") +
#'   xlim(c(136, 140)) + ylim(-37, -33) +
#'   coord_equal()
#' 
#' 
aec_carto_f <-function(aec_data_sub, polygon.vertex=6, name.text=TRUE,
                       dist.ratio=dist.ratio, iteration=100,
                       xlab="", ylab="", ...) {
  #aec_data_sub <- aec_extract(aec_data)
  purrr::when(is.null(aec_data_sub$POPULATION), aec_data_sub$POPULATION <- 1000)
  aec_data_dor <- dorling(aec_data_sub$id, aec_data_sub$long_c,
                          aec_data_sub$lat_c, aec_data_sub$POPULATION,
                          polygon.vertex=polygon.vertex,
                          name.text=name.text,
                          dist.ratio=dist.ratio,
                          iteration=iteration,
                          xlab=xlab, ylab=ylab)
  return(aec_data_dor)
}

#' aec_carto_join_f - bind the cartogram coordinates to original data
#'
#' Add the cartogram locations as new variables to original data
#' and make any of these that were not made equal to the original centroids
#' @export
#' @param aec_data subset of data with centroids of electoral divisions
#' @param aec_carto centers
#'
#' @examples
#' library(dplyr)
#' library(ggplot2)
#' data(nat_map)
#' data(nat_data)
#' cities <- list(c(151.2, -33.8), # Sydney
#' c(153.0, -27.5), # Brisbane
#' c(145.0, -37.8), # Melbourne
#' c(138.6, -34.9), # Adelaide,
#' c(115.9, -32.0)) # Perth
#' expand <- list(c(2,3.8), c(2,3), c(2.6,4.1), c(4,3), c(12,6))
#' nat_carto <- purrr::map2(.x=cities, .y=expand,
#' .f=aec_extract_f, aec_data=nat_data) %>%
#'   purrr::map_df(aec_carto_f) %>%
#'     mutate(region=as.integer(as.character(region))) %>%
#'       rename(id=region)
#' nat_data_cart <- aec_carto_join_f(nat_data, nat_carto)
#' # Map theme
#' theme_map <- theme_bw()
#' theme_map$line <- element_blank()
#' theme_map$strip.text <- element_blank()
#' theme_map$axis.text <- element_blank()
#' theme_map$plot.title <- element_blank()
#' theme_map$axis.title <- element_blank()
#' theme_map$panel.border <- element_rect(colour = "grey90", size=1, fill=NA)
#' 
#' ggplot(data=nat_map) +
#'   geom_polygon(aes(x=long, y=lat, group=group, order=order),
#'   fill="grey90", colour="white") +
#'     geom_point(data=nat_data_cart, aes(x=x, y=y), size=2, alpha=0.4,
#'                  colour="#572d2c") +
#'     geom_text(data=nat_data_cart, aes(x=x, y=y, label=id), size=0.5) +
#'       coord_equal() + theme_map
#'  
aec_carto_join_f <- function(aec_data, aec_carto) {
  aec_carto_join <- merge(aec_data, aec_carto, by="id", all.x=TRUE)

  # Make corto centers of remote districts same as actual lat/long
  aec_carto_join$x[is.na(aec_carto_join$x)] <-
    aec_carto_join$long_c[is.na(aec_carto_join$x)]
  aec_carto_join$y[is.na(aec_carto_join$y)] <-
    aec_carto_join$lat_c[is.na(aec_carto_join$y)]

  return(aec_carto_join)
}

