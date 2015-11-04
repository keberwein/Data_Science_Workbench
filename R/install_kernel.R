pkgTest <- function(x)
{
  if (!require(x,character.only = TRUE))
  {
    install.packages(x,dep=TRUE)
    if(!require(x,character.only = TRUE)) install.packages(x)
  }
}
pkgTest('devtools')
pkgTest('RCurl')
install_github('IRkernel/repr')
install_github('IRkernel/IRdisplay')
install_github('IRkernel/IRkernel')
IRkernel::installspec()
q(save="no", runLast=TRUE)