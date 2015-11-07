install.packages(c('rzmq','repr','IRkernel','IRdisplay'),repos = c('http://irkernel.github.io/', getOption('repos')), type = 'source')
IRkernel::installspec(user = FALSE)
q(save="no", runLast=TRUE)
