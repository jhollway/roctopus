#' Two-mode 112th Congress Senate Voting
#'
#' These datasets list the U.S. Senators who served in the 112th Congress, 
#' which met from January 3, 2011 to January 3, 2013. 
#' Although the Senate has 100 seats, 103 persons served during this period due to two resignations and a death. 
#' However, the third replacement occurred only two days before the end and cast no votes on the bills investigated here. 
#' Hence, the number of Senators we analyzed is 102.
#' 
#' CQ Almanac identified 25 key bills on which the Senate voted during the 112th Congress,
#' and which Democratic and Republican Senators voting “yea” and “nay” on each proposal.
#' 
#' Lastly, we obtained data on campaign contributions made by 92 PACs from the Open Secrets Website. 
#' We recorded all contributions made during the 2008, 2010, and 2012 election campaigns 
#' to the 102 persons who were Senators in the 112th Congress. 
#' The vast majority of PAC contributions to a candidate during a campaign was for $10,000 
#' (the legal maximum is $5,000 each for a primary and the general election). 
#' We aggregated the contributions across all three electoral cycles, then dichotomized the sums into no contribution (0) 
#' and any contribution (1).
#'
#' @docType data
#' @keywords datasets
#' @name mpn_senate112
#' @usage data(mpn_DemSxP)
#' @format Matrix of 51 rows (Senators) and 63 columns (PACS)
#' @source Knoke, Diani, Hollway, and Christopoulos. 2021. \emph{Multimodal Political Networks}. Cambridge University Press: Cambridge.
"mpn_DemSxP"

#' @rdname mpn_senate112
#' @usage data(mpn_RepSxP)
#' @format Matrix of 62 rows (Senators) and 72 columns (PACS)
"mpn_RepSxP"

#' @rdname mpn_senate112
#' @usage data(mpn_OverSxP)
#' @format Matrix of 20 rows (Senators) and 32 columns (PACS)
"mpn_OverSxP"
