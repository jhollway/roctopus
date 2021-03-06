#' Coercion between migraph-consistent object classes 
#' 
#' The `as_` functions in `{migraph}` coerce objects
#' between several common classes of social network objects.
#' These include:
#' - adjacency and incidence matrices
#' - edgelists (as data frames)
#' - `{igraph}` `graph` objects
#' - `{tidygraph}` `tbl_graph` objects
#' - `{network}` `network` objects
#' @name coercion
#' @param object A data frame edgelist, matrix, igraph, tidygraph, or network object.
#' @param twomode An option to override the heuristics for distinguishing incidence
#' from adjacency matrices. By default FALSE.
#' @details Behaviour is a little different depending on the data format.
#' 
#' If the data frame is a 2 column edgelist,
#' the first column will become the rows
#' and the second column will become the columns.
#' If the data frame is a 3 column edgelist,
#' then the third column will be used as 
#' the cell values or tie weights.
#' 
#' Incidence matrices are typically inferred from unequal dimensions,
#' but since in rare cases a matrix with equal dimensions may still
#' be an incidence matrix, an additional argument `twomode` can be
#' specified to override this heuristic.
#' This information is usually already embedded in `{igraph}`, 
#' `{tidygraph}`, and `{network}` objects.
#' @examples
#' test <- data.frame(id1 = c("A","B","B","C","C"),
#'                    id2 = c("I","G","I","G","H"))
#' as_matrix(test)
#' @return An adjacency or incidence matrix, named if possible.
#' @export
as_matrix <- function(object){
  
  if(missing(object)){
    expect_nodes()
    graph <- .G()
    if (is_twomode(graph)){
      mat <- igraph::as_incidence_matrix(graph, sparse = FALSE)
    } else {
      mat <- igraph::as_adjacency_matrix(graph, sparse = FALSE)
    }
  } else if (is.igraph(object)) {
    if (is_twomode(object)){
      mat <- igraph::as_incidence_matrix(object, sparse = FALSE)
    } else {
      mat <- igraph::as_adjacency_matrix(object, sparse = FALSE)
    }
  } else if (is.network(object)) {
    if(network::is.bipartite(object)){
      mat <- network::as.matrix.network(object)
    } else {
      mat <- network::as.matrix.network(object)
    }
  } else if (is.matrix(object)) {
    mat <- object
  } else if (is.data.frame(object)){
    if (ncol(object) == 2) { # Adds a third (weight) column to a two-column edgelist
      object <- as.data.frame(table(object[,1], object[,2]))
    }
    if (ncol(object) == 3) {
      # object <- object[order(object[,1], object[,2]),]
      nodes1 <- as.character(unique(object[,1]))
      nodes1 <- sort(nodes1)
      nodes2 <- as.character(unique(object[,2]))
      nodes2 <- sort(nodes2)
      if(nrow(object) != length(nodes1)*length(nodes2)){
        allcombs <- expand.grid(object[,1:2], stringsAsFactors = FALSE)
        allcombs <- subset(allcombs, !duplicated(allcombs))
        object <- merge(allcombs, object, all.x = TRUE)
        object <- object[order(object[,2], object[,1]),]
        object[is.na(object)] <- 0
      }
      out <- structure(as.numeric(object[,3]), 
                       .Dim = c(as.integer(length(nodes1)), as.integer(length(nodes2))), 
                       .Dimnames = list(nodes1, nodes2))
    }
    mat <- out
  }
  mat
}

#' @rdname coercion
#' @importFrom network as.matrix.network.incidence as.matrix.network.adjacency
#' @return An igraph graph object.
#' @examples
#' test <- data.frame(id1 = c("A","B","B","C","C"),
#'                    id2 = c("I","G","I","G","H"))
#' as_igraph(test)
#' @export
as_igraph <- function(object, twomode = FALSE){
  
  if(missing(object)){
    expect_nodes()
    graph <- .G()
    weights <- rlang::enquo(weights)
    weights <- rlang::eval_tidy(weights, .E())
  } else if (is.igraph(object)) {
    graph <- object
  } else if (is.network(object)) {
    if(network::is.bipartite(object)){
      graph <- network::as.matrix.network.incidence(object)
      graph <- igraph::graph_from_incidence_matrix(graph)
    } else {
      graph <- network::as.matrix.network.adjacency(object)
      graph <- igraph::graph_from_adjacency_matrix(graph)
    }
  } else if (is.data.frame(object) | is.matrix(object)) {
    if (is.data.frame(object)) object <- as_matrix(object)
    if(nrow(object)!=ncol(object) | twomode){
      graph <- igraph::graph_from_incidence_matrix(object)
    } else {
      graph <- igraph::graph_from_adjacency_matrix(object)
    } 
  }
  graph
}

#' @rdname coercion
#' @importFrom tidygraph as_tbl_graph is.tbl_graph
#' @return A tidygraph tbl_graph class object
#' @examples
#' test <- data.frame(id1 = c("A","B","B","C","C"),
#'                    id2 = c("I","G","I","G","H"))
#' as_tidygraph(test)
#' @export
as_tidygraph <- function(object, twomode = FALSE){
  
  if(missing(object)){
    tidy <- object
  } else if (is.igraph(object)) {
    tidy <- tidygraph::as_tbl_graph(object)
  } else if (is.network(object)) {
    if(network::is.bipartite(object)){
      tidy <- network::as.matrix.network.incidence(object)
      tidy <- igraph::graph_from_incidence_matrix(tidy)
      tidy <- tidygraph::as_tbl_graph(tidy)
    } else {
      tidy <- network::as.matrix.network.adjacency(object)
      tidy <- igraph::graph_from_adjacency_matrix(tidy)
      tidy <- tidygraph::as_tbl_graph(tidy)
    }
  } else if (is.data.frame(object) | is.matrix(object)) {
    if (is.data.frame(object)) object <- as_matrix(object)
    if(nrow(object)!=ncol(object) | twomode){
      tidy <- tidygraph::as_tbl_graph(igraph::graph_from_incidence_matrix(object))
    } else {
      tidy <- tidygraph::as_tbl_graph(igraph::graph_from_adjacency_matrix(object))
    } 
  }
  tidy
}

#' @rdname coercion
#' @importFrom network is.network as.network
#' @return A sna/network network class object
#' @examples
#' test <- data.frame(id1 = c("A","B","B","C","C"),
#'                    id2 = c("I","G","I","G","H"))
#' as_network(test)
#' @export
as_network <- function(object){
  
  if(!network::is.network(object)){
    if(is_twomode(object)){
      net <- as_matrix(object)
      net <- network::as.network(net, bipartite = TRUE)
    } else {
      net <- as_matrix(object)
      net <- network::as.network(net, bipartite = FALSE)
    }
  } else {
    net <- object
  }
  net
  
}

