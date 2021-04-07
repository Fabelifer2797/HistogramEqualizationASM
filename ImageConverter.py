import matplotlib.pyplot as plt
from PIL import Image



def getBytesFromFile():

    image = Image.open("./testimage.jpg")
    imageL = image.convert('L')
    imageL.save("./testimageL.jpg")
    mat = plt.imread("./testimageL.jpg")
    m = mat.shape

    b = []
    for columna in mat:
        for fila in columna:
            b.append(fila)



    with open("./image.txt", "w") as archivo:
        contador = 0
        for item in b:
            item = str(item)
            if (contador == 152099):
                archivo.write(item)
                contador += 1
            else:
                archivo.write("%s\n" % item)
                contador += 1



getBytesFromFile()