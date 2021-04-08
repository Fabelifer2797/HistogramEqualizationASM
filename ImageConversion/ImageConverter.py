import time

import matplotlib.pyplot as plt
from PIL import Image



def getBytesFromFile(imagePath):

    image = Image.open(imagePath)
    imageSize = image.size
    imageWidth = imageSize[0]
    imageHeight = imageSize[1]


    if imageWidth > imageHeight:
        imageFinalSize = imageWidth

    else:
        imageFinalSize = imageHeight

    image = image.resize((imageFinalSize,imageFinalSize))
    image = image.convert('L')
    image.save(imagePath)
    time.sleep(2)
    mat = plt.imread(imagePath)
    m = mat.shape

    byteArray = []
    for columna in mat:
        for fila in columna:
            byteArray.append(fila)



    with open("./image.txt", "w") as archivo:
        contador = 0
        for item in byteArray:
            item = str(item)
            if (contador == (imageFinalSize * imageFinalSize) - 1):
                archivo.write("%s\n" % item)
                archivo.write('F')
            else:
                archivo.write("%s\n" % item)
                contador += 1

    return imageFinalSize