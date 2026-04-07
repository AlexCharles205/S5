#NodeVectors : A two-dimentional list of all the node vectors
#W : The window size
#S : The increment size
#n : The window number to get
#Type : The type of the output to chose from:
    #'List': A two dimensional TxW list
    #'Vectors': A list of W vectors over GF(2)
    #'Matrix': A TxW matrix over GF(2)
def SlidingWindow(NodeVectors, W=20, S=5, n=0, Type='List'):
    assert Type in ['List', 'Vectors', 'Matrix'], "Type should be either 'List', 'Vectors' or 'Matrix'"
    assert n*S+W<=len(NodeVectors), "The parameter n of SlidingWindow function is too large"

    if n == -1:
        ListWindow = NodeVectors[-W:]
        #print(ListWindow)
    else :
        ListWindow = NodeVectors[n*S:n*S+W]

    if Type == 'Vectors':
        return([Vector(GF(2),L) for L in ListWindow])
    if Type == 'Matrix':
        return(Matrix(GF(2), ListWindow).transpose())
    else:
        return(ListWindow)
