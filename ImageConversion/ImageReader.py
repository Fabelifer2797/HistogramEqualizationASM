import numpy as np
import matplotlib.pyplot as plt

def imageReader(imagePath, imageSize):

    byte =0;
    i = 0;
    j = 0;
    A= np.zeros((imageSize,imageSize));
    fig, (ax1,ax2) = plt.subplots(1, 2)
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
    B = plt.imread(imagePath)
    ax1.imshow(B,cmap='gray');
    ax1.set_title("Imagen Original")
    ax2.imshow (A,cmap='gray');
    ax2.set_title("Imagen Ecualizada")
    plt.show();