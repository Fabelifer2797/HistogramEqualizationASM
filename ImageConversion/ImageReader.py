import numpy as np
import matplotlib.pyplot as plt


def imageReader(imagePath, imageSize):

    byte =0;
    i = 0;
    j = 0;
    A= np.zeros((imageSize,imageSize));
    file = open('../AssemblyCode/imageHE.txt','r')
    for line in file:
        j+=1;
        if(j > (imageSize - 1)):
            i+=1;
            j=0;
        for character in line:
            byte = byte*10;
            if(character != '\n'):
                byte = byte +int(character);
            else:
                A[i,j] = byte;
                byte = 0;

    fig = plt.figure()
    fig.subplots_adjust(hspace=0.2)
    B = plt.imread(imagePath)

    fig.add_subplot(221)
    plt.title("Original Image")
    plt.set_cmap('gray')
    plt.axis('off')
    plt.imshow(B)

    fig.add_subplot(222)
    plt.title("Histogram")
    plt.hist(B, 10)

    fig.add_subplot(223)
    plt.title("Histogram equalization")
    plt.set_cmap('gray')
    plt.axis('off')
    plt.imshow(A)

    fig.add_subplot(224)
    plt.title("Histogram")
    plt.hist(A, 10)

    plt.show()

